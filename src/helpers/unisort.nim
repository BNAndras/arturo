######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2022 Yanis Zafirópulos
#
# @file: helpers/unisort.nim
######################################################

#=======================================
# Libraries
#=======================================

import algorithm, sequtils, sets, tables, unicode

import helpers/charsets as CharsetsHelper

import vm/values/value

#=======================================
# Constants
#=======================================

const
    onlySafeCode = true

    transformations = {
        "Á".runeAt(0): static "A".runeAt(0),
        "É".runeAt(0): static "E".runeAt(0),
        "Í".runeAt(0): static "I".runeAt(0),
        "Ó".runeAt(0): static "O".runeAt(0),
        "Ú".runeAt(0): static "U".runeAt(0),
        "á".runeAt(0): static "a".runeAt(0),
        "é".runeAt(0): static "e".runeAt(0),
        "í".runeAt(0): static "i".runeAt(0),
        "ó".runeAt(0): static "o".runeAt(0),
        "ú".runeAt(0): static "u".runeAt(0)
    }.toTable()

func unicmp(x,y: Value, charset: seq[Rune], transformable: HashSet[Rune], sensitive:bool = false):int =
    func transformRune(ru: var Rune) =
        if transformable.contains(ru):
            ru = transformations[ru]

    var i = 0
    var j = 0
    var xr, yr: Rune
    while i < x.s.len and j < y.s.len:
        fastRuneAt(x.s, i, xr)
        fastRuneAt(y.s, j, yr)

        if not sensitive:
            xr = toLower(xr)
            yr = toLower(yr)

        transformRune(xr)
        transformRune(yr)

        let xri = charset.find(xr)
        let yri = charset.find(yr)

        if xri == -1 or yri == -1:
            result = cmp((int)(xr), (int)(yr))
        else:
            result = xri - yri

        if result != 0: return
  
    result = x.s.len - y.s.len

#=======================================
# Templates
#=======================================

template `<-` (a, b) =
    when defined(gcDestructors):
        a = move b
    elif onlySafeCode:
        shallowCopy(a, b)
    else:
        copyMem(addr(a), addr(b), sizeof(T))

#=======================================
# Methods
#=======================================

proc unimerge(a, b: var openArray[Value], lo, m, hi: int, lang: string, 
              cmp: proc (x, y: Value, charset: seq[Rune], transformable: HashSet[Rune], sensitive: bool): int {.closure.}, 
              charset: seq[Rune], 
              transformable: HashSet[Rune],
              sensitive:bool = false,
              order: SortOrder) =

    if cmp(a[m], a[m+1], charset, transformable, sensitive) * order <= 0: return
    var j = lo

    assert j <= m
    when onlySafeCode:
        var bb = 0
        while j <= m:
            b[bb] <- a[j]
            inc(bb)
            inc(j)
    else:
        copyMem(addr(b[0]), addr(a[j]), sizeof(Value)*(m-j+1))
        j = m+1
    
    var i = 0
    var k = lo

    while k < j and j <= hi:
        if cmp(b[i], a[j], charset, transformable, sensitive) * order <= 0:
            a[k] <- b[i]
            inc(i)
        else:
            a[k] <- a[j]
            inc(j)
        inc(k)

    when onlySafeCode:
        while k < j:
            a[k] <- b[i]
            inc(k)
            inc(i)
    else:
        if k < j: copyMem(addr(a[k]), addr(b[i]), sizeof(Value)*(j-k))

# TODO(Helpers\unisort) Verify string sorting works properly
#  The `unisort` implementation looks like hack - or incomplete. Also, add unit tests
#  labels: library,bug,unit-test
proc unisort*(a: var openArray[Value], lang: string, 
              cmp: proc (x, y: Value, charset: seq[Rune], transformable: HashSet[Rune], sensitive: bool): int {.closure.},
              sensitive:bool = false,
              order = SortOrder.Ascending) =
    let charset = getCharsetForSorting(lang)
    let fullCharset = getFullCharsetForSorting(lang)
    let transformable = intersection(toHashSet(toSeq(keys(transformations))),toHashSet(fullCharset))

    var n = a.len
    var b: seq[Value]
    newSeq(b, n div 2)
    var s = 1
    while s < n:
        var m = n-1-s
        while m >= 0:
            unimerge(a, b, max(m-s+1, 0), m, m+s, lang, cmp, charset, transformable, sensitive, order)
            dec(m, s*2)
        s = s*2

proc unisort*(a: var openArray[Value], lang: string, sensitive:bool = false, order = SortOrder.Ascending) = 
    unisort(a, lang, unicmp, sensitive, order)

proc unisorted*(a: openArray[Value], lang: string, cmp: proc(x, y: Value, charset: seq[Rune], transformable: HashSet[Rune], insensitive: bool): int {.closure.},
                sensitive:bool = false,
                order = SortOrder.Ascending): seq[Value] =
    result = newSeq[Value](a.len)
    for i in 0 .. a.high:
        result[i] = a[i]
    unisort(result, lang, cmp, sensitive, order)

proc unisorted*(a: openArray[Value], lang: string, sensitive:bool = false, order = SortOrder.Ascending): seq[Value] =
    echo ":: unisorted :: with lang=" & lang & ", sensitive=" & $(sensitive) & ", order=" & $(order)
    unisorted(a, lang, unicmp, sensitive, order)