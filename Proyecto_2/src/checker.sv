class _checker #(parameter pckg_sz = 20);
  
  drv_sb #(.pckg_sz(pckg_sz)) chk_sb_transaction;
  sb_chk_mbx #(.pckg_sz(pckg_sz)) sb_chk_mbx;
  
  mon_chk_mbx mon_chk_mbx;
  mon_chk mon_chk_transaction;
  
  drv_sb #(.pckg_sz(pckg_sz)) array_sc[longint];
  mon_chk array_mon[longint];
  
  list_chk_mbx list_chk_mbx;
  list_chk  list_chk_transaction;
  list_chk real_path[$];
  
  int prom = 0;
  int count = 1;
  int break_path = 0;
  
  
  
  
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
    
    /* Verifica por arreglo
    foreach (array_sc[k]) $display("PATH [%p]",array_sc[k].ruta);
    foreach (real_path[i])array_sc[real_path[i].data_out[pckg_sz-9:0]].ruta.delete({real_path[i].list_r,real_path[i].list_c});
    $display("\n\n");
    foreach (array_sc[k]) $display("PATH [%p] r[%0d] c[%0d]",array_sc[k].ruta,array_sc[k].row,array_sc[k].colum);
    $display("\n\n");
    foreach (array_sc[k]) begin
      foreach(array_sc[k].ruta[i])$display("PATH [%p] [%0d]",array_sc[k].ruta,i);
    end
    */
    
    /*
     foreach (array_sc[k]) begin
      
      $display("\nCAMBIO");
      //$display("PATH [%p]",array_sc[k].ruta);
      for (int i = 0; i <=5 ; i++)begin
        for (int j = 0; j <= 5; j++) begin
          if(array_sc[k].path[i][j] == 1) $display("ERROR [%0d]",array_sc[k].path[i][j]);
        end
      end
    end;*/
    
    //Valida por mapeo
    
    $display("REALPATH [%0d]",real_path.size());
    
    
    foreach (real_path[i]) begin
      array_sc[real_path[i].data_out[pckg_sz-9:0]].path[real_path[i].list_r][real_path[i].list_c]=0;
      if(array_sc[real_path[i].data_out[pckg_sz-9:0]].jump == 0) array_sc[real_path[i].data_out[pckg_sz-9:0]].jump = 1;
      $display("Cantidad de saltos [%0d]",array_sc[real_path[i].data_out[pckg_sz-9:0]].jump);
    end;
    
    foreach (array_sc[k]) begin
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
    
    
    /*
    $display("TAMAÑO [%0d]",array_sc.size());
    foreach (array_sc[k]) begin
      
      $display("\nCAMBIO");
      //$display("PATH [%p]",array_sc[k].ruta);
      for (int i = 0; i <=5 ; i++)begin
        for (int j = 0; j <= 5; j++) begin
          $display("[%0d]",array_sc[k].path[i][j]);
        end
      end
    end;
    
    foreach (real_path[i]) begin
      array_sc[real_path[i].data_out[pckg_sz-9:0]].path[real_path[i].list_r][real_path[i].list_c]=-1;
    end;
    
    foreach (array_sc[k]) begin
      $display("\nVERIFICADO");
      for (int i = 0; i <=5 ; i++)begin
        for (int j = 0; j <= 5; j++) begin
          $display("[%0d]",array_sc[k].path[i][j]);
        end
      end
    end;
    */
    foreach (array_mon[i]) begin
      prom = prom+array_mon[i].tiempo - array_sc[i].transaction_time;
    end;
    $display("En las transacciones completadas el retraso promedio fué de: [%0d]",prom/array_mon.size);
   	
    foreach (array_mon[i]) begin
      array_sc.delete(i);
    end;
    $display("\nSe perdieron [%0d] paquetes",array_sc.size);
    
    if(array_sc.size !=0)begin
      foreach (array_sc[i]) begin
        $display("[%0d] El paquete [%0d] del driver [%0d][%0d] NO LLEGÓ AL DRIVER DESTINO [%0d][%0d]",count,i, array_sc[i].row,array_sc[i].colum,array_sc[i].paquete[pckg_sz-9:pckg_sz-12],array_sc[i].paquete[pckg_sz-13:pckg_sz-16]);
        count = count +1;
      end;
    end
    else $display("TODOS LOS PAQUETES LLEGARON A SU DESTINO, %0d", real_path.size());
    
  endtask
  
endclass
