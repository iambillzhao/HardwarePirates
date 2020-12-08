*-------------------------  OP-Codes  ----------------------
* Written by :  Anna Jennings, Lucy Chi
* Date       :  10/30/2020
* Description:  Handles all required Op-codes
*-----------------------------------------------------------




*-------------------------  MOVE  --------------------------
* Written by :  Anna Jennings
* Date       :  10/30/2020
* Description:  Prints the MOVE EA
*-----------------------------------------------------------
                   
*--------------------  MOVE: Instruction Check  ------------
OP_MOVE             CLR         D4
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on
                    AND.L       #%0000000000111000,D4   ; clearing all bits except Source Mode
                    LSR.L       #3,D4                   ; stores source mode in D4
                    
                    BRA         MOVE_Source_Check       ; branches to check the source mode

                    CLR         D4
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on               
                    AND.L       #%0011000000000000,D4   ; clear all bits except the size     
                    LSR.L       #8,D4                   ; access the size element of the instruction, do this by shifting the number the right 12 bits                    
                    LSR.L       #4,D4
                    
                    BRA         MOVE_Size_Check              ; check proper size                   
                
*----------------------  MOVE: Display MOVE -----------------
MOVE_Dis            LEA         MOVE_Output,A1          ; Display 'MOVE' 
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
                    
                    *BRA         Invalid_Instruction     ; branches if the size data isn't properly formatted

MOVE_Dest_Reg       CLR         D4
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on

*----------------------  MOVE: Get Source  -------------------
                    AND.L       #%0000000000111000,D4   ; clearing all bits except Source Mode
                    LSR.L       #3,D4                   ; stores source mode in D4

                    MOVE.L      A0,D5                   
                    AND.L       #%0000000000000111,D5   ; clears all bits except source registration and stores it in D5                 
                    
                    JSR         EA_DECODE               ; send to the EA with D4 holding the Destination and D5 holding Source

                    LEA         Comma,A1                ; prints a comma
                    MOVE.B      #14,D0
                    TRAP        #15
                    
*----------------------  MOVE: Get Destination  --------------
                    CLR         D4
                    MOVE.L      A0,D4               

                    AND.L       #%0000111000000000,D4   ; clear all bits except the Destination Register 
                    MOVE.L      #9,D1                    
                    LSR.L       D1,D4                   ; access the destination register

                    MOVE.W      D4,D5                   ; stores destination register in D5
                    
                    CLR         D4
                    MOVE.L      A0,D4

                    AND.L       #%0000000111000000,D4   ; clearing all bits except Destination Mode
                    LSR.L       #6,D4                   ; stores destination mode in D4

*----------------------  MOVE: Send to EA  -------------------

                    JSR         EA_DECODE               ; send to the EA with D4 holding the Destination and D5 holding Source  
                    RTS
*----------------------  MOVE: Functions  --------------------

MOVE_Byte           LEA         Output_Byte,A1          ; Display '.B' for MOVE size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output

                    BRA         MOVE_Dest_Reg           ; return to code

                    
MOVE_Word           LEA         Output_Word,A1          ; Display '.W' for MOVE size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                   
                    BRA         MOVE_Dest_Reg           ; return to code
 
MOVE_Long           LEA         Output_Long,A1          ; Display '.L' for MOVE size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output

                    BRA         MOVE_Dest_Reg           ; return to code
                    
MOVE_Source_Check   CMP.L       #%001,D4                ; an invalid input
                    BEQ         Invalid_Instruction     ; moves on to next instruction                    
                    BRA         MOVE_Dis                ; move to check next part of instruction

MOVE_Size_Check     CMP.B       #%00,D4
                    BEQ         Invalid_Instruction
                    BRA         MOVE_Dis

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
                    
                    RTS
*----------------------  End of NOP  ----------------------------
*Performs no operation
*-----------------------------------------------------------------



*-------------------------  RTS  --------------------------
* Written by :  Lucy Chi
* Date       :  11/07/2020
* Description:  Op-code: RTS
*-----------------------------------------------------------  

 

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

*----------------------  LEA: Instruction check  -----------------
OP_LEA              CLR         D4
                    MOVE.L      A0,D4
                    AND.L       #%0000000000111000,D4   ; clearing all bits except Source Mode
                    LSR.L       #3,D4                   ; stores source mode in D4
                    BRA         LEA_Mode_Check


*------------------------  LEA: Diplay LEA  ----------------------
LEA_Dis             LEA         LEA_Output,A1           ; Display 'LEA'
                    MOVE.B      #14,D0                  ; trap rask 14 is loaded into D0
                    TRAP        #15                     ; trap 15 is for output
                      
                      
