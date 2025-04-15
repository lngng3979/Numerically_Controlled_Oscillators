`timescale 1ns/1ps
//`define PERIOD 20
module tb (
	//input clk,
	//input reset,
);
	reg clk, reset, preload, enable, updn;
	reg [7:0] pl_data;
	reg [3:0] incr;
	wire [7:0] cout;
	wire clk_delay;
	reg [31:0] value;
	/*
	reg [31:0] table_ [0:255];

	initial
		for (integer i=0; i<256; i=i+1) begin
		        table_[i] = $sin(i*$acos(-1)/128.0) * (2**31-1);
			$display("assign table_[%3d] = 32'H%h;", i, table_[i]);
		end
	*/


	reg csb00, csb10, web0;
	reg [3:0] wmask0;
	reg [7:0] addr0;
	reg [31:0] din0;

	task init_mem();
		for (integer i=0; i<256; i=i+1) begin
			value = $sin(i*$acos(-1)/128.0) * ((2**31)-1);
			addr0 = i;
			web0 = 0;
			wmask0 = 4'hF;
			din0 = value;
			//$display("i: %3d; value: %32h", i, value);
			if (i<128)
				csb00 = 1'b0;
			else
				csb10 = 1'b0;
			waitforclk(1);
			csb00 = 1'b1;
			csb10 = 1'b1;
		end
	endtask

	initial begin
		csb00 = 1'b1;
		csb10 = 1'b1;
		web0 = 1'b1;
		wmask0 = 4'h0;
		addr0 = 0;
		din0 = 0;
	end

	assign #(`CLK_DELAY) clk_delay = clk;

	initial begin
		clk = 0;
		forever
			#(`PERIOD/2) clk = ~clk;
	end

	task waitforclk (input integer n);
		repeat (n)
			@(posedge clk_delay);
	endtask

	task preload_ (input [3:0] n);
	begin
		preload = 1;
		pl_data = n;
		@(posedge clk_delay);
		preload = 0;
	end
	endtask

	task stopforclk (input integer n);
	begin
		enable = 0;
		repeat (n)
			@(posedge clk_delay);
		enable = 1;
	end
	endtask

	counter dut (
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.updn(updn),
		.preload(preload),
		.pl_data(pl_data),
		.incr(incr),
		//.table_(table_),

		.csb00(csb00),
		.csb10(csb10),
		.web0(web0),
		.wmask0(wmask0),
		.addr0(addr0),
		.din0(din0),

		.cout(cout)
	);

	//initial $display("Hello world\n");
	
	// adjusting : real ratio ;
/*	
	function [31:0] sinef;
		input integer  fd;	
		input integer  max;
		input integer  offset;
		integer [7:0] value;
		begin 
			angle = 0 ;
		repeat (256) 
		 	if ( angle < max) begin 
			value = $sin(2*(2.0/3)*(angle)*($acos(-1)/256)*($pow(2,31)-1);
		end
			else value = 0;
			if (angle < 256) begin
			$fwrite(fd, "16'h%4h, \n", value);
			else
			$fwrite(fd, "16'h%4h);",value);
*/
	// end

	initial begin
		$dumpfile("counter.vcd");
		$dumpvars();
		incr = 1;
		preload = 0;
		pl_data = 0;
		enable = 1;
		updn = 1;
		reset = 1;
		waitforclk(3);
		reset = 0;
		init_mem();
		waitforclk(26);
		preload_(5);
		waitforclk(10);
		preload_(2);
		waitforclk(10);
		stopforclk(10);
		incr = 1;
		waitforclk(100);
		//updn = 0;
		waitforclk(1000);
		incr = 2;
		waitforclk(1000);
		incr = 3;
		waitforclk(1000);
		incr = 4;
		waitforclk(1000);
		incr = 5;
		waitforclk(1000);
		incr = 6;
		waitforclk(1000);
		$finish();
	end
endmodule
