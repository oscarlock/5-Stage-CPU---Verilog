// IF
`include "adder.v"
`include "mux2to1.v"
`include "programCounter.v"
`include "instructionMemory.v"

`include "bufferIFID.v"

// ID
`include "hazardUnit.v"
`include "controlUnit.v"
`include "registerFile.v"
`include "comparator.v"
`include "signExtend.v"
`include "shiftLeft1.v"

`include "bufferIDEX.v"

// EX
`include "mux5to1.v"
`include "ALU.v"
`include "forwardUnit.v"

`include "bufferEXMEM.v"

// MEM
`include "dataMemory.v"

`include "bufferMEMWB.v"

module top;

reg CLOCK, RESET;

wire[15:0] pc_out, adderIF_out, muxIF_out, im_out;

reg CLEAR;

// IF/ID
wire[15:0] bIFID_pc, bIFID_instMem;
// ****************************************************************************************************************************************************

// ****************************************************************************************************************************************************

// CONTROL

wire      pcWrite, hu_bIFID, hu_bIDEX;
wire      hu_pc, hu_halt;

wire[3:0] cu_opCode, cu_functCode;
wire[1:0] cu_signExtend;
wire      cu_muxIF, cu_muxEXtop, cu_muxEXbottom, cu_muxWB, 
          cu_memRead, cu_memWrite, cu_regWrite, cu_regWrite0,
          cu_comp;

wire[15:0] RD1out, RD2out, RD0out, test, test0,
           r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15; 

wire       comp_out;//wire[1:0]  comp_out;

wire[15:0] se_signExtend, sl1_shiftLeft1, adderID_out;

// ****************************************************************************************************************************************************

// ID/EX
wire[15:0] bIDEX_pc, bIDEX_RD1, bIDEX_RD2, bIDEX_RD0, bIDEX_signExtend;
wire[3:0]  bIDEX_RR1, bIDEX_RR2, bIDEX_wAddr, bIDEX_opCode, bIDEX_functCode;
wire       bIDEX_muxEXtop, bIDEX_muxEXbottom, bIDEX_muxWB, 
           bIDEX_memRead, bIDEX_memWrite, bIDEX_regWrite, bIDEX_regWrite0;

// ****************************************************************************************************************************************************

// Execute
wire[15:0] muxEXtop_out, muxEXbottom_out;

wire[15:0] ALUout, R0out;
wire overFlow;

wire[1:0]  fu_muxEXtop, fu_muxEXbottom;
wire       fu_muxMEM;

// ****************************************************************************************************************************************************

// EX/MEM
wire[15:0] bEXMEM_ALU, bEXMEM_RD1, bEXMEM_R0;
wire[3:0]  bEXMEM_RR1, bEXMEM_wAddr;
wire       bEXMEM_muxWB, 
           bEXMEM_memRead, bEXMEM_memWrite, bEXMEM_regWrite, bEXMEM_regWrite0;

// ****************************************************************************************************************************************************

// Memory
wire[15:0] dm_readData;
wire[15:0] testDM; // TEST 

// ****************************************************************************************************************************************************

// MEM/WB
wire[15:0] bMEMWB_ALU, bMEMWB_R0, bMEMWB_dm,
           muxMEM_out;
wire[3:0]  bMEMWB_RR1, bMEMWB_wAddr;
wire       bMEMWB_muxWB,
           bMEMWB_regWrite, bMEMWB_regWrite0;

// ****************************************************************************************************************************************************

// Writeback
wire[15:0] muxWB_out;

// ****************************************************************************************************************************************************

// ****************************************************************************************************************************************************

// INSTRUCTION FETCH


