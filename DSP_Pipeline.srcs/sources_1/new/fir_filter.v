module fir_filter #(
    parameter N = 8
)(
    input clk,
    input rst,
    input signed [15:0] x_in,
    output signed [15:0] y_out
);

    reg signed [15:0] coeff [0:N-1];
    reg signed [31:0] acc [0:N-1];

    integer i;

    initial begin
        coeff[0] = 16'sd1638;  // example coefficients
        coeff[1] = 16'sd3276;
        coeff[2] = 16'sd4915;
        coeff[3] = 16'sd6553;
        coeff[4] = 16'sd6553;
        coeff[5] = 16'sd4915;
        coeff[6] = 16'sd3276;
        coeff[7] = 16'sd1638;
    end

    always @(posedge clk) begin
        if (rst) begin
            for (i=0;i<N;i=i+1)
                acc[i] <= 0;
        end else begin
            acc[0] <= x_in * coeff[0];
            for (i=1;i<N;i=i+1)
                acc[i] <= acc[i-1] + x_in * coeff[i];
        end
    end

    assign y_out = acc[N-1][30:15];

endmodule
