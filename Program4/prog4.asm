TITLE Prog4     (prog4.asm)

; Author: Amanda Lawrence
; Email:  lawreama@oregonstate.edu
; Course / Project ID: CS 271 - Programming Assignment #4                 Date: 08/6/2017
; Description: MASM Program that uses arrays, randomize, sorting


INCLUDE Irvine32.inc

; (insert constant definitions here)
numMax			EQU 200
numMin			EQU 10
hi				EQU 999
lo				EQU 100

.data
; (insert variable definitions here)
intro			BYTE "Program 4: Sorting Random Integers                 	     by: Amanda Lawrence", 0
hello			BYTE "Hello ", 0
instructions	BYTE "This program generates random numbers in the range [100 .. 999]", 0
instructions2	BYTE "displays the original list, sorts the list, and calculates the ", 0
instructions3	BYTE "median value. Finally, it displays the list sorted in descending order.", 0
prompt			BYTE "How many numbers should be generated? [10 .. 200]", 0
thirdNumPrompt	BYTE "Give the number as an integer in the range [10 .. 200].", 0
secondNumPrompt	BYTE "That number is out of range.", 0
range			BYTE "Enter a number in [10 .. 200]", 0
medianPrompt	BYTE "The median is ", 0
unsortedPrompt	BYTE "The unsorted random numbers: ", 0
sortedPrompt	BYTE "The sorted list: ", 0
spaces			BYTE "    ", 0
firstNum		DWORD ?
checkFor10		DWORD 10
tenPerLine		DWORD 0

;array
list			DWORD numMax DUP(?)


goodbyeString	BYTE "Thank you for playing! Goodbye ", 0

.code
main PROC
; (insert executable instructions here)
	call	introduction

	push	OFFSET firstNum
	call	getUserData

	call	Randomize
	push	OFFSET list
	push	firstNum
	call	fillArray

	;call	sortList
	
	;call	displayMedian

	mov		edx, OFFSET unsortedPrompt
	call	WriteString
	call	CrLf

	push	OFFSET list
	push	firstNum
	call	displayList

	;call	sortList
	;call	displayMedian
	;call	displayList

	call	farewell
	exit	; exit to operating system
main ENDP



introduction PROC
	; Prints out the title of the program, author's name
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLF
	mov		edx, OFFSET instructions
	call	WriteString
	call	CrLF
	mov		edx, OFFSET instructions2
	call	WriteString
	call	CrLF
	mov		edx, OFFSET instructions3
	call	WriteString
	call	CrLF
	ret
introduction ENDP



getUserData PROC
; prints out instructions to the user, and get's data 

	push	ebp
	mov		ebp, esp
	mov		ebx, [ebp + 8]

		printInstructions:
					mov		edx, OFFSET prompt
					call	WriteString
					call	CrLf
					call	ReadInt
					;mov		firstNum, eax
					mov		[ebx], eax
					call	CrLF

		validate:
					cmp		eax, numMax
					jg		outOfRange
					cmp		eax, numMin
					jl		outOfRange
					ret

		outOfRange:
					mov		edx, OFFSET secondNumPrompt	
					call	WriteString
					call	CrLf
					call	printInstructions

		pop	ebp
		ret	4
getUserData ENDP


fillArray PROC
;parameters: request(value), array (reference)
;fillArray will fill up an array with values

	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 12]
	mov		ecx, [ebp + 8]
	;mov		ecx, firstNum

		;loop to generate a random number, and to put in the array
		fillUpArray:
					mov		eax, hi
					sub		eax, lo
					inc		eax
					call	RandomRange
					add		eax, lo
					mov		[esi], eax
					add		esi, 4				;move onto next location in array
					loop	fillUpArray

		pop ebp
		ret 8
fillArray ENDP



displayList PROC
; parameters: array (reference), request (value), title (reference)
		push	ebp
		mov		ebp, esp
		mov		ebx, tenPerLine
		mov		esi, [ebp + 12]
		mov		ecx, [ebp + 8]

			displayElement:										;displays one value at a time
						mov		eax, [esi]
						call	WriteDec
						mov		edx, OFFSET spaces
						call	WriteString
						inc		ebx								;will count up to 10, 
						cmp		ebx, checkFor10
						jl		stayOnLine
						call	CrLf							; if the number of values on a line equals 10, then we'll start a new line and set ebx to 0
						mov		ebx, 0

			stayOnLine:								
						add		esi, 4
						loop displayElement

			breakOutLoop:
						pop		ebp
						ret		8
displayList ENDP






farewell PROC
	call	CrLf
	mov		edx, OFFSET goodbyeString
	call	WriteString
	call	CrLf
	ret
farewell ENDP	


; (insert additional procedures here)

END main
