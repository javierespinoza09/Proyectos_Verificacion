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
  gen_chk_sb_mbx gen_chk_sb_mbx;
  gen_chk_sb gen_chk_sb_transaction;

  function new();
    this.gen_ag_transaction = new();
    this.tst_gen_transaction = new();
    this.gen_chk_sb_transaction = new();
  endfunction 
  /*                                         */
  /*Contiene los casos de generación de datos*/
  /*                                         */
  task run ();
    forever begin
    tst_gen_mbx.get(tst_gen_transaction);
	$display("GENERADOR: Transaccion recivida de TEST recibida en %d",$time);    
    case (this.tst_gen_transaction.caso)
      normal:begin
        this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.cant_datos = 15;
        this.gen_ag_transaction.id_modo = normal_id;
        this.gen_ag_transaction.id_rand = 1;
        this.gen_ag_transaction.id = tst_gen_transaction.id;
        this.gen_ag_transaction.source_rand = 1;
        this.gen_ag_transaction.source = tst_gen_transaction.source;
        gen_ag_mbx.put(gen_ag_transaction);
        gen_chk_sb_transaction.cant_datos = this.gen_ag_transaction.cant_datos;
        gen_chk_sb_mbx.put(gen_chk_sb_transaction);
      end
      broadcast:begin
        this.gen_ag_transaction.cant_datos = 5;
        this.gen_ag_transaction.id_rand = 0;
        this.gen_ag_transaction.id_modo = normal_id;
        this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.id = {8{1'b1}};
        this.gen_ag_transaction.source_rand = 1;
        this.gen_ag_transaction.source = tst_gen_transaction.source;
        gen_ag_mbx.put(gen_ag_transaction);
        gen_chk_sb_transaction.cant_datos = this.gen_ag_transaction.cant_datos;
        gen_chk_sb_mbx.put(gen_chk_sb_transaction);
      end
      one_to_all:begin
        this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.cant_datos = 10;
        this.gen_ag_transaction.id_modo = fix_source;
        this.gen_ag_transaction.id_rand = 1;
        this.gen_ag_transaction.id = tst_gen_transaction.id;
        this.gen_ag_transaction.source_rand = 0;
        this.gen_ag_transaction.source = tst_gen_transaction.source;
        gen_ag_mbx.put(gen_ag_transaction);
        gen_chk_sb_transaction.cant_datos = this.gen_ag_transaction.cant_datos;
        gen_chk_sb_mbx.put(gen_chk_sb_transaction);
      end
      all_to_one:begin
        this.gen_ag_transaction.data_modo = max_aleatoriedad;
        this.gen_ag_transaction.cant_datos = 10;
        this.gen_ag_transaction.id_modo = fix_source;
        this.gen_ag_transaction.id_rand = 0;
        this.gen_ag_transaction.id = tst_gen_transaction.id;
        this.gen_ag_transaction.source_rand = 1;
        this.gen_ag_transaction.source = tst_gen_transaction.source;
        gen_ag_mbx.put(gen_ag_transaction);
        gen_chk_sb_transaction.cant_datos = this.gen_ag_transaction.cant_datos;
        gen_chk_sb_mbx.put(gen_chk_sb_transaction);
      end
      default: begin
        this.gen_ag_transaction.cant_datos = 10;
        gen_ag_mbx.put(gen_ag_transaction);
        gen_chk_sb_transaction.cant_datos = this.gen_ag_transaction.cant_datos;
        gen_chk_sb_mbx.put(gen_chk_sb_transaction);
      end 
      
	endcase
end
    
    
    
  endtask
  
endclass