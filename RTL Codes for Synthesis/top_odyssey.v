// Modified By Godwin on 12/11/2007 
// Added 2 macros
// Added Power Controller
// Added Address Mux
// Added Extra Multiplie



module gprs_top (MemWriteBus, MemWriteValid, MemReadBus, clock, reset,power_ack,MemOverflow,cs);
   input  [31:0]     MemReadBus;             // Memory Read Bus
   output [63:0]     MemWriteBus;            // Memory Write Bus
   output 	     MemWriteValid,power_ack,MemOverflow;      // Memory Write Bus Contains Data
   input             clock,reset;
   input [1:0] cs;
   wire [31:0] y1 , y2, y3 , y4;  
   wire [63:0] a1, a2, a3, a4 ;
   wire  b1, b2, b3, b4, c1 , c2, c3, c4 , d1 , d2 ,d3 , d4 ; 
  
 demux dm1 (MemReadBus, y1 , y2, y3, y4 ,cs); 
 sub_chip sub_chip1 (a1, b1, y1, clock, reset, c1, d1);
 sub_chip sub_chip2 (a2, b2, y2, clock, reset, c2, d2);
 sub_chip sub_chip3 (a3, b3, y3, clock, reset, c3, d3);
 sub_chip sub_chip4 (a4, b4, y4, clock, reset, c4, d4);
 mux dm2 (a1, a2 , a3 , a4, b1, b2, b3, b4, c1 , c2, c3, c4 , d1 , d2 ,d3 , d4 , MemWriteBus, MemWriteValid, power_ack, MemOverflow,cs);
endmodule


