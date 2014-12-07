module byteToCoords(
              input clock,
              input we,
              input reset,
              output ready,
              input [7:0] data,
              output reg [7:0] coords [24:0])

  parameter READ = 2'b10;
  parameter IDLE = 2'b00;
  parameter READY = 2'b11
  reg [1:0] state = IDLE;

  initial ready = 0;
  reg [2:0] counter;
  always @ (clock) begin
    case (state)
      READ: begin
      end
      READY: begin
      end
      default: begin
      end


    if (counter < 6) begin
      if (we) begin
        coords[counter] <= data;
        counter <= counter+1;
        if (counter == 5) ready <= 1;
        else ready <= 0;
      end
    end else begin
      if (reset) begin
        ready <= 0;
        counter <= 0;
      end else ready <= 1;
    end
  end
endmodule
