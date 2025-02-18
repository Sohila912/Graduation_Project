vlib work
vlog OD_Distance_tb.sv OD_Distance.sv +cover -covercells
vsim -voptargs=+acc work.OD_Distance_tb -cover
add wave *
add wave /OD_Distance_tb/u1/state_rst_a /OD_Distance_tb/u1/output_rst_a /OD_Distance_tb/u1/output_a /OD_Distance_tb/u1/assert__timeout_a /OD_Distance_tb/u1/assert__distance_a /OD_Distance_tb/u1/assert__distance_a2

#coverage save OD_Time_tb.ucdb -onexit
run -all