*------------------------  LEA: Get Register  --------------------                      
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on               
                    AND.L       #%0000111000000000,D4   ; clear all bits except the register     
                    LSR.L       #8,D4                   ; access the size element of the instruction, do this by shifting the number the right 9 bits 
                    LSR.L       #1,D4
                    
                    CMP.B       #8,D4                   ; checking to make sure the register number is less than 8, and greater than 0
                    BGE         Invalid_Instruction     ; branch if greater than or equal to 8
                    CMP.B       #0,D4
                    BLT         Invalid_Instruction     ; branch if less than 0
                    
                    MOVE.L      D4,D7                   ; copying the register number into D5
                    CLR         D4
                    
*-----------------------  LEA: Get Effective Address  -------------
                    CLR         D4
                    MOVE.L      A0,D4
                    AND.L       #%0000000000111000,D4   ; clearing all bits except Source Mode
                    LSR.L       #3,D4                   ; stores source mode in D4

                    MOVE.L      A0,D5                   
                    AND.L       #%0000000000000111,D5   ; clears all bits except source registration and stores it in D5                 
                    
                    JSR         EA_DECODE               ; send to the EA with D4 holding the Destination and D5 holding Source
                    CLR         D4
                    CLR         D5

                    LEA         Comma,A1                ; prints a comma
                    MOVE.B      #14,D0
                    TRAP        #15

                    MOVE.L      #1,D4                   ; sets the mode to 001
                    MOVE.L      D7,D5                   ; moves the registration bits to D5
                    CLR         D7
                   

*----------------------  LEA: Send to EA  --------------------------
                    JSR         EA_DECODE 
                    RTS                                  ; Send to the EA with D5 holding the register number, and D6 holding the effective address
                    
*----------------------  LEA: Functions  ---------------------------
LEA_Mode_Check      CMP.W       #%000,D4
                    BEQ         Invalid_Instruction
                    CMP.W       #%001,D4
                    BEQ         Invalid_Instruction
                    CMP.W       #%011,D4
                    BEQ         Invalid_Instruction
                    CMP.W       #%100,D4
                    BEQ         Invalid_Instruction
                    BRA         LEA_Dis
                    
*---------------------  End of LEA  --------------------------------
*LEA has been printed 
*D5 holds the register number
*D6 holds the effective address (mode,register)
*-------------------------------------------------------------------       


*------------------------  ADD  ----------------------------------
* Written by :  Lexun Chi
* Date       :  11/23/2020
* Description:  ADD op-code
*-----------------------------------------------------------------

*------------------------  ADD: Diplay ADD  ----------------------
OP_ADD              LEA         ADD_Output,A1           ; Display 'ADD'
                    MOVE.B      #14,D0                  ; trap rask 14 is loaded into D0
                    TRAP        #15                     ; trap 15 is for output
*                    TRAP        #15
      
                    MOVE.L      A0,D4                   ; move the data from A0 and load it into D4 to be worked on  
                    AND.L       #%0000000100000000,D4   ; Clear all bits except for Bit 8
                    LSR.L       #8,D4                   ; access Bit 8, do this by shifting the number the right 8 bits
                    
                    CMP.B       #%00,D4                 ; Bit 8 = 0
                    BEQ         ADD_DN                   
                    
                    CMP.B       #%01,D4                 ; Bit 8 = 1
                    BEQ         ADD_EA
                    
*--------------------- ADD <ea> + Dn --> Dn  ----------------------------------
ADD_DN              MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on  

                    MOVE.B      #10,D0                  ; Prepare a shift of 10 bits
                    LSL.W       D0,D7                   ; Cut up to bit 5
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits
                    
                    MOVE.W      D7,SRC_MODE             ; Copy bits to decode source mode
                    MOVE.W      D7,D4                   ; Copy bits to decode source mode  

                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on 
                    MOVE.B      #13,D0                  ; Prepare a shift of 12 bits
                    LSL.W       D0,D7                   ; Cut up to bit 2
                    LSR.W       D0,D7                   ; Isolate the remainder bits
                
                    MOVE.W      D7,SRC_REGISTER         ; Copy bits to decode source register
                    MOVE.W      D7,D5         ; Copy bits to decode source register
                    
                    JSR         EA_DECODE

                    LEA         Comma,A1                ; prints a comma
                    MOVE.B      #14,D0
                    TRAP        #15
                    
                    MOVE.W      #0,DEST_MODE            ; Force Dn dest mode
                    MOVE.W      #0,D4                   ; Force Dn dest mode
                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on 
                    LSL.W       #4,D7                   ; Cut up to bit 11
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits
                    
                    MOVE.W      D7,DEST_REGISTER        ; Copy bits to decode destination register
                    MOVE.W      D7,D5                   ; Copy bits to decode destination register

                    JSR         EA_DECODE
                    RTS

