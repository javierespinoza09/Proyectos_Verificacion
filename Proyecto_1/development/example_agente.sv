class Agente #(parameter drvrs = 4, parameter pckg_sz = 16);
    ag_dr_mbx [drvrs-1:0] ag_dr_mbx;
	ag_dr #(.pckg_sz(pckg_sz)) ag_dr_transaction;
    int num_transacciones;
    int delay;
    
    function new(int num_transacciones);
        this.num_transacciones = num_transacciones;
    endfunction
    task run();
        for (int i = 0; i < num_transacciones; i++) begin
            ag_dr_transaction.randomize();
            ag_dr_mbx[i].put(ag_dr_transaction);
            
        end
    endtask

endclass