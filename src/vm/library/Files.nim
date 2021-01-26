######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2020 Yanis Zafirópulos
#
# @file: library/Files.nim
######################################################

#=======================================
# Libraries
#=======================================

import os, strtabs, tables

import vm/stack, vm/value

#=======================================
# Methods
#=======================================

builtin "exists?",
    alias       = none, 
    description = "check if given file exists",
    args        = {
        "file"  : {String}
    },
    attrs       = {
        "dir"   : ({Boolean},"check for directory")
    },
    returns     = {Boolean},
    example     = """
        if exists? "somefile.txt" [ 
            print "file exists!" 
        ]
    """:
        ##########################################################
        if (popAttr("dir") != VNULL): 
            stack.push(newBoolean(dirExists(x.s)))
        else: 
            stack.push(newBoolean(fileExists(x.s)))

# template IsExists*():untyped =
#     # EXAMPLE:
#     # if exists? "somefile.txt" [ 
#     # ____print "file exists!" 
#     # ]

#     require(opExists)

#     if (popAttr("dir") != VNULL): stack.push(newBoolean(dirExists(x.s)))
#     else: stack.push(newBoolean(fileExists(x.s)))

        # opRead      : OpSpec(   name    : "read",    
        #                         alias   : "<<",  
        #                         args    : 1,   

        #                         an      : "file",        
        #                         a       : {String},                      
        #                         ret     : {String,Block,Binary},                
        #                         attrs   :   ".lines -> read file lines into block~" &
        #                                     ".json -> read json file into a valid value~" &
        #                                     ".csv -> read CSV file into a block of rows~" &
        #                                     ".withHeaders -> read CSV headers~"&
        #                                     ".html* -> read html file into node dictionary~" &
        #                                     ".markdown* -> read markdown and convert to html~" &
        #                                     ".binary -> read as binary", 
        #                         desc    : "read file from given path", ),

        # opWrite     : OpSpec(   name    : "write",  
        #                         alias   : ">>",      
        #                         args    : 2,   

        #                         an      : "file",        
        #                         a       : {String,Null},                   
        #                         bn      : "content",     
        #                         b       : {Any},      
        #                         ret     : {Null},      
        #                         attrs   :   ".directory -> create directory at path~" &
        #                                     ".json -> write value as json~" &
        #                                     ".binary -> write as binary",
        #                         desc    : "write content to file at given path"),


builtin "read",
    alias       = doublearrowleft, 
    description = "read file from given path",
    args        = {
        "file"  : {String}
    },
    attrs       = {
        "lines"         : ({Boolean},"read file lines into block"),
        "json"          : ({Boolean},"read CSV file into a block of rows"),
        "withHeaders"   : ({Boolean},"read CSV headers"),
        "html"          : ({Boolean},"read HTML file into node dictionary"),
        "markdown"      : ({Boolean},"read Markdown and convert to HTML"),
        "binary"        : ({Boolean},"read as binary")
    },
    returns     = {String,Block,Binary},
    example     = """
        ; reading a simple local file
        str: read "somefile.txt"

        ; also works with remote urls
        page: read "http://www.somewebsite.com/page.html"

        ; we can also "read" JSON data as an object
        data: read.json "mydata.json"

        ; or even convert Markdown to HTML on-the-fly
        html: read.markdown "## Hello" ____; "<h2>Hello</h2>"
    """:
        ##########################################################
        if (popAttr("binary") != VNULL):
            var f: File
            discard f.open(x.s)
            var b: seq[byte] = newSeq[byte](f.getFileSize())
            discard f.readBytes(b, 0, f.getFileSize())

            f.close()

            stack.push(newBinary(b))
        else:
            let (src, _{.inject.}) = getSource(x.s)

            if (popAttr("lines") != VNULL):
                stack.push(newStringBlock(src.splitLines()))
            elif (popAttr("json") != VNULL):
                stack.push(parseJsonNode(parseJson(src)))
            elif (popAttr("csv") != VNULL):
                stack.push(parseCsvInput(src, withHeaders=(popAttr("withHeaders")!=VNULL)))
            elif (popAttr("toml") != VNULL):
                stack.push(parseTomlString(src))
            elif (popAttr("html") != VNULL):
                stack.push(parseHtmlInput(src))
            elif (popAttr("markdown") != VNULL):
                stack.push(parseMarkdownInput(src))
            # elif attrs.hasKey("xml"):
            #     stack.push(parseXmlNode(parseXml(action(x.s))))
            else:
                stack.push(newString(src))

# template Read*():untyped =
#     # EXAMPLE:
#     # ; reading a simple local file
#     # str: read "somefile.txt"
#     #
#     # ; also works with remote urls
#     # page: read "http://www.somewebsite.com/page.html"
#     #
#     # ; we can also "read" JSON data as an object
#     # data: read.json "mydata.json"
#     #
#     # ; or even convert Markdown to HTML on-the-fly
#     # html: read.markdown "## Hello" ____; "<h2>Hello</h2>"

#     require(opRead)
    
