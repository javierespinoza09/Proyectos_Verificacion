class example_driver;
	parameter drvrs = 4
	parameter pckg_sz = 16
	virtual bus_if #(.drvrs(drvrs), .pckg_sz(pckg_sz)) v_if;
	int automatic drv_num;
	rand bit [pckg_sz-9:0] payload;
	rand bit [8:0] id;

	constraint valid_addrs {id < $clog2(drvrs)};


	function new (int drv_num);
		this.drv_num = drv_num;
	endfunction	

	task run();
		v_if.pndng[this.drv_num] = 1;
		v_if.D_pop[this.drv_num] = {this.id,this.payload};
		if (v_if.pop[this.drv_num]) begin
			#1
			v_if.pndng[this.drv_num] = 0;
		end
		if (v_if.push[this.drv_num]) begin
			$display("Device_%d Dato Recibido %b",this.drv_num,v_if.D_push[this.drv_num])
	endtask


endclass
