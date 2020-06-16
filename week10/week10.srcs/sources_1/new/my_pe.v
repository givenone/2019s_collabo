`timescale 1ns / 1ps

module my_pe #(
        parameter VECTOR_SIZE = 16
    )
    (
        // clk/reset
        input aclk,
        input aresetn,
        // port A
        input [31:0] ain,
        // peram -> port B 
        input [31:0] din,
        input [31:0]  addr,
        input we,
        // integrated valid signal -> for input ready..
        input valid,
        // computation result
        output dvalid,
        output [31:0] dout
    ); 
    
   (* ram_style = "block" *) reg [31:0] peram [0:VECTOR_SIZE-1];  // local register
   
    reg [31:0] psum;
    reg [31:0] weight;
    wire [31:0] cout;
    //wire [31:0] cout; // output of mac -> psum(output value of pe stored)
    
    always @(negedge aclk) begin
        if(!aresetn) begin
            weight = 0;
        end
        else begin
            if(we) peram[addr] = din;
            else weight = peram[addr];
        end
    end
    
    always @(*) begin
        psum = (!aresetn) ? 0 :
        dvalid ? cout : 0;
    end
    
    assign dout = psum; // psum(output value register -> wire)
        
    // fused multiplier for MAC :: res = a * b + c
    floating_point_0 mul(
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_a_tvalid(valid),
        .s_axis_a_tdata(ain),
        .s_axis_b_tvalid(valid),
        .s_axis_b_tdata(weight),
        .s_axis_c_tvalid(valid),
        .s_axis_c_tdata(psum),
        .m_axis_result_tvalid(dvalid),
        .m_axis_result_tdata(cout)
    );
endmodule  