module controlUnit(input[3:0]      oppcode, functionCode, 
                   output reg[3:0] functCode,
                   output reg[1:0] signExtend,
                   output reg      muxIF, muxEXtop, muxEXbottom, muxWB, 
                                   memRead, memWrite, regWrite, regWrite0,
                                   comparator);

always@(*) 
begin
   comparator = 1'b0;
   if (oppcode == 4'b0000) 
      begin
         if (functionCode == 4'b1111)      // signed addition
            begin
               functCode   = 4'b1111;
               signExtend  = 2'bxx;
               muxIF       = 1'b0;
               muxEXtop    = 1'b0;
               muxEXbottom = 1'b0;
	           muxWB       = 1'b1;
               memRead     = 1'bx;
               memWrite    = 1'bx;
               regWrite    = 1'b1;
               regWrite0   = 1'b0;
            end
         else if (functionCode == 4'b1110) // signed subtraction
            begin
               functCode   = 4'b1110;
               signExtend  = 2'bxx;
               muxIF       = 1'b0;
	           muxEXtop    = 1'b0;
               muxEXbottom = 1'b0;
	           muxWB       = 1'b1;
               memRead     = 1'bx;
               memWrite    = 1'bx;
               regWrite    = 1'b1;
               regWrite0   = 1'b0;
            end
         else if (functionCode == 4'b1101) // bitwise and
            begin
               functCode   = 4'b1101;
               signExtend  = 2'bxx;
               muxIF       = 1'b0;
	           muxEXtop    = 1'b0;
	           muxEXbottom = 1'b0;
	           muxWB       = 1'b1;
               memRead     = 1'bx;
               memWrite    = 1'bx;
	           regWrite    = 1'b1;
	           regWrite0   = 1'b0;
            end
         else if (functionCode == 4'b1100) // bitwise or
            begin
	           functCode   = 4'b1100;
	           signExtend  = 2'bxx;
               muxIF       = 1'b0;
	           muxEXtop    = 1'b0;
	           muxEXbottom = 1'b0;
	           muxWB       = 1'b1;
               memRead     = 1'bx;
               memWrite    = 1'bx;
	           regWrite	   = 1'b1;
	           regWrite0   = 1'b0;
	        end
         else if (functionCode == 4'b0001) // signed multiplication
            begin
               functCode   = 4'b0001;
	           signExtend  = 2'bxx;
               muxIF       = 1'b0;
	           muxEXtop    = 1'b0;
	           muxEXbottom = 1'b0;
	           muxWB       = 1'b1;
               memRead     = 1'bx;
               memWrite    = 1'bx;
	           regWrite	   = 1'b1;
	           regWrite0   = 1'b1;
	        end
         else if (functionCode == 4'b0010) // signed division
            begin
	           functCode   = 4'b0010;
	           signExtend  = 2'bxx;
               muxIF       = 1'b0;
	           muxEXtop    = 1'b0;
	           muxEXbottom = 1'b0;
	           muxWB       = 1'b1;
               memRead     = 1'bx;
               memWrite    = 1'bx;
	           regWrite	   = 1'b1;
	           regWrite0   = 1'b1;
	        end
         else if (functionCode == 4'b1010) // logical shift left
            begin
   	           functCode   = 4'b1010;
	           signExtend  = 2'b00;
               muxIF       = 1'b0;
	           muxEXtop    = 1'b0;
	           muxEXbottom = 1'b1;
	           muxWB       = 1'b1;
               memRead     = 1'bx;
               memWrite    = 1'bx;
	           regWrite	   = 1'b1;
	           regWrite0   = 1'b0;
            end
         else if (functionCode == 4'b1011) // logical shift right
            begin
	           functCode   = 4'b1011;
	           signExtend  = 2'b00;
               muxIF       = 1'b0;
	           muxEXtop    = 1'b0;
	           muxEXbottom = 1'b1;
	           muxWB       = 1'b1;
               memRead     = 1'bx;
               memWrite    = 1'bx;
	           regWrite	   = 1'b1;
	           regWrite0   = 1'b0;
	    end
         else if (functionCode == 4'b1000) // rotate left
            begin
  	           functCode   = 4'b1000;
	           signExtend  = 2'b00;
               muxIF       = 1'b0;
	           muxEXtop    = 1'b0;
	           muxEXbottom = 1'b1;
	           muxWB       = 1'b1;
               memRead     = 1'bx;
               memWrite    = 1'bx;
	           regWrite	   = 1'b1;
	           regWrite0   = 1'b0;
	        end
         else if (functionCode == 4'b1001) // rotate right
            begin
               functCode   = 4'b1001;
	           signExtend  = 2'b00;
               muxIF       = 1'b0;
	           muxEXtop    = 1'b0;
	           muxEXbottom = 1'b1;
	           muxWB       = 1'b1;
               memRead     = 1'bx;
               memWrite    = 1'bx;
	           regWrite	   = 1'b1;
	           regWrite0   = 1'b0;
	    end
//         else
//            $display("unknown functCode");
      end
   else if (oppcode == 4'b1000)            // load
      begin
         functCode	       = 4'b1111;
	     signExtend	       = 2'b01;
         muxIF             = 1'b0;
	     muxEXtop          = 1'b1;
	     muxEXbottom       = 1'b0;
	     muxWB             = 1'b0;
         memRead           = 1'b1;
	     memWrite          = 1'bx;
	     regWrite          = 1'b1;
	     regWrite0         = 1'b0;
      end
   else if (oppcode == 4'b1011)            // store
      begin
         functCode	       = 4'b1111;
	     signExtend	       = 2'b01;
         muxIF             = 1'b0;
	     muxEXtop          = 1'b1;
	     muxEXbottom	   = 1'b0;
	     muxWB             = 1'b0;
         memRead           = 1'bx;
	     memWrite          = 1'b1;
	     regWrite          = 1'b0;
	     regWrite0         = 1'b0;
      end
   else if ((oppcode == 4'b0100) || (oppcode == 4'b0101) || (oppcode == 4'b0110))           // branch
      begin
         signExtend        = 2'b10;
         comparator        = 1'b1;
      end
   else if (oppcode == 4'b1100)            // jump
      begin
         functCode	       = 4'b1111;
	     signExtend	       = 2'b11;
         muxIF             = 1'b1;
         muxEXtop          = 1'bx;
	     muxEXbottom	   = 1'bx;
         muxWB             = 1'bx;
         memRead           = 1'bx;
         memWrite          = 1'bx;
         regWrite          = 1'bx;
         regWrite0         = 1'bx;
      end
   else if (oppcode == 4'b1111)            // halt
      begin
         functCode	       = 4'b1111;
	     signExtend	       = 2'b11;
         muxIF             = 1'bx;
         muxEXtop          = 1'bx;
	     muxEXbottom	   = 1'bx;
         muxWB             = 1'bx;
         memRead           = 1'bx;
         memWrite          = 1'bx;
	     regWrite          = 1'bx;
	     regWrite0         = 1'bx;
      end
   else
      $display("unknown opCode");
end

endmodule
