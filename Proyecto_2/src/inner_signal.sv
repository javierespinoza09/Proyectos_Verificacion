interface inner_signals #(parameter ROWS = 2, parameter COLUMS = 2, parameter pckg_sz =20, parameter fifo_depth = 4)(input clk, input logic [pckg_sz-1:0] data_out[ROWS][COLUMS][4], input logic popin[ROWS][COLUMS][4], input logic pop[ROWS][COLUMS][4], input logic [pckg_sz-1:0]data_out_i_in[ROWS][COLUMS][4]);
   


endinterface