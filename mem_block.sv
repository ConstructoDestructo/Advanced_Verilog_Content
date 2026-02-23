`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2022 07:29:58 PM
// Design Name: 
// Module Name: mem_block
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


module mem_block(
    input logic clk, 
    input logic we, //write enable
    input logic [11:0] addr,
    input logic [3:0] din,
    output logic [3:0] dout
    );
    
    // TODO: Write your code here 
    // DO NOT CHANGE THE MODULE INTERFACE
    
    logic [10:0] bram_addr;
    logic [1:0] demux_select;
    
    bram_simple_synch_dual_port #(.ADDR_WIDTH(11), .DATA_WIDTH(4)) bram1
    (
        .clk(clk),
        .we(we),
        .addr_r(bram_addr),
        .addr_w(bram_addr),        
        .din(din),       
        .dout(dout)
    );
    
        bram_simple_synch_dual_port #(.ADDR_WIDTH(11), .DATA_WIDTH(4)) bram2
    (
        .clk(clk),
        .we(we),
        .addr_r(bram_addr),
        .addr_w(bram_addr),        
        .din(din),       
        .dout(dout)
    );
    
        bram_simple_synch_dual_port #(.ADDR_WIDTH(11), .DATA_WIDTH(4)) bram3
    (
        .clk(clk),
        .we(we),
        .addr_r(bram_addr),
        .addr_w(bram_addr),        
        .din(din),       
        .dout(dout)
    );
    
        bram_simple_synch_dual_port #(.ADDR_WIDTH(11), .DATA_WIDTH(4)) bram4
    (
        .clk(clk),
        .we(we),
        .addr_r(bram_addr),
        .addr_w(bram_addr),        
        .din(din),       
        .dout(dout)
    );
    
    private_tool pt1
    (
        .demux_select(demux_select),
        .addr(addr),
        .bram_addr(bram_addr)
     );
    
    assign demux_select[1] = addr[11];
    assign demux_select[0] = addr[10];
    
endmodule

module private_tool(
    input logic [1:0] demux_select,
    input logic [11:0] addr,
    output logic [10:0] bram_addr
);

always_comb
begin
    if(demux_select == 0)
        bram_addr = {demux_select[0],addr[9],addr[8],addr[7],addr[6],addr[5],addr[4],addr[3],addr[2],addr[1],addr[0]};
    else if(demux_select == 1)
        bram_addr = {demux_select[0],addr[9],addr[8],addr[7],addr[6],addr[5],addr[4],addr[3],addr[2],addr[1],addr[0]};
    else if(demux_select == 2)
        bram_addr = {demux_select[0],addr[9],addr[8],addr[7],addr[6],addr[5],addr[4],addr[3],addr[2],addr[1],addr[0]};
    else if(demux_select == 3)
        bram_addr = {demux_select[0],addr[9],addr[8],addr[7],addr[6],addr[5],addr[4],addr[3],addr[2],addr[1],addr[0]};
end

endmodule