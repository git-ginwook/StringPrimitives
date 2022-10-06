TITLE Prime Numbers     (project4_leeginw.asm)

; Author: GinWook Lee
; Last Modified: 2/20/2022
; OSU email address: leeginw@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number: 04
; Due Date: 2/20/2022
; Description: This program takes a user input between 1 and 200 and shows the specified number of prime numbers.
;				The program first validates whether the user entered a valid number.
;				If not, the program lets user to try again.
;				Given a valid user input, the program then calculates and sequentially displays prime numbers 
;				in an ascending order, with 10 numbers per row and at least three spaces between each number,
;				until the total number of prime numbers matches the number specified by user.			
;				**Extra Credits:
;				1) align the numbers so that the first digit of each number on a row matches with other rows.
;				2a) extend the range of primes to display up to 4000 primes.
;				2b) show 20 rows of primes per page
;				2c) user presses any key to continue to the next page

INCLUDE Irvine32.inc

; user input range (when n is an integer, 1 <= n <=200)
LOWER_BOUND = 1
UPPER_BOUND1 = 200

; [Extra Credit #2] increase the upper bound to 4000 (new range: 1 <= n <= 4000)
UPPER_BOUND2 = 4000

.data

; instruction prompt
msg_intro			BYTE		"Prime Numbers programmed by GinWook Lee",13,10,0
instruction			BYTE		"Enter the number of prime numbers you would like to see.",13,10
					BYTE		"I will accept orders for up to 4000 primes.",13,10,13,10,0

; user input
ask_num				BYTE		"Enter the number of primes to display [1 ... 200]: ",0
user_num			DWORD		?

; input data validation
msg_error			BYTE		"No primes for you! Number out of range. Try again.",13,10,0

; calculate prime numbers
line_count			DWORD		10			; 10 prime numbers per line


candidate			DWORD		3			; initialize prime number candidate 
result_boolean		DWORD		?

; goodbye
msg_goodbye			BYTE		13,10,"Results certified by GinWook Lee. Goodbye.",13,10,0

; [Extra Credit #1] prompt and alignment variable
extra_1				BYTE		"**EC#1: output columns will be aligned.",13,10,0
tabchar				BYTE		09,0

; [Extra Credit #2] prompt and row count variable
extra_2				BYTE		"**EC#2: range is increased to 4000, 20 rows of numbers per page",13,10,13,10,0
ask_num2			BYTE		"Enter the number of primes to display [1 ... 4000]: ",0
row_count			DWORD		20			; 20 rows per page

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
; Description: call and display instruction prompts for user to grasp the purpose of this program.
; 
; Preconditions: there is no preconditions for this procedure.
; Postconditions: EDX changed to address of a global variable (instruction)
;
; Receives: intro and instruction messages are stored in global vairables (msg_intro, instruction).
;			addresses of two global variables (msg_intro, instruction).
;			**EC#1: a notification that indicates Extra Credit #1 is stored in (extra_1).
;			**EC#2: a notification that indicates Extra Credit #2 is stored in (extra_2).
; Returns: display program title, programmer's name, and instruction to user.
; -------------------------------------------------------------------------------------------------
introduction PROC
	; display intro and instruction prompt
	MOV		EDX, OFFSET		msg_intro
	CALL	WriteString						; "Prime Numbers programmed by GinWook Lee"
	MOV		EDX, OFFSET		extra_1
	CALL	WriteString						; "**EC#1: output columns will be aligned."
	MOV		EDX, OFFSET		extra_2
	CALL	WriteString						; "**EC#2: range is increased to 4000, 20 rows of numbers per page"
	MOV		EDX, OFFSET		instruction
	CALL	WriteString						; "Enter the number of prime numbers you would like to see."
	RET
introduction ENDP

; -------------------------------------------------------------------------------------------------
; Name: getUserData
; Description: ask user to enter an integer between 1 and 200. Then, check whether the input is within
;				the specified range (1~200). If the input falls outside of the range, ask user to try again.
;				**EC#2: input range is increased to 4000.
; 
; Preconditions: there is no preconditions for this procedure.
; Postconditions: ECX is set to zero. EAX keeps a valid user input. EDX has the address of (ask_num2).
;
; Receives: a message prompt to ask user for an input is stored in a global variable (ask_num2).
;			an error message is also stored in a global variable (msg_error) in case for an invalid input.
;			ECX (either 0 or 1) from the nested procedure (validate).
; Returns: store a valid user input to a global variable (user_num).
; -------------------------------------------------------------------------------------------------
getUserData PROC
	; [EC#2] ask user for an input
_input:
	MOV		EDX, OFFSET		ask_num2
	CALL	WriteString						; "Enter the number of primes to display [1 ... 4000]: "
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
; Description: unless the user input passes both lower and upper bound checks (1 and 200), 
;				return to getUserData procedure to show the error message and let user try again.
;				**EC#2: the upper bound is increased to 4000.
; 
; Preconditions: a user input is entered and stored in EAX for validation.
; Postconditions: ECX is is set to either 0 or 1 to inidicate whether the user input is valid.
;
; Receives: user input stored in EAX. input ranges specified as constants(LOWER_BOUND, UPPER_BOUND).
; Returns: ECX with validation result (0 for valid, 1 for invalid).
; -------------------------------------------------------------------------------------------------
validate PROC
	; lower bound check
	CMP		EAX, LOWER_BOUND
	JB		_error							; if the user input is less than 1, jump to _error

	; [EC#2] upper bound check
	CMP		EAX, UPPER_BOUND2
	JA		_error							; if the user input is greater than 4000, jump to _error
	
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

; -------------------------------------------------------------------------------------------------
; Name: showPrimes
; Description: display prime numbers in ascending order, with 10 prime numbers per row. The total number
;				of prime numbers displayed will equal to the number user specified in (user_num). Each
;				prime number displayed will have at least 3 spaces (or horizontal tab) between numbers.
; 
; Preconditions: user input is valid and the value is stored in a global variable (user_num).
; Postconditions: (result_boolean) is set to either 0 or 1. (line_count) is changed depending on the 
;					number of prime numbers in the last row. ECX is changed to 0 once all intended 
;					prime numbers are displayed. EDX is set to the address of the last (tabchar) used.
;					EAX and EBX is changed to a value that equals to the last prime number displayed.
;
; Receives: valid user input (user_num). 
;			initial line and row count variables (line_count, row_count) set to 10 and 20 respectively.
;			address of a global variable (tabchar) to add a space between each prime number display.
;			result_boolean (either 0 or 1) variable from the nested procedure (isPrime).
;				if prime, prime number is stored in EAX and the next number to be tested in (candidate).
;				if not prime, the next prime number to be tested is stored in (candidate).
; Returns: display prime numbers sequentially until the total number of prime numbers reaches (user_num).
; -------------------------------------------------------------------------------------------------
showPrimes PROC
	; set ECX as a variable to count prime numbers displayed
	MOV		ECX, user_num					; set ECX as a prime counter (using LOOP)
	CALL	CrLf
	
	; base case: the minimum valid user input is 1
	MOV		EAX, 2							; initialize the first prime to EAX
	JMP		_prime							; 2 is the first prime number to be displayed by default

	; use subprocedure, isPrime to check if candidate is prime
_primeLoop:	
	CALL	isPrime
	
	CMP		result_boolean, 0				; boolean value passed from isPrime (0 = not prime, 1 = prime)
	JE		_primeLoop						; if not prime, jump back to _primeLoop. continue, otherwise.

	; [EC#1] display prime numbers and align output columns using horizontal tab
_prime:
	CALL	WriteDec						; display prime number
	MOV		EDX, OFFSET		tabchar
	CALL	WriteString						; add space (use horizontal tab for better alignment)
	
	; when line_count reaches 0, jump to _newLine	
	PUSH	ECX								; save the current prime number count
	MOV		ECX, line_count					; recall the current line_count (initial value is 10)
	LOOP	_countPrime						; until 10 prime numbers are filled, jump to _countPrime

	MOV		line_count, ECX					; store the new line_count (zero)
	POP		ECX								; restore the prime number count
	JMP		_newLine

	; check number of primes after line check
_countPrime:
	MOV		line_count, ECX					; store the new line_count
	POP		ECX								; restore the prime number count

	LOOP	_primeLoop						; back to _primeLoop if the prime counter(ECX) != 0
	JMP		_return							; if ECX = 0, jump to _return

	; move to the next row
_newLine:
	CALL	CrLf
	ADD		line_count, 10					; reset the line count back to 10

	; [EC#2] increase row count till the 20th row is reached
	PUSH	ECX								; save the current prime number count
	MOV		ECX, row_count					; recall the current row_count (initial value is 20)
	LOOP	_currentPage					; until row_count reaches zero, jump to _currentPage	

	; [EC#2] let user continue to the next page after the 20th row of prime numbers
	MOV		row_count, ECX					; save decremented row_count
	POP		ECX								; restore the prime number count

	MOV		row_count, 20					; reset row_count to 20
	CALL	CrLF
	CALL	WaitMsg							; when row_count equals 20, wait till user moves to the next page
	CALL	CrLf
	CALL	CrLf
	JMP		_return	

	; check number of primes after page check
_currentPage:
	MOV		row_count, ECX					; save decremented row_count
	POP		ECX

_return:	
	LOOP	_primeLoop						; back to _primeLoop until the total prime numbers equal user_num 
	CALL	CrLf
	RET
showPrimes ENDP

; -------------------------------------------------------------------------------------------------
; Name: isPrime
; Description: check the prime number candidate and return the result whether it is prime.
; 
; Preconditions: (user_num) is greater than 1 and ECX is not zero, yet.
; Postconditions: (candidate) is increased by 2 after each round of this procedure.
;					EBX is changed to a value between 2 and (candidate).
;					EAX is changed to the last quotient (depending on the _primeCheck result).
;					EDX is changed to the last remainder (depending on the _primeCheck result).
;
; Receives: initial candidate value (candidate) set to 3. 
; Returns: result_boolean (0 not prime or 1 prime). 
;				if prime, prime number is stored in EAX and the next prime number to be tested in (candidate).
;				if not prime, the next prime number to be tested is stored in (candidate).
; -------------------------------------------------------------------------------------------------
isPrime PROC	
	; initialize divisor (EBX)
	MOV		EBX, 2							; set to 2 as the starting point

	; first round
	CMP		candidate, 3					; if candidate == 3, jump straight to _primeCheck
	JE		_primeCheck			

	; -----------------------------------------------
	; This section checks if candidate value is prime.
	; Use DIV instruction repeatedly until: 
	;	a) divisor (EBX) equals candidate, meaning candidate is prime
	;	OR
	;	b) remainder (EDX) equals zero, meaning candidate is not prime
	; -----------------------------------------------
_primeCheck:
	MOV		EAX, candidate					; reset low dividend (EAX) to candidate 
	MOV		EDX, 0							; clear high dividend (EDX) to zero
	DIV		EBX								; EDX:EAX divide by EBX

	CMP		EBX, candidate					
	JE		_prime							; if divisor equals dividends, jump to _prime

	CMP		EDX, 0
	JE		_notPrime						; if remainder equals zero, jump to _notPrime
	
	INC		EBX								; increase divisor (EBX) by 1		 
	JMP		_primeCheck						; continue the checking process

	; return boolean result
_notPrime:
	MOV		result_boolean, 0				; indicate candidate is not a prime
	JMP		_return
	
_prime:
	MOV		result_boolean, 1				; indicate candidate is a prime
	MOV		EAX, candidate					; store prime number in EAX

_return:
	ADD		candidate, 2					; increase candidate by 2 (checking odd numbers only)
	RET
isPrime ENDP

; 4. say goodbye
; -------------------------------------------------------------------------------------------------
; Name: farewell
; Description: call and display a farewell prompt to let user know this is the end of the program.
; 
; Preconditions: ECX equals zero. All prime numbers are displayed on the console. The total number of 
;				prime numbers matches the user specified value (user_num).
; Postconditions: EDX changed to address of a global variable (msg_goodbye).
;
; Receives: farewell message stored in a global variable (msg_goodbye).
; Returns: display the farewell message to user.
; -------------------------------------------------------------------------------------------------
farewell PROC
	MOV		EDX, OFFSET		msg_goodbye
	CALL	WriteString						; "Results certified by GinWook Lee. Goodbye."
	RET
farewell ENDP

END main