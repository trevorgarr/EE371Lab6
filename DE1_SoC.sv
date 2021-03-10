/* Top level module of the FPGA that takes the onboard resources 
 * as input and outputs the lines drawn from the VGA port.
 *
 * Inputs:
 *   KEY 			- On board keys of the FPGA
 *   SW 			- On board switches of the FPGA
 *   CLOCK_50 		- On board 50 MHz clock of the FPGA
 *
 * Outputs:
 *   HEX 			- On board 7 segment displays of the FPGA
 *   LEDR 			- On board LEDs of the FPGA
 *   VGA_R 			- Red data of the VGA connection
 *   VGA_G 			- Green data of the VGA connection
 *   VGA_B 			- Blue data of the VGA connection
 *   VGA_BLANK_N 	- Blanking interval of the VGA connection
 *   VGA_CLK 		- VGA's clock signal
 *   VGA_HS 		- Horizontal Sync of the VGA connection
 *   VGA_SYNC_N 	- Enable signal for the sync of the VGA connection
 *   VGA_VS 		- Vertical Sync of the VGA connection
 */
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS, PS2_CLK, PS2_DAT);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	inout PS2_CLK;
	inout PS2_DAT;
	
	logic start;
	logic mouse_click;
	logic[25:0] counter = 0;
	assign start = SW[8];
	logic done_w, done_b;
	logic reset;
	assign reset = SW[9];
	logic [10:0] x, y, mouse_x, mouse_y, square_x_w, square_y_w, square_x_b, square_y_b, x_loc, y_loc;
	logic pixel_color;
	logic accurate_clck;
	
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR[7:0] = SW[7:0];
	
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(reset), 
		.x, 
		.y,
		.pixel_color	(1'b1), 
		.pixel_write	(1'b1),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));
				
	
	//ps2 mouse (.CLOCK_50, .reset, .start, .button_left(mouse_click),
				  //.bin_x(mouse_x), .bin_y(mouse_y), .PS2_CLK, .PS2_DAT);
	
   square_loc_picker sqp (.clk(CLOCK_50), .reset, .start(accurate_clck), .x_loc, .y_loc);

	square_drawer sq_w (.clk(CLOCK_50), .reset, .start(accurate_clck), .x0(x_loc), .y0(y_loc),
							  .x(square_x_w), .y(square_y_w), .done(done_w));
//	square_drawer sq_b (.clk(CLOCK_50), .reset, .start, .x0(x_loc),.y0(y_loc),
//							  .x(square_x_b), .y(square_y_b), .done(done_b));

	assign x = square_x_w;
	assign y = square_y_w;
	
	assign accurate_clck = (counter == 50000000);
	
	always_ff @(posedge CLOCK_50) begin
		counter <= counter + 1;
		if(counter == 50000000) begin //take away for simulation
			counter <= 0;
		end
	end

	//assign x = accurate_clck ? square_x_w : 
	
	//accurate_click acc (.clk, .reset, .mouse_click, .mouse_x, .mouse_y, .square_x0, .square_y0, .accurate_clck);
	
	score count (.clk(CLOCK_50), .rst(reset), .point(accurate_clck), .HEX0, .HEX1);
	

endmodule  // DE1_SoC

module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic CLOCK_50;
	logic [7:0] VGA_R, VGA_G, VGA_B;
	logic VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS;

	DE1_SoC dut(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	
	parameter clock_period = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(clock_period/2) CLOCK_50 <= ~CLOCK_50;
	end
	integer i;
	initial begin
		SW[9] = 1;  			 @(posedge CLOCK_50);
		SW[9] = 0; SW[8] = 1; @(posedge CLOCK_50);
		for(i = 0; i < 50000000; i++)
			@(posedge CLOCK_50);
																			
		$stop;
	end
endmodule
