`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer: Andres Martinez Paz
// 
// Create Date:    20:04:52 03/31/2017 
// Design Name: CompE 470L Final Project processor
// Module Name:    CPU 
// Project Name: CompE 470L Final Project
// Target Devices: Spartan6 board
// Tool versions: N/A
// Description: Top module of final project for CompE 470L
//
// Dependencies: None
//
// Revision: A
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CPU( input M_CLOCK,
				input PB_CLK,
				input PB_RST,
				input PB_DataMem,
				input PB_InstrMem,
				input [7:0] IO_DSW,
				output [6:0] IO_SSEG,
				output IO_SSEG_DP,
				output [3:0] IO_SSEGD,
				output IO_SSEG_COL,
				output [7:0] IO_LED,
				output [3:0] F_LED);

	assign IO_SSEG_COL = 1'b1;
	assign IO_SSEG_DP = 1'b1;

	wire [15:0] PC;
	wire [15:0] PCPrime;
	wire PCSrc;
	wire [15:0] PCPlus1;
	wire [15:0] PCBranch;
	wire [15:0] Mux0Out;
	wire [15:0] Mux1Out;
	wire [2:0] Mux3Out;
	wire [15:0] Mux6Out;
	wire [15:0] Mux7Out;
	wire [15:0] Instr;
	wire Jump;
	wire [2:0] Op;
	wire [2:0] Funct;
	wire MemToReg;
	wire MemWrite;
	wire Branch;
	wire [2:0] ALUControl;
	wire ALUSrc;
	wire RegDst;
	wire RegWrite;
	wire JAL;
	wire JumpReg;
	wire RegRA;
	wire [2:0] Address1;
	wire [2:0] Address2;
	wire [2:0] Address3;
	wire [15:0] WriteData;
	wire [2:0] ShowAddress;
	wire [15:0] RD1;
	wire [15:0] RD2;
	wire [15:0] ShowData;
	wire [6:0] imm;
	wire [15:0] signImm;
	wire [15:0] ALUSrcA;
	wire [15:0] ALUSrcB;
	wire [15:0] ALUResult;
	wire Zero;
	wire [15:0] ReadData;
	
	wire [3:0] ShowDataAddress;
	wire [15:0] ShowDataMemory;
	
	assign Op = Instr[15:13];
	assign Funct =  Instr[2:0];
	assign Address1 = Instr[12:10];
	assign Address2 = Instr[9:7];
	assign imm = Instr[6:0];
	
	assign ShowAddress = ~IO_DSW[2:0];
	assign ShowDataAddress = ~IO_DSW[3:0]; 
	assign ALUSrcA = RD1;
	assign clk = ~PB_CLK;
	
	//instantiate clock divider to drive memories and registers of CPU (to eliminate PB glitches)
	ClockDivider cd00 (
					.inClk(M_CLOCK),
					.outClk(CPUClk));
	
	//instantiate PCSrc mux (16bit)
	Mux16 mux00 (
					.in0(PCPlus1),
					.in1(PCBranch),
					.sel(PCSrc),
					.out(Mux0Out));
	
	
	//instantiate Jump mux
	Mux16 mux01 (
					.in0(Mux0Out),
					.in1({PCPlus1[15:13], Instr[12:0]}),
					.sel(Jump),
					.out(Mux1Out));
	
	//instantiate JumpReg mux
	Mux16 mux02 (
					.in0(Mux1Out),
					.in1(ALUResult),
					.sel(JumpReg),
					.out(PCPrime));
	
	//instantiate ProgramCounter 
	ProgramCounter pc00 (
					.PCPrime(PCPrime),
					.rst(~PB_RST),
					.clk(CPUClk),
					.write(clk),
					.PC(PC));
					
	//instantiate PCPlus1
	PCPlus1 pcp00 (
					.PC(PC),
					.PCPlus1(PCPlus1));
					
	//instantiate InstructionMemory
	InstructionMem im00 (
					.Address(PC[7:0]),
					.ReadData(Instr));
					
	//instantiate Control Unit
	ControlUnit cu00 (
					.Op(Op),
					.Funct(Funct),
					.MemToReg(MemToReg),
					.MemWrite(MemWrite),
					.Branch(Branch),
					.ALUControl(ALUControl),
					.ALUSrc(ALUSrc),
					.RegDst(RegDst),
					.RegWrite(RegWrite),
					.Jump(Jump),
					.JAL(JAL),
					.JumpReg(JumpReg),
					.RegRA(RegRA));
	
	//instantiate RegisterFile
	RegisterFile rf00 (
					.clk(CPUClk),
					.Address1(Address1),
					.Address2(Address2),
					.Address3(Address3),
					.WE(RegWrite),
					.write(clk),
					.WriteData(WriteData),
					.ShowAddress(ShowAddress),
					.RD1(RD1),
					.RD2(RD2),
					.ShowData(ShowData));

	//instantiate SignExtend
	SignExtend se00 (
					.imm(imm),
					.signImm(signImm));
					
	//instantiate RegDst mux
	Mux3 mux03 (
					.in0(Instr[9:7]),
					.in1(Instr[6:4]),
					.sel(RegDst),
					.out(Mux3Out));
					
	//instantiate RegRA mux
	Mux3 mux04 (
					.in0(Mux3Out),
					.in1(3'b111),  //address for RA register
					.sel(RegRA),
					.out(Address3));
					
	//instantiate ALUSrc mux
	Mux16 mux05 (
					.in0(RD2),
					.in1(signImm),
					.sel(ALUSrc),
					.out(ALUSrcB));
					
	//Instantiate ALU
	ALU alu00 (
					.ALUControl(ALUControl),
					.srcA(ALUSrcA),
					.srcB(ALUSrcB),
					.ALUResult(ALUResult),
					.Zero(Zero));
					
	//Instantiate PCBranch
	PCBranch pcb00 (
					.SignImm(signImm),
					.PCPlus1(PCPlus1),
					.PCBranch(PCBranch));
	
	//instantiate AND gate for PCSrc
	and and00 (PCSrc, Branch, Zero);
	
	//instantiate DataFile
	DataFile df00 (
					.clk(CPUClk),
					.WE(MemWrite),
					.write(clk),
					.Address(ALUResult[3:0]),
					.WriteData(RD2),
					.ShowAddress(ShowDataAddress),
					.ReadData(ReadData),
					.ShowData(ShowDataMemory));
					
	//instantiate MemToReg mux
	Mux16 mux06 (
					.in0(ALUResult),
					.in1(ReadData),
					.sel(MemToReg),
					.out(Mux6Out));
				
	
	//instantiate JAL mux
	Mux16 mux07 (
					.in0(Mux6Out),
					.in1(PCPlus1),
					.sel(JAL),
					.out(WriteData));
	
	
	//instantiate InterfaceModule
	InterfaceModule inm00 (
					.M_CLOCK(M_CLOCK),
					.PB_DataMem(PB_DataMem),
					.PB_InstrMem(PB_InstrMem),
					.Instr(Instr),
					.ProgramCounter(PC),
					.RegValue(ShowData),
					.MemValue(ShowDataMemory),
					.IO_SSEG(IO_SSEG),
					.IO_SSEGD(IO_SSEGD),
					.IO_LED(IO_LED),
					.F_LED(F_LED));
endmodule




