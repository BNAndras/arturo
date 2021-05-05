######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2021 Yanis Zafirópulos
#
# @file: helpers/colors.nim
######################################################

#=======================================
# Global Variables
#=======================================

var
    NoColors* = false

#=======================================
# Constants
#=======================================

const
    noColor*     = "\e[0m"

    blackColor*     = ";30"
    redColor*       = ";31"
    greenColor*     = ";32"
    yellowColor*    = ";33"
    blueColor*      = ";34"
    magentaColor*   = ";35"
    cyanColor*      = ";36"
    whiteColor*     = ";37"
    grayColor*      = ";90"

#=======================================
# Templates
#=======================================

template resetColor*():string =
    if NoColors: ""
    else: noColor

template fg*(color: string=""):string =
    if NoColors: ""
    else: "\e[0" & color & "m"

template bold*(color: string=""):string =
    if NoColors: ""
    else: "\e[1" & color & "m"

template underline*(color: string=""):string = 
    if NoColors: ""
    else: "\e[4" & color & "m"

template rgb*(color: string=""):string =
    if NoColors: ""
    else: ";38;5;" & color

template rgb*(color: tuple[r, g, b: range[0 .. 255]]):string =
    if NoColors: ""
    else: ";38;2;" & $(color[0]) & ";" & $(color[1]) & ";" & $(color[2])