class rd_base_seq extends uvm_sequence #(rd_tx);
  
    uvm_phase phase;
    
    `uvm_object_utils(rd_base_seq)
    
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
  
  
  //fifo_rd_seq
  class rd_seq extends rd_base_seq;
    int rd_count;
  
    `uvm_object_utils(rd_seq)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
    task body ();
      uvm_resource_db#(int)::read_by_name("GLOBAL", "RD_COUNT", rd_count, this);
  
      repeat (rd_count) begin
        `uvm_do(req)
      end
    endtask
  endclass
  
  //fifo concurrent read with dealy
  class rd_delay_seq extends rd_base_seq;
     int rd_count;
       int rd_delay;
  
    `uvm_object_utils(rd_delay_seq)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
    task body ();
      uvm_resource_db#(int)::read_by_name("GLOBAL", "WR_COUNT", rd_count, this);
      repeat(rd_count) begin
        rd_delay = $urandom_range(1 , `MAX_RD_DELAY);
        `uvm_do_with(req, {req.delay == rd_delay;})
      end
      
    endtask
  endclass