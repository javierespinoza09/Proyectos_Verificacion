///////////////////////////////////
///////Clases de los Mailbox///////
///////////////////////////////////


class rand_values_generate #(parameter pckg_sz = 20, parameter ROWS = 2, parameter COLUMS = 2);
  int target;
  rand bit [3:0] id_row;
  rand bit [3:0] id_colum; 
  randc int source;
  rand int burst_test;
  rand int burst_test_size;
  rand int general_test;
  constraint pos_source_addrs {source >= 0;};
  constraint source_addrs {source < COLUMS*2+ROWS*2;};
  constraint valid_addrs_col {if(id_row == 0 | id_row == ROWS+1)id_colum <= COLUMS & id_colum > 0;};
  constraint valid_addrs_row {if(id_colum == 0 | id_colum == COLUMS+1) id_row <= ROWS & id_row > 0;};
  constraint burst_test_size_c {burst_test_size > COLUMS*2+ROWS*2; burst_test_size < COLUMS*2+ROWS*2*2;};
  constraint burst_test_c {burst_test > 4; burst_test < 6;};
  constraint general_test_c {general_test > 75; general_test < 200;};
endclass

class tb_tst;
	int test;
	int mode;
	int tiempo;
	function new(int test, int mode);
		this.test = test;
		this.mode = mode;
		this.tiempo = $time;
	endfunction 
endclass

class tst_chk;
  int test;
  int mode;

  function new(int test, int mode);
		this.test = test;
		this.mode = mode;
	endfunction 
endclass


class tst_gen;
  int caso;
  bit [3:0] id_row;
  bit [3:0] id_colum;
  int source;
  int mode;
  int cant_datos;
  function new ();
  endfunction;
endclass


class gen_ag;
  int cant_datos;
  int data_modo;        
  int id_modo;
  int id_rand;
  int mode;
  bit [3:0] id_row;
  bit [3:0] id_colum;
  int source_rand;
  bit [3:0] source;
  //bit [3:0] source_row;
  //bit [3:0] source_colum;
  function new ();
  endfunction;
endclass

class mon_chk;
  bit [3:0] row;
  bit [3:0] colum;
  int payload;
  int receiver;
  int tiempo;
  int key;
  function new (int receiver);
	  this.receiver = receiver;
	  this.tiempo = $time;
  endfunction;
endclass

class r_c_mapping;
  int column;
  int row;
endclass

class ag_dr #(parameter pckg_sz = 20, parameter ROWS = 2, parameter COLUMS = 2);
  rand bit [pckg_sz-26:0] dato;
  rand bit [3:0] id_row;
  rand bit [3:0] id_colum;
  rand bit mode;
  rand int source;
  bit [7:0] Nxt_jump;
  rand int tiempo;
  int variability;
  int fix_source;
  r_c_mapping drv_map [COLUMS*2+ROWS*2];
  //Respecto al Source
  constraint pos_source_addrs {source >= 0;};  //**Restriccion necesaria
  constraint source_addrs {source < COLUMS*2+ROWS*2;};  //**Restriccion para asegurar que el paquete se dirige a un driver existente (necesaria)
  constraint self_r_c {id_row != drv_map[source].row; id_colum != drv_map[source].column;};
  //Respecto al ID
  constraint valid_addrs {id_row <= ROWS+1; id_row >= 0; id_colum <= COLUMS+1; id_colum >= 0;};       //Restriccion asegura que la direccion pertenece a un driver
  constraint send_to_itself {id_row == drv_map[source].row; id_colum == drv_map[source].column;};
  constraint valid_addrs_col {if(id_row == 0 | id_row == ROWS+1)id_colum <= COLUMS & id_colum > 0;};
  constraint valid_addrs_row {if(id_colum == 0 | id_colum == COLUMS+1) id_row <= ROWS & id_row > 0;};
  constraint valid_addrs_Driver {if(id_row != 0 & id_row != ROWS+1)id_colum == 0 | id_colum == COLUMS+1;};
  constraint mode1 {mode == 1;};
  constraint mode0 {mode == 0;};
  constraint delay {tiempo > 20; tiempo < 100;};
  
  //constraint self_addrs {id != source;};        //Restriccion que no permite a un id igual al del dispositivo
  //Respecto al DATO
  //constraint data_variablility {dato inside {{(pckg_sz-18){1'b1}},{(pckg_sz-18){1'b0}}};};
  
  

  function new ();
    variability = pckg_sz - 18;
  endfunction;
  
