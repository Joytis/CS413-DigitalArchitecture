/* -- ARM */

/* -- DATA SECTION */

.data

/* CONTROL VARIABLES */
.balign 4 /* price of a soda */
mprice: .word 		55
.balign 4/*return variable*/
mrval: .word			0
.balign 4/*input variable*/
minput: .word		0

/* -- COIN VALUES */
.balign 4 /* penny */
mpenny: .word 		1
.balign 4 /* nickel */
mnickel: .word 		5
.balign 4 /* dime */
mdime: .word 		10
.balign 4 /* quarter */
mquarter: .word 		25
.balign 4 /* 50c piece */
mfcp: .word 			50
.balign 4 /* dollar */
mdollar: .word  		100
.balign 4 /* slug(?) */
mslug: .word 		0

/* -- STRINGS */
.balign  4 /* input format for scanf */
minputformat: .asciz "%s"
.balign  4 /* Prompt */
mprompt: .asciz "Enter coin or select return.\n"
.balign 4
miprompt: .asciz "Welcome to the Soda Machine!\n"
.balign 4 /* total  prompt */
mtprompt: .asciz "Total is %d cents.\n\n"
.balign 4 /* returning  prompt */
mretprompt: .asciz "Returning all change!\n"
.balign 4 /* returning  prompt */
mpcarat: .asciz "> "
.balign 4 /* returning  prompt */
mpriceprompt: .asciz "Make selection or return: (C) Coke, (S) Sprite, (P) Dr. Pepper, (D) Diet Coke, or (M) Mellow Yellow\n"
.balign 4 /* coke  prompt */
mscoke: .asciz "Selection is Coke\n"
.balign 4 /* spr  prompt */
mssprite: .asciz "Selection is Sprite\n"
.balign 4 /* dp  prompt */
msdp: .asciz "Selection is Dr. Pepper\n"
.balign 4 /* dcoke  prompt */
msdietcoke: .asciz "Selection is Diet Coke\n"
.balign 4 /* my  prompt */
msmy: .asciz "Selection is Mellow Yellow\n"
.balign 4 /* change  prompt */
mchange: .asciz "Returning %d cents as change!\n"
.balign 4 /* change  prompt */
moutchoice: .asciz "The machine is out of this selection!\n"

.balign 4 /* null prompt to fix seg fault */
mnullp: .asciz "\n"


/* -- PROGRAM SECTION */
.text
.global main

/* =============== */
/* -- PROGRAM MAIN */
/* =============== */
main:
	ldr 		r1, 		rval
	str 		lr, 		[r1]

	/* -- LOAD UP SOME REGISTERS */
	mov	r5,		#0 /* Total Change */
	ldr	 	r6,		price
	ldr 		r6, 		[r6]
	mov 	r7, 		#0 /* storing current input  */
	mov 	r9, 		#0 /* using as a flag. */

	mov 	r4, 		#3	/* Stores the amount of Coke*/
	mov 	r8, 		#2	/* Stores the amount of Sprite*/
	mov 	r10, 	#4	/* Stores the amount of DP*/
	mov 	r11, 	#5	/* Stores the amount of Diet Coke*/
	mov 	r12, 	#3	/* Stores the amount of Mellow Yellow */

	
	/* print out intro message */
	ldr 		r0,		iprompt
	bl		printf 

/* Main program loop */
_loop1:

	@ PRINT OUT A PROMPT 	
	ldr		r0, 		prompt
	bl		printf

	@ PRINT OUT A PROMPT 	
	ldr		r0, 		pcarat
	bl		printf
	@ ENTER AN OPTION 
	ldr		r0, 		inputformat
	ldr		r1, 		input
	bl		scanf
	
	@ GET CHARACTER VALUE
	ldr 		r7, 		input
	ldr		r7, 		[r7]
	
	@ P Penny
	@ N Nickel
	@ D Dime
	@ Q Quarter
	@ F 50c
	@ B dollar bill
	@ S Slug
	@ Return Change
	
	
									@PENNY
	cmp 	r7, 		#80  @P
	bne		_if1
	add		r5, 		r5, 		#1
_if1:									@NICKEL
	cmp 	r7, 		#78  @N
	bne		_if2
	add		r5, 		r5, 		#5
_if2:									@DIME
	cmp 	r7, 		#68  @D
	bne		_if3
	add		r5, 		r5, 		#10
_if3:									@QUARTER
	cmp 	r7, 		#81  @Q
	bne		_if4
	add		r5, 		r5, 		#25
_if4:									@FIFTY
	cmp 	r7, 		#70  @F
	bne		_if5
	add		r5, 		r5, 		#50
_if5:									@DOLLAR
	cmp 	r7, 		#66  @B
	bne		_if6
	add		r5, 		r5, 		#100
_if6:									@SLUG
	cmp 	r7, 		#83  @S
	bne		_if7
