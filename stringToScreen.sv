module stringToScreen #(parameter size = 10, stringSize = 6) (clk, reset, xOffset,yOffset, x, y, start, done, str);
	input logic [6:0] str [stringSize-1:0];
	input logic [10:0] xOffset,yOffset;
	input logic start, clk, reset;
	output logic done;
	output logic[10:0] x, y;
	
	logic[14:0] asciiVal;
	logic [10:0] charOffset;
	logic charDone, stop;
	logic nxtChar, startChar;
	logic [stringSize-1:0] counter;
	logic [8:0] hold;
	
	enum{first,update,stay,finished} ps, ns;
	
	always_comb
		case(ps)
			first: ns = start ? stay : first;
			update: ns = stay;
			stay: begin if(stop) ns = finished;
							else ns = charDone ? update : stay;
					end
			finished: ns = start ? finished : first;
		endcase
	
	always_ff @(posedge clk) begin
		if(reset) begin
			ps <= first;
		end else if(ps == first) begin
			asciiVal <= str[stringSize-1];
			nxtChar <= 1;
			charOffset <= 0;
			counter <= stringSize - 2;
			ps <= ns;
			hold <= 0;
			startChar <= 1;
		end else if(ps == update) begin
			asciiVal <= str[counter];
			counter <= counter - 1;
			nxtChar <= 1;
			if(str[counter] != 0) begin
				charOffset <= charOffset + size + 5;
			end
			hold <= 0;
			startChar <= 1;
			ps <= ns;
		end else if(ps == stay) begin
			hold <= hold + 1;
			startChar <= 0;
			if(hold > 5) begin
				ps <= ns;
				nxtChar <= 0;
			end
		end else if(ps == finished) begin
			ps <= ns;
		end
	end
	assign stop = (counter) == 0;
	assign done = ps == finished && charDone;  
	
	
	charConverter #(.size(size)) convert (.clk, .reset(startChar), .character(asciiVal), .x, .y, .x0(xOffset+charOffset), .y0(yOffset), .done(charDone), .start(nxtChar));

	
endmodule
	
	
	