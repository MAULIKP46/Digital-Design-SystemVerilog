//--------------------------------------------------------------
// Project : 101 Non-Overlapping Sequence Detector
// Type    : Moore Finite State Machine (FSM)
// Language: SystemVerilog
//
// Description:
// Detects the input sequence "101".
// The output is asserted for one clock cycle after the
// complete sequence is detected.
// Uses an asynchronous active-high reset.
//--------------------------------------------------------------

module sequence_detector_101_non_overlapping (
    input  logic clk,
    input  logic reset,
    input  logic in,
    output logic out
);

    //----------------------------------------------------------
    // State Declaration
    //----------------------------------------------------------
    typedef enum logic [1:0] {
        S0,     // No bits matched
        S1,     // Matched "1"
        S2,     // Matched "10"
        S3      // Matched "101" (Detection State)
    } state_t;

    state_t present, next;

    //----------------------------------------------------------
    // State Register
    //----------------------------------------------------------
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            present <= S0;
        else
            present <= next;
    end

    //----------------------------------------------------------
    // Next-State Logic
    //----------------------------------------------------------
    always_comb begin
        case (present)

            // Initial State
            S0: begin
                if (in)
                    next = S1;
                else
                    next = S0;
            end

            // Matched "1"
            S1: begin
                if (in)
                    next = S0;
                else
                    next = S2;
            end

            // Matched "10"
            S2: begin
                if (in)
                    next = S3;
                else
                    next = S0;
            end

            // Sequence Detected
            S3: begin
                next = S0;
            end

            default: begin
                next = S0;
            end

        endcase
    end

    //----------------------------------------------------------
    // Output Logic (Moore FSM)
    //----------------------------------------------------------
    always_comb begin
        case (present)

            S0: out = 1'b0;
            S1: out = 1'b0;
            S2: out = 1'b0;
            S3: out = 1'b1;

            default: out = 1'b0;

        endcase
    end

endmodule
