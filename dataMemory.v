module dataMemory(input            clock, reset, 
                                   readEnable, writeEnable, 
                  input[15:0]      address, writeData, 
                  output reg[15:0] readData, testDM);

reg[7:0] memory[65536:0];
integer  i;

always@(posedge clock or negedge reset)
begin
   if (!reset)
      begin
         memory[0] <= 8'h99;
         memory[1] <= 8'hAB;
         for(i = 2; i < 65536; i = i +1)
            begin
               memory[i] <= 8'h00;
            end
      end
   else if (writeEnable == clock)
      begin
         memory[address]   <= writeData[7:0];
         memory[address+1] <= writeData[15:8];
      end
end

always@(*)
begin
   readData = 16'hxxxx;
   testDM = {memory[3], memory[2]};
   if (readEnable == 1'b1)
      begin
         readData = {memory[address+1], memory[address]};
      end
end

endmodule
