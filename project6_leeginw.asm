TITLE Project 6     (project6_leeginw.asm)

; Author: GinWook Lee
; Last Modified: 3/11/2022
; OSU email address: leeginw@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 06                 
; Due Date: 3/13/2022
; Description: 

INCLUDE Irvine32.inc


; ------------------------------------------------------------------------
; Name: mGetString
; Description:
;
; Receives:
;
; ------------------------------------------------------------------------
mGetString	MACRO		intro, error, array, string, ascii, sign 
	; preserve registers
	PUSH	EDX
	PUSH	ECX
	PUSH	EAX
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	
_input:
	; display input prompt
	MOV		EDX, intro						; OFFSET input_msg
	CALL	WriteString
	
	; read user input
	MOV		EDX, string						; OFFSET inputString	
	MOV		ECX, LENGTH_LIMIT+1				; invalid if greater than or equal to 12 digits
	CALL	ReadString
	
	MOV		ECX, EAX						; set repeat number for validation loop

	; [validation]
	; _error if input length greater than or equal to 12 digits
	CMP		EAX, LENGTH_LIMIT
	JAE		_error
	
	; first character check
	MOV		ESI, string						; OFFSET inputString 
	MOV		EDI, ascii						; OFFSET ascii

	LODSB									; [ESI] -> AL

	SCASB									; AL - [EDI]
	JE		_firstPlus
	SCASB
	JE		_firstMinus
	SCASB
	JB		_error
	SCASB
	JA		_error

	JMP		_firstInteger
	
_firstPlus:
	; if first char is 43d (+)
	MOV		sign, DWORD PTR 1				; 1 for positive
	JMP		_remainChar

_firstMinus:
	; if first char is 45d (-)
	MOV		sign, DWORD PTR 2				; 2 for positive
	JMP		_remainChar

_firstInteger:
	MOV		sign, DWORD PTR 0				; 0 for integer

	; remaining character check
_remainChar:
	LOOP	_validLoop
	JMP		_return

_validLoop:
	MOV		EDI, ascii						; reset EDI
	ADD		EDI, 2							; no need to checck for + and - signs

	LODSB									; load the next char into AL

	SCASB
	JB		_error
	SCASB
	JA		_error

	LOOP	_validLoop
	JMP		_return

_error:
	; display error message for an invalid input
	MOV		EDX, error						; OFFSET error_msg
	CALL	WriteString
	JMP		_input							; return to _input

	; restore registers
_return:
	POP		EBX
	POP		ESI
	POP		EDI
	POP		EAX
	POP		ECX
	POP		EDX

ENDM

; ------------------------------------------------------------------------
; Name: mDisplayString
; Description:
;
; Receives:
;
; ------------------------------------------------------------------------
mDisplayString MACRO



ENDM


; global constants
ARRAYSIZE = 10
LENGTH_LIMIT = 12								; max number of digits for a 32-bit register

; ASCII 
PLUS = 43
MINUS = 45
ZERO = 48
NINE = 57


.data

; prompt variables
intro_msg		BYTE		"Project 6: Low-Level I/O Procedures",13,10
				BYTE		"Written by GinWook Lee",13,10,13,10
				BYTE		"Please enter 10 signed decimal integers. "
				BYTE		"Each integer needs to be able to fit in a 32-bit register.",13,10
				BYTE		"Once all inputs are in, this program will display: ",13,10
				BYTE		"	1) 10 valid integers entered",13,10
				BYTE		"	2) sum and average of those integers",13,10,13,10,0

input_msg		BYTE		"Please enter a signed decimal integer: ",0
error_msg		BYTE		"ERROR: your number is either too big or not a signed decimal integer.",13,10,0

array_msg		BYTE		"10 valid integers you entered: ",13,10,0
sum_msg			BYTE		13,10,"The sum of 10 valid integers you entered: ",0
avg_msg			BYTE		13,10,"The truncated average (to the nearest decimal): ", 0

farewell_msg	BYTE		13,10,"Thanks for playing!",0

; global variables
inputArray		BYTE		ARRAYSIZE DUP(?)
inputString		BYTE		LENGTH_LIMIT-1 DUP(?)

ascii			BYTE		PLUS, MINUS, ZERO, NINE
signChar		DWORD		?


sum				SDWORD		?
average			SDWORD		?

.code
main PROC

	; program introduction
	PUSH	OFFSET		intro_msg
	CALL	introduction
	
	; read valid user input 10 times
	PUSH	signChar							; EBP+28
	PUSH	OFFSET		ascii					; EBP+24
	PUSH	OFFSET		inputString				; EBP+20

	PUSH	OFFSET		inputArray				; EBP+16		*
	PUSH	OFFSET		error_msg				; EBP+12
	PUSH	OFFSET		input_msg				; EBP+8
	CALL ReadVal	
	
	; display integer list with sum and average of those integers
	CALL WriteVal

	Invoke ExitProcess,0						; exit to operating system
main ENDP


; ------------------------------------------------------------------------
; Name: introduction
; Description: introduce the program to the user.
;
; Preconditions: no precondition.
; Postconditions: no change.
;
; Receives: program introduction and description prompt from 'main' procedure.
;		- parameter: 'intro_msg' (reference, input)
; Returns: display program title and description.
; ------------------------------------------------------------------------
introduction	PROC USES EBP
	MOV		EBP, ESP
	
	PUSH	EDX									; preserve register

	MOV		EDX, [EBP+8]						; OFFSET intro_msg
	CALL	WriteString

	POP		EDX									; restore register

	RET		4
introduction	ENDP

; ------------------------------------------------------------------------
; Name: ReadVal
; Description:
;
; Preconditions:
; Postconditions:
;		- parameters: 'input_msg' (reference, input)
; Receives:
; Returns:
; ------------------------------------------------------------------------
ReadVal			PROC USES EBP
	MOV		EBP, ESP

	; call macro with parameters: intro, error, array*, string, ascii, sign
_getValid:
	mGetString			[EBP+8], [EBP+12], [EBP+16], [EBP+20], [EBP+24], [EBP+28]

	; convert ASCII to a numeric value




	RET		24
ReadVal			ENDP


; ------------------------------------------------------------------------
; Name:
; Description:
;
; Preconditions:
; Postconditions:
;
; Receives:
; Returns:
; ------------------------------------------------------------------------
WriteVal		PROC USES EBP
	


	RET
WriteVal		ENDP

END main
