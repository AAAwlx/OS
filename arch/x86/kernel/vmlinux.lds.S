#include <asm-generic/vmlinux.lds.h>
#include <asm/asm-offsets.h>
#include <asm/thread_info.h>
#include <asm/page_types.h>
#include <asm/cache.h>
#include <AOS/init.h>
#include <asm/boot.h>
#undef i386     /* in case the preprocessor is a 32bit one */

#define THREAD_ORDER	1
#define PAGE_SIZE 4096
#define THREAD_SIZE 	(PAGE_SIZE << THREAD_ORDER)
OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)/*指定输出格式*/

OUTPUT_ARCH(i386:x86-64)
ENTRY(startup_64)

#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)

#define X64_ALIGN_DEBUG_RODATA_BEGIN	. = ALIGN(HPAGE_SIZE);

#define X64_ALIGN_DEBUG_RODATA_END				\
		. = ALIGN(HPAGE_SIZE);				\
		__end_rodata_hpage_align = .;

#else

#define X64_ALIGN_DEBUG_RODATA_BEGIN
#define X64_ALIGN_DEBUG_RODATA_END

#endif
/*设置程序表头*/
PHDRS {
	text PT_LOAD FLAGS(5);          /*RX*/
	data PT_LOAD FLAGS(6);          /* RWE */
	user PT_LOAD FLAGS(5);          /* R_E */
	init PT_LOAD FLAGS(7);          /* RWE */
	note PT_NOTE FLAGS(4);          /* ___ */
}

SECTIONS
{
	. = 1M;
	__boot_start = .;

	/* ASM boot-state kernel */

    .boot.loader :
	{
		KEEP(*(.boot.header))
		*(.boot.*)
		arch/x86/kernel/head_64.o
	}

	. = ALIGN(4096);

	/* C boot-state kernel */

	.boot.text ALIGN(4096) :
	{
		arch/x86/kernel/head_64.o(.text)
	}

	. = ALIGN(4096);

	.boot.rodata ALIGN(4096) :
	{
		arch/x86/kernel/head_64.o(.rodata)
	}

	. = ALIGN(4096);

	.boot.data ALIGN(4096) :
	{
		arch/x86/kernel/head_64.o(.data)
		arch/x86/kernel/head_64.o(.*)
	}

	. = ALIGN(4096);

	__boot_end = .;

    . = (0xffffffff80000000)+((0x1000000 + (0x1000000 - 1)) & ~(0x1000000 - 1));
        phys_startup_64 = startup_64 - LOAD_OFFSET;

	.text :  AT(ADDR(.text) - LOAD_OFFSET) {
		_text = .;
		HEAD_TEXT
		. = ALIGN(8);
		_stext = .;
		TEXT_TEXT
		SCHED_TEXT
		LOCK_TEXT
		KPROBES_TEXT
		IRQENTRY_TEXT
		*(.fixup)
		*(.gnu.warning)
		/* End of text section */
		_etext = .;
	} :text = 0x9090

	NOTES :text :note

	EXCEPTION_TABLE(16) :text = 0x9090

	X64_ALIGN_DEBUG_RODATA_BEGIN
	RO_DATA(PAGE_SIZE)
	X64_ALIGN_DEBUG_RODATA_END

	/* Data */
	.data : AT(ADDR(.data) - LOAD_OFFSET) {
		/* Start of data section */
		_sdata = .;

		/* init_task */
		INIT_TASK_DATA(THREAD_SIZE)

		PAGE_ALIGNED_DATA(PAGE_SIZE)

		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)

		DATA_DATA
		CONSTRUCTORS

		/* rarely changed data like cpu maps */
		READ_MOSTLY_DATA(INTERNODE_CACHE_BYTES)

		/* End of data section */
		_edata = .;
	} :data

	/* Init code and data - will be freed after init */
	. = ALIGN(PAGE_SIZE);
	.init.begin : AT(ADDR(.init.begin) - LOAD_OFFSET) {
		__init_begin = .; /* paired with __init_end */
	}

#ifdef CONFIG_X86_64
	:init
#endif

#define CONFIG_X86_L1_CACHE_SHIFT 6

	INIT_DATA_SECTION(16)

	.x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
		__x86_cpu_dev_start = .;
		*(.x86_cpu_dev.init)
		__x86_cpu_dev_end = .;
	}

	. = ALIGN(8);
	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
		__parainstructions = .;
		*(.parainstructions)
		__parainstructions_end = .;
	}

	/*
	 * .exit.text is discard at runtime, not link time, to deal with
	 *  references from .altinstructions and .eh_frame
	 */
	.exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
		EXIT_TEXT
	}

	.exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
		EXIT_DATA
	}

#if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
	PERCPU(PAGE_SIZE)
#endif

	. = ALIGN(PAGE_SIZE);

	/* freed after init ends here */
	.init.end : AT(ADDR(.init.end) - LOAD_OFFSET) {
		__init_end = .;
	}

	/*
	 * smp_locks might be freed after init
	 * start/end must be page aligned
	 */
	. = ALIGN(PAGE_SIZE);
	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
		__smp_locks = .;
		*(.smp_locks)
		. = ALIGN(PAGE_SIZE);
		__smp_locks_end = .;
	}

#ifdef CONFIG_X86_64
	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
		NOSAVE_DATA
	}
#endif

	/* BSS */
	. = ALIGN(PAGE_SIZE);
	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
		__bss_start = .;
		*(.bss.page_aligned)
		*(.bss)
		. = ALIGN(4);
		__bss_stop = .;
	}

	. = ALIGN(PAGE_SIZE);
	.brk : AT(ADDR(.brk) - LOAD_OFFSET) {
		__brk_base = .;
		. += 64 * 1024;		/* 64k alignment slop space */
		*(.brk_reservation)	/* areas brk users have reserved */
		__brk_limit = .;
	}

	_end = .;

}




