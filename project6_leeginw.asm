TITLE Project 6     (project6_leeginw.asm)

; Author: GinWook Lee
; Last Modified: 3/13/2022
; OSU email address: leeginw@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number: 06                 
; Due Date: 3/13/2022
; Description: This program asks for 10 integers and displays a list, sum, and average of those integers.
;		Each integer must fit in a 32-register (-2^31 to 2^31-1). Otherwise, the program invalidates such input.
;
;		The program takes user input as a string of characters, validates and converts each number to ASCII.
;		Then, ASCII are converted back to numbers for sum and average calculations.
;		Once all numbers are calculated, each number reverts back to ASCII for display.		
;	
;	input assumptions: (no validation) 
;		1) no arithematic calculations (e.g., "12379+893", "180-2879", "1123x19")
;		2) sum of any two integers won't exceed a 32-register

INCLUDE Irvine32.inc


; ------------------------------------------------------------------------
; Name: mGetString
; Description: display input prompt and get user input in inputString
;
; Receives:
;	- parameters:'input_msg' (reference, input), 'inputString' (reference, input),
;			'countAllowed'(value, input), 'inputLength' (value, input)
; ------------------------------------------------------------------------
mGetString	MACRO		input, string, count, length
	; preserve registers
	PUSH	EDX
	PUSH	ECX
	PUSH	EAX
	
	; display input prompt
	MOV		EDX, input						; OFFSET input_msg
	CALL	WriteString
	
	; read user input
	MOV		EDX, string						; OFFSET inputString
	MOV		ECX, count						; countAllowed (13)
	CALL	ReadString
	MOV		length, EAX
	
	; restore registers
	POP		EAX
	POP		ECX
	POP		EDX

ENDM

; ------------------------------------------------------------------------
; Name: mDisplayString
; Description: display one valid user input at a time
;
; Receives:
;	- parameters: string (reference, input), 'count' (value, input)
; ------------------------------------------------------------------------
mDisplayString MACRO	string, count
	LOCAL	_displayLoop
	; preserve registers
	PUSH	ESI
	PUSH	ECX
	
	MOV		ECX, count

	MOV		ESI, string	
	DEC		ESI	

	; display characters in a numeric value
_displayLoop:	
	STD	
	LODSB

	CALL	WriteChar
	LOOP	_displayLoop

	CLD

	; restore registers
	POP		ECX
	POP		ESI

ENDM


; global constants
ARRAYSIZE = 10
LENGTH_LIMIT = 500								; extra space in case of a zero-padded number

