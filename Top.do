vlib work
vsim -voptargs=+acc work.Top_tb 
add wave -position insertpoint  \
sim:/Top_tb/brake_pedal \
sim:/Top_tb/brake_signal \
sim:/Top_tb/car_speed \
sim:/Top_tb/clk \
sim:/Top_tb/correct_count \
sim:/Top_tb/distance \
sim:/Top_tb/error_count \
sim:/Top_tb/rst \
sim:/Top_tb/time_out \
sim:/Top_tb/dut/can_inst/ACK_slot \
sim:/Top_tb/dut/abs_inst/ACK_slot \
sim:/Top_tb/GoldenModel/brake_signal_GM \
sim:/Top_tb/GoldenModel/time_taken_GM \
add wave /Top_tb/dut/assert__rst_holds_brake_low /Top_tb/dut/assert__brake_pedal_response /Top_tb/dut/assert__obstacle_close_response /Top_tb/dut/assert__no_danger_no_brake /Top_tb/dut/assert__ack_forwarding_active


run -all
