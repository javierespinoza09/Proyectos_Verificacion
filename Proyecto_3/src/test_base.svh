//////////////////////////////////////////////////
//  Proyecto 3 Implementacion UVM               //
//  Seccion: UVM_Test                           //
//  Desarrollado por: J. Espinoza y J. Mejia    //
//  Revisado por: R. Garcia                     //
//  2023                                        //
//////////////////////////////////////////////////

class test_base extends uvm_test;
    `uvm_component_utils(test_base)
    parameter COLUMS = 4;
    parameter ROWS = 4;
    parameter pckg_sz = 40;
    int id_modo;

  function new(string name = "test_base", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    ambiente a0;
    gen_sequence_item sec [ROWS*2+COLUMS*2];
    virtual router_if v_if;

    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);
        a0 = ambiente::type_id::create("a0", this);

        if(!uvm_config_db#(virtual router_if)::get(this, "", "v_if", v_if)) begin
            `uvm_error("","uvm_config_db::get failed")
        end

        uvm_config_db#(virtual router_if)::set(this, "a0.agente0.*", "router_if", v_if);
        uvm_config_db#(int)::set(this, "*", "COLUMS_param", COLUMS);
        uvm_config_db#(int)::set(this, "*", "ROWS_param", ROWS);
        uvm_config_db#(int)::set(this, "*", "pckg_sz_param", pckg_sz);



        for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
        automatic int k = i;
		sec[k] = gen_sequence_item::type_id::create($sformatf("sec_num%0d",k),this);
            sec[k].cant_datos = 2;
            sec[k].data_modo = 0;
            sec[k].id_modo = normal_id;
            sec[k].id_rand = 1;
            sec[k].mode  = random;
            sec[k].id_row = 0;
            sec[k].id_colum = 0;
            sec[k].source_rand = 0;
            sec[k].source = k;

        end

    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        apply_reset();

        for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
        automatic int k = i;
            sec[k].start(a0.agente0.secuencer[k]);
        end

        #1000
        phase.drop_objection(this);
    endtask


    virtual task apply_reset();
        v_if.reset = 1;
        @(posedge v_if.clk);
        #2000;
        v_if.reset = 0;
        #10;
        `uvm_warning("Se hizo el reinicio en driver!",get_type_name())
    endtask

endclass
