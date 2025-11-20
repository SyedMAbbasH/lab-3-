`timescale 1ns/1ps

module tb_systolic_array_top;

    localparam WIDTH = 8;

    reg clk;
    reg reset_n;
    reg  signed [WIDTH-1:0] x_in_left;
    reg  signed [WIDTH-1:0] y_prev_right;
    reg  signed [WIDTH-1:0] w3, w2, w1;

    wire signed [WIDTH-1:0] results_left;
    wire signed [WIDTH-1:0] x_out_ignored;
    wire signed [WIDTH-1:0] y_slice3_out, y_slice2_out, y_slice1_out;

    systolic_array_top #(.WIDTH(WIDTH)) dut (
        .clk           (clk),
        .reset_n       (reset_n),
        .x_in_left     (x_in_left),
        .y_prev_right  (y_prev_right),
        .w3            (w3),
        .w2            (w2),
        .w1            (w1),
        .results_left  (results_left),
        .x_out_ignored (x_out_ignored),
        .y_slice3_out  (y_slice3_out),
        .y_slice2_out  (y_slice2_out),
        .y_slice1_out  (y_slice1_out)
    );

    always #10 clk = ~clk;

    integer i;
    reg signed [WIDTH-1:0] stream1 [0:2];
    reg signed [WIDTH-1:0] stream2 [0:2];

    initial begin
        clk = 0;
        reset_n = 0;
        x_in_left = 0;
        y_prev_right = 0;
        w3 = 2;
        w2 = -1;
        w1 = 3;

        #5;
        reset_n = 0;
        repeat (2) @(negedge clk);
        reset_n = 1;
        @(negedge clk);

        y_prev_right = 0;
        x_in_left = 5;   @(negedge clk);
        x_in_left = -2;  @(negedge clk);
        x_in_left = 1;   @(negedge clk);
        x_in_left = 0;   @(negedge clk);
        repeat (8) @(posedge clk);

        reset_n = 0;
        repeat (2) @(negedge clk);
        reset_n = 1;
        @(negedge clk);

        x_in_left = 0;
        y_prev_right = 10; @(negedge clk);
        x_in_left = 3;  @(negedge clk);
        y_prev_right = -5;
        x_in_left = -1; @(negedge clk);
        y_prev_right = 7;
        x_in_left = 4;  @(negedge clk);
        repeat (8) @(posedge clk);

        reset_n = 0;
        repeat (2) @(negedge clk);
        reset_n = 1;
        @(negedge clk);

        stream1[0] = 3;   stream1[1] = 6;   stream1[2] = 9;
        stream2[0] = -1;  stream2[1] = -2;  stream2[2] = -3;

        y_prev_right = 0;
        for (i = 0; i < 6; i = i + 1) begin
            if (i % 2 == 0) x_in_left = stream1[i/2];
            else            x_in_left = stream2[i/2];
            @(negedge clk);
        end

        repeat (10) @(posedge clk);
        $stop;
    end

endmodule
