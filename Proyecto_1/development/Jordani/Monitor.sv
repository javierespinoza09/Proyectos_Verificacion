class Monitor #(parameter pckg_sz = 16, parameter drvrs = 4);
  /*       */
  /*Mailbox*/
  /*       */
	mon_chk_sb_mbx mon_chk_sb_mbx;
	mon_chk_sb mon_chk_sb_transaction;
	bit [pckg_sz-1:0] d_q[$];
	virtual bus_if #(.drvrs(drvrs), .pckg_sz(pckg_sz)) v_if;
	int mnt_num;

	function new(int mnt_num);
		this.d_q = {};
                this.mnt_num = mnt_num;
                this.mon_chk_sb_transaction = new(this.mnt_num);
                this.mon_chk_sb_mbx = new();
		$display("Monitor %d a iniciado",this.mnt_num);
	endfunction
  	//////////////////////////////////////////////
	//Envía la transacción al Driver y al CHK_SB//
    //////////////////////////////////////////////
	task run();
      forever begin
        @(posedge this.v_if.push[0][this.mnt_num]);
        this.d_q.push_back(this.v_if.D_push[0][this.mnt_num]);
		this.mon_chk_sb_transaction = new(this.mnt_num);
        this.mon_chk_sb_transaction.id = this.v_if.D_push[0][this.mnt_num][pckg_sz-1:pckg_sz-8];
        this.mon_chk_sb_transaction.payload = this.v_if.D_push[0][this.mnt_num][pckg_sz-9:0];
        this.mon_chk_sb_mbx.put(mon_chk_sb_transaction);
      end
	endtask

endclass
