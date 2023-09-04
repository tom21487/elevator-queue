// Testbench for clock divider
//
// Original Author: Shawn Hymel
// Original Date: November 11, 2021
// Modified: Tom Jiao
// Modified Date: July 29, 2023
// License: 0BSD

// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps

// Define our testbench
module testbench();

    // Internal signals
    wire    clk_divided;

    // Storage elements (set initial values to 0)
    reg     clk = 0;
    reg     rst = 0;            
    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;
    localparam HALF_PERIOD = 41.67;
    
    // Generate FPGA clock signal: 1 / ((2 * 41.67) * 1 ns) = 11,999,040.08 Hz = 12 MHz
    always begin
        
        // Delay for 41.67 time units
        // 10 ps precision means that 41.667 is rounded to 41.67
        #HALF_PERIOD;
        
        // Toggle clock line
        clk = ~clk;
    end
    
    // Instantiate the unit under test (UUT)
    clk_divider #(.MAX_CLK_CNT(2)) uut (
        .clk(clk),
        .rst(rst),
        .clk_divided(clk_divided)
    );
    
    // Pulse reset line high at the beginning
    initial begin
        rst = 1'b1;
        #HALF_PERIOD;
        #HALF_PERIOD;
        rst = 1'b0;
    end
    
    // Run simulation (output to .vcd file)
    initial begin
    
        // Create simulation output file 
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
        
        // Wait for given amount of time for simulation to complete
        #(DURATION)
        
        // Notify and end simulation
        $display("Finished!");
        $finish;
    end
    
endmodule
