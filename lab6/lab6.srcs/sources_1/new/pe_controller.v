`timescale 1ns / 1ps

module pe_controller #(
        parameter RAM_SIZE = 6
        )
    (
        input start,
        input aclk,
        input areset_n,
        input [31:0] rddata,
        output done,
        output [RAM_SIZE -1 : 0] raddr,
        output [31:0] wrdata
    );
    reg [2:0] state;
    reg [4:0] count_load; // 32
    reg [3:0] count_cal, count_cal_latency;  // 16
    reg [2:0] count_done; // 5
    reg count_rst_load, count_rst_cal, count_rst_cal_latency, count_rst_done;
    parameter 	IDLE = 3'd0, INIT = 3'd1, LOAD = 3'd2, CALC = 3'd3, RES = 3'd4;     
    
    reg flag; // state for counter (pe)
    
    // register and wires for pe module !
    reg [31:0] ain, bin;
    reg [RAM_SIZE-1:0]  addr;
    reg we;
    // integrated valid signal -> for input ready..
    reg valid;
    // computation result
    wire [31:0] cout;
    wire dvalid;
    wire [31:0] dout;
    always @(posedge aclk or negedge areset_n) begin
        if(!areset_n) begin
            state = 0; count_load = 0; count_cal =0; count_cal_latency = 0; count_done = 0;
            count_rst_load = 0; count_rst_cal = 0; count_rst_cal_latency = 0; count_rst_done = 0;
            flag = 0;
        end
        case (state)
            LOAD : // load <16 -> local register in pe and load > 16 : peram(global bram)
            // Do things with rddata, raddr
            //CALC : //calculation
            //RES : //     
        endcase
    end
    my_pe #(.L_RAM_SIZE(6)) mac(
        .aclk(aclk),
        .aresetn(areset_n),
        .ain(ain),
        .din(din),
        .addr(addr),
        .we(we),
        .valid(valid),
        .dvalid(dvalid),
        .dout(dout),
        .cout(cout)
        );
       
    // counter
    always @(posedge aclk or posedge count_rst_load)
        if(count_rst_load) count_load <= 0;
        else count_load <= count_load + 1;
        
    // TODO :: how to wait pe cycle ? (one counter++ per one pe latency)   
    // one for vector, one for latency !
    always @(posedge aclk or posedge count_rst_cal)
        if(count_rst_cal) count_cal <= 0;
        else count_cal <= count_cal + 1;

    always @(posedge aclk or posedge count_rst_cal_latency)
        if(count_rst_cal_latency) count_cal_latency <= 0;
        else if(flag) begin
            count_cal_latency <= count_cal_latency + 1;
            count_rst_cal = 1; 
        end

    always @(posedge aclk or posedge count_rst_done)
        if(count_rst_done) count_done <= 0;
        else count_done <= count_done + 1;
   
   
    // evaluate output

   always @(*)
        if(state == CALC && count_cal == 15) begin
            flag = 1;
        end
        else if(state == CALC && count_cal != 15) begin
            flag = 0;
            count_rst_cal = 0;
        end
        else begin
            flag = 0;
            count_rst_cal = 1;
        end
        
    always @(*)
        case (state)
            CALC : count_rst_cal_latency = 0;
            default : count_rst_cal_latency = 1;
        endcase

    always @(*)
        case (state)
            LOAD : count_rst_load = 0;
            default : count_rst_load = 1;
        endcase
    
    always @(*)
        case (state)
            RES : count_rst_done = 0;
            default : count_rst_done = 1;
        endcase
endmodule