adder adderIF(.in1(pc_out), .in2(16'h0002),
              .out(adderIF_out));

mux2to1 muxIF(.select(comp_out), //cu_muxIF),
              .in0(adderIF_out), .in1(adderID_out),
              .out(muxIF_out));

programCounter pc(.clock(CLOCK), .reset(RESET), .pcWrite(hu_pc), .halt(hu_halt),
                  .in(muxIF_out), 
                  .out(pc_out));

instructionMemory im(.clock(CLOCK), .reset(RESET), 
                     .programCounter(pc_out), 
                     .readRegister(im_out));

// ********************************************************************** IF/ID  **********************************************************************

bufferIFID bIFID(.clock(CLOCK), .reset(RESET), .stall(hu_bIFID), .flush(comp_out),
                 .programCounter(pc_out), .instructionMemory(im_out), 
                 .bufferIFID_pc(bIFID_pc), .bufferIFID_instMem(bIFID_instMem));

// ****************************************************************************************************************************************************

// INSTRUCTION DECODE

hazardUnit hu(.halt(bIFID_instMem[15:12]), 
              .bufferIFID_RR1(bIFID_instMem[11:8]), .bufferIFID_RR2(bIFID_instMem[7:4]), .bufferIDEX_RR1(bIDEX_RR1), .bufferIDEX_memRead(bIDEX_memRead),
              .pc_pc(hu_pc), .pc_halt(hu_halt), .bIFID_stall(hu_bIFID), .bIDEX_flush(hu_bIDEX));

controlUnit cu(.oppcode(bIFID_instMem[15:12]), .functionCode(bIFID_instMem[3:0]), 
               .functCode(cu_functCode),
               .signExtend(cu_signExtend),
               .muxIF(cu_muxIF), .muxEXtop(cu_muxEXtop), .muxEXbottom(cu_muxEXbottom), .muxWB(cu_muxWB), 
               .memRead(cu_memRead), .memWrite(cu_memWrite), .regWrite(cu_regWrite), .regWrite0(cu_regWrite0),
               .comparator(cu_comp));

registerFile rf(.clock(CLOCK), .reset(RESET), .regWrite(bMEMWB_regWrite), .regWrite0(bMEMWB_regWrite0),
                .rAddr1(bIFID_instMem[11:8]), .rAddr2(bIFID_instMem[7:4]), 
                .wAddr(bMEMWB_wAddr), .wData(muxWB_out), .wData0(bMEMWB_R0), 
                .rData1(RD1out), .rData2(RD2out), .rData0(RD0out), .rTest(test), .rTest0(test0),
                .r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6), .r7(r7), .r8(r8), .r9(r9), .r10(r10), .r11(r11), .r12(r12), .r13(r13),
                .r14(r14), .r15(r15));

comparator comp(.control(cu_comp), 
                .opCode(bIFID_instMem[15:12]),
                .in1(RD1out), .in2(RD0out),
                .out(comp_out));

signExtend se(.select(cu_signExtend), .in(bIFID_instMem), .out(se_signExtend));

shiftLeft1 sl1(.in(se_signExtend),
               .out(sl1_shiftLeft1));

adder adderID(.in1(sl1_shiftLeft1), .in2(bIFID_pc),
              .out(adderID_out));

// ********************************************************************** ID/EX  **********************************************************************

bufferIDEX bIDEX(.clock(CLOCK), .reset(RESET), .flush(hu_bIDEX), // .clear(comp_out),
                 .pc(bIFID_pc), .RD1(RD1out), .RD2(RD2out), .RD0(RD0out), .signExtend(se_signExtend), 
                 .RR1(bIFID_instMem[11:8]), .RR2(bIFID_instMem[7:4]), .wAddr(bIFID_instMem[11:8]), .opCode(cu_opCode), .functCode(cu_functCode),
                 .muxEXtop(cu_muxEXtop), .muxEXbottom(cu_muxEXbottom), .muxWB(cu_muxWB), 
                 .memRead(cu_memRead), .memWrite(cu_memWrite),  .regWrite(cu_regWrite), .regWrite0(cu_regWrite0),
                 .bufferIDEX_pc(bIDEX_pc),
                 .bufferIDEX_RD1(bIDEX_RD1), .bufferIDEX_RD2(bIDEX_RD2), .bufferIDEX_RD0(bIDEX_RD0), .bufferIDEX_signExtend(bIDEX_signExtend), 
                 .bufferIDEX_RR1(bIDEX_RR1), .bufferIDEX_RR2(bIDEX_RR2), .bufferIDEX_wAddr(bIDEX_wAddr), 
                 .bufferIDEX_opCode(bIDEX_opCode), .bufferIDEX_functCode(bIDEX_functCode),
                 .bufferIDEX_muxEXtop(bIDEX_muxEXtop), .bufferIDEX_muxEXbottom(bIDEX_muxEXbottom), .bufferIDEX_muxWB(bIDEX_muxWB), 
		 .bufferIDEX_memRead(bIDEX_memRead), .bufferIDEX_memWrite(bIDEX_memWrite), 
                 .bufferIDEX_regWrite(bIDEX_regWrite), .bufferIDEX_regWrite0(bIDEX_regWrite0));

