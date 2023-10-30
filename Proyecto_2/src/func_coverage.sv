class coverage #(parameter pckg_sz = 40);
	covergroup pop_cg;
		coverpoint router_tb.DUT.popin[0] {bins b1 = {1};}
		coverpoint router_tb.DUT.popin[1] {bins b1 = {1};}
		coverpoint router_tb.DUT.popin[2] {bins b1 = {1};}
		coverpoint router_tb.DUT.popin[3] {bins b1 = {1};}
		coverpoint router_tb.DUT.popin[4] {bins b1 = {1};}
		coverpoint router_tb.DUT.popin[6] {bins b1 = {1};}
                coverpoint router_tb.DUT.popin[7] {bins b1 = {1};}
                coverpoint router_tb.DUT.popin[8] {bins b1 = {1};}
                coverpoint router_tb.DUT.popin[9] {bins b1 = {1};}
                coverpoint router_tb.DUT.popin[10] {bins b1 = {1};}
		coverpoint router_tb.DUT.popin[11] {bins b1 = {1};}
                coverpoint router_tb.DUT.popin[12] {bins b1 = {1};}
                coverpoint router_tb.DUT.popin[13] {bins b1 = {1};}
                coverpoint router_tb.DUT.popin[14] {bins b1 = {1};}
                coverpoint router_tb.DUT.popin[15] {bins b1 = {1};}
	endgroup

	covergroup id_row_cg;
		coverpoint router_tb.DUT.data_out[0][pckg_sz-9:pckg_sz-12] {bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[1][pckg_sz-9:pckg_sz-12] {bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[2][pckg_sz-9:pckg_sz-12] {bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[3][pckg_sz-9:pckg_sz-12] {bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[4][pckg_sz-9:pckg_sz-12]{bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[5][pckg_sz-9:pckg_sz-12]{bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[6][pckg_sz-9:pckg_sz-12]{bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[7][pckg_sz-9:pckg_sz-12]{bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[8][pckg_sz-9:pckg_sz-12]{bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[9][pckg_sz-9:pckg_sz-12]{bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[10][pckg_sz-9:pckg_sz-12]{bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[11][pckg_sz-9:pckg_sz-12]{bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[12][pckg_sz-9:pckg_sz-12]{bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[13][pckg_sz-9:pckg_sz-12]{bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[14][pckg_sz-9:pckg_sz-12]{bins r = {[0:5]};}
		coverpoint router_tb.DUT.data_out[15][pckg_sz-9:pckg_sz-12]{bins r = {[0:5]};}
	endgroup

	covergroup id_col_cg;
                coverpoint router_tb.DUT.data_out[0][pckg_sz-13:pckg_sz-16] {bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[1][pckg_sz-13:pckg_sz-16] {bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[2][pckg_sz-13:pckg_sz-16] {bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[3][pckg_sz-13:pckg_sz-16] {bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[4][pckg_sz-13:pckg_sz-16]{bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[5][pckg_sz-13:pckg_sz-16]{bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[6][pckg_sz-13:pckg_sz-16]{bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[7][pckg_sz-13:pckg_sz-16]{bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[8][pckg_sz-13:pckg_sz-16]{bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[9][pckg_sz-13:pckg_sz-16]{bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[10][pckg_sz-13:pckg_sz-16]{bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[11][pckg_sz-13:pckg_sz-16]{bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[12][pckg_sz-13:pckg_sz-16]{bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[13][pckg_sz-13:pckg_sz-16]{bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[14][pckg_sz-13:pckg_sz-16]{bins c = {[0:5]};}
                coverpoint router_tb.DUT.data_out[15][pckg_sz-13:pckg_sz-16]{bins c = {[0:5]};}
        endgroup

	covergroup i_pop;
		coverpoint router_tb.DUT._rw_[1]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[1]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[2]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop = {1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop= {1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[3]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop {bins i_pop ={1};} 
coverpoint router_tb.DUT._rw_[4]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop {bins i_pop ={1};}
	endgroup
	
	function new();
		pop_cg = new();
		id_row_cg = new();
		id_col_cg = new();
		i_pop = new();
	endfunction

	task run();
		forever begin 
			#5
			pop_cg.sample();
			id_row_cg.sample();
			id_col_cg.sample();
			i_pop.sample();
		end
	endtask

	function display_coverage();
		$display("COVERTURA POP: %0.2f", pop_cg.get_coverage(),$time);
		$display("COVERTURA ROW: %0.2f", id_row_cg.get_coverage(),$time);
		$display("COVERTURA COLUMN: %0.2f", id_col_cg.get_coverage(),$time);
		$display("COVERTURA DE I_POP: %0.2f", i_pop.get_coverage(),$time);
	endfunction




endclass

