# Mapa de registos
	.data
	.eqv 	SIZE, 50
	.eqv 	print_string, 4
str1:	.asciiz "Arquitetura de "
str2:	.space 	SIZE
str3:	.asciiz "\n"
str4:	.asciiz "Computadores I"
	.text
	.globl 	main
main:
	subu 	$sp, $sp, 4
	sw	$ra, 0($sp)
	la 	$a0, str2
	la 	$a1, str1
	jal	strcpy
	la	$a0, str2
	li	$v0, print_string
	syscall
	la	$a0, str3
	li	$v0, print_string
	syscall
	
	la	$a0, str2
	la	$a1, str4
	jal	strcat
	
	move 	$a0, $v0 
	li	$v0, print_string
	syscall
	
	lw	$ra, 0($sp)
	addu	$sp, $sp, 4
	jr	$ra
	
	
#char *strcat(char *dst, char *src)
strcat:
	subu	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	move	$s0, $a0

while_sct:
	lb	$s1, 0($a0)
	beq	$s1, 0x00, end_sct
	addi	$a0, $a0, 1
	j	while_sct
end_sct:
	jal	strcpy
	move 	$v0, $s0
	
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	addu	$sp, $sp, 12
	jr	$ra

# char *strcpy(char *dst, char *src)
strcpy:	
	move	$v0, $a0
do:
	lb	$t0, 0($a1)
	sb	$t0, 0($a0)
while_sc:
	addi	$t1, $a1, 1
	lb	$t2, 0($t1)
	beq	$t2, 0x00, end_sc
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	j	do
end_sc:
	jr 	$ra
	