onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fused_mul_opt

do {wave.do}

view wave
view structure
view signals

do {fused_mul.udo}

run -all

quit -force
