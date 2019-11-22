module adder(input[15:0]      in1, in2, 
             output reg[15:0] out);

always@(*)
begin
   assign out = in1 + in2;
end

endmodule
