#include <iostream>
#include "AST/declarationlist.hpp"
#include "visitor/visitor.hpp"

using namespace std;
std::vector<std::pair<int,int> >  darr;

declaration::declaration(uint32_t line, uint32_t col): ASTNodeBase(line,col){
}

void declaration::printNode(){
    cout << "declaration <line: " << location.line<<", col: "<< location.col << "> "<< endl;
}

declaration::~declaration(){
    ;
}

void declaration::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this,level);
}
