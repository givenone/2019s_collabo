`timescale 1ns / 1ps


 module my_pe #(
    parameter L_RAM_SIZE = 6
)(
    input aclk,
    input aresetn,
    input [31:0] ain,
    input [31:0] din,
    input [L_RAM_SIZE-1:0] addr,
    input we,
    input valid,
    output dvalid,
    output [31:0] dout
);

(* ram_style = "block" *) reg [31:0] peram [0:2**L_RAM_SIZE - 1];

    // for accumulating MAC result
    wire [31:0] temp;
    reg [31:0] psum;
    reg [31:0] bin;

    always @(posedge aclk or negedge aresetn) begin    
        if(!aresetn) begin
            bin = 0;
            psum = 0;
        end
       
        if(we) peram[addr] = din;
        else bin = peram[addr];
    end
   
    always @(temp) begin
        psum = dvalid ? temp : 0;
    end
   
    assign dout = psum;

    fused_mul mul(
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_a_tvalid(valid),
        .s_axis_a_tdata(ain),
        .s_axis_b_tvalid(valid),
        .s_axis_b_tdata(bin),
        .s_axis_c_tvalid(valid),
        .s_axis_c_tdata(psum),
        .m_axis_result_tvalid(dvalid),
        .m_axis_result_tdata(temp)
    );

endmodule