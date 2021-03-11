module square_drawer #(parameter SIZE = 10) (clk, reset, start, x0, y0, x, y, done, setColor, pixelColor);
	input logic clk, reset, start, setColor;
	input logic [10:0] x0, y0;
	output logic [10:0] x, y;
	output logic done, pixelColor;
	logic [10:0] x1, y1;
	logic [10:0] x_loc, y_loc;
	
	assign x1 = x0 + SIZE;
	assign y1 = y0 + SIZE;
	
	enum {boot,idle, draw, finish} ps, ns;
	
	always_comb begin
		case(ps)
			boot: ns = idle;
			idle: ns = start ? draw : idle;
			draw:  ns = (y_loc == y1 & x_loc == x1) ? finish : draw;
			finish: ns = start ? finish : idle;	
		endcase
		if(!setColor) begin
			if(ps == draw || ps == finish)
				pixelColor = 1'b0;
			else
				pixelColor = 1'b1;
		end else
			pixelColor = 1'b1;
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			x_loc <= x0;
			y_loc <= y0;
		end else if (ps == idle) begin
			x_loc <= x0;
			y_loc <= y0;
		end else if (ps == draw) begin
			if (x_loc == x1 && y_loc != y1) begin
				x_loc <= x0;
				y_loc <= y_loc + 1'b1;
			end else if (y_loc == y1 && x_loc != x1) begin
				x_loc <= x_loc + 1'b1;
				y_loc <= y1;
			end else begin
				x_loc <= x_loc + 1'b1;
				y_loc <= y_loc;
			end
		end
		ps <= ns;
	end
	
	assign x = x_loc;
	assign y = y_loc;
	assign done = (ps == finish);
	
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
						x0 <= 0; y0 <= 0; 				  @(posedge clk);
						start <= 1; 					     @(posedge clk);
															  	  @(posedge done);
																		
		$stop;
	end
endmodule