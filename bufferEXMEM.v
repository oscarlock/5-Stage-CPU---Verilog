module bufferEXMEM(input            clock, reset,
                   input[15:0]      ALU, RD1, R0,
                   input[3:0]       RR1, wAddr,
                   input            muxWB, 
                                    memRead, memWrite, regWrite, regWrite0,
                   output reg[15:0] bufferEXMEM_ALU, bufferEXMEM_RD1, bufferEXMEM_R0,
                   output reg[3:0]  bufferEXMEM_RR1, bufferEXMEM_wAddr,
                   output reg       bufferEXMEM_muxWB, 
                                    bufferEXMEM_memRead, bufferEXMEM_memWrite, bufferEXMEM_regWrite, bufferEXMEM_regWrite0);

reg[15:0] s_ALU, s_RD1, s_R0;
reg[3:0]  s_RR1, s_wAddr;
reg       s_muxWB, 
          s_memRead, s_memWrite, s_regWrite, s_regWrite0;

always@(posedge clock or negedge reset)
begin
   if (!reset)
      begin
// WB
         s_wAddr     <= 4'h0;
	     s_muxWB     <= 1'b0;
         s_regWrite  <= 1'b0;
         s_regWrite0 <= 1'b0;

// MEM
         s_RD1       <= 16'h0000;
         s_memRead   <= 1'b0;
	     s_memWrite  <= 1'b0;

// BUFFER
         s_ALU       <= 16'h0000;
         s_R0        <= 16'h0000;

// FORWARD
         s_RR1       <= 4'h0;

      end
   else
      begin
// WB
         s_wAddr     <= wAddr;
	     s_muxWB     <= muxWB;
         s_regWrite  <= regWrite;
         s_regWrite0 <= regWrite0;

// MEM
         s_RD1       <= RD1;
         s_memRead   <= memRead;
	     s_memWrite  <= memWrite;

// BUFFER
         s_ALU       <= ALU;
         s_R0        <= R0;

// FORWARD
         s_RR1       <= RR1;

   end
end

always@(*)
begin
// WB
   bufferEXMEM_wAddr     <= s_wAddr;
   bufferEXMEM_muxWB     <= s_muxWB;
   bufferEXMEM_regWrite  <= s_regWrite;
   bufferEXMEM_regWrite0 <= s_regWrite0;

// MEM
   bufferEXMEM_RD1       <= s_RD1;
   bufferEXMEM_memRead   <= s_memRead;
   bufferEXMEM_memWrite  <= s_memWrite;

// BUFFER
   bufferEXMEM_ALU       <= s_ALU;
   bufferEXMEM_R0        <= s_R0;

// FORWARD
   bufferEXMEM_RR1       <= s_RR1;

end

endmodule
