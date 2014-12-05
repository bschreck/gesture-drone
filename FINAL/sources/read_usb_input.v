`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:46:46 11/19/2014 
// Design Name: 
// Module Name:    read_usb_input 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module read_usb_input(
    input clock,
	 input reset,
	 input [7:0] data,
	 output rd,
	 input rxf,
	 output reg [7:0] out_data
    );
	 
	 wire [7:0] inter;
	 reg [24:0] counter = 25'd0;
	 wire debug; //for debugging - not used
	 reg hold = 1;
	 wire newout;
	 
	 parameter ON = 1'b1;
	 parameter OFF = 1'b0;
	 reg state = OFF;
	 initial out_data = 0;

	 usb_input usb_i(.clk(clock),
						 .reset(reset),
						 .data(data), //incoming data from usb
						 .rd(rd),
						 .rxf(rxf),
						 .out(inter), //output data - not always valid
						 .newout(newout), //signals out is valid
						 .hold(hold),
						 .state(debug));
						 
always @(posedge clock) begin
	case (state)
	OFF:
	begin //increment counter
		counter <= counter +1;
		if (counter == 25'd27000000) begin
		  state <= ON;
		  hold <= 0;
		end
	end
	ON:
	begin 
		if (newout) begin
			out_data <= inter;
			state <= OFF;
			hold <= 1;
		end
	end
	endcase
end

endmodule
