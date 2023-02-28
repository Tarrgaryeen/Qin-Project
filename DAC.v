module DAC(
    input wire dac_clk,
    input wire rst_n,
    input wire [11:0] din,
    output wire dac_out//pwm输出
);

    parameter COUNT_MAX = 12'd4095;

    reg [11:0] count;

    always@(posedge	dac_clk or negedge rst_n)
        if(!rst_n)
            count <= 12'd0;
        else if(count == COUNT_MAX)
            count <= 12'd0;
        else
            count <= count + 1'b1;

    assign dac_out = (count <= din)?1'b1:1'b0;

endmodule