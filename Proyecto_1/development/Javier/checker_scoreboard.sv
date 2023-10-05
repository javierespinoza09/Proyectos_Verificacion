class checker_scoreboard #(parameter drvrs = 4, parameter pckg_sz = 16);
  ///////////////////////////////////////////
  //Creación de los Mailbox y Transacciones//
  ///////////////////////////////////////////
  tst_chk_sb_mbx tst_chk_sb_mbx;
  tst_chk_sb tst_chk_sb_transaction;
  ag_chk_sb_mbx #(.pckg_sz(pckg_sz)) ag_chk_sb_mbx;
  ag_chk_sb	#(.pckg_sz(pckg_sz)) ag_chk_sb_transaction;
  mon_chk_sb_mbx mon_chk_sb_mbx;
  mon_chk_sb mon_chk_sb_transaction;
  ag_chk_sb #(.pckg_sz(pckg_sz)) q_instrucciones [$];
  mon_chk_sb q_resultados [$];
  mon_chk_sb q_resultados_array [];
  
  
  //Variables para el manejo de los datos del reporte//
  int res[$];
  int prom = 0;
  int tiempo = 0;

  //El constructor vacía las colas e inicia el mbx//
  function new();
    this.q_instrucciones = {};
    this.q_resultados = {};
    this.mon_chk_sb_mbx = new();
  endfunction 
  
  //Función para almacenar todas las transacciones enviadas//
  task run_ag();
    forever begin
      this.ag_chk_sb_mbx.get(this.ag_chk_sb_transaction);
      this.q_instrucciones.push_back(this.ag_chk_sb_transaction);  
    end 
  endtask
  
  //Función para almacenar los datos recibidos//
    task run_mon();
    forever begin
    this.mon_chk_sb_mbx.get(this.mon_chk_sb_transaction);
      this.q_resultados.push_back(this.mon_chk_sb_transaction);
      this.q_resultados_array = new [this.q_resultados_array.size() + 1] (this.q_resultados_array);
      if (this.q_resultados_array.size() == 0) this.q_resultados_array[0] = this.mon_chk_sb_transaction;
      else this.q_resultados_array[this.q_resultados_array.size()-1] =this.mon_chk_sb_transaction;
    end 
  endtask
  
  /*                           */
  /*SISTEMA DE REPORTE DE DATOS*/
  /*                           */
  
  function report_sb();
    int fa;
    fa = $fopen("Reporte.csv","a");
    $fdisplay(fa,"Reporte Scoreboard");
    
    
    $fdisplay(fa,"REPORTE DE TRANSACCIONES REALIZADAS");
    foreach(this.q_instrucciones[i]) $fdisplay(fa,"Posición %d de la cola, dato = %d , id = %d, instante [%g], salió del: %g",i,this.q_instrucciones[i].payload,this.q_instrucciones[i].id, this.q_instrucciones[i].transaction_time,this.q_instrucciones[i].source);
    $fdisplay(fa,"REPORTE DE TRANSACCIONES RECIBIDAS");
    foreach(this.q_resultados_array[i]) $fdisplay(fa,"Posición %d de la cola, dato = %d , id = %d, instante [%g], llegó al: %g",i,this.q_resultados_array[i].payload,this.q_resultados_array[i].id, this.q_resultados_array[i].tiempo,this.q_resultados_array[i].receiver);
    
    
    
    $fdisplay(fa,"REPORTE DE RETRASOS EN LAS TRANSACCIONES");
    foreach(this.q_instrucciones[i]) begin
      res = q_resultados_array.find_index with (item.id == this.q_instrucciones[i].id & item.payload == this.q_instrucciones[i].payload );
      tiempo =q_resultados_array[res[0]].tiempo - this.q_instrucciones[i].transaction_time;
      $fdisplay(fa,"El retraso Salida-Entrada en el Dato: %d con ID: %d es de [%g]",this.q_instrucciones[i].payload, this.q_instrucciones[i].id,tiempo);
      prom = prom + tiempo;
    end
    $fdisplay(fa,"El retraso promedio es de: [%g]",prom/this.q_resultados_array.size());
  
  endfunction
  
endclass