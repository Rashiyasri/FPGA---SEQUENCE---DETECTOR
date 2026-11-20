`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.09.2026 20:00:19
// Design Name: 
// Module Name: tb_sequence_detector
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

module tb_programmable_sequence_detector;

    reg clk;
    reg reset;
    reg serial_in;
    reg [3:0] pattern_in;
    reg load_pattern;

    wire detected;

    integer errors;

    // Connect main module with testbench
    programmable_sequence_detector dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .pattern_in(pattern_in),
        .load_pattern(load_pattern),
        .detected(detected)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    // Task to load pattern
    task program_pattern;
        input [3:0] new_pattern;
        begin
            @(negedge clk);
            pattern_in = new_pattern;
            load_pattern = 1'b1;

            @(negedge clk);
            load_pattern = 1'b0;
        end
    endtask

    // Task to send one serial bit and check output
    task send_bit;
        input data_bit;
        input expected_detect;
        begin
            @(negedge clk);
            serial_in = data_bit;

            @(posedge clk);
            #1;

            if (detected !== expected_detect) begin
                $display("ERROR: detected=%b expected=%b",
                         detected, expected_detect);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        // Initial values
        clk = 0;
        reset = 1;
        serial_in = 0;
        pattern_in = 4'b0000;
        load_pattern = 0;
        errors = 0;

        // Reset
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 0;

        // Test 1: Program 1011
        program_pattern(4'b1011);

        // Send 1 0 1 1
        send_bit(1'b1, 1'b0);
        send_bit(1'b0, 1'b0);
        send_bit(1'b1, 1'b0);
        send_bit(1'b1, 1'b1);  // Pattern 1011 detected

        // Test 2: Change pattern dynamically to 0110
        program_pattern(4'b0110);

        // Send 0 1 1 0
        send_bit(1'b0, 1'b0);
        send_bit(1'b1, 1'b0);
        send_bit(1'b1, 1'b0);
        send_bit(1'b0, 1'b1);  // Pattern 0110 detected

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TEST FAILED");

        #20;
        $finish;
    end

endmodule


