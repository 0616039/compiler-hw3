#pragma once
#include <string>
#include <vector>
#include "AST/ast.hpp"
#include "AST/binaryop.hpp"

class ASTNodeVisitorBase;

class variable : public ASTNodeBase
{
public:
  std::vector<std::pair<int,int> >   arr;
  std::vector<std::pair<int,int> > ::iterator arrit;
  // std::string name;
  // std::string type;
  char *name;
  char *type;
  bool ifconst = false;
  litconst* constvalue;
  variable(uint32_t line, uint32_t col);
  void printNode();
  ~variable();
  void accept(ASTNodeVisitorBase &v,size_t level);
};

class variablelist{
public:
	std::vector<variable*> variablevec;
};