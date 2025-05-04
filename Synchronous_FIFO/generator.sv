class gen;

mailbox c;

function new(mailbox c);
this.c = c;
endfunction



task run;
txn F;
repeat(10)  begin
F = new();
F.randomize();
c.put(F);
end
endtask

endclass
