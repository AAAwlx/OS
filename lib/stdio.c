#include <asm/stdio.h>
#include <linux/printk.h>
#include <linux/efi.h>
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/ns16550a.h>

int printk(const char *fmt, ...)
{
	char printf_buf[256];
	va_list args;
	int printed;
	int loglevel = printk_get_level(fmt);

	switch (loglevel) {
	case '0' ... '9':
		loglevel -= '0';
		break;
	default:
		loglevel = -1;
		break;
	}

	// if (loglevel >= efi_loglevel)
	// 	return 0;

	// if (loglevel >= 0)
	// 	efi_puts("EFI stub: ");
	
	fmt = printk_skip_level(fmt);

	va_start(args, fmt);
	printed = vsnprintf(printf_buf, sizeof(printf_buf), fmt, args);
	va_end(args);

	serial_ns16550a_puts(printf_buf);
	if (printed >= sizeof(printf_buf)) {
		serial_ns16550a_puts("[Message truncated]\n");
		return -1;
	}

	return printed;
}
