`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2020 10:41:51 PM
// Design Name: 
// Module Name: tb_pe_controller
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


module tb_pe_controller # (
    parameter VECTOR_SIZE = 6,
    parameter MATRIX_SIZE = 2,
    parameter L_RAM_SIZE = 6,
    parameter CLK_PERIOD = 2
)();

reg start;
reg aclk;
reg aresetn;
reg [31:0] din;
wire done;
wire [31:0] rdaddr;
wire [31:0] wrdata;
wire [2:0] ps;

integer i;
integer j;
////input data
reg [31:0] din_mem[0:63];

initial begin
    start=0;
    aclk<=0;
    aresetn=1;
    
    #(CLK_PERIOD*5);
    aresetn=0;
    #(CLK_PERIOD*5);
    aresetn=1;
    #(CLK_PERIOD*5);
    start = 1;
       

    for(j = 0; j < 5; j = j + 1) begin
        for(i = 0; i < 64; i = i + 1) begin
            din = din_mem[i];
            #(CLK_PERIOD*5);
        end
    end
end
    
//always @(posedge aclk)
    //din <= din_mem[rdaddr];
            
initial 
    $readmemh("input.txt", din_mem);

always #5 aclk = ~aclk;

    pe_controller #(.L_RAM_SIZE(L_RAM_SIZE), .MATRIX_SIZE(MATRIX_SIZE), .VECTOR_SIZE(VECTOR_SIZE)) UUT (
        .start(start),
        .aclk(aclk),
        .aresetn(aresetn),
        .rddata(din),
        .done(done),
        .rdaddr(rdaddr),
        .wrdata(wrdata),
        .ps(ps)
    );
endmodule