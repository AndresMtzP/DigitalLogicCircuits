gui_open_window Wave
gui_sg_create SuperCoolClk_group
gui_list_add_group -id Wave.1 {SuperCoolClk_group}
gui_sg_addsignal -group SuperCoolClk_group {SuperCoolClk_tb.test_phase}
gui_set_radix -radix {ascii} -signals {SuperCoolClk_tb.test_phase}
gui_sg_addsignal -group SuperCoolClk_group {{Input_clocks}} -divider
gui_sg_addsignal -group SuperCoolClk_group {SuperCoolClk_tb.CLK_IN1}
gui_sg_addsignal -group SuperCoolClk_group {{Output_clocks}} -divider
gui_sg_addsignal -group SuperCoolClk_group {SuperCoolClk_tb.dut.clk}
gui_list_expand -id Wave.1 SuperCoolClk_tb.dut.clk
gui_sg_addsignal -group SuperCoolClk_group {{Status_control}} -divider
gui_sg_addsignal -group SuperCoolClk_group {SuperCoolClk_tb.RESET}
gui_sg_addsignal -group SuperCoolClk_group {{Counters}} -divider
gui_sg_addsignal -group SuperCoolClk_group {SuperCoolClk_tb.COUNT}
gui_sg_addsignal -group SuperCoolClk_group {SuperCoolClk_tb.dut.counter}
gui_list_expand -id Wave.1 SuperCoolClk_tb.dut.counter
gui_zoom -window Wave.1 -full
