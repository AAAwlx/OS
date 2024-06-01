/*
 * Generate definitions needed by assembly language modules.
 * This code generates raw asm output which is post-processed to extract
 * and format the required data.
 */
#define COMPILE_OFFSETS

#include <linux/compiler.h>
#include <linux/kbuild.h>

#define __NO_STUBS 1
#undef __SYSCALL
#undef _ASM_X86_UNISTD_64_H
#define __SYSCALL(nr, sym) [nr] = 1,
static char syscalls[] = {
//#include <asm/unistd.h>
};

int main(void)
{
	BLANK();
	DEFINE(PAGE_SZ, 4096);
	BLANK();
	return 0;
}
