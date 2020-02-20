TITLE Prog5     (prog5.asm)

; Author: Amanda Lawrence
; Email:  lawreama@oregonstate.edu
; Course / Project ID: CS 271 - Programming Assignment #5B                 Date: 08/13/2017
; Description: MASM Program that calculates combinations. Objectives are:
;					1. Designing, implementing and calling low-level I/O procedures
;					2. Implementing recursion
;						a. parameter passing on the system stack
;						b. maintaining activation records (stack frames)

INCLUDE Irvine32.inc

; (insert constant definitions here)
nMax			EQU 12
nMin			EQU 3
;hi				EQU 12
rMin			EQU 1

.data
; (insert variable definitions here)
intro			BYTE "Program 5B: Combinations Calculator                 	     by: Amanda Lawrence", 0
hello			BYTE "Welcome to the Combinations Calculator. ", 0
instructions	BYTE "I'll give you a combinations problem. You enter your answer, ", 0
instructions2	BYTE "and I'll let you know if you're right. ", 0
problem			BYTE "Problem: ", 0
prompt			BYTE "Number of elements in the set:  ", 0
secondPrompt	BYTE "Number of elements to choose from the set:  ", 0
thirdPrompt		BYTE "How many ways can you choose?  ", 0
thereAre		BYTE "There are ", 0
combinationsOf	BYTE " combinations of ", 0
itemsFromASetOf	BYTE " items from a set of ", 0
practice		BYTE "You need more practice.", 0
correct			BYTE "You are correct!", 0
anotherProblem	BYTE "  Another problem? (y/n):  ", 0
enterANumber	BYTE "Please enter a valid number.", 0
goodbye			BYTE "OK ... Goodbye!", 0
totalElements	DWORD ?										;represents n in combinations equation
chooseFromElements	DWORD ?									;represents r in combinations equation
userAnswer		DWORD ?										;what the user inputs, their guess to the number of combinations
answer			DWORD ?
response		BYTE 10 DUP(0)
yesResponse		BYTE "y, Y", 0
string			BYTE	30 DUP(0)
;goodbyeString	BYTE "Thank you for playing! Goodbye ", 0


display		MACRO	buffer
	push	edx
	mov		edx, OFFSET buffer
	call	WriteString
	pop		edx
ENDM


.code
main PROC
; (insert executable instructions here)
	call	introduction

	call	Randomize

	wantsAnotherProblem:

		push	OFFSET totalElements
		push	OFFSET chooseFromElements
		call	showProblem

		push	OFFSET userAnswer
		call	getData

		push	totalElements
		push	chooseFromElements
		push	OFFSET answer
		call	combinations

		push	totalElements
		push	chooseFromElements
		push	userAnswer
		push	answer
		call	showResults

		mov		esi, OFFSET response
		mov		edi, OFFSET yes
		cmpsb
		je		wantsAnotherProblem
		call	farewell	

		popad
	exit	; exit to operating system
main ENDP



introduction PROC
	; Prints out the title of the program, author's name, and description of program to user
	display intro
	call	CrLF
	display instructions
	call	CrLF
	display instructions2
	call	CrLF
	display instructions3
	call	CrLF
	ret
introduction ENDP


showProblem PROC
;generates random numbers and displays the problem, the n and r of the problem
	push	ebp
	mov		ebp, esp
	pushad

	mov		eax, nMax
	sub		eax, nMin
	inc		eax

	call	RandomRange

	add		eax, nMin
	mov		ebx, [ebp+12]	
	mov		[ebx], eax

	mov		eax, [ebx]
	sub		eax, rMin
	inc		eax
	
	call	RandomRange

	add		eax, rMin
	mov		ebx, [ebp+8]
	mov		[ebx], eax

	display problem
	call	CrLF

	display prompt
	mov		ebx, [ebp+12]
	mov		eax, [ebx]
	call	WriteDec
	call	CrLF

	display secondPrompt
	mov		ebx, [ebp+8]
	mov		eax, [ebx]
	call	WriteDec
	call	CrLF

