window.Prism = window.Prism || {};
window.Prism.manual = true;
window.Prism.languages = window.Prism.languages || {};
var _self="undefined"!=typeof window?window:"undefined"!=typeof WorkerGlobalScope&&self instanceof WorkerGlobalScope?self:{},Prism=function(e){var t=/\blang(?:uage)?-([\w-]+)\b/i,a=0,n={manual:e.Prism&&e.Prism.manual,disableWorkerMessageHandler:e.Prism&&e.Prism.disableWorkerMessageHandler,util:{encode:function e(t){return t instanceof r?new r(t.type,e(t.content),t.alias):Array.isArray(t)?t.map(e):t.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/\u00a0/g," ")},type:function(e){return Object.prototype.toString.call(e).slice(8,-1)},objId:function(e){return e.__id||Object.defineProperty(e,"__id",{value:++a}),e.__id},clone:function e(t,a){var r,s;switch(a=a||{},n.util.type(t)){case"Object":if(s=n.util.objId(t),a[s])return a[s];for(var i in r={},a[s]=r,t)t.hasOwnProperty(i)&&(r[i]=e(t[i],a));return r;case"Array":return s=n.util.objId(t),a[s]?a[s]:(r=[],a[s]=r,t.forEach((function(t,n){r[n]=e(t,a)})),r);default:return t}},getLanguage:function(e){for(;e&&!t.test(e.className);)e=e.parentElement;return e?(e.className.match(t)||[,"none"])[1].toLowerCase():"none"},currentScript:function(){if("undefined"==typeof document)return null;if("currentScript"in document)return document.currentScript;try{throw new Error}catch(n){var e=(/at [^(\r\n]*\((.*):.+:.+\)$/i.exec(n.stack)||[])[1];if(e){var t=document.getElementsByTagName("script");for(var a in t)if(t[a].src==e)return t[a]}return null}},isActive:function(e,t,a){for(var n="no-"+t;e;){var r=e.classList;if(r.contains(t))return!0;if(r.contains(n))return!1;e=e.parentElement}return!!a}},languages:{extend:function(e,t){var a=n.util.clone(n.languages[e]);for(var r in t)a[r]=t[r];return a},insertBefore:function(e,t,a,r){var s=(r=r||n.languages)[e],i={};for(var l in s)if(s.hasOwnProperty(l)){if(l==t)for(var o in a)a.hasOwnProperty(o)&&(i[o]=a[o]);a.hasOwnProperty(l)||(i[l]=s[l])}var u=r[e];return r[e]=i,n.languages.DFS(n.languages,(function(t,a){a===u&&t!=e&&(this[t]=i)})),i},DFS:function e(t,a,r,s){s=s||{};var i=n.util.objId;for(var l in t)if(t.hasOwnProperty(l)){a.call(t,l,t[l],r||l);var o=t[l],u=n.util.type(o);"Object"!==u||s[i(o)]?"Array"!==u||s[i(o)]||(s[i(o)]=!0,e(o,a,l,s)):(s[i(o)]=!0,e(o,a,null,s))}}},plugins:{},highlightAll:function(e,t){n.highlightAllUnder(document,e,t)},highlightAllUnder:function(e,t,a){var r={callback:a,container:e,selector:'code[class*="language-"], [class*="language-"] code, code[class*="lang-"], [class*="lang-"] code'};n.hooks.run("before-highlightall",r),r.elements=Array.prototype.slice.apply(r.container.querySelectorAll(r.selector)),n.hooks.run("before-all-elements-highlight",r);for(var s,i=0;s=r.elements[i++];)n.highlightElement(s,!0===t,r.callback)},highlightElement:function(a,r,s){var i=n.util.getLanguage(a),l=n.languages[i];a.className=a.className.replace(t,"").replace(/\s+/g," ")+" language-"+i;var o=a.parentElement;o&&"pre"===o.nodeName.toLowerCase()&&(o.className=o.className.replace(t,"").replace(/\s+/g," ")+" language-"+i);var u={element:a,language:i,grammar:l,code:a.textContent};function g(e){u.highlightedCode=e,n.hooks.run("before-insert",u),u.element.innerHTML=u.highlightedCode,n.hooks.run("after-highlight",u),n.hooks.run("complete",u),s&&s.call(u.element)}if(n.hooks.run("before-sanity-check",u),!u.code)return n.hooks.run("complete",u),void(s&&s.call(u.element));if(n.hooks.run("before-highlight",u),u.grammar)if(r&&e.Worker){var c=new Worker(n.filename);c.onmessage=function(e){g(e.data)},c.postMessage(JSON.stringify({language:u.language,code:u.code,immediateClose:!0}))}else g(n.highlight(u.code,u.grammar,u.language));else g(n.util.encode(u.code))},highlight:function(e,t,a){var s={code:e,grammar:t,language:a};return n.hooks.run("before-tokenize",s),s.tokens=n.tokenize(s.code,s.grammar),n.hooks.run("after-tokenize",s),r.stringify(n.util.encode(s.tokens),s.language)},tokenize:function(e,t){var a=t.rest;if(a){for(var n in a)t[n]=a[n];delete t.rest}var r=new l;return o(r,r.head,e),i(e,r,t,r.head,0),function(e){var t=[],a=e.head.next;for(;a!==e.tail;)t.push(a.value),a=a.next;return t}(r)},hooks:{all:{},add:function(e,t){var a=n.hooks.all;a[e]=a[e]||[],a[e].push(t)},run:function(e,t){var a=n.hooks.all[e];if(a&&a.length)for(var r,s=0;r=a[s++];)r(t)}},Token:r};function r(e,t,a,n){this.type=e,this.content=t,this.alias=a,this.length=0|(n||"").length}function s(e,t,a,n){e.lastIndex=t;var r=e.exec(a);if(r&&n&&r[1]){var s=r[1].length;r.index+=s,r[0]=r[0].slice(s)}return r}function i(e,t,a,l,g,c){for(var d in a)if(a.hasOwnProperty(d)&&a[d]){var p=a[d];p=Array.isArray(p)?p:[p];for(var m=0;m<p.length;++m){if(c&&c.cause==d+","+m)return;var f=p[m],h=f.inside,v=!!f.lookbehind,y=!!f.greedy,b=f.alias;if(y&&!f.pattern.global){var F=f.pattern.toString().match(/[imsuy]*$/)[0];f.pattern=RegExp(f.pattern.source,F+"g")}for(var k=f.pattern||f,x=l.next,w=g;x!==t.tail&&!(c&&w>=c.reach);w+=x.value.length,x=x.next){var A=x.value;if(t.length>e.length)return;if(!(A instanceof r)){var P,$=1;if(y){if(!(P=s(k,w,e,v)))break;var S=P.index,E=P.index+P[0].length,_=w;for(_+=x.value.length;S>=_;)_+=(x=x.next).value.length;if(w=_-=x.value.length,x.value instanceof r)continue;for(var j=x;j!==t.tail&&(_<E||"string"==typeof j.value);j=j.next)$++,_+=j.value.length;$--,A=e.slice(w,_),P.index-=w}else if(!(P=s(k,0,A,v)))continue;S=P.index;var C=P[0],O=A.slice(0,S),z=A.slice(S+C.length),T=w+A.length;c&&T>c.reach&&(c.reach=T);var N=x.prev;O&&(N=o(t,N,O),w+=O.length),u(t,N,$),x=o(t,N,new r(d,h?n.tokenize(C,h):C,b,C)),z&&o(t,x,z),$>1&&i(e,t,a,x.prev,w,{cause:d+","+m,reach:T})}}}}}function l(){var e={value:null,prev:null,next:null},t={value:null,prev:e,next:null};e.next=t,this.head=e,this.tail=t,this.length=0}function o(e,t,a){var n=t.next,r={value:a,prev:t,next:n};return t.next=r,n.prev=r,e.length++,r}function u(e,t,a){for(var n=t.next,r=0;r<a&&n!==e.tail;r++)n=n.next;t.next=n,n.prev=t,e.length-=r}if(e.Prism=n,r.stringify=function e(t,a){if("string"==typeof t)return t;if(Array.isArray(t)){var r="";return t.forEach((function(t){r+=e(t,a)})),r}var s={type:t.type,content:e(t.content,a),tag:"span",classes:["token",t.type],attributes:{},language:a},i=t.alias;i&&(Array.isArray(i)?Array.prototype.push.apply(s.classes,i):s.classes.push(i)),n.hooks.run("wrap",s);var l="";for(var o in s.attributes)l+=" "+o+'="'+(s.attributes[o]||"").replace(/"/g,"&quot;")+'"';return"<"+s.tag+' class="'+s.classes.join(" ")+'"'+l+">"+s.content+"</"+s.tag+">"},!e.document)return e.addEventListener?(n.disableWorkerMessageHandler||e.addEventListener("message",(function(t){var a=JSON.parse(t.data),r=a.language,s=a.code,i=a.immediateClose;e.postMessage(n.highlight(s,n.languages[r],r)),i&&e.close()}),!1),n):n;var g=n.util.currentScript();function c(){n.manual||n.highlightAll()}if(g&&(n.filename=g.src,g.hasAttribute("data-manual")&&(n.manual=!0)),!n.manual){var d=document.readyState;"loading"===d||"interactive"===d&&g&&g.defer?document.addEventListener("DOMContentLoaded",c):window.requestAnimationFrame?window.requestAnimationFrame(c):window.setTimeout(c,16)}return n}(_self);
/**
 * Prism: Lightweight, robust, elegant syntax highlighting
 *
 * @license MIT <https://opensource.org/licenses/MIT>
 * @author Lea Verou <https://lea.verou.me>
 * @namespace
 * @public
 */"undefined"!=typeof module&&module.exports&&(module.exports=Prism),"undefined"!=typeof global&&(global.Prism=Prism),Prism.languages.markup={comment:/<!--[\s\S]*?-->/,prolog:/<\?[\s\S]+?\?>/,doctype:{pattern:/<!DOCTYPE(?:[^>"'[\]]|"[^"]*"|'[^']*')+(?:\[(?:[^<"'\]]|"[^"]*"|'[^']*'|<(?!!--)|<!--(?:[^-]|-(?!->))*-->)*\]\s*)?>/i,greedy:!0,inside:{"internal-subset":{pattern:/(\[)[\s\S]+(?=\]>$)/,lookbehind:!0,greedy:!0,inside:null},string:{pattern:/"[^"]*"|'[^']*'/,greedy:!0},punctuation:/^<!|>$|[[\]]/,"doctype-tag":/^DOCTYPE/,name:/[^\s<>'"]+/}},cdata:/<!\[CDATA\[[\s\S]*?]]>/i,tag:{pattern:/<\/?(?!\d)[^\s>\/=$<%]+(?:\s(?:\s*[^\s>\/=]+(?:\s*=\s*(?:"[^"]*"|'[^']*'|[^\s'">=]+(?=[\s>]))|(?=[\s/>])))+)?\s*\/?>/,greedy:!0,inside:{tag:{pattern:/^<\/?[^\s>\/]+/,inside:{punctuation:/^<\/?/,namespace:/^[^\s>\/:]+:/}},"attr-value":{pattern:/=\s*(?:"[^"]*"|'[^']*'|[^\s'">=]+)/,inside:{punctuation:[{pattern:/^=/,alias:"attr-equals"},/"|'/]}},punctuation:/\/?>/,"attr-name":{pattern:/[^\s>\/]+/,inside:{namespace:/^[^\s>\/:]+:/}}}},entity:[{pattern:/&[\da-z]{1,8};/i,alias:"named-entity"},/&#x?[\da-f]{1,8};/i]},Prism.languages.markup.tag.inside["attr-value"].inside.entity=Prism.languages.markup.entity,Prism.languages.markup.doctype.inside["internal-subset"].inside=Prism.languages.markup,Prism.hooks.add("wrap",(function(e){"entity"===e.type&&(e.attributes.title=e.content.replace(/&amp;/,"&"))})),Object.defineProperty(Prism.languages.markup.tag,"addInlined",{value:function(e,t){var a={};a["language-"+t]={pattern:/(^<!\[CDATA\[)[\s\S]+?(?=\]\]>$)/i,lookbehind:!0,inside:Prism.languages[t]},a.cdata=/^<!\[CDATA\[|\]\]>$/i;var n={"included-cdata":{pattern:/<!\[CDATA\[[\s\S]*?\]\]>/i,inside:a}};n["language-"+t]={pattern:/[\s\S]+/,inside:Prism.languages[t]};var r={};r[e]={pattern:RegExp(/(<__[^>]*>)(?:<!\[CDATA\[(?:[^\]]|\](?!\]>))*\]\]>|(?!<!\[CDATA\[)[\s\S])*?(?=<\/__>)/.source.replace(/__/g,(function(){return e})),"i"),lookbehind:!0,greedy:!0,inside:n},Prism.languages.insertBefore("markup","cdata",r)}}),Prism.languages.html=Prism.languages.markup,Prism.languages.mathml=Prism.languages.markup,Prism.languages.svg=Prism.languages.markup,Prism.languages.xml=Prism.languages.extend("markup",{}),Prism.languages.ssml=Prism.languages.xml,Prism.languages.atom=Prism.languages.xml,Prism.languages.rss=Prism.languages.xml,function(e){var t=/("|')(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1/;e.languages.css={comment:/\/\*[\s\S]*?\*\//,atrule:{pattern:/@[\w-](?:[^;{\s]|\s+(?![\s{]))*(?:;|(?=\s*\{))/,inside:{rule:/^@[\w-]+/,"selector-function-argument":{pattern:/(\bselector\s*\(\s*(?![\s)]))(?:[^()\s]|\s+(?![\s)])|\((?:[^()]|\([^()]*\))*\))+(?=\s*\))/,lookbehind:!0,alias:"selector"},keyword:{pattern:/(^|[^\w-])(?:and|not|only|or)(?![\w-])/,lookbehind:!0}}},url:{pattern:RegExp("\\burl\\((?:"+t.source+"|"+/(?:[^\\\r\n()"']|\\[\s\S])*/.source+")\\)","i"),greedy:!0,inside:{function:/^url/i,punctuation:/^\(|\)$/,string:{pattern:RegExp("^"+t.source+"$"),alias:"url"}}},selector:RegExp("[^{}\\s](?:[^{};\"'\\s]|\\s+(?![\\s{])|"+t.source+")*(?=\\s*\\{)"),string:{pattern:t,greedy:!0},property:/(?!\s)[-_a-z\xA0-\uFFFF](?:(?!\s)[-\w\xA0-\uFFFF])*(?=\s*:)/i,important:/!important\b/i,function:/[-a-z0-9]+(?=\()/i,punctuation:/[(){};:,]/},e.languages.css.atrule.inside.rest=e.languages.css;var a=e.languages.markup;a&&(a.tag.addInlined("style","css"),e.languages.insertBefore("inside","attr-value",{"style-attr":{pattern:/(^|["'\s])style\s*=\s*(?:"[^"]*"|'[^']*')/i,lookbehind:!0,inside:{"attr-value":{pattern:/=\s*(?:"[^"]*"|'[^']*'|[^\s'">=]+)/,inside:{style:{pattern:/(["'])[\s\S]+(?=["']$)/,lookbehind:!0,alias:"language-css",inside:e.languages.css},punctuation:[{pattern:/^=/,alias:"attr-equals"},/"|'/]}},"attr-name":/^style/i}}},a.tag))}(Prism),Prism.languages.clike={comment:[{pattern:/(^|[^\\])\/\*[\s\S]*?(?:\*\/|$)/,lookbehind:!0,greedy:!0},{pattern:/(^|[^\\:])\/\/.*/,lookbehind:!0,greedy:!0}],string:{pattern:/(["'])(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1/,greedy:!0},"class-name":{pattern:/(\b(?:class|interface|extends|implements|trait|instanceof|new)\s+|\bcatch\s+\()[\w.\\]+/i,lookbehind:!0,inside:{punctuation:/[.\\]/}},keyword:/\b(?:if|else|while|do|for|return|in|instanceof|function|new|try|throw|catch|finally|null|break|continue)\b/,boolean:/\b(?:true|false)\b/,function:/\w+(?=\()/,number:/\b0x[\da-f]+\b|(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:e[+-]?\d+)?/i,operator:/[<>]=?|[!=]=?=?|--?|\+\+?|&&?|\|\|?|[?*/~^%]/,punctuation:/[{}[\];(),.:]/},Prism.languages.javascript=Prism.languages.extend("clike",{"class-name":[Prism.languages.clike["class-name"],{pattern:/(^|[^$\w\xA0-\uFFFF])(?!\s)[_$A-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*(?=\.(?:prototype|constructor))/,lookbehind:!0}],keyword:[{pattern:/((?:^|})\s*)(?:catch|finally)\b/,lookbehind:!0},{pattern:/(^|[^.]|\.\.\.\s*)\b(?:as|async(?=\s*(?:function\b|\(|[$\w\xA0-\uFFFF]|$))|await|break|case|class|const|continue|debugger|default|delete|do|else|enum|export|extends|for|from|function|(?:get|set)(?=\s*[\[$\w\xA0-\uFFFF])|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)\b/,lookbehind:!0}],function:/#?(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*(?=\s*(?:\.\s*(?:apply|bind|call)\s*)?\()/,number:/\b(?:(?:0[xX](?:[\dA-Fa-f](?:_[\dA-Fa-f])?)+|0[bB](?:[01](?:_[01])?)+|0[oO](?:[0-7](?:_[0-7])?)+)n?|(?:\d(?:_\d)?)+n|NaN|Infinity)\b|(?:\b(?:\d(?:_\d)?)+\.?(?:\d(?:_\d)?)*|\B\.(?:\d(?:_\d)?)+)(?:[Ee][+-]?(?:\d(?:_\d)?)+)?/,operator:/--|\+\+|\*\*=?|=>|&&=?|\|\|=?|[!=]==|<<=?|>>>?=?|[-+*/%&|^!=<>]=?|\.{3}|\?\?=?|\?\.?|[~:]/}),Prism.languages.javascript["class-name"][0].pattern=/(\b(?:class|interface|extends|implements|instanceof|new)\s+)[\w.\\]+/,Prism.languages.insertBefore("javascript","keyword",{regex:{pattern:/((?:^|[^$\w\xA0-\uFFFF."'\])\s]|\b(?:return|yield))\s*)\/(?:\[(?:[^\]\\\r\n]|\\.)*]|\\.|[^/\\\[\r\n])+\/[gimyus]{0,6}(?=(?:\s|\/\*(?:[^*]|\*(?!\/))*\*\/)*(?:$|[\r\n,.;:})\]]|\/\/))/,lookbehind:!0,greedy:!0,inside:{"regex-source":{pattern:/^(\/)[\s\S]+(?=\/[a-z]*$)/,lookbehind:!0,alias:"language-regex",inside:Prism.languages.regex},"regex-flags":/[a-z]+$/,"regex-delimiter":/^\/|\/$/}},"function-variable":{pattern:/#?(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*(?=\s*[=:]\s*(?:async\s*)?(?:\bfunction\b|(?:\((?:[^()]|\([^()]*\))*\)|(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*)\s*=>))/,alias:"function"},parameter:[{pattern:/(function(?:\s+(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*)?\s*\(\s*)(?!\s)(?:[^()\s]|\s+(?![\s)])|\([^()]*\))+(?=\s*\))/,lookbehind:!0,inside:Prism.languages.javascript},{pattern:/(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*(?=\s*=>)/i,inside:Prism.languages.javascript},{pattern:/(\(\s*)(?!\s)(?:[^()\s]|\s+(?![\s)])|\([^()]*\))+(?=\s*\)\s*=>)/,lookbehind:!0,inside:Prism.languages.javascript},{pattern:/((?:\b|\s|^)(?!(?:as|async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|set|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)(?![$\w\xA0-\uFFFF]))(?:(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*\s*)\(\s*|\]\s*\(\s*)(?!\s)(?:[^()\s]|\s+(?![\s)])|\([^()]*\))+(?=\s*\)\s*\{)/,lookbehind:!0,inside:Prism.languages.javascript}],constant:/\b[A-Z](?:[A-Z_]|\dx?)*\b/}),Prism.languages.insertBefore("javascript","string",{"template-string":{pattern:/`(?:\\[\s\S]|\${(?:[^{}]|{(?:[^{}]|{[^}]*})*})+}|(?!\${)[^\\`])*`/,greedy:!0,inside:{"template-punctuation":{pattern:/^`|`$/,alias:"string"},interpolation:{pattern:/((?:^|[^\\])(?:\\{2})*)\${(?:[^{}]|{(?:[^{}]|{[^}]*})*})+}/,lookbehind:!0,inside:{"interpolation-punctuation":{pattern:/^\${|}$/,alias:"punctuation"},rest:Prism.languages.javascript}},string:/[\s\S]+/}}}),Prism.languages.markup&&Prism.languages.markup.tag.addInlined("script","javascript"),Prism.languages.js=Prism.languages.javascript,function(){if("undefined"!=typeof self&&self.Prism&&self.document){Element.prototype.matches||(Element.prototype.matches=Element.prototype.msMatchesSelector||Element.prototype.webkitMatchesSelector);var e=window.Prism,t={js:"javascript",py:"python",rb:"ruby",ps1:"powershell",psm1:"powershell",sh:"bash",bat:"batch",h:"c",tex:"latex"},a="data-src-status",n="loading",r="loaded",s='pre[data-src]:not([data-src-status="loaded"]):not([data-src-status="loading"])',i=/\blang(?:uage)?-([\w-]+)\b/i;e.hooks.add("before-highlightall",(function(e){e.selector+=", "+s})),e.hooks.add("before-sanity-check",(function(i){var l=i.element;if(l.matches(s)){i.code="",l.setAttribute(a,n);var u=l.appendChild(document.createElement("CODE"));u.textContent="Loading…";var g=l.getAttribute("data-src"),c=i.language;if("none"===c){var d=(/\.(\w+)$/.exec(g)||[,"none"])[1];c=t[d]||d}o(u,c),o(l,c);var p=e.plugins.autoloader;p&&p.loadLanguages(c);var m=new XMLHttpRequest;m.open("GET",g,!0),m.onreadystatechange=function(){var t,n;4==m.readyState&&(m.status<400&&m.responseText?(l.setAttribute(a,r),u.textContent=m.responseText,e.highlightElement(u)):(l.setAttribute(a,"failed"),m.status>=400?u.textContent=(t=m.status,n=m.statusText,"✖ Error "+t+" while fetching file: "+n):u.textContent="✖ Error: File does not exist or is empty"))},m.send(null)}})),e.plugins.fileHighlight={highlight:function(t){for(var a,n=(t||document).querySelectorAll(s),r=0;a=n[r++];)e.highlightElement(a)}};var l=!1;e.fileHighlight=function(){l||(console.warn("Prism.fileHighlight is deprecated. Use `Prism.plugins.fileHighlight.highlight` instead."),l=!0),e.plugins.fileHighlight.highlight.apply(this,arguments)}}function o(e,t){var a=e.className;a=a.replace(i," ")+" language-"+t,e.className=a.replace(/\s+/g," ").trim()}}();
Prism.languages.arturo = {
    'comment': /;.*/,
    'character': {
        pattern: /`.`/,
        alias: 'function'
    },
    'string': {
        pattern: /"(?:[^"\\]|\\.)*"/,
        greedy: true,
        alias: 'function'
    },
    'builtin': {
        pattern: /[\w]+\b\??:/i
    },
    'literal': {
        pattern: /'(?:[\w]+\b\??:?)/,
        alias: 'boolean'
    },
    'type': {
        pattern: /:(?:[\w]+\b\??:?)/,
        alias: 'boolean'
    },
    'keyword1': {
        pattern: /\b(?:all|and|any|ascii|attr|attribute|attributeLabel|binary|block|char|contains|database|date|dictionary|empty|equal|even|every|exists|false|floating|function|greater|greaterOrEqual|if|in|inline|integer|is|key|label|leap|less|lessOrEqual|literal|logical|lower|nand|negative|nor|not|notEqual|null|numeric|odd|or|path|pathLabel|positive|prefix|prime|regex|same|set|some|sorted|standalone|string|subset|suffix|superset|symbol|symbolLiteral|true|try|type|unless|upper|when|whitespace|word|xnor|xor|zero)\?/,
        alias: 'keyword'
    },
    'keyword2': {
        pattern: /\b(?:abs|acos|acosh|acsec|acsech|actan|actanh|add|after|alert|alias|and|angle|append|arg|args|arity|array|as|asec|asech|asin|asinh|atan|atan2|atanh|attr|attrs|average|before|benchmark|blend|break|builtins1|builtins2|call|capitalize|case|ceil|chop|clear|clip|close|color|combine|conj|continue|copy|cos|cosh|crc|csec|csech|ctan|ctanh|cursor|darken|dec|decode|define|delete|desaturate|deviation|dialog|dictionary|difference|digest|digits|div|do|download|drop|dup|e|else|empty|encode|ensure|env|escape|execute|exit|exp|extend|extract|factors|false|fdiv|filter|first|flatten|floor|fold|from|function|gamma|gcd|get|goto|hash|hypot|if|inc|indent|index|infinity|info|input|insert|inspect|intersection|invert|jaro|join|keys|kurtosis|last|let|levenshtein|lighten|list|ln|log|loop|lower|mail|map|match|max|maybe|median|min|mod|module|mul|nand|neg|new|nor|normalize|not|now|null|open|or|outdent|pad|palette|panic|path|pause|permissions|permutate|pi|pop|popup|pow|powerset|powmod|prefix|print|prints|process|product|query|random|range|read|relative|remove|rename|render|repeat|replace|request|return|reverse|round|sample|saturate|script|sec|sech|select|serve|set|shl|shr|shuffle|sin|sinh|size|skewness|slice|sort|spin|split|sqrt|squeeze|stack|strip|sub|suffix|sum|switch|symbols|symlink|sys|take|tan|tanh|terminal|terminate|to|true|truncate|try|type|unclip|union|unique|unless|until|unzip|upper|values|var|variance|volume|webview|while|with|wordwrap|write|xnor|xor|zip)\b/,
        alias: 'keyword'
    },
    'sugar': {
        pattern: /\->|=>|\||\:\:/,
        alias: 'important'
    },
    'symbol': {
        pattern: /<\:|\-\:|ø|@|#|\+|\||\*|\$|\-|\%|\/|\.\.|\^|~|=|<|>|\\|\-\-\-/
    }
};

Prism.languages.art = Prism.languages['arturo'];
document.addEventListener('DOMContentLoaded', () => {
    Prism.highlightAll();
    window.scroll = new SmoothScroll('a[href*="#"]',{
        speed: 200,
        offset: 90
    });
});

(function(Prism) {
	// $ set | grep '^[A-Z][^[:space:]]*=' | cut -d= -f1 | tr '\n' '|'
	// + LC_ALL, RANDOM, REPLY, SECONDS.
	// + make sure PS1..4 are here as they are not always set,
	// - some useless things.
	var envVars = '\\b(?:BASH|BASHOPTS|BASH_ALIASES|BASH_ARGC|BASH_ARGV|BASH_CMDS|BASH_COMPLETION_COMPAT_DIR|BASH_LINENO|BASH_REMATCH|BASH_SOURCE|BASH_VERSINFO|BASH_VERSION|COLORTERM|COLUMNS|COMP_WORDBREAKS|DBUS_SESSION_BUS_ADDRESS|DEFAULTS_PATH|DESKTOP_SESSION|DIRSTACK|DISPLAY|EUID|GDMSESSION|GDM_LANG|GNOME_KEYRING_CONTROL|GNOME_KEYRING_PID|GPG_AGENT_INFO|GROUPS|HISTCONTROL|HISTFILE|HISTFILESIZE|HISTSIZE|HOME|HOSTNAME|HOSTTYPE|IFS|INSTANCE|JOB|LANG|LANGUAGE|LC_ADDRESS|LC_ALL|LC_IDENTIFICATION|LC_MEASUREMENT|LC_MONETARY|LC_NAME|LC_NUMERIC|LC_PAPER|LC_TELEPHONE|LC_TIME|LESSCLOSE|LESSOPEN|LINES|LOGNAME|LS_COLORS|MACHTYPE|MAILCHECK|MANDATORY_PATH|NO_AT_BRIDGE|OLDPWD|OPTERR|OPTIND|ORBIT_SOCKETDIR|OSTYPE|PAPERSIZE|PATH|PIPESTATUS|PPID|PS1|PS2|PS3|PS4|PWD|RANDOM|REPLY|SECONDS|SELINUX_INIT|SESSION|SESSIONTYPE|SESSION_MANAGER|SHELL|SHELLOPTS|SHLVL|SSH_AUTH_SOCK|TERM|UID|UPSTART_EVENTS|UPSTART_INSTANCE|UPSTART_JOB|UPSTART_SESSION|USER|WINDOWID|XAUTHORITY|XDG_CONFIG_DIRS|XDG_CURRENT_DESKTOP|XDG_DATA_DIRS|XDG_GREETER_DATA_DIR|XDG_MENU_PREFIX|XDG_RUNTIME_DIR|XDG_SEAT|XDG_SEAT_PATH|XDG_SESSION_DESKTOP|XDG_SESSION_ID|XDG_SESSION_PATH|XDG_SESSION_TYPE|XDG_VTNR|XMODIFIERS)\\b';

	var commandAfterHeredoc = {
		pattern: /(^(["']?)\w+\2)[ \t]+\S.*/,
		lookbehind: true,
		alias: 'punctuation', // this looks reasonably well in all themes
		inside: null // see below
	};

	var insideString = {
		'bash': commandAfterHeredoc,
		'environment': {
			pattern: RegExp("\\$" + envVars),
			alias: 'constant'
		},
		'variable': [
			// [0]: Arithmetic Environment
			{
				pattern: /\$?\(\([\s\S]+?\)\)/,
				greedy: true,
				inside: {
					// If there is a $ sign at the beginning highlight $(( and )) as variable
					'variable': [
						{
							pattern: /(^\$\(\([\s\S]+)\)\)/,
							lookbehind: true
						},
						/^\$\(\(/
					],
					'number': /\b0x[\dA-Fa-f]+\b|(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:[Ee]-?\d+)?/,
					// Operators according to https://www.gnu.org/software/bash/manual/bashref.html#Shell-Arithmetic
					'operator': /--?|-=|\+\+?|\+=|!=?|~|\*\*?|\*=|\/=?|%=?|<<=?|>>=?|<=?|>=?|==?|&&?|&=|\^=?|\|\|?|\|=|\?|:/,
					// If there is no $ sign at the beginning highlight (( and )) as punctuation
					'punctuation': /\(\(?|\)\)?|,|;/
				}
			},
			// [1]: Command Substitution
			{
				pattern: /\$\((?:\([^)]+\)|[^()])+\)|`[^`]+`/,
				greedy: true,
				inside: {
					'variable': /^\$\(|^`|\)$|`$/
				}
			},
			// [2]: Brace expansion
			{
				pattern: /\$\{[^}]+\}/,
				greedy: true,
				inside: {
					'operator': /:[-=?+]?|[!\/]|##?|%%?|\^\^?|,,?/,
					'punctuation': /[\[\]]/,
					'environment': {
						pattern: RegExp("(\\{)" + envVars),
						lookbehind: true,
						alias: 'constant'
					}
				}
			},
			/\$(?:\w+|[#?*!@$])/
		],
		// Escape sequences from echo and printf's manuals, and escaped quotes.
		'entity': /\\(?:[abceEfnrtv\\"]|O?[0-7]{1,3}|x[0-9a-fA-F]{1,2}|u[0-9a-fA-F]{4}|U[0-9a-fA-F]{8})/
	};

	Prism.languages.bash = {
		'shebang': {
			pattern: /^#!\s*\/.*/,
			alias: 'important'
		},
		'comment': {
			pattern: /(^|[^"{\\$])#.*/,
			lookbehind: true
		},
		'function-name': [
			// a) function foo {
			// b) foo() {
			// c) function foo() {
			// but not “foo {”
			{
				// a) and c)
				pattern: /(\bfunction\s+)[\w-]+(?=(?:\s*\(?:\s*\))?\s*\{)/,
				lookbehind: true,
				alias: 'function'
			},
			{
				// b)
				pattern: /\b[\w-]+(?=\s*\(\s*\)\s*\{)/,
				alias: 'function'
			}
		],
		// Highlight variable names as variables in for and select beginnings.
		'for-or-select': {
			pattern: /(\b(?:for|select)\s+)\w+(?=\s+in\s)/,
			alias: 'variable',
			lookbehind: true
		},
		// Highlight variable names as variables in the left-hand part
		// of assignments (“=” and “+=”).
		'assign-left': {
			pattern: /(^|[\s;|&]|[<>]\()\w+(?=\+?=)/,
			inside: {
				'environment': {
					pattern: RegExp("(^|[\\s;|&]|[<>]\\()" + envVars),
					lookbehind: true,
					alias: 'constant'
				}
			},
			alias: 'variable',
			lookbehind: true
		},
		'string': [
			// Support for Here-documents https://en.wikipedia.org/wiki/Here_document
			{
				pattern: /((?:^|[^<])<<-?\s*)(\w+?)\s[\s\S]*?(?:\r?\n|\r)\2/,
				lookbehind: true,
				greedy: true,
				inside: insideString
			},
			// Here-document with quotes around the tag
			// → No expansion (so no “inside”).
			{
				pattern: /((?:^|[^<])<<-?\s*)(["'])(\w+)\2\s[\s\S]*?(?:\r?\n|\r)\3/,
				lookbehind: true,
				greedy: true,
				inside: {
					'bash': commandAfterHeredoc
				}
			},
			// “Normal” string
			{
				// https://www.gnu.org/software/bash/manual/html_node/Double-Quotes.html
				pattern: /(^|[^\\](?:\\\\)*)"(?:\\[\s\S]|\$\([^)]+\)|\$(?!\()|`[^`]+`|[^"\\`$])*"/,
				lookbehind: true,
				greedy: true,
				inside: insideString
			},
			{
				// https://www.gnu.org/software/bash/manual/html_node/Single-Quotes.html
				pattern: /(^|[^$\\])'[^']*'/,
				lookbehind: true,
				greedy: true
			},
			{
				// https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html
				pattern: /\$'(?:[^'\\]|\\[\s\S])*'/,
				greedy: true,
				inside: {
					'entity': insideString.entity
				}
			}
		],
		'environment': {
			pattern: RegExp("\\$?" + envVars),
			alias: 'constant'
		},
		'variable': insideString.variable,
		'function': {
			pattern: /(^|[\s;|&]|[<>]\()(?:add|apropos|apt|aptitude|apt-cache|apt-get|aspell|automysqlbackup|awk|basename|bash|bc|bconsole|bg|bzip2|cal|cat|cfdisk|chgrp|chkconfig|chmod|chown|chroot|cksum|clear|cmp|column|comm|composer|cp|cron|crontab|csplit|curl|cut|date|dc|dd|ddrescue|debootstrap|df|diff|diff3|dig|dir|dircolors|dirname|dirs|dmesg|du|egrep|eject|env|ethtool|expand|expect|expr|fdformat|fdisk|fg|fgrep|file|find|fmt|fold|format|free|fsck|ftp|fuser|gawk|git|gparted|grep|groupadd|groupdel|groupmod|groups|grub-mkconfig|gzip|halt|head|hg|history|host|hostname|htop|iconv|id|ifconfig|ifdown|ifup|import|install|ip|jobs|join|kill|killall|less|link|ln|locate|logname|logrotate|look|lpc|lpr|lprint|lprintd|lprintq|lprm|ls|lsof|lynx|make|man|mc|mdadm|mkconfig|mkdir|mke2fs|mkfifo|mkfs|mkisofs|mknod|mkswap|mmv|more|most|mount|mtools|mtr|mutt|mv|nano|nc|netstat|nice|nl|nohup|notify-send|npm|nslookup|op|open|parted|passwd|paste|pathchk|ping|pkill|pnpm|popd|pr|printcap|printenv|ps|pushd|pv|quota|quotacheck|quotactl|ram|rar|rcp|reboot|remsync|rename|renice|rev|rm|rmdir|rpm|rsync|scp|screen|sdiff|sed|sendmail|seq|service|sftp|sh|shellcheck|shuf|shutdown|sleep|slocate|sort|split|ssh|stat|strace|su|sudo|sum|suspend|swapon|sync|tac|tail|tar|tee|time|timeout|top|touch|tr|traceroute|tsort|tty|umount|uname|unexpand|uniq|units|unrar|unshar|unzip|update-grub|uptime|useradd|userdel|usermod|users|uudecode|uuencode|v|vdir|vi|vim|virsh|vmstat|wait|watch|wc|wget|whereis|which|who|whoami|write|xargs|xdg-open|yarn|yes|zenity|zip|zsh|zypper)(?=$|[)\s;|&])/,
			lookbehind: true
		},
		'keyword': {
			pattern: /(^|[\s;|&]|[<>]\()(?:if|then|else|elif|fi|for|while|in|case|esac|function|select|do|done|until)(?=$|[)\s;|&])/,
			lookbehind: true
		},
		// https://www.gnu.org/software/bash/manual/html_node/Shell-Builtin-Commands.html
		'builtin': {
			pattern: /(^|[\s;|&]|[<>]\()(?:\.|:|break|cd|continue|eval|exec|exit|export|getopts|hash|pwd|readonly|return|shift|test|times|trap|umask|unset|alias|bind|builtin|caller|command|declare|echo|enable|help|let|local|logout|mapfile|printf|read|readarray|source|type|typeset|ulimit|unalias|set|shopt)(?=$|[)\s;|&])/,
			lookbehind: true,
			// Alias added to make those easier to distinguish from strings.
			alias: 'class-name'
		},
		'boolean': {
			pattern: /(^|[\s;|&]|[<>]\()(?:true|false)(?=$|[)\s;|&])/,
			lookbehind: true
		},
		'file-descriptor': {
			pattern: /\B&\d\b/,
			alias: 'important'
		},
		'operator': {
			// Lots of redirections here, but not just that.
			pattern: /\d?<>|>\||\+=|==?|!=?|=~|<<[<-]?|[&\d]?>>|\d?[<>]&?|&[>&]?|\|[&|]?|<=?|>=?/,
			inside: {
				'file-descriptor': {
					pattern: /^\d/,
					alias: 'important'
				}
			}
		},
		'punctuation': /\$?\(\(?|\)\)?|\.\.|[{}[\];\\]/,
		'number': {
			pattern: /(^|\s)(?:[1-9]\d*|0)(?:[.,]\d+)?\b/,
			lookbehind: true
		}
	};

	commandAfterHeredoc.inside = Prism.languages.bash;

	/* Patterns in command substitution. */
	var toBeCopied = [
		'comment',
		'function-name',
		'for-or-select',
		'assign-left',
		'string',
		'environment',
		'function',
		'keyword',
		'builtin',
		'boolean',
		'file-descriptor',
		'operator',
		'punctuation',
		'number'
	];
	var inside = insideString.variable[1].inside;
	for(var i = 0; i < toBeCopied.length; i++) {
		inside[toBeCopied[i]] = Prism.languages.bash[toBeCopied[i]];
	}

	Prism.languages.shell = Prism.languages.bash;
})(Prism);

var linuxLogo = `<svg xmlns="http://www.w3.org/2000/svg" width="2em" height="2em" viewBox="0 0 32 32"><path fill="currentColor" d="M16 5C10.488 5 6 9.488 6 15v8c0 1.117-.883 2-2 2v2c2.2 0 4-1.8 4-4v-8c0-4.43 3.57-8 8-8a7.98 7.98 0 0 1 2.875.531c-.293.414-.137 1.145.406 1.688c.586.586 1.39.734 1.782.344c.144-.145.187-.368.187-.594A7.978 7.978 0 0 1 24 15v8c0 2.2 1.8 4 4 4v-2c-1.117 0-2-.883-2-2v-8c0-5.512-4.488-10-10-10zm-3 6c-1.52 0-2.668.852-3.25 1.875C9.168 13.898 9 15.047 9 16c0 1.355.414 2.348.875 2.969c.043.058.082.101.125.156c-.613.656-1 1.469-1 2.375c0 1.43.973 2.598 2.25 3.344C12.527 25.59 14.184 26 16 26c1.816 0 3.473-.41 4.75-1.156C22.027 24.098 23 22.93 23 21.5c0-.906-.387-1.719-1-2.375c.043-.055.082-.098.125-.156c.46-.621.875-1.614.875-2.969c0-.953-.168-2.102-.75-3.125A3.707 3.707 0 0 0 19 11a3.688 3.688 0 0 0-3 1.5a3.688 3.688 0 0 0-3-1.5zm0 2c.867 0 1.21.313 1.531.875c.32.563.469 1.418.469 2.125h2c0-.707.148-1.563.469-2.125c.32-.563.664-.875 1.531-.875c.867 0 1.21.313 1.531.875c.32.563.469 1.418.469 2.125c0 .96-.277 1.48-.5 1.781c-.07.098-.11.14-.156.188c-.227-.114-.446-.25-.688-.344c.211-.273.344-.672.344-1.125c0-.828-.45-1.5-1-1.5s-1 .672-1 1.5c0 .266.078.504.156.719A10.963 10.963 0 0 0 16 17c-.758 0-1.469.082-2.156.219c.078-.215.156-.453.156-.719c0-.828-.45-1.5-1-1.5s-1 .672-1 1.5c0 .453.133.852.344 1.125c-.242.094-.461.23-.688.344a1.334 1.334 0 0 1-.156-.188c-.223-.3-.5-.82-.5-1.781c0-.707.148-1.563.469-2.125c.32-.563.664-.875 1.531-.875zm3 6c1.5 0 2.855.352 3.75.875S21 20.996 21 21.5s-.355 1.102-1.25 1.625c-.895.523-2.25.875-3.75.875s-2.855-.352-3.75-.875S11 22.004 11 21.5s.355-1.102 1.25-1.625C13.145 19.352 14.5 19 16 19zm-2.5 1.438l-1 1.718S13.926 23 16 23s3.5-.844 3.5-.844l-1-1.718S17.547 21 16 21c-1.547 0-2.5-.563-2.5-.563z"></path></svg>`;
var macosLogo = `<svg xmlns="http://www.w3.org/2000/svg" width="2em" height="2em" viewBox="0 0 32 32"><path fill="currentColor" d="M20.844 2c-1.64 0-3.297.852-4.407 2.156v.032c-.789.98-1.644 2.527-1.375 4.312c-.128-.05-.136-.035-.28-.094c-.692-.281-1.548-.594-2.563-.594c-3.98 0-7 3.606-7 8.344c0 3.067 1.031 5.942 2.406 8.094c.688 1.078 1.469 1.965 2.281 2.625c.813.66 1.664 1.125 2.625 1.125c.961 0 1.68-.324 2.219-.563c.54-.238.957-.437 1.75-.437c.715 0 1.078.195 1.625.438c.547.242 1.293.562 2.281.562c1.07 0 1.98-.523 2.719-1.188c.738-.664 1.36-1.519 1.875-2.343c.516-.824.922-1.633 1.219-2.282c.148-.324.258-.593.343-.812c.086-.219.13-.281.188-.531l.188-.813l-.75-.343a5.33 5.33 0 0 1-1.5-1.063c-.625-.637-1.157-1.508-1.157-2.844A4.08 4.08 0 0 1 24.563 13c.265-.309.542-.563.75-.719c.105-.078.187-.117.25-.156c.062-.04.05-.027.156-.094l.843-.531l-.562-.844c-1.633-2.511-4.246-2.844-5.281-2.844c-.48 0-.82.168-1.25.25c.242-.226.554-.367.75-.624c.004-.004-.004-.028 0-.032c.011-.011.023-.02.031-.031h.031a6.16 6.16 0 0 0 1.563-4.438L21.78 2zm-1.188 2.313c-.172.66-.453 1.289-.906 1.78l-.063.063c-.382.516-.972.899-1.562 1.125c.164-.652.45-1.312.844-1.812c.008-.012.023-.02.031-.032c.438-.5 1.043-.875 1.656-1.125zm-7.437 5.5c.558 0 1.172.21 1.812.468c.64.258 1.239.594 2.094.594c.852 0 1.496-.336 2.25-.594c.754-.258 1.559-.469 2.344-.469c.523 0 1.816.333 2.906 1.344c-.191.172-.36.297-.563.531a6.21 6.21 0 0 0-1.53 4.094c0 1.906.831 3.34 1.718 4.25c.55.563.89.696 1.313.938c-.055.125-.086.222-.157.375a18.82 18.82 0 0 1-1.093 2.062c-.454.727-1.004 1.434-1.532 1.907c-.527.472-1 .687-1.375.687c-.566 0-.898-.156-1.468-.406S17.581 25 16.5 25c-1.137 0-1.977.336-2.563.594c-.585.258-.89.406-1.406.406c-.246 0-.777-.2-1.375-.688c-.597-.488-1.254-1.23-1.844-2.156c-1.183-1.851-2.093-4.394-2.093-7c0-3.941 2.199-6.343 5-6.343z"></path></svg>`;
var windowsLogo = `<svg xmlns="http://www.w3.org/2000/svg" width="2em" height="2em" viewBox="0 0 32 32"><path fill="currentColor" d="M27 5L5 7.992v16.016L27 27V5zm-2 2.29V15H15V8.65l10-1.36zM13 8.921V15H7V9.738l6-.816zM7 17h6v6.078l-6-.816V17zm8 0h10v7.71l-10-1.36V17z"></path></svg>`;
var bsdLogo = `<svg xmlns="http://www.w3.org/2000/svg" width="2em" height="2em" viewBox="0 0 32 32"><path fill="currentColor" d="M5 5v1c0 1.852.621 3.855 1.5 5.469A10.989 10.989 0 0 0 5 17c0 6.063 4.938 11 11 11c5.695 0 10.387-4.352 10.938-9.906c.035-.364.062-.723.062-1.094c0-1.574-.336-3.098-.969-4.5c-.05.086-.082.148-.125.219c-.343.765-.742 1.574-1.156 2.25A8.79 8.79 0 0 1 25 17c0 .305-.004.61-.031.906A8.998 8.998 0 0 1 16 26c-4.984 0-9-4.016-9-9s4.016-9 9-9c.43 0 .836.035 1.25.094c.242-.324.492-.614.719-.875v-.032L18.156 7c.219-.238.426-.441.625-.625A10.852 10.852 0 0 0 16 6c-1.395 0-2.738.273-3.969.75a8.273 8.273 0 0 0-1.094-.656C9.817 5.535 8.168 5 6 5zm21 0c-2.168 0-3.816.535-4.938 1.094c-1.12.558-1.78 1.187-1.78 1.187L19 7.594v.437s.023 1.211.656 2.438C20.29 11.695 21.72 13 24 13h.531l.313-.438S27 9.445 27 6V5zM7.219 7.156c1.093.14 2.031.39 2.687.688c-.746.496-1.398 1.09-2 1.75a13.263 13.263 0 0 1-.687-2.438zm17.5 0c-.328 1.758-.91 3.137-1.25 3.719c-1.098-.168-1.696-.688-2.032-1.344c-.28-.543-.277-.808-.312-1.094c.172-.144.23-.238.813-.53c.644-.321 1.636-.598 2.78-.75z"></path></svg>`;
var raspberryLogo = `<svg xmlns="http://www.w3.org/2000/svg" width="2em" height="2em" viewBox="0 0 32 32"><path fill="currentColor" d="m24.398 14.8l-.199-.3c0-2.398-1.097-3.3-2.3-4c.402-.102.8-.2.902-.7c.699-.198.8-.5.898-.8c.2-.102.7-.398.7-1c.3-.2.5-.5.402-.898c.3-.403.398-.704.3-1c.399-.5.2-.801.098-1.102c.301-.602 0-1.2-.8-1.102c-.297-.5-1.098-.398-1.2-.398c-.097-.2-.3-.3-.8-.2c-.5-.3-.899-.3-1.297-.1c-.5-.4-.801-.098-1.102 0c-.602-.2-.7.1-1 .198c-.602-.097-.8.204-1.102.5h-.296c-.903.5-1.403 1.704-1.602 2.204c-.2-.602-.602-1.704-1.602-2.204h-.296c-.301-.296-.5-.597-1.102-.5c-.3-.097-.398-.398-1-.199c-.2-.097-.398-.199-.7-.199c-.1 0-.198.102-.402.2c-.398-.2-.796-.2-1.097.1c-.5-.1-.7.098-.801.2c-.102 0-.898-.102-1.2.398c-.902-.097-1.198.5-.902 1.102c-.199.3-.296.5.102 1.102c-.2.199-.102.597.3.898c-.1.398 0 .7.4 1c-.098.5.5.8.6 1c.098.3.2.602.9.8c.1.5.5.598.902.7c-1.301.7-2.301 1.7-2.301 4l-.2.3c-1.402.9-2.703 3.7-.703 6c.102.7.301 1.2.5 1.802c.301 2.296 2.204 3.398 2.704 3.5c.699.597 1.5 1.097 2.597 1.5c1 1 2.102 1.398 3.2 1.398c1.101 0 2.203-.398 3.203-1.398c1.097-.403 1.898-.903 2.597-1.5c.5-.102 2.403-1.204 2.7-3.5C24.601 22 24.8 21.5 25 20.8c2.2-2.301.898-5.102-.602-6zm-1.296-.402C23 15.398 18.199 11.102 19 11c2.3-.398 4.2.898 4.102 3.398zM17.8 4.5c0 .2.097.3.097.398c.301-.296.5-.597.801-.898c0 .2-.097.3.102.5c.199-.3.398-.5.8-.7c-.203.302 0 .4.098.5c.301-.198.5-.402 1-.6c-.097.198-.3.3-.097.5c.296-.2.5-.302 1.199-.5c-.102.198-.403.3-.301.5c.3-.098.7-.2 1.102-.302c-.204.204-.403.301-.204.403c.403-.102.801-.301 1.301-.102l-.3.301h1.203c-.204.3-.403.5-.5.898h.5c-.204.602-.602.704-.704.903c.102.097.301.097.602 0c-.2.398-.5.597-.8.898c.1.102.198.102.5 0c-.302.301-.598.5-.9.801c.098.102.302.102.5.102c-.3.296-.8.5-1.198.699c.097.199.296.097.398.097c-.3.204-.8.403-1.2.5c.098.102.2.204.4.204c-.5.296-1.2.097-1.4.296c0 .102.2.204.302.301c-.801 0-2.903 0-3.301-1.597c.8-.903 2.199-1.903 4.699-3.204c-1.898.704-3.7 1.5-5.102 2.704c-1.597-.801-.5-2.801.403-3.602zM16 10.3c1.2 0 2.7.9 2.7 1.802c0 .796-1.098 1.398-2.7 1.398s-2.7-.8-2.7-1.5s1.302-1.7 2.7-1.7zm-6.102-.6c.204 0 .301-.098.403-.2c-.5-.2-1-.3-1.301-.602c.2 0 .3 0 .5-.097c-.398-.2-.8-.403-1.2-.7c.2 0 .4 0 .5-.101c-.3-.2-.6-.5-.902-.7h.5c-.296-.402-.597-.6-.796-1a.643.643 0 0 0 .597 0c-.097-.198-.597-.3-.8-.8h.5c-.098-.398-.297-.7-.399-.898h1.2l-.302-.403c.5-.097 1 0 1.301.102c.2-.102 0-.301-.199-.403c.398.102.8.204 1.102.301c.199-.199-.102-.3-.301-.5c.699.102.898.301 1.199.5c.2-.199 0-.3-.102-.5c.5.2.704.403 1 .602c.102-.102.204-.2.102-.5c.2.199.5.398.7.699c.198-.102.1-.3.1-.5c.302.3.598.602.802.898c.097 0 .097-.199.097-.398c.801.8 2 2.8.301 3.602C13.102 6.898 11.3 6 9.398 5.398c2.5 1.301 3.903 2.301 4.704 3.204c-.403 1.597-2.5 1.699-3.301 1.597c.199-.097.3-.199.3-.3c-.101-.098-.703 0-1.203-.2zm2.801 1.198c.801.102-4 4.403-4.097 3.403c-.102-2.403 1.796-3.801 4.097-3.403zm-5.097 9.5c-1.204-1-1.602-3.699.597-5c1.301-.398.5 5.403-.597 5zm4.597 5c-.699.403-2.3.204-3.398-1.398c-.801-1.398-.7-2.8-.102-3.2c.801-.5 2.102.2 3 1.302c.801.898 1.2 2.699.5 3.296zm-1.3-6.097c-1.2-.801-1.399-2.602-.5-4.102c1-1.398 2.703-2 3.902-1.199c1.199.8 1.398 2.602.5 4.102c-.903 1.5-2.7 2-3.903 1.199zM16 28.199c-1.5.102-2.898-1.199-2.898-1.597c0-.602 1.796-1.102 3-1.102c1.199-.102 2.796.398 2.796 1c0 .398-1.5 1.7-2.898 1.7zm3-6.398c0 1.5-1.3 2.699-2.898 2.699c-1.602 0-3-1.2-3-2.7c0-1.5 1.296-2.698 2.898-2.698c1.7 0 3 1.199 3 2.699zM17.2 18c-1-1.398-.7-3.3.5-4.102c1.198-.796 3-.296 3.902 1.204c.898 1.5.699 3.296-.5 4.097c-1.204.7-3 .2-3.903-1.199zm6 6c-1.302 1.8-3 1.8-3.598 1.3c-.704-.6-.204-2.6.796-3.698c1-1.204 2.204-2 2.903-1.403c.5.7.8 2.602-.102 3.801zm.902-3.7c-1.102.5-2-5.3-.602-5c2.2 1.2 1.8 4 .602 5z"></path></svg>`;
var dockerLogo = `<svg xmlns="http://www.w3.org/2000/svg" width="2em" height="2em" viewBox="0 0 32 32"><path fill="currentColor" d="M12 6v3H6v3H3v3h-.938a1 1 0 0 0-.78.406s-.087.106-.126.188c-.039.082-.066.207-.093.312a2.97 2.97 0 0 0-.094.813c0 .687.082 1.449.281 2.218A5.83 5.83 0 0 0 1 19h.281a9.42 9.42 0 0 0 .969 2.313c.012.019.02.042.031.062v.031c.059.242.203.453.406.594l.032.031c.168.235.336.465.531.688c1.637 1.883 4.277 3.312 8.031 3.312c5.766 0 10.758-2.375 13.75-7.031h5.063c-.633-.16-2.008-.39-1.782-1.219c-.699.809-1.992.98-3.062.844c.352-.582.68-1.195.969-1.844c1.656-.097 2.914-.656 3.625-1.343c.812-.786 1.062-1.688 1.062-1.688a1 1 0 0 0-.312-1.031s-1.512-1.059-3.688-.844c-.746-1.992-2.312-2.969-2.312-2.969a1.006 1.006 0 0 0-.688-.125a.987.987 0 0 0-.437.219s-.457.406-.813 1.063c-.355.656-.676 1.652-.562 2.906c.043.46.324.867.5 1.312c-.125.078-.242.168-.407.25a4.689 4.689 0 0 1-2.093.469H20v-3h-3V6zm2 2h1v1h-1zm-6 3h1v1H8zm3 0h1v1h-1zm3 0h1v1h-1zm10.344.313c.36.406.75.98.906 1.812a1.004 1.004 0 0 0 1.25.781c.906-.246 1.566-.168 2.031-.031c-.054.066-.02.055-.093.125c-.458.441-1.223.934-2.813.875a1.007 1.007 0 0 0-.969.625c-.449 1.113-.972 2.113-1.593 3c-1.477.574-4.762.152-5.032-.594c-.976 1.145-3.988 1.145-4.968 0c-.317.88-4.876 1.285-5.657.157c-.629.585-2.918.976-4.218.093A7.56 7.56 0 0 1 3.03 17h17.063a6.72 6.72 0 0 0 2.968-.688a6.794 6.794 0 0 0 1.219-.75a.983.983 0 0 0 .469-.671a.988.988 0 0 0-.188-.797c-.265-.348-.417-.774-.468-1.313c-.063-.703.097-1.11.25-1.469zM5 14h1v1H5zm3 0h1v1H8zm3 0h1v1h-1zm3 0h1v1h-1zm3 0h1v1h-1zM3.406 19h19.282c-2.633 3.406-6.614 5.031-11.407 5.031c-2.511 0-4.273-.676-5.531-1.656c2.125-.074 3.656-.625 3.656-.625a1.002 1.002 0 1 0-.5-1.938c-.054.016-.105.04-.156.063c0 0-2.191.719-4.781.406A7.067 7.067 0 0 1 3.406 19zm7.313.188a.601.601 0 0 0-.594.593c0 .32.273.594.594.594c.32 0 .562-.273.562-.594a.583.583 0 0 0-.031-.218a.253.253 0 0 1-.219.125c-.133 0-.219-.118-.219-.25c0-.09.024-.149.094-.188c-.066-.027-.113-.063-.187-.063z"/></svg>`;
var webLogo = `<svg xmlns="http://www.w3.org/2000/svg" width="2em" height="2em" viewBox="0 0 32 32"><path fill="currentColor" d="M5 5v22h22V5H5zm2 2h18v18H7V7zm13.244 8c-1.425 0-2.346.912-2.346 2.12c0 1.31.77 1.937 1.928 2.43l.4.173c.733.323 1.169.511 1.169 1.062c0 .465-.427.799-1.092.799c-.788 0-1.236-.418-1.578-.979l-1.31.75c.464.931 1.433 1.645 2.925 1.645c1.52 0 2.66-.788 2.66-2.232c0-1.35-.77-1.949-2.139-2.528l-.398-.172c-.693-.304-.988-.503-.988-.978c0-.39.294-.694.77-.694c.465 0 .758.2 1.034.694l1.256-.807c-.532-.93-1.265-1.283-2.29-1.283zm-5.85.096v5.463c0 .798-.342 1.005-.865 1.005c-.55 0-.788-.379-1.035-.826l-1.31.79c.38.807 1.129 1.472 2.412 1.472C15.02 23 16 22.24 16 20.576v-5.48h-1.605z"/></svg>`;

function ajaxGet(url,action) {
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == XMLHttpRequest.DONE) {   // XMLHttpRequest.DONE == 4
            if (xmlhttp.status == 200) {
                action(xmlhttp.responseText);
            }
            else if (xmlhttp.status == 400) {
                //console.log('There was an error 400');
            }
            else {
                //console.log('something else other than 200 was returned');
            }
        }
    };

    xmlhttp.open("GET", url, true);
    xmlhttp.send();
}

function ajaxPost(url,action,data) {
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == XMLHttpRequest.DONE) {   // XMLHttpRequest.DONE == 4
            if (xmlhttp.status == 200) {
                action(xmlhttp.responseText);
            }
            else if (xmlhttp.status == 400) {
                //console.log('There was an error 400');
            }
            else {
                //console.log('something else other than 200 was returned');
            }
        }
    };

    xmlhttp.open("POST", url, true);
	xmlhttp.setRequestHeader('Content-Type', 'application/json');
    xmlhttp.send(JSON.stringify(data));
}
document.addEventListener('DOMContentLoaded', () => {
	const clipboard = new Clipboard('.copy', {
		target: (trigger) => {
		  return trigger.nextElementSibling;
		}
	  });
	  
	  //
	  // do stuff when copy is clicked
	  clipboard.on('success', (event) => {
		event.trigger.textContent = 'copied!';
		setTimeout(() => {
		  event.clearSelection();
		  event.trigger.textContent = 'copy';
		}, 2000);
	  });

	const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
	if ($navbarBurgers.length > 0) {
		$navbarBurgers.forEach( el => {
			el.addEventListener('click', () => {
				const target = el.dataset.target;
				const $target = document.getElementById(target);
				el.classList.toggle('is-active');
				$target.classList.toggle('is-active');
			});
		});
	}

    var element =  document.getElementById('stargazers');
    if (typeof(element) != 'undefined' && element != null)
    {
        function setDiv(div,content){
            document.getElementById(div).innerHTML = content;
        }

        function setClass(cl,content){
            var elems=document.getElementsByClassName(cl);
            for(var i = 0; i < elems.length; i++){
                elems[i].innerHTML = content;
            }
        }

		function hideTableElement(div){
			document.getElementById(div).style.display = 'none';
		}

		function showTableElement(div){
			document.getElementById(div).style.display = 'table';
		}

		// capture click events on checkbox
		document.getElementById('version-switch').addEventListener('click', function() {
			if (this.checked) {
				this.checked = true;
				hideTableElement('downloadstable-mini');
				showTableElement('downloadstable-full');
			} else {
				this.checked = false;
				hideTableElement('downloadstable-full');
				showTableElement('downloadstable-mini');
			}
		});

        ajaxGet("https://api.github.com/search/repositories?q=arturo-lang/arturo", function (data){
            var parsed = JSON.parse(data);
            setDiv("stargazers",parsed.items[0].stargazers_count);
        });

        ajaxGet("https://api.github.com/repos/arturo-lang/arturo/releases", function (data){
            var parsed = JSON.parse(data);
            /*console.log(parsed);*/
            var releaseVersion = parsed[0].tag_name;
            setClass("release-version", parsed[0].tag_name);
            setClass("release-version-mini", `${parsed[0].tag_name}<sup>*</sup>`);
            setDiv("release-date", parsed[0].published_at);
			/*
            ajaxGet(parsed[0].assets_url, function (data){
                var parsed = JSON.parse(data);
                var downloadsTable = `<tr><th></th><th></th><th class="is-hidden-touch has-text-centered">Version</th><th class="is-hidden-touch has-text-centered">Compressed file size</th><th></th></tr>`;
                var downloadItems = [];
                for (var i = 0; i < parsed.length; i++){
                    var elem = parsed[i];
                    var logo = "";
                    var os = "";
                    var order = "";
                    var version = releaseVersion;
                    if (elem.name.includes("Linux")) { order = 1; logo = linuxLogo; os = "<b>Linux</b>"; }
                    else if (elem.name.includes("macOS")) { order = 2; logo = macosLogo; os = "<b>macOS</b>"; }
                    else if (elem.name.includes("Windows")) { order = 3; logo = windowsLogo; os = "<b>Windows</b>"; }
                    else if (elem.name.includes("FreeBSD")) { order = 4; logo = bsdLogo; os = "<b>FreeBSD</b>"; }
                    else if (elem.name.includes("arm-")) { order = 5; logo = raspberryLogo; os = "<b>arm</b>"; }
                    else if (elem.name.includes("arm64-")) { order = 6; logo = raspberryLogo; os = "<b>arm64</b>"; }
					else if (elem.name.includes("Web")) { order = 7; logo = webLogo; os = "<b>Web</b>"; }
                    if (elem.name.includes("mini")) { 
						version += "<sup>*</sup>"; 
						os += "<sup class='is-hidden-desktop'>*</sup>";
					}
                    var size = ((elem.size)/(1024*1024)).toFixed(2) + " MB";
                    var link = elem.browser_download_url;

                    downloadItems.push(`<tr><td order="${order}" class="first-td">${logo}</td><td>${os}</td><td class="is-hidden-touch has-text-centered">${version}</td><td class="is-hidden-touch has-text-centered">${size}</td><td><a href="${link}"><i class="far fa-arrow-alt-circle-down"></i>&nbsp;&nbsp;Download</a></td></tr>`);
                }
                downloadItems.sort();
                downloadsTable += downloadItems.join("");
                downloadsTable += `<tr><td class="first-td">${dockerLogo}</td><td><b>Docker</b></td><td class="release-version is-hidden-touch has-text-centered">${releaseVersion}</td><td class="is-hidden-touch has-text-centered">--</td><td><a rel="noopener" target="_blank" href="https://hub.docker.com/repository/docker/arturolang/arturo"><i class="far fa-arrow-alt-circle-right"></i>&nbsp;&nbsp;Docker Hub</a></td></tr>`
                setDiv("downloads",downloadsTable);
                
            });*/
        })
    }
});