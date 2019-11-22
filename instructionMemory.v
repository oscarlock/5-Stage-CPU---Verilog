module instructionMemory(input            clock, reset, 
                         input[15:0]      programCounter, 
                         output reg[15:0] readRegister);

reg [15:0] instruction [48:0];

always@(posedge clock or negedge reset)
begin
   if(!reset)
      begin
         instruction[00] <= 16'b0000000100101111; //signed addition		    0x012f 
         instruction[02] <= 16'b0000000100101110; //signed subtraction      0x012e
         instruction[04] <= 16'b0000001101001100; //bitwise or			    0x034c
         instruction[06] <= 16'b0000001100101101; //bitwise and			    0x032d
         instruction[08] <= 16'b0000010101100001; //signed multiplication	0x0561
         instruction[10] <= 16'b0000000101010010; //signed division		    0x0152
         instruction[12] <= 16'b0000000000001110; //signed subtraction		0x001c
         instruction[14] <= 16'b0000010000111010; //logical shift left		0x044a
         instruction[16] <= 16'b0000010000101011; //logical shift right		0x0429
         instruction[18] <= 16'b0000011000111000; //rotate left			    0x0628
         instruction[20] <= 16'b0000011000101001; //rotate right			0x0629
         instruction[22] <= 16'b0110011100000100; //branch equals		    0x6704
         instruction[24] <= 16'b0000101100011111; //signed addition		    0x0B1F
         instruction[26] <= 16'b0100011100000101; //branch on less than	    0x4705
         instruction[28] <= 16'b0000101100101111; //signed addition		    0x0b2f
         instruction[30] <= 16'b0101011100000010; //branch on greater than	0x5702
         instruction[32] <= 16'b0000001000011111; //signed addition		    0x021f
         instruction[34] <= 16'b0000001000011111; //signed addition		    0x021f
         instruction[36] <= 16'b1000100010010000; //load word			    0x8890
         instruction[38] <= 16'b0000100010001111; //signed addition		    0x088f
         instruction[40] <= 16'b1011100010010010; //store word			    0xb892
         instruction[42] <= 16'b1000101010010010; //load word			    0x8a92
         instruction[44] <= 16'b0000110011001111; //signed addition		    0x0ccf
         instruction[46] <= 16'b0000110111011110; //signed subtraction		0x0ddd
         instruction[48] <= 16'b0000110011011111; //signed addition 		0x0cdf
		 instruction[50] <= 0;
      end
end
	
always@(*)
begin
	readRegister = instruction[programCounter];
end

endmodule
