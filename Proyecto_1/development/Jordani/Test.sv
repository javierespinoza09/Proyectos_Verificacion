class Test #(parameter drvrs = 4, parameter pckg_sz = 16, parameter fifo_size = 8);
  tst_gen_mbx tst_gen_mbx;
  tst_gen tst_gen_transaction;
  tst_chk_sb_mbx tst_chk_sb_mbx;
  tst_chk_sb tst_chk_sb_transaction;
	int test;
       int source;
       int id;
  function new(int test);
    this.tst_gen_transaction = new();
    this.tst_chk_sb_transaction = new();
	this.test = test;
  endfunction 
  
  task run();
	tst_gen_transaction.id = this.id;
	tst_gen_transaction.source = this.source;
    tst_gen_transaction.caso = this.test;
  	tst_gen_mbx.put(tst_gen_transaction);
    
    tst_chk_sb_transaction.test = this.test;
    tst_chk_sb_transaction.drvrs = this.drvrs;
    tst_chk_sb_transaction.pckg_sz = this.pckg_sz;
    tst_chk_sb_transaction.fifo_size = this.fifo_size;
    tst_chk_sb_mbx.put(tst_chk_sb_transaction);
    
  endtask
  
  
endclass