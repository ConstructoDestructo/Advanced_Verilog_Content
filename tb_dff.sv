`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2026 07:55:20 PM
// Design Name: 
// Module Name: tb_dff
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


module tb_dff();

localparam CLOCK_PERIOD = 10; //10 time units

logic clk;

logic d_ff_output;
logic reset,clk,enable;
logic data;
 
d_ff_async_reset_sync_enable #(.N(1'b1)) dff1(.*);

always #(CLOCK_PERIOD/2) clk = ~clk;

initial
begin
clk = 0;
reset = 1;
enable = 0;
data = 1'b1;

#10 
reset = 0;
enable = 1;
data = 1'b0;

#10 data = 1'b1;
#10 data = 1'b0;
end
endmodule
