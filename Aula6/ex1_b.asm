#Mapa de registos
	.data
str:	.asciiz "Arquitetura de Computadores I"
	.eqv print_int10, 1
	.text
	.globl main
main:
	subu 	$sp, $sp, 4
	sw 	$ra, 0($sp)
	la 	$a0, str
	jal 	strlen
	move 	$a0, $v0
	li 	$v0, print_int10
	syscall
	lw	$ra, 0($sp)
	addu	$sp, $sp, 4
	jr 	$ra

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
