TITLE Integer Accumulator      (project3_leeginw.asm)

; Author: GinWook Lee
; Last Modified: 1/31/2022
; OSU email address: leeginw@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number: 03
; Due Date: 2/7/2022
; Description: TBD

INCLUDE Irvine32.inc

; (insert macro definitions here)

; range boundaries in constant values
LOW_BOUND		=	-200
MIDLOW_BOUND	=	-100
MIDHIGH_BOUND	=	-50
HIGH_BOUND		=	-1

.data

	; messages
	msg_welcome				BYTE		"Welcome to the Integer Accumulator by GinWook Lee",13,10,0
	
	ask_name				BYTE		"What is your name? ",0
	msg_greet				BYTE		"Hello there, ",0
	
	instruction_1			BYTE		"Please enter numbers in [-200, -100] or [-50, -1].",13,10,0
	instruction_2			BYTE		"Enter a non-negative number when you are finished to see results.",13,10,0

	ask_val					BYTE		"Enter number: ",0

	msg_error				BYTE		"Number Invalid!",13,10,0
	msg_zeroValid			BYTE		"There is no valid input.",13,10,0

	msg_goodbye				BYTE		"Goodbye, ",0
	
	; user inputs
	user_name				BYTE		33 DUP(0)
	
	; result variables
	count					SDWORD		?
	sum						SDWORD		?
	avg						SDWORD		?
	min						SDWORD		-1					; highest value within the valid number range
	max						SDWORD		-200				; lowest value within the valid number range

	; result messages
	msg_count_1				BYTE		"You entered ",0
	msg_count_2				BYTE		" valid numbers.",0
	msg_sum					BYTE		"The sum of your valid numbers is ",0
	msg_avg					BYTE		"The rounded (to the nearest integer) average is ",0
	msg_max					BYTE		"The maximum valid number is ",0
	msg_min					BYTE		"The minimum valid number is ",0

.code
main PROC

	; 1. display the program title and programmer's name
	MOV		EDX, OFFSET		msg_welcome
	CALL	WriteString
	
	; 2. get the user's name, and greet the user
	MOV		EDX, OFFSET		ask_name
	CALL	WriteString
	
	MOV		EDX, OFFSET		user_name
	MOV		ECX, 32
	CALL	ReadString

	MOV		EDX, OFFSET		msg_greet
	CALL	WriteString
	MOV		EDX, OFFSET		user_name
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf

	; 3. display instructions for the user
_instruction:
	MOV		EDX, OFFSET		instruction_1
	CALL	WriteString
	MOV		EDX, OFFSET		instruction_2
	CALL	WriteString
	CALL	CrLf

	; -------------------------------------------------------------
	; 4. repeatedly prompt the user to enter a number
	;	a. validate the user input to be in [-200, -100] or [-50, -1] inclusive
	;	b. notify the user of any invalid negative numbers (negative but not in range)
	;	c. count and accumulate the valid user numbers (until a non-negative number)
	;	d. set min and max values among valid user numbers
	; -------------------------------------------------------------

	;	a. validate the user input
_input:
	MOV		EDX, OFFSET		ask_val
	CALL	WriteString
	CALL	ReadInt							; get user integer in EAX
	
	MOV		EBX, EAX
	JZ		_check							; if 0; jump to _check
	JNS		_check							; if positive(non-negative): jump to _check

	CMP		EAX, LOW_BOUND						
	JL		_invalid						; if (-infinity, -200): jump to _invalid 
	
	CMP		EAX, MIDLOW_BOUND						
	JLE		_valid							; if [-200, -100]: jump to _valid 

	CMP		EAX, MIDHIGH_BOUND
	JL		_invalid						; if (-100, -50): jump to _invalid	
	
	CMP		EAX, HIGH_BOUND
	JLE		_valid							; if [-50, -1]: jump to _valid

	;	b. notify the user of any invalid negative numbers
_invalid:
	MOV		EDX, OFFSET		msg_error
	CALL	WriteString
	JMP		_input

	;	c. count and accumulate the valid user numbers
_valid:
	
	INC		count							; increase valid number count by 1
	ADD		sum, EAX						; accumulate the valid numbers
	
	;	d. set min and max values among valid user numbers	

	CMP		EAX, min
	JL		_changeMin						; if the valid input is less than the current min, jump to _changeMin
	JMP		_max							; if not, keep the current min

_changeMin:
	MOV		min, EAX

_max:
	CMP		EAX, max
	JG		_changeMax						; if the valid input is greater than the current max, jump to _changeMax
	JMP		_input							; if not, keep the current max

_changeMax:
	MOV		max, EAX
	JMP		_input

	; -------------------------------------------------------------
	; 5. calculate the average (rounded) of the valid numbers and store in a variable
	;		a. check if there is at least one valid number. 
	;			i. If none, skip to _zeroValid followed by _goodbye
	;		b. divide sum by count to get the quotient
	;		c. round the quotient up or down based on the remainder
	; -------------------------------------------------------------

	;	a. check if there is at least one valid number
_check:
	CMP		count, 0
	JNE		_average						; if there is at least one valid input: jump to _average

	;		a.i. special message indicating that there is no valid input
_zeroValid:
	MOV		EDX, OFFSET		msg_zeroValid
	CALL	WriteString
	JMP		_goodbye

	;	b. divide sum by count to get the quotient
_average:
	MOV		EAX, sum
	CDQ
	IDIV	count
	MOV		avg, EAX						; store the quotient in avg

	;	c. round the quotient up or down based on the remainder
	IMUL	EAX, EDX, -2					; remiander * -2 
	CMP		EAX, count						
	JLE		_display						; if (remainder * -2) <= divisor: round up [e.g., -20.5 to -20]

	DEC		avg								; if (remainder * -2) > divisor: round down [e.g., -20.51 to -21]

	; -------------------------------------------------------------
	; 6. display:
	;	a. count of validated numbers entered
	;	b. sum of valid numbers
	;	c. maximum valid user value entered
	;	d. minimum valid user value entered
	;	e. average of valid numbers (rounded to the nearest integer)
	;	f. parting message (with the user's name)
	; -------------------------------------------------------------
_display:
	
	;	a. count of validated numbers entered
	CALL	CrLf
	MOV		EDX, OFFSET		msg_count_1
	CALL	WriteString
	MOV		EAX, count
	CALL	WriteDec
	MOV		EDX, OFFSET		msg_count_2
	CALL	WriteString
	CALL	CrLf

	;	b. sum of valid numbers
	MOV		EDX, OFFSET		msg_sum
	CALL	WriteString
	MOV		EAX, sum
	CALL	WriteInt
	Call	CrLf

	;	c. maximum valid user value entered
	MOV		EDX, OFFSET		msg_max
	CALL	WriteString
	MOV		EAX, sum
	CALL	WriteInt
	Call	CrLf

	;	d. minimum valid user value entered
	MOV		EDX, OFFSET		msg_min
	CALL	WriteString
	MOV		EAX, sum
	CALL	WriteInt
	Call	CrLf

	;	e. average of valid numbers (rounded to the nearest integer)
	MOV		EDX, OFFSET		msg_avg
	CALL	WriteString
	MOV		EAX, avg
	CALL	WriteInt
	Call	CrLf

	;	f. parting message with the user name
_goodbye:
	CALL	CrLf
	MOV		EDX, OFFSET		msg_goodbye
	CALL	WriteString
	MOV		EDX, OFFSET		user_name
	CALL	WriteString

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
