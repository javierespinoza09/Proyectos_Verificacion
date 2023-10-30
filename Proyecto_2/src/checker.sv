class _checker #(parameter pckg_sz = 20,parameter fifo_size = 4);
  
  drv_sb #(.pckg_sz(pckg_sz)) chk_sb_transaction;
  sb_chk_mbx #(.pckg_sz(pckg_sz)) sb_chk_mbx;
  
  mon_chk_mbx mon_chk_mbx;
  mon_chk mon_chk_transaction;
  
  drv_sb #(.pckg_sz(pckg_sz)) array_sc[longint];
  mon_chk array_mon[longint];
  
  tst_chk tst_chk_transaction;
  tst_chk_mbx tst_chk_mbx;
  
  
  list_chk_mbx list_chk_mbx;
  list_chk  list_chk_transaction;
  list_chk real_path[$];
  
  
  gen_ag_mode enum_mode;
  Tests test_name;
  
  int prom = 0;
  int count = 1;
  int break_path = 0;
  int jump_prom = 0;
  int fa;
  string file_name;
  
  task clean();
    prom = 0;
    count = 1;
    break_path = 0;
    jump_prom = 0;
   	foreach (array_sc[i]) array_sc.delete(i);
    foreach (array_mon[i]) array_mon.delete(i);
    real_path = {};
    //$display("TAMAÑO SC [%0d] MON [%0d] REAL [%0d]",array_sc.size(),array_mon.size(),real_path.size());
    
  endtask
  
  task listeners();
    forever begin
      list_chk_mbx.get(list_chk_transaction);
      real_path.push_back(list_chk_transaction);
    end
  endtask
  
  
  
  task run_sc();
    
  forever begin
      sb_chk_mbx.get(chk_sb_transaction);
      array_sc[{chk_sb_transaction.paquete}] = this.chk_sb_transaction;
      //$display("\nHASH SC Key [%d]",chk_sb_transaction.paquete);
    end
    
  endtask
 	
  
  
  	
  
  task run_mon();
    
    forever begin
      mon_chk_mbx.get(mon_chk_transaction);
      array_mon[{mon_chk_transaction.key}] = this.mon_chk_transaction;
      //$display("\nHASH MON Key [%d]",mon_chk_transaction.key);
    end
    
 
  endtask
  
  

    
 
  
  task report();
    
    this.file_name = $sformatf("Reporte_F%0d.csv",fifo_size);
    this.fa = $fopen(this.file_name,"a");
    
    
    
    tst_chk_mbx.get(tst_chk_transaction);
    enum_mode =tst_chk_transaction.mode;
    test_name = tst_chk_transaction.test;
    $display("PRUEBA %s",test_name.name());
    $display("TAMAÑO [%0d]",array_sc.size());
    $display("TAMAÑO [%0d]",array_mon.size());
    
    $fdisplay(fa,"Test/%s",test_name.name());
    $fdisplay(fa,"Modo/%s",enum_mode.name());
    $fdisplay(fa,"FIFO/%d",fifo_size);
    
    //$display("TAMAÑO BEFORE CLEAN SC [%0d] path [%0d]",array_sc.size(),real_path.size());
    foreach (real_path[i]) begin
      array_sc[real_path[i].data_out[pckg_sz-9:0]].path[real_path[i].list_r][real_path[i].list_c]=0;
      if(array_sc[real_path[i].data_out[pckg_sz-9:0]].jump == 0) array_sc[real_path[i].data_out[pckg_sz-9:0]].jump = 1;
      //$display("Cantidad de saltos [%0d]",array_sc[real_path[i].data_out[pckg_sz-9:0]].jump);
    end;
    
    foreach (array_sc[k]) begin
      jump_prom = jump_prom + array_sc[k].jump;
      break_path = 0;
      //$display("PATH [%p]",array_sc[k].ruta);
      for (int i = 0; i <=5 ; i++)begin
        for (int j = 0; j <= 5; j++) begin
          if(array_sc[k].path[i][j] == 1) begin
            $display("\nERROR: PAQUETE [%0b] FUENTE [%0d][%0d] TARGET [%0d][%0d] MODO[%0b]",array_sc[k].paquete,array_sc[k].row,array_sc[k].colum,array_sc[k].paquete[pckg_sz-9:pckg_sz-12],array_sc[k].paquete[pckg_sz-13:pckg_sz-16],array_sc[k].paquete[pckg_sz-17]);
            $display("NO ENTRÓ A LA TERMINAL [%0d][%0d]",i,j);
            break_path = 1;
            break;
          end
          if(break_path) break;
        end
      end
    end;
    
    foreach (array_mon[i]) begin
      prom = prom+array_mon[i].tiempo - array_sc[i].transaction_time;
    end;
    $fdisplay(fa,"Transacciones/%0d",array_sc.size());
    $fdisplay(fa,"Recibidas/%0d",array_mon.size());
    $fdisplay(fa,"Saltos/%0d",jump_prom/array_sc.size());
    $fdisplay(fa,"Delay/%0d",prom/array_mon.size);
   	
    foreach (array_mon[i]) begin
      array_sc.delete(i);
    end;
    $fdisplay(fa,"Perdidos/%0d",array_sc.size);
    
    if(array_sc.size !=0)begin
      foreach (array_sc[i]) begin
        $display("[%0d] El paquete [%0d] del driver [%0d][%0d] NO LLEGÓ AL DRIVER DESTINO [%0d][%0d]",count,i, array_sc[i].row,array_sc[i].colum,array_sc[i].paquete[pckg_sz-9:pckg_sz-12],array_sc[i].paquete[pckg_sz-13:pckg_sz-16]);
        count = count +1;
      end;
    end
    else $display("TODOS LOS PAQUETES LLEGARON A SU DESTINO, %0d", real_path.size());
    
  endtask
  
endclass
