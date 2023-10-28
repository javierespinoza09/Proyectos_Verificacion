class Test #(parameter drvrs = 4, 
            parameter pckg_sz = 16, 
            parameter fifo_size = 8, 
            parameter ROWS = 2, 
            parameter COLUMS = 2);

  tst_gen_mbx tst_gen_mbx;
  tst_gen tst_gen_transaction;
  //tst_chk_sb_mbx tst_chk_sb_mbx;
  //tst_chk_sb tst_chk_sb_transaction;
  rand_values_generate #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz)) rand_values_generate;
	int test;
       int source;
       int id;
  function new(int test);
    this.tst_gen_transaction = new();
    this.tst_gen_mbx = new();
   // this.tst_chk_sb_transaction = new();
	this.test = test;
    rand_values_generate = new();
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
    case(this.test)
        source_burst: begin
            rand_values_generate.randomize();
            for(int i = 0; i <= rand_values_generate.burst_test_size; i++) begin
                this.tst_gen_transaction = new();
                rand_values_generate.randomize();
                tst_gen_transaction.cant_datos = rand_values_generate.burst_test;
                tst_gen_transaction.id_row = rand_values_generate.id_row;
		tst_gen_transaction.id_colum = rand_values_generate.id_colum;
                tst_gen_transaction.source = rand_values_generate.source;
                tst_gen_transaction.caso = one_to_all;
                tst_gen_mbx.put(tst_gen_transaction);
            end
        end

        id_burst:begin
            rand_values_generate.randomize();
            this.source = rand_values_generate.source;
            for(int i = 0; i <= rand_values_generate.burst_test_size; i++) begin
                this.tst_gen_transaction = new();
                rand_values_generate.randomize();
                tst_gen_transaction.cant_datos = rand_values_generate.burst_test;
                tst_gen_transaction.id_row = rand_values_generate.id_row;
                tst_gen_transaction.id_colum = rand_values_generate.id_colum;
                tst_gen_transaction.source = rand_values_generate.source;
                tst_gen_transaction.caso = all_to_one;
                tst_gen_mbx.put(tst_gen_transaction);
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
  endtask
  
  
endclass
