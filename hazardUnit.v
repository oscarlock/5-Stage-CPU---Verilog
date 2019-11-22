module hazardUnit(input[3:0] halt,
                  input[3:0] bufferIFID_RR1, bufferIFID_RR2, bufferIDEX_RR1, 
                  input      bufferIDEX_memRead, 
                  output reg pc_pc, pc_halt, bIFID_stall, bIDEX_flush);

always@(*)
begin
   if (halt == 4'b1111)
      begin
         pc_halt = 1'b1;
      end
   else if ((bufferIFID_RR1 != 0) && (bufferIFID_RR2 != 0) && bufferIDEX_memRead && ((bufferIFID_RR1 == bufferIDEX_RR1) || (bufferIFID_RR2 == bufferIDEX_RR1)))
      begin $display("stall");
         pc_pc          = 1'b0;
         bIFID_stall    = 1'b1;
         bIDEX_flush    = 1'b1;
      end
   else 
      begin
         pc_pc          = 1'b1;
         bIFID_stall    = 1'b0;
         bIDEX_flush    = 1'b0;
      end
end

endmodule