// ****************************************************************************************************************************************************

// EXECUTE
/*
mux4to1 muxEXtop(.selectTop(bIDEX_muxEXtop), .selectBottom(fu_muxEXtop),
                 .in0(bIDEX_RD1), .in1(bIDEX_signExtend), .in2(bEXMEM_ALU), .in3(muxWB_out),
                 .out(muxEXtop_out));

mux4to1 muxEXbottom(.selectTop(bIDEX_muxEXbottom), .selectBottom(fu_muxEXbottom),
                    .in0(bIDEX_RD2), .in1(bIDEX_signExtend), .in2(bEXMEM_ALU), .in3(muxWB_out),
                    .out(muxEXbottom_out));
*/

mux5to1 muxEXtop(.selectTop(bIDEX_muxEXtop), .selectBottom(fu_muxEXtop),
                 .in0(bIDEX_RD1), .in1(bIDEX_signExtend), .in2(bEXMEM_ALU), .in3(muxWB_out), .in4(bEXMEM_R0),
                 .out(muxEXtop_out));

mux5to1 muxEXbottom(.selectTop(bIDEX_muxEXbottom), .selectBottom(fu_muxEXbottom),
                    .in0(bIDEX_RD2), .in1(bIDEX_signExtend), .in2(bEXMEM_ALU), .in3(muxWB_out), .in4(bEXMEM_R0),
                    .out(muxEXbottom_out));


ALU alu(.functionCode(bIDEX_functCode), .in1(muxEXtop_out), .in2(muxEXbottom_out), 
        .out(ALUout), .R0(R0out));
/*
shiftLeft1 sl1(.in(bIDEX_signExtend),
               .out(sl1_shiftLeft1));

adder adderID(.in1(sl1_shiftLeft1), .in2(bIDEX_pc),
              .out(adderID_out));
*/

forwardUnit fu(.bIDEX_RR1(bIDEX_RR1), .bIDEX_RR2(bIDEX_RR2), .bEXMEM_RR1(bEXMEM_RR1), .bMEMWB_RR1(bMEMWB_RR1),
               .bEXMEM_regWrite(bEXMEM_regWrite), .bEXMEM_memRead(bEXMEM_memRead), .bEXMEM_memWrite(bEXMEM_memWrite), .bMEMWB_regWrite(bMEMWB_regWrite),
               .bEXMEM_regWrite0(bEXMEM_regWrite0),
               .muxEXtop(fu_muxEXtop), .muxEXbottom(fu_muxEXbottom), .muxMEM(fu_muxMEM));

// ********************************************************************** EX/MEM **********************************************************************

bufferEXMEM bEXMEM(.clock(CLOCK), .reset(RESET),
                   .ALU(ALUout), .RD1(bIDEX_RD1), .R0(R0out), 
                   .RR1(bIDEX_RR1), .wAddr(bIDEX_wAddr),
                   .muxWB(bIDEX_muxWB), 
                   .memRead(bIDEX_memRead), .memWrite(bIDEX_memWrite), .regWrite(bIDEX_regWrite), .regWrite0(bIDEX_regWrite0), 
                   .bufferEXMEM_ALU(bEXMEM_ALU), .bufferEXMEM_RD1(bEXMEM_RD1), .bufferEXMEM_R0(bEXMEM_R0),
                   .bufferEXMEM_RR1(bEXMEM_RR1), .bufferEXMEM_wAddr(bEXMEM_wAddr),
                   .bufferEXMEM_muxWB(bEXMEM_muxWB), 
                   .bufferEXMEM_memRead(bEXMEM_memRead), .bufferEXMEM_memWrite(bEXMEM_memWrite), 
                   .bufferEXMEM_regWrite(bEXMEM_regWrite), .bufferEXMEM_regWrite0(bEXMEM_regWrite0));

// ****************************************************************************************************************************************************

// MEMORY

