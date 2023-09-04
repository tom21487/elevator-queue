// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps
// Define our testbench
module testbench();
    // 寄存器（输入）
    reg [1:0] next_queue_add_i;
    reg [1:0] next_queue_add_ip1;
    reg [2:0] next_tail_add;
    reg [1:0] pos_lvl;
    reg shift_im1;
    // 导线（输出）
    wire [1:0] next_queue_sub_i;
    wire shift_i;
    // 预期输出
    reg [1:0] next_queue_sub_i_expected;
    reg shift_i_expected;
    
    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;

    // Instantiate the unit under test (UUT)
    lvl_i_logic #(.i(1)) uut (
        .next_queue_add_i(next_queue_add_i),
        .next_queue_add_ip1(next_queue_add_ip1),
        .next_tail_add(next_tail_add),
        .pos_lvl(pos_lvl),
	.shift_im1(shift_im1),
        .next_queue_sub_i(next_queue_sub_i),
        .shift_i(shift_i)
    );

    // 验证输出值
    task check_ans();
        begin            
            if (next_queue_sub_i != next_queue_sub_i_expected) begin
                $display("ERROR: next_queue_sub_i mismatch!");
                $display("expected: %b", next_queue_sub_i_expected);
                $display("got:      %b", next_queue_sub_i);
                $finish;
            end
            if (shift_i != shift_i_expected) begin
                $display("ERROR: shift_i mismatch!");
                $display("expected: %b", shift_i_expected);
                $display("got:      %b", shift_i);
                $finish;
            end
        end
    endtask

    // Toggle inputs and check expected
    initial begin
        // 设置输入
        next_queue_add_i = 2'b01;
        next_queue_add_ip1 = 2'b10;
        next_tail_add = 3'b011;
        pos_lvl = 2'b10;
	shift_im1 = 0;
        // 检查输出
        next_queue_sub_i_expected = 2'b01;
        shift_i_expected = 0;
        #10;
        check_ans();

        // 设置输入
	next_queue_add_i = 2'b01;
	next_queue_add_ip1 = 2'b10;
	next_tail_add = 3'b011;
        pos_lvl = 2'b10;
	shift_im1 = 1;
        // 查看输出
        next_queue_sub_i_expected = 2'b10;
        shift_i_expected = 1;
        #10;
        check_ans();

        // 设置输入
        next_queue_add_i = 2'b10;
        next_queue_add_ip1 = 2'b11;
        next_tail_add = 3'b011;
        pos_lvl = 2'b10;
	shift_im1 = 0;
        // 查看输出
        next_queue_sub_i_expected = 2'b11;
        shift_i_expected = 1;
	#10;
	check_ans();

        // 设置输入
        next_queue_add_i = 2'b11;
        next_queue_add_ip1 = 2'b00;
        next_tail_add = 3'b000;
        pos_lvl = 2'b11;
	shift_im1 = 0;
        // 查看输出
        next_queue_sub_i_expected = 2'b11;
        shift_i_expected = 0;
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
