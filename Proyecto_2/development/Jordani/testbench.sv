`timescale 1ns/10ps
//`include "router_if.sv"
`include "driver.sv"
`include "Monitor.sv"
//`define LIB
//`include "Router_library.sv"
//DEBUG

module router_tb;
reg clk_tb,reset_tb;

parameter pckg_sz = 40;
parameter fifo_size = 4;
parameter broadcast = {pckg_sz-18{1'b1}};
parameter id_column = 0;
parameter id_row = 0;
parameter COLUMS = 2;
parameter ROWS = 2;
parameter Drivers = COLUMS*2+ROWS*2;
  
  Driver #(.drvrs(Drivers), .pckg_sz(pckg_sz), .fifo_size(fifo_size), .ROWS(ROWS), .COLUMS(COLUMS)) driver [ROWS*2+COLUMS*2];
  ag_dr_mbx #(.pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS)) ag_dr_mbx [Drivers];//Mailbox con el agente
  ag_dr #(.pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS)) ag_dr_transaction;
  Monitor #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz)) monitor [Drivers];
  
  
  

initial begin
  $dumpfile("test_router.vcd");
  $dumpvars(0,router_tb);
end


router_if #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz),.fifo_depth(fifo_size)) v_if (.clk(clk_tb));
  
  

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
  
  for(int i = 0; i < COLUMS*2+ROWS*2; i++) begin
    automatic int k = i;
    ag_dr_mbx[k] = new();
    
  end
  #50;
  
  for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
    automatic int k = i;
    driver[k] = new(k);
    monitor[k] = new(k);
    driver[k].ag_dr_mbx = ag_dr_mbx[k];
  end
   
   for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
    automatic int k = i;
    driver[k].fifo_in.v_if = v_if;
    monitor[k].v_if = v_if;
  end
  
  for(int i = 0; i<COLUMS*2+ROWS*2; i++ ) begin
    fork
    automatic int k = i;
      driver[k].run();
      monitor[k].run();
    join_none
  end
  
  for(int i = 0; i < 6; i++) begin
    automatic int k = i;
     ag_dr_transaction = new();
     ag_dr_transaction.randomize();
     ag_dr_transaction.Nxt_jump = 0;
     ag_dr_mbx[k].put(ag_dr_transaction);
     $display("Nxt_jump = %b id_row = %b id_col = %b mode = %b dato = %b", ag_dr_transaction.Nxt_jump,ag_dr_transaction.id_row,ag_dr_transaction.id_colum,ag_dr_transaction.mode,ag_dr_transaction.dato);
    
  end
  
  
  
end
  


initial begin
#5000;
  $finish;
end
endmodule
