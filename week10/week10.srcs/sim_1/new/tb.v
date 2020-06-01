module tb();

parameter L_RAM_SIZE = 4;
parameter CLK_PERIOD = 2;

reg aclk;
reg aresetn;
reg start;
reg [31:0] din;
wire done;
wire [L_RAM_SIZE:0] rdaddr;
wire [31:0] wrdata;
//input data 
reg [31:0] din_mem [2**(L_RAM_SIZE+1)-1:0];

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
	$readmemh("input.txt", din_mem);
        

always @(posedge aclk) 
    din <= din_mem[rdaddr];

always #(CLK_PERIOD/2) aclk = ~aclk;

pe_controller #(2**L_RAM_SIZE,L_RAM_SIZE) UUT(
    .start(start),
    .aclk(aclk),
    .areset_n(aresetn),
    .rddata(din),
    .done(done),
    .raddr(rdaddr),
    .wrdata(wrdata)
    );
endmodule