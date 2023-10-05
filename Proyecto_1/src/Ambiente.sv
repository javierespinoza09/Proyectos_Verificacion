class Ambiente  #(parameter drvrs = 4, parameter pckg_sz = 16, parameter fifo_size = 8);
	/*
	rand int drvrs;
	rand int pckg_sz;
	rand int fifo_size;
	constraint valid_drvrs {drvrs < 15 ; drvrs >= 4;};
        constraint valid_fifo_size {fifo_size > 0; fifo_size < 20;};
        constraint valid_pckg_sz {pckg_sz >= 8; pckg_sz < 64;};
	*/

	///////////////////////////////////////////////
	/////Instancias de los bloques del ambiente////
	///////////////////////////////////////////////
	
       	Driver #(.drvrs(drvrs), .pckg_sz(pckg_sz), .fifo_size(fifo_size)) driver [drvrs];
    	Agente #(.drvrs(drvrs), .pckg_sz(pckg_sz)) agente;
        Monitor #(.drvrs(drvrs), .pckg_sz(pckg_sz)) monitor [drvrs];
    	//virtual bus_if #(.drvrs(drvrs), .pckg_sz(pckg_sz)) v_if;
        Generador #(.drvrs(drvrs), .pckg_sz(pckg_sz)) generador;
	checker_scoreboard #(.drvrs(drvrs), .pckg_sz(pckg_sz)) chk_sb;	
	/////////////////////////////////
	////Instancias de los mailbox////
	/////////////////////////////////
	
	gen_ag_mbx gen_ag_mbx;
	ag_chk_sb_mbx #(.pckg_sz(pckg_sz)) ag_chk_sb_mbx;
	tst_gen_mbx tst_gen_mbx;
	ag_dr_mbx #(.drvrs(drvrs), .pckg_sz(pckg_sz)) ag_dr_mbx[drvrs];
        mon_chk_sb_mbx mon_chk_sb_mbx;
    	function new();
            	for(int i = 0; i < drvrs; i++) begin
                   	automatic int k = i;
            		this.ag_dr_mbx[k] = new();
		end
		//////////////////////////////
		//Se inicializan los malibox//
		//////////////////////////////
		this.mon_chk_sb_mbx = new();
		this.gen_ag_mbx = new();
  		this.ag_chk_sb_mbx = new();
  		this.tst_gen_mbx = new ();
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
		this.chk_sb = new();
        	this.chk_sb.ag_chk_sb_mbx = ag_chk_sb_mbx;
		this.chk_sb.mon_chk_sb_mbx = mon_chk_sb_mbx;
		for (int i = 0; i<drvrs; i++ ) begin

			automatic int k = i;
			this.driver[k] = new(k);
                	this.monitor[k] = new(k);
            		this.monitor[k].mon_chk_sb_mbx = mon_chk_sb_mbx;
            		this.agente.ag_dr_mbx_array[k] = ag_dr_mbx[k];
            		this.driver[k].ag_dr_mbx = ag_dr_mbx[k];
            		//this.driver[k].fifo_in.v_if = v_if;
                	//this.monitor[k].v_if = v_if;
        	end

	endfunction


	task run();
		fork
                	this.agente.run();
        		this.chk_sb.run_ag();
			this.chk_sb.run_mon();
			this.generador.run();
                	for(int i = 0; i<drvrs; i++ ) begin
                        	fork
              				automatic int k = i;
              				this.driver[k].run();
              				this.monitor[k].run();
				join_none
                	end
		join
	endtask

	task resport();
		this.chk_sb.report_sb();
	endtask

	function display();
		$display("Ambiente: Drivers=%d / pckg=%d / fifo=%d",this.drvrs,this.pckg_sz,this.fifo_size);
	endfunction


endclass
