#pragma once
#include "AST/ast.hpp"
#include "AST/program.hpp"
#include "AST/declarationlist.hpp"
#include "AST/compoundstatement.hpp"
#include "AST/variable.hpp"
#include "AST/binaryop.hpp"
#include "AST/statement.hpp"

class ASTNodeVisitorBase
{
public:
    virtual void visit(ProgramNode *e, size_t level) = 0;
    virtual void visit(declaration *e, size_t level) = 0;
    virtual void visit(compoundstatement *e, size_t level) = 0;
    virtual void visit(variable *e, size_t level) = 0;
    virtual void visit(binaryop *e, size_t level) = 0;
    virtual void visit(litconst *e, size_t level) = 0;
    virtual void visit(unaryop *e, size_t level) = 0;
    virtual void visit(function *e, size_t level) = 0;
    virtual void visit(varReference *e, size_t level) = 0;
    virtual void visit(AssignmentNode *e, size_t level) = 0;
    virtual void visit(PrintNode *e, size_t level) = 0;
    virtual void visit(ReadNode *e, size_t level) = 0;
    virtual void visit(IfNode *e, size_t level) = 0;
    virtual void visit(WhileNode *e, size_t level) = 0;
    virtual void visit(ForNode *e, size_t level) = 0;
    virtual void visit(ReturnNode *e, size_t level) = 0;
    virtual void visit(functioncall *e, size_t level) = 0;
};