class fifo_env extends uvm_env;
    fifo_agent_wr wr_agnt;
     fifo_agent_rd rd_agnt;
    sboard sboard_i;
    top_sqr top_sqr_i;
  
    `uvm_component_utils(fifo_env)
    
    function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      wr_agnt = fifo_agent_wr::type_id::create("wr_agnt", this);
      rd_agnt = fifo_agent_rd::type_id::create("rd_agnt", this);
      sboard_i = sboard::type_id::create("sboard_i", this);
      top_sqr_i = top_sqr::type_id::create("top_sqr_i", this);
  
  
    endfunction
    
    function void connect_phase (uvm_phase phase);
      super.connect_phase(phase);
      wr_agnt.wr_mon_i.ap_port.connect(sboard_i.imp_write);
      rd_agnt.rd_mon_i.ap_port.connect(sboard_i.imp_read);
      
      //mapping virtual sequencer
      top_sqr_i.wr_sqr_i = wr_agnt.wr_sqr_i;
      top_sqr_i.rd_sqr_i = rd_agnt.rd_sqr_i;
  
    endfunction
  endclass