`timescale  10ns/100ps

module led_top #(LED_SIZE =8,
		SW_SIZE=8,
		FREQUENCY_DIV_SIZE=28
		)
	(
	 	input			clk_p,
		input			clk_n,
		input			rst_n,//middle sw
		input	[SW_SIZE-1:0]	sw,//4 sws
		output	[LED_SIZE-1:0]	led_out//8 led outputs
	);
	
	IBUFDS #(
		.DIFF_TERM("FALSE"),
		.IBUF_LOW_PWR("FALSE"),
		.IOSTANDARD("DEFAULT")
		) buf_inst (
		.O(clk),
		.I(clk_p),
		.IB(clk_n)
		);


	reg					flag;
	reg	[FREQUENCY_DIV_SIZE-1:0]	div_counter;
	reg	[LED_SIZE-1:0]			led_count;

	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
		begin
			div_counter	<={FREQUENCY_DIV_SIZE{1'b0}};
			flag 		<=1'b0;
		end
		else if(div_counter == 27'd100000000)
		begin
			flag 		<=1'b1;
			div_counter	<={FREQUENCY_DIV_SIZE{1'b0}};
		end
		else
		begin
			flag 		<=1'b0;
			div_counter	<=div_counter+1;
		end
	end 


	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
		begin
			led_count	<={LED_SIZE{1'b0}};
		end
		else if(flag)
		begin
			if(sw ==8'd1)
			begin
				led_count	<=led_count;
			end
			else if(sw==8'd2)
			begin
				led_count	<=led_count<<1;
			end
			else if(sw==8'd4)
			begin
				led_count	<=led_count>>1;
			end
			else if(sw==8'd8)
			begin
				led_count	<=~led_count;
			end
			else
			begin
				led_count	<=led_count+1;
			end
		end
		else
		begin
			led_count	<=led_count;
		end

	end 

	assign led_out	= led_count;


endmodule
