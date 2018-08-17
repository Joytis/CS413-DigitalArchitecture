/* -- ARM */

/* -- DATA SECTION */
@ 24.96.117.81

.data


/* -- PROGRAM SECTION */
.text

/* =============== */
/* -- PROGRAM MAIN */
/* =============== */
			.global _start
_start:        
		LDR sp, =stack
		ADD sp, sp, #100      @ since we use push and pop, it assumes a 
                                 @ full descending (FD) stack
                                 @ so stack pointer should start at the higher 
                                 @ addresses and the stack will grow up

		@ Sum even numbers from 1 to 25
		MOV r2, #0
		MOV r1, #1
evenSumLoop:
		ANDS r3, r1, #1		
		BLEQ printNum
		ANDS r3, r1, #1
		ADDEQ r2, r2, r1
		ADD r1, r1, #1
		CMP r1, #26
		BMI evenSumLoop
		@ print sum
		MOV r1, r2
		BL printNum
		MOV r5, r2

		@ Sum odd numbers from 1 to 25
		MOV r2, #0
		MOV r1, #1
oddSumLoop:
		ANDS r3, r1, #1
		BLNE printNum
		ANDS r3, r1, #1
		ADDNE r2, r2, r1
		ADD r1, r1, #1
		CMP r1, #26
		BMI oddSumLoop
		@ print sum
		MOV r1, r2
		BL printNum

		ADD r1, r2, r5
		BL printNum


		@ exit the program
		MOV r7, #1
		SVC 0

		@ How do I actually exit the program??
		@ BX lr;

printNum:	 
		PUSH {lr}
		
		@ This is the value I want to print    
		BL outDec             @ call subroutine to print the value
		BL newline            @ print a newline

		POP {pc}


outDec:   @ This routine expects the number to be printed to be in r1 before being called
		PUSH  {r0-r4, r6, r8, lr}     @ save working registers & link register
		MOV   r8, #0
		MOV   r4, #0                  @ number of digits in number to print
outNext:  
		MOV   r8, r8, LSL #4
		ADD   r4, r4, #1
		BL    div10                   @ quotient will be in r1 and remainder in r2
		ADD   r8, r8, r2              @ insert remainder (least significant digit)
		CMP   r1, #0                  @ if quotient zero then all done
		BNE   outNext                 @ else deal with the next digit
outNxt1:  AND   r0, r8, #0xF
		ADD   r0, r0, #0x30
		LDR   r6, =value
		STR   r0, [r6]                @ copy value in r0 to our storage area (value)
		MOVS  r8, r8, LSR #4
		BL    putCh
		SUBS  r4, r4, #1              @ decrement counter
		BNE   outNxt1                 @ repeat until all printed          
outEx:    POP {r0-r4, r6, r8, pc}       @ restore registers and return

div10:                                  @ divide r1 by 10
								@ return with quotient in r1, remainder in r2      
		SUB   r2, r1, #10
		SUB   r1, r1, r1, LSR #2
		ADD   r1, r1, r1, LSR #4
		ADD   r1, r1, r1, LSR #8
		ADD   r1, r1, r1, LSR #16
		MOV   r1, r1, LSR #3
		ADD   r3, r1, r1, ASL #2
		SUBS  r2, r2, r3, ASL #1
		ADDPL r1, r1, #1
		ADDMI r2, r2, #10
		MOV   pc, lr                  @ exit div10 and return

putCh:    
		PUSH {r0-r2, r7, lr}          @ save working registers

		@ write the value
		MOV   r7, #4                  @ doing a write
		MOV   r0, #1                  @ file descriptor for standard output
		LDR   r1, =value              @ address of character to print
		MOV   r2, #1                  @ buffer size of 1 (writing 1 char)
		SVC   0                       @ invoke kernel (do system call)

		POP {r0-r2, r7, pc}           @ exit putCh and return

newline:
		PUSH {r0-r2, r7, lr}          @ save working registers

		@ write a newline
		MOV  R7, #4                   @ doing a write
		MOV  R0, #1                   @ file descriptor for standard output
		LDR  R1, =nl                  @ address of newline character stored
		MOV  R2, #1                   @ buffer size of 1 (writing 1 char)
		SVC  0                        @ do the system call

		POP {r0-r2, r7, pc}           @ exit newline


.data

value:  .word 0                 @ place to store value
stack:  .space 100, 0           @ set up stack
nl:     .ascii "\n"


