
`timescale 1ns/10ps

`include "Router_library.sv"
`include "Ambiente.sv"
`include "Test.sv"
`include "func_coverage.sv"
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
  
  	tst_chk_mbx tst_chk_mbx;

	tb_tst_mbx tb_tst_mbx;
    tb_tst tb_tst_transaction;
	



  	Ambiente #(.Drivers(Drivers), .pckg_sz(pckg_sz), .fifo_size(fifo_size), 
            .ROWS(ROWS), .COLUMS(COLUMS)) ambiente;
    	Test #(.drvrs(Drivers), .pckg_sz(pckg_sz), .fifo_size(fifo_size),
            .ROWS(ROWS), .COLUMS(COLUMS)) test;
	
	coverage #(.pckg_sz(pckg_sz)) coverage;

	

	initial begin
		
		forever begin
        		#1
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
	coverage = new();
	ambiente = new();
	test = new();
	tst_gen_mbx = new();
	tb_tst_mbx = new();
      tst_chk_mbx = new();
	test.tb_tst_mbx = tb_tst_mbx;
	test.tst_gen_mbx = tst_gen_mbx;
      test.tst_chk_mbx =tst_chk_mbx;
	ambiente.generador.tst_gen_mbx = tst_gen_mbx;
    ambiente.chk.tst_chk_mbx = tst_chk_mbx;


  		for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
    			automatic int k = i;
     			//$display("Driver [%0d] id_row: %0d id_col: %0d",i,driver[k].self_row,driver[k].self_col);
    			ambiente.driver[k].fifo_in.v_if = v_if;
    			ambiente.monitor[k].v_if = v_if;
  		end
	fork
		ambiente.run();
		test.run();
		coverage.run();
	join_none
	
	`test_case(normal_test,random);

	#5000
	ambiente.report();
    #5000
	
	
	//coverage.display_coverage();
	`test_case(source_burst,mode_1);

    #5000
	ambiente.report();
     #5000
    
        `test_case(source_burst,mode_0);
      
    #5000
	ambiente.report();
     #5000
      `test_case(source_burst,random);
      
	#5000
	ambiente.report();
     #5000
	`test_case(id_burst,mode_1);
	

	#5000
	ambiente.report();
     #5000
        `test_case(id_burst,mode_0);
      
      
    #5000
	ambiente.report();
     #5000
      `test_case(id_burst,random);

	#5000
    ambiente.report();
     #5000
      `test_case(even_source_load,mode_0);
      
    #5000
    ambiente.report();
       #5000
      `test_case(even_source_load,mode_1);
      
     #5000
    ambiente.report();
       #5000
      `test_case(even_source_load,random);
    #5000
    ambiente.report();
	 #5000
      `test_case(itself_messages,random);
    #5000
    ambiente.report();
    
    $display("///////////////////TEST FINISHED///////////////////");
	coverage.display_coverage();
	
	$finish;
  	end



	




  endmodule
