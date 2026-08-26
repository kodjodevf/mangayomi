//! Hand-written jsoup-style CSS + pseudo-class selector engine on top of
//! `scraper`'s HTML tree. `scraper`'s own `Selector` (backed by Servo's
//! `selectors` crate) only implements standard CSS, not jsoup extensions like
//! `:contains()`, `:has()`, `:matches()`, `:eq()`/`:lt()`/`:gt()`, so rather
//! than mixing two selector engines this implements the whole thing by hand
//! (mirroring the design of the `pseudom` Dart/ANTLR package used elsewhere
//! in this project, just hand-rolled instead of grammar-generated).

use ego_tree::NodeId;
use regex::Regex;
use scraper::{ElementRef, Html, Node};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub(crate) enum Combinator {
    Descendant,
    Child,
    NextSibling,
    SubsequentSibling,
}

#[derive(Debug, Clone)]
pub(crate) enum AttrMatcher {
    Exists,
    Exact(String),
    Includes(String),
    Dash(String),
    Prefix(String),
    Suffix(String),
    Substring(String),
    NotEqual(String),
    AnyAttr,
}

#[derive(Debug, Clone)]
pub(crate) struct AttrSelector {
    pub name: String,
    pub matcher: AttrMatcher,
}

#[derive(Debug, Clone)]
pub(crate) enum Pseudo {
    Empty,
    FirstChild,
    LastChild,
    OnlyChild,
    FirstOfType,
    LastOfType,
    OnlyOfType,
    NthChild(String),
    NthLastChild(String),
    NthOfType(String),
    NthLastOfType(String),
    Contains(String),
    IContains(String),
    ContainsOwn(String),
    IContainsOwn(String),
    Matches(String),
    MatchesOwn(String),
    Has(String),
    Not(String),
    Is(String),
    Eq(i64),
    Lt(i64),
    Gt(i64),
    Blank,
}

#[derive(Debug, Clone, Default)]
pub(crate) struct Compound {
    pub tag: Option<String>,
    pub id: Option<String>,
    pub classes: Vec<String>,
    pub attrs: Vec<AttrSelector>,
    pub pseudos: Vec<Pseudo>,
}

/// One `(combinator, compound)` step in a selector chain, e.g. `div > p.foo`
/// parses to `[(Descendant, div), (Child, p.foo)]` (first combinator is
/// always `Descendant`, meaning "search descendants of the context node").
pub(crate) type Chain = Vec<(Combinator, Compound)>;

pub(crate) fn parse_groups(query: &str) -> Vec<Chain> {
    split_top_level(query, ',')
        .into_iter()
        .map(|g| parse_chain(g.trim()))
        .collect()
}

fn split_top_level(s: &str, sep: char) -> Vec<String> {
    let mut out = Vec::new();
    let mut depth = 0i32;
    let mut cur = String::new();
    let mut in_quotes: Option<char> = None;
    for c in s.chars() {
        match c {
            '\'' | '"' if in_quotes.is_none() => {
                in_quotes = Some(c);
                cur.push(c);
            }
            c2 if Some(c2) == in_quotes => {
                in_quotes = None;
                cur.push(c2);
            }
            '(' | '[' if in_quotes.is_none() => {
                depth += 1;
                cur.push(c);
            }
            ')' | ']' if in_quotes.is_none() => {
                depth -= 1;
                cur.push(c);
            }
            c2 if c2 == sep && depth == 0 && in_quotes.is_none() => {
                out.push(std::mem::take(&mut cur));
            }
            c2 => cur.push(c2),
        }
    }
    if !cur.trim().is_empty() || out.is_empty() {
        out.push(cur);
    }
    out
}

