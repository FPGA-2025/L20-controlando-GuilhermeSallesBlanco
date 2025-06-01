module fifo(
    input        clk,
    input        rst_n,

    // Write interface
    input        wr_en,
    input  [7:0] data_in,
    output       full,

    // Read interface
    input        rd_en,
    output reg [7:0] data_out,
    output       empty,

    // status
    output reg [3:0] fifo_words  // Current number of elements
);

parameter TAM_DADO = 8;
parameter PROF_FIFO = 8;

reg [TAM_DADO-1:0] fifo_mem [0:PROF_FIFO-1]; 
reg [TAM_DADO-1:0] wr_ptr; 
reg [TAM_DADO-1:0] rd_ptr;

assign full = ((wr_ptr == rd_ptr -1) || (wr_ptr == PROF_FIFO && rd_ptr == 0));
assign empty = (wr_ptr == rd_ptr);

always @(posedge clk) begin
    if(!rst_n) begin
        wr_ptr <= 0;
    end else if(wr_en && !full) begin
        fifo_mem[wr_ptr] <= data_in;
        wr_ptr <= wr_ptr + 1;
    end 
end

always @(posedge clk) begin
    if(!rst_n) begin
        rd_ptr <= 0;
    end else if(rd_en && !empty) begin
        data_out <= fifo_mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
    end 
end

always @(*) begin
    fifo_words = wr_ptr - rd_ptr;
end

endmodule
