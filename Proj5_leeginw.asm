TITLE Project 5     (project5_leeginw.asm)

; Author: GinWook Lee
; Last Modified: 3/2/2022
; OSU email address: leeginw@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 05
; Due Date: 3/2/2022 + 2 grace days
; Description: This program generates a random list, sorts it in ascending order, finds the median value,
;				and counts the number of instances of each random value generated. 
;				The program follows a strict boundary defined by global constants:
;					1) the total number of elements in a random list is limited to ARRAYSIZE,
;					2) the lowest possible value is set by LO,
;					3) and the highest possible value is determined by HI.
;				The proram displays each result in an orderly manner (20 numbers per line evenly spaced out).		

INCLUDE Irvine32.inc

; global constants
ARRAYSIZE = 200
LO = 15
HI = 50
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

instance_msg	BYTE		"The number of instances of each random number generated (15~50):",13,10,0

farewell_msg	BYTE		"Thank you and goodbye!",13,10,0

; global variables
space			BYTE		32,0						; space char
line			DWORD		20							; 20 numbers per line

randArray		BYTE		ARRAYSIZE DUP(?)
counts			BYTE		HI - LO + 1 DUP(?)

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

; 3. sort the random list in randArray in ascending order and display the median value
	; push the address of the randArray
	PUSH	OFFSET		randArray
	CALL	sortList									; sort random numbers in asecending order

	; push median message to the stack
	PUSH	OFFSET		median_msg
	CALL	displayMedian								; show the median value

	; push variables for the displayList procedure
	PUSH	OFFSET		sort_msg
	PUSH	OFFSET		randArray
	PUSH	LENGTHOF	randArray
	PUSH	OFFSET		space							; space char
	PUSH	line										; 20 elements per line
	CALL	displayList


; 4. count number of instances for each value between LO(15) and HI(50)
	; push the addresses of randArray and counts arrays 
	PUSH	TYPE		randArray
	PUSH	OFFSET		randArray
	PUSH	OFFSET		counts							; new empty array to hold the number of instances
	CALL	countList

	; push variables for the displayList procedure
	PUSH	OFFSET		instance_msg
	PUSH	OFFSET		counts
	PUSH	LENGTHOF	counts							; number of values between LO and HI (inclusive)
	PUSH	OFFSET		space
	PUSH	line
	CALL	displayList

; 5. say goodbye
;	push farewell message to the stack
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

	RET		8											; two passed parameters
fillArray		ENDP


; -------------------------------------------------------------------------------------------------
; Name: sortList
; Description: sort the original array with 200 random numbers in ascending order.
; 
; Preconditions: proper execution of the fillArray procedure to generate 200 random numbers within
;					the given range [15, 50] in randArray.
; Postconditions: no changes.
;
; Receives: meemory address of 'randArray' 
;	- parameters: 'randArray' (reference, input), 'randArray' (reference, output)
; Returns: randArray should be sorted in asecending order.
; -------------------------------------------------------------------------------------------------
sortList		PROC	USES	EBP
	MOV		EBP, ESP									; set new EBP

	; preserve registers
	PUSH	ECX
	
	; set registers
	MOV		ECX, ARRAYSIZE
	DEC		ECX
	MOV		ESI, [EBP+8]								; address of the first value in randArray
	MOV		EDI, [EBP+8]								
	INC		EDI											; address of the second value in randArray

_exchange:
	CALL	exchangeElements							
	LOOP	_exchange									; repeat until the bubble sort is complete
	
	; restore registers
	POP		ECX
	
	RET		4											; one passed parameter
sortList		ENDP
	; -------------------------------------------------------------------------------------------------
	; Name: exchangeElements
	; Description: run one cycle of the bubble sort method until all the numbers in randArray gets sorted.
	; 
	; Preconditions: initial execution of this procedure requires ESI and EDI to point to the first and 
	;				the second value of randArray. Each subsequent call of this procedure also needs
	;				a decremented ECX from sortList to minimize the unncessary sorting. 
	; Postconditions: no changes.
	;
	; Receives: memory addresses of the first and second value in 'randArray'
	; Returns: each nth exchange returns more sorted array with the nth largest value positioned at 
	;			the right end of the array (from the largest to smallest in reverse order).
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

		; initialize registers
		MOV		EAX, 0
		MOV		EBX, 0
		MOV		EDX, 0

		; compare the current and next indices
	_bubble:
		MOV		EAX, [ESI]									; prep to convert into a 8-bit register
		MOV		EBX, [EDI]									; prep to convert into a 8-bit register

		CMP		AL, BL
		JA		_moveRight

		; move to the next pair of indices
		INC		ESI
		INC		EDI

		LOOP	_bubble
		JMP		_returnSort

		; switch positions of the two values
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

		RET													; return to sortList
	exchangeElements	ENDP


