//////////////////////////////////////////////////
//  Proyecto 3 Implementacion UVM               //
//  Seccion: UVM_Driver                         //
//  Desarrollado por: J. Espinoza y J. Mejia    //
//  Revisado por: R. Garcia                     //
//  2023                                        //
//////////////////////////////////////////////////

class driver extends uvm_driver;
  
  `uvm_component_utils(driver)
  
  virtual router_if v_if;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual router_if)::get(this, "", "v_if", v_if)) begin
      `uvm_error("","uvm_config_db::get failed")
    end
  endfunction
  
  
  task run_phase(uvm_phase phase);
    v_if.reset = 1;
    phase.raise_objection(this);
    @(posedge v_if.clk);
    #20;
    v_if.reset = 0;
    #10;
    `uvm_warning("Se hizo el reinicio en driver!",get_type_name())
    phase.drop_objection(this);
  endtask
  
  
endclass: driver