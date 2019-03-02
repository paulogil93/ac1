#Mapa de registos
	.data
str:	.asciiz "ITED - orievA ed edadisrevinU"
	.eqv print_string, 4
	.text
	.globl main
main:
	la 	$a0, str
	subu	$sp, $sp, 4
	sw	$ra, 0($sp)
	jal	strrev
	lw	$ra, 0($sp)
	move	$a0, $v0
	li	$v0, print_string
	syscall
	jr	$ra

#strrev
strrev:
	subu	$sp, $sp, 16
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	move	$s0, $a0 
	move	$s1, $a0
	move	$s2, $a0
while1:
	lb	$t0, 0($s2)
	beq	$t0, 0x00, endw1
	addi	$s2, $s2, 1
	j	while1
endw1:
	subi	$s2, $s2, 1
while2:
	bge	$s1, $s2, endw2
	lb	$a0, 0($s1)
	lb	$a1, 0($s2)
	jal	exchange
	sb	$v0, 0($s1)
	sb	$v1, 0($s2)
	addi	$s1, $s1, 1
	subi	$s2, $s2, 1
	j	while2
endw2:
	move	$v0, $s0
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	addu	$sp, $sp, 16
	jr	$ra
	
exchange:
	move	$v0, $a1
	move 	$v1, $a0
	jr	$ra
	