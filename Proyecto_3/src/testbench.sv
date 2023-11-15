// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
`include "Items_Macros.svh"
`include "driver.svh"
`include "agente.svh"
`include "Ambiente.svh"
//`include "pckg_test.svh"


module tb_top;
  import uvm_pkg::*;
  import test::*;
  
  
  bit clk_tb;
  always #5 clk_tb <= ~clk_tb;
  
  
  router_if dut_if(clk_tb);
  dut_wrapper dut_wr (._if (dut_if));
  

  initial begin
    uvm_config_db#(virtual router_if)::set(null, "*","v_if", dut_if);
    run_test("test");
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb_top);
  end
  
  
  
endmodule
