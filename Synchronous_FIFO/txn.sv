class txn;

  rand bit wr_en;      // Write enable
  rand bit rd_en;      // Read enable
  rand  bit[7:0] din;        // Data input
  logic [7:0] dout;      // Data output
  logic full;      // FIFO full
  logic empty;

  constraint C1{
     !(wr_en && rd_en);
  };

  constraint C2{
    wr_en dist { 1 := 50, 0:=50};
    rd_en == !wr_en;
  };

  

endclass
