`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:36 03/19/2013 
// Design Name: 
// Module Name:    clockdiv 
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
module clockdiv(
	input wire clk,		//master clock: 50MHz
	input wire clr,		//asynchronous reset
	output wire dclk,		//pixel clock: 25MHz
	output wire segclk,	//7-segment clock: 381.47Hz
	output reg clk_30hz
	);

// 17-bit counter variable
reg [17:0] q;


reg [21:0] counter_30hz;

initial begin
	counter_30hz = 1666666;
	clk_30hz = 0;
end


always @ (posedge clk)
begin
	counter_30hz = counter_30hz - 1;
	if(counter_30hz == 0)
	begin
		counter_30hz = 1666666;
		clk_30hz = ~clk_30hz;
	end	
end


// Clock divider --
// Each bit in q is a clock signal that is
// only a fraction of the master clock.
always @(posedge clk or posedge clr)
begin
	// reset condition
	if (clr == 1)
		q <= 0;
	// increment counter by one
	else
		q <= q + 1;
end

// 50Mhz � 2^17 = 381.47Hz
assign segclk = q[17];

// 50Mhz � 2^1 = 25MHz
assign dclk = q[1];

endmodule
