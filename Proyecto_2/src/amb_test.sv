`timescale 1ns/10ps

`include "Router_library.sv"
`include "Ambiente.sv"
`include "Test.sv"
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
	tst_gen tst_gen_transaction;
	tst_gen_mbx  tst_gen_mbx;
	



  	Ambiente #(.Drivers(Drivers), .pckg_sz(pckg_sz), .fifo_size(fifo_size), 
            .ROWS(ROWS), .COLUMS(COLUMS)) ambiente;
    	Test #(.drvrs(Drivers), .pckg_sz(pckg_sz), .fifo_size(fifo_size),
            .ROWS(ROWS), .COLUMS(COLUMS)) test;

	
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
	ambiente = new();
	test = new(source_burst);
	tst_gen_mbx = new();
	test.tst_gen_mbx = tst_gen_mbx;
	ambiente.generador.tst_gen_mbx = tst_gen_mbx;


  		for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
    			automatic int k = i;
     			//$display("Driver [%0d] id_row: %0d id_col: %0d",i,driver[k].self_row,driver[k].self_col);
    			ambiente.driver[k].fifo_in.v_if = v_if;
    			ambiente.monitor[k].v_if = v_if;
  		end
	fork
		ambiente.run();
		test.run();
	join_none
	/*
	tst_gen_transaction = new();
        tst_gen_transaction.caso = normal;
        tst_gen_transaction.mode = random;
        tst_gen_mbx.put(tst_gen_transaction);
	
	
	#5000
        tst_gen_transaction = new();
        tst_gen_transaction.caso = normal;
        tst_gen_transaction.mode = mode_1;
	$display("TEST: MODO [%g]", tst_gen_transaction.mode);
        tst_gen_mbx.put(tst_gen_transaction);
*/
	#10000
	ambiente.report();
	$finish;
  	end

	




  endmodule
