module key_one(
    input wire clk,
    input wire rst,
    input wire key_in,
    output reg key_val
);

localparam COUNT_MAX = 20'd500_000;

reg [19:0] counter ;

always@(posedge clk or posedge rst)begin
    if(rst)
        counter <= 0;
    else if(key_in == 1)
        counter <= 0;
    else if(counter == COUNT_MAX )
        counter <= counter;

    else 
        counter <= counter +1;

end

always@(posedge clk or posedge rst)begin
    if(rst)
        key_val <= 1;
    else if(counter ==  COUNT_MAX - 1)begin
            if(key_in == 0)
                key_val <= 0;
            else
                key_val <= 1;
    end
    else 
        key_val <= 1;
end
    



endmodule