//this runs once at startup
module screenStartup(clk, reset, start,done,x,y, pixelColor, press_play);
	input logic start, clk, reset, press_play;
	output logic done;
	output logic [10:0] x,y;
	output logic pixelColor;
	
	logic lineDone, newString, newLine;
	logic [6:0] str [13:0];
	logic [10:0] xOffset, yOffset;
	logic [10:0] hold;
	
	enum{startState,welcome,press_to_play,erase, hold_till_button, score, finished} ps, ns;
	
	always_comb
		case(ps)
			startState: begin str = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0}; xOffset = 0; yOffset = 0; ns = start ? welcome : startState; end
			welcome: begin str = '{55,37,44,35,47,45,37,0,0,0,0,0,0,0}; xOffset = 220; yOffset = 10; ns = press_to_play; end
			press_to_play: begin str = '{48,50,37,51,51,95,52,47,95,48,44,33,57,0}; xOffset = 150; yOffset = 60; ns = press_play ? erase : hold_till_button; end
			hold_till_button: begin str = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0}; xOffset = 0; yOffset = 0; ns = press_play ? erase : hold_till_button; end
			erase: begin str = '{48,50,37,51,51,95,52,47,95,48,44,33,57,0}; xOffset = 150; yOffset = 60; ns = score; end
			score: begin str = '{51,35,47,50,37,0,0,0,0,0,0,0,0,0}; xOffset = 235; yOffset = 60; ns = finished; end
			finished: begin str = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0}; xOffset = 0; yOffset = 0; ns = start ? finished : startState; end
		endcase
	
	always_ff @(posedge clk) begin
		if(reset) begin
			ps <= startState;
		end else if(ps == startState || ps == hold_till_button || ps == finished) begin
			hold <= 0;
			newString <= 0;
			newLine <= 0;
			ps <= ns;
		end else if(lineDone && hold > 5) begin
			ps <= ns;
			newString <= 0;
			hold <= 0;
		end else begin
			hold <= hold + 1;
			if(hold > 1)
				newLine <= 0;
			if(hold > 5)
				newString <= 1;
		end
	end
	
	assign pixelColor = (ps != erase);
	assign done = ps == finished;
	
	stringToScreen #(.size(20),.stringSize(14)) prntScreen (.clk, .reset(newLine), .xOffset,.yOffset, .start(newString), .done(lineDone), .x, .y,.str(str));
	
endmodule 