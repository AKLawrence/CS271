TITLE Prog3     (prog3.asm)

; Author: Amanda Lawrence
; Course / Project ID: CS 271 - Programming Assignment #3                 Date: 07/3/2017
; Description: MASM Program that calculates composite numbers:
;					1. Designing and implementing procedures
;					2. Designing and implementing loops
;					3. Writing nested loops
;					4. Understanding data validation

INCLUDE Irvine32.inc

; (insert constant definitions here)
numMax			EQU 400
numMin			EQU 1

.data
; (insert variable definitions here)
intro			BYTE "Program 3: Composite Numbers	     by: Amanda Lawrence", 0
;namePrompt		BYTE "What is your name?", 0
hello			BYTE "Hello ", 0
instructions	BYTE "Enter the number of Composite numbers you would like to see.", 0
secondNumPrompt	BYTE "Give the number as an integer in the range [1 .. 400].", 0
thirdNumPrompt	BYTE "That number is out of range.", 0
range			BYTE "Enter a number in [1 .. 400]", 0
spaces			BYTE "    ", 0
firstNum		DWORD ?
currentNum		DWORD ?
startFactoring	DWORD 2
endFactoring	DWORD ?
divideBy10		DWORD 10
tenPerLine		DWORD 1

goodbyeString	BYTE "Thank you for playing! Goodbye ", 0

.code
main PROC
; (insert executable instructions here)
	call	introduction
	call	 getUserData
	call	showComposites
	call	farewell
	exit	; exit to operating system
main ENDP



introduction PROC
	; Prints out the title of the program, author's name
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLF
	ret
introduction ENDP



getUserData PROC
; prints out instructions to the user
		printInstructions:
					mov		edx, OFFSET instructions
					call	WriteString
					call	CrLf
					mov		edx, OFFSET secondNumPrompt
					call	WriteString
					call	CrLf
					call	ReadInt
					mov		firstNum, eax
					call	CrLF

		validate:
					cmp		eax, numMax
					jg		outOfRange
					cmp		eax, numMin
					jl		outOfRange
					ret

		outOfRange:
					mov		edx, OFFSET thirdNumPrompt	
					call	WriteString
					call	CrLf
					call	printInstructions
getUserData ENDP



showComposites PROC
; uses 2 loops. Outer loop steps through potential composite numbers (4 up to currentNum) while the inner loop will check if that value is actually composite

	mov ecx, firstNum
	mov currentNum, 4	;start calculating from 4 as that's the first possible composite number

	findNextComposite:
				call	isComposite

	printOutComposite:	;OUTER LOOP
			; prints out the currentNum (which is only returned from isComposite if it is indeed a composite number)
			; checks if we have printed ten numbers on a line, calls CrLf if so.
				mov		eax, currentNum
				call	WriteDec
				mov		edx, OFFSET spaces
				call	WriteString
				inc		currentNum 
				mov		edx, tenPerLine
				inc		edx
				mov		tenPerLine, edx
				cdq
				div		divideBy10
				cmp		edx, 0
				jne		loopAgain
				call	CrLf
			
	loopAgain:
				loop	findNextComposite
	ret
showComposites ENDP


isComposite PROC
	; uses 2 loops. Outer loop steps through potential composite numbers (4 up to currentNum) while the inner loop will check if that value is actually composite
	; We want to test if a potential composite, currentNum, is divisible by any number from 2 up to currentNum-1
	; this is our OUTER LOOP it will only return a value that is composite

	startFactoringAt2:
				mov		eax, currentNum
				dec		eax
				mov		startFactoring, 2
				mov		endFactoring, eax

	innerLoop:		; cycles through number 2 up to currentNum-1, testing if their division results in a 0 remainer
				mov		eax, currentNum
				cdq
				div		startFactoring		; eax / startFactoring
				cmp		edx, 0				; compare the remainder in edx to 0. Similar to modulus operation
				je		isAComposite
				inc		startFactoring		; increment to the next possible factor
				mov		eax, startFactoring
				cmp		eax, endFactoring	; if the value in startFactoring is the same as endFactoring, we have reached the end of possible factors
				jle		innerLoop
				inc		currentNum			; move onto the next potential composite number
				jmp		startFactoringAt2

	isAComposite:
			;will return the currentNum, to be printed out in showComposite
				ret
isComposite ENDP



farewell PROC
	call	CrLf
	mov		edx, OFFSET goodbyeString
	call	WriteString
	call	CrLf
	ret
farewell ENDP	


; (insert additional procedures here)

END main
