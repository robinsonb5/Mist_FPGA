//
// scandoubler_rotate.v
// 
// Copyright (c) 2024 Alastair M. Robinson
// 
// This source file is free software: you can redistribute it and/or modify 
// it under the terms of the GNU General Public License as published 
// by the Free Software Foundation, either version 3 of the License, or 
// (at your option) any later version. 
// 
// This source file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of 
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License 
// along with this program.  If not, see <http://www.gnu.org/licenses/>. 

// Streams incoming video data to an SDRAM port, in 16-word bursts.
// Incoming data is scaled to RGB565
//
// Streams data from SDRAM to output linebuffers in 8-word bursts
// Outgoing data is scaled to OUT_COLOR_DEPTH
//
// The SDRAM controller is responsible for the actual cornerturn.
//

module scandoubler_rotate
(
	// system interface
	input        clk_sys,

	input        bypass,
	input [1:0]  rotation, // 0 - no rotation, 1 - clockwise, 2 - anticlockwise

	// Pixelclock
	input            pe_in,
	input            pe_out,
	input            ppe_out,

	// incoming video interface
	input        hb_in,
	input        vb_in,
	input        hs_in,
	input        vs_in,
	input [COLOR_DEPTH-1:0] r_in,
	input [COLOR_DEPTH-1:0] g_in,
	input [COLOR_DEPTH-1:0] b_in,

	// output interface
	input        hb_sd,
	input        vb_sd,
	input        vs_sd,
	output [OUT_COLOR_DEPTH-1:0] r_out,
	output [OUT_COLOR_DEPTH-1:0] g_out,
	output [OUT_COLOR_DEPTH-1:0] b_out,

	// Memory interface - to RAM.  Operates on 16-word bursts
	output reg          vidin_req,    // High at start of row, remains high until burst of 16 pixels has been delivered
	output wire         vidin_frame,  // Odd or even frame for double-buffering
	output reg [9:0]    vidin_row,    // Y position of current row.
	output reg [9:0]    vidin_col,    // X position of current burst.
	output reg [15:0]   vidin_d,      // Incoming video data
	input wire          vidin_ack,    // Request next word from host
	
	// Memory interface - from RAM.  Operates on 8-word bursts
	output wire         vidout_req,   // High at start of row, remains high until entire row has been delivered
	output wire         vidout_frame, // Odd or even frame for double-buffering
	output wire [9:0]   vidout_row,   // Y position of current row.  (Controller maintains X counter)
	output wire [9:0]   vidout_col,   // Y position of current row.  (Controller maintains X counter)
	input wire [15:0]   vidout_d,     // Outgoing video data
	input wire          vidout_ack    // Valid data available.
);

parameter HCNT_WIDTH = 10; // Resolution of scandoubler buffer
parameter COLOR_DEPTH = 6; // Bits per colour to be stored in the buffer
parameter OUT_COLOR_DEPTH = 6; // Bits per color outputted


// Scale incoming video signal to RGB565
wire [15:0] vin_rgb565;

scandoubler_scaledepth #(.IN_DEPTH(COLOR_DEPTH),.OUT_DEPTH(5)) scalein_r (.d(r_in),.q(vin_rgb565[15:11]));
scandoubler_scaledepth #(.IN_DEPTH(COLOR_DEPTH),.OUT_DEPTH(6)) scalein_g (.d(g_in),.q(vin_rgb565[10:5]));
scandoubler_scaledepth #(.IN_DEPTH(COLOR_DEPTH),.OUT_DEPTH(5)) scalein_b (.d(b_in),.q(vin_rgb565[4:0]));



// Stream incoming pixels to SDRAM, taking care of inverting either X or Y coordinates.
// The SDRAM controller does the actual cornerturn.


// Framing
reg [HCNT_WIDTH-1:0] in_xpos;
reg [HCNT_WIDTH-1:0] in_ypos;
reg [HCNT_WIDTH-1:0] in_xpos_max;
reg [HCNT_WIDTH-1:0] in_ypos_max;
reg hb_in_d;

// Toggle logical / physical frame every vblank
reg logicalframe = 1'b0;
reg vb_d = 1'b1;
always @(posedge clk_sys) begin
	vb_d<=vb_in;
	if(!vb_d && vb_in) begin
		logicalframe<=~logicalframe;
		in_ypos_max<=in_ypos-1'b1;
	end
end

always @(posedge clk_sys) begin
	hb_in_d<=hb_in;
	if(vb_in)
		in_ypos<=10'd0;
	else if(!hb_in_d && hb_in)	begin // Increment row on hblank
		in_ypos<=in_ypos+10'd1;
		in_xpos_max <= in_xpos; // Round up to (next multiple of 8)-1
	end
end

always @(posedge clk_sys) begin
	if(hb_in)
		in_xpos<=10'd0;
	else if(pe_in)
		in_xpos<=in_xpos+10'd1;	// Increment column on pixel enable
end

// Buffer incoming video data and write to SDRAM.  (16 word bursts, striped across two banks, SDRAM controller handles )

reg [15:0] rowbuf[0:31] /* synthesis ramstyle="logic" */;
reg [4:0] rowwptr;
reg [4:0] rowrptr;
reg running=1'b0;

wire [3:0] escape,start;
assign start = rotation[0] ? 4'b0000 : 4'b1111;
assign escape = rotation[0] ? 4'b1111 : 4'b0000;

