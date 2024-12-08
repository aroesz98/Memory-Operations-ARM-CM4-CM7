# ARM Cortex M4/M7 optimized memory operations

## Implementation Description:
This assembly code implements optimized versions of the `memcmp`, `memset`, and `memcpy` functions for the ARM architecture, utilizing the ARMv7-M architecture with VFPv2 floating-point support. It's applicable for Cortex M4 and Cortex M7 MCU's. These functions are commonly used for memory comparison, setting, and copying, respectively, and the use of VFP instructions enhances performance.

## Functionality and Function Descriptions:

1. **`memcmp_vfp`:**
   - **Purpose:** Compares two blocks of memory.
   - **Registers:**
     - `r0`: Pointer to the first memory block.
     - `r1`: Pointer to the second memory block.
     - `r2`: Number of bytes to compare.
   - **Operation:**
     - If `r2` (size) is zero, returns 0 indicating the blocks are equal.
     - Compares memory in 4-byte chunks using `ldr` and `subs` instructions.
     - Falls back to comparing 1-byte chunks if less than 4 bytes remain.
     - If any mismatch is found, returns -1; otherwise, returns 0.

2. **`memset_vfp`:**
   - **Purpose:** Fills a block of memory with a specified value.
   - **Registers:**
     - `r0`: Pointer to the memory block.
     - `r1`: Value to be set.
     - `r2`: Number of bytes to set.
   - **Operation:**
     - If `r2` (size) is zero, terminates the function.
     - Prepares the `d0` register with the value to be set using `bfi` and `vmov` instructions.
     - Sets memory in 32-byte chunks using `vstr` instructions.
     - Falls back to setting 8-byte, 4-byte, and 1-byte chunks as the size decreases.
     - Returns to the caller using `bx lr`.

3. **`memcpy_vfp`:**
   - **Purpose:** Copies a block of memory from a source to a destination.
   - **Registers:**
     - `r0`: Pointer to the destination memory block.
     - `r1`: Pointer to the source memory block.
     - `r2`: Number of bytes to copy.
   - **Operation:**
     - If `r2` (size) is zero, terminates the function.
     - Copies memory in 128-byte chunks using `vldr` and `vstr` instructions.
     - Falls back to copying 32-byte, 8-byte, 4-byte, and 1-byte chunks as the size decreases.
     - Returns the address of the destination buffer using `mov` and `bx lr`.

## Detailed Function Operations:

1. **`memcmp_vfp`:**
   - **Start:** Checks if `r2` is zero and jumps to `_cmp_good` if true. Otherwise, compares memory in 4-byte chunks.
   - **4-Byte Comparison Loop (`_cmp4`):** Loads and compares 4 bytes from each memory block. If they are not equal, jumps to `_cmp_err`. Otherwise, decrements `r2` and repeats until less than 4 bytes remain.
   - **1-Byte Comparison Loop (`_cmp1`):** Loads and compares 1 byte from each memory block. If they are not equal, jumps to `_cmp_err`. Otherwise, decrements `r2` and repeats until no bytes remain.
   - **End:** If all comparisons are successful, moves 0 into `r0` and returns. If any comparison fails, moves -1 into `r0` and returns.

2. **`memset_vfp`:**
   - **Start:** Checks if `r2` is zero and jumps to `stop` if true. Prepares the `d0` register with the value to be set.
   - **32-Byte Setting Loop (`set32`):** Sets 32 bytes of memory at a time using `vstr` instructions. Adjusts `r0` and `r2` accordingly and repeats until less than 32 bytes remain.
   - **8-Byte Setting Loop (`set8`):** Sets 8 bytes of memory at a time using `vstr` instructions. Adjusts `r0` and `r2` accordingly and repeats until less than 8 bytes remain.
   - **4-Byte Setting Loop (`set4`):** Sets 4 bytes of memory at a time using `str` instructions. Adjusts `r0` and `r2` accordingly and repeats until less than 4 bytes remain.
   - **1-Byte Setting Loop (`set1`):** Sets 1 byte of memory at a time using `strb` instructions. Adjusts `r0` and `r2` accordingly and repeats until no bytes remain.
   - **End:** Restores the original values of `d0` and `r1` from the stack and returns to the caller using `bx lr`.

3. **`memcpy_vfp`:**
   - **Start:** Checks if `r2` is zero and jumps to `stop` if true. Pushes the source pointer onto the stack and prepares the `d0` register.
   - **128-Byte Copy Loop (`copy128`):** Copies 128 bytes of memory at a time using `vldr` and `vstr` instructions. Adjusts `r0`, `r1`, and `r2` accordingly and repeats until less than 128 bytes remain.
   - **32-Byte Copy Loop (`copy32`):** Copies 32 bytes of memory at a time using `ldr` and `str` instructions. Adjusts `r0`, `r1`, and `r2` accordingly and repeats until less than 32 bytes remain.
   - **8-Byte Copy Loop (`copy8`):** Copies 8 bytes of memory at a time using `ldr` and `str` instructions. Adjusts `r0`, `r1`, and `r2` accordingly and repeats until less than 8 bytes remain.
   - **4-Byte Copy Loop (`copy4`):** Copies 4 bytes of memory at a time using `ldr` and `str` instructions. Adjusts `r0`, `r1`, and `r2` accordingly and repeats until less than 4 bytes remain.
   - **1-Byte Copy Loop (`copybytes`):** Copies 1 byte of memory at a time using `ldrb` and `strb` instructions. Adjusts `r0`, `r1`, and `r2` accordingly and repeats until no bytes remain.
   - **End:** Restores the original values of `d0` and `r1` from the stack, moves the address of the destination buffer into `r0`, and returns to the caller using `bx lr`.

*libmemory_operations_release_imxrt1050.a* memory statistics:
![image](https://github.com/aroesz98/Memory-Operations-ARM-CM4-CM7/assets/87637585/6410e2d3-7441-41bf-966d-b81cc10d5642)
