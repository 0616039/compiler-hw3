#pragma once
#include <string>
#include "AST/ast.hpp"
#include "AST/variable.hpp"
#include "AST/statement.hpp"
#include "AST/compoundstatement.hpp"
#include "AST/declarationlist.hpp"
#include "AST/binaryop.hpp"



class ASTNodeVisitorBase;

class statement : public ASTNodeBase
{
public:
	statement(uint32_t line, uint32_t col);
};
class compoundstatement : public statement
{
public:
  // std::string name;
  std::string type;
  declaration* dl;
  std::vector<declaration*> lgandconstantdec;  
  std::vector<class statement*> stats;  

  compoundstatement(uint32_t line, uint32_t col);
  void printNode();
  ~compoundstatement();
  void accept(ASTNodeVisitorBase &v,size_t level);
};
class AssignmentNode :public statement {
public:
	varReference* Lvalue;
	Operator* expr;
	AssignmentNode(uint32_t line, uint32_t col);
	void accept(ASTNodeVisitorBase &v, size_t level);
	~AssignmentNode();
	void printNode();
};

class PrintNode :public statement {
public:
	Operator* Target;
	PrintNode(uint32_t line, uint32_t col);
	void accept(ASTNodeVisitorBase &v, size_t level);
	~PrintNode();
	void printNode();
};

class ReadNode :public statement {
public:
	varReference* Target;
	ReadNode(uint32_t line, uint32_t col);
	void accept(ASTNodeVisitorBase &v, size_t level);
	~ReadNode();
	void printNode() ;
};

class IfNode :public statement {
public:
	Operator* condition;
	std::vector<statement*> body;
	std::vector<statement*> Elsebody;
	IfNode(uint32_t line, uint32_t col);
	void accept(ASTNodeVisitorBase &v, size_t level);
	~IfNode();
	void printNode();
};

class WhileNode :public statement {
public:
	Operator* condition;
	std::vector<statement*> body;
	WhileNode(uint32_t line, uint32_t col);
	void accept(ASTNodeVisitorBase &v, size_t level);
	~WhileNode();
	void printNode();
};

class ForNode :public statement {
public:
	declaration* loopdecls;
	AssignmentNode* initialstatement;
	Operator* condition;
	std::vector<statement*> body;
	ForNode(uint32_t line, uint32_t col);
	void accept(ASTNodeVisitorBase &v, size_t level);
	~ForNode();
	void printNode();
};
class ReturnNode : public statement {
public:
	Operator* returnvalue;
	ReturnNode(uint32_t line, uint32_t col);
	void printNode();
	~ReturnNode();
	void accept(ASTNodeVisitorBase &v, size_t level);
};

class functioncall : public statement,public Operator{
public:
  char *name;
  uint32_t line;
  uint32_t col;
  std::vector<Operator*> argument;
  functioncall(uint32_t line, uint32_t col);
  void printNode();
  ~functioncall();
  void accept(ASTNodeVisitorBase &v, size_t level);
};

class statementlist
{
public:
	std::vector<statement*> statementvec;
};