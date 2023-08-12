//wr mon
class wr_mon extends uvm_monitor;
  
    wr_tx tx;
    virtual fifo_if vif;
    uvm_analysis_port#(wr_tx) ap_port;
    
    `uvm_component_utils(wr_mon)
    
    function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_resource_db#(virtual fifo_if)::read_by_name("GLOBAL", "intf", vif , this))begin
        `uvm_error("DRV_INTF", "No virtual interface found!!!")
      end
      ap_port = new("ap_port", this);
    endfunction
    
    task run_phase (uvm_phase phase);
      forever begin
        @(vif.wr_mon_cb);
        if(vif.wr_mon_cb.wr_en == 1) begin
          tx = wr_tx::type_id::create("tx");
          tx.data_in = vif.wr_mon_cb.data_in;
          ap_port.write(tx);
        end
        
      end
      
    endtask
    
  endclass
  
  //rd mon
  class rd_mon extends uvm_monitor;
    
    rd_tx tx;
    virtual fifo_if vif;
    uvm_analysis_port#(rd_tx) ap_port;
    
    `uvm_component_utils(rd_mon)
    
    function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_resource_db#(virtual fifo_if)::read_by_name("GLOBAL", "intf", vif , this))begin
        `uvm_error("DRV_INTF", "No virtual interface found!!!")
      end
      ap_port = new("ap_port", this);
    endfunction
    
    task run_phase (uvm_phase phase);
      
      forever begin
        @(vif.rd_mon_cb);
        if(vif.rd_mon_cb.rd_en == 1) begin
          tx = rd_tx::type_id::create("tx");
          
          //fork join so that back to back read can be checked
          fork
            begin
              @(vif.rd_mon_cb);
              @(vif.rd_mon_cb);
          tx.data_out = vif.rd_mon_cb.data_out; 
          ap_port.write(tx);
            end
          join_none
  
        end
      end
      
    endtask
    
  endclass