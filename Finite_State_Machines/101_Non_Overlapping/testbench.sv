//--------------------------------------------------------------
// Testbench : 101 Non-Overlapping Sequence Detector
//--------------------------------------------------------------

module testbench;

    logic clk;
    logic reset;
    logic in;
    logic out;

    // DUT Instantiation
    sequence_detector_101_non_overlapping dut (
        .clk   (clk),
        .reset (reset),
        .in    (in),
        .out   (out)
    );

    //----------------------------------------------------------
    // Clock Generation (10 ns Period)
    //----------------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //----------------------------------------------------------
    // Waveform Dump
    //----------------------------------------------------------
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, testbench);
    end

    //----------------------------------------------------------
    // Monitor Signals
    //----------------------------------------------------------
    initial begin
        $monitor(
            "T=%0t | clk=%b reset=%b in=%b out=%b present=%b next=%b",
            $time,
            clk,
            reset,
            in,
            out,
            dut.present,
            dut.next
        );
    end

    //----------------------------------------------------------
    // Test Stimulus
    //----------------------------------------------------------
    initial begin

        // Initialize Inputs
        reset = 1;
        in    = 0;

        // Hold reset
        #10;
        reset = 0;

        // Test Sequence 1 : 101 (Should Detect)
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;

        // Random Inputs
        @(negedge clk) in = 0;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;

        // Asynchronous Reset Check
        #3 reset = 1;
        #7 reset = 0;

        // Test Sequence 2 : 101 (Should Detect Again)
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;

        // Additional Random Inputs
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 0;

        #20;
        $finish;

    end

endmodule
