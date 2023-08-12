// Virtual sqr will run virtual sequences created using the two master sqrs

class top_sqr extends uvm_sequencer;
    wr_sqr wr_sqr_i;
      rd_sqr rd_sqr_i;
  
    `uvm_component_utils(top_sqr)
    
    `NEW_COMP
    
    //wr_sqr and rd_sqr handles in build phase are not created here since we need to map them to the actual sqr present in the respective agent class
  endclass