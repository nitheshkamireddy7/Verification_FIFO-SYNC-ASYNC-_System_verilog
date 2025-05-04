class monitor;

  virtual FIFO_if FIFO;

  function new(virtual FIFO_if FIFO);
    this.FIFO = FIFO;
  endfunction

  task run;
    txn F;
    forever begin
      @(posedge FIFO.clk);
      F = new();

      F.dout  = FIFO.dout;
      F.full  = FIFO.full;
      F.empty = FIFO.empty;

      
      $display("MON: dout=%0h full=%0b empty=%0b", F.dout, F.full, F.empty);
    end
  endtask

endclass
