#=======================================================
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2023 Yanis Zafirópulos
#
# @file: helpers/objects.nim
#=======================================================

#=======================================
# Libraries
#=======================================
    
import vm/values/value

#=======================================
# Methods
#=======================================

proc injectThis*(meth: Value) =
    if meth.params.len < 1 or meth.params[0] != "this":
        meth.params.insert("this")
        meth.arity += 1

proc generateCustomObject(prot: Prototype, arguments: ValueArray | ValueDict): Value =
    newObject(arguments, prot, proc (self: Value, prot: Prototype) =
        for methodName, objectMethod in prot.methods:
            case methodName:
                of "init":
                    when arguments is ValueArray:
                        if arguments.len != objectMethod.arity - 1:
                            # TODO(generateCustomObject) should throw if number of arguments is not correct
                            #  labels: error handling, oop, vm, values
                            echo "incorrect number of arguments"
                        prot.doInit(self, arguments)
                of "print": discard
                of "compare": discard
                else:
                    if objectMethod.kind==Function:
                        let objMethod = copyValue(objectMethod)
                        objMethod.injectThis()
                        self.o[methodName] = objMethod
                        if (let methodInfo = objectMethod.info; not methodInfo.isNil):
                            self.o[methodName].info = methodInfo
                    else:
                        self.o[methodName] = objectMethod
    )