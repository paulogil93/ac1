# Mapa de registos
# $t0 - value
# $t1 - i
# $t2 - digito	
	.data
str1:	.asciiz "Introduza um numero: "
str2:	.asciiz "\nO valor em hexadecimal: "
	.eqv	print_string, 4
	.eqv	read_int, 5
	.eqv	print_char, 11
	.text
	.globl	main
main:
	la	$a0, str1
	li	$v0, print_string
	syscall
	
	li	$v0, read_int
	syscall
	move	$t0, $v0
	
	la 	$a0, str2
	li 	$v0, print_string
	syscall
	
	li 	$t1, 0x08
while:
	andi 	$t3, $t0, 0xF0000000
	bnez 	$t3, do
	blez 	$t1, do
	sll 	$t0, $t0, 4
	subi 	$t1, $t1, 1
	j 	while
do:
	andi 	$t2, $t0, 0xF0000000
	srl 	$t2, $t2, 28
	bgt 	$t2, 9, else
	addi 	$t3, $t2, 0x30
	move	$a0, $t3
	li	$v0, print_char
	syscall
	j	endif
else:
	addi	$t3, $t2, 0x30
	addi 	$t3, $t3, 0x07
	move	$a0, $t3
	li	$v0, print_char
	syscall
endif:
	sll 	$t0, $t0, 4
	subi	$t1, $t1, 1
	blez	$t1, EXIT
	j	do
EXIT:
	jr	$ra
	
	
