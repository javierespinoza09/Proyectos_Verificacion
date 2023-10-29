class scoreboard #(parameter pckg_sz = 20);
  drv_sb_mbx #(.pckg_sz(pckg_sz)) drv_sb_mbx;
  drv_sb #(.pckg_sz(pckg_sz)) drv_sb_transaction;
  
  sb_chk_mbx #(.pckg_sz(pckg_sz)) sb_chk_mbx;
  int r;
  int c;
  int rr;
  int cc;
  integer num = 1'h0;
  task run();
    forever begin
 
      drv_sb_mbx.get(drv_sb_transaction);
      r = drv_sb_transaction.row;
      c = drv_sb_transaction.colum;
      if(r == 0) r = 1;
      if(c == 0) c = 1;
      if(r == 5) r = 4;
      if(c == 5) c = 4;
      //$display("Valor de R %0d C %0d",r,c);
      //$display("MODE: [%0d]",drv_sb_transaction.paquete[pckg_sz-17]);
      //$display("ORI: [%0d] [%0d] DIR: [%0d] [%0d]",drv_sb_transaction.row,drv_sb_transaction.colum, drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12], drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16]);
      case(drv_sb_transaction.paquete[pckg_sz-17])
        0:begin
          if(((drv_sb_transaction.row <=drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12]))&(drv_sb_transaction.listo !=1)) begin
            if((drv_sb_transaction.colum <= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])&(drv_sb_transaction.listo !=1))begin
              
              rr = r;
              cc = c;
              while((cc< drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])&(cc<4))begin
                //$display("Va de R %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc++;
               end
              while(rr<= drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12])begin
                //$display("Vainside de R %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr++;
              end
          	end
          	else begin
              rr = r;
              cc = c;
              while((cc > drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])&(cc>=2))begin
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc--;
               end
              while(rr<= drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12])begin
               // $display("Valores de R %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr++;
              end
            end
          end
          if(((drv_sb_transaction.row >= drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12]))&(drv_sb_transaction.listo !=1)) begin
            //$display("ORI: [%0d] [%0d] DIR: [%0d] [%0d]",drv_sb_transaction.row,drv_sb_transaction.colum, drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12], drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16]);
            if((drv_sb_transaction.colum <= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])&(drv_sb_transaction.listo !=1))begin
              rr = r;
              cc = c;
              while((cc< drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])&(cc<=3))begin
                //$display("Valores de R %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc++;
              end
              while((rr>= drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12])&(rr>=2))begin
                //$display("Valores de R %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr--;
               end
          	end
          	else begin
              //$display("ORI: [%0d] [%0d] DIR: [%0d] [%0d]",drv_sb_transaction.row,drv_sb_transaction.colum, drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12], drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16]);
              rr = r;
              cc = c;
              //$display("rr[%0d] y cc[%0d]",rr,cc);
              while((cc > drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])&(cc>1))begin
                //$display("Valores de R %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc--;
               end
              //$display("REF RR %0d row %0d",rr,drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12]);
              while((rr >= drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12])&(rr>=1))begin
                //$display("Valoress de R %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr--;
              end
            end
          end
        end
        1:begin
         // $display("Valor de R %0d C %0d",r,c);
          if(((drv_sb_transaction.row <=drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12]))&(drv_sb_transaction.listo !=1)) begin
            if((drv_sb_transaction.colum <= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])&(drv_sb_transaction.listo !=1))begin
              //$display("ORI: [%0d] [%0d] DIR: [%0d] [%0d]",drv_sb_transaction.row,drv_sb_transaction.colum, drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12], drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16]);
              rr = r;
              cc = c;
              while((rr< drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12])&(rr<=3))begin
                //$display("Valores de R- %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr++;
              end
              while((cc<= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])&(cc<=3))begin
                //$display("Valores de R- %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc++;
               end
          	end
          	else begin
              rr = r;
              cc = c;
              //$display("ORI: [%0d] [%0d] DIR: [%0d] [%0d]",drv_sb_transaction.row,drv_sb_transaction.colum, drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12], drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16]);
              while((rr< drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12])&(rr<=3))begin
                //$display("Validación de R %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr++;
               end
              while(cc > drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])begin
                //$display("Valores de R %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc--;
              end
            end
          end
          
          if(((drv_sb_transaction.row >= drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12]))&(drv_sb_transaction.listo !=1)) begin
            if((drv_sb_transaction.colum <= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])&(drv_sb_transaction.listo !=1))begin
              //$display("ORI: [%0d] [%0d] DIR: [%0d] [%0d]",drv_sb_transaction.row,drv_sb_transaction.colum, drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12], drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16]);
              rr = r;
              cc = c;
              while((rr> drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12])&(rr>=2))begin
               //$display("Valores de R- %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr--;
               end
              while((cc<= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])&(cc<=3))begin
                //$display("Valores de R %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc++;
              end
          	end
          	else begin
              rr = r;
              cc = c;
             // $display("rr[%0d] y cc[%0d]",rr,cc);
              while((rr > drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12])&(rr>1))begin
               // $display("Valores de R %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr--;
               end
              while((cc > drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])&(cc>=1))begin
                //$display("Valores de R %0d C %0d",rr,cc);
                drv_sb_transaction.path[rr][cc] = 1;
                drv_sb_transaction.ruta[{rr,cc}]=1;
                drv_sb_transaction.listo = 1;
                drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc--;
              end
            end
          end
        end
      endcase
      sb_chk_mbx.put(drv_sb_transaction);
     /*
      $display("SE ENVIÓ UN PAQUETE AL CHK ");
      $display("SALIDA [%0d][%0d] DESTINO [%0d][%0d] modo [%0d]",drv_sb_transaction.row,drv_sb_transaction.colum,drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12],drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16],drv_sb_transaction.paquete[pckg_sz-17]);
    for (int i = 0; i <=5 ; i++)begin
      for (int j = 0; j <= 5; j++) begin
        if(drv_sb_transaction.path[i][j]==1)$display("ruta [%0d][%0d]",i,j);
      end
    end*/
    
      
    end 
  endtask
  
endclass