{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "7870588d",
   "metadata": {},
   "outputs": [],
   "source": [
    "// Array Slice i  (W1 variant)\n",
    "// One building block of the systolic array.\n",
    "\n",
    "module array_slice #(\n",
    "    parameter WIDTH = 8              // bit-width of X, W, and Y\n",
    ") (\n",
    "    input  logic                        clk,\n",
    "    input  logic                        reset_n,   // active-low reset\n",
    "\n",
    "    // Signed data ports (Step 1(b))\n",
    "    input  logic signed [WIDTH-1:0]     x_in,      // X entering slice (from left)\n",
    "    input  logic signed [WIDTH-1:0]     w,         // stationary weight Wi\n",
    "    input  logic signed [WIDTH-1:0]     y_in,      // Y entering slice (from right)\n",
    "\n",
    "    output logic signed [WIDTH-1:0]     x_out,     // X leaving slice (to right)\n",
    "    output logic signed [WIDTH-1:0]     y_out      // Y leaving slice (to left)\n",
    ");\n",
    "\n",
    "    // Flip-flops for traveling values X and Y\n",
    "    logic signed [WIDTH-1:0] x_reg;    // bottom FF in the figure\n",
    "    logic signed [WIDTH-1:0] y_reg;    // top FF in the figure\n",
    "\n",
    "    // Sequential logic for X and Y flip-flops\n",
    "    always_ff @(posedge clk or negedge reset_n) begin\n",
    "        if (!reset_n) begin\n",
    "            x_reg <= '0;\n",
    "            y_reg <= '0;\n",
    "        end else begin\n",
    "            // X pipeline FF (bottom block)\n",
    "            x_reg <= x_in;\n",
    "\n",
    "            // MAC operation for Y:\n",
    "            // multiplier (x_in * w) + adder ( + y_in ),\n",
    "            // then result stored in Y flip-flop (top block).\n",
    "            y_reg <= y_in + x_in * w;\n",
    "        end\n",
    "    end\n",
    "\n",
    "    // Outputs\n",
    "    assign x_out = x_reg;\n",
    "    assign y_out = y_reg;\n",
    "\n",
    "endmodule\n"
   ]
  }
 ],
 "metadata": {
  "language_info": {
   "name": "python"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
