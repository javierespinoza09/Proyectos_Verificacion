`timescale 1ns/10ps
//`include "router_if.sv"
`include "driver.sv"
`include "Router_library.sv"
module router_tb;
reg clk_tb,reset_tb;

parameter pckg_sz = 20;
parameter fifo_size = 4;
parameter broadcast = {8{1'b1}};
parameter id_column = 0;
parameter id_row = 0;
parameter column = 2;
parameter row = 2;
parameter Drivers = column*2+row*2;
  
  Driver #(.drvrs(Drivers), .pckg_sz(pckg_sz), .fifo_size(fifo_size), .row(row), .column(column)) driver [row*2+column*2];
  ag_dr_mbx #(.drvrs(Drivers), .pckg_sz(pckg_sz)) ag_dr_mbx [column*2+row*2];//Mailbox con el agente
  ag_dr #(.drvrs(Drivers), .pckg_sz(pckg_sz)) ag_dr_transaction;
  
  
  

initial begin
  $dumpfile("test_router.vcd");
  $dumpvars(0,router_tb);
end


	router_if #(.ROWS(row), .COLUMS(column), .pckg_sz(pckg_sz),.fifo_depth(fifo_size), .bdcst(broadcast)) v_if (.clk(clk_tb));
  
  

  mesh_gnrtr #(.ROWS(row), .COLUMS(column), .pckg_sz(pckg_sz),.fifo_depth(fifo_size), .bdcst(broadcast)) DUT (
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
  
  
  for(int i = 0; i < column*2+row*2; i++) begin
    automatic int k = i;
    ag_dr_mbx[k] = new();
    
  end
  
  
  for (int i = 0; i<row*2+column*2; i++ ) begin
    automatic int k = i;
    driver[k] = new(k);
    driver[k].ag_dr_mbx = ag_dr_mbx[k];
    driver[k].fifo_in.v_if = v_if;
    //driver[k].ag_chk_sb_mbx = ag_chk_sb_mbx;
  end
  
  for(int i = 0; i<column*2+row*2; i++ ) begin
    fork
    automatic int k = i;
      driver[k].run();
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
