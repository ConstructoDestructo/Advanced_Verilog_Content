`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2026 02:00:41 PM
// Design Name: 
// Module Name: tb_timer
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


`timescale 1ns/1ps

module tb_timer;
  logic clk;
  logic reset;
  logic clk_ms;

  // 100 MHz base clock
  localparam time CLK_PERIOD = 10ns;

  // Expected tick interval for a 1 ms tick output
  localparam time MS_TICK_PERIOD = 1ms;

  // Allow some slack for off-by-one counter designs
  localparam time TOL = 1 * CLK_PERIOD; // +/- 1 cycle tolerance

  // Clock gen
  initial clk = 1'b0;
  always #(CLK_PERIOD/2) clk = ~clk;

  // DUT instance
  ms_clock dut (
    .clk_ms (clk_ms),
    .clk    (clk),
    .reset  (reset)
  );

  // Reset + run control
  initial begin
    reset = 1'b1;
    repeat (5) @(posedge clk);   // hold reset for a few cycles
    reset = 1'b0;

    // Safety timeout in case clk_ms never ticks
    #(10*MS_TICK_PERIOD);
    $fatal(1, "TIMEOUT: clk_ms never produced enough ticks.");
  end


endmodule

