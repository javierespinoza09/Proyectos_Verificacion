class test_base extends uvm_test;
    `uvm_component_utils(test_base)
    parameter COLUMS = 4;
    parameter ROWS = 4;

    function new(string name = "test_base", uvm_component parent = null)
        super.new(name, parent);
    endfunction


    ambiente a0;
    gen_sequence_item sec [ROWS*2+COLUMS*2];
    virtual router_if v_if;

    virtual function build_phase(uvm_phase phase);
        super.build_phase(phase);

        a0 = ambiente::type_id::create("a0", this);

        if(!uvm_config_db#(virtual router_if)::get(this, "", "v_if", v_if)) begin
            `uvm_error("","uvm_config_db::get failed")
        end

        uvm_config_db#(virtual router_if)::set(this, "a0.agente0.*", "router_if", v_if);
        uvm_config_db#(int)::set(this, "*", "COLUMS_param", COLUMS);
        uvm_config_db#(int)::set(this, "*", "ROWS_param", ROWS);

    endfunction

endclass