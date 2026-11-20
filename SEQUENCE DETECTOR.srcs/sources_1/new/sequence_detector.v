`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.09.2026 19:59:00
// Design Name: 
// Module Name: sequence_detector
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

module programmable_sequence_detector (
    input clk,
    input reset,
    input serial_in,
    input [3:0] pattern_in,
    input load_pattern,
    output reg detected
);

    reg [3:0] pattern_reg;
    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0000;
            shift_reg   <= 4'b0000;
            detected    <= 1'b0;
        end
        else begin
            detected <= 1'b0;

            // Load a new sequence pattern
            if (load_pattern) begin
                pattern_reg <= pattern_in;
                shift_reg   <= 4'b0000;
            end
            else begin
                // Shift incoming serial bit
                shift_reg <= {shift_reg[2:0], serial_in};

                // Check whether received bits match the pattern
                if ({shift_reg[2:0], serial_in} == pattern_reg)
                    detected <= 1'b1;
            end
        end
    end

endmodule

 