module demux (a , y1 , y2, y3, y4, cs);
  input [31:0] a ;
  input [1:0] cs;
  output reg [31:0] y1,y2,y3,y4;
 always @(*)
 begin
  if (cs == 2'b00) 
  begin
	y1=a;
	y2=0;
        y3=0;
        y4=0;
  end
  else if (cs == 2'b01)
  begin
	y1=0;
	y2=a;
        y3=0;
        y4=0;
  end
 else if (cs == 2'b10)
  begin
	y1=0;
	y2=0;
        y3=a;
        y4=0;
  end
 else if (cs == 2'b11)
  begin
	y1=0;
	y2=0;
        y3=0;
        y4=a;
  end
 end 
 endmodule 

module mux (a1, a2, a3, a4, b1, b2, b3, b4, c1 , c2, c3, c4 , d1 , d2 ,d3 , d4 , z1, z2, z3, z4 , cs);
input [63:0] a1, a2, a3, a4;
input b1, b2, b3, b4, c1 , c2, c3, c4 , d1 , d2 ,d3 , d4 ; 
input [1:0] cs ;
output reg [63:0] z1;
output reg z2, z3, z4;
 always @(*)
 begin
  if (cs == 2'b00)
   begin 
	z1 = a1;
        z2 = b1;
        z3 = c1;
        z4 = d1;
   end
  else if (cs == 2'b01)
   begin
        z1 = a2;
        z2 = b2;
        z3 = c2;
        z4 = d2;
   end
  else if (cs == 2'b10)
   begin
        z1 = a3;
        z2 = b3;
        z3 = c3;
        z4 = d3;
   end
  else if (cs == 2'b11)
   begin
	z1 = a4;
        z2 = b4;
        z3 = c4;
        z4 = d4;
   end
  end 
 endmodule 




module sub_chip (MemWriteBus, MemWriteValid, MemReadBus, clock, reset,power_ack,MemOverflow);

   input  [31:0]     MemReadBus;             // Memory Read Bus
   output [63:0]     MemWriteBus;            // Memory Write Bus
   output 	     MemWriteValid,power_ack,MemOverflow;      // Memory Write Bus Contains Data
   input             clock,reset;                  // System Clock

   wire 	     inst_sd;                // switch 
   wire 	     inst_iso;            // iso
   wire 	     inst_reset;
   wire 	     inst_save;
   wire 	     inst_restore;

   wire 	     gprs_sd;                // switch 
   wire 	     gprs_iso;            // iso
   wire 	     gprs_reset;
   wire 	     gprs_save;
   wire 	     gprs_restore;
  
   wire 	     mult_iso;            // iso
   wire 	     mult_sd;                // switch 

   wire 	     memx_iso;            // iso
   wire 	     memx_sd;                // switch 

   wire 	     memy_iso;            // iso
   wire 	     memy_sd;                // switch 
   wire		     power_ack;

   wire genpp_on;
   wire genpp_ack;

   wire   [31:0]     MemReadBus;             // Memory Read Bus
   wire   [63:0]     MemWriteBus;            // Memory Write Bus
   wire 	     MemWriteValid;          // Memory Write Bus Contains Data
   wire   [31:0]     A, B, C;                // Data Buses
   wire   [3:0]      RdAdrA, RdAdrB, RdAdrC; // Read Addresses
   wire   [3:0]      WrtAdrX, WrtAdrY;       // Write Address
   wire              WrtEnbX, WrtEnbY;       // Write Enables
   wire   [31:0]     Product;                // Multiplier output
   wire 	     Ovfl;                   // Multiplier Overflow

   
   wire mult_reset;
//   assign mult_reset = 1'b0;
             
   wire    GENPP_ao = 1'b1;

// Wires added for the new modules /////////////////////////


wire [63:0] memX_dataout,memY_dataout;
wire [7:0] common_address;


//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Instruction Decoder 
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
InstructionDecoder InstDecode(
                    .InstBus(MemReadBus),
                    .RdAdrA(RdAdrA),
                    .RdAdrB(RdAdrB),
                    .RdAdrC(RdAdrC),
                    .WrtAdrX(WrtAdrX),
                    .WrtEnbX(WrtEnbX),
                    .WrtAdrY(WrtAdrY),
                    .WrtEnbY(WrtEnbY),
                    .MemWriteValid(MemWriteValid), 
                    .clock(clock), 
                    .reset(reset|inst_reset));
   
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// 16 General Purpose Registers
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
GeneralPurposeRegisters  GPRs(
                          .A(A),
                          .B(B),
                          .C(C),
                          .RdAdrA(RdAdrA),
                          .RdAdrB(RdAdrB),
                          .RdAdrC(RdAdrC),
                          .WrtAdrX(WrtAdrX),
                          .WrtEnbX(WrtEnbX),
                          .WrtAdrY(WrtAdrY),
                          .WrtEnbY(WrtEnbY),
                          .X(MemReadBus),
                          .Y(Product),
                          .clock(clock), 
                          .reset(reset)); 
   

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// 32 x 32 Signed Multiplier
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Mult_32x32 Multiplier(
            .Ovfl(Ovfl),
	    .Product(Product),
	    .X(A),
	    .Y(B),
	    .Z(C),
	    .clock(clock),
	    .iso(mult_iso), 
	    .reset(reset|mult_reset));


//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Power Controller
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


power_controller PwrCtrl (
	         .clock(clock),
                 .reset(reset),
                 .MemReadBus(MemReadBus[31:24]),
                 .gprs_iso(gprs_iso),
                 .mult_iso(mult_iso),
                 .memx_iso(memx_iso),
                 .memy_iso(memy_iso),
                 .inst_iso(inst_iso),
                 .gprs_save(gprs_save),
                 .gprs_restore(gprs_restore),
                 .gprs_reset(gprs_reset),
                 .inst_save(inst_save),
                 .inst_restore(inst_restore),
                 .inst_reset(inst_reset),
                 .mult_reset(mult_reset),
                 .gprs_sd(gprs_sd),
                 .mult_sd(mult_sd),
                 .inst_sd(inst_sd),
                 .memx_sd(memx_sd),
                 .memy_sd(memy_sd),
                 .power_ack(power_ack));

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Address generator for X and Y RAM's
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

address_gen_add AddressGen (
             .read_addressX(RdAdrA),
             .read_addressY(RdAdrB),
             .write_addressX(WrtAdrX),
             .write_addressY(WrtAdrY),
             .write_X_enable(WrtEnbX), 
             .write_Y_enable(WrtEnbY),
	     .memX_datain(memX_dataout),
	     .memY_datain(memY_dataout),
             .common_address(common_address),
	     .MemWriteBus(MemWriteBus),
             .MemOverflow(MemOverflow));

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Memory X
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


wire notWrtEnbX = ~WrtEnbX;

MemXHier MemXHier ( .memX_dataout(memX_dataout), .common_address(common_address),
	.Product(Product), .C(C), .clock(clock), .notWrtEnbX(notWrtEnbX),
	.WrtEnbX(WrtEnbX) );

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Memory Y
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

wire notWrtEnbY = ~WrtEnbY;

MemYHier MemYHier ( .memY_dataout(memY_dataout), .common_address(common_address),
	.B(B), .A(A), .clock(clock), .notWrtEnbY(notWrtEnbY), .WrtEnbY(WrtEnbY) );

endmodule

