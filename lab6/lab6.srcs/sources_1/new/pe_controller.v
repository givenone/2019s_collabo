`timescale 1ns / 1ps

module pe_controller #(
        parameter VECTOR_SIZE = 16,
        parameter L_RAM_SIZE = 6
        )
    (
        input start,
        input aclk,
        input areset_n,
        input [31:0] rddata,
        output done,
        output [L_RAM_SIZE : 0] raddr, // LRAM * 2, be careful of size
        output reg [31:0] wrdata,
        output [2:0] state,
        output [2:0] n_state,
        output [31:0] c,
        output [31:0] ddd,
        output dval,
        output [31:0] a,
        output [31:0] d,
        output w,
        output [L_RAM_SIZE-1:0]  hh_addr
    );
    
    // register and wires for pe module !
    wire [31:0] ain, din;
    wire [L_RAM_SIZE-1:0]  addr;
    wire we_local;
    wire valid;
    wire dvalid;
    wire [31:0] dout;

    // global mem
    wire we_global;
    reg [31:0] gout;
    (* ram_style = "block" *) reg [31:0] peram [0: VECTOR_SIZE - 1];  // global register
    always @(posedge aclk)
        if(we_global) peram[addr] <= rddata;
        //else gout <= peram[addr];    
    
    // FSM
    parameter 	IDLE = 3'd0, INIT = 3'd1, LOAD = 3'd2, CALC = 3'd3, DONE = 3'd4;        
    wire load_done;
    wire calc_done;
    wire done_done;
    reg [2:0] present_state, next_state;
    
    assign state = present_state;
    assign n_state = next_state;
    
    // state shift
    always @(posedge aclk)
        if(!areset_n) present_state <= IDLE; else present_state <= next_state;    
    
    // state update
    always @(*)
        case(present_state)
            IDLE : if(start) next_state = LOAD; else next_state = present_state;
            LOAD : if(load_done) next_state = CALC; else next_state = present_state;
            CALC : if(calc_done) next_state = DONE ; else next_state = present_state;
            DONE : if(done_done) next_state = IDLE; else next_state = present_state;
        endcase
    
    // COUNTER -> implement only one counter ! -> zero is done.
            
    localparam count_load = 2 * 2 * VECTOR_SIZE - 1; // 
    localparam count_cal = VECTOR_SIZE * VECTOR_SIZE - 1;  // 16
    localparam count_done = 5; // 5
    reg [31:0] counter;
    assign c = counter;
    wire [31:0] counter_val = (next_state == LOAD) ? count_load 
    : (next_state == CALC) ?  count_cal 
    : (next_state == DONE) ? count_done 
    : 0;
    
    wire counter_start =  start || load_done || calc_done;
    wire counter_down = (present_state == LOAD) || (present_state == CALC) || (present_state == DONE);
    always @(posedge aclk) begin
        if(!areset_n) counter <= 'd0;
        else 
            if(counter_start) counter <= counter_val;
            else if(counter_down) counter <= counter-1;
    end

            
    assign load_done = (present_state == LOAD) && (counter == 'd0);
    assign calc_done = (present_state == CALC) && (counter == 'd0) && dvalid;
    assign done_done = (present_state == DONE) && (counter == 'd0);
    assign done = (present_state == DONE);
    
    // internal registers
    // 1) LOAD - global/local register -> we / addr setting, raddr, din
    assign we_local = ((present_state == LOAD) && counter[L_RAM_SIZE+1] && !counter[0]) ? 1'd1 : 1'd0;
    assign we_global = ((present_state == LOAD) && !counter[L_RAM_SIZE+1] && !counter[0]) ? 1'd1 : 1'd0;
    // ** IMPORTANT : LOAD : one cycle for read data , one cycle for write data. 
    // if counter[0] == 0 -> read && counter[0] == 1 -> write
    
    assign addr = (present_state == LOAD) ? counter[L_RAM_SIZE:1] : // applicable for both global, local RAM
    (present_state == CALC) ? counter[31:4] : 1'd0;
    
    // raddr : address for 2 RAMs
    assign raddr = (present_state == LOAD) ? counter[L_RAM_SIZE+1:1] : 1'd0;
    // din
    assign din = (present_state == LOAD) ? rddata : 1'd0;
    
    // 2) CALC
    assign ain = (present_state == CALC) ? peram[addr] : 1'd0;
    assign valid = (present_state == CALC) ? 1'd1 : 1'd0;
    
    // 3) DONE
    always @(posedge aclk)
        if (!areset_n)
                wrdata <= 'd0;
        else
            if (dvalid) wrdata <= dout;
            else wrdata <= wrdata;
            
    my_pe #(.L_RAM_SIZE(6)) mac(
    .aclk(aclk),
    .aresetn(areset_n),
    .ain(ain),
    .din(din),
    .addr(addr),
    .we(we_local),
    .valid(valid),
    .dvalid(dvalid),
    .dout(dout)
    );
    
    assign ddd = dout;
    assign dval = dvalid;
    assign a = ain;
    assign d = din;
    assign w = we_local;
    assign hh_addr = addr;
endmodule
