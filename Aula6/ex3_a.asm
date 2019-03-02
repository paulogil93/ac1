#strcpy
strcpy:	
	subu	$sp, $sp, 4
	sw	$ra, 0($sp)
	li	$t0, 0x00
do:
	addu	$t1, $t0, $a0
	addu	$t2, $t0, $a1
	lb	$t3, 0($t1)
	lb	$t4, 0($t2)
	sb	$t3, 0($t2)
	sb	$t4, 0($t1)
while:
	addi	$t2, $t1, 1
	beq	$t2, 0x00, end
	addi	$t0, $t0, 1
	j	do
end:
	move	$v0, $a0
	lw	$ra, 0($sp)
	addu	$sp, $sp, 4
	jr 	$ra