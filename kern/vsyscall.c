#include <inc/vsyscall.h>
#include <kern/vsyscall.h>
#include <kern/vga.h>

void vsyscall_init(void) {
    vsys[VSYS_getframebuffer_width] = context.width;
    vsys[VSYS_getframebuffer_height] = context.height;
    vsys[VSYS_getframebuffer_bpp] = context.bits_per_pixel;
}