showProblem ENDP




getData PROC
; gets data by prompting the user for their answer 

	push	ebp
	mov		ebp, esp
	pushad
	display	thirdPrompt 

		tryAgain:
				mov		eax, 0
				mov		ebx, [ebp+8]
				mov		[ebx], eax

				mov		edx, OFFSET string
				mov		ecx, 29
				call	ReadString
				mov		ecx, eax
				mov		esi, OFFSET string

		validate:
				mov		ebx, [ebp+8]
				mov		eax, [ebx]
				mov		ebx, 10
				mul		ebx
	
				mov		ebx, [ebp+8]
				mov		[ebx], eax
				mov		al, [esi]
				cmp		al, 47
				jle		outOfRange

				cmp		al, 58
				jge		outOfRange

				inc		esi
				sub		al, 48
		
				mov		ebx, [ebp+8]
				add		[ebx], al

				loop		validate
				jmp		continue

		outOfRange:
				display		enterANumber
				call		CrLf
				jmp		tryAgain

		continue:
				popad
				pop		ebp
				ret		4

getData ENDP




combinations PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	edx
	sub		esp, 16

	push	[ebp+16]
	push	[ebp+8]
	call	factorial

	mov		ebx, [ebp+8]				
	mov		eax, [ebx]
	mov		DWORD PTR [ebp-4], eax

	push	[ebp+12]
	push	[ebp+8]
	call	factorial

	mov		ebx, [ebp+8]
	mov		eax, [ebx]
	mov		DWORD PTR [ebp-8], eax

	mov		eax, [ebp+16]
	mov		ebx, [ebp+12]
	sub		eax, ebx
	cmp		eax, 0
	je		downToOne
	mov		DWORD PTR [ebp-12], eax

	push	[ebp-12]
	push	[ebp+8]
	call	factorial

	mov		ebx, [ebp+8]
	mov		eax, [ebx]
	mov		DWORD PTR [ebp-16], eax

	mov		eax, [ebp-8]
	mov		ebx, [ebp-16]
	mul		ebx

	mov		edx, 0
	mov		ebx, eax
	mov		eax, [ebp-4]
	div		ebx

	mov		ebx, [ebp+8]
	mov		[ebx], eax
	jmp		continue

downToOne:
	mov		eax, 1
	mov		ebx, [ebp+8]
	mov		[ebx], eax
	mov		eax, [ebx]

continue:
	pop		edx
	pop		ebx
	pop		eax
	mov		esp, ebp
	pop		ebp
	ret		12
combinations ENDP



factorial PROC
	push	ebp
	mov		ebp, esp
	pushad	

	mov		eax, [ebp+12]
	mov		ebx, [ebp+8]
	cmp		eax, 0
	ja		recurse
	mov		esi, [ebp+8]
	mov		eax, 1
	mov		[esi], eax
	jmp		continue

recurse:

	dec		eax
	push	eax
	push	ebx
	call	factorial
	mov		esi, [ebp+8]
	mov		ebx, [esi]
	mov		eax, [ebp+12]	
	mul		ebx
	mov		[esi], eax
	
continue:		
	popad
	pop		ebp				
	ret		8

factorial ENDP



showResults PROC
	push	ebp
	mov		ebp, esp
	pushad
	
	call	CrLf
	display	thereAre
	mov		eax, [ebp+8]
	call	WriteDec

	display	combinationsOf
	mov		eax, [ebp+16]
	call	WriteDec

	display	itemsFromASetOf
	mov		eax, [ebp+20]
	call	WriteDec
	call	CrlF
	
	mov		eax, [ebp+12]
	cmp		eax, [ebp+8]
	je		right
	call	CrlF

	display	practice
	call	CrLf
	jmp		continue

right:
	display	correct
	call	CrLf
continue:			
	popad
	pop		ebp
	ret		16
showResults ENDP




farewell PROC
	call	CrLf
	mov		edx, OFFSET goodbyeString
	call	WriteString
	call	CrLf
	ret
farewell ENDP	


; (insert additional procedures here)

END main
