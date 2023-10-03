//`include "Clases_mailbox.sv"
class Agente #(parameter drvrs = 4, parameter pckg_sz = 16);
  
	//Mailboxes
    ag_dr_mbx ag_dr_mbx_array [drvrs];
  	gen_ag_mbx gen_ag_mbx;
  	ag_chk_sb_mbx ag_chk_sb_mbx;
    //Transacciones
	gen_ag gen_ag_transaction;
  	ag_chk_sb ag_chk_sb_transaction;
  
	ag_dr #(.pckg_sz(pckg_sz),.drvrs(drvrs)) ag_dr_transaction;

	//Atributos principales
    int num_transacciones;
    int delay;
    int source;

	
  
    function new();
	this.ag_dr_transaction = new();
   
	for(int i = 0;i < drvrs; i++) begin
		automatic int k = i;	
		this.ag_dr_mbx_array[k] = new();
	end
        $display("Se ha inciado el agente");
    endfunction
  
    
  
  
    task run();
      	forever begin
      	//get desde el generador al agente//
        this.gen_ag_mbx.get(this.gen_ag_transaction);
        this.num_transacciones = this.gen_ag_transaction.cant_datos;
        $display("Transaccion gen_ag recibida cant %d en el tiempo %d", this.num_transacciones,$time);
		
        for (int i = 0; i < this.num_transacciones; i++) begin
			this.ag_dr_transaction = new();
			case (this.gen_ag_transaction.data_modo)
				max_variabilidad: ag_dr_transaction.data_variablility.constraint_mode(1);
				max_aleatoriedad: ag_dr_transaction.data_variablility.constraint_mode(0);
				default: max_aleatoriedad: ag_dr_transaction.data_variablility.constraint_mode(0);
			endcase

			case (this.gen_ag_transaction.id_modo)
				self_id: begin 
					ag_dr_transaction.self_addrs.constraint_mode(0);
					ag_dr_transaction.valid_addrs.constraint_mode(1);
				end
				any_id: begin 
					ag_dr_transaction.self_addrs.constraint_mode(0);
					ag_dr_transaction.valid_addrs.constraint_mode(0);
				end
				invalid_id: begin 
					ag_dr_transaction.self_addrs.constraint_mode(1);
					ag_dr_transaction.valid_addrs.constraint_mode(0);
				end
				normal_id: begin 
					ag_dr_transaction.self_addrs.constraint_mode(1);
					ag_dr_transaction.valid_addrs.constraint_mode(1);
				end
				default: begin 
					ag_dr_transaction.self_addrs.constraint_mode(1);
					ag_dr_transaction.valid_addrs.constraint_mode(1);
				end
			endcase
			///Se randomizan los parámetros según las restricciones
			this.ag_dr_transaction.randomize();
			///Se evalúa si el paquete requere que el ID, Source o ambos en cada paquete sea previamente determinado
			if(this.gen_ag_transaction.id_rand==1) ag_dr_transaction.id = gen_ag_transaction.id;
			if(this.gen_ag_transaction.source_rand==1) ag_dr_transaction.source = gen_ag_transaction.source;
			///Se carga el tiempo de la transacción 
          	this.ag_dr_transaction.tiempo = $time;
			///Se envía el paquete al mailbox corresponciente
            this.ag_dr_mbx_array[this.ag_dr_transaction.source].put(this.ag_dr_transaction);


          	this.ag_chk_sb_transaction = new(this.ag_dr_transaction.dato, this.ag_dr_transaction.id, this.ag_dr_transaction.tiempo, this.ag_dr_transaction.source);
          	this.ag_chk_sb_mbx.put(ag_chk_sb_transaction);
          
          
	        $display("Mensaje enviado a %d con id: %d y payload: %d",this.ag_dr_transaction.source,this.ag_dr_transaction.id, this.ag_dr_transaction.dato);
	    #1;
        end
        end 
      
    endtask 
endclass


/*
Agente #(.drvrs(), .pckg_sz()) agente;
agente.new(num_transacciones)
agente.ag_dr_mbx = ag_dr_mbx //Arreglo de mdb tipo "ag_dr"
agente.run();
*/