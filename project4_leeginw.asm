TITLE Prime Numbers     (project4_leeginw.asm)

; Author: GinWook Lee
; Last Modified: 2/18/2022
; OSU email address: leeginw@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 04
; Due Date: 2/20/2022
; Description: 

INCLUDE Irvine32.inc

; (insert macro definitions here)

; user input range (when n is an integer, 1 <= n <=200)
LOWER_BOUND = 1
UPPER_BOUND = 200

.data

; instruction prompt
msg_intro			BYTE		"Prime Numbers programmed by GinWook Lee",13,10,13,10,0
instruction			BYTE		"Enter the number of prime numbers you would like to see.",13,10
					BYTE		"I will accept orders for up to 200 primes.",13,10,13,10,0

; user input
ask_num				BYTE		"Enter the number of primes to display [1 ... 200]: ",0
user_num			DWORD		?

; input data validation
msg_error			BYTE		"No primes for you! Number out of range. Try again.",13,10,0

; calculate prime numbers
line_count			DWORD		10			; 10 prime numbers per line
tabchar				BYTE		09,0

candidate			DWORD		?
result_boolean		DWORD		?

; goodbye
msg_goodbye			BYTE		13,10,13,10,"Results certified by GinWook Lee. Goodbye.",13,10,0

.code
main PROC

; procedure calls
	CALL	introduction		; 1. instruction prompt
	CALL	getUserData			; 2. user input and data validation (+handles out of range error message)
	CALL	showPrimes			; 3. calculate and display prime numbers (+display requirements)
	CALL	farewell			; 4. say goodbye

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; -------------------------------------------------------------------------------------------------
; Name: introduction
; Description: prompt program title, programmer's name, and instruction for user.
; 
; Preconditions: intro and instruction messages are stored in global vairables (msg_intro, instruction)
; Postconditions: EDX changed to addresses of string
;
; Receives: addresses of (msg_intro, instruction) on EDX
; Returns: display intro and instruction messages on the console
; -------------------------------------------------------------------------------------------------
introduction PROC
	; display intro and instruction prompt
	MOV		EDX, OFFSET		msg_intro
	CALL	WriteString						; "Prime Numbers programmed by GinWook Lee"
	MOV		EDX, OFFSET		instruction
	CALL	WriteString						; "Enter the number of prime numbers you would like to see."
	RET
introduction ENDP

; 2. user input and data validation
	; if out of range: error message and re-prompt 
; -------------------------------------------------------------------------------------------------
; Name: getUserData
; Description:
; 
; Preconditions:
; Postconditions:
;
; Receives:
; Returns:
; -------------------------------------------------------------------------------------------------
getUserData PROC
	; ask user for an input
_input:
	MOV		EDX, OFFSET		ask_num
	CALL	WriteString						; "Enter the number of primes to display [1 ... 200]: "
	CALL	ReadDec
	
	; validate the user input before storing it in a global variable
	CALL	validate						; jump to validate procedure
	JECXZ	_valid							; if ECX=0 (valid), jump to _valid
	
	; show error message for invalid input and let user try again
	MOV		EDX, OFFSET		msg_error
	CALL	WriteString						; "No primes for you! Number out of range. Try again."
	JMP		_input							; jump to _input (re-try)

	; store valid user input
_valid:
	MOV		user_num, EAX					; store the user input
	
	RET
getUserData ENDP

; -------------------------------------------------------------------------------------------------
; Name: validate
; Description:
; 
; Preconditions: user input value in EAX
; Postconditions:
;
; Receives: EAX with user input
; Returns: ECX with validation result
; -------------------------------------------------------------------------------------------------
validate PROC
	; lower bound check
	CMP		EAX, LOWER_BOUND
	JB		_error							; if the user input is less than 1, jump to _error

	; upper bound check
	CMP		EAX, UPPER_BOUND
	JA		_error							; if the user input is greater than 200, jump to _error
	
	; passed lower and upper bound checks
	MOV		ECX, 0							; input is valid (0)
	JMP		_return

	; user input is out of range
_error:
	MOV		ECX, 1							; input is invalid (1)
	
	; return with the validation result
_return:
	RET										; return to getUserData procedure 
validate ENDP

; 3. calculate and display prime numbers
	; 10 prime numbers per line (except for the final row)
	; ascending order
	; at least 3 spaces between numbers
; -------------------------------------------------------------------------------------------------
; Name: showPrimes
; Description:
; 
; Preconditions:
; Postconditions:
;
; Receives:
; Returns:
; -------------------------------------------------------------------------------------------------
showPrimes PROC
	; set the countdown variable ECX
	MOV		ECX, user_num					; set ECX as prime counter (using LOOP)
	CALL	CrLf
	
	; base case: the minimum valid user input is 1
	MOV		candidate, 2					; initialize candidate as 2
	MOV		EAX, candidate					; move the first prime to EAX
	
	INC		candidate						; increase candidate by 1
	JMP		_prime							; 2 is the first prime number by default

_primeLoop:	
	CALL	isPrime
	
	; check the result (0 = not prime, 1 = prime)
	CMP		result_boolean, 0
	JE		_primeLoop						; if not prime, jump back to _primeLoop. Prime, otherwise.

	; display prime numbers
_prime:
	MOV		EAX, candidate					; move prime number to EAX
	CALL	WriteDec						; display prime number
	MOV		EDX, OFFSET		tabchar
	CALL	WriteString						; add space (horizontal tab)

	; if line_count reaches 0, jump to _newLine	
	DEC		line_count						; decrease line_count by 1
	CMP		line_count, 0
	JE		_newLine						; if 10 prime numbers fill the current row, jump to _newLine

	; check number of primes
	LOOP	_primeLoop						; back to _primeLoop until user_num is reached
	JMP		_return							; ECX = 0, jump to _return

	; move to the next row
_newLine:
	CALL	CrLf							; move down to the next row
	ADD		line_count, 10					; reset the line count to 10

	; check number of primes
	LOOP	_primeLoop						; back to _primeLoop until user_num is reached

_return:	
	RET
showPrimes ENDP

; -------------------------------------------------------------------------------------------------
; Name: isPrime
; Description:
; 
; Preconditions:
; Postconditions:
;
; Receives:
; Returns: result_boolean (0 not prime or 1 prime)
; -------------------------------------------------------------------------------------------------
isPrime PROC
	; if first round: candidate == 3, jump straight to _primeCheck
	CMP		candidate, 3
	JE		_primeCheck

	; for each subsequent round: increase candidate by 2 (checking odd numbers only)
	ADD		candidate, 2					; increment candidate by 2

	; check if candidate value is prime
_primecheck:

	; return boolean


	RET
isPrime ENDP

; 4. say goodbye
; -------------------------------------------------------------------------------------------------
; Name: farewell
; Description:
; 
; Preconditions:
; Postconditions:
;
; Receives:
; Returns:
; -------------------------------------------------------------------------------------------------
farewell PROC
	MOV		EDX, OFFSET		msg_goodbye
	CALL	WriteString						; "Results certified by GinWook Lee. Goodbye."
	RET
farewell ENDP

END main
