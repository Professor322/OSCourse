#ifndef JOS_KERN_VSYSCALL_H
#define JOS_KERN_VSYSCALL_H

extern volatile int *vsys;

void vsyscall_init(void);

#endif
