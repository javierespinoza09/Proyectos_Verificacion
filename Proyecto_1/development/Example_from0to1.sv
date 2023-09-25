`timescale 1ns/10ps
module bus_tb;
reg reset_tb,clk_tb;
reg pndng_tb [0:0][3:0];
reg [15:0] D_pop_tb [0:0][3:0];
wire push_tb [0:0][3:0];
wire pop_tb [0:0][3:0];
wire [15:0] D_push_tb [0:0][3:0];
 
  
  bs_gnrtr_n_rbtr DUT_0 (.clk(clk_tb),
                         .reset(reset_tb),
                         .pndng(pndng_tb),
                         .push(push_tb),
                         .pop(pop_tb),
                         .D_pop(D_pop_tb),
                         .D_push(D_push_tb)
                        );
  
  
initial begin
  $dumpfile("test_bus.vcd");
  $dumpvars(0,bus_tb);
end

initial begin
forever begin
	#5
	clk_tb = ~clk_tb;
end
end
  
initial begin
  reset_tb = 1;
  D_pop_tb [0][0] =16'b0000000100000011;
  pndng_tb [0][0] = 1;
  pndng_tb [0][1] = 0;
  pndng_tb [0][2] = 0;
  pndng_tb [0][3] = 0;
  clk_tb = 0;
  #100
  reset_tb = 0;
  #1000
  $finish;
end

endmodule