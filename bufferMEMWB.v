module bufferMEMWB(input            clock, reset,
                   input[15:0]      dm, ALU, R0,
                   input[3:0]       RR1, wAddr,
                   input            muxWB, memWrite, regWrite, regWrite0,
                   output reg[15:0] bufferMEMWB_dm, bufferMEMWB_ALU, bufferMEMWB_R0,
                   output reg[3:0]  bufferMEMWB_RR1, bufferMEMWB_wAddr,
                   output reg       bufferMEMWB_muxWB,
                                    bufferMEMWB_regWrite, bufferMEMWB_regWrite0);

reg[15:0] s_dm, s_ALU, s_R0;
reg[3:0]  s_RR1, s_wAddr;
reg       s_muxWB, s_regWrite, s_regWrite0;

always@(posedge clock or negedge reset)
begin
   if (!reset)
      begin
// WB
         s_wAddr         <= 4'h0;
	     s_muxWB         <= 1'b0;
         s_regWrite      <= 1'b0;
         s_regWrite0     <= 1'b0;

// BUFFER
         s_dm            <= 16'h0000;
         s_ALU           <= 16'h0000;
         s_R0            <= 16'h0000;

// FORWARD
         s_RR1           <= 4'h0;

      end
   else
      begin
// WB
         s_wAddr         <= wAddr;
	     s_muxWB         <= muxWB;
         s_regWrite      <= regWrite;
         s_regWrite0     <= regWrite0;

// BUFFER
         s_dm            <= dm;
         s_ALU           <= ALU;
         s_R0            <= R0;

// FORWARD
         s_RR1           <= RR1;

      end
end

always@(*)
begin
// WB
   bufferMEMWB_wAddr     <= s_wAddr;
   bufferMEMWB_muxWB     <= s_muxWB;
   bufferMEMWB_regWrite  <= s_regWrite;
   bufferMEMWB_regWrite0 <= s_regWrite0;

// BUFFER
   bufferMEMWB_dm        <= s_dm;
   bufferMEMWB_ALU       <= s_ALU;
   bufferMEMWB_R0        <= s_R0;

// FORWARD
   bufferMEMWB_RR1       <= s_RR1;

end

endmodule
