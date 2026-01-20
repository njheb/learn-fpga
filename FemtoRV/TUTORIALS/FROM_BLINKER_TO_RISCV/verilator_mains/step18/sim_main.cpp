#include "VSOC.h"
#include "verilated.h"
#include <iostream>

int main(int argc, char** argv, char** env) {
   VSOC top;
   top.CLK = 0;
   while(!Verilated::gotFinish()) {
      top.CLK = !top.CLK;
      top.eval();
   }
   return 0;
}

/*
Then to compile the C++ and run the generated program:
  $ cd obj_dir
  $ make -f VSOC.mk
  $ ./VSOC
*/ 