fn parse_chain(group: &str) -> Chain {
    let mut chain = Vec::new();
    let chars = group.chars().collect::<Vec<_>>();
    let mut i = 0usize;
    let mut buf = String::new();
    let mut pending_combinator = Combinator::Descendant;
    let mut depth = 0i32;

    macro_rules! flush {
        () => {
            let seg = buf.trim();
            if !seg.is_empty() {
                chain.push((pending_combinator, parse_compound(seg)));
            }
            buf.clear();
        };
    }

    while i < chars.len() {
        let c = chars[i];
        match c {
            '(' | '[' => {
                depth += 1;
                buf.push(c);
            }
            ')' | ']' => {
                depth -= 1;
                buf.push(c);
            }
            '>' if depth == 0 => {
                flush!();
                pending_combinator = Combinator::Child;
            }
            '+' if depth == 0 => {
                flush!();
                pending_combinator = Combinator::NextSibling;
            }
            '~' if depth == 0 => {
                flush!();
                pending_combinator = Combinator::SubsequentSibling;
            }
            c2 if c2.is_whitespace() && depth == 0 => {
                if !buf.trim().is_empty() {
                    flush!();
                    pending_combinator = Combinator::Descendant;
                }
            }
            c2 => buf.push(c2),
        }
        i += 1;
    }
    flush!();
    chain
}

fn parse_compound(seg: &str) -> Compound {
    let mut compound = Compound::default();
    let chars = seg.chars().collect::<Vec<_>>();
    let mut i = 0usize;
    while i < chars.len() {
        match chars[i] {
            '#' => {
                i += 1;
                let (id, ni) = take_ident(&chars, i);
                compound.id = Some(id);
                i = ni;
            }
            '.' => {
                i += 1;
                let (class, ni) = take_ident(&chars, i);
                compound.classes.push(class);
                i = ni;
            }
            '[' => {
                i += 1;
                let (inner, ni) = take_until(&chars, i, ']');
                compound.attrs.push(parse_attr(&inner));
                i = ni;
            }
            ':' => {
                i += 1;
                let (name, ni) = take_ident(&chars, i);
                i = ni;
                let mut args = None;
                if i < chars.len() && chars[i] == '(' {
                    i += 1;
                    let (inner, ni2) = take_balanced(&chars, i, '(', ')');
                    args = Some(inner);
                    i = ni2;
                }
                if let Some(p) = build_pseudo(&name, args) {
                    compound.pseudos.push(p);
                }
            }
            '*' => {
                i += 1;
            }
            _ => {
                let (tag, ni) = take_ident(&chars, i);
                if tag.is_empty() {
                    i += 1;
                } else {
                    compound.tag = Some(tag.to_lowercase());
                    i = ni;
                }
            }
        }
    }
    compound
}

fn take_ident(chars: &[char], mut i: usize) -> (String, usize) {
    let mut out = String::new();
    while i < chars.len() {
        let c = chars[i];
        if c.is_alphanumeric() || c == '-' || c == '_' {
            out.push(c);
            i += 1;
        } else {
            break;
        }
    }
    (out, i)
}

fn take_until(chars: &[char], mut i: usize, end: char) -> (String, usize) {
    let mut out = String::new();
    while i < chars.len() {
        if chars[i] == end {
            i += 1;
            break;
        }
        out.push(chars[i]);
        i += 1;
    }
    (out, i)
}

fn take_balanced(chars: &[char], mut i: usize, open: char, close: char) -> (String, usize) {
    let mut depth = 1i32;
    let mut out = String::new();
    while i < chars.len() {
        let c = chars[i];
        if c == open {
            depth += 1;
        } else if c == close {
            depth -= 1;
            if depth == 0 {
                i += 1;
                break;
            }
        }
        out.push(c);
        i += 1;
    }
    (out, i)
}

fn unquote(s: &str) -> String {
    let s = s.trim();
    if s.len() >= 2 {
        let first = s.chars().next().unwrap();
        let last = s.chars().last().unwrap();
        if (first == '"' && last == '"') || (first == '\'' && last == '\'') {
            return s[1..s.len() - 1].to_string();
        }
    }
    s.to_string()
}

