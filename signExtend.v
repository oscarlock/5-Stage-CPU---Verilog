module signExtend(input[1:0]       select,
                  input[15:0]      in,
                  output reg[15:0] out);

always@(*)
begin
   out = 16'hxxxx;
   if (select == 2'b00)
      begin
         if (in[7] == 1'b0) 
            out = {12'h000, in[7:4]};
         else if (in[7] == 1'b1)
            out = {12'hFFF, in[7:4]};
      end
   else if (select == 2'b01)
      begin
         if (in[3] == 1'b0)
            out = {12'h000, in[3:0]};
         else if (in[3] == 1'b1)
            out = {12'hFFF, in[3:0]};
      end
   else if (select == 2'b10)
      begin
         if (in[7] == 1'b0)
            out = {8'h00, in[7:0]};
         else if (in[7] == 1'b1)
            out = {8'hFF, in[7:0]};
      end
   else if (select == 2'b11)
      begin
         if (in[11] == 1'b0)
            out = {4'h0, in[11:0]};
         else if (in[11] == 1'b1)
            out = {4'hF, in[11:0]};
      end
end

endmodule
