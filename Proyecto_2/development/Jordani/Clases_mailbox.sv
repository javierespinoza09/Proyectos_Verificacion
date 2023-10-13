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

class tst_sb;
  int test;
  int drvrs;
  int pckg_sz;
  int fifo_size;
  function new ();
  endfunction;
endclass


class tst_gen;
  int caso;
  bit [3:0] row;
  bit [3:0] colum;
  int source;
  function new ();
  endfunction;
endclass


class gen_ag;
  int cant_datos;
  int data_modo;        
  int id_modo;
  int id_rand;
  bit [3:0] row;
  bit [3:0] colum;
  int source_rand;
  int source;
  function new ();
  endfunction;
endclass

class mon_sb;
  bit [3:0] row;
  bit [3:0] colum;
  int payload;
  int receiver;
  int tiempo;
  function new (int receiver);
	  this.receiver = receiver;
	  this.tiempo = $time;
  endfunction;
endclass


class ag_dr #(parameter pckg_sz = 20, parameter ROWS = 2, parameter COLUMS = 2);
  rand bit [pckg_sz-18:0] dato;
  randc bit [3:0] id_row;
  randc bit [3:0] id_colum;
  rand bit mode;
  rand int source;
  bit [7:0] Nxt_jump;
  int tiempo;
  int variability;
  int fix_source;
  
  //Respecto al Source
  constraint pos_source_addrs {source >= 0;};  //**Restriccion necesaria
  constraint source_addrs {source < COLUMS*2+ROWS*2;};  //**Restriccion para asegurar que el paquete se dirige a un driver existente (necesaria)
  //Respecto al ID
  constraint valid_addrs {id_row <= ROWS+1; id_row >= 0; id_colum <= COLUMS+1; id_colum >= 0;};       //Restriccion asegura que la direccion pertenece a un driver
  constraint valid_addrs_col {if(id_row == 0 | id_row == ROWS+1)id_colum <= COLUMS & id_colum > 0;};
  constraint valid_addrs_row {if(id_colum == 0 | id_colum == COLUMS+1) id_row <= ROWS & id_row > 0;};
  constraint valid_addrs_Driver {if(id_row != 0 & id_row != ROWS+1)id_colum == 0 | id_colum == COLUMS+1;};
  
  //constraint self_addrs {id != source;};        //Restriccion que no permite a un id igual al del dispositivo
  //Respecto al DATO
  //constraint data_variablility {dato inside {{(pckg_sz-18){1'b1}},{(pckg_sz-18){1'b0}}};};
  
  

  function new ();
    variability = pckg_sz - 18;
  endfunction;
  
endclass


class ag_chk #(parameter pckg_sz = 20);
  bit [pckg_sz-18:0] payload ;
  bit [3:0] row;
  bit [3:0] colum;
  bit mode;
  int transaction_time;
  int source;
  
  function new(bit [pckg_sz-1:0] info,bit [3:0] row, bit [3:0] col,int tiempo,int source);
    this.payload = info;
    this.row = row;
    this.colum = col;
    this.transaction_time = tiempo;
    this.source = source;
  endfunction
  
  function display();
    $display("El dato: %b se envió, en el tiempo %g", this.payload, this.transaction_time);
  endfunction 
  
endclass


class gen_chk;
  int cant_datos;
  function new ();
  endfunction;
endclass


///////////////////
////Mailboxes//////
///////////////////
typedef mailbox #(ag_chk) ag_chk_mbx ;
typedef mailbox #(ag_dr) ag_dr_mbx ;
typedef mailbox #(gen_ag) gen_ag_mbx ;
typedef mailbox #(mon_sb) mon_sb_mbx;
typedef mailbox #(tst_gen) tst_gen_mbx;
typedef mailbox #(tst_sb) tst_sb_mbx;
typedef mailbox #(gen_chk) gen_chk_mbx;

/////////////////////////////////////////////
//Set de variables para los casos de prueba//
/////////////////////////////////////////////
typedef enum {max_variabilidad, max_aleatoriedad} gen_ag_data_modo;
typedef enum {self_id, any_id, invalid_id, fix_source ,normal_id} gen_ag_id_modo;
typedef enum {bus_push, bus_pop} monitor_modo;
typedef enum {normal, broadcastt, one_to_all, all_to_one} Generador_modo;

//PROYECTO 2//
typedef enum {col_first,row_firts} mode;