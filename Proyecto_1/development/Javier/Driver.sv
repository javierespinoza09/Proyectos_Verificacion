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
		this.ag_dr_transaction = new();
		this.ag_dr_mbx = new();
    	endfunction

	virtual task run();				//Tarea principal del driver
		//this.v_if.rst = 1;		//Se aplica rst al DUT
		$display("Driver %d running",this.drv_num);
		@(posedge this.v_if.clk) this.v_if.rst = 0;	//Se termina el perido de rst
		forever begin
			@(posedge this.v_if.clk);
			//bit [pckg_sz-1:0] front_data = 0;
			if (this.q_in.size==0) begin
				this.v_if.pndng[0][this.drv_num] = 0;
				this.v_if.D_pop[0][this.drv_num] = 0;
		       	end
			else begin 
				this.v_if.pndng[0][this.drv_num] = 1;
				this.v_if.D_pop[0][this.drv_num] = q_in[0];	
			end
			if(this.v_if.pop[0][this.drv_num]) begin
				$display("pop %d dato %b",this.drv_num, v_if.D_pop[0][this.drv_num]);
				q_in.delete(0);
			end
			if(this.ag_dr_mbx.try_get(this.ag_dr_transaction)) begin
				$display("Transaccion ag_dr recibida en %d en el tiempo %d", this.drv_num,$time);
				q_in.push_back({this.ag_dr_transaction.id,this.ag_dr_transaction.dato});
				$display("Dato cargado: %b", {this.ag_dr_transaction.id,this.ag_dr_transaction.dato});
			end
			//	this.v_if.pndng[0][this.drv_num] = 1;
			if (this.v_if.push[0][this.drv_num]) begin 
				this.q_out.push_back(this.v_if.D_push[0][this.drv_num]);
				$display("Push a %d en el tiempo %d del dato %b",this.drv_num, $time,this.q_out[$]);
			end
	
			#10;	
				
		end
		
	endtask

	function report();
		$display("Driver %d",this.drv_num);
		foreach(this.q_out[i]) $display("Pos %d de la cola es = %b",i,this.q_out[i]);
	endfunction
	



endclass

