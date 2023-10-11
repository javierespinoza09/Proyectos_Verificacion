class fifo_in #(parameter column = 4, parameter row = 4, parameter packagesize = 40, parameter drvrs = 4, parameter fifo_size = 8);

	bit [packagesize-1:0] d_q[$];
	int fifo_num;
	virtual router_if #(.ROWS(row), .COLUMS(column), .pckg_sz(packagesize)) v_if;
	parameter default_data = 0;
	function new (int fifo_num);
		d_q = {};
		this.fifo_num = fifo_num;
		
	endfunction
	

	function fifo_push(bit [packagesize-1:0] dato); 
			this.d_q.push_back(dato);
			this.v_if.data_out_i_in[this.fifo_num] = d_q[0];
			this.v_if.pndng_i_in[this.fifo_num] = 1;
	endfunction

	task if_signal();
		$display("FIFO%d: if_signal running",this.fifo_num);
      	this.v_if.pndng_i_in[this.fifo_num] = 0;
		forever begin	
			
			if(this.d_q.size==0) begin 
				this.v_if.pndng_i_in[this.fifo_num] = 0;
				this.v_if.data_out_i_in[this.fifo_num] = 0;
			end
			else begin
				this.v_if.pndng_i_in[this.fifo_num] = 1;
				this.v_if.data_out_i_in[this.fifo_num] = d_q[0];
			end
          
          
          	@(posedge this.v_if.pop[0][this.fifo_num]);
			this.v_if.data_out_i_in[this.fifo_num] = d_q[0];
			@(posedge this.v_if.clk);
			if(this.d_q.size>0) this.d_q.delete(0);
		end
	endtask
  

endclass