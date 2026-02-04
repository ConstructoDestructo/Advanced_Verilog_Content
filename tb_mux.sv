`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2026 09:12:56 PM
// Design Name: 
// Module Name: tb_mux
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

logic [7:0] mux_output;
logic enable;
logic [7:0] data [3:0];
logic [2:0] select;



mux_n_to_1_generic #(.N(4),.M(8)) mux1(.*);
    
    initial
    begin
        
        enable = 0;
        data[0] = 0;
        data[1] = 1;
        data[2] = 0;
        data[3] = 1;
        select = 0;
        
        #10 
        enable = 1;
        select = 0;      
          
        #10 
        select = 1;   
        
                #10 
        select = 2;
        
                #10 
        select = 3;
        
                #10 
        data[0] = 1;
        data[1] = 0;
        data[2] = 1;
        data[3] = 0;
        select = 0;
        
                #10 
        select = 1;
        
                #10 
        select = 2;
        
                #10 
        select = 3;
    end
    
endmodule
