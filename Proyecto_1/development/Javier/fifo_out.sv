class fifo_out #(parameter packagesize = 16, parameter drvrs = 4);

	bit [packagesize-1:0] d_q[$];
	int fifo_num;
	virtual bus_if #(.drvrs(drvrs), .pckg_sz(packagesize)) v_if;
	parameter default_data = 0;
	function new (int fifo_num);
		d_q = {};
		this.fifo_num = fifo_num;
		$display("FIFO OUT %d inicializada",this.fifo_num);
		//this.v_if.pndng[0][this.fifo_num] = 0;
	endfunction

	task if_signal();
		$display("Funcion if_signal %d",this.fifo_num);
		forever begin
		@(posedge this.v_if.push[0][this.fifo_num]);
			this.d_q.push_back(this.v_if.D_push[0][this.fifo_num]);
			$display("PUSH %d",this.fifo_num);
		end
	endtask

endclass
