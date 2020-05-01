`timescale 1ns / 1ps

module one_sec(
    input GCLK,
    input BTNC,
    output reg [7:0] LD
    );
    reg [30:0] down_counter;
    
    initial begin
        down_counter = 100000000;
        LD = 0;
    end
    
    always @(posedge GCLK or posedge BTNC) begin
        if(BTNC) begin
            down_counter = 100000000;
            LD = 0;
        end
        else begin
            down_counter = down_counter - 1;
            if(down_counter == 0) begin
                LD = LD + 1;
                down_counter = 100000000;
            end
        end
     end   
endmodule
