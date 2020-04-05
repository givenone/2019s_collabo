`timescale 1ns / 1ps

module tb_multadd();
    reg [32-1:0] ain;
    reg [32-1:0] bin;
    reg [32-1:0] cin;
    reg rst;
    reg clk;
    wire [64-1:0] res;
    
    integer i;
    
    initial begin
        clk <= 0;
        rst <= 0;
        for(i = 0; i < 32; i = i + 1) begin
            ain = $urandom%(2**31);
            bin = $urandom%(2**31);
            cin = $urandom%(2**31);
            #20;
        end
    end
    
    always #5 clk = ~clk;
    
    xbip_multadd_0 UUT(
        .a(ain),
        .b(bin),
        .c(cin),
        .clk(clk),
        .sclr(rst),
        .ce(1'b1),
        .p(res),
        .subtract(1'b0)
    );
endmodule
