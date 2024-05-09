// Memcpy implementation ARM optimized using FPU registers.
// This implementation breaks down copying into several blocks: 128, 32, 4, and 1 byte.
// Using the FPU allows us to copy 8 bytes at a time using special register from D0 from FPU co-processor.
// Basically only R0-R3, D0 are used. Using more than 1 register of FPU doesn't make any sense because of the small performance gains(probably due to pipelining).
// Author: Arkadiusz Szlanta

.syntax unified
.arch	armv7-m
.fpu	vfpv2

.text
.global     memcpy_vfp
.type       memcpy_vfp, %function
.align      4

memcpy_vfp:
    cmp     r2, #0                  // Nothing to copy. Don't play with me.
    beq     stop

    // Push D0 on the stack. ARM registers r0-r3 do not require that as they are temporary.
    push    {r1}
    vpush   {d0}
    cmp     r2, #127
	bhi		copy128
	cmp     r2, #31
	bhi		copy32
    cmp     r2, #7
	bhi		copy8
    cmp     r2, #3
    bhi     copy4
    bls     copybytes

copy128:
    vldr    d0, [r1]
    vstr    d0, [r0]
    vldr    d0, [r1, #8]
    vstr    d0, [r0, #8]
    vldr    d0, [r1, #16]
    vstr    d0, [r0, #16]
    vldr    d0, [r1, #24]
    vstr    d0, [r0, #24]
    vldr    d0, [r1, #32]
    vstr    d0, [r0, #32]
    vldr    d0, [r1, #40]
    vstr    d0, [r0, #40]
    vldr    d0, [r1, #48]
    vstr    d0, [r0, #48]
    vldr    d0, [r1, #56]
    vstr    d0, [r0, #56]
    vldr    d0, [r1, #64]
    vstr    d0, [r0, #64]
    vldr    d0, [r1, #72]
    vstr    d0, [r0, #72]
    vldr    d0, [r1, #80]
    vstr    d0, [r0, #80]
    vldr    d0, [r1, #88]
    vstr    d0, [r0, #88]
    vldr    d0, [r1, #96]
    vstr    d0, [r0, #96]
    vldr    d0, [r1, #104]
    vstr    d0, [r0, #104]
    vldr    d0, [r1, #112]
    vstr    d0, [r0, #112]
    vldr    d0, [r1, #120]
    vstr    d0, [r0, #120]
    add     r1, r1, #128
    add     r0, r0, #128
	subs    r2, r2, #128
    cmp     r2, #127
	bhi     copy128
    cmp     r2, #0
    beq     stop
	cmp     r2, #31
    bhi     copy32
    cmp     r2, #7
    bhi     copy8
    cmp     r2, #3
    bhi     copy4
    b       copybytes

copy32:
    ldr     r3, [r1], #4
	str     r3, [r0], #4
    ldr     r3, [r1], #4
	str     r3, [r0], #4
    ldr     r3, [r1], #4
	str     r3, [r0], #4
    ldr     r3, [r1], #4
	str     r3, [r0], #4
    ldr     r3, [r1], #4
	str     r3, [r0], #4
    ldr     r3, [r1], #4
	str     r3, [r0], #4
    ldr     r3, [r1], #4
	str     r3, [r0], #4
    ldr     r3, [r1], #4
	str     r3, [r0], #4
	subs    r2, r2, #32
    cmp     r2, #31
	bhi     copy32
    cmp     r2, #0
    beq     stop
    cmp     r2, #7
    bhi     copy8
    cmp     r2, #3
    bhi     copy4
    b       copybytes

copy8:
    ldr     r3, [r1], #4
	str     r3, [r0], #4
    ldr     r3, [r1], #4
	str     r3, [r0], #4
	subs    r2, r2, #8
    cmp     r2, #7
    bhi     copy8
    cmp     r2, #0
    beq     stop
    cmp     r2, #3
    bhi     copy4
    b       copybytes

copy4:
	ldr     r3, [r1], #4
	str     r3, [r0], #4
	subs    r2, r2, #4
    cmp     r2, #3
    bhi     copy4
    cmp     r2, #0
    beq     stop
	b       copybytes

copybytes:
    ldrb    r3, [r1], #1
	strb    r3, [r0], #1
	subs    r2, r2, #1
    cmp     r2, #0
	bne     copybytes
    b       stop

stop:
    vpop    {d0}
    pop     {r1}

    // Return address of destination buffer
    mov     r0, r1
    bx      lr

.size	memcpy_vfp, . - memcpy_vfp

