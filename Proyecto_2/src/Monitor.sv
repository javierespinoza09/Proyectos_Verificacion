class Monitor #(parameter COLUMS = 2, parameter ROWS = 2, parameter pckg_sz = 20, parameter drvrs = 4, parameter fifo_size = 4);
  /*       */
  /*Mailbox*/
  /*       */
	mon_chk_mbx mon_chk_mbx;
	mon_chk mon_chk_transaction;
	bit [pckg_sz-1:0] d_q[$];
    virtual router_if #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz), .fifo_depth(fifo_size)) v_if;
	int mnt_num;
  	int self_row;
  	int self_col;

	function new(int mnt_num);
		this.d_q = {};
                this.mnt_num = mnt_num;
                //this.mon_chk_sb_transaction = new(this.mnt_num);
                //this.mon_chk_sb_mbx = new();
		$display("Monitor %d a iniciado",this.mnt_num);
		
	endfunction
  	//////////////////////////////////////////////
	//Envía la transacción al Driver y al CHK_SB//
    //////////////////////////////////////////////
	task run();
		this.v_if.pop[this.mnt_num] = 0;
      forever begin
        @(posedge this.v_if.clk);
        if(this.v_if.pndng[this.mnt_num] == 1)begin
			this.v_if.pop[this.mnt_num] = 1;
        	this.d_q.push_back(this.v_if.data_out[this.mnt_num]);
        	//$display("\nDATO ENTRÓ A LA FIFO %d",this.mnt_num);
        	//$display("DATO: %b",this.v_if.data_out[this.mnt_num]);
          	this.mon_chk_transaction = new(this.mnt_num);
          	this.mon_chk_transaction.row = this.v_if.data_out[this.mnt_num][pckg_sz-9:pckg_sz-12];
          	this.mon_chk_transaction.colum = this.v_if.data_out[this.mnt_num][pckg_sz-13:pckg_sz-16];
          	this.mon_chk_transaction.payload = this.v_if.data_out[this.mnt_num][pckg_sz-18:0];
          	this.mon_chk_transaction.key = this.v_if.data_out[this.mnt_num][pckg_sz-1:0];
        	this.mon_chk_mbx.put(mon_chk_transaction);
          	//$display("EL MONITOR [%0d][%0d] RECIBIÓ UN PAQUETE INCORRECTO [%0d][%0d]",self_row,self_col,this.mon_chk_transaction.row,this.v_if.data_out[this.mnt_num][pckg_sz-13:pckg_sz-16]);
          assert ((self_row == this.mon_chk_transaction.row) | (self_col ==this.mon_chk_transaction.colum));
            //#15;
            //#15;
	    @(posedge this.v_if.clk);
        this.v_if.pop[this.mnt_num] = 0;
        end
        
        else this.v_if.pop[this.mnt_num] = 0;
        	
	//else this.v_if.pop[this.mnt_num] = 0;
      end
     
      //#5;
      
	endtask

endclass
