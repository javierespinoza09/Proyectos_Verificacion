`include "queue_handler.sv"
module queue_tb();
    int p;
    initial begin
    queue_handler Q0;
    Q0 = new(); 
    p = Q0.pndng_q1();
    $display("Pending = %0d",p);
    for (int i = 0; i<10; i++) begin
        Q0.q1.push_back(i);
    end
    p = Q0.pndng_q1();
    $display("Pending = %0d",p);
    Q0.print_q1;
    end
endmodule

