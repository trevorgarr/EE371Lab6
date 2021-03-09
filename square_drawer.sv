module square_drawer #(parameter SIZE = 10) (clk, reset, start, x0, y0, x, y, done);
	input logic clk, reset, start;
	input logic [10:0] x0, y0;
	output logic [10:0] x, y;
	output logic done;
	logic [10:0] x1, y1;
	logic [10:0] x_loc, y_loc;
	
	assign x1 = x0 + SIZE;
	assign y1 = y0 + SIZE;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			x_loc <= x0;
			y_loc <= y0;
			done <= 1'b0;
		end else if (start) begin
			if (y_loc == y1 & x_loc == x1) begin
				done <= 1'b1;
				x_loc <= x_loc;
				y_loc <= y_loc;
			end else if (x_loc == x1) begin
				x_loc <= x0;
				y_loc <= y_loc + 1'b1;
				done <= done;
			end else begin
				x_loc <= x_loc + 1'b1;
				y_loc <= y_loc;
				done <= done;
			end
		end
	end
	
	assign x = x_loc;
	assign y = y_loc;
	
endmodule

module square_drawer_testbench();
	logic clk, reset;
	logic [10:0] x0, y0;
	logic done;
	logic start;
	logic [10:0] x, y;
	
	square_drawer dut (clk, reset, start, x0, y0, x, y, done);

	parameter clock_period = 100;
	initial begin
		clk <= 0;
		forever #(clock_period/2) clk <= ~clk;
	end

	initial begin
		reset <= 1; x0 <= 20; y0 <= 20;				  @(posedge clk);
		reset <= 0; start <= 1;  						  @(posedge clk);
															  	  @(posedge done);
		reset <= 1; x0 <= 0; y0 <= 0; 				  @(posedge clk);
		reset <= 0; start <= 1; 					     @(posedge clk);
															  	  @(posedge done);
																		
		$stop;
	end
endmodule
