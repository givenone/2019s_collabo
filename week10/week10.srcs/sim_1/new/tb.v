module tb();

parameter L_RAM_SIZE = 6;
parameter VECTOR_SIZE = 16;
parameter MATRIX_SIZE = 4;
parameter CLK_PERIOD = 2;

reg aclk;
reg aresetn;
reg start;
reg [31:0] din;
wire done;
wire write;
wire [L_RAM_SIZE:0] rdaddr;
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
    #(CLK_PERIOD * 5);
    start = 0;
    
end

initial 
	$readmemh("input_1234.txt", din_mem);
        

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
    .wrdata(wrdata)
    );
endmodule