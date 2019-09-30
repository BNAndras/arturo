/*****************************************************************
 * Arturo
 * 
 * Programming Language + Interpreter
 * (c) 2019 Yanis Zafirópulos (aka Dr.Kameleon)
 *
 * @file: parser/statement.d
 *****************************************************************/

module parser.statements;

// Imports

import core.memory;
import std.conv;
import std.stdio;

import parser.statement;

import value;

import panic;

import globals;

// C Interface

extern (C) {
	void* new_Statements() { return cast(void*)(new Statements()); }
	void add_Statement(Statements s, Statement st) { GC.addRoot(cast(void*)s); s.add(st); }
}

// Utilities

class ReturnResult : Exception {
	Value val;
	this(Value v) {
		super("ReturnResult");
		val = v;
	}
}

// Functions

class Statements {

	Statement[] lst;

	this() {
	}

	this(Statement st) {
		lst ~= st;
	}

	void add(Statement st) {
		lst ~= st;
	}

	Value execute(Value* v = null) {
		Value ret;
		foreach (size_t i, Statement s; lst) {
			try {
				ret = s.execute(v);
			}
			catch (Exception e) {

				if (cast(ReturnResult)(e) !is null) {
					debug write("BLOCK::execute -> got Return: ");
					if (!Glob.blockStack.isEmpty() && Glob.blockStack.lastItem() is this) {
						debug writeln("It's last item - return it");

						//writeln("STATEMENTS::execute -> popping block from stack after executing");
						Glob.blockStack.pop();
						//Glob.contextStack.pop();
						//writeln("Return:: popping context");
						//writeln(Glob.inspectAllVars());
						Value va = (cast(ReturnResult)(e)).val;
						return va;
					}
					else {
						debug writeln("Not last item - reTHROW");
						//writeln("Return:: popping context (throw)"); 					
						throw e;
					}
				} else {
					debug writeln("BLOCK::execute -> got Exception");
					Panic.runtimeError(e.msg, s.pos);
				}
			}
		}

		return ret;
	}

	void inspect() {
		foreach (size_t i, Statement s; lst) {
			s.inspect();
		}
	}

}