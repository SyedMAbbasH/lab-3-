{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "7870588d",
   "metadata": {},
   "outputs": [],
   "source": [
    "module array_slice #(\n",
    "    parameter WIDTH = 8    // bit-width of X, W, Y\n",
    ") (\n",
    "    input  logic                        clk,\n",
    "    input  logic                        reset_n,   // active-low synchronous reset\n",
    "\n",
    "    // Data ports (signed)\n",
    "    input  logic signed [WIDTH-1:0]     x_in,      // traveling X input\n",
    "    input  logic signed [WIDTH-1:0]     w,         // stationary weight\n",
    "    input  logic signed [WIDTH-1:0]     y_in,      // traveling Y input\n",
    "\n",
    "    output logic signed [WIDTH-1:0]     x_out,     // traveling X output\n",
    "    output logic signed [WIDTH-1:0]     y_out      // traveling Y output (partial sum)\n",
    ");\n",
    "\n",
    "    // Registers holding traveling values\n",
    "    logic signed [WIDTH-1:0] x_reg;\n",
    "    logic signed [WIDTH-1:0] y_reg;\n",
    "\n",
    "    // Sequential logic: all state updates on the rising clock edge\n",
    "    always_ff @(posedge clk or negedge reset_n) begin\n",
    "        if (!reset_n) begin\n",
    "            x_reg <= '0;\n",
    "            y_reg <= '0;\n",
    "        end else begin\n",
    "            // X passes through slice (propagates in one direction)\n",
    "            x_reg <= x_in;\n",
    "\n",
    "            // Y accumulates partial sum: y_out = y_in + x_in * w\n",
    "            y_reg <= y_in + x_in * w;\n",
    "        end\n",
    "    end\n",
    "\n",
    "    // Drive outputs\n",
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
