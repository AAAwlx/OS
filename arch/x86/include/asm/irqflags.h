#ifndef _ASM_IRQFLAGS_H
#define _ASM_IRQFLAGS_H

static inline unsigned long native_save_fl(void)
{
	unsigned long flags;

	/*
	 * "=rm" is safe here, because "pop" adjusts the stack before
	 * it evaluates its effective address -- this is part of the
	 * documented behavior of the "pop" instruction.
	 */
	asm volatile("# __raw_save_flags\n\t"
		     "pushf ; pop %0"
		     : "=rm" (flags)
		     : /* no input */
		     : "memory");

	return flags;
}

static inline void native_restore_fl(unsigned long flags)
{
	asm volatile("push %0 ; popf"
		     : /* no output */
		     :"g" (flags)
		     :"memory", "cc");
}

// 关闭本地CPU中断
static inline void native_irq_disable(void)
{
	asm volatile("cli": : :"memory");
}

// 打开本地CPU中断
static inline void native_irq_enable(void)
{
	asm volatile("sti": : :"memory");
}

static inline void native_safe_halt(void)
{
	asm volatile("sti; hlt": : :"memory");
}

static inline void native_halt(void)
{
	asm volatile("hlt": : :"memory");
}
// 关闭本地CPU中断
void arch_local_irq_disable(void)
{
	native_irq_disable();
}

// 打开本地CPU中断
void arch_local_irq_enable(void)
{
	native_irq_enable();
}

#endif