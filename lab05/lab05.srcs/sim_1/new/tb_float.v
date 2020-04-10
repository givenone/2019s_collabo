`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/10 23:04:19
// Design Name: 
// Module Name: tb_float
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


module tb_float();
    reg aclk;
    reg aresetn;
    reg [31:0] ain;
    reg [31:0] bin;
    reg [31:0] sum;
    reg valid;
    wire dvalid;
    wire [31:0] dout;
    
    wire [31:0] temp;
    
    integer i;
    
    always #5 aclk = ~aclk;
    
    always @(posedge aclk or aresetn) begin
        if(!aresetn) begin
            sum = 0;
        end
        
        sum = dvalid ? temp : 0;
    end
    
    initial begin
        aclk <= 1;
        aresetn = 0;
        valid = 0;
        #20;
        aresetn = 1;
        valid = 1;
        for(i = 0; i < 16; i = i + 1) begin
            ain = 32'h3f800000;
            bin = 32'h3f800000;
            #160;
        end
        
        valid = 0;
    end
    
    assign dout = sum;
    
    fused_mul mul(
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_a_tvalid(valid),
        .s_axis_a_tdata(ain),
        .s_axis_b_tvalid(valid),
        .s_axis_b_tdata(bin),
        .s_axis_c_tvalid(valid),
        .s_axis_c_tdata(sum),
        .m_axis_result_tvalid(dvalid),
        .m_axis_result_tdata(temp)
    );
    

endmodule