*--------------------- ADD Dn + <ea> --> <ea>  ----------------------------------
ADD_EA              MOVE.W      #0,SRC_MODE             ; Force Dn source mode
                    MOVE.W      #0,D4
                    
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on  
                    LSL.W       #4,D7                   ; Cut up to bit 11
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits

                    MOVE.W      D7,SRC_REGISTER         ; Copy bits to decode source register
                    MOVE.W      D7,D5
                    
                    JSR         EA_DECODE

                    LEA         Comma,A1                ; prints a comma
                    MOVE.B      #14,D0
                    TRAP        #15
                                    
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on   
                    MOVE.B      #10,D0                  ; Prepare a shift of 10 bits
                    LSL.W       D0,D7                   ; Cut up to bit 5
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits

                    MOVE.W      D7,DEST_MODE            ; Copy bits to decode destination mode
                    MOVE.W      D7,D4                    
                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on 
                    MOVE.B      #13,D0                  ; Prepare a shift of 12 bits
                    LSL.W       D0,D7                   ; Cut up to bit 2
                    LSR.W       D0,D7                   ; Isolate the remainder bits            
                    
                    MOVE.W      D7,DEST_REGISTER        ; Copy bits to decode destination register
                    MOVE.W      D7,D5
                    
                    JSR         EA_DECODE
                    RTS
                    
*---------------------  End of ADD  --------------------------------
*ADD has been printed 
*SRC_MODE,SRC_REGISTER,DEST_MODE,DEST_REGISTER hold the corresponding data
*------------------------------------------------------------------- 


*------------------------  SUB  ----------------------------------
* Written by :  Lexun Chi
* Date       :  11/27/2020
* Description:  SUB op-code
*-----------------------------------------------------------------


*------------------------  SUB: Diplay SUB  ----------------------
OP_SUB              LEA         SUB_Output,A1           ; Display 'SUB'
                    MOVE.B      #14,D0                  ; trap rask 14 is loaded into D0
                    TRAP        #15                     ; trap 15 is for output
                    
                    MOVE.L      A0,D4                   ; move the data from A0 and load it into D4 to be worked on  
                    AND.L       #%0000000100000000,D4   ; Clear all bits except for Bit 8
                    LSR.L       #8,D4                   ; access Bit 8, do this by shifting the number the right 8 bits
                    
                    CMP.B       #%00,D4                 ; Bit 8 = 0
                    BEQ         SUB_DN                   
                    
                    CMP.B       #%01,D4                 ; Bit 8 = 1
                    BEQ         SUB_EA

*------------------------ SUB Dn - <ea> --> Dn  --------------------------
SUB_DN              MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on  

                    MOVE.B      #10,D0                  ; Prepare a shift of 10 bits
                    LSL.W       D0,D7                   ; Cut up to bit 5
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits
                    
                    MOVE.W      D7,SRC_MODE             ; Copy bits to decode source mode
                    MOVE.W      D7,D4
                    
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on 
                    MOVE.B      #13,D0                  ; Prepare a shift of 12 bits
                    LSL.W       D0,D7                   ; Cut up to bit 2
                    LSR.W       D0,D7                   ; Isolate the remainder bits
                
                    MOVE.W      D7,SRC_REGISTER         ; Copy bits to decode source register
                    MOVE.W      D7,D5
                    
                    JSR         EA_DECODE

                    LEA         Comma,A1                ; prints a comma
                    MOVE.B      #14,D0
                    TRAP        #15
                
                    MOVE.W      #0,DEST_MODE            ; Force Dn dest mode
                    MOVE.W      #0,D4
                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on 
                    LSL.W       #4,D7                   ; Cut up to bit 11
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits
                    
                    MOVE.W      D7,DEST_REGISTER        ; Copy bits to decode destination register
                    MOVE.W      D7,D5

*                    BRA         EA_SUB                  ; send to the EA with SRC_MODE,SRC_REGISTER,DEST_MODE,DEST_REGISTER holding the data 
                    JSR         EA_DECODE
                    RTS
       
*----------------------- SUB Dn + <ea> --> <ea> ----------------------------------
SUB_EA              MOVE.W      #0,SRC_MODE             ; Force Dn source mode
                    MOVE.W      #0,D4
                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on  
                    LSL.W       #4,D7                   ; Cut up to bit 11
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits

                    MOVE.W      D7,SRC_REGISTER         ; Copy bits to decode source register
                    MOVE.W      D7,D5
                
                    JSR         EA_DECODE
                    
                    LEA         Comma,A1                ; prints a comma
                    MOVE.B      #14,D0
                    TRAP        #15
                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on   
                    MOVE.B      #10,D0                  ; Prepare a shift of 10 bits
                    LSL.W       D0,D7                   ; Cut up to bit 5
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits

                    MOVE.W      D7,DEST_MODE            ; Copy bits to decode destination mode
                    MOVE.W      D7,D4
                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on 
                    MOVE.B      #13,D0                  ; Prepare a shift of 12 bits
                    LSL.W       D0,D7                   ; Cut up to bit 2
                    LSR.W       D0,D7                   ; Isolate the remainder bits            
                    
                    MOVE.W      D7,DEST_REGISTER        ; Copy bits to decode destination register
                    MOVE.W      D7,D5
                    
