`include "FIFO_if.sv"
`include "txn.sv"
`include "gen.sv"
`include "dri.sv"
`include "monitor.sv"
`include "environment.sv"
`include "RTL.sv"// Include your FIFO RTL module

module test;

  // Clock and reset
  logic clk;
  logic rstn;

  // Instantiate the interface
  FIFO_if intf();

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;  // 100MHz clock (10ns period)

  // Apply reset
  initial begin
    rstn = 0;
    #20;
    rstn = 1;
  end

  // Connect interface signals
  assign intf.clk = clk;
  assign intf.rstn = rstn;

  // DUT instantiation
  sync_fifo dut (
    .clk     (intf.clk),
    .rstn    (intf.rstn),
    .wr_en   (intf.wr_en),
    .rd_en   (intf.rd_en),
    .din     (intf.din),
    .dout    (intf.dout),
    .full    (intf.full),
    .empty   (intf.empty)
  );

  // Environment instance
  environment env;

  initial begin
    env = new(intf);
    env.run();
    #1000;  // Let simulation run for a while
    $finish;
  end

endmodule
