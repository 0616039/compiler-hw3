%{

#include "include/AST/ast.hpp"
#include "include/AST/program.hpp"
#include "include/AST/declarationlist.hpp"
#include "include/core/error.h"
#include "include/visitor/dumpvisitor.hpp"
#include "include/AST/compoundstatement.hpp"
#include "include/AST/variable.hpp"
#include "include/AST/binaryop.hpp"
#include "include/AST/statement.hpp"
#include "include/AST/function.hpp"



#include <memory>
#include <vector>


#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <iostream>
#include <cstring>
#define YYLTYPE yyltype

typedef struct YYLTYPE {
    uint32_t first_line;
    uint32_t first_column;
    uint32_t last_line;
    uint32_t last_column;
} yyltype;

/* Declared by scanner.l */
extern int32_t LineNum;
extern char Buffer[512];

/* Declared by lex */
extern FILE *yyin;
extern char *yytext;

extern "C" int yylex(void);
extern "C" int yyparse();
static void yyerror(const char *msg);

static ProgramNode *root;
static declaration *dec;
static compoundstatement* CS;
static variable* var;

std::vector<std::pair<char*,std::pair<int,int> > > va;
std::vector<std::pair<char*, std::pair<int,int> > > ::iterator it;

std::vector<std::pair<int,int> >  arr1;
std::vector<std::pair<int,int> > ::iterator arrit;

std::vector<int>  int1;
std::vector<int> ::iterator intit;

std::vector<double>  real1;
std::vector<double> ::iterator realit;

std::vector<std::string>  str1;
std::vector<std::string> ::iterator strit;

std::vector<bool>  bo1;
std::vector<bool> ::iterator boit;

std::vector<litconst*>  type1;

std::vector<std::shared_ptr<ASTNodeBase>> v;

%}

