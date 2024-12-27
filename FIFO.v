//RA2211004010126
//RA2211004010141
module FIFO #(parameter DATA_WIDTH = 8, parameter FIFO_DEPTH = 16)(
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] wr_data,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire full,
    output wire empty
);

    // Define memory array
    reg [DATA_WIDTH-1:0] fifo_mem[FIFO_DEPTH-1:0];
    reg [3:0] wr_ptr;   // Write pointer
    reg [3:0] rd_ptr;   // Read pointer
    reg [4:0] fifo_cnt; // FIFO count to track full/empty status

    // Write data to FIFO
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wr_ptr <= 0;
        else if (wr_en && !full) begin
            fifo_mem[wr_ptr] <= wr_data;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read data from FIFO
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rd_ptr <= 0;
        else if (rd_en && !empty) begin
            rd_ptr <= rd_ptr + 1;
        end
    end

    // Output the read data
    assign rd_data = fifo_mem[rd_ptr];

    // FIFO status: Full or Empty
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            fifo_cnt <= 0;
        else if (wr_en && !rd_en && !full)
            fifo_cnt <= fifo_cnt + 1;
        else if (rd_en && !wr_en && !empty)
            fifo_cnt <= fifo_cnt - 1;
    end

    // FIFO Full and Empty conditions
    assign full = (fifo_cnt == FIFO_DEPTH);
    assign empty = (fifo_cnt == 0);

endmodule
