# Mapa de registos
# num:	  $t0
# p:	  $t1
# p*:	  $t2
	.data 
	.eqv SIZE, 20
	.eqv read_string, 8
	.eqv print_int10, 1
str:	.space SIZE
	.text
	.globl main
main:
	la	$a0, str
	li	$a1, SIZE
	li	$v0, read_string
	syscall
	la	$t1, str
	li 	$t0, 0x00
while:
	lb	$t2, 0($t1)
	beq	$t2, 0x00, endw
	blt	$t2, '0', endif
	bgt	$t2, '9', endif
	addi	$t0, $t0, 1
endif:
	addiu	$t1, $t1, 1
	j	while
endw:
	move	$a0, $t0
	li	$v0, print_int10
	syscall
	
	jr	$ra
	