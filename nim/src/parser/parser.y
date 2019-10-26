%{
/*****************************************************************
 * Arturo
 * 
 * Programming Language + Interpreter
 * (c) 2019 Yanis Zafirópulos (aka Dr.Kameleon)
 *
 * @file: parser/parser.y
 *****************************************************************/

/****************************************
 Extern & Forward declarations
 ****************************************/

// Macros

#define POS(X) setStatementPosition(X,yyfilename,yylineno);

// Parser interface

extern void yyerror(const char* str);
extern int yyparse(void);
extern int yylex();

extern int yylineno;
char* yyfilename;

// External definitions - from Nim

extern void* MainProgram;

extern void* identifierFromString(char* i);
extern void* identifierFromKeypath(void* k);

extern void* argumentFromIdentifier(void* i);
extern void* argumentFromStringLiteral(char* l);
extern void* argumentFromIntegerLiteral(char* l);
extern void* argumentFromRealLiteral(char* l);
extern void* argumentFromBooleanLiteral(char* l);
extern void* argumentFromNullLiteral();
extern void* argumentFromArrayLiteral(void* l);
extern void* argumentFromDictionaryLiteral(void* l);
extern void* argumentFromFunctionLiteral(void* l, char* args);
extern void* argumentFromInlineCallLiteral(void* l);

extern void* expressionFromArgument(void *a);
extern void* expressionFromExpressions(void* l, char* op, void* r);

extern void* newExpressionList();
extern void addExpressionToExpressionList(void* x, void* xl);

extern void* statementFromExpression(void* x);
extern void* statementFromExpressions(void* i, void* xl);
extern void* setStatementPosition(void* s, char* f, int l);

extern void* newStatementList();
extern void addStatementToStatementList(void* s, void* sl);

/****************************************
 Functions
 ****************************************/ 
 
int yywrap() {
	return 1;
} 

%}

/****************************************
 Definitions
 ****************************************/

%union {
	char* str;
	void* compo;
}

/****************************************
 Tokens & Types
 ****************************************/

%token <str> ID "ID"
%token <str> HASH_ID "@ID"
%token <str> FUNCTION_ID "Function Identifier"
%token <str> INTEGER "Integer"
%token <str> REAL "Real"
%token <str> STRING "String Literal"
%token <str> NULLV "Null"
%token <str> BOOLEANV "Boolean"

%token <str> PIPE "|"

%token <str> EQ_OP "="
%token <str> LE_OP "<="
%token <str> LT_OP "<"
%token <str> GE_OP ">="
%token <str> GT_OP ">"
%token <str> NE_OP "!="

%token <str> PLUS_SG "+"
%token <str> MINUS_SG "-"
%token <str> MULT_SG "*"
%token <str> DIV_SG "/"
%token <str> MOD_SG "%"
%token <str> POW_SG "^"

%token <str> BEGIN_ARR "#("
%token <str> BEGIN_DICT "#{"
%token <str> BEGIN_INLINE "$("

%token <str> DOT "."
%token <str> HASH "#"
%token <str> DOLLAR "$"
%token <str> LPAREN "("
%token <str> RPAREN ")"
%token <str> LCURLY "{"
%token <str> RCURLY "}"
%token <str> LSQUARE "["
%token <str> RSQUARE "]"
%token <str> COMMA ","
%token <str> COLON ":"
%token <str> EXCL "!"
%token <str> SEMICOLON ";"
%token <str> TILDE "~"

%token <str> NEW_LINE "End Of Line"

%type <str> args

%type <compo> keypath
%type <compo> identifier string number boolean null
%type <compo> array dictionary function inline_call
%type <compo> argument expression expression_list
%type <compo> statement statement_list

/****************************************
 Directives
 ****************************************/

%glr-parser
%locations
%define parse.error verbose

%right TILDE
%nonassoc EQ_OP LE_OP GE_OP LT_OP GT_OP NE_OP 

%left PLUS_SG MINUS_SG
%left MULT_SG DIV_SG MOD_SG 
%left POW_SG

%nonassoc REDUCE
%nonassoc ID

%left INTEGER
%left REAL

