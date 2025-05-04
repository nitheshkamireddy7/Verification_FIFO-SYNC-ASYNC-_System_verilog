class dri;

mailbox c;
virtual FIFO_if  FIFO;

function new(mailbox c,virtual FIFO_if FIFO);

this.c = c;
this.FIFO = FIFO;
endfunction

task run;
txn F;
forever begin

c.get(F);
@(posedge FIFO.clk);
FIFO.wr_en <=F.wr_en;
FIFO.rd_en <=F.rd_en;
FIFO.din <= F.din;

end
endtask
endclass
