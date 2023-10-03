class Generador #(parameter drvrs = 4, parameter pckg_sz = 16);
  
  gen_ag_mbx gen_ag_mbx;
  gen_ag gen_ag_transaction;

  function new();
    this.gen_ag_transaction = new();
  endfunction 
  
  task run ();
    this.gen_ag_transaction.cant_datos = 10;
    this.gen_ag_transaction.data_modo = max_variabilidad;
    gen_ag_mbx.put(gen_ag_transaction);
  endtask
  
endclass