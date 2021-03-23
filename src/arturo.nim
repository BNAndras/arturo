######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2021 Yanis Zafirópulos
#
# @file: arturo.nim
######################################################

#=======================================
# Libraries
#=======================================

import parseopt, segFaults

when defined(PORTABLE):
    import os, sequtils
else:
    import tables

when defined(PROFILE):
    import nimprof

import vm/[bytecode, version, value, vm]

#=======================================
# Types
#=======================================

type
    CmdAction = enum
        execFile
        evalCode
        readBcode
        writeBcode
        showHelp
        showVersion

#=======================================
# Constants
#=======================================

const helpTxt = """

Usage:
  arturo [options] <path>

Options:
  -c --compile              Compile script and write bytecode
  -x --execute              Execute script from bytecode

  -e --evaluate             Evaluate given code
  -r --repl                 Show repl / interactive console

  -u --update               Update to latest version

  -m --module           
        list                List all available modules
        remote              List all available remote modules
        info <name>         Get info about given module
        install <name>      Install remote module by name
        uninstall <name>    Uninstall module by name
        update              Update all local modules

  -d --debug                Show debugging information
  -h --help                 Show this help screen
  -v --version              Show current version
"""
    
#=======================================
# Main entry
#=======================================

when isMainModule:

    var token = initOptParser()

    var action: CmdAction = evalCode
    var runConsole  = static readFile("src/scripts/console.art")
    var runUpdate   = static readFile("src/scripts/update.art")
    var runModule   = static readFile("src/scripts/module.art")
    var code: string = ""
    var arguments: seq[string] = @[]

    when not defined(PORTABLE):

        while true:
            token.next()
            case token.kind:
                of cmdArgument: 
                    if code=="":
                        if action==evalCode:
                            action = execFile
                        
                        code = token.key
                        break
                of cmdShortOption, cmdLongOption:
                    case token.key:
                        of "r","repl":
                            action = evalCode
                            code = runConsole
                        of "e","evaluate":
                            action = evalCode
                            code = token.val
                        of "c","compile":
                            action = writeBcode
                            code = token.val
                        of "x","execute":
                            action = readBcode
                            code = token.val
                        of "u","update":
                            action = evalCode
                            code = runUpdate
                        of "m", "module":
                            action = evalCode
                            code = runModule
                        of "d","debug":
                            # DoDebug = true
                            discard
                        of "h","help":
                            action = showHelp
                        of "v","version":
                            action = showVersion
                        else:
                            #echo "error: unrecognized option (" & token.key & ")"
                            discard
                of cmdEnd: break

        arguments = token.remainingArgs()

        case action:
            of execFile, evalCode:
                if code=="":
                    code = runConsole

                when defined(BENCHMARK):
                    benchmark "doParse / doEval":
                        discard run(code, arguments, action==execFile)
                else:
                    discard run(code, arguments, action==execFile)
                    
            of writeBcode:
                let filename = code
                discard writeBytecode(run(code, arguments, isFile=true, doExecute=false), filename & ".bcode")

            of readBcode:
                let filename = code
                runBytecode(readBytecode(code), filename, arguments)

            of showHelp:
                echo helpTxt
            of showVersion:
                echo VersionTxt
    else:
        arguments = commandLineParams().map(proc (x:string):Value = newString(x))
        code = static readFile(getEnv("PORTABLE_INPUT"))

        discard run(code, arguments, isFile=false)