
/////////////////////////////////////////////////////////////////////////////////
////Clase que funciona como puntos de prueba en las terminales del Router////////
////Evalua en el flanco del pop el dato de salida y se lo comunica el checker////
/////////////////////////////////////////////////////////////////////////////////
class listener;
	int t;
	int row;
	int column;
  	list_chk_mbx list_chk_mbx;
    list_chk     transaction;

	virtual router_if v_if;

	task run();
		fork	
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(1,1,router_tb.DUT._rw_[1]._clm_[1].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(1,1,router_tb.DUT._rw_[1]._clm_[1].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(1,1,router_tb.DUT._rw_[1]._clm_[1].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(1,1,router_tb.DUT._rw_[1]._clm_[1].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(1,2,router_tb.DUT._rw_[1]._clm_[2].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(1,2,router_tb.DUT._rw_[1]._clm_[2].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(1,2,router_tb.DUT._rw_[1]._clm_[2].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(1,2,router_tb.DUT._rw_[1]._clm_[2].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(1,3,router_tb.DUT._rw_[1]._clm_[3].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(1,3,router_tb.DUT._rw_[1]._clm_[3].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(1,3,router_tb.DUT._rw_[1]._clm_[3].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(1,3,router_tb.DUT._rw_[1]._clm_[3].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(1,4,router_tb.DUT._rw_[1]._clm_[4].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(1,4,router_tb.DUT._rw_[1]._clm_[4].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(1,4,router_tb.DUT._rw_[1]._clm_[4].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(1,4,router_tb.DUT._rw_[1]._clm_[4].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(2,1,router_tb.DUT._rw_[2]._clm_[1].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(2,1,router_tb.DUT._rw_[2]._clm_[1].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(2,1,router_tb.DUT._rw_[2]._clm_[1].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(2,1,router_tb.DUT._rw_[2]._clm_[1].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(2,2,router_tb.DUT._rw_[2]._clm_[2].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(2,2,router_tb.DUT._rw_[2]._clm_[2].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(2,2,router_tb.DUT._rw_[2]._clm_[2].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(2,2,router_tb.DUT._rw_[2]._clm_[2].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(2,3,router_tb.DUT._rw_[2]._clm_[3].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(2,3,router_tb.DUT._rw_[2]._clm_[3].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(2,3,router_tb.DUT._rw_[2]._clm_[3].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(2,3,router_tb.DUT._rw_[2]._clm_[3].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(2,4,router_tb.DUT._rw_[2]._clm_[4].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(2,4,router_tb.DUT._rw_[2]._clm_[4].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(2,4,router_tb.DUT._rw_[2]._clm_[4].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[2]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(2,4,router_tb.DUT._rw_[2]._clm_[4].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(3,1,router_tb.DUT._rw_[3]._clm_[1].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(3,1,router_tb.DUT._rw_[3]._clm_[1].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(3,1,router_tb.DUT._rw_[3]._clm_[1].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(3,1,router_tb.DUT._rw_[3]._clm_[1].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(3,2,router_tb.DUT._rw_[3]._clm_[2].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(3,2,router_tb.DUT._rw_[3]._clm_[2].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(3,2,router_tb.DUT._rw_[3]._clm_[2].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(3,2,router_tb.DUT._rw_[3]._clm_[2].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(3,3,router_tb.DUT._rw_[3]._clm_[3].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(3,3,router_tb.DUT._rw_[3]._clm_[3].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(3,3,router_tb.DUT._rw_[3]._clm_[3].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(3,3,router_tb.DUT._rw_[3]._clm_[3].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(3,4,router_tb.DUT._rw_[3]._clm_[4].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(3,4,router_tb.DUT._rw_[3]._clm_[4].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(3,4,router_tb.DUT._rw_[3]._clm_[4].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[3]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(3,4,router_tb.DUT._rw_[3]._clm_[4].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(4,1,router_tb.DUT._rw_[4]._clm_[1].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(4,1,router_tb.DUT._rw_[4]._clm_[1].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(4,1,router_tb.DUT._rw_[4]._clm_[1].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(4,1,router_tb.DUT._rw_[4]._clm_[1].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(4,2,router_tb.DUT._rw_[4]._clm_[2].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(4,2,router_tb.DUT._rw_[4]._clm_[2].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(4,2,router_tb.DUT._rw_[4]._clm_[2].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(4,2,router_tb.DUT._rw_[4]._clm_[2].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(4,3,router_tb.DUT._rw_[4]._clm_[3].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(4,3,router_tb.DUT._rw_[4]._clm_[3].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(4,3,router_tb.DUT._rw_[4]._clm_[3].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(4,3,router_tb.DUT._rw_[4]._clm_[3].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop);
                    transaction=new(4,4,router_tb.DUT._rw_[4]._clm_[4].rtr._nu_[0].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop);
                    transaction=new(4,4,router_tb.DUT._rw_[4]._clm_[4].rtr._nu_[1].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop);
                    transaction=new(4,4,router_tb.DUT._rw_[4]._clm_[4].rtr._nu_[2].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
            begin
                forever begin
                    @(posedge router_tb.DUT._rw_[4]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop);
                    transaction=new(4,4,router_tb.DUT._rw_[4]._clm_[4].rtr._nu_[3].rtr_ntrfs_.data_out);
                    list_chk_mbx.put(transaction);
                    // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida
                end
            end
          
		join_none
	endtask






endclass
