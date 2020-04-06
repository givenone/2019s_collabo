`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2020 04:58:43 PM
// Design Name: 
// Module Name: tb_adder_array
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


module tb_adder_array();

    //for my ip
    reg [2:0] cmd;
    reg [31:0] ain[3:0];
    reg [31:0] bin[3:0];
    reg clk;
    wire [31:0] dout[3:0];
    wire [3:0] overflow;
    
    //for test
    integer i, j;
    //random test vector generation
    initial begin
        clk<=0;
        
        for(i=0; i<=4; i=i+1) begin
            cmd = i;
            for(j=0; j<16; j=j+1) begin
                ain[0] = $urandom%(2**31);
                ain[1] = $urandom%(2**31);
                ain[2] = $urandom%(2**31);
                ain[3] = $urandom%(2**31);
                bin[0] = $urandom%(2**31);
                bin[1] = $urandom%(2**31);
                bin[2] = $urandom%(2**31);
                bin[3] = $urandom%(2**31);
                #10;
            end
        end
    end
    
    always #5 clk = ~clk;
    
    adder_array UUT_adder_array(
        .cmd(cmd),
        .ain0(ain[0]),
        .ain1(ain[1]),
        .ain2(ain[2]),
        .ain3(ain[3]),
        .bin0(bin[0]),
        .bin1(bin[1]),
        .bin2(bin[2]),
        .bin3(bin[3]),
        .dout0(dout[0]),
        .dout1(dout[1]),
        .dout2(dout[2]),
        .dout3(dout[3]),
        .overflow(overflow)
    );
        
endmodule
