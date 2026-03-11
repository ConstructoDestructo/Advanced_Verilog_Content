`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2026 12:31:20 PM
// Design Name: 
// Module Name: timer_top
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


module timer_top(

output logic [3:0] LED,

input logic clk,
input logic reset,
input logic timer_run,
input logic [1:0] cs
    );
    
    logic read;
    logic write;
    logic clk_ms;
    logic en;
    logic [3:0] decoder_output;
    logic [31:0] rd_data[3:0];
    logic [31:0] wr_data;
    logic [4:0] addr;
    logic [1:0] cs_bus;
    
    blink blink1(
    .LED(LED),
    .read(read),
    .write(write),
    .wr_data(wr_data),
    .addr(addr),
    .clk(clk_ms),
    .reset(reset),
    .rd_data(rd_data),
    .timer_run(timer_run),
    .cs(cs),
    .cs_bus(cs_bus)
    );
    
    chu_timer t1
    (.clk(clk_ms),
     .reset(reset),
     .cs(decoder_output[0]),
     .read(read),
     .write(write),
     .addr(addr),
     .wr_data(wr_data),
     .rd_data(rd_data[0])
     );
     
    chu_timer t2
    (.clk(clk_ms),
     .reset(reset),
     .cs(decoder_output[1]),
     .read(read),
     .write(write),
     .addr(addr),
     .wr_data(wr_data),
     .rd_data(rd_data[1])
     );
     
    chu_timer t3
    (.clk(clk_ms),
     .reset(reset),
     .cs(decoder_output[2]),
     .read(read),
     .write(write),
     .addr(addr),
     .wr_data(wr_data),
     .rd_data(rd_data[2])
     );
     
    chu_timer t4
    (.clk(clk_ms),
     .reset(reset),
     .cs(decoder_output[3]),
     .read(read),
     .write(write),
     .addr(addr),
     .wr_data(wr_data),
     .rd_data(rd_data[3])
     );
     
     dec2to4 dec1
     (.en(en),
      .sel(cs_bus),
      .y(decoder_output)
     );
     
     ms_clock clk1
     (.clk_ms(clk_ms),
      .clk(clk),
      .reset(reset)
     );
     
   assign en = 1'b1;
   
endmodule






// 2-to-4 decoder (behavioral)
// One-hot output: y[sel] = 1 when en=1, otherwise all zeros.
module dec2to4 (
  input  logic       en,
  input  logic [1:0] sel,
  output logic [3:0] y
);

  always_comb begin
    y = 4'b0000;
    if (en) begin
      unique case (sel)
        2'b00: y = 4'b0001;
        2'b01: y = 4'b0010;
        2'b10: y = 4'b0100;
        2'b11: y = 4'b1000;
        default: y = 4'b0000; // defensive; sel is 2-bit so this won't occur
      endcase
    end
  end
endmodule

module ms_clock(
output logic clk_ms,
input logic clk,
input logic reset
);

logic [15:0] toggle_count;

always_ff @(posedge clk,posedge reset)
begin

if(reset)
begin
    clk_ms <= 0;
    toggle_count <= 0;
end
else if(toggle_count == 49999)
begin
    clk_ms <= ~clk_ms;
    toggle_count <= 0;
end
else
    toggle_count <= toggle_count + 1;
end

endmodule

module write_control(
  output logic [31:0] wr_data,
  output logic        read,
  output logic        write,
  output logic [4:0]  addr,

  // IMPORTANT: this is the select that should drive your 2->4 decoder,
  // not the raw user cs, so clears go to the correct timer.
  output logic [1:0]  cs_bus,

  input  logic        timer_run,
  input  logic [1:0]  cs_user,

  // internal "overflow" info coming from blink (hit detect)
  input  logic        overflow_any,
  input  logic [1:0]  overflow_id,

  input  logic        clk_ms,
  input  logic        reset
);

  // chu_timer control register address (addr[1:0] == 2'b10)
  localparam logic [4:0] CTRL_ADDR = 5'b00010;

  // rising-edge detect for timer_run (so holding the button doesn't spam writes)
  logic timer_run_d;
  always_ff @(posedge clk_ms or posedge reset) begin
    if (reset) timer_run_d <= 1'b0;
    else       timer_run_d <= timer_run;
  end
  wire run_pulse = timer_run && !timer_run_d;

  // defaults
  always_comb begin
    addr    = CTRL_ADDR;
    read    = 1'b1;

    // default: no write, follow user selection
    write   = 1'b0;
    wr_data = 32'h0000_0000;
    cs_bus  = cs_user;

    // Priority 1: clear the timer that hit its threshold
    if (overflow_any) begin
      cs_bus  = overflow_id;       // target the timer that hit
      write   = 1'b1;
      wr_data = 32'h0000_0003;      // bit1=clear pulse (no memory)
    end
    // Priority 2: start/enable the user-selected timer
    else if (run_pulse) begin
      cs_bus  = cs_user;           // target selected timer
      write   = 1'b1;
      wr_data = 32'h0000_0001;     // bit0=go=1 (latched in ctrl_reg)
    end
  end

endmodule

module blink(
  output logic [3:0]  LED,
  output logic        read,
  output logic        write,
  output logic [31:0] wr_data,
  output logic [4:0]  addr,
  output logic [1:0] cs_bus,

  input  logic        clk,
  input  logic        reset,
  input  logic [31:0] rd_data [3:0],
  input  logic        timer_run,
  input  logic [1:0]  cs
);

  // ------------------------------------------------------------
  // Thresholds (edit these instead of hardcoding literals)
  // ------------------------------------------------------------
  localparam logic [31:0] TH0 = 32'd5000;
  localparam logic [31:0] TH1 = 32'd2000;
  localparam logic [31:0] TH2 = 32'd1000;
  localparam logic [31:0] TH3 = 32'd500;

  // per-timer threshold hits
  logic hit0, hit1, hit2, hit3;

  assign hit0 = (rd_data[0] == TH0);
  assign hit1 = (rd_data[1] == TH1);
  assign hit2 = (rd_data[2] == TH2);
  assign hit3 = (rd_data[3] == TH3);

  // INTERNAL "overflow" info for write_control (NOT ports)
  logic       overflow_any;
  logic [1:0] overflow_id;

  // Toggle LEDs (allow multiple toggles per cycle)
  always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
      LED <= 4'b0000;
    end else begin
      if (hit0) LED[0] <= ~LED[0];
      if (hit1) LED[1] <= ~LED[1];
      if (hit2) LED[2] <= ~LED[2];
      if (hit3) LED[3] <= ~LED[3];
    end
  end

  // Encode "someone hit" + "who should be cleared"
  // (Only one timer can be cleared per cycle anyway, so pick one with priority.)
  always_comb begin
    overflow_any = hit0 | hit1 | hit2 | hit3;

    if (hit0)       overflow_id = 2'd0;
    else if (hit1)  overflow_id = 2'd1;
    else if (hit2)  overflow_id = 2'd2;
    else            overflow_id = 2'd3; // only meaningful when overflow_any=1
  end

  // write_control consumes the internal overflow signals
  write_control wc1(
    .wr_data      (wr_data),
    .read         (read),
    .write        (write),
    .addr         (addr),

    .timer_run    (timer_run),
    .cs_user      (cs),
    .cs_bus(cs_bus),
    
    .overflow_any (overflow_any),
    .overflow_id  (overflow_id),

    .clk_ms       (clk),
    .reset        (reset)
  );

endmodule