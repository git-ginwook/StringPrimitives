TITLE Project 6     (project6_leeginw.asm)

; Author: GinWook Lee
; Last Modified: 3/11/2022
; OSU email address: leeginw@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 06                 
; Due Date: 3/13/2022
; Description: 
;	input assumption: 
;		1) no calculations (e.g., "12379+893", "180-2879", "1123x19")
;		2) sum of any two integers won't exceed a 32-register

INCLUDE Irvine32.inc


; ------------------------------------------------------------------------
; Name: mGetString
; Description:
;
; Receives:
;	- parameters:
;
; ------------------------------------------------------------------------
mGetString	MACRO		intro, string, count, length
	; preserve registers
	PUSH	EDX
	PUSH	ECX
	PUSH	EAX
	
	; display input prompt
	MOV		EDX, intro						; OFFSET input_msg
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
; Description:
;
; Receives:
;	- parameters: 
; ------------------------------------------------------------------------
mDisplayString MACRO	string, count
	LOCAL	_displayLoop
	; preserve registers
	PUSH	ESI
	PUSH	ECX
	
	MOV		ECX, count

	MOV		ESI, string	
	DEC		ESI	

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
LENGTH_LIMIT = 500								; 12 digits exceed a 32-register (even with a sign char)

MIN = -2147483648								; -2^31

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
	MOV		EDI, OFFSET inputArray				; 

_readLoop:
	PUSH	OFFSET		errorFlag				; EBP+28
	PUSH	OFFSET		error_msg				; EBP+24
	PUSH	inputLength							; EBP+20
	PUSH	countAllowed						; EBP+16
	PUSH	OFFSET		inputString				; EBP+12
	PUSH	OFFSET		input_msg				; EBP+8
	CALL	ReadVal	
	
	LOOP	_readLoop

	; display integer list with sum and average of those integers
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

	; preserve registers
	PUSH	EAX
	PUSH	ESI
	PUSH	EBX
	PUSH	ECX

	; call macro with parameters: OFFSET intro, OFFSET string, count
_getAgain:
	mGetString			[EBP+8], [EBP+12], [EBP+16], [EBP+20]

	PUSH	[EBP+28]							; OFFSET errorFlag
	PUSH	[EBP+20]							; inputLength from mGetString
	PUSH	[EBP+12]							; OFFSET inputString from mGetString
	CALL	Conversion							; 

	; check error flag
	MOV		ESI, [EBP+28]
	MOV		EBX, [ESI]
	CMP		EBX, 0
	JE		_valid

	; error_msg prompt
	MOV		EDX, [EBP+24]
	CALL	WriteString							; display error_msg
	
	JMP		_getAgain


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
; Description:
;
; Preconditions:
; Postconditions: EAX
;
; Receives:
; Returns:
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
;
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

	; [check for empty string]
	CMP		ECX, 0								; if length is zero
	JE		_error

	JMP		_convert


	; [check for digit]
_digitCheck:
	; AL has char
	CMP		count, 0							
	JNE		_remainDigit						; if not the first digit, jump to _remainDigit

	; if first digit
	INC		count

	CALL	IsDigit
	JZ		_checkedDigit						; valid digit, move to _checkedDigit

	; check if -
	CMP		AL, MINUS							; - (ASCII)
	JE		_minusVal

	; check if +
	CMP		AL, PLUS							; + (ASCII)
	JE		_plusVal							; no change, jump to _checkedDigit

	; neither a digit, positive, nor negative sign
	JMP		_error

_minusVal:
	INC		sign								;change sign
_plusVal:
	DEC		ECX
	JMP		_convertLoop
	

_remainDigit:
	CALL	IsDigit
	JZ		_checkedDigit
	
	JMP		_error								; not a digit, then _error


	; [check for exceed?]
_exceedCheck:






; -------------------------------------
; conversion!
;
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

_overFlow:
	; special case: -2,147,483,648
	CMP		val, MIN							; -2,147,483,648
	JE		_special

_error:
	INC		error	
	MOV		EBX, error

	MOV		EDI, [EBP+16]
	MOV		[EDI], EBX

	JMP		_return

_special:
	; special case: 2,147,483,648 or +2,147,483,648
	CMP		sign, 0
	JE		_error

	MOV		EAX, MIN							; -2,147,483,648

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
; Name:
; Description:
;
; Preconditions:
; Postconditions:
;
; Receives:
;
; Returns:
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

	; 
	
	MOV		ECX, ARRAYSIZE
	MOV		sum, 0
	MOV		ESI, [EBP+8]						; OFFSET inputArray
	
	; sum calculation
_sumLoop:
	LODSD
	ADD		sum, EAX
	LOOP	_sumLoop

	; average calculation
	MOV		avg, 0

	MOV		EAX, sum
	CDQ
	MOV		EBX, ARRAYSIZE
	IDIV	EBX
	
	MOV		avg, EAX

	; prompt for list of signed integers
	MOV		EDX, [EBP+12]						; OFFSET array_msg
	CALL	WriteString

; -------------------------------------
; convert number to ASCII: list
;
; -------------------------------------
	MOV		EAX, 0
	MOV		EDX, 0
	MOV		ECX, ARRAYSIZE

	MOV		EDI, [EBP+16]						; OFFSET displayString BYTE
	MOV		ESI, [EBP+8]						; OFFSET inputArray SDWORD

	MOV		count, 2
	
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

	MOV		EAX, EDX	

	STOSB										; AL -> [EDI]
	
	POP		EAX

	MOV		EDX, 0

	INC		count

	CMP		EAX, 0		
	JNE		_integer

	mDisplayString		EDI, count				; read backward using count

	MOV		count, 0

	CMP		ECX, 2
	JE		_last

	ADD		count, 2

_last:
	LOOP	_loadInteger


; -------------------------------------
; convert number to ASCII: sum
;
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

	MOV		EDX, 0

	INC		count

	CMP		EAX, 0		
	JNE		_integerSum

	mDisplayString		EDI, count				; read backward using count
	
; -------------------------------------
; convert number to ASCII: average
;
; -------------------------------------

	; prompt for average
	MOV		EDX, [EBP+24]						; OFFSET avg_msg
	CALL	WriteString

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
	
	NEG		EAX									; multiply by -1

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

	MOV		EDX, 0

	INC		count

	CMP		EAX, 0		
	JNE		_integerAvg

	mDisplayString		EDI, count				; read backward using count


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
