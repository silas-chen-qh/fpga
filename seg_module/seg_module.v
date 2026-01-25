module led_module(
    input wire clk,
    input wire rst,
    input wire [31:0] data_in,
    input wire [7:0] dp_in,
    output reg [7:0] seg,//段选
    output reg [7:0] sel//位选
);



localparam COUNT_MAX = 20'd50_000




reg [19:0] counter;
reg [3:0] bit;

assign wire data_now = data_in[8-1-bit +: 4]

always@(posedge clk or posedge rst)begin
    if(rst)
        counter <= 0;
    else if(counter == COUNT_MAX -1)
        counter <= 0;
    else 
        counter <= counter + 1;
end

always@(posedge clk or posedge rst)begin
    if(rst)begin
        seg<=8'b1111_1111;

        sel<=8'b1111_1111;
    end
    else if(counter ==  COUNT_MAX - 1)begin
        if(bit == 8)
            bit <= 0;
        else 
            bit <= bit + 1;

        case(data_now)
            4'd0: seg <= 8'hC0;
            4'h1: seg <= 8'hF9;
            4'h2: seg <= 8'hA4;
            4'h3: seg <= 8'hB0;
            4'h4: seg <= 8'h99;
            4'h5: seg <= 8'h92;
            4'h6: seg <= 8'h82;
            4'h7: seg <= 8'hF8;
            4'h8: seg <= 8'h80;
            4'h9: seg <= 8'h90;
            4'hA: seg <= 8'h88;
            4'hB: seg <= 8'h83;
            4'hC: seg <= 8'hC6;
            4'hD: seg <= 8'hA1;
            4'hE: seg <= 8'h86;
            4'hF: seg <= 8'h8E;
            default: seg = 8'hFF;
        endcase
        sel <= ~(0000_0001 << bit);
        seg[7] <= dp_in[8-1-bit];
    end

end


endmodule