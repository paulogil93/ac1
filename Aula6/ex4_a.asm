#char *strcat(char *dst, char *src)
strcat:
	subu	$sp, $sp, 8
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	move	$a0, v
while_sct:
	lb	$s0, 0($a0)
	beq	$s0, 0x00, end_sct
	addi	$a0, $a0, 1
	j	while_sct
end_sct:
	jal	strcpy
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	addu	$sp, $sp, 8
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
	