*                    BRA         EA_SUB                  ; send to the EA with SRC_MODE,SRC_REGISTER,DEST_MODE,DEST_REGISTER holding the data
                    JSR         EA_DECODE
                    RTS

*---------------------  End of SUB  --------------------------------
*SUB has been printed 
*SRC_MODE,SRC_REGISTER,DEST_MODE,DEST_REGISTER hold the corresponding data
*------------------------------------------------------------------- 



*------------------------  MULS  ----------------------------------
* Written by :  Lexun Chi
* Date       :  11/29/2020
* Description:  MULS op-code
*-----------------------------------------------------------------

*------------------------  MULS: Diplay MULS  ----------------------                    
OP_MULS             LEA         MULS_Output,A1          ; Display 'MULS'
                    MOVE.B      #14,D0                  ; trap rask 14 is loaded into D0
                    TRAP        #15                     ; trap 15 is for output
                    
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on
                    MOVE.B      #10,D0                  ; Prepare a shift of 10 bits
                    LSL.W       D0,D7                   ; Cut up to bit 5
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits    
                    MOVE.W      D7,SRC_MODE             ; Copy bits to src dest mode
                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on 
                    MOVE.B      #13,D0                  ; Prepare a shift of 12 bits
                    LSL.W       D0,D7                   ; Cut up to bit 2
                    LSR.W       D0,D7                   ; Isolate the remainder bits         
                    MOVE.W      D7,SRC_REGISTER         ; Copy bits to src dest register
                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on  
                    LSL.W       #4,D7                   ; Cut up to bit 11
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits       
                    MOVE.W      #0,DEST_MODE            ; Force Dn dest mode
                    MOVE.W      D7,DEST_REGISTER        ; Copy bits to decode dest register
                    
                   
                    BRA         EA_MULS                 ; send to the EA with SRC_MODE,SRC_REGISTER,DEST_MODE,DEST_REGISTER holding the data
                    
*---------------------  End of MULS --------------------------------
*MULS has been printed 
*SRC_MODE,SRC_REGISTER,DEST_MODE,DEST_REGISTER hold the corresponding data
*------------------------------------------------------------------- 
                   

*------------------------  JSR  ----------------------------------
* Written by :  Anna Jennings
* Date       :  11/24/2020
* Description:  Prints JSR EA
*-----------------------------------------------------------------

*---------------------  JSR: Instuction Checks  ------------------
OP_JSR              CLR         D4                      ; Clearing D4
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on
                    AND.L       #%0000000000111000,D4   ; clear all bits expect the effective address's mode
                    LSR.L       #3,D4                   ; isolate the mode bits
                    
                    BRA         JSR_Mode_Check
                       
*----------------------- JSR: Display  ---------------------------
JSR_Dis             LEA         JSR_Output,A1           ; Display 'JSR' 
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
               
              
*-------------------  JSR: Effective Address  --------------------
                    CLR         D4                      ; Clearing D4
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on
                    AND.L       #%0000000000111111,D4   ; clear all bits expect the effective address
                    
*-------------------  JSR: Send to EA  ---------------------------                    
                    JSR         EA_DECODE               ; move to EA with D4 holding the effective address (mode, register)


*------------------- JSR: Functions  -----------------------------
JSR_Mode_Check      CMP.W       #%000,D4
                    BEQ         Invalid_Instruction
                    CMP.W       #%001,D4
                    BEQ         Invalid_Instruction
                    CMP.W       #%011,D4
                    BEQ         Invalid_Instruction
                    CMP.W       #%100,D4
                    BEQ         Invalid_Instruction
                    BRA         JSR_Dis

*----------------------  End of JSR  -----------------------------
*JSR has been printed
*D4 holds the effective address (mode, register)
*-----------------------------------------------------------------



*------------------------  NOT  ----------------------------------
* Written by :  Anna Jennings
* Date       :  11/24/2020
* Description:  Prints NOT EA
*-----------------------------------------------------------------
*---------------------- NOT: Instruction Check  ------------------
OP_NOT              CLR         D4                      ; clearing D4
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on
                    AND.L       #%0000000000111000,D4   ; clear all bits except the effective address mode
                    LSR.L       #3,D4                   ; isolate the mode
                    
                    BRA         NOT_Mode_Check
                    
NOT_SC              MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on               
                    AND.L       #%0000000011000000,D4   ; clear all bits except the size     
                    LSR.L       #6,D4                   ; access the size element of the instruction, do this by shifting the number the right 12 bits   
                    
                    BRA         NOT_Size_Check
                    
