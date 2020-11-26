#pragma once
#include <string>
#include "AST/ast.hpp"
#include "AST/declarationlist.hpp"
#include "AST/statement.hpp"
#include "AST/compoundstatement.hpp"
#include "AST/function.hpp"
class ASTNodeVisitorBase;

class ProgramNode : public ASTNodeBase
{
public:
  std::vector<declaration*> gvandconstdec;
  std::vector<function*> fundec;
  compoundstatement* body;
  char *name;
  ProgramNode(uint32_t line, uint32_t col);
  void printNode();
  ~ProgramNode();
  void accept(ASTNodeVisitorBase &v,size_t level);
};