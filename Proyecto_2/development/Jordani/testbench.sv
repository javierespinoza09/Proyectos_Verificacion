`timescale 1ns/10ps
`include "router_if.sv"

module router_tb;
reg clk_tb,reset_tb;
parameter Drivers = 4;
parameter pckg_sz = 40;
parameter fifo_size = 4;
parameter broadcast = {8{1'b1}};
parameter id_column = 0;
parameter id_row = 0;
parameter column = 2;
parameter row = 2;

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
  /*
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
  
  
  for(int i = 0; i<Drivers; i++ ) begin
    fork begin
      automatic int k = i;
      driver[i+1].recibido();
    end 
    join_any
  end 
  
    */
end
  


initial begin
#5000;
  $finish;
end
endmodule