*----------------------  NOT: Display ----------------------------
NOT_Dis             LEA         NOT_Output,A1           ; Display 'NOT' 
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output 
                   
*-----------------------  NOT: Get Size  -------------------------
NOT_OP              MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on               
                    AND.L       #%0000000011000000,D4   ; clear all bits except the size     
                    LSR.L       #6,D4                   ; access the size element of the instruction, do this by shifting the number the right 12 bits                                     
                                   
                    CMP.B       #%00,D4                 ; checking if the size is byte
                    BEQ         NOT_Byte                ; branch to the byte condition

                    CMP.B       #%01,D4                 ; checking if the size is Word  
                    BEQ         NOT_Word                ; branch to Word condition

                    CMP.B       #%10,D4                 ; checking if the size is Long
                    BEQ         NOT_Long                ; Branch to Long Condition
                             

*----------------------  NOT: Effective Address  ----------------
NOT_Effective_Add   CLR         D4                      ; clearing D4
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on
                    AND.L       #%0000000000111111,D4   ; clear all bits except the effective address
                    
                    JSR         EA_DECODE               ; send to EA with D4 holding the effective address (mode,register)


*-----------------------  NOT: Functions  ------------------------      
NOT_Byte            LEA         Output_Byte,A1          ; Display '.B' for MOVE size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output

                    BRA         NOT_Effective_Add       ; return to code

                    
NOT_Word            LEA         Output_Word,A1          ; Display '.W' for MOVE size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                   
                    BRA         NOT_Effective_Add       ; return to code
 
NOT_Long            LEA         Output_Long,A1          ; Display '.L' for MOVE size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output

                    BRA         NOT_Effective_Add       ; return to code
                    
NOT_Mode_Check      CMP.W       #%001,D4                ; invalid mode data
                    BEQ         Invalid_Instruction 
                    BRA         NOT_SC   

NOT_Size_Check      CMP.B       #%11,D4                 ; invalid size
                    BEQ         Invalid_Instruction
                    BRA         NOT_Dis
                    
*----------------------  End of NOT  -----------------------------
*NOT and size have been printed
*D4 holds the effective address (mode, register)
*-----------------------------------------------------------------
                    

*------------------------  AND  ----------------------------------
* Written by :  Lexun Chi
* Date       :  12/2/2020
* Description:  AND op-code
*-----------------------------------------------------------------

*                    MOVE.L      #%1100000100010000,A0   ; Testing Info

*------------------------  AND: Diplay AND  ----------------------     
OP_AND              LEA         AND_Output,A1           ; Display 'AND' 
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output  
                    
                    MOVE.L      A0,D4                   ; move the data from A0 and load it into D4 to be worked on  
                    AND.L       #%0000000100000000,D4   ; Clear all bits except for Bit 8
                    LSR.L       #8,D4                   ; access Bit 8, do this by shifting the number the right 8 bits
                    
                    CMP.B       #%00,D4                 ; Bit 8 = 0
                    BEQ         AND_DN                   
                    
                    CMP.B       #%01,D4                 ; Bit 8 = 1
                    BEQ         AND_EA
                    
*--------------------- AND <ea> + Dn --> Dn  ----------------------------------
AND_DN              MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on 

                    MOVE.B      #10,D0                  ; Prepare a shift of 10 bits
                    LSL.W       D0,D7                   ; Cut up to bit 5
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits
                    
                    MOVE.W      D7,SRC_MODE             ; Copy bits to decode source mode
                    MOVE.W      D7,D4
                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on 
                    MOVE.B      #13,D0                  ; Prepare a shift of 12 bits
                    LSL.W       D0,D7                   ; Cut up to bit 2
                    LSR.W       D0,D7                   ; Isolate the remainder bits
                
                    MOVE.W      D7,SRC_REGISTER         ; Copy bits to decode source register
                    MOVE.W      D7,D5
                    
                    JSR         EA_DECODE

                    LEA         Comma,A1                ; prints a comma
                    MOVE.B      #14,D0
                    TRAP        #15
                    
                    MOVE.W      #0,DEST_MODE            ; Force Dn dest mode
                    MOVE.W      #0,D4
                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on 
                    LSL.W       #4,D7                   ; Cut up to bit 11
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits
                    
                    MOVE.W      D7,DEST_REGISTER        ; Copy bits to decode destination register
                    MOVE.W      D7,D5
                    
                    JSR         EA_DECODE
                    RTS

*                    BRA         EA_AND                  ; send to the EA with SRC_MODE,SRC_REGISTER,DEST_MODE,DEST_REGISTER holding the data 

