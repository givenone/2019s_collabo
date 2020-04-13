`timescale 1ns / 1ps

module my_pe #(
        parameter L_RAM_SIZE = 6
    )
    (
        // clk/reset
        input aclk,
        input aresetn,
        // port A
        input [31:0] ain,
        // peram -> port B 
        input [31:0] din,
        input [L_RAM_SIZE-1:0]  addr,
        input we,
        // integrated valid signal
        input valid,
        // computation result
        output dvalid,
        output [31:0] dout
    );

   (* ram_style = "block" *) reg [31:0] peram [0:2**L_RAM_SIZE - 1];  // local register

 

endmodule  

