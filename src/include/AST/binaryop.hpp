#pragma once
#include <string>
#include "AST/ast.hpp"
#include "AST/binaryop.hpp"


class ASTNodeVisitorBase;

class Operator : public ASTNodeBase{
public:
  char *name;
  Operator(uint32_t line, uint32_t col);
};
class binaryop : public Operator
{
public:
  // std::string name;
  // std::string type;
  char *name;
  Operator* left;
  Operator* right;
  binaryop(uint32_t line, uint32_t col);
  void printNode();
  ~binaryop();
  void accept(ASTNodeVisitorBase &v, size_t level);
};
class unaryop : public Operator
{
public:
  // std::string name;
  // std::string type;
  char *name;
  Operator* right;
  int cons;
  unaryop(uint32_t line, uint32_t col);
  void printNode();
  ~unaryop();
  void accept(ASTNodeVisitorBase &v, size_t level);
};

class litconst : public Operator
{
public:
  // std::string name;
  // std::string type;
  std::string value;
  char* type;
  litconst(uint32_t line, uint32_t col);
  void printNode();
  ~litconst();
  void accept(ASTNodeVisitorBase &v, size_t level);
};

class varReference :public Operator {
public:
  char *name;
  std::vector<Operator*> opvec;
  varReference(uint32_t line, uint32_t col);
  void printNode();
  ~varReference();
  void accept(ASTNodeVisitorBase &v, size_t level); 
  
};

class oplist{
public:
  std::vector<Operator*> opvec;
};

