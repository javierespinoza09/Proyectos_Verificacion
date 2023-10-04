class Ambiente #(parameter drvrs = 4, parameter pckg_sz = 16, parameter fifo_size = 8);
	
	///////////////////////////////////////////////
	/////Instancias de los bloques del ambiente////
	///////////////////////////////////////////////
	
       	Driver #(.drvrs(Drivers), , .pckg_sz(pckg_sz), .fifo_size(fifo_size)) driver [Drivers];
    	Agente #(.drvrs(Drivers), .pckg_sz(pckg_sz)) agente;
        Monitor #(.drvrs(Drivers), .pckg_sz(pckg_sz)) monitor [Drivers];
    	virtual bus_if #(.drvrs(Drivers), .pckg_sz(pckg_sz)) v_if (.clk(clk_tb));
        Generador #(.drvrs(Drivers), .pckg_sz(pckg_sz)) generador;
	
	/////////////////////////////////
	////Instancias de los mailbox////
	/////////////////////////////////
	
	gen_ag_mbx gen_ag_mbx;
	ag_chk_sb_mbx ag_chk_sb_mbx;
	tst_gen_mbx tst_gen_mbx;
	ag_dr_mbx ag_dr_mbx[Drivers];
        mon_chk_sb_mbx mon_chk_sb_mbx[Drivers];
    	function new();
            	for(int i = 0; i < Drivers; i++) begin
                   	automatic int k = i;
            		this.ag_dr_mbx[k] = new();
           		this.mon_chk_sb_mbx[k] = new();
		end
		//////////////////////////////
		//Se inicializan los malibox//
		//////////////////////////////
		this.gen_ag_mbx gen_ag_mbx = new();
  		this.ag_chk_sb_mbx ag_chk_sb_mbx = new();
  		this.tst_gen_mbx tst_gen_mbx = new ();
		////////////////////////////////////////////////////////////////////
		//Se inicializan las clases agente, generador y checker_scoreboard//
		//	Se instancian los mailbox de cada modulo		  //	
		////////////////////////////////////////////////////////////////////
		this.agente = new();
		this.agente.gen_ag_mbx = gen_ag_mbx;
		this.agente.ag_chk_sb_mbx = ag_chk_sb_mbx;
		this.generador = new();
		this.generador.gen_ag_mbx = gen_ag_mbx;
		this.generador.tst_gen_mbx = tst_gen_mbx;
		this.chk_sb_m = new();
        	this.chk_sb_m.ag_chk_sb_mbx = ag_chk_sb_mbx;

		for (int i = 0; i<Drivers; i++ ) begin

			automatic int k = i;
			this.driver[k] = new(k);
                	this.monitor[k] = new(k);
            
            		this.agente.ag_dr_mbx_array[k] = ag_dr_mbx[k];
                	this.chk_sb_m.mon_chk_sb_mbx[k] = mon_chk_sb_mbx[k];
                	this.monitor[k].mon_chk_sb_mbx = mon_chk_sb_mbx[k];
            		this.driver[k].ag_dr_mbx = ag_dr_mbx[k];
            		this.driver[k].fifo_in.v_if = v_if;
                	this.monitor[k].v_if = v_if;
        	end

	endfunction


	task run();
		fork
                	this.agente.run();
        		this.chk_sb_m.run();
                	for(int i = 0; i<Drivers; i++ ) begin
                        	fork
              				automatic int k = i;
              				this.driver[k].run();
              				this.monitor[k].run();
				join_none
                	end
		join_none
	endtask

	task resport();
		this.chk_sb_m.report_sb();
	endtask


endclass
