`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/31 14:54:52
// Design Name: 
// Module Name: tb_integer
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


module tb_integer();
    reg[32-1:0] ain;
    reg[32-1:0] bin;
    reg[32-1:0] cin;
    reg clk;
    wire [64-1:0] res;
    wire [48-1:0] pcout;
    
    integer i;
    initial begin
        clk <=0;
        for(i=0; i<32; i=i+1) begin
            ain = $urandom%(2**31);
            bin = $urandom%(2**31);
            cin = $urandom%(2**31);
            #20;
        end
    end
    
    always #5 clk = ~clk;
    
    xbip_multadd_0 ma(
        .A(ain),
        .B(bin),
        .C(cin),
        .CLK(clk),
        .CE(1'b1),
        .SCLR(1'b0),
        .SUBTRACT(1'b0),
        .P(res),
        .PCOUT(pcout)
     );
endmodule