endclass


class drv_sb #(parameter pckg_sz = 20);
  bit [pckg_sz-1:0] paquete ;
  bit [3:0] row;
  bit [3:0] colum;
  bit mode;
  int transaction_time;
  int source;
  int path [5][5];
  int ruta [int];
  bit listo = 0;
  int jump = 0;
  
  function new(bit [pckg_sz-1:0] info,bit [3:0] row, bit [3:0] col,int tiempo);
    this.paquete = info;
    this.row = row;
    this.colum = col;
    this.transaction_time = tiempo;
  endfunction
  
endclass


class gen_chk;
  int cant_datos;
  function new ();
  endfunction;
endclass


class list_chk #(parameter pckg_sz = 40);
  int list_r;
  int list_c;
  bit [pckg_sz-9:0] data_out;
  int time_list;
  /*
  bit [3:0] trgt_r;
  bit [3:0] trgt_c;
  bit mode;
  bit [3:0] src_R;
  bit [3:0] src_C;
  bit [pck_sz-26:0] pyld
  */
  
  
  
  function new(int list_r, int list_c, [pckg_sz-1:0] data_out);
    this.list_r = list_r;
    this.list_c = list_c;
    this.data_out = data_out [pckg_sz-9:0];
    this.time_list = $time;
  endfunction
  
  
endclass

/*
class list_chk;
  //list_chk_mbx list_chk_mbx;
  list_chk list_chk_transaction;
  
  
  int id_c;
  int id_r;
  
  function new(int row, int col);
    this.id_c = col;
    this.id_r = row;
    //this.list_chk_mbx = new();
  endfunction
  
  task run();
    forever begin
      //wait(real_path[this.id_r][this.id_c].triggered);
      //list_chk_transaction = new(this.id_r, this.id_c);
      //list_chk_mbx.put(list_chk_transaction);
      $display("EVENTO [%0d][%0d]",this.id_r,this.id_c);
    end 
    
  endtask
endclass
*/

///////////////////
////Mailboxes//////
///////////////////
typedef mailbox #(drv_sb) drv_sb_mbx ;
typedef mailbox #(ag_dr) ag_dr_mbx ;
typedef mailbox #(gen_ag) gen_ag_mbx;
typedef mailbox #(mon_chk) mon_chk_mbx;
typedef mailbox #(tst_gen) tst_gen_mbx;
typedef mailbox #(tst_chk) tst_chk_mbx;
typedef mailbox #(gen_chk) gen_chk_mbx;
typedef mailbox #(list_chk) list_chk_mbx;
typedef mailbox #(drv_sb) sb_chk_mbx ;
typedef mailbox #(tb_tst) tb_tst_mbx;

/////////////////////////////////////////////
//Set de variables para los casos de prueba//
/////////////////////////////////////////////
typedef enum {max_variabilidad, max_aleatoriedad} gen_ag_data_modo;
typedef enum {self_id, any_id, invalid_id, fix_source ,normal_id,send_to_itself} gen_ag_id_modo;
typedef enum {bus_push, bus_pop} monitor_modo;
typedef enum {normal, broadcastt, one_to_all, all_to_one, any,
       		itself, all_to_one_itself, one_to_all_itself} Generador_modo;
typedef enum {source_burst, id_burst, even_source_load, even_id_load, itself_messages, normal_test} Tests;

//PROYECTO 2//
typedef enum {col_first,row_firts} mode;
typedef enum {random, mode_1, mode_0} gen_ag_mode;
//////////
//MACROS//
//////////

`define mapping(ROWS, COLUMS) \
               for (int i = 0; i<COLUMS;i++)begin \
                  drv_map[i].row = 0;              \
                  drv_map[i].column = i+1; \
                end \
                for (int i = 0; i<ROWS;i++)begin \
                  drv_map[i+COLUMS].column = 0; \
                  drv_map[i+COLUMS].row = i+1; \
                end \
                for (int i = 0; i<COLUMS;i++)begin \
                  drv_map[i+ROWS*2].row = ROWS+1; \
                  drv_map[i+ROWS*2].column = i+1; \
                end \
                for (int i = 0; i<ROWS;i++)begin \
                  drv_map[i+COLUMS*3].column = COLUMS+1; \
                  drv_map[i+COLUMS*3].row = i+1; \
                end 

`define test_case(test,mode) \
	tb_tst_transaction = new(test, mode);	\
        tb_tst_mbx.put(tb_tst_transaction);	
 



