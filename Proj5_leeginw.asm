TITLE Project 5     (project0_leeginw.asm)

; Author: GinWook Lee
; Last Modified: 3/1/2022
; OSU email address: leeginw@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 05
; Due Date: 2/27/2022 + 2 grace days
; Description: 

INCLUDE Irvine32.inc

; (insert macro definitions here)

; global constants
ARRAYSIZE = 200
LO = 15
HI = 50
; expected tests
;	LO: 5 to 20
;	HI: 30 to 60 
;	ARRAYSIZE: 20 to 1000

.data

; prompt variables
intro			BYTE			"Generating, Sorting, and Counting Random Integers! "
				BYTE			"Programmed by GinWook lee",13,10,13,10,0

descript		BYTE			"This program generates 200 random numbers in a given range and displays: ",13,10
				BYTE			09,"1) the original list of random number array",13,10
				BYTE			09,"2) the median value of the array",13,10
				BYTE			09,"3) the sorted list of the array in ascending order",13,10
				BYTE			09,"4) the number of instances of each random value generated",13,10,13,10,0

; array and count variables
;randArray
;counts


.code
main PROC


; 1. program introduction
;	push prompt variables to the stack
	PUSH	OFFSET intro 
;	PUSH	DWORD PTR LENGTHOF intro					; 33h = 51 characters
	PUSH	OFFSET descript
;	PUSH	DWORD PTR LENGTHOF descript					; 4bh = 75 characters
	CALL	introduction


	
	CALL	fillArray
	
	CALL	sortList
	
	CALL	displayMedian
	
	CALL	countList



	CALL	farewell

	Invoke ExitProcess,0								; exit to operating system
main ENDP

; -------------------------------------------------------------------------------------------------
; Name: introduction
; Description: 
; 
; Preconditions: 
; Postconditions: 
;
; Receives: 
; Returns:
; -------------------------------------------------------------------------------------------------
introduction	PROC	USES	EBP
	MOV		EBP, ESP									; store new EBP
	
	; introduce the program
	MOV		EDX, [EBP+12]
	CALL	WriteString
	MOV		EDX, [EBP+8]
	CALL	WriteString
	;
	RET		16
introduction	ENDP


; -------------------------------------------------------------------------------------------------
; Name: fillArray
; Description: generate 200 random numbers ...
; 
; Preconditions: 
; Postconditions: 
;
; Receives: 
; Returns:
; -------------------------------------------------------------------------------------------------
fillArray		PROC	USES	EBP
	MOV		EBP, ESP									; store new EBP
;
	CALL displayList
;
	RET
fillArray		ENDP


; -------------------------------------------------------------------------------------------------
; Name: sortList
; Description: generate 200 random numbers ...
; 
; Preconditions: 
; Postconditions: 
;
; Receives: 
; Returns:
; -------------------------------------------------------------------------------------------------
sortList		PROC	USES	EBP
	MOV		EBP, ESP									; store new EBP
;
	CALL	exchangeElements

	CALL	displayList
;
	RET
sortList		ENDP
	; -------------------------------------------------------------------------------------------------
	; Name: exchangeElements
	; Description: generate 200 random numbers ...
	; 
	; Preconditions: 
	; Postconditions: 
	;
	; Receives: 
	; Returns:
	; -------------------------------------------------------------------------------------------------
	exchangeElements	PROC	USES	EBP
		MOV		EBP, ESP									; store new EBP
	;
	;
	;
		RET
	exchangeElements	ENDP


; -------------------------------------------------------------------------------------------------
; Name: displayMedian
; Description: generate 200 random numbers ...
; 
; Preconditions: 
; Postconditions: 
;
; Receives: 
; Returns:
; -------------------------------------------------------------------------------------------------
displayMedian		PROC	USES	EBP
	MOV		EBP, ESP									; store new EBP
;
;
;
	RET
displayMedian		ENDP


; -------------------------------------------------------------------------------------------------
; Name: countList
; Description: generate 200 random numbers ...
; 
; Preconditions: 
; Postconditions: 
;
; Receives: 
; Returns:
; -------------------------------------------------------------------------------------------------
countList		PROC	USES	EBP
	MOV		EBP, ESP									; store new EBP
;
	CALL	displayList
;
	RET
countList		ENDP


; -------------------------------------------------------------------------------------------------
; Name: farewell
; Description: generate 200 random numbers ...
; 
; Preconditions: 
; Postconditions: 
;
; Receives: 
; Returns:
; -------------------------------------------------------------------------------------------------
farewell		PROC	USES	EBP
	MOV		EBP, ESP									; store new EBP
;
;
;
	RET
farewell		ENDP


; -------------------------------------------------------------------------------------------------
; Name: displayList
; Description: this procedure will be called three times for 1) unsorted 2) sorted 3) counts arrays
; 
; Preconditions: 
; Postconditions: 
;
; Receives: 
; Returns:
; -------------------------------------------------------------------------------------------------
displayList			PROC	USES	EBP
	MOV		EBP, ESP									; store new EBP
;
;
;
	RET
displayList			ENDP


END main
