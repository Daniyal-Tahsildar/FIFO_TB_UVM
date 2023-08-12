interface fifo_if (input logic clk, rst);
    logic             full;
    logic             wr_en;
   logic [`WIDTH-1:0] data_in;
    logic             empty; 
    logic             rd_en; 
   logic [`WIDTH-1:0] data_out;
   logic              write_error;
   logic              read_error;
   
   //clocking blocks prevented double sampling, change monitor run phase for clocking block accordingly
   
   clocking wr_mon_cb @(posedge clk);
     default input #1;
     input wr_en;
     input data_in;
     input full, empty;
     input write_error;
 
   endclocking
   
   clocking rd_mon_cb @(posedge clk);
     default input #1;
     input rd_en;
     input data_out;
     input full, empty;
     input read_error;
 
   endclocking
 
 endinterface