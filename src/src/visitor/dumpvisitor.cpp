#include "visitor/dumpvisitor.hpp"

void DumpVisitor::visit(ProgramNode *e, size_t level)
{
    e->printNode();

    for(size_t i = 0; i < e->gvandconstdec.size();i++){
        for(int j = 0; j < level; j++){
            std::cout<<"  ";
            e->gvandconstdec[i]->accept(*this,level+1);
        }
    }
    for(size_t i = 0; i < e->fundec.size();i++){
        for(int j = 0; j < level; j++){
            std::cout<<"  ";
            e->fundec[i]->accept(*this,level+1);
        }
    }
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->body->accept(*this,level+1);
}
void DumpVisitor::visit(declaration *e, size_t level)
{
    e->printNode();
    for (size_t i = 0; i < e->vars.size(); ++i) {
        for(int j = 0; j < level; j++){
            std::cout<<"  ";
        }    
        e->vars[i]->accept(*this, level + 1);
    }
}
void DumpVisitor::visit(compoundstatement *e, size_t level)
{   
	e->printNode();   	
    for (size_t i = 0; i < e->lgandconstantdec.size(); ++i) {
        for(int j = 0; j < level; j++){
            std::cout<<"  ";
        } 
        e->lgandconstantdec[i]->accept(*this, level + 1);
    }
    for (size_t i = 0; i < e->stats.size(); ++i) {
        for(int j = 0; j < level; j++){
            std::cout<<"  ";
        } 
        e->stats[i]->accept(*this, level + 1);
    }
}

void DumpVisitor::visit(variable *e, size_t level)
{
    e->printNode();   	
    if(e->ifconst){
        for(int j = 0; j < level; j++){
            std::cout<<"  ";
        }
        e->constvalue->accept(*this,level+1);
    }
}

void DumpVisitor::visit(binaryop *e, size_t level)
{
    e->printNode();  
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->left->accept(*this,level+1);
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->right->accept(*this,level+1);

}
void DumpVisitor::visit(litconst *e, size_t level)
{
	e->printNode();   	
}

void DumpVisitor::visit(unaryop *e, size_t level)
{
    e->printNode();   
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->right->accept(*this,level+1);
}


void DumpVisitor::visit(function *e, size_t level)
{
    e->printNode();   
    for(size_t i = 0; i < e->Parameter.size(); i++){
        for(int j = 0; j < level; j++){
            std::cout<<"  ";
        }
        //std::cout<< e->Parameter.size();
        e->Parameter[i]->accept(*this,level+1);    
    }   
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->body->accept(*this,level+1); 

}

void DumpVisitor::visit(varReference *e, size_t level)
{
    e->printNode();       
    for (size_t i = 0; i < e->opvec.size(); ++i) {
        for(int j = 0; j < level-1; j++){
            std::cout<<"  ";
        }
        std::cout << "[\n";
        for(int j = 0; j < level; j++){
            std::cout<<"  ";
        }
        e->opvec[i]->accept(*this, level + 1);
        for(int j = 0; j < level-1; j++){
            std::cout<<"  ";
        }
        std::cout << "]\n";
    }
}
void DumpVisitor::visit(AssignmentNode *e, size_t level)
{
    e->printNode();   
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->Lvalue->accept(*this,level+1);
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->expr->accept(*this,level+1);    
}

void DumpVisitor::visit(PrintNode *e, size_t level)
{
    e->printNode();  
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->Target->accept(*this,level+1);     
}

void DumpVisitor::visit(ReadNode *e, size_t level)
{
    e->printNode();       
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->Target->accept(*this,level+1);
}

void DumpVisitor::visit(IfNode *e, size_t level)
{
    e->printNode();       
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->condition->accept(*this,level+1);
    for (size_t i = 0; i < e->body.size(); i++) {
        for(int j = 0; j < level; j++){
            std::cout<<"  ";
        }
        e->body[i]->accept(*this, level + 1);
    }
    if (e->Elsebody.size()>0) {
        for(int j = 0; j < level-1; j++){
        std::cout<<"  ";
        }
        std::cout << "else\n";
        for (size_t i = 0; i < e->Elsebody.size(); i++) {
            for(int j = 0; j < level; j++){
                std::cout<<"  ";
            }
            e->Elsebody[i]->accept(*this, level + 1);
        }
    }

}

void DumpVisitor::visit(WhileNode *e, size_t level)
{
    e->printNode();
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->condition->accept(*this,level+1);
    for(size_t i = 0; i < e->body.size(); i++){
        for(int j = 0; j < level; j++){
            std::cout<<"  ";
        }
        e->body[i]->accept(*this,level+1);
    }       
}

void DumpVisitor::visit(ForNode *e, size_t level)
{
    e->printNode();
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->loopdecls->accept(*this,level+1);
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->initialstatement->accept(*this,level+1);
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->condition->accept(*this,level+1);
    for(size_t i = 0; i < e->body.size(); i++){
        for(int j = 0; j < level; j++){
            std::cout<<"  ";
        }
        e->body[i]->accept(*this,level+1);
    }  

}

void DumpVisitor::visit(ReturnNode *e, size_t level)
{
    e->printNode();
    for(int j = 0; j < level; j++){
        std::cout<<"  ";
    }
    e->returnvalue->accept(*this,level+1); 

}

void DumpVisitor::visit(functioncall *e, size_t level)
{
    e->printNode();
    for(size_t i = 0; i < e->argument.size(); i++){
        for(int j = 0; j < level; j++){
            std::cout<<"  ";
        }
        e->argument[i]->accept(*this,level+1);
    }
}
