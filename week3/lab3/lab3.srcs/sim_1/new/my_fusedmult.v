`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/29 15:59:46
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
    reg [2*BITWIDTH-1:0] tmp;
     always @(posedge clk) begin
        case(en)
            1'b0: tmp <= 32'b0;
            1'b1: tmp <= tmp + ain * bin;
        endcase
    end
    assign dout = tmp;
endmodule

module tb_fmul();
    parameter BITWIDTH = 32;
    
    reg [BITWIDTH-1:0] ain;
    reg [BITWIDTH-1:0] bin;
    reg clk;
    reg en;
    wire [2*BITWIDTH-1:0] dout;
    
    integer i;
    
    always #5 clk = ~clk;
    
    initial begin
        clk <= 0;
        en <= 0;
        #30;
        en <= 1;
        for(i = 0; i < 32; i = i + 1) begin
            ain = $urandom%(2**31);
            bin = $urandom%(2**31);
            #10;
        end
    end
    
    my_fusedmult #(BITWIDTH) MY_FMUL(
        .ain(ain),
        .bin(bin),
        .clk(clk),
        .en(en),
        .dout(dout)
    );
    
endmodule
