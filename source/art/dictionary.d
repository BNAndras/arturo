/*****************************************************************
 * Arturo
 * 
 * Programming Language + Interpreter
 * (c) 2019 Yanis Zafirópulos (aka Dr.Kameleon)
 *
 * @file: art/dictionary.d
 *****************************************************************/

module art.dictionary;

// Imports

import std.conv;
import std.file;
import std.stdio;
import std.string;

import parser.expression;
import parser.expressions;
import parser.statements;

import compiler;

import value;

import func;
import globals;

import panic;

import var;

// Functions

class Has__Key : Func {
	this(string ns="") { super(ns ~ "hasKey","check if dictionary has key",[[dV,sV]],[bV]); }
	override Value execute(Expressions ex, string hId=null) {
		Value[] v = validate(ex);
		alias dict = D!(v,0);
		alias key = S!(v,1);

		return new Value(v[0].dictionaryContains(v[1]));
	}
}

class Keys : Func {
	this(string ns="") { super(ns ~ "keys","get array of dictionary keys",[[dV]],[aV]); }
	override Value execute(Expressions ex, string hId=null) {
		Value[] v = validate(ex);
		alias dict = D!(v,0);

		Value[] ret;
		foreach (Var va; dict.variables)
			ret ~= new Value(va.name);

		return new Value(ret);
	}
}
