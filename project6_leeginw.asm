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
mGetString	MACRO		intro, string, count, length
	; preserve registers
	PUSH	EDX
	PUSH	ECX
	PUSH	EAX
	
_input:
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
inputArray		SDWORD		ARRAYSIZE DUP(?)

inputLength		DWORD		?
countAllowed	DWORD		LENGTH_LIMIT+1
inputString		BYTE		LENGTH_LIMIT DUP(?)

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
	MOV		ECX, ARRAYSIZE						; set number of valid inputs
	MOV		EDI, OFFSET inputArray				; 

_readLoop:
	PUSH	inputLength							; EBP+20
	PUSH	countAllowed						; EBP+16
	PUSH	OFFSET		inputString				; EBP+12
	PUSH	OFFSET		input_msg				; EBP+8
	CALL ReadVal	
	
	LOOP	_readLoop

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
	PUSH	EAX

	; call macro with parameters: OFFSET intro, OFFSET string, count
	mGetString			[EBP+8], [EBP+12], [EBP+16], [EBP+20]
	
	PUSH	[EBP+20]							; inputLength from mGetString
	PUSH	[EBP+12]							; OFFSET inputString from mGetString

	CALL	Conversion							; 

	STOSD										; EAX to OFFSET inputArray

	; restore registers
	POP		EAX

	RET		16
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
	LOCAL	val:SDWORD

	; preserve registers [except for EAX]
	PUSH	ESI
	PUSH	ECX
	PUSH	EBX
	PUSH	EDX

	MOV		ESI, [EBP+8]						; point ESI to inputString from mGetString
	MOV		ECX, [EBP+12]						; length of inputString to ECX

	MOV		val, 0								; reset val to zero

	; validation!


	; convert valid input to signed integer
_convertLoop:
	MOV		EAX, val							; prep EAX for MUL
	MOV		EBX, 10
	MUL		EBX									; multiply by 10 to increase decimal digit
	MOV		val, EAX							

	MOV		EAX, 0								; reset EAX
	
	LODSB										; load one byte from inputString to AL 

	SUB		AL, 48								; convert ASCII to decimal value
	ADD		val, EAX							; combine the latest decimal digit

	LOOP	_convertLoop						; LOOP until all inputString bytes are converted

	MOV		EAX, val							; preserve valid numeric value in EAX

	; restore registers [except for EAX]
	POP		EDX
	POP		EBX
	POP		ECX
	POP		ESI

	RET		8
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


	; sum

	; average

	; convert number to ASCII

	; display

		; list with Loop

		; sum

		; average


	RET
WriteVal		ENDP

END main
