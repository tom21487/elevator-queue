module pressed_lvl_in_queue_logic #(parameter i = 0) (
    input pressed_en,
    input [1:0] pressed_lvl,
    input [1:0] queue_i,
    input [2:0] tail,
    output pressed_lvl_in_queue
);
    assign pressed_lvl_in_queue = queue_i == tail && tail > i;
endmodule
