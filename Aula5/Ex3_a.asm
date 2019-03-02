# Mapa de registos
# i:		$t0
# lista:	$t1
# lista[i]:	$t2
	.data
	.eqv	SIZE, 10
	.eqv	TRUE, 1
	.eqv	FALSE, 0
str1:	.asciiz "\nIntroduza um numero: "
str2:	.asciiz "\nConteudo do array: "
str3:	.asciiz "; "
	.align	2
lista:	.space	40
	.eqv	read_int, 5
	.eqv	print_int, 1
	.eqv 	print_string, 4
	.text
	.globl 	main
main:
	li	$t0, 0x00
while1:
	bge	$t0, SIZE, sort
	la	$a0, str1
	li	$v0, print_string
	syscall
	
	li	$v0, read_int
	syscall
	
	la	$t1, lista
	sll	$t2, $t0, 2
	addu	$t2, $t2, $t1
	sw	$v0, 0($t2)
	addi	$t0, $t0, 1
	j	while1
sort:
	li	$t7, SIZE
	sub	$t7, $t7, 1
do:
	li	$t3, FALSE
	li	$t0, 0x00
while2:
	bge	$t0, $t7, endw2
	sll	$t2, $t0, 2
	addu	$t2, $t2, $t1
	lw	$t4, 0($t2)
	lw	$t5, 4($t2)
	ble	$t4, $t5, endif
	sw	$t4, 4($t2)
	sw	$t5, 0($t2)
	li	$t3, TRUE
endif:
	addi	$t0, $t0, 1
	j	while2
endw2:
	beq	$t3, TRUE, do
endDo:
	li	$t0, 0x00
	la	$a0, str2
	li	$v0, print_string
	syscall
while3:
	bge	$t0, SIZE, endw3
	sll	$t2, $t0, 2
	addu	$t2, $t2, $t1
	lw	$t3, 0($t2)
	
	move	$a0, $t3
	li	$v0, print_int
	syscall
	
	la	$a0, str3
	li	$v0, print_string
	syscall
	
	addi	$t0, $t0, 1
	j	while3
endw3:
	jr	$ra
	
	
	
	
	
	
	
	
	
	
	