#pragma once
#include <cstdint>
#include <string>
#include <iostream>
#include <vector>
class ASTNodeVisitorBase;

struct Location
{
  uint32_t line;
  uint32_t col;
  Location(uint32_t line, uint32_t col) : line(line), col(col){};
};



struct array
{
  std::vector<std::pair<int,int> >  arr;
  array(std::vector<std::pair<int,int> >  arr) : arr(arr){};
};


class ASTNodeBase
{
public:
  Location location;
  ASTNodeBase(int32_t line, int32_t col) : location(line, col){};
  virtual ~ASTNodeBase(){};
  virtual void printNode();
  virtual void accept(ASTNodeVisitorBase &v,size_t level) = 0;
};


class Type {
public:
  char* type;
};