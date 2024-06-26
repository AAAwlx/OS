#include <AOS/stdio.h>
#include <AOS/printk.h>
#include <AOS/efi.h>
#include <AOS/types.h>
#include <AOS/kernel.h>
#include <asm/stdio.h>
#include <asm/print.h>
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

	fmt = printk_skip_level(fmt);

	va_start(args, fmt);
	printed = vsnprintf(printf_buf, sizeof(printf_buf), fmt, args);
	va_end(args);

	print_str(printf_buf);
	if (printed >= sizeof(printf_buf)) {
		print_str("[Message truncated]\n");
		return -1;
	}

	return printed;
}
