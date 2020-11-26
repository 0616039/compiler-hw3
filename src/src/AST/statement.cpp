#include <iostream>
#include "AST/statement.hpp"
#include "visitor/visitor.hpp"
#include "AST/binaryop.hpp"

using namespace std;
std::vector<std::pair<int,int> >  sarr;


statement::statement(uint32_t line, uint32_t col): ASTNodeBase(line,col){
}


compoundstatement::compoundstatement(uint32_t line, uint32_t col): statement(line,col){
}

void compoundstatement::printNode(){
    cout <<"compound statement <line: " << location.line<<", col: "<< location.col << ">"<< endl;
}

compoundstatement::~compoundstatement(){
    ;
}

void compoundstatement::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this, level);
}

AssignmentNode::AssignmentNode(uint32_t line, uint32_t col): statement(line,col){
}

void AssignmentNode::printNode(){
    cout <<"assignment statement <line: " << location.line<<", col: "<< location.col << ">"<< endl;
}

AssignmentNode::~AssignmentNode(){
    ;
}

void AssignmentNode::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this, level);
}

PrintNode::PrintNode(uint32_t line, uint32_t col): statement(line,col){
}

void PrintNode::printNode(){
    cout <<"print statement <line: " << location.line<<", col: "<< location.col << ">"<< endl;
}

PrintNode::~PrintNode(){
    ;
}

void PrintNode::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this, level);
}

ReadNode::ReadNode(uint32_t line, uint32_t col): statement(line,col){
}

void ReadNode::printNode(){
    cout <<"read statement <line: " << location.line<<", col: "<< location.col << ">"<< endl;
}

ReadNode::~ReadNode(){
    ;
}

void ReadNode::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this, level);
}

IfNode::IfNode(uint32_t line, uint32_t col): statement(line,col){
}

void IfNode::printNode(){
    cout <<"if statement <line: " << location.line<<", col: "<< location.col << ">"<< endl;
}

IfNode::~IfNode(){
    ;
}

void IfNode::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this, level);
}

WhileNode::WhileNode(uint32_t line, uint32_t col): statement(line,col){
}

void WhileNode::printNode(){
    cout <<"while statement <line: " << location.line<<", col: "<< location.col << ">"<< endl;
}

WhileNode::~WhileNode(){
    ;
}

void WhileNode::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this, level);
}

ForNode::ForNode(uint32_t line, uint32_t col): statement(line,col){
}

void ForNode::printNode(){
    cout <<"for statement <line: " << location.line<<", col: "<< location.col << ">"<< endl;
}

ForNode::~ForNode(){
    ;
}

void ForNode::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this, level);
}

ReturnNode::ReturnNode(uint32_t line, uint32_t col): statement(line,col){
}

void ReturnNode::printNode(){
    cout <<"return statement <line: " << location.line<<", col: "<< location.col << ">"<< endl;
}

ReturnNode::~ReturnNode(){
    ;
}

void ReturnNode::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this, level);
}


functioncall::functioncall(uint32_t line, uint32_t col): statement(line,col),Operator(line,col){
}

void functioncall::printNode(){
	cout << "function call statement <line: " << line << ", col: " << col << "> "<<name<<"\n";
}

functioncall::~functioncall(){
    ;
}

void functioncall::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this,level);
}