`timescale 1ns / 1ps

module pe_controller #(
        parameter VECTOR_SIZE = 16,
        parameter MATRIX_SIZE = 16, 
        parameter L_RAM_SIZE = 4
        )
    (
        input start,
        input aclk,
        input areset_n,
        input [31:0] rddata,
        output done,
        output write,
        output [31 : 0] raddr, // LRAM * 2, be careful of size
        output [31:0] wrdata,
        
        output [31:0] temp_addr,
        output [31:0] temp_index,
        
        output we_globall
    );
    assign temp_addr = addr;
    assign temp_index = index;
    assign we_globall = we_global;
    // register and wires for pe module !
    wire [31:0] din;
    wire [31:0] ain [0 : MATRIX_SIZE-1];
    wire [31:0]  addr;
    wire we_local;
    wire valid;
    wire dvalid;
    wire [31:0] dout [0 : MATRIX_SIZE-1];
    wire [31:0] answer [0 : MATRIX_SIZE - 1];

    // global mem
    wire we_global;
    wire [31 : 0] index;
    (* ram_style = "block" *) reg [31:0] pram [0 : MATRIX_SIZE-1] [0: VECTOR_SIZE - 1];  // global register
    always @(negedge aclk)
        if(we_global) pram[index][addr] <= din;
    
    // FSM
    parameter 	IDLE = 3'd0, WRITE = 3'd1, LOAD = 3'd2, CALC = 3'd3, DONE = 3'd4, WAIT = 3'd5;        
    wire load_done;
    wire calc_done;
    wire done_done;
    wire write_done;
    wire wait_done;
    reg [2:0] present_state, next_state;

    
    // state shift
    always @(posedge aclk)
        if(!areset_n) present_state <= IDLE; else present_state <= next_state;    
    
    // state update
    always @(*)
        case(present_state)
            IDLE : if(start) next_state = WAIT; else next_state = present_state;
            WAIT : if(wait_done) next_state = LOAD; else next_state = present_state;
            LOAD : if(load_done) next_state = CALC; else next_state = present_state;
            CALC : if(calc_done) next_state = WRITE ; else next_state = present_state;
            WRITE : if(write_done) next_state = DONE ; else next_state = present_state;
            DONE : if(done_done) next_state = IDLE; else next_state = present_state;
        endcase
    
    // COUNTER -> implement only one counter ! -> zero is done.
            
    localparam count_load = 2 * (MATRIX_SIZE + 1) * VECTOR_SIZE - 1; // 2 for memory load, M * V + V
    localparam count_cal = VECTOR_SIZE * 16 - 1;  // 16 : ip latency
    localparam count_write = MATRIX_SIZE - 1 ; // 1 buffer for storing data.
    localparam count_done = 5; // 5
    localparam count_wait = 3; // 2 cycles for initial waiting.
    reg [31:0] counter;

    wire [31:0] counter_val = (next_state == LOAD) ? count_load 
    : (next_state == WAIT) ?  count_wait
    : (next_state == CALC) ?  count_cal
    : (next_state == WRITE) ? count_write 
    : (next_state == DONE) ? count_done 
    : 0;
    wire idle_done;
    assign idle_done =  (present_state == IDLE) && (next_state == WAIT);
    
    wire counter_start =  idle_done || wait_done || load_done || calc_done || write_done;
    wire counter_down = (present_state == WAIT) || (present_state == LOAD) || (present_state == CALC) || (present_state == WRITE) ||  (present_state == DONE);
    always @(posedge aclk) begin
        if(!areset_n) counter <= 'd0;
        else 
            if(counter_start) counter <= counter_val;
            else if(counter_down) counter <= counter-1;
    end
    
    assign wait_done = (present_state == WAIT) && (counter == 'd0);        
    assign load_done = (present_state == LOAD) && (counter == 'd0);
    assign calc_done = (present_state == CALC) && (counter == 'd0) && dvalid;
    assign write_done = (present_state == WRITE) && (counter == 'd0);
    assign done_done = (present_state == DONE) && (counter == 'd0);
    assign done = (present_state == DONE);
    assign write = (present_state == WRITE);
    
    
    // internal registers
    // 1) LOAD - global/local register -> we / addr setting, raddr, din
    // ** caution forequality
    assign we_local = ((present_state == LOAD) && counter > (count_load - 2 * VECTOR_SIZE) && counter[0])  ? 1'd1 : 1'd0; // first row
    assign we_global = ((present_state == LOAD) && counter <= (count_load - 2 * VECTOR_SIZE) && counter[0]) ? 1'd1 : 1'd0;  // second - last row
    
    // ** IMPORTANT : LOAD : one cycle for read data , one cycle for write data. 
    // if counter[0] == 0 -> read && counter[0] == 1 -> write
    
    assign addr = (present_state == LOAD) ? (counter / 2) % VECTOR_SIZE : // applicable for both global, local RAM
    (present_state == CALC) ? counter / 16 : 1'd0; //counter[31:4] : 1'd0;
    // addr only indicate address among vecotor
    
   
    assign index = (present_state == LOAD) ? (counter / 2) / VECTOR_SIZE :
    (present_state == WRITE) ? counter : 1'd0;
    // index of pe module (matrix row)
    
    
    // raddr : address for 2 RAMs
    assign raddr = (present_state == WAIT) ? 1'd0 :
    (present_state == LOAD) ? (MATRIX_SIZE + 1) * VECTOR_SIZE - (counter/2) :  // indicate address. just din in real situation. // (+1 than simple case.)
    (present_state == WRITE) ? count_write - counter : 1'd0;
    // din
    
    assign din = (present_state == LOAD) ? rddata : 1'd0;
    
    // 2) CALC
//    assign ain = (present_state == CALC) ? peram[addr] : 1'd0;
    genvar i;        
    generate        
        for (i = 0; i < MATRIX_SIZE ; i=i+1)         
          assign ain[i] =  (present_state == CALC) ? pram[i][addr] : 1'd0;       
    endgenerate 

    assign valid = (present_state == CALC) ? 1'd1 : 1'd0;
    
    // 3) WRITE
    // assign to wrdata sequentially.

    genvar j;        
    generate        
        for (j = 0; j < MATRIX_SIZE ; j=j+1)         
          assign answer[j] = (dvalid) ? dout[j] : answer[j];       
    endgenerate
    
    assign wrdata = (present_state == WRITE) ? answer[index] : 1'd0;

    // 4) DONE
    //assign wrdata = (done) ? dout : 'd0;


    wire [MATRIX_SIZE-1 :0] dvalid_array;
    assign dvalid = dvalid_array[0];

    wire re;
    assign re = ~(present_state == WAIT);
    genvar k;
    generate 
        for(k = 0; k < MATRIX_SIZE; k=k+1) begin
              my_pe #(.VECTOR_SIZE(VECTOR_SIZE)) mac(
                .aclk(aclk),
                .aresetn(re),
                .ain(ain[k]),
                .din(din),
                .addr(addr),
                .we(we_local),
                .valid(valid),
                .dvalid(dvalid_array[k]),
                .dout(dout[k])
                );
          end
     endgenerate

       
endmodule