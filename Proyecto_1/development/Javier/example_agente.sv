class Agente #(parameter drvrs = 4, parameter pckg_sz = 16);
    	ag_dr_mbx ag_dr_mbx [drvrs-1:0];
    //gen_ag gen_ag;
	ag_dr #(.pckg_sz(pckg_sz)) ag_dr_transaction;
    	int num_transacciones;
    	int delay;
    	int source;


    function new(int num_transacciones);
        this.num_transacciones = num_transacciones;
	this.ag_dr_transaction = new();
	for(int i = 0;i < drvrs; i++) this.ag_dr_mbx[i] = new();
        $display("Se ha inciado el agente");
    endfunction
    task run();
        for (int i = 0; i < this.num_transacciones; i++) begin
            ag_dr_transaction.randomize();
	    $display("AAAA");
            ag_dr_mbx[ag_dr_transaction.source].put(ag_dr_transaction);
        end
    endtask 
endclass


/*
Agente #(.drvrs(), .pckg_sz()) agente;
agente.new(num_transacciones)
agente.ag_dr_mbx = ag_dr_mbx //Arreglo de mdb tipo "ag_dr"
agente.run();
*/
