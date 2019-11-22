module mux5to1(input            selectTop, 
               input[1:0]       selectBottom,
               input[15:0]      in0, in1, in2, in3, in4,
               output reg[15:0] out);

always@(*)
begin
   if (selectBottom == 2'b10)
      begin
         out = in4;
      end 
   else if (selectTop == 1'b1)
      begin
         out = in1;
      end
   else if (selectBottom == 2'b00)
      begin
         out = in2;
      end
   else if (selectBottom == 2'b01)
      begin
         out = in3;
      end
   else if (selectTop == 1'b0)
      begin
         out = in0;
      end
end

endmodule
