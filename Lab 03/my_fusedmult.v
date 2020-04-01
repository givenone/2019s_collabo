`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2020 05:55:19 PM
// Design Name: 
// Module Name: my_fusedmult
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


module my_fusedmult #(
    parameter BITWIDTH = 32
)
(
    input [BITWIDTH-1:0] ain,
    input [BITWIDTH-1:0] bin,
    input en,
    input clk,
    output [2*BITWIDTH-1:0] dout
);
/* IMPLEMENT HERE! */

wire [2*BITWIDTH-1:0] mult_out;
wire [2*BITWIDTH-1:0] add_out;
reg [2*BITWIDTH-1:0] final_out = 0;
wire overflow;

assign dout = final_out;

always @(posedge clk) begin

    if (en == 0) begin
        final_out = 0;
    end
    
    else begin
        final_out = add_out;
    end
end

my_mul #(BITWIDTH) multiplier(.ain(ain), .bin(bin), .dout(mult_out));
my_add #(2*BITWIDTH) adder(.ain(mult_out), .bin(dout), .dout(add_out), .overflow(overflow));
                       
endmodule
