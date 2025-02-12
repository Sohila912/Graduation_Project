vlib work
vlog *v +cover -covercells
vsim -voptargs=+acc work.OD_Time_tb -cover
add wave *
add wave -position insertpoint  \
sim:/OD_Time_tb/u1/cs \
sim:/OD_Time_tb/u1/ns
#coverage save OD_Time_tb.ucdb -onexit
run -all
