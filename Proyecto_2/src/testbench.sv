
`timescale 1ns/10ps
//`include "router_if.sv"

//`define LIB
`include "Router_library.sv"
//`include "checker.sv"
`include "driver.sv"
`include "listener.sv"
`include "Agente.sv"
`include "Generador.sv"
`include "scoreboard.sv"
`include "Monitor.sv"
//`include "Clases_mailbox.sv"
`include "checker.sv"


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
  Generador #(.drvrs(Drivers), .pckg_sz(pckg_sz)) generador;
  listener listener;
  scoreboard #(.pckg_sz(pckg_sz)) sb;
  _checker #(.pckg_sz(pckg_sz)) chk;
 
	
  
  gen_ag_mbx gen_ag_mbx;
  //gen_ag gen_ag_transaction;
  list_chk_mbx list_chk_mbx;
  list_chk transaction;
  drv_sb_mbx #(.pckg_sz(pckg_sz)) drv_sb_mbx;
  sb_chk_mbx #(.pckg_sz(pckg_sz)) sb_chk_mbx;
  mon_chk_mbx mon_chk_mbx;

  /////Temporal Pruebas Generador//////
  ////////////////////////////////////
  tst_gen_mbx tst_gen_mbx;
  tst_gen tst_gen_transaction;

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
   generador = new();
   tst_gen_mbx = new();
   gen_ag_mbx = new();
   list_chk_mbx = new();
   drv_sb_mbx = new();
   sb_chk_mbx = new();
   mon_chk_mbx = new();
   
   
  for(int i = 0; i < COLUMS*2+ROWS*2; i++) begin
    automatic int k = i;
    ag_dr_mbx[k] = new();
    
  end
   chk = new();
   chk.sb_chk_mbx =sb_chk_mbx;
   chk.mon_chk_mbx = mon_chk_mbx;
   chk.list_chk_mbx = list_chk_mbx;
   sb = new();
   sb.drv_sb_mbx=drv_sb_mbx;
   sb.sb_chk_mbx = sb_chk_mbx;
   listener=new();
   //listener.v_if = v_if;
   listener.list_chk_mbx = list_chk_mbx;



  #50;
   agente = new();
   agente.gen_ag_mbx = gen_ag_mbx;
   generador.gen_ag_mbx = gen_ag_mbx;
   generador.tst_gen_mbx = tst_gen_mbx;
  for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
    automatic int k = i;
    driver[k] = new(k);
    driver[k].ag_dr_mbx = ag_dr_mbx[k];
    driver[k].drv_sb_mbx = drv_sb_mbx;
    monitor[k] = new(k);
    monitor[k].mon_chk_mbx = mon_chk_mbx;
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
    chk.run_sc();
    chk.run_mon();
    chk.listeners();
    generador.run();
    for(int i = 0; i<COLUMS*2+ROWS*2; i++ ) begin
      fork
      automatic int k = i;
        driver[k].run();
        monitor[k].run();
      join_none
    end
  join_none
   
	
	tst_gen_transaction = new();
	tst_gen_transaction.caso = normal;
	tst_gen_transaction.mode = mode_0;
	tst_gen_mbx.put(tst_gen_transaction);

	/*
	#200
	tst_gen_transaction = new();
        tst_gen_transaction.caso = normal;
        tst_gen_transaction.mode = mode_1;
        tst_gen_mbx.put(tst_gen_transaction);	
        */
   /*
   gen_ag_transaction = new();
   gen_ag_transaction.cant_datos = 30;
   gen_ag_transaction.id_modo = normal_id;
   gen_ag_transaction.id_rand = 1;
   gen_ag_transaction.id_row = 1;
   gen_ag_transaction.id_colum = 0;
   gen_ag_transaction.source_rand = 1;
   gen_ag_transaction.source = 0;
   gen_ag_transaction.mode = random;
   
   
   gen_ag_mbx.put(gen_ag_transaction);
     */
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
#10000;
  
    chk.report();
  

  $finish;
end
endmodule
