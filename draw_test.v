module draw_test(clk, rst, button, VGA_CLK, VGA_VS, VGA_HS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B, light1, light2, light3);
	input clk;
	input rst;
	input [1:0] button;


	output VGA_CLK;
	output VGA_HS;
	output VGA_VS;
	output VGA_BLANK_N;
	output VGA_SYNC_N;
	output [9:0] VGA_R;
	output [9:0] VGA_G;
	output [9:0] VGA_B;
	output reg light1;
	output reg light2;
	output reg light3;
	

	// Found VGA on the internet (Credited in citation)
	vga_adapter VGA(
	  .resetn(1'b1),
	  .clock(clk),
	  .colour(colour),
	  .x(x),
	  .y(y),
	  .plot(1'b1),
	  .VGA_R(VGA_R),
	  .VGA_G(VGA_G),
	  .VGA_B(VGA_B),
	  .VGA_HS(VGA_HS),
	  .VGA_VS(VGA_VS),
	  .VGA_BLANK(VGA_BLANK_N),
	  .VGA_SYNC(VGA_SYNC_N),
	  .VGA_CLK(VGA_CLK));
	defparam VGA.RESOLUTION = "160x120";
	defparam VGA.MONOCHROME = "FALSE";
	defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
	defparam VGA.BACKGROUND_IMAGE = "background.mif";
	
	clock(.clock(clk), .clk(frame));
	
	reg [7:0]player_balance;
	reg [5:0]S;
	reg [5:0]NS;
	reg [17:0]draw;
	reg done;
	reg fill_done;
	
	reg [19:0]line_len;
	reg [19:0]line_dip;
	
	parameter imageBits = 512'b10000111111000011000011111100001000001111110000000000111111000000000011111100000000001111110000010000111111000011000011111100001100001111110000110000111111000010000011111100000000001111110000000000111111000000000011111100000100001111110000110000111111000011000011111100001100001111110000100000111111000000000011111100000000001111110000000000111111000001000011111100001100001111110000110000111111000011000011111100001000001111110000000000111111000000000011111100000000001111110000010000111111000011000011111100001,
	          imageWidth = 5'd31,
				 imageHeight = 5'd16,
				 imageStart = 9'd511;
				 
	reg [63:0]imageX;
	reg [63:0]imageY;
	reg [63:0]counter;
	
	parameter initX = 63'd15,
			    initY = 63'd15;
	
	
	reg [7:0]x;
	reg [7:0]y;
	reg [2:0]colour;
	wire frame;
	
	parameter START_DRAW = 4'd0,
				 INIT_DRAW = 4'd1,
				 COND_DRAW = 4'd2,
				 DRAW_IMAGE = 4'd3,
				 BITCOND_DRAW = 4'd4,
				 INCX_DRAW_IMAGE = 4'd5,
				 INCY_DRAW_IMAGE = 4'd6,
				 DEC_COUNTER_DRAW_IMAGE = 4'd7,
				 EXIT_DRAW_IMAGE = 4'd8;
	
	
	
	always @(posedge clk or negedge rst)
		if (rst == 1'b0)
			S <= START_DRAW;
		else
			S <= NS;
			
	always @(*)
		case (S)
			START_DRAW : NS = INIT_DRAW;
			INIT_DRAW : NS = COND_DRAW;
			COND_DRAW :
				if (imageBits[counter] == 1'b1)
					NS = DRAW_IMAGE;
				else
					NS = BITCOND_DRAW;
					
			DRAW_IMAGE : NS = BITCOND_DRAW;
			BITCOND_DRAW :
				if (imageX >= imageWidth)
					NS = INCY_DRAW_IMAGE;
				else
					NS = INCX_DRAW_IMAGE;
			
			INCX_DRAW_IMAGE : NS = DEC_COUNTER_DRAW_IMAGE;
			INCY_DRAW_IMAGE : NS = DEC_COUNTER_DRAW_IMAGE;
			DEC_COUNTER_DRAW_IMAGE :
				if (imageY < imageHeight)
					NS = COND_DRAW;
				else
					NS = EXIT_DRAW_IMAGE;
			EXIT_DRAW_IMAGE : NS = EXIT_DRAW_IMAGE;
			
		endcase
			
			
	always @(posedge clk or negedge rst)
		if (rst == 1'b0)
		begin
			done <= 1'b0;
			fill_done <= 1'b0;
			colour <= 3'b000;
			x <= 8'b00000000;
			y <= 8'b00000000;
			draw <= 18'b0;
			line_len <= 20'd0;
			line_dip <= 20'd0;
			light1 <= 1'b0;
			light2 <= 1'b0;
			light3 <= 1'b0;
			
			imageX <= 64'b0;
			imageY <= 64'b0;
			counter <= 64'b0;
		end
		else
			case (S)
				START_DRAW : begin end
				INIT_DRAW : counter <= imageStart;
				COND_DRAW : begin end
				DRAW_IMAGE :
				begin
					colour <= 3'b100;
					x <= initX + imageX;
					y <= initY + imageY;
				end
				
				BITCOND_DRAW : begin end
				INCX_DRAW_IMAGE : imageX <= imageX + 1'b1;
				INCY_DRAW_IMAGE :
				begin
					imageX <= 64'b0;
					imageY <= imageY + 1'b1;
				end
				DEC_COUNTER_DRAW_IMAGE : counter <= counter - 1'b1;
				EXIT_DRAW_IMAGE : begin end
			endcase
	
endmodule 


module clock (input clock, output clk);
	reg [19:0] frame_counter;
	reg frame;

	always@(posedge clock)
	  begin
		 if (frame_counter == 20'b0) begin
			frame_counter = 20'd833332;  // This divisor gives us ~60 frames per second
			frame = 1'b1;
		 end 
		 
		 else 
		 begin
			frame_counter = frame_counter - 1'b1;
			frame = 1'b0;
		 end
	  end

	assign clk = frame;
endmodule
