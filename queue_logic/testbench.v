// Defines timescale for simulation: <time_unit> / <time_precision>.
`timescale 1 ns / 10 ps

// Define our testbench.
module testbench();

    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;

    // Entries.
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // Inputs.
    reg add_en;
    reg [1:0] added_entry;
    reg [1:0] current_entry;
    reg [7:0] queue;
    reg [2:0] tail;

    // Actual outputs.
    wire current_entry_was_in_queue;
    wire [7:0] next_queue_sub;
    wire [2:0] next_tail_sub;

    // Expected outputs.
    reg current_entry_was_in_queue_expected;
    reg [7:0] next_queue_sub_expected;
    reg [2:0] next_tail_sub_expected;

    // Instantiate the unit under test (UUT).
    queue_logic uut (
        // Inputs.
        .pressed_en(add_en),
        .pressed_lvl(added_entry),
        .pos_lvl(current_entry),
        .queue(queue),
        .tail(tail),
        // Outputs.
        .stop_at_pos_lvl(current_entry_was_in_queue),
        .next_queue_sub(next_queue_sub),
        .next_tail_sub(next_tail_sub)
    );

    task check_ans();
    begin
        if (current_entry_was_in_queue != current_entry_was_in_queue_expected) begin
            $display("ERROR: output mismatch!");
		    $display("expected: %b", current_entry_was_in_queue_expected);
		    $display("got:      %b", current_entry_was_in_queue);
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

    // Toggle inputs
    initial begin
        /*
         Test 0: add added_entry
         Input:
         - Current entry: A
         - Queued entries: [ B, C ]
         - State to add: D
         Output:
         - Current entry in queue: no
         - Queued entries: [ B, C, D ]     
        */
        queue = { A, D, C, B };
	tail = 2;
        current_entry = A;
        add_en = 1;
        added_entry = D;
        next_queue_sub_expected = { A, D, C, B };
        next_tail_sub_expected = 3;
        current_entry_was_in_queue_expected = 0;
	    #10;
	    check_ans();

        /*
         Test 1: subtract current_entry
         Input:
         - Current entry: C
         - Queued entries: [ A, C, B ]
         - State to add: none
         Output:
         - Current entry in queue: yes
         - Queued entries: [ A, B ]
         */
       queue = { D, B, C, A };
       tail = 3;
       current_entry = C;
       add_en = 0;
       added_entry = D;
       next_queue_sub_expected = { D, D, B, A };
       next_tail_sub_expected = 2;
       current_entry_was_in_queue_expected = 1;
       #10;
       check_ans();

        /*
         Test 2: don't add because added_entry_in_queue
         Input:
         - Current entry: C
         - Queued entries: [ A ]
         - State to add: A
         Output:
         - Current entry in queue: no
         - Queued entries: [ A ]
         */
        queue = { D, B, C, A };
        tail = 1;
        current_entry = C;
        add_en = 1;
        added_entry = A;
	next_queue_sub_expected = { D, B, C, A };
        next_tail_sub_expected = 1;
        current_entry_was_in_queue_expected = 0;
	#10;
        check_ans();

        /*
         Test 3: don't subtract because tail is out of bounds
         Input:
         - Current entry: D
         - Queued entries: [ A ]
         - State to add: none
         Output:
         - Current entry in queue: no
         - Queued entries: [ A ]
         */
        queue = { B, D, C, A };
        tail = 1;
        current_entry = D;
        add_en = 0;
        added_entry = B;
        next_queue_sub_expected = { B, D, C, A };
        next_tail_sub_expected = 1;
        current_entry_was_in_queue_expected = 0;
        #10;
        check_ans();

        /*
         Test 4: add and subtract at the same time (different levels)
         Input:
         - Current entry: B
         - Queued entries: [ B ]
         - States to add: A
         Output:
         - Current entry in queue: yes
         - Queued entries: [ A ]
         */
        queue = { A, D, C, B };
        tail = 1;
        current_entry = B;
        add_en = 1;
        added_entry = A;
        next_queue_sub_expected = { A, A, D, A };
        next_tail_sub_expected = 1;
        current_entry_was_in_queue_expected = 1;
        #10;
        check_ans();

        /*
         Test 5: add and subtract at the same time (same level, full)
         Input: 
         - Current entry: C
         - Queued entries: [ D, C, A, B ]
         - State to add: C
         Output:
         - Current entry in queue: yes
         - Queued entries: [ D, A, B ]
         */
        queue = { B, A, C, D };
        tail = 4;
        current_entry = C;
        add_en = 1;
        added_entry = C;
        next_queue_sub_expected = { B, B, A, D };
        next_tail_sub_expected = 3;
        current_entry_was_in_queue_expected = 1;
        #10;
        check_ans();

        /*
         Test 6: add and subtract at the same time (same level, not full)
         Input:
         - Current entry: C
         - Queued entries: [ D, C, A ]
         - State to add: C
         Output:
         - Current entry in queue: yes
         - Queued entry: [ D, A ]
         */
        queue = { B, A, C, D };
        tail = 3;
        current_entry = C;
        add_en = 1;
        added_entry = C;
        next_queue_sub_expected = { B, B, A, D };
        next_tail_sub_expected = 2;
        current_entry_was_in_queue_expected = 1;
        #10;
        check_ans();
    end

    // Run simulation (output to .vcd file).
    initial begin
        // Create simulation output file.
        $dumpfile("testbench.vcd");
        // 0 means look for variables in all levels.
        $dumpvars(0, testbench);
        // Wait for given amount of time for simulation to complete.
        #(DURATION);
        // Notify and end simulation.
        $display("Finished!");
        $finish;
    end

endmodule
