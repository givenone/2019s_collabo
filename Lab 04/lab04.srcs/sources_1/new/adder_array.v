`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2020 12:13:51 AM
// Design Name: 
// Module Name: adder_array
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


module adder_array(cmd, ain0, ain1, ain2, ain3, bin0, bin1, bin2, bin3, dout0, dout1, dout2, dout3, overflow);
    
    input [2:0] cmd;
    input [31:0] ain0, ain1, ain2, ain3;
    input [31:0] bin0, bin1, bin2, bin3;
    output [31:0] dout0, dout1, dout2, dout3;
    output [3:0] overflow;
    
    wire [31:0] ain[3:0];
    wire [31:0] bin[3:0];
    wire [31:0] dout[3:0];
    
    assign {ain[0], ain[1], ain[2], ain[3]} = {ain0, ain1, ain2, ain3};
    assign {bin[0], bin[1], bin[2], bin[3]} = {bin0, bin1, bin2, bin3};
    //assign {dout0, dout1, dout2, dout3} = {dout[0], dout[1], dout[2], dout[3]};
   
    assign {overflow[0], dout0} = (cmd [2:0] == 3'b000 || cmd == 3'b100) ? dout[0] : 0;
    assign {overflow[1], dout1} = (cmd [2:0] == 3'b001 || cmd == 3'b100) ? dout[1] : 0;
    assign {overflow[2], dout2} = (cmd [2:0] == 3'b010 || cmd == 3'b100) ? dout[2] : 0;                             
    assign {overflow[3], dout3} = (cmd [2:0] == 3'b011 || cmd == 3'b100) ? dout[3] : 0;
    
    genvar i;
    
    generate for (i=0; i<4; i=i+1)
    begin: adder_array
        my_add adder(
            .ain(ain[i]),
            .bin(bin[i]),
            .dout(dout[i]),
            .overflow(overflow[i]) 
            );
    end endgenerate
    
endmodule
