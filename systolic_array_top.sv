

module systolic_array_top #(
    parameter WIDTH = 8
)(
    input  logic                        clk,
    input  logic                        reset_n,

  
    input  logic signed [WIDTH-1:0]     x_in_left,

  
    input  logic signed [WIDTH-1:0]     y_prev_right,

   
    input  logic signed [WIDTH-1:0]     w3,   
    input  logic signed [WIDTH-1:0]     w2,   
    input  logic signed [WIDTH-1:0]     w1,   

   
    output logic signed [WIDTH-1:0]     results_left,


    output logic signed [WIDTH-1:0]     x_out_ignored,

   
    output logic signed [WIDTH-1:0]     y_slice3_out,
    output logic signed [WIDTH-1:0]     y_slice2_out,
    output logic signed [WIDTH-1:0]     y_slice1_out
);

    
    logic signed [WIDTH-1:0] x_s3_to_s2;   
    logic signed [WIDTH-1:0] x_s2_to_s1;   

    
    logic signed [WIDTH-1:0] y_s2_to_s3;   
    logic signed [WIDTH-1:0] y_s1_to_s2;   

    
    
    array_slice #(.WIDTH(WIDTH)) slice3 (
        .clk   (clk),
        .reset_n(reset_n),
        .x_in  (x_in_left),
        .w     (w3),
        .y_in  (y_s2_to_s3),
        .x_out (x_s3_to_s2),
        .y_out (results_left)
    );

    assign y_slice3_out = results_left;

    
    array_slice #(.WIDTH(WIDTH)) slice2 (
        .clk   (clk),
        .reset_n(reset_n),
        .x_in  (x_s3_to_s2),
        .w     (w2),
        .y_in  (y_s1_to_s2),
        .x_out (x_s2_to_s1),
        .y_out (y_s2_to_s3)
    );

    assign y_slice2_out = y_s2_to_s3;

    
    array_slice #(.WIDTH(WIDTH)) slice1 (
        .clk   (clk),
        .reset_n(reset_n),
        .x_in  (x_s2_to_s1),
        .w     (w1),
        .y_in  (y_prev_right),
        .x_out (x_out_ignored),
        .y_out (y_s1_to_s2)
    );

    assign y_slice1_out = y_s1_to_s2;

endmodule