always @(posedge clk_sys) begin

	// Reset on vblank
	if(vb_in) begin
		running<=1'b1; // (rotation!=2'b00 && !bypass);
		rowwptr<=5'h0;
	end

	// Don't update row during hblank (gives buffer time to empty)
	if(!hb_in) begin
		if(rotation[0])
			vidin_row<=in_ypos_max-in_ypos;
		else
			vidin_row<=in_ypos;
	end
	// Write incoming pixels to a line buffer
	if(running && pe_in && !vb_in && !hb_in) begin
		rowbuf[rowwptr]<=vin_rgb565;
		if((rowwptr[3:0]==4'b1111) || (hb_in & !hb_in_d)) begin
			if(rotation[0])
				vidin_col<=in_xpos;
			else
				vidin_col<=in_xpos_max - in_xpos;	// Low 4 bits will be overriden
			vidin_req<=1'b1;
			rowrptr<={rowwptr[4],start};
		end
		rowwptr<=rowwptr+1'b1;
	end

	// Write pixels from linebuffer to SDRAM
	vidin_d <= rowbuf[rowrptr];
	vidin_col[3:0] <= rowrptr[3:0];
	if(vidin_ack) begin
		if(rowrptr[3:0]==escape)
			vidin_req<=1'b0;
		if(rotation[0])
			rowrptr<=rowrptr+1'b1;
		else
			rowrptr<=rowrptr-1'b1;
	end
end

assign vidin_frame = logicalframe;


// Pixel read process - streams data from SDRAM to linebuffers.

reg [15:0] linebuffer1 [0:2**HCNT_WIDTH-1];
// reg [15:0] linebuffer2 [0:2**HCNT_WIDTH-1];

reg fetch;

reg [HCNT_WIDTH-1:0] fetch_xpos;
reg [HCNT_WIDTH-1:0] sd_ypos;
reg [HCNT_WIDTH:0] sd_yacc;

reg hb_sd_d;
reg vs_sd_d;

always @(posedge clk_sys) begin
	hb_sd_d<=hb_sd;
	vs_sd_d<=vs_sd;
	if(vb_sd) begin
		sd_ypos<=10'd0;
		sd_yacc<=11'd0;
	end else if(!hb_sd_d && hb_sd) begin // Increment row on hblank
		sd_yacc<=sd_yacc+in_xpos_max;
	end
	
	if (sd_yacc>{in_ypos_max,1'b0}) begin
		fetch_xpos<=10'd0;
		sd_ypos<=sd_ypos+10'd1;
		fetch<=sd_ypos == (in_xpos_max-1'b1) ? 1'b0 : 1'b1; // Stop fetching if rounding causes us to reach the foot of the screen a row or two early.
		sd_yacc<=sd_yacc-{in_ypos_max,1'b0};
	end

	if(!vs_sd_d && vs_sd) begin
		fetch_xpos <= 10'd0;
		fetch<=1'b1;
	end

	if(fetch_xpos==in_ypos_max) begin
		fetch<=1'b0;
	end
	
	if(vidout_ack) begin
		fetch_xpos<=fetch_xpos+10'd1;
//		if(sd_ypos[0])
			linebuffer1[fetch_xpos]<=vidout_d;
//		else
//			linebuffer2[fetch_xpos]<=vidout_d;
	end
	
end

assign vidout_row = sd_ypos;
assign vidout_col = fetch_xpos;

assign vidout_frame = ~logicalframe;
assign vidout_req = fetch;

reg [HCNT_WIDTH-1:0] sd_xpos;
reg [HCNT_WIDTH:0] sd_xacc;
reg [HCNT_WIDTH-1:0] sd_xoffset;

reg [15:0] vout_rgb565;

always @(posedge clk_sys) begin
	if(hb_sd) begin
		sd_xpos<=10'd0;
		sd_xacc<=10'd0;
		sd_xoffset<=in_xpos_max-in_ypos_max;
	end

	if(sd_xacc>{in_ypos_max,1'b0}) begin
		sd_xacc<=sd_xacc-{in_ypos_max,1'b0};
		if(|sd_xoffset)
			sd_xoffset<=sd_xoffset-1'b1;
		else
			sd_xpos<=sd_xpos+1'b1;
	end

	if(!hb_sd && ppe_out)
		sd_xacc<=sd_xacc+in_xpos_max;

	if((sd_xpos==in_ypos_max) && ppe_out)
		sd_xoffset<=10'h3ff;

//	if(sd_ypos[0])
		vout_rgb565<=|sd_xoffset ? 16'h0 : linebuffer1[sd_xpos];
//	else
//		vout_rgb565<=|sd_xoffset ? 16'h0 : linebuffer2[sd_xpos];
end

scandoubler_scaledepth #(.IN_DEPTH(5),.OUT_DEPTH(OUT_COLOR_DEPTH)) scaleout_r (.d(vout_rgb565[15:11]),.q(r_out));
scandoubler_scaledepth #(.IN_DEPTH(6),.OUT_DEPTH(OUT_COLOR_DEPTH)) scaleout_g (.d(vout_rgb565[10:5]),.q(g_out));
scandoubler_scaledepth #(.IN_DEPTH(5),.OUT_DEPTH(OUT_COLOR_DEPTH)) scaleout_b (.d(vout_rgb565[4:0]),.q(b_out));

endmodule


