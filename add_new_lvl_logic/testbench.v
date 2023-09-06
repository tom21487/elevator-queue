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
    reg pressed_en;
    reg [1:0] pressed_lvl;
    reg [7:0] queue;
    reg [2:0] tail;
    // 导线（输出）
    wire add_new_lvl;
    // 预期输出
    reg add_new_lvl_expected;

    // Instantiate the unit under test (UUT)
    add_new_lvl_logic uut (
	.pressed_en(pressed_en),
	.pressed_lvl(pressed_lvl),
	.queue(queue),
	.tail(tail),
	.add_new_lvl(add_new_lvl)
    );

    // 验证输出值
    task check_ans();
	begin
            if (add_new_lvl != add_new_lvl_expected) begin
		$display("ERROR: output mismatch!");
		$display("expected: %b", add_new_lvl_expected);
		$display("got:      %b", add_new_lvl);
		$finish;
            end
	end
    endtask

    // Toggle inputs and check output
    initial begin
	// Test 0: pressed_en & pressed_lvl_in_queue, don't add_new_lvl
	pressed_en = 1;
	pressed_lvl = A;
	queue[0] = C;
	queue[1] = A;
	queue[2] = D;
	queue[3] = B;
	tail = 2;
	add_new_lvl_expected = 0;
	#10;
	check_ans();

	// Test 1: pressed_en & ~pressed_lvl_in_queue, do add_new_lvl
	pressed_en = 1;
	pressed_lvl = D;
	queue[0] = C;
	queue[1] = A;
	queue[2] = D;
	queue[3] = D;
	tail = 1;
	add_new_lvl_expected = 1;
	#10;
	check_ans();

	// Test 2: ~pressed_en & pressed_lvl_in_queue, don't add_new_lvl
        pressed_en = 0;
	pressed_lvl = B;
	queue[0] = B;
	queue[1] = C;
	queue[2] = A;
	queue[3] = D;
	tail = 4;
        add_new_lvl_expected = 0;
        #10;
        check_ans();

	// Test 3: ~pressed_en & ~pressed_lvl_in_queue, don't add_new_lvl
        pressed_en = 0;
	pressed_lvl = B;
	queue[0] = B;
	queue[1] = C;
	queue[2] = A;
	queue[3] = D;
	tail = 0;
        add_new_lvl_expected = 0;
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
