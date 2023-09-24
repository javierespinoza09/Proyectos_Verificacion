interface bus_if #(parameter drvrs = 4, parameter pckg_sz = 16)
(input clk);
    logic rst;
    logic [drvrs-1:0] pndng;
    logic [drvrs-1:0] push;
    logic [drvrs-1:0] pop;
    logic [pckg_sz-1:0] D_pop [drvrs-1:0];
    logic [pckg_sz-1:0] D_push [drvrs-1:0];
endinterface