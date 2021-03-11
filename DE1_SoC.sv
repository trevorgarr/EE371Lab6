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
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, CLOCK2_50, 
    VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS, PS2_CLK, PS2_DAT,
    FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input CLOCK_50;
	input CLOCK2_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	output FPGA_I2C_SCLK;
    inout FPGA_I2C_SDAT;
    output AUD_XCK;
    input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
    input AUD_ADCDAT;
    output AUD_DACDAT;
    logic read_ready, write_ready, read, write;
    logic [23:0] readdata_left, readdata_right;
    logic [23:0] writedata_left, writedata_right;
	
	inout PS2_DAT;
	inout PS2_CLK;
	
	logic[20:0] counter;
	
	logic reset;
	assign reset = SW[9];
	
	logic [10:0] x, y;
	logic pixel_color;
	
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(reset), 
		.x, 
		.y,
		.pixel_color, 
		.pixel_write	(1'b1),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));
				
	logic start;
	logic mouse_click;
	assign start = ~KEY[0];
	logic accurate_clck;
	logic start_picker;
	logic tripBox;
	assign start_picker = accurate_clck | tripBox;
	assign LEDR[7] = accurate_clck;
	
	logic startupDone, boxEnd, boxStart, frstClick, eraseScore, erasedBox, boxPixelColor1, boxPixelColor2, boxPixelColor;
	
	//assign boxPixelColor = (boxPixelColor1 && boxPixelColor2);
	
	always_ff @(posedge CLOCK_50) begin
		if(boxPixelColor1 && boxPixelColor2)
			boxPixelColor <= 1;
		else
			boxPixelColor <= 0;
	end
	
	
	logic [10:0] xStartup, yStartup, xMouse, yMouse, x_loc, y_loc, square_x1, square_y1, square_x2, square_y2, square_x, square_y;
	
	assign square_x = (square_x1 == x_loc) ? square_x2 : square_x1;
	assign square_y = (square_y1 == y_loc) ? square_y2 : square_y1;
	
	logic startupPixelColor, mousePixelColor, newGame;
	
	logic[6:0] score0 = 0, score1 = 0;
	logic[3:0] count0, count1;
	
	always_ff @(posedge CLOCK_50) begin
		if(count1 > score1[3:0]) begin
			score1[3:0] <= count1;
			score0[3:0] <= count0;
		end else if(count0 > score0[3:0] && count1 == score1[3:0]) begin
				score0[3:0] <= count0;
				score1 <= score1;
		end else begin
				score0 <= score0;
				score1 <= score1;
		end
	end
		
	
	//ps2 mouse (.CLOCK_50, .PS2_CLK,.PS2_DAT, .reset, .start, .button_left(mouse_click), .bin_x(x), . bin_y(y));
	
	//assign LEDR[7] = mouse_click;
	
	clock_generator my_clock_gen(
        CLOCK2_50,
        reset,
        AUD_XCK
    );

    audio_and_video_config cfg(
        CLOCK_50,
        reset,
        FPGA_I2C_SDAT,
        FPGA_I2C_SCLK
    );

    audio_codec codec(
        CLOCK_50,
        reset,
        read,
        write,
        writedata_left, 
        writedata_right,
        AUD_ADCDAT,
        AUD_BCLK,
        AUD_ADCLRCK,
        AUD_DACLRCK,
        read_ready, write_ready,
        readdata_left, readdata_right,
        AUD_DACDAT
    );
	 
	note_play np (.clk(CLOCK_50), .reset, .read_ready, .write_ready, .read, .write,
                        .writedata_left, .writedata_right, .start(accurate_clck), .done(done_play));
								
	
	mouseTracker mouse(.clk(CLOCK_50), .PS2_CLK,.PS2_DAT, .reset, .start(1'b0), .button_left(mouse_click),.x(xMouse), .y(yMouse),.pixel_color(mousePixelColor));
	screenStartup startup(.clk(CLOCK_50), .reset, .start,.done(startupDone),.x(xStartup),.y(yStartup), .pixelColor(startupPixelColor), .press_play(mouse_click), .prevScore0(score0+16), .prevScore1(score1+16));
	
	square_loc_picker sqp (.clk(CLOCK_50), .reset, .start(erasedBox), .x_loc, .y_loc, .done(boxStart));

	square_drawer sq (.clk(CLOCK_50), .reset, .start(boxStart), .x0(x_loc), .y0(y_loc),
							  .x(square_x1), .y(square_y1), .done(boxEnd),  .setColor(1'b1), .pixelColor(boxPixelColor1));
	
	square_drawer sqErase (.clk(CLOCK_50), .reset, .start(start_picker), .x0(x_loc), .y0(y_loc),
							  .x(square_x2), .y(square_y2), .done(erasedBox), .setColor(1'b0), .pixelColor(boxPixelColor2));
	
	accurate_click acc (.clk(CLOCK_50), .reset, .mouse_click(mouse_click), .mouse_x(xMouse), .mouse_y(yMouse), .square_x0(x_loc), .square_y0(y_loc), .accurate_clck);
	
	
	vgaController controller(.clk(CLOCK_50),.reset, .start, .pixel_color, .x,.y,.xMouse,.yMouse, .mousePixelColor, 
									 .xStartup,.yStartup, .startupPixelColor, .start_state_finished(startupDone),
									 .xBox(square_x), .yBox(square_y), .boxStart(start_picker), .boxEnd, .boxPixelColor, .tripBox, .newGame); 
		
	score scoring(.clk(CLOCK_50), .rst(newGame), .point(accurate_clck), .HEX0, .HEX1, .count0, .count1);
	
	//stringToScreen #(.size(20),.stringSize(8)) prntScreen (.clk(CLOCK_50), .reset(SW[0]), .xOffset(100),.yOffset(10), .start(SW[5]), .done(LEDR[7]), .x, .y,.str(str));
	//charConverter convert(.clk(CLOCK_50), .reset(SW[0]), .character(0), .x, .y, .x0(10), .y0(10), .done(LEDR[7]), .start(SW[5]));
	

endmodule  // DE1_SoC

module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic clk;
	logic [7:0] VGA_R, VGA_G, VGA_B;
	logic VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS;
	DE1_SoC dut(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, clk, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	
	parameter clock_period = 100;
	initial begin
		clk <= 0;
		forever #(clock_period/2) clk <= ~clk;
	end
	integer i;
	initial begin
		SW[8] = 0;			@(posedge clk);
		for(i = 0; i < 2000; i++)
				@(posedge clk);
						@(posedge clk);
			SW[8] = 1;			@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
			SW[8] = 0;			@(posedge clk);
		for(i = 0; i < 20000; i++)
			@(posedge clk);
		
		SW[8] = 1;			@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
			SW[8] = 0;			@(posedge clk);
		for(i = 0; i < 2000; i++)
			@(posedge clk);
																			
		$stop;
	end
endmodule	