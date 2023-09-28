`include "bus_if.sv"
`include "Clases_mailbox.sv"
class Driver #(parameter drvrs = 4, parameter pckg_sz = 16)(input clk);
    virtual bus_if #(.drvrs(drvrs), .pckg_sz(pckg_sz)) v_if;
    int drv_num;
	bit [pckg_sz-1:0] q_in[$];
    bit [pckg_sz-1:0] q_out[$];
	ag_dr_mbx ag_dr_mbx;
	
	ag_dr #(.pckg_sz(pckg_sz)) ag_dr_transaction;
	ag_dr_transaction.new();
	function new(int drv_num);
        	this.q_in={};
        	this.q_out={};
		this.drv_num = drv_num;
    	endfunction

	task run();				//Tarea principal del driver
		//this.v_if.rst = 1;		//Se aplica rst al DUT
		bit [pckg_sz-1:0] front_data = 0;
		@(posedge v_if.clk) v_if.rst = 0;	//Se termina el perido de rst
		forever begin
			bit [pckg_sz-1:0] front_data = 0;
			if (this.q_in.size==0) begin
			       this.v_if.pndng[0][this.drv_num] = 0;
			       this.v_if.D_in[0][this.drv_num] = 0;
		       	end
			else begin 
				this.v_if.pndng[0][this.drv_num] = 1;
				this.v_if.D_in[0][this.drv_num] = q_in[0];	
			@(posedge clk) begin
					if(this.v_if.pop[0][this.drv_num] == 1) begin
						front_data = q_in.pop_front;
					end
					if(ag_dr_mbx.try_get(ag_dr_transaction)) begin
						$display("Transaccion ag_dr recibida");
									this.q_in.push_back(ag_dr_transaction.dato);
						this.v_if.pndng[0][this.drv_num] = 1;
					end
					if (this.v_if.pop[0][this.drv_num] == 1) q_out.push_back(this.v_if.D_out[0][this.drv_num]);
				end
			end
		end
		
	endtask

	function report();
		$display("Driver %d",this.drv_num);
		foreach(q_out(i)) $display("Pos %d de la cola es = %b",i,q[i]);
	endfunction
	



endclass

salida

./salida -gui