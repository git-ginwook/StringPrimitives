TITLE Project 5     (project5_leeginw.asm)

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
ARRAYSIZE = 300
LO = 10
HI = 60
; expected test ranges
;	LO: 5 to 20
;	HI: 30 to 60 
;	ARRAYSIZE: 20 to 1000

.data

; prompt variables
intro_msg		BYTE		"Generating, Sorting, and Counting Random Integers! "
				BYTE		"Programmed by GinWook lee",13,10,13,10,0

descript_msg	BYTE		"This program generates 200 random numbers in between 15 and 50 and displays: ",13,10
				BYTE		32,"1) the original list of random number array",13,10
				BYTE		32,"2) the median value of the array",13,10
				BYTE		32,"3) the sorted list of the array in ascending order",13,10
				BYTE		32,"4) the number of instances of each random value generated (15~50)",13,10,13,10,0

unsort_msg		BYTE		"The original array of random numbers:",13,10,0

median_msg		BYTE		"The median value of the array: ",0

sort_msg		BYTE		"The sorted array of random numbers in ascending order:",13,10,0

instance_msg	BYTE		"The number of instances of each random number generated:",13,10,0

farewell_msg	BYTE		"Thank you and goodbye!",13,10,0

; global variables
space			BYTE		32,0						; space char
line			DWORD		20							; 20 numbers per line
median			DWORD		?

;counts
randArray		BYTE		ARRAYSIZE DUP(?)

.code
main PROC


; 1. program introduction
	; push program intro and description variables
	PUSH	OFFSET		intro_msg
	PUSH	OFFSET		descript_msg
	CALL	introduction

; 2. generate and display an array of 200 random numbers	
	; push the address and tye type of the empty randArray
	CALL	Randomize									; initialize a random seed
	PUSH	OFFSET		randArray
	PUSH	TYPE		randArray
	CALL	fillArray									; fill randArray with 200 random numbers
	
	; push variables for the displayList procedure
	PUSH	OFFSET		unsort_msg
	PUSH	OFFSET		randArray
	PUSH	LENGTHOF	randArray
	PUSH	OFFSET		space
	PUSH	line
	CALL	displayList									; display the filled randArray

; 3. sort the random list in randArray in ascending order
	; push the address of the randArray
	PUSH	OFFSET		randArray
	CALL	sortList									; sort random numbers in asecending order

	PUSH	OFFSET		median_msg
	CALL	displayMedian								; show the median value

	; push variables for the displayList procedure
	PUSH	OFFSET		sort_msg
	PUSH	OFFSET		randArray
	PUSH	LENGTHOF	randArray
	PUSH	OFFSET		space
	PUSH	line
	CALL	displayList


; 4. count number of instances for each value between LO(15) and HI(50)
	; push
;	PUSH	OFFSET		instance_msg
	
	CALL	countList

	; push variables for the displayList procedure
	PUSH	OFFSET		instance_msg
	PUSH	OFFSET		randArray
	PUSH	HI - LO + 1									; number of values between LO and HI (inclusive)
	PUSH	OFFSET		space
	PUSH	line
	CALL	displayList

; 6. say goodbye
;	push farewell variable to the stack
	PUSH	OFFSET		farewell_msg

	CALL	farewell

	Invoke ExitProcess,0								; exit to operating system
main ENDP

; -------------------------------------------------------------------------------------------------
; Name: introduction
; Description: Introduce the program to the user.
; 
; Preconditions: there is no preconditions for the procedure.
; Postconditions: no changes.
;
; Receives: program introduction and description prompts from 'main' procedure.
;	- parameters: 'intro_msg' (reference, input), 'descript_msg' (reference, input)
; Returns: display program title and description with programmer's name.
; -------------------------------------------------------------------------------------------------
introduction	PROC	USES	EBP
	MOV		EBP, ESP									; set new EBP
	
	; preserve register to be used
	PUSH	EDX

	; introduce the program 
	MOV		EDX, [EBP+12]								; OFFSET intro_msg
	CALL	WriteString
	MOV		EDX, [EBP+8]								; OFFSET descript_msg
	CALL	WriteString
	
	; restore register used
	POP		EDX

	RET		8											; two passed parameters
