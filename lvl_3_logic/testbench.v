// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps
// Define our testbench
module testbench();
    // 寄存器（输入）
    reg [1:0] next_queue_add_3;
    reg [2:0] next_tail_add;
    reg [1:0] pos_lvl;
    reg shift_2;
    // 导线（输出）
    wire [1:0] next_queue_sub_3;
    wire shift_3;
    // 预期输出
    reg [1:0] next_queue_sub_3_expected;
    reg shift_3_expected;
    
    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;

    // Instantiate the unit under test (UUT)
    lvl_3_logic uut (
        .next_queue_add_3(next_queue_add_3),
        .next_tail_add(next_tail_add),
        .pos_lvl(pos_lvl),
	.shift_2(shift_2),
        .next_queue_sub_3(next_queue_sub_3),
        .shift_3(shift_3)
    );

    // 验证输出值
    task check_ans();
        begin            
            if (next_queue_sub_3 != next_queue_sub_3_expected) begin
                $display("ERROR: next_queue_sub_3 mismatch!");
                $display("expected: %b", next_queue_sub_3_expected);
                $display("got:      %b", next_queue_sub_3);
                $finish;
            end
            if (shift_3 != shift_3_expected) begin
                $display("ERROR: shift_3 mismatch!");
                $display("expected: %b", shift_3_expected);
                $display("got:      %b", shift_3);
                $finish;
            end
        end
    endtask

    // Toggle inputs and check expected
    initial begin
        // 设置输入
        next_queue_add_3 = 2'b01;
        next_tail_add = 3'b100;
        pos_lvl = 2'b01;
	shift_2 = 0;
        // 检查输出
        next_queue_sub_3_expected = 2'b01;
        shift_3_expected = 1;
        #10;
        check_ans();

        // 设置输入
	next_queue_add_3 = 2'b01;
	next_tail_add = 3'b100;
        pos_lvl = 2'b00;
	shift_2 = 0;
        // 查看输出
        next_queue_sub_3_expected = 2'b01;
        shift_3_expected = 0;
        #10;
        check_ans();

        // 设置输入
        next_queue_add_3 = 2'b01;
        next_tail_add = 3'b100;
        pos_lvl = 2'b00;
	shift_2 = 1;
        // 查看输出
        next_queue_sub_3_expected = 2'b01;
        shift_3_expected = 1;
	#10;
	check_ans();

        // 设置输入
        next_queue_add_3 = 2'b01;
        next_tail_add = 3'b011;
        pos_lvl = 2'b01;
	shift_2 = 0;
        // 查看输出
        next_queue_sub_3_expected = 2'b01;
        shift_3_expected = 0;
	#10;
	check_ans();

        // 设置输入
        next_queue_add_3 = 2'b01;
        next_tail_add = 3'b011;
        pos_lvl = 2'b10;
	shift_2 = 1;
        // 查看输出
        next_queue_sub_3_expected = 2'b01;
        shift_3_expected = 1; // Shift propagation regardless of tail validity
	#10;
	check_ans();
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
