# Testing the OLED screen, displaying an animated pattern with
# all the 65K colors.

.include "femtorv32.inc"
.include "ssd1351_1331.inc"

# On the IceStick, install the code in BRAM (much faster)
.ifdef ICE_STICK
.section .fastcode
.endif
.ifdef ICE_ZERO
.section .fastcode
.endif

.globl main
.type  main, @function
	
main:   add sp,sp,-4
        sw ra, 0(sp)
	
	call GL_init
	
	# anim
	# s0 = X, s1 = Y, s2 = bound, s3 = frame
	li s2,128	
	li s3,0
anim:	
        OLED2 0x15,0x00,0x7f         # column address
	OLED2 0x75,0x00,0x7f         # row address
	OLED0 0x5c                   # write RAM
	li s1,0
loop_y:	li s0,0
loop_x:	add s0,s0,1

	# compute pixel color: RRRRR GGGGG 0 BBBBB
	# (or an additional G LSB instead of 0)
	#  RRRRR = X+frame
	#  GGGGG = X >> 3
	#  BBBBB = Y+frame

	add t0,s0,s3
	sll t0,t0,3
	
	srl t1,s0,5
	and t1,t1,7
	or  t0,t0,t1
	sw t0, IO_SSD1351_DAT(gp)
	add t0,s1,s3
	andi t0,t0,31
	sll t1,s0,3
	and t1,t1,192
	or  t0,t0,t1
	sw t0, IO_SSD1351_DAT(gp)
	
	bne s0,s2,loop_x
	add s1,s1,1
	bne s1,s0,loop_y
	add s3,s3,1

	sw s3, 0(gp)
	j anim

        li a0,0
	lw ra, 0(sp)
	add sp,sp,4
	ret
