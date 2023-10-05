class Test #(parameter drvrs = 4, parameter pckg_sz = 16, parameter fifo_size = 8);
	/*rand int drvrs;
	rand int pckg_sz;
	rand int fifo_size;
  	constraint valid_drvrs {drvrs < 15 ; drvrs >= 4;};
	constraint valid_fifo_size {fifo_size > 0; fifo_size < 20;};
	constraint valid_pckg_sz {pckg_sz >= 8; pckg_sz < 64;};
	*/
	tst_gen_mbx tst_gen_mbx;
        tst_gen tst_gen_transaction;
	tst_chk_sb tst_chk_sb_transaction;
	tst_chk_sb_mbx tst_chk_sb_mbx;

  function new();
    	this.tst_gen_transaction = new();
	this.tst_chk_sb_transaction = new();
  endfunction 
  
  task run();
	this.tst_gen_transaction = new();  
	this.tst_chk_sb_transaction = new();
    	tst_gen_transaction.caso = normal;
    	tst_gen_mbx.put(tst_gen_transaction);
	this.tst_chk_sb_transaction.test = normal;
	this.tst_chk_sb_transaction.drvrs = drvrs;
	this.tst_chk_sb_transaction.pckg.sz = pckg_sz;
	this.tst_chk_sb_transaction.fifo_size = fifo_size;
	tst_chk_sb_mbx.put(tst_chk_sb_transaction);
    	$display("TEST: CASO-NORMAL",$time);

	#50000

	this.tst_gen_transaction = new();
        this.tst_chk_sb_transaction = new();
        tst_gen_transaction.caso = broadcast;
        tst_gen_mbx.put(tst_gen_transaction);
        this.tst_chk_sb_transaction.test = normal;
        this.tst_chk_sb_transaction.drvrs = drvrs;
        this.tst_chk_sb_transaction.pckg.sz = pckg_sz;
        this.tst_chk_sb_transaction.fifo_size = fifo_size;
        tst_chk_sb_mbx.put(tst_chk_sb_transaction);
        $display("TEST: BROADCAST",$time);

    	#50000

	this.tst_gen_transaction = new();
        this.tst_chk_sb_transaction = new();
        tst_gen_transaction.caso = one_to_all;
        tst_gen_mbx.put(tst_gen_transaction);
        this.tst_chk_sb_transaction.test = normal;
        this.tst_chk_sb_transaction.drvrs = drvrs;
        this.tst_chk_sb_transaction.pckg.sz = pckg_sz;
        this.tst_chk_sb_transaction.fifo_size = fifo_size;
        tst_chk_sb_mbx.put(tst_chk_sb_transaction);
        $display("TEST: BROADCAST",$time);
  endtask
  
  
endclass
