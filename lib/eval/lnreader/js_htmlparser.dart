import 'package:flutter_qjs/flutter_qjs.dart';

class JsHtmlParser {
  late JavascriptRuntime runtime;
  JsHtmlParser(this.runtime);

  void init() {
    runtime.evaluate('''
class Parser {
    constructor(options = {}) {
        this.options = options;
        this.buffer = '';
    }

    isVoidElement(name) {
      return [
        "area",
        "base",
        "basefont",
        "br",
        "col",
        "command",
        "embed",
        "frame",
        "hr",
        "img",
        "input",
        "isindex",
        "keygen",
        "link",
        "meta",
        "param",
        "source",
        "track",
        "wbr",
      ].includes(name);
    }

    write(html) {
        this.buffer += html;
        let i = 0;
        let textStart = 0;
        const len = this.buffer.length;
        let insideQuote = null;

        while (i < len) {
            const ch = this.buffer[i];

            // Track string literals
            if ((ch === '"' || ch === "'")) {
                if (insideQuote === ch) {
                    insideQuote = null;
                } else if (insideQuote === null) {
                    insideQuote = ch;
                }
                i++;
                continue;
            }

            if (ch === '<' && insideQuote === null) {
                // Emit any text before the tag
                if (i > textStart && this.options.ontext) {
                    const text = this.buffer.slice(textStart, i);
                    this.options.ontext(text);
                }

                const tagStart = i;
                i++;

                const isClosing = this.buffer[i] === '/';
                if (isClosing) i++;

                // Parse tag name
                const nameStart = i;
                while (i < len && /[a-zA-Z0-9:-]/.test(this.buffer[i])) i++;
                const nameEnd = i;
                const tagName = this.buffer.slice(nameStart, nameEnd);

                if (isClosing) {
                    if (this.options.onclosetag) {
                        this.options.onclosetag(tagName);
                    }
                } else {
                    if (this.options.onopentagname) {
                        this.options.onopentagname(tagName);
                    }
                }

                // Parse attributes
                let attrs = {};
                let attrName = '';
                let attrValue = '';
                let readingAttrName = true;
                let inAttrQuote = null;

                while (i < len && this.buffer[i] !== '>') {
                    const c = this.buffer[i];

                    // Skip over whitespace
                    if (/\\s/.test(c)) {
                        i++;
                        continue;
                    }

                    // Handle self-closing tag
                    if (c === '/' && this.buffer[i + 1] === '>') {
                        if (!isClosing && this.options.onselfclosingtag) {
                            this.options.onselfclosingtag();
                        }
                        i += 2;
                        textStart = i;
                        if (this.options.onopentag) {
                            this.options.onopentag(tagName, attrs);
                        }
                        if (this.options.onopentagend) {
                            this.options.onopentagend();
                        }
                        continue;
                    }

                    // Parse attribute name
                    let attrStart = i;
                    while (i < len && /[^\\s=>]/.test(this.buffer[i])) i++;
                    attrName = this.buffer.slice(attrStart, i);

                    // Skip whitespace after name
                    while (i < len && /\\s/.test(this.buffer[i])) i++;

                    // Expect '='
                    if (this.buffer[i] === '=') {
                        i++; // skip '='

                        // Skip whitespace after '='
                        while (i < len && /\\s/.test(this.buffer[i])) i++;

                        const quote = this.buffer[i];
                        if (quote === '"' || quote === "'") {
                            inAttrQuote = quote;
                            i++; // skip quote

                            const valStart = i;
                            while (i < len && this.buffer[i] !== inAttrQuote) i++;
                            attrValue = this.buffer.slice(valStart, i);
                            i++; // skip closing quote
                        } else {
                            // Unquoted value
                            const valStart = i;
                            while (i < len && /[^\\s>]/.test(this.buffer[i])) i++;
                            attrValue = this.buffer.slice(valStart, i);
                        }

                        // Emit merged attribute callback
                        if (this.options.onattribute) {
                            this.options.onattribute(attrName, attrValue);
                        }

                        attrs[attrName] = attrValue;
                        attrName = '';
                        attrValue = '';
                    } else {
                        // attribute without value (e.g. `disabled`)
                        if (this.options.onattribute) {
                            this.options.onattribute(attrName, null);
                        }
                        attrs[attrName] = null;
                        attrName = '';
                    }
                }

                // Closing normal tag '>'
                i++; // skip '>'

                if (!isClosing && this.options.onopentag) {
                    this.options.onopentag(tagName, attrs);
                }

                if (this.options.onopentagend) {
                    this.options.onopentagend();
                }

                textStart = i;
            } else {
                i++;
            }
        }

        // Emit any remaining text
        if (textStart < len && this.options.ontext) {
            const text = this.buffer.slice(textStart, len);
            this.options.ontext(text);
        }
    }

    end() {
        if (this.options.onend) {
            this.options.onend();
        }
    }
}
''');
  }
}
