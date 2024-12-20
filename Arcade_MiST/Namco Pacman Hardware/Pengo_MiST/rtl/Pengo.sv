//============================================================================
//  Arcade: Pengo
//
//  Port to MiSTer
//  Copyright (C) 2017 Sorgelig
//
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//============================================================================

module Pengo(
	input         CLOCK_27,
`ifdef USE_CLOCK_50
	input         CLOCK_50,
`endif

	output        LED,
	output [VGA_BITS-1:0] VGA_R,
	output [VGA_BITS-1:0] VGA_G,
	output [VGA_BITS-1:0] VGA_B,
	output        VGA_HS,
	output        VGA_VS,

`ifdef USE_HDMI
	output        HDMI_RST,
	output  [7:0] HDMI_R,
	output  [7:0] HDMI_G,
	output  [7:0] HDMI_B,
	output        HDMI_HS,
	output        HDMI_VS,
	output        HDMI_PCLK,
	output        HDMI_DE,
	input         HDMI_INT,
	inout         HDMI_SDA,
	inout         HDMI_SCL,
`endif

	input         SPI_SCK,
	inout         SPI_DO,
	input         SPI_DI,
	input         SPI_SS2,    // data_io
	input         SPI_SS3,    // OSD
	input         CONF_DATA0, // SPI_SS for user_io

`ifdef USE_QSPI
	input         QSCK,
	input         QCSn,
	inout   [3:0] QDAT,
`endif
`ifndef NO_DIRECT_UPLOAD
	input         SPI_SS4,
`endif

	output [12:0] SDRAM_A,
	inout  [15:0] SDRAM_DQ,
	output        SDRAM_DQML,
	output        SDRAM_DQMH,
	output        SDRAM_nWE,
	output        SDRAM_nCAS,
	output        SDRAM_nRAS,
	output        SDRAM_nCS,
	output  [1:0] SDRAM_BA,
	output        SDRAM_CLK,
	output        SDRAM_CKE,

`ifdef DUAL_SDRAM
	output [12:0] SDRAM2_A,
	inout  [15:0] SDRAM2_DQ,
	output        SDRAM2_DQML,
	output        SDRAM2_DQMH,
	output        SDRAM2_nWE,
	output        SDRAM2_nCAS,
	output        SDRAM2_nRAS,
	output        SDRAM2_nCS,
	output  [1:0] SDRAM2_BA,
	output        SDRAM2_CLK,
	output        SDRAM2_CKE,
`endif

	output        AUDIO_L,
	output        AUDIO_R,
`ifdef I2S_AUDIO
	output        I2S_BCK,
	output        I2S_LRCK,
	output        I2S_DATA,
`endif
`ifdef I2S_AUDIO_HDMI
	output        HDMI_MCLK,
	output        HDMI_BCK,
	output        HDMI_LRCK,
	output        HDMI_SDATA,
`endif
`ifdef SPDIF_AUDIO
	output        SPDIF,
`endif
`ifdef USE_AUDIO_IN
	input         AUDIO_IN,
`endif
	input         UART_RX,
	output        UART_TX

);

`ifdef NO_DIRECT_UPLOAD
localparam bit DIRECT_UPLOAD = 0;
wire SPI_SS4 = 1;
`else
localparam bit DIRECT_UPLOAD = 1;
`endif

`ifdef USE_QSPI
localparam bit QSPI = 1;
assign QDAT = 4'hZ;
`else
localparam bit QSPI = 0;
`endif

`ifdef VGA_8BIT
localparam VGA_BITS = 8;
`else
localparam VGA_BITS = 6;
`endif

`ifdef USE_HDMI
localparam bit HDMI = 1;
assign HDMI_RST = 1'b1;
`else
localparam bit HDMI = 0;
`endif