MIN = -2147483648								; -2^31 (the lowest value that fits into a 32-register

; ASCII
SPACE = 32
COMMA = 44
PLUS = 43
MINUS = 45
ZERO = 48


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

array_msg		BYTE		13,10,"10 valid integers you entered: ",13,10,0
sum_msg			BYTE		13,10,"The sum of 10 valid integers you entered: ",0
avg_msg			BYTE		13,10,"The truncated average (to the nearest decimal): ", 0

farewell_msg	BYTE		13,10,13,10,"Thanks for playing!",0

; global variables
inputArray		SDWORD		ARRAYSIZE DUP(?)

inputLength		DWORD		?
countAllowed	DWORD		LENGTH_LIMIT+1
inputString		BYTE		LENGTH_LIMIT DUP(?)

errorFlag		DWORD		?


displayString	BYTE		LENGTH_LIMIT DUP(?)


.code
main PROC

	; program introduction
	PUSH	OFFSET		intro_msg
	CALL	introduction
	
	; read valid user input 10 times
	MOV		ECX, ARRAYSIZE						; set number of valid inputs
	MOV		EDI, OFFSET inputArray				; EDI point to inputArray to store valid user inputs

_readLoop:
	PUSH	OFFSET		errorFlag				; EBP+28
	PUSH	OFFSET		error_msg				; EBP+24
	PUSH	inputLength							; EBP+20
	PUSH	countAllowed						; EBP+16
	PUSH	OFFSET		inputString				; EBP+12
	PUSH	OFFSET		input_msg				; EBP+8
	CALL	ReadVal	
	
	LOOP	_readLoop

	; display integer list along with sum and average of those integers
	PUSH	OFFSET		farewell_msg			; EBP+28
	PUSH	OFFSET		avg_msg					; EBP+24
	PUSH	OFFSET		sum_msg					; EBP+20
	PUSH	OFFSET		displayString			; EBP+16
	PUSH	OFFSET		array_msg				; EBP+12
	PUSH	OFFSET		inputArray				; EBP+8
	CALL	WriteVal

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
; Description: ask for user input, validate and convert through Conversion procedure,
;		and fill inputArray one at a time with a valid user input.
;
; Preconditions: EDI is pointing to the next byte to store next valid user input
; Postconditions: EDI points to the last value(10th) of inputArray
;
; Receives: 
;		- parameters: 'input_msg' (reference, input), 'inputString' (reference, input),
;			'countAllowed'(value, input), 'inputLength' (value, input),
;			'error_msg' (reference, input), 'error_flag' (reference, input)
; Returns: inputArray is filled with 10 valid user inputs
; ------------------------------------------------------------------------

ReadVal			PROC USES EBP
	MOV		EBP, ESP

	; preserve registers
	PUSH	EAX
	PUSH	ESI
	PUSH	EBX
	PUSH	ECX

	; call macro with parameters: OFFSET input, OFFSET string, count, length
_getAgain:
	mGetString			[EBP+8], [EBP+12], [EBP+16], [EBP+20]

	PUSH	[EBP+28]							; OFFSET errorFlag
	PUSH	[EBP+20]							; inputLength from mGetString
	PUSH	[EBP+12]							; OFFSET inputString from mGetString
	CALL	Conversion

	; check error flag
	MOV		ESI, [EBP+28]
	MOV		EBX, [ESI]
	CMP		EBX, 0
	JE		_valid								; jump to _valid if no error flag (0)

	; invalid input
	MOV		EDX, [EBP+24]
	CALL	WriteString							; display error_msg
	
	JMP		_getAgain							; return to get user input 

	; valid input
_valid:
	STOSD										; EAX to OFFSET inputArray

	; restore registers
	POP		ECX
	POP		EBX
	POP		ESI
	POP		EAX

	RET		24
ReadVal			ENDP


; ------------------------------------------------------------------------
; Name: conversion
; Description: validate, convert, and return a valid user input to ReadVal procedure.
;		if input is invalid, display error_msg
;
; Preconditions: user input has been entered and its memory address with the length of string
;		should be passed through the runtime stack
; Postconditions: user input is validated. Ask for another input in case for invalid.
;
; Receives:
;		- parameters: 'inputString' (reference, input), 'inputLength' (value, input),
;			'error_flag' (reference, input)
; Returns: validated input is passed back to ReadVal procedure in EAX register
; ------------------------------------------------------------------------
Conversion		PROC
	LOCAL	val:SDWORD, error:DWORD, count:DWORD, sign:DWORD

	; preserve registers [except for EAX]
	PUSH	ESI
	PUSH	ECX
	PUSH	EBX
	PUSH	EDX
	PUSH	EDI

; -------------------------------------
; validation!
; validate user input with the following criteria:
;	1) check for empty string
;	2) check for type (character or number)
;	3) check for sign (first digit only: + or -)
;
; following validations are embedded in conversion! section:
;	1) check for exceeding value
;	2) check for special cases
; -------------------------------------

	; initialize registers
	MOV		ESI, [EBP+8]						; point ESI to inputString from mGetString
	MOV		ECX, [EBP+12]						; length of inputString to ECX
	MOV		EAX, 0								; initialize EAX
	
	; initialize local variables
	MOV		val, 0								
	MOV		error, 0							
	MOV		count, 0
	MOV		sign, 0

	; 1) check for empty string
	CMP		ECX, 0								; if length is zero
	JE		_error

	JMP		_convert


	; 2) check for type (character or number)
_digitCheck:
	; AL has char
	CMP		count, 0							
	JNE		_remainDigit						; if not the first digit, jump to _remainDigit

	; if first digit
	INC		count

	CALL	IsDigit
	JZ		_checkedDigit						; valid digit, move to _checkedDigit

	; 3) check for sign (first digit only: + or -)
	; check if -
	CMP		AL, MINUS							; - (ASCII)
	JE		_minusVal

	; check if +
	CMP		AL, PLUS							; + (ASCII)
	JE		_plusVal							; no change, jump to _checkedDigit

	; neither a digit, positive, nor negative sign
	JMP		_error

_minusVal:
	INC		sign								;change sign if the first char is "-"
_plusVal:
	DEC		ECX
	JMP		_convertLoop
	
	; check remaining digits
_remainDigit:
	CALL	IsDigit
	JZ		_checkedDigit
	
	JMP		_error								; not a digit, then _error

