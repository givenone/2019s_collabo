`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/31 14:45:49
// Design Name: 
// Module Name: tb
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


module tb();

    reg[32-1:0] ain;
    reg[32-1:0] bin;
    reg[32-1:0] cin;
    reg rst;
    reg clk;
    wire[32-1:0] res;
    wire dvalid;
    
    integer i;
    
    initial begin
        clk <=0;
        rst <=0;
        
        for(i=0; i<32; i=i+1) begin
            ain = $urandom%(2**31);
            bin = $urandom%(2**31);
            cin = $urandom%(2**31);
            #20;
        end
    end
    
    always #5 clk = ~clk;
    
    floating_point_0 fp(
        .aclk(clk),
        .aresetn(~rst),
        .s_axis_a_tdata(ain),
        .s_axis_b_tdata(bin),
        .s_axis_c_tdata(cin),
        .s_axis_a_tvalid(1'b1),
        .s_axis_b_tvalid(1'b1),
        .s_axis_c_tvalid(1'b1),
        .m_axis_result_tvalid(dvalid),
        .m_axis_result_tdata(res)
        );
endmodule
