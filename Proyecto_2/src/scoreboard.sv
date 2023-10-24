class scoreboard #(parameter pckg_sz = 20);
  drv_sb_mbx #(.pckg_sz(pckg_sz)) drv_sb_mbx;
  drv_sb #(.pckg_sz(pckg_sz)) drv_sb_transaction;
  
  sb_chk_mbx #(.pckg_sz(pckg_sz)) sb_chk_mbx;
  
  task run();
    forever begin
 
      drv_sb_mbx.get(drv_sb_transaction);
      $display("MODE: [%0d]",drv_sb_transaction.paquete[pckg_sz-17]);
      $display("ORI: [%0d] [%0d] DIR: [%0d] [%0d]",drv_sb_transaction.row,drv_sb_transaction.colum, drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12], drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16]);
      case(drv_sb_transaction.paquete[pckg_sz-17])
        0:begin
          if((drv_sb_transaction.row <=drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12])) begin
            if(drv_sb_transaction.colum <= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])begin
              for(int r = drv_sb_transaction.row; r<= drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12];r++)begin
                for (int c = drv_sb_transaction.colum; c<= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16];c++ )begin
                  //$display("Valor de R %0d C %0d",r,c);
                  drv_sb_transaction.path[r][c] = 1;
                end
              end
          	end
          	else begin
              for(int r = drv_sb_transaction.row; r<= drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12];r++)begin
                for (int c = drv_sb_transaction.colum+1; c > drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16];c-- )begin
                  //$display("Valor de R %0d C %0d",r,c-1);
                  drv_sb_transaction.path[r][c-1] = 1;
                end
              end
            end
          end
          if((drv_sb_transaction.row >= drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12])) begin
            if(drv_sb_transaction.colum <= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])begin
              for(int r = drv_sb_transaction.row+1; r> drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12];r--)begin
                for (int c = drv_sb_transaction.colum; c<= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16];c++ )begin
                  //$display("Valor de R %0d C %0d",r,c);
                  drv_sb_transaction.path[r-1][c] = 1;
                end
              end
          	end
          	else begin
              for(int r = drv_sb_transaction.row+1; r > drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12];r--)begin
                for (int c = drv_sb_transaction.colum+1; c > drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16];c--)begin
                  //$display("Valor de R %0d C %0d",r,c);
                  drv_sb_transaction.path[r-1][c-1] = 1;
                end
              end
            end
          end
        end
        1:begin
          if((drv_sb_transaction.row <=drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12])) begin
            if(drv_sb_transaction.colum <= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])begin
              for(int r = drv_sb_transaction.row; r<= drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12];r++)begin
                for (int c = drv_sb_transaction.colum; c<= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16];c++ )begin
                  //$display("Valor de R %0d C %0d",r,c);
                  drv_sb_transaction.path[r][c] = 1;
                end
              end
          	end
          	else begin
              for(int r = drv_sb_transaction.row; r<= drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12];r++)begin
                for (int c = drv_sb_transaction.colum+1; c > drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16];c-- )begin
                  //$display("Valor de R %0d C %0d",r,c-1);
                  drv_sb_transaction.path[r][c-1] = 1;
                end
              end
            end
          end
          if((drv_sb_transaction.row >= drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12])) begin
            if(drv_sb_transaction.colum <= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16])begin
              for(int r = drv_sb_transaction.row+1; r> drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12];r--)begin
                for (int c = drv_sb_transaction.colum; c<= drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16];c++ )begin
                  //$display("Valor de R %0d C %0d",r,c);
                  drv_sb_transaction.path[r-1][c] = 1;
                end
              end
          	end
          	else begin
              for(int r = drv_sb_transaction.row+1; r > drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12];r--)begin
                for (int c = drv_sb_transaction.colum+1; c > drv_sb_transaction.paquete[pckg_sz-13:pckg_sz-16];c--)begin
                  //$display("Valor de R %0d C %0d",r,c);
                  drv_sb_transaction.path[r-1][c-1] = 1;
                end
              end
            end
          end
        end
      endcase
    
    /*$display("FIFO R[%0d] C[%0d] Paquete %b",drv_sb_transaction.row,drv_sb_transaction.colum,drv_sb_transaction.paquete);
    for (int i = 0; i <=5 ; i++)begin
      for (int j = 0; j <= 5; j++) begin
        $display("[%0d]",drv_sb_transaction.path[i][j]);
      end
    end
    */
      sb_chk_mbx.put(drv_sb_transaction);
    end 
  endtask
  
endclass