introduction	ENDP


; -------------------------------------------------------------------------------------------------
; Name: fillArray
; Description: fill the empty array with 200 random numbers in the range between 15 and 50.
; 
; Preconditions: initialize the starting seed value for 'RandomRange' procedure by calling 'Randomize'.
; Postconditions: no changes.
;
; Receives: memory address and the number of bytes in 'randArray'.
;	- parameters: 'randArray' (reference, input), 'TYPE randArray' (value, input),
;					'randArray' (reference, output)
; Returns: randArray should be filled with new 200 random numbers in the range between 15 and 50.
; -------------------------------------------------------------------------------------------------
fillArray		PROC	USES	EBP
	MOV		EBP, ESP									; set new EBP
	
	; preserve registers to be used
	PUSH	EAX
	PUSH	ECX
	PUSH	EDI

	; set registers
	MOV		ECX, ARRAYSIZE								; ARRAYSIZE(200) into ECX
	MOV		EDI, [EBP+12]								; address of randArray into EDI

	; generate 200 random numbers
_randGenerator:
	MOV		EAX, HI - LO + 1							; set the upper limit
	CALL	RandomRange									; produce a random integer
	ADD		EAX, LO										; range correction 

	MOV		[EDI], EAX									; overwrite value in randArray
	ADD		EDI, [EBP+8]								; increment EDI by 1 byte
	LOOP	_randGenerator

	; restore registers used in this procedure
	POP		EDI
	POP		ECX
	POP		EAX

	RET		8											; three passed parameters
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
	MOV		EBP, ESP									; set new EBP

	; preserve registers
	PUSH	ECX
	
	; set registers
	MOV		ECX, ARRAYSIZE
	DEC		ECX

	MOV		ESI, [EBP+8]
	MOV		EDI, [EBP+8]
	INC		EDI

_exchange:
	CALL	exchangeElements							
	LOOP	_exchange									; _exchange (x200)
	
	; restore registers
	POP		ECX
	
	RET		4
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
		MOV		EBP, ESP									; set new EBP
		
		; preserve registers
		PUSH	EAX
		PUSH	EBX
		PUSH	ECX
		PUSH	EDX
		PUSH	ESI
		PUSH	EDI

		; set registers
		MOV		EAX, 0
		MOV		EBX, 0
		MOV		EDX, 0

		; compare the current and next indices
	_bubble:
		MOV		EAX, [ESI]
		MOV		EBX, [EDI]

		CMP		AL, BL
		JA		_moveRight

		; move to the next pair of indices
		INC		ESI
		INC		EDI

		LOOP	_bubble
		JMP		_returnSort

	_moveRight:
		MOV		[ESI], BL
		MOV		[EDI], AL

		; move to the next pair of indices
		INC		ESI
		INC		EDI

		LOOP	_bubble

		; restore registers
	_returnSort:
		POP		EDI
		POP		ESI
		POP		EDX
		POP		ECX
		POP		EBX
		POP		EAX

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
	MOV		EBP, ESP									; set new EBP

	; preserve register to be used
	PUSH	EDX
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX

	; display a message prompt for displayMedian
	MOV		EDX, [EBP+8]								; OFFSET median_msg
	CALL	WriteString
	
	; set registers

	MOV		EAX, ARRAYSIZE
	MOV		EBX, 2
	MOV		EDX, 0
	
	INC		EAX
	DIV		EBX

	MOV		ECX, EAX
	MOV		EAX, 0

	CMP		EDX, 0
	JE		_odd

	; even

	; get the middle two values
	MOV		AL, [randArray + ECX * TYPE randArray]
	DEC		ECX
	MOV		DL, [randArray + ECX * TYPE randArray]

	; 
	ADD		AL, DL
	DIV		BL

	; quotient AL remainder AH
	CMP		AH, 0
	JNE		_roundUp
	JMP		_showMedian

