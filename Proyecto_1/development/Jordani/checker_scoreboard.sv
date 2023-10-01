class checker_scoreboard;
  ag_chk_sb_mbx ag_chk_sb_mbx;
  ag_chk_sb	ag_chk_sb_transaction;
  
  
  function new();
    
  endfunction 
  
  task run();
    forever begin
    this.ag_chk_sb_mbx.get(this.ag_chk_sb_transaction);
      $display("Chk recibió el dato %b  con id %b se envió en el tiempo [%g]",this.ag_chk_sb_transaction.payload,this.ag_chk_sb_transaction.id, this.ag_chk_sb_transaction.payload, this.ag_chk_sb_transaction.transaction_time);
    end 
  endtask
  
endclass