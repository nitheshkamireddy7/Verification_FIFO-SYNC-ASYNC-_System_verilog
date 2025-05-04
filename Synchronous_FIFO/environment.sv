class environment;
virtual FIFO_if FIFO;
mailbox c;

gen g;
dri d;
monitor mon;

function new(virtual FIFO_if FIFO);

this.FIFO = FIFO;
c = new();
g= new(c);
d= new(c,FIFO);
mon = new(FIFO);
endfunction

task run;
fork
g.run();
d.run();
mon.run();
join_none
endtask
endclass
