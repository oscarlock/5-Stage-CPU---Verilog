module registerFile(input            clock, reset, regWrite, regWrite0,
                    input[3:0]       rAddr1, rAddr2, wAddr, 
                    input[15:0]      wData, wData0, 
                    output reg[15:0] rData1, rData2, rData0, rTest, rTest0,
                    output reg[15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15);

reg[15:0] register[15:0];

always@(posedge clock or negedge reset)
begin
   if (!reset)
      begin
         register[0]        <= 16'h0000;
	     register[1]        <= 16'h0F00;
	     register[2]        <= 16'h0050;
	     register[3]        <= 16'hFF0F;
	     register[4]        <= 16'hF0FF;
	     register[5]        <= 16'h0040;
	     register[6]        <= 16'h0024;
	     register[7]        <= 16'h00FF;
	     register[8]        <= 16'hAAAA;
	     register[9]        <= 16'h0000;
	     register[10]       <= 16'h0000;
	     register[11]       <= 16'h0000;
	     register[12]       <= 16'hFFFF;
	     register[13]       <= 16'h0002;
	     register[14]       <= 16'h0000;
	     register[15]       <= 16'h0000;
      end
   else if (regWrite == clock || regWrite0 == clock)
      begin
         if (regWrite)
            register[wAddr] <= wData; 
         if (regWrite0)
            register[0]     <= wData0;
      end
end

always@(*)
begin
   rData1 <= register[rAddr1];
   rData2 <= register[rAddr2];
   rData0 <= register[0];

// TEST
   rTest  <= register[8];
   rTest0 <= register[0];
   r0 <= register[0];
   r1 <= register[1];
   r2 <= register[2];
   r3 <= register[3];
   r4 <= register[4];
   r5 <= register[5];
   r6 <= register[6];
   r7 <= register[7];
   r8 <= register[8];
   r9 <= register[9];
   r10 <= register[10];
   r11 <= register[11];
   r12 <= register[12];
   r13 <= register[13];
   r14 <= register[14];
   r15 <= register[15];


end

endmodule
