`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2026 03:12:00 PM
// Design Name: 
// Module Name: seven_seg_counter
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

// this design should count at 1Hz and in decimal on a 7 segment display (BCD counter)
module seven_seg_counter #(parameter freq = 100_000_000)(
    input logic clk,
    input logic reset,
    output logic [6:0] seg,
    output logic [3:0] an
    );
    
    // enable generator
    logic enable;
    logic [31:0] count;
    
    always_ff @(posedge clk) begin
        if (reset) begin 
            count <= 0;
            enable <= 0;
        end else if (count == freq - 1) begin
            count <= 0;
            enable <= 1'b1;
        end else begin
            count <= count + 1;
            enable <= 1'b0;
        end
    end
    
    // counter
    logic [3:0] counter;
    always_ff @(posedge clk) begin
        if (reset) 
            counter <= 0;
        else if (enable) begin
            if (counter == 9) 
                counter <= 0;
            else 
                counter <= counter + 1;
        end
    end
    
    
    
    // mapping to display 
    // seg patterns appropriately map onto basys 3 display
    always_comb begin
        case (counter)
            4'd0: begin
                seg = 7'b0000001;
                an = 4'b1110;
            end
            4'd1: begin
                seg = 7'b1001111;
                an = 4'b1110;
            end
            4'd2: begin
                seg = 7'b0010010;
                an = 4'b1110;
            end
            4'd3: begin
                seg = 7'b0000110;
                an = 4'b1110;
            end
            4'd4: begin
                seg = 7'b1001100;
                an = 4'b1110;
            end
            4'd5: begin
                seg = 7'b0100100;
                an = 4'b1110;
            end
            4'd6: begin
                seg = 7'b0100000;
                an = 4'b1110;
            end
            4'd7: begin
                seg = 7'b0001111;
                an = 4'b1110;
            end
            4'd8: begin
                seg = 7'b0000000;
                an = 4'b1110;
            end
            4'd9: begin
                seg = 7'b0000100;
                an = 4'b1110;
            end
            default: begin
                seg = 7'b1111111;
                an = 4'b1110;
            end
        endcase
    end
    
endmodule
