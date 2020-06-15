module tb();

parameter L_RAM_SIZE = 3;
parameter VECTOR_SIZE = 8;
parameter MATRIX_SIZE = 8;
parameter CLK_PERIOD = 2;

reg aclk;
reg aresetn;
reg start;
reg [31:0] din;

wire [31:0] temp_addr;
wire [31:0] temp_index;
wire we_global;


wire done;
wire write;
wire [31:0] rdaddr;
wire [31:0] wrdata;
//input data 
reg [31:0] din_mem [(MATRIX_SIZE+1) * VECTOR_SIZE -1:0];




integer i;
initial begin
    aclk <= 1;
    start <= 0;
    aresetn <= 1;
    
    #(CLK_PERIOD*5);
    aresetn<=0;

    #(CLK_PERIOD*5);
    aresetn<=1;
    
    #(CLK_PERIOD*5);
    start = 1;


// test for multiple times.
   
end

initial 
	$readmemh("input_64.txt", din_mem);
/*
always @(negedge done) begin
    #(CLK_PERIOD*5);
    aresetn<=0;

    #(CLK_PERIOD*5);
    aresetn<=1;
    
    #(CLK_PERIOD*5);
    start = 1;

    
    end

 */

always @(*) 
    din <= din_mem[rdaddr];

always #(CLK_PERIOD/2) aclk = ~aclk;

pe_controller #(.MATRIX_SIZE(MATRIX_SIZE), .VECTOR_SIZE(VECTOR_SIZE), .L_RAM_SIZE(L_RAM_SIZE)) UUT(
    .start(start),
    .aclk(aclk),
    .areset_n(aresetn),
    .rddata(din),
    .done(done),
    .write(write),
    .raddr(rdaddr),
    .wrdata(wrdata),
    
    .temp_addr(temp_addr),
    .temp_index(temp_index),
    .we_globall(we_global)
    );
endmodule