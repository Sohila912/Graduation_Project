vlib work
vlog ABS_tb.sv ABS.sv +cover -covercells
vsim -voptargs=+acc work.ABS_Controller_tb -cover
add wave *
add wave -position insertpoint  \
sim:/ABS_Controller_tb/dut/cs \
sim:/ABS_Controller_tb/dut/ns \
sim:/ABS_Controller_tb/dut/auto_brake
add wave /ABS_Controller_tb/dut/state_rst_a /ABS_Controller_tb/dut/output_rst_a 
add wave /ABS_Controller_tb/dut/assert__IDLE_a
add wave /ABS_Controller_tb/dut/assert__BRAKE_a /ABS_Controller_tb/dut/assert__LOCK_a
add wave /ABS_Controller_tb/dut/brake_a /ABS_Controller_tb/dut/No_brake_a
#coverage save OD_Time_tb.ucdb -onexit
run -all