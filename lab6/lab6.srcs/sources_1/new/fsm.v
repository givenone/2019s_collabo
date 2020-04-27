`timescale 1ns / 1ps

module fsm(
        input clk,
        input rst,
        input [4:0] count_load, // 32
        input [3:0] count_cal, count_cal_latency,  // 16
        input [2:0] count_done, // 5
        input start,
        output state 
    );
    
    reg flag;
    parameter IDLE = 3'd0, INIT = 3'd1, LOAD = 3'd2, CALC = 3'd3, RES = 3'd4; 

 
 


endmodule
