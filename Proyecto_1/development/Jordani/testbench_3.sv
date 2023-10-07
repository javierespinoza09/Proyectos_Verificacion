`timescale 1ns/1ps
`include "Driver.sv"
`include "agente.sv"
`include "checker_scoreboard.sv"
`include "Generador.sv"
`include "Monitor.sv"
`include "Test.sv"
//`include "Library.sv"
`include "Ambiente.sv"

module testbench;
tst_gen_mbx tst_gen_mbx = new();
tst_chk_sb_mbx tst_chk_sb_mbx = new();
parameter drvrs = 4;
parameter pckg_sz = 16;
parameter fifo_size = 16;
parameter bits = 1;
parameter broadcast = {8{1'b1}};
reg clk_tb,reset_tb;
initial begin
  $dumpfile("test_bus.vcd");
  $dumpvars(0,testbench);
end

bus_if #(.drvrs(drvrs), .pckg_sz(pckg_sz),.bits(bits)) _if (.clk(clk_tb));
bs_gnrtr_n_rbtr  #(.bits(bits),.drvrs(drvrs), .pckg_sz(pckg_sz),.broadcast(broadcast)) DUT_0 (.clk(_if.clk),.reset(_if.rst), .pndng(_if.pndng), .push(_if.push), .pop(_if.pop), .D_pop(_if.D_pop), .D_push(_if.D_push));

Ambiente #(.drvrs(drvrs), .pckg_sz(pckg_sz), .fifo_size(fifo_size)) ambiente_0;
  Test #(.drvrs(drvrs), .pckg_sz(pckg_sz), .fifo_size(fifo_size)) t_0,t_1,t_2,t_3;


initial begin
    clk_tb = 0;
    reset_tb = 1;
    _if.rst = reset_tb;
    #50
    reset_tb = 0;
    _if.rst = reset_tb;

end

initial begin
forever begin
        #5
        clk_tb = ~clk_tb;
end
end



	initial begin
		
		t_0 = new(all_to_one);
		t_0.tst_gen_mbx = tst_gen_mbx;
      	t_0.tst_chk_sb_mbx = tst_chk_sb_mbx;
		t_0.source = 0;
		t_0.id = 2;
		
		ambiente_0 = new();
		ambiente_0.display();
		ambiente_0.generador.tst_gen_mbx = tst_gen_mbx;
      	ambiente_0.chk_sb.tst_chk_sb_mbx = tst_chk_sb_mbx;
		//ambiente_0.v_if = _if;
		for (int i = 0; i<drvrs; i++ ) begin

                        automatic int k = i;
			ambiente_0.driver[k].fifo_in.v_if = _if;
                	ambiente_0.monitor[k].v_if = _if;
		
		end

		fork
			t_0.run();
		ambiente_0.run();
		join_none
		
		#200000
                ambiente_0.resport(0);
		
		disable fork;
		////////////////////////////////////////////////////
				t_1 = new(normal);
                t_1.tst_gen_mbx = tst_gen_mbx;
                t_1.tst_chk_sb_mbx = tst_chk_sb_mbx;
                
                ambiente_0 = new();
                ambiente_0.display();
                ambiente_0.generador.tst_gen_mbx = tst_gen_mbx;
                ambiente_0.chk_sb.tst_chk_sb_mbx = tst_chk_sb_mbx;
                //ambiente_0.v_if = _if;
                for (int i = 0; i<drvrs; i++ ) begin

                        automatic int k = i;
                        ambiente_0.driver[k].fifo_in.v_if = _if;
                        ambiente_0.monitor[k].v_if = _if;

                end

		fork
                        t_1.run();
                ambiente_0.run();
        	join_none
		#200000
                ambiente_0.resport(1);
		//////////////////////////////////////////////////

		disable fork;

          t_2 = new(one_to_all);
                t_2.tst_gen_mbx = tst_gen_mbx;
                t_2.tst_chk_sb_mbx = tst_chk_sb_mbx;
                
                ambiente_0 = new();
                ambiente_0.display();
                ambiente_0.generador.tst_gen_mbx = tst_gen_mbx;
          		ambiente_0.chk_sb.tst_chk_sb_mbx = tst_chk_sb_mbx;
                //ambiente_0.v_if = _if;
                for (int i = 0; i<drvrs; i++ ) begin

                        automatic int k = i;
                        ambiente_0.driver[k].fifo_in.v_if = _if;
                        ambiente_0.monitor[k].v_if = _if;

                end

                fork
                        t_2.run();
                ambiente_0.run();
                join_none
                #200000
                ambiente_0.resport(2);
          
         //////////////////////////////////////////////////
          disable fork;
            
            	t_3 = new(broadcastt);
                t_3.tst_gen_mbx = tst_gen_mbx;
                t_3.tst_chk_sb_mbx = tst_chk_sb_mbx;
                
                ambiente_0 = new();
                ambiente_0.display();
                ambiente_0.generador.tst_gen_mbx = tst_gen_mbx;
                ambiente_0.chk_sb.tst_chk_sb_mbx = tst_chk_sb_mbx;
                //ambiente_0.v_if = _if;
                for (int i = 0; i<drvrs; i++ ) begin

                        automatic int k = i;
                        ambiente_0.driver[k].fifo_in.v_if = _if;
                        ambiente_0.monitor[k].v_if = _if;

                end

		fork
                        t_3.run();
                ambiente_0.run();
        	join_none
		#200000
            ambiente_0.resport(3);
		//////////////////////////////////////////////////

		//disable fork;

	end
initial begin
#1000000
  $finish;
end


endmodule