*-----------------------------------------------------------
* Title      : Final Project
* Written by : Anna Jennings, Bill Zhao, Lawrence Fiesta, Lexun Chi
* Date       : Fall 2020
* Description: CSS 422 Disassembler
*-----------------------------------------------------------

    ORG    $1000
    
START:                  ; first instruction of program


*-------------------------  I/O  ---------------------------
* Written by :  Bill Zhao
* Date       :  November 2020
* Description:  Structure implementations and disassembly
*-----------------------------------------------------------


*--------------------  I/O Initialization ------------------
    LEA     WELCOME,A1  ; loads message to A1
    MOVE.B  #14,D0      ; sets to task 14
    TRAP    #15         ; displays welcome message
    BRA     BEG         ; begins catching input


*--------------------- INPUT CATCHING ---------------------- 
BEG: 
    ; CLEAR REGISTERS
    CLR     D0          ; clears register D0
    CLR     D1          ; clears register D1
    CLR     D2          ; clears register D2
    CLR     D3          ; clears register D3
    CLR     D4          ; clears register D4
    CLR     D5          ; clears register D5
    CLR     D6          ; clears register D6
    CLR     D7          ; clears register D7
    
    ; LOAD FIRST MESSAGE, Q TO QUIT
    LEA     INPUTBEG,A1 ; loads message to A1
    MOVE.B  #14,D0      ; sets to task 14
    TRAP    #15         ; displays message and asks for input
    
    ; CATCH INPUT, CONVERT TO ASCII
    MOVE.B  #2,D0       ; sets to task 2
    LEA     SADD,A1     ; loads starting address to A1
    TRAP    #15         ; gets input from the user
    
    ; CHECK FOR VALIDITY, ERROR INVALIDADD IF INVALID
    CMP.W   #$0000,D1   ; compares 0 to D1
    BEQ     INVALIDADD  ; triggers program's invalid branch
    CMP.W   #$0008,D1   ; compares 8 to D1
    BGT     INVALIDADD  ; triggers program's invalid branch
    JSR     BCON        ; loops to convert ASCII to hex
    MOVE.L  D3,A0       ; moves the data of D3 to A0
    MOVE.W  (A0),D0     ; copies the data from A0 to D0
    MOVE.L  D0,A0       ; moves the copied data to A0
    MOVEA.L D3,A5       ; moves temporary address to A5 for start
    MOVE.L  D3,D5       ; moves the value of D3 to D5 for checks
    
    ; ADDRESS CHECKS
    ANDI.B  #1,D2       ; checks if it is odd
    BNE     INVALIDADD  ; invalid if odd, error
    MOVE.L  D3,D2       ; moves starting address to D2
    CLR     D3          ; clears D3 for ending address
    
END:
    ; LOAD FIRST MESSAGE, Q TO QUIT
    LEA     INPUTEND,A1 ; loads message to A1
    MOVE.B  #14,D0      ; sets to task 14
    TRAP    #15         ; displays message and asks for input
    
    ; CATCH INPUT, CONVERT TO ASCII
    MOVE.B  #2,D0       ; sets to task 2
    LEA     EADD,A1     ; loads ending address to A1
    TRAP    #15         ; gets input from the user
    
    ; CHECK FOR VALIDITY, ERROR INVALIDADD IF INVALID
    CMP.W   #$0000,D1   ; compares 0 to D1
    BEQ     INVALIDADD  ; triggers program's invalid branch
    CMP.W   #$0008,D1   ; compares 8 to D1
    BGT     INVALIDADD  ; triggers program's invalid branch
    JSR     BCON        ; loops to convert ASCII to hex
    MOVEA.L D3,A6       ; moves temporary address to A6 for end
    
    ; ADDRESS CHECKS
    ANDI.B  #1,D3       ; checks if it is odd
    BNE     INVALIDADD  ; invalid if odd, error
    CMP.L   D3,D5       ; checks if the ending address is less
    BGT     INVALIDADD  ; ending address is less, invalid
    MOVE.L  A6,D3       ; moves ending address to D3
    
    ; BEGIN DISASSEMBLY PROCESS
    LEA     DISBEG,A1   ; loads message to A1
    MOVE.B  #14,D0      ; sets to task 14
    TRAP    #15         ; displays message
    JSR     NOW         ; continues to disassembly
    BRA     ASK         ; program starts to loop
    

*-------------------- ASCII CONVERSION --------------------- 
BCON:
    ; DETERMINE NUMBER OR LETTER
    CMPI.B  #$0,D1      ; compares length in D1 to 0
    BEQ     BACK        ; if length is 0, go back
    CLR     D0          ; clears D0 for conversion
    MOVE.B  (A1)+,D0    ; increments A1 pointer to D0
    
    ; NUMBER CASE
    CMPI.B  #$39,D0     ; compares with 39
    BLE     NUM         ; < 39 is a number
    
    ; LETTER CASE
    CMPI.B  #$66,D0     ; compares with 66
    BLE     LET         ; > 66 is a letter
    
    ; ADDRESS CHECKS
    BRA     INVALIDADD  ; otherwise, it is invalid

