module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  logic                  clk,
    input  logic                  rstn,       // Active-low reset
    input  logic                  wr_en,      // Write enable
    input  logic                  rd_en,      // Read enable
    input  logic [DATA_WIDTH-1:0] din,        // Data input
    output logic [DATA_WIDTH-1:0] dout,       // Data output
    output logic                  full,       // FIFO full
    output logic                  empty       // FIFO empty
);

    // Memory to store FIFO data
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Read and write pointers
    logic [ADDR_WIDTH-1:0] wr_ptr;
    logic [ADDR_WIDTH-1:0] rd_ptr;

    // Counter to keep track of FIFO occupancy
    logic [ADDR_WIDTH:0] count;

    // Write operation
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read operation
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            rd_ptr <= 0;
            dout   <= '0;
        end else if (rd_en && !empty) begin
            dout <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    // Counter logic
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            count <= 0;
        end else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1; // write only
                2'b01: count <= count - 1; // read only
                default: count <= count;   // no change or simultaneous read/write
            endcase
        end
    end

    // Status signals
    assign full  = (count == DEPTH);
    assign empty = (count == 0);

endmodule

