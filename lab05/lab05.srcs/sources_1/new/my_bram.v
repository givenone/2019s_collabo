`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2020 08:54:00 PM
// Design Name: 
// Module Name: my_bram
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
    input wire [3:0] BRAM_WE,   //each of four bytes has its own write enable signal
    input wire done
  );
    reg [31:0] mem[0:8191];     //8192 entries (each entry has 4 bytes)
    wire [BRAM_ADDR_WIDTH-3:0] addr = BRAM_ADDR[BRAM_ADDR_WIDTH-1:2];   //addr=an index of 4-byte entry
    reg [31:0] dout;
    
    //integer i;
    
    //code for reading and writing
    initial begin
        if(INIT_FILE != "") begin
            //read data from INIT_FILE and store them into mem
            $readmemh(INIT_FILE, mem);    
        end
        wait (done)
            //write data stored in mem into OUT_FILE
            $writememh(OUT_FILE, mem);
    end
    
    //code for BRAM implementation
    always @(posedge BRAM_CLK) begin
        if (BRAM_RST == 1) begin
            BRAM_RDDATA <= 0;
        end
        else if (BRAM_EN == 1) begin
            //if all BRAM_WE == 0
            //if (BRAM_WE[0] == 0 && BRAM_WE[1] == 0 && BRAM_WE[2] == 0 && BRAM_WE[3] == 0) begin
            if (BRAM_WE == 4'b0000) begin
                BRAM_RDDATA <= mem[addr];
            end
            else begin
                /*for(i=0; i<4; i=i+1) begin
                    if(BRAM_WE[i] == 1) begin
                        //mem[addr][8*(i+1)-1:8*i] <= BRAM_WRDATA[8*(i+1)-1:8*i];
                     
                    end
                end*/
                if(BRAM_WE[0] == 1) begin
                    mem[addr][8*(0+1)-1:8*0] <= BRAM_WRDATA[8*(0+1)-1:8*0];
                end
                
                if(BRAM_WE[1] == 1) begin
                    mem[addr][8*(1+1)-1:8*1] <= BRAM_WRDATA[8*(1+1)-1:8*1];
                end
                
                if(BRAM_WE[2] == 1) begin
                    mem[addr][8*(2+1)-1:8*2] <= BRAM_WRDATA[8*(2+1)-1:8*2];
                end
                
                if(BRAM_WE[3] == 1) begin
                    mem[addr][8*(3+1)-1:8*3] <= BRAM_WRDATA[8*(3+1)-1:8*3];
                end
            end
        end
    end    
endmodule

