*-------------------------  OP-Codes  --------------------------
* Written by :  Anna Jennings, Lucy Chi
* Date       :  10/30/2020
* Description:  Handles all required Op-codes
*-----------------------------------------------------------
START:              ORG    $1000                         ; first instruction of program


*-------------------------  MOVE  --------------------------
* Written by :  Anna Jennings
* Date       :  10/30/2020
* Description:  Prints the MOVE EA
*-----------------------------------------------------------                   

                    MOVE.L      #%0010010111111000,A0   ; Testing info


*----------------------  MOVE: Display MOVE -----------------
OP_MOVE             LEA         MOVE_Output,A1          ; Display 'MOVE' 
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                    
                    
*----------------------  MOVE: Get Size  --------------------
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on               
                    AND.L       #%0011000000000000,D4   ; clear all bits except the size     
                    LSR.L       #8,D4                   ; access the size element of the instruction, do this by shifting the number the right 12 bits                    
                    LSR.L       #4,D4
                    
                                   
                                   
                    CMP.B       #%01,D4                 ; checking if the size is byte
                    BEQ         MOVE_Byte               ; branch to the byte condition

                    CMP.B       #%11,D4                 ; checking if the size is Word  
                    BEQ         MOVE_Word               ; branch to Word condition

                    CMP.B       #%10,D4                 ; checking if the size is Long
                    BEQ         MOVE_Long               ; Branch to Long Condition
                    
                    BRA         Invalid_Instruction     ; branches if the size data isn't properly formatted

*----------------------  MOVE: Get Destination  --------------
MOVE_Dest_Reg       CLR         D4
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on               
                    AND.L       #%0000111000000000,D4   ; clear all bits except the Destination Register                     
                    LSR.L       #6,D4                   ; access the destination register

                    MOVE.W      D4,D5
                    
                    CLR         D4
                    MOVE.L      A0,D4

                    AND.L       #%0000000111000000,D4   ; clearing all bits except Destination Mode
                    LSR.L       #6,D4
                    ADD.L       D4,D5                   ; combining the Source data together

*----------------------  MOVE: Get Source  -------------------
                    CLR         D4
                    MOVE.L      A0,D4
                    AND.L       #%0000000000111111,D4   ; clearing all bits except Source Mode,and Register
*----------------------  MOVE: Send to EA  -------------------

                    BRA         EA_MOVE                 ; send to the EA with D4 holding the Destination and D5 holding Source  
                    
*----------------------  MOVE: Functions  --------------------

MOVE_Byte           LEA         Output_Byte,A1          ; Display '.B' for MOVE size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output

                    BRA         Dest_Reg                ; return to code
                    
MOVE_Word           LEA         Output_Word,A1          ; Display '.W' for MOVE size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                   
                    BRA         MOVE_Dest_Reg           ; return to code
 
MOVE_Long           LEA         Output_Long,A1          ; Display '.L' for MOVE size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output

                    BRA         MOVE_Dest_Reg           ; return to code
                    

*----------------------  End of MOVE  ----------------------------
*Move and its size have been printed
*D4,D5 are loaded with EA and ready to be analyzed
*-----------------------------------------------------------------


*-------------------------  NOP  --------------------------
* Written by :  Lucy Chi
* Date       :  11/04/2020
* Description:  Op-code: NOP
*-----------------------------------------------------------  

                    MOVE.L      #%0100111001110001,A0   ; Testing info
 

*-------------------------  Display NOP  ---------------------------------
OP_NOP              LEA         NOP_Output,A1           ; Display 'NOP' 
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                    
                    LEA         Next_Line,A1            ; Go to next line
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                    
*----------------------  End of NOP  ----------------------------
*Performs no operation
*-----------------------------------------------------------------

*-------------------------  RTS  --------------------------
* Written by :  Lucy Chi
* Date       :  11/07/2020
* Description:  Op-code: RTS
*-----------------------------------------------------------  

                    MOVE.L      #%0100111001110101,A0    ; Testing info 
 

*-------------------------  Display RTS  ---------------------------------
OP_RTS              LEA         RTS_Output,A1           ; Display 'RTS' 
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                    
                    LEA         Next_Line,A1            ; Go to next line
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                    
                    RTS                                 ; return 
                    
*----------------------  End of RTS  ----------------------------
*Performs no operation
*-----------------------------------------------------------------
                   
                    
                    

*------------------------  LEA  ----------------------------------
* Written by :  Anna Jennings
* Date       :  11/5/2020
* Description:  Prints the LEA EA
*-----------------------------------------------------------------





*---------------------  Next OP-Code  -----------------------



*------------------------------------------------------------                    

                    SIMHALT                             ; halt simulator
                    
*--------------------- EQUs ----------------------------------------

CR              EQU     $0D                 
LF              EQU     $0A 
                  
                    
*---------------------  Global Variables and Functions -----------------------------------                    

Invalid_Ins_Output  DC.W        'Invalid Instruction',0
MOVE_Output         DC.W        'MOVE',0
Output_Byte         DC.W        '.B     ',0
Output_Word         DC.W        '.W     ',0
Output_Long         DC.W        '.L     ',0
NOP_Output          DC.W        'NOP',0
RTS_Output          DC.W        'RTS',0

Next_Line           DC.W        CR,LF,0
 

Invalid_Instruction 
                    LEA         Invalid_Ins_Output,A1   ; Displaying the Invalid instruction message
                    MOVE.B      #14,D0                  ; Loading the invalid input message into D0
                    TRAP        #15
                    SIMHALT                             ; stop code if failed input
                        
                    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
