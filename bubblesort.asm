.386
.model flat,stdcall
.stack 5096

include \masm32\include\masm32rt.inc
include \masm32\macros\macros.asm

ExitProcess proto,deExitCode:dword

.data

	list dd 3, 7, 8, 10, 12, 13, 14, 17, 18, 20
	;listLen	equ $ - list
	
.code

main proc

start_:
		mov edx, sizeof list	; length of the array
		mov ecx, 0				; index
		mov edi, 0				; number of times we checked our condition in succession 

check_condition:				
		add edi, 4				; incrementing number of checkings
		add ecx, 4				; incrementing index
		cmp ecx, edx			; checking if we are at last index
		jge	check_endCondition	; if true we check for ending conditions	
		jl compare				; if false we go to the comparison
		
compare:
		sub ecx, 4				; decrementing index as it was increased beforehand
		mov eax, [list + ecx]	; current value in the list at current index
		mov ebx, [list + ecx + 4] ; following value
		cmp eax, ebx			
		jg  swap				; if the current value is greater we are swapping the numbers
		add ecx, 4				; else index is incremented 	
		jmp check_condition		; and we jump back to check_condition

swap:
		;xchg  eax, ebx	
		mov  edi, 0				; we have to swap numbers, therefore the succession is interrupted and we have to set edi to 0
		mov  [list + ecx], ebx	; moving the follwing value stored at ebx to the current index in the list
		mov  [list + ecx + 4], eax ; moving current value to the following index in the list
		add ecx, 4				; increment the index
		jmp check_condition		; jump to check_condition

check_endCondition:
		cmp edx, edi			; base case is that the number of comparisons(successions) equals to the array length
		jne start_				; if not equal the algorithm starts at the beginning
		xor ebx, ebx			
		jmp print_				; else the result is achieved and we print it
	

print_:	
		push edx				; printf uses the edx register, push saves the value in the stack 
		add ebx, 4				; ebx is used as index
		mov edi, [list + ebx - 4] ; current value is stored in edi
		printf (" %d ", edi)	
		pop edx					; saved array length is popped back to edx
		cmp ebx, edx			; check if we reached the end of the array
		jl print_				; it the end is not reached yet print is repeated
		invoke ExitProcess, 0	; else we exit the process
main endp

end main