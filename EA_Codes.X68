*-------------------------  OP-Codes  --------------------------
* Written by :  Anna Jennings, Lucy Chi
* Date       :  10/30/2020
* Description:  Handles all required Op-codes
*-----------------------------------------------------------

EA_DECODE  		LEA     EA_JMP,A4       ; loads ea jump table in A4
                LEA     HEX_TABLE,A5    ; loads hex table to A5
                MULU    #6,D4            

                JSR     0(A4, D4)       ; runs subroutine that matches the mode
                
                RTS

*---------------------- EA Jump table ----------------------
EA_JMP          JMP     Address000      ; data register Dn
                JMP     Address001      ; address register An
                JMP     Address010      ; address indirect (An)
                *JMP    Address011      ; address with post-increment (An)+
                *JMP    Address100      ; address with pre-decrement -(An)
                *JMP    Address111      ; absolute short (xxx).W, absolute long (xxx).L, immediate #imm

*---------------- Address000 - Data register ----------------
Address000      MOVE.L          #26, D6
                LEA             0(A5, D6),A1
                MOVE.B          #14, D0
                TRAP            #15                
                
                MULU            #2,D5
                LEA             0(A5, D5),A1
                MOVE.B          #14, D0
                TRAP            #15
                
                RTS

*----------- Address001 - Address Register Direct -----------
Address001      MOVE.L          #20, D6
                LEA             0(A5, D6),A1
                MOVE.B          #14, D0
                TRAP            #15 
                
                MULU            #2, D5
                LEA             0(A5, D5),A1
                MOVE.B          #14, D0
                TRAP            #15

                RTS
                
*---------- Address010 - Address Register Indirect ----------  
Address010      MOVE.L          #20, D6

                LEA             Open_P,A1                ; prints an open parenthesis
                MOVE.B          #14,D0
                TRAP            #15
                
                LEA             0(A5, D6),A1
                MOVE.B          #14, D0
                TRAP            #15 
                
                MULU            #2, D5
                LEA             0(A5, D5),A1
                MOVE.B          #14, D0
                TRAP            #15

                LEA             Close_P,A1                ; prints a close parenthesis
                MOVE.B          #14,D0
                TRAP            #15
               
                
                RTS


*---------------------- Hex table ----------------------
HEX_TABLE       DC.B    '0',0
                DC.B    '1',0
                DC.B    '2',0
                DC.B    '3',0
                DC.B    '4',0
                DC.B    '5',0
                DC.B    '6',0
                DC.B    '7',0
                DC.B    '8',0
                DC.B    '9',0
                DC.B    'A',0
                DC.B    'B',0
                DC.B    'C',0
                DC.B    'D',0
                DC.B    'E',0
                DC.B    'F',0
                
Open_P          DC.W    '(',0
Close_P         DC.W    ')',0



*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
