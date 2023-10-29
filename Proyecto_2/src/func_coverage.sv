class coverage #(parameter pckg_sz = 40);
	covergroup pop_cg;
		coverpoint router_tb.DUT.pop[0] {bins b1 = {1};}
		coverpoint router_tb.DUT.pop[1] {bins b1 = {1};}
		coverpoint router_tb.DUT.pop[2] {bins b1 = {1};}
		coverpoint router_tb.DUT.pop[3] {bins b1 = {1};}
		coverpoint router_tb.DUT.pop[4] {bins b1 = {1};}
		coverpoint router_tb.DUT.pop[6] {bins b1 = {1};}
                coverpoint router_tb.DUT.pop[7] {bins b1 = {1};}
                coverpoint router_tb.DUT.pop[8] {bins b1 = {1};}
                coverpoint router_tb.DUT.pop[9] {bins b1 = {1};}
                coverpoint router_tb.DUT.pop[10] {bins b1 = {1};}
		coverpoint router_tb.DUT.pop[11] {bins b1 = {1};}
                coverpoint router_tb.DUT.pop[12] {bins b1 = {1};}
                coverpoint router_tb.DUT.pop[13] {bins b1 = {1};}
                coverpoint router_tb.DUT.pop[14] {bins b1 = {1};}
                coverpoint router_tb.DUT.pop[15] {bins b1 = {1};}
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
	
	function new();
		pop_cg = new();
		id_row_cg = new();
		id_col_cg = new();
	endfunction

	task run();
		forever begin 
			#5
			pop_cg.sample();
			id_row_cg.sample();
			id_col_cg.sample;
		end
	endtask

	function display_coverage();
		$display("COVERTURA POP: %0.2f", pop_cg.get_coverage(),$time);
		$display("COVERTURA ROW: %0.2f", id_row_cg.get_coverage(),$time);
		$display("COVERTURA COLUMN: %0.2f", id_col_cg.get_coverage(),$time);
	endfunction




endclass

