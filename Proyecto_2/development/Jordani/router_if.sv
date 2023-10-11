interface router_if #(parameter pck_sz = 40, parameter num_ntrfs=4, parameter broadcast = {8{1'b1}}, parameter fifo_depth=4,parameter id_c = 0,parameter id_r = 0,parameter columns= 4, parameter rows = 4)(input clk);
 
  logic reset;
  logic [pck_sz-1:0] data_out_i_in[num_ntrfs-1:0];
  logic pndng_i_in[num_ntrfs-1:0];
  logic pop[num_ntrfs-1:0];
  logic popin[num_ntrfs-1:0];
  logic pndng[num_ntrfs-1:0];
  logic [pck_sz-1:0] data_out[num_ntrfs-1:0];

endinterface

