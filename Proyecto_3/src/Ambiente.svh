//////////////////////////////////////////////////
//  Proyecto 3 Implementacion UVM               //
//  Seccion: UVM_Enviroment                     //
//  Desarrollado por: J. Espinoza y J. Mejia    //
//  Revisado por: R. Garcia                     //
//  2023                                        //
//////////////////////////////////////////////////

class ambiente extends uvm_env;
    `uvm_component_utils(ambiente);

    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction

    agente agente0;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agente0 = agente::type_id::create("agente0",this);
    endfunction

endclass
