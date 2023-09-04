// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps
// Define our testbench
module testbench();
    // 寄存器（输入）
    reg [1:0] next_queue_add_0;
    reg [1:0] next_queue_add_1;
    reg [2:0] next_tail_add;
    reg [1:0] pos_lvl;
    // 导线（输出）
    wire [1:0] next_queue_sub_0;
    wire shift_0;
    // 预期输出
    reg [1:0] next_queue_sub_0_expected;
    reg shift_0_expected;
    
    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;
    // Instantiate the unit under test (UUT)
    lvl_0_logic uut (
        .next_queue_add_0(next_queue_add_0),
        .next_queue_add_1(next_queue_add_1),
        .next_tail_add(next_tail_add),
        .pos_lvl(pos_lvl),
        .next_queue_sub_0(next_queue_sub_0),
        .shift_0(shift_0)
    );

    // 验证输出值
    task check_ans();
        begin            
            if (next_queue_sub_0 != next_queue_sub_0_expected) begin
                $display("ERROR: next_queue_sub_0 mismatch!");
                $display("expected: %b", next_queue_sub_0_expected);
                $display("got:      %b", next_queue_sub_0);
                $finish;
            end
            if (shift_0 != shift_0_expected) begin
                $display("ERROR: shift_0 mismatch!");
                $display("expected: %b", shift_0_expected);
                $display("got:      %b", shift_0);
                $finish;
            end
        end
    endtask

    // Toggle inputs and check expected
    initial begin
        // 设置输入
        next_queue_add_0 = 2'b11;
        next_queue_add_1 = 2'b10;
        next_tail_add = 3'b001;
        pos_lvl = 2'b10;
        // 检查输出
        next_queue_sub_0_expected = 2'b11;
        shift_0_expected = 0;
        #10;
        check_ans();

        // 设置输入
        pos_lvl = 2'b11;
        // 查看输出
        next_queue_sub_0_expected = 2'b10;
        shift_0_expected = 1;
        #10;
        check_ans();

        // 设置输入
        next_queue_add_0 = 2'b10;
        next_queue_add_1 = 2'b01;
        pos_lvl = 2'b10;
        next_tail_add = 2'b00;
        // 查看输出
        next_queue_sub_0_expected = 2'b10;
        shift_0_expected = 0;
    end

    // Run simulation (output to .vcd file)
    initial begin
        // Create simulation output file
        $dumpfile("testbench.vcd");
        // 0 means look for variables in all levels
        $dumpvars(0, testbench);
        // Wait for given amount of time for simulation to complete
        #(DURATION);
        // Notify and end simulation
        $display("Finished!");
        $finish;
    end
endmodule
