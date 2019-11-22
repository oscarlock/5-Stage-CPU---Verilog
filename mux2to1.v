module mux2to1(input            select,
               input[15:0]      in0, in1,
               output reg[15:0] out);

always@(*)
   if (select == 1'b1)
      out = in1;
   else
      out = in0;

endmodule