dataMemory dm(.clock(CLOCK), .reset(RESET), . readEnable(bEXMEM_memRead), .writeEnable(bEXMEM_memWrite), 
              .address(bEXMEM_ALU), .writeData(muxMEM_out), 
              .readData(dm_readData), .testDM(testDM));

mux2to1 muxMEM(.select(fu_muxMEM),
               .in0(bEXMEM_RD1), .in1(muxWB_out),
               .out(muxMEM_out));

// ********************************************************************** MEM/WB **********************************************************************

bufferMEMWB bMEMWB(.clock(CLOCK), .reset(RESET),
                   .dm(dm_readData), .ALU(bEXMEM_ALU), .R0(bEXMEM_R0),
                   .RR1(bEXMEM_RR1), .wAddr(bEXMEM_wAddr),
                   .muxWB(bEXMEM_muxWB), .memWrite(bEXMEM_memWrite), .regWrite(bEXMEM_regWrite), .regWrite0(bEXMEM_regWrite0), 
                   .bufferMEMWB_dm(bMEMWB_dm), .bufferMEMWB_ALU(bMEMWB_ALU), .bufferMEMWB_R0(bMEMWB_R0),
                   .bufferMEMWB_RR1(bMEMWB_RR1), .bufferMEMWB_wAddr(bMEMWB_wAddr),
                   .bufferMEMWB_muxWB(bMEMWB_muxWB),
                   .bufferMEMWB_regWrite(bMEMWB_regWrite), .bufferMEMWB_regWrite0(bMEMWB_regWrite0));

// ****************************************************************************************************************************************************

// WRITEBACK

mux2to1 muxWB(.select(bMEMWB_muxWB),
              .in0(bMEMWB_dm), .in1(bMEMWB_ALU),
              .out(muxWB_out));

// ****************************************************************************************************************************************************

initial
   $vcdpluson;

initial
begin
   $display("TIME\t CLOCK\t RESET\t PC\t R0\t R1\t R2\t R3\t R4\t R5\t R6\t R7\t R8\t R9\t R10\t R11\t R12\t R13\t R14\t R15\t");
   $monitor("%4d\t %b\t %b\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t", $time, CLOCK, RESET, pc_out,
             r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15);
//   $display("time\t CLOCK\t RESET\t pc\t im\t IFID\t IDEX\t IDEX\t IDEX \t  sign\t muxEX\t muxEX\t ALU\t R0\t RD0\t EXMEM\t EXMEM\t dm\t muxWB\t  memR\t IFID\t test\t testDM\t SE\t SL1\t Comp\t");
//   $display("   \t     \t     \t   \t   \t   IM\t  RD1\t  RD2\t fCode\t   Ext\t   top\t bottm\t    \t   \t    \t    RR1\t   ALU\t   \t      \t     \t");
//   $monitor("%4d\t %b\t %b\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %b\t", 
//             $time, CLOCK, RESET, 
//             pc_out, im_out, bIFID_instMem, 
//             bIDEX_RD1, bIDEX_RD2, bIDEX_functCode, 
//             se_signExtend, muxEXtop_out, muxEXbottom_out, ALUout, R0out, RD0out, bEXMEM_RR1, bEXMEM_ALU,
//             dm_readData, muxWB_out, cu_memRead, bIFID_pc, test, testDM, se_signExtend, sl1_shiftLeft1, /* adderID_out,*/ comp_out);


//  $display("time\t clock\t reset\t pc\t im\t IFID\t IFID\t IFID\t IDEX\t IDEX\t EXMEM\t MEMWB\t");
//  $display("\t \t \t \t \t im\t RR1\t RR2\t RR1\t RR2\t RR1\t RR1\t");
//  $monitor("%4d\t %b\t %b\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t %h\t", $time, CLOCK, RESET, pc_out, im_out, bIFID_instMem, bIFID_instMem[11:8], bIFID_instMem[7:4], bIDEX_RR1, bIDEX_RR2, bEXMEM_RR1, bMEMWB_RR1);
end

initial
begin
   CLOCK = 0;
   RESET = 0;

   #5 RESET = 1;
end

initial
begin
   forever #10 CLOCK = ~CLOCK;
end

initial
begin
   #610 $finish;
//   #130 $finish;
end

endmodule
