vlib work
vlog DSP.v MUX_FF.v DSP_tb.v
vsim -voptargs=+acc tb
add wave *
run -all
#quit -sim


