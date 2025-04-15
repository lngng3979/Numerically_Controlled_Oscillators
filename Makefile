tb.exe: *.v
	iverilog -D PERIOD=10 -D CLK_DELAY=0.01 -g2005-sv -f verilog.f -o tb.exe
counter.vcd: tb.exe
	./tb.exe
debug:
	gtkwave counter.vcd
clean: 
	rm -rf counter.vcd tb.exe
viewwaveform: tb.exe counter.vcd debug

synthesis :
	openlane --dockerized initial.json --to Yosys.Synthesis

gds: 
	openlane --dockerized initial.json 
viewlayout:
	openlane --dockerized initial.json --last-run --flow openinopenroad

