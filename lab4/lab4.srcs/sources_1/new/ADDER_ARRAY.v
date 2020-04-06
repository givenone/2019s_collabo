`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/31 15:07:54
// Design Name: 
// Module Name: ADDER_ARRAY
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


module ADDER_ARRAY( cmd, ain0, ain1, ain2, ain3, bin0, bin1, bin2, bin3, dout0, dout1, dout2, dout3, overflow);

    input [2:0] cmd;
    input [31:0] ain0, ain1, ain2, ain3;
    input [31:0] bin0, bin1, bin2, bin3;
    output [31:0] dout0, dout1, dout2, dout3;
    output [3:0] overflow;
    
    genvar i;    
    wire [31:0] ain [3:0];
    wire [31:0] bin [3:0];
    wire [31:0] dout [3:0];
    
    assign {ain[0], ain[1], ain[2], ain[3]} =  {ain0, ain1, ain2, ain3};
    assign {bin[0], bin[1], bin[2], bin[3]} =  {bin0, bin1, bin2, bin3};
    
    generate for(i=0; i<4; i=i+1) begin:bitnum
        ADDER #(32) my_adder(
            .ain(ain[i]),
            .bin(bin[i]),
            .dout(dout[i]),
            .overflow(overflow[i])
           );
    end endgenerate
    reg [31:0] tmp [3:0];
   always @(*) begin   
       case(cmd[2:0])
            3'b000 : {tmp[0], tmp[1], tmp[2], tmp[3]} = {dout[0], 32'b0, 32'b0, 32'b0};
            3'b001 : {tmp[0], tmp[1], tmp[2], tmp[3]} =  {32'b0, dout[1], 32'b0, 32'b0};
            3'b010 : {tmp[0], tmp[1], tmp[2], tmp[3]} =  {32'b0, 32'b0, dout[2], 32'b0};
            3'b011 : {tmp[0], tmp[1], tmp[2], tmp[3]} =  {32'b0, 32'b0, 32'b0, dout[3]};
            3'b100 : {tmp[0], tmp[1], tmp[2], tmp[3]} =  {dout[0], dout[1], dout[2], dout[3]};
        endcase
    end
    assign {dout0, dout1, dout2, dout3} = {tmp[0], tmp[1], tmp[2], tmp[3]};
endmodule

module test_adderarray();
    reg [2:0] cmd;
    reg [31:0] ain [3:0];
    reg [31:0] bin [3:0];
    wire [31:0] dout [3:0];
    wire [3:0] overflow;
    
    reg clk;

    always #5 clk = ~clk;
    integer i, j, k;
    initial begin
        clk <=0;
        #30;
        
        for(i=0; i<=4; i=i+1) begin
            cmd = i;
            for(j=0; j<=8; j=j+1) begin
                for(k=0; k<4; k=k+1) begin
                    ain[k] = $urandom%(2**32-1);
                    bin[k] = $urandom%(2**32-1);
                end
 
                #10;
            end
        end 
    end
    
    ADDER_ARRAY test(
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