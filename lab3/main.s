/* -- ARM */

/* -- DATA SECTION */

.data

/* CONTROL VARIABLES */
.balign 4/*return variable*/
rval: .word 0
data1: .space 100
data2: .space 100
input_src: .word 0
input_dst: .word 0
input_len: .word 0
trash: .word 0

/* -- STRINGS */
.balign 4
sprompt: .asciz "0x00000000: \n"
sprompt2: .asciz "0x00000064: \n"
testp: .asciz "Init Chunk %d\n"
pr_cpdata: .asciz "COPYDATA\n"
pr_srcadr: .asciz "source_address: "
pr_dstadr: .asciz "dest_address: "
pr_length: .asciz "length: "
inv_src: .asciz "Invalid Source Address\n"
inv_dst: .asciz "Invalid Destination Address \n"
inv_same: .asciz "Addresses are same. Invalid \n"
inv_len: .asciz "Invalid Length\n"

format_hex: .asciz "%x"
format_dec: .asciz "%d"
format_hex_n: .asciz "%x\n"
format_str: .asciz "%"
carat: .asciz "> "
endl: .asciz "\n"


/* -- PROGRAM SECTION */
.text

@ Assumes data is in r0, value in r1
init_chunk:
    push    {r2, lr}
    mov		r2, #0 @index
init_chunk_loop:
	str		r1, [r0, r2]
	add 	r2, r2, #4
	cmp 	r2, #100
	bne 	init_chunk_loop
    pop     {r2, pc}

@ Data address in r0
print_data:
	push    {r2-r3, lr}
    mov		r2, #0 @index
print_data_loop:
	ldr		r3, [r0, r2]
	add 	r2, r2, #4

	@ print the value
	push	{r0-r2}
	ldr 	r0, =format_hex
	mov 	r1, r3
	bl 		printf
	pop	 	{r0-r2}

	cmp 	r2, #100
	bne 	print_data_loop
    pop     {r2-r3, pc}

@Print the prompts
user_prompt:
	push 	{r0, lr}

	@ print intro data1
	ldr		r0,	=sprompt
	bl		printf 
	ldr 	r0, =data1
	bl		print_data 
	ldr		r0,	=endl
	bl		printf 

	@ print intro data2
	ldr		r0,	=sprompt2
	bl		printf 
	ldr 	r0, =data2
	bl		print_data 
	ldr		r0,	=endl
	bl		printf 

    pop     {r0, pc}

@ flushes the input
flush: 
	push 	{r0, r1, lr}
	ldr 	r0, =format_str
	ldr 	r1, =trash
    pop     {r0, r1, pc}

@ Checks for valid address. Assume value r0. Return 1 or 0 r1
valid_addr:
	push 	{r0, r3, r4, lr}
	mov 	r1, #1
	ldr 	r3, =0x00000000
	ldr 	r4, =0x00000064
	cmp  	r0, r3
	beq 	va_exit
	cmp 	r0, r4
	beq 	va_exit
	mov 	r1, #0
va_exit:
    pop     {r0, r3, r4, pc}




.global main

/* =============== */
/* -- PROGRAM MAIN */
/* =============== */
main:
	@ Store return value
	ldr 	r1, =rval
	str 	lr, [r1]

	ldr		r0,	=data1
	ldr 	r1, =0xAAAAAAAA
	bl		init_chunk 

	ldr		r0,	=data2
	ldr 	r1, =0xBBBBBBBB
	bl		init_chunk

	@ prompt stuff
	bl 		user_prompt
	ldr		r0,	=pr_cpdata
	bl		printf 

	@ Get user input for src, dest, and len. 
	ldr 	r0, =pr_srcadr
	bl 		printf
	ldr 	r0, =format_hex
	ldr  	r1, =input_src
	bl 		scanf

	ldr 	r0, =pr_dstadr 
	bl 		printf
	ldr 	r0, =format_hex
	ldr  	r1, =input_dst
	bl 		scanf

	ldr 	r0, =pr_length
	bl 		printf
	ldr 	r0, =format_dec
	ldr  	r1, =input_len
	bl 		scanf

	@ Check for invalid data
	ldr 	r0, =input_src
	ldr 	r0, [r0]
	bl 		valid_addr
	beq 	_x1
	@ leave
	ldr 	r0, =inv_src
	bl 		printf
	b 		_exit
_x1:

	@ Check for invalid data
	ldr 	r0, =input_dst
	ldr 	r0, [r0]
	bl 		valid_addr
	cmp 	r1, #1 
	beq 	_x2
	@ leave
	ldr 	r0, =inv_dst
	bl 		printf
	b 		_exit
_x2:

	@ Check for SAME ADDRESS
	ldr 	r0, =input_src
	ldr 	r0, [r0]
	ldr 	r1, =input_dst
	ldr 	r1, [r1]
	cmp 	r0, r1
	bne 	_x2_5
	@ leave
	ldr 	r0, =inv_same
	bl 		printf
	b 		_exit
_x2_5:

	@ Checks for valid address. Assume value r0. Return 1 or 0 r1
	ldr 	r1, =input_len
	ldr 	r1, [r1]
	cmp  	r1, #100
	bgt 	_x3_bad
	cmp 	r1, #0
	blt 	_x3_bad
	b 		_x3
_x3_bad:
	@ leave
	ldr 	r0, =inv_len
	bl 		printf
	b 		_exit
_x3:

	@ ALL INPUT IS VALID! PROCEDE
	@ swap data between addresses
	ldr r0, =data1
	ldr r1, =data2
	mov r2, #0 @offset
	ldr r5, =input_len
	ldr r5, [r5]
the_loop:
	ldrb	r3, [r0, r2] 
	ldrb	r4, [r1, r2] 
	strb	r3, [r1, r2] 
	strb	r4, [r0, r2] 
	add 	r2, r2, #1
	cmp 	r2, r5
	bne 	the_loop

	@ prompt stuff
	bl 		user_prompt

_exit:
	@ get outta here. 
	ldr 	lr, =rval
	ldr 	lr, [lr]
	bx 		lr


/* -- VARIABLE DEFINITIONS (addresses) */

/* -- EXTERNALS */
.global printf
.global scanf


