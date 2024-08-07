#ifndef _ASM_GENERIC_SECTIONS_H_
#define _ASM_GENERIC_SECTIONS_H_

#include <AOS/compiler.h>


extern char __brk_base[], __brk_limit[];
extern char _etext[];
extern char __bss_start[], __bss_stop[];
extern char __init_begin[], __init_end[];
extern char _sinittext[], _einittext[];

extern char per_cpu_var_start[], per_cpu_var_end[];

#ifndef arch_is_kernel_text
static inline int arch_is_kernel_text(unsigned long addr)
{
	return 0;
}
#endif

#endif /* _ASM_GENERIC_SECTIONS_H_ */
