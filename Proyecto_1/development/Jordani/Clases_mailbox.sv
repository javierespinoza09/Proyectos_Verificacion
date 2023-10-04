///////////////////////////////////
///////Clases de los Mailbox///////
///////////////////////////////////

//clases aún no usadas//



class tst_chk_sb;
  int reporte;
  int retardo;
  int miss_hit;
  function new ();
  endfunction;
endclass

//clases en uso//

class tst_gen;
  int caso;
  function new ();
  endfunction;
endclass


class gen_ag;
  int cant_datos;
  int data_modo;         //Seleccionar los constraints de los datos rand
  int id_modo;
  int id_rand;
  int id;
  int source_rand;
  int source;
  function new ();
  endfunction;
endclass

class mon_chk_sb;
  int id;
  int payload;
  int receiver;
  int tiempo;
  function new (int receiver);
	  this.receiver = receiver;
	  this.tiempo = $time;
  endfunction;
endclass


class ag_dr #(parameter drvrs = 4, parameter pckg_sz = 16);
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
  
  //constraint fixed_source {source == fix_source;};
  
  

  function new ();   //int driver, int tiempo);
    //this.tiempo = tiempo;
    //this.source = driver;
    variability = pckg_sz - 9;
    $display("Se inicializa la clase ag_dr");
  endfunction;
  
  function void print(string tag = "");
    $display("[%g] %s Tiempo=%g dato=%b",$time,tag,this.tiempo,this.dato);
  endfunction 
  
endclass


class ag_chk_sb #(parameter packagesize = 16);
  bit [packagesize-9:0] payload ;
  bit [7:0] id ;
  int transaction_time;
  int source;
  
  function new(bit [packagesize-1:0] info, [7:0] destino, tiempo, source);
    this.payload = info;
    this.id = destino;
    this.transaction_time = tiempo;
    this.source = source;
  endfunction
  
  function display();
    $display("El dato: %b se envió, en el tiempo %g", this.payload, this.transaction_time);
  endfunction 
  
endclass



////Mailboxes//////
 
typedef mailbox #(ag_chk_sb) ag_chk_sb_mbx ;
typedef mailbox #(ag_dr) ag_dr_mbx ;
typedef mailbox #(gen_ag) gen_ag_mbx ;
typedef mailbox #(mon_chk_sb) mon_chk_sb_mbx;
typedef mailbox #(tst_gen) tst_gen_mbx;


////
typedef enum {max_variabilidad, max_aleatoriedad} gen_ag_data_modo;
typedef enum {self_id, any_id, invalid_id, fix_source ,normal_id} gen_ag_id_modo;
typedef enum {bus_push, bus_pop} monitor_modo;
typedef enum {normal, broadcast, one_to_all, all_to_one, rand_payload} Generador_modo;