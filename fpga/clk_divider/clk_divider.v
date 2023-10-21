module clk_divider(
    input clk,
    input rst,
    output reg clk_divided
);
    // 参数
    parameter MAX_CLK_CNT = 16;
    // 寄存器
    // MAX_CLK_CNT >= 0 otherwise clk_cnt and next_clk_cnt are undefined!
    reg [$clog2(MAX_CLK_CNT)-1:0] clk_cnt;
    reg [$clog2(MAX_CLK_CNT)-1:0] next_clk_cnt;
    // 导线
    reg next_clk_divided;
    always @ (*) begin
        if (clk_cnt == MAX_CLK_CNT - 1) begin
            next_clk_divided = ~clk_divided;
            next_clk_cnt = 0;
        end else begin
            next_clk_divided = clk_divided;
            next_clk_cnt = clk_cnt + 1;
        end
    end
    always @ (posedge clk) begin
        if (rst) begin
            clk_divided <= 0;
            clk_cnt     <= 0;
        end else begin
            clk_divided <= next_clk_divided;
            clk_cnt     <= next_clk_cnt;
        end
    end
endmodule
