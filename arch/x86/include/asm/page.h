#ifndef _ASM_PAGE_H
#define _ASM_PAGE_H


#include <AOS/align.h>

#define PAGE_SHIFT	12
#define PAGE_SIZE	(1UL << PAGE_SHIFT)
#define THREAD_ORDER	1
#define THREAD_SIZE  8192
#define PAGE_MASK	(~(PAGE_SIZE - 1))

#define MEM_BITMAP_BASE 0x90000UL
#define START_FRAME 0x200000UL

/*低 128 MB 位图*/
#define MEMORY_SIZE 0x8000000
#define NR_PAGE (MEMORY_SIZE >> 12)

/*4kb 页前提*/
#define RESERVED_PHY_POOL_BASE 0x2000UL
#define USR_PHY_POOL_BASE 0x3000UL

#define PMD_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT - 3))
#define PMD_SIZE	(1UL << PMD_SHIFT)
#define PMD_MASK	(~(PMD_SIZE-1))
#define PGDIR_SHIFT	(PMD_SHIFT + (PAGE_SHIFT - 3))

#define PGD_BASE_ADD 0x9000000000010000

/*将给定的值x按页对齐*/
#define PFN_ALIGN(x)	(((unsigned long)(x) + (PAGE_SIZE - 1)) & PAGE_MASK)
/*将给定的值x向上舍入到下一个页面的起始位置*/
#define PFN_UP(x)	(((x) + PAGE_SIZE-1) >> PAGE_SHIFT)
/*将给定的值x向下舍入到当前页面的起始位置*/
#define PFN_DOWN(x)	((x) >> PAGE_SHIFT)
/*将给定的PFN转换为物理地址*/
#define PFN_PHYS(x)	((phys_addr_t)(x) << PAGE_SHIFT)
/*将给定的物理地址转换为PFN*/
#define PHYS_PFN(x)	((unsigned long)((x) >> PAGE_SHIFT))

#define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)

#define __va(x)		((void *)((unsigned long)(x) + CACHE_BASE))
#define pfn_to_page(pfn) ((void *)((pfn) * PAGE_SIZE))

#define PAGE_ATTR_P     (1 << 0)
#define PAGE_ATTR_RW    (1 << 1)
#define PAGE_ATTR_PS    (1 << 7)

//void phy_pool_init(void);
//void paging_init(void);



#endif /* _ASM_PAGE_H */
