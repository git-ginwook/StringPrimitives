TITLE Basic Logic and Arithmetic Program     (Project1_leeginw.asm)

; Author: GinWook Lee
; Last Modified: 1/21/2022
; OSU email address: leeginw@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:    Project 01             Due Date: 1/24/2022
; Description: 
;	This program will take three integer inputs from user and calculate the sums and differences of those integers.
;	At the top of the output screen, program title and my name will be displayed.
;	Followed by the brief function of this program, instruction for user will be shown.
;	User will be able to enter the first, second, and third positive integers successively in a descending order.
;	The program takes three integers and calculates the sums and differences in a particular order:
;		[A+B, A-B, A+C, A-C, B+C, B-C, A+B+C]
;	Once, all calculations are displayed, there will be a closing remark with a good bye.
;	Extra Credits: 
;		1) before the closing remark, user will be asked whether to play this program again.
;			- the program will repeat until the user chooses to quit.
;		2) when user inputs the second and third numbers, program checks to see 
;			if A is less than B, or B is less than C, sequentially.
;			if "yes" in either case, the program jumps to descending error message and ends the program.
;		3) the program will also calculate [B-A, C-A, C-B, C-B-A] and display results in negative values.

INCLUDE Irvine32.inc

	; no macros to use
	; no constants to use

.data

	; introduction
	intro_1			BYTE	"	Elementary Arithmetic			by GinWook Lee",0
	intro_2			BYTE	"This program will calculate the sums and differences of three integers.",0

	; input prompt
	prompt_1		BYTE	"Enter 3 positive numbers in descending values (e.g., A > B > C).",0
	prompt_2		BYTE	"First number: ",0
	prompt_3		BYTE	"Second number: ",0
	prompt_4		BYTE	"Third number: ",0

	; integer input variables(A, B, C) to be entered by user (max up to ~4 billion)
	firstNumber		DWORD	?		; variable A
	secondNumber	DWORD	?		; variable B
	thirdNumber		DWORD	?		; variable C

	; arithmetic sign prompt
	prompt_plus		BYTE	" + ",0
	prompt_minus	BYTE	" - ",0
	prompt_equal	BYTE	" = ",0
	
	; result variables
	result_1		DWORD	?		; A + B 
	result_2		DWORD	?		; A - B 
	result_3		DWORD	?		; A + C 
	result_4		DWORD	?		; A - C 
	result_5		DWORD	?		; B + C 
	result_6		DWORD	?		; B - C 
	result_7		DWORD	?		; A + B + C 

	; closing comment
	goodbye			BYTE	"Thanks for using Elementary Arithmetic! Goodbye!",0

	; Extra Credit #1
	extra_1			BYTE	"**EC#1: repeat this program until the user chooses to quit.",0
	ask				BYTE	"play again? (Yes: press 1, No: press 0) ",0
	response		DWORD	?		; 1 = play again, 0 = exit

	; Extra Credit #2
	extra_2			BYTE	"**EC#2: check if numbers are not in strictly descending order.",0
	desc_error		BYTE	"ERROR: The numbers are not in descending order!",13,10,0
	error_bye		BYTE	"Please stick to the rules next time. Bye!",0

	; Extra Credit #3
	extra_3			BYTE	"**EC#3: handle negative results and computes B-A, C-A, C-B, C-B-A.",13,10,0
	result_8		SDWORD	?		; B - A
	result_9		SDWORD	?		; C - A
	result_10		SDWORD	?		; C - B
	result_11		SDWORD	?		; C - B - A

.code
main PROC

	; 1. introduction
	MOV		EDX, OFFSET		intro_1			; program title and name
	CALL	WriteString
	CALL	CrLf
	
	MOV		EDX, OFFSET		extra_1			; extra credit #1 description
	CALL	WriteString
	CALL	CrLf

	MOV		EDX, OFFSET		extra_2			; extra credit #2 description
	CALL	WriteString
	CALL	CrLf

	MOV		EDX, OFFSET		extra_3			; extra credit #3 description
	CALL	WriteString
	CALL	CrLf

	MOV		EDX, OFFSET		intro_2			; program description
	CALL	WriteString
	CALL	CrLf


