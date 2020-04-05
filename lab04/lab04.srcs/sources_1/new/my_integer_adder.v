`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/05 22:30:31
// Design Name: 
// Module Name: my_integer_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module my_integer_adder(ain, bin, cin, clk, rst, sum, cout);
    input [31:0] ain, bin, cin;
    input clk, rst;
    output [31:0] sum;
    output cout;
endmodule

module tb_integer_adder();
    reg [31:0] ain, bin, cin;
    reg clk, rst;
    wire [31:0] cout;
    
    
endmodule
