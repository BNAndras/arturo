######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2022 Yanis Zafirópulos
#
# @file: helpers/webview.nim
######################################################

#=======================================
# Libraries
#=======================================

import os, osproc, strutils

when not defined(NOWEBVIEW):
    import std/json

    import extras/webview
    when defined(macosx):
        import extras/menubar
    import helpers/jsonobject
    import vm/values/value

    export webview

#=======================================
# Types
#=======================================

when not defined(NOWEBVIEW):
    type
        WebviewCallKind* = enum
            FunctionCall,
            ExecuteCode,
            BackendAction,
            WebviewEvent,
            UnrecognizedCall

        WebviewCallHandler* = proc (call: WebviewCallKind, value: Value): Value

#=======================================
# Variables
#=======================================

when not defined(NOWEBVIEW):
    var
        mainWebview* {.global.}      : Webview
        mainCallHandler* {.global.}  : WebviewCallHandler

#=======================================
# Methods
#=======================================

proc openChromeWindow*(port: int, flags: seq[string] = @[]) =
    var args = @[
        "--app=http://localhost:" & port.intToStr & "/ ",
        "--disable-http-cache",
        # "--disable-background-networking",
        # "--disable-background-timer-throttling", 
        # "--disable-backgrounding-occluded-windows", 
        # "--disable-breakpad", 
        # "--disable-client-side-phishing-detection", 
        # "--disable-default-apps", 
        # "--disable-dev-shm-usage", 
        # "--disable-infobars", 
        # "--disable-extensions", 
        # "--disable-features=site-per-process", 
        # "--disable-hang-monitor", 
        # "--disable-ipc-flooding-protection", 
        # "--disable-popup-blocking", 
        # "--disable-prompt-on-repost", 
        # "--disable-renderer-backgrounding", 
        # "--disable-sync", 
        # "--disable-translate", 
        # "--disable-windows10-custom-titlebar", 
        # "--metrics-recording-only", 
        # "--no-first-run", 
        # "--no-default-browser-check", 
        # "--safebrowsing-disable-auto-update", 
        # "--enable-automation", 
        # "--password-store=basic", 
        # "--use-mock-keychain"
    ]

    for flag in flags:
        args &= flag.strip

    var chromeBinaries: seq[string]
    var chromePath = ""

    when hostOS == "macosx":
        chromeBinaries = @[
            r"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
            r"/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary",
            r"/Applications/Chromium.app/Contents/MacOS/Chromium",
            r"/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge",
            r"/usr/bin/google-chrome-stable",
            r"/usr/bin/google-chrome",
            r"/usr/bin/chromium",
            r"/usr/bin/chromium-browser"
        ]
    elif hostOS == "windows":
        chromeBinaries = @[
            getEnv("LocalAppData") & r"/Google/Chrome/Application/chrome.exe",
            getEnv("ProgramFiles") & r"/Google/Chrome/Application/chrome.exe",
            getEnv("ProgramFiles(x86)") & r"/Google/Chrome/Application/chrome.exe",
            getEnv("LocalAppData") & r"/Chromium/Application/chrome.exe",
            getEnv("ProgramFiles") & r"/Chromium/Application/chrome.exe",
            getEnv("ProgramFiles(x86)") & r"/Chromium/Application/chrome.exe",
            getEnv("ProgramFiles(x86)") & r"/Microsoft/Edge/Application/msedge.exe",
            getEnv("ProgramFiles") & r"/Microsoft/Edge/Application/msedge.exe"
        ]
    elif hostOS == "linux":
        chromeBinaries = @[
            r"/usr/bin/google-chrome-stable",
            r"/usr/bin/google-chrome",
            r"/usr/bin/chromium",
            r"/usr/bin/chromium-browser",
            r"/snap/bin/chromium"
        ]

    for bin in chromeBinaries:
        if fileExists(bin):
            chromePath = bin
            break

    if chromePath == "":
        echo "could not find any Chrome-compatible browser installed"
    else:
        let command = chromePath.replace(" ", r"\ ") & " " & args.join(" ")
        if execCmd(command) != 0:
            echo "could not open a Chrome window"

when not defined(NOWEBVIEW):

    proc newWebView*(title       : string                = "Arturo", 
                     url         : string                = "", 
                     width       : int                   = 640, 
                     height      : int                   = 480, 
                     resizable   : bool                  = true, 
                     debug       : bool                  = false, 
                     initializer : string                = "",
                     callHandler : WebviewCallHandler    = nil): Webview =

        result = webview_create(debug.cint)
        webview_set_title(result, title=title.cstring)
        webview_set_size(result, width.cint, height.cint, if resizable: Constraints.Default else: Constraints.Fixed)
        webview_navigate(result, url.cstring)
        webview_init(result,(
            (static readFile(parentDir(currentSourcePath()) & "/webviews.js")) & 
            "\n" & 
            initializer
        ).cstring)

        let handler = proc (seq: cstring, req: cstring, arg: pointer) {.cdecl.} =
            var request = parseJson($(req))

            let mode = request.elems[0].str
            let value = valueFromJson(request.elems[1].str)

            var res = 0
            var callKind: WebviewCallKind
            var returned: cstring = "{}"

            case mode:
                of "call"   : callKind = FunctionCall
                of "exec"   : callKind = ExecuteCode
                of "event"  : callKind = WebviewEvent
                of "action" : callKind = BackendAction
                else        : 
                    res = 1
                    callKind = UnrecognizedCall

            if callKind != UnrecognizedCall:
                returned = jsonFromValue(mainCallHandler(callKind, value), pretty=false).cstring

            webview_return(mainWebview, seq, res.cint, returned)

        mainWebview = result
        mainCallHandler = callHandler
        result.webview_bind("callback", handler, cast[pointer](0))

    proc show*(w: Webview) =
        when defined(macosx):
            generateDefaultMainMenu()

        webview_run(w)
        webview_destroy(w)

    proc evaluate*(w: Webview, js: string) =
        webview_eval(w, js.cstring)