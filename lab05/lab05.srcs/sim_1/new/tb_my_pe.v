`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2020 10:15:53 PM
// Design Name: 
// Module Name: tb_my_pe
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


module tb_my_pe();

parameter L_RAM_SIZE = 6;

    //clk/reset
    reg aclk;
    reg aresetn;
    //port A
    reg [31:0] ain;
    //peram -> port B
    reg [31:0] din;
    reg [L_RAM_SIZE-1:0] addr;
    reg we;
    //integrated valid signal
    reg valid;
    //computation result
    wire dvalid;
    wire [31:0] dout;
    
    //for test
    integer i;
    //random test vector generation
    initial begin   
        aclk <= 1;
        valid = 0;
        we = 1;
        aresetn = 1;
        for(i=0; i<16; i=i+1) begin
            addr = i;
            din = $urandom%(2**31);
            #10;
        end
        valid = 1;
        we = 0;
        for(i=0; i<16; i=i+1) begin
            addr = i;
            ain = $urandom%(2**31);
            #160;
        end
        valid = 0;       
    end
    always #5 aclk = ~aclk;

    my_pe #() pe (
        .aclk(aclk),
        .aresetn(aresetn),
        .ain(ain),
        .din(din),
        .addr(addr),
        .we(we),
        .valid(valid),
        .dvalid(dvalid),
        .dout(dout)
    );

endmodule
