for row in range(1, 5):
    for col in range(1, 5):
        for terminal in range(4):
            print(f"begin")
            print(f"    forever begin")
            print(f"        @(posedge router_tb.DUT._rw_[{row}]._clm_[{col}].rtr._nu_[{terminal}].rtr_ntrfs_.pop);")
            print(f"        // Aquí colocar las acciones que deseas realizar cuando ocurra el flanco de subida")
            print(f"    end")
            print(f"end")

