///////////////////////////////////
///////Clases de los Mailbox///////
///////////////////////////////////

//clases aún no usadas//
class tst_gen;
  int caso;
  function new ();
  endfunction;
endclass


class tst_chk_sb;
  int reporte;
  int retardo;
  int miss_hit;
  function new ();
  endfunction;
endclass

class gen_ag;
  int cant_datos;
  int modo;
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
  function new ();
  endfunction;
endclass

//clases en uso//

class ag_dr #(parameter packagesize = 16);
  bit [packagesize:0] dato;
  int tiempo;
  function new (bit [packagesize:0] dato, int tiempo);
    this.dato = dato;
    this.tiempo = tiempo;
  endfunction;
  
  function void print(string tag = "");
    $display("[%g] %s Tiempo=%g dato=%b",$time,tag,this.tiempo,this.dato);
  endfunction 
  
endclass


class ag_chk_sb #(parameter packagesize = 16);
  bit [packagesize-9:0] payload ;
  bit [7:0] id ;
  int transaction_time;
  
  function new(bit [packagesize-1:0] info, [7:0] destino, tiempo);
    this.payload = info;
    this.id = destino;
    this.transaction_time = tiempo;
  endfunction
  
  function display();
    $display("El dato: %b se envió, en el tiempo %g", this.payload, this.transaction_time);
  endfunction 
  
endclass






////Mailboxes//////
typedef mailbox #(ag_chk_sb) ag_chk_sb_mbx ;
typedef mailbox #(ag_dr) ag_dr_mbx;
/////