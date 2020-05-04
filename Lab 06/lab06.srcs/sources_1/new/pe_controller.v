`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2020 06:37:53 PM
// Design Name: 
// Module Name: pe_controller
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


module pe_controller # (
    parameter VECTOR_SIZE = 16,
    parameter L_RAM_SIZE = 4

)(
    input start,
    input aclk,
    input aresetn,
    input [31:0] rddata,
    output done,
    output [L_RAM_SIZE:0] rdaddr,
    output [31:0] wrdata,
    //debugging
    output [2:0] ps
    );
    
    //PE
    wire [31:0] ain;
    wire [31:0] din;
    wire [L_RAM_SIZE-1:0] addr;
    wire pe_we;                    //enable for PE
    wire global_we;                //enable outside PE
    wire valid;
    wire dvalid;
    wire [31:0] dout;
    
    my_pe #(
        .L_RAM_SIZE(L_RAM_SIZE)
    ) my_pe (
        .aclk(aclk),
        .aresetn(aresetn),      
        .ain(ain),
        .din(din),
        .addr(addr),
        .we(pe_we),                
        .valid(valid),
        .dvalid(dvalid),
        .dout(dout)
    );
    
    //global bram
    (* ram_style="block" *) reg [31:0] globalmem[0:VECTOR_SIZE-1];
    
    //data into BRAM
    always @ (posedge aclk) begin
        if (global_we) globalmem[addr] <= rddata;
    end
    
    //FSM
    reg [2:0] present_state, next_state;    //present state and next state
    localparam S_IDLE = 3'd0;
    localparam S_LOAD = 3'd1;
    localparam S_CALC = 3'd2;
    localparam S_DONE = 3'd3;
    localparam CNTLOAD = 2* VECTOR_SIZE - 1;         //31
    localparam CNTCALC = 16 * VECTOR_SIZE - 1;       //15
    localparam CNTDONE = 5;
    
    wire load_done;
    wire calc_done;
    wire done_done;
   
    reg counter_rst_load31;
    reg counter_rst_calc15;
    reg counter_rst_done5;
    reg [6:0] counter_load31;
    reg [9:0] counter_calc15;
    reg [2:0] counter_done5;

    //debugging
    assign ps = present_state;
    
    //control we
    assign pe_we = (present_state == S_LOAD && counter_load31 <= 15) ? 1'b1 : 1'b0;
    assign global_we = (present_state == S_LOAD && counter_load31 > 15) ? 1'b1 : 1'b0;
    
    //THIS addr for peram and bram
    assign addr = (present_state == S_CALC) ? (counter_calc15 / VECTOR_SIZE) 
    : global_we ? counter_load31 
    : pe_we ? counter_load31 - VECTOR_SIZE 
    : 1'd0;

    //assign ain
    assign ain = (present_state == S_CALC) ? globalmem[addr] : 1'd0;
    
    //assign din
    assign din = (present_state == S_LOAD) ? rddata : 1'd0;
    
    //assign done
    assign load_done = (counter_load31 == CNTLOAD) ? 1'b1 : 1'b0;
    assign calc_done = (counter_calc15 == CNTCALC) ? 1'b1 : 1'b0;
    assign done_done = (counter_done5 == CNTDONE) ? 1'b1 : 1'b0;
    assign done = (present_state == S_DONE);

    //assign rdaddr
    assign rdaddr = (present_state == S_LOAD) ? counter_load31 : 1'd0;
   
   //assign valid signal for pe
   assign valid = (present_state == S_CALC) ? 1'd1 : 1'd0;
   
   //assign wrdata
    assign wrdata = (present_state == S_DONE) ? dout : 1'd0;
   
    //counter
    always @(posedge aclk or posedge counter_rst_load31)
        if(counter_rst_load31) counter_load31 <= 0;
        else counter_load31 <= counter_load31 + 1;
    always @(posedge aclk or posedge counter_rst_calc15)
        if(counter_rst_calc15) counter_calc15 <= 0;
        else counter_calc15 <= counter_calc15 + 1;
    always @(posedge aclk or posedge counter_rst_done5)
        if(counter_rst_done5) counter_done5 <= 0;
        else counter_done5 <= counter_done5 + 1;
    
    //part 1: initialise to state IDLE and update present state register
    always @(posedge aclk)
        if(!aresetn) present_state <= S_IDLE;
        else present_state <= next_state;
    
    //part 2: determine next state
    always @(*)
        case(present_state)
            S_IDLE: if(start) next_state = S_LOAD; else next_state = present_state;
            S_LOAD: if(load_done) next_state = S_CALC; else next_state = present_state;
            S_CALC: if(calc_done) next_state = S_DONE; else next_state = present_state;
            S_DONE: if(done_done) next_state = S_IDLE; else next_state = present_state;
        endcase
        
    //part 3: evaluate output
    always @(*)
        //S_CALC
        case(present_state)
            S_CALC: counter_rst_calc15 = 0;   //counter for S_CALC continues to tick
            default: counter_rst_calc15 = 1;
        endcase
        
    always @(*)
        //S_LOAD
        case(present_state)
            S_LOAD: counter_rst_load31 = 0;   //counter for S_LOAD continues to tick
            default: counter_rst_load31 = 1;
        endcase
       
    always @(*)
        //S_DONE
        case(present_state)
            S_DONE: counter_rst_done5 = 0;   //counter for S_DONE continues to tick
            default: counter_rst_done5 = 1;
        endcase
        
    always @(*)
        //S_IDLE
        case(present_state)
            S_IDLE: begin
               counter_rst_load31 = 1;
               counter_rst_calc15 = 1;
               counter_rst_done5 = 1; 
            end
        endcase   
endmodule