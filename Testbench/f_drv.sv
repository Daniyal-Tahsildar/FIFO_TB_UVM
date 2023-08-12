//wr drv
class wr_drv extends uvm_driver#(wr_tx);
  
    virtual fifo_if vif;
    uvm_analysis_port#(wr_tx) ap_port;
    
    `uvm_component_utils(wr_drv)
    
    function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      if(!(uvm_resource_db#(virtual fifo_if)::read_by_name("GLOBAL", "intf", vif, this)))begin
        `uvm_error("DRV_INTF", "No virtual interface found!!!")
      end
      ap_port = new("ap_port", this);
    endfunction
    
    task run_phase (uvm_phase phase);
      wait (vif.rst == 0);
      forever begin
        seq_item_port.get_next_item(req);
        ap_port.write(req);
        req.print();
        drive(req);
        seq_item_port.item_done();
      end
    endtask
    
    task drive (wr_tx tx);
      @(posedge vif.clk);
         vif.wr_en = 1;
     //  vif.wr_en = tx.wr_en;
      vif.data_in = tx.data_in;
      @(posedge vif.clk);
          vif.wr_en = 0;
      repeat(tx.delay) @(posedge vif.clk);
  
      
    endtask
    
  endclass
  
  //rd drv
  class rd_drv extends uvm_driver#(rd_tx);
    
    virtual fifo_if vif;
    uvm_analysis_port#(rd_tx) ap_port;
    
    `uvm_component_utils(rd_drv)
    
    function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      if(!(uvm_resource_db#(virtual fifo_if)::read_by_name("GLOBAL", "intf", vif , this)))begin
        `uvm_error("DRV_INTF", "No virtual interface found!!!")
      end
      ap_port = new("ap_port", this);
    endfunction
    
    task run_phase (uvm_phase phase);
      wait (vif.rst == 0);
      forever begin
        seq_item_port.get_next_item(req);
        ap_port.write(req);
        drive(req);
        seq_item_port.item_done();
      end
    endtask
    
    task drive (rd_tx tx);
      @(posedge vif.clk);
          vif.rd_en = 1;
  //     vif.rd_en = tx.rd_en;
      tx.data_out = vif.data_out;
  
      @(posedge vif.clk);
          vif.rd_en = 0;
      repeat(tx.delay) @(posedge vif.clk);
      
    endtask
    
  endclass