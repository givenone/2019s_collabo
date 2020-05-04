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
    parameter L_RAM_SIZE = 4,
    parameter CLK_PERIOD = 10
)();

reg start;
reg aclk;
reg aresetn;
reg [31:0] din;
wire done;
wire [L_RAM_SIZE:0] rdaddr;
wire [31:0] wrdata;
wire [2:0] ps;

//input data
reg [31:0] din_mem[2**(L_RAM_SIZE+1)-1:0];

initial begin
    start<=0;
    aclk<=0;
    aresetn<=1;
    
//    $readmemh("input.txt", din_mem);
    #(CLK_PERIOD*5);
    aresetn<=0;
    #(CLK_PERIOD*5);
    aresetn<=1;
    #(CLK_PERIOD*5);
    start = 1;
    
end

initial 
	$readmemh("input.txt", din_mem);
        
    always @(posedge aclk)
        din <= din_mem[rdaddr];

    always #5 aclk = ~aclk;
    
    pe_controller #(2**L_RAM_SIZE, L_RAM_SIZE) UUT(
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
