#include <iostream>
#include "AST/binaryop.hpp"
#include "visitor/visitor.hpp"

using namespace std;
std::vector<std::pair<int,int> >  biarr;
Operator::Operator(uint32_t line, uint32_t col) : ASTNodeBase(line,col){
};

binaryop::binaryop(uint32_t line, uint32_t col): Operator(line,col){
}

void binaryop::printNode(){
    cout <<"binary operator <line: " << location.line<<", col: "<< location.col << "> "<< name << "\n";
}

binaryop::~binaryop(){
    ;
}

void binaryop::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this,level);
}

unaryop::unaryop(uint32_t line, uint32_t col): Operator(line,col){
}

void unaryop::printNode(){
    cout <<"unary operator <line: " << location.line<<", col: "<< location.col << "> "<< name << endl;
}

unaryop::~unaryop(){
    ;
}

void unaryop::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this,level);
}

varReference::varReference(uint32_t line, uint32_t col): Operator(line,col){
}

void varReference::printNode(){
		std::cout << "variable reference <line: " << location.line << ", col: " << location.col << "> "<<name<<"\n";
}

varReference::~varReference(){
    ;
}

void varReference::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this,level);
}

litconst::litconst(uint32_t line, uint32_t col): Operator(line,col){
}

void litconst::printNode(){
    cout <<"constant <line: " << location.line <<", col: "<< location.col << "> ";
    if(std::string(type)=="string"){
        cout<<"\""<< value << "\""<< endl;
    }
    else{
        cout << value << endl;
    }
   
}

litconst::~litconst(){
    ;
}

void litconst::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this,level);
}
