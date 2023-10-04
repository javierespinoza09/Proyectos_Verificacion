class Generador #(parameter drvrs = 4, parameter pckg_sz = 16);
  tst_gen_mbx tst_gen_mbx;
  gen_ag_mbx gen_ag_mbx;
  gen_ag gen_ag_transaction;
  tst_gen tst_gen_transaction;

  function new();
    this.gen_ag_transaction = new();
    this.tst_gen_transaction = new();
  endfunction 
  
  task run ();
    //this.gen_ag_transaction.cant_datos = 10;
    //this.gen_ag_transaction.data_modo = max_variabilidad;
    //gen_ag_mbx.put(gen_ag_transaction);
    tst_gen_mbx.get(tst_gen_transaction);
    
    case (this.tst_gen_transaction.caso)
      normal:begin
        this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.cant_datos = 10;
        this.gen_ag_transaction.id_modo = normal_id;
        this.gen_ag_transaction.id_rand = 1;
        this.gen_ag_transaction.id = 0;
        this.gen_ag_transaction.source_rand = 1;
        this.gen_ag_transaction.source = 1;
        gen_ag_mbx.put(gen_ag_transaction);
      end
      broadcast:begin
        this.gen_ag_transaction.cant_datos = 1;
        this.gen_ag_transaction.id_rand = 0;
        this.gen_ag_transaction.id_modo = normal_id;
        this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.id = {8{1'b1}};
        this.gen_ag_transaction.source_rand = 1;
        this.gen_ag_transaction.source = 1;
        gen_ag_mbx.put(gen_ag_transaction);
      end
      one_to_all:begin
        this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.cant_datos = 10;
        this.gen_ag_transaction.id_modo = fix_source;
        this.gen_ag_transaction.id_rand = 1;
        this.gen_ag_transaction.id = 0;
        this.gen_ag_transaction.source_rand = 0;
        this.gen_ag_transaction.source = 1;
        gen_ag_mbx.put(gen_ag_transaction);
      end
      all_to_one:begin
        this.gen_ag_transaction.cant_datos = drvrs-1;
        this.gen_ag_transaction.id = 0;
        gen_ag_mbx.put(gen_ag_transaction);
      end
      default: begin
        this.gen_ag_transaction.cant_datos = 10;
        gen_ag_mbx.put(gen_ag_transaction);
      end 
      
	endcase
    
    
    
  endtask
  
endclass