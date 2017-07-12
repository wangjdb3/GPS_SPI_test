vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../GPS_test.srcs/sources_1/ip/fifo/sim/fifo.v" \


vlog -work xil_defaultlib \
"glbl.v"

