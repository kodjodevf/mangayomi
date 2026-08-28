//! `html` WASM host imports: HTML parsing/querying via `scraper`, plus a
//! hand-written jsoup-style selector engine (`super::selector`) for the
//! pseudo-classes `scraper`'s standard-CSS-only `Selector` doesn't support.
//! Mutation operations (`set_text`, `set_html`, `append`, `prepend`,
//! `set_attr`, ...) aren't exposed by `scraper`'s high-level API at all, so
//! they're implemented by hand here via direct `ego_tree` surgery.

use std::sync::Arc;

use ego_tree::{NodeId, Tree};
use scraper::{Html, Node};
use wasmi::{Caller, Linker};

use super::memory;
use super::selector;
use super::store::{HtmlDoc, HtmlNode, StoredValue};
use super::HostState;

pub(crate) fn link(linker: &mut Linker<HostState>) -> anyhow::Result<()> {
    linker.func_wrap(
        "html",
        "parse",
        |mut caller: Caller<'_, HostState>,
         html_ptr: i32,
         html_len: i32,
         base_ptr: i32,
         base_len: i32|
         -> i32 {
            let mem = caller.data().memory.unwrap();
            let html = match memory::read_string(mem, &caller, html_ptr, html_len) {
                Ok(s) => s,
                Err(_) => return -3,
            };
            let base_url = if base_len > 0 {
                memory::read_string(mem, &caller, base_ptr, base_len).ok()
            } else {
                None
            };
            store_document(&mut caller, &html, base_url)
        },
    )?;

    linker.func_wrap(
        "html",
        "parse_fragment",
        |mut caller: Caller<'_, HostState>,
         html_ptr: i32,
         html_len: i32,
         base_ptr: i32,
         base_len: i32|
         -> i32 {
            let mem = caller.data().memory.unwrap();
            let html = match memory::read_string(mem, &caller, html_ptr, html_len) {
                Ok(s) => s,
                Err(_) => return -3,
            };
            let base_url = if base_len > 0 {
                memory::read_string(mem, &caller, base_ptr, base_len).ok()
            } else {
                None
            };
            store_document(&mut caller, &html, base_url)
        },
    )?;

    linker.func_wrap(
        "html",
        "escape",
        |mut caller: Caller<'_, HostState>, text_ptr: i32, text_len: i32| -> i32 {
            let mem = caller.data().memory.unwrap();
            let text = match memory::read_string(mem, &caller, text_ptr, text_len) {
                Ok(s) => s,
                Err(_) => return -2,
            };
            let escaped = text
                .replace('&', "&amp;")
                .replace('<', "&lt;")
                .replace('>', "&gt;")
                .replace('"', "&quot;")
                .replace('\'', "&#39;");
            caller
                .data_mut()
                .store
                .store(StoredValue::Bytes(escaped.into_bytes()))
        },
    )?;

    linker.func_wrap(
        "html",
        "unescape",
        |mut caller: Caller<'_, HostState>, text_ptr: i32, text_len: i32| -> i32 {
            let mem = caller.data().memory.unwrap();
            let text = match memory::read_string(mem, &caller, text_ptr, text_len) {
                Ok(s) => s,
                Err(_) => return -2,
            };
            let unescaped = text
                .replace("&amp;", "&")
                .replace("&lt;", "<")
                .replace("&gt;", ">")
                .replace("&quot;", "\"")
                .replace("&#39;", "'")
                .replace("&apos;", "'");
            caller
                .data_mut()
                .store
                .store(StoredValue::Bytes(unescaped.into_bytes()))
        },
    )?;

    linker.func_wrap(
        "html",
        "kind",
        |caller: Caller<'_, HostState>, desc: i32| -> i32 {
            match caller.data().store.get(desc) {
                Some(StoredValue::HtmlDocRoot(_)) => 7,
                Some(StoredValue::HtmlNode(n)) => {
                    let doc = n.doc.html.lock();
                    match doc.tree.get(n.id).map(|r| r.value()) {
                        Some(Node::Element(_)) => 5,
                        Some(Node::Comment(_)) => 4,
                        Some(Node::Text(_)) => 2,
                        Some(_) => 1,
                        None => 0,
                    }
                }
                Some(StoredValue::HtmlNodeList(_)) => 6,
                _ => 0,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "child_nodes",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let list = match caller.data().store.get(desc) {
                Some(StoredValue::HtmlDocRoot(doc)) => {
                    let root = doc.html.lock().tree.root().id();
                    children_of(doc.clone(), root)
                }
                Some(StoredValue::HtmlNode(n)) => children_of(n.doc.clone(), n.id),
                _ => return -1,
            };
            caller
                .data_mut()
                .store
                .store(StoredValue::HtmlNodeList(list))
        },
    )?;

    linker.func_wrap(
        "html",
        "children",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let list = match caller.data().store.get(desc) {
                Some(StoredValue::HtmlDocRoot(doc)) => {
                    let root = doc.html.lock().tree.root().id();
                    element_children_of(doc.clone(), root)
                }
                Some(StoredValue::HtmlNode(n)) => element_children_of(n.doc.clone(), n.id),
                Some(StoredValue::HtmlNodeList(list)) => {
                    let mut out = Vec::new();
                    for n in list.clone() {
                        out.extend(element_children_of(n.doc.clone(), n.id));
                    }
                    out
                }
                _ => return -1,
            };
            caller
                .data_mut()
                .store
                .store(StoredValue::HtmlNodeList(list))
        },
    )?;

    linker.func_wrap(
        "html",
        "has_attr",
        |caller: Caller<'_, HostState>, desc: i32, attr_ptr: i32, attr_len: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -1,
            };
            let mem = caller.data().memory.unwrap();
            let name = match memory::read_string(mem, &caller, attr_ptr, attr_len) {
                Ok(s) => s,
                Err(_) => return -1,
            };
            let doc = node.doc.html.lock();
            match element_of(&doc, node.id) {
                Some(el) => {
                    if el.attr(&name).is_some() {
                        1
                    } else {
                        0
                    }
                }
                None => -1,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "set_attr",
        |caller: Caller<'_, HostState>,
         desc: i32,
         attr_ptr: i32,
         attr_len: i32,
         val_ptr: i32,
         val_len: i32|
         -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -1,
            };
            let mem = caller.data().memory.unwrap();
            let name = match memory::read_string(mem, &caller, attr_ptr, attr_len) {
                Ok(s) => s,
                Err(_) => return -1,
            };
            let value = match memory::read_string(mem, &caller, val_ptr, val_len) {
                Ok(s) => s,
                Err(_) => return -1,
            };
            let mut doc = node.doc.html.lock();
            match doc.tree.get_mut(node.id) {
                Some(mut nm) => {
                    if let Node::Element(el) = nm.value() {
                        let qname = html5ever_qualname(&name);
                        if let Some(pos) = el.attrs.iter().position(|(k, _)| *k == qname) {
                            el.attrs[pos].1 = value.into();
                        } else {
                            el.attrs.push((qname, value.into()));
                        }
                        0
                    } else {
                        -1
                    }
                }
                None => -1,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "remove_attr",
        |caller: Caller<'_, HostState>, desc: i32, attr_ptr: i32, attr_len: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -1,
            };
            let mem = caller.data().memory.unwrap();
            let name = match memory::read_string(mem, &caller, attr_ptr, attr_len) {
                Ok(s) => s,
                Err(_) => return -1,
            };
            let mut doc = node.doc.html.lock();
            match doc.tree.get_mut(node.id) {
                Some(mut nm) => {
                    if let Node::Element(el) = nm.value() {
                        let qname = html5ever_qualname(&name);
                        el.attrs.retain(|(k, _)| *k != qname);
                        0
                    } else {
                        -1
                    }
                }
                None => -1,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "set_text",
        |caller: Caller<'_, HostState>, desc: i32, ptr: i32, len: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -1,
            };
            let mem = caller.data().memory.unwrap();
            let text = match memory::read_string(mem, &caller, ptr, len) {
                Ok(s) => s,
                Err(_) => return -1,
            };
            let mut doc = node.doc.html.lock();
            detach_children(&mut doc.tree, node.id);
            doc.tree
                .get_mut(node.id)
                .unwrap()
                .append(Node::Text(scraper::node::Text { text: text.into() }));
            0
        },
    )?;

    linker.func_wrap(
        "html",
        "set_html",
        |caller: Caller<'_, HostState>, desc: i32, ptr: i32, len: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -1,
            };
            let mem = caller.data().memory.unwrap();
            let html = match memory::read_string(mem, &caller, ptr, len) {
                Ok(s) => s,
                Err(_) => return -1,
            };
            let fragment = Html::parse_fragment(&html);
            let mut doc = node.doc.html.lock();
            detach_children(&mut doc.tree, node.id);
            let src_root = fragment.tree.root().id();
            let child_ids: Vec<_> = fragment
                .tree
                .get(src_root)
                .unwrap()
                .children()
                .map(|c| c.id())
                .collect();
            for c in child_ids {
                append_clone(&mut doc.tree, node.id, &fragment.tree, c);
            }
            0
        },
    )?;

    linker.func_wrap(
        "html",
        "prepend",
        |caller: Caller<'_, HostState>, desc: i32, ptr: i32, len: i32| -> i32 {
            insert_html(&caller, desc, ptr, len, true)
        },
    )?;

    linker.func_wrap(
        "html",
        "append",
        |caller: Caller<'_, HostState>, desc: i32, ptr: i32, len: i32| -> i32 {
            insert_html(&caller, desc, ptr, len, false)
        },
    )?;

    linker.func_wrap(
        "html",
        "base_uri",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let uri = match caller.data().store.get(desc) {
                Some(StoredValue::HtmlDocRoot(doc)) => doc.base_url.clone(),
                Some(StoredValue::HtmlNode(n)) => n.doc.base_url.clone(),
                _ => None,
            };
            caller
                .data_mut()
                .store
                .store(StoredValue::Bytes(uri.unwrap_or_default().into_bytes()))
        },
    )?;

    linker.func_wrap(
        "html",
        "own_text",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -1,
            };
            let doc = node.doc.html.lock();
            let mut buf = String::new();
            if let Some(nr) = doc.tree.get(node.id) {
                for child in nr.children() {
                    if let Node::Text(t) = child.value() {
                        buf.push_str(&t.text);
                    }
                }
            }
            caller
                .data_mut()
                .store
                .store(StoredValue::Bytes(buf.trim().to_string().into_bytes()))
        },
    )?;

    linker.func_wrap(
        "html",
        "data",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -1,
            };
            let doc = node.doc.html.lock();
            let text = match doc.tree.get(node.id).map(|r| r.value()) {
                Some(Node::Element(_)) => {
                    element_of(&doc, node.id).map(|e| e.text().collect::<Vec<_>>().join(""))
                }
                Some(Node::Comment(c)) => Some(c.comment.to_string()),
                _ => None,
            };
            match text {
                Some(t) => caller
                    .data_mut()
                    .store
                    .store(StoredValue::Bytes(t.into_bytes())),
                None => -1,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "id",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -1,
            };
            let doc = node.doc.html.lock();
            let id = element_of(&doc, node.id)
                .and_then(|e| e.value().id())
                .unwrap_or("")
                .to_string();
            caller
                .data_mut()
                .store
                .store(StoredValue::Bytes(id.into_bytes()))
        },
    )?;

    linker.func_wrap(
        "html",
        "tag_name",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -1,
            };
            let doc = node.doc.html.lock();
            let name = element_of(&doc, node.id)
                .map(|e| e.value().name().to_string())
                .unwrap_or_default();
            caller
                .data_mut()
                .store
                .store(StoredValue::Bytes(name.into_bytes()))
        },
    )?;

    linker.func_wrap(
        "html",
        "class_name",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -1,
            };
            let doc = node.doc.html.lock();
            let classes = element_of(&doc, node.id)
                .map(|e| e.value().classes().collect::<Vec<_>>().join(" "))
                .unwrap_or_default();
            caller
                .data_mut()
                .store
                .store(StoredValue::Bytes(classes.into_bytes()))
        },
    )?;

    linker.func_wrap(
        "html",
        "has_class",
        |caller: Caller<'_, HostState>, desc: i32, class_ptr: i32, class_len: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -1,
            };
            let mem = caller.data().memory.unwrap();
            let class = match memory::read_string(mem, &caller, class_ptr, class_len) {
                Ok(s) => s,
                Err(_) => return -1,
            };
            let doc = node.doc.html.lock();
            match element_of(&doc, node.id) {
                Some(e) => {
                    if e.value().classes().any(|c| c == class) {
                        1
                    } else {
                        0
                    }
                }
                None => -1,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "add_class",
        |caller: Caller<'_, HostState>, desc: i32, class_ptr: i32, class_len: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -1,
            };
            let mem = caller.data().memory.unwrap();
            let class = match memory::read_string(mem, &caller, class_ptr, class_len) {
                Ok(s) => s,
                Err(_) => return -1,
            };
            let mut doc = node.doc.html.lock();
            match doc.tree.get_mut(node.id) {
                Some(mut nm) => {
                    if let Node::Element(el) = nm.value() {
                        let existing = el.attr("class").unwrap_or("").to_string();
                        if !existing.split_whitespace().any(|c| c == class) {
                            let mut updated = existing;
                            if !updated.is_empty() {
                                updated.push(' ');
                            }
                            updated.push_str(&class);
                            let qname = html5ever_qualname("class");
                            if let Some(pos) = el.attrs.iter().position(|(k, _)| *k == qname) {
                                el.attrs[pos].1 = updated.into();
                            } else {
                                el.attrs.push((qname, updated.into()));
                            }
                        }
                        0
                    } else {
                        -1
                    }
                }
                None => -1,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "remove_class",
        |caller: Caller<'_, HostState>, desc: i32, class_ptr: i32, class_len: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -1,
            };
            let mem = caller.data().memory.unwrap();
            let class = match memory::read_string(mem, &caller, class_ptr, class_len) {
                Ok(s) => s,
                Err(_) => return -1,
            };
            let mut doc = node.doc.html.lock();
            match doc.tree.get_mut(node.id) {
                Some(mut nm) => {
                    if let Node::Element(el) = nm.value() {
                        let existing = el.attr("class").unwrap_or("").to_string();
                        let updated = existing
                            .split_whitespace()
                            .filter(|c| *c != class)
                            .collect::<Vec<_>>()
                            .join(" ");
                        let qname = html5ever_qualname("class");
                        if updated.is_empty() {
                            el.attrs.retain(|(k, _)| *k != qname);
                        } else if let Some(pos) = el.attrs.iter().position(|(k, _)| *k == qname) {
                            el.attrs[pos].1 = updated.into();
                        } else {
                            el.attrs.push((qname, updated.into()));
                        }
                        0
                    } else {
                        -1
                    }
                }
                None => -1,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "first",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            match caller.data().store.get(desc) {
                Some(StoredValue::HtmlNodeList(list)) => match list.first().cloned() {
                    Some(n) => caller.data_mut().store.store(StoredValue::HtmlNode(n)),
                    None => -5,
                },
                _ => -5,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "last",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            match caller.data().store.get(desc) {
                Some(StoredValue::HtmlNodeList(list)) => match list.last().cloned() {
                    Some(n) => caller.data_mut().store.store(StoredValue::HtmlNode(n)),
                    None => -5,
                },
                _ => -5,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "get",
        |mut caller: Caller<'_, HostState>, desc: i32, index: i32| -> i32 {
            match caller.data().store.get(desc) {
                Some(StoredValue::HtmlNodeList(list)) => {
                    if index >= 0 && (index as usize) < list.len() {
                        let n = list[index as usize].clone();
                        caller.data_mut().store.store(StoredValue::HtmlNode(n))
                    } else {
                        -5
                    }
                }
                _ => -5,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "size",
        |caller: Caller<'_, HostState>, desc: i32| -> i32 {
            match caller.data().store.get(desc) {
                Some(StoredValue::HtmlNodeList(list)) => list.len() as i32,
                _ => 0,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "parent",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -5,
            };
            let parent_id = {
                let doc = node.doc.html.lock();
                doc.tree
                    .get(node.id)
                    .and_then(|n| n.parent())
                    .map(|p| p.id())
            };
            match parent_id {
                Some(id) => caller
                    .data_mut()
                    .store
                    .store(StoredValue::HtmlNode(HtmlNode { doc: node.doc, id })),
                None => -5,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "siblings",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -5,
            };
            let list = {
                let doc = node.doc.html.lock();
                let parent = match doc.tree.get(node.id).and_then(|n| n.parent()) {
                    Some(p) => p,
                    None => return -5,
                };
                parent
                    .children()
                    .filter(|c| c.id() != node.id && scraper::ElementRef::wrap(*c).is_some())
                    .map(|c| HtmlNode {
                        doc: node.doc.clone(),
                        id: c.id(),
                    })
                    .collect::<Vec<_>>()
            };
            caller
                .data_mut()
                .store
                .store(StoredValue::HtmlNodeList(list))
        },
    )?;

    linker.func_wrap(
        "html",
        "next",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -5,
            };
            let next_id = {
                let doc = node.doc.html.lock();
                let mut cur = doc.tree.get(node.id).and_then(|n| n.next_sibling());
                loop {
                    match cur {
                        Some(c) if scraper::ElementRef::wrap(c).is_some() => break Some(c.id()),
                        Some(c) => cur = c.next_sibling(),
                        None => break None,
                    }
                }
            };
            match next_id {
                Some(id) => caller
                    .data_mut()
                    .store
                    .store(StoredValue::HtmlNode(HtmlNode { doc: node.doc, id })),
                None => -5,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "previous",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -5,
            };
            let prev_id = {
                let doc = node.doc.html.lock();
                let mut cur = doc.tree.get(node.id).and_then(|n| n.prev_sibling());
                loop {
                    match cur {
                        Some(c) if scraper::ElementRef::wrap(c).is_some() => break Some(c.id()),
                        Some(c) => cur = c.prev_sibling(),
                        None => break None,
                    }
                }
            };
            match prev_id {
                Some(id) => caller
                    .data_mut()
                    .store
                    .store(StoredValue::HtmlNode(HtmlNode { doc: node.doc, id })),
                None => -5,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "attr",
        |mut caller: Caller<'_, HostState>, desc: i32, key_ptr: i32, key_len: i32| -> i32 {
            let mem = caller.data().memory.unwrap();
            let key = match memory::read_string(mem, &caller, key_ptr, key_len) {
                Ok(s) => s,
                Err(_) => return -5,
            };
            let node = match caller.data().store.get(desc) {
                Some(StoredValue::HtmlNode(n)) => n.clone(),
                Some(StoredValue::HtmlNodeList(l)) => match l.first().cloned() {
                    Some(n) => n,
                    None => return -5,
                },
                _ => return -5,
            };
            let doc = node.doc.html.lock();
            let el = match element_of(&doc, node.id) {
                Some(e) => e,
                None => return -5,
            };
            let (raw_key, is_abs) = match key.strip_prefix("abs:") {
                Some(k) => (k, true),
                None => (key.as_str(), false),
            };
            let value = el.attr(raw_key).map(|v| {
                if is_abs {
                    resolve_absolute_url(node.doc.base_url.as_deref(), v)
                } else {
                    v.to_string()
                }
            });
            drop(doc);
            match value {
                Some(v) => caller
                    .data_mut()
                    .store
                    .store(StoredValue::Bytes(v.into_bytes())),
                None => -5,
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "outer_html",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -5,
            };
            let doc = node.doc.html.lock();
            let html = match doc.tree.get(node.id) {
                Some(n) if n.id() == doc.tree.root().id() => doc.html(),
                _ => element_of(&doc, node.id)
                    .map(|e| e.html())
                    .unwrap_or_default(),
            };
            drop(doc);
            caller
                .data_mut()
                .store
                .store(StoredValue::Bytes(html.into_bytes()))
        },
    )?;

    linker.func_wrap(
        "html",
        "remove",
        |caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let node = match html_node(&caller, desc) {
                Some(n) => n,
                None => return -5,
            };
            let mut doc = node.doc.html.lock();
            if let Some(mut nm) = doc.tree.get_mut(node.id) {
                nm.detach();
                0
            } else {
                -5
            }
        },
    )?;

    linker.func_wrap(
        "html",
        "select",
        |mut caller: Caller<'_, HostState>, desc: i32, query_ptr: i32, query_len: i32| -> i32 {
            let mem = caller.data().memory.unwrap();
            let query = match memory::read_string(mem, &caller, query_ptr, query_len) {
                Ok(s) => s,
                Err(_) => return -4,
            };
            let roots = context_roots(&caller, desc);
            if roots.is_empty() {
                return -5;
            }
            let mut out = Vec::new();
            for root in roots {
                let doc = root.doc.html.lock();
                for id in selector::select(&doc, root.id, &query) {
                    out.push(HtmlNode {
                        doc: root.doc.clone(),
                        id,
                    });
                }
            }
            caller
                .data_mut()
                .store
                .store(StoredValue::HtmlNodeList(out))
        },
    )?;

    linker.func_wrap(
        "html",
        "select_first",
        |mut caller: Caller<'_, HostState>, desc: i32, query_ptr: i32, query_len: i32| -> i32 {
            let mem = caller.data().memory.unwrap();
            let query = match memory::read_string(mem, &caller, query_ptr, query_len) {
                Ok(s) => s,
                Err(_) => return -4,
            };
            let roots = context_roots(&caller, desc);
            for root in roots {
                let found = {
                    let doc = root.doc.html.lock();
                    selector::select_first(&doc, root.id, &query)
                };
                if let Some(id) = found {
                    return caller
                        .data_mut()
                        .store
                        .store(StoredValue::HtmlNode(HtmlNode { doc: root.doc, id }));
                }
            }
            -5
        },
    )?;

    linker.func_wrap(
        "html",
        "text",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let t = match caller.data().store.get(desc) {
                Some(StoredValue::HtmlDocRoot(doc)) => {
                    let d = doc.html.lock();
                    d.root_element().text().collect::<Vec<_>>().join(" ")
                }
                Some(StoredValue::HtmlNode(n)) => {
                    let doc = n.doc.html.lock();
                    element_of(&doc, n.id)
                        .map(|e| e.text().collect::<Vec<_>>().join(" "))
                        .unwrap_or_default()
                }
                Some(StoredValue::HtmlNodeList(list)) => list
                    .iter()
                    .map(|n| {
                        let doc = n.doc.html.lock();
                        element_of(&doc, n.id)
                            .map(|e| e.text().collect::<Vec<_>>().join(" "))
                            .unwrap_or_default()
                    })
                    .collect::<Vec<_>>()
                    .join(" "),
                _ => return -5,
            };
            caller
                .data_mut()
                .store
                .store(StoredValue::Bytes(t.trim().to_string().into_bytes()))
        },
    )?;

    linker.func_wrap(
        "html",
        "untrimmed_text",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let t = match caller.data().store.get(desc) {
                Some(StoredValue::HtmlNode(n)) => {
                    let doc = n.doc.html.lock();
                    element_of(&doc, n.id)
                        .map(|e| e.text().collect::<Vec<_>>().join(""))
                        .unwrap_or_default()
                }
                Some(StoredValue::HtmlNodeList(list)) => list
                    .iter()
                    .map(|n| {
                        let doc = n.doc.html.lock();
                        element_of(&doc, n.id)
                            .map(|e| e.text().collect::<Vec<_>>().join(""))
                            .unwrap_or_default()
                    })
                    .collect::<Vec<_>>()
                    .join(""),
                _ => return -5,
            };
            caller
                .data_mut()
                .store
                .store(StoredValue::Bytes(t.into_bytes()))
        },
    )?;

    linker.func_wrap(
        "html",
        "html",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            let t = match caller.data().store.get(desc) {
                Some(StoredValue::HtmlDocRoot(doc)) => doc.html.lock().html(),
                Some(StoredValue::HtmlNode(n)) => {
                    let doc = n.doc.html.lock();
                    element_of(&doc, n.id)
                        .map(|e| e.inner_html())
                        .unwrap_or_default()
                }
                Some(StoredValue::HtmlNodeList(list)) => list
                    .iter()
                    .map(|n| {
                        let doc = n.doc.html.lock();
                        element_of(&doc, n.id).map(|e| e.html()).unwrap_or_default()
                    })
                    .collect::<Vec<_>>()
                    .join("\n"),
                _ => return -5,
            };
            caller
                .data_mut()
                .store
                .store(StoredValue::Bytes(t.into_bytes()))
        },
    )?;

    Ok(())
}

