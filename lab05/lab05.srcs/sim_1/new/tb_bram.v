`timescale 1ns / 1ps


module tb_bram();
    parameter integer BRAM_ADDR_WIDTH = 15;
    parameter INIT_FILE = "input.txt";
    parameter OUT_FILE = "output.txt";
    
    reg [BRAM_ADDR_WIDTH-1:0] BRAM_ADDR;
    reg BRAM_CLK;
    reg BRAM_RST;
//    reg [3:0] BRAM_WE_SRC;
    reg [31:0] BRAM_WRDATA;
    wire [31:0] BRAM_RDDATA;
    reg [3:0] BRAM_WE_SRC;
    reg done;
    
    wire [31:0] temp;
    
    integer i;
    
    initial begin
        BRAM_CLK <= 1;
        BRAM_RST <= 0;
        done <= 0;
        #10
        
        for(i=0;i<8192;i=i+1) begin
            BRAM_ADDR = 4*i;
            #4;
        end
        done = 1;
    end
    
    always #1 BRAM_CLK = ~BRAM_CLK;
    
    my_bram #(.BRAM_ADDR_WIDTH(15), .INIT_FILE(INIT_FILE), .OUT_FILE("output1.txt")) SRC (BRAM_ADDR, BRAM_CLK, BRAM_WRDATA, temp, 1, BRAM_RST, 4'b0000, done);
    my_bram #(.BRAM_ADDR_WIDTH(15), .INIT_FILE(""), .OUT_FILE("output2.txt")) DST (BRAM_ADDR, BRAM_CLK, temp, BRAM_RDDATA, 1, BRAM_RST, 4'b1111, done);
    
endmodule