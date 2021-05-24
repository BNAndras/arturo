######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2021 Yanis Zafirópulos
#
# @file: library/Converters.nim
######################################################

#=======================================
# Pragmas
#=======================================

{.used.}

#=======================================
# Libraries
#=======================================

import algorithm, sequtils, strformat, sugar, times, unicode
when not defined(NOGMP):
    import extras/bignum

import helpers/arrays
import helpers/colors
import helpers/datasource
when not defined(NOASCIIDECODE):
    import helpers/strings

import vm/lib
import vm/[errors, exec, parse]

#=======================================
# Helpers
#=======================================

proc convertedValueToType*(x, y: Value, tp: ValueKind): Value =
    if y.kind == tp and y.kind!=Dictionary:
        return y
    else:
        case y.kind:
            of Null:
                case tp:
                    of Boolean: return VFALSE
                    of Integer: return I0
                    of String: return newString("null")
                    else: RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of Boolean:
                case tp:
                    of Integer:
                        if y.b: return I1
                        else: return I0
                    of Floating:
                        if y.b: return F1
                        else: return F0
                    of String:
                        if y.b: return newString("true")
                        else: return newString("false")
                    else: RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of Integer:
                case tp:
                    of Boolean: return newBoolean(y.i!=0)
                    of Floating: return newFloating((float)y.i)
                    of Char: return newChar(chr(y.i))
                    of String: 
                        if y.iKind==NormalInteger: 
                            if (let aFormat = popAttr("format"); aFormat != VNULL):
                                try:
                                    var ret = ""
                                    formatValue(ret, y.i, aFormat.s)
                                    return newString(ret)
                                except:
                                    RuntimeError_ConversionFailed(codify(y), $(y.kind), $(x.t))
                            else:
                                return newString($(y.i))
                        else:
                            when not defined(NOGMP): 
                                return newString($(y.bi))
                    of Date:
                        return newDate(local(fromUnix(y.i)))
                    of Binary:
                        let str = $(y.i)
                        var ret: ByteArray = newSeq[byte](str.len)
                        for i,ch in str:
                            ret[i] = (byte)(ord(ch))
                        return newBinary(ret)
                    else: RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of Floating:
                case tp:
                    of Boolean: return newBoolean(y.f!=0.0)
                    of Integer: return newInteger((int)y.f)
                    of Char: return newChar(chr((int)y.f))
                    of String: 
                        if (let aFormat = popAttr("format"); aFormat != VNULL):
                            try:
                                var ret = ""
                                formatValue(ret, y.f, aFormat.s)
                                return newString(ret)
                            except:
                                RuntimeError_ConversionFailed(codify(y), $(y.kind), $(x.t))
                        else:
                            return newString($(y.f))
                    of Binary:
                        let str = $(y.f)
                        var ret: ByteArray = newSeq[byte](str.len)
                        for i,ch in str:
                            ret[i] = (byte)(ord(ch))
                        return newBinary(ret)
                    else: RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of Version:
                if tp==String: return newString($(y))
                else: RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of Type:
                if tp==String: return newString(($(y.t)).toLowerAscii())
                else: RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of Char:
                case tp:
                    of Integer: return newInteger(ord(y.c))
                    of Floating: return newFloating((float)ord(y.c))
                    of String: return newString($(y.c))
                    of Binary: return newBinary(@[(byte)(ord(y.c))])
                    else: RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of String:
                case tp:
                    of Boolean: 
                        if y.s=="true": return VTRUE
                        elif y.s=="false": return VFALSE
                        else: RuntimeError_ConversionFailed(codify(y), $(y.kind), $(x.t))
                    of Integer:
                        try:
                            return newInteger(y.s)
                        except ValueError:
                            RuntimeError_ConversionFailed(codify(y), $(y.kind), $(x.t))
                    of Floating:
                        try:
                            return newFloating(parseFloat(y.s))
                        except ValueError:
                            RuntimeError_ConversionFailed(codify(y), $(y.kind), $(x.t))
                    of Version:
                        try:
                            return newVersion(y.s)
                        except ValueError:
                            RuntimeError_ConversionFailed(codify(y), $(y.kind), $(x.t))
                    of Type:
                        try:
                            return newType(y.s)
                        except ValueError:
                            RuntimeError_ConversionFailed(codify(y), $(y.kind), $(x.t))
                    of Char:
                        if y.s.runeLen() == 1:
                            return newChar(y.s)
                        else:
                            RuntimeError_ConversionFailed(codify(y), $(y.kind), $(x.t))
                    of Word:
                        return newWord(y.s)
                    of Literal:
                        return newLiteral(y.s)
                    of Label:
                        return newLabel(y.s)
                    of Attribute:
                        return newAttribute(y.s)
                    of AttributeLabel:
                        return newAttributeLabel(y.s)
                    of Symbol:
                        try:
                            return newSymbol(y.s)
                        except ValueError:
                            RuntimeError_ConversionFailed(codify(y), $(y.kind), $(x.t))
                    of Binary:
                        var ret: ByteArray = newSeq[byte](y.s.len)
                        for i,ch in y.s:
                            ret[i] = (byte)(ord(ch))
                        return newBinary(ret)
                    of Block:
                        return doParse(y.s, isFile=false)
                    of Color:
                        try:
                            return newColor(y.s)
                        except:
                            RuntimeError_ConversionFailed(codify(y), $(y.kind), $(x.t))
                    of Date:
                        var dateFormat = "yyyy-MM-dd'T'HH:mm:sszzz"
                        if (let aFormat = popAttr("format"); aFormat != VNULL):
                            dateFormat = aFormat.s
                        
                        let timeFormat = initTimeFormat(dateFormat)
                        try:
                            return newDate(parse(y.s, timeFormat))
                        except:
                            RuntimeError_ConversionFailed(codify(y), $(y.kind), $(x.t))
                    else:
                        RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of Literal, 
               Word,
               Label:
                case tp:
                    of String: 
                        return newString(y.s)
                    of Literal:
                        return newLiteral(y.s)
                    of Word:
                        return newWord(y.s)
                    else:
                        RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of Attribute,
               AttributeLabel:
                case tp:
                    of String: 
                        return newString(y.r)
                    of Literal:
                        return newLiteral(y.r)
                    of Word:
                        return newWord(y.r)
                    else:
                        RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of Inline:
                case tp:
                    of Block:
                        return newBlock(cleanBlock(y.a))
                    else:
                        RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of Block:
                case tp:
                    of Complex:
                        let blk = cleanBlock(y.a)
                        return newComplex(blk[0], blk[1])
                    of Inline:
                        let blk = cleanBlock(y.a)
                        return newInline(blk)
                    of Dictionary:
                        if x.tpKind==BuiltinType:
                            let stop = SP
                            discard execBlock(y)

                            let arr: ValueArray = sTopsFrom(stop)
                            var dict: ValueDict = initOrderedTable[string,Value]()
                            SP = stop

                            var i = 0
                            while i<arr.len:
                                if i+1<arr.len:
                                    dict[$(arr[i])] = arr[i+1]
                                i += 2

                            return(newDictionary(dict))
                        else:
                            let stop = SP
                            discard execBlock(y)

                            let arr: ValueArray = sTopsFrom(stop)
                            var dict = initOrderedTable[string,Value]()
                            SP = stop

                            var i = 0
                            while i<arr.len and i<x.prototype.a.len:
                                let k = x.prototype.a[i]
                                dict[k.s] = arr[i]
                                i += 1

                            var res = newDictionary(dict)
                            res.custom = x

                            if x.methods.d.hasKey("init"):
                                push res
                                callFunction(x.methods.d["init"])

                            return(res)

                    of Color:
                        let blk = cleanBlock(y.a)
                        if (popAttr("hsl") != VNULL):
                            return newColor(HSLtoRGB((blk[0].i, blk[1].f, blk[2].f)))
                        else:
                            return newColor((blk[0].i, blk[1].i, blk[2].i))

                    of Bytecode:
                        let blk = cleanBlock(y.a)
                        return(newBytecode(blk[0].a, blk[1].a.map(proc (x:Value):byte = (byte)(x.i))))
                    else:
                        discard

            of Dictionary:
                case tp:
                    of Dictionary:
                        if x.tpKind==BuiltinType:
                            return(y)
                        else:
                            var dict = initOrderedTable[string,Value]()

                            for k,v in pairs(y.d):
                                for item in x.prototype.a:
                                    if item.s == k:
                                        dict[k] = v

                            var res = newDictionary(dict)
                            res.custom = x
                            return(res)
                    else:
                        RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of Symbol:
                case tp:
                    of String:
                        return newString($(y))
                    of Literal:
                        return newLiteral($(y))
                    else:
                        RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of Date:
                case tp:
                    of Integer:
                        return newInteger(toUnix(toTime(y.eobj)))
                    of String:
                        var dateFormat = "yyyy-MM-dd'T'HH:mm:sszzz"
                        if (let aFormat = popAttr("format"); aFormat != VNULL):
                            dateFormat = aFormat.s
                        
                        try:
                            return newString(format(y.eobj, dateFormat))
                        except:
                            RuntimeError_ConversionFailed(codify(y), $(y.kind), $(x.t))
                    else: 
                        RuntimeError_CannotConvert(codify(y), $(y.kind), $(x.t))

            of Complex,
               Function,
               Color,
               Database,
               Newline,
               Nothing,
               Any,
               Path,
               PathLabel,
               Bytecode,
               Binary: discard

