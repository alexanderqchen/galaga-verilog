`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:23:42 06/04/2018 
// Design Name: 
// Module Name:    engine 
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



module engine(
	input clk_30hz,
	input [9:0] xPosData,
	input [9:0] yPosData,
	input RST,
	output reg [9:0] playerX,
	output reg [8:0] playerY,
	output reg [9:0] player_bullet_x,
	output reg [8:0] player_bullet_y,
	// Alive bit for each enemy
	output reg enemy1,
	output reg enemy2,
	output reg enemy3,
	output reg enemy4,
	output reg enemy5,
	output reg enemy6,
	output reg enemy7,
	// y position of each bullet
	output reg [8:0] enemy1_bullet,
	output reg [8:0] enemy2_bullet,
	output reg [8:0] enemy3_bullet,
	output reg [8:0] enemy4_bullet,
	output reg [8:0] enemy5_bullet,
	output reg [8:0] enemy6_bullet,
	output reg [8:0] enemy7_bullet,
	output reg [1:0] lives,
	output reg [6:0] bossHP,
	output bossActive,
	output reg win,
	output reg lose
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

	parameter ENEMY_BULLET_DISABLE = 511;

	parameter BOSS_LEFT = 256;
	parameter BOSS_RIGHT = 384;
	parameter BOSS_TOP = 420;
	parameter BOSS_BOTTOM = 360;

	parameter BOUNDARY = 6;

	parameter NUM_WAVES = 2;

	reg bossActive_old;
	reg done;
	reg [1:0] lives_save;
	reg [6:0] bossHP_save;

	assign bossActive = !(enemy1 || enemy2 || enemy3 || enemy4 || enemy5 || enemy6 || enemy7);

	initial begin

		// Set initial position of player
		playerX = 320;
		playerY = 60;

		// Initialize bullets to not exist
		player_bullet_x = 320;
		player_bullet_y = 60;
		lives = 3;

		// Initialize all enemies to alive
		enemy1 = 1;
		enemy2 = 1;
		enemy3 = 1;
		enemy4 = 1;
		enemy5 = 1;
		enemy6 = 1;
		enemy7 = 1;

		enemy1_bullet = 420;
		enemy2_bullet = 420;
		enemy3_bullet = 420;
		enemy4_bullet = 420;
		enemy5_bullet = 360;
		enemy6_bullet = 360;
		enemy7_bullet = 360;

		bossHP = 50;
		bossActive_old = 0;

		win = 0;
		lose = 0;
		done = 0;
	end

	always @ (posedge clk_30hz) begin

		if(RST) begin
			// Set initial position of player
			playerX = 320;
			playerY = 60;

			// Initialize bullets to not exist
			player_bullet_x = 320;
			player_bullet_y = 60;
			lives = 3;

			// Initialize all enemies to alive
			enemy1 = 1;
			enemy2 = 1;
			enemy3 = 1;
			enemy4 = 1;
			enemy5 = 1;
			enemy6 = 1;
			enemy7 = 1;

			enemy1_bullet = 420;
			enemy2_bullet = 420;
			enemy3_bullet = 420;
			enemy4_bullet = 420;
			enemy5_bullet = 360;
			enemy6_bullet = 360;
			enemy7_bullet = 360;

			bossHP = 50;
			bossActive_old = 0;

			win = 0;
			lose = 0;
			done = 0;
		end


		lives_save = lives;
		bossHP_save = bossHP;

		/************************
			Boss
		***********************/
		// Initiate boss mode
		if(bossActive != bossActive_old) begin
			enemy1_bullet = 360;
			enemy2_bullet = 360;
			enemy3_bullet = 360;
			enemy4_bullet = 360;
			enemy5_bullet = 360;
			enemy6_bullet = 360;
			enemy7_bullet = 360;
		end



		/***************************
			Collisions
		**************************/
		// Player collide with enemy
		if(bossActive) begin
			if(playerY >= BOSS_BOTTOM - PLAYER_HEIGHT && playerY <= BOSS_TOP + PLAYER_HEIGHT && playerX >= BOSS_LEFT - PLAYER_WIDTH && playerX <= BOSS_RIGHT + PLAYER_WIDTH) begin
				lives = lives - 1;
				bossHP = bossHP - 1;
			end
		end
		else if(playerY >= 420 - ENEMY_HEIGHT - PLAYER_HEIGHT && playerY <= 420 + ENEMY_HEIGHT + PLAYER_HEIGHT) begin // Top row of enemies
			if(enemy1 && playerX >= 128 - ENEMY_WIDTH - PLAYER_WIDTH  && playerX <= 128 + ENEMY_WIDTH + PLAYER_WIDTH) begin
				lives = lives - 1;
				enemy1 = 0;
			end
			else if(enemy2 && playerX >= 256  - ENEMY_WIDTH - PLAYER_WIDTH && playerX <= 256 + ENEMY_WIDTH + PLAYER_WIDTH) begin
				lives = lives - 1;
				enemy2 = 0;
			end
			else if(enemy3 && playerX >= 384 - ENEMY_WIDTH - PLAYER_WIDTH && playerX <= 384 + ENEMY_WIDTH + PLAYER_WIDTH) begin
				lives = lives - 1;
				enemy3 = 0;
			end
			else if(enemy4 && playerX >= 512 - ENEMY_WIDTH - PLAYER_WIDTH && playerX <= 512 + ENEMY_WIDTH + PLAYER_WIDTH) begin
				lives = lives - 1;
				enemy4 = 0;
			end
		end
		else if(playerY >= 360 - ENEMY_HEIGHT - PLAYER_HEIGHT && playerY <= 360 + ENEMY_HEIGHT + PLAYER_HEIGHT) begin // Bottom row of enemies
			if(enemy5 && playerX >= 160 - ENEMY_WIDTH - PLAYER_WIDTH && playerX <= 160 + ENEMY_WIDTH + PLAYER_WIDTH) begin
				lives = lives - 1;
				enemy5 = 0;
			end
			else if(enemy6 && playerX >= 320 - ENEMY_WIDTH - PLAYER_WIDTH && playerX <= 320 + ENEMY_WIDTH + PLAYER_WIDTH) begin
				lives = lives - 1;
				enemy6 = 0;
			end
			else if(enemy7 && playerX >= 480 - ENEMY_WIDTH - PLAYER_WIDTH && playerX <= 480 + ENEMY_WIDTH + PLAYER_WIDTH) begin
				lives = lives - 1;
				enemy7 = 0;
			end
		end

		// Player bullet collide with enemies
		if(bossActive) begin
			if(player_bullet_x >= BOSS_LEFT && player_bullet_x <= BOSS_RIGHT && player_bullet_y >= BOSS_BOTTOM && player_bullet_y <= BOSS_TOP) begin
				player_bullet_x = playerX;
				player_bullet_y = playerY;
				bossHP = bossHP - 1;
			end
		end
		else if(player_bullet_y >= 420 - ENEMY_HEIGHT - PLAYER_BULLET_HEIGHT && player_bullet_y <= 420 + ENEMY_HEIGHT + PLAYER_BULLET_HEIGHT) begin // Top row of enemies
			if(enemy1 && player_bullet_x >= 128 - ENEMY_WIDTH - PLAYER_BULLET_WIDTH && player_bullet_x <= 128 + ENEMY_WIDTH + PLAYER_BULLET_WIDTH) begin
				player_bullet_x = playerX;
				player_bullet_y = playerY;
				enemy1 = 0;
			end
			else if(enemy2 && player_bullet_x >= 256 - ENEMY_WIDTH - PLAYER_BULLET_WIDTH && player_bullet_x <= 256 + ENEMY_WIDTH + PLAYER_BULLET_WIDTH) begin
				player_bullet_x = playerX;
				player_bullet_y = playerY;
				enemy2 = 0;
			end
			else if(enemy3 && player_bullet_x >= 384 - ENEMY_WIDTH - PLAYER_BULLET_WIDTH && player_bullet_x <= 384 + ENEMY_WIDTH + PLAYER_BULLET_WIDTH) begin
				player_bullet_x = playerX;
				player_bullet_y = playerY;
				enemy3 = 0;
			end
			else if(enemy4 && player_bullet_x >= 512 - ENEMY_WIDTH - PLAYER_BULLET_WIDTH && player_bullet_x <= 512 + ENEMY_WIDTH + PLAYER_BULLET_WIDTH) begin
				player_bullet_x = playerX;
				player_bullet_y = playerY;
				enemy4 = 0;
			end
		end
		else if(player_bullet_y >= 360 - ENEMY_HEIGHT - PLAYER_BULLET_HEIGHT && player_bullet_y <= 360 + ENEMY_HEIGHT + PLAYER_BULLET_HEIGHT) begin // Bottom row of enemies
			if(enemy5 && player_bullet_x >= 160 - ENEMY_WIDTH - PLAYER_BULLET_WIDTH && player_bullet_x <= 160 + ENEMY_WIDTH + PLAYER_BULLET_WIDTH) begin
				player_bullet_x = playerX;
				player_bullet_y = playerY;
				enemy5 = 0;
			end
			else if(enemy6 && player_bullet_x >= 320 - ENEMY_WIDTH - PLAYER_BULLET_WIDTH && player_bullet_x <= 320 + ENEMY_WIDTH + PLAYER_BULLET_WIDTH) begin
				player_bullet_x = playerX;
				player_bullet_y = playerY;
				enemy6 = 0;
			end
			else if(enemy7 && player_bullet_x >= 480 - ENEMY_WIDTH - PLAYER_BULLET_WIDTH && player_bullet_x <= 480 + ENEMY_WIDTH + PLAYER_BULLET_WIDTH) begin
				player_bullet_x = playerX;
				player_bullet_y = playerY;
				enemy7 = 0;
			end
		end


		// Enemy bullets collide with player
		if(!bossActive) begin
			if(playerX >= 128 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 128 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy1_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy1_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy1_bullet = enemy1 ? 420 : ENEMY_BULLET_DISABLE;
			end
			else if(playerX >= 256 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 256 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy2_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy2_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy2_bullet = enemy2 ? 420 : ENEMY_BULLET_DISABLE;
			end
			else if(playerX >= 384 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 384 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy3_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy3_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy3_bullet = enemy3 ? 420 : ENEMY_BULLET_DISABLE;
			end
			else if(playerX >= 512 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 512 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy4_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy4_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy4_bullet = enemy4 ? 420 : ENEMY_BULLET_DISABLE;
			end
			if(playerX >= 160 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 160 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy5_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy5_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy5_bullet = enemy5 ? 360: ENEMY_BULLET_DISABLE;
			end
			else if(playerX >= 320 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 320 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy6_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy6_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy6_bullet = enemy6 ? 360: ENEMY_BULLET_DISABLE;
			end
			else if(playerX >= 480 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 480 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy7_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy7_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy7_bullet = enemy7 ? 360: ENEMY_BULLET_DISABLE;
			end
		end
		else begin
			if(playerX >= 256 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 256 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy1_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy1_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy1_bullet = 360;
			end
			else if(playerX >= 277 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 277 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy2_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy2_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy2_bullet = 360;
			end
			else if(playerX >= 299 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 299 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy3_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy3_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy3_bullet = 360;
			end
			else if(playerX >= 320 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 320 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy4_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy4_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy4_bullet = 360;
			end
			else if(playerX >= 341 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 341 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy5_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy5_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy5_bullet = 360;
			end
			else if(playerX >= 363 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 363 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy6_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy6_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy6_bullet = 360;
			end
			else if(playerX >= 384 - PLAYER_WIDTH - ENEMY_BULLET_SIZE && playerX <= 384 + PLAYER_WIDTH + ENEMY_BULLET_SIZE && playerY >= enemy7_bullet - PLAYER_HEIGHT - ENEMY_BULLET_SIZE && playerY <= enemy7_bullet + PLAYER_HEIGHT + ENEMY_BULLET_SIZE) begin
				lives = lives - 1;
				enemy7_bullet = 360;
			end
		end


		/***************************
			Player
		***************************/
		// Player Movement
		if(xPosData > 600 && playerX < 640 - BOUNDARY) begin
			playerX = playerX + 2;
		end
		else if (xPosData < 400 && playerX > 0 + BOUNDARY) begin
			playerX = playerX - 2;
		end
		if(yPosData > 600 && playerY < 480 - BOUNDARY) begin
			playerY = playerY + 2;
		end
		else if (yPosData < 400 && playerY > 0 + BOUNDARY) begin
			playerY = playerY - 2;
		end

		// Bullet offscreen
		if(player_bullet_y >= 480 - BOUNDARY) begin
			player_bullet_x = playerX;
			player_bullet_y = playerY;
		end

		// Bullet movement
		player_bullet_y = player_bullet_y + 4;


		/***************************
			Enemies
		***************************/
		// Bullet offscreen
		if(enemy1_bullet <= 0 + BOUNDARY) begin
			enemy1_bullet = bossActive ? 360 : enemy1 ? 420 : ENEMY_BULLET_DISABLE;
		end
		if(enemy2_bullet <= 0 + BOUNDARY) begin
			enemy2_bullet = bossActive ? 360 : enemy2 ? 420 : ENEMY_BULLET_DISABLE;
		end
		if(enemy3_bullet <= 0 + BOUNDARY) begin
			enemy3_bullet = bossActive ? 360 : enemy3 ? 420 : ENEMY_BULLET_DISABLE;
		end
		if(enemy4_bullet <= 0 + BOUNDARY) begin
			enemy4_bullet = bossActive ? 360 : enemy4 ? 420 : ENEMY_BULLET_DISABLE;
		end
		if(enemy5_bullet <= 0 + BOUNDARY) begin
			enemy5_bullet = bossActive ? 360 : enemy5 ? 360 : ENEMY_BULLET_DISABLE;
		end
		if(enemy6_bullet <= 0 + BOUNDARY) begin
			enemy6_bullet = bossActive ? 360 : enemy6 ? 360 : ENEMY_BULLET_DISABLE;
		end
		if(enemy7_bullet <= 0 + BOUNDARY) begin
			enemy7_bullet = bossActive ? 360 : enemy7 ? 360 : ENEMY_BULLET_DISABLE;
		end

		// Bullet movement

		if(enemy1_bullet != ENEMY_BULLET_DISABLE || bossActive)
			enemy1_bullet = enemy1_bullet - 5;
		if(enemy2_bullet != ENEMY_BULLET_DISABLE || bossActive)
			enemy2_bullet = enemy2_bullet - 3;
		if(enemy3_bullet != ENEMY_BULLET_DISABLE || bossActive)
			enemy3_bullet = enemy3_bullet - 4;
		if(enemy4_bullet != ENEMY_BULLET_DISABLE || bossActive)
			enemy4_bullet = enemy4_bullet - 2;
		if(enemy5_bullet != ENEMY_BULLET_DISABLE || bossActive)
			enemy5_bullet = enemy5_bullet - 4;
		if(enemy6_bullet != ENEMY_BULLET_DISABLE || bossActive)
			enemy6_bullet = enemy6_bullet - 5;
		if(enemy7_bullet != ENEMY_BULLET_DISABLE || bossActive)
			enemy7_bullet = enemy7_bullet - 2;


		if(lose || win) begin
			lives = lives_save;
			bossHP = bossHP_save;
		end

		if(lives == 0 && !done) begin
			lose = 1;
			done = 1;
		end
		if(bossHP == 0 && !done) begin
			win = 1;
			done = 1;
		end

		

		bossActive_old = bossActive;

	end

endmodule
