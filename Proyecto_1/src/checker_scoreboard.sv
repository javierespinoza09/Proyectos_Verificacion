class checker_scoreboard;
  ag_chk_sb_mbx ag_chk_sb_mbx;
  ag_chk_sb	ag_chk_sb_transaction;
  mon_chk_sb_mbx mon_chk_sb_mbx;
  mon_chk_sb mon_chk_sb_transaction;
  ag_chk_sb q_instrucciones [$];
  mon_chk_sb q_resultados [$];
  
  function new();
    this.q_instrucciones = {};
  endfunction 
  
  task run();
    forever begin
    this.ag_chk_sb_mbx.get(this.ag_chk_sb_transaction);
      this.q_instrucciones.push_back(this.ag_chk_sb_transaction);
      //$display("Chk recibió el dato %b  con id %b se envió en el tiempo [%g]",this.ag_chk_sb_transaction.payload,this.ag_chk_sb_transaction.id, this.ag_chk_sb_transaction.payload, this.ag_chk_sb_transaction.transaction_time);
    end 
  endtask
  
  
  function report_sb();
    $display("Reporte Cola Scoreboard");
    foreach(this.q_instrucciones[i]) $display("Posisción %d de la cola, dato = %b , id = %b, instante [%g], salió del: %g",i,this.q_instrucciones[i].payload,this.q_instrucciones[i].id, this.q_instrucciones[i].transaction_time,this.q_instrucciones[i].source); //aserciones para el caso broadcast, revisar que lleguen todos
	endfunction
  
  
  
endclass