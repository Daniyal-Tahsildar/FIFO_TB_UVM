`define NEW_COMP \
function new(string name = "", uvm_component parent = null); \
  super.new(name, parent); \
  endfunction 

`define NEW_OBJ \
function new(string name = ""); \
  super.new(name); \
  endfunction 

`define WIDTH 8
`define DEPTH 16
`define MAX_WR_DELAY 7
`define MAX_RD_DELAY 10

class fifo_common;
  static int num_matches;
  static int num_mismatches;
endclass