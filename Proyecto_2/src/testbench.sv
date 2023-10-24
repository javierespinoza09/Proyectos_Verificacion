`timescale 1ns/10ps
//`include "router_if.sv"
`include "driver.sv"
`include "Monitor.sv"
`include "Agente.sv"
//`define LIB
`include "Router_library.sv"
`include "listener.sv"
`include "scoreboard.sv"
//DEBUG

module router_tb;
reg clk_tb,reset_tb;

parameter pckg_sz = 40;
parameter fifo_size = 4;
parameter broadcast = {pckg_sz-18{1'b1}};
parameter id_column = 0;
parameter id_row = 0;
parameter COLUMS = 4;
parameter ROWS = 4;
parameter Drivers = COLUMS*2+ROWS*2;
  
  Driver #(.drvrs(Drivers), .pckg_sz(pckg_sz), .fifo_size(fifo_size), .ROWS(ROWS), .COLUMS(COLUMS)) driver [ROWS*2+COLUMS*2];
  ag_dr_mbx #(.pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS)) ag_dr_mbx [Drivers];//Mailbox con el agente
  ag_dr #(.pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS)) ag_dr_transaction;
  Monitor #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz)) monitor [Drivers];
  Agente #(.drvrs(Drivers), .pckg_sz(pckg_sz), .fifo_size(fifo_size), .ROWS(ROWS), .COLUMS(COLUMS)) agente;
  listener listener;
  scoreboard #(.pckg_sz(pckg_sz)) sb;

  
  
  gen_ag_mbx gen_ag_mbx;
  gen_ag gen_ag_transaction;
  list_chk_mbx list_chk_mbx;
  list_chk transaction;
  drv_sb_mbx #(.pckg_sz(pckg_sz)) drv_sb_mbx;
  sb_chk_mbx #(.pckg_sz(pckg_sz)) sb_chk_mbx;
  

initial begin
  $dumpfile("test_router.vcd");
  $dumpvars(0,router_tb);
end


router_if #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz),.fifo_depth(fifo_size)) v_if (.clk(clk_tb));
  
  //inner_signals #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz),.fifo_depth(fifo_size)) signals_if (.clk(clk_tb));

  mesh_gnrtr #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz),.fifo_depth(fifo_size), .bdcst(broadcast)) DUT (
  .clk(clk_tb),
  .reset(v_if.reset),
  .pndng(v_if.pndng),
  .data_out(v_if.data_out),
  .popin(v_if.popin),
  .pop(v_if.pop),
  .data_out_i_in(v_if.data_out_i_in),
  .pndng_i_in(v_if.pndng_i_in)
  );






initial begin
forever begin
	#5
	clk_tb = ~clk_tb;
end
end

initial begin
  clk_tb = 0;
  v_if.reset = reset_tb;
  reset_tb = 1;
  v_if.reset = reset_tb;
  #50
  reset_tb = 0;
  v_if.reset = reset_tb;
 end


 initial begin 
   agente = new();
   gen_ag_mbx = new();
   list_chk_mbx = new();
   drv_sb_mbx = new();
   sb_chk_mbx = new();
   
  for(int i = 0; i < COLUMS*2+ROWS*2; i++) begin
    automatic int k = i;
    ag_dr_mbx[k] = new();
    
  end
   
   sb = new();
   sb.drv_sb_mbx=drv_sb_mbx;
   sb.sb_chk_mbx = sb_chk_mbx;
   listener=new();
   listener.v_if = v_if;
   listener.list_chk_mbx = list_chk_mbx;



  #50;
   agente = new();
   agente.gen_ag_mbx = gen_ag_mbx;
  for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
    automatic int k = i;
    driver[k] = new(k);
    monitor[k] = new(k);
    driver[k].ag_dr_mbx = ag_dr_mbx[k];
    driver[k].drv_sb_mbx = drv_sb_mbx;
    agente.ag_dr_mbx_array[k] = ag_dr_mbx[k];
    
  end
   
   //Asignación a cada Driver de su propia posición 
   for (int i = 0; i<COLUMS;i++)begin
     driver[i].self_row = 0;
     driver[i].self_col = i+1;
   end
   for (int i = 0; i<ROWS;i++)begin
     driver[i+COLUMS].self_col = 0;
     driver[i+COLUMS].self_row = i+1;
   end
   for (int i = 0; i<COLUMS;i++)begin
     driver[i+ROWS*2].self_row = ROWS+1;
     driver[i+ROWS*2].self_col = i+1;
   end
   for (int i = 0; i<ROWS;i++)begin
     driver[i+COLUMS*3].self_col = COLUMS+1;
     driver[i+COLUMS*3].self_row = i+1;
   end
   
   
   for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
    automatic int k = i;
     $display("Driver [%0d] id_row: %0d id_col: %0d",i,driver[k].self_row,driver[k].self_col);
    driver[k].fifo_in.v_if = v_if;
    monitor[k].v_if = v_if;
  end
   
   
  fork
    agente.run();
	listener.run();
    sb.run();
    for(int i = 0; i<COLUMS*2+ROWS*2; i++ ) begin
      fork
      automatic int k = i;
        driver[k].run();
        monitor[k].run();
      join_none
    end
  join_none
   
   
   gen_ag_transaction = new();
   gen_ag_transaction.cant_datos = 3;
   gen_ag_transaction.data_modo = max_aleatoriedad;
   gen_ag_transaction.id_modo = normal_id;
   gen_ag_transaction.id_rand = 1;
   gen_ag_transaction.id_row = 0;
   gen_ag_transaction.id_colum = 0;
   gen_ag_transaction.source_rand = 1;
   gen_ag_transaction.source = 0;
   
   
   gen_ag_mbx.put(gen_ag_transaction);
     
     /*
     ag_dr_transaction = new();
     ag_dr_transaction.randomize();
     ag_dr_transaction.Nxt_jump = 0;
    //Este if verifica si se va a enviar un paquete a él mismo, invierte la dirección si es necesario
     if(ag_dr_transaction.id_row == driver[ag_dr_transaction.source].self_row  & ag_dr_transaction.id_colum == driver[ag_dr_transaction.source].self_col) begin
       ag_dr_transaction.id_row = driver[ag_dr_transaction.source].self_col;
       ag_dr_transaction.id_colum = driver[ag_dr_transaction.source].self_row;
     end
      ag_dr_mbx[ag_dr_transaction.source].put(ag_dr_transaction);
    $display("source = %0d id_row = %0d id_col = %0d mode = %b dato = %b", ag_dr_transaction.source,ag_dr_transaction.id_row,ag_dr_transaction.id_colum,ag_dr_transaction.mode,ag_dr_transaction.dato);
    */ 
   
   
  
end
  
initial begin
  forever begin
    list_chk_mbx.get(transaction);
    $display("\nSe recibió del listener [%0d] [%0d] el dato [%b]",transaction.list_r,transaction.list_c,transaction.data_out);
  end
end

initial begin
#5000;
  $finish;
end
endmodule
