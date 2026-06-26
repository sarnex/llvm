//===-- MSVC-compat additions to llvm-libc's <malloc.h> for sycl-jit ------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// On a Windows-MSVC target some bundled headers (e.g. clang's <mm_malloc.h>)
// expect MSVC's `_aligned_malloc`/`_aligned_free`, which llvm-libc does not
// declare. This shim sits ahead of llvm-libc's <malloc.h> on the include path,
// pulls it in via #include_next, and adds only the MSVC spellings. Device code
// never links these; the declarations only need to exist for name lookup.
//
//===----------------------------------------------------------------------===//

#ifndef _SYCL_JIT_MSVC_MALLOC_H
#define _SYCL_JIT_MSVC_MALLOC_H

#include_next <malloc.h>

#ifdef __cplusplus
extern "C" {
#endif

void *_aligned_malloc(__SIZE_TYPE__ __size, __SIZE_TYPE__ __alignment);
void _aligned_free(void *__ptr);

#ifdef __cplusplus
}
#endif

#endif // _SYCL_JIT_MSVC_MALLOC_H
