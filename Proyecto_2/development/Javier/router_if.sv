interface router_if #(parameter ROWS = 2, parameter COLUMS =2, parameter pckg_sz =20, parameter fifo_depth = 4)(input clk);
   
  
  logic pndng[ROWS*2+COLUMS*2];
  logic [pckg_sz-1:0] data_out[ROWS*2+COLUMS*2];
  logic popin[ROWS*2+COLUMS*2];
  logic pop[ROWS*2+COLUMS*2];
  logic [pckg_sz-1:0]data_out_i_in[ROWS*2+COLUMS*2];
  logic pndng_i_in[ROWS*2+COLUMS*2];
  logic reset;

endinterface
