#include <iostream>
#include "AST/program.hpp"
#include "visitor/visitor.hpp"
#include <vector>
using namespace std;

std::vector<std::pair<int,int> >  arr;
ProgramNode::ProgramNode(uint32_t line, uint32_t col): ASTNodeBase(line,col){
}

void ProgramNode::printNode(){
    cout << "program <line: " << location.line<<", col: "<< location.col << "> " << name << " void"<< endl;
}

ProgramNode::~ProgramNode(){
    ;
}

void ProgramNode::accept(ASTNodeVisitorBase &v,size_t level){
    v.visit(this,level);
  
}
