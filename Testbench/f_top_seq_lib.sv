//virtual sequence code

class top_base_seq extends uvm_sequence;
  
    uvm_phase phase;
    
    `uvm_object_utils(top_base_seq)
    
    `NEW_OBJ
    
    task pre_body();
      phase = get_starting_phase();
      if (phase != null)begin
        phase.raise_objection(this);
        phase.phase_done.set_drain_time (this, 100);
        end
    endtask
    
    task post_body();
      phase = get_starting_phase();
      if (phase != null)begin
        phase.drop_objection(this);
        end
    endtask
    
  endclass
  
  class v_seq extends top_base_seq;
    wr_seq  wr_seq_i;
    rd_seq   rd_seq_i;
   `uvm_declare_p_sequencer(top_sqr)
  
    `uvm_object_utils(v_seq)
  
    
    `NEW_OBJ
    
    task body();
      `uvm_do_on(wr_seq_i, p_sequencer.wr_sqr_i)
      `uvm_do_on(rd_seq_i, p_sequencer.rd_sqr_i)
  
    endtask
  
  endclass
  
  //TODO: Create virtual seq for concurrent tests and other tests 
  
  class v_conc_seq extends top_base_seq;
    wr_delay_seq  wr_seq_i;
    rd_delay_seq   rd_seq_i;
   `uvm_declare_p_sequencer(top_sqr)
  
    `uvm_object_utils(v_conc_seq)
  
    
    `NEW_OBJ
    
    task body();
      fork
      `uvm_do_on(wr_seq_i, p_sequencer.wr_sqr_i)
      `uvm_do_on(rd_seq_i, p_sequencer.rd_sqr_i)
      join
    endtask
  endclass
    