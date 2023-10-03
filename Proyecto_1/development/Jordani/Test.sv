class Test #(parameter drvrs = 4, parameter pckg_sz = 16);
  tst_gen_mbx tst_gen_mbx;
  tst_gen tst_gen_transaction;

  function new();
    this.tst_gen_transaction = new();
  endfunction 
  
  task run();
    tst_gen_transaction.caso = normal;
    tst_gen_mbx.put(tst_gen_transaction);
  endtask
  
  
endclass