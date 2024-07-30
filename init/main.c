#include <AOS/printk.h>
#include <AOS/task.h>
#include <AOS/init.h>
#include <AOS/ns16550a.h>
#include <AOS/types.h>
#include <asm/stdio.h>
#include <AOS/smp.h>
#include <AOS/irqflags.h>
extern void start_kernel(void);

bool early_boot_irqs_disabled;

void start_kernel(void)
{
	char str[] = "AAAOS";
	int cpu = smp_processor_id();
	printk("%s %s-%d.%d.%d\n", "hello", str, 0, 0, 1);

	local_irq_disable();
	early_boot_irqs_disabled = true;

	/**
	 * 禁止中断，进行必要的设置后开启
	 */
	
	printk("cpu = %d\n", cpu);

	while(1);
}
