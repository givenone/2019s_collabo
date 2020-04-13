`timescale 1ns / 1ps


module tb_pe();

parameter L_RAM_SIZE = 6;

    reg aclk;
    reg aresetn;
    reg [31:0] ain;
    reg [31:0] din;
    reg [L_RAM_SIZE-1:0] addr;
    reg we;
    reg valid;
    wire dvalid;
    wire [31:0] dout;
   
    integer i;
   
    initial begin
        aclk <= 1;
        we = 1;
        valid = 0;
        aresetn = 0;
        #10;
        aresetn = 1;
       
        for(i = 0; i < 16; i = i + 1) begin
            din = $urandom%(32'h3f800000);
            addr = i;
            #10;
        end
       
        valid = 1;
        we = 0;
       
        for(i = 0; i < 16; i = i + 1) begin
            ain = $urandom%(32'h3f800000);
            addr = i;
            #160;
        end
        
        valid = 0;      
    end
   
    always #5 aclk = ~aclk;

    my_pe #(6) UUT (
        .aclk(aclk),
        .aresetn(aresetn),
        .ain(ain),
        .din(din),
        .addr(addr),
        .we(we),
        .valid(valid),
        .dvalid(dvalid),
        .dout(dout)
    );

endmodule
