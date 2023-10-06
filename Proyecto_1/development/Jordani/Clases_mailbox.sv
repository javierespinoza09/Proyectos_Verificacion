///////////////////////////////////
///////Clases de los Mailbox///////
///////////////////////////////////


class rand_values_generate;
	rand int drvrs;
        rand int pckg_sz;
        rand int fifo_size;
        constraint valid_drvrs {drvrs < 15 ; drvrs >= 4;};
        constraint valid_fifo_size {fifo_size > 0; fifo_size < 20;};
        constraint valid_pckg_sz {pckg_sz >= 8; pckg_sz < 64;};
endclass

class tst_chk_sb;
  int test;
  int drvrs;
  int pckg_sz;
  int fifo_size;
  function new ();
  endfunction;
endclass


class tst_gen;
  int caso;
  int id;
  int source;
  function new ();
  endfunction;
endclass


class gen_ag;
  int cant_datos;
  int data_modo;        
  int id_modo;
  int id_rand;
  int id;
  int source_rand;
  int source;
  function new ();
  endfunction;
endclass

class mon_chk_sb ;
  int id;
  int payload;
  int receiver;
  int tiempo;
  function new (int receiver);
	  this.receiver = receiver;
	  this.tiempo = $time;
  endfunction;
endclass


class ag_dr #(parameter pckg_sz = 16, parameter drvrs = 4);
  rand bit [pckg_sz-9:0] dato;
  rand bit [7:0] id;
  rand int source;
  int tiempo;
  int variability;
  int fix_source;
  
  //Respecto al Source
  constraint pos_source_addrs {source >= 0;};  //**Restriccion necesaria
  constraint source_addrs {source < drvrs;};  //**Restriccion para asegurar que el paquete se dirige a un driver existente (necesaria)
  //Respecto al ID
  constraint valid_addrs {id < drvrs;};       //Restriccion asegura que la direccion pertenece a un driver
  constraint self_addrs {id != source;};        //Restriccion que no permite a un id igual al del dispositivo
  //Respecto al DATO
  constraint data_variablility {dato inside {{(pckg_sz-8){1'b1}},{(pckg_sz-8){1'b0}}};};
  
  

  function new ();
    variability = pckg_sz - 9;
  endfunction;
  
endclass


class ag_chk_sb #(parameter pckg_sz = 16);
  bit [pckg_sz-9:0] payload ;
  bit [7:0] id ;
  int transaction_time;
  int source;
  
  function new(bit [pckg_sz-1:0] info,bit [7:0] destino,int tiempo,int source);
    this.payload = info;
    this.id = destino;
    this.transaction_time = tiempo;
    this.source = source;
  endfunction
  
  function display();
    $display("El dato: %b se envió, en el tiempo %g", this.payload, this.transaction_time);
  endfunction 
  
endclass


///////////////////
////Mailboxes//////
///////////////////
typedef mailbox #(ag_chk_sb) ag_chk_sb_mbx ;
typedef mailbox #(ag_dr) ag_dr_mbx ;
typedef mailbox #(gen_ag) gen_ag_mbx ;
typedef mailbox #(mon_chk_sb) mon_chk_sb_mbx;
typedef mailbox #(tst_gen) tst_gen_mbx;
typedef mailbox #(tst_chk_sb) tst_chk_sb_mbx;

/////////////////////////////////////////////
//Set de variables para los casos de prueba//
/////////////////////////////////////////////
typedef enum {max_variabilidad, max_aleatoriedad} gen_ag_data_modo;
typedef enum {self_id, any_id, invalid_id, fix_source ,normal_id} gen_ag_id_modo;
typedef enum {bus_push, bus_pop} monitor_modo;
typedef enum {normal, broadcast, one_to_all, all_to_one} Generador_modo;