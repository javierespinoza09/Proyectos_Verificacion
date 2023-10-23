for r in range(1, 5):
    for c in range(1, 5):
        for t in range(4):
            code_line_data_out = f"signals_if.data_out[{r}][{c}][{t}] = DUT._rw_[{r}]._clm_[{c}].rtr._nu_[{t}].rtr_ntrfs_.data_out \\"
            code_line_pop = f"signals_if.pop[{r}][{c}][{t}] = DUT._rw_[{r}]._clm_[{c}].rtr._nu_[{t}].rtr_ntrfs_.pop \\"
            print(code_line_data_out)
            print(code_line_pop)

