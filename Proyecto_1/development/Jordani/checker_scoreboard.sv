class checker_scoreboard #(parameter drvrs = 4, parameter pckg_sz = 16);
  ag_chk_sb_mbx #(.packagesize(pckg_sz)) ag_chk_sb_mbx;
  ag_chk_sb #(.packagesize(pckg_sz)) ag_chk_sb_transaction;
  mon_chk_sb_mbx mon_chk_sb_mbx [drvrs];
  mon_chk_sb mon_chk_sb_transaction;
  ag_chk_sb #(.packagesize(pckg_sz)) q_instrucciones [$];
  mon_chk_sb q_resultados [$];
  
  function new();
    this.q_instrucciones = {};
    for(int i = 0;i < drvrs; i++) begin
		automatic int k = i;	
		this.mon_chk_sb_mbx[k] = new();
	end
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
    foreach(this.q_instrucciones[i]) $display("Posición %d de la cola, dato = %b , id = %b, instante [%g], salió del: %g",i,this.q_instrucciones[i].payload,this.q_instrucciones[i].id, this.q_instrucciones[i].transaction_time,this.q_instrucciones[i].source); //aserciones para el caso broadcast, revisar que lleguen todos
	endfunction
  
  
  
endclass