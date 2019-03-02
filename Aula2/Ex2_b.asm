	.data
	.eqv read_int, 5
	.eqv print_int16, 34
	.eqv print_char, 11
	.text
	.globl main
main:
	li $v0, read_int
	syscall
	move $t0, $v0
	
	#Digito 3
	and $t1, $t0, 0x0000F000
	srl $t1, $t1, 12
	move $a0, $t1
	li $v0, print_int16	
	syscall
	li $a0, 0x20	#space
	li $v0, print_char
	syscall
	
	#Digito 2
	and $t1, $t0, 0x00000F00
	srl $t1, $t1, 8
	move $a0, $t1
	li $v0, print_int16
	syscall
	li $a0, 0x20	#space
	li $v0, print_char
	syscall
	
	#Digito 1
	and $t1, $t0, 0x000000F0
	srl $t1, $t1, 4
	move $a0, $t1
	li $v0, print_int16
	syscall
	li $a0, 0x20	#space
	li $v0, print_char
	syscall
	
	#Digito 0
	and $t1, $t0, 0x0000000F
	move $a0, $t1
	li $v0, print_int16
	syscall
	li $a0, 0x20	#space
	li $v0, print_char
	syscall
	
	jr $ra