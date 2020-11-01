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
    
    LEA     GOODBYE,A1  ; loads message to A1
    MOVE.B  #14,D0      ; sets to task 14
    TRAP    #15         ; displays message and asks for input
    
    SIMHALT             ; halt simulator

* Put variables and constants here
CR      EQU     $0D
LF      EQU     $0A

WELCOME DC.B    'Welcome to CSS 422 Final Project Disassembler!',CR,LF
        DC.B    'Written by Anna Jennings, Bill Zhao, Lawrence Fiesta, and Lexun Chi',CR,LF,CR,LF
        DC.B    'NOTE: PLEASE ENTER AN ADDRESS:',0
        
GOODBYE DC.B    CR,LF,'Thank you for using our disassembler, good bye!',CR,LF,0
    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
