class drv_item extends uvm_sequence_item;
    `uvm_object_utils(drv_item)
    rand bit [pckg_sz-26:0] dato;
    rand bit [3:0] id_row;
    rand bit [3:0] id_colum;
    rand bit mode;
    int source;
    bit [7:0] Nxt_jump;
    rand int tiempo;
    int variability;
    int fix_source;
    r_c_mapping drv_map [COLUMS*2+ROWS*2];
    //Respecto al Source
    //constraint pos_source_addrs {source >= 0;};  //**Restriccion necesaria
    //constraint source_addrs {source < COLUMS*2+ROWS*2;};  //**Restriccion para asegurar que el paquete se dirige a un driver existente (necesaria)
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

    function new(string name = "drv_item");
        super.new(name);
    endfunction


endclass