//
// frac_interp.v
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


module frac_interp #(parameter bitwidth=10, parameter fracwidth=16) (
	input clk,
	input reset_n,
	input [bitwidth+fracwidth-1:0] stepsize,
	input [bitwidth-1:0] offset,
	input [bitwidth-1:0] limit, // Blank after this value is reached.
	input step_reset,
	input step_in,
	output reg step_out,
	output [bitwidth-1:0] whole,
	output reg [fracwidth-1:0] fraction,
	output blank
);

reg [bitwidth+fracwidth-1:0] spos;
wire [bitwidth-1:0] spos_whole = spos[bitwidth+fracwidth-1:fracwidth];
wire [fracwidth-1:0] spos_frac = spos[fracwidth-1:0];

reg [bitwidth-1:0] dpos;

reg [bitwidth-1:0] whole_i;
reg [bitwidth-1:0] offsetcounter;

always @(posedge clk) begin
	step_out<=1'b0;
	if (step_in) begin
		if(dpos>spos_whole) begin
			spos<=spos+stepsize;
			fraction<=spos_frac;
			step_out<=1'b1;
			whole_i<=whole_i+1;
		end else
			fraction<=0;
		if(|offsetcounter)
			offsetcounter<=offsetcounter-1;
		else
			dpos<=dpos+1'b1;
	end

	if (whole_i==limit)
		offsetcounter<={bitwidth{1'b1}}; // Ensure the rest of the span is blanked

	if (step_reset || !reset_n) begin
		spos<=0;
		dpos<=0;
		whole_i<=0;
		offsetcounter<=offset;
	end
end

assign whole=whole_i;

assign blank=|offsetcounter;

endmodule

