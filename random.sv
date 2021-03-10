module random (clk, reset, out);
	input logic reset, clk;
	output logic [5:0] out;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			out <= 5'b0;
		end else begin
			out[5] <= out[4];
			out[4] <= out[3];
			out[3] <= out[2];
			out[2] <= out[1];
			out[1] <= out[0];
			out[0] <= (out[5] ~^ out[4]);
		end
	end
endmodule

module random_testbench();
	logic clk, reset;
	logic [5:0] out;
	
	parameter CLOCK_PERIOD = 100;
	
	random dut_random (clk, reset, out);
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	integer i;
	
	initial begin
		reset <= 1;								   	@(posedge clk)
		reset <= 0;							    		@(posedge clk)
															@(posedge clk)
		for (i = 0; i < 64; i++) begin
			@(posedge clk);
		end		
															@(posedge clk)
		$stop;
	end
endmodule 


	
	