pub(crate) fn store_document(
    caller: &mut Caller<'_, HostState>,
    html: &str,
    base_url: Option<String>,
) -> i32 {
    let doc = Arc::new(HtmlDoc {
        html: parking_lot::Mutex::new(Html::parse_document(html)),
        base_url,
    });
    caller.data_mut().store.store(StoredValue::HtmlDocRoot(doc))
}

fn html_node(caller: &Caller<'_, HostState>, desc: i32) -> Option<HtmlNode> {
    match caller.data().store.get(desc)? {
        StoredValue::HtmlNode(n) => Some(n.clone()),
        StoredValue::HtmlDocRoot(doc) => {
            let root = doc.html.lock().tree.root().id();
            Some(HtmlNode {
                doc: doc.clone(),
                id: root,
            })
        }
        StoredValue::HtmlNodeList(list) => list.first().cloned(),
        _ => None,
    }
}

/// Resolves the element/document/list roots to search from for `select`/`select_first`.
fn context_roots(caller: &Caller<'_, HostState>, desc: i32) -> Vec<HtmlNode> {
    match caller.data().store.get(desc) {
        Some(StoredValue::HtmlDocRoot(doc)) => {
            let root = doc.html.lock().tree.root().id();
            let node = HtmlNode {
                doc: doc.clone(),
                id: root,
            };
            vec![node]
        }
        Some(StoredValue::HtmlNode(n)) => vec![n.clone()],
        Some(StoredValue::HtmlNodeList(list)) => list.clone(),
        _ => Vec::new(),
    }
}

