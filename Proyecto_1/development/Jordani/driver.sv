`include "bus_if.sv"
`include "Clases_mailbox.sv"
`include "fifo_in.sv"
class Driver #(parameter drvrs = 4, parameter pckg_sz = 16, parameter fifo_size = 8);
    	//virtual bus_if #(.drvrs(drvrs), .pckg_sz(pckg_sz)) v_if;
    	int drv_num;
	fifo_in #(.packagesize(pckg_sz), .drvrs(drvrs), .fifo_size(fifo_size)) fifo_in;
    ag_dr_mbx #(.drvrs(drvrs), .pckg_sz(pckg_sz)) ag_dr_mbx;
	ag_dr #(.drvrs(drvrs), .pckg_sz(pckg_sz)) ag_dr_transaction;
	
	function new(int drv_num);
		this.drv_num = drv_num;
		$display("Driver %d a iniciado",this.drv_num);
		this.ag_dr_transaction = new();
		this.ag_dr_mbx = new();
		this.fifo_in = new(drv_num);
		//this.fifo_in.v_if = v_if;
		//this.v_if.pndng[0][this.drv_num] = 0;
    	endfunction

	/*
	Tarea run(): Se ejecuta una función recurrente que evalúa la cantidad de datos en la cola de entrada "q_in"
	para el control de la bandera "pndng", además de la obtención de paquetes tipo "ag_dr" para ser cargado en la cola 
	*/
	
	virtual task run();
		//this.v_if.pndng[0][this.drv_num] = 0;
		fork
			fifo_in.if_signal();
		join_none
		forever begin	
			this.ag_dr_mbx.get(ag_dr_transaction);
			$display("Transaccion ag_dr en %d",this.drv_num);
			if(this.fifo_in.d_q.size < fifo_size) begin
				this.fifo_in.fifo_push({this.ag_dr_transaction.id,this.ag_dr_transaction.dato});
			end
			else $display("FIFO %d FULL MISSED_PKG %b", this.drv_num,{this.ag_dr_transaction.id,this.ag_dr_transaction.dato});
			#10;	
				
		end
		
	endtask

	function report();
		$display("Driver %d",this.drv_num);
		//foreach(this.q_out[i]) $display("Pos %d de la cola es = %b",i,this.q_out[i]);
	endfunction
	



endclass
