module pos_lvl_logic(
    input [1:0] pos_lvl,
    input [2:0] tail,
    input [11:0] queue,
    output [1:0] next_pos_lvl
);
    assign next_pos_lvl = 0;
endmodule
