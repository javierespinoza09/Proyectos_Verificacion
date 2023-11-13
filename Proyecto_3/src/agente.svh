//////////////////////////////////////////////////
//  Proyecto 3 Implementacion UVM               //
//  Seccion: UVM_Agente                         //
//  Desarrollado por: J. Espinoza y J. Mejia    //
//  Revisado por: R. Garcia                     //
//  2023                                        //
//////////////////////////////////////////////////

class agente extends uvm_agent;
  `uvm_component_utils(agente)
  
  driver driver_ag;
  string name;
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    driver_ag= driver ::type_id::create("driver",this);
  endfunction
endclass