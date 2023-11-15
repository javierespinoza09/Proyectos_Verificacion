//////////////////////////////////////////////////
//  Proyecto 3 Implementacion UVM               //
//  Seccion: UVM_Agente                         //
//  Desarrollado por: J. Espinoza y J. Mejia    //
//  Revisado por: R. Garcia                     //
//  2023                                        //
//////////////////////////////////////////////////

class agente extends uvm_agent;
  parameter COLUMS = 4;
  parameter ROWS = 4;
  `uvm_component_utils(agente)
  
  driver driver_ag [ROWS*2+COLUMS*2];
  uvm_sequencer #(drv_item) secuencer [ROWS*2+COLUMS*2];
  string name;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
      automatic int k = i;
      driver_ag [k] = driver ::type_id::create("driver",this);
    end
    for (int i = 0; i<COLUMS;i++)begin
            driver_ag[i].self_row = 0;
            driver_ag[i].self_col = i+1;
          	//monitor[i].self_row = 0;
            //monitor[i].self_col = i+1;
        end
        for (int i = 0; i<ROWS;i++)begin
            driver_ag[i+COLUMS].self_col = 0;
            driver_ag[i+COLUMS].self_row = i+1;
          	//monitor[i+COLUMS].self_col = 0;
            //monitor[i+COLUMS].self_row = i+1;
        end
        for (int i = 0; i<COLUMS;i++)begin
            driver_ag[i+ROWS*2].self_row = ROWS+1;
            driver_ag[i+ROWS*2].self_col = i+1;
          	//monitor[i+ROWS*2].self_row = ROWS+1;
            //monitor[i+ROWS*2].self_col = i+1;
        end
        for (int i = 0; i<ROWS;i++)begin
            driver_ag[i+COLUMS*3].self_col = COLUMS+1;
            driver_ag[i+COLUMS*3].self_row = i+1;
          	//monitor[i+COLUMS*3].self_col = COLUMS+1;
            //monitor[i+COLUMS*3].self_row = i+1;
        end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
      automatic int k = i;
      driver_ag[k].seq_item_port.connect(secuencer[k]);
    end
  endfunction

endclass