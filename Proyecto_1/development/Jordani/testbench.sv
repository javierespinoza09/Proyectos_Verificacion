// Code your testbench here
// or browse Examples
`timescale 1ns/10ps
`include "Driver.sv"
`include "agente.sv"
`include "checker_scoreboard.sv"
`include "Generador.sv"
`include "Monitor.sv"
`include "Test.sv"
//`include "Library.sv"



module agente_driver_tb;
reg reset_tb,clk_tb;
parameter Drivers = 6;
parameter pckg_sz = 32;
parameter fifo_size = 8;

  //Clases de los módulos//
    Driver #(.drvrs(Drivers), .pckg_sz(pckg_sz), .fifo_size(fifo_size)) driver [Drivers];
    Agente #(.drvrs(Drivers), .pckg_sz(pckg_sz)) agente;
  	Monitor #(.drvrs(Drivers), .pckg_sz(pckg_sz)) monitor[Drivers];
    bus_if #(.drvrs(Drivers), .pckg_sz(pckg_sz)) v_if (.clk(clk_tb));
  	Generador #(.drvrs(Drivers), .pckg_sz(pckg_sz)) generador;
    Test #(.drvrs(Drivers), .pckg_sz(pckg_sz)) test;
  	checker_scoreboard #(.drvrs(Drivers), .pckg_sz(pckg_sz)) chk_sb_m;
  //  v_if.rst = reset_tb;
   
  ///////////////////////////
  //inicializar los mailbox//
  ///////////////////////////
    //ag_chk_sb_mbx ag_chk_sb_mbx = new();
    ag_dr_mbx #(.drvrs(Drivers), .pckg_sz(pckg_sz)) ag_dr_mbx[Drivers];
  	mon_chk_sb_mbx mon_chk_sb_mbx[Drivers];
    
  
  gen_ag_mbx gen_ag_mbx= new();
  ag_chk_sb_mbx #(.packagesize(pckg_sz)) ag_chk_sb_mbx = new();
  
  tst_gen_mbx tst_gen_mbx = new ();
  //////////////////
  //instanciar DUT//
  //////////////////
  
  
  
  initial begin
	    for(int i = 0; i < Drivers; i++) begin
		   automatic int k = i;
		   ag_dr_mbx[k] = new();
           mon_chk_sb_mbx[k] = new();

    end
    end
  
  
  bs_gnrtr_n_rbtr  #(.drvrs(Drivers), .pckg_sz(pckg_sz)) DUT_0 (.clk(v_if.clk),
                         .reset(reset_tb),
                         .pndng(v_if.pndng),
                         .push(v_if.push),
                         .pop(v_if.pop),
                         .D_pop(v_if.D_pop),
                         .D_push(v_if.D_push)
                        );
  
  
  
  
//clase de prueba
  //gen_ag gen_ag_transaction;
  //tst_gen tst_gen_transaction;
  
///////////////////////  
//Ciclo de ejecución// 
/////////////////////
  
initial begin
  $dumpfile("test_bus.vcd");
  $dumpvars(0,agente_driver_tb);
end

initial begin
forever begin
	#5
	clk_tb = ~clk_tb;
end
end

initial begin
    clk_tb = 0;
    reset_tb = 1;
    #50
    reset_tb = 0;
    
end
initial begin
	//monitor = new(0);
	agente = new();
    generador = new();
    test = new();
    //tst_gen_transaction = new();
  	//tst_gen_transaction.caso = normal;
  	generador.tst_gen_mbx = tst_gen_mbx;
  	test.tst_gen_mbx = tst_gen_mbx;
    //tst_gen_mbx.put(tst_gen_transaction);
    test.run();
  	agente.gen_ag_mbx = gen_ag_mbx;
  	generador.gen_ag_mbx = gen_ag_mbx;
  	agente.ag_chk_sb_mbx = ag_chk_sb_mbx;
  	
    generador.run();
  	//gen_ag_transaction = new();
	//gen_ag_transaction.cant_datos = 10;
    //gen_ag_mbx.put(gen_ag_transaction);
  	chk_sb_m = new();
  	chk_sb_m.ag_chk_sb_mbx = ag_chk_sb_mbx;
  	//chk_sb_m.mon_chk_sb_mbx = mon_chk_sb_mbx;
	for (int i = 0; i<Drivers; i++ ) begin

            automatic int k = i;
            driver[k] = new(k);
     		monitor[k] = new(k);
            ///////////////
            //constraints//
            ///////////////
            agente.ag_dr_mbx_array[k] = ag_dr_mbx[k];
      		chk_sb_m.mon_chk_sb_mbx[k] = mon_chk_sb_mbx[k];
      		monitor[k].mon_chk_sb_mbx = mon_chk_sb_mbx[k];
            driver[k].ag_dr_mbx = ag_dr_mbx[k];
            driver[k].fifo_in.v_if = v_if;
      		monitor[k].v_if = v_if;
           $display("Driver %0d",driver[k].drv_num);
        end

 
  	fork
		agente.run();
        chk_sb_m.run();

		for(int i = 0; i<Drivers; i++ ) begin
			fork	
              automatic int k = i;
              driver[k].run();
              monitor[k].run();
				
			join_none	
		end
//		agente.run();
	join_none
  
end
  
initial begin
  #5000
  for(int i = 0; i<Drivers; i++ ) begin
    fork	
      automatic int k = i;
      driver[k].report();
    
    join_none	
  end
  chk_sb_m.report_sb();
end
  
initial begin
#10000
  $finish;
end
endmodule
