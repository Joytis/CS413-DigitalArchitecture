/* -- ARM */

/* -- DATA SECTION */
.data

@ Array 1
.balign  4 /* input format for scanf */
data1: .skip 100
@ Array 2
data2: .skip 100

/* -- STRINGS */
.balign  4 /* input format for scanf */
moutput_start_data1: .asciz "Data 1: "
output_start_data2: .asciz "Data 2: "
format_hex: .asciz "%x"
prompt_carat: .asciz "> "
prompt_endl: .asciz "\n"


/* -- PROGRAM SECTION */
.text

@@ Assumes data is in r0, value in r1
@init_chunk:
@    push    {r2, lr}
@    mov		r2, #0 @index
@
@    ldr 	r0, output_start_data1
@	bl 		printf
@init_chunk_loop:
@	str		r1, [r0, r2]
@	add 	r2, r2, #4
@	cmp 	r2, #100
@	bne 	init_chunk_loop
@    pop     {r2, pc}
@
@@ Data address in r0
@print_data:
@	push    {r2-r3, lr}
@    mov		r2, #0 @index
@    ldr 	r0, output_start_data1
@	bl 		printf
@print_data_loop:
@	ldr		r3, [r0, r2]
@	add 	r2, r2, #4
@
@	@ print the value
@	push	{r0, r1}
@	ldr 	r0, =format_hex
@	mov 	r1, r3
@	pop	 	{r0, r1}
@
@	cmp 	r2, #100
@	bne 	init_chunk_loop
@    pop     {r2-r3, pc}

.global main


/* =============== */
/* -- PROGRAM MAIN */
/* =============== */
main:
	ldr		r0, output_start_data1
	bl		printf

	@ Initialize the data sections. 
	@ldr 	r0, data1
	@ldr 	r1, =0xAAAAAAAA
	@ldr 	r0, output_start_data1
	@bl 		printf
	@bl 		init_chunk
@
	@ldr 	r0, data2
	@ldr 	r1, =0xBBBBBBBB
	@ldr 	r0, output_start_data1
	@bl 		printf
	@bl 		init_chunk
@
@
@
	@@ Initial data print
	@ldr 	r0, output_start_data1
	@bl 		printf
	@ldr 	r0, data1
	@bl 		print_data
@
@
	@ldr 	r0, output_start_data2
	@bl 		printf
	@ldr 	r0, data2
	@bl 		print_data

	bx 		lr


output_start_data1 		: .word moutput_start_data1


/* -- EXTERNALS */
.global printf
.global scanf




