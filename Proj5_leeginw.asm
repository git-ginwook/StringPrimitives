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
intro_msg		BYTE			"Generating, Sorting, and Counting Random Integers! "
				BYTE			"Programmed by GinWook lee",13,10,13,10,0

descript_msg	BYTE			"This program generates 200 random numbers in a given range and displays: ",13,10
				BYTE			09,"1) the original list of random number array",13,10
				BYTE			09,"2) the median value of the array",13,10
				BYTE			09,"3) the sorted list of the array in ascending order",13,10
				BYTE			09,"4) the number of instances of each random value generated",13,10,13,10,0

unsort_msg		BYTE			"The original array of random numbers:",13,10,0

median_msg		BYTE			"The median value of the array: ",0

sort_msg		BYTE			"The sorted array of random numbers in ascending order:",13,10,0

instance_msg	BYTE			"The number of instances of each random number generated:",13,10,0

farewell_msg	BYTE			"Thank you and goodbye!",13,10,0

; array and count variables
;randArray
;counts


.code
main PROC


; 1. program introduction
	; push program intro and description variables to the stack
	PUSH	OFFSET intro_msg
	PUSH	OFFSET descript_msg

	CALL	introduction


; 2. generate an array of 200 random numbers	
	CALL	fillArray
	
	CALL	sortList
	
	CALL	displayMedian
	
	CALL	countList


; 6. say goodbye
;	push farewell variable to the stack
	PUSH	OFFSET farewell_msg

	CALL	farewell

	Invoke ExitProcess,0								; exit to operating system
main ENDP

; -------------------------------------------------------------------------------------------------
; Name: introduction
; Description: Introduce the program to the user.
; 
; Preconditions: there is no preconditions for the procedure.
; Postconditions: EDX has the address of 'descript_msg'.
;
; Receives: program introduction and description prompts from 'main' procedure.
;	- parameters: 'intro_msg' (reference, input), 'descript_msg' (reference, input)
; Returns: display program title and description with programmer's name.
; -------------------------------------------------------------------------------------------------
introduction	PROC	USES	EBP
	MOV		EBP, ESP									; set new EBP
	
	; introduce the program 
	MOV		EDX, [EBP+12]								; OFFSET intro_msg
	CALL	WriteString
	MOV		EDX, [EBP+8]								; OFFSET descript_msg
	CALL	WriteString
	
	RET		8											; two passed parameters
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
displayMedian	PROC	USES	EBP
	MOV		EBP, ESP									; store new EBP
;
;
;
	RET
displayMedian	ENDP


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
; Description: end the program with a goodbye message to the user.
; 
; Preconditions: all displays, including the original list, the median value, sorted list, and
;				list of instances, are successfully shown to the user.
; Postconditions: EDX has the address of 'farewell_msg'.
;
; Receives: farewell prompts from 'main' procedure.
;	- parameter: 'farewell_msg' (reference, input)
; Returns: display the goodbye message.
; -------------------------------------------------------------------------------------------------
farewell		PROC	USES	EBP
	MOV		EBP, ESP									; store new EBP
	
	; say goodbye to the user
	MOV		EDX, [EBP+8]								; OFFSET farewell_msg
	CALL	WriteString
	
	RET		4											; one passed parameter
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
