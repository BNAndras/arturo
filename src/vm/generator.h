/*****************************************************************
 * Arturo :VM
 * 
 * Programming Language + Compiler
 * (c) 2019-2020 Yanis Zafirópulos (aka Dr.Kameleon)
 *
 * @file: src/vm/generator.h
 *****************************************************************/

#ifndef __GENERATOR_H__
#define __GENERATOR_H__

#include "opcodes.h"

/**************************************
  Definitions
 **************************************/

#define GLOBAL_VAR 	0x8000

/**************************************
  External declarations
 **************************************/

extern FILE* yyin;
struct yy_buffer_state;

extern int yyparse();
extern struct yy_buffer_state* yy_scan_string(const char* str);
extern void yy_switch_to_buffer(struct yy_buffer_state* buff);
extern void yy_delete_buffer(struct yy_buffer_state* buff);

/**************************************
  Function declarations
 **************************************/

void emitOp(OPCODE op);
void reemitOp(int pos, OPCODE op);
void emitOpByte(OPCODE op, Byte b);
void emitOpWord(OPCODE op, Word w);
void emitOpDword(OPCODE op, Dword d);
void emitOpValue(OPCODE op, Value v);

void doPushInt(Value v);

int storeValueData(Value v);
void processConst(Value v);

void processCall(char* id);
void processLoad(char* id);
void processStore(char* id);
void processInPlace(OPCODE op, char* id);

void signalGotInArray();
void signalFoundArray();

void signalGotInDictionary();
void signalFoundDictionary();

void signalGotInBlock();
void signalGotOutOfBlock();

void signalGotInFunction();
void signalFoundFunction();

void signalFoundIf();
void finalizeIf();

void signalFoundLoop();
void finalizeLoop();

void generatorSetup();
void generatorFinalize();

bool generateBytecode(FILE* script);

/**************************************
  Globals
 **************************************/

CStringArray* 		GlobalLookup;
CStringArray* 		LocalLookup;
intArray*			LocalLookupStack;
	
intArray* BlockStarts;

intArray* IfStarts;
intArray* LoopStarts;
intArray* LoopHeaders;
int ifsFound;
bool inIf;
int inLoop;
int dictsFound;

bool weAreInIf;
bool weAreInLoop;

int argCounter;

bool weAreInBlock;
bool weAreInDict;

OPCODE lastOp;

#endif