`timescale 1ns / 1ps


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

module my_adder_array(cmd, ain0, ain1, ain2, ain3, bin0, bin1, bin2, bin3, dout0, dout1, dout2, dout3, overflow);
    input [2:0] cmd;
    input [31:0] ain0, ain1, ain2, ain3, bin0, bin1, bin2, bin3;
    output [31:0] dout0, dout1, dout2, dout3;
    output [3:0] overflow;
    
    wire [31:0] ain [3:0];
    wire [31:0] bin [3:0];
    wire [31:0] dout [3:0];
    reg [31:0] temp [3:0];
    
    genvar i;
    
    generate for(i = 0; i < 4; i = i + 1) begin: adder
        my_add #(32) add (.ain(ain[i]), .bin(bin[i]), .dout(dout[i]), .overflow(overflow[i]));
    end endgenerate
    
    always @(*) begin
        if(cmd == 0 || cmd == 4) temp[0] = dout[0]; else temp[0] = 0;
        if(cmd == 1 || cmd == 4) temp[1] = dout[1]; else temp[1] = 0;
        if(cmd == 2 || cmd == 4) temp[2] = dout[2]; else temp[2] = 0;
        if(cmd == 3 || cmd == 4) temp[3] = dout[3]; else temp[3] = 0;
    end
    
    assign {ain[0], ain[1], ain[2], ain[3]} = {ain0, ain1, ain2, ain3};
    assign {bin[0], bin[1], bin[2], bin[3]} = {bin0, bin1, bin2, bin3};
    assign {dout0, dout1, dout2, dout3} = {temp[0], temp[1], temp[2], temp[3]};
    
endmodule

module tb_adder_array();
    reg [2:0] cmd;
    reg [31:0] ain0, ain1, ain2, ain3, bin0, bin1, bin2, bin3;
    wire [31:0] dout0, dout1, dout2, dout3;
    wire [3:0] overflow;
    
    integer i,j;
    
    initial begin
        for(i=0;i<=4;i=i+1) begin
            for(j=0;j<4;j=j+1)begin
                cmd = i;
                ain0 = $urandom%(2**31);
                ain1 = $urandom%(2**31);
                ain2 = $urandom%(2**31);
                ain3 = $urandom%(2**31);
                bin0 = $urandom%(2**31);
                bin1 = $urandom%(2**31);
                bin2 = $urandom%(2**31);
                bin3 = $urandom%(2**31);
                #20;
            end
        end
    end
    
    my_adder_array UUT(
        .cmd(cmd),
        .ain0(ain0), .ain1(ain1), .ain2(ain2), .ain3(ain3),
        .bin0(bin0), .bin1(bin1), .bin2(bin2), .bin3(bin3),
        .dout0(dout0), .dout1(dout1), .dout2(dout2), .dout3(dout3),
        .overflow(overflow)
    );
    
endmodule