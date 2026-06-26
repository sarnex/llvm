//===-- MSVC-compat additions to llvm-libc's <sys/stat.h> for sycl-jit ----===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// SYCL's <sycl/detail/os_util.hpp> (host utility code, pulled into the device
// translation unit) uses MSVC's `struct _stat`/`_stat()` under _WIN32. These
// are not part of llvm-libc, so provide them here. Sits ahead of llvm-libc's
// <sys/stat.h> on the include path and pulls it in via #include_next. Device
// code never calls these; the declarations only satisfy name lookup.
//
//===----------------------------------------------------------------------===//

#ifndef _SYCL_JIT_MSVC_SYS_STAT_H
#define _SYCL_JIT_MSVC_SYS_STAT_H

#include_next <sys/stat.h>

// MSVC's _stat spelling (see <sys/stat.h> in the MS UCRT). Field names are
// deliberately opaque: device code never reads them, and llvm-libc's POSIX
// <sys/stat.h> #defines st_atime/st_mtime/st_ctime as macros, which would
// otherwise clash with member names here.
struct _stat {
  unsigned int __dev;
  unsigned short __ino;
  unsigned short __mode;
  short __nlink;
  short __uid;
  short __gid;
  unsigned int __rdev;
  long long __size;
  long long __atime;
  long long __mtime;
  long long __ctime;
};

#ifdef __cplusplus
extern "C" {
#endif

int _stat(const char *__path, struct _stat *__buf);

#ifdef __cplusplus
}
#endif

#endif // _SYCL_JIT_MSVC_SYS_STAT_H
