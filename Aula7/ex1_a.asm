#Mapa de registos
# res:		$v0
# s:		$a0
# *s:		$t0
#digit:		$t1

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
	