; -------------------------------------
; conversion!
; convert ASCII to numeric values and load into EAX
; [check for exceed 1 and 2] invalid input if Overflow Flag gets set
; special cases: -2,147,483,648(valid) and +2,147,483,648(invalid)
; -------------------------------------
	; reset errorFlag to zero
_convert:
	MOV		EBX, error

	MOV		EDI, [EBP+16]
	MOV		[EDI], EBX

	; conversion setup
	MOV		ESI, [EBP+8]						; point ESI to inputString from mGetString
	MOV		ECX, [EBP+12]						; length of inputString to ECX


	; convert valid input to signed integer	
_convertLoop:
	MOV		EAX, val							; prep EAX for MUL	
	MOV		EBX, 10
	MUL		EBX									; multiply by 10 to increase decimal digit

	; [check for exceed 1]
	JO		_overFlow

	MOV		val, EAX						

	MOV		EAX, 0								; reset EAX
	
	LODSB										; load one byte from inputString to AL 

	JMP		_digitCheck							; jump to check digit
_checkedDigit:


	SUB		AL, ZERO							; zero (ASCII)
	ADD		val, EAX							; combine the latest decimal digit

	; [check for exceed 2]
	JO		_overFLow

	LOOP	_convertLoop						; LOOP until all inputString bytes are converted

	MOV		EAX, val							; preserve valid numeric value in EAX

	CMP		sign, 0
	JE		_return								; if sign is 0 (positive), jump to _return

	NEG		EAX									; if sign is 1 (negative), multiply EAX by -1
	JMP		_return

	; when overflow status flag is set
_overFlow:
	; special case: -2,147,483,648 (valid)
	CMP		val, MIN							; MIN = -2,147,483,648
	JE		_special

	; invalid input
_error:
	INC		error	
	MOV		EBX, error

	MOV		EDI, [EBP+16]
	MOV		[EDI], EBX

	JMP		_return

	; validate special cases
_special:
	; special case: 2,147,483,648 or +2,147,483,648 (invalid)
	CMP		sign, 0
	JE		_error

	MOV		EAX, MIN							; -2,147,483,648 is valid

	; restore registers [except for EAX]
_return:
	POP		EDI
	POP		EDX
	POP		EBX
	POP		ECX
	POP		ESI

	RET		12
Conversion		ENDP

; ------------------------------------------------------------------------
; Name: WriteVal
; Description: display a list of valid integers, sum and truncated average of those integers.
;	Lastly, farewell_msg is shown to the user.
;
; Preconditions: 10 valid integers are stored in inputArray.
; Postconditions: all messages displayed.
;
; Receives:
;	- parameters: 'inputArray' (reference, input), 'array_msg' (reference, input),
;		'displayString' (reference, input), 'sum_msg' (reference, input), 'avg_msg' (reference, input)
; Returns: display prompts, list of valid integers, sum and average of those integers, and farewell_msg
; ------------------------------------------------------------------------
WriteVal		PROC
	LOCAL	sum:SDWORD, avg:SDWORD, count:DWORD

	; preserve registers
	PUSH	ESI
	PUSH	EAX
	PUSH	EBX
	PUSH	EDX
	PUSH	EDI
	PUSH	ECX

	; initial setup
	MOV		ECX, ARRAYSIZE
	MOV		sum, 0
	MOV		ESI, [EBP+8]						; OFFSET inputArray
	
	; sum calculation
_sumLoop:
	LODSD										; load one number at a time: [ESI] -> AL
	ADD		sum, EAX
	LOOP	_sumLoop

	; average calculation
	MOV		avg, 0

	MOV		EAX, sum
	CDQ
	MOV		EBX, ARRAYSIZE						; divide by the number of inputs: 10
	IDIV	EBX
	
	MOV		avg, EAX							; quotient only for truncated average

; -------------------------------------
; convert number to ASCII: list
; convert to ASCII and display a list of valid integers
; -------------------------------------
	; prompt for list of signed integers
	MOV		EDX, [EBP+12]						; OFFSET array_msg
	CALL	WriteString

	; initial setup
	MOV		EAX, 0
	MOV		EDX, 0
	MOV		ECX, ARRAYSIZE

	MOV		EDI, [EBP+16]						; OFFSET displayString BYTE
	MOV		ESI, [EBP+8]						; OFFSET inputArray SDWORD

	MOV		count, 2							; extra counts for space(" ") and comma(",")
	
