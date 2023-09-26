//Clases de los Mailbox
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
/////