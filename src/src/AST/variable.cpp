#include <iostream>
#include <vector>
#include "AST/variable.hpp"
#include "visitor/visitor.hpp"

using namespace std;
// std::vector<std::pair<int,int> >  varr;
std::vector<std::pair<int,int> > ::iterator arriter;
variable::variable(uint32_t line, uint32_t col): ASTNodeBase(line,col){
}

void variable::printNode(){

	cout <<"variable <line: " << location.line<<", col: "<< location.col << "> "<< name<< " "<<type;

	for(arriter = arr.begin();arriter!=arr.end();arriter++){
    	cout<<"["<<(*arriter).first<<"..."<<(*arriter).second<<"]";
    }
    arr.clear();
    cout<<endl;
}

variable::~variable(){
    ;
}

void variable::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this,level);
}
