# char *itoa(unsigned int n, insigned int b, char *s)
itoa:
	subu	$sp, $sp, 28
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)	#digit
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	move	$s3, $a2
do_itoa:
	rem	$s4, $s0, $s1
	div	$s0, $s0, $s1
	move	$a0, $s4
	jal	toascii
	move	$v0, $s4
	sb	$s4, 0($s3)
	addi	$s3, $s3, 1
while_itoa:
	ble	$s0, 0x00, end_do_it
	j	do_itoa
end_do_it:
	sb	$0, 0($s3)
	move	$a0, $s2
	jal	strrev
	subu	$sp, $sp, 28
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)	#digit
	addu	$sp, $sp, 28
	jr	$ra
	
# char toascii(char)
toascii:
	addi	$a0, $a0, '0'
	ble	$a0, '9', end_ta
	addi	$a0, $a0, 7
end:
	move 	$v0, $a0
	jr	$ra
	
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
	lb	$a0, 0($s1)
	lb	$a1, 0($s2)
	jal	exchange
	sb	$v0, 0($s1)
	sb	$v1, 0($s2)
	addi	$s1, $s1, 1
	subi	$s2, $s2, 1
	j	while2
endw2:
	move	$v0, $s0
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	addu	$sp, $sp, 16
	jr	$ra
	
exchange:
	move	$v0, $a1
	move 	$v1, $a0
	jr	$ra
	
	
	