fn parse_attr(inner: &str) -> AttrSelector {
    let inner = inner.trim();
    if inner == "^" || inner == "*" {
        return AttrSelector {
            name: String::new(),
            matcher: AttrMatcher::AnyAttr,
        };
    }
    if let Some(rest) = inner.strip_prefix('^') {
        return AttrSelector {
            name: rest.trim().to_string(),
            matcher: AttrMatcher::AnyAttr,
        };
    }
    for (op, ctor) in [
        ("!=", AttrMatcher::NotEqual as fn(String) -> AttrMatcher),
        ("^=", AttrMatcher::Prefix as fn(String) -> AttrMatcher),
        ("$=", AttrMatcher::Suffix as fn(String) -> AttrMatcher),
        ("*=", AttrMatcher::Substring as fn(String) -> AttrMatcher),
        ("~=", AttrMatcher::Includes as fn(String) -> AttrMatcher),
        ("|=", AttrMatcher::Dash as fn(String) -> AttrMatcher),
        ("=", AttrMatcher::Exact as fn(String) -> AttrMatcher),
    ] {
        if let Some(idx) = inner.find(op) {
            let name = inner[..idx].trim().to_string();
            let value = unquote(inner[idx + op.len()..].trim());
            return AttrSelector {
                name,
                matcher: ctor(value),
            };
        }
    }
    AttrSelector {
        name: inner.to_string(),
        matcher: AttrMatcher::Exists,
    }
}

fn build_pseudo(name: &str, args: Option<String>) -> Option<Pseudo> {
    let a = || args.clone().map(|s| unquote(&s)).unwrap_or_default();
    Some(match name {
        "empty" => Pseudo::Empty,
        "first-child" | "first" | "firstChild" => Pseudo::FirstChild,
        "last-child" | "last" | "lastChild" => Pseudo::LastChild,
        "only-child" | "onlyChild" => Pseudo::OnlyChild,
        "first-of-type" | "firstOfType" => Pseudo::FirstOfType,
        "last-of-type" | "lastOfType" => Pseudo::LastOfType,
        "only-of-type" | "onlyOfType" => Pseudo::OnlyOfType,
        "nth-child" | "nthChild" => Pseudo::NthChild(a()),
        "nth-last-child" | "nthLastChild" => Pseudo::NthLastChild(a()),
        "nth-of-type" | "nthOfType" => Pseudo::NthOfType(a()),
        "nth-last-of-type" | "nthLastOfType" => Pseudo::NthLastOfType(a()),
        "contains" => Pseudo::Contains(a()),
        "icontains" => Pseudo::IContains(a()),
        "containsOwn" | "contains-own" => Pseudo::ContainsOwn(a()),
        "icontainsOwn" | "icontains-own" => Pseudo::IContainsOwn(a()),
        "matches" => Pseudo::Matches(a()),
        "matchesOwn" | "matches-own" => Pseudo::MatchesOwn(a()),
        "has" => Pseudo::Has(args.unwrap_or_default()),
        "not" => Pseudo::Not(args.unwrap_or_default()),
        "is" => Pseudo::Is(args.unwrap_or_default()),
        "eq" => Pseudo::Eq(a().parse().unwrap_or(-1)),
        "lt" => Pseudo::Lt(a().parse().unwrap_or(-1)),
        "gt" => Pseudo::Gt(a().parse().unwrap_or(-1)),
        "blank" => Pseudo::Blank,
        _ => return None,
    })
}

/// Parses a `nth-*` argument (`odd`, `even`, `2n+1`, `-n+3`, `5`, ...) into
/// `(a, b)` such that a 1-based `index` matches when `(index - b) % a == 0`
/// (for `a == 0`, matches only `index == b`).
fn parse_nth(expr: &str) -> (i64, i64) {
    let cleaned: String = expr.chars().filter(|c| !c.is_whitespace()).collect();
    let cleaned = cleaned.to_lowercase();
    if cleaned == "odd" {
        return (2, 1);
    }
    if cleaned == "even" {
        return (2, 0);
    }
    if let Ok(re) = Regex::new(r"^([+-]?\d*)?n([+-]?\d+)?$") {
        if let Some(caps) = re.captures(&cleaned) {
            let a_str = caps.get(1).map(|m| m.as_str()).unwrap_or("");
            let a: i64 = match a_str {
                "" | "+" => 1,
                "-" => -1,
                s => s.parse().unwrap_or(1),
            };
            let b: i64 = caps
                .get(2)
                .map(|m| m.as_str().parse().unwrap_or(0))
                .unwrap_or(0);
            return (a, b);
        }
    }
    (0, cleaned.parse().unwrap_or(0))
}

