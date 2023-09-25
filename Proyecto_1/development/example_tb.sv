`timescale 1ns/1ps
`include "Library.sv"
`include "bus_if.sv"
`include "example_driver.sv"
module example_tb;
reg clk;
parameter drvrs = 4; 
parameter pckg_sz = 16;
virtual bus_if #(.drvrs(drvrs), .pckg_sz(pckg_sz)) bus_if;

bs_gnrtr_n_rbtr #(
.drvrs(drvrs),
.pckg_sz(pckg_sz)
) (
.clk(bus_if.clk),
.reset(bus_if.rst),
.pndng(bus_if.pndng),
.push(bus_if.push),
.pop(bus_if.pop),
.D_pop(bus_if.D_pop),
.D_push(bus_if.D_push)
)
always #5 clk = ~clk;

example_driver driver [drvrs];

initial begin
    for (int i = 0; i < drvrs; i++) begin
        driver[i] = new(i);
        driver[i].randomize();
        driver[i].v_if = bus_if;
    end
    
    for (int i = 0; i < drvrs; i++) begin
        fork begin
            driver[i].run();
        end
        join
    end 
end

endmodule