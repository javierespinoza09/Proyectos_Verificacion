class fifo_in #(parameter packagesize = 16, parameter drvrs = 4, parameter fifo_size = 8);

	bit [packagesize-1:0] d_q[$];
	int fifo_num;
	virtual bus_if #(.drvrs(drvrs), .pckg_sz(packagesize)) v_if;
	parameter default_data = 0;
	function new (int fifo_num);
		d_q = {};
		this.fifo_num = fifo_num;
		//this.v_if.pndng[0][this.fifo_num] = 0;
	endfunction
	

	function fifo_push(bit dato);
		if(this.d_q.size < fifo_size) begin 
			this.d_q.push_back(dato);
			this.v_if.D_pop[0][this.fifo_num] = d_q[0];
			this.v_if.pndng[0][this.fifo_num] = 1;
		end
		else $display("FIFO %d FULL", this.fifo_num);
	endfunction

	task if_signal();
		forever begin	
			@(posedge this.v_if.pop[0][this.fifo_num]);
			this.v_if.D_pop[0][this.fifo_num] = d_q[0];
			@(posedge this.v_if.clk);
			this.d_q.delete(0);
			if(this.d_q.size==0) begin 
				this.v_if.pndng[0][this.fifo_num] = 0;
				this.v_if.D_pop[0][this.fifo_num] = 0;
			end
			else begin
				this.v_if.pndng[0][this.fifo_num] = 1;
				this.v_if.D_pop[0][this.fifo_num] = d_q[0];
			end
		end
	endtask

endclass
