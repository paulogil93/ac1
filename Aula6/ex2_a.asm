#strrev
strrev:
	subu	$sp, $sp, 16
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	move	$s0, $a0 
	move	$s1, $a0
	move	$s2, $a0
while1:
	lb	$t0, 0($s2)
	beq	$t0, 0x00, endw1
	addi	$s2, $s2, 1
	j	while1
endw1:
	subi	$s2, $s2, 1
while2:
	bge	$s1, $s2, endw2
	move	$a0, $s1
	move	$a1, $s2
	jal	exchange
	move	$s1, $a0
	move	$s2, $a1
	j	while
endw2:
	move	$v0, $s0
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	addu	$sp, $sp, 16
	jr	$ra
	
exchange:
	move	$v1, $a0
	move	$v0, $a1
	jr	$ra
	