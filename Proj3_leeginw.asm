TITLE Integer Accumulator      (project3_leeginw.asm)

; Author: GinWook Lee
; Last Modified: 2/5/2022
; OSU email address: leeginw@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number: 03
; Due Date: 2/7/2022
; Description: This program takes in negative integers either between -200 and -100 or between -50 and -1.
;				The program validates user inputs to check whether the inputs are within the specified ranges.
;				Once user enters a non-negative integers, zero or above, the program switches to the
;				calculate-and-display mode. User will be able to see the maximum, minimum, sum, and average of 
;				the valid inputs they put in.
;				**Extra Cerdits:
;					1) Display line numbers during user inputs and increment the numbers only for valid entries
;					2) Round to the nearest hundredth decimal point (e.g., 0.01) without the Floating Point Unit

INCLUDE Irvine32.inc

; (insert macro definitions here)

; valid range boundaries in constant values
LOW_BOUND		=	-200
MIDLOW_BOUND	=	-100
MIDHIGH_BOUND	=	-50
HIGH_BOUND		=	-1

.data

	; messages
	msg_welcome				BYTE		"Welcome to the Integer Accumulator by GinWook Lee",13,10,0
	
	ask_name				BYTE		13,10,"What is your name? ",0
	msg_greet				BYTE		13,10,"Hello there, ",0
	
	instruction_1			BYTE		"Please enter integer numbers in [-200, -100] or [-50, -1].",13,10,0
	instruction_2			BYTE		"Enter a non-negative integer when you are finished to see results.",13,10,0

	ask_val					BYTE		"Enter integer: ",0

	msg_error				BYTE		"Number Invalid!",13,10,0
	msg_zeroValid			BYTE		"There is no valid input.",13,10,0

	msg_goodbye				BYTE		"Goodbye, ",0
	
	; user inputs
	user_name				BYTE		33 DUP(0)

	; result variables
	count					SDWORD		?
	sum						SDWORD		?
	quotient1				SDWORD		?
	min						SDWORD		?
	max						SDWORD		?

	; result messages
	msg_count_1				BYTE		"You entered ",0
	msg_count_2				BYTE		" valid numbers.",0
	msg_sum					BYTE		"The sum of your valid numbers is ",0
	msg_avg1				BYTE		"The rounded (to the nearest integer) average is ",0
	msg_max					BYTE		"The maximum valid number is ",0
	msg_min					BYTE		"The minimum valid number is ",0

	; [Extra Credit #1] prompt and variables
	extra_1					BYTE		13,10,"**EC#1: Each user input will be numbered. "
							BYTE		"And the line number increases only after a valid input.",13,10,0
	
	line_number				DWORD		1
	ask_val_line			BYTE		". ",0

	; [Extra Credit #2] prompts and variables
	extra_2					BYTE		"**EC#2: The second average will be displayed to the nearest hundredth decimal point.",13,10,0
	msg_avg2				BYTE		"The rounded (to the nearest hundredth) average is ",0
	dec_point				BYTE		".",0
	tenth					BYTE		"0",0

	quotient2				SDWORD		?
	decimal					DWORD		?

.code
main PROC

	; 1. display the program title and programmer's name
	MOV		EDX, OFFSET		msg_welcome	
	CALL	WriteString							; "Welcome to the Integer Accumulator by GinWook Lee"

	; [EC#1] display description for the extra credit #1
	MOV		EDX, OFFSET		extra_1
	CALL	WriteString							; prompt for extra credit #1

	; [EC#2] display description for the extra credit #2
	MOV		EDX, OFFSET		extra_2
	CALL	WriteString							; prompt for extra credit #2

	; 2. get the user's name, and greet the user
	MOV		EDX, OFFSET		ask_name
	CALL	WriteString							; "What is your name? "
	
	MOV		EDX, OFFSET		user_name
	MOV		ECX, 32
	CALL	ReadString							; save user_name

	MOV		EDX, OFFSET		msg_greet
	CALL	WriteString							; "Hello there, "
	MOV		EDX, OFFSET		user_name
	CALL	WriteString							; display user_name
	CALL	CrLf
	CALL	CrLf

	; 3. display instructions for the user
_instruction:
	MOV		EDX, OFFSET		instruction_1
	CALL	WriteString							; "Please enter integer numbers in [-200, -100] or [-50, -1]."
	MOV		EDX, OFFSET		instruction_2
	CALL	WriteString							;"Enter a non-negative integer when you are finished to see results."
	CALL	CrLf

	; -------------------------------------------------------------
	; 4. repeatedly prompt the user to enter a number
	;	[EC#1] display line numbers for user inputs
	;	a. validate the user input to be in [-200, -100] or [-50, -1] inclusive
	;	b. notify the user of any invalid negative numbers (negative but not in range)
	;	c. count and accumulate the valid user numbers (until a non-negative number)
	;	d. set min and max values among valid user numbers
	; -------------------------------------------------------------

	;	[EC#1] display the line number
_input:
	MOV		EAX, line_number
	CALL	WriteDec						; display line_number
	MOV		EDX, OFFSET		ask_val_line
	CALL	WriteString						; ". "

	;	a. validate the user input	
	MOV		EDX, OFFSET		ask_val
	CALL	WriteString						; "Enter integer: "
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
	CALL	WriteString						; "Number Invalid!"
	JMP		_input

	;	c. count and accumulate the valid user numbers
_valid:
	INC		count							; increase valid number count by 1
	;	[EC#1] increment the line number only for valid entries
	INC		line_number						; increase line number by 1
	ADD		sum, EAX						; accumulate the valid numbers
	
	;	d. set min and max values among valid user numbers	
	CMP		count, 1
	JE		_initial						; if the input is the first valid number, jump to _initial
	JMP		_minmax							; if not, jump to _minmax

_initial:
	MOV		min, EAX						; set the first valid number as min
	MOV		max, EAX						; set the first valid number as max
	JMP		_input

_minmax:
	CMP		EAX, min
	JL		_changeMin						; if the valid input is less than the current min, jump to _changeMin
	JMP		_max							; if not, keep the current min

_changeMin:
	MOV		min, EAX						; switch min

_max:
	CMP		EAX, max
	JG		_changeMax						; if the valid input is greater than the current max, jump to _changeMax
	JMP		_input							; if not, keep the current max

_changeMax:
	MOV		max, EAX						; switch max
	JMP		_input

	; -------------------------------------------------------------
	; 5. calculate the average (rounded) of the valid numbers and store in a variable
	;		a. check if there is at least one valid number. 
	;			i. If none, skip to _zeroValid followed by _goodbye
	;		b. divide sum by count to get the quotient
	;		c. round the quotient up or down based on the remainder
	;		[EC#2] calculate the second average rounded to the nearest hundredth decimal point
	; -------------------------------------------------------------

	;	a. check if there is at least one valid number
_check:
	CMP		count, 0
	JNE		_average						; if there is at least one valid input: jump to _average

	;		a.i. special message indicating that there is no valid input
_zeroValid:
	MOV		EDX, OFFSET		msg_zeroValid
	CALL	WriteString						; "There is no valid input."
	JMP		_goodbye

	;	b. divide sum by count to get the quotient
_average:
	MOV		EAX, sum
	CDQ
	IDIV	count
	MOV		quotient1, EAX					; store the quotient in quotient1
	
	;	[EC#2] store the quotient for the second calculation for average
	MOV		quotient2, EAX					; store the quotient in quotient2

	;	c. round the quotient up or down based on the remainder
	IMUL	EAX, EDX, -2					; remainder * -2 
	CMP		EAX, count						
	JLE		_anotherAverage					; if (remainder * -2) <= divisor: round up [e.g., -20.5 to -20]

	DEC		quotient1						; if (remainder * -2) > divisor: round down [e.g., -20.51 to -21]

	;	[EC#2] calculate another average rounded to the nearest hundredth
_anotherAverage:
	IMUL	EAX, EDX, -100					; remainder * -100
	CDQ
	IDIV	count							; divide by count (divisor)
	MOV		decimal, EAX
	
	;	[EC#2] round up or down based on the remainder
	IMUL	EAX, EDX, 2						; remainder * 2 
	CMP		EAX, count						
	JLE		_display						; if (remainder * 2) <= divisor: round down [e.g., 20.5 to 20]

	INC		decimal							; if (remainder * 2) > divisor: round up [e.g., 20.51 to 21]

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
	CALL	WriteString						; "You entered "
	MOV		EAX, count
	CALL	WriteDec						; display count
	MOV		EDX, OFFSET		msg_count_2
	CALL	WriteString						; " valid numbers."
	CALL	CrLf

	;	b. sum of valid numbers
	MOV		EDX, OFFSET		msg_sum
	CALL	WriteString						; "The sum of your valid numbers is "
	MOV		EAX, sum
	CALL	WriteInt						; display sum
	Call	CrLf

	;	c. maximum valid user value entered
	MOV		EDX, OFFSET		msg_max
	CALL	WriteString						; "The maximum valid number is "
	MOV		EAX, max
	CALL	WriteInt						; display max
	Call	CrLf

	;	d. minimum valid user value entered
	MOV		EDX, OFFSET		msg_min
	CALL	WriteString						; "The minimum valid number is "
	MOV		EAX, min
	CALL	WriteInt						; display min
	Call	CrLf

	;	e. average of valid numbers (rounded to the nearest integer)
	MOV		EDX, OFFSET		msg_avg1
	CALL	WriteString						; "The rounded (to the nearest integer) average is "
	MOV		EAX, quotient1
	CALL	WriteInt						; display quotient1
	Call	CrLf

	;	[EC#2] average of valid numbers (rounded to the nearest hundredth)
	MOV		EDX, OFFSET		msg_avg2
	CALL	WriteString						; "The rounded (to the nearest hundredth) average is "
	
	MOV		EAX, quotient2
	CALL	WriteInt						; display quotient2
	MOV		EDX, OFFSET		dec_point
	CALL	WriteString						; "."
	
	
	CMP		decimal, 10						; check if decimal is smaller than 10
	JL		_append							; if decimal < 10, jump to _append
	
	MOV		EAX, decimal
	CALL	WriteDec						; display decimal
	CALL	CrLf
	JMP		_goodbye

_append:
	MOV		EDX, OFFSET		tenth
	CALL	WriteString						; "0" append zero in the tenth decimal
	MOV		EAX, decimal
	CALL	WriteDec						; display decimal
	CALL	CrLF

	;	f. parting message with the user name
_goodbye:
	CALL	CrLf
	MOV		EDX, OFFSET		msg_goodbye
	CALL	WriteString						; "Goodbye, "
	MOV		EDX, OFFSET		user_name
	CALL	WriteString						; display user_name

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
