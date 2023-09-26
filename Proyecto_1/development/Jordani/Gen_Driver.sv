`include "bus_if"
`include "test_mbx"

class example_driver #(parameter drvrs = 4, parameter pckg_sz = 16);
	virtual bus_if #(.drvrs(drvrs), .pckg_sz(pckg_sz)) v_if;
  
    ag_chk_sb_mbx ag_chk_sb_mbx;
  
    ag_chk_sb #(.packagesize(pckg_sz), .drivers(drvrs)) transaction;
 
  
	rand bit [pckg_sz-9:0] payload;
	randc bit [7:0] id;
	int drv_num;
  

  
  constraint valid_addrs {id < drvrs;};


	function new (int drv_num);
		this.drv_num = drv_num;
	endfunction	

	task run();
		this.v_if.pndng[0][this.drv_num] = 1;	
		this.v_if.D_pop[0][this.drv_num] = {this.id,this.payload};
      this.transaction = new(this.payload, this.id, $time); //crea el mensaje
        this.transaction.randomize();
      @(posedge v_if.pop[0][this.drv_num])begin
        if (this.v_if.pop[0][this.drv_num]) begin
          #2
		  this.v_if.pndng[0][this.drv_num] = 0;
          this.transaction.display();
          ag_chk_sb_mbx.put(transaction);
		end 
      end 
			
	endtask
  task recibido();
    int espera = 0;
    while(espera==0)begin
      if (this.v_if.push[0][this.drv_num]==1) begin
          $display("Device_ 0x%0d Dato Recibido 0x%0d",this.drv_num,this.v_if.D_push[0][this.drv_num]);
          espera = 1;
        end
      #2;
    end 
  endtask
  
	function display();
      $display("Dato: %b  Dispositivo: %b", this.payload,this.id);
	endfunction

endclass 