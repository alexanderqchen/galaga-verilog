`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:57:37 06/05/2018
// Design Name:   engine
// Module Name:   /home/ise/xilinx/finalproject v0.5/engine_tb.v
// Project Name:  finalproject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: engine
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module engine_tb;

	// Inputs
	reg clk_30hz;
	reg [9:0] xPosData;
	reg [9:0] yPosData;

	// Outputs
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

	// Instantiate the Unit Under Test (UUT)
	engine uut (
		.clk_30hz(clk_30hz), 
		.xPosData(xPosData), 
		.yPosData(yPosData), 
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
		.bossActive(bossActive)
	);

	initial begin
		// Initialize Inputs
		clk_30hz = 0;
		xPosData = 500;
		yPosData = 500;

		// Wait 100 ns for global reset to finish
		#100;
      
		
		//wait 5 seconds for enemy bullet to hit player and player bullet to hit enemy
		#150;
		xPosData = 650;
		#64
		xPosData = 500;
		#500;
		xPosData = 650;
		#96;
		xPosData = 500;
		#500;
		xPosData = 650;
		#32;
		xPosData = 500;
		#500;
		xPosData = 300;
		#256;
		xPosData = 500;
		#500;
		xPosData = 300;
		#96;
		xPosData = 500;
		#500;
		xPosData = 300;
		#32;
		xPosData = 500;
		#500;
		xPosData = 700;
		#192;
		xPosData = 500;
		
		
		// Add stimulus here

	end
	
	always #1
		clk_30hz = ~clk_30hz;
      
endmodule

