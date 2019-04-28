`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:25 03/19/2013 
// Design Name: 
// Module Name:    NERP_demo_top 
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
module NERP_demo_top(
	input wire clk,			//master clock = 100MHz
	input MISO,
	input RST,
	output wire [6:0] seg,	//7-segment display LEDs
	output wire [3:0] an,	//7-segment display anode enable
	output wire dp,			//7-segment display decimal point
	output wire [2:0] red,	//red vga output - 3 bits
	output wire [2:0] green,//green vga output - 3 bits
	output wire [1:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync,			//vertical sync out
	output SS,
	output MOSI,
	output SCLK
	);

wire [9:0] xPosData;
wire [9:0] yPosData;
wire [9:0] playerX;
wire [8:0] playerY;
wire [9:0] player_bullet_x;
wire [8:0] player_bullet_y;
wire enemy1;
wire enemy2;
wire enemy3;
wire enemy4;
wire enemy5;
wire enemy6;
wire enemy7;
wire [8:0] enemy1_bullet;
wire [8:0] enemy2_bullet;
wire [8:0] enemy3_bullet;
wire [8:0] enemy4_bullet;
wire [8:0] enemy5_bullet;
wire [8:0] enemy6_bullet;
wire [8:0] enemy7_bullet;
wire [1:0] lives;
wire [6:0] bossHP;
wire bossActive;
wire win;
wire lose;
wire done;
wire clk_30hz;

// VGA display clock interconnect
wire dclk;

// Joystick
PmodJSTK_Demo joystick(
	.CLK(clk),
	.MISO(MISO),
	.SS(SS),
	.MOSI(MOSI),
	.SCLK(SCLK),
	.xPosData(xPosData),
	.yPosData(yPosData)
	);

// Game Engine
engine e(
	//input
	.clk_30hz(clk_30hz),
	.xPosData(xPosData),
	.yPosData(yPosData),
	.RST(RST),
	//output
	.playerX(playerX),
	.playerY(playerY),
	.player_bullet_x(player_bullet_x),
	.player_bullet_y(player_bullet_y),
	.enemy1(enemy1),
	.enemy2(enemy2),
	.enemy3(enemy3),
	.enemy4(enemy4),
	.enemy5(enemy5),
	.enemy6(enemy6),
	.enemy7(enemy7),
	.enemy1_bullet(enemy1_bullet),
	.enemy2_bullet(enemy2_bullet),
	.enemy3_bullet(enemy3_bullet),
	.enemy4_bullet(enemy4_bullet),
	.enemy5_bullet(enemy5_bullet),
	.enemy6_bullet(enemy6_bullet),
	.enemy7_bullet(enemy7_bullet),
	.lives(lives),
	.bossHP(bossHP),
	.bossActive(bossActive),
	.win(win),
	.lose(lose)
	);


// 7-segment clock interconnect
wire segclk;



// disable the 7-segment decimal points
assign dp = 1;

// generate 7-segment clock & display clock
clockdiv U1(
	.clk(clk),
	.clr(0),
	.segclk(segclk),
	.dclk(dclk),
	.clk_30hz(clk_30hz)
	);

// 7-segment display controller
segdisplay U2(
	.segclk(segclk),
	.clr(0),
	.lives(lives),
	.seg(seg),
	.an(an)
	);

// VGA controller
vga640x480 U3(
	//input
	.dclk(dclk),			//pixel clock: 25MHz
	.clr(0),			//asynchronous reset
	.playerX(playerX),
	.playerY(playerY),
	.player_bullet_x(player_bullet_x),
	.player_bullet_y(player_bullet_y),
	.enemy1(enemy1),
	.enemy2(enemy2),
	.enemy3(enemy3),
	.enemy4(enemy4),
	.enemy5(enemy5),
	.enemy6(enemy6),
	.enemy7(enemy7),
	.enemy1_bullet(enemy1_bullet),
	.enemy2_bullet(enemy2_bullet),
	.enemy3_bullet(enemy3_bullet),
	.enemy4_bullet(enemy4_bullet),
	.enemy5_bullet(enemy5_bullet),
	.enemy6_bullet(enemy6_bullet),
	.enemy7_bullet(enemy7_bullet),
	.lives(lives),
	.bossHP(bossHP),
	.bossActive(bossActive),
	.win(win),
	.lose(lose),
	//output
	.hsync(hsync),		//horizontal sync out
	.vsync(vsync),		//vertical sync out
	.red(red),	//red vga output
	.green(green), //green vga output
	.blue(blue)	//blue vga output
	);

endmodule
