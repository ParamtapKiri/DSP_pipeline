module pipeline_top(
    input clk,
    input rst,
    input signed [15:0] x,
    output signed [15:0] y
);

    wire signed [15:0] fir_y;
    wire signed [15:0] iir_y;
    wire signed [15:0] fft_y;

    fir_filter FIR(clk, rst, x, fir_y);
    iir_filter IIR(clk, rst, fir_y, iir_y);
    fft_radix2 FFT(clk, rst, iir_y, fft_y);

    assign y = fft_y;

endmodule
