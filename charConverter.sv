//takes a number that represents either a number or character and outputs the x and y coordinates 
module charConverter #(parameter size = 10) (clk, reset, character, x, y, x0, y0, done, start);
	input logic[6:0] character;
	input logic clk, start, reset;
	output logic [10:0] x,y;
	input logic [10:0] x0, y0;
	output logic done; 
	
	logic [14:0] ascii [95:0];
	
	initial begin
		$readmemb("14segTable.txt",ascii);
	end
	logic [13:0] hexVal;
	assign hexVal = 14'b11111111111111;
	
	//seg7Hex #(.size(size)) test (.clk, .reset, .hex(ascii[character]),.x,.y, .xOffset(x0), .yOffset(y0), .done, .start); //temperary to see if this works
	seg14Hex prtScreen (.clk, .reset, .hex(ascii[character]),.x,.y, .xOffset(x0), .yOffset(y0), .done, .start);
	
	

endmodule

module seg14Hex #(parameter size = 20) (clk, reset, hex,x,y, xOffset, yOffset, done, start);
	input logic [13:0] hex;
	input logic start, clk, reset;
	output logic [10:0] x,y;
	input logic [10:0] xOffset,yOffset;
	output logic done; 
	logic lineDone;
	logic [10:0] x0,x1,y0,y1;
	logic newLine;
	
	enum{startState,a,b,c,d,e,f,g1, g2, h, i, j, k, l, m, finished} ns,ps;
	
	always_comb begin
		case(ps)
			startState: begin if(!start)
						ns = startState;
					 else if(hex[0])
						ns = a;
					 else if(hex[1])
						ns = b;
					 else if(hex[2])
						ns = c;
					 else if(hex[3])
						ns = d;
					 else if(hex[4])
						ns = e;
					 else if(hex[5])
						ns = f;
					 else if(hex[6])
					   ns = g1;
					 else if(hex[7])
					   ns = g2;
					 else if(hex[8])
					   ns = h;
					 else if(hex[9])
					   ns = i;
					 else if(hex[10])
					   ns = j;
					 else if(hex[11])
					   ns = k;
					 else if(hex[12])
					   ns = l;
					 else if(hex[13])
					   ns = m;
					 else
					   ns = finished;
					end
			a:		begin 
					if(hex[1])
						ns = b;
					 else if(hex[2])
						ns = c;
					 else if(hex[3])
						ns = d;
					 else if(hex[4])
						ns = e;
					 else if(hex[5])
						ns = f;
					 else if(hex[6])
					   ns = g1;
					 else if(hex[7])
					   ns = g2;
					 else if(hex[8])
					   ns = h;
					 else if(hex[9])
					   ns = i;
					 else if(hex[10])
					   ns = j;
					 else if(hex[11])
					   ns = k;
					 else if(hex[12])
					   ns = l;
					 else if(hex[13])
					   ns = m;
					 else
					   ns = finished;
					end
		  b:		 if(hex[2])
						ns = c;
					 else if(hex[3])
						ns = d;
					 else if(hex[4])
						ns = e;
					 else if(hex[5])
						ns = f;
					 else if(hex[6])
					   ns = g1;
					 else if(hex[7])
					   ns = g2;
					 else if(hex[8])
					   ns = h;
					 else if(hex[9])
					   ns = i;
					 else if(hex[10])
					   ns = j;
					 else if(hex[11])
					   ns = k;
					 else if(hex[12])
					   ns = l;
					 else if(hex[13])
					   ns = m;
					 else
					   ns = finished;
		 c:		 if(hex[3])
						ns = d;
					 else if(hex[4])
						ns = e;
					 else if(hex[5])
						ns = f;
					 else if(hex[6])
					   ns = g1;
					 else if(hex[7])
					   ns = g2;
					 else if(hex[8])
					   ns = h;
					 else if(hex[9])
					   ns = i;
					 else if(hex[10])
					   ns = j;
					 else if(hex[11])
					   ns = k;
					 else if(hex[12])
					   ns = l;
					 else if(hex[13])
					   ns = m;
					 else
					   ns = finished;
		d:			 if(hex[4])
						ns = e;
					 else if(hex[5])
						ns = f;
					 else if(hex[6])
					   ns = g1;
					 else if(hex[7])
					   ns = g2;
					 else if(hex[8])
					   ns = h;
					 else if(hex[9])
					   ns = i;
					 else if(hex[10])
					   ns = j;
					 else if(hex[11])
					   ns = k;
					 else if(hex[12])
					   ns = l;
					 else if(hex[13])
					   ns = m;
					 else
					   ns = finished;	
		e:			if(hex[5])
						ns = f;
					 else if(hex[6])
					   ns = g1;
					 else if(hex[7])
					   ns = g2;
					 else if(hex[8])
					   ns = h;
					 else if(hex[9])
					   ns = i;
					 else if(hex[10])
					   ns = j;
					 else if(hex[11])
					   ns = k;
					 else if(hex[12])
					   ns = l;
					 else if(hex[13])
					   ns = m;
					 else
					   ns = finished;
		f:			 if(hex[6])
					   ns = g1;
					 else if(hex[7])
					   ns = g2;
					 else if(hex[8])
					   ns = h;
					 else if(hex[9])
					   ns = i;
					 else if(hex[10])
					   ns = j;
					 else if(hex[11])
					   ns = k;
					 else if(hex[12])
					   ns = l;
					 else if(hex[13])
					   ns = m;
					 else
					   ns = finished;
	   g1:		 if(hex[7])
					   ns = g2;
					 else if(hex[8])
					   ns = h;
					 else if(hex[9])
					   ns = i;
					 else if(hex[10])
					   ns = j;
					 else if(hex[11])
					   ns = k;
					 else if(hex[12])
					   ns = l;
					 else if(hex[13])
					   ns = m;
					 else
					   ns = finished;
		g2:		 if(hex[8])
					   ns = h;
					 else if(hex[9])
					   ns = i;
					 else if(hex[10])
					   ns = j;
					 else if(hex[11])
					   ns = k;
					 else if(hex[12])
					   ns = l;
					 else if(hex[13])
					   ns = m;
					 else
					   ns = finished;
		h:			 if(hex[9])
					   ns = i;
					 else if(hex[10])
					   ns = j;
					 else if(hex[11])
					   ns = k;
					 else if(hex[12])
					   ns = l;
					 else if(hex[13])
					   ns = m;
					 else
					   ns = finished;
		i:			 if(hex[10])
					   ns = j;
					 else if(hex[11])
					   ns = k;
					 else if(hex[12])
					   ns = l;
					 else if(hex[13])
					   ns = m;
					 else
					   ns = finished;
		j:			 if(hex[11])
					   ns = k;
					 else if(hex[12])
					   ns = l;
					 else if(hex[13])
					   ns = m;
					 else
					   ns = finished;
		k:			 if(hex[12])
					   ns = l;
					 else if(hex[13])
					   ns = m;
					 else
					   ns = finished;
		l:			 if(hex[13])
					   ns = m;
					 else
					   ns = finished;
		m:			 ns = finished;
		finished: ns = start ? finished : startState;
		endcase
	end
	
	always_ff @(posedge clk)begin 
		if(reset)
			ps <= startState;
		if(lineDone)
			ps <= ns;
	end
	
	always_comb
		case(ps)
			startState: begin x0 = 0; x1 = 0; y0 = 0; y1 = 0; end
			a: begin x0 = xOffset; x1 = size+xOffset; y0 = yOffset; y1 = yOffset; end
			b: begin x0 = xOffset+size; x1 = xOffset+size; y0 = yOffset; y1 = yOffset+size; end
			c: begin x0 = xOffset+size; x1 = xOffset+size; y0 = yOffset+size; y1 = yOffset+size*2; end
			d: begin x0 = xOffset; x1 = xOffset+size; y0 = yOffset+size*2; y1 = yOffset + size*2; end
			e: begin x0 = xOffset; x1 = xOffset; y0 = yOffset+size; y1 = yOffset+size*2; end
			f: begin x0 = xOffset; x1 = xOffset; y0 = yOffset; y1 = yOffset+size; end
			g1: begin x0 = xOffset; x1 = size/2+xOffset; y0 = yOffset+size; y1 = yOffset+size; end
			g2: begin x0 = xOffset+size/2; x1 = size+xOffset; y0 = yOffset+size; y1 = yOffset+size; end
			h: begin x0 = xOffset; x1 = size/2+xOffset; y0 = yOffset; y1 = yOffset+size; end
			i: begin x0 = xOffset+size/2; x1 = size/2+xOffset; y0 = yOffset; y1 = yOffset+size; end
			j: begin x0 = xOffset+size/2; x1 = size+xOffset; y0 = yOffset+size; y1 = yOffset; end
			k: begin x0 = xOffset; x1 = size/2+xOffset; y0 = yOffset+size*2; y1 = yOffset+size; end
			l: begin x0 = xOffset+size/2; x1 = size/2+xOffset; y0 = yOffset+size; y1 = yOffset+size*2; end
			m: begin x0 = xOffset+size/2; x1 = xOffset+size; y0 = yOffset+size; y1 = yOffset+size*2; end
			finished: begin x0 = 0; x1 = 0; y0 = 0; y1 = 0; end
	  endcase
	  
	  assign done = (ps == finished);
	  assign newLine = 0; //I think this always stays 0, attached to line_drawers reset
	  
	  
					

	line_drawer draw(.clk, .reset(newLine), .x0, .y0, .x1, .y1, .x, .y, .done(lineDone));
	
	
