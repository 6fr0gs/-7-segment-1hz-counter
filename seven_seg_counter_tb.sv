`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2026 10:10:50 PM
// Design Name: 
// Module Name: seven_seg_counter_tb
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

module seven_seg_counter_tb;
   
    logic clk;
    logic reset;
    logic [6:0] seg;
    
    logic [3:0] true_counter;
    logic signed [31:0] error_count = 0;

    seven_seg_counter #(.freq(10)) u0(
        .clk(clk),
        .reset(reset),
        .seg(seg)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    // Self checking
    logic check_flag;
    initial begin
        check_flag = 0;
        clk = 0;
        reset = 1;
       
        repeat (5) @(posedge clk);
        reset <= 0;
        
        @(posedge clk);
        check_flag  <= 1;
        true_counter <= 0;
    end    
    
            
    // initialize true_count @ 0 and counter of DUT
    always_ff @(posedge clk) begin
        if (check_flag && u0.enable) begin
            if (true_counter == u0.counter) begin
                $display("@%t: counter is correctly at %d", $time, true_counter);
                if (true_counter == 9)
                    true_counter <= 0;
                else
                    true_counter = true_counter + 1;
            end else begin
                $error("@%t: counter is at %d when it should be at %d.", $time, u0.counter, true_counter);
                error_count++;
            end
        end
    end
        
   // test passed or failed
   initial begin 
   #5000
   if (error_count > 0)
       $display("TESTBENCH FAIL: %d ERRORS DETECTED", error_count);
   else if (error_count == 0)
       $display("TESTBENCH SUCCESSFUL");
   $finish;
   end
    
endmodule
