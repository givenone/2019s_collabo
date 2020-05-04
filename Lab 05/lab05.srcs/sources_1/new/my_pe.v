`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2020 01:46:19 AM
// Design Name: 
// Module Name: my_pe
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


   module my_pe #(
    parameter L_RAM_SIZE = 6
  )(
        //clk/reset
        input aclk,
        input aresetn,
        //port A
        input [31:0] ain,
        //peram -> port B
        input [31:0] din,
        input [L_RAM_SIZE-1:0] addr,
        input we,
        //integrated valid signal
        input valid,
        //computation result
        output dvalid,
        output [31:0] dout
    );
    
    (* ram_style = "block" *) reg [31:0] peram [0:2**L_RAM_SIZE - 1]; //local register
    
    //for my IP
    reg [31:0] bin;
    reg [31:0] psum;        // partial sum
    wire [31:0] res; 
    
    always @(posedge aclk) begin
        if(aresetn == 0) begin      //reset is activated
            bin = 0;
            psum = 0;
        end
        
        if(we == 1) begin
            peram[addr] = din;
        end
        
        else begin
            bin = peram[addr];
        end
    end
    
    always @(res) begin
        if (dvalid == 1) begin
            psum = res;
        end
        
        else begin
            psum = 0;
        end
    end
    
    assign dout = res;
    
    floating_point_MAC MAC(
        .s_axis_a_tdata(ain),
        .s_axis_a_tvalid(valid),
        .s_axis_b_tdata(bin),
        .s_axis_b_tvalid(valid),
        .s_axis_c_tdata(psum),
        .s_axis_c_tvalid(valid),
        .aclk(aclk),
        .aresetn(aresetn),
        .m_axis_result_tdata(res),
        .m_axis_result_tvalid(dvalid)
    );
endmodule
