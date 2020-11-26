#pragma once
#include <string>
#include <vector>
#include "AST/ast.hpp"
#include "AST/compoundstatement.hpp"
#include "AST/declarationlist.hpp"

class ASTNodeVisitorBase;

class function : public ASTNodeBase
{
public:
 
  char *name;
  std::vector<declaration*> Parameter;
  Type* returntype;
  compoundstatement *body;

  function(uint32_t line, uint32_t col);
  void printNode();
  ~function();
  void accept(ASTNodeVisitorBase &v,size_t level);
};

class functionlist{
public:
  std::vector<function*> funvec;
};