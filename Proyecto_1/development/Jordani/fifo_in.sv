class fifo_in #(parameter packagesize = 16, parameter drvrs = 4, parameter fifo_size = 8);

	bit [packagesize-1:0] d_q[$];
	int fifo_num;
	virtual bus_if #(.drvrs(drvrs), .pckg_sz(packagesize)) v_if;
	parameter default_data = 0;
	function new (int fifo_num);
		d_q = {};
		this.fifo_num = fifo_num;
		
	endfunction
	

	function fifo_push(bit [packagesize-1:0] dato); 
			this.d_q.push_back(dato);
			this.v_if.D_pop[0][this.fifo_num] = d_q[0];
			this.v_if.pndng[0][this.fifo_num] = 1;
      		$display("FIFO %d, SE CARGÓ DATO %d", this.fifo_num, dato);
	endfunction

	task if_signal();
		$display("Funcion if_signal %d",this.fifo_num);
      	this.v_if.pndng[0][this.fifo_num] = 0;
		forever begin	
			
			if(this.d_q.size==0) begin 
				this.v_if.pndng[0][this.fifo_num] = 0;
				this.v_if.D_pop[0][this.fifo_num] = 0;
			end
			else begin
				this.v_if.pndng[0][this.fifo_num] = 1;
				this.v_if.D_pop[0][this.fifo_num] = d_q[0];
			end
          
          
          	@(posedge this.v_if.pop[0][this.fifo_num]);
			this.v_if.D_pop[0][this.fifo_num] = d_q[0];
			@(posedge this.v_if.clk);
			this.d_q.delete(0);
          
		end
	endtask
  

endclass
