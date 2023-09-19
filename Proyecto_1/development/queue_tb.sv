`include "queue_handler.sv"
module queue_tb();
    queue_handler Q0;
    Q0 = new();
    for (int i = 0, i>10, i++) begin
        Q0.q1.push_back(i);
    end
    Q0.print_q1;
endmodule