NUM:
    ; NUMBER CONVERSION
    SUBI.B  #$30,D0     ; number to convert directly
    BRA     NEXT        ; next character

LET:
    ; LETTER CONVERSION
    SUBI.B  #$37,D0     ; minus 37 from ASCII
    CMP.B   #$20,D0     ; uppercased to be converted
    BLT     LETCON      ; branches to letter conversion
    SUBI.B  #$20,D0     ; lowercased to uppercased
    BRA     LETCON      ; branches to letter conversion
    
LETCON:
    ; ADDDRESS CHECKS
    CMP.B   #$A,D0      ; compares with A
    BLT     INVALIDADD  ; hex less than A is invalid, error
    CMP.B   #$F,D0      ; compares with F
    BGT     INVALIDADD  ; hex greater than F is invalid, error
    
    ; VALID CHARACTER
    BRA     NEXT        ; next character
    
NEXT:
    ; DECREMENT COUNTER
    ADD.B   D0,D3       ; adds D0 and D3
    SUBI.B  #$1,D1      ; decrements D1 by 1
    
    ; ALL PROCESSED
    CMPI.B  #$0,D1      ; if length is 0
    BEQ     BACK        ; go back to original jsr
    
    ; NEXT CHARACTER
    MOVE.L  #0,D0       ; sets D0 to 0
    ASL.L   #4,D3       ; shifts left 4 of D3
    ADD.B   D0,D3       ; adds D0 and D3
    BRA     BCON        ; next character conversion
    
BACK:
    RTS                 ; rts to go back to original jsr
    
    
*-------------------- DISASSEMBLY --------------------------
NOW:
    ; A0 TO STORE CODE TO DISASSEMBLE
    MOVE.W  A0,D4       ; moves A0 to D4
    CLR     D0          ; clears D0
    
    ; GETS MOST SIGNIFICANT 4 BYTES
    MOVE.B  #12,D0      ; puts 12 in D0
    LSR.W   D0,D4       ; shifts D4 by 12
    MULU    #6,D4       ; gets offset
    
    CMP     D3,D2       ; comapres curr and ending address
    BGT     ASK         ; disassembly completed
    
    ; USE JUMP TABLE OPCODES STORED IN A3
    LEA     OPCODES,A3  ; loads op-code jump table
    JSR     00(A3,D4)   ; jsr using word processes
    BRA     CON         ; jumps to the continue branch

CON:
    LEA     NEXTLINE,A1
    MOVE.B  #14,D0
    TRAP    #15
    ADD.W   #2,D2
    MOVE.L  D2,A0
    MOVE.W  (A0),D0
    MOVE.L  D0,A0    
    BRA     NOW

OPCODES:
    JMP     S00         ; for MOVE
    JMP     S00         ; for MOVE
    JMP     S00         ; for MOVE
    JMP     S00         ; for MOVE
    JMP     S0100       ; for NOT,JSR,RTS,NOP,MOVEM,LEA
    JMP     S0110       ; for BRA,BCC (BLT,BGE,BEQ)
    JMP     SS
    JMP     SS
    JMP     SS
    JMP     S1001       ; for SUB
    JMP     SS          ; for INVALID
    JMP     SS          ; for INVALID
    JMP     S1100       ; for MULS,AND
    JMP     S1101       ; for ADD
    JMP     S1110       ; for SHIFT (LSL,ASR)
    JMP     SS
    
; for MOVE
S00:
    CLR     D4          ; clears data register D4
    BRA     OP_MOVE     ; redirects to MOVE
    
; for NOT,JSR,RTS,NOP,MOVEM,LEA
S0100:
    CLR     D4          ; clears data register D4
    MOVE.L  A0,D4       ; copies from D7 to D4
    CMP.L   #%0100111001110101,D4 ; compares to RTS
    BEQ     OP_RTS      ; redirects to RTS
    CMP.L   #%0100111001110001,D4 ; compares to NOP
    BEQ     OP_NOP      ; redirects to NOP
    ASL.B   #4,D4       ; shifts 4 of D4
    CMP.W   #$1110,D4   ; compares to JSR unique bits
    BEQ     OP_JSR      ; redirects to JSR
    CMP.W   #$0110,D4   ; compares to NOT unique bits
    BEQ     OP_NOT      ; redirects to NOT
    CMP.W   #$1000,D4   ; compares to MOVEM unique bits
    BEQ     OP_MOVEM    ; redirects to MOVEM
    CMP.W   #$1100,D4   ; compares to MOVEM unique bits
    BEQ     OP_MOVEM    ; redirects to MOVEM
    BRA     OP_LEA      ; redirects to LEA otherwise

; for BRA,BCC (BLT,BGE,BEQ)
S0110:
    CLR     D4          ; clears data register D4
    BRA     OP_BRANCH   ; redirects to BRANCH (BRA,BCC)    

; for SUB
S1001:
    CLR     D4          ; clears data register D4
    BRA     OP_SUB      ; redirects to SUB

