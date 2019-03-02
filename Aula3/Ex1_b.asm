# Mapa de registos
# $t0 - bit
# $t1 - value
# $t2 - i
	.data
str1:	.asciiz "Introduza um numero: "
str2:	.asciiz "Valor em binario: "
	.eqv print_string, 4
	.eqv read_int, 5
	.eqv print_char, 11
	.text
	.globl main
main:
	li $t0, 0x00
	li $t1, 0x00
	li $t2, 0x00
	
	la $a0, str1
	li $v0, print_string
	syscall
	
	li $v0, read_int
	syscall
	move $t1, $v0
	
	la $a0, str2
	li $v0, print_string
	syscall
for:
	bge $t2, 32, endfor
	andi $t0, $t1, 0x80000000
	
	beq $t0, 0x00, else
	li $a0, '1'
	li $v0, print_char
	syscall
	
	j endif
else:
	li $a0, '0'
	li $v0, print_char
	syscall
endif:
	sll $t1, $t1, 1
	addi $t2, $t2, 1
	j for
endfor:
	jr $ra