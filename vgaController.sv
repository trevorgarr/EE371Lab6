module vgaController(clk,reset, start, pixel_color, x,y,xMouse,yMouse, mousePixelColor, xStartup,yStartup, startupPixelColor, start_state_finished,xBox,yBox, boxPixelColor, boxStart, boxEnd, tripBox, newGame);
	output logic tripBox;
	input logic clk, reset, start, start_state_finished, boxStart, boxEnd, mousePixelColor, startupPixelColor, boxPixelColor;
	input logic [10:0] xMouse, yMouse, xStartup, yStartup, xBox, yBox;
	output logic [10:0] x,y;
	output logic pixel_color, newGame;
	
	logic[31:0] counter;
	
	
	enum{idle, startupState, mouseState, boxState} ps, ns;
	
	always_comb begin
		case(ps)
			idle: begin x = 0; y = 0; pixel_color = 1'b0; tripBox = 1'b0; ns = startupState; end
			startupState: begin x = xStartup; y = yStartup; pixel_color = startupPixelColor; ns = start_state_finished ? boxState : startupState; if(start_state_finished) tripBox = 1'b1; else tripBox = 1'b0; end
			mouseState: begin x=xMouse; y = yMouse; pixel_color = mousePixelColor; tripBox = 1'b0; if(counter[30] == 1) ns = idle; else ns = boxStart ? boxState : mouseState; end
			boxState: begin x=xBox; y = yBox; pixel_color = boxPixelColor; tripBox = 1'b0; ns = boxEnd ? mouseState: boxState; end
		endcase
	end
	
	always_ff @(posedge clk) begin
		if(reset) begin
			ps <= idle;
			counter <= 0;
		end else
			ps <= ns;
		if(ps == idle) begin
			counter <= 0;
			newGame <= 1;
		end else begin
			counter <= counter + 1;
			newGame <= 0;
		end
	end
	
endmodule 