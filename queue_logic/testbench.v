// Test cases are done, 其它需要更新
// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps
// Define our testbench
module testbench();
    // 寄存器（输入）
    reg pressed_en;
    reg [1:0] pressed_lvl;
    reg [1:0] pos_lvl;
    reg [7:0] queue;
    reg [2:0] tail;
    // 导线（输出）
    wire stop_at_pos_lvl;
    wire [7:0] next_queue_sub;
    wire [2:0] next_tail_sub;
    // 预期输出
    reg stop_at_pos_lvl_expected;
    reg [7:0] next_queue_sub_expected;
    reg [2:0] next_tail_sub_expected;

    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;
    // 楼层枚举值
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // Instantiate the unit under test (UUT) (need to redo)
    queue_logic uut (
        // 输入
        .pressed_en(pressed_en),
        .pressed_lvl(pressed_lvl),
        .pos_lvl(pos_lvl),
        .queue(queue),
        .tail(tail),
        // 输出
        .stop_at_pos_lvl(stop_at_pos_lvl),
        .next_queue_sub(next_queue_sub),
        .next_tail_sub(next_tail_sub)
    );

    // 验证输出值
    task check_ans();
	begin
            if (stop_at_pos_lvl != stop_at_pos_lvl_expected) begin
		$display("ERROR: output mismatch!");
		$display("expected: %b", stop_at_pos_lvl_expected);
		$display("got:      %b", stop_at_pos_lvl);
		$finish;
            end
            if (next_queue_sub != next_queue_sub_expected) begin
		$display("ERROR: output mismatch!");
		$display("expected: %b", next_queue_sub_expected);
		$display("got:      %b", next_queue_sub);
		$finish;
            end
            if (next_tail_sub != next_tail_sub_expected) begin
		$display("ERROR: output mismatch!");
		$display("expected: %b", next_tail_sub_expected);
		$display("got:      %b", next_tail_sub);
		$finish;
            end
	end
    endtask

    // Toggle inputs (don't change!!)
    initial begin
	// Test 0: add pressed_lvl
	queue = { A, D, C, B };
	tail = 2;
        pos_lvl = A;
        pressed_en = 1;
        pressed_lvl = D;
	next_queue_sub_expected = { A, D, C, B };
        next_tail_sub_expected = 3;
        stop_at_pos_lvl_expected = 0;
	#10;
	check_ans();

	// Test 1: subtract pos_lvl
	queue = { D, B, C, A };
	tail = 3;
        pos_lvl = C;
        pressed_en = 0;
        pressed_lvl = D;
	next_queue_sub_expected = { D, D, B, A };
        next_tail_sub_expected = 2;
        stop_at_pos_lvl_expected = 1;
	#10;
	check_ans();

	// Test 2: don't add because pressed_lvl_in_queue
	queue = { D, B, C, A };
	tail = 1;
        pos_lvl = C;
        pressed_en = 0;
        pressed_lvl = A;
	next_queue_sub_expected = { D, B, C, A };
        next_tail_sub_expected = 1;
        stop_at_pos_lvl_expected = 0;
	#10;
	check_ans();

	// Test 3: don't subtract because tail is out of bounds
	queue = { B, D, C, A };
	tail = 1;
        pos_lvl = D;
        pressed_en = 0;
        pressed_lvl = B;
	next_queue_sub_expected = { B, D, C, A };
        next_tail_sub_expected = 1;
        stop_at_pos_lvl_expected = 0;
	#10;
	check_ans();

	// Test 4: add and subtract at the same time (different levels)
	queue = { A, D, C, B };
	tail = 1;
        pos_lvl = B;
        pressed_en = 1;
        pressed_lvl = A;
	next_queue_sub_expected = { A, A, D, A };
        next_tail_sub_expected = 1;
        stop_at_pos_lvl_expected = 1;
	#10;
	check_ans();

	// Test 5: add and subtract at the same time (same level, full)
	queue = { B, A, C, D };
	tail = 4;
        pos_lvl = C;
        pressed_en = 1;
        pressed_lvl = C;
	next_queue_sub_expected = { B, B, A, D };
        next_tail_sub_expected = 3;
        stop_at_pos_lvl_expected = 1;
	#10;
	check_ans();

	// Test 6: add and subtract at the same time (same level, not full)
	queue = { B, A, C, D };
	tail = 4;
        pos_lvl = C;
        pressed_en = 1;
        pressed_lvl = C;
	next_queue_sub_expected = { B, B, A, D };
        next_tail_sub_expected = 3;
        stop_at_pos_lvl_expected = 1;
	#10;
	check_ans();
	// 5和6告诉我们应该先减再加，之后再改。
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