_again:
	; 2. get the data (from user)
	MOV		EDX, OFFSET		prompt_1		; instruction for user
	CALL	WriteString
	CALL	CrLf

	; (1) get the first number(A) from user
	MOV		EDX, OFFSET		prompt_2		; input request
	CALL	WriteString						
	CALL	ReadDec							; preconditions: None 
											; postconditions: value is saved in EAX
	MOV		firstNumber, EAX				; value is saved in firstNumber

	; (2) get the second number(B) from user
	MOV		EDX, OFFSET		prompt_3		; input request
	CALL	WriteString						
	CALL	ReadDec							; preconditions: None 
											; postconditions: value is saved in EAX
	MOV		secondNumber, EAX				; value is saved in secondNumber

	; EC#2. check if the first number is greater than the second number
	MOV		EAX, firstNumber
	CMP		EAX, secondNumber
	JB		_notDescend						; jump to notDescend label if firstNumber < secondNumber

	; (3) get the third number(C) from user
	MOV		EDX, OFFSET		prompt_4		; input request
	CALL	WriteString						
	CALL	ReadDec							; preconditions: None 
											; postconditions: value is saved in EAX
	MOV		thirdNumber, EAX				; value is saved in thirdNumber

	; EC#2. check if the second number is greater than the third number
	MOV		EAX, secondNumber
	CMP		EAX, thirdNumber
	JB		_notDescend						; jump to notDescend label if secondNumber < thirdNumber


	; 3. calculate the required values
	; (1) add the first and second numbers: A + B
	MOV		EAX, firstNumber
	MOV		EBX, secondNumber
	ADD		EAX, EBX
	MOV		result_1, EAX					; store the result of addition in result_1

	; (2) subtract the first and second numbers: A - B
	MOV		EAX, firstNumber
	MOV		EBX, secondNumber
	SUB		EAX, EBX
	MOV		result_2, EAX					; store the result of subtraction in result_2

	; (3) add the first and third numbers: A + C
	MOV		EAX, firstNumber
	MOV		EBX, thirdNumber
	ADD		EAX, EBX
	MOV		result_3, EAX					; store the result of addition in result_3

	; (4) subtract the first and third numbers: A - C
	MOV		EAX, firstNumber
	MOV		EBX, thirdNumber
	SUB		EAX, EBX
	MOV		result_4, EAX					; store the result of subtraction in result_4

	; (5) add the second and third numbers: B + C
	MOV		EAX, secondNumber
	MOV		EBX, thirdNumber
	ADD		EAX, EBX
	MOV		result_5, EAX					; store the result of addition in result_5

	; (6) subtract the second and third numbers: B - C
	MOV		EAX, secondNumber
	MOV		EBX, thirdNumber
	SUB		EAX, EBX
	MOV		result_6, EAX					; store the result of subtraction in result_6

	; (7) add the first, second and third numbers: A + B + C
	MOV		EAX, firstNumber
	MOV		EBX, secondNumber
	ADD		EAX, EBX
	MOV		EBX, thirdNumber
	ADD		EAX, EBX
	MOV		result_7, EAX					; store the result of addition in result_7

	; EC#3. (8) subtract the second and first numbers: B - A
	MOV		EAX, secondNumber
	MOV		EBX, firstNumber
	SUB		EAX, EBX
	MOV		result_8, EAX					; store the result of subtracion in result_8

	; EC#3. (9) subtract the third and first numbers: C - A
	MOV		EAX, thirdNumber
	MOV		EBX, firstNumber
	SUB		EAX, EBX
	MOV		result_9, EAX					; store the result of subtracion in result_9

	; EC#3. (10) subtract the third and second numbers: C - B
	MOV		EAX, thirdNumber
	MOV		EBX, secondNumber
	SUB		EAX, EBX
	MOV		result_10, EAX					; store the result of subtracion in result_10

	; EC#3. (11) subtract the third, second, and first numbers: C - B - A
	MOV		EAX, thirdNumber
	MOV		EBX, secondNumber
	SUB		EAX, EBX
	MOV		EBX, firstNumber
	SUB		EAX, EBX
	MOV		result_10, EAX					; store the result of subtracion in result_11

	; 4. display the results 	
	; (1) A + B = result_1: add the first and second numbers
	MOV		EAX, firstNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_plus
	CALL	WriteString
	MOV		EAX, secondNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_equal
	CALL	WriteString
	MOV		EAX, result_1
	CALL	WriteDec
	CALL	CrLf

	; (2) A - B = result_2: subtract the first and second numbers
	MOV		EAX, firstNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_minus
	CALL	WriteString
	MOV		EAX, secondNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_equal
	CALL	WriteString
	MOV		EAX, result_2
	CALL	WriteDec
	CALL	CrLf

	; (3) A + C = result_3: add the first and third numbers
	MOV		EAX, firstNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_plus
	CALL	WriteString
	MOV		EAX, thirdNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_equal
	CALL	WriteString
	MOV		EAX, result_3
	CALL	WriteDec
	CALL	CrLf

	; (4) A - C = result_4: subtract the first and third numbers
	MOV		EAX, firstNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_minus
	CALL	WriteString
	MOV		EAX, thirdNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_equal
	CALL	WriteString
	MOV		EAX, result_4
	CALL	WriteDec
	CALL	CrLf

	; (5) B + C = result_5: add the second and third numbers
	MOV		EAX, secondNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_plus
	CALL	WriteString
	MOV		EAX, thirdNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_equal
	CALL	WriteString
	MOV		EAX, result_5
	CALL	WriteDec
	CALL	CrLf

	; (6) B - C = result_6: subtract the second and third numbers
	MOV		EAX, secondNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_minus
	CALL	WriteString
	MOV		EAX, thirdNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_equal
	CALL	WriteString
	MOV		EAX, result_6
	CALL	WriteDec
	CALL	CrLf

	; (7) A + B + C = result_7: add the first, second, and third numbers
	MOV		EAX, firstNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_plus
	CALL	WriteString
	MOV		EAX, secondNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_plus
	CALL	WriteString
	MOV		EAX, thirdNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_equal
	CALL	WriteString
	MOV		EAX, result_7
	CALL	WriteDec
	CALL	CrLf

	; EC#3. (8) B - A = result_8: subtract the second and first numbers
	MOV		EAX, secondNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_minus
	CALL	WriteString
	MOV		EAX, firstNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_equal
	CALL	WriteString
	MOV		EAX, result_8
	CALL	WriteInt
	CALL	CrLf

	; EC#3. (9) C - A = result_9: subtract the third and first numbers
	MOV		EAX, thirdNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_minus
	CALL	WriteString
	MOV		EAX, firstNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_equal
	CALL	WriteString
	MOV		EAX, result_9
	CALL	WriteInt
	CALL	CrLf

	; EC#3. (10) C - B = result_10: subtract the third and second numbers
	MOV		EAX, thirdNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_minus
	CALL	WriteString
	MOV		EAX, secondNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_equal
	CALL	WriteString
	MOV		EAX, result_10
	CALL	WriteInt
	CALL	CrLf

	; EC#3. (11) C - B - A = result_11: subtract the third, second, and first numbers
	MOV		EAX, thirdNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_minus
	CALL	WriteString
	MOV		EAX, secondNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_minus
	CALL	WriteString
	MOV		EAX, firstNumber
	CALL	WriteDec
	MOV		EDX, OFFSET		prompt_equal
	CALL	WriteString
	MOV		EAX, result_10
	CALL	WriteInt
	CALL	CrLf

	; EC#1. ask whether the user wants to play again
_ask:
	MOV		EDX, OFFSET		ask			; ask prompt
	CALL	WriteString
	CALL	ReadDec						; preconditions: None 
										; postconditions: value is saved in EAX
	MOV		response, EAX				; user response saved in "response"
	CMP		response, 1					
	JE		_again						; if response is 1, jump back to _again

	; 5. say goodbye
	MOV		EDX, OFFSET		goodbye
	CALL	WriteString
	CALL	CrLF
	JMP		_end

	; EC#2. user inputs are not in descending order 
_notDescend:
	MOV		EDX, OFFSET		desc_error	; display error message
	CALL	WriteString
	MOV		EDX, OFFSET		error_bye	; goodbye propmt
	CALL	WriteString
	CALL	CrLf
	JMP		_ask						; ask if user wants to continue play

_end:
	Invoke ExitProcess,0	; exit to operating system
main ENDP

; no additional procedures

END main
