######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2022 Yanis Zafirópulos
#
# @file: helpers/regex.nim
######################################################

#=======================================
# Libraries
#=======================================

import hashes
import nre except toSeq

#=======================================
# Types
#=======================================

type
    RegExp* = Regex

#=======================================
# Methods
#=======================================

proc `$`*(rx: RegExp): string =
    rx.pattern

proc newRegExp*(pattern: string): RegExp =
    re(pattern)

proc hash*(rx: RegExp): Hash =
    hash(rx.pattern)
