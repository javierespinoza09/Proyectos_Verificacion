`include "Clases_mailbox.sv"

class drv_item extends uvm_sequence_item;
    `uvm_object_utils(drv_item)
    parameter COLUMS = 4;
    parameter ROWS = 4;
  	parameter pckg_sz = 40;
    /*if(!uvm_config_db#(virtual router_if)::get(this, "", "v_if", v_if)) begin
        `uvm_error("","uvm_config_db::get failed")
    end*/
    rand bit [pckg_sz-26:0] dato;
    rand bit [3:0] id_row;
    rand bit [3:0] id_colum;
    rand bit mode;
    rand int source;
    bit [7:0] Nxt_jump;
    rand int tiempo;
    int variability;
    int fix_source;
    r_c_mapping drv_map [COLUMS*2+ROWS*2];
    //Respecto al Source
    constraint pos_source_addrs {source >= 0;};  //**Restriccion necesaria
    constraint source_addrs {source < COLUMS*2+ROWS*2;};  //**Restriccion para asegurar que el paquete se dirige a un driver existente (necesaria)
    constraint self_r_c {id_row != drv_map[source].row; id_colum != drv_map[source].column;};
    //Respecto al ID
    constraint valid_addrs {id_row <= ROWS+1; id_row >= 0; id_colum <= COLUMS+1; id_colum >= 0;};       //Restriccion asegura que la direccion pertenece a un driver
    constraint send_to_itself {id_row == drv_map[source].row; id_colum == drv_map[source].column;};
    constraint valid_addrs_col {if(id_row == 0 | id_row == ROWS+1)id_colum <= COLUMS & id_colum > 0;};
    constraint valid_addrs_row {if(id_colum == 0 | id_colum == COLUMS+1) id_row <= ROWS & id_row > 0;};
    constraint valid_addrs_Driver {if(id_row != 0 & id_row != ROWS+1)id_colum == 0 | id_colum == COLUMS+1;};
    constraint mode1 {mode == 1;};
    constraint mode0 {mode == 0;};
    constraint delay {tiempo > 20; tiempo < 100;};
  	virtual router_if v_if;

    function new(string name = "drv_item");
        super.new(name);
    endfunction

    function void build_phase(uvm_phase phase);
      /*
      if(!uvm_config_db#(virtual router_if#(4, 4, 40, 4))::get(this, "", "v_if", v_if)) begin
        `uvm_error("","uvm_config_db::get failed")
      end
      
      if(!uvm_config_db#(int)::get(this, "", "pckg_sz", pckg_sz)) begin
          `uvm_error("","uvm_config_db::get failed")
      end
      if(!uvm_config_db#(int)::get(this, "", "COLUMS", COLUMS)) begin
          `uvm_error("","uvm_config_db::get failed")
        end
      if(!uvm_config_db#(int)::get(this, "", "ROWS", ROWS)) begin
          `uvm_error("","uvm_config_db::get failed")
        end*/
    endfunction
  
    virtual function string item_str_content ();
        return $sformatf("Source=%0d, Mode=%0b, Row=%0d, Col=%0d, Data=%0h", source, mode, id_row, id_row, dato);
    endfunction

endclass


