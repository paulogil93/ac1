	.data
	.eqv	print_int10, 1
	.text
	.globl main
main:
	subu	$sp, $sp, 4
	sw	$ra, 0($sp)
	li	$a0, 15
	li	$a1, 3
	jal	div_x
	move	$a0, $v0
	li	$v0, print_int10
	syscall
	
	lw	$ra, 0($sp)
	addu	$sp, $sp, 4
	jr	$ra

# unsigned int div(unsigned int dividendo, unsigned in divisor)
div_x:
	li	$t0, 0x00
	li	$t1, 0x00
	li	$t2, 0x00
	li	$t3, 0x00
	
	sll	$a1, $a1, 16
	andi	$a0, $a0, 0xFFFF
	sll	$a0, $a0, 1
	
for_div:
	bgeu	$t0, 16, endf_div
	li	$t1, 0x00
if_div:
	bltu	$a0, $a1, endif_div
	subu	$a0, $a0, $a1
	li	$t1, 0x01
endif_div:
	sll	$a0, $a0, 1
	or	$a0, $a0, $t1
	addi	$t0, $t0, 1
	j	for_div
endf_div:
	srl	$t3, $a0, 1
	andi	$t3, $t3, 0xFFFF0000
	andi	$t2, $a0, 0xFFFF
	
	or	$v0, $t3, $t2
	jr	$ra
	