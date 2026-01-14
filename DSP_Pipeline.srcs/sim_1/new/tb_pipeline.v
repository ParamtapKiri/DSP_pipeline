module tb_pipeline;

    reg clk = 0;
    reg rst = 1;
    reg signed [15:0] x;
    wire signed [15:0] y;

    pipeline_top DUT(clk, rst, x, y);

    always #5 clk = ~clk;

    initial begin
        #20 rst = 0;
        repeat (100) begin
            x = $random;
            #10;
        end
        $finish;
    end

endmodule
