#strlen
strlen:
	li	$t1, 0x00
while:
	lb	$t0, 0($a0)
	addiu	$a0, $a0, 1
	bne	$t0, '\0', endw
	addi	$t1, $t1, 1
	j	while
endw:
	move	$v0, $t1
	jr	$ra
	