fn matches_nth(a: i64, b: i64, index: i64) -> bool {
    if a == 0 {
        return index == b;
    }
    let diff = index - b;
    if a > 0 {
        diff >= 0 && diff % a == 0
    } else {
        diff <= 0 && diff % a == 0
    }
}

// ---------------------------------------------------------------------------
// Matching
// ---------------------------------------------------------------------------

fn elem(doc: &Html, id: NodeId) -> Option<ElementRef<'_>> {
    ElementRef::wrap(doc.tree.get(id)?)
}

fn own_text(doc: &Html, id: NodeId) -> String {
    let node_ref = match doc.tree.get(id) {
        Some(n) => n,
        None => return String::new(),
    };
    let mut buf = String::new();
    for child in node_ref.children() {
        if let Node::Text(t) = child.value() {
            let trimmed = t.trim();
            if !trimmed.is_empty() {
                if !buf.is_empty() {
                    buf.push(' ');
                }
                buf.push_str(trimmed);
            }
        }
    }
    buf
}

fn text_content(doc: &Html, id: NodeId) -> String {
    elem(doc, id)
        .map(|e| e.text().collect::<Vec<_>>().join(""))
        .unwrap_or_default()
}

/// Element siblings (any tag) sharing the same parent as `id`, in document order.
fn element_siblings_any(doc: &Html, id: NodeId) -> Vec<NodeId> {
    let node = match doc.tree.get(id) {
        Some(n) => n,
        None => return Vec::new(),
    };
    let parent = match node.parent() {
        Some(p) => p,
        None => return vec![id],
    };
    parent
        .children()
        .filter(|c| ElementRef::wrap(*c).is_some())
        .map(|c| c.id())
        .collect()
}

/// Element siblings sharing the same tag name as `id`, in document order.
fn element_siblings_same_tag(doc: &Html, id: NodeId) -> Vec<NodeId> {
    let tag = elem(doc, id).map(|e| e.value().name().to_string());
    element_siblings_any(doc, id)
        .into_iter()
        .filter(|s| elem(doc, *s).map(|e| e.value().name().to_string()) == tag)
        .collect()
}

fn sibling_index(doc: &Html, id: NodeId) -> i64 {
    element_siblings_any(doc, id)
        .iter()
        .position(|x| *x == id)
        .map(|i| i as i64)
        .unwrap_or(-1)
}

fn matches_attr(e: ElementRef, sel: &AttrSelector) -> bool {
    if matches!(sel.matcher, AttrMatcher::AnyAttr) {
        if sel.name.is_empty() {
            return e.value().attrs().next().is_some();
        }
        return e
            .value()
            .attrs()
            .any(|(k, _)| k.starts_with(sel.name.as_str()));
    }
    let value = e.value().attr(&sel.name);
    match &sel.matcher {
        AttrMatcher::Exists => value.is_some(),
        AttrMatcher::Exact(v) => value.map(|x| x.eq_ignore_ascii_case(v)).unwrap_or(false),
        AttrMatcher::NotEqual(v) => value.map(|x| !x.eq_ignore_ascii_case(v)).unwrap_or(true),
        AttrMatcher::Prefix(v) => value
            .map(|x| x.to_lowercase().starts_with(&v.to_lowercase()))
            .unwrap_or(false),
        AttrMatcher::Suffix(v) => value
            .map(|x| x.to_lowercase().ends_with(&v.to_lowercase()))
            .unwrap_or(false),
        AttrMatcher::Substring(v) => value
            .map(|x| x.to_lowercase().contains(&v.to_lowercase()))
            .unwrap_or(false),
        AttrMatcher::Includes(v) => {
            if sel.name.eq_ignore_ascii_case("class") {
                e.value().classes().any(|c| c.eq_ignore_ascii_case(v))
            } else {
                value
                    .map(|x| x.split_whitespace().any(|p| p.eq_ignore_ascii_case(v)))
                    .unwrap_or(false)
            }
        }
        AttrMatcher::Dash(v) => value
            .map(|x| {
                x.eq_ignore_ascii_case(v)
                    || x.to_lowercase()
                        .starts_with(&format!("{}-", v.to_lowercase()))
            })
            .unwrap_or(false),
        AttrMatcher::AnyAttr => unreachable!(),
    }
}