_loadInteger:	
	MOV		[EDI], BYTE PTR SPACE				; space (ASCII)
	INC		EDI
	MOV		[EDI], BYTE PTR COMMA				; comma (ASCII)
	INC		EDI

	LODSD										; [ESI] -> EAX

	; check for a negative value
	CMP		EAX, 0
	JNL		_integer							; if positive, jump to _integer
	
	; display negative sign
	PUSH	EAX

	MOV		EAX, 0								; reset EAX
	MOV		AL, MINUS							; negative (ASCII)
	CALL	WriteChar							; display minus sign
	
	POP		EAX
	
	NEG		EAX									; multiply by -1

_integer:		
	CDQ
	MOV		EDX, 0								; reset to zero
	MOV		EBX, 10
	IDIV	EBX
	
	ADD		EDX, ZERO							; zero (ASCII)
	
	PUSH	EAX
	MOV		EAX, EDX							; move the remainder to EAX
	STOSB										; AL -> [EDI]
	POP		EAX

	MOV		EDX, 0								; reset EDX

	INC		count								; count number of characters

	CMP		EAX, 0								; done when the quotient is zero
	JNE		_integer

	mDisplayString		EDI, count				; read backward using count

	MOV		count, 0							; reset count

	; check for the last input (10th)
	CMP		ECX, 2
	JE		_last								; if last, skip extra counts (no need for comma and space)

	ADD		count, 2

_last:
	LOOP	_loadInteger

; -------------------------------------
; convert number to ASCII: sum
; convert to ASCII and display sum of 10 valid integers
; -------------------------------------
	; prompt for sum
	MOV		EDX, [EBP+20]						; OFFSET sum_msg
	CALL	WriteString

	MOV		count, 0
	MOV		EAX, sum

	; check for a negative value
	CMP		EAX, 0
	JNL		_integerSum							; if positive, jump to _integer
	
	; display negative sign
	PUSH	EAX

	MOV		EAX, 0								; reset EAX
	MOV		AL, MINUS							; negative (ASCII)
	CALL	WriteChar							; display minus sign
	
	POP		EAX
	
	NEG		EAX									; multiply by -1

	; convert sum to ASCII
_integerSum:		
	CDQ
	MOV		EDX, 0								; reset to zero
	MOV		EBX, 10
	IDIV	EBX
	
	ADD		EDX, ZERO							; zero (ASCII)

	PUSH	EAX
	MOV		EAX, EDX	
	STOSB										; AL -> [EDI]
	POP		EAX

	MOV		EDX, 0								; reset EDX

	INC		count

	CMP		EAX, 0								; done when the quotient is zero
	JNE		_integerSum

	mDisplayString		EDI, count				; read backward using count
	
; -------------------------------------
; convert number to ASCII: average
; convert to ASCII and display truncated average of 10 valid integers
; -------------------------------------
	; prompt for average
	MOV		EDX, [EBP+24]						; OFFSET avg_msg
	CALL	WriteString

	; initial setup
	MOV		count, 0
	MOV		EAX, avg

	; check for a negative value
	CMP		EAX, 0
	JNL		_integerAvg							; if positive, jump to _integer

	; display negative sign
	PUSH	EAX

	MOV		EAX, 0								; reset EAX
	MOV		AL, MINUS							; negative (ASCII)
	CALL	WriteChar							; display minus sign
	
	POP		EAX
	
	NEG		EAX									; multiply by -1 to revert back to positive integer

	; convert average to ASCII
_integerAvg:		
	CDQ
	MOV		EDX, 0								; reset to zero
	MOV		EBX, 10
	IDIV	EBX
	
	ADD		EDX, ZERO							; zero (ASCII)

	PUSH	EAX
	MOV		EAX, EDX	
	STOSB										; AL -> [EDI]
	POP		EAX

	MOV		EDX, 0								; reset EDX

	INC		count

	CMP		EAX, 0								; done when the quotient is zero
	JNE		_integerAvg

	mDisplayString		EDI, count				; read backward using count

; -------------------------------------
; conclusion:
; display farewell_msg
; -------------------------------------
	; prompt for thank you
	MOV		EDX, [EBP+28]						; OFFSET farewell_msg
	CALL	WriteString

	; restore registers
	POP		ECX
	POP		EDI
	POP		EDX
	POP		EBX
	POP		EAX
	POP		ESI

	RET		24
WriteVal		ENDP

END main
