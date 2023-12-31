//`include "Clases_mailbox.sv"
class Agente #(parameter drvrs = 4, parameter pckg_sz = 16);
    	ag_dr_mbx ag_dr_mbx_array [drvrs];
    //gen_ag gen_ag;
	ag_dr #(.pckg_sz(pckg_sz)) ag_dr_transaction;
    	int num_transacciones;
    	int delay;
    	int source;


    function new(int num_transacciones);
        this.num_transacciones = num_transacciones;
	this.ag_dr_transaction = new();
	for(int i = 0;i < drvrs; i++) begin
		automatic int k = i;	
		this.ag_dr_mbx_array[k] = new();
	end
        $display("Se ha inciado el agente");
    endfunction
    task run();
        for (int i = 0; i < this.num_transacciones; i++) begin
		this.ag_dr_transaction = new();
            	this.ag_dr_transaction.randomize();
	        //$display("Mensaje enviado a %d Antes",this.ag_dr_transaction.source);
            	this.ag_dr_mbx_array[this.ag_dr_transaction.source].put(this.ag_dr_transaction);
	        $display("Mensaje enviado a %d con id: %d y payload: %d",this.ag_dr_transaction.source, this.ag_dr_transaction.id, this.ag_dr_transaction.dato);
	    #1;
        end
    endtask 
endclass


/*
Agente #(.drvrs(), .pckg_sz()) agente;
agente.new(num_transacciones)
agente.ag_dr_mbx = ag_dr_mbx //Arreglo de mdb tipo "ag_dr"
agente.run();
*/