#=======================================
# Methods
#=======================================

proc defineSymbols*() =

    when defined(VERBOSE):
        echo "- Importing: Converters"

    builtin "array",
        alias       = at, 
        rule        = PrefixPrecedence,
        description = "create array from given block, by reducing/calculating all internal values",
        args        = {
            "source": {Any}
        },
        attrs       = {
            "of"    : ({Integer,Block},"initialize an empty n-dimensional array with given dimensions")
        },
        returns     = {Block},
        example     = """
            none: @[]               ; none: []
            a: @[1 2 3]             ; a: [1 2 3]
            
            b: 5
            c: @[b b+1 b+2]         ; c: [5 6 7]
            
            d: @[
                3+1
                print "we are in the block"
                123
                print "yep"
            ]
            ; we are in the block
            ; yep
            ; => [4 123]
            ;;;;
            ; initializing empty array with initial value
            x: array.of: 2 "done"
            inspect.muted x
            ; [ :block
            ;     done :string
            ;     done :string
            ; ]
            ;;;;
            ; initializing empty n-dimensional array with initial value
            x: array.of: [3 4] 0          ; initialize a 3x4 2D array
                                            ; with zeros
            ; => [[0 0 0 0] [0 0 0 0] [0 0 0 0]]
        """:
            ##########################################################
            if (let aOf = popAttr("of"); aOf != VNULL):
                if aOf.kind == Integer:
                    let size = aOf.i
                    let blk:ValueArray = safeRepeat(x, size)
                    push newBlock(blk)
                else:
                    var val: Value = copyValue(x)
                    var blk: ValueArray = @[]

                    for item in aOf.a.reversed:
                        blk = safeRepeat(val, item.i)
                        val = newBlock(blk.map((v)=>copyValue(v)))

                    push newBlock(blk)
            else:
                let stop = SP

                if x.kind==Block:
                    discard execBlock(x)
                elif x.kind==String:
                    let (_{.inject.}, tp) = getSource(x.s)

                    if tp!=TextData:
                        discard execBlock(doParse(x.s, isFile=false))#, isIsolated=true)
                    else:
                        echo "file does not exist"

                let arr: ValueArray = sTopsFrom(stop)
                SP = stop

                push(newBlock(arr))

    builtin "as",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "format given value as implied type",
        args        = {
            "value" : {Any}
        },
        attrs       = 
        when not defined(NOASCIIDECODE):
            {
                "binary"    : ({Boolean},"format integer as binary"),
                "hex"       : ({Boolean},"format integer as hexadecimal"),
                "octal"     : ({Boolean},"format integer as octal"),
                "ascii"     : ({Boolean},"transliterate string to ASCII"),
                "agnostic"  : ({Boolean},"convert words in block to literals, if not in context"),
                "code"      : ({Boolean},"convert value to valid Arturo code"),
                "pretty"    : ({Boolean},"prettify generated code"),
                "unwrapped" : ({Boolean},"omit external block notation")
            }
        else:
            {
                "binary"    : ({Boolean},"format integer as binary"),
                "hex"       : ({Boolean},"format integer as hexadecimal"),
                "octal"     : ({Boolean},"format integer as octal"),
                "agnostic"  : ({Boolean},"convert words in block to literals, if not in context"),
                "code"      : ({Boolean},"convert value to valid Arturo code"),
                "pretty"    : ({Boolean},"prettify generated code"),
                "unwrapped" : ({Boolean},"omit external block notation")
            }
        ,
        returns     = {Any},
        example     = """
            print as.binary 123           ; 1111011
            print as.octal 123            ; 173
            print as.hex 123              ; 7b
            ;;;;
            print as.ascii "thís ìß ñot à tést"
            ; this iss not a test
        """:
            ##########################################################
            if (popAttr("binary") != VNULL):
                push(newString(fmt"{x.i:b}"))
            elif (popAttr("hex") != VNULL):
                push(newString(fmt"{x.i:x}"))
            elif (popAttr("octal") != VNULL):
                push(newString(fmt"{x.i:o}"))
            elif (popAttr("agnostic") != VNULL):
                let res = cleanBlock(x.a).map(proc(v:Value):Value =
                    if v.kind == Word and not SymExists(v.s): newLiteral(v.s)
                    else: v
                )
                push(newBlock(res))
            elif (popAttr("code") != VNULL):
                push(newString(codify(x,pretty = (popAttr("pretty") != VNULL), unwrapped = (popAttr("unwrapped") != VNULL), safeStrings = (popAttr("safe") != VNULL))))
            else:
                when not defined(NOASCIIDECODE):
                    if (popAttr("ascii") != VNULL):
                        push(newString(convertToAscii(x.s)))
                    else:
                        push(x)
                else:
                    push(x)

    builtin "define",
        alias       = dollar, 
        rule        = PrefixPrecedence,
        description = "define new type with given characteristics",
        args        = {
            "type"      : {Type},
            "prototype" : {Block},
            "methods"   : {Block}
        },
        attrs       = NoAttrs,
        returns     = {Nothing},
        example     = """
            define :person [name surname age][  

                ; magic method to be executed
                ; after a new object has been created
                init: [
                    this\name: capitalize this\name
                ]

                ; magic method to be executed
                ; when the object is about to be printed
                print: [
                    render "NAME: |this\name|, SURNAME: |this\surname|, AGE: |this\age|"
                ]

                ; magic method to be used
                ; when comparing objects (e.g. when sorting)
                compare: [
                    if this\age = that\age -> return 0
                    if this\age < that\age -> return neg 1
                    if this\age > that\age -> return 1
                ]
            ]

            sayHello: function [this][
                ensure -> is? :person this
                print ["Hello" this\name]
            ]

            a: to :person ["John" "Doe" 35]
            b: to :person ["jane" "Doe" 33]

            print a
            ; NAME: John, SURNAME: Doe, AGE: 35
            print b
            ; NAME: Jane, SURNAME: Doe, AGE: 33

            sayHello a
            ; Hello John 

            a > b 
            ; => true (a\age > b\age)

            print join.with:"\n" sort @[a b]
            ; NAME: Jane, SURNAME: Doe, AGE: 33
            ; NAME: John, SURNAME: Doe, AGE: 35

            print join.with:"\n" sort.descending @[a b]
            ; NAME: John, SURNAME: Doe, AGE: 35
            ; NAME: Jane, SURNAME: Doe, AGE: 33
        """:
            ##########################################################
            x.prototype = y
            x.methods = newDictionary(execBlock(z,dictionary=true))
            if x.methods.d.hasKey("init"):
                x.methods.d["init"] = newFunction(
                    newBlock(@[newWord("this")]),
                    x.methods.d["init"] 
                )
            if x.methods.d.hasKey("print"):
                x.methods.d["print"] = newFunction(
                    newBlock(@[newWord("this")]),
                    x.methods.d["print"] 
                )

            if x.methods.d.hasKey("compare"):
                if x.methods.d["compare"].kind==Block:
                    x.methods.d["compare"] = newFunction(
                        newBlock(@[newWord("this"),newWord("that")]),
                        x.methods.d["compare"] 
                    )
                else:
                    let key = x.methods.d["compare"]
                    x.methods.d["compare"] = newFunction(
                        newBlock(@[newWord("this"),newWord("that")]),
                        newBlock(@[
                            newWord("if"), newPath(@[newWord("this"), key]), newSymbol(greaterthan), newPath(@[newWord("that"), key]), newBlock(@[newWord("return"),newInteger(1)]),
                            newWord("if"), newPath(@[newWord("this"), key]), newSymbol(equal), newPath(@[newWord("that"), key]), newBlock(@[newWord("return"),newInteger(0)]),
                            newWord("return"), newWord("neg"), newInteger(1)
                        ])
                    )
            # let methods = execBlock(z,dictionary=true)
            # for k,v in pairs(methods):
            #     # add a `this` first parameter
            #     v.params.a.insert(newWord("this"),0)
            #     # add as first command in block: 
            #     # ensure [:TYPE = type this]
            #     v.main.a.insert(newWord("ensure"),0)
            #     v.main.a.insert(newBlock(@[
            #         newUserType(x.name),
            #         newSymbol(equal),
            #         newWord("type"),
            #         newWord("this")
            #     ]),1)
            #     SetSym(k, v)
            #     Arities[k] = v.params.a.len

    builtin "dictionary",
        alias       = sharp, 
        rule        = PrefixPrecedence,
        description = "create dictionary from given block or file, by getting all internal symbols",
        args        = {
            "source": {String,Block}
        },
        attrs       = {
            "with"  : ({Block},"embed given symbols"),
            "raw"   : ({Boolean},"create dictionary from raw block"),
            "data"  : ({Boolean},"parse input as data")
        },
        returns     = {Dictionary},
        example     = """
            none: #[]               ; none: []
            a: #[
                name: "John"
                age: 34
            ]             
            ; a: [name: "John", age: 34]
            
            d: #[
                name: "John"
                print "we are in the block"
                age: 34
                print "yep"
            ]
            ; we are in the block
            ; yep
            ; => [name: "John", age: 34]
        """:
            ##########################################################
            var dict: ValueDict

            if (popAttr("data") != VNULL):
                if x.kind==Block:
                    push(parseData(x))
                elif x.kind==String:
                    let (src, tp) = getSource(x.s)

                    if tp!=TextData:
                        dict = parseData(doParse(src, isFile=false)).d
                    else:
                        echo "file does not exist"

                    push(newDictionary(dict))
            else:
                if x.kind==Block:
                    #dict = execDictionary(x)
                    if (popAttr("raw") != VNULL):
                        dict = initOrderedTable[string,Value]()
                        var idx = 0
                        let blk = cleanBlock(x.a)
                        while idx < blk.len:
                            dict[blk[idx].s] = blk[idx+1]
                            idx += 2
                    else:
                        dict = execBlock(x,dictionary=true)
                elif x.kind==String:
                    let (src, tp) = getSource(x.s)

                    if tp!=TextData:
                        dict = execBlock(doParse(src, isFile=false), dictionary=true)#, isIsolated=true)
                    else:
                        echo "file does not exist"

                if (let aWith = popAttr("with"); aWith != VNULL):
                    for x in aWith.a:
                        dict[x.s] = GetSym(x.s)
                        
                push(newDictionary(dict))

    builtin "from",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "get value from string, using given representation",
        args        = {
            "value" : {String}
        },
        attrs       = {
            "binary"    : ({Boolean},"get integer from binary representation"),
            "hex"       : ({Boolean},"get integer from hexadecimal representation"),
            "octal"     : ({Boolean},"get integer from octal representation")
        },
        returns     = {Any},
        example     = """
            print from.binary "1011"        ; 11
            print from.octal "1011"         ; 521
            print from.hex "0xDEADBEEF"     ; 3735928559
        """:
            ##########################################################
            if (popAttr("binary") != VNULL):
                try:
                    push(newInteger(parseBinInt(x.s)))
                except ValueError:
                    push(VNULL)
            elif (popAttr("hex") != VNULL):
                try:
                    push(newInteger(parseHexInt(x.s)))
                except ValueError:
                    push(VNULL)
            elif (popAttr("octal") != VNULL):
                try:
                    push(newInteger(parseOctInt(x.s)))
                except ValueError:
                    push(VNULL)
            else:
                push(x)

    builtin "function",
        alias       = dollar, 
        rule        = PrefixPrecedence,
        description = "create function with given arguments and body",
        args        = {
            "arguments" : {Block},
            "body"      : {Block}
        },
        attrs       = {
            "import"    : ({Block},"import/embed given list of symbols from current environment"),
            "export"    : ({Block},"export given symbols to parent"),
            "exportable": ({Boolean},"export all symbols to parent"),
            "memoize"   : ({Boolean},"store results of function calls")
        },
        returns     = {Function},
        example     = """
            f: function [x][ x + 2 ]
            print f 10                ; 12
            
            f: $[x][x+2]
            print f 10                ; 12
            ;;;;
            multiply: function [x,y][
                x * y
            ]
            print multiply 3 5        ; 15
            ;;;;
            publicF: function .export['x] [z][
                print ["z =>" z]
                x: 5
            ]
            
            publicF 10
            ; z => 10
            
            print x
            ; 5
            ;;;;
            ; memoization
            fib: $[x].memoize[
                if? x<2 [1]
                else [(fib x-1) + (fib x-2)]
            ]

            loop 1..25 [x][
                print ["Fibonacci of" x "=" fib x]
            ]
        """:
            ##########################################################
            var imports = VNULL
            if (let aImport = popAttr("import"); aImport != VNULL):
                var ret = initOrderedTable[string,Value]()
                for item in aImport.a:
                    ret[item.s] = GetSym(item.s)
                imports = newDictionary(ret)

            var exportable = (popAttr("exportable")!=VNULL)

            var exports = VNULL
            if (let aExport = popAttr("export"); aExport != VNULL):
                exports = aExport

            var memoize = (popAttr("memoize")!=VNULL)

            push(newFunction(x,y,imports,exports,exportable,memoize))

    builtin "to",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "convert value to given type",
        args        = {
            "type"  : {Type,Block},
            "value" : {Any}
        },
        attrs       = {
            "format": ({String},"use given format (for dates)"),
            "hsl"   : ({Boolean},"convert HSL block to color")
        },
        returns     = {Any},
        example     = """
            to :integer "2020"            ; 2020
            
            to :integer `A`               ; 65
            to :char 65                   ; `A`
            
            to :integer 4.3               ; 4
            to :floating 4                ; 4.0

            to :complex [1 2]             ; 1.0+2.0i
            to :complex @[2.3 neg 4.5]    ; 2.3-4.5i
            
            to :boolean 0                 ; false
            to :boolean 1                 ; true
            to :boolean "true"            ; true

            to :literal "symbol"          ; 'symbol
            ;;;;
            to :string 2020               ; "2020"
            to :string 'symbol            ; "symbol"
            to :string :word              ; "word"
        
            to :string .format:"dd/MM/yy" now
            ; 22/03/21

            to :string .format:".2f" 123.12345
            ; 123.12
            ;;;;
            to :block "one two three"       ; [one two three]

            do to :block "print 123"        ; 123
            ;;;;
            to :date 0          ; => 1970-01-01T01:00:00+01:00

            print now           ; 2021-05-22T07:39:10+02:00
            to :integer now     ; => 1621661950

            to :date .format:"dd/MM/yyyy" "22/03/2021"
            ; 2021-03-22T00:00:00+01:00
            ;;;;
            to [:string] [1 2 3 4]         
            ; ["1" "2" "3" "4"]

            to [:char] "hello"
            ; [`h` `e` `l` `l` `o`]
            ;;;;
            define :person [name surname age][]

            to :person ["John" "Doe" 35]
            ; [name:John surname:Doe age:35]
            ;;;;
            to :color [255 0 10]
            ; => #FF000A

            to :color .hsl [255 0.2 0.4]
            ; => #5C527A
        """:
            ##########################################################
            if x.kind==Type:
                let tp = x.t
                push convertedValueToType(x, y, tp)
            else:
                var ret: ValueArray = @[]
                let blk = cleanBlock(x.a)
                let tp = blk[0].t
                    
                if y.kind==String:
                    ret = toSeq(runes(y.s)).map((c) => newChar(c))
                else:
                    for item in cleanBlock(y.a):
                        ret.add(convertedValueToType(blk[0], item, tp))

                push newBlock(ret)
            

    builtin "with",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "create closure-style block by embedding given words",
        args        = {
            "embed" : {Literal, Block},
            "body"  : {Block}
        },
        attrs       = NoAttrs,
        returns     = {Block},
        example     = """
            f: function [x][ 
                with [x][ 
                    "the multiple of" x "is" 2*x 
                ] 
            ]

            multiplier: f 10

            print multiplier
            ; the multiple of 10 is 20 
        """:
            ##########################################################
            var blk: ValueArray = cleanBlock(y.a)
            if x.kind == Literal:
                blk.insert(GetSym(x.s))
                blk.insert(newLabel(x.s))
            else:
                for item in cleanBlock(x.a):
                    blk.insert(GetSym(item.s))
                    blk.insert(newLabel(item.s))

            push(newBlock(blk))

#=======================================
# Add Library
#=======================================

Libraries.add(defineSymbols)