class Monitor #(parameter pckg_sz = 16, parameter drvrs = 4);
	mon_chk_sb_mbx mon_chk_sb_mbx;
	mon_chk_sb #(.pckg_sz(pckg_sz)) mon_chk_sb_transaction;

	virtual bus_if #(.drvrs(drvrs), .pckg_sz(pckg_sz)) v_if;
	int mnt_num;

	function new(int drv_num);
                this.mnt_num = mnt_num;
                this.mon_chk_sb_transaction = new();
                this.mon_chk_sb_mbx = new();
		$display("Monitor %d a iniciado",this.mnt_num);
	endfunction

	task run();
		forever begin
			@(posedge this.v_if.clk);
			if(this.v_if.pop[0][this.mnt_num]) begin
				this.mon_chk_sb_transaction = new();
				this.mon_chk_sb_transaction.id = this.v_if.D_pop[0][this.mnt_num][drvrs-1:drvrs-9];
				this.mon_chk_sb_transaction.payload = this.v_if.D_pop[0][this.mnt_num][drvrs-9:0];
				this.mon_chk_sb_transaction.sender = this.mnt_num;
				this.mon_chk_sb_transaction.tiempo = $time;
				this.mon_chk_sb_transaction.tipo_interaccion = bus_pop;
				this.mon_chk_sb_mbx.put(mon_chk_sb_transaction);
				$display("POP %d Dato %h Tiempo %d",this.mnt_num,this.v_if.D_pop[0][this.mnt_num], $time);
			end
			if(this.v_if.push[0][this.mnt_num]) begin
                                this.mon_chk_sb_transaction = new();
                                this.mon_chk_sb_transaction.id = this.v_if.D_push[0][this.mnt_num][drvrs-1:drvrs-9];
                                this.mon_chk_sb_transaction.payload = this.v_if.D_push[0][this.mnt_num][drvrs-9:0];
                                this.mon_chk_sb_transaction.receiver = this.mnt_num;
                                this.mon_chk_sb_transaction.tiempo = $time;
				this.mon_chk_sb_transaction.tipo_interaccion = bus_push;
				$display("PUSH %d Dato %h Tiempo %d",this.mnt_num,this.v_if.D_pop[0][this.mnt_num], $time);
                                this.mon_chk_sb_mbx.put(mon_chk_sb_transaction);
                        end
		
		end
	
	endtask

endclass
