//`include "fifo_out.sv"
class Monitor #(parameter pckg_sz = 16, parameter drvrs = 4);
	mon_chk_sb_mbx mon_chk_sb_mbx;
	mon_chk_sb #(.pckg_sz(pckg_sz)) mon_chk_sb_transaction;
	bit [pckg_sz-1:0] d_q[$];
	//fifo_out #(.packagesize(pckg_sz), .drvrs(drvrs)) fifo_out;
	virtual bus_if #(.drvrs(drvrs), .pckg_sz(pckg_sz)) v_if;
	int mnt_num;

	function new(int mnt_num);
		this.d_q = {};
                this.mnt_num = mnt_num;
                this.mon_chk_sb_transaction = new(this.mnt_num);
                this.mon_chk_sb_mbx = new();
		//this.fifo_out = new(mnt_num);
		$display("Monitor %d a iniciado",this.mnt_num);
	endfunction

	task run();
		forever begin
			@(posedge this.v_if.push[0][this.mnt_num]);
               		this.d_q.push_back(this.v_if.D_push[0][this.mnt_num]);
			this.mon_chk_sb_transaction = new(this.mnt_num);
                        this.mon_chk_sb_transaction.id = this.v_if.D_push[0][this.mnt_num][pckg_sz-1:pckg_sz-9];
                        this.mon_chk_sb_transaction.payload = this.v_if.D_push[0][this.mnt_num][pckg_sz-9:0];
                        this.mon_chk_sb_mbx.put(mon_chk_sb_transaction);
                        $display("PUSH %d Dato %d Tiempo %d",this.mnt_num,this.v_if.D_push[0][this.mnt_num], $time);
      		end
	endtask

endclass