*--------------------- AND Dn + <ea> --> <ea>  ----------------------------------
AND_EA              MOVE.W      #0,SRC_MODE             ; Force Dn source mode
                    MOVE.W      #0,D4
                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on  
                    LSL.W       #4,D7                   ; Cut up to bit 11
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits

                    MOVE.W      D7,SRC_REGISTER         ; Copy bits to decode source register
                    MOVE.W      D7,D5
                    
                    JSR         EA_DECODE
                    
                    LEA         Comma,A1                ; prints a comma
                    MOVE.B      #14,D0
                    TRAP        #15
                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on   
                    MOVE.B      #10,D0                  ; Prepare a shift of 10 bits
                    LSL.W       D0,D7                   ; Cut up to bit 5
                    MOVE.B      #13,D0                  ; Prepare a shift of 13 bits
                    LSR.W       D0,D7                   ; Isolate the remainder bits

                    MOVE.W      D7,DEST_MODE            ; Copy bits to decode destination mode
                    MOVE.W      D7,D4
                
                    MOVE.W      A0,D7                   ; move the data from A0 and load it into D7 to be worked on 
                    MOVE.B      #13,D0                  ; Prepare a shift of 12 bits
                    LSL.W       D0,D7                   ; Cut up to bit 2
                    LSR.W       D0,D7                   ; Isolate the remainder bits            
                    
                    MOVE.W      D7,DEST_REGISTER        ; Copy bits to decode destination register
                    MOVE.W      D7,D5
                    
*                    BRA         EA_AND                  ; send to the EA with SRC_MODE,SRC_REGISTER,DEST_MODE,DEST_REGISTER holding the data
                    JSR         EA_DECODE
                    RTS
                    
*---------------------  End of AND  --------------------------------
*AND has been printed 
*SRC_MODE,SRC_REGISTER,DEST_MODE,DEST_REGISTER hold the corresponding data
*------------------------------------------------------------------- 


*-------------------------  Shift (LSL, ASR)  --------------------------
* Written by :  Anna Jennings
* Date       :  11/27/2020
* Description:  Prints the Shift EA
*-----------------------------------------------------------

*--------------------  Shift: Instruction Checks  -----------
OP_Shift            MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on               
                    AND.L       #%0000000011000000,D4   ; clear all bits except the size     
                    LSR.L       #6,D4                   ; access the size element of the instruction, do this by shifting the number the right 12 bits
                    
                    BRA         SHIFT_Size_Check

*---------------------  Display Shift Type  -----------------
SHIFT_Dis           MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on
                    AND.L       #%0000000000011000,D4   ; clear all bits except the shift type     
                    LSR.L       #8,D4                   ; access the registers elements of the instruction, do this by shifting the number the right 9 bits
                    LSR.L       #1,D4
                    
                    CMP.B       #%01,D4                 ; checking to see if LS 
                    BRA         LS_Display              ; branch if LS
                    
                    CMP.B       #%00,D4                 ; checking to if AS
                    BRA         AS_Display              ; branch if AS
                    
                    BRA         Invalid_Instruction     ; invailid insruction and move on
                    
*-------------------- LSL: Direction Check  ----------------
Shift_Dir           MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on               
                    AND.L       #%0000000100000000,D4   ; clear all bits except the direction bit     
                    LSR.L       #8,D4                   ; access the direction element of the instruction, do this by shifting the number the right 8 bits
                    
                    CMP.B       #%1,D4                  ; if the bit is a 1 the direction is left 
                    BRA         Left_Dir_Output
                    
                    CMP.B       #%0,D4                  ; if the bit is a 0 the direction is right                   
                    BRA         Right_Dir_Output        ; branch if right direction
                   

*----------------  Shift: Get Register/Count  -------------
Shift_Reg           CLR         D4                      ; clearing D4
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on
                    AND.L       #%0000111000000000,D4   ; clear all bits except the register     
                    LSR.L       #8,D4                   ; access the registers elements of the instruction, do this by shifting the number the right 9 bits
                    LSR.L       #1,D4
       
                    MOVE.L      D4,D5                   ; storing the register/count in D5
                    CLR         D4                      ; clearing D4 
                    
*-----------------  Shift: Get Size  -----------------------
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on               
                    AND.L       #%0000000011000000,D4   ; clear all bits except the size     
                    LSR.L       #6,D4                   ; access the size element of the instruction, do this by shifting the number the right 12 bits                                     
                                   
                    CMP.B       #%00,D4                 ; checking if the size is byte
                    BEQ         Shift_Byte              ; branch to the byte condition

                    CMP.B       #%01,D4                 ; checking if the size is Word  
                    BEQ         Shift_Word              ; branch to Word condition

                    CMP.B       #%10,D4                 ; checking if the size is Long
                    BEQ         Shift_Long              ; Branch to Long Condition   
                 