`ifdef BIG_OSD
localparam bit BIG_OSD = 1;
`define SEP "-;",
`else
localparam bit BIG_OSD = 0;
`define SEP
`endif

// remove this if the 2nd chip is actually used
`ifdef DUAL_SDRAM
assign SDRAM2_A = 13'hZZZZ;
assign SDRAM2_BA = 0;
assign SDRAM2_DQML = 1;
assign SDRAM2_DQMH = 1;
assign SDRAM2_CKE = 0;
assign SDRAM2_CLK = 0;
assign SDRAM2_nCS = 1;
assign SDRAM2_DQ = 16'hZZZZ;
assign SDRAM2_nCAS = 1;
assign SDRAM2_nRAS = 1;
assign SDRAM2_nWE = 1;
`endif

`include "build_id.v" 

localparam CONF_STR = {
	"Pengo;;",
	"O67,Rotate Screen,90 Degrees,Off,180 Degrees;",
	"O8,Rotation filter,On,Off;",
	"O2,Rotate Controls,Off,On;",
	"O34,Scanlines,Off,25%,50%,75%;",
	"O5,Blend,Off,On;",
	"T0,Reset;",
	"V,v1.20.",`BUILD_DATE
};

wire        rotate = status[2];
wire  [1:0] scanlines = status[4:3];
wire        blend = status[5];
wire  [1:0] rotate_screen_raw = status[7:6];
wire  [1:0] rotate_screen = {rotate_screen_raw[1],~rotate_screen_raw[0]};
wire        rotate_filter = ~status[8];

assign LED = 1;
assign AUDIO_R = AUDIO_L;

wire clk_mem, clk_sys, clk_vid, clk_snd = clk_vid;

wire pll_locked;
pll pll(
	.inclk0(CLOCK_27),
	.areset(0),
	.c0(clk_vid),
	.c1(clk_sys),
	.c2(clk_mem),
	.c3(SDRAM_CLK),
	.locked(pll_locked)
	);

assign SDRAM_CKE = pll_locked;

reg ce_6m;
always @(posedge clk_sys) begin
	reg [1:0] div;
	div <= div + 1'd1;
	ce_6m <= !div;
end

wire        ioctl_downl;
wire  [7:0] ioctl_index;
wire        ioctl_wr;
wire [24:0] ioctl_addr;
wire  [7:0] ioctl_dout;

data_io data_io(
	.clk_sys       ( clk_sys      ),
	.SPI_SCK       ( SPI_SCK      ),
	.SPI_SS2       ( SPI_SS2      ),
	.SPI_DI        ( SPI_DI       ),
	.ioctl_download( ioctl_downl  ),
	.ioctl_index   ( ioctl_index  ),
	.ioctl_wr      ( ioctl_wr     ),
	.ioctl_addr    ( ioctl_addr   ),
	.ioctl_dout    ( ioctl_dout   )
);

wire [63:0] status;
wire  [1:0] buttons;
wire  [1:0] switches;
wire  [31:0] joystick_0;
wire  [31:0] joystick_1;
wire        scandoublerD;
wire        ypbpr;
wire        no_csync;
wire        key_strobe;
wire        key_pressed;
wire  [7:0] key_code;
`ifdef USE_HDMI
wire        i2c_start;
wire        i2c_read;
wire  [6:0] i2c_addr;
wire  [7:0] i2c_subaddr;
wire  [7:0] i2c_dout;
wire  [7:0] i2c_din;
wire        i2c_ack;
wire        i2c_end;
`endif

user_io #(
	.STRLEN(($size(CONF_STR)>>3)),
	.FEATURES(32'h0 | (BIG_OSD << 13) | (HDMI << 14)))
user_io(
	.clk_sys        (clk_sys        ),
	.conf_str       (CONF_STR       ),
	.SPI_CLK        (SPI_SCK        ),
	.SPI_SS_IO      (CONF_DATA0     ),
	.SPI_MISO       (SPI_DO         ),
	.SPI_MOSI       (SPI_DI         ),
	.buttons        (buttons        ),
	.switches       (switches       ),
	.scandoubler_disable (scandoublerD	  ),
	.ypbpr          (ypbpr          ),
	.no_csync       (no_csync       ),
`ifdef USE_HDMI
	.i2c_start      (i2c_start      ),
	.i2c_read       (i2c_read       ),
	.i2c_addr       (i2c_addr       ),
	.i2c_subaddr    (i2c_subaddr    ),
	.i2c_dout       (i2c_dout       ),
	.i2c_din        (i2c_din        ),
	.i2c_ack        (i2c_ack        ),
	.i2c_end        (i2c_end        ),
`endif
	.key_strobe     (key_strobe     ),
	.key_pressed    (key_pressed    ),
	.key_code       (key_code       ),
	.joystick_0     (joystick_0     ),
	.joystick_1     (joystick_1     ),
	.status         (status         )
	);

wire  [7:0] audio;
wire        hs, vs;
wire        hb, vb;
wire  [2:0] r,g;
wire  [1:0] b;

// reset generation
reg reset = 1;
reg rom_loaded = 0;
always @(posedge clk_sys) begin
	reg ioctl_downlD;
	ioctl_downlD <= ioctl_downl;

	if (ioctl_downlD & ~ioctl_downl) rom_loaded <= 1;
	reset <= status[0] | buttons[1] | ~rom_loaded | ioctl_downl;
end


PACMAN_MACHINE Pengo(
	.video_r(r),
	.video_g(g),
	.video_b(b),
	.hsync(hs),
	.vsync(vs),
	.h_blank(hb),
	.v_blank(vb),
	.audio(audio),
	.in0_reg(~{m_fireA, 2'b00,m_coin1,m_right,m_left,m_down,m_up}),
	.in1_reg(~{1'b0, m_two_players, m_one_player, 5'b00000}),
	.dipsw1_reg(8'b11100000),
	.dipsw2_reg(8'b11001100),
	.RESET(reset),
	.CLK(clk_sys),
	.ENA_6(ce_6m),

	.rom_addr(rom_addr),
	.rom_dout(rom_addr[0] ? rom_dout[15:8] : rom_dout[7:0]),

	.dl_addr(ioctl_addr[15:0]),
	.dl_wr(ioctl_wr),
	.dl_data(ioctl_dout)
);

wire vidin_req;
wire vidin_ack;
wire [10:0] vidin_x;
wire [10:0] vidin_y;
wire [15:0] vidin_d;
wire vidin_frame;

wire vidout_req;
wire vidout_ack;
wire [10:0] vidout_x;
wire [10:0] vidout_y;
wire [15:0] vidout_d;
wire vidout_frame;

mist_video #(.COLOR_DEPTH(3),.SD_HCNT_WIDTH(10)) mist_video(
	.clk_sys(clk_mem),
	.SPI_SCK(SPI_SCK),
	.SPI_SS3(SPI_SS3),
	.SPI_DI(SPI_DI),
	.R(r),
	.G(g),
	.B({b, 1'b0}),
	.HBlank(hb),
	.VBlank(vb),
	.HSync(~hs),
	.VSync(~vs),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B),
	.VGA_VS(VGA_VS),
	.VGA_HS(VGA_HS),
	.rotate({~rotate_screen[1],(~rotate) & ~(^rotate_screen)}),
//	.rotate({1'b1,rotate}),
	.rotate_screen(rotate_screen),
	.rotate_hfilter(rotate_filter),
	.rotate_vfilter(rotate_filter),	
	.scandoubler_disable(scandoublerD),
	.scanlines(scanlines),
	.ce_divider(4'hf),
	.blend(blend),
	.ypbpr(ypbpr),
	.no_csync(no_csync),
	// SDRAM interface for rotation
	.vidin_req  ( vidin_req  ),
	.vidin_d    ( vidin_d    ),
	.vidin_ack  ( vidin_ack  ),
	.vidin_frame(vidin_frame ),
	.vidin_x    ( vidin_x  ),
	.vidin_y    ( vidin_y  ),

	.vidout_req( vidout_req  ),
	.vidout_d  ( vidout_d    ),
	.vidout_ack( vidout_ack  ),
	.vidout_frame( vidout_frame),
	.vidout_x  ( vidout_x    ),
	.vidout_y  ( vidout_y    )
);

reg      port1_req;
wire     port1_ack;
reg [15:0] rom_dout;
reg [14:0] rom_addr;

wire sdram_ready;

// SDRAM controller
scandoubler_sdram sdram_ctrl (
	.sd_data(SDRAM_DQ),   // 16 bit bidirectional data bus
	.sd_addr(SDRAM_A),    // 13 bit multiplexed address bus
	.sd_dqm({SDRAM_DQMH,SDRAM_DQML}), // two byte masks
	.sd_ba(SDRAM_BA),   // two banks
	.sd_cs(SDRAM_nCS),  // a single chip select
	.sd_we(SDRAM_nWE),  // write enable
	.sd_ras(SDRAM_nRAS), // row address select
	.sd_cas(SDRAM_nCAS), // columns address select

	.clk_96(clk_mem),
	.init(~pll_locked),
	.ready(sdram_ready),

	// ROM upload
	.port1_req     ( port1_req    ),
	.port1_ack     ( port1_ack    ),
	.port1_addr    ( ioctl_addr[22:1] ),
	.port1_ds      ( { ioctl_addr[0], ~ioctl_addr[0] } ),
	.port1_we      ( ioctl_downl ),
	.port1_din     ( {ioctl_dout, ioctl_dout} ),

	// CPU
	.rom_oe       ( !ioctl_downl ),
	.rom_addr     ( ioctl_downl ? 17'h1ffff : {3'b000, rom_addr[14:1] } ),
	.rom_dout     ( rom_dout  ),

	// SDRAM interface for rotation
	.vidin_req  ( vidin_req  ),
	.vidin_d    ( vidin_d    ),
	.vidin_ack  ( vidin_ack  ),
	.vidin_frame(vidin_frame ),
	.vidin_x  ( vidin_x  ),
	.vidin_y  ( vidin_y  ),

	.vidout_req( vidout_req  ),
	.vidout_q  ( vidout_d    ),
	.vidout_ack( vidout_ack  ),
	.vidout_frame( vidout_frame),
	.vidout_x ( vidout_x  ),
	.vidout_y ( vidout_y  )
);

always @(posedge clk_vid) begin
	reg ioctl_wr_last = 0;

	if(port1_ack)
		port1_req<=1'b0;
	
	ioctl_wr_last <= ioctl_wr;
	if (ioctl_downl) begin
		if (~ioctl_wr_last && ioctl_wr) begin
			port1_req <= 1'b1;
		end
	end
end

	
dac #(
	.C_bits(8))
dac(
	.clk_i(clk_snd),
	.res_n_i(1),
	.dac_i(audio),
	.dac_o(AUDIO_L)
	);

// controls
wire m_up, m_down, m_left, m_right, m_fireA, m_fireB, m_fireC, m_fireD, m_fireE, m_fireF;
wire m_up2, m_down2, m_left2, m_right2, m_fire2A, m_fire2B, m_fire2C, m_fire2D, m_fire2E, m_fire2F;
wire m_tilt, m_coin1, m_coin2, m_coin3, m_coin4, m_one_player, m_two_players, m_three_players, m_four_players;

arcade_inputs #(.START1(10), .START2(12), .COIN1(11)) inputs (
	.clk         ( clk_sys     ),
	.key_strobe  ( key_strobe  ),
	.key_pressed ( key_pressed ),
	.key_code    ( key_code    ),
	.joystick_0  ( joystick_0  ),
	.joystick_1  ( joystick_1  ),
	.rotate      ( rotate | ^rotate_screen), // Only rotate controls if screen if scandoubler isn't rotating
	.orientation ( {rotate_screen[1], (^rotate_screen)} ),
//	.rotate      ( rotate      ),
//	.orientation ( {1'b1, ~|rotate_screen} ),
	.joyswap     ( 1'b0        ),
	.oneplayer   ( 1'b1        ),
	.controls    ( {m_tilt, m_coin4, m_coin3, m_coin2, m_coin1, m_four_players, m_three_players, m_two_players, m_one_player} ),
	.player1     ( {m_fireF, m_fireE, m_fireD, m_fireC, m_fireB, m_fireA, m_up, m_down, m_left, m_right} ),
	.player2     ( {m_fire2F, m_fire2E, m_fire2D, m_fire2C, m_fire2B, m_fire2A, m_up2, m_down2, m_left2, m_right2} )
);

endmodule 
