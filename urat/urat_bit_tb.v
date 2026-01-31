`timescale 1ns / 1ps

module urat_bit_tb(


);

    reg clk;
    reg rst;
    reg [7:0] data;
    wire led;
    wire uart_tx;
 

uart_tx urat_tx_tb(
    .clk(clk),
    .rst(rst),
    .data(data),
    .uart_tx(uart_tx),
    .led(led)
);




initial clk = 1;
always #10 clk = ~clk;

initial begin
    rst = 1;
    #100
    rst = 0;
    data = 8'b0101_0101;
    #30_000_000
    data = 8'b10101_010;
    #30_000_000
    $stop;

end


endmodule