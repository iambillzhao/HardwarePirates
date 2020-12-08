*****************************
*
* demo_test.X68
*
* Created 12/05/2018
*
* Test program for CSS 422 Disassembler Project Demo
*
*****************************

start		EQU	$00009000	* ORG and END address

* ORG the program so that it straddles the address boundary $00007FFF to $00008000

		ORG	start

NOP
    MULS.W    D0,D1
    MULS.W    (A0),D1
    MULS.W    -(A0),D1
    MULS.W    (A0)+,D1
    
* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
