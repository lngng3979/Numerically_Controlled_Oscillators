//`timescale 1ns/100ps
 
module counter (
	input clk,
	input reset,
	input enable,
	input preload,
	input updn,
	input [6:0] pl_data,
	input [3:0] incr,

	input csb00,
	input csb10,
	input web0,
	input [3:0] wmask0,
	input [6:0] addr0,
	input [31:0] din0,

	//input [31:0] table_ [0:255],
	output reg [7:0] cout,
	output [31:0] sine_out
);


	wire [31:0] temp_sine_out0;
	wire [31:0] temp_sine_out1;
	reg [31:0] reg_sine_out;
	reg [7:0] cout_reg;
	
	assign sine_out = reg_sine_out;

	sky130_sram_512byte_1rw1r_32x128_8 u_mem0 (
		.clk0(clk),
		.csb0(csb00),
		.web0(web0),
		.wmask0(wmask0),
		.addr0(addr0),
		.din0(din0),
		//.dout0(dout0),
		.clk1(clk),
		.csb1(1'b0),
		.addr1(cout[6:0]),
		.dout1(temp_sine_out0)
	);

	sky130_sram_512byte_1rw1r_32x128_8 u_mem1 (
		.clk0(clk),
		.csb0(csb10),
		.web0(web0),
		.wmask0(wmask0),
		.addr0(addr0),
		.din0(din0),
		//.dout0(dout0),
		.clk1(clk),
		.csb1(1'b0),
		.addr1(cout[6:0]),
		.dout1(temp_sine_out1)
	);

	always @(posedge clk) begin
		cout_reg = cout;
	end

	always @(posedge clk) begin
		if (cout_reg[7])
			reg_sine_out = temp_sine_out1;
		else
			reg_sine_out = temp_sine_out0;
	end



	always @(posedge clk or posedge reset) begin
		if (reset)
			cout = 0;
		else if (preload)
			cout = pl_data;
		else if (enable)
			if (updn)
					 cout = cout + incr;
			else
				 	 cout = cout - incr;
end


endmodule
