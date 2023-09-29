`include "bus_if.sv"
`include "Clases_mailbox.sv"
class Driver #(parameter drvrs = 4, parameter pckg_sz = 16);
    virtual bus_if #(.drvrs(drvrs), .pckg_sz(pckg_sz)) v_if;
    int drv_num;
	bit [pckg_sz-1:0] q_in[$];
    bit [pckg_sz-1:0] q_out[$];
	ag_dr_mbx ag_dr_mbx;
	
	ag_dr #(.pckg_sz(pckg_sz)) ag_dr_transaction;

	function new(int drv_num);
        	this.q_in={};
        	this.q_out={};
		this.drv_num = drv_num;
		$display("Driver %d a iniciado",this.drv_num);
    	endfunction

	task run();				//Tarea principal del driver
		//this.v_if.rst = 1;		//Se aplica rst al DUT
		$display("Driver %d running",this.drv_num);
		@(posedge v_if.clk) v_if.rst = 0;	//Se termina el perido de rst
		forever begin
			bit [pckg_sz-1:0] front_data = 0;
			if (this.q_in.size==0) begin
			       this.v_if.pndng[0][this.drv_num] = 0;
			       this.v_if.D_pop[0][this.drv_num] = 0;
		       	end
			else begin 
				this.v_if.pndng[0][this.drv_num] = 1;
				this.v_if.D_pop[0][this.drv_num] = q_in[0];	
			end
			if(this.v_if.pop[0][this.drv_num] == 1) begin
					$display("pop %d dato %b",this.drv_num, v_if.D_pop[0][this.drv_num]);
					q_in.delete(0);
			end
			if(ag_dr_mbx.try_get(ag_dr_transaction)); 
				$display("Transaccion ag_dr recibida");
				this.q_in.push_back(ag_dr_transaction.dato);
				this.v_if.pndng[0][this.drv_num] = 1;
			if (this.v_if.push[0][this.drv_num] == 1) q_out.push_back(this.v_if.D_push[0][this.drv_num]);
				
			
		end
		
	endtask

	function report();
		$display("Driver %d",this.drv_num);
		foreach(q_out[i]) $display("Pos %d de la cola es = %b",i,q_out[i]);
	endfunction
	



endclass

