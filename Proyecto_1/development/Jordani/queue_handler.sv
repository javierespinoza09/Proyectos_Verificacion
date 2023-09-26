class queue_handler;
    int q1[$];
    int q2[$];
    function new();
        this.q1={};
        this.q2={};
    endfunction

    task print_q1();
        foreach (q1[i]) begin
            $display("De la cola q1 en la pos %0d el valor es %0d",i,q1[i]);
        end
    endtask

    task print_q2();
        foreach (q2[i]) begin
            $display("De la cola q1 en la pos %0d el valor es %0d",i,q2[i]);
        end
    endtask

    function int pndng_q1();
	    int p;
	    if (q1.size==0) return 0;
	    else return 1;
    endfunction
endclass
