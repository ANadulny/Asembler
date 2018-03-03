# fib-- (callee-save method) 
# Registers used: 
# $a0 - initially n. 
# $s0 - parameter n. 
# $s1 - fib (n - 1). 
# $s2 - fib (n - 2). 
	.text
fib:
	subu	$sp, $sp, 32
	sw	$ra, 28($sp)
	sw 	$fp, 24($sp) 
	sw 	$s0, 20($sp) 
	sw 	$s1, 16($sp)
	sw 	$s2, 12($sp) 
	addu 	$fp, $sp, 32 
	
	move 	$s0, $a0 # get n from caller.
	blt 	$s0, 2, fib_base_case # if n < 2, then do base case.
	sub 	$a0, $s0, 1 # compute fib (n - 1) 
	jal 	fib  
	move 	$s1, $v0 # s1 = fib (n - 1).
	sub 	$a0, $s0, 2 # compute fib (n - 2) 
	jal 	fib 
	move 	$s2, $v0 # $s2 = fib (n - 2).
	add 	$v0, $s1, $s2 # $v0 = fib (n - 1) + fib (n - 2). 
	b fib_return
fib_base_case: # in the base case, return 1. 
	li 	$v0, 1
fib_return: 
	lw 	$ra, 28($sp) # restore the Return Address. 
	lw 	$fp, 24($sp) # restore the Frame Pointer. 
	lw 	$s0, 20($sp) # restore $s0. 
	lw	$s1, 16($sp) # restore $s1. 
	lw 	$s2, 12($sp) # restore $s2. 
	addu 	$sp, $sp, 32 # restore the Stack Pointer. 
	jr 	$ra # return.
