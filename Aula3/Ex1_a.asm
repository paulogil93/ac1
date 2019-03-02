# Mapa de registos
# $t0 - soma
# $t1 - value
# $t2 - i
	.data
str1:	.asciiz "Introduza um numero: "
str2:	.asciiz "Valor ignorado\n"
str3:	.asciiz "Soma dos positivos: "
	.eqv print_string, 4
	.eqv read_int, 5
	.eqv print_int10, 1
	.text
	.globl main
main:
	li $t0, 0x00
	li $t2, 0x00
for:
	bge $t2, 5, endfor
	la $a0, str1
	li $v0, print_string
	syscall
	
	li $v0, read_int
	syscall
	move $t1, $v0
	
	ble $t1, $0, else
	add $t0, $t0, $t1
	
	j endif
else:
	la $a0, str2
	li $v0, print_string
	syscall
endif:
	addi $t2, $t2, 1
	j for
endfor:
	la $a0, str3
	li $v0, print_string
	syscall
	
	move $a0, $t0
	li $v0, print_int10
	syscall
	
	jr $ra