#ifndef _LINUX_KERNEL_H
#define _LINUX_KERNEL_H

#include <AOS/types.h>
#include <AOS/stdarg.h>

int vsnprintf(char *buf, size_t size, const char *fmt, va_list args);

#endif /* _LINUX_KERNEL_H */
