class wr_tx extends uvm_sequence_item;
    rand bit [`WIDTH-1:0] data_in;
    rand int delay ;
    // rand bit wr_en;
    `uvm_object_utils_begin(wr_tx)
        `uvm_field_int(data_in , UVM_ALL_ON)
      `uvm_field_int(delay , UVM_ALL_ON)
  //   	`uvm_field_int(wr_en , UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "");
      super.new(name);
    endfunction
    
    //Any constraints
    
  //   constraint wr_en_c {
  //     wr_en dist{1 :/ 80 , 0:/ 20};
  //   }
    constraint delay_c {
      soft delay == 0;
    }
      
  endclass
  
  class rd_tx extends uvm_sequence_item;
    //rand bit rd_en;
    bit [`WIDTH-1:0] data_out;
    rand int delay ;
  
    `uvm_object_utils_begin(rd_tx)
        //`uvm_field_int(rd_en , UVM_ALL_ON)
      `uvm_field_int(data_out , UVM_ALL_ON)
      `uvm_field_int(delay , UVM_ALL_ON)
  
    `uvm_object_utils_end
    
    function new(string name = "");
      super.new(name);
    endfunction
      
     //Any constraints
    
    constraint delay_c {
      soft delay == 0;
    }
  
  endclass