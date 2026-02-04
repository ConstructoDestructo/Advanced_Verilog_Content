`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2026 08:26:21 PM
// Design Name: 
// Module Name: mux_n_to_1_generic
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

//data_width used by the mux is aways defined by the largest width you wish to use
//M represents the argest data width in number of bits of course
//N represents the number of inputs into the Mux or the size of the mux (N to 1 MUX)

// Move the logic calculation into the parameter list so the ports can see it
module mux_n_to_1_generic #(
    parameter N = 2, 
    parameter M = 1,
    parameter SELECT_WIDTH = (N > 1) ? $clog2(N) : 1
)(
    output logic [M-1:0] mux_output,
    input  logic         enable,
    input  logic [M-1:0] data [N-1:0], // Properly declared unpacked array
    input  logic [SELECT_WIDTH-1:0] select
);

    always_comb begin
        if (enable) begin
            // You don't need a for-loop! 
            // This is the "General" way to index any size array.
            mux_output = data[select];
        end else begin
            // Use 0 for internal logic; only use 'z' if driving an external IC pin
            mux_output = '0; 
        end
    end
    
endmodule

