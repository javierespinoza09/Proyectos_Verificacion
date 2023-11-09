`include "Router_library.sv"
`include "router_if.svh"
`include "if.svh"

package test;
import uvm_pkg::*;

`include "driver.svh"

//clase agente
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

//clase ambiente

class ambiente extends uvm_env;
  
  `uvm_component_utils(ambiente);
  
  agente agente_env;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    agente_env = agente::type_id::create("agente",this);
  endfunction
  
endclass


class test extends uvm_test;
  `uvm_component_utils(test)
  
  ambiente ambiente_tst;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    
  endfunction
  
  function void build_phase(uvm_phase phase);
    ambiente_tst = ambiente::type_id::create("ambiente",this);
  endfunction
  
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #10;
    `uvm_warning("", "Inicio del Test!")
    phase.drop_objection(this);
  endtask
  
  
endclass


endpackage