fn matches_pseudo(doc: &Html, id: NodeId, p: &Pseudo) -> bool {
    match p {
        Pseudo::Empty => doc
            .tree
            .get(id)
            .map(|n| {
                n.children().all(|c| match c.value() {
                    Node::Text(t) => t.trim().is_empty(),
                    Node::Element(_) => false,
                    _ => true,
                })
            })
            .unwrap_or(false),
        Pseudo::Blank => text_content(doc, id).trim().is_empty(),
        Pseudo::FirstChild => element_siblings_any(doc, id).first() == Some(&id),
        Pseudo::LastChild => element_siblings_any(doc, id).last() == Some(&id),
        Pseudo::OnlyChild => element_siblings_any(doc, id).len() == 1,
        Pseudo::FirstOfType => element_siblings_same_tag(doc, id).first() == Some(&id),
        Pseudo::LastOfType => element_siblings_same_tag(doc, id).last() == Some(&id),
        Pseudo::OnlyOfType => element_siblings_same_tag(doc, id).len() == 1,
        Pseudo::NthChild(expr) => {
            let sibs = element_siblings_any(doc, id);
            let (a, b) = parse_nth(expr);
            match sibs.iter().position(|x| *x == id) {
                Some(idx) => matches_nth(a, b, idx as i64 + 1),
                None => false,
            }
        }
        Pseudo::NthLastChild(expr) => {
            let sibs = element_siblings_any(doc, id);
            let (a, b) = parse_nth(expr);
            match sibs.iter().position(|x| *x == id) {
                Some(idx) => matches_nth(a, b, (sibs.len() - idx) as i64),
                None => false,
            }
        }
        Pseudo::NthOfType(expr) => {
            let sibs = element_siblings_same_tag(doc, id);
            let (a, b) = parse_nth(expr);
            match sibs.iter().position(|x| *x == id) {
                Some(idx) => matches_nth(a, b, idx as i64 + 1),
                None => false,
            }
        }
        Pseudo::NthLastOfType(expr) => {
            let sibs = element_siblings_same_tag(doc, id);
            let (a, b) = parse_nth(expr);
            match sibs.iter().position(|x| *x == id) {
                Some(idx) => matches_nth(a, b, (sibs.len() - idx) as i64),
                None => false,
            }
        }
        Pseudo::Contains(t) | Pseudo::IContains(t) => text_content(doc, id)
            .to_lowercase()
            .contains(&t.to_lowercase()),
        Pseudo::ContainsOwn(t) | Pseudo::IContainsOwn(t) => {
            own_text(doc, id).to_lowercase().contains(&t.to_lowercase())
        }
        Pseudo::Matches(re) => Regex::new(re)
            .map(|r| r.is_match(&text_content(doc, id)))
            .unwrap_or(false),
        Pseudo::MatchesOwn(re) => Regex::new(re)
            .map(|r| r.is_match(&own_text(doc, id)))
            .unwrap_or(false),
        Pseudo::Has(sel) => !select(doc, id, sel).is_empty(),
        Pseudo::Not(sel) => !matches_any_group(doc, id, sel),
        Pseudo::Is(sel) => matches_any_group(doc, id, sel),
        Pseudo::Eq(n) => sibling_index(doc, id) == *n,
        Pseudo::Lt(n) => sibling_index(doc, id) < *n,
        Pseudo::Gt(n) => sibling_index(doc, id) > *n,
    }
}

