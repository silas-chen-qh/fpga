module key_fliter(
    input wire clk,
    input wire rst,
    input wire [4:0]key_in,
    output reg [4:0]key_val
)

localparam COUNT_MAX == 20d'500_000;

reg [19:0]  counter;

always@(posedge clk or posedeg rst)begin
    if(rst)
        counter <= 0;
    else if(key_in[0]==1&&key_in[1]==1&&key_in[2]==1&&key_in[3]==1)
        counter <= 0;
    else if(counter == COUNT_MAX)
        counter <= counter;
    else 
        counter <= counter  + 1;
end

always@(posedge clk or posedge rst)begin
    if(rst)
        key_val <= 4'b0000;
    else if(counter == COUNT_MAX - 1)
        begin
            if(key_in[0]==0)
                key_val <= 4'b0001;
            else if(key_in[1]==0)
                key_val <=   4'b0010;
            else if(key_in[2]==0)
                key_val <= 4'b0100;
            else if(key_in[3]==0)
                key_val <= 4'B1000;
            else 
                key_val <= 4'b0000;
        end
    else
        key_val <= 4'b0000;

end

endmodule
