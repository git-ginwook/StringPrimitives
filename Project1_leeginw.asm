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

.code
main PROC

	; 1. introduction
	MOV		EDX, OFFSET		intro_1			; program title and name
	CALL	WriteString
	CALL	CrLf
	MOV		EDX, OFFSET		intro_2			; program description
	CALL	WriteString
	CALL	CrLf

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

	; (3) get the third number(C) from user
	MOV		EDX, OFFSET		prompt_4		; input request
	CALL	WriteString						
	CALL	ReadDec							; preconditions: None 
											; postconditions: value is saved in EAX
	MOV		thirdNumber, EAX				; value is saved in thirdNumber


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

	; 5. say goodbye
	MOV		EDX, OFFSET		goodbye
	CALL	WriteString
	CALL	CrLF

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; no additional procedures

END main
