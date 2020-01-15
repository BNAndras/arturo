/*****************************************************************
 * Arturo :VM
 * 
 * Programming Language + Compiler
 * (c) 2019-2020 Yanis Zafirópulos (aka Dr.Kameleon)
 *
 * @file: src/vm/func.h
 *****************************************************************/

#ifndef __FUNC_H__
#define __FUNC_H__

#include "../arturo.h"

/**************************************
  Type definitions
 **************************************/

typedef struct {
    Dword ip;
    Byte args;
} Func;

/**************************************
  Inline Methods
 **************************************/

//-------------------------
// Constructor
//-------------------------

static inline Func* fNew(Dword ip, Byte args) {
    Func* ret = malloc(sizeof(Func));
    ret->ip = ip;
    ret->args = args;
    return ret;
}

//-------------------------
// Destructor
//-------------------------

static inline void fFree(Func* dest) {
    free(dest);
}

#endif