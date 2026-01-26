module top_seg(
    input wire sys_clk,
    input wire sys_rst,

    output wire [7:0] seg_com,
    output wire [7:0] seg_led
);

wire [31:0] display  = 32'h12345678;

seg_module segmodule(
    .clk    (sys_clk),
    .rst    (sys_rst),

    .data_in    (display),
    .dp_in      (8'b1111_0111),

    .seg    (seg_com),
    .sel    (seg_led)
);


endmodule