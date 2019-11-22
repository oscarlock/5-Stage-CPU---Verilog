module comparator(input       control, 
                  input[3:0]  opCode,
                  input[15:0] in1, in2, 
                  output reg  out);

reg comp;

always@(*)
begin
   if (opCode == 4'b0100)
      comp = in1 < in2;
   else if (opCode == 4'b0101)
      comp = in1 > in2;
   else if (opCode == 4'b0110)
      comp = in1 == in2;
   
   if (control & comp)
       out = 1'b1;
   else
       out = 1'b0;
end

endmodule
