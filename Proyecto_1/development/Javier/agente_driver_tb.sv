`timescale 1ns/10ps
`include "Driver.sv"
`include "example_agente.sv"
//`include "bus_if.sv"
`include "Library.sv"

module agente_driver_tb;
reg reset_tb,clk_tb;
parameter Drivers = 4;
parameter pckg_sz = 16;

  
    Driver #(.drvrs(Drivers)) driver [Drivers-1:0];
    Agente #(.drvrs(Drivers), .pckg_sz(pckg_sz)) agente;
    bus_if #(.drvrs(Drivers), .pckg_sz(pckg_sz)) v_if (.clk(clk_tb));
  //  v_if.rst = reset_tb;
   
  ///////////////////////////
  //inicializar los mailbox//
  ///////////////////////////
    //ag_chk_sb_mbx ag_chk_sb_mbx = new();
    ag_dr_mbx ag_dr_mbx[Drivers-1:0];
    initial begin
        for(int i = 0; i < Drivers; i++) ag_dr_mbx[i] = new();
    end
  
  //////////////////
  //instanciar DUT//
  //////////////////
  bs_gnrtr_n_rbtr DUT_0 (.clk(v_if.clk),
                         .reset(reset_tb),
                         .pndng(v_if.pndng),
                         .push(v_if.push),
                         .pop(v_if.pop),
                         .D_pop(v_if.D_pop),
                         .D_push(v_if.D_push)
                        );
  
  
  
  
  
  
  
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
	agente = new(20);
    clk_tb = 0;
    reset_tb = 1;
    #50
    reset_tb = 0;
    
    //agente = new(20);

    for (int i = 0; i<Drivers; i++ ) begin
        fork 

            begin
            automatic int k = i;
            driver[k] = new(k);
            ///////////////
            //constraints//
            ///////////////
            agente.ag_dr_mbx[k] = ag_dr_mbx[k];
            driver[k].ag_dr_mbx = ag_dr_mbx[k];

           // driver[k].valid_addrs.constraint_mode(1);
            //driver[k].self_addrs.constraint_mode(1);
            ///////////////  
            //driver[k].ag_chk_sb_mbx = ag_chk_sb_mbx;
            driver[k].v_if = v_if;
            ///driver[k].randomize();
            //driver[k].display();
            $display("Driver_0x%0d",driver[k].drv_num);
        end
	join
  end 
  
  	fork
		agente.run();
		begin
  			for(int i = 0; i<Drivers; i++ ) begin
      				automatic int k = i;
				driver[k].run();
			end
		end
	join	
  
end 
initial begin
#5000;
  $finish;
end
endmodule