fn element_of<'a>(doc: &'a Html, id: NodeId) -> Option<scraper::ElementRef<'a>> {
    scraper::ElementRef::wrap(doc.tree.get(id)?)
}

fn children_of(doc: Arc<HtmlDoc>, id: NodeId) -> Vec<HtmlNode> {
    let d = doc.html.lock();
    let ids: Vec<_> = d
        .tree
        .get(id)
        .map(|n| n.children().map(|c| c.id()).collect())
        .unwrap_or_default();
    drop(d);
    ids.into_iter()
        .map(|id| HtmlNode {
            doc: doc.clone(),
            id,
        })
        .collect()
}

fn element_children_of(doc: Arc<HtmlDoc>, id: NodeId) -> Vec<HtmlNode> {
    let d = doc.html.lock();
    let ids: Vec<_> = d
        .tree
        .get(id)
        .map(|n| {
            n.children()
                .filter(|c| scraper::ElementRef::wrap(*c).is_some())
                .map(|c| c.id())
                .collect()
        })
        .unwrap_or_default();
    drop(d);
    ids.into_iter()
        .map(|id| HtmlNode {
            doc: doc.clone(),
            id,
        })
        .collect()
}

fn detach_children(tree: &mut Tree<Node>, id: NodeId) {
    let child_ids: Vec<_> = tree
        .get(id)
        .map(|n| n.children().map(|c| c.id()).collect())
        .unwrap_or_default();
    for c in child_ids {
        if let Some(mut nm) = tree.get_mut(c) {
            nm.detach();
        }
    }
}

