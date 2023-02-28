module I2S_DAC(
   input  clk50M,
   input  rst_n,
   input  Key,

   input  mic_sd,
   output mic_sck,
   output mic_ws,

   output led,
   output mic_out
);

   wire clk200M;
   wire signed [23:0] mic_data;
   wire [11:0] dac_data;
   wire led;

   assign dac_data = $unsigned((mic_data >>> 12) + 2047);

DAC_pll DAC_pll_u (     //IP核
   .pll_rst (1'b0),     // input
   .clkin1  (clk50M),   // input
   .pll_lock(),         // output
   .clkout0 (clk200M)   // output
);

I2S I2S_under(
   .clk(clk50M),
   .rst_n(rst_n),
   .ldata(),
   .rdata(mic_data[23:0]),

   .key(Key),
   .State(led),
   .mic_sck(mic_sck),
   .mic_ws(mic_ws),
   .mic_sd(mic_sd)
);

DAC DAC_under(
   .dac_clk(clk200M),
   .rst_n(rst_n),
   .din(dac_data),
   .dac_out(mic_out)
);

endmodule