//`include "Clases_mailbox.sv"





class Agente #(parameter drvrs = 4, parameter pckg_sz = 20, parameter fifo_size = 4, parameter ROWS = 2, parameter COLUMS = 2);
  
	//Mailboxes
    ag_dr_mbx #(.drvrs(drvrs), .pckg_sz(pckg_sz)) ag_dr_mbx_array [drvrs];
    gen_ag_mbx gen_ag_mbx;
    
    //Transacciones
	gen_ag gen_ag_transaction;
  ag_dr #(.ROWS(ROWS), .pckg_sz(pckg_sz), .COLUMS(COLUMS)) ag_dr_transaction;

	//Atributos principales
    int num_transacciones;
    int delay;
    int source;
    int mode;

	r_c_mapping drv_map [COLUMS*2+ROWS*2];


  
    function new();
		this.ag_dr_transaction = new();
      	
		for (int i = 0; i<ROWS*2+COLUMS*2; i++) begin
			automatic int k = i;
          	this.ag_dr_mbx_array[k] = new();
			drv_map[k] = new();
  		end
      `mapping(ROWS,COLUMS);
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
	this.mode = this.gen_ag_transaction.mode;
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
                  ag_dr_transaction.valid_addrs_col.constraint_mode(1); 
                  ag_dr_transaction.valid_addrs_row.constraint_mode(1);
                  ag_dr_transaction.valid_addrs_Driver.constraint_mode(1); 
                  ag_dr_transaction.source_addrs.constraint_mode(1);
                  ag_dr_transaction.pos_source_addrs.constraint_mode(1);
                  ag_dr_transaction.send_to_itself.constraint_mode(0);
                  
				end
				any_id: begin //Send to any id, even invalid id and it self
                  ag_dr_transaction.self_r_c.constraint_mode(0); 
                  ag_dr_transaction.valid_addrs_col.constraint_mode(0); 
                  ag_dr_transaction.valid_addrs_row.constraint_mode(0);
                  ag_dr_transaction.valid_addrs_Driver.constraint_mode(0);
                  ag_dr_transaction.source_addrs.constraint_mode(1);
                  ag_dr_transaction.pos_source_addrs.constraint_mode(1);
                  ag_dr_transaction.send_to_itself.constraint_mode(0);
                  
				end
				invalid_id: begin //Send to any id,even invalid id, but it self
                  ag_dr_transaction.self_r_c.constraint_mode(1); 
                  ag_dr_transaction.valid_addrs_col.constraint_mode(0); 
                  ag_dr_transaction.valid_addrs_row.constraint_mode(0);
                  ag_dr_transaction.valid_addrs_Driver.constraint_mode(0);  
                  ag_dr_transaction.source_addrs.constraint_mode(1);
                  ag_dr_transaction.pos_source_addrs.constraint_mode(1);
                  ag_dr_transaction.send_to_itself.constraint_mode(0);
                  
				end
				
        normal_id: begin 
                  ag_dr_transaction.self_r_c.constraint_mode(1);  
                  ag_dr_transaction.valid_addrs_col.constraint_mode(1); 
                  ag_dr_transaction.valid_addrs_row.constraint_mode(1);
                  ag_dr_transaction.valid_addrs_Driver.constraint_mode(1); 
                  ag_dr_transaction.source_addrs.constraint_mode(1); 
                  ag_dr_transaction.pos_source_addrs.constraint_mode(1);
                  ag_dr_transaction.send_to_itself.constraint_mode(0);
                  
				end
        send_to_itself: begin 
                  ag_dr_transaction.self_r_c.constraint_mode(0);  
                  ag_dr_transaction.valid_addrs_col.constraint_mode(0); 
                  ag_dr_transaction.valid_addrs_row.constraint_mode(0);
                  ag_dr_transaction.valid_addrs_Driver.constraint_mode(0); 
                  ag_dr_transaction.source_addrs.constraint_mode(1); 
                  ag_dr_transaction.pos_source_addrs.constraint_mode(1);
                  ag_dr_transaction.send_to_itself.constraint_mode(1);
                  
				end
				default: begin 
                  ag_dr_transaction.self_r_c.constraint_mode(1);  
                  ag_dr_transaction.valid_addrs_col.constraint_mode(1); 
                  ag_dr_transaction.valid_addrs_row.constraint_mode(1);
                  ag_dr_transaction.valid_addrs_Driver.constraint_mode(1); 
                  ag_dr_transaction.source_addrs.constraint_mode(1); 
                  ag_dr_transaction.pos_source_addrs.constraint_mode(1); 
				end
			endcase

      case (this.mode)
        random: begin
		$display("randdom");
          this.ag_dr_transaction.mode1.constraint_mode(0);
          this.ag_dr_transaction.mode0.constraint_mode(0);
        end
        mode_1: begin
	       $display("MODE_1");	
          this.ag_dr_transaction.mode1.constraint_mode(1);
          this.ag_dr_transaction.mode0.constraint_mode(0);  
        end
        mode_0: begin
	        $display("MODE_0");	
          ag_dr_transaction.mode1.constraint_mode(0);
          ag_dr_transaction.mode0.constraint_mode(1);  
        end
        default: begin
	       $display("DEFAULT");	
          ag_dr_transaction.mode1.constraint_mode(0);
          ag_dr_transaction.mode0.constraint_mode(0);
        end
      endcase
          //////////////////
          //ALEATORIZACION//
          //////////////////
	  //
	  	this.ag_dr_transaction.Nxt_jump = 0;
		this.ag_dr_transaction.randomize();
			
      	//////////////////////////////
        //VALIDACION DE FILA-COLUMNA//
        //////////////////////////////
    
	if(this.gen_ag_transaction.source_rand==0) begin
       		ag_dr_transaction.source = gen_ag_transaction.source;
          	if(this.gen_ag_transaction.id_modo != self_id || this.gen_ag_transaction.id_modo != send_to_itself) begin
            		if(ag_dr_transaction.id_row == ag_dr_transaction.drv_map[ag_dr_transaction.source].row && ag_dr_transaction.id_colum == ag_dr_transaction.drv_map[ag_dr_transaction.source].column) begin  
              			//$display("WARNING: DIRECCION PROPIA SOURCE [%d]  FILA [%d] COLUMNA [%d]", ag_dr_transaction.source, ag_dr_transaction.id_row, ag_dr_transaction.id_colum);
				if(ag_dr_transaction.id_row == 0 || ag_dr_transaction.id_row == ROWS + 1) begin
                			if(ag_dr_transaction.id_colum == 1) ag_dr_transaction.id_colum = ag_dr_transaction.id_colum + 1;
                			else ag_dr_transaction.id_colum = ag_dr_transaction.id_colum - 1;
              			end 
              			else begin 
                			if(ag_dr_transaction.id_row == 1) ag_dr_transaction.id_row = ag_dr_transaction.id_row + 1;
                			else ag_dr_transaction.id_row = ag_dr_transaction.id_row - 1; 
              			end
            		end
          	end
        end
                        ///Se evalúa si el paquete requere que el ID, Source o ambos en cada paquete sea previamente determinado
        if(this.gen_ag_transaction.id_rand==0) begin
		ag_dr_transaction.id_row = gen_ag_transaction.id_row;
          	ag_dr_transaction.id_colum = gen_ag_transaction.id_colum;
          	if(this.gen_ag_transaction.id_modo != self_id || this.gen_ag_transaction.id_modo != send_to_itself) begin
            		if(ag_dr_transaction.id_row == ag_dr_transaction.drv_map[source].row && ag_dr_transaction.id_colum == ag_dr_transaction.drv_map[source].column) begin
                		if(ag_dr_transaction.source == 0) ag_dr_transaction.source = ag_dr_transaction.source+1;
                  		else ag_dr_transaction.source = ag_dr_transaction.source-1;
            		end
          	end		
	end

			///Se carga el tiempo de la transacción 
          	this.ag_dr_transaction.tiempo = $time;
		//$display("AGENTE: Dato [%b] modo [%b] Nxt [%b]", this.ag_dr_transaction.dato, this.ag_dr_transaction.mode, this.ag_dr_transaction.Nxt_jump);
			///Se envía el paquete al mailbox corresponciente
		if(this.gen_ag_transaction.id_modo == send_to_itself) begin 
			this.ag_dr_transaction.id_row = ag_dr_transaction.drv_map[ag_dr_transaction.source].row;
			this.ag_dr_transaction.id_colum = ag_dr_transaction.drv_map[ag_dr_transaction.source].column;
		end
            this.ag_dr_mbx_array[this.ag_dr_transaction.source].put(this.ag_dr_transaction);
	    #1;


          	//this.ag_chk_sb_transaction = new(this.ag_dr_transaction.dato, this.ag_dr_transaction.id, $time, this.ag_dr_transaction.source);
          	//this.ag_chk_sb_mbx.put(ag_chk_sb_transaction);
          
          
	        
	    
        end
        end 
      
    endtask 
endclass