; for MULS,AND
S1100:  
    CLR     D4          ; clears data register D4
    MOVE.L  D7,D4       ; copies from D7 to D4
    ASL.B   #6,D4       ; shifts by 6 bits
    CMP.W   #$0111,D4   ; compares with MULS unique bits
    BEQ     OP_MULS     ; redirects to MULS
    CMP.W   #$1111,D4   ; compares with MULS unique bits
    BEQ     OP_MULS     ; redirects to MULS
    ; TODO: NOT YET IMPLEMENTED
    BRA     OP_AND      ; redirects to AND otherwise

; for ADD
S1101:
    CLR     D4          ; clears data register D4
    BRA     OP_ADD      ; redirects to ADD

; for SHIFT (LSL,ASR)
S1110:
    CLR     D4          ; clears data register D4
    BRA     OP_SHIFT    ; redirects to SHIFT (ASR,LSL)
    
; for INVALID
SS:
    BRA     Invalid_Instruction ; invalid code


*-------------------- PROGRAM LOOP -------------------------
ASK:
    ; Q TO QUIT PROGRAM, ANY INTEGER TO CONTINUE
    ; ACCEPTS 1 CHARACTER, AUTOMATIC ENTER
    LEA     INPUTCON,A1 ; asks if user wants to loop
    CLR     D0          ; clears D0
    MOVE.B  #14,D0      ; sets to task 14
    TRAP    #15         ; sets to trap 15, display
    MOVE.B  #5,D0       ; sets to task 5
    TRAP    #15         ; sets to trap 15, catch input char
    
    ; QUIT CONDITION
    CMP.B   #'Q',D1     ; if input is Q
    BEQ     BYE         ; aborts program
    BRA     BEG         ; otherwise, loops to the beginning


*-------------------- INVALID ERROR ------------------------ 
INVALIDADD:
    ; DISPLAY INVALID MESSAGE
    LEA     INVALID,A1  ; loads message to A1
    MOVE.B  #14,D0      ; sets to task 14
    TRAP    #15         ; displays message
    
    ; CLEAR REGISTERS
    CLR     D0          ; clears register D0
    CLR     D1          ; clears register D1
    CLR     D2          ; clears register D2
    CLR     D3          ; clears register D3
    CLR     D4          ; clears register D4
    CLR     D5          ; clears register D5
    CLR     D6          ; clears register D6
    CLR     D7          ; clears register D7
    BRA     BEG         ; loop from the program beginning


*-------------------- PROGRAM COMPLETE --------------------- 
BYE:
    ; END OF PROGRAM
    LEA     GOODBYE,A1  ; loads message to A1
    MOVE.B  #14,D0      ; sets to task 14
    TRAP    #15         ; displays message and asks for input
    
    SIMHALT             ; halts simulator


*------------------------ CONSTANTS ------------------------
CR      EQU     $0D
LF      EQU     $0A

WELCOME DC.B    'Welcome to CSS 422 Final Project Disassembler!',CR,LF
        DC.B    'Written by Anna Jennings, Bill Zhao, Lawrence Fiesta, and Lexun Chi',CR,LF,0      

INPUTBEG DC.B   CR,LF,'PLEASE ENTER THE STARTING ADDRESS: ',0

INPUTEND DC.B   CR,LF,'PLEASE ENTER THE ENDING ADDRESS: ',0

DISBEG   DC.B   CR,LF,'STARTING DISASSEMBLY PROCESS:',CR,LF,0

NEXTLINE DC.B   CR,LF,0

INPUTCON DC.B   CR,LF,'DISASSEMBLY COMPLETED!',CR,LF
         DC.B   'PRESS ENTER TO START AGAIN, "Q" TO QUIT: ',CR,LF,0

DISCON  DC.B    'PRESS ENTER TO CONTINUE THE DISASSEMBLY',0
        
INVALID DC.B    CR,LF,'ERROR: THIS IS AN INVALID ADDRESS!',CR,LF,0

GOODBYE DC.B    CR,LF,'Thank you for using our disassembler!',CR,LF,0


*------------------------ VARIABLES ------------------------
SADD    DS.B    8       ; starting address storage

EADD    DS.B    8       ; ending address storage


*--------------------- INCLUDE FILES -----------------------
    INCLUDE 'EA_CODES.X68'  ; includes ea code disassembly
    INCLUDE 'OP_CODES.X68'  ; includes op code disassembly
    
    END    START        ; last line of source


*------------------- EXTERNAL REFERENCES -------------------
* https://www.ascii-code.com/
* http://mrjester.hapisan.com/04_MC68/Sect05Part05/Index.html
* http://www.easy68k.com/QuickStart/TrapTasks.htm
* http://neo.dmcs.pl/pn/asembler_68000/asm.html
* http://goldencrystal.free.fr/M68kOpcodes-v2.3.pdf
* https://stackoverflow.com/questions/48017/what-is-a-jump-table
<<<<<<< HEAD











=======
>>>>>>> 970dc9b4d99505a759f3dd49cab09be291bd27c1

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
