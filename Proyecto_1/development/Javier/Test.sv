class Test #(parameter drvrs = 4, parameter pckg_sz = 16);
  tst_gen_mbx tst_gen_mbx;
  tst_gen tst_gen_transaction;
	int test; 
  function new(int test);
    this.tst_gen_transaction = new();
	this.test = test;
  endfunction 
  
  task run();
    tst_gen_transaction.caso = this.test;
    tst_gen_mbx.put(tst_gen_transaction);
  endtask
  
  
endclass
