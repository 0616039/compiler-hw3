#pragma once
#include "visitor/visitor.hpp"

class DumpVisitor : public ASTNodeVisitorBase
{
public:
    void visit(ProgramNode *e,size_t level) override;
    void visit(declaration *e, size_t level) override;
    void visit(compoundstatement *e, size_t level) override;
    void visit(variable *e, size_t level) override;
    // void visit(Operator *e, size_t level) override;
    void visit(binaryop *e, size_t level) override;
    void visit(litconst *e, size_t level) override;
    void visit(unaryop *e, size_t level) override;
    // void visit(statement *e, size_t level) override;
    void visit(function *e, size_t level) override;
    void visit(varReference *e, size_t level) override;
    void visit(AssignmentNode *e, size_t level) override;
	void visit(PrintNode *e, size_t level) override;
	void visit(ReadNode *e, size_t level) override;
	void visit(IfNode *e, size_t level) override;
	void visit(WhileNode *e, size_t level) override;
	void visit(ForNode *e, size_t level) override;
	void visit(ReturnNode *e, size_t level) override;
	void visit(functioncall *e, size_t level) override;
};