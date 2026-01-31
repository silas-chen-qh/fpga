module uart_bits_tx(
    input clk,
    input rst,
    input start,

    output uart_tx,
    output bits_done

);
reg [2:0] state;
reg [7:0] data [0:11];
initial begin
    data[0]="H"; data[1]="e"; data[2]="l"; data[3]="l"; data[4]="o"; data[5]=" ";
    data[6]="W"; data[7]="o"; data[8]="r"; data[9]="l"; data[10]="d"; data[11]="!";
end

reg [7:0] data_bit;
reg [3:0]  send_ptr;
reg send_go;
reg bit_done

localparam  IDLE = 2'd0;
localparam  SEND = 2'd1;
localparam  BUSY = 2'd2;

always@(posedge clk or posedge rst)begin
    if(rst)begin
        state <= IDLE;
        send_ptr <= 0;
        send_go <= 0;
    end
    else begin case(state)
        IDLE:begin
            if(start)
                state <= SEND;
                send_ptr <= 0;
            else
                state <= state;
        end
        SEND:begin
                send_go <= 1;
                data_bit <= data[send_ptr];
                state   <= BUSY;
        end
        BUSY:begin
                send_go <= 0;
                if(bit_done)begin

                    if(send_ptr == 11)
                        state <= IDLE;
                    else begin
                        send_ptr <= send_prj +1;
                        state <= SEND;
                    end
                end
        end
        default: state <= IDLE;
    endcase
    end
end

always@(posedge clk or posedge rst)
    if(rst)
        bits_done <= 0;
    else if((send_ptr == 11)&&bit_done)
        bits_done <= 1;
    else
        bits_done <= 0;

 uart_tx #(
        .BAUT(9600),
        .CLK_RATE(50_000_000)
    ) u_uart_tx (
        .clk           (clk),
        .rst           (rst),
        .data          (data),
        .send_go       (send_go),
        .send_complete (), 
        .uart_tx       (uart_tx),
        .led           ()         // 暂时不用
    );
endmodule