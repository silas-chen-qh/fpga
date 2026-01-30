module uart(
    input wire clk,
    input wire rst,
    input wire [7:0] data,

    output reg urx,
    output reg led



);
//时钟周期50，000，000

//波特率计算逻辑
localparam BAUT = 9600;
localparam BAUD_CNT_MAX = 50_000_000/BAUT - 1;

reg [12:0] baut_cnt;

/////新增
reg tx_busy_flag;



always@(posedge clk or posedge rst)
    if(rst)
        baut_cnt <= 0;
    else if(baut_cnt == BAUD_CNT_MAX)
        baut_cnt <= 0;
    else
        baut_cnt <= baut_cnt + 1;

//发送逻辑（一秒）

localparam SEND_CNT_MAX = 50_000_000 - 1;

reg [27:0] send_cnt;

always@(posedge clk or posedge rst)
    if(rst)
        send_cnt <= 0;
    else if(send_cnt == SEND_CNT_MAX)
        send_cnt <= 0;
    else
        send_cnt <= send_cnt + 1;


//赋值逻辑
reg [7:0] data_reg

always@(posedge clk)
    if(sned_cnt == SEND_CNT_MAX)
        data_reg <= data;

//bit递增逻辑

reg [3:0] bit_cnt;
always@(posedge clk or posedge rst)
    if(rst)
        bit_cnt <= 0;
    else if(bit_cnt==9)
        bit_cnt <= 0;
    else
        bit_cnt <= bit_cnt + 1;



//发送逻辑
always@(posedge clk or posedge rst)begin
    if(rst)
        urx <= 1;
    else if(sned_cnt == SEND_CNT_MAX)
        case(bit_cnt)
            0:urx <= 1'd0;
            1:urx <= data_reg[0];
            2:urx <= data_reg[1];
            3:urx <= data_reg[2];
            4:urx <= data_reg[3];
            5:urx <= data_reg[4];
            6:urx <= data_reg[5];
            7:urx <= data_reg[6];
            8:urx <= data_reg[7];
            9:urx <= 1'd1;
        default: urx <= urx;
    endcase
end

always@(posedge clk or posedge rst)
    if(rst)
        led <= 1;
    else if((sned_cnt == SEND_CNT_MAX)&&(bit_cnt == 9))
        led <= ~led;
    else
        led <= 1;



endmodule