_if7:									@RETURN
	cmp 	r7, 		#82  @R
	bne		_if8
 	mov	r5, 		#0

	@ PRINT OUT A PROMPT
	ldr		r0, 		retprompt
	bl		printf
_if8:

	
	@ PRINT OUT A PROMPT
	ldr		r0, 		tprompt
	mov	r1, 		r5
	bl		printf

	cmp 	r5, 		r6
	bls		_ifprice

_priceloop:
	mov 	r9, 		#0

	@ PRINT OUT A PROMPT
	ldr		r0, 		priceprompt
	bl		printf

	@ PRINT OUT A PROMPT 	
	ldr		r0, 		pcarat
	bl		printf
	@ ENTER AN OPTION 
	ldr		r0, 		inputformat
	ldr		r1, 		input
	bl		scanf
	
	@ GET CHARACTER VALUE
	ldr 		r7, 		input
	ldr		r7, 		[r7]
	
	@ C Coke 3
	@ S Sprite 8
	@ P DR P 10
	@ D Diet Coke 11
	@ M Mellow Yellow 12

									@Coke
	cmp 	r7, 		#67  @C
	bne		_sel1
	cmp 	r4,		#0
	beq		_sel1o
	ldr		r0,		scoke
	mov 	r9, 		#1
	subs 	r4, 		r4, 		#1
	b		_sel1	
_sel1o:
	ldr 		r0, 		outchoice
	mov 	r9, 		#2
_sel1:
									@Sprite
	cmp 	r7, 		#83  @S
	bne		_sel2
	cmp 	r8,		#0
	beq		_sel2o
	ldr		r0,		ssprite
	mov 	r9, 		#1	
	subs 	r8, 		r8, 		#1
	b		_sel2	
_sel2o:
	ldr 		r0, 		outchoice
	mov 	r9, 		#2
_sel2:
									@DR p
	cmp 	r7, 		#80  @P
	bne		_sel3
	cmp 	r10, 	#0
	beq		_sel3o
	ldr		r0,		sdp
	mov 	r9, 		#1	
	subs 	r10, 	r10, 	#1
	b		_sel3	
_sel3o:
	ldr 		r0, 		outchoice
	mov 	r9, 		#2
_sel3:
									@Diet Coke
	cmp 	r7, 		#68  @D
	bne		_sel4
	cmp 	r11, 	#0
	beq		_sel4o
	ldr		r0,		sdietcoke
	mov 	r9, 		#1
	subs 	r11, 	r11, 	#1
	b		_sel4	
_sel4o:
	ldr 		r0, 		outchoice
	mov 	r9, 		#2	
_sel4:
									@MY
	cmp 	r7, 		#77  @M
	bne		_sel5
	cmp 	r12, 	#0
	beq		_sel5o
	ldr		r0,		smy
	mov 	r9, 		#1	
	subs 	r12, 	r12, 	#1
	b		_sel5	
_sel5o:
	ldr 		r0, 		outchoice
	mov 	r9, 		#2
_sel5:
									@ RETURN
	cmp 	r7, 		#82  @R
	bne		_sel6
	@ PRINT OUT A PROMPT
	ldr		r0,		retprompt
	bl		printf
	mov 	r9, 		#1	
	b		_priceloopexit
	
_sel6:		
	
	cmp	r9, 		#1
	bpl		_nullskp
	ldr		r0, 		nullp
_nullskp:				
	
	@ PRINT OUT A PROMPT
	bl		printf

	cmp	r9, 		#2
	beq		_priceloop

	cmp	r9, 		#1
	bne		_priceloop
	
	sub 	r5, 		#55
	@ PRINT OUT A PROMPT
	ldr		r0, 		pchange
	mov	r1, 		r5
	bl		printf
	
_priceloopexit:
	mov 	r5, 		#0
	
_ifprice:

	b 		_loop1
_end:
	ldr 		lr, 		rval
	ldr 		lr, 		[lr]
	bx 		lr


/* -- VARIABLE DEFINITIONS (addresses) */
price		: .word mprice
rval			: .word mrval
input		: .word minput

penny	 	: .word mpenny
nickel	 	: .word mnickel
dime 		: .word mdime 		
quarter		: .word mquarter
fcp	 		: .word mfcp 			
dollar 		: .word mdollar 		
slug 		: .word mslug

inputformat 	: .word minputformat
iprompt		: .word miprompt
prompt 		: .word mprompt
tprompt 		: .word mtprompt
retprompt	: .word mretprompt
pcarat 		: .word mpcarat
priceprompt	: .word mpriceprompt
pchange 	: .word mchange
outchoice	: .word moutchoice
nullp		: .word mnullp

scoke		: .word mscoke
ssprite		: .word mssprite
sdp			: .word msdp
sdietcoke	: .word msdietcoke
smy		: .word msmy

/* -- EXTERNALS */
.global printf
.global scanf