%start program

%%

/****************************************
 Grammar Rules
 ****************************************/

//==============================
// Building blocks
//==============================


keypath					: 	ID DOT ID 															{ void* e = newExpressionList(); 
																								  addExpressionToExpressionList(expressionFromArgument(argumentFromIdentifier(identifierFromString($1))), e); 
																								  addExpressionToExpressionList(expressionFromArgument(argumentFromIdentifier(identifierFromString($3))), e); 
																								  $$ = expressionFromArgument(argumentFromInlineCallLiteral(statementFromExpressions("get",e))); }
						| 	ID DOT INTEGER 	 													{ void* e = newExpressionList(); 
																								  addExpressionToExpressionList(expressionFromArgument(argumentFromIdentifier(identifierFromString($1))), e); 
																								  addExpressionToExpressionList(expressionFromArgument(argumentFromIntegerLiteral($3)), e); 
																								  $$ = expressionFromArgument(argumentFromInlineCallLiteral(statementFromExpressions("get",e))); }
						| 	ID DOT LSQUARE expression RSQUARE 									{ void* e = newExpressionList(); 
																								  addExpressionToExpressionList(expressionFromArgument(argumentFromIdentifier(identifierFromString($1))), e); 
																								  addExpressionToExpressionList($4, e); 
																								  $$ = expressionFromArgument(argumentFromInlineCallLiteral(statementFromExpressions("get",e))); }
						| 	keypath DOT ID 														{ void* e = newExpressionList(); 
																								  addExpressionToExpressionList(expressionFromArgument(argumentFromInlineCallLiteral($1)), e); 
																								  addExpressionToExpressionList(expressionFromArgument(argumentFromIdentifier(identifierFromString($3))), e); 
																								  $$ = expressionFromArgument(argumentFromInlineCallLiteral(statementFromExpressions("get",e))); }
						| 	keypath DOT INTEGER 												{ void* e = newExpressionList(); 
																								  addExpressionToExpressionList(expressionFromArgument(argumentFromInlineCallLiteral($1)), e);
																								  addExpressionToExpressionList(expressionFromArgument(argumentFromIntegerLiteral($3)), e);  
																								  $$ = expressionFromArgument(argumentFromInlineCallLiteral(statementFromExpressions("get",e))); }
						| 	keypath	DOT LSQUARE expression RSQUARE 								{ void* e = newExpressionList(); 
																								  addExpressionToExpressionList(expressionFromArgument(argumentFromInlineCallLiteral($1)), e); 
																								  addExpressionToExpressionList($4, e);  
																								  $$ = expressionFromArgument(argumentFromInlineCallLiteral(statementFromExpressions("get",e))); }
						;					

args					: 	ID[previous] COMMA ID 												{ strcat( $1, "," ); $$ = strcat($1, $3); }
						|	ID 																	{ $$ = $1; }
						|	/* Nothing */														{ }
						;

identifier 				: 	ID 																	{ $$ = identifierFromString($1); }
						| 	keypath 															{ $$ = identifierFromKeypath($1); }
						;

string 					:	STRING 																{ $$ = argumentFromStringLiteral($1); }
						|	TILDE 																{ $$ = argumentFromStringLiteral(""); }
						|	TILDE ID 															{ $$ = argumentFromStringLiteral($ID); }
						;

number					:	INTEGER																{ $$ = argumentFromIntegerLiteral($1); }
						|	REAL 																{ $$ = argumentFromRealLiteral($1); }
						;

boolean 				:  	BOOLEANV 															{ $$ = argumentFromBooleanLiteral($1); }
						;

null 					:	NULLV 																{ $$ = argumentFromNullLiteral(); }
						;

array 					:	BEGIN_ARR expression_list RPAREN 									{ $$ = argumentFromArrayLiteral($2); }
						|	BEGIN_ARR RPAREN 													{ $$ = argumentFromArrayLiteral(NULL); }
						;

dictionary 				: 	BEGIN_DICT statement_list RCURLY 									{ $$ = argumentFromDictionaryLiteral($2); }
						;

