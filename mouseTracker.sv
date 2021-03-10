module mouseTracker(clk, PS2_CLK,PS2_DAT, reset, start, button_left, x, y,pixel_color);

	input logic clk, reset, start;
	output logic  pixel_color, button_left;
	output logic [10:0] x,y;
	logic [10:0] bin_x,bin_y; 
	inout PS2_CLK, PS2_DAT;
	
	logic count;
	
	ps2 mouse(.start,.reset,.CLOCK_50(clk), .PS2_CLK,.PS2_DAT, .button_left(button_left),.bin_x(bin_x), . bin_y(bin_y));
	
	always_ff @(posedge clk) begin
		if(reset) begin
			x <= 0;
			y <= 0;
			pixel_color <= 0;
		end
		
		if(count) begin
			x <= bin_x;
			y <= bin_y;
			pixel_color <= 1;
		end else begin
			pixel_color <= 0;
		end
		count = ~count;
	end
endmodule
			

