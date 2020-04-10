`timescale 1ns / 1ps


module tb_pe2();

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
        aresetn = 0;
        we = 1;
        valid = 0;

        #10;
        aresetn = 1;
        
        for(i = 0; i < 16; i = i + 1) begin
            din = $urandom%(2**31);
            addr = i;
            #10;
        end
        
        valid = 1;
        we = 0;
        
        for(i = 0; i < 16; i = i + 1) begin
            ain = $urandom%(2**31);
            addr = i;
            #160;
        end       
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
