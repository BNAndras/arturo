#=======================================================
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2023 Yanis Zafirópulos
#
# @file: library/Statistics.nim
#=======================================================

## The main Statistics module 
## (part of the standard library)

#=======================================
# Pragmas
#=======================================

{.used.}

#=======================================
# Libraries
#=======================================

import sequtils, stats, sugar

import helpers/ranges

import vm/lib

import vm/values/custom/[vrange]

#=======================================
# Methods
#=======================================

proc defineSymbols*() =

    # TODO(Statistics) more potential built-in function candidates?
    #  labels: library, enhancement, open discussion

    builtin "average",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "get average from given collection of numbers",
        args        = {
            "collection"    : {Block,Range}
        },
        attrs       = NoAttrs,
        returns     = {Floating},
        example     = """
            print average [2 4 5 6 7 2 3]
            ; 4.142857142857143
        """:
            #=======================================================
            var res = F0.copyValue
            if x.kind == Block:
                ensureCleaned(x)
                for num in cleanX:
                    res += num

                res //= newFloating(cleanX.len)
            else:
                for item in items(x.rng):
                    res += item

                res //= newFloating(x.rng.len)

            push(res)

    builtin "deviation",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "get population standard deviation of given collection of numbers",
        args        = {
            "collection"    : {Block}
        },
        attrs       = {
            "sample"    : ({Logical},"calculate the sample standard deviation")
        },
        returns     = {Floating},
        example     = """
            arr:  [1 2 3 4]
            arr2: [3 120 4 7 87 2 6 34]

            print deviation arr         ; 1.118033988749895
            print deviation arr2        ; 42.70959347734417
            
            deviation.sample arr        ; => 1.290994448735806
            deviation.sample arr2       ; => 45.65847597731914
        """:
            #=======================================================
            ensureCleaned(x)
            if (hadAttr("sample")):
                push newFloating(standardDeviationS(cleanX.map((z)=>asFloat(z))))
            else:
                push newFloating(standardDeviation(cleanX.map((z)=>asFloat(z))))

    builtin "kurtosis",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "get population kurtosis of given collection of numbers",
        args        = {
            "collection"    : {Block}
        },
        attrs       = {
            "sample"    : ({Logical},"calculate the sample kurtosis")
        },
        returns     = {Floating},
        example     = """
            arr:  [1 2 3 4]
            arr2: [3 120 4 7 87 2 6 34]

            print kurtosis arr          ; -1.36
            print kurtosis arr2         ; -0.3863717894076322

            kurtosis.sample arr         ; => -1.200000000000001
            kurtosis.sample arr2        ; => 0.5886192422439724
        """:
            #=======================================================
            ensureCleaned(x)
            if (hadAttr("sample")):
                push newFloating(kurtosisS(cleanX.map((z)=>asFloat(z))))
            else:
                push newFloating(kurtosis(cleanX.map((z)=>asFloat(z))))

    builtin "median",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "get median from given collection of numbers",
        args        = {
            "collection"    : {Block}
        },
        attrs       = NoAttrs,
        returns     = {Integer,Floating,Null},
        example     = """
            print median [2 4 5 6 7 2 3]
            ; 6
            
            print median [1 5 2 3 4 7 9 8]
            ; 3.5
        """:
            #=======================================================
            ensureCleaned(x)
            if cleanX.len==0: 
                push(VNULL)
            else:
                let first = cleanX[(cleanX.len-1) div 2]
                let second = cleanX[((cleanX.len-1) div 2)+1]

                if cleanX.len mod 2 == 1:
                    push(first) 
                else:
                    push((first + second)//I2)

    builtin "skewness",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "get population skewness of given collection of numbers",
        args        = {
            "collection"    : {Block}
        },
        attrs       = {
            "sample"    : ({Logical},"calculate the sample skewness")
        },
        returns     = {Floating},
        example     = """
            arr:  [1 2 3 4]
            arr2: [3 120 4 7 87 2 6 34]

            print skewness arr          ; 0.0
            print skewness arr2         ; 1.127950016816592

            skewness.sample arr         ; => 0.0
            skewness.sample arr2        ; => 1.40680083744453
        """:
            #=======================================================
            ensureCleaned(x)
            if (hadAttr("sample")):
                push newFloating(skewnessS(cleanX.map((z)=>asFloat(z))))
            else:
                push newFloating(skewness(cleanX.map((z)=>asFloat(z))))
    
    builtin "variance",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "get population variance of given collection of numbers",
        args        = {
            "collection"    : {Block}
        },
        attrs       = {
            "sample"    : ({Logical},"calculate the sample variance")
        },
        returns     = {Floating},
        example     = """
            arr:  [1 2 3 4]
            arr2: [3 120 4 7 87 2 6 34]

            print variance arr          ; 1.25
            print variance arr2         ; 1824.109375

            variance.sample arr         ; => 1.666666666666667
            variance.sample arr2        ; => 2084.696428571428
        """:
            #=======================================================
            ensureCleaned(x)
            if (hadAttr("sample")):
                push newFloating(varianceS(cleanX.map((z)=>asFloat(z))))
            else:
                push newFloating(variance(cleanX.map((z)=>asFloat(z))))

#=======================================
# Add Library
#=======================================

Libraries.add(defineSymbols)