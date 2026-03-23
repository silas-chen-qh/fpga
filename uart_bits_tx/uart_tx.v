module uart_tx#(
    parameter sys_clock = 50_000_000,
    parameter baud      = 9600    
)
(
    input wire          clk,
    input wire          rst,
    input wire          data_vld,
    input wire [7:0]    data_tx,
    output reg          tx,
    output reg          ready
);

//确定每一位发送时间 即确定每一位发送需要的时钟个数
localparam CNT_MAX = sys_clock / baud;
reg busy;
reg [19:0] counter;
reg [3:0] cnt_bit;
reg [7:0] data_reg;

always@(posedge clk or posedge rst)
begin
    if(rst)
        ready <= 1;
    else if(ready && data_vld)
        ready <= 0;
    else if(cnt_bit == 9 && counter == CNT_MAX - 1)
        ready <= 1;
end

always@(posedge clk or posedge rst)
begin
    if(rst)
        busy <= 0;
    else if(ready && data_vld)
        busy <= 1;
    else if(cnt_bit == 9 && counter == CNT_MAX - 1)
        busy <= 0;
end

always@(posedge clk or posedge rst)
begin
    if(rst)
        data_reg <= 0;
    else if(data_vld && ready)
        data_reg <= data_tx;
end

always@(posedge clk or posedge rst)
begin
    if(rst)
        counter <= 0;
    else if(busy)begin
        if(counter == CNT_MAX - 1)
            counter <= 0;
        else
            counter <= counter + 1;
    end
    else 
        counter <= 0;
end
always@(posedge clk or posedge rst)
begin
    if(rst)
        cnt_bit <= 0;
    else if(busy)begin
        if(counter == CNT_MAX - 1)begin
            if(cnt_bit == 9)
                cnt_bit <= 0;
            else 
                cnt_bit <= cnt_bit + 1;
        end
    end
end

always@(posedge clk or posedge rst)
begin
    if(rst)
        tx <= 1;
    else if(busy)begin
        case(cnt_bit)
            4'd0:begin tx <= 0;           end
            4'd1:begin tx <= data_reg[0]; end
            4'd2:begin tx <= data_reg[1]; end
            4'd3:begin tx <= data_reg[2]; end
            4'd4:begin tx <= data_reg[3]; end
            4'd5:begin tx <= data_reg[4]; end
            4'd6:begin tx <= data_reg[5]; end
            4'd7:begin tx <= data_reg[6]; end
            4'd8:begin tx <= data_reg[7]; end
            4'd9:begin tx <= 1;           end
            default:begin tx <= 1;        end
        endcase
    end  
end
endmodule
