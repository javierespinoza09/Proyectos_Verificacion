// Code your testbench here
// or browse Examples
`timescale 1ns/10ps
`include "Driver"
`include "example_agente"
`include "checker_scoreboard"
`include "Generador"
//`include "bus_if.sv"


module agente_driver_tb;
reg reset_tb,clk_tb;
parameter Drivers = 4;
parameter pckg_sz = 16;

  //Clases de los módulos//
    Driver #(.drvrs(Drivers)) driver [Drivers];
    Agente #(.drvrs(Drivers), .pckg_sz(pckg_sz)) agente;
    bus_if #(.drvrs(Drivers), .pckg_sz(pckg_sz)) v_if (.clk(clk_tb));
  	Generador #(.drvrs(Drivers), .pckg_sz(pckg_sz)) generador;
  	checker_scoreboard  chk_sb_m;
  //  v_if.rst = reset_tb;
   
  ///////////////////////////
  //inicializar los mailbox//
  ///////////////////////////
    //ag_chk_sb_mbx ag_chk_sb_mbx = new();
    ag_dr_mbx ag_dr_mbx[Drivers];
    initial begin
	    for(int i = 0; i < Drivers; i++) begin
		   automatic int k = i;
		   ag_dr_mbx[k] = new();

    end
    end
  
  gen_ag_mbx gen_ag_mbx = new();
  ag_chk_sb_mbx ag_chk_sb_mbx = new();
  mon_chk_sb_mbx mon_chk_sb_mbx = new();
  tst_gen_mbx tst_gen_mbx = new ();
  //////////////////
  //instanciar DUT//
  //////////////////
  bs_gnrtr_n_rbtr  #(.drvrs(Drivers)) DUT_0 (.clk(v_if.clk),
                         .reset(reset_tb),
                         .pndng(v_if.pndng),
                         .push(v_if.push),
                         .pop(v_if.pop),
                         .D_pop(v_if.D_pop),
                         .D_push(v_if.D_push)
                        );
  
  
  
  
//clase de prueba
  //gen_ag gen_ag_transaction;
  tst_gen tst_gen_transaction;
  
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
	agente = new();
    generador = new();
    tst_gen_transaction = new();
  	tst_gen_transaction.caso = broadcast;
  	generador.tst_gen_mbx = tst_gen_mbx;
    tst_gen_mbx.put(tst_gen_transaction);
  	agente.gen_ag_mbx = gen_ag_mbx;
  	generador.gen_ag_mbx = gen_ag_mbx;
  	agente.ag_chk_sb_mbx = ag_chk_sb_mbx;
  	
    generador.run();
  	//gen_ag_transaction = new();
	//gen_ag_transaction.cant_datos = 10;
    //gen_ag_mbx.put(gen_ag_transaction);
  	chk_sb_m = new();
  	chk_sb_m.ag_chk_sb_mbx = ag_chk_sb_mbx;
  	chk_sb_m.mon_chk_sb_mbx = mon_chk_sb_mbx;
	for (int i = 0; i<Drivers; i++ ) begin

            automatic int k = i;
            driver[k] = new(k);
            ///////////////
            //constraints//
            ///////////////
            agente.ag_dr_mbx_array[k] = ag_dr_mbx[k];
            driver[k].ag_dr_mbx = ag_dr_mbx[k];
            driver[k].v_if = v_if;
           $display("Driver %0d",driver[k].drv_num);
        end

 
  	fork
		agente.run();
        chk_sb_m.run();

		for(int i = 0; i<Drivers; i++ ) begin
			fork	
     					automatic int k = i;
					driver[k].run();
				
			
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
