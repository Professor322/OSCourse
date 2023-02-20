#ifndef JOS_INC_VSYSCALL_H
#define JOS_INC_VSYSCALL_H

/* system call numbers */
enum {
    VSYS_gettime,
    VSYS_getframebuffer_width,
    VSYS_getframebuffer_height,
    VSYS_getframebuffer_bpp,
    VSYS_getframebuffer_size,
    NVSYSCALLS
};

#endif /* !JOS_INC_VSYSCALL_H */
