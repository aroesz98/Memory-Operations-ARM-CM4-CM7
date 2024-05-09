// MEMCMP implementation ARM optimized using FPU registers.
// This implementation breaks down comparing into several 2 blocks: 4 and 1 byte.
// Basically R0-R4 register are used.
// Author: Arkadiusz Szlanta

.syntax unified
.arch	armv7-m
.fpu	vfpv2

.text
.global     memcmp_vfp
.type       memcmp_vfp, %function
.align      4

memcmp_vfp:
    cbz     r2, _cmp_good                  // Nothing to copy. Don't play with me.
    cmp     r2, #3
    bhi     _cmp4
    b       _cmp1

_cmp4:
    ldr     r3, [r0], #4
    ldr     r4, [r1], #4
    subs    r2, r2, #4
    cmp     r3, r4
    bne     _cmp_err
    cbz     r2, _cmp_good
    cmp     r2, #3
    bhi     _cmp4
    b       _cmp1

_cmp1:
    ldrb    r3, [r0], #1
    ldrb    r4, [r1], #1
    subs    r2, r2, #1
    cmp     r3, r4
    bne     _cmp_err
    cbz     r2, _cmp_good
    b       _cmp1

_cmp_good:
    mov     r0, #0
    bx      lr

_cmp_err:
    mvn     r0, #0
    bx      lr

.size	memcmp_vfp, . - memcmp_vfp
