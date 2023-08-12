`uvm_analysis_imp_decl(_write)
`uvm_analysis_imp_decl(_read)

class sboard extends uvm_scoreboard;
  wr_tx wr_Q[$];
  rd_tx rd_Q[$];

  wr_tx wr_tx_i;
  rd_tx rd_tx_i;
  
  uvm_analysis_imp_write#(wr_tx, sboard) imp_write;
  uvm_analysis_imp_read#(rd_tx, sboard) imp_read;

  `uvm_component_utils(sboard)
  
  `NEW_COMP
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    imp_write = new("imp_write", this);
    imp_read = new("imp_read", this);

  endfunction
  
  
  function void write_write(wr_tx tx);
    $display("[time: %t] storing write tx in wr queue: %h", $realtime, tx.data_in);
    wr_Q.push_back(tx);
  endfunction
  
  function void write_read(rd_tx tx);
    $display("[time: %t] storing read tx in rd queue: %h", $realtime, tx.data_out);
    rd_Q.push_back(tx);
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      wait (wr_Q.size() > 0 && rd_Q.size() > 0 );
        wr_tx_i = wr_Q.pop_front();
        rd_tx_i = rd_Q.pop_front();
      if (wr_tx_i.data_in == rd_tx_i.data_out)begin 
        fifo_common::num_matches++;
      end
      else begin
        fifo_common::num_mismatches++;
      end     
    end
  endtask
endclass
