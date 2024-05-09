// MEMSET implementation ARM optimized using FPU registers.
// This implementation breaks down set value into several blocks: 32, 8, 4, and 1 byte.
// Using the FPU allows us to set 8 bytes at a time using special register D0 from FPU co-processor.
// Basically only R0-R3, D0 are used. Using more than 1 register of FPU doesn't make any sense because of the small performance gains(probably due to pipelining).
// Author: Arkadiusz Szlanta

.syntax unified
.arch	armv7-m
.fpu	vfpv2

.text
.global     memset_vfp
.type       memset_vfp, %function
.align      4

memset_vfp:
    cbz     r2, stop                  // Nothing to copy. Don't play with me.
    push    {r1}
    vpush   {d0}
    bfi     r3, r1, #0, #8
    bfi     r3, r1, #8, #8
    bfi     r3, r1, #16, #8
    bfi     r3, r1, #24, #8
    vmov    s0, r3
    vmov    s1, r3
	cmp     r2, #31
	bhi		set32
    cmp     r2, #7
	bhi		set8
    cmp     r2, #3
    bhi     set4
    b       set1

set32:
    vstr    d0, [r0]
    vstr    d0, [r0, #8]
    vstr    d0, [r0, #16]
    vstr    d0, [r0, #24]
    add     r0, r0, #32
	subs    r2, r2, #32
    cmp     r2, #31
	bhi     set32
    cbz     r2, stop
    cmp     r2, #7
    bhi     set8
    cmp     r2, #3
    bhi     set4
    b       set1

set8:
    vstr    d0, [r0]
    add     r0, r0, #8
	subs    r2, r2, #8
    cmp     r2, #7
    bhi     set8
    cbz     r2, stop
    cmp     r2, #3
    bhi     set4
    b       set1

set4:
	str     r3, [r0], #4
	subs    r2, r2, #4
    cmp     r2, #3
    bhi     set4
    cbz     r2, stop
	b       set1

set1:
	strb    r3, [r0], #1
	subs    r2, r2, #1
    cbz     r2, stop
    b       set1

stop:
    vpop    {d0}
    pop     {r1}
    bx      lr

.size	memset_vfp, . - memset_vfp