*-----------------  Shift: Get I/R  ------------------------
Shift_IR            MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on
                    AND.L       #%0000000000100000,D4   ; clear all bits except the i/r
                    LSR.L       #5,D4                   ; access the i/r elememt, by shifting 5 places to the right

                    MOVE.B      D4,D6                   ; move the i/r to D6 to be used by ea
                    JSR         EA_DECODE               ; send to EA with D5 holding the count/register, and D6 holding the i/r
   

*--------------------  LSL: Functions  ---------------------
LS_Display          LEA         LS_Output,A1            ; Display 'LS' 
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                    
                    BRA         Shift_Dir
  
AS_Display          LEA         AS_Output,A1            ; Display 'AS' 
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                    
                    BRA         Shift_Dir
                    
Left_Dir_Output     LEA         L_Output,A1             ; Display 'L' 
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15
                    
                    BRA         Shift_Reg 
   
Right_Dir_Output    LEA         R_Output,A1             ; Display 'R' 
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15
                    
                    BRA         Shift_Reg                 
                  
Shift_Byte          LEA         Output_Byte,A1          ; Display '.B' for LSL size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output

                    BRA         Shift_IR                ; return to code

                    
Shift_Word          LEA         Output_Word,A1          ; Display '.W' for LSL size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                   
                    BRA         Shift_IR                ; return to code
 
Shift_Long          LEA         Output_Long,A1          ; Display '.L' for LSL size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output

                    BRA         Shift_IR                ; return to code
                    
SHIFT_Size_Check    CMP.W       #%11,D4                 ; invalid size
                    BEQ         Invlaid_Instruction     
                    BRA         SHIFT_Dis


*----------------------  End of Shift  -----------------------------
*AS* or LS* printed with the appropriate direction of shift
*printed instruciton size 
*D5 holds the count/register depending on i/r
*D6 holds i/r bit to determine whether count or register
*----------------------------------------------------------------- 




*-------------------------  MOVEM  -------------------------
* Written by :  Anna Jennings
* Date       :  12/1/2020
* Description:  Prints the MOVEM EA
*----------------------------------------------------------- 

*----------------  MOVEM: Instuction Checks  ---------------
OP_MOVEM            MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on 
                    AND.L       #%0000000000111000,D4   ; isolate mode bits
                    LSR.L       #3,D4                   ; move mode bits to msb 
                    
                    BRA         MOVEM_Mode_Check 


*----------------  MOVEM: Display MOVEM  -------------------
MOVEM_Dis           LEA         MOVEM_Output,A1         ; Display 'MOVEM' 
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                    
*---------------  MOVEM: Get size  -------------------------
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on 
                    AND.L       #%0000000001000000,D4   ; isolate size bit
                    LSR.L       #6,D4                   ; move size bit to msb
                    
                    CMP.B       #%0,D4                  ; checking if the size is word
                    BEQ         MOVEM_Word              ; branch to word output       

                    CMP.B       #%1,D4                  ; checking if the size is long
                    BEQ         MOVEM_Long              ; branch to word output                     

*--------------  MOVEM: Direction  -------------------------
MOVEM_Dir           CLR         D4                      ; clears D4
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on
                    AND.L       #%0000010000000000,D4   ; isolate direction bit for EA
                    LSR.L       #8,D4                   ; shift bits to isolate the direction bit
                    LSR.L       #2,D4                   
                    MOVE.L      D4,D5                   ; store direction bit in D5
                    
*---------------  MOVEM: Effective Address  ----------------                    
                    CLR         D4                      ; clears D4
                    MOVE.L      A0,D4                   ; move the data from A0 (the instruction) and load it into D4 to be worked on
                    AND.L       #%0000000000111111,D4   ; isolate the effective address

                    JSR         EA_DECODE               ; send to EA with D5 with direction bit and D4 with effective address (mode, register)

*-------------- MOVEM: Functions  --------------------------
MOVEM_Word          LEA         Output_Word,A1          ; Display '.W' for MOVEM size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                   
                    BRA         MOVEM_Dir               ; return to code

MOVEM_Long          LEA         Output_Long,A1          ; Display '.L' for MOVEM size
                    MOVE.B      #14,D0                  ; trap task 14 is loaded into D0
                    TRAP        #15                     ; task 15 for output
                   
                    BRA         MOVEM_Dir               ; return to code
                    
MOVEM_Mode_Check    CMP.W       #%000,D4            
                    BEQ         Invailid_Instruction
                    CMP.W       #%001,D4
                    BEQ         Invalid_Instuction
                    CMP.W       #%011,D4
                    BEQ         Invalid_Instruction
                    BRA         MOVEM_Dis
                    
                    
*----------------------  End of MOVEM  ----------------------------
*Movem and its size have been printed
*D4 holds the effective address (mode, register)
*D5 holds the direction bit
*-----------------------------------------------------------------         