_roundUp:
	MOV		AH, 0
	INC		AL
	JMP		_showMedian
	
_odd:
	DEC		ECX
	MOV		AL, [randArray + ECX * TYPE randArray]


	; show the median value
_showMedian:
	CALL	WriteDec
	CALL	CrLf
	CALL	CrLf
	
	; restore register
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EDX

	RET		4
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
	MOV		EBP, ESP									; set new EBP
	; preserve registers

	; write prompt


	; set registers

	; 
_inRange:

	; count instances (for each value in the range between LO(15) and HI(50))
_countLoop:
	


	; store each count in randArray


	; restore registers
_nextProc:


	RET
countList		ENDP


; -------------------------------------------------------------------------------------------------
; Name: farewell
; Description: end the program with a goodbye message to the user.
; 
; Preconditions: all displays, including the original list, the median value, sorted list, and
;				list of instances, are successfully shown to the user.
; Postconditions: no changes.
;
; Receives: farewell prompts from 'main' procedure.
;	- parameter: 'farewell_msg' (reference, input)
; Returns: display the goodbye message.
; -------------------------------------------------------------------------------------------------
farewell		PROC	USES	EBP
	MOV		EBP, ESP									; set new EBP
	
	; preserve a register
	PUSH	EDX

	; say goodbye to the user
	CALL	CrLf
	MOV		EDX, [EBP+8]								; OFFSET farewell_msg
	CALL	WriteString
	
	; restore a register
	POP		EDX

	RET		4											; one passed parameter
farewell		ENDP


; -------------------------------------------------------------------------------------------------
; Name: displayList
; Description: this procedure will be called three times to display 1) unsorted 2) sorted 3) counts arrays
; 
; Preconditions: for each procedure call, 'randArray' is filled with values from matching procedure:
;				1) unsorted array from fillArray procedure
;				2) sorted array from sortList procedure
;				3) counts array from countList procedure
; Postconditions: no changes.
;
; Receives: five parameters to show a message prompt and variables to display numbers in 'randArray'.
;	- parameters: 'unsort_msg' (reference, input), 'randArray' (reference, input), 
;					number of values to display* (value, input), 'space' (reference, input), line (value, input)
;	* 1 & 2) for sorted/unsorted arrays: 'LENGTHOF randArray' 3) for counts array: 'HI - LO + 1'
; Returns: display a message prompt and values in 'randArray'.  
; -------------------------------------------------------------------------------------------------
displayList			PROC	USES	EBP
	MOV		EBP, ESP									; set new EBP
	
	; preserve registers to be used
	PUSH	ESI
	PUSH	ECX
	PUSH	EDX
	PUSH	EBX
	PUSH	EAX

	; write prompt
	MOV		EDX, [EBP+24]
	CALL	WriteString

	; set registers
	MOV		ESI, [EBP+20]								; first address into ESI
	MOV		ECX, [EBP+16]								; length into ECX
	MOV		EDX, [EBP+12]								; space char " " into EDX
	MOV		EBX, [EBP+8]								; line count(20) into EBX
	MOV		EAX, 0										; reset EAX to zero

	; diplay the filled array
_displayLoop:
	MOV		AL, [ESI]
	CALL	WriteDec									; display the value pointed by ESI
	CALL	WriteString									; space char " "
	
	INC		ESI											; increment ESI by 1 byte for the next value in array
	DEC		EBX											; decrement EBX by 1 to count down values in a line
	
	JZ		_newLine									; if 20 values in a line reached, jump to _newLine

	LOOP	_displayLoop								; display values in the array one at a time
	JMP		_nextProc

_newLine:
	CALL	CrLf										; move to the next line 
	MOV		EBX, [EBP+8]								; reset line counter to 20
	LOOP	_displayLoop								; display values in the array one at a time

	; restore registers used
_nextProc:
	CALL	CrLf
	
	POP		EAX
	POP		EBX
	POP		EDX
	POP		ECX
	POP		ESI

	RET		20											; five passed parameters
displayList			ENDP


END main
