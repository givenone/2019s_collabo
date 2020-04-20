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
    reg [2:0] present_state, next_state;
    reg flag;
    parameter IDLE = 3'd0, INIT = 3'd1, LOAD = 3'd2, CALC = 3'd3, RES = 3'd4; 

    always @(posedge clk or posedge rst)
        if(rst) present_state <= IDLE; else present_state <= next_state; 
 
    always @(*)
        case(present_state)
            IDLE : if(start) next_state = INIT; else next_state = present_state;
            INIT : next_state = LOAD;
            LOAD : if(count_load == 31) next_state = CALC; else next_state = present_state;
            CALC : if(count_cal_latency == 15) next_state = RES ; else next_state = present_state;
            RES : if(count_done == 4) next_state = IDLE; else next_state = present_state;
        endcase

endmodule
