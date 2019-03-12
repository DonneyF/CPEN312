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
	cjne A, #00000002H, NOT_002
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

; Some aliases due to jump distance
wait_half_second_alias1: ljmp wait_half_second
LATCH_SW3_ALIAS: ljmp LATCH_SW3

NOT_002:
	cjne A, #00000003H, NOT_003
	; Starting with the six most significant digits, scroll one digit to the right every second
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
	lcall wait_half_second_alias1
	ljmp SCROLL_RIGHT

SCROLL_RIGHT:
	; Scroll left, so the value in HEX5 goes to HEX4
	mov A, R4
	mov R3, A

	mov A, R5
	mov R4, A

	mov R5, HEX0
	mov HEX0, HEX1
	mov HEX1, HEX2
	mov HEX2, HEX3
	mov HEX3, HEX4
	mov HEX4, HEX5
	mov HEX5, R3
	; Wait a full second
	lcall wait_half_second_alias1
	lcall wait_half_second_alias1
	; Exit condition
	jnb KEY.3, LATCH_SW3_ALIAS
	ljmp SCROLL_RIGHT

NOT_003:
	;Make the six least significant digits blink every second
	cjne A, #00000004H, NOT_004
	mov HEX5, #DIGIT_3
	mov HEX4, #DIGIT_1
	mov HEX3, #DIGIT_6
	mov HEX2, #DIGIT_1
	mov HEX1, #DIGIT_6
	mov HEX0, #DIGIT_1

	lcall wait_half_second_alias1
	lcall wait_half_second_alias1

	mov HEX5, #BLANK
	mov HEX4, #BLANK
	mov HEX3, #BLANK
	mov HEX2, #BLANK
	mov HEX1, #BLANK
	mov HEX0, #BLANK

	lcall wait_half_second_alias1
	lcall wait_half_second_alias1

	jnb KEY.3, LATCH_SW3_ALIAS
	jmp NOT_003

; Some aliases due to jump distance
wait_half_second_alias2: ljmp wait_half_second
LATCH_SW3_ALIAS2: ljmp LATCH_SW3

NOT_004:
	cjne A, #00000005H, NOT_005
	;Make the six most significant digits appear one at time every second, starting with a blank display
	;Init blank
	mov HEX5, #BLANK
	mov HEX4, #BLANK
	mov HEX3, #BLANK
	mov HEX2, #BLANK
	mov HEX1, #BLANK
	mov HEX0, #BLANK

	lcall wait_half_second_alias2
	lcall wait_half_second_alias2

	mov HEX5, #DIGIT_2
	lcall wait_half_second_alias2
	lcall wait_half_second_alias2
	mov HEX4, #DIGIT_1
	lcall wait_half_second_alias2
	lcall wait_half_second_alias2
	mov HEX3, #DIGIT_3
	lcall wait_half_second_alias2
	lcall wait_half_second_alias2
	mov HEX2, #DIGIT_1
	lcall wait_half_second_alias2
	lcall wait_half_second_alias2
	mov HEX1, #DIGIT_6
	lcall wait_half_second_alias2
	lcall wait_half_second_alias2
	mov HEX0, #DIGIT_1
	lcall wait_half_second_alias2
	lcall wait_half_second_alias2

	jnb KEY.3, LATCH_SW3_ALIAS2
	jmp NOT_004

LATCH_SW3_ALIAS3: ljmp LATCH_SW3

NOT_005:
	cjne A, #00000006H, NOT_006

	mov HEX5, #09H ; H
	mov HEX4, #06H; E
	mov HEX3, #47H; L
	mov HEX2, #47H; L
	mov HEX1, #40H; 0
	mov HEX0, #BLANK

	lcall wait_half_second_alias2
	lcall wait_half_second_alias2

	mov HEX5, #DIGIT_2
	mov HEX4, #DIGIT_1
	mov HEX3, #DIGIT_3
	mov HEX2, #DIGIT_1
	mov HEX1, #DIGIT_6
	mov HEX0, #DIGIT_1

	lcall wait_half_second_alias2
	lcall wait_half_second_alias2

	mov HEX5, #46H ; C
	mov HEX4, #0CH; P
	mov HEX3, #48H; N
	mov HEX2, #30H; 3
	mov HEX1, #79H; 1
	mov HEX0, #24H ;2
	
	lcall wait_half_second_alias2
	lcall wait_half_second_alias2

	jnb KEY.3, LATCH_SW3_ALIAS3
	jmp NOT_005

LATCH_SW3_ALIAS4: ljmp LATCH_SW3

NOT_006:
	;Init blank
	mov HEX5, #BLANK
	mov HEX4, #BLANK
	mov HEX3, #BLANK
	mov HEX2, #BLANK
	mov HEX1, #BLANK
	mov HEX0, #BLANK
	lcall BLINK_DIGITS

BLINK_DIGITS:
	
	mov HEX5, #DIGIT_2
	lcall wait_half_second_alias2
	mov HEX5, #BLANK
	lcall wait_half_second_alias2

	mov HEX4, #DIGIT_1
	lcall wait_half_second_alias2
	mov HEX4, #BLANK
	lcall wait_half_second_alias2

	mov HEX3, #DIGIT_3
	lcall wait_half_second_alias2
	mov HEX3, #BLANK
	lcall wait_half_second_alias2

	mov HEX2, #DIGIT_1
	lcall wait_half_second_alias2
	mov HEX2, #BLANK
	lcall wait_half_second_alias2

	mov HEX1, #DIGIT_6
	lcall wait_half_second_alias2
	mov HEX1, #BLANK
	lcall wait_half_second_alias2

	mov HEX0, #DIGIT_1
	lcall wait_half_second_alias2
	mov HEX0, #BLANK
	lcall wait_half_second_alias2

	jnb KEY.3, LATCH_SW3_ALIAS4
	jmp NOT_006
END
