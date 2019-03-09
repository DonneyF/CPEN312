$MODDE0CV

; Initialize some equivalents (Sort of like #define in C)
DIGIT_1 equ 79H
DIGIT_2 equ 24H
DIGIT_3 equ 30H
DIGIT_6 equ 2H
BLANK equ 01111111b

; Start the process at memory location 0
org 0
    ; Long jump to the instructions under the init label
	ljmp init

; wait process instructions: This set of instruc tions delays sequential instructions by approximately 0.5s.
wait_half_second:
    ; Move the decimal 90 to the register R2
    mov R2, #90  ; 90 is 5AH
    ; Label a process L3 that moves the decimal 250 to the register R1
L3: mov R1, #250 ; 250 is FAH 
L2: mov R0, #250
L1: djnz R0, L1  ; 3 machine cycles-> 3*30ns*250=22.5us
    djnz R1, L2  ; 22.5us*250=5.625ms
    djnz R2, L3  ; 5.625ms*90=0.506s (approximately)
    ; Return to the previous instruction set
	ret

; Initializes the 7-Segment Displays to some value
init:
	mov SP, #0x7f ; Initialize the stack
	MOV LEDRA, #0
	MOV LEDRB, #0
	lcall main
	
; Our Main logic
main:
	; Compare switch with 000
	mov A, SWA
	;cjne A, #00000001H, NOT_001
	cjne A, #00000000H, NOT_000
	; If equal, display the six most sigificant digits
	mov HEX5, #DIGIT_2
	mov HEX4, #DIGIT_1
	mov HEX3, #DIGIT_3
	mov HEX2, #DIGIT_1
	mov HEX1, #DIGIT_6
	mov HEX0, #DIGIT_1

LATCH_SW3:
	;mov R0, KEY
	jb KEY.3, LATCH_SW3
	ljmp main

NOT_000:
	; Compare with 001
	cjne A, #00000001H, NOT_001
	; If equal, Display the two least significant digits
	mov HEX5, #BLANK
	mov HEX4, #BLANK
	mov HEX3, #BLANK
	mov HEX2, #BLANK
	mov HEX1, #DIGIT_6
	mov HEX0, #DIGIT_1
	ljmp LATCH_SW3

NOT_001:
	cjne A, #00000002H, wait_half_second
	; Starting with the six most significant digits, scroll one digit to the left every second
	; Get out
	jb KEY.3, LATCH_SW3
	; Initialize the displays
	mov HEX5, #DIGIT_2
	mov HEX4, #DIGIT_1
	mov HEX3, #DIGIT_3
	mov HEX2, #DIGIT_1
	mov HEX1, #DIGIT_6
	mov HEX0, #DIGIT_1
	mov R5, #DIGIT_6
	mov R4, #DIGIT_1
	; Need an extra register for to not overwrite data
	mov R3, #DIGIT_2
	lcall wait_half_second
	ljmp SCROLL_LEFT

SCROLL_LEFT:
	; Scroll left, so the value in HEX4 goes to HEX5
	mov HEX5, HEX4
	mov HEX4, HEX3
	mov HEX3, HEX2
	mov HEX2, HEX1
	mov HEX1, HEX0
	mov HEX0, R5

	; Cannot copy register to register. Instead copy to accumulator.
	mov A, R4
	mov R5, A

	mov A, R3
	mov R4, A

	mov R3, HEX5
	; Wait a full second
	lcall wait_half_second
	lcall wait_half_second

	; Exit condition
	jnb KEY.3, LATCH_SW3
	ljmp SCROLL_LEFT

;dont_do_this:

;	; Check if SWA is 01010100.  If so display "------"
;	mov a, swa
;	cjne a, #01010100b, not_01010100
;	; Display "------"		
;	mov HEX4, #DASH
;	mov HEX3, #DASH
;	mov HEX2, #DASH
;	mov HEX1, #DASH
;	mov HEX0, #DASH
;	lcall wait
;not_01010100:
	
    sjmp main

END
