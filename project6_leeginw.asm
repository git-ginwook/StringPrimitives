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
;	- parameters: input_msg (reference, input), countAllowed (value, input),
;				inputString (reference, output), inputLength (reference, output)
;
; ------------------------------------------------------------------------
mGetString	MACRO		intro, string, length, count
	; preserve registers
	PUSH	EDX
	PUSH	EBX
	PUSH	ECX
	PUSH	EAX
	
_input:
	; display input prompt
	MOV		EDX, intro						; OFFSET input_msg
	CALL	WriteString
	
	; read user input
	MOV		EDX, string						; OFFSET inputString	
	MOV		EBX, length						; OFFSET inputLength
	MOV		ECX, count						; countAllowed (13)
	CALL	ReadString
	MOV		[EBX], EAX						; store number of bytes
	
	; restore registers
	POP		EAX
	POP		ECX
	POP		EBX
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
inputString		BYTE		LENGTH_LIMIT DUP(?)
inputLength		DWORD		?
countAllowed	DWORD		LENGTH_LIMIT+1

inputValue		SDWORD		?
inputArray		SDWORD		ARRAYSIZE DUP(?)

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
	PUSH	OFFSET		inputArray				; EBP+28
	PUSH	OFFSET		inputValue				; EBP+24

	PUSH	countAllowed						; EBP+20

	PUSH	OFFSET		inputLength				; EBP+16
	PUSH	OFFSET		inputString				; EBP+12
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

	; preserve registers
	PUSH	ECX
	PUSH	EAX
	PUSH	EDI

	MOV		ECX, ARRAYSIZE						; set number of valid inputs
	MOV		EDI, [EBP+28]						; point EDI to inputArray

	; call macro with parameters: OFFSET intro, OFFSET string, OFFSET length, count
_getValue:
	mGetString			[EBP+8], [EBP+12], [EBP+16], [EBP+20]
	
	PUSH	[EBP+12]
	CALL	Conversion

	; [sub] inputValue
	MOV		EAX, inputValue

	; loop 10 times to load 10 valid user inputs in inputArray
	STOSD
	LOOP	_getValue

	; restore registers
	POP		EDI
	POP		EAX
	POP		ECX

	RET		28
ReadVal			ENDP


; ------------------------------------------------------------------------
; Name: conversion
; Description:
;
; Preconditions:
; Postconditions:
;
; Receives:
; Returns:
; ------------------------------------------------------------------------
Conversion		PROC USES EBP
	MOV		EBP, ESP
	
	; convert ASCII to a numeric value
	PUSH	ESI
	PUSH	ECX
	PUSH	EAX
	PUSH	EBX
	PUSH	EDX

	; mov inputString to ESI
	MOV		ESI, [EBP+8]						; point ESI to inputString

	MOV		ECX, inputLength					; [sub] inputLength
	MOV		inputValue, 0

	; validation!

_conversion:
	MOV		EAX, inputValue						; [sub] inputValue
	MOV		EBX, 10
	MUL		EBX	
	MOV		inputValue, EAX

	MOV		EAX, 0								; reset EAX
	
	LODSB

	SUB		AL, 48
	ADD		inputValue, EAX						; [sub] inputValue

	LOOP	_conversion

	POP		EDX
	POP		EBX
	POP		EAX
	POP		ECX
	POP		ESI

	RET		4
Conversion		ENDP

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
	MOV		EBP, ESP


	RET
WriteVal		ENDP

END main
