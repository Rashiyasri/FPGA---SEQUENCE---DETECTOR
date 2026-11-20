module programmable_sequence_detector (
    input        clk,
    input        reset,
    input        pattern_load,
    input  [3:0] pattern_in,
    input        serial_in,
    output reg   match
);

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] shift_reg;

    localparam S0 = 2'b00,
               S1 = 2'b01,
               S2 = 2'b10,
               S3 = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state       <= S0;
            pattern_reg <= 4'b0000;
            shift_reg   <= 4'b0000;
            match       <= 1'b0;
        end
        else begin
            match <= 1'b0;

            if (pattern_load)
                pattern_reg <= pattern_in;

            case (state)
                S0: begin
                    shift_reg <= {shift_reg[2:0], serial_in};
                    state     <= S1;
                end

                S1: begin
                    shift_reg <= {shift_reg[2:0], serial_in};
                    state     <= S2;
                end

                S2: begin
                    shift_reg <= {shift_reg[2:0], serial_in};
                    state     <= S3;
                end

                S3: begin
                    shift_reg <= {shift_reg[2:0], serial_in};
                    match     <= ({shift_reg[2:0], serial_in} == pattern_reg);
                    state     <= S0;
                end

                default: begin
                    state     <= S0;
                    shift_reg <= 4'b0000;
                end
            endcase
        end
    end

endmodule