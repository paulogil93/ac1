# Mapa de registos
# p:		$t0
# *p:		$t1
# lista+size:	$t2
	.data
	.eqv	SIZE, 10
str1:	.asciiz "\nConteudo do array: "
str2:	.asciiz "; "
lista:	.word 	8, -4, 3, 5, 124, -15, 87, 9, 27, 15
	.eqv	print_int, 1
	.eqv 	print_string, 4
	.text
	.globl 	main
main:
	la	$a0, str1
	li	$v0, print_string
	syscall
	
	la	$t0, lista
	li	$t2, SIZE
	sll	$t2, $t2, 2
	addu	$t2, $t2, $t0
while:
	bge	$t0, $t2, endw
	lw 	$t1, 0($t0)
	move	$a0, $t1
	li	$v0, print_int
	syscall
	la	$a0, str2
	li	$v0, print_string
	syscall
	addu	$t0, $t0, 4
	j	while
endw:
	jr	$ra
	
	