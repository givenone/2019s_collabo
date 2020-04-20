`timescale 1ns / 1ps
module my_bram # (
    parameter integer BRAM_ADDR_WIDTH = 15, // 8192 entries of 4-byte data
    parameter INIT_FILE = "input.txt",
    parameter OUT_FILE = "output.txt"
  )(
    input wire [BRAM_ADDR_WIDTH-1:0] BRAM_ADDR,
    input wire BRAM_CLK,
    input wire [31:0] BRAM_WRDATA,
    output reg [31:0] BRAM_RDDATA,
    input wire BRAM_EN,
    input wire BRAM_RST,
    input wire [3:0] BRAM_WE, // each of four bytes has its own write enable signal
    input wire done
  );
    reg [31:0] mem[0:8191]; // 8192 entries (each entry has 4 bytes) : THIS IS MEMORY !!
    wire [BRAM_ADDR_WIDTH-3:0] addr = BRAM_ADDR[BRAM_ADDR_WIDTH-1:2]; // addr = an index of 4-byte entry :: EXTERNAL ADDRESS !!
    reg [31:0] dout;
   
   always @(posedge BRAM_CLK or posedge BRAM_RST) begin
    if(BRAM_RST) /*asyncronous resest*/ BRAM_RDDATA <= 0;
    else if(BRAM_EN) begin
        if(BRAM_WE == 4'b0000) BRAM_RDDATA <= mem[addr];
        else begin
            if(BRAM_WE[0] == 1) mem[addr][8*(0+1)-1:8*0] <= BRAM_WRDATA[8*(0+1)-1:8*0];
            if(BRAM_WE[1] == 1) mem[addr][8*(1+1)-1:8*1] <= BRAM_WRDATA[8*(1+1)-1:8*1];
            if(BRAM_WE[2] == 1) mem[addr][8*(2+1)-1:8*2] <= BRAM_WRDATA[8*(2+1)-1:8*2];
            if(BRAM_WE[3] == 1) mem[addr][8*(3+1)-1:8*3] <= BRAM_WRDATA[8*(3+1)-1:8*3];
            end
        end
    end
endmodule