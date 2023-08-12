
//TODO:incomplete scoreboard, does not correctly verify 2 testcases,

//TODO: Add more test cases and sequences, 
//TODO: Make design better,
//TODO: Check coverage (and assertions if file created)


import uvm_pkg::*;
`include "uvm_macros.svh" 

 `include "fifo.v"
 `include "common.sv"
 `include "intf.sv"
  
 `include "f_seq_item.sv"
 `include "wr_seq_lib.sv"
 `include "rd_seq_lib.sv"
`include "f_sqr.sv"

`include "f_drv.sv"
`include "f_mon.sv"
`include "f_cov.sv"
 `include "f_agent.sv"
`include "f_top_sqr.sv"
`include "f_top_seq_lib.sv"
 `include "f_scoreboard.sv"
 `include "f_env.sv"
 `include "f_test.sv"

`timescale 1ns/ 10ps

 module fifo_tb;
  
  logic clk, rst;
   
   parameter WIDTH = 8;
   parameter DEPTH = 16;
   //parameter ADDR_WIDTH = $clog2(DEPTH)+1;
  
  fifo_if intf (clk, rst); 

  my_fifo #(.WIDTH(WIDTH), .DEPTH(DEPTH)) DUT (
    .clk(clk),
    .rst(rst),
    .full(intf.full),
    .wr_en(intf.wr_en),
    .data_in(intf.data_in),
    .empty(intf.empty), 
    .rd_en(intf.rd_en), 
    .write_error(write_error),
    .read_error(read_error),
    .data_out(intf.data_out));
   
   initial begin : generate_clock
      clk = 1'b0;
      while(1) #5 clk = ~clk;
   end
  
  
  initial begin 
    //run_test("wr_rd_test");
    //run_test("wr_error_test");
    //run_test("rd_error_test");
    //run_test("wr_rd_con");
    //run_test("wr_rd_v_test");
   run_test("wr_rd_conc_v_test");

   end

   initial begin
      $timeformat(-9, 0, " ns");
     uvm_resource_db#(virtual fifo_if)::set("GLOBAL", "intf", intf ,null); 
      rst <= 1'b1;
      intf.rd_en <= 1'b0;
      intf.wr_en <= 1'b0;
      intf.data_in <= '0;      
     for (int i=0; i < 3; i++) @(posedge clk);
      @(negedge clk);
      rst <= 1'b0;
   end
       
   initial begin 
     $dumpfile("my_fifo.vcd");
     $dumpvars();

   end
         
endmodule
       