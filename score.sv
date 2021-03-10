module score (clk, rst, point, HEX0, HEX1);
	input logic clk, rst, point;
	output logic [6:0] HEX0, HEX1;
	logic [3:0] count0, count1;
	
	always_ff @ (posedge clk) begin
		if (rst) begin
			count0 <= 0;
			count1 <= 0;
		end
		if (point) begin
			count0 <= count0 + 1;
		end
		else if (count0 > 9) begin
			count0 <= 0;
			count1 <= count1 + 1;
		end
	end
	
	seg7 s0 (.leds(HEX0), .bcd(count0));
	seg7 s1 (.leds(HEX1), .bcd(count1));
endmodule

module score_testbench();
	logic clk, rst, point;
	logic [6:0] HEX0, HEX1;
	
	parameter CLOCK_PERIOD = 100;
	
	score dut_score (clk, rst, point, HEX0, HEX1);
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	integer i;
	
	initial begin
		rst <= 1; 										@(posedge clk)
		rst <= 0;										@(posedge clk)
						point <= 1; 					@(posedge clk)
						point <= 0; 					@(posedge clk)
															@(posedge clk)
															@(posedge clk)
		for (i = 0; i < 200; i++) begin
			point = ~point;
			@(posedge clk);
		end		
															@(posedge clk)
		$stop;
	end
endmodule 