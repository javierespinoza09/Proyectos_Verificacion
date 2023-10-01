`include "bus_if"
`include "Clases_mailbox"
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
      	//this.ag_dr_transaction.valid_addrs.constraint_mode(1);
      	//this.ag_dr_transaction.self_addrs.constraint_mode(1);
      	//this.ag_dr_transaction.broadcast.constraint_mode(0);
		this.ag_dr_mbx = new();
    endfunction

	/*
	Tarea run(): Se ejecuta una función recurrente que evalúa la cantidad de datos en la cola de entrada "q_in"
	para el control de la bandera "pndng", además de la obtención de paquetes tipo "ag_dr" para ser cargado en la cola 
	*/
	
	virtual task run();				//Tarea principal del driver

		//$display("Driver %d running",this.drv_num);	//Print para indicar el inicio de la ejecución del driver
		forever begin									//Función recurrente del driver
			@(posedge this.v_if.clk);					//Se evalúa en el flanco del reloj (Emulando sincronía)
			//bit [pckg_sz-1:0] front_data = 0;
			if (this.q_in.size==0) begin				//Evaluación de datos en la cola de entrada "q_in"; True en caso de estar vacía
				this.v_if.pndng[0][this.drv_num] = 0;	//Se setea la bandera "pndng" a 0 (No hay datos pendientes en la cola)
				this.v_if.D_pop[0][this.drv_num] = 0;	//Se coloca en la salida 0
		       	end
			else begin 									//Evaluación de datos en la cola de entrada "q_in"; True en caso de No estar vacía
				this.v_if.pndng[0][this.drv_num] = 1;	//Se setea la bandera "pndng" a 1 (No hay datos pendientes en la cola)
				this.v_if.D_pop[0][this.drv_num] = q_in[0];	//Se coloca en la salida el dato que se cargó en la cola
			end
			if(this.v_if.pop[0][this.drv_num]) begin	//Se evalúa señal de pop 
				//$display("pop %d dato %b",this.drv_num, v_if.D_pop[0][this.drv_num]); 
				q_in.delete(0);
			end
			if(this.ag_dr_mbx.try_get(this.ag_dr_transaction)) begin 	//Se intenta extraer un dato del mailbox 
				//$display("Transaccion ag_dr recibida en %d en el tiempo %d", this.drv_num,$time);
				q_in.push_back({this.ag_dr_transaction.id,this.ag_dr_transaction.dato});
				//$display("Dato cargado: %b", {this.ag_dr_transaction.id,this.ag_dr_transaction.dato});
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
