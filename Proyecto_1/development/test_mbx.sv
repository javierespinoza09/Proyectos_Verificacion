class transaction_chk_sb #(parameter packagesize = 16);
  int payload [packagesize-9:0];
  int id [7:0];
  int transaction_time;
  
  function new(int info [packagesize-9:0], int destino [7:0],int tiempo);
    this.payload = info;
    this.id = destino;
    this.transaction_time = tiempo;
  endfunction
  
endclass