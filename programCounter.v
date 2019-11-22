module programCounter(input            clock, reset, pcWrite, halt,
                      input[15:0]      in, 
                      output reg[15:0] out);

reg[15:0] s_in;

always@(posedge clock or negedge reset)
begin
   if (!reset)
      begin
         s_in <= 16'h0000;
         out  <= 16'h0000;
      end
//   else if (halt == 1'b1)
//      begin
//         clock <= 1'bx;
//      end
   else if (pcWrite == 1'b0)
      begin
         s_in <= s_in;
      end
   else
      begin
         s_in <= in;
      end
end

always@(*)
begin
   out <= s_in;
end

endmodule
