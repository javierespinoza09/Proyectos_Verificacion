`timescale 1ns/10ps
`include "example_driver"
`include "test_mbx"
module bus_tb;
reg reset_tb,clk_tb;
reg pndng_tb [0:0][3:0];
reg [15:0] D_pop_tb [0:0][3:0];
wire push_tb [0:0][3:0];
wire pop_tb [0:0][3:0];
wire [15:0] D_push_tb [0:0][3:0];
parameter Drivers = 4;
parameter pckg_sz = 16;
  
////Mailboxes//////
  typedef mailbox #(transaction_chk_sb) mbx_ag_chk;
  mbx_ag_chk ag_chk_sb_mbx;
/////
  
  
  
  
  example_driver #(.drvrs(Drivers)) driver [Drivers-1:0];
  bus_if #(.drvrs(Drivers), .pckg_sz(pckg_sz)) v_if (.clk(clk_tb));
  
  transaction_chk_sb #(.packagesize(pckg_sz)) transaction ;
 
  
  bs_gnrtr_n_rbtr DUT_0 (.clk(clk_tb),
                         .reset(reset_tb),
                         .pndng(v_if.pndng),
                         .push(v_if.push),
                         .pop(v_if.pop),
                         .D_pop(v_if.D_pop),
                         .D_push(v_if.D_push)
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
  clk_tb = 0;
  reset_tb = 1;
  #50
  reset_tb = 0;
  for(int i = 0; i<Drivers; i++ ) begin
    fork begin
      automatic int k = i;
      driver[k] = new(k);
      driver[k].v_if = v_if;
      driver[k].randomize();
      driver[k].display();
      driver[k].run();
      
      $display("Driver_0x%0d",driver[k].drv_num);
    end 
    join
  end 
  for(int i = 0; i<Drivers; i++)begin
    $display("Pending = %0d y Dato_pop = %b",v_if.pndng[0][i],v_if.D_pop[0][i]);
    transaction = new(v_if.D_pop[0][i]);
  	transaction.display();
  end
  
 
  
  
  for(int i = 0; i<Drivers; i++ ) begin
    fork begin
      automatic int k = i;
      driver[i+1].recibido();
    end 
    join_any
  end 
end
  
  

initial begin
#5000;
  $finish;
end
endmodule