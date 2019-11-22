module ALU(input[3:0]         functionCode, 
           input signed[15:0] in1, in2,
           output reg[15:0]   out, R0);
 
reg [15:0] overFlow;
reg [15:0] temp, temp2;

always@(*) 
begin
   R0 = 16'hxxxx;

   if (functionCode == 4'b1111)			    //signed addition
      begin
         out = in1 + in2;
      end
   else if (functionCode == 4'b1110)		//signed subtraction
      begin
         out = in1 - in2;
      end
   else if (functionCode == 4'b1101)		//bitwise and
      begin
         out = in1 & in2;
      end
   else if (functionCode == 4'b1100) 		//bitwise or
      begin
         out = in1 | in2;
      end
   else if (functionCode == 4'b0001) 		//signed multiplication
      begin
         {R0, out} = in1 * in2;
      end
   else if (functionCode == 4'b0010) 		//signed division
      begin
         out = in1 / in2;
         R0  = in1 % in2;
      end
   else if (functionCode == 4'b1010)		//logical shift left
      begin
         out = in1 << in2;
      end
   else if (functionCode == 4'b1011) 		//logical shift right
      begin
         out = in1 >> in2;
      end
   else if (functionCode == 4'b1000)		//rotate left
      begin
         {overFlow, temp} = in1 << in2;
         out = overFlow + temp;
      end
   else if (functionCode == 4'b1001)		//rotate right
      begin
         temp2 = (16 - in2) % 16;
         {overFlow, temp} = in1 << temp2;
         out = overFlow + temp;	
      end
end

endmodule
