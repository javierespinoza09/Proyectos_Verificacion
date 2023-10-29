class Test #(parameter drvrs = 4, 
            parameter pckg_sz = 16, 
            parameter fifo_size = 8, 
            parameter ROWS = 2, 
            parameter COLUMS = 2);

	tst_gen_mbx tst_gen_mbx;
  	tst_gen tst_gen_transaction;
  	tb_tst_mbx tb_tst_mbx;
	tb_tst tb_tst_transaction;

  //tst_chk_sb_mbx tst_chk_sb_mbx;
  //tst_chk_sb tst_chk_sb_transaction;
  rand_values_generate #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz)) rand_values_generate;
	int test;
       int source;
       int id;
       int burst_test_size;
       int burst_test;
       r_c_mapping drv_map [COLUMS*2+ROWS*2];
       
  function new();
    this.tst_gen_transaction = new();
    this.tst_gen_mbx = new();
    this.tb_tst_mbx = new();
    rand_values_generate = new();
    for(int i = 0; i<COLUMS*2+ROWS*2; i++) begin 
	    automatic int k = i;
	    drv_map[k] = new();
    end
    `mapping(ROWS,COLUMS);
  endfunction
  
  task run();
  /*
	tst_gen_transaction.id = this.id;
	tst_gen_transaction.source = this.source;
    tst_gen_transaction.caso = this.test;
  	tst_gen_mbx.put(tst_gen_transaction);
    
    tst_chk_sb_transaction.test = this.test;
    tst_chk_sb_transaction.drvrs = this.drvrs;
    tst_chk_sb_transaction.pckg_sz = this.pckg_sz;
    tst_chk_sb_transaction.fifo_size = this.fifo_size;
    tst_chk_sb_mbx.put(tst_chk_sb_transaction);
    */
   forever begin
	   tb_tst_mbx.get(tb_tst_transaction);
	   this.test =  tb_tst_transaction.test;

    case(this.test)
        source_burst: begin
            rand_values_generate.randomize();
	   
	    this.burst_test_size = rand_values_generate.burst_test_size;
            for(int i = 0; i <= this.burst_test_size; i++) begin

		
                this.tst_gen_transaction = new();
		rand_values_generate.randomize();
                tst_gen_transaction.cant_datos = rand_values_generate.burst_test;
                tst_gen_transaction.id_row = rand_values_generate.id_row;
		tst_gen_transaction.id_colum = rand_values_generate.id_colum;
                tst_gen_transaction.source = rand_values_generate.source;
		tst_gen_transaction.mode =  tb_tst_transaction.mode;
		$display("RAND SOURCE %d BURST_SZ %d",rand_values_generate.source, rand_values_generate.burst_test);
                tst_gen_transaction.caso = one_to_all;
                tst_gen_mbx.put(tst_gen_transaction);
		#10;
		
		
            end
        end

        id_burst:begin

            rand_values_generate.randomize();
            this.burst_test_size = rand_values_generate.burst_test_size;
            for(int i = 0; i <= burst_test_size; i++) begin
                this.tst_gen_transaction = new();
                rand_values_generate.randomize();
                tst_gen_transaction.cant_datos = rand_values_generate.burst_test;
                tst_gen_transaction.id_row = rand_values_generate.id_row;
                tst_gen_transaction.id_colum = rand_values_generate.id_colum;
                tst_gen_transaction.source = rand_values_generate.source;
		tst_gen_transaction.mode =  tb_tst_transaction.mode;
                tst_gen_transaction.caso = all_to_one;
		$display("RAND ID [%d][%d] BURST_SZ %d",rand_values_generate.id_row, rand_values_generate.id_colum, rand_values_generate.burst_test);
                tst_gen_mbx.put(tst_gen_transaction);
		#10;
            end
        end

	itself_messages:begin
	       	rand_values_generate.randomize();
            this.burst_test_size = rand_values_generate.burst_test_size;
            for(int i = 0; i <= burst_test_size; i++) begin
                this.tst_gen_transaction = new();
                rand_values_generate.randomize();
                tst_gen_transaction.cant_datos = rand_values_generate.burst_test;
                tst_gen_transaction.id_row = rand_values_generate.id_row;
                tst_gen_transaction.id_colum = rand_values_generate.id_colum;
                tst_gen_transaction.source = rand_values_generate.source;
                tst_gen_transaction.mode =  tb_tst_transaction.mode;
                tst_gen_transaction.caso = itself;
                $display("RAND SOURCE[%d] BURST_SZ %d", rand_values_generate.source, rand_values_generate.burst_test);
                tst_gen_mbx.put(tst_gen_transaction);
                #10;
		end
	end

	even_source_load: begin
		rand_values_generate.randomize();
            	this.burst_test = rand_values_generate.burst_test;
            for(int i = 0; i < COLUMS*2+ROWS*2 ; i++) begin
                this.tst_gen_transaction = new();
                rand_values_generate.randomize();
                tst_gen_transaction.cant_datos = burst_test;
                tst_gen_transaction.id_row = rand_values_generate.id_row;
                tst_gen_transaction.id_colum = rand_values_generate.id_colum;
                tst_gen_transaction.source = i;
                tst_gen_transaction.mode =  tb_tst_transaction.mode;
                tst_gen_transaction.caso = one_to_all;
                $display("RAND BURST_SZ %d",burst_test);
		$display("TST_GEN: SOURCE [%0b] ", tst_gen_transaction.source);
                tst_gen_mbx.put(tst_gen_transaction);
                #10;


		end
	end
	
       	default: begin
		rand_values_generate.randomize();
		this.tst_gen_transaction = new();
                tst_gen_transaction.cant_datos = rand_values_generate.burst_test;
                tst_gen_transaction.id_row = rand_values_generate.id_row;
                tst_gen_transaction.id_colum = rand_values_generate.id_colum;
                tst_gen_transaction.source = this.rand_values_generate.source;
                tst_gen_transaction.caso = one_to_all;
                tst_gen_mbx.put(tst_gen_transaction);
	end
    

    endcase
    end
  endtask
  
  
endclass
