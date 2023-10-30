`include "driver.sv"
`include "Monitor.sv"
`include "Agente.sv" 
`include "listener.sv"
`include "scoreboard.sv"
`include "checker.sv"
`include "Generador.sv"
class Ambiente  #(parameter Drivers = 4, parameter pckg_sz = 40, 
                parameter fifo_size = 4, parameter ROWS = 2, 
                parameter COLUMS = 2);

    ////////////////////////////////
    ////////Module instances////////
    ////////////////////////////////

    Driver #(.drvrs(Drivers), .pckg_sz(pckg_sz), .fifo_size(fifo_size), .ROWS(ROWS), .COLUMS(COLUMS)) driver [ROWS*2+COLUMS*2];
    Monitor #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz), .fifo_size(fifo_size)) monitor [Drivers];
    Agente #(.drvrs(Drivers), .pckg_sz(pckg_sz), .fifo_size(fifo_size), .ROWS(ROWS), .COLUMS(COLUMS)) agente;
    listener listener;
    scoreboard #(.pckg_sz(pckg_sz)) sb;
  _checker #(.pckg_sz(pckg_sz),.fifo_size(fifo_size)) chk;
    Generador #(.drvrs(Drivers), .pckg_sz(pckg_sz)) generador; 

    /////////////////////////
    ////Mailbox instances////
    /////////////////////////
    ag_dr_mbx #(.pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS)) ag_dr_mbx [Drivers];
    
    //Manejador de arreglo mailbox Agente-Driver
    gen_ag_mbx gen_ag_mbx;
    
	tst_gen_mbx tst_gen_mbx;
	//tst_chk_mbx tst_chk_mbx;
    //Instancia de mailbox Generador-Agente
    list_chk_mbx list_chk_mbx;
    //Instancia de mailbox Listener-Checker
    drv_sb_mbx #(.pckg_sz(pckg_sz)) drv_sb_mbx;
    //Instancia de mailbox Driver-Scoreborad
    sb_chk_mbx #(.pckg_sz(pckg_sz)) sb_chk_mbx;
    //Instacia de mailbox Scoreboard-Checker
    mon_chk_mbx mon_chk_mbx;
    //Instancia de mailbox Monitor-Checker

    function new();

        tst_gen_mbx = new();
        gen_ag_mbx = new();
        list_chk_mbx = new();
        drv_sb_mbx = new();
        sb_chk_mbx = new();
        mon_chk_mbx = new();
      	//tst_chk_mbx = new();
        for(int i = 0; i < COLUMS*2+ROWS*2; i++) begin
            automatic int k = i;
            ag_dr_mbx[k] = new();
        end

        agente = new();
        agente.gen_ag_mbx = gen_ag_mbx;

        generador = new();
        generador.gen_ag_mbx = gen_ag_mbx;
	

        chk = new();
        chk.sb_chk_mbx =sb_chk_mbx;
        chk.mon_chk_mbx = mon_chk_mbx;
      	chk.list_chk_mbx = list_chk_mbx;
      	//chk.tst_chk_mbx = tst_chk_mbx;

        sb = new();
        sb.drv_sb_mbx=drv_sb_mbx;
        sb.sb_chk_mbx = sb_chk_mbx;

        listener=new();
        listener.list_chk_mbx = list_chk_mbx;

        for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
            automatic int k = i;
            driver[k] = new(k);
            driver[k].ag_dr_mbx = ag_dr_mbx[k];
            driver[k].drv_sb_mbx = drv_sb_mbx;
            monitor[k] = new(k);
            monitor[k].mon_chk_mbx = mon_chk_mbx;
            agente.ag_dr_mbx_array[k] = ag_dr_mbx[k];         
        end

        /////////////////////////////////////////////////////////
        ////Mapeo de Driver a su correspondiente Fila-Columna////
        /////////////////////////////////////////////////////////
        for (int i = 0; i<COLUMS;i++)begin
            driver[i].self_row = 0;
            driver[i].self_col = i+1;
        end
        for (int i = 0; i<ROWS;i++)begin
            driver[i+COLUMS].self_col = 0;
            driver[i+COLUMS].self_row = i+1;
        end
        for (int i = 0; i<COLUMS;i++)begin
            driver[i+ROWS*2].self_row = ROWS+1;
            driver[i+ROWS*2].self_col = i+1;
        end
        for (int i = 0; i<ROWS;i++)begin
            driver[i+COLUMS*3].self_col = COLUMS+1;
            driver[i+COLUMS*3].self_row = i+1;
        end

    endfunction


    task run();
        fork
	    generador.run();
            agente.run();
            listener.run();
            sb.run();
            chk.run_sc();
            chk.run_mon();
          	chk.listeners();
          	//chk.tst();
            for(int i = 0; i<COLUMS*2+ROWS*2; i++ ) begin
            fork
            automatic int k = i;
                driver[k].run();
                monitor[k].run();
            join_none
            end
        join_none
    endtask

    task report();
        chk.report();
      	$display("//////////////////////////////////FIN DEL REPORTE/////////////////////////////////////");
      	//#100;
        chk.clean();
      	

    endtask






endclass 
