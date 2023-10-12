class Monitor #(parameter column = 2, parameter row = 2, parameter packagesize = 20, parameter drvrs = 4, parameter fifo_size = 4);
  /*       */
  /*Mailbox*/
  /*       */
	//mon_chk_sb_mbx mon_chk_sb_mbx;
	//mon_chk_sb mon_chk_sb_transaction;
	bit [packagesize-1:0] d_q[$];
	virtual router_if #(.ROWS(row), .COLUMS(column), .pckg_sz(packagesize),.fifo_depth(fifo_size)) v_if;
	int mnt_num;

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
      forever begin
        @(posedge this.v_if.clk);
        if(this.v_if.pndng[this.mnt_num] == 1)begin
        	this.d_q.push_back(this.v_if.data_out_i_in[this.mnt_num]);
        	$display("\nDATO ENTRÓ A LA FIFO %d",this.mnt_num);
        	$display("DATO: %b\n",this.mnt_num);
        
		//this.mon_chk_sb_transaction = new(this.mnt_num);
        //this.mon_chk_sb_transaction.id = this.v_if.D_push[0][this.mnt_num][pckg_sz-1:pckg_sz-8];
        //this.mon_chk_sb_transaction.payload = this.v_if.D_push[0][this.mnt_num][pckg_sz-9:0];
        //this.mon_chk_sb_mbx.put(mon_chk_sb_transaction);
            //#15;
            this.v_if.pop[this.mnt_num] = 1;
            //#15;
          
        end
      end
      this.v_if.pop[this.mnt_num] = 0;
      //#5;
      
	endtask

endclass