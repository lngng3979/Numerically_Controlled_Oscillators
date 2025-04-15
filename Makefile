tb.exe:*.v
	iverilog -D PERIOD=10 -D CLK_DELAY=0.01 -g2005-sv -f verilog.f -o tb.exe
