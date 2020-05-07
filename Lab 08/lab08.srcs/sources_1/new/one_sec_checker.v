`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2020 09:00:16 PM
// Design Name: 
// Module Name: one_sec_checker
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


module one_sec_checker(
        input GCLK,
        input CENTER_PUSHBUTTON,
        output reg [7:0] LED
    );
    
    reg [26:0] down_counter;
    
    always @(posedge GCLK) begin
        if(CENTER_PUSHBUTTON == 1) begin
            down_counter <= 0;
            LED <= 0;
        end
        else begin
            down_counter = down_counter - 1;
            if (down_counter == 0) begin
                LED = LED + 1;
                down_counter <= 0;
            end
        end
    end
endmodule
