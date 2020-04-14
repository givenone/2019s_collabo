`timescale 1ns / 1ps
module temp;
    parameter L_RAM_SIZE = 6;
    
    reg aclk;
    reg aresetn;
    // port A
    reg [31:0] ain;
    // peram -> port B 
    reg [31:0] din;
    reg [L_RAM_SIZE-1:0]  addr;
    reg we;
    // integrated valid signal -> for input ready..
    reg valid;
    // computation result

    wire dvalid;
    wire [31:0] dout;
    integer i;

    initial begin 
        aclk <= 1;
        aresetn = 0;
        valid = 0;
        #10;
        
// Load matrix to local register
        aresetn = 1; // negative reset
        we = 1;

        for(i=0; i<16; i=i+1) begin
            din = $urandom%(2**31);
            addr = i;
            #10; // TODO :: delay control !
        end
// MAC 
        valid = 1;
        we = 0;
        for(i=0; i<16; i=i+1) begin
            ain = $urandom%(2**31);
            addr = i;
            #160; // TODO :: delay control for MAC -> use valid signal?
        end
    end
    
    always #5 aclk = ~aclk;
    
    my_pe #(.L_RAM_SIZE(6)) mac(
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