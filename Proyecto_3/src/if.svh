module dut_wrapper (router_if _if);
  
  mesh_gnrtr DUT (
  .clk(_if.clk),
  .reset(_if.reset),
  .pndng(_if.pndng),
  .data_out(_if.data_out),
  .popin(_if.popin),
  .pop(_if.pop),
  .data_out_i_in(_if.data_out_i_in),
  .pndng_i_in(_if.pndng_i_in)
);
  
  
endmodule