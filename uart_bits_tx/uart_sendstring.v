module uart_sendstring#(
    parameter data_length = 6
)(
    input wire clk,
    input wire rst,
    input wire [8 * data_length - 1 : 0] data_in,
    input wire                           flag,
    output wire                          tx
    );
    
    reg        data_vld;
    wire [7:0] data_tx;
    wire ready;
    reg [3:0]  cnt_byte; 
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            data_vld <= 0;
        else if(cnt_byte == data_length - 1 && ready)
            data_vld <= 0;
        else if(flag)
            data_vld <= 1;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            cnt_byte <= 0;
        else if(cnt_byte == data_length - 1 && ready)
            cnt_byte <= 0;
        else if(ready && data_vld)
            cnt_byte <= cnt_byte + 1;
    end
    
    assign data_tx = data_in[8*(data_length -1 - cnt_byte) +: 8];
    
    uart_tx#(
        .sys_clock (50_000_000),
        .baud      (9600)
)
(
        .clk(clk),
        .rst(rst),
        .data_vld(data_vld),
        .data_tx(data_tx),
        .tx(tx),
        .ready(ready)
);
endmodule
