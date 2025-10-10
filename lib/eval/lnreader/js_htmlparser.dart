import 'package:flutter_qjs/flutter_qjs.dart';

class JsHtmlParser {
  late JavascriptRuntime runtime;
  JsHtmlParser(this.runtime);

  void init() {
    runtime.evaluate('''
class Parser{constructor(t={}){this.options=t,this.buffer=""}write(t){this.buffer+=t;let s=0,o=0;const i=this.buffer.length;let n=null;for(;s<i;){const t=this.buffer[s];if('"'!==t&&"'"!==t)if("<"===t&&null===n){if(s>o&&this.options.ontext){const t=this.buffer.slice(o,s);this.options.ontext(t)}s++;const t="/"===this.buffer[s];t&&s++;const n=s;for(;s<i&&/[a-zA-Z0-9:-]/.test(this.buffer[s]);)s++;const e=s,f=this.buffer.slice(n,e);t?this.options.onclosetag&&this.options.onclosetag(f):this.options.onopentagname&&this.options.onopentagname(f);let h={},r="",l="",u=null;for(;s<i&&">"!==this.buffer[s];){const n=this.buffer[s];if(/\\s/.test(n)){s++;continue}if("/"===n&&">"===this.buffer[s+1])return!t&&this.options.onselfclosingtag&&this.options.onselfclosingtag(),s+=2,o=s,this.options.onopentag&&this.options.onopentag(f,h),void(this.options.onopentagend&&this.options.onopentagend());let e=s;for(;s<i&&/[^\\s=>]/.test(this.buffer[s]);)s++;for(r=this.buffer.slice(e,s);s<i&&/\\s/.test(this.buffer[s]);)s++;if("="===this.buffer[s]){for(s++;s<i&&/\\s/.test(this.buffer[s]);)s++;const t=this.buffer[s];if('"'===t||"'"===t){u=t,s++;const o=s;for(;s<i&&this.buffer[s]!==u;)s++;l=this.buffer.slice(o,s),s++}else{const t=s;for(;s<i&&/[^\\s>]/.test(this.buffer[s]);)s++;l=this.buffer.slice(t,s)}this.options.onattribute&&this.options.onattribute(r,l),h[r]=l,r="",l=""}else this.options.onattribute&&this.options.onattribute(r,null),h[r]=null,r=""}s++,!t&&this.options.onopentag&&this.options.onopentag(f,h),this.options.onopentagend&&this.options.onopentagend(),o=s}else s++;else n===t?n=null:null===n&&(n=t),s++}if(o<i&&this.options.ontext){const t=this.buffer.slice(o,i);this.options.ontext(t)}}end(){this.options.onend&&this.options.onend()}}
''');
  }
}
