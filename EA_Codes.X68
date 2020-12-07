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
                JMP     Address011      ; address with post-increment (An)+
                JMP     Address100      ; address with pre-decrement -(An)
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

*---------- Address011 - Address Register Indirect with Post-Incrementing ----------  
Address011      JSR				Address010
				
                LEA             Plus,A1                ; prints a plus
                MOVE.B          #14,D0
                TRAP            #15
                              
                RTS


*---------- Address100 - Address Register Indirect with Pre-Decrementing ----------  
Address100      LEA             Minus,A1                ; prints a minus
                MOVE.B          #14,D0
                TRAP            #15
                
                JSR             Address010
                            
                RTS
                
*---------- Address111 - Absolute word, Long address, and Immediate Data ----------  
*Address111      MOVEA.L         A2, A6
*                CMP.B           #%000, D5
*                BEQ             Abs_Word
*                
*                CMP.B           #%001, D5
*                BEQ             Abs_Long
*                
*                CMP.B           #%100, D5
*                BEQ             Imm_Data
*                
*
*Abs_Word        ADDA.W          #2, A6
*                MOVE.B          #0, Address_Size
*                
*                LEA             Dollar,A1               ; prints a dollar
*                MOVE.B          #14,D0
*                TRAP            #15
*                
*                CLR.L           D6
*                MOVE.W          (A6),D6
*                MOVE.W          #4,D7
*                JSR             PRINT_IADDR
*
*                ADDA.W          #2, A2
*                
*                RTS
*
*Abs_Long        ADDA.W          #2, A6
*                MOVE.B          #1, Address_Size
*
*                LEA             Dollar,A1               ; prints a dollar
*                MOVE.B          #14,D0
*                TRAP            #15
*                
*                CLR.L           D6
*                MOVE.L          (A6),D6
*                MOVE.L          #8,D7
*                JSR             PRINT_IADDR
*
*                ADDA.W          #4, A2
*                
*                RTS
*
*Imm_Data        LEA             Pound,A1                ; prints a pound
*                MOVE.B          #14,D0
*                TRAP            #15
*
*                LEA             Dollar,A1               ; prints a dollar
*                MOVE.B          #14,D0
*                TRAP            #15
*
*                CLR.L           D5
*                MOVE.B          Opcode_Size, D5
*                
*                CMP.B           #2,D5
*                BEQ             Imm_Long               
*                
*                ADDA.W          #2, A6
*                
*                CLR.L           D6
*                MOVE.W          (A6),D6
*                MOVE.L          #4, D7
*                JSR             PRINT_DATA
*                
*                ADDA.W          #2, A2
*                
*                RTS
*                                
*
*Imm_Long        ADDA.W          #2, A6
*                
*                CLR.L           D6
*                MOVE.L          (A6),D6
*                MOVE.L          #8,D7
*                JSR             PRINT_DATA
*
*                ADDA.W          #4, A2
*
*                RTS
*
*                BRA             EA_INVALID
*
*PRINT_IADDR      MOVEM.L     D2-D5/D7, -(SP)
*                 LEA         JMP_HEX, A5
*                 
*                 CMP.B       #0, Address_Size
*                 BEQ         CHECK_SIZE
*                                                 
*IADDR_LOOP1      MULU.W      #4, D7
*                 MOVE.L      #32, D5
*                 SUB.L       D7, D5
*                 MOVE.L      #28, D4
*
*IADRR_LOOP2      MOVE.L      D6, D2
*                 LSL.L       D5, D2
*                 LSR.L       D4, D2
*
*                 MULU        #2, D2
*                 LEA         0(A5, D2),A1
*                 MOVE.B      #14, D0
*                 TRAP        #15
*
*                 ADD.B       #4, D5
*                 CMP.B       #32, D5
*                 BNE         IADRR_LOOP2
*               
*IADDR_RETURN     MOVEM.L     (SP)+,D2-D5/D7
*                 RTS 
*                 
*CHECK_SIZE       MOVE.W      D6, D1
*                 MOVE.B      #16, D2
*                 LSL.L       D2, D1
*                 MOVE.B      #28, D2
*                 LSR.L       D2, D1
*                 
*                 CMP.B       #0, D1
*                 BNE         IADDR_LOOP1
*                 
*                 MOVE.W      D6, D1
*                 MOVE.B      #20, D2
*                 LSL.L       D2, D1
*                 MOVE.B      #28, D2
*                 LSR.L       D2, D1
*                 
*                 CMP.B       #0, D1
*                 BNE         IADDR_LOOP1
*                 
*                 BRA         B_ADDR
*                 
*B_ADDR          MOVE.B       #1, D3
*                MOVE.B       D6, D1
*                MOVE.L       #24, D2
*                LSL.L        D2, D1
*                MOVE.L       #28, D2
*                LSR.L        D2, D1
*
*                CMP.B        #9, D1
*                BLE          UNTIL_9
*
*                CMP.B        #9, D1
*                BGT          OVER_9
*                
*B_ADDR_LOOP     CMP.B        #2, D3
*                BEQ          IADDR_RETURN 
*                
*                MOVE.B       D6, D1
*                MOVE.L       #28, D2
*                LSL.L        D2, D1
*                MOVE.L       #28, D2
*                LSR.L        D2, D1
*                ADDQ         #1, D3
*
*                CMP.B        #9, D1
*                BLE          UNTIL_9
*
*                CMP.B        #9, D1
*                BGT          OVER_9   
*
*UNTIL_9         JSR          EVALUATE_NUM 
*                
*                BRA          B_ADDR_LOOP
*                
*OVER_9          JSR          EVALUATE_CHAR
*            
*                BRA          B_ADDR_LOOP                              
*                 
*
**-----------------------------------------------------------------
** Print Data (Byte, Word, Long)
** D5 - size of the data
** D6 - data to be printed
**-----------------------------------------------------------------                        
*PRINT_DATA      MOVEM.L      D0-D4/A0-A7, -(SP)
*                CMP.B        #0, D5
*                BEQ          PRINT_IB
*                
*                LEA          JMP_HEX, A5
*                MULU.W       #4, D7
*                MOVE.L       #32, D3
*                SUB.L        D7, D3
*                MOVE.L       #28, D4
*                     
*WL_LOOP         MOVE.L       D6, D2
*                LSL.L        D3, D2
*                LSR.L        D4, D2
*                
*                MULU         #2, D2
*                LEA          0(A5,D2),A1
*                MOVE.B       #14, D0
*                TRAP         #15
*                
*                ADD.B        #4, D3
*                CMP.B        #32, D3
*                BNE          WL_LOOP
*                
*RETURN          MOVEM.L      (SP)+, D0-D4/A0-A7                
*                RTS
*
*PRINT_IB        MOVE.B       #1, D3
*                MOVE.B       D6, D1
*                MOVE.L       #24, D2
*                LSL.L        D2, D1
*                MOVE.L       #28, D2
*                LSR.L        D2, D1
*
*                CMP.B        #9, D1
*                BLE          TIL_9
*
*                CMP.B        #9, D1
*                BGT          SURPASS_9
*                
*B_LOOP          CMP.B        #2, D3
*                BEQ          RETURN 
*                
*                MOVE.B       D6, D1
*                MOVE.L       #28, D2
*                LSL.L        D2, D1
*                MOVE.L       #28, D2
*                LSR.L        D2, D1
*                ADDQ         #1, D3
*
*                CMP.B        #9, D1
*                BLE          TIL_9
*
*                CMP.B        #9, D1
*                BGT          SURPASS_9   
*
*TIL_9           JSR          EVALUATE_NUM 
*                
*                BRA          B_LOOP
*                
*SURPASS_9       JSR          EVALUATE_CHAR
*            
*                BRA          B_LOOP                  

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
Plus            DC.W    '+',0
Minus           DC.W    '-',0
Dollar          DC.W    '$',0
Pound           DC.W    '#',0

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
