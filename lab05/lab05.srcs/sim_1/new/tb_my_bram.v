`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2020 11:18:01 PM
// Design Name: 
// Module Name: tb_my_bram
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


module tb_my_bram();
    parameter integer BRAM_ADDR_WIDTH = 15;
    parameter INIT_FILE = "input.txt";
    parameter OUT_FILE = "output.txt";
    
    reg [BRAM_ADDR_WIDTH-1:0] BRAM_ADDR;
    reg BRAM_CLK;
    reg [31:0] BRAM_WRDATA;
    wire [31:0] BRAM_RDDATA;
    reg BRAM_EN;
    reg BRAM_RST;
    reg [3:0] BRAM_WE;
    reg done;
    
    wire [31:0] tmp;
    
    //for test
    integer i;
    //random test vector generation
    initial begin
        BRAM_CLK<=1;
        BRAM_RST<=0;
        done<=0;
        for(i=0;i<8192;i=i+1) begin
            BRAM_ADDR = i*4;   //only use upper 13 bits
            #4;
        end
        done<=1;
    end
    
    always #1 BRAM_CLK = ~BRAM_CLK;
    
    my_bram #(
        .BRAM_ADDR_WIDTH(15),
        .INIT_FILE(INIT_FILE),
        .OUT_FILE("output1.txt")
    ) BRAM1 (
        .BRAM_ADDR(BRAM_ADDR),
        .BRAM_CLK(BRAM_CLK),
        .BRAM_WRDATA(BRAM_WRDATA),
        .BRAM_RDDATA(tmp),
        .BRAM_EN(1'b1),
        .BRAM_WE(4'b0000),
        .BRAM_RST(1'b0),
        .done(done)
    );
    
    my_bram #(
        .BRAM_ADDR_WIDTH(15),
        .INIT_FILE(""),
        .OUT_FILE("output2.txt")
    ) BRAM2 (
        .BRAM_ADDR(BRAM_ADDR),
        .BRAM_CLK(BRAM_CLK),
        .BRAM_WRDATA(tmp),
        .BRAM_RDDATA(BRAM_RDDATA),
        .BRAM_EN(1'b1),
        .BRAM_WE(4'b1111),
        .BRAM_RST(1'b0),
        .done(done)
    );

endmodule
