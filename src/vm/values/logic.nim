######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2022 Yanis Zafirópulos
#
# @file: vm/values/logic.nim
######################################################

#=======================================
# Libraries
#=======================================

import vm/values/value

#=======================================
# Methods
#=======================================

func And*(x,y: logical): logical {.noSideEffect.} =
    if x==False: return False
    if y==False: return False
    if x==True and y==True: return True
    else: return Maybe

func Not*(x: logical): logical {.noSideEffect.} =
    if x==True: return False
    elif x==False: return True
    else: return Maybe
    
func Or*(x,y: logical): logical {.noSideEffect.} =
    if x==True: return True
    if y==True: return True
    if x==False and y==False: return False
    else: return Maybe

func Xor*(x,y: logical): logical {.noSideEffect.} =
    return And(Or(x,y),Not(And(x,y)))