; -------------------------------------------------------------------------------------------------
; Name: displayMedian
; Description: calculate the median value of the sorted list in randArray and display it to the user.
; 
; Preconditions: proper execution of the sortList procedure to have 200 random numbers sorted in
;				ascending order.
; Postconditions: no changes.
;
; Receives: a message prompt to show the median value.
;	- parameters: 'median_msg' (reference, input)
; Returns: the median value is shown to the user.
; -------------------------------------------------------------------------------------------------
displayMedian	PROC	USES	EBP
	MOV		EBP, ESP									; set new EBP

	; preserve registers
	PUSH	EDX
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX

	; display a message prompt for the displayMedian procedure
	MOV		EDX, [EBP+8]								; OFFSET median_msg
	CALL	WriteString
	
	; set registers
	MOV		EAX, ARRAYSIZE								; dividend
	MOV		EBX, 2										; divisor
	MOV		EDX, 0										; remainder
	
	; find the middle value
	INC		EAX
	DIV		EBX											; (number of elements + 1) / 2

	MOV		ECX, EAX									; move the quotient to ECX
	MOV		EAX, 0

	CMP		EDX, 0										; if remainder is zero, jump to _odd
	JE		_odd


	; if raminder is not zero (even), get the middle two values
	MOV		AL, [randArray + ECX * TYPE randArray]		; address of randArray + (quotient * 1)
	DEC		ECX
	MOV		DL, [randArray + ECX * TYPE randArray]		; address od randArray + ((quotient-1) * 1)

	; combine the middle two values (as a 8-bit reigster) for another division
	ADD		AL, DL
	DIV		BL											; divisor = 2 to get the average of the two values
	
	; rounding the average
	CMP		AH, 0										; remainder(AH) : quotient(AL) 
	JNE		_roundUp									; if remainder is not zero, jump to _roundUp
	JMP		_showMedian									; if remainder is zero, jump to _showMedian

_roundUp:
	MOV		AH, 0										; set the upper register(AH) of AX to zero
	INC		AL											; round up
	JMP		_showMedian
	
_odd:
	DEC		ECX
	MOV		AL, [randArray + ECX * TYPE randArray]		; address of randArray + ((quotient-1) * 1)


	; show the median value
_showMedian:
	CALL	WriteDec									; EAX cleared other than the 8-bit register(AL)
	CALL	CrLf
	CALL	CrLf
	
	; restore registers
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EDX

	RET		4											; one passed parameter									
displayMedian	ENDP


; -------------------------------------------------------------------------------------------------
; Name: countList
; Description: count the number of instances of each value generated in randArray within the given 
;				range [15,50]. Then, store each count in counts array starting with the lowest value(15). 
;				Once the highest value(50) is counted, counts array is displayed to the user.
; 
; Preconditions: proper execution of the sortList procedure to have 200 random numbers sorted in
;				ascending order.
; Postconditions: no changes.
;
; Receives: memory addresses of 'randArray' and 'counts, plus data size of 'randArray'
;	- parameters: 'TYPE randArray' (value, input), 'randArray' (reference, input), 'counts' (reference, input)
;					'counts' (reference, output)
; Returns: counts array should be filled with number of instances of each value in randArray.
; -------------------------------------------------------------------------------------------------
countList		PROC	USES	EBP
	MOV		EBP, ESP									; set new EBP
	; preserve registers
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	ESI
	PUSH	EDI

	; set registers
	MOV		EAX, 0
	MOV		EBX, LO										; starting counting target (15)
	MOV		ECX, ARRAYSIZE								; move through 200 values
	MOV		ESI, [EBP+12]								; address of randArray
	MOV		EDI, [EBP+8]								; address of counts

	; 
_count:
	CMP		[ESI], BL									; value in randArray vs. counting target 
	JE		_addCount									; if value == counting target, jump to _addCount
	MOV		[EDI], AL									; store the current count in counts array
	ADD		EDI, [EBP+16]								; increment EDI by 1
	MOV		EAX, 0										; reset count to zero
	INC		EBX
	JMP		_count

_addCount:
	INC		EAX											; increase count
	ADD		ESI, [EBP+16]								; increment ESI by 1
	LOOP	_count
	
	MOV		[EDI], AL									; append the last count to the counts array

	; restore registers
	POP		EDI
	POP		ESI
	POP		ECX
	POP		EBX
	POP		EAX

	RET		12
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
	MOV		EDX, [EBP+24]								; msg prompt
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
