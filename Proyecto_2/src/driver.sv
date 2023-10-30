`include "router_if.sv"
`include "Clases_mailbox.sv"
`include "fifo_in.sv"

//Driver se cominica de forma directa con la FIFO y por medio de un mailbox con el agente//

class Driver #(parameter drvrs = 4, parameter pckg_sz = 20, parameter fifo_size = 4, parameter ROWS = 2, parameter COLUMS = 2);
  int drv_num;
  bit [3:0] self_row;
  bit [3:0] self_col;
  bit [pckg_sz-1:0] paquete;
  int count;
  fifo_in #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz), .fifo_size(fifo_size)) fifo_in;//instancia de la FIFO que se comunica al DUT
  ag_dr_mbx #(.pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS)) ag_dr_mbx;				   //Mailbox con el agente
  ag_dr #(.pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS)) ag_dr_transaction;		   	   //Transacción para comunicarse con el agente
  drv_sb_mbx #(.pckg_sz(pckg_sz)) drv_sb_mbx; 												//Transacciones
  drv_sb #(.pckg_sz(pckg_sz)) drv_sb_transaction;
	
	function new(int drv_num);
      this.drv_num = drv_num;							//Identificador único para cada Driver
      $display("Driver %d a iniciado",this.drv_num);     
      this.ag_dr_transaction = new();                  
      this.ag_dr_mbx = new(); 
      this.fifo_in = new(drv_num);                      //Contructor de la FIFO
    	endfunction

	/*
	Tarea run(): Se ejecuta una función recurrente que evalúa la cantidad de datos en la cola de entrada "q_in"
	para el control de la bandera "pndng", además de la obtención de paquetes tipo "ag_dr" para ser cargado en la cola 
	*/
	
	virtual task run();
		fork
			fifo_in.if_signal();
		join_none
		forever begin
          this.ag_dr_mbx.get(ag_dr_transaction);                                          //Comunicación con el agente
	this.count = 0;
	while(count < ag_dr_transaction.tiempo) begin
		#1
		count = count + 1;
	end
	while(this.fifo_in.d_q.size >= fifo_size) #5;
       	paquete = {this.ag_dr_transaction.Nxt_jump,this.ag_dr_transaction.id_row,this.ag_dr_transaction.id_colum,this.ag_dr_transaction.mode,this.self_row,this.self_col,this.ag_dr_transaction.dato[pckg_sz-26:0]};	
          this.fifo_in.fifo_push(paquete);//Manda un paquete a la FIFO  
          drv_sb_transaction = new(paquete,self_row,self_col,$time);
          drv_sb_mbx.put(drv_sb_transaction);
		end
	endtask

	



endclass

