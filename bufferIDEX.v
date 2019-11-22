module bufferIDEX(input            clock, reset, flush,
                  input[15:0]      pc, RD1, RD2, RD0, signExtend, 
                  input[3:0]       RR1, RR2, wAddr, opCode, functCode,
                  input            muxEXtop, muxEXbottom, muxWB, 
                                   memRead, memWrite, regWrite, regWrite0,
                  output reg[15:0] bufferIDEX_pc, bufferIDEX_RD1, bufferIDEX_RD2, bufferIDEX_RD0, bufferIDEX_signExtend,
                  output reg[3:0]  bufferIDEX_RR1, bufferIDEX_RR2, bufferIDEX_wAddr, bufferIDEX_opCode, bufferIDEX_functCode,
                  output reg       bufferIDEX_muxEXtop, bufferIDEX_muxEXbottom, bufferIDEX_muxWB, 
                                   bufferIDEX_memRead, bufferIDEX_memWrite, bufferIDEX_regWrite, bufferIDEX_regWrite0);

reg[15:0] s_pc, s_RD1, s_RD2, s_RD0, s_signExtend;
reg[3:0]  s_RR1, s_RR2, s_wAddr, s_opCode, s_functCode;
reg       s_muxEXtop, s_muxEXbottom, s_muxWB, 
          s_memRead, s_memWrite, s_regWrite, s_regWrite0;

always@(posedge clock or negedge reset)
begin
   if (!reset)
      begin
// WB
         s_wAddr          <= 4'h0;
	     s_muxWB          <= 1'b0;
         s_regWrite       <= 1'b0;
         s_regWrite0      <= 1'b0;

// MEM
         s_memRead        <= 1'b0;
         s_memWrite       <= 1'b0;

// EX
         s_pc             <= 4'h0;
         s_opCode         <= 4'h0;
         s_functCode      <= 4'h0;
	     s_muxEXtop       <= 1'b0;
         s_muxEXbottom    <= 1'b0;

// BUFFER
         s_RD1            <= 16'h0000;
         s_RD2            <= 16'h0000;
         s_RD0            <= 16'h0000;
         s_signExtend     <= 16'h0000;

// FORWARD
         s_RR1            <= 4'h0;
         s_RR2            <= 4'h0;

      end
   else if (flush)
      begin $display("FLUSH");
// WB
         s_wAddr          <= 0;
	     s_muxWB          <= 0;
         s_regWrite       <= 0;
         s_regWrite0      <= 0;

// MEM
         s_memRead        <= 0;
         s_memWrite       <= 0;

// EX
         s_pc             <= 0;
         s_opCode         <= 0;
         s_functCode      <= 0;
	     s_muxEXtop       <= 0;
         s_muxEXbottom    <= 0;

// BUFFER
         s_RD1            <= 0;
         s_RD2            <= 0;
         s_RD0            <= 0;
         s_signExtend     <= 0;

// FORWARD
         s_RR1            <= 0;
         s_RR2            <= 0;
      end
   else
      begin
// WB
         s_wAddr          <= wAddr;
	     s_muxWB          <= muxWB;
         s_regWrite       <= regWrite;
         s_regWrite0      <= regWrite0;

// MEM
         s_memRead        <= memRead;
         s_memWrite       <= memWrite;

// EX
         s_pc             <= pc;
         s_opCode         <= opCode;
         s_functCode      <= functCode;
	     s_muxEXtop       <= muxEXtop;
         s_muxEXbottom    <= muxEXbottom;

// BUFFER
         s_RD1            <= RD1;
         s_RD2            <= RD2;
         s_RD0            <= RD0;
         s_signExtend     <= signExtend;

// FORWARD
         s_RR1            <= RR1;
         s_RR2            <= RR2;

      end
end

always@(*)
begin
// WB
   bufferIDEX_wAddr       <= s_wAddr;
   bufferIDEX_muxWB       <= s_muxWB;
   bufferIDEX_regWrite    <= s_regWrite;
   bufferIDEX_regWrite0   <= s_regWrite0;

// MEM
   bufferIDEX_memRead     <= s_memRead;
   bufferIDEX_memWrite    <= s_memWrite;

// EX
   bufferIDEX_pc          <= s_pc;
   bufferIDEX_opCode      <= s_opCode;
   bufferIDEX_functCode   <= s_functCode;
   bufferIDEX_muxEXtop    <= s_muxEXtop;
   bufferIDEX_muxEXbottom <= s_muxEXbottom;

// BUFFER
   bufferIDEX_RD1         <= s_RD1;
   bufferIDEX_RD2         <= s_RD2;
   bufferIDEX_RD0         <= s_RD0;
   bufferIDEX_signExtend  <= s_signExtend; 

// FORWARD
   bufferIDEX_RR1         <= s_RR1;
   bufferIDEX_RR2         <= s_RR2;

end

endmodule
