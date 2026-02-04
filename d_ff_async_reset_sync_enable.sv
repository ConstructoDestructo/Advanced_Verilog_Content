`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2026 07:43:22 PM
// Design Name: 
// Module Name: d_ff_async_reset_sync_enable
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//N represents the number of bits to be stored
module d_ff_async_reset_sync_enable #(parameter N = 1)(
output logic [(N-1):0] d_ff_output,
input logic reset,clk,enable,
input logic [(N-1):0] data 
    );
    
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            d_ff_output <= 1'b0;
        else if(enable)
            d_ff_output <= data;
    end
endmodule