#     if (popAttr("binary") != VNULL):
#         var f: File
#         discard f.open(x.s)
#         var b: seq[byte] = newSeq[byte](f.getFileSize())
#         discard f.readBytes(b, 0, f.getFileSize())

#         f.close()

#         stack.push(newBinary(b))
#     else:
#         let (src, _{.inject.}) = getSource(x.s)

#         if (popAttr("lines") != VNULL):
#             stack.push(newStringBlock(src.splitLines()))
#         elif (popAttr("json") != VNULL):
#             stack.push(parseJsonNode(parseJson(src)))
#         elif (popAttr("csv") != VNULL):
#             stack.push(parseCsvInput(src, withHeaders=(popAttr("withHeaders")!=VNULL)))
#         elif (popAttr("toml") != VNULL):
#             stack.push(parseTomlString(src))
#         elif (popAttr("html") != VNULL):
#             stack.push(parseHtmlInput(src))
#         elif (popAttr("markdown") != VNULL):
#             stack.push(parseMarkdownInput(src))
#         # elif attrs.hasKey("xml"):
#         #     stack.push(parseXmlNode(parseXml(action(x.s))))
#         else:
#             stack.push(newString(src))

        # opZip       : OpSpec(   name    : "zip",      
        #                         args    : 2,   
      
        #                         an      : "destination",
        #                         a       : {String},
        #                         bn      : "files",
        #                         b       : {Block},
        #                         ret     : {Null},
        #                         desc    : "zip given files to file at destination" ),

        # opUnzip     : OpSpec(   name    : "unzip",      
        #                         args    : 2,   
      
        #                         an      : "destination",
        #                         a       : {String},
        #                         bn      : "original",
        #                         b       : {String},
        #                         ret     : {Null},
        #                         desc    : "unzip given archive to destination" ),


builtin "unzip",
    alias       = none, 
    description = "unzip given archive to destination",
    args        = {
        "destination"   : {String},
        "original"      : {String}
    },
    attrs       = {},
    returns     = {Nothing},
    example     = """
        unzip "folder" "archive.zip"
    """:
        ##########################################################
        miniz.unzip(y.s, x.s)

# template Unzip*():untyped = 
#     # EXAMPLE:
#     # unzip "folder" "archive.zip"
#     require(opUnzip)

#     miniz.unzip(y.s, x.s)

builtin "write",
    alias       = doublearrowright, 
    description = "write content to file at given path",
    args        = {
        "file"      : {String,Null},
        "content"   : {Any}
    },
    # ".directory -> create directory at path~" &
    #                                         ".json -> write value as json~" &
    #                                         ".binary -> write as binary",
    attrs       = {
        "directory"     : ({Boolean},"create directory at path"),
        "json"          : ({Boolean},"write value as Json"),
        "binary"        : ({Boolean},"write as binary")
    },
    returns     = {Nothing},
    example     = """
        ; write some string data to given file path
        write "somefile.txt" "Hello world!"

        ; we can also write any type of data as JSON
        write.json "data.json" myData
    """:
        ##########################################################
        if (popAttr("directory") != VNULL):
            createDir(x.s)
        else:
            if (popAttr("binary") != VNULL):
                var f: File
                discard f.open(x.s, mode=fmWrite)
                discard f.writeBytes(y.n, 0, y.n.len)

                f.close()
            else:
                if (popAttr("json") != VNULL):
                    let rez = json.pretty(generateJsonNode(y), indent=4)
                    if x.kind==String:
                        writeFile(x.s, rez)
                    else:
                        stack.push(newString(rez))
                else:
                    writeFile(x.s, y.s)

# template Write*():untyped =
#     # EXAMPLE:
#     # ; write some string data to given file path
#     # write "somefile.txt" "Hello world!"
#     #
#     # ; we can also write any type of data as JSON
#     # write.json "data.json" myData

#     require(opWrite)

#     if (popAttr("directory") != VNULL):
#         createDir(x.s)
#     else:
#         if (popAttr("binary") != VNULL):
#             var f: File
#             discard f.open(x.s, mode=fmWrite)
#             discard f.writeBytes(y.n, 0, y.n.len)

#             f.close()
#         else:
#             if (popAttr("json") != VNULL):
#                 let rez = json.pretty(generateJsonNode(y), indent=4)
#                 if x.kind==String:
#                     writeFile(x.s, rez)
#                 else:
#                     stack.push(newString(rez))
#             else:
#                 writeFile(x.s, y.s)

builtin "zip",
    alias       = none, 
    description = "zip given files to file at destination",
    args        = {
        "destination"   : {String},
        "files"         : {Block}
    },
    attrs       = {},
    returns     = {Nothing},
    example     = """
        zip "dest.zip" ["file1.txt" "img.png"]
    """:
        ##########################################################
        let files: seq[string] = y.a.map((z)=>z.s)
        miniz.zip(files, x.s)
    
# template Zip*():untyped = 
#     # EXAMPLE:
#     # zip "dest.zip" ["file1.txt" "img.png"]

#     require(opZip)

#     let files: seq[string] = y.a.map((z)=>z.s)

#     miniz.zip(files, x.s)
