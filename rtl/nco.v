`timescale 1ns/100ps
`define USE_RAM
module counter (
        input clk,
        input reset,
        input enable,
        input preload,
        input updn,
        input [7:0] pl_data,
        input [3:0] incr,
`ifdef USE_RAM
        input csb00,
        input csb10,
        input csb20,
        input csb30,
        input web0,
        input [3:0] wmask0,
        input [7:0] addr0,
        input [31:0] din0,
`endif
        //input [31:0] table_ [0:255],
        output reg [7:0] cout,
        output [31:0] sine_out
);
