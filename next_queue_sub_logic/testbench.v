// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps

// Define our testbench
module testbench();

    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;
    // 楼层枚举值
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // 寄存器（输入）
    reg [1:0] pos_lvl;
    reg [7:0] next_queue_add;
    reg [2:0] next_tail_add;
    // 导线（输出）
    wire [7:0] next_queue_sub;
    wire stop_at_pos_lvl;
    // 预期输出
    reg [7:0] next_queue_sub_expected;
    reg stop_at_pos_lvl_expected;

    // Instantiate the unit under test (UUT)
    next_queue_sub_logic uut(
        // 输入
        .pos_lvl(pos_lvl),
	.next_queue_add(next_queue_add),
	.next_tail_add(next_tail_add),
        // 输出
	.next_queue_sub(next_queue_sub),
        .stop_at_pos_lvl(stop_at_pos_lvl)
    );

    // 验证输出值
    task check_ans();
	begin
            if (next_queue_sub != next_queue_sub_expected) begin
		$display("ERROR: next_queue_sub mismatch!");
		$display("expected: %b", next_queue_sub_expected);
		$display("got:      %b", next_queue_sub);
		$finish;
            end

            if (stop_at_pos_lvl != stop_at_pos_lvl_expected) begin
		$display("ERROR: stop_at_pos_lvl mismatch!");
		$display("expected: %b", stop_at_pos_lvl_expected);
		$display("got:      %b", stop_at_pos_lvl);
		$finish;
            end
        end
    endtask

    // Toggle inputs and check output
    initial begin
	pos_lvl = C;
	next_queue_add = { D, A, B, C };
        next_tail_add = 2'b01;
        next_queue_sub_expected = { D, D, A, B };
        stop_at_pos_lvl_expected = 1;
        #10;
        check_ans();

	pos_lvl = C;
	next_queue_add = { D, D, A, B };
        next_tail_add = 2'b01;
        next_queue_sub_expected = { D, D, A, B };
        stop_at_pos_lvl_expected = 0;
        #10;
        check_ans();

	pos_lvl = D;
	next_queue_add = { D, D, A, B };
        next_tail_add = 2'b01;
        next_queue_sub_expected = { D, D, A, B };
        stop_at_pos_lvl_expected = 0;
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
