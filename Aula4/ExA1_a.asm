# Mapa de registos
# p:	$t0
# *p:	$t1
	.data
	.eqv	SIZE, 20
	.eqv	read_string, 8
	.eqv	print_string, 4
str:	.asciiz "Introduza uma string: "
array:	.space 	SIZE
	.text
	.globl	main
main:
	la	$a0, str
	li	$v0, print_string
	syscall
	
	la 	$a0, array
	li 	$a1, SIZE
	li	$v0, read_string
	syscall
	
	la	$t0, array
while:
	lb	$t1, 0($t0)
	#beq	$t1, 0x00, endw
	beq	$t1, '\n', endw
	subi	$t1, $t1, 0x20
	sb	$t1, 0($t0)
	addi	$t0, $t0, 1
	j	while
endw:
	la 	$a0, array
	li 	$v0, print_string
	syscall
	
	jr	$ra
	
	
	
