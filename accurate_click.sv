module accurate_click #(parameter SIZE = 10) (clk, reset, mouse_click, mouse_x,
															 mouse_y, square_x0, square_y0, accurate_clck);
	input logic clk, reset, mouse_click;
	input logic [10:0] mouse_x, mouse_y, square_x0, square_y0;
	output logic accurate_clck;
	logic [10:0] square_x1, square_y1;
	logic in_bin_x, in_bin_y;
	
	assign square_x1 = square_x0 + SIZE;
	assign square_y1 = square_y0 + SIZE;
	
	logic withInX, withInY, inBoth;
	 assign withInX = (mouse_x >= square_x0) && (mouse_x <= square_x1);
	 assign withInY = (mouse_y >= square_y0) && (mouse_y <= square_y1);
	 assign inBoth = withInX && withInY;
	
	
	always_ff @(posedge clk) begin
		if (reset) begin
			accurate_clck <= 1'b0;
		end else if (mouse_click) begin
			accurate_clck <= inBoth;
		end else begin
			accurate_clck <= 1'b0;
		end
	end
	
endmodule

module accurate_click_testbench();
	logic clk, reset, mouse_click, accurate_clck;
	logic [10:0] mouse_x, mouse_y, square_x0, square_y0;
	
	accurate_click dut (clk, reset, mouse_click, mouse_x, mouse_y, square_x0, square_y0, accurate_clck);

	parameter clock_period = 100;
	initial begin
		clk <= 0;
		forever #(clock_period/2) clk <= ~clk;
	end

	initial begin
		reset <= 1; 										  						    @(posedge clk);
		reset <= 0; mouse_click	<= 1;	mouse_x <= 10; mouse_y <= 10; 
												square_x0 <= 5; square_y0 <= 5;   @(posedge clk);
						mouse_click <= 0;										 	    @(posedge clk);
						mouse_click	<= 1;	mouse_x <= 20; mouse_y <= 15; 
												square_x0 <= 50; square_y0 <= 50; @(posedge clk);
						mouse_click <= 0;										 	    @(posedge clk);
																					       @(posedge clk);
																							 @(posedge clk);
																		
		$stop;
	end
endmodule