*------------------------  Branch Group  -------------------
* Written by :  Anna Jennings
* Date       :  11/16/2020
* Description:  Prints BRA, BCC, BLT, BGE, or BEQ
*-----------------------------------------------------------


                
*--------------- Branch: Get Branch Type  -----------------           

OP_Branch           MOVE.L      A0,D4                   ; move instruction from A0 to D4 to be worked on
                    AND.L       #%0000111100000000,D4   ; Isolate Branch type 
                    LSR.L       #8,D4                   ; rotate bits to isolate branch type in msb

*---------------  Branch: Display Type  -------------------
                
                    CMP.L       #%0000000000000000,D4   ; checking if BRA
                    BEQ         BRA_Message             ; branch to print out BRA
                
                    CMP.L       #%0000000000001101,D4   ; checking if BLT
                    BEQ         BLT_Message             ; branch to print out BLT
                
                    CMP.L       #%0000000000001100,D4   ; checking if BGE
                    BEQ         BGE_Message             ; branch to print out BGE
                
                    CMP.L       #%0000000000000111,D4   ; checking if BEQ
                    BEQ         BEQ_Message             ; branch to print out BEQ
                
                    BRA         Invalid_Instruction     ; branch if invalid instruction
                
*---------------  Branch: Functions  ---------------------
BRA_Message         LEA         BRA_Output,A1           ; loading BRA message into A1
                    MOVE.B      #14,D0                  ; trap task 14 loadinto D0
                    TRAP        #15                     ; output BRA
                
                    *BRA         EA_Branch               ; finish op-code
                
BLT_Message         LEA         BLT_Output,A1           ; loading BRA message into A1
                    MOVE.B      #14,D0                  ; trap task 14 loadinto D0
                    TRAP        #15                     ; output BRA
                
                    *BRA         EA_Branch               ; finish op-code   

BGE_Message         LEA         BGE_Output,A1           ; loading BRA message into A1
                    MOVE.B      #14,D0                  ; trap task 14 loadinto D0
                    TRAP        #15                     ; output BRA
                
                    *BRA         EA_Branch               ; finish op-code    

BEQ_Message         LEA         BEQ_Output,A1           ; loading BRA message into A1
                    MOVE.B      #14,D0                  ; trap task 14 loadinto D0
                    TRAP        #15                     ; output BRA
                
*                    BRA         EA_Branch               ; finish op-code
                    
                
*------------------ End of Branch  -------------------------
*The branch condition has been printed to the screen
*no remaining data is stored
*-----------------------------------------------------------




                    SIMHALT                             ; halt simulator
                    
*--------------------- EQUs ----------------------------------------

CR              EQU     $0D                 
LF              EQU     $0A 
                  
                    
*---------------------  Global Variables and Functions -----------------------------------                    

Invalid_Ins_Output  DC.W        'Invalid Instruction',0
Output_Byte         DC.W        '.B     ',0
Output_Word         DC.W        '.W     ',0
Output_Long         DC.W        '.L     ',0
MOVE_Output         DC.W        'MOVE',0
MOVEM_Output        DC.W        'MOVEM',0
NOP_Output          DC.W        'NOP',0
LEA_Output          DC.W        'LEA     ',0
ADD_Output          DC.W        'ADD     ',0
AND_Output          DC.W        'AND     ',0
JSR_Output          DC.W        'JSR',0
NOT_Output          DC.W        'NOT',0
RTS_Output          DC.W        'RTS',0
SUB_Output          DC.W        'SUB     ',0
MULS_Output         DC.W        'MULS',0
BRA_Output          DC.W        'BRA  ',0
BLT_Output          DC.W        'BLT  ',0
BGE_Output          DC.W        'BGE  ',0
BEQ_Output          DC.W        'BEQ  ',0
LS_Output           DC.W        'LS',0
AS_Output           DC.W        'AS',0
R_Output            DC.W        'R',0
L_Output            DC.W        'L',0

Next_Line           DC.W        CR,LF,0

Comma               DC.W        ',',0


SRC_MODE            DS.W        1                       ; Storage for the source EA mode type
SRC_REGISTER        DS.W        1                       ; Storage for the source EA register ID  
DEST_MODE           DS.W        1                       ; Storage for the destination EA mode type
DEST_REGISTER       DS.W        1                       ; Storage for the destination EA register ID

  
EA_ADD
EA_SUB
EA_MULS


Invalid_Instruction 
                    LEA         Invalid_Ins_Output,A1   ; Displaying the Invalid instruction message
                    MOVE.B      #14,D0                  ; Loading the invalid input message into D0
                    TRAP        #15
                    BRA         NOW
                                  
                    
                    SIMHALT                             ; stop code if failed input
                        
                    END    START        ; last line of source
















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
