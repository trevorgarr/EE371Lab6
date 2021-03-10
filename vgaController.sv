module vgaController(clk,reset, start, pixel_color, x,y,xMouse,yMouse, mousePixelColor, xStartup,yStartup, startupPixelColor, start_state_finished,xBox,yBox, boxPixelColor boxStart, boxEnd);

	input logic clk, reset, start, start_state_finished, boxStart, boxEnd, mousePixelColor, startupPixelColor, boxPixelColor;
	input logic [10:0] xMouse, yMouse, xStartup, yStartup, xBox, yBox;
	output logic [10:0] x,y;
	output logic pixel_color;
	
	logic [10:0] xCounter, yCounter;
	
	
	enum{idle, startupState, mouseState, boxState} ps, ns;
	
	always_comb
		case(ps)
			idle: begin x = 0; y = 0; pixel_color = 1'b0; ns = start ? startupState : idle; end
			startupState: begin x = xStartup; y = yStartup; pixel_color = startupPixelColor; ns = start_state_finished ? mouseState : startupState; end
			mouseState: begin x=xMouse; y = yMouse; pixel_color = mousePixelColor; ns = boxStart ? boxState : mouseState; end
			boxState: begin x=xBox; y = yBox; pixel_color = boxPixelColor; ns = boxEnd ? mouseState: boxState; end
		endcase
	
	always_ff @(posedge clk) begin
		if(reset)
			ps <= idle;
		else
			ps <= ns;
	end
endmodule 