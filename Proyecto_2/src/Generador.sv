/* Este módulo se encarga de indicarle al agente los parámetros de los
Datos que debe generar para cada uno de los test                    */

class Generador #(parameter drvrs = 4, parameter pckg_sz = 16);
  /*       */
  /*Mailbox*/
  /*       */
  tst_gen_mbx tst_gen_mbx;
  gen_ag_mbx gen_ag_mbx;
  gen_ag gen_ag_transaction;
  tst_gen tst_gen_transaction;
  //gen_chk_sb_mbx gen_chk_sb_mbx;
  //gen_chk_sb gen_chk_sb_transaction;

  function new();
    this.gen_ag_transaction = new();
    this.tst_gen_transaction = new();
    //this.gen_chk_sb_transaction = new();
  endfunction 
  /*                                         */
  /*Contiene los casos de generación de datos*/
  /*                                         */
  task run ();
    forever begin
    tst_gen_mbx.get(tst_gen_transaction);
	  $display("GENERADOR: Transaccion recivida de TEST recibida en %d",$time);  
    this.tst_gen_transaction = new();  
    case (this.tst_gen_transaction.caso)
      normal:begin
        //this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.cant_datos = 5;
        this.gen_ag_transaction.id_modo = normal_id;
        this.gen_ag_transaction.id_rand = 1;
        this.gen_ag_transaction.id_row = tst_gen_transaction.id_row;
        this.gen_ag_transaction.id_colum = tst_gen_transaction.id_colum;
        this.gen_ag_transaction.source_rand = 1;
        this.gen_ag_transaction.source = tst_gen_transaction.source;
        
      end
      broadcastt:begin
        this.gen_ag_transaction.cant_datos = 5;
        this.gen_ag_transaction.id_rand = 0;
        this.gen_ag_transaction.id_modo = normal_id;
        //this.gen_ag_transaction.data_modo = max_aleatoriedad;
        //this.gen_ag_transaction.id = {8{1'b1}};
        this.gen_ag_transaction.source_rand = 1;
        this.gen_ag_transaction.source = tst_gen_transaction.source;
        
      end
      one_to_all:begin
        //this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.cant_datos = 40;
        this.gen_ag_transaction.id_modo = normal_id;
        this.gen_ag_transaction.id_rand = 1;
        this.gen_ag_transaction.id_row = tst_gen_transaction.id_row;
        this.gen_ag_transaction.id_colum = tst_gen_transaction.id_colum;
        this.gen_ag_transaction.source_rand = 0;
        this.gen_ag_transaction.source = tst_gen_transaction.source;
        
      end
      one_to_all_itself:begin
        //this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.cant_datos = 40;
        this.gen_ag_transaction.id_modo = self_id;
        this.gen_ag_transaction.id_rand = 1;
        this.gen_ag_transaction.id_row = tst_gen_transaction.id_row;
        this.gen_ag_transaction.id_colum = tst_gen_transaction.id_colum;
        this.gen_ag_transaction.source_rand = 0;
        this.gen_ag_transaction.source = tst_gen_transaction.source;
        
      end
      all_to_one:begin
        //this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.cant_datos = 30;
        this.gen_ag_transaction.id_modo = normal_id;
        this.gen_ag_transaction.id_rand = 0;
        this.gen_ag_transaction.id_row = tst_gen_transaction.id_row;
        this.gen_ag_transaction.id_colum = tst_gen_transaction.id_colum;
        this.gen_ag_transaction.source_rand = 1;
        this.gen_ag_transaction.source = tst_gen_transaction.source;
        
      end
      all_to_one_itself:begin
        //this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.cant_datos = 30;
        this.gen_ag_transaction.id_modo = self_id;
        this.gen_ag_transaction.id_rand = 0;
        this.gen_ag_transaction.id_row = tst_gen_transaction.id_row;
        this.gen_ag_transaction.id_colum = tst_gen_transaction.id_colum;
        this.gen_ag_transaction.source_rand = 1;
        this.gen_ag_transaction.source = tst_gen_transaction.source;
        
      end
      any:begin
        //this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.cant_datos = 35;
        this.gen_ag_transaction.id_modo = any_id;
        this.gen_ag_transaction.id_rand = 1;
        this.gen_ag_transaction.id_row = tst_gen_transaction.id_row;
        this.gen_ag_transaction.id_colum = tst_gen_transaction.id_colum;
        this.gen_ag_transaction.source_rand = 1;
        this.gen_ag_transaction.source = tst_gen_transaction.source;
        
      end
      itself:begin
        //this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.cant_datos = 5;
        this.gen_ag_transaction.id_modo = send_to_itself;
        this.gen_ag_transaction.id_rand = 1;
        this.gen_ag_transaction.id_row = tst_gen_transaction.id_row;
        this.gen_ag_transaction.id_colum = tst_gen_transaction.id_colum;
        this.gen_ag_transaction.source_rand = 0;
        this.gen_ag_transaction.source = tst_gen_transaction.source;
        
      end
      
      default: begin
        //this.gen_ag_transaction.cant_datos = 10;
        $display("Generador \n Warning: Invalid test-case %g", this.tst_gen_transaction.caso);
      end 
      
	endcase

  this.gen_ag_transaction.mode = this.tst_gen_transaction.mode;
  
  gen_ag_mbx.put(gen_ag_transaction);
  //gen_chk_sb_transaction.cant_datos = this.gen_ag_transaction.cant_datos;
  //gen_chk_sb_mbx.put(gen_chk_sb_transaction);
end
    
    
    
  endtask
  
endclass
