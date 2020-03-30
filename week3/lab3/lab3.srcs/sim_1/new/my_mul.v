`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/29 15:59:19
// Design Name: 
// Module Name: my_mul
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


module my_mul #(
    parameter BITWIDTH = 32
)
(
    input [BITWIDTH-1:0] ain,
    input [BITWIDTH-1:0] bin,
    output [2*BITWIDTH-1:0] dout
);
/* IMPLEMENT HERE! */
    assign dout = ain * bin;
endmodule

module tb_mul();
    parameter BITWIDTH = 32;
    reg [BITWIDTH-1:0] ain;
    reg [BITWIDTH-1:0] bin;
    wire [2*BITWIDTH-1:0] dout;
    
    integer i;
    
    initial begin
        for(i = 0; i < 32; i = i + 1) begin
            ain = $urandom%(2 ** 31);
            bin = $urandom%(2 ** 31);
            #10;
        end
    end
    
    my_mul #(BITWIDTH) MY_MUL(
        .ain(ain),
        .bin(bin),
        .dout(dout)
    );
endmodule
