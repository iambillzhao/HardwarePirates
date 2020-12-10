*-------------------------  EA-Codes  ----------------------
* Written by :  Lawrence Fiesta
* Date       :  10/30/2020
* Description:  Handles all required EA-codes
*-----------------------------------------------------------
*-----------------------------------------------------------
* Effective address decode
* A4 loads the jump table of EA
* A5 loads the jump table of Hexadecimal
* D4(Mode), D5(Register)
*-----------------------------------------------------------
EA_DECODE       LEA     EA_JMP,A4       ; loads ea jump table in A4
                LEA     HEX_TABLE,A5    ; loads hex table to A5
                MULU    #6,D4            
                MOVE.W  A0,Original
                JSR     0(A4, D4)       ; runs subroutine that matches the mode
                
                RTS
*---------------------- EA Jump table ----------------------
EA_JMP          JMP     Address000      ; data register Dn
                JMP     Address001      ; address register An
                JMP     Address010      ; address indirect (An)
                JMP     Address011      ; address with post-increment (An)+
                JMP     Address100      ; address with pre-decrement -(An)
                JMP     Address101      ; 101
                JMP     Address110      ; 110
                JMP     Address111      ; absolute short (xxx).W, absolute long (xxx).L, immediate #imm
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
                
Address101
                BRA     Invalid_Instruction
Address110
                BRA     Invalid_Instruction
                
*---------- Address111 - Absolute word, Long address, and Immediate Data ----------  
Address111      MOVEA.L         A2, A6
                CMP.B           #%000, D5
                BEQ             Abs_Word
                
                CMP.B           #%001, D5
                BEQ             Abs_Long
                
                CMP.B           #%100, D5
                BEQ             Imm_Data
                
Abs_Word        ADDA.W          #2, A6
                
*                LEA             Dollar,A1               ; prints a dollar
*                MOVE.B          #14,D0
*                TRAP            #15
                ADD.W           #2,D2       ; increment address by 2
                MOVE.L          D2,A0       ; copies data from D2 to A0
                MOVE.W          (A0),D1
                
                MOVE.L          D1,A2       ; moves copied data to A0
                MOVE.B          #0,D6
                MOVE.L          #28,D2
                
                JSR             LOOP
                
                MOVE.L          A0,D2
                MOVE.L          Original,A0
                RTS
Abs_Long        ADDA.W          #2, A6
*                MOVE.B          #1, Address_Size
*                LEA             Dollar,A1               ; prints a dollar
*                MOVE.B          #14,D0
*                TRAP            #15
*                CLR             D0
                
                ADD.L           #2,D2       ; increment address by 2
                MOVE.L          D2,A0       ; copies data from D2 to A0
                MOVE.L          (A0),D1     ; copies data from A0 to D0
                
                MOVE.L          D1,A2       ; moves copied data to A0
                MOVE.B          #0,D6
                MOVE.L          #28,D2
                
                JSR             LOOP
                MOVE.L          A0,D2
                ADD.W           #2,D2
                
                RTS
                
Imm_Data        ADD.W           #2,D2       ; increment address by 2
                MOVE.L          D2,A0       ; copies data from D2 to A0
                MOVE.W          (A0),D1
                
                MOVE.L          D1,A2       ; moves copied data to A0
                MOVE.B          #16,D6
                MOVE.L          #28,D2
                
                JSR             LOOP
                
                MOVE.L          A0,D2
                MOVE.L          Original,A0
                RTS
                                
Imm_Long        ADDA.W          #2, A6
                
                CLR.L           D6
                MOVE.L          (A6),D6
*                MOVE.L          #8,D7
*                JSR             PRINT_DATA
                ADDA.W          #4, A2
                RTS
*                BRA             EA_INVALID
LOOP            MOVE.L          A2,D1
                LSL.L           D6,D1
                LSR.L           D2,D1
                
                MULU            #2,D1
                LEA             0(A5,D1),A1
                MOVE.L          #14,D0
                TRAP            #15
                
                ADD.B           #4,D6
                CMP.B           #32,D6
                BNE             LOOP                
                
                RTS
BCC_DISP        
                MOVEA.L         D2,A4
                ADD.W           #$2,A4
                
                CLR             D6
                MOVE.B          D4,D6
                ADDA.W          D6,A4
                MOVE.L          A4,D5       ; hex value ready to for output

                MOVE.L          A4,A2
                MOVE.B          #16,D6
                MOVE.B          #0  ,D6
                MOVE.L          #28,D2
                LEA             HEX_TABLE,A5    ; loads hex table to A5

                JSR             LOOP
                MOVE.W          Original_Add,D2
*                MOVE.L          Original,A0

                RTS

DATA_REG_SHIFT
                MOVE.B          #0,D4

                JSR             EA_DECODE

                BRA             DATA_RETURN


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

Original        DS.W        1                       ; original data
Original_Add    DS.W        1                       ; original address

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