endmodule










module seg7Hex #(parameter size = 10) (clk, reset, hex,x,y, xOffset, yOffset, done,start);
	input logic [6:0] hex;
	input logic start, clk, reset;
	output logic [10:0] x,y;
	input logic [10:0] xOffset,yOffset;
	output logic done; 
	logic lineDone;
	logic [10:0] x0,x1,y0,y1;
	logic newLine;
	
	enum{startState,a,b,c,d,e,f,g, finished} ns,ps;

	always_comb begin
		case(ps)
			startState: begin if(!start)
						ns = startState;
					 else if(hex[0])
						ns = a;
					 else if(hex[1])
						ns = b;
					 else if(hex[2])
						ns = c;
					 else if(hex[3])
						ns = d;
					 else if(hex[4])
						ns = e;
					 else if(hex[5])
						ns = f;
					 else if(hex[6])
					   ns = g;
					 else
					   ns = finished;
					end
			a:		begin 
					if(hex[1])
						ns = b;
					 else if(hex[2])
						ns = c;
					 else if(hex[3])
						ns = d;
					 else if(hex[4])
						ns = e;
					 else if(hex[5])
						ns = f;
					 else if(hex[6])
					   ns = g;
					 else
					   ns = finished;
					end
		  b:		 if(hex[2])
						ns = c;
					 else if(hex[3])
						ns = d;
					 else if(hex[4])
						ns = e;
					 else if(hex[5])
						ns = f;
					 else if(hex[6])
					   ns = g;
					 else
					   ns = finished;
		 c:		 if(hex[3])
						ns = d;
					 else if(hex[4])
						ns = e;
					 else if(hex[5])
						ns = f;
					 else if(hex[6])
					   ns = g;
					 else
					   ns = finished;
		d:			 if(hex[4])
						ns = e;
					 else if(hex[5])
						ns = f;
					 else if(hex[6])
					   ns = g;
					 else
					   ns = finished;
		e:			if(hex[5])
						ns = f;
					 else if(hex[6])
					   ns = g;
					 else
					   ns = finished;
		f:			 if(hex[6])
					   ns = g;
					 else
					   ns = finished;
	   g:			 ns = finished;
		finished: ns = start ? finished : startState;
		endcase
	end
	
	always_ff @(posedge clk)begin 
		if(reset)
			ps <= startState;
		if(lineDone)
			ps <= ns;
	end
	
	always_comb
		case(ps)
			startState: begin x0 = 0; x1 = 0; y0 = 0; y1 = 0; end
			a: begin x0 = xOffset; x1 = size+xOffset; y0 = yOffset; y1 = yOffset; end
			b: begin x0 = xOffset+size; x1 = xOffset+size; y0 = yOffset; y1 = yOffset+size; end
			c: begin x0 = xOffset+size; x1 = xOffset+size; y0 = yOffset+size; y1 = yOffset+size*2; end
			d: begin x0 = xOffset; x1 = xOffset+size; y0 = yOffset+size*2; y1 = yOffset + size*2; end
			e: begin x0 = xOffset; x1 = xOffset; y0 = yOffset+size; y1 = yOffset+size*2; end
			f: begin x0 = xOffset; x1 = xOffset; y0 = yOffset; y1 = yOffset+size; end
			g: begin x0 = xOffset; x1 = size+xOffset; y0 = yOffset+size; y1 = yOffset+size; end
			finished: begin x0 = 0; x1 = 0; y0 = 0; y1 = 0; end
	  endcase
	  
	  assign done = (ps == finished);
	  assign newLine = 0; //I think this always stays 0, attached to line_drawers reset
	  
	  
					

	line_drawer draw(.clk, .reset(newLine), .x0, .y0, .x1, .y1, .x, .y, .done(lineDone));

endmodule

module charConverter_testbench();
	logic[6:0] character;
	logic clk, start, reset;
	logic [10:0] x,y;
	logic done;
	
	charConverter dut(.clk, .reset, .character,.x,.y, .done, .start);
	
	 parameter clock_period = 100;
    initial begin
        clk <= 0;
        forever #(clock_period/2) clk <= ~clk;
    end
    integer i;
    initial begin
		reset <= 1; character <= 7'b1000011; start <= 1;				@(posedge clk);
		reset <= 0;													@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
																		@(posedge done);
																		@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
	 $stop;
	end
endmodule
