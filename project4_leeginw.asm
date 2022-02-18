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

instruction_1		BYTE		"Enter the number of prime numbers you would like to see.",13,10
					BYTE		"I will accept orders for up to 200 primes.",13,10,13,10,0

; user input
ask_num				BYTE		"Enter the number of primes to display [1 ... 200]: ",0
user_num			DWORD		?

; input data validation
msg_error			BYTE		"No primes for you! Number out of range. Try again.",13,10,0

; calculate prime numbers
prime_count			DWORD		?
line_count			DWORD		9
display_spaces		BYTE		"    ",0

; goodbye
msg_goodbye			BYTE		"Results certified by GinWook Lee. Goodbye.",0

.code
main PROC

; procedure calls

; 1. instruction prompt
; 2. user input
; 3. input data validation
	; if out of range: error message and re-prompt 
; 4. calculate and display prime numbers
;	; 10 prime numbers per line (except for the final row)
	; ascending order
	; at least 3 spaces between numbers
; 5. say goodbye

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; 1. instruction prompt
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
introduction PROC
	;...
	RET
introduction ENDP

; 2. user input and data validation
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
	;...
	RET
getUserData ENDP

; 3. input data validation
	; if out of range: error message and re-prompt 
; -------------------------------------------------------------------------------------------------
; Name: validate
; Description:
; 
; Preconditions:
; Postconditions:
;
; Receives:
; Returns:
; -------------------------------------------------------------------------------------------------
validate PROC
	;...
	RET
validate ENDP

; 4. calculate and display prime numbers
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
	;...
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
; Returns:
; -------------------------------------------------------------------------------------------------
isPrime PROC
	;...
	RET
isPrime ENDP

; 5. say goodbye
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
	;...
	RET
farewell ENDP

END main
