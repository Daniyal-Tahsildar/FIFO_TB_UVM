//fifo agent write side
class fifo_agent_wr extends uvm_agent;
    wr_drv wr_drv_i;
      wr_mon wr_mon_i;
    wr_sqr wr_sqr_i;
    wr_cov wr_cov_i;
  
    `uvm_component_utils(fifo_agent_wr)
    
    `NEW_COMP
    
    function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      wr_drv_i = wr_drv::type_id::create("wr_drv_i", this);
      wr_mon_i = wr_mon::type_id::create("wr_mon_i", this);
      wr_sqr_i = wr_sqr::type_id::create("wr_sqr_i", this);
      wr_cov_i = wr_cov::type_id::create("wr_cov_i", this);
   
    endfunction
    
    function void connect_phase (uvm_phase phase);
      super.connect_phase(phase);
      wr_drv_i.seq_item_port.connect(wr_sqr_i.seq_item_export);
      // commenting out since delay is not available in interface
      //wr_mon_i.ap_port.connect(wr_cov_i.analysis_export);
      wr_drv_i.ap_port.connect(wr_cov_i.analysis_export);
  
    endfunction
    
  endclass
  
  //fifo agent read side
  class fifo_agent_rd extends uvm_agent;
    rd_drv rd_drv_i;
      rd_mon rd_mon_i;
    rd_sqr rd_sqr_i;
    rd_cov rd_cov_i;
  
    `uvm_component_utils(fifo_agent_rd)
    
    `NEW_COMP
    
    function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      rd_drv_i = rd_drv::type_id::create("rd_drv_i", this);
      rd_mon_i = rd_mon::type_id::create("rd_mon_i", this);
      rd_sqr_i = rd_sqr::type_id::create("rd_sqr_i", this);
      rd_cov_i = rd_cov::type_id::create("rd_cov_i", this);
   
    endfunction
    
    function void connect_phase (uvm_phase phase);
      super.connect_phase(phase);
      rd_drv_i.seq_item_port.connect(rd_sqr_i.seq_item_export);
      // commenting out since delay is not available in interface
      //rd_mon_i.ap_port.connect(rd_cov_i.analysis_export);
      rd_drv_i.ap_port.connect(rd_cov_i.analysis_export);
  
    endfunction
    
  endclass