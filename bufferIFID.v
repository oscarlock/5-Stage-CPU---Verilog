module bufferIFID(input            clock, reset, stall, flush,
                  input[15:0]      programCounter, instructionMemory, 
                  output reg[15:0] bufferIFID_pc, bufferIFID_instMem);

reg[15:0] s_programCounter, s_instructionMemory;

always@(posedge clock or negedge reset)
begin
   if (!reset)
      begin
         s_programCounter    <= 16'h0000;
         s_instructionMemory <= 16'h0000;
      end
   else if (stall)
      begin $display("stall");
         s_programCounter    <= s_programCounter;
         s_instructionMemory <= s_instructionMemory;
      end
   else if (flush)
      begin
         s_programCounter    <= 0;
         s_instructionMemory <= 0;
      end
   else
      begin
         s_programCounter    <= programCounter;
         s_instructionMemory <= instructionMemory;
      end
end

always@(*)
begin
   bufferIFID_pc             <= s_programCounter;
   bufferIFID_instMem        <= s_instructionMemory;
end

endmodule
