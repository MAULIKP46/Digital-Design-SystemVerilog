`timescale 1s/100ms

//==============================================================================
// Module : Traffic Signal Controller
// Author : Maulik Parasramka
//
// Description:
// Moore FSM implementation of a fixed-time two-road traffic signal controller.
//
// State Sequence:
//   NS_GREEN  -> NS_YELLOW -> EW_GREEN -> EW_YELLOW -> NS_GREEN
//
// Features:
// - Moore FSM
// - Synchronous reset
// - Internal timer-based state transitions
// - Separate state register, timer, next-state logic, and output logic
//==============================================================================

module traffic_signal (
    input  logic clk,
    input  logic rst,

    output logic ns_red,
    output logic ns_yellow,
    output logic ns_green,

    output logic ew_red,
    output logic ew_yellow,
    output logic ew_green
);

    //--------------------------------------------------------------------------
    // Traffic signal timing (clock cycles)
    //--------------------------------------------------------------------------

    localparam int GREEN_TIME  = 100;
    localparam int YELLOW_TIME = 20;

    //--------------------------------------------------------------------------
    // Internal timer
    //--------------------------------------------------------------------------

    logic [7:0] counter;

    //--------------------------------------------------------------------------
    // FSM State Encoding
    //--------------------------------------------------------------------------

    typedef enum logic [1:0] {
        NS_GREEN  = 2'b00,
        NS_YELLOW = 2'b01,
        EW_GREEN  = 2'b10,
        EW_YELLOW = 2'b11
    } state_t;

    state_t state, next_state;

    //--------------------------------------------------------------------------
    // State Register
    //--------------------------------------------------------------------------

    always_ff @(posedge clk) begin
        if (rst)
            state <= NS_GREEN;
        else
            state <= next_state;
    end

    //--------------------------------------------------------------------------
    // Timer Counter
    //--------------------------------------------------------------------------

    always_ff @(posedge clk) begin
        if (rst)
            counter <= 0;

        else if (
            (state == NS_GREEN  && counter == GREEN_TIME ) ||
            (state == NS_YELLOW && counter == YELLOW_TIME) ||
            (state == EW_GREEN  && counter == GREEN_TIME ) ||
            (state == EW_YELLOW && counter == YELLOW_TIME)
        )
            counter <= 0;

        else
            counter <= counter + 1;
    end

    //--------------------------------------------------------------------------
    // Next-State Logic
    //--------------------------------------------------------------------------

    always_comb begin
        case (state)

            NS_GREEN: begin
                if (counter == GREEN_TIME)
                    next_state = NS_YELLOW;
                else
                    next_state = NS_GREEN;
            end

            NS_YELLOW: begin
                if (counter == YELLOW_TIME)
                    next_state = EW_GREEN;
                else
                    next_state = NS_YELLOW;
            end

            EW_GREEN: begin
                if (counter == GREEN_TIME)
                    next_state = EW_YELLOW;
                else
                    next_state = EW_GREEN;
            end

            EW_YELLOW: begin
                if (counter == YELLOW_TIME)
                    next_state = NS_GREEN;
                else
                    next_state = EW_YELLOW;
            end

            default:
                next_state = NS_GREEN;

        endcase
    end

    //--------------------------------------------------------------------------
    // Output Logic (Moore FSM)
    //--------------------------------------------------------------------------

    always_comb begin
        case (state)

            // North-South Green
            NS_GREEN: begin
                ns_red    = 0;
                ns_yellow = 0;
                ns_green  = 1;

                ew_red    = 1;
                ew_yellow = 0;
                ew_green  = 0;
            end

            // North-South Yellow
            NS_YELLOW: begin
                ns_red    = 0;
                ns_yellow = 1;
                ns_green  = 0;

                ew_red    = 1;
                ew_yellow = 0;
                ew_green  = 0;
            end

            // East-West Green
            EW_GREEN: begin
                ns_red    = 1;
                ns_yellow = 0;
                ns_green  = 0;

                ew_red    = 0;
                ew_yellow = 0;
                ew_green  = 1;
            end

            // East-West Yellow
            EW_YELLOW: begin
                ns_red    = 1;
                ns_yellow = 0;
                ns_green  = 0;

                ew_red    = 0;
                ew_yellow = 1;
                ew_green  = 0;
            end

            default: begin
                ns_red    = 0;
                ns_yellow = 0;
                ns_green  = 1;

                ew_red    = 1;
                ew_yellow = 0;
                ew_green  = 0;
            end

        endcase
    end

endmodule
