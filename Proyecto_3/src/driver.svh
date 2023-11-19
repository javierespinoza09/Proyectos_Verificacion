//////////////////////////////////////////////////
//  Proyecto 3 Implementacion UVM               //
//  Seccion: UVM_Driver                         //
//  Desarrollado por: J. Espinoza y J. Mejia    //
//  Revisado por: R. Garcia                     //
//  2023                                        //
//////////////////////////////////////////////////

class driver extends uvm_driver#(drv_item);
  
  `uvm_component_utils(driver)
  parameter fifo_size = 4;
  parameter pckg_sz = 40;
  virtual router_if v_if;
  int driver_num;
  int count;
  bit [3:0] self_row;
  bit [3:0] self_col;
  bit [40-1:0] d_q [$];
  bit [40-1:0] paquete;
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual router_if)::get(this, "", "v_if", v_if)) begin
      `uvm_error("","uvm_config_db::get failed")
    end
    /*if(!uvm_config_db#(int)::get(this, "", "fifo_size", fifo_size)) begin
          `uvm_error("","uvm_config_db::get failed")
    end
    if(!uvm_config_db#(int)::get(this, "", "pckg_sz", pckg_sz)) begin
          `uvm_error("","uvm_config_db::get failed")
    end*/
  endfunction
  
  
  task run_phase(uvm_phase phase);
    //Objecion
    //v_if.reset = 1;
    fork 
      this.if_signal();
      begin 
        forever begin
          //this.ag_dr_mbx.get(ag_dr_transaction);
          drv_item drv_item_i;
          seq_item_port.get_next_item(drv_item_i);                                      
	        this.count = 0;
	          while(this.d_q.size >= fifo_size) #5;
          paquete = {drv_item_i.Nxt_jump,drv_item_i.id_row,drv_item_i.id_colum,drv_item_i.mode,self_row,self_col,drv_item_i.dato};	
              this.fifo_push(paquete);//Manda un paquete a la FIFO  
              seq_item_port.item_done();
              //drv_sb_transaction = new(paquete,self_row,self_col,$time);
              //drv_sb_mbx.put(drv_sb_transaction);
        end
      end
    join_none


    //phase.raise_objection(this);
    /*
    @(posedge v_if.clk);
    #20;
    v_if.reset = 0;
    #10;
    `uvm_warning("Se hizo el reinicio en driver!",get_type_name())
    //Delay grandote
    //Bajar Objscion
    */
  endtask

  function fifo_push(bit [pckg_sz-1:0] dato); 
			this.d_q.push_back(dato);
			this.v_if.data_out_i_in[this.driver_num] = d_q[0];
			this.v_if.pndng_i_in[this.driver_num] = 1;
	endfunction


  task if_signal();
      	this.v_if.pndng_i_in[this.driver_num] = 0;
        this.v_if.data_out_i_in[this.driver_num] = 0;
		forever begin
			if(this.d_q.size==0) begin 
				this.v_if.pndng_i_in[this.driver_num] = 0;
				this.v_if.data_out_i_in[this.driver_num] = 0;
			end
			else begin
				this.v_if.pndng_i_in[this.driver_num] = 1;
				this.v_if.data_out_i_in[this.driver_num] = d_q[0];
			end
      @(posedge this.v_if.popin[this.driver_num]);
			if(this.d_q.size>0) this.d_q.delete(0);
		end
	endtask
  
  
endclass: driver