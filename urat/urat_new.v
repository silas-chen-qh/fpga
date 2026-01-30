module uart_bit(
    input clk,
    input rst,
    input [7:0]data,
    output reg uart_tx,
    output reg led
);


//波特计数器
//计数器三要素（开始，暂停，记满清零），需要暂停，所以需要增添使能信号）
localparam BAUT = 9600;
localparam SEND_MAX = 50_000_000;
localparam BAUT_CNT_MAX = SEND_MAX/BAUT - 1;

reg [12:0] baut_cnt;
reg en_baut_cnt;
reg [3:0]bit_cnt;
reg [26:0]send_cnt;
reg [7:0] data_reg;

always@(posedge clk or posedge rst)
    if(rst)
        en_baut_cnt <= 0;
    else if(send_cnt == SEND_MAX-1)
        en_baut_cnt <= 1;
    else if((bit_cnt == 9)&&(send_cnt == SEND_MAX - 1))
        en_baut_cnt <= 0;


always@(posedge clk or posedge rst)
    if(rst)
        baut_cnt <= 0;
    else if(en_baut_cnt)begin
        if(baut_cnt == BAUT_CNT_MAX)
            baut_cnt <= 0;
        else
            baut_cnt <= baut_cnt + 1;
    end


//位计数器
 always@(posedge clk or posedge rst)
    if(rst)
        bit_cnt <= 0;
    else if(baut_cnt == BAUT_CNT_MAX)begin
        if(bit_cnt == 9)
            bit_cnt <= 0;
        else 
            bit_cnt <= bit_cnt + 1;
    end




//延时计数器1s
 always@(posedge clk or posedge rst)
    if(rst)
        send_cnt <= 0;
    else if(send_cnt == SEND_MAX - 1)begin
        send_cnt <= 0;
    end
    else 
        send_cnt <= send_cnt + 1;



 always@(posedge clk or posedge rst)
    if(rst)
        data_reg <= 0;
    else if(send_cnt == SEND_MAX - 1)
        data_reg <= data;
    else 
        data_reg <= data_reg;



//位发送逻辑
always@(posedge clk or posedge rst)
    if(rst)
        uart_tx <= 1;
    else if(en_baut_cnt)begin case(bit_cnt)
        0:uart_tx <= 1'd0;
        1:uart_tx <= data_reg[0];
        2:uart_tx <= data_reg[1];
        3:uart_tx <= data_reg[2];
        4:uart_tx <= data_reg[3];
        5:uart_tx <= data_reg[4];
        6:uart_tx <= data_reg[5];
        7:uart_tx <= data_reg[6];
        8:uart_tx <= data_reg[7];
        9:uart_tx <= 1'd1;
        default uart_tx <= uart_tx;

    endcase
    end


//led反转逻辑
always@(posedge clk or posedge rst)
    if(rst)
        led <= 1;
    else if((bit_cnt == 9)&&(send_cnt == SEND_MAX - 1))
        led <= ~led;

    


endmodule