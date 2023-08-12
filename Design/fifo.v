
module my_fifo #(
    parameter WIDTH,
    parameter int DEPTH
    //parameter ADDR_WIDTH = $clog2(DEPTH)+1
    )
    (
        input clk, rst ,
        input [WIDTH -1 :0] data_in,
        input wr_en, rd_en,

        output reg [WIDTH -1: 0] data_out,
        output empty, full,
        output write_error,
        output read_error

    );
  
  localparam int ADDR_WIDTH = $clog2(DEPTH)+1;


    reg [ADDR_WIDTH-1: 0] wr_addr, rd_addr;

    wire valid_rd, valid_wr;

    reg [WIDTH-1 : 0] fifo_r [DEPTH];
  
  // write/read overflow error flag
  assign write_error = (full) ? '1 : '0;
  assign read_error = (empty ) ? '1 : '0;


    assign valid_rd = !read_error && rd_en; 
    assign valid_wr = !write_error && wr_en;
    
    assign full = (wr_addr[ADDR_WIDTH-1] != rd_addr[ADDR_WIDTH -1]) && (wr_addr[ADDR_WIDTH-2:0] == rd_addr[ADDR_WIDTH -2:0]);
    assign empty = wr_addr == rd_addr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
          for (int i = 0; i < DEPTH; i++) fifo_r[i] <= '0;
            data_out <= '0;
        end

        else begin
          if (valid_wr) fifo_r[wr_addr[ADDR_WIDTH - 2:0]] <= data_in;
          //conditional statement to prevent 0's occurring during read error 
          if(read_error) data_out <= data_out;
          else
          data_out <= fifo_r[rd_addr[ADDR_WIDTH - 2:0]];
            
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_addr <= '0;
            rd_addr <= '0;

        end

        else begin
          if (valid_rd) rd_addr <= rd_addr + 1'b1;
          if (valid_wr) wr_addr <= wr_addr + 1'b1;

        end
    end


endmodule