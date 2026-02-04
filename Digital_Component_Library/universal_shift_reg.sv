`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2026 09:52:30 PM
// Design Name: 
// Module Name: universal_shift_reg
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

module universal_shift_reg #(parameter N = 8)(
    output logic [(N-1):0] shift_reg_output,
    input logic clk, reset, enable,
    input logic [(N-1):0] shift_reg_input,
    input logic [1:0] select
);

    logic [N-1:0] r_next, r_reg;
    
    // 1. Create a 4-slot array (one for each Mux input)
    logic [N-1:0] mux_inputs [3:0];

    // 2. Instantiate the Memory (State)
    d_ff_async_reset_sync_enable #(.N(N)) dff (
        .d_ff_output(r_reg),
        .reset(reset),
        .clk(clk),
        .enable(enable),
        .data(r_next) // The output of the mux tells the DFF what to store next
    );

    // 3. Instantiate the Next-State Logic (Mux)
    mux_n_to_1_generic #(.N(4), .M(N)) mux1 (
        .mux_output(r_next),
        .enable(1'b1),        // Keep mux active
        .data(mux_inputs),   // Pass the array here
        .select(select)
    );

    // 4. Define the 4 possible "Next States"
    assign mux_inputs[0] = r_reg;                                     // No Change
    assign mux_inputs[1] = {r_reg[N-2:0], shift_reg_input[0]};        // Left Shift
    assign mux_inputs[2] = {shift_reg_input[N-1], r_reg[N-1:1]};      // Right Shift
    assign mux_inputs[3] = shift_reg_input;                           // Parallel Load

    // 5. Connect Output
    assign shift_reg_output = r_reg;

endmodule