class gen_sequence_item extends uvm_sequence #(drv_item);
    `uvm_object_utils(gen_sequence_item);

    function new (string name = "gen_sequence_item");
        super.new(name);
    endfunction
	parameter COLUMS = 4;
  	parameter ROWS = 4;
    int cant_datos;
    int data_modo;        
    int id_modo;
    int id_rand;
    int mode;
    bit [3:0] id_row;
    bit [3:0] id_colum;
    int source_rand;
    bit [3:0] source;
	drv_item drv_item_i;
    r_c_mapping drv_map [COLUMS*2+ROWS*2];

    function void build_phase(uvm_phase phase);
      /*
      if(!uvm_config_db#(int)::get(this, "", "COLUMS", COLUMS)) begin
          `uvm_error("","uvm_config_db::get failed")
        end
      if(!uvm_config_db#(int)::get(this, "", "ROWS", ROWS)) begin
          `uvm_error("","uvm_config_db::get failed")
        end*/
        `mapping(ROWS,COLUMS);
        foreach (drv_map[i]) begin
			$display("POS %d ROW=%0d COL=%0d",i,drv_map[i].row,drv_map[i].column);
		end
      
    endfunction

    virtual task body();
        for (int i = 0; i < this.cant_datos; i++) begin
			
            drv_item_i = drv_item::type_id::create("drv_item_i");
            start_item(drv_item_i);

          	/////////////////////////////////////////////////
			//Casos para las pruebas que se desean ejecutar//
            /////////////////////////////////////////////////
			case (this.id_modo)
				self_id: begin 
                  drv_item_i.self_r_c.constraint_mode(0); 
                  drv_item_i.valid_addrs_col.constraint_mode(1); 
                  drv_item_i.valid_addrs_row.constraint_mode(1);
                  drv_item_i.valid_addrs_Driver.constraint_mode(1); 
                  drv_item_i.source_addrs.constraint_mode(1);
                  drv_item_i.pos_source_addrs.constraint_mode(1);
                  drv_item_i.send_to_itself.constraint_mode(0);
                  
				end
				any_id: begin //Send to any id, even invalid id and it self
                  drv_item_i.self_r_c.constraint_mode(0); 
                  drv_item_i.valid_addrs_col.constraint_mode(0); 
                  drv_item_i.valid_addrs_row.constraint_mode(0);
                  drv_item_i.valid_addrs_Driver.constraint_mode(0);
                  drv_item_i.source_addrs.constraint_mode(1);
                  drv_item_i.pos_source_addrs.constraint_mode(1);
                  drv_item_i.send_to_itself.constraint_mode(0);
                  
				end
				invalid_id: begin //Send to any id,even invalid id, but it self
                  drv_item_i.self_r_c.constraint_mode(1); 
                  drv_item_i.valid_addrs_col.constraint_mode(0); 
                  drv_item_i.valid_addrs_row.constraint_mode(0);
                  drv_item_i.valid_addrs_Driver.constraint_mode(0);  
                  drv_item_i.source_addrs.constraint_mode(1);
                  drv_item_i.pos_source_addrs.constraint_mode(1);
                  drv_item_i.send_to_itself.constraint_mode(0);
                  
				end
				
        normal_id: begin 
                  drv_item_i.self_r_c.constraint_mode(1);  
                  drv_item_i.valid_addrs_col.constraint_mode(1); 
                  drv_item_i.valid_addrs_row.constraint_mode(1);
                  drv_item_i.valid_addrs_Driver.constraint_mode(1); 
                  drv_item_i.source_addrs.constraint_mode(1); 
                  drv_item_i.pos_source_addrs.constraint_mode(1);
                  drv_item_i.send_to_itself.constraint_mode(0);
                  
				end
        send_to_itself: begin 
                  drv_item_i.self_r_c.constraint_mode(0);  
                  drv_item_i.valid_addrs_col.constraint_mode(0); 
                  drv_item_i.valid_addrs_row.constraint_mode(0);
                  drv_item_i.valid_addrs_Driver.constraint_mode(0); 
                  drv_item_i.source_addrs.constraint_mode(1); 
                  drv_item_i.pos_source_addrs.constraint_mode(1);
                  drv_item_i.send_to_itself.constraint_mode(1);
                  
				end
				default: begin 
                  drv_item_i.self_r_c.constraint_mode(1);  
                  drv_item_i.valid_addrs_col.constraint_mode(1); 
                  drv_item_i.valid_addrs_row.constraint_mode(1);
                  drv_item_i.valid_addrs_Driver.constraint_mode(1); 
                  drv_item_i.source_addrs.constraint_mode(1); 
                  drv_item_i.pos_source_addrs.constraint_mode(1); 
				end
			endcase

      case (this.mode)
        random: begin
		//$display("randdom");
          this.drv_item_i.mode1.constraint_mode(0);
          this.drv_item_i.mode0.constraint_mode(0);
        end
        mode_1: begin
	      // $display("MODE_1");	
          this.drv_item_i.mode1.constraint_mode(1);
          this.drv_item_i.mode0.constraint_mode(0);  
        end
        mode_0: begin
	       // $display("MODE_0");	
          drv_item_i.mode1.constraint_mode(0);
          drv_item_i.mode0.constraint_mode(1);  
        end
        default: begin
	       //$display("DEFAULT");	
          drv_item_i.mode1.constraint_mode(0);
          drv_item_i.mode0.constraint_mode(0);
        end
      endcase
          //////////////////
          //ALEATORIZACION//
          //////////////////
	  //
	  	this.drv_item_i.Nxt_jump = 0;
		this.drv_item_i.randomize();
			
      	//////////////////////////////
        //VALIDACION DE FILA-COLUMNA//
        //////////////////////////////
    
	if(this.source_rand==0) begin
       		drv_item_i.source = source;
          	if(this.id_modo != self_id || this.id_modo != send_to_itself) begin
            		if(drv_item_i.id_row == drv_item_i.drv_map[drv_item_i.source].row && drv_item_i.id_colum == drv_item_i.drv_map[drv_item_i.source].column) begin  
              		//$display("WARNING: DIRECCION PROPIA SOURCE [%d]  FILA [%d] COLUMNA [%d]", drv_item_i.source, drv_item_i.id_row, drv_item_i.id_colum);
                        if(drv_item_i.id_row == 0 || drv_item_i.id_row == ROWS + 1) begin
                            if(drv_item_i.id_colum == 1) drv_item_i.id_colum = drv_item_i.id_colum + 1;
                            else drv_item_i.id_colum = drv_item_i.id_colum - 1;
                        end 
                        else begin 
                            if(drv_item_i.id_row == 1) drv_item_i.id_row = drv_item_i.id_row + 1;
                            else drv_item_i.id_row = drv_item_i.id_row - 1; 
                        end
            		end
          	end
        end
        ///Se evalúa si el paquete requere que el ID, Source o ambos en cada paquete sea previamente determinado
        if(this.id_rand==0) begin
		drv_item_i.id_row = id_row;
          	drv_item_i.id_colum = id_colum;
          	if(this.id_modo != self_id || this.id_modo != send_to_itself) begin
            		if(drv_item_i.id_row == drv_item_i.drv_map[source].row && drv_item_i.id_colum == drv_item_i.drv_map[source].column) begin
                		if(drv_item_i.source == 0) drv_item_i.source = drv_item_i.source+1;
                  		else drv_item_i.source = drv_item_i.source-1;
            		end
          	end		
	end

			///Se carga el tiempo de la transacción 
          	this.drv_item_i.tiempo = $time;
		//$display("AGENTE: Dato [%b] modo [%b] Nxt [%b]", this.drv_item_i.dato, this.drv_item_i.mode, this.drv_item_i.Nxt_jump);
			///Se envía el paquete al mailbox corresponciente
		if(this.id_modo == send_to_itself) begin 
			this.drv_item_i.id_row = drv_item_i.drv_map[drv_item_i.source].row;
			this.drv_item_i.id_colum = drv_item_i.drv_map[drv_item_i.source].column;
		end
	    #1;
        `uvm_info("SEQ",$sformatf("New item %0s", drv_item_i.item_str_content()),UVM_HIGH)
        finish_item(drv_item_i);  

        end
        `uvm_info("SEQ", $sformatf("Done generatating %0d items", cant_datos), UVM_LOW)

    endtask


endclass