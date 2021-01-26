######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2020 Yanis Zafirópulos
#
# @file: library/Files.nim
######################################################

#=======================================
# Methods
#=======================================

builtin "exists?",
    alias       = unaliased, 
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

builtin "unzip",
    alias       = unaliased, 
    description = "unzip given archive to destination",
    args        = {
        "destination"   : {String},
        "original"      : {String}
    },
    attrs       = NoAttrs,
    returns     = {Nothing},
    example     = """
        unzip "folder" "archive.zip"
    """:
        ##########################################################
        miniz.unzip(y.s, x.s)

builtin "write",
    alias       = doublearrowright, 
    description = "write content to file at given path",
    args        = {
        "file"      : {String,Null},
        "content"   : {Any}
    },
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

builtin "zip",
    alias       = unaliased, 
    description = "zip given files to file at destination",
    args        = {
        "destination"   : {String},
        "files"         : {Block}
    },
    attrs       = NoAttrs,
    returns     = {Nothing},
    example     = """
        zip "dest.zip" ["file1.txt" "img.png"]
    """:
        ##########################################################
        let files: seq[string] = y.a.map((z)=>z.s)
        miniz.zip(files, x.s)