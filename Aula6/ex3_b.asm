#Mapa de registos
# $s0:	exit_value
	.data
	.eqv STR_MAX_SIZE, 30
	.eqv print_string, 4
	.eqv print_int10, 1
str1:	.asciiz "I serodatupmoC ed arutetiuqrA"
str2:	.space 31
str3:	.asciiz "\n"
str4:	.asciiz "String too long: "
	.text
	.globl main
main:
	li 	$s0, 0x00
if1:
	la	$a0, str1
	subu	$sp, $sp, 4
	sw	$ra, 0($sp)
	jal	strlen
	bgt	$v0, STR_MAX_SIZE, else
	la	$a0, str2
	la	$a1, str1
	jal	strcpy
	move	$a0, $v0
	li	$v0, print_string
	syscall
	la	$a0, str3
	li	$v0, print_string
	syscall
	la	$a0, str2
	jal	strrev
	move 	$a0, $v0
	li	$v0, print_string
	syscall
	li	$s0, 0x00
	j	endif
else:	
	la	$a0, str4
	li	$v0, print_string
	syscall
	la 	$a0, str1
	jal	strlen
	move	$a0, $v0
	li	$v0, print_int10
	syscall
	li	$s0, 0xF
endif:
	lw	$ra, 0($sp)
	addu	$sp, $sp, 4
	jr	$ra
	
# char *strcpy(char *dst, char *src)
strcpy:	
	li	$t0, 0x00
do:
	addu	$t1, $t0, $a0
	addu	$t2, $t0, $a1
	lb	$t3, 0($t2)
	sb	$t3, 0($t1)
while_sc:
	addi	$t2, $t2, 1
	lb	$t3, 0($t2)
	beq	$t3, 0x00, end_sc
	addi	$t0, $t0, 1
	j	do
end_sc:
	move	$v0, $a0
	jr 	$ra
	
# int strlen(char *s)
strlen:
	li	$t0, 0x00
while_sl:
	lb	$t1, 0($a0)
	addiu	$a0, $a0, 1
	beq	$t1, '\0', endw_sl
	addi	$t0, $t0, 1
	j	while_sl
endw_sl:
	move	$v0, $t0
	jr	$ra
	
# char *strrev(char *)
strrev:
	subu	$sp, $sp, 16
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	move	$s0, $a0 
	move	$s1, $a0
	move	$s2, $a0
while1_sr:
	lb	$t0, 0($s2)
	beq	$t0, 0x00, endw1_sr
	addi	$s2, $s2, 1
	j	while1_sr
endw1_sr:
	subi	$s2, $s2, 1
while2_sr:
	bge	$s1, $s2, endw2_sr
	lb	$a0, 0($s1)
	lb	$a1, 0($s2)
	jal	exchange
	sb	$v0, 0($s1)
	sb	$v1, 0($s2)
	addi	$s1, $s1, 1
	subi	$s2, $s2, 1
	j	while2_sr
endw2_sr:
	move	$v0, $s0
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	addu	$sp, $sp, 16
	jr	$ra

# void exchange(char *c1, char *c2)
exchange:
	move	$v0, $a1
	move 	$v1, $a0
	jr	$ra
