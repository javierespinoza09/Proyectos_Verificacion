
//////////////////////////////////////////////////
//  Proyecto 3 Implementacion UVM               //
//  Seccion: UVM_Monitor                        //
//  Desarrollado por: J. Espinoza y J. Mejia    //
//  Revisado por: R. Garcia                     //
//  2023                                        //
//////////////////////////////////////////////////

class monitor extends uvm_monitor;
  
  import uvm_pkg::*;
  
    `uvm_component_utils(monitor);
  
    uvm_analysis_port #(mon_sb) mon_sb_analysis_port;
    parameter COLUMS = 4;
    parameter ROWS = 4;
  	parameter pckg_sz = 40;

    mon_sb mon_sb;
  
    int mnt_num;
    bit [3:0] self_row;
    bit [3:0] self_col;
    bit [pckg_sz-1:0] paquete;
    bit [pckg_sz-1:0] d_q[$];
    bit modo;
    int dato;
  
  virtual router_if v_if;
  
  function new (string name, uvm_component parent);
    super.new(name,parent);
    mon_sb_analysis_port=new("mon_sb_analysis_port",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual router_if)::get(this,"","v_if",v_if))begin
      `uvm_error("","uvm_config_db::get failed monitor")
    end
  endfunction
  
  task run_phase(uvm_phase phase);
    v_if.pop[mnt_num]=0;
    
    phase.raise_objection(this);

    forever begin
      @(posedge v_if.clk);
   
        if (v_if.pndng[mnt_num]==1) begin
            v_if.pop[this.mnt_num] = 1;
            d_q.push_back(this.v_if.data_out[this.mnt_num]);
            mon_sb = mon_sb::type_id::create("mon_sb");
            mon_sb.row = this.v_if.data_out[this.mnt_num][pckg_sz-9:pckg_sz-12];
            mon_sb.colum = this.v_if.data_out[this.mnt_num][pckg_sz-13:pckg_sz-16];
            mon_sb.payload = this.v_if.data_out[this.mnt_num][pckg_sz-18:0];
            mon_sb.receiver = mnt_num;
            mon_sb.key = this.v_if.data_out[this.mnt_num][pckg_sz-1:0];
            mon_sb.tiempo = $time;
            mon_sb_analysis_port.write (mon_sb);
            
            @(posedge this.v_if.clk);
            this.v_if.pop[mnt_num] = 0;
        end
    end
    
    phase.drop_objection(this);// para terminar
    
  endtask
    
endclass: monitor