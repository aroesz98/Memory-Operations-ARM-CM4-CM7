# Memory-Operations-ARM-CM4-CM7
ARM Cortex M4/M7 optimized memory operations

This library contains optimized version of memcpy, memset and memcmp using FPU registers. It is applicable for Cortex M4 and Cortex M7 MCU's.
Will upload benchmark results soon but those functions are about 6 up to 10 times than implementation from STL library(NewLibNano).

libmemory_operations_release_imxrt1050.a memory statistics:

   text    data     bss     dec     hex filename
     60       0       0      60      3c memcmp_vfp.s.obj (ex libmemory_operations_release.a)
    356       0       0     356     164 memcpy_vfp.s.obj (ex libmemory_operations_release.a)
    140       0       0     140      8c memset_vfp.s.obj (ex libmemory_operations_release.a)
