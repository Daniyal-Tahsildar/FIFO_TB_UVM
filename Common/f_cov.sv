
//wr cov
class wr_cov extends uvm_subscriber#(wr_tx);
  
    wr_tx tx;
    
    `uvm_component_utils(wr_cov)
    
    covergroup wr_cg;
      cov_wr : coverpoint tx.delay {
        bins ZERO = {0};
        bins LOWER = {[1: 4]};
        bins UPPER = {[5 : `MAX_WR_DELAY]};
  
      //option.auto_bin_max = 8;
      }
      
    endgroup
    
    function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
      wr_cg = new();
    endfunction
    
    function void write (wr_tx t);
      $cast (tx, t);
      wr_cg.sample();
    endfunction
  endclass
  
  //rd cov
  class rd_cov extends uvm_subscriber#(rd_tx);
    
    rd_tx tx;
    `uvm_component_utils(rd_cov)
    
    covergroup rd_cg;
      cov_rd : coverpoint tx.delay {
        bins ZERO = {0};
        bins LOWER = {[1: 4]};
        bins UPPER = {[5 : `MAX_RD_DELAY]};
      //option.auto_bin_max = 8;
      }
    endgroup
    
    function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
      rd_cg = new();
    endfunction
    
    
    function void write (rd_tx t);
      $cast (tx, t);
      rd_cg.sample();
    endfunction
  endclass