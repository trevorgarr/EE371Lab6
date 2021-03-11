module square_loc_picker (clk, reset, start, x_loc, y_loc, done);
	input logic clk, reset, start;
	output logic done;
	output logic [10:0] x_loc = 0, y_loc = 0;
	logic [10:0] x, y;
	logic [5:0] rand_loc;
	
	random rando (.clk, .reset, .out(rand_loc));

	always_comb begin
		case (rand_loc)
			6'b000000 : begin x = 345; y = 343; end
			6'b000001 : begin x = 0; y = 200; end
			6'b000010 : begin x = 50; y = 150; end
			6'b000011 : begin x = 600; y = 400; end
			6'b000100 : begin x = 123; y = 423; end
			6'b000101 : begin x = 321; y = 231; end
			6'b000110 : begin x = 43; y = 100; end
			6'b000111 : begin x = 43; y = 211; end
			6'b001000 : begin x = 321; y = 241; end
			6'b001001 : begin x = 98; y = 118; end
			6'b001010 : begin x = 234; y = 187; end
			6'b001011 : begin x = 78; y = 234; end
			6'b001100 : begin x = 111; y = 333; end
			6'b001101 : begin x = 333; y = 111; end
			6'b001110 : begin x = 99; y = 120; end
			6'b001111 : begin x = 234; y = 133; end
			6'b010000 : begin x = 600; y = 132; end
			6'b010001 : begin x = 1; y = 423; end
			6'b010010 : begin x = 44; y = 342; end
			6'b010011 : begin x = 223; y = 232; end
			6'b010100 : begin x = 323; y = 191; end
			6'b010101 : begin x = 89; y = 142; end
			6'b010110 : begin x = 50; y = 435; end
			6'b010111 : begin x = 98; y = 150; end
			6'b011000 : begin x = 445; y = 185; end
			6'b011001 : begin x = 612; y = 152; end
			6'b011010 : begin x = 30; y = 123; end
			6'b011011 : begin x = 132; y = 132; end
			6'b011100 : begin x = 342; y = 185; end
			6'b011101 : begin x = 443; y = 300; end
			6'b011110 : begin x = 553; y = 390; end
			6'b011111 : begin x = 112; y = 321; end
			6'b100000 : begin x = 212; y = 230; end
			6'b100001 : begin x = 545; y = 190; end
			6'b100010 : begin x = 435; y = 213; end
			6'b100011 : begin x = 543; y = 400; end
			6'b100100 : begin x = 543; y = 324; end
			6'b100101 : begin x = 023; y = 230; end
			6'b100110 : begin x = 400; y = 400; end
			6'b100111 : begin x = 600; y = 200; end
			6'b101000 : begin x = 9; y = 146; end
			6'b101001 : begin x = 43; y = 121; end
			6'b101010 : begin x = 259; y = 198; end 
			6'b101011 : begin x = 42; y = 323; end
			6'b101100 : begin x = 620; y = 334; end
			6'b101101 : begin x = 152; y = 339; end
			6'b101110 : begin x = 354; y = 390; end
			6'b101111 : begin x = 213; y = 213; end
			6'b110000 : begin x = 89; y = 289; end
			6'b110001 : begin x = 120; y = 389; end
			6'b110010 : begin x = 230; y = 289; end
			6'b110011 : begin x = 340; y = 108; end
			6'b110100 : begin x = 450; y = 410; end
			6'b110101 : begin x = 560; y = 157; end
			6'b110110 : begin x = 610; y = 400; end
			6'b110111 : begin x = 99; y = 210; end
			6'b111000 : begin x = 102; y = 400; end
			6'b111001 : begin x = 210; y = 312; end
			6'b111010 : begin x = 356; y = 286; end
			6'b111011 : begin x = 456; y = 212; end
			6'b111100 : begin x = 512; y = 164; end
			6'b111101 : begin x = 612; y = 230; end
			6'b111110 : begin x = 387; y = 400; end
			6'b111111 : begin x = 500; y = 220; end
		endcase
	end
	
	enum{idle,run,finished} ps, ns;
	
	always_comb
		case(ps)
			idle: ns = start ? run : idle;
			run: ns = finished;
			finished: ns = start ? finished : idle;
		endcase
	
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= idle;
		end else begin
			ps <= ns;
		end
		if(ps == idle) begin
			x_loc <= x_loc;
			y_loc <= y_loc;
		end else if (ps == run) begin
			x_loc <= x;
			y_loc <= y;
		end else begin
			x_loc <= x_loc;
			y_loc <= y_loc;
		end
	end
	
	assign done = (ps == finished);
	
endmodule

module square_loc_picker_testbench();
	logic clk, reset;
	logic [10:0] x_loc, y_loc;
	
	square_loc_picker dut (clk, reset, x_loc, y_loc);

	parameter clock_period = 100;
	initial begin
		clk <= 0;
		forever #(clock_period/2) clk <= ~clk;
	end

	initial begin
		reset <= 1; 										  @(posedge clk);
		reset <= 0; 				  						  @(posedge clk);
																  @(posedge clk);
																  @(posedge clk);
																  @(posedge clk);
																  @(posedge clk);
																  @(posedge clk);
																  @(posedge clk);
																  @(posedge clk);
																		
		$stop;
	end
endmodule