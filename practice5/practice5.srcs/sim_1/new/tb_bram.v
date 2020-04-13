`timescale 1ns / 1ps

module tb_bram;
    parameter integer BRAM_ADDR_WIDTH = 15; // 8192 entries of 4-byte data
    parameter INIT_FILE = "input.txt"; // Input file path 
    parameter OUT_FILE = "output.txt"; // output file path
    
    reg [BRAM_ADDR_WIDTH-1:0] BRAM_ADDR;
    reg BRAM_CLK;
    reg [31:0] BRAM_WRDATA;
    
    wire [31:0] BRAM_RDDATA; // output
    
    reg BRAM_EN;
    reg BRAM_RST;
    reg [3:0] BRAM_WE; // each of four bytes has its own write enable signal
    reg done;
    
    wire [31:0] read;
    
    integer i;
    initial begin
        BRAM_CLK <= 0;
        BRAM_RST <= 0;
        BRAM_EN <= 1;
        done <= 0;
        #4
        
        for(i=0; i<8192; i=i+1) begin
            BRAM_ADDR = i * 4;
            #4; // wait 5 clock cycle for visualizing
        end
        done = 1;
    end
    
    always #1 BRAM_CLK = ~BRAM_CLK;
    
    my_bram #(.BRAM_ADDR_WIDTH(15), .INIT_FILE(INIT_FILE), .OUT_FILE("") ) READ (BRAM_ADDR, BRAM_CLK, BRAM_WRDATA, BRAM_RDDATA, BRAM_EN, BRAM_RST, 4'b0000, done);
    my_bram #(.BRAM_ADDR_WIDTH(15), .INIT_FILE(""), .OUT_FILE("output.txt") ) WRITE (BRAM_ADDR, BRAM_CLK, BRAM_RDDATA, read, BRAM_EN, BRAM_RST, 4'b1111, done);
        
    
endmodule
