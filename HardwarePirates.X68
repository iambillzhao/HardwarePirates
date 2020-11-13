*-----------------------------------------------------------
* Title      : Final Project
* Written by : Anna Jennings, Bill Zhao, Lawrence Fiesta, Lexun Chi
* Date       : Fall 2020
* Description: CSS 422 Disassembler
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    LEA     WELCOME,A1  ; loads message to A1
    MOVE.B  #14,D0      ; sets to task 14
    TRAP    #15         ; displays message and asks for input

BEG LEA     INPUT,A1    ; loads message to A1
    MOVE.B  #14,D0      ; sets to task 14
    TRAP    #15         ; displays message and asks for input
    MOVE.B  #4,D0       ; sets to task 2
    TRAP    #15         ; gets input from the user
    CMP     #$0,D1      ; compares 0 to D1
    BEQ     END         ; triggers program's goodbye branch
    BRA     BEG         ; loops to get the next input
    
END LEA     GOODBYE,A1  ; loads message to A1
    MOVE.B  #14,D0      ; sets to task 14
    TRAP    #15         ; displays message and asks for input
    
    SIMHALT             ; halt simulator

* Put variables and constants here
CR      EQU     $0D
LF      EQU     $0A

WELCOME DC.B    'Welcome to CSS 422 Final Project Disassembler!',CR,LF
        DC.B    'Written by Anna Jennings, Bill Zhao, Lawrence Fiesta, and Lexun Chi',CR,LF,0        

INPUT   DC.B    CR,LF,'PLEASE ENTER AN ADDRESS, TYPE "0" TO QUIT: ',0
        
GOODBYE DC.B    CR,LF,'Thank you for using our disassembler, good bye!',CR,LF,0
    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
