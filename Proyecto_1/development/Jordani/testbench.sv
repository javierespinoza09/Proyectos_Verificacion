`timescale 1ns/1ps
`include "driver.sv"
`include "agente.sv"
`include "checker_scoreboard.sv"
`include "Generador.sv"
`include "Monitor.sv"
`include "Test.sv"
//`include "Library.sv"
`include "Ambiente.sv"

////////////////////
//Modulo Principal//
////////////////////
module testbench;
  
  
//mailbox hacia el Generador y Test//
tst_gen_mbx tst_gen_mbx = new();
tst_chk_sb_mbx tst_chk_sb_mbx = new();
  
  
//Parámetros de la Prueba//  
parameter drvrs = 4;
parameter pckg_sz = 16;
parameter fifo_size = 8;
parameter bits = 1;
parameter broadcast = {8{1'b1}};
reg clk_tb,reset_tb;
  
  
//Genración del Archivo de Salida//  
initial begin
  $dumpfile("test_bus.vcd");
  $dumpvars(0,testbench);
end

//Instanciación De los Módulos//  
  bus_if #(.drvrs(drvrs), .pckg_sz(pckg_sz),.bits(bits)) _if (.clk(clk_tb));       //Interfaz
bs_gnrtr_n_rbtr  #(.bits(bits),.drvrs(drvrs), .pckg_sz(pckg_sz),.broadcast(broadcast)) DUT_0 (.clk(_if.clk),.reset(_if.rst), .pndng(_if.pndng), .push(_if.push), .pop(_if.pop), .D_pop(_if.D_pop), .D_push(_if.D_push)); 							//Dispositvo Bajo Prueba

  Ambiente #(.drvrs(drvrs), .pckg_sz(pckg_sz), .fifo_size(fifo_size)) ambiente_0;  //Ambiente de pruebas
  Test #(.drvrs(drvrs), .pckg_sz(pckg_sz), .fifo_size(fifo_size)) t_0; 			   //Módulo Test


///////////////////////////////////
//Ciclo de Operación del programa//
///////////////////////////////////
initial begin
    clk_tb = 0;
    reset_tb = 1;
    _if.rst = reset_tb;
    #50
    reset_tb = 0;
    _if.rst = reset_tb;
	//Reset Inicial para el DUT Finalizado//
end

initial begin
forever begin
        #5
        clk_tb = ~clk_tb;
end
end


	
	initial begin
      	//Instanciación del Módulo Test y Conexión del MBX//
		Test t_0;
		t_0 = new();
		t_0.tst_gen_mbx = tst_gen_mbx;
		
      	//Instanciación del ambiente y sus módulos junto a sus MBX//
		ambiente_0 = new();
		ambiente_0.display();
		ambiente_0.generador.tst_gen_mbx = tst_gen_mbx;
      	ambiente_0.chk_sb.tst_chk_sb_mbx = tst_chk_sb_mbx;
		
		for (int i = 0; i<drvrs; i++ ) begin
          automatic int k = i;
          //Se Conecta la Interfaz de cada Driver y monitor a _if//
          ambiente_0.driver[k].fifo_in.v_if = _if; 
          ambiente_0.monitor[k].v_if = _if;
		
		end

		fork
          t_0.run(); 		//Inicia la prueba
          ambiente_0.run(); //Inicia las funciones run() de cada bloque del ambiente
	join_none
		
		#200000
                ambiente_0.resport();

	end
initial begin
#500000
  $finish;
end


endmodule
