class example_driver;
	parameter drvrs = 4
	parameter pckg_sz = 16
	virtual bus_if #(.drvrs(drvrs), .pckg_sz(pckg_sz)) v_if;
	int automatic drv_num;
	rand bit [pckg_sz-9:0] payload;
	rand bit [7:0] id;

	constraint valid_addrs {id < $clog2(drvrs)};


	function new (int drv_num);
		this.drv_num = drv_num;
	endfunction	

	task run();
		v_if.pndng[0][this.drv_num] = 1;
		while (v_if.pndng[0][this.drv_num]) begin	
			v_if.D_pop[0][this.drv_num] = {this.id,this.payload};
			if (v_if.pop[0][this.drv_num]) begin
				#1
				v_if.pndng[0][this.drv_num] = 0;
			end
			if (v_if.push[0][this.drv_num]) begin
				$display("Device_%b Dato Recibido %b",this.drv_num,v_if.D_push[this.drv_num])
			end
			
		end
	endtask
	function display();
		$display("Dato: %b  Dispositivo: %b", this.payload,this.id)
	endfunction

endclass
