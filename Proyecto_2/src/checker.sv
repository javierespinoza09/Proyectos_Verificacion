class _checker #(parameter pckg_sz = 20);
  
  drv_sb #(.pckg_sz(pckg_sz)) chk_sb_transaction;
  sb_chk_mbx #(.pckg_sz(pckg_sz)) sb_chk_mbx;
  
  mon_chk_mbx mon_chk_mbx;
  mon_chk mon_chk_transaction;
  
  drv_sb #(.pckg_sz(pckg_sz)) array_sc[longint];
  mon_chk array_mon[longint];
  
  int prom = 0;
  int count = 1;
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

//      $display("\nHASH MON Key [%d]",mon_chk_transaction.key);

    end
    
 
  endtask
  
  task report();
    
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
    else $display("TODOS LOS PAQUETES LLEGARON A SU DESTINO");
    
  endtask
  
endclass
