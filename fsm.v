module fsm(
    input        clk,
    input        rst_n,

    output reg   wr_en,       // controla a escrita na FIFO
    output [7:0] fifo_data,   // sempre 0xAA
    input  [3:0] fifo_words   // quantas palavras estão na FIFO
);

localparam STOP = 2'b00;
localparam WRITING = 2'b01;
localparam READING = 2'b10;

reg [1:0] estado, prox_estado;
reg [7:0] fifo_data_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n && estado !== STOP) begin
        estado <= STOP;
    end else begin
        estado <= prox_estado;
    end
end

always @(*) begin
    prox_estado = estado;
    case(estado)
        STOP: begin
            prox_estado = WRITING;
        end
        WRITING: begin
            if(fifo_words >= 5) begin
                prox_estado = READING;
            end else begin
                prox_estado = WRITING;
            end
        end
        READING: begin
            if(fifo_words <= 2) begin
                prox_estado = WRITING;
            end else begin
                prox_estado = READING;
            end
        end
        default: begin
            prox_estado = STOP;
        end
    endcase
end

assign fifo_data = fifo_data_reg;

always @(*) begin
    fifo_data_reg = 8'hAA; 
    case(estado)
        WRITING: wr_en = 1;
        READING: wr_en = 0;
    endcase
end

endmodule
