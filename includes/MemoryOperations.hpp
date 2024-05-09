#ifndef MEMORY_OPERATIONS_HPP
#define MEMORY_OPERATIONS_HPP

#include "stdint.h"

namespace MemoryOperations
{
    extern "C" {
        int  memcmp_vfp(void *s0, void *s1, uint32_t len);
        void memcpy_vfp(void *dst, void *src, uint32_t len);
        void memset_vfp(void *dst, uint8_t val, uint32_t len);
    }
}

#endif