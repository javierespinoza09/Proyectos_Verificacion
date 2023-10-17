`include "Clases_mailbox.sv"
class Agente #(parameter drvrs = 4, parameter pckg_sz = 20, parameter fifo_size = 4, parameter ROWS = 2, parameter COLUMS = 2);
  
	//Mailboxes
    ag_dr_mbx #(.drvrs(drvrs), .pckg_sz(pckg_sz)) ag_dr_mbx_array [drvrs];
    gen_ag_mbx gen_ag_mbx;
    
    //Transacciones
	gen_ag gen_ag_transaction;
	ag_dr #(.drvrs(drvrs), .pckg_sz(pckg_sz)) ag_dr_transaction;

	//Atributos principales
    int num_transacciones;
    int delay;
    int source;

	r_c_mapping drv_map [COLUMS*2+ROWS*2];


  
    function new();
		this.ag_dr_transaction = new();

		for (int i = 0; i<ROWS*2+COLUMS*2; i++) begin
			automatic int k = i;
			drv_map[k] = new(k);
  		end
		`mapping (ROWS,COLUMS)
		foreach (drv_map[i]) begin
			$display("POS %d ROW=%0d COL=%0d",i,drv_map[i].row,drv_map[i].column);
		end
		$display("Se ha inciado el agente");
    endfunction
  
    
  
  
    task run();
      	forever begin
      	//get desde el generador al agente//
        this.gen_ag_mbx.get(this.gen_ag_transaction);
        this.num_transacciones = this.gen_ag_transaction.cant_datos;
        //Casos para la variabilidad de los Datos//
        for (int i = 0; i < this.num_transacciones; i++) begin
			this.ag_dr_transaction = new();
			this.ag_dr_transaction.drv_map = this.drv_map;
			/*case (this.gen_ag_transaction.data_modo)
				max_variabilidad: begin
                  ag_dr_transaction.data_variablility.constraint_mode(1);
                end
				max_aleatoriedad: begin 
                  ag_dr_transaction.data_variablility.constraint_mode(0);
                end
				default: begin 
                  	ag_dr_transaction.data_variablility.constraint_mode(0);
                end
			endcase*/
          	/////////////////////////////////////////////////
			//Casos para las pruebas que se desean ejecutar//
            /////////////////////////////////////////////////
			case (this.gen_ag_transaction.id_modo)
				self_id: begin 
                  ag_dr_transaction.self_r_c.constraint_mode(0); 
                  ag_dr_transaction.valid_addrs.constraint_mode(1); 
                  ag_dr_transaction.source_addrs.constraint_mode(1);
                  ag_dr_transaction.pos_source_addrs.constraint_mode(1);
                  
				end
				any_id: begin 
                  ag_dr_transaction.self_addrs.constraint_mode(0); 
                  ag_dr_transaction.valid_addrs.constraint_mode(0); 
                  ag_dr_transaction.source_addrs.constraint_mode(1);
                  ag_dr_transaction.pos_source_addrs.constraint_mode(1);
                  
				end
				invalid_id: begin 
                  ag_dr_transaction.self_addrs.constraint_mode(1); 
                  ag_dr_transaction.valid_addrs.constraint_mode(0);  
                  ag_dr_transaction.source_addrs.constraint_mode(1);
                  ag_dr_transaction.pos_source_addrs.constraint_mode(1);
                  
				end
				fix_source: begin 
                  ag_dr_transaction.self_addrs.constraint_mode(1); 
                  ag_dr_transaction.valid_addrs.constraint_mode(1); 
                  ag_dr_transaction.source_addrs.constraint_mode(1); 
                  ag_dr_transaction.pos_source_addrs.constraint_mode(1); 
                   
				end
              	normal_id: begin 
                  ag_dr_transaction.self_r_c.constraint_mode(1);  
                  ag_dr_transaction.valid_addrs.constraint_mode(1); 
                  ag_dr_transaction.source_addrs.constraint_mode(1); 
                  ag_dr_transaction.pos_source_addrs.constraint_mode(1);
                  
				end
				default: begin 
                  ag_dr_transaction.self_addrs.constraint_mode(1); 
                  ag_dr_transaction.valid_addrs.constraint_mode(1); 
				end
			endcase
		this.ag_dr_transaction.randomize();
			///Se randomizan los parámetros según las restricciones
	
		if(this.gen_ag_transaction.source_rand==0) begin 
			ag_dr_transaction.source = gen_ag_transaction.source;
                        if(ag_dr_transaction.id == ag_dr_transaction.source) begin
                                if(ag_dr_transaction.id == 0) ag_dr_transaction.id = ag_dr_transaction.id+1;
                                else ag_dr_transaction.id = ag_dr_transaction.id-1;
                        end
                end	
			///Se evalúa si el paquete requere que el ID, Source o ambos en cada paquete sea previamente determinado
		if(this.gen_ag_transaction.id_rand==0) begin
		       	ag_dr_transaction.id = gen_ag_transaction.id;
			if(ag_dr_transaction.id == ag_dr_transaction.source) begin
				if(ag_dr_transaction.source == 0) ag_dr_transaction.source = ag_dr_transaction.id+1;
				else ag_dr_transaction.source = ag_dr_transaction.source-1;
			end
		end
			///Se carga el tiempo de la transacción 
          	this.ag_dr_transaction.tiempo = $time;
			///Se envía el paquete al mailbox corresponciente
            this.ag_dr_mbx_array[this.ag_dr_transaction.source].put(this.ag_dr_transaction);


          	//this.ag_chk_sb_transaction = new(this.ag_dr_transaction.dato, this.ag_dr_transaction.id, $time, this.ag_dr_transaction.source);
          	//this.ag_chk_sb_mbx.put(ag_chk_sb_transaction);
          
          
	        
	    #1;
        end
        end 
      
    endtask 
endclass