%locations
%code requires{ #include "AST/program.hpp" }
%code requires{ #include "AST/declarationlist.hpp" }
%code requires{ #include "AST/compoundstatement.hpp" }
%code requires{ #include "AST/variable.hpp" }
%code requires{ #include "AST/binaryop.hpp" }
%code requires{ #include "AST/statement.hpp" }
%code requires{ #include "AST/function.hpp" }

    /* Delimiter */
%token COMMA SEMICOLON COLON
%token L_PARENTHESIS R_PARENTHESIS
%token L_BRACKET R_BRACKET

    /* Operator */
%token ASSIGN
%left <str>OR
%left <str>AND
%right <str>NOT
%left <str>LESS LESS_OR_EQUAL EQUAL GREATER GREATER_OR_EQUAL NOT_EQUAL
%left <str>PLUS MINUS
%left <str>MULTIPLY DIVIDE MOD
%right <str>UNARY_MINUS

    /* Keyword */
%token <str>ARRAY BOOLEAN INTEGER REAL STRING
%token END BEGIN_ /* Use BEGIN_ since BEGIN is a keyword in lex */
%token DO ELSE FOR IF THEN WHILE
%token DEF OF TO RETURN VAR
%token <str>FALSE TRUE
%token PRINT READ

    /* Identifier */
%token <str>ID

    /* Literal */
%token <str>INT_LITERAL
%token <str>REAL_LITERAL
%token <str>STRING_LITERAL

%union {
    int num;
    char *str;
    double flo;
    bool bo;
    Type* type;
    ProgramNode* program;
    declaration* decl;
    compoundstatement* Compoundstatement;
    variable *Variable;
    Operator *op;
    binaryop* Bop;
    litconst* lit;
    unaryop* Uop;
    function* fun;
    varReference* varref;
    statement* state;
    functioncall *funcall;
    AssignmentNode *assign;
    PrintNode *print;
    ReadNode* read;
    IfNode* ifnode;
    WhileNode* whilenode;
    ForNode* fornode;
    ReturnNode* returnnode;

    oplist* Oplist;
    statementlist* Statelist;
    declarationlist* Declarationlist;
    functionlist* Functionlist;
    variablelist* Variablelist;
}
%type<program> Program
%type<str> ProgramName FunctionName

%type<str> TypeOrConstant Type ScalarType ArrType ArrDecl
%type<decl> Declaration  FormalArg
%type<Compoundstatement> CompoundStatement
%type<op> Expression
%type<lit> LiteralConstant
%type<varref> VariableReference
%type<fun> FunctionDeclaration
%type<type> ReturnType

/*statement*/
%type<state> Statement Simple
%type<ifnode> Condition
%type<whilenode> While
%type<fornode> For
%type<returnnode> Return
%type<funcall> FunctionInvokation FunctionCall

/*list*/
%type<Oplist> ExpressionList Expressions ArrForm;
%type<Statelist> StatementList Statements ElseOrNot;
%type<Declarationlist> FormalArgList FormalArgs DeclarationList Declarations;
%type<Functionlist> FunctionList Functions;
%type<Variablelist> IdList;

%%
    /*
       Program Units
                     */

Program:
    ProgramName SEMICOLON DeclarationList FunctionList CompoundStatement END ProgramName {
        $$ = root = new ProgramNode(@1.first_line, @1.first_column);
        $$->location.line=@1.first_line;
        $$->location.col=@1.first_column;
        $$->name = $1;
        $$->body=$5;
        for(size_t i =0;i<$3->v.size();i++){
            $$->gvandconstdec.push_back($3->v[i]);
        }
        for(size_t i =0;i<$4->funvec.size();i++){
            $$->fundec.push_back($4->funvec[i]);
        }
        /*std::cout<<$$->body->location.line<<" "<<$$->body->location.col<<std::endl;*/
    }
;

ProgramName:
    ID
;

/*ProgramBody:
    DeclarationList FunctionList CompoundStatement*/

DeclarationList:
    Epsilon{
    $$ = new declarationlist;
    }
    |
    Declarations
;

Declarations:
    Declaration{
    $$ = new declarationlist;
    $$->v.push_back($1);
    }
    |
    Declarations Declaration{
    $$ = $1;
    $$->v.push_back($2);
    }
;

FunctionList:
    Epsilon{
    $$ = new functionlist;
    }
    |
    Functions
;

Functions:
    FunctionDeclaration{
    $$ = new functionlist;
    $$->funvec.push_back($1);
    }
    |
    Functions FunctionDeclaration{
    $$ = $1;
    $$->funvec.push_back($2);
    }
;

FunctionDeclaration:
    FunctionName L_PARENTHESIS FormalArgList R_PARENTHESIS ReturnType SEMICOLON
    CompoundStatement
    END FunctionName{
    $$ = new function(@1.first_line,@1.first_column);
    $$->name=$1;
    $$->body=$7;
    $$->returntype=$5;
    for(size_t i = 0; i < $3->v.size(); i++){
        $$->Parameter.push_back($3->v[i]);
    }
    }
;

FunctionName:
    ID
;

FormalArgList:
    Epsilon{
    $$ = new declarationlist;
    }
    |
    FormalArgs
;

FormalArgs:
    FormalArg{
    $$ = new declarationlist;
    $$->v.push_back($1);
    }
    |
    FormalArgs SEMICOLON FormalArg{
    $$ = $1;
    $$->v.push_back($3);
    }
;

FormalArg:
    IdList COLON Type{
        $$ = new declaration(@1.first_line,@1.first_column); 
        $$->location.line = @1.first_line;
        $$->location.col = @1.first_column;
        for(size_t i = 0; i < $1->variablevec.size(); i++){
            $1->variablevec[i]->type=$3;
            for(arrit=arr1.begin();arrit!=arr1.end();arrit++){
                $1->variablevec[i]->arr.push_back(std::make_pair((*arrit).first,(*arrit).second));
            }
            arr1.clear();
            $$->vars.push_back($1->variablevec[i]);
        }
    }
;

IdList:
    ID {
    $$ = new variablelist;
    var = new variable(@1.first_line,@1.first_column);
    var->name=$1;
    $$->variablevec.push_back(var);
    }
    |
    IdList COMMA ID{
    $$ = $1;
    var = new variable(@3.first_line,@3.first_column);
    var->name=$3;
    $$->variablevec.push_back(var);
    }
;

ReturnType:
    COLON ScalarType{
    $$ = new Type;
    $$->type=$2;
    }
    |
    Epsilon{
    $$ = new Type;
    $$->type="void";
    }
;

    /*
       Data Types and Declarations
                                   */

Declaration:
    VAR IdList COLON Type SEMICOLON{
        
        $$ = new declaration(@1.first_line, @1.first_column);
        $$->location.line=@1.first_line;
        $$->location.col=@1.first_column;
        for(arrit=arr1.begin();arrit!=arr1.end();arrit++){
        ($$->arr).push_back(std::make_pair((*arrit).first,(*arrit).second));
        }
        v.push_back(std::make_shared<declaration>($$->location.line, $$->location.col));

        for(it = va.begin();it!=va.end();it++){
        v.push_back(std::make_shared<variable>((*it).second.first, (*it).second.second));}
        va.clear();
        
        for(size_t i =0;i<$2->variablevec.size();i++){
            $2->variablevec[i]->type = $4;
            for(arrit=arr1.begin();arrit!=arr1.end();arrit++){
                $2->variablevec[i]->arr.push_back(std::make_pair((*arrit).first,(*arrit).second));
            }
            arr1.clear();
            $$->vars.push_back($2->variablevec[i]);
        }
        
    }
    |VAR IdList COLON LiteralConstant SEMICOLON{
        
        $$ = new declaration(@1.first_line, @1.first_column);
        $$->location.line=@1.first_line;
        $$->location.col=@1.first_column;

        for(arrit=arr1.begin();arrit!=arr1.end();arrit++){
        ($$->arr).push_back(std::make_pair((*arrit).first,(*arrit).second));
        }

        v.push_back(std::make_shared<declaration>($$->location.line, $$->location.col));

        for(it = va.begin();it!=va.end();it++){
        v.push_back(std::make_shared<variable>((*it).second.first, (*it).second.second));}
        va.clear();
        arr1.clear();

        for(size_t i =0;i<$2->variablevec.size();i++){
            $2->variablevec[i]->type = $4->type;
            $2->variablevec[i]->ifconst = TRUE;
            $2->variablevec[i]->constvalue=$4;
            for(arrit=arr1.begin();arrit!=arr1.end();arrit++){
                $2->variablevec[i]->arr.push_back(std::make_pair((*arrit).first,(*arrit).second));
            }
            arr1.clear();
            $$->vars.push_back($2->variablevec[i]);
        }
    }
;

/*TypeOrConstant:
    Type
    |
    LiteralConstant{$$=$1->number;}*/
;

Type:
    ScalarType{$$ = $1;}
    |
    ArrType{$$ = $1;}
;

ScalarType:
    INTEGER{$$ = $1;}
    |
    REAL{$$ = $1;}
    |
    STRING{$$ = $1;}
    |
    BOOLEAN{$$ = $1;}
;

ArrType:
    ArrDecl ScalarType{ 
    $$=$2; 
    }
;

ArrDecl:
    ARRAY INT_LITERAL TO INT_LITERAL OF {arr1.push_back(std::make_pair(std::stoi($2),std::stoi($4)));}
    |
    ArrDecl ARRAY INT_LITERAL TO INT_LITERAL OF{arr1.push_back(std::make_pair(std::stoi($3),std::stoi($5)));}
;

LiteralConstant:
    INT_LITERAL{
    $$ = new litconst(@1.first_line,@1.first_column);
    $$->value=std::string($1);
    $$->type="integer";
    }
    |
    REAL_LITERAL{
    $$ = new litconst(@1.first_line,@1.first_column);
    $$->value=std::string($1);
    $$->type="real";
    }
    |
    STRING_LITERAL{
    $$ = new litconst(@1.first_line,@1.first_column);
    $$->value=std::string($1);
    $$->type="string";
    }
    |
    TRUE{
    $$ = new litconst(@1.first_line,@1.first_column);
    $$->value="true";
    $$->type="boolean";
    }
    |
    FALSE{
    $$ = new litconst(@1.first_line,@1.first_column);
    $$->value="false";
    $$->type="boolean";
    }
;

    /*
    INT_LITERAL{$$->number = $1;int1.push_back($$);}
    |
    REAL_LITERAL{$$->realnumber=$1,con.push_back($$);}
    |
    STRING_LITERAL{$$->string=$1;con.push_back($$);}
    |
    TRUE{$$->yesorno=$1;con.push_back($$);}
    |
    FALSE{$$->yesorno=$1;con.push_back($$);}
       Statements
                  */

Statement:
    CompoundStatement{
    $$=(statement*)$1;
    }
    |
    Simple{
    $$=(statement*)$1;
    }
    |
    Condition{
    $$=(statement*)$1;
    }
    |
    While{
    $$=(statement*)$1;
    }
    |
    For{
    $$=(statement*)$1;
    }
    |
    Return{
    $$=(statement*)$1;
    }
    |
    FunctionInvokation{
    $$=(statement*)$1;
    }
;

CompoundStatement:
    BEGIN_
    DeclarationList
    StatementList
    END
    {
        $$ = CS = new compoundstatement(@1.first_line, @1.first_column);
        $$->location.line=@1.first_line;
        $$->location.col=@1.first_column;
        v.push_back(std::make_shared<compoundstatement>($$->location.line, $$->location.col));
        for(size_t i =0;i<$2->v.size();i++){
            $$->lgandconstantdec.push_back($2->v[i]);
        }
        for(size_t i =0;i<$3->statementvec.size();i++){
            $$->stats.push_back($3->statementvec[i]);
        }
    }
;

Simple:
    VariableReference ASSIGN Expression SEMICOLON{
    AssignmentNode *a;
    a = new AssignmentNode(@2.first_line,@2.first_column);
    a->Lvalue= $1;
    a->expr = $3;
    a->location.line = @2.first_line;
    a->location.col = @2.first_column;
    $$ = (statement*)a;
    }
    |
    PRINT Expression SEMICOLON{
    PrintNode* print; 
    print = new PrintNode(@1.first_line,@1.first_column);
    print->Target = $2;
    print->location.line = @1.first_line;
    print->location.col = @1.first_column;
    $$ = (statement*)print;
    }
    |
    READ VariableReference SEMICOLON{
    ReadNode* read; 
    read = new ReadNode(@1.first_line,@1.first_column);
    read->Target = $2;
    read->location.line = @1.first_line;
    read->location.col = @1.first_column;
    $$ = (statement*)read;
    }
;

VariableReference:
    ID{
    $$ = new varReference(@1.first_line,@1.first_column);
    $$->name = $1;
    $$->location.line = @1.first_line;
    $$->location.col = @1.first_column;
    }
    |
    ID ArrForm{
    $$ = new varReference(@1.first_line,@1.first_column);
    $$->name = $1;
    for(size_t i =0;i<$2->opvec.size();i++){
        $$->opvec.push_back($2->opvec[i]);
    }
    $$->location.line = @1.first_line;
    $$->location.col = @1.first_column;
    }
;

ArrForm:
    L_BRACKET Expression R_BRACKET{
    $$ = new oplist;
    $$->opvec.push_back($2);
    }
    |
    ArrForm L_BRACKET Expression R_BRACKET{
    $$ = $1;
    $$->opvec.push_back($3);
    }
;

Condition:
    IF Expression THEN
    StatementList
    ElseOrNot
    END IF{
    $$ = new IfNode(@1.first_line,@1.first_column);
    $$->condition = $2;

    for(size_t i =0;i<$4->statementvec.size();i++){
        $$->body.push_back($4->statementvec[i]);
    }
    for(size_t i =0;i<$5->statementvec.size();i++){
        $$->Elsebody.push_back($5->statementvec[i]);
    }
    
    $$->location.line = @1.first_line;
    $$->location.col = @1.first_column;
    }
;

ElseOrNot:
    ELSE
    StatementList{
    $$ =$2;
    }
    |
    Epsilon{
    $$ = new statementlist;
    }
;

While:
    WHILE Expression DO
    StatementList
    END DO{
    $$ = new WhileNode(@1.first_line,@1.first_column);
    $$->condition = $2;
    for(size_t i =0;i<$4->statementvec.size();i++){
        $$->body.push_back($4->statementvec[i]);
    }
    }

For:
    FOR ID ASSIGN INT_LITERAL TO INT_LITERAL DO
    StatementList
    END DO{
    /*Loop variable declaration*/
    variable *va = new variable(@2.first_line,@2.first_column);
    va->name = $2;
    va->type = "integer";
    va->location.line=@2.first_line;
    va->location.col=@2.first_column;
    declaration *dec = new declaration(@2.first_line,@2.first_column);
    dec->vars.push_back(va);
    dec->location.line=@2.first_line;
    dec->location.col=@2.first_column;
    /*Initial statement*/
    varReference *vr = new varReference(@2.first_line,@2.first_column);
    vr->name=$2;
    vr->location.line=@2.first_line;
    vr->location.col=@2.first_column;
    litconst *con = new litconst(@4.first_line,@4.first_column);
    con->value=std::string($4);
    con->type="integer";
    con->location.line=@4.first_line;
    con->location.col=@4.first_column;
    AssignmentNode *assign = new AssignmentNode(@3.first_line,@3.first_column);
    assign->Lvalue=vr;
    assign->expr=con;
    assign->location.line=@3.first_line;
    assign->location.col=@3.first_column;
    /*Condition*/
    litconst *co = new litconst(@6.first_line,@6.first_column);
    co->value=$6;
    co->type="integer";
    co->location.line=@6.first_line;
    co->location.col=@6.first_column;
    /*body*/
    $$ = new ForNode(@1.first_line,@1.first_column);
    $$->loopdecls=dec;
    $$->initialstatement=assign;
    $$->condition=co;
    for(size_t i =0;i<$8->statementvec.size();i++){
        $$->body.push_back($8->statementvec[i]);
    }
    $$->location.line=@1.first_line;
    $$->location.col=@1.first_column;

    }
;

Return:
    RETURN Expression SEMICOLON{
        $$ = new ReturnNode(@1.first_line,@1.first_column);
        $$->returnvalue = $2;
        $$->location.line = @1.first_line;
        $$->location.col = @1.first_column;
    }
;

FunctionInvokation:
    FunctionCall SEMICOLON
;

FunctionCall:
    ID L_PARENTHESIS ExpressionList R_PARENTHESIS{
        $$ = new functioncall(@1.first_line,@1.first_column);
        $$->name = $1;
        for(size_t i =0;i<$3->opvec.size();i++){
            $$->argument.push_back($3->opvec[i]);
        }
        $$->line = @1.first_line;
        $$->col = @1.first_column;
    }
;

ExpressionList:
    Epsilon{
    $$ = new oplist;
    }
    |
    Expressions
;

Expressions:
    Expression{
    $$ = new oplist;
    $$->opvec.push_back($1);
    }
    |
    Expressions COMMA Expression{
    $$ = $1;
    $$->opvec.push_back($3);
    }
;

StatementList:
    Epsilon{
    $$ = new statementlist;
    }
    |
    Statements
;

Statements:
    Statement{
    $$ = new statementlist;
    $$->statementvec.push_back($1);
    }
    |
    Statements Statement{
    $$ = $1;
    $$->statementvec.push_back($2);
    }
;

Expression:
    L_PARENTHESIS Expression R_PARENTHESIS{
    $$ = $2;
    }
    |
    MINUS Expression %prec UNARY_MINUS{
    unaryop* uop = new unaryop(@1.first_line,@1.first_column);
    uop->name = "neg";
    uop->right=$2;
    uop->location.line=@1.first_line;
    uop->location.col=@1.first_column;
    $$=(Operator*)uop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    $$->location.line=@1.first_line;
    $$->location.col=@1.first_column;
    v.push_back(std::make_shared<unaryop>($$->location.line, $$->location.col));
    }
    |
    Expression MULTIPLY Expression{
    binaryop* bop = new binaryop(@2.first_line,@2.first_column);
    bop->name = $2;
    bop->left=$1;
    bop->right=$3;
    bop->location.line=@2.first_line;
    bop->location.col=@2.first_column;
    $$=(Operator*)bop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    }
    |
    Expression DIVIDE Expression{
    binaryop* bop = new binaryop(@2.first_line,@2.first_column);
    bop->name = $2;
    bop->left=$1;
    bop->right=$3;
    bop->location.line=@2.first_line;
    bop->location.col=@2.first_column;
    $$=(Operator*)bop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    }
    |
    Expression MOD Expression{
    binaryop* bop = new binaryop(@2.first_line,@2.first_column);
    bop->name = $2;
    bop->left=$1;
    bop->right=$3;
    bop->location.line=@2.first_line;
    bop->location.col=@2.first_column;
    $$=(Operator*)bop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    }
    |
    Expression PLUS Expression{
    binaryop* bop = new binaryop(@2.first_line,@2.first_column);
    bop->name = $2;
    bop->left=$1;
    bop->right=$3;
    bop->location.line=@2.first_line;
    bop->location.col=@2.first_column;
    $$=(Operator*)bop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    }
    |
    Expression MINUS Expression{
    binaryop* bop = new binaryop(@2.first_line,@2.first_column);
    bop->name = $2;
    bop->left=$1;
    bop->right=$3;
    bop->location.line=@2.first_line;
    bop->location.col=@2.first_column;
    $$=(Operator*)bop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    }
    |
    Expression LESS Expression{
    binaryop* bop = new binaryop(@2.first_line,@2.first_column);
    bop->name = $2;
    bop->left=$1;
    bop->right=$3;
    bop->location.line=@2.first_line;
    bop->location.col=@2.first_column;
    $$=(Operator*)bop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    }
    |
    Expression LESS_OR_EQUAL Expression{
    binaryop* bop = new binaryop(@2.first_line,@2.first_column);
    bop->name = $2;
    bop->left=$1;
    bop->right=$3;
    bop->location.line=@2.first_line;
    bop->location.col=@2.first_column;
    $$=(Operator*)bop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    }
    |
    Expression GREATER Expression{
    binaryop* bop = new binaryop(@2.first_line,@2.first_column);
    bop->name = $2;
    bop->left=$1;
    bop->right=$3;
    bop->location.line=@2.first_line;
    bop->location.col=@2.first_column;
    $$=(Operator*)bop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    }
    |
    Expression GREATER_OR_EQUAL Expression{
    binaryop* bop = new binaryop(@2.first_line,@2.first_column);
    bop->name = $2;
    bop->left=$1;
    bop->right=$3;
    bop->location.line=@2.first_line;
    bop->location.col=@2.first_column;
    $$=(Operator*)bop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    }
    |
    Expression EQUAL Expression{
    binaryop* bop = new binaryop(@2.first_line,@2.first_column);
    bop->name = $2;
    bop->left=$1;
    bop->right=$3;
    bop->location.line=@2.first_line;
    bop->location.col=@2.first_column;
    $$=(Operator*)bop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    }
    |
    Expression NOT_EQUAL Expression{
    binaryop* bop = new binaryop(@2.first_line,@2.first_column);
    bop->name = $2;
    bop->left=$1;
    bop->right=$3;
    bop->location.line=@2.first_line;
    bop->location.col=@2.first_column;
    $$=(Operator*)bop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    }
    |
    NOT Expression{
    unaryop* uop = new unaryop(@1.first_line,@1.first_column);
    uop->name = "not";
    uop->right=$2;
    uop->location.line=@1.first_line;
    uop->location.col=@1.first_column;
    $$=(Operator*)uop;
    v.push_back(std::make_shared<unaryop>(@1.first_line, @1.first_column));
    }
    |
    Expression AND Expression{
    binaryop* bop = new binaryop(@2.first_line,@2.first_column);
    bop->name = $2;
    bop->left=$1;
    bop->right=$3;
    bop->location.line=@2.first_line;
    bop->location.col=@2.first_column;
    $$=(Operator*)bop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    }
    |
    Expression OR Expression{
    binaryop* bop = new binaryop(@2.first_line,@2.first_column);
    bop->name = $2;
    bop->left=$1;
    bop->right=$3;
    bop->location.line=@2.first_line;
    bop->location.col=@2.first_column;
    $$=(Operator*)bop;
    v.push_back(std::make_shared<binaryop>(@2.first_line, @2.first_column));
    }
    |
    LiteralConstant{
    $$=(Operator*)$1;
    }
    |
    VariableReference{
    $$=(Operator*)$1;
    }
    |
    FunctionCall{
    $$=(Operator*)$1;
    }
;

    /*
       misc
            */
Epsilon:
;
%%

void yyerror(const char *msg) {
    fprintf(stderr,
            "\n"
            "|-----------------------------------------------------------------"
            "---------\n"
            "| Error found in Line #%d: %s\n"
            "|\n"
            "| Unmatched token: %s\n"
            "|-----------------------------------------------------------------"
            "---------\n",
            LineNum, Buffer, yytext);
    exit(-1);
}

int main(int argc, const char *argv[]) {
    /*CHECK(argc == 2, "Usage: ./parser <filename>\n");*/
 
    FILE *fp = fopen(argv[1], "r");

    CHECK(fp != NULL, "fopen() fails.\n");
    yyin = fp;
    yyparse();

    //freeProgramNode(root);
    DumpVisitor dvisitor;
    root->accept(dvisitor,1);
/*    for (size_t i = 0; i<=v.size()-1 ; i++)
    v[i]->accept(dvisitor,1);*/
/*
    for(iter=dec.begin();iter!=dec.end();iter++){
        (*iter)->accept(dvisitor);
    
    }
    for(it=f.begin();it!=f.end();it++){
        (*it)->accept(dvisitor);
    }
    if(CS!=NULL){
    CS->accept(dvisitor);
    }*/
    /*std::cout << "CPP works!" << std::endl;*/
    printf("\n"
           "|--------------------------------|\n"
           "|  There is no syntactic error!  |\n"
           "|--------------------------------|\n");
    return 0;
}
