`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: EE2026
// Engineer: Liu Jingming
// 
// Create Date: 2020/03/24 11:19:19
// Design Name: 
// Module Name: game_maze
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mux_4to1_assign ( input [15:0] a, [15:0] b, [15:0] c, [15:0] d, [1:0] sel, [15:0] out);  
   assign out = sel[1] ? (sel[0] ? d : c) : (sel[0] ? b : a); 
endmodule

module maze_pixel_map (input CLK, input [12:0] Pix, output reg [12:0] xvalue,reg [12:0] yvalue);
    always @ (posedge CLK) begin
        yvalue = Pix / 8'd96;   //0~64
        xvalue = Pix - yvalue * 8'd96;  //0~96
    end      
endmodule

module maze_map(input CLK, [12:0] xvalue, [12:0] yvalue,[12:0] xdot, [12:0] ydot, output reg [1:0]OnRoad);
    always @ (posedge CLK) begin
            if ((xvalue <=  xdot + 1) && (xvalue >= xdot - 1) && (yvalue <=  ydot + 1) && (yvalue >= ydot - 1)) OnRoad = 2'b10;
            else if ((xvalue >= 7'd0) && (xvalue<=7'd18) && (yvalue >= 7'd56) && (yvalue <= 7'd64)) OnRoad = 0;
            else if ((xvalue >= 7'd12) && (xvalue<=7'd18) && (yvalue >= 7'd32) && (yvalue <= 7'd56)) OnRoad = 0;
            else if ((xvalue >= 7'd6) && (xvalue<=7'd12) && (yvalue >= 7'd8) && (yvalue <= 7'd40)) OnRoad = 0;
            else if ((xvalue >= 7'd12) && (xvalue<=7'd30) && (yvalue >= 7'd8) && (yvalue <= 7'd16)) OnRoad = 0;
            else if ((xvalue >= 7'd24) && (xvalue<=7'd54) && (yvalue >= 7'd16) && (yvalue <= 7'd24)) OnRoad = 0;
            else if ((xvalue >= 7'd36) && (xvalue<=7'd42) && (yvalue >= 7'd0) && (yvalue <= 7'd16)) OnRoad = 0;
            else if ((xvalue >= 7'd42) && (xvalue<=7'd66) && (yvalue >= 7'd0) && (yvalue <= 7'd8)) OnRoad = 0;
            else if ((xvalue >= 7'd36) && (xvalue<=7'd42) && (yvalue >= 7'd0) && (yvalue <= 7'd16)) OnRoad = 0;
            else if ((xvalue >= 7'd60) && (xvalue<=7'd66) && (yvalue >= 7'd8) && (yvalue <= 7'd40)) OnRoad = 0;
            else if ((xvalue >= 7'd48) && (xvalue<=7'd60) && (yvalue >= 7'd24) && (yvalue <= 7'd32)) OnRoad = 0;
            else if ((xvalue >= 7'd30) && (xvalue<=7'd54) && (yvalue >= 7'd32) && (yvalue <= 7'd40)) OnRoad = 0;
            else if ((xvalue >= 7'd30) && (xvalue<=7'd36) && (yvalue >= 7'd40) && (yvalue <= 7'd48)) OnRoad = 0;
            else if ((xvalue >= 7'd18) && (xvalue<=7'd60) && (yvalue >= 7'd48) && (yvalue <= 7'd56)) OnRoad = 0;
            else if ((xvalue >= 7'd84) && (xvalue<=7'd90) && (yvalue >= 7'd40) && (yvalue <= 7'd64)) OnRoad = 0;
            else if ((xvalue >= 7'd72) && (xvalue<=7'd84) && (yvalue >= 7'd40) && (yvalue <= 7'd48)) OnRoad = 0;
            else if ((xvalue >= 7'd66) && (xvalue<=7'd72) && (yvalue >= 7'd24) && (yvalue <= 7'd32)) OnRoad = 0;
            else if ((xvalue >= 7'd72) && (xvalue<=7'd80) && (yvalue >= 7'd16) && (yvalue <= 7'd40)) OnRoad = 0;
            else if ((xvalue >= 7'd80) && (xvalue<=7'd92) && (yvalue >= 7'd16) && (yvalue <= 7'd24)) OnRoad = 0;
            else if ((xvalue >= 7'd84) && (xvalue<=7'd90) && (yvalue >= 7'd0) && (yvalue <= 7'd16)) OnRoad = 0;
            else OnRoad = 2'b01; 
    end
endmodule

module maze_map_color(input CLK, [2:0] OnRoad,output reg [15:0] STREAM);
    always @ (posedge CLK) begin
        if (OnRoad == 2'b10) STREAM = 16'b0000000000001111;   //blue
        else if (OnRoad == 0) STREAM = 16'b1101100000000000;     //red
        else if (OnRoad == 1) STREAM = 16'b0000000111100000;   //green 
    end
endmodule

//Button Debouncing
module my_dff (input CLOCK, D, output reg Q = 0);
    always @ (posedge CLOCK) Q <= D;
endmodule
module task1(input CLOCK, BTN, output Q);
    wire Q1;
    wire Q2;
    my_dff f0(CLOCK, BTN, Q1);
    my_dff f1(CLOCK, Q1, Q2);
    assign Q = (Q1 & ~Q2);
endmodule

module maze_dot_movement (input CLK, BTNC,BTNU, BTND, BTNR, BTNL, validmove, output reg [12:0] xdot,reg [12:0] ydot, reg [1:0] gamestart = 2'b00);
    wire QC; wire QU; wire QD; wire QR; wire QL;
    task1 ef0(CLK, BTNC, QC);
    task1 ef1(CLK, BTNU, QU);
    task1 ef2(CLK, BTND, QD);
    task1 ef3(CLK, BTNR, QR);
    task1 ef4(CLK, BTNL, QL);
    
    
    always@(posedge CLK) begin
        if(QC == 1) begin 
            gamestart = 2'b01;   //display gamestart
        end
        if(gamestart == 0) begin  
            xdot = 12'd6;
            ydot = 12'd60;
        end
        else begin
            if (validmove == 1) begin
                if(QL==1) xdot <= xdot - 1;
                if(QR==1) xdot <= xdot + 1;
                if(QU==1) ydot <= ydot - 1;
                if(QD==1) ydot <= ydot + 1;
            end
        end
    end
endmodule

module maze_checkwall(input CLK, [12:0] xvalue, [12:0] yvalue, output reg onwall);
     always @ (posedge CLK) begin
             if ((xvalue >= 7'd0) && (xvalue<=7'd18) && (yvalue >= 7'd56) && (yvalue <= 7'd64)) onwall=1;
             else if ((xvalue >= 7'd12) && (xvalue<=7'd18) && (yvalue >= 7'd32) && (yvalue <= 7'd56)) onwall=1;
             else if ((xvalue >= 7'd6) && (xvalue<=7'd12) && (yvalue >= 7'd8) && (yvalue <= 7'd40)) onwall=1;
             else if ((xvalue >= 7'd12) && (xvalue<=7'd30) && (yvalue >= 7'd8) && (yvalue <= 7'd16)) onwall=1;
             else if ((xvalue >= 7'd24) && (xvalue<=7'd54) && (yvalue >= 7'd16) && (yvalue <= 7'd24)) onwall=1;
             else if ((xvalue >= 7'd36) && (xvalue<=7'd42) && (yvalue >= 7'd0) && (yvalue <= 7'd16)) onwall=1;
             else if ((xvalue >= 7'd42) && (xvalue<=7'd66) && (yvalue >= 7'd0) && (yvalue <= 7'd8)) onwall=1;
             else if ((xvalue >= 7'd36) && (xvalue<=7'd42) && (yvalue >= 7'd0) && (yvalue <= 7'd16)) onwall=1;
             else if ((xvalue >= 7'd60) && (xvalue<=7'd66) && (yvalue >= 7'd8) && (yvalue <= 7'd40)) onwall=1;
             else if ((xvalue >= 7'd48) && (xvalue<=7'd60) && (yvalue >= 7'd24) && (yvalue <= 7'd32)) onwall=1;
             else if ((xvalue >= 7'd30) && (xvalue<=7'd54) && (yvalue >= 7'd32) && (yvalue <= 7'd40)) onwall=1;
             else if ((xvalue >= 7'd30) && (xvalue<=7'd36) && (yvalue >= 7'd40) && (yvalue <= 7'd48)) onwall=1;
             else if ((xvalue >= 7'd18) && (xvalue<=7'd60) && (yvalue >= 7'd48) && (yvalue <= 7'd56)) onwall=1;
             else if ((xvalue >= 7'd84) && (xvalue<=7'd90) && (yvalue >= 7'd40) && (yvalue <= 7'd64)) onwall=1;
             else if ((xvalue >= 7'd72) && (xvalue<=7'd84) && (yvalue >= 7'd40) && (yvalue <= 7'd48)) onwall=1;
             else if ((xvalue >= 7'd66) && (xvalue<=7'd72) && (yvalue >= 7'd24) && (yvalue <= 7'd32)) onwall=1;
             else if ((xvalue >= 7'd72) && (xvalue<=7'd80) && (yvalue >= 7'd16) && (yvalue <= 7'd40)) onwall=1;
             else if ((xvalue >= 7'd80) && (xvalue<=7'd92) && (yvalue >= 7'd16) && (yvalue <= 7'd24)) onwall=1;
             else if ((xvalue >= 7'd84) && (xvalue<=7'd90) && (yvalue >= 7'd0) && (yvalue <= 7'd16)) onwall=1;
             else onwall=0; 
     end
endmodule

module maze_valid_move (input CLK, [12:0] xdot, [12:0] ydot, onwall, output reg validmove=1);
    maze_checkwall mvm0(CLK, xdot, ydot, onwall);
    always @ (posedge CLK) begin
        if(onwall==1) validmove = 0;
        else validmove = 1;
    end
endmodule

module maze_win (input CLK, [12:0] xvalue, [12:0] yvalue, output reg win);
    always @ (posedge CLK) begin
        if ((xvalue >= 7'd84) && (xvalue<=7'd90) && (yvalue >= 7'd0) && (yvalue <= 7'd8)) win=1;
        else win = 0;
    end
endmodule

module maze_display_win(input CLK, xvalue, yvalue, output reg [15:0] STREAM);
    always @ (posedge CLK) begin
        STREAM = 16'b0001111000000000;
    end
endmodule

module maze_display(input CLK, state,[12:0] Pix, output reg [15:0] STREAM);
    reg MAPG; 
    reg MAPA; 
    reg MAPM;
    reg MAPE;
    reg MAPO;
    reg MAPV;
    reg MAPR;
    CharBlocks charG(20'd6, MAPG);   //[34:0] MAP
    CharBlocks charA(20'd0, MAPA);
    CharBlocks charM(20'd12, MAPM);
    CharBlocks charE(20'd4, MAPE);
    CharBlocks charO(20'd14, MAPO);
    CharBlocks charV(20'd21, MAPV);
    CharBlocks charR(20'd17, MAPR);
endmodule
/* 
module maze_draw_char(input CLK, [12:0] xvalue,[12:0] yvalue,[12:0] topleftx,[12:0] toplefty, [34:0] MAP, output reg [15:0] STREAM);
    if((xvalue>=topleftx)&&(xvalue<=topleftx+3'd4)&&(yvalue>=toplefty)&&(yvalue<=toplefty+4'd6)) begin
        STREAM = (xvalue && MAP[1])? 16'b1111100000000000:0;
        
    end
endmodule
*/



module game_maze(input CLK,BTNC,BTNU, BTND, BTNR, BTNL, [12:0] Pix, STREAM);
    wire [12:0] xvalue;
    wire [12:0] yvalue;
    wire [12:0] xdot;
    wire [12:0] ydot;
    wire [1:0] OnRoad;
    wire validmove;
    reg [2:0] gamestate=3'd0;
    wire [1:0] gamestart;
    reg [40:0] counter = 41'd0;
    wire win;
    wire [15:0] stream1;
    wire [15:0] stream2;
    wire [1:0] sel;
    maze_pixel_map f0(CLK, Pix, xvalue,yvalue);
    maze_map f1(CLK,xvalue,yvalue,xdot, ydot, OnRoad);
    maze_map_color f2(CLK, OnRoad, stream1);
    maze_valid_move f3(CLK, xdot, ydot, validmove);
    maze_dot_movement f4(CLK, BTNC,BTNU, BTND, BTNR, BTNL,validmove, xdot, ydot, gamestart);
    maze_win f5(CLK, xdot, ydot, sel[0]);
    maze_display_win f6(CLK, xvalue, yvalue, stream2);
    B16_MUX f7(stream2,stream1,sel[0],STREAM); 
    
    /*
    always @ (posedge CLK) begin
        if(gamestart==1) begin
            gamestate = 3'd1;
            counter <= counter + 1;
            //
        end
        if(counter[40]==1) begin 
            if(validmove==0) gamestate=3'd3;
            if (win==1) gamestate = 3'd4;
            else gamestate = 3'd2;
        end
        
        case (gamestate) 
            3'd01: STREAM=16'b1111100000000000;
            3'd03: STREAM=16'b0000011110000000;
            3'd04: STREAM=16'b0000000001111111;
        endcase
    end
    */
endmodule