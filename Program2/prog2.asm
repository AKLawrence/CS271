TITLE Prog2     (prog2.asm)

; Author: Amanda Lawrence
; Course / Project ID: CS 271 - Programming Assignment #2                 Date: 07/16/2017
; Description: MASM Program that completes these tasks:
;					1. Getting string input
;					2. Designing and implementing a counted loop
;					3. Designing and implementing a post-test loop
;					4. Keeping track of a previous value
;					5. Implementing data validation

INCLUDE Irvine32.inc

; (insert constant definitions here)
numMax			EQU 46
numMin			EQU 1

.data
; (insert variable definitions here)
introduction	BYTE "Program 2: Fibonacci Numbers	     by: Amanda Lawrence", 0
namePrompt		BYTE "What is your name?", 0
hello			BYTE "Hello ", 0
firstNumPrompt	BYTE "Enter the number of Fibonacci terms to be displayed.", 0
secondNumPrompt	BYTE "Give the number as an integer in the range [1 .. 46].", 0
thirdNumPrompt	BYTE "How many Fibonacci terms do you want? ", 0
range			BYTE "Enter a number in [1 .. 46]", 0
spaces			BYTE "    ", 0
userName		BYTE 20 DUP(0)
userNameCount	DWORD ?
firstNum		DWORD ?
;numMax = 46
;numMin = 1
nMinus1			DWORD 1
nMinus2			DWORD 0
newFib			DWORD 1
divideBy5		DWORD 5
fivePerLine		DWORD 1

goodbyeString	BYTE "Thank you for playing! Goodbye ", 0

.code
main PROC
; (insert executable instructions here)

; Prints out the title of the program, author's name
mov		edx, OFFSET introduction
call	WriteString
call	CrLF

; prints out instructions to the user
mov		edx, OFFSET namePrompt
call	WriteString
call	CrLf

; reads in the user's name
mov		edx, OFFSET userName
mov		ecx, SIZEOF userName
call	ReadString
mov		userNameCount, eax
call	CrLF

; prints out hello and the user's name
mov		edx, OFFSET hello
call	WriteString
mov		edx, OFFSET userName
call	WriteString
call	CrLf


; Prompts the user to input the first number, the number of Fibonacci terms they want, and then saves it to firstNum
mov		edx, OFFSET firstNumPrompt
call	WriteString
call	CrLF

promptAgain:
mov		edx, OFFSET secondNumPrompt	
call	WriteString
call	CrLf
mov		edx, OFFSET thirdNumPrompt
call	WriteString
call	ReadInt
mov		firstNum, eax
call	CrLF

;Check that number is valid, between 1 and 46
cmp		eax, numMax
jg		outOfRange
cmp		eax, numMin
jl		outOfRange

;Start printing out Fibonacci numbers 
mov		eax, newFib
call	WriteDec	;since we will always run through at least the first Fibonacci number, it is hard-coded here.
mov		ecx, firstNum
dec		ecx			; since we already ran through the first Fibonacci number 2 lines above, decrement the counter in ecx
mov		edx, OFFSET spaces
call	WriteString
mov		eax, nMinus1

startFibLoop:
mov		newFib, eax
call	WriteDec
mov		edx, OFFSET spaces
call	WriteString
mov		newFib, eax
mov		eax, nMinus1
mov		nMinus2, eax
mov		eax, newFib
mov		nMinus1, eax
add		eax, nMinus2

;checks if we have printed five numbers on a line, calls CrLf if so.
;inc		fivePerLine
mov		edx, fivePerLine
inc		edx
mov		fivePerLine, edx
cdq
div		divideBy5
cmp		edx, 0
jne		restoreEAX
call	CrLf

restoreEAX:
mov		eax, nMinus2
add		eax, nMinus1

loop	startFibLoop
jmp		goodbye



outOfRange:
mov		edx, OFFSET range
call	WriteString
call	CrLf
jmp		promptAgain	

	
goodbye:
call	CrLf
mov		edx, OFFSET goodbyeString
call	WriteString
mov		edx, OFFSET userName
call	WriteString
call	CrLf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
