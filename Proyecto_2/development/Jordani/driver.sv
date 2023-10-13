`include "router_if.sv"
`include "Clases_mailbox.sv"
`include "fifo_in.sv"

//Driver se cominica de forma directa con la FIFO y por medio de un mailbox con el agente//

class Driver #(parameter drvrs = 4, parameter pckg_sz = 20, parameter fifo_size = 4, parameter ROWS = 2, parameter COLUMS = 2);
    	int drv_num;
  		int self_row;
  		int self_col;
  		fifo_in #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz)) fifo_in;//instancia de la FIFO que se comunica al DUT
 		ag_dr_mbx #(.pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS)) ag_dr_mbx;				   //Mailbox con el agente
  		ag_dr #(.pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS)) ag_dr_transaction;		   	   //Transacción para comunicarse con el agente
  		//ag_chk_sb_mbx #(.pckg_sz(pckg_sz)) ag_chk_sb_mbx;
    	//Transacciones
  		//ag_chk_sb #(.pckg_sz(pckg_sz)) ag_chk_sb_transaction;
	
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
	  $display("DRIVER %d: Transaction received",this.drv_num);
          while(this.fifo_in.d_q.size >= fifo_size) #5;
          this.fifo_in.fifo_push({this.ag_dr_transaction.Nxt_jump,this.ag_dr_transaction.id_row,this.ag_dr_transaction.id_colum,this.ag_dr_transaction.mode,this.ag_dr_transaction.dato});//Manda un paquete a la FIFO  
          $display("Se envió %b", {this.ag_dr_transaction.Nxt_jump,this.ag_dr_transaction.id_row,this.ag_dr_transaction.id_colum,this.ag_dr_transaction.mode,this.ag_dr_transaction.dato});
          //this.ag_chk_sb_transaction = new(this.ag_dr_transaction.dato, this.ag_dr_transaction.id, $time, this.ag_dr_transaction.source);
          //this.ag_chk_sb_mbx.put(ag_chk_sb_transaction);
		end
	endtask

	



endclass
