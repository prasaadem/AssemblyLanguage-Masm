
; Program Description	:  	This program
;							*Displays Inverse SID and Family Name with capital letters
;							*Prompts user to enter a character and then displays the sum and the message
; Author				:	Aditya Emani
; Date					:   18-November-2016   
; masm					:	Visual - Windows   		


INCLUDE Irvine32.inc

.data
IntVal		DWORD	?
EfName		BYTE	"Enter First Name: ",0
ElName		BYTE	"Enter Last Name: ",0
ESid		BYTE	"Enter SID: ",0
NameSid		BYTE	"Name and SID: ",0
ISidCName	BYTE	"Inverse SID and capitalized family name: ",0
StrIp		BYTE	"Enter Char: ",0
Sum			BYTE	"The Sum of my SID and its inverse is: ",0
var			BYTE	"S"
fName		BYTE	20 DUP (0)
fnameSize	=	($ - fName) - 1
aName		BYTE	20 DUP (0)
nameSize	=	($ - aName) - 1
SID			DWORD	?
sidSize		=	($ - SID) +4
b			DWORD	10
ISid		DWORD	?

.code

main PROC
	call clrscr

;Code to input values

	mov edx, OFFSET EfName
	call WriteString

	mov edx, OFFSET fName
	mov ecx, SIZEOF fName
	call Readstring

	mov edx, OFFSET ElName
	call WriteString

	mov edx, OFFSET aName
	mov ecx, SIZEOF aName
	call Readstring


	mov edx, OFFSET ESid
	call WriteString

	mov edx, OFFSET Intval
	call ReadDec
	mov IntVal,eax


;Code to print the Name and SID

	call clrscr							;Clears the output command screen
	mov edx, OFFSET NameSid
	call WriteString
	call crlf

	mov edx, OFFSET fName				;Moves OFFSET to fName
	call WriteString					;Prints the name at output

	mov edx, OFFSET aName				;Moves OFFSET to aName
	call WriteString					;Prints the name at output
	call crlf

	mov eax, IntVal						;OFFSET at EAX
	call WriteDec						;Prints SID at output
	call crlf
	call crlf

;Code to move the individual SID elements to an array

	mov eax,IntVal
	mov edx,0							;clearing offset for Divison operation
	mov ecx,8							;Initializing counter to 12

L11:	DIV b							;Divides the number stored in edx:eax and keeps remainder in eax
	mov ebx, eax						;Storing the value of EAX in EBX
	mov eax,edx							;storing the Remainder in EAX
	push eax							;pushes the individual elements onto the stack
	mov eax,ebx							;Re-stores the value back to EAX
	mov edx,0
	Loop L11

;Load elements into stack

	mov ecx,8
	mov esi,0
	
L12:	pop eax							;pops the individual elements from stack	
	mov SID[esi],eax					;Storing the elements in array
	add esi,4							;Incrementing the index to access next element
	Loop L12

;pop the SID from the stack in reverse and store in the array

	mov ecx,sidSize						;Initializing the counter to SID length
	mov esi,0			

L3 : 	mov eax, SID[esi]		
	push eax							;Pushes the individual elements to stack			
	add esi,4							;Incrementing the index to access next element
	Loop L3

	mov ecx, sidsize					;Initializing the counter to SID length
	mov esi,0

L4:	pop eax								;pops the individual elements from stack
	movzx ebx, al
	mov SID[esi],ebx					;Storing the reverse popped elements in array
	add esi,4							;Incrementing the index to access next element
	Loop L4

	mov edx, OFFSET ISidCName
	call WriteString
	call crlf

	mov ecx, sidSize
	mov esi,0
	mov eax,0
	mov ebx,10

L1:	MUL ebx								;Loop to print the reversed SID
	add eax, SID[esi]					;saving reversed sid in eax		
	add esi,4							;Incrementing the index to access next element		
	Loop L1
	call WriteDec						;Prints the reversed SID to output
	call crlf
	mov Isid,eax


;Code to Capitalize the Family Name

	mov ecx, nameSize					;Initializing the counter value to Name Size
	mov esi, 0

L5:	AND aName[esi], 11011111b			;Converts lowercase letters to upper case and stores in aName	
	inc esi
	loop L5

	mov edx, OFFSET aName				;Initializes OFFSET to aName
	call WriteString					;Prints Capitalized FamilyName
	call crlf
	call crlf

;Code to prompt user to enter a char
L:	mov edx, OFFSET StrIp		
	call WriteString
	call ReadChar						;Reads a character from Keyboard
	movzx eax,al			
	call WriteChar						;Writes the prompted character at output
	call crlf
	cmp al,var							;Compares if the prompted character is 'S'
	jz L29
	jnz L
										;Loop repeats till the user prompts 'S'

  ;Code to calculate Sum of SID &inverse SID

L29:	mov edx, OFFSET Sum
	call WriteString
	call crlf
mov eax,ISid
	add eax,IntVal							;Sum is stored in EAX
	call WriteDec
	call crlf
	call ReadChar
	
							;Writes the sum to output
	


L10:	exit							;Returning to MSDOS

main ENDP								;End Procedure
END main				;End Program
