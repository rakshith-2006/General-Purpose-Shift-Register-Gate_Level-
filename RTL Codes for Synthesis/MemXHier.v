module MemXHier ( memX_dataout, common_address, Product, C, clock, notWrtEnbX, WrtEnbX );
  output [63:0] memX_dataout;
  wire [31:0] a;
  wire [31:0] b;
  input [7:0] common_address;
  input [31:0] Product;
  input [31:0] C; 
  input clock, notWrtEnbX, WrtEnbX;
	
  wire [7:0] common_address_int;
  wire [31:0] Product_int;
  wire [31:0] C_int;
  wire clock_int, notWrtEnbX_int, WrtEnbX_int;

// Temporary hack to make verification pass
// Add buffers on the input nets of macro
  NBUFFX4_RVT clock_cell (.A(clock), .Y(clock_int) );
  NBUFFX4_RVT notWrtEnbX_cell (.A(notWrtEnbX), .Y(notWrtEnbX_int) );
  NBUFFX4_RVT WrtEnbX_cell (.A(WrtEnbX), .Y(WrtEnbX_int) );


  NBUFFX4_RVT common_address0  (.A(common_address[0]), .Y(common_address_int[0]) );
  NBUFFX4_RVT common_address1  (.A(common_address[1]), .Y(common_address_int[1]) );
  NBUFFX4_RVT common_address2  (.A(common_address[2]), .Y(common_address_int[2]) );
  NBUFFX4_RVT common_address3  (.A(common_address[3]), .Y(common_address_int[3]) );
  NBUFFX4_RVT common_address4  (.A(common_address[4]), .Y(common_address_int[4]) );
  NBUFFX4_RVT common_address5  (.A(common_address[5]), .Y(common_address_int[5]) );
  NBUFFX4_RVT common_address6  (.A(common_address[6]), .Y(common_address_int[6]) );
  NBUFFX4_RVT common_address7  (.A(common_address[7]), .Y(common_address_int[7]) );

  NBUFFX4_RVT Prod0  (.A(Product[0]), .Y(Product_int[0]) );
  NBUFFX4_RVT Prod1  (.A(Product[1]), .Y(Product_int[1]) );
  NBUFFX4_RVT Prod2  (.A(Product[2]), .Y(Product_int[2]) );
  NBUFFX4_RVT Prod3  (.A(Product[3]), .Y(Product_int[3]) );
  NBUFFX4_RVT Prod4  (.A(Product[4]), .Y(Product_int[4]) );
  NBUFFX4_RVT Prod5  (.A(Product[5]), .Y(Product_int[5]) );
  NBUFFX4_RVT Prod6  (.A(Product[6]), .Y(Product_int[6]) );
  NBUFFX4_RVT Prod7  (.A(Product[7]), .Y(Product_int[7]) );
  NBUFFX4_RVT Prod8  (.A(Product[8]), .Y(Product_int[8]) );
  NBUFFX4_RVT Prod9  (.A(Product[9]), .Y(Product_int[9]) );
  NBUFFX4_RVT Prod10  (.A(Product[10]), .Y(Product_int[10]) );
  NBUFFX4_RVT Prod11  (.A(Product[11]), .Y(Product_int[11]) );
  NBUFFX4_RVT Prod12  (.A(Product[12]), .Y(Product_int[12]) );
  NBUFFX4_RVT Prod13  (.A(Product[13]), .Y(Product_int[13]) );
  NBUFFX4_RVT Prod14  (.A(Product[14]), .Y(Product_int[14]) );
  NBUFFX4_RVT Prod15  (.A(Product[15]), .Y(Product_int[15]) );
  NBUFFX4_RVT Prod16  (.A(Product[16]), .Y(Product_int[16]) );
  NBUFFX4_RVT Prod17  (.A(Product[17]), .Y(Product_int[17]) );
  NBUFFX4_RVT Prod18  (.A(Product[18]), .Y(Product_int[18]) );
  NBUFFX4_RVT Prod19  (.A(Product[19]), .Y(Product_int[19]) );
  NBUFFX4_RVT Prod20  (.A(Product[20]), .Y(Product_int[20]) );
  NBUFFX4_RVT Prod21  (.A(Product[21]), .Y(Product_int[21]) );
  NBUFFX4_RVT Prod22  (.A(Product[22]), .Y(Product_int[22]) );
  NBUFFX4_RVT Prod23  (.A(Product[23]), .Y(Product_int[23]) );
  NBUFFX4_RVT Prod24  (.A(Product[24]), .Y(Product_int[24]) );
  NBUFFX4_RVT Prod25  (.A(Product[25]), .Y(Product_int[25]) );
  NBUFFX4_RVT Prod26  (.A(Product[26]), .Y(Product_int[26]) );
  NBUFFX4_RVT Prod27  (.A(Product[27]), .Y(Product_int[27]) );
  NBUFFX4_RVT Prod28  (.A(Product[28]), .Y(Product_int[28]) );
  NBUFFX4_RVT Prod29  (.A(Product[29]), .Y(Product_int[29]) );
  NBUFFX4_RVT Prod30  (.A(Product[30]), .Y(Product_int[30]) );
  NBUFFX4_RVT Prod31  (.A(Product[31]), .Y(Product_int[31]) );

  NBUFFX4_RVT C0  (.A(C[0]), .Y(C_int[0]) );
  NBUFFX4_RVT C1  (.A(C[1]), .Y(C_int[1]) );
  NBUFFX4_RVT C2  (.A(C[2]), .Y(C_int[2]) );
  NBUFFX4_RVT C3  (.A(C[3]), .Y(C_int[3]) );
  NBUFFX4_RVT C4  (.A(C[4]), .Y(C_int[4]) );
  NBUFFX4_RVT C5  (.A(C[5]), .Y(C_int[5]) );
  NBUFFX4_RVT C6  (.A(C[6]), .Y(C_int[6]) );
  NBUFFX4_RVT C7  (.A(C[7]), .Y(C_int[7]) );
  NBUFFX4_RVT C8  (.A(C[8]), .Y(C_int[8]) );
  NBUFFX4_RVT C9  (.A(C[9]), .Y(C_int[9]) );
  NBUFFX4_RVT C10  (.A(C[10]), .Y(C_int[10]) );
  NBUFFX4_RVT C11  (.A(C[11]), .Y(C_int[11]) );
  NBUFFX4_RVT C12  (.A(C[12]), .Y(C_int[12]) );
  NBUFFX4_RVT C13  (.A(C[13]), .Y(C_int[13]) );
  NBUFFX4_RVT C14  (.A(C[14]), .Y(C_int[14]) );
  NBUFFX4_RVT C15  (.A(C[15]), .Y(C_int[15]) );
  NBUFFX4_RVT C16  (.A(C[16]), .Y(C_int[16]) );
  NBUFFX4_RVT C17  (.A(C[17]), .Y(C_int[17]) );
  NBUFFX4_RVT C18  (.A(C[18]), .Y(C_int[18]) );
  NBUFFX4_RVT C19  (.A(C[19]), .Y(C_int[19]) );
  NBUFFX4_RVT C20  (.A(C[20]), .Y(C_int[20]) );
  NBUFFX4_RVT C21  (.A(C[21]), .Y(C_int[21]) );
  NBUFFX4_RVT C22  (.A(C[22]), .Y(C_int[22]) );
  NBUFFX4_RVT C23  (.A(C[23]), .Y(C_int[23]) );
  NBUFFX4_RVT C24  (.A(C[24]), .Y(C_int[24]) );
  NBUFFX4_RVT C25  (.A(C[25]), .Y(C_int[25]) );
  NBUFFX4_RVT C26  (.A(C[26]), .Y(C_int[26]) );
  NBUFFX4_RVT C27  (.A(C[27]), .Y(C_int[27]) );
  NBUFFX4_RVT C28  (.A(C[28]), .Y(C_int[28]) );
  NBUFFX4_RVT C29  (.A(C[29]), .Y(C_int[29]) );
  NBUFFX4_RVT C30  (.A(C[30]), .Y(C_int[30]) );
  NBUFFX4_RVT C31  (.A(C[31]), .Y(C_int[31]) );


  always @(  posedge clock ) begin
      //$display ($time,,, "    MEMX : read=%b,write=%b, Address=%h, data_in=%h,data_out=%h",notWrtEnbX,WrtEnbX,common_address,{Product,C},memX_dataout);
      if (WrtEnbX== 1'b1) begin 
        $display ($time ,,," Wrote MEMX at %h , the data %h ", common_address,{Product,C});
      end
      if (notWrtEnbX== 1'b1) begin
          $display ($time ,,,"    Reading MEMX at %h , the data %h ", common_address,memX_dataout);
      end
   end
assign memX_dataout = {a,b};

SRAMLP1RW64x32 MemXa (
         .A(common_address_int[5:0]),
         .I(Product_int),
         .WEB(WrtEnbX_int),
         .CSB(common_address_int[6]),
         .OEB(common_address_int[7]),
         .CE(clock_int),
         .O(a)) ;

SRAMLP1RW64x32 MemXb (
         .A(common_address_int[5:0]),
         .I(C_int),
         .WEB(WrtEnbX_int),
         .CSB(common_address_int[6]),
         .OEB(common_address_int[7]),
         .CE(clock_int),
         .O(b)) ;


endmodule
