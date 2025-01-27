//////////////////////////////////////////////////////////////////////////////////
// Company: EE2026
// Engineer: Li Bozhao
// Create Date: 03/25/2020 00:05:16 AM
// Design Name: FGPA Project for EE2026
// Module Name: [Functions] DrawPoint, DrawLine, DrawChar, DrawRect, DrawCirc, DrawSceneSprite, FillRect, FillCirc, 
// Project Name: FGPA Project for EE2026
// Target Devices: Basys 3
// Tool Versions: Vivado 2018.2
// Description: These functions can be used to parse commands for drawing geometric shapes and texts conveniently
// Dependencies: NUL
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Must be included before use. All rights reserved by Li Bozhao.
//////////////////////////////////////////////////////////////////////////////////
function [63:0] DrawPoint;
    input [6:0] X;
    input [5:0] Y;
    input [15:0] COLOR; 
    begin
        DrawPoint[63] = 1;//Enable
        DrawPoint[62:59] = 4'd1;//PT
        DrawPoint[6:0] = X;
        DrawPoint[12:7] = Y;
        DrawPoint[28:13] = COLOR;
        DrawPoint[58:29] = 0;
    end
endfunction

function [63:0] DrawLine;
    input [6:0] X1;
    input [5:0] Y1;
    input [6:0] X2;
    input [5:0] Y2;
    input [15:0] COLOR;
    begin
        DrawLine[63] = 1;//Enable
        DrawLine[62:59] = 4'd2;//LN
        DrawLine[6:0] = X1;
        DrawLine[12:7] = Y1;
        DrawLine[28:13] = COLOR;
        DrawLine[35:29] = X2;
        DrawLine[41:36] = Y2;
        DrawLine[58:42] = 0;
    end
endfunction

function [63:0] DrawChar;
    input [6:0] X;
    input [5:0] Y;
    input [19:0] CHR;
    input [15:0] COLOR;
    input [1:0] POWER;
    begin
        DrawChar[63] = 1;//Enable
        DrawChar[62:59] = 4'd3;//CHR
        DrawChar[6:0] = X;
        DrawChar[12:7] = Y;
        DrawChar[28:13] = COLOR;
        DrawChar[48:29] = CHR;
        DrawChar[50:49] = POWER;
        DrawChar[58:51] = 0;
    end
endfunction

function [63:0] DrawRect;
    input [6:0] X1;
    input [5:0] Y1;
    input [6:0] X2;
    input [5:0] Y2;
    input [15:0] COLOR;
    begin
        DrawRect[63] = 1;//Enable
        DrawRect[62:59] = 4'd4;//RECT
        DrawRect[6:0] = X1;
        DrawRect[12:7] = Y1;
        DrawRect[28:13] = COLOR;
        DrawRect[35:29] = X2;
        DrawRect[41:36] = Y2;
        DrawRect[58:42] = 0;
    end
endfunction

function [63:0] DrawCirc;
    input [6:0] X;
    input [5:0] Y;
    input [4:0] R;
    input [15:0] COLOR;
    begin
        DrawCirc[63] = 1;//Enable
        DrawCirc[62:59] = 4'd5;//CIRC
        DrawCirc[6:0] = X;
        DrawCirc[12:7] = Y;
        DrawCirc[28:13] = COLOR;
        DrawCirc[33:29] = R;
        DrawCirc[58:34] = 0;
    end
endfunction

function [63:0] DrawSceneSprite;
    input [6:0] X;
    input [5:0] Y;
    input [15:0] MCOLOR;
    input [6:0] INDEX;
    input [1:0] POWER;
    begin
        DrawSceneSprite[63] = 1;//Enable
        DrawSceneSprite[62:59] = 4'd6;//SPRSCN
        DrawSceneSprite[6:0] = X;
        DrawSceneSprite[12:7] = Y;
        DrawSceneSprite[28:13] = MCOLOR;
        DrawSceneSprite[35:29] = INDEX;
        DrawSceneSprite[37:36] = POWER;
        DrawSceneSprite[58:38] = 0;
    end
endfunction

function [63:0] FillRect;
    input [6:0] X1;
    input [5:0] Y1;
    input [6:0] X2;
    input [5:0] Y2;
    input [15:0] COLOR;
    begin
        FillRect[63] = 1;//Enable
        FillRect[62:59] = 4'd7;//FRECT
        FillRect[6:0] = X1;
        FillRect[12:7] = Y1;
        FillRect[28:13] = COLOR;
        FillRect[35:29] = X2;
        FillRect[41:36] = Y2;
        FillRect[58:42] = 0;
    end
endfunction

function [63:0] FillCirc;
    input [6:0] X;
    input [5:0] Y;
    input [4:0] R;
    input [15:0] COLOR;
    begin
        FillCirc[63] = 1;//Enable
        FillCirc[62:59] = 4'd8;//FCIRC
        FillCirc[6:0] = X;
        FillCirc[12:7] = Y;
        FillCirc[28:13] = COLOR;
        FillCirc[33:29] = R;
        FillCirc[58:34] = 0;
    end
endfunction

function [63:0] QuickDrawSceneSprite;//using SPRSCN command
    input [6:0] LOCX;//actually 0 to 11
    input [5:0] LOCY;//actually 0 to 7
    input [15:0] MCOLOR;
    input [6:0] INDEX;
    input [1:0] POWER;
    begin
        QuickDrawSceneSprite[63] = 1;//Enable
        QuickDrawSceneSprite[62:59] = 4'd6;//SPRSCN
        QuickDrawSceneSprite[6:0] = LOCX << 3;
        QuickDrawSceneSprite[12:7] = LOCY << 3;
        QuickDrawSceneSprite[28:13] = MCOLOR;
        QuickDrawSceneSprite[35:29] = INDEX;
        QuickDrawSceneSprite[37:36] = POWER;
        QuickDrawSceneSprite[58:38] = 0;
    end
endfunction

function [63:0] SBNCH;
    input [6:0] ADDR;
    input [1:0] CMP;
    begin
        SBNCH[63] = 1;//Enable
        SBNCH[62:59] = 4'd13;//SBNCH
        SBNCH[6:0] = ADDR;//target address
        SBNCH[8:7] = CMP;
        SBNCH[58:9] = 0;
    end
endfunction

function [63:0] DBNCH;
    input [6:0] ADDR1;
    input [6:0] ADDR2;
    input [1:0] CMP;
    begin
        DBNCH[63] = 1;//Enable
        DBNCH[62:59] = 4'd14;//DBNCH
        DBNCH[6:0] = ADDR1;//target address 1
        DBNCH[13:7] = ADDR2;//target address 2
        DBNCH[15:14] = CMP;
        DBNCH[58:16] = 0;
    end
endfunction

function [63:0] JMP;
    input [6:0] ADDR;
    begin
        JMP[63] = 1;//Enable
        JMP[62:59] = 4'd15;//JMP
        JMP[6:0] = ADDR;//target address
        JMP[58:7] = 0;
    end
endfunction

function [63:0] IdleCmd;
    IdleCmd = {1'b1,63'b0};
endfunction;