fn append_clone(tree: &mut Tree<Node>, parent: NodeId, src_tree: &Tree<Node>, src_id: NodeId) {
    let value = match src_tree.get(src_id) {
        Some(n) => n.value().clone(),
        None => return,
    };
    let new_id = match tree.get_mut(parent) {
        Some(mut p) => p.append(value).id(),
        None => return,
    };
    let child_ids: Vec<_> = src_tree
        .get(src_id)
        .map(|n| n.children().map(|c| c.id()).collect())
        .unwrap_or_default();
    for c in child_ids {
        append_clone(tree, new_id, src_tree, c);
    }
}

fn insert_html(
    caller: &Caller<'_, HostState>,
    desc: i32,
    ptr: i32,
    len: i32,
    prepend: bool,
) -> i32 {
    let node = match html_node(caller, desc) {
        Some(n) => n,
        None => return -1,
    };
    let mem = caller.data().memory.unwrap();
    let html = match memory::read_string(mem, caller, ptr, len) {
        Ok(s) => s,
        Err(_) => return -1,
    };
    let fragment = Html::parse_fragment(&html);
    let mut doc = node.doc.html.lock();
    let src_root = fragment.tree.root().id();
    let child_ids: Vec<_> = fragment
        .tree
        .get(src_root)
        .map(|n| n.children().map(|c| c.id()).collect())
        .unwrap_or_default();

    if prepend {
        let existing_first = doc
            .tree
            .get(node.id)
            .and_then(|n| n.first_child())
            .map(|c| c.id());
        for c in child_ids {
            let value = match fragment.tree.get(c) {
                Some(n) => n.value().clone(),
                None => continue,
            };
            let new_id = match existing_first {
                Some(first) => doc.tree.get_mut(first).unwrap().insert_before(value).id(),
                None => doc.tree.get_mut(node.id).unwrap().append(value).id(),
            };
            let grandchildren: Vec<_> = fragment
                .tree
                .get(c)
                .map(|n| n.children().map(|g| g.id()).collect())
                .unwrap_or_default();
            for g in grandchildren {
                append_clone(&mut doc.tree, new_id, &fragment.tree, g);
            }
        }
    } else {
        for c in child_ids {
            append_clone(&mut doc.tree, node.id, &fragment.tree, c);
        }
    }
    0
}

fn resolve_absolute_url(base: Option<&str>, val: &str) -> String {
    if val.starts_with("http://") || val.starts_with("https://") {
        return val.to_string();
    }
    if let Some(base) = base {
        if let Ok(b) = url::Url::parse(base) {
            if let Ok(joined) = b.join(val) {
                return joined.to_string();
            }
        }
    }
    val.to_string()
}

fn html5ever_qualname(name: &str) -> html5ever::QualName {
    html5ever::QualName::new(
        None,
        html5ever::Namespace::from("http://www.w3.org/1999/xhtml"),
        html5ever::LocalName::from(name),
    )
}
