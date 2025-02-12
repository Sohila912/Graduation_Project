vlib work
vlog *v +cover -covercells
vsim -voptargs=+acc work.Main_tb -cover
add wave -position insertpoint  \
sim:/Main_tb/clk \
sim:/Main_tb/echo_pulse \
sim:/Main_tb/Object_detected \
sim:/Main_tb/rst \
sim:/Main_tb/speed
run -all
