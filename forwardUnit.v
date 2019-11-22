module forwardUnit(input[3:0]      bIDEX_RR1, bIDEX_RR2, bEXMEM_RR1, bMEMWB_RR1,
                   input           bEXMEM_regWrite, bEXMEM_memRead, bEXMEM_memWrite, bMEMWB_regWrite,
                                   bEXMEM_regWrite0,
                   output reg[1:0] muxEXtop, muxEXbottom, 
                   output reg      muxMEM);

always@(*)
begin
   muxEXtop    = 2'bxx;
   muxEXbottom = 2'bxx;
   muxMEM      = 1'b0;

   if (bEXMEM_regWrite && (bEXMEM_RR1 != 0) && (bEXMEM_RR1 == bIDEX_RR1))
      begin $display("forward ex");
         muxEXtop    = 2'b00;
      end
   if (bEXMEM_regWrite && (bEXMEM_RR1 != 0) && (bEXMEM_RR1 == bIDEX_RR2))
      begin $display("forward ex");
         muxEXbottom = 2'b00;
      end

   if (bMEMWB_regWrite && (bMEMWB_RR1 != 0) && (bMEMWB_RR1 == bIDEX_RR1))
      begin $display("forward mem");
         muxEXtop    = 2'b01;
      end
   if (bMEMWB_regWrite && (bMEMWB_RR1 != 0) && (bMEMWB_RR1 == bIDEX_RR2))
      begin $display("forward mem");
         muxEXbottom = 2'b01;
      end
   
   if (bEXMEM_regWrite0 && (bIDEX_RR1 == 4'h0))
      begin $display("forward 0");
         muxEXtop = 2'b10;
      end

   if (bEXMEM_regWrite0 && (bIDEX_RR2 == 4'h0))
      begin $display("forward 0");
         muxEXbottom = 2'b10;
      end

   if (bMEMWB_regWrite && bEXMEM_memWrite && (bMEMWB_RR1 != 0) && (bMEMWB_RR1 == bEXMEM_RR1))
      begin $display("forward store");
         muxMEM = 1'b1;
      end
end

endmodule
