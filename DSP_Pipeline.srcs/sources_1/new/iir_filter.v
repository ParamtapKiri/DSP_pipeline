module iir_filter(
    input clk,
    input rst,
    input signed [15:0] x,
    output signed [15:0] y
);

    reg signed [31:0] acc;
    reg signed [15:0] x1, y1;

    // Example coefficients (Q1.15)
    wire signed [15:0] b0 = 16'sd16384;
    wire signed [15:0] b1 = 16'sd8192;
    wire signed [15:0] a1 = -16'sd4096;

    always @(posedge clk) begin
        if (rst) begin
            acc <= 0;
            x1 <= 0;
            y1 <= 0;
        end else begin
            acc <= b0*x + b1*x1 - a1*y1;
            x1 <= x;
            y1 <= acc[30:15];
        end
    end

    assign y = acc[30:15];

endmodule
