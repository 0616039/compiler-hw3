#pragma once
#include <string>
#include "AST/ast.hpp"
#include "AST/variable.hpp"


class ASTNodeVisitorBase;

class declaration : public ASTNodeBase
{
public:
  //std::string name;
  // std::string type;
  // // variable var;
  std::vector<std::pair<int,int> >  arr;
  std::vector<std::pair<int,int> > ::iterator arrit;
  std::vector<declaration*> v;
  std::vector<variable*> vars;
  declaration(uint32_t line, uint32_t col);
  void printNode();
  ~declaration();
  void accept(ASTNodeVisitorBase &v, size_t level);
};

class declarationlist {
public:
	std::vector<declaration*> v;
};