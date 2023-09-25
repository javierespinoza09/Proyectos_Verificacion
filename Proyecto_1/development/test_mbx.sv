class transaction_chk_sb #(parameter packagesize = 16);
  bit [packagesize-1:0] payload ;
  //bit [7:0] id ;
  //int transaction_time;
  
  function new(bit [packagesize-1:0] info);
    this.payload = info;
    //this.id = destino;
    //this.transaction_time = tiempo;
  endfunction
  
  function display();
    $display("El dato: %b se recibió en el Device:", this.payload);
  endfunction 
  
endclass
  
