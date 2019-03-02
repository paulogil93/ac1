#Mapa de registos
# res:		$v0
# s:		$a0
# *s:		$t0
#digit:		$t1
	.data
	.eqv print_int10, 1
str:	.asciiz "2016 e 2020 sao anos bissextos"
	.text
	.globl main
main:
	subu	$sp, $sp, 4
	sw	$ra, 0($sp)
	la	$a0, str
	jal	atoi
	move	$a0, $v0
	li	$v0, print_int10
	syscall
	lw	$ra, 0($sp)
	addu	$sp, $sp, 4
	jr	$ra
	
#atoi - unsigned int atoi(char *s)
atoi:
	li	$v0, 0x00
while_at:
	lb	$t0, 0($a0)
	blt	$t0, '0', endw_at
	bgt	$t0, '9', endw_at
	subi	$t1, $t0, '0'
	addiu	$a0, $a0, 1
	mul	$v0, $v0, 10
	add	$v0, $v0, $t1
	j	while_at
endw_at:
	jr	$ra
