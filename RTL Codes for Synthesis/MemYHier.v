
//`define testing_only 

module MemYHier ( memY_dataout, common_address, B, A, clock, notWrtEnbY, WrtEnbY );
  output [63:0] memY_dataout;
  wire [31:0] a;
  wire [31:0] b;
  input [7:0] common_address;
  input [31:0] B;
  input [31:0] A;
  input clock, notWrtEnbY, WrtEnbY;


  wire [7:0] common_address_int;
  wire [31:0] A_int;
  wire [31:0] B_int;
  wire clock_int, notWrtEnbY_int, WrtEnbY_int;

  NBUFFX4_HVT clock_cell (.A(clock), .Y(clock_int) );
  NBUFFX4_HVT notWrtEnbY_cell (.A(notWrtEnbY), .Y(notWrtEnbY_int) );
  NBUFFX4_HVT WrtEnbY_cell (.A(WrtEnbY), .Y(WrtEnbY_int) );

  NBUFFX4_HVT common_address0  (.A(common_address[0]), .Y(common_address_int[0]) );
  NBUFFX4_HVT common_address1  (.A(common_address[1]), .Y(common_address_int[1]) );
  NBUFFX4_HVT common_address2  (.A(common_address[2]), .Y(common_address_int[2]) );
  NBUFFX4_HVT common_address3  (.A(common_address[3]), .Y(common_address_int[3]) );
  NBUFFX4_HVT common_address4  (.A(common_address[4]), .Y(common_address_int[4]) );
  NBUFFX4_HVT common_address5  (.A(common_address[5]), .Y(common_address_int[5]) );
  NBUFFX4_HVT common_address6  (.A(common_address[6]), .Y(common_address_int[6]) );
  NBUFFX4_HVT common_address7  (.A(common_address[7]), .Y(common_address_int[7]) );

  NBUFFX4_HVT A0  (.A(A[0]), .Y(A_int[0]) );
  NBUFFX4_HVT A1  (.A(A[1]), .Y(A_int[1]) );
  NBUFFX4_HVT A2  (.A(A[2]), .Y(A_int[2]) );
  NBUFFX4_HVT A3  (.A(A[3]), .Y(A_int[3]) );
  NBUFFX4_HVT A4  (.A(A[4]), .Y(A_int[4]) );
  NBUFFX4_HVT A5  (.A(A[5]), .Y(A_int[5]) );
  NBUFFX4_HVT A6  (.A(A[6]), .Y(A_int[6]) );
  NBUFFX4_HVT A7  (.A(A[7]), .Y(A_int[7]) );
  NBUFFX4_HVT A8  (.A(A[8]), .Y(A_int[8]) );
  NBUFFX4_HVT A9  (.A(A[9]), .Y(A_int[9]) );
  NBUFFX4_HVT A10  (.A(A[10]), .Y(A_int[10]) );
  NBUFFX4_HVT A11  (.A(A[11]), .Y(A_int[11]) );
  NBUFFX4_HVT A12  (.A(A[12]), .Y(A_int[12]) );
  NBUFFX4_HVT A13  (.A(A[13]), .Y(A_int[13]) );
  NBUFFX4_HVT A14  (.A(A[14]), .Y(A_int[14]) );
  NBUFFX4_HVT A15  (.A(A[15]), .Y(A_int[15]) );
  NBUFFX4_HVT A16  (.A(A[16]), .Y(A_int[16]) );
  NBUFFX4_HVT A17  (.A(A[17]), .Y(A_int[17]) );
  NBUFFX4_HVT A18  (.A(A[18]), .Y(A_int[18]) );
  NBUFFX4_HVT A19  (.A(A[19]), .Y(A_int[19]) );
  NBUFFX4_HVT A20  (.A(A[20]), .Y(A_int[20]) );
  NBUFFX4_HVT A21  (.A(A[21]), .Y(A_int[21]) );
  NBUFFX4_HVT A22  (.A(A[22]), .Y(A_int[22]) );
  NBUFFX4_HVT A23  (.A(A[23]), .Y(A_int[23]) );
  NBUFFX4_HVT A24  (.A(A[24]), .Y(A_int[24]) );
  NBUFFX4_HVT A25  (.A(A[25]), .Y(A_int[25]) );
  NBUFFX4_HVT A26  (.A(A[26]), .Y(A_int[26]) );
  NBUFFX4_HVT A27  (.A(A[27]), .Y(A_int[27]) );
  NBUFFX4_HVT A28  (.A(A[28]), .Y(A_int[28]) );
  NBUFFX4_HVT A29  (.A(A[29]), .Y(A_int[29]) );
  NBUFFX4_HVT A30  (.A(A[30]), .Y(A_int[30]) );
  NBUFFX4_HVT A31  (.A(A[31]), .Y(A_int[31]) );

  NBUFFX4_HVT B0  (.A(B[0]), .Y(B_int[0]) );
  NBUFFX4_HVT B1  (.A(B[1]), .Y(B_int[1]) );
  NBUFFX4_HVT B2  (.A(B[2]), .Y(B_int[2]) );
  NBUFFX4_HVT B3  (.A(B[3]), .Y(B_int[3]) );
  NBUFFX4_HVT B4  (.A(B[4]), .Y(B_int[4]) );
  NBUFFX4_HVT B5  (.A(B[5]), .Y(B_int[5]) );
  NBUFFX4_HVT B6  (.A(B[6]), .Y(B_int[6]) );
  NBUFFX4_HVT B7  (.A(B[7]), .Y(B_int[7]) );
  NBUFFX4_HVT B8  (.A(B[8]), .Y(B_int[8]) );
  NBUFFX4_HVT B9  (.A(B[9]), .Y(B_int[9]) );
  NBUFFX4_HVT B10  (.A(B[10]), .Y(B_int[10]) );
  NBUFFX4_HVT B11  (.A(B[11]), .Y(B_int[11]) );
  NBUFFX4_HVT B12  (.A(B[12]), .Y(B_int[12]) );
  NBUFFX4_HVT B13  (.A(B[13]), .Y(B_int[13]) );
  NBUFFX4_HVT B14  (.A(B[14]), .Y(B_int[14]) );
  NBUFFX4_HVT B15  (.A(B[15]), .Y(B_int[15]) );
  NBUFFX4_HVT B16  (.A(B[16]), .Y(B_int[16]) );
  NBUFFX4_HVT B17  (.A(B[17]), .Y(B_int[17]) );
  NBUFFX4_HVT B18  (.A(B[18]), .Y(B_int[18]) );
  NBUFFX4_HVT B19  (.A(B[19]), .Y(B_int[19]) );
  NBUFFX4_HVT B20  (.A(B[20]), .Y(B_int[20]) );
  NBUFFX4_HVT B21  (.A(B[21]), .Y(B_int[21]) );
  NBUFFX4_HVT B22  (.A(B[22]), .Y(B_int[22]) );
  NBUFFX4_HVT B23  (.A(B[23]), .Y(B_int[23]) );
  NBUFFX4_HVT B24  (.A(B[24]), .Y(B_int[24]) );
  NBUFFX4_HVT B25  (.A(B[25]), .Y(B_int[25]) );
  NBUFFX4_HVT B26  (.A(B[26]), .Y(B_int[26]) );
  NBUFFX4_HVT B27  (.A(B[27]), .Y(B_int[27]) );
  NBUFFX4_HVT B28  (.A(B[28]), .Y(B_int[28]) );
  NBUFFX4_HVT B29  (.A(B[29]), .Y(B_int[29]) );
  NBUFFX4_HVT B30  (.A(B[30]), .Y(B_int[30]) );
  NBUFFX4_HVT B31  (.A(B[31]), .Y(B_int[31]) );

`ifdef testing_only
  always @(  posedge clock) begin
//$display ($time,,, "  MEMY : read=%b,write=%b, Address=%h, data_in=%h,data_out=%h",notWrtEnbY,WrtEnbY,common_address,{A,B},memY_dataout);
      if (WrtEnbY== 1'b1) begin
//$display ("                      ",$time ,,,"     Wrote MEMY at %h , the data %h", common_address,{A,B});
      end
      if (notWrtEnbY== 1'b1) begin
//$display ("                      ",$time ,,,"        Read MEMY at %h , the data %h", common_address,memY_dataout);
      end
   end
`endif

assign memY_dataout = {a,b};

SRAMLP1RW64x32 MemXa (
         .A(common_address_int[5:0]),
         .I(A),
         .WEB(WrtEnbY_int),
         .CSB(common_address_int[6]),
         .OEB(common_address_int[7]),
         .CE(clock_int),
         .O(a)) ;

SRAMLP1RW64x32 MemXb (
         .A(common_address_int[5:0]),
         .I(B),
         .WEB(WrtEnbY_int),
         .CSB(common_address_int[6]),
         .OEB(common_address_int[7]),
         .CE(clock_int),
         .O(b)) ;
endmodule
