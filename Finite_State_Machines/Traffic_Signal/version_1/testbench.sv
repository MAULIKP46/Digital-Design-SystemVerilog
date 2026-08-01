`timescale 1s/100ms

//==============================================================================
// Testbench : Traffic Signal Controller
// Author    : Maulik Parasramka
//
// Description:
// Verifies the fixed-time Moore FSM traffic signal controller.
//
// Features:
// - Clock generation
// - Reset stimulus using a reusable task
// - Internal signal monitoring
// - Waveform generation for GTKWave
//==============================================================================

module tb;

    //----------------------------------------------------------------------
    // Testbench Signals
    //----------------------------------------------------------------------

    logic clk;
    logic rst;

    logic ns_red;
    logic ns_yellow;
    logic ns_green;

    logic ew_red;
    logic ew_yellow;
    logic ew_green;

    //----------------------------------------------------------------------
    // Device Under Test (DUT)
    //----------------------------------------------------------------------

    traffic_signal dut (
        .clk(clk),
        .rst(rst),
        .ns_red(ns_red),
        .ns_yellow(ns_yellow),
        .ns_green(ns_green),
        .ew_red(ew_red),
        .ew_yellow(ew_yellow),
        .ew_green(ew_green)
    );

    //----------------------------------------------------------------------
    // Clock Generation
    // 1-second clock period
    //----------------------------------------------------------------------

    initial begin
        clk = 0;
        forever #0.5 clk = ~clk;
    end

    //----------------------------------------------------------------------
    // Reset Task
    //----------------------------------------------------------------------

    task apply_reset(input logic value);
        begin
            #1.2 rst = value;
        end
    endtask

    //----------------------------------------------------------------------
    // Test Sequence
    //----------------------------------------------------------------------

    initial begin

        // Generate waveform
        $dumpfile("traffic_signal.vcd");
        $dumpvars(0, tb);

        // Monitor important signals
        $monitor(
    "t=%0t clk=%b rst=%b counter=%0d state=%b next=%b NS=%b%b%b EW=%b%b%b",
    $time,
    clk,
    rst,
    dut.counter,
    dut.state,
    dut.next_state,
    ns_red,
    ns_yellow,
    ns_green,
    ew_red,
    ew_yellow,
    ew_green
);

        // Initial reset
        apply_reset(1);
        apply_reset(0);

        // Allow controller to run
        repeat (2) begin
            #200;

            apply_reset(1);
            #5;
            apply_reset(0);

            #300;
        end

        $finish;

    end

endmodule
