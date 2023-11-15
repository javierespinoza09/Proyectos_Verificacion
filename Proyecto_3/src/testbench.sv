// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
`include "Items_Macros.svh"
`include "driver.svh"
`include "agente.svh"
`include "Ambiente.svh"
`include "pckg_test.svh"


module tb_top;
  import uvm_pkg::*;
  import test::*;
  
  int COLUMS = 4;
  parameter int ROWS = 4;
  parameter int fifo_size = 4;
  parameter int pckg_sz = 40;
  bit clk_tb;
  always #5 clk_tb <= ~clk_tb;
  
  
  router_if dut_if(clk_tb);
  dut_wrapper dut_wr (._if (dut_if));
  

  initial begin
    uvm_config_db#(virtual router_if)::set(null, "*","v_if", dut_if);
    uvm_config_db#(int)::set(null, "*","COLUMS", COLUMS);
    uvm_config_db#(int)::set(null, "*","ROWS", ROWS);
    uvm_config_db#(int)::set(null, "*","fifo_size", fifo_size);
    uvm_config_db#(int)::set(null, "*","pckg_sz", pckg_sz);
    run_test("test_base");
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb_top);
  end
  
  
  
endmodule
