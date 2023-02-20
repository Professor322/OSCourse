#include <inc/vsyscall.h>
#include <inc/lib.h>

static inline uint64_t
vsyscall(int num) {
    // LAB 12: Your code here
    return vsys[num];
}

int
vsys_gettime(void) {
    return vsyscall(VSYS_gettime);
}

uint32_t vsys_getframebuffer_width(void) {
    return vsyscall(VSYS_getframebuffer_width);
}
uint32_t vsys_getframebuffer_height(void) {
    return vsyscall(VSYS_getframebuffer_height);

}
uint32_t vsys_getframebuffer_bpp(void) {
    return vsyscall(VSYS_getframebuffer_bpp);
}
