`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/30 01:13:06
// Design Name: 
// Module Name: my_add
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


module my_add #(
    parameter BITWIDTH = 32
)
( 
    input [BITWIDTH-1:0] ain,
    input [BITWIDTH-1:0] bin,
    output [BITWIDTH-1:0] dout,
    output overflow
);
    assign {overflow, dout} = ain + bin;
endmodule

module test_add();
    parameter BITWIDTH = 32;
    reg [BITWIDTH-1:0] ain;
    reg [BITWIDTH-1:0] bin;
    wire [BITWIDTH-1:0] dout;
    
    integer i;
    
    initial begin
        for(i = 0; i < 32; i = i + 1) begin
            ain = $urandom%(2 ** 31);
            bin = $urandom%(2 ** 31);
            #10;
        end
    end
    
    my_add #(BITWIDTH) MY_ADD(
        .ain(ain),
        .bin(bin),
        .dout(dout),
        .overflow(overflow)
    );
endmodule