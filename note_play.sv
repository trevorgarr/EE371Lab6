/* Trevor Garrood and Sam Quiring
 * EE 371 Lab 6 03/10/2021
 *
 * Playes a note from memory
 *
 * The inputs are clk, reset, read_ready, write_ready
 * The outputs are read, write, writedata_left, writedata_right.
 */
module note_play (clk, reset, read_ready, write_ready, read, write,
						writedata_left, writedata_right, start, done);
	input logic clk, reset, start; 
	input logic read_ready, write_ready;
	output logic read, write;
	output logic [23:0] writedata_left = 0, writedata_right = 0;
	output logic done;
	logic time_up = 0;
	logic [15:0] address = 0;
	logic [23:0] data_out;
	logic [20:0] counter = 0;
	
	enum{idle, play, finish} ps, ns;
	
	always_comb begin
		case(ps)
			idle: ns = start ? play : idle;
			play:  ns = (counter == 2000000) ? finish : play;
			finish: ns = start ? finish : idle;	
		endcase
	end
	
	// runs the built note module
	note note_seq (.address, .clock(clk), .q(data_out));
	
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= idle;
		end else begin
			ps <= ns;
		end
		if (ps == idle) begin
			writedata_left <= 0; 
	      writedata_right <= 0;
			address <= address;
		end else if (ps == play) begin
			counter <= counter + 1;
			address <= address + 1'b1;
			writedata_left <= data_out; 
	      writedata_right <= data_out;
			if (counter == 2000000) begin
				counter <= 0;
			end		
		end else begin
			writedata_left <= 0; 
			writedata_right <= 0;
		end
	end

	assign done = (ps == finish);
	assign read = read_ready;
	assign write = write_ready;
	
endmodule

// Tests our note_play implementation to ensure proper read/write capability
`timescale 1 ps / 1 ps
module note_play_testbench();
	logic CLOCK_50, reset, start, done;
	logic read_ready, write_ready;
	logic [23:0] writedata_left, writedata_right;
	logic read, write;
	
	parameter CLOCK_PERIOD = 100;
	
	note_play dut (CLOCK_50, reset, read_ready, write_ready, read, write,
						writedata_left, writedata_right, start, done);
	
	// initialize the clock
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
		reset = 1; read_ready = 0; write_ready = 0; @(posedge CLOCK_50)
		reset = 0; read_ready = 1; write_ready = 1; @(posedge CLOCK_50)
																  @(posedge CLOCK_50)
																  @(posedge CLOCK_50)
																  @(posedge done)
																  @(posedge CLOCK_50)
																  @(posedge CLOCK_50)
		$stop;
	end
endmodule
