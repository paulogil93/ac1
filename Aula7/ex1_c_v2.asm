#Mapa de registos
# res:		$v0
# s:		$a0
# *s:		$t0
# digit:	$t1
# index:	$t2
# string_size:	$t3
# size-index:	$t4
#
	.data
	.eqv print_int10, 1
str:	.asciiz "1010"
	.text
	.globl main
main:
	subu	$sp, $sp, 4
	sw	$ra, 0($sp)
	la	$a0, str
	jal	atoi
	move	$a0, $v0
	li	$v0, print_int10
	syscall
	lw	$ra, 0($sp)
	addu	$sp, $sp, 4
	jr	$ra
	
#atoi - unsigned int atoi(char *s)
atoi:
	subu	$sp, $sp, 32
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	sw	$s6, 28($sp)
	move	$s0, $a0	#s
	jal	strlen
	move	$s1, $v0	#strlen(s)
	li	$v0, 0x00
	li	$s2, 0x00
	subi	$s1, $s1, 1
while_at:
	bgt	$s2, $s1, endw_at
	add	$s3, $s2, $s0
	lb	$s4, 0($s3)
	beq	$s4, 0x00, endw_at
if_at:	
	beq	$s4, '0', endif_at
	sub	$s5, $s1, $s2
	li	$s6, 1
	sllv	$s6, $s6, $s5
	add	$v0, $v0, $s6
endif_at:
	addi	$s2, $s2, 1
	j	while_at
endw_at:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	addu	$sp, $sp, 32
	jr	$ra
	
#strlen
strlen:
	li	$t0, 0x00
while:
	lb	$t1, 0($a0)
	addiu	$a0, $a0, 1
	beq	$t1, '\0', endw
	addi	$t0, $t0, 1
	j	while
endw:
	move	$v0, $t0
	jr	$ra