function 				: 	LCURLY statement_list RCURLY 										{ $$ = argumentFromFunctionLiteral($2,""); }
						|	LSQUARE args RSQUARE LCURLY statement_list RCURLY 					{ $$ = argumentFromFunctionLiteral($5,$2); }
						;

inline_call				:	BEGIN_INLINE statement RPAREN 										{ $$ = argumentFromInlineCallLiteral($2); }					
						;

argument				:	identifier 															{ $$ = argumentFromIdentifier($1); }
						| 	number 																
						|	string
						|	boolean 															
						|	null	 															
						| 	array
						|	dictionary
						|	function
						|	inline_call
						;

//==============================
// Expressions
//==============================

expression				: 	argument 															{ $$ = expressionFromArgument($1); }
						|	LPAREN expression[main] RPAREN 										{ $$ = $main; }
						|	expression[left] PLUS_SG expression[right] 							{ $$ = expressionFromExpressions($left, "PLUS_SG", $right); }
						| 	expression[left] MINUS_SG expression[right] 						{ $$ = expressionFromExpressions($left, "MINUS_SG", $right); }
						| 	expression[left] MULT_SG expression[right] 							{ $$ = expressionFromExpressions($left, "MULT_SG", $right); }
						| 	expression[left] DIV_SG expression[right] 							{ $$ = expressionFromExpressions($left, "DIV_SG", $right); }
						| 	expression[left] MOD_SG expression[right] 							{ $$ = expressionFromExpressions($left, "MOD_SG", $right); }
						| 	expression[left] POW_SG expression[right] 							{ $$ = expressionFromExpressions($left, "POW_SG", $right); }
						| 	expression[left] EQ_OP expression[right] 							{ $$ = expressionFromExpressions($left, "EQ_OP", $right); } 
						|	expression[left] LE_OP expression[right]							{ $$ = expressionFromExpressions($left, "LE_OP", $right); } 
						|	expression[left] GE_OP expression[right]							{ $$ = expressionFromExpressions($left, "GE_OP", $right); } 
						|	expression[left] LT_OP expression[right]							{ $$ = expressionFromExpressions($left, "LT_OP", $right); } 
						|	expression[left] GT_OP expression[right]							{ $$ = expressionFromExpressions($left, "GT_OP", $right); } 
						|	expression[left] NE_OP expression[right]							{ $$ = expressionFromExpressions($left, "NE_OP", $right); } 
						;


expression_list			:	expression 															{ void* e = newExpressionList(); addExpressionToExpressionList($expression, e); $$ = e; }
						| 	expression_list[previous] expression 								{ void* e = $previous; addExpressionToExpressionList($expression, e); $$ = e; }
						| 	expression_list[previous] SEMICOLON NEW_LINE expression 			{ void* e = $previous; addExpressionToExpressionList($expression, e); $$ = e; }
						;

//==============================
// Statements
//==============================

statement				: 	expression 															{ $$ = statementFromExpression($1); POS($$); }
						|	identifier expression_list											{ $$ = statementFromExpressions($1,$2); POS($$); }
						|	identifier PIPE statement[previous]									{ void* e = newExpressionList(); addExpressionToExpressionList(expressionFromArgument(argumentFromInlineCallLiteral($previous)), e); $$ = statementFromExpressions($identifier,e); POS($$); }
						;

statement_list 			:	statement_list[previous] NEW_LINE statement 						{ void* s = $previous; if ($statement!=NULL) { addStatementToStatementList($statement, s); } $$ = s; }
						|   statement_list[previous] COMMA statement 							{ void* s = $previous; if ($statement!=NULL) { addStatementToStatementList($statement, s); } $$ = s; }
						|	statement_list[previous] NEW_LINE									{ $$ = $previous; }
						| 	statement 															{ void* s = newStatementList(); if ($statement!=NULL) { addStatementToStatementList($statement, s); $$ = s; } }
						|	/* Nothing */														{ $$ = newStatementList(); }
						;

//==============================
// Entry point
//==============================

program					:	statement_list 														{ MainProgram = $statement_list; }
						;

%%

/****************************************
  This is the end,
  my only friend, the end...
 ****************************************/