`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:30:38 03/19/2013 
// Design Name: 
// Module Name:    vga640x480 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module vga640x480(
	input wire dclk,			//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
	input [9:0] playerX,
	input [8:0] playerY,
	input [9:0] player_bullet_x,
	input [8:0] player_bullet_y,
	input enemy1,
	input enemy2,
	input enemy3,
	input enemy4,
	input enemy5,
	input enemy6,
	input enemy7,
	input [8:0] enemy1_bullet,
	input [8:0] enemy2_bullet,
	input [8:0] enemy3_bullet,
	input [8:0] enemy4_bullet,
	input [8:0] enemy5_bullet,
	input [8:0] enemy6_bullet,
	input [8:0] enemy7_bullet,
	input [1:0] lives,
	input [6:0] bossHP,
	input bossActive,
	input win,
	input lose,
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue	//blue vga output
	);


parameter PLAYER_WIDTH = 9; //half
parameter PLAYER_HEIGHT = 9; //half
parameter PLAYER_SPEED = 2;
parameter PLAYER_BULLET_SPEED = 4;
parameter PLAYER_BULLET_WIDTH = 1; //half
parameter PLAYER_BULLET_HEIGHT = 5;

parameter ENEMY_WIDTH = 7; //half
parameter ENEMY_HEIGHT = 7; //half
parameter ENEMY_BULLET_SPEED = 2;
parameter ENEMY_BULLET_SIZE = 3; //half

parameter BOSS_LEFT = 256;
parameter BOSS_RIGHT = 384;
parameter BOSS_TOP = 420;
parameter BOSS_BOTTOM = 360;


// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr)
begin
	// reset condition
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =
always @(*)
begin
	// first check if we're within vertical active video range
	if (vc >= vbp && vc < vfp && hc >= hbp && hc < hfp)
	begin

		// default
		red = 0;
		green = 0;
		blue = 0;


		// draw enemies
		//if(enemy1 && hc >= hbp + 128 - ENEMY_WIDTH && hc <= hbp + 128 + ENEMY_WIDTH && vc >= vfp - 420 - ENEMY_HEIGHT && vc <= vfp - 420 + ENEMY_HEIGHT) begin
		if(enemy1 && (((hc >= hbp + 128 - ENEMY_WIDTH && hc <= hbp + 128 - ENEMY_WIDTH + 2) || 
		(hc <= hbp + 128 + ENEMY_WIDTH && hc >= hbp + 128 + ENEMY_WIDTH - 2)) && (vc >= vfp - 420 - ENEMY_HEIGHT && vc <= vfp - 420 + ENEMY_HEIGHT) ||
		(hc >= hbp + 128 - ENEMY_WIDTH && hc <= hbp + 128 + ENEMY_WIDTH && vc >= vfp - 420 - 1 && vc <= vfp - 420 + 1) ||
		(hc >= hbp + 128 - 2 && hc <= hbp + 128 + 2 && vc >= vfp - 420 - 2 && vc <= vfp - 420 + 2))) begin
			red = 3'b111;
			green = 0;
			blue = 2'b11;
		end
		//if(enemy2 && hc >= hbp + 256 - ENEMY_WIDTH && hc <= hbp + 256 + ENEMY_WIDTH && vc >= vfp - 420 - ENEMY_HEIGHT && vc <= vfp - 420 + ENEMY_HEIGHT) begin
		if(enemy2 && (((hc >= hbp + 256 - ENEMY_WIDTH && hc <= hbp + 256 - ENEMY_WIDTH + 2) || 
		(hc <= hbp + 256 + ENEMY_WIDTH && hc >= hbp + 256 + ENEMY_WIDTH - 2)) && (vc >= vfp - 420 - ENEMY_HEIGHT && vc <= vfp - 420 + ENEMY_HEIGHT) ||
		(hc >= hbp + 256 - ENEMY_WIDTH && hc <= hbp + 256 + ENEMY_WIDTH && vc >= vfp - 420 - 1 && vc <= vfp - 420 + 1) ||
		(hc >= hbp + 256 - 2 && hc <= hbp + 256 + 2 && vc >= vfp - 420 - 2 && vc <= vfp - 420 + 2))) begin
			red = 3'b111;
			green = 0;
			blue = 2'b11;
		end
		//if(enemy3 && hc >= hbp + 384 - ENEMY_WIDTH && hc <= hbp + 384 + ENEMY_WIDTH && vc >= vfp - 420 - ENEMY_HEIGHT && vc <= vfp - 420 + ENEMY_HEIGHT) begin
		if(enemy3 && (((hc >= hbp + 384 - ENEMY_WIDTH && hc <= hbp + 384 - ENEMY_WIDTH + 2) || 
		(hc <= hbp + 384 + ENEMY_WIDTH && hc >= hbp + 384 + ENEMY_WIDTH - 2)) && (vc >= vfp - 420 - ENEMY_HEIGHT && vc <= vfp - 420 + ENEMY_HEIGHT) ||
		(hc >= hbp + 384 - ENEMY_WIDTH && hc <= hbp + 384 + ENEMY_WIDTH && vc >= vfp - 420 - 1 && vc <= vfp - 420 + 1) ||
		(hc >= hbp + 384 - 2 && hc <= hbp + 384 + 2 && vc >= vfp - 420 - 2 && vc <= vfp - 420 + 2))) begin
			red = 3'b111;
			green = 0;
			blue = 2'b11;
		end
		//if(enemy4 && hc >= hbp + 512 - ENEMY_WIDTH && hc <= hbp + 512 + ENEMY_WIDTH && vc >= vfp - 420 - ENEMY_HEIGHT && vc <= vfp - 420 + ENEMY_HEIGHT) begin
		if(enemy4 && (((hc >= hbp + 512 - ENEMY_WIDTH && hc <= hbp + 512 - ENEMY_WIDTH + 2) || 
		(hc <= hbp + 512 + ENEMY_WIDTH && hc >= hbp + 512 + ENEMY_WIDTH - 2)) && (vc >= vfp - 420 - ENEMY_HEIGHT && vc <= vfp - 420 + ENEMY_HEIGHT) ||
		(hc >= hbp + 512 - ENEMY_WIDTH && hc <= hbp + 512 + ENEMY_WIDTH && vc >= vfp - 420 - 1 && vc <= vfp - 420 + 1) ||
		(hc >= hbp + 512 - 2 && hc <= hbp + 512 + 2 && vc >= vfp - 420 - 2 && vc <= vfp - 420 + 2))) begin
			red = 3'b111;
			green = 0;
			blue = 2'b11;
		end
		//if(enemy5 && hc >= hbp + 160 - ENEMY_WIDTH && hc <= hbp + 160 + ENEMY_WIDTH && vc >= vfp - 360 - ENEMY_HEIGHT && vc <= vfp - 360 + ENEMY_HEIGHT) begin
		if(enemy5 && (((hc >= hbp + 160 - ENEMY_WIDTH && hc <= hbp + 160 - ENEMY_WIDTH + 2) || 
		(hc <= hbp + 160 + ENEMY_WIDTH && hc >= hbp + 160 + ENEMY_WIDTH - 2)) && (vc >= vfp - 360 - ENEMY_HEIGHT && vc <= vfp - 360 + ENEMY_HEIGHT) ||
		(hc >= hbp + 160 - ENEMY_WIDTH && hc <= hbp + 160 + ENEMY_WIDTH && vc >= vfp - 360 - 1 && vc <= vfp - 360 + 1) ||
		(hc >= hbp + 160 - 2 && hc <= hbp + 160 + 2 && vc >= vfp - 360 - 2 && vc <= vfp - 360 + 2))) begin
			red = 3'b111;
			green = 0;
			blue = 2'b11;
		end
		//if(enemy6 && hc >= hbp + 320 - ENEMY_WIDTH && hc <= hbp + 320 + ENEMY_WIDTH && vc >= vfp - 360 - ENEMY_HEIGHT && vc <= vfp - 360 + ENEMY_HEIGHT) begin
		if(enemy6 && (((hc >= hbp + 320 - ENEMY_WIDTH && hc <= hbp + 320 - ENEMY_WIDTH + 2) || 
		(hc <= hbp + 320 + ENEMY_WIDTH && hc >= hbp + 320 + ENEMY_WIDTH - 2)) && (vc >= vfp - 360 - ENEMY_HEIGHT && vc <= vfp - 360 + ENEMY_HEIGHT) ||
		(hc >= hbp + 320 - ENEMY_WIDTH && hc <= hbp + 320 + ENEMY_WIDTH && vc >= vfp - 360 - 1 && vc <= vfp - 360 + 1) ||
		(hc >= hbp + 320 - 2 && hc <= hbp + 320 + 2 && vc >= vfp - 360 - 2 && vc <= vfp - 360 + 2))) begin
			red = 3'b111;
			green = 0;
			blue = 2'b11;
		end
		//if(enemy7 && hc >= hbp + 480 - ENEMY_WIDTH && hc <= hbp + 480 + ENEMY_WIDTH && vc >= vfp - 360 - ENEMY_HEIGHT && vc <= vfp - 360 + ENEMY_HEIGHT) begin
		if(enemy7 && (((hc >= hbp + 480 - ENEMY_WIDTH && hc <= hbp + 480 - ENEMY_WIDTH + 2) || 
		(hc <= hbp + 480 + ENEMY_WIDTH && hc >= hbp + 480 + ENEMY_WIDTH - 2)) && (vc >= vfp - 360 - ENEMY_HEIGHT && vc <= vfp - 360 + ENEMY_HEIGHT) ||
		(hc >= hbp + 480 - ENEMY_WIDTH && hc <= hbp + 480 + ENEMY_WIDTH && vc >= vfp - 360 - 1 && vc <= vfp - 360 + 1) ||
		(hc >= hbp + 480 - 2 && hc <= hbp + 480 + 2 && vc >= vfp - 360 - 2 && vc <= vfp - 360 + 2))) begin
			red = 3'b111;
			green = 0;
			blue = 2'b11;
		end

		// draw player bullet
		if(hc >= hbp + player_bullet_x - PLAYER_BULLET_WIDTH && hc <= hbp + player_bullet_x + PLAYER_BULLET_WIDTH && vc >= vfp - player_bullet_y - PLAYER_BULLET_HEIGHT && vc <= vfp - player_bullet_y + PLAYER_BULLET_HEIGHT) begin
			red = 0;
			green = 0;
			blue = 2'b11;
		end

		// draw enemy bullets
		if(!bossActive) begin
			if(hc >= hbp + 128 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 128 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy1_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy1_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 128 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 128 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy1_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy1_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 128 - ENEMY_BULLET_SIZE && hc <= hbp + 128 + ENEMY_BULLET_SIZE && vc >= vfp - enemy1_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy1_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end
			if(hc >= hbp + 256 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 256 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy2_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy2_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 256 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 256 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy2_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy2_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 256 - ENEMY_BULLET_SIZE && hc <= hbp + 256 + ENEMY_BULLET_SIZE && vc >= vfp - enemy2_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy2_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end
			if(hc >= hbp + 384 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 384 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy3_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy3_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 384 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 384 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy3_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy3_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 384 - ENEMY_BULLET_SIZE && hc <= hbp + 384 + ENEMY_BULLET_SIZE && vc >= vfp - enemy3_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy3_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end
			if(hc >= hbp + 512 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 512 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy4_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy4_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 512 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 512 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy4_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy4_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 512 - ENEMY_BULLET_SIZE && hc <= hbp + 512 + ENEMY_BULLET_SIZE && vc >= vfp - enemy4_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy4_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end
			if(hc >= hbp + 160 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 160 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy5_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy5_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 160 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 160 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy5_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy5_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 160 - ENEMY_BULLET_SIZE && hc <= hbp + 160 + ENEMY_BULLET_SIZE && vc >= vfp - enemy5_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy5_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end
			if(hc >= hbp + 320 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 320 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy6_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy6_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 320 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 320 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy6_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy6_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 320 - ENEMY_BULLET_SIZE && hc <= hbp + 320 + ENEMY_BULLET_SIZE && vc >= vfp - enemy6_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy6_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				
				green = 0;
				blue = 0;
			end
			if(hc >= hbp + 480 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 480 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy7_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy7_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 480 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 480 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy7_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy7_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 480 - ENEMY_BULLET_SIZE && hc <= hbp + 480 + ENEMY_BULLET_SIZE && vc >= vfp - enemy7_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy7_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end
		end
		else begin
			

			// draw hp bar
			if(hc >= hbp + 20 && hc < hbp + 20 + bossHP * 12 && vc <= vfp - 460 && vc >= vfp - 480) begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end

			// draw bullets
			if(hc >= hbp + 256 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 256 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy1_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy1_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 256 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 256 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy1_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy1_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 256 - ENEMY_BULLET_SIZE && hc <= hbp + 256 + ENEMY_BULLET_SIZE && vc >= vfp - enemy1_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy1_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end
			if(hc >= hbp + 277 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 277 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy2_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy2_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 277 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 277 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy2_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy2_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 277 - ENEMY_BULLET_SIZE && hc <= hbp + 277 + ENEMY_BULLET_SIZE && vc >= vfp - enemy2_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy2_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end
			if(hc >= hbp + 299 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 299 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy3_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy3_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 299 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 299 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy3_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy3_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 299 - ENEMY_BULLET_SIZE && hc <= hbp + 299 + ENEMY_BULLET_SIZE && vc >= vfp - enemy3_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy3_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end
			if(hc >= hbp + 320 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 320 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy4_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy4_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 320 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 320 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy4_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy4_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 320 - ENEMY_BULLET_SIZE && hc <= hbp + 320 + ENEMY_BULLET_SIZE && vc >= vfp - enemy4_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy4_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end
			if(hc >= hbp + 341 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 341 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy5_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy5_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 341 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 341 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy5_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy5_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 341 - ENEMY_BULLET_SIZE && hc <= hbp + 341 + ENEMY_BULLET_SIZE && vc >= vfp - enemy5_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy5_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end
			if(hc >= hbp + 363 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 363 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy6_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy6_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 363 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 363 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy6_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy6_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 363 - ENEMY_BULLET_SIZE && hc <= hbp + 363 + ENEMY_BULLET_SIZE && vc >= vfp - enemy6_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy6_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end
			if(hc >= hbp + 384 - ENEMY_BULLET_SIZE + 1 && hc <= hbp + 384 + ENEMY_BULLET_SIZE - 1 && vc >= vfp - enemy7_bullet - ENEMY_BULLET_SIZE + 1 && vc <= vfp - enemy7_bullet + ENEMY_BULLET_SIZE - 1 ||
			   hc >= hbp + 384 - ENEMY_BULLET_SIZE + 2 && hc <= hbp + 384 + ENEMY_BULLET_SIZE - 2 && vc >= vfp - enemy7_bullet - ENEMY_BULLET_SIZE && vc <= vfp - enemy7_bullet + ENEMY_BULLET_SIZE ||
			   hc >= hbp + 384 - ENEMY_BULLET_SIZE && hc <= hbp + 384 + ENEMY_BULLET_SIZE && vc >= vfp - enemy7_bullet - ENEMY_BULLET_SIZE + 2 && vc <= vfp - enemy7_bullet + ENEMY_BULLET_SIZE - 2) begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end

			// draw boss
			//if(hc >= hbp + BOSS_LEFT && hc <= hbp + BOSS_RIGHT && vc >= vfp - BOSS_TOP && vc <= vfp - BOSS_BOTTOM) begin
			if((hc >= hbp + BOSS_LEFT + 44 && hc <= hbp + BOSS_RIGHT - 44 && vc >= vfp - BOSS_TOP - 5 && vc <= vfp - BOSS_BOTTOM + 20) ||
			(hc >= hbp + BOSS_LEFT + 29 && hc <= hbp + BOSS_RIGHT - 29 && vc >= vfp - BOSS_TOP && vc <= vfp - BOSS_BOTTOM) ||
			(hc >= hbp + BOSS_LEFT + 14 && hc <= hbp + BOSS_RIGHT - 14 && vc >= vfp - BOSS_TOP + 10 && vc <= vfp - BOSS_BOTTOM) ||
			(hc >= hbp + BOSS_LEFT + 59 && hc <= hbp + BOSS_RIGHT - 59 && vc >= vfp - BOSS_TOP && vc <= vfp - BOSS_BOTTOM + 30) ||
			(hc >= hbp + BOSS_LEFT - 10 && hc <= hbp + BOSS_RIGHT + 10 && vc >= vfp - BOSS_TOP + 50 && vc <= vfp - BOSS_BOTTOM) || 
			((vc >= vfp - BOSS_TOP + 35 && vc <= vfp - BOSS_BOTTOM + 10) &&
			((hc >= hbp + BOSS_LEFT - 10 && hc <= hbp + BOSS_LEFT + 4) || 
			(hc <= hbp + BOSS_RIGHT + 10 && hc >= hbp + BOSS_RIGHT - 4))) || 
			((vc >= vfp - BOSS_TOP + 35 && vc <= vfp - BOSS_BOTTOM + 15) &&
			((hc >= hbp + BOSS_LEFT - 5 && hc <= hbp + BOSS_LEFT) || 
			(hc <= hbp + BOSS_RIGHT + 5 && hc >= hbp + BOSS_RIGHT)))) begin
				red = 3'b010;
				green = 3'b010;
				blue = 2'b01;
			end

		end

		

		// draw player
		//if(hc >= hbp + playerX - PLAYER_WIDTH && hc <= hbp + playerX + PLAYER_WIDTH && vc >= vfp - playerY - PLAYER_HEIGHT && vc <= vfp - playerY + PLAYER_HEIGHT) begin
		if((hc >= hbp + playerX - 2 && hc <= hbp + playerX + 2 && vc >= vfp - playerY - PLAYER_HEIGHT - 9 && vc <= vfp - playerY + PLAYER_HEIGHT + 3) ||
			(vc <= vfp - playerY + PLAYER_HEIGHT && vc >= vfp - playerY + PLAYER_HEIGHT - 6 && hc >= hbp + playerX - PLAYER_WIDTH && hc <= hbp + playerX + PLAYER_WIDTH) ||
			(vc <= vfp - playerY + PLAYER_HEIGHT && vc >= vfp - playerY - PLAYER_HEIGHT) &&
			((hc >= hbp + playerX - PLAYER_WIDTH && hc <= hbp + playerX - PLAYER_WIDTH + 3) ||
			(hc >= hbp + playerX + PLAYER_WIDTH - 3 && hc <= hbp + playerX + PLAYER_WIDTH))) begin
			red = 3'b010;
			green = 3'b010;
			blue = 2'b10;
		end


		// draw win or lose
		if(lose) begin
			if ((vc > vbp + 100 && vc <= vbp + 150 && hc > hbp + 258 && hc <= hbp + 583) && 
				((hc <= hbp + 268) || 
				(hc > hbp + 268 && hc <= hbp + 278 && vc > vbp + 140) || 
				(hc > hbp + 283 && hc <= hbp + 293) || 
				(hc > hbp + 303 && hc <= hbp + 313) || 
				(hc > hbp + 293 && hc <= hbp + 303 && vc > vbp + 140) || 
				(hc > hbp + 293 && hc <= hbp + 303 && vc <= vbp + 110) || 
				(hc > hbp + 318 && hc <= hbp + 328 && vc <= vbp + 120) || 
				(hc > hbp + 333 && hc <= hbp + 343 && vc > vbp + 115) || 
				(hc > hbp + 328 && hc <= hbp + 343 && vc <= vbp + 105) || 
				(hc > hbp + 328 && hc <= hbp + 333 && vc > vbp + 115 && vc <= vbp + 120) || 
				(hc > hbp + 318 && hc <= hbp + 333 && vc > vbp + 145) || 
				(hc > hbp + 348 && hc <= hbp + 358) || 
				(hc > hbp + 358 && hc <= hbp + 373 && vc <= vbp + 105) || 
				(hc > hbp + 358 && hc <= hbp + 373 && vc > vbp + 115 && vc <= vbp + 120) || 
				(hc > hbp + 358 && hc <= hbp + 373 && vc > vbp + 145))) begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
		end
		else if(win) begin
			if ((vc > vbp + 100 && vc <= vbp + 150 && hc > hbp + 270 && hc <= hbp + 370) && 
				((hc <= hbp + 280) || 
				(hc > hbp + 290 && hc <= hbp + 300) || 
				(hc > hbp + 310 && hc <= hbp + 320) || 
				(hc > hbp + 280 && hc <= hbp + 290 && vc > vbp + 145) || 
				(hc > hbp + 300 && hc <= hbp + 310 && vc > vbp + 145) || 
				(hc > hbp + 325 && hc <= hbp + 335) || 
				(hc > hbp + 340 && hc <= hbp + 350) || 
				(hc > hbp + 360 && hc <= hbp + 370) || 
				(hc > hbp + 350 && hc <= hbp + 360 && vc <= vbp + 105))) begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
		end
		
	end
	// we're outside active vertical range so display black
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end

endmodule
