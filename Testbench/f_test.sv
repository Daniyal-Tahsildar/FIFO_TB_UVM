//base test
class base_test extends uvm_test;
    fifo_env env;
    
    `uvm_component_utils(base_test)
    
    function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      env = fifo_env::type_id::create("env", this);
      
    endfunction
    
    function void end_of_elaboration_phase(uvm_phase phase);
      uvm_top.print_topology();
    endfunction
    
    function void report_phase(uvm_phase phase);
      if (fifo_common:: num_mismatches > 0 || fifo_common:: num_matches == 0) begin
        `uvm_error("STATUS",$psprintf("TEST FAIL, num_matches = %d, num_mismatches = %d", fifo_common:: num_matches, fifo_common:: num_mismatches));
        
      end
      else begin
        `uvm_info("STATUS", $psprintf("TEST PASS, num_matches = %d, num_mismatches = %d", fifo_common:: num_matches, fifo_common:: num_mismatches), UVM_NONE);
      end
  
    endfunction
    
  endclass
  
  //fifo test_1
  class wr_rd_test extends base_test;
    
    `uvm_component_utils(wr_rd_test)
    
    `NEW_COMP
    
    function void build_phase (uvm_phase phase);
      //not registering this class to factory using super.build phase since resources of same type and name are conflicting, only base class is factory registed and all other test classes overwrite resources according to their use case,  
      //super.build_phase(phase);
          env = fifo_env::type_id::create("env", this);
      uvm_resource_db#(int)::set("GLOBAL", "WR_COUNT", `DEPTH, null);
      uvm_resource_db#(int)::set("GLOBAL", "RD_COUNT", `DEPTH, null);
  
    endfunction
    
    task run_phase (uvm_phase phase);
      wr_seq wr_seq_i;
      rd_seq rd_seq_i;
  
      wr_seq_i = wr_seq::type_id::create("wr_seq_i");
      rd_seq_i = rd_seq::type_id::create("rd_seq_i");
      
      phase.raise_objection(this);
      phase.phase_done.set_drain_time(this, 100);
      
      wr_seq_i.start(env.wr_agnt.wr_sqr_i);
      rd_seq_i.start(env.rd_agnt.rd_sqr_i);
  
      phase.drop_objection(this);
      
    endtask
    
  endclass
    
  //wr overflow test  
    class wr_error_test extends wr_rd_test;
    
      `uvm_component_utils(wr_error_test)
    
    `NEW_COMP
    
    function void build_phase (uvm_phase phase);
      //super.build_phase(phase);
      env = fifo_env::type_id::create("env", this);
  
      uvm_resource_db#(int)::set("GLOBAL", "WR_COUNT", `DEPTH+10, null);
      uvm_resource_db#(int)::set("GLOBAL", "RD_COUNT", 0, null);
  
      
    endfunction
    
    
  endclass
  
  // read error test
  class rd_error_test extends wr_rd_test;
    
    `uvm_component_utils(rd_error_test)
    
    `NEW_COMP
    
    function void build_phase (uvm_phase phase);
      //super.build_phase(phase);
      env = fifo_env::type_id::create("env", this);
  
      uvm_resource_db#(int)::set("GLOBAL", "WR_COUNT", `DEPTH, null);
      uvm_resource_db#(int)::set("GLOBAL", "RD_COUNT", `DEPTH+2, null);
  
    endfunction
    
  endclass
  
  //write read concurrently with random delays
  class wr_rd_con extends wr_rd_test;
    
    `uvm_component_utils(wr_rd_con)
    
    `NEW_COMP
    
    function void build_phase (uvm_phase phase);
      //super.build_phase(phase);
      env = fifo_env::type_id::create("env", this);
  
      uvm_resource_db#(int)::set("GLOBAL", "WR_COUNT", 50, null);
      uvm_resource_db#(int)::set("GLOBAL", "RD_COUNT", 50, null);
  
    endfunction
    
    //task required since new sequences are run
    task run_phase (uvm_phase phase);
      wr_delay_seq wr_seq_i;
      rd_delay_seq rd_seq_i;
  
      wr_seq_i = wr_delay_seq::type_id::create("wr_seq_i");
      rd_seq_i = rd_delay_seq::type_id::create("rd_seq_i");
      
      phase.raise_objection(this);
      phase.phase_done.set_drain_time(this, 100);
      
      //concurrent run
      fork
      wr_seq_i.start(env.wr_agnt.wr_sqr_i);
      rd_seq_i.start(env.rd_agnt.rd_sqr_i);
      join
  
      phase.drop_objection(this);
      
    endtask
    
  endclass
  
  //virtual sequence
  class wr_rd_v_test extends base_test;
    
    `uvm_component_utils(wr_rd_v_test)
    
    `NEW_COMP
    
    function void build_phase (uvm_phase phase);
      //not registering this class to factory using super.build phase since resources of same type and name are conflicting, only base class is factory registed and all other test classes overwrite resources according to their use case,  
      //super.build_phase(phase);
          env = fifo_env::type_id::create("env", this);
      uvm_resource_db#(int)::set("GLOBAL", "WR_COUNT", `DEPTH, null);
      uvm_resource_db#(int)::set("GLOBAL", "RD_COUNT", `DEPTH, null);
  
    endfunction
    
    task run_phase (uvm_phase phase);
      v_seq v_seq_i;
  
      v_seq_i = v_seq::type_id::create("v_seq_i");
      
      phase.raise_objection(this);
      phase.phase_done.set_drain_time(this, 100);
      
      //virtual sequencer argumenet is virtual sqr handle present in env
      v_seq_i.start(env.top_sqr_i);
      
      phase.drop_objection(this);
      
    endtask
    
  endclass
  
  class wr_rd_conc_v_test extends base_test;
    
    `uvm_component_utils(wr_rd_conc_v_test)
    
    `NEW_COMP
    
    function void build_phase (uvm_phase phase);
      //not registering this class to factory using super.build phase since resources of same type and name are conflicting, only base class is factory registed and all other test classes overwrite resources according to their use case,  
      //super.build_phase(phase);
          env = fifo_env::type_id::create("env", this);
      uvm_resource_db#(int)::set("GLOBAL", "WR_COUNT", 50, null);
      uvm_resource_db#(int)::set("GLOBAL", "RD_COUNT", 50, null);
  
    endfunction
    
    task run_phase (uvm_phase phase);
      v_conc_seq v_seq_i;
  
      v_seq_i = v_conc_seq::type_id::create("v_seq_i");
      
      phase.raise_objection(this);
      phase.phase_done.set_drain_time(this, 100);
      
      //virtual sequencer argumenet is virtual sqr handle present in env
      v_seq_i.start(env.top_sqr_i);
  
      phase.drop_objection(this);
      
    endtask
    
  endclass