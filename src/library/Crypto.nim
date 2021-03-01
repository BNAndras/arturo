######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2021 Yanis Zafirópulos
#
# @file: library/Crypto.nim
######################################################

#=======================================
# Pragmas
#=======================================

{.used.}

#=======================================
# Libraries
#=======================================

import base64, md5, std/sha1, uri

import vm/[common, globals, stack, value]

#=======================================
# Methods
#=======================================

proc defineSymbols*() =

    when defined(VERBOSE):
        echo "- Importing: Crypto"

    builtin "decode",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "base-64 encode given value",
        args        = {
            "value" : {String,Literal}
        },
        attrs       = {
            "url"   : ({Boolean},"decode URL based on RFC3986")
        },
        returns     = {String,Nothing},
        example     = """
            print decode "TnVtcXVhbSBmdWdpZW5zIHJlc3BleGVyaXM="
            ; Numquam fugiens respexeris

            print decode.url "http%3A%2F%2Ffoo+bar%2F"
            ; http://foo bar/
        """:
            ##########################################################
            if (popAttr("url")!=VNULL):
                if x.kind==Literal:
                    InPlace.s = InPlaced.s.decodeUrl()
                else:
                    stack.push(newString(x.s.decodeUrl()))
            else:
                if x.kind==Literal:
                    InPlace.s = InPlaced.s.decode()
                else:
                    stack.push(newString(x.s.decode()))

    builtin "encode",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "base-64 decode given value",
        args        = {
            "value" : {String,Literal}
        },
        attrs       = {
            "url"   : ({Boolean},"encode URL based on RFC3986")
        },
        returns     = {String,Nothing},
        example     = """
            print encode "Numquam fugiens respexeris"
            ; TnVtcXVhbSBmdWdpZW5zIHJlc3BleGVyaXM=

            print encode.url "http://foo bar/"
            ; http%3A%2F%2Ffoo+bar%2F
        """:
            ##########################################################
            if (popAttr("url")!=VNULL):
                if x.kind==Literal:
                    InPlace.s = InPlaced.s.encodeUrl()
                else:
                    stack.push(newString(x.s.encodeUrl()))
            else:
                if x.kind==Literal:
                    InPlace.s = InPlaced.s.encode()
                else:
                    stack.push(newString(x.s.encode()))

    builtin "digest",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "get digest for given value (default: MD5)",
        args        = {
            "value" : {String,Literal}
        },
        attrs       = {
            "sha"   : ({Boolean},"use SHA1")
        },
        returns     = {String,Nothing},
        example     = """
            print digest "Hello world"
            ; 3e25960a79dbc69b674cd4ec67a72c62
            
            print digest.sha "Hello world"
            ; 7b502c3a1f48c8609ae212cdfb639dee39673f5e
        """:
            ##########################################################
            if (popAttr("sha") != VNULL):
                if x.kind==Literal:
                    SetInPlace(newString(($(secureHash(InPlace.s))).toLowerAscii()))
                else:
                    stack.push(newString(($(secureHash(x.s))).toLowerAscii()))
            else:
                if x.kind==Literal:
                    SetInPlace(newString(($(toMD5(InPlace.s))).toLowerAscii()))
                else:
                    stack.push(newString(($(toMD5(x.s))).toLowerAscii()))

    builtin "hash",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "get hash for given value",
        args        = {
            "value" : {Any}
        },
        attrs       = {
            "string": ({Boolean},"get as a string")
        },
        returns     = {Integer,String},
        example     = """
            print hash "hello"      ; 613153351
            print hash [1 2 3]      ; 645676735036410
            print hash 123          ; 123

            a: [1 2 3]
            b: [1 2 3]
            print (hash a)=(hash b) ; true
        """:
            ##########################################################
            if (popAttr("string") != VNULL):
                stack.push(newString($(hash(x))))
            else:
                stack.push(newInteger(hash(x)))

#=======================================
# Add Library
#=======================================

Libraries.add(defineSymbols)