#=======================================================
# nim-portable-dialogs
# Wrapper for Steve Bennett's fork of LineNoise
# for Nim
#
# (c) 2022 Yanis Zafirópulos
# 
# @license: see LICENSE file
# @file: extras/linenoise.nim
#=======================================================

#=======================================
# Libraries
#=======================================

import os

#=======================================
# Compilation & Linking
#=======================================

{.passC: "-I" & parentDir(currentSourcePath()) .}

{.compile("linenoise/linenoise.c", "-DUSE_UTF8 -I" & parentDir(currentSourcePath())).}
{.compile("linenoise/stringbuf.c", "-DUSE_UTF8 -I" & parentDir(currentSourcePath())).}
{.compile("linenoise/utf8.c", "-DUSE_UTF8 -I" & parentDir(currentSourcePath())).}

#=======================================
# Types
#=======================================

type
    LinenoiseCompletions* = object
        len*: csize_t
        cvec*: cstringArray

    LinenoiseCompletionCallback*    = proc (buf: cstring; lc: ptr LinenoiseCompletions) {.cdecl.}
    LinenoiseHintsCallback*         = proc (buf: cstring; color: var cint; bold: var cint): cstring {.cdecl.}
    LinenoiseFreeHintsCallback*     = proc (buf: cstring; color: var cint; bold: var cint) {.cdecl.}

#=======================================
# Function prototypes
#=======================================

{.push header: "linenoise/linenoise.h", cdecl.}

proc linenoiseSetCompletionCallback*(cback: ptr LinenoiseCompletionCallback, userdata: cstring) {.importc: "linenoiseSetCompletionCallback".}
proc linenoiseSetHintsCallback*(cback: ptr LinenoiseHintsCallback, userdata: cstring) {.importc: "linenoiseSetHintsCallback".}
proc linenoiseAddCompletion*(a2: ptr LinenoiseCompletions; a3: cstring) {.importc: "linenoiseAddCompletion".}
proc linenoiseReadLine*(prompt: cstring): cstring {.importc: "linenoise".}
proc linenoiseHistoryAdd*(line: cstring): cint {.importc: "linenoiseHistoryAdd", discardable.}
proc linenoiseHistorySetMaxLen*(len: cint): cint {.importc: "linenoiseHistorySetMaxLen".}
proc linenoiseHistorySave*(filename: cstring): cint {.importc: "linenoiseHistorySave".}
proc linenoiseHistoryLoad*(filename: cstring): cint {.importc: "linenoiseHistoryLoad".}
proc linenoiseClearScreen*() {.importc: "linenoiseClearScreen".}
proc linenoiseSetMultiLine*(ml: cint) {.importc: "linenoiseSetMultiLine".}
proc linenoisePrintKeyCodes*() {.importc: "linenoisePrintKeyCodes".}

{.pop.}

proc free*(s: cstring) {.importc: "free", header: "<stdlib.h>".}

#=======================================
# Methods
#=======================================

proc clearScreen*() = 
    linenoiseClearScreen()