/// Whether `id` matches any single-compound group in `sel` (used by `:is()`/`:not()`).
fn matches_any_group(doc: &Html, id: NodeId, sel: &str) -> bool {
    parse_groups(sel)
        .iter()
        .any(|chain| chain.len() == 1 && matches_compound(doc, id, &chain[0].1))
}

pub(crate) fn matches_compound(doc: &Html, id: NodeId, compound: &Compound) -> bool {
    let e = match elem(doc, id) {
        Some(e) => e,
        None => return false,
    };
    if let Some(tag) = &compound.tag {
        if e.value().name() != tag {
            return false;
        }
    }
    if let Some(wanted_id) = &compound.id {
        if e.value().id() != Some(wanted_id.as_str()) {
            return false;
        }
    }
    for class in &compound.classes {
        if !e.value().classes().any(|c| c == class) {
            return false;
        }
    }
    for attr in &compound.attrs {
        if !matches_attr(e, attr) {
            return false;
        }
    }
    for pseudo in &compound.pseudos {
        if !matches_pseudo(doc, id, pseudo) {
            return false;
        }
    }
    true
}

fn descendants_of(doc: &Html, root: NodeId) -> Vec<NodeId> {
    match doc.tree.get(root) {
        Some(n) => n
            .descendants()
            .filter(|d| d.id() != root)
            .map(|d| d.id())
            .collect(),
        None => Vec::new(),
    }
}

fn direct_children(doc: &Html, root: NodeId) -> Vec<NodeId> {
    match doc.tree.get(root) {
        Some(n) => n.children().map(|c| c.id()).collect(),
        None => Vec::new(),
    }
}

fn all_following_siblings(doc: &Html, id: NodeId) -> Vec<NodeId> {
    let mut out = Vec::new();
    if let Some(n) = doc.tree.get(id) {
        let mut cur = n.next_sibling();
        while let Some(s) = cur {
            out.push(s.id());
            cur = s.next_sibling();
        }
    }
    out
}

fn next_sibling(doc: &Html, id: NodeId) -> Option<NodeId> {
    doc.tree.get(id)?.next_sibling().map(|s| s.id())
}

fn select_chain(doc: &Html, root: NodeId, chain: &Chain) -> Vec<NodeId> {
    if chain.is_empty() {
        return Vec::new();
    }
    let mut ordered: Vec<NodeId> = descendants_of(doc, root)
        .into_iter()
        .filter(|id| elem(doc, *id).is_some() && matches_compound(doc, *id, &chain[0].1))
        .collect();

    for (combinator, compound) in &chain[1..] {
        let mut next = Vec::new();
        let mut seen = std::collections::HashSet::new();
        for &cand in &ordered {
            let related: Vec<NodeId> = match combinator {
                Combinator::Child => direct_children(doc, cand),
                Combinator::Descendant => descendants_of(doc, cand),
                Combinator::NextSibling => next_sibling(doc, cand).into_iter().collect(),
                Combinator::SubsequentSibling => all_following_siblings(doc, cand),
            };
            for r in related {
                if elem(doc, r).is_some() && matches_compound(doc, r, compound) && seen.insert(r) {
                    next.push(r);
                }
            }
        }
        ordered = next;
    }
    ordered
}

pub(crate) fn select(doc: &Html, root: NodeId, query: &str) -> Vec<NodeId> {
    let groups = parse_groups(query);
    let mut all = std::collections::HashSet::new();
    for chain in &groups {
        for id in select_chain(doc, root, chain) {
            all.insert(id);
        }
    }
    // Return results in document order for jsoup-like determinism.
    descendants_of(doc, root)
        .into_iter()
        .filter(|id| all.contains(id))
        .collect()
}

pub(crate) fn select_first(doc: &Html, root: NodeId, query: &str) -> Option<NodeId> {
    select(doc, root, query).into_iter().next()
}
