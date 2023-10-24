class listener;
	int t;
	int row;
	int column;

	virtual router_if v_if;

	task run();
		fork	
			begin
				forever begin 
					@(posedge router_tb.DUT._rw_[4]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop);
					$display("POP t:%d r:%d c:%d", 0, 4, 2,$time);
			end 
			end
			begin
                forever begin
                    @(posedge router_tb.DUT._rw_[1]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop);
                    $display("POP t:%d r:%d c:%d", 3, 1, 2,$time);
                end
            end


		join_none
	endtask






endclass
