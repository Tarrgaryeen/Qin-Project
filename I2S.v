module I2S(
    input clk,
    input rst_n,
    output reg [23:0] ldata,
    output reg [23:0] rdata,

    input key,
    output State,
    output mic_sck,   //串行时钟，对应每一位数据   f=声道数*采样频率+采样位数
    output mic_ws,    //字段选择信号    f=0左声道，f=1右声道
    input  mic_sd     //串行数据：用二进制补码表示的音频数据，由高位到低位传输
);

   key_filter key_filter_u(
      .clk(clk),
      .rst_n(rst_n),
      .Key(key),
      .Key_R_Flag(Key_R_Flag)
   );
   wire Key_R_Flag;

   parameter div_clk = 28;
   parameter div_ws  = div_clk * 64;

   reg [15:0] sck_cnt;
   reg [21:0] ws_cnt;
   reg [23:0] shift_reg_l;
   reg [23:0] shift_reg_r;

   reg State;
   reg led;

   assign mic_sck = (sck_cnt > div_clk/2-1) ? 1'b1 : 1'b0;
   assign mic_ws  = (ws_cnt > div_ws/2-1) ? 1'b1 : 1'b0;

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
            sck_cnt <= 0;
      end
      else begin
         if(sck_cnt == div_clk-1) begin
            sck_cnt <= 0;
         end
         else begin
            sck_cnt <= sck_cnt + 1;
         end
      end
   end

    always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         ws_cnt <= 0;
      end
      else begin
         if(ws_cnt == div_ws-1) begin
            ws_cnt <= 0;
         end
         else begin
            ws_cnt <= ws_cnt + 1;
         end
      end
   end

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         shift_reg_l <= 0;
         shift_reg_r <= 0;
      end
      else begin
         case(ws_cnt)   //通过位移寄存器将mic_sd存储到shift_reg_l和shift_reg_r中
            div_clk*1+div_clk/2-1 : begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*2+div_clk/2-1 : begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*3+div_clk/2-1 : begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*4+div_clk/2-1 : begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*5+div_clk/2-1 : begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*6+div_clk/2-1 : begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*7+div_clk/2-1 : begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*8+div_clk/2-1 : begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*9+div_clk/2-1 : begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*10+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*11+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*12+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*13+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*14+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*15+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*16+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*17+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*18+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*19+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*20+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*21+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*22+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*23+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end
            div_clk*24+div_clk/2-1: begin shift_reg_l <= {shift_reg_l[22:0],mic_sd}; shift_reg_r <= shift_reg_r; end

            div_clk*33+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*34+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*35+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*36+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*37+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*38+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*39+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*40+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*41+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*42+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*43+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*44+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*45+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*46+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*47+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*48+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*49+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*50+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*51+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*52+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*53+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*54+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*55+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end
            div_clk*56+div_clk/2-1: begin shift_reg_l <= shift_reg_l; shift_reg_r <= {shift_reg_r[22:0],mic_sd}; end

            default: begin shift_reg_l <= shift_reg_l; shift_reg_r <= shift_reg_r; end
         endcase
      end
   end

   always@(posedge Key_R_Flag)
      State <= ~State;

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         ldata <= 0;
         rdata <= 0;
      end
      else begin
         if(State) begin
            if((ws_cnt == div_clk*56+div_clk/2)) begin
               ldata <= shift_reg_l;
               rdata <= shift_reg_r;
            end
            else begin
               ldata <= ldata;
               rdata <= rdata;
            end
         end
         else begin
            ldata <= 0;
            rdata <= 0;
         end
      end
   end

endmodule
