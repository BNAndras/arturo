#[*****************************************************************
  * Arturo
  * 
  * Programming Language + Interpreter
  * (c) 2019 Yanis Zafirópulos (aka Dr.Kameleon)
  *
  * @file: lib/system/json.nim
  * @description: JSON parsing/generation
  *****************************************************************]#

#[######################################################
    Helpers
  ======================================================]#

proc generateCsvFromArrays*(s: seq[Value]): string =
    result = ""

    for arr in s:
        result &= (A(arr).map((x)=>escape(x.stringify(quoted=false)))).join(",") & "\n"

proc generateCsvFromDictionaries*(s: seq[Value]): string =
    result = ""
    let headers = D(s[0]).keys()
    result &= (headers.map((x)=>escape(x))).join(",") & "\n"
    for dict in s:
        result &= (D(dict).values.map((x)=>escape(x.stringify(quoted=false)))).join(",") & "\n"


proc parseCsv*(s: string, headers:bool): Value =
    var ret: seq[Value]

    var strm = newStringStream(s)
    var parser: CsvParser
    parser.open(strm, "tmp.csv")

    if headers:
        parser.readHeaderRow()
        while parser.readRow():
            var row: seq[(string,Value)]
            for col in items(parser.headers):
                row.add((col,STR(parser.rowEntry(col))))
            ret.add(DICT(row))
    else:
        while parser.readRow():
            var row: seq[Value]
            for val in items(parser.row):
                row.add(STR(val))
            ret.add(ARR(row))

    parser.close()
    strm.close()

    result = ARR(ret)

#[######################################################
    Functions
  ======================================================]#

proc Csv_generateCsv*[F,X,V](f: F, xl: X): V {.inline.} =
    let v0 = VALID(0,AV)

    case A(v0)[0].kind
        of AV: result = STR(generateCsvFromArrays(A(v0)))
        of DV: result = STR(generateCsvFromDictionaries(A(v0)))
        else: discard

proc Csv_parseCsv*[F,X,V](f: F, xl: X): V {.inline.} =
    let v0 = VALID(0,AV)

    if xl.list.len==2:
        result = parseCsv(S(v0),headers=B(VALID(1,BV)))
    else:
        result = parseCsv(S(v0),headers=false)

#[******************************************************
  ******************************************************
    UnitTests
  ******************************************************
  ******************************************************]#

# when defined(unittest):

#     suite "Library: system/dictionary":

#         test "shuffle":
#             check(not eq( callFunction("shuffle",@[ARR(@[INT(1),INT(2),INT(3),INT(4),INT(5),INT(6),INT(7),INT(8),INT(9)])]), ARR(@[INT(1),INT(2),INT(3),INT(4),INT(5),INT(6),INT(7),INT(8),INT(9)]) ))

#         test "swap":
#             check(eq( callFunction("swap",@[ARR(@[INT(1),INT(2),INT(3)]),INT(0),INT(2)]), ARR(@[INT(3),INT(2),INT(1)]) ))
