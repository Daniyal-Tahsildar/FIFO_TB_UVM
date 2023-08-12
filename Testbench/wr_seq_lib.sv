class wr_base_seq extends uvm_sequence #(wr_tx);
  
    uvm_phase phase;
    
    `uvm_object_utils(wr_base_seq)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
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
  
  
  //fifo_wr_seq
  class wr_seq extends wr_base_seq;
     int wr_count;
  
    `uvm_object_utils(wr_seq)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
    task body ();
      uvm_resource_db#(int)::read_by_name("GLOBAL", "WR_COUNT", wr_count, this);
      repeat(wr_count) begin
        `uvm_do(req)
      end
      
    endtask
  endclass
  
  //fifo concurrent write with dealy
  class wr_delay_seq extends wr_base_seq;
     int wr_count;
       int wr_delay;
  
    `uvm_object_utils(wr_delay_seq)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
    task body ();
      uvm_resource_db#(int)::read_by_name("GLOBAL", "WR_COUNT", wr_count, this);
      repeat(wr_count) begin
        wr_delay = $urandom_range(1 , `MAX_WR_DELAY);
        `uvm_do_with(req, {req.delay == wr_delay;})
      end
      
    endtask
  endclass