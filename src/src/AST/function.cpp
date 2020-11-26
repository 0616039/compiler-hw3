#include <iostream>
#include <vector>
#include "AST/variable.hpp"
#include "visitor/visitor.hpp"

using namespace std;
// std::vector<std::pair<int,int> >  varr;
function::function(uint32_t line, uint32_t col): ASTNodeBase(line,col){
}

void function::printNode(){

	cout <<"function declaration <line: " << location.line<<", col: "<< location.col << "> "<< name<<" "<<returntype->type;
	cout << " (";
		if (Parameter.size()>0) {
			for (size_t i = 0; i < Parameter.size(); i++) {
				for (size_t j = 0; j < Parameter[i]->vars.size(); j++) {
					if(i!=0||j!=0)
					std::cout << ", ";
					cout << Parameter[i]->vars[j]->type;
					if (Parameter[i]->vars[j]->arr.size()>0) {
						for (size_t k = 0; k < Parameter[i]->vars[j]->arr.size(); k++) {
							int f = Parameter[i]->vars[j]->arr[k].first;
							int s = Parameter[i]->vars[j]->arr[k].second;
							cout << "[" << s-f << "]";
						}
					}
				}
			}
		}
		cout << ")";
		cout << endl;
}

function::~function(){
    ;
}

void function::accept(ASTNodeVisitorBase &v, size_t level){
    v.visit(this,level);
}
