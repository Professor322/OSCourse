
obj/user/buggyhello2:     file format elf64-x86-64


Disassembly of section .text:

0000000000800000 <__text_start>:
.globl _start
_start:
    # See if we were started with arguments on the stack

#ifndef CONFIG_KSPACE
    movabs $USER_STACK_TOP, %rax
  800000:	48 b8 00 70 ff ff 7f 	movabs $0x7fffff7000,%rax
  800007:	00 00 00 
    cmpq %rax, %rsp
  80000a:	48 39 c4             	cmp    %rax,%rsp
    jne args_exist
  80000d:	75 04                	jne    800013 <args_exist>

    # If not, push dummy argc/argv arguments.
    # This happens when we are loaded by the kernel,
    # because the kernel does not know about passing arguments.
    # Marking argc and argv as zero.
    pushq $0
  80000f:	6a 00                	push   $0x0
    pushq $0
  800011:	6a 00                	push   $0x0

0000000000800013 <args_exist>:

args_exist:
    movq 8(%rsp), %rsi
  800013:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
    movq (%rsp), %rdi
  800018:	48 8b 3c 24          	mov    (%rsp),%rdi
    xorl %ebp, %ebp
  80001c:	31 ed                	xor    %ebp,%ebp
    call libmain
  80001e:	e8 26 00 00 00       	call   800049 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

const char *hello = "hello, world\n";

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
    sys_cputs(hello, 1024 * 1024);
  800029:	be 00 00 10 00       	mov    $0x100000,%esi
  80002e:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800035:	00 00 00 
  800038:	48 8b 38             	mov    (%rax),%rdi
  80003b:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  800042:	00 00 00 
  800045:	ff d0                	call   *%rax
}
  800047:	5d                   	pop    %rbp
  800048:	c3                   	ret    

0000000000800049 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800049:	55                   	push   %rbp
  80004a:	48 89 e5             	mov    %rsp,%rbp
  80004d:	41 56                	push   %r14
  80004f:	41 55                	push   %r13
  800051:	41 54                	push   %r12
  800053:	53                   	push   %rbx
  800054:	41 89 fd             	mov    %edi,%r13d
  800057:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80005a:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800061:	00 00 00 
  800064:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80006b:	00 00 00 
  80006e:	48 39 c2             	cmp    %rax,%rdx
  800071:	73 17                	jae    80008a <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800073:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800076:	49 89 c4             	mov    %rax,%r12
  800079:	48 83 c3 08          	add    $0x8,%rbx
  80007d:	b8 00 00 00 00       	mov    $0x0,%eax
  800082:	ff 53 f8             	call   *-0x8(%rbx)
  800085:	4c 39 e3             	cmp    %r12,%rbx
  800088:	72 ef                	jb     800079 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80008a:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  800091:	00 00 00 
  800094:	ff d0                	call   *%rax
  800096:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80009f:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000a3:	48 c1 e0 04          	shl    $0x4,%rax
  8000a7:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000ae:	00 00 00 
  8000b1:	48 01 d0             	add    %rdx,%rax
  8000b4:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000bb:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000be:	45 85 ed             	test   %r13d,%r13d
  8000c1:	7e 0d                	jle    8000d0 <libmain+0x87>
  8000c3:	49 8b 06             	mov    (%r14),%rax
  8000c6:	48 a3 08 40 80 00 00 	movabs %rax,0x804008
  8000cd:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000d0:	4c 89 f6             	mov    %r14,%rsi
  8000d3:	44 89 ef             	mov    %r13d,%edi
  8000d6:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000e2:	48 b8 f7 00 80 00 00 	movabs $0x8000f7,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	call   *%rax
#endif
}
  8000ee:	5b                   	pop    %rbx
  8000ef:	41 5c                	pop    %r12
  8000f1:	41 5d                	pop    %r13
  8000f3:	41 5e                	pop    %r14
  8000f5:	5d                   	pop    %rbp
  8000f6:	c3                   	ret    

00000000008000f7 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000f7:	55                   	push   %rbp
  8000f8:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000fb:	48 b8 33 08 80 00 00 	movabs $0x800833,%rax
  800102:	00 00 00 
  800105:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800107:	bf 00 00 00 00       	mov    $0x0,%edi
  80010c:	48 b8 78 01 80 00 00 	movabs $0x800178,%rax
  800113:	00 00 00 
  800116:	ff d0                	call   *%rax
}
  800118:	5d                   	pop    %rbp
  800119:	c3                   	ret    

000000000080011a <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80011a:	55                   	push   %rbp
  80011b:	48 89 e5             	mov    %rsp,%rbp
  80011e:	53                   	push   %rbx
  80011f:	48 89 fa             	mov    %rdi,%rdx
  800122:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800125:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80012a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80012f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800134:	be 00 00 00 00       	mov    $0x0,%esi
  800139:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80013f:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800141:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800145:	c9                   	leave  
  800146:	c3                   	ret    

0000000000800147 <sys_cgetc>:

int
sys_cgetc(void) {
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80014c:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800151:	ba 00 00 00 00       	mov    $0x0,%edx
  800156:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80015b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800160:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800165:	be 00 00 00 00       	mov    $0x0,%esi
  80016a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800170:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800172:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800176:	c9                   	leave  
  800177:	c3                   	ret    

0000000000800178 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800178:	55                   	push   %rbp
  800179:	48 89 e5             	mov    %rsp,%rbp
  80017c:	53                   	push   %rbx
  80017d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800181:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800184:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800189:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80018e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800193:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800198:	be 00 00 00 00       	mov    $0x0,%esi
  80019d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001a3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001a5:	48 85 c0             	test   %rax,%rax
  8001a8:	7f 06                	jg     8001b0 <sys_env_destroy+0x38>
}
  8001aa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001b0:	49 89 c0             	mov    %rax,%r8
  8001b3:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001b8:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  8001bf:	00 00 00 
  8001c2:	be 26 00 00 00       	mov    $0x26,%esi
  8001c7:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  8001ce:	00 00 00 
  8001d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d6:	49 b9 66 19 80 00 00 	movabs $0x801966,%r9
  8001dd:	00 00 00 
  8001e0:	41 ff d1             	call   *%r9

00000000008001e3 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
  8001e7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001e8:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8001f2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001fc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800201:	be 00 00 00 00       	mov    $0x0,%esi
  800206:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80020c:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80020e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800212:	c9                   	leave  
  800213:	c3                   	ret    

0000000000800214 <sys_yield>:

void
sys_yield(void) {
  800214:	55                   	push   %rbp
  800215:	48 89 e5             	mov    %rsp,%rbp
  800218:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800219:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80021e:	ba 00 00 00 00       	mov    $0x0,%edx
  800223:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800228:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800232:	be 00 00 00 00       	mov    $0x0,%esi
  800237:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80023d:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80023f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800243:	c9                   	leave  
  800244:	c3                   	ret    

0000000000800245 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  800245:	55                   	push   %rbp
  800246:	48 89 e5             	mov    %rsp,%rbp
  800249:	53                   	push   %rbx
  80024a:	48 89 fa             	mov    %rdi,%rdx
  80024d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800250:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800255:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80025c:	00 00 00 
  80025f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800264:	be 00 00 00 00       	mov    $0x0,%esi
  800269:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80026f:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800271:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800275:	c9                   	leave  
  800276:	c3                   	ret    

0000000000800277 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  800277:	55                   	push   %rbp
  800278:	48 89 e5             	mov    %rsp,%rbp
  80027b:	53                   	push   %rbx
  80027c:	49 89 f8             	mov    %rdi,%r8
  80027f:	48 89 d3             	mov    %rdx,%rbx
  800282:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  800285:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80028a:	4c 89 c2             	mov    %r8,%rdx
  80028d:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800290:	be 00 00 00 00       	mov    $0x0,%esi
  800295:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80029b:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80029d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002a1:	c9                   	leave  
  8002a2:	c3                   	ret    

00000000008002a3 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002a3:	55                   	push   %rbp
  8002a4:	48 89 e5             	mov    %rsp,%rbp
  8002a7:	53                   	push   %rbx
  8002a8:	48 83 ec 08          	sub    $0x8,%rsp
  8002ac:	89 f8                	mov    %edi,%eax
  8002ae:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002b1:	48 63 f9             	movslq %ecx,%rdi
  8002b4:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002b7:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002bc:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002ca:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002cc:	48 85 c0             	test   %rax,%rax
  8002cf:	7f 06                	jg     8002d7 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002d1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002d5:	c9                   	leave  
  8002d6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002d7:	49 89 c0             	mov    %rax,%r8
  8002da:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002df:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  8002e6:	00 00 00 
  8002e9:	be 26 00 00 00       	mov    $0x26,%esi
  8002ee:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  8002f5:	00 00 00 
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	49 b9 66 19 80 00 00 	movabs $0x801966,%r9
  800304:	00 00 00 
  800307:	41 ff d1             	call   *%r9

000000000080030a <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80030a:	55                   	push   %rbp
  80030b:	48 89 e5             	mov    %rsp,%rbp
  80030e:	53                   	push   %rbx
  80030f:	48 83 ec 08          	sub    $0x8,%rsp
  800313:	89 f8                	mov    %edi,%eax
  800315:	49 89 f2             	mov    %rsi,%r10
  800318:	48 89 cf             	mov    %rcx,%rdi
  80031b:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80031e:	48 63 da             	movslq %edx,%rbx
  800321:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800324:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800329:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80032c:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80032f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800331:	48 85 c0             	test   %rax,%rax
  800334:	7f 06                	jg     80033c <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  800336:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80033a:	c9                   	leave  
  80033b:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80033c:	49 89 c0             	mov    %rax,%r8
  80033f:	b9 05 00 00 00       	mov    $0x5,%ecx
  800344:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  80034b:	00 00 00 
  80034e:	be 26 00 00 00       	mov    $0x26,%esi
  800353:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  80035a:	00 00 00 
  80035d:	b8 00 00 00 00       	mov    $0x0,%eax
  800362:	49 b9 66 19 80 00 00 	movabs $0x801966,%r9
  800369:	00 00 00 
  80036c:	41 ff d1             	call   *%r9

000000000080036f <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80036f:	55                   	push   %rbp
  800370:	48 89 e5             	mov    %rsp,%rbp
  800373:	53                   	push   %rbx
  800374:	48 83 ec 08          	sub    $0x8,%rsp
  800378:	48 89 f1             	mov    %rsi,%rcx
  80037b:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80037e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800381:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800386:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80038b:	be 00 00 00 00       	mov    $0x0,%esi
  800390:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800396:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800398:	48 85 c0             	test   %rax,%rax
  80039b:	7f 06                	jg     8003a3 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80039d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003a3:	49 89 c0             	mov    %rax,%r8
  8003a6:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003ab:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  8003b2:	00 00 00 
  8003b5:	be 26 00 00 00       	mov    $0x26,%esi
  8003ba:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  8003c1:	00 00 00 
  8003c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c9:	49 b9 66 19 80 00 00 	movabs $0x801966,%r9
  8003d0:	00 00 00 
  8003d3:	41 ff d1             	call   *%r9

00000000008003d6 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8003d6:	55                   	push   %rbp
  8003d7:	48 89 e5             	mov    %rsp,%rbp
  8003da:	53                   	push   %rbx
  8003db:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8003df:	48 63 ce             	movslq %esi,%rcx
  8003e2:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8003e5:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8003ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003ef:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003f4:	be 00 00 00 00       	mov    $0x0,%esi
  8003f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003ff:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800401:	48 85 c0             	test   %rax,%rax
  800404:	7f 06                	jg     80040c <sys_env_set_status+0x36>
}
  800406:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80040a:	c9                   	leave  
  80040b:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80040c:	49 89 c0             	mov    %rax,%r8
  80040f:	b9 09 00 00 00       	mov    $0x9,%ecx
  800414:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  80041b:	00 00 00 
  80041e:	be 26 00 00 00       	mov    $0x26,%esi
  800423:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  80042a:	00 00 00 
  80042d:	b8 00 00 00 00       	mov    $0x0,%eax
  800432:	49 b9 66 19 80 00 00 	movabs $0x801966,%r9
  800439:	00 00 00 
  80043c:	41 ff d1             	call   *%r9

000000000080043f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80043f:	55                   	push   %rbp
  800440:	48 89 e5             	mov    %rsp,%rbp
  800443:	53                   	push   %rbx
  800444:	48 83 ec 08          	sub    $0x8,%rsp
  800448:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80044b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80044e:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800453:	bb 00 00 00 00       	mov    $0x0,%ebx
  800458:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80045d:	be 00 00 00 00       	mov    $0x0,%esi
  800462:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800468:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80046a:	48 85 c0             	test   %rax,%rax
  80046d:	7f 06                	jg     800475 <sys_env_set_trapframe+0x36>
}
  80046f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800473:	c9                   	leave  
  800474:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800475:	49 89 c0             	mov    %rax,%r8
  800478:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80047d:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  800484:	00 00 00 
  800487:	be 26 00 00 00       	mov    $0x26,%esi
  80048c:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  800493:	00 00 00 
  800496:	b8 00 00 00 00       	mov    $0x0,%eax
  80049b:	49 b9 66 19 80 00 00 	movabs $0x801966,%r9
  8004a2:	00 00 00 
  8004a5:	41 ff d1             	call   *%r9

00000000008004a8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8004a8:	55                   	push   %rbp
  8004a9:	48 89 e5             	mov    %rsp,%rbp
  8004ac:	53                   	push   %rbx
  8004ad:	48 83 ec 08          	sub    $0x8,%rsp
  8004b1:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8004b4:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004b7:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004c1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004c6:	be 00 00 00 00       	mov    $0x0,%esi
  8004cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004d1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004d3:	48 85 c0             	test   %rax,%rax
  8004d6:	7f 06                	jg     8004de <sys_env_set_pgfault_upcall+0x36>
}
  8004d8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004dc:	c9                   	leave  
  8004dd:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004de:	49 89 c0             	mov    %rax,%r8
  8004e1:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8004e6:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  8004ed:	00 00 00 
  8004f0:	be 26 00 00 00       	mov    $0x26,%esi
  8004f5:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  8004fc:	00 00 00 
  8004ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800504:	49 b9 66 19 80 00 00 	movabs $0x801966,%r9
  80050b:	00 00 00 
  80050e:	41 ff d1             	call   *%r9

0000000000800511 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  800511:	55                   	push   %rbp
  800512:	48 89 e5             	mov    %rsp,%rbp
  800515:	53                   	push   %rbx
  800516:	89 f8                	mov    %edi,%eax
  800518:	49 89 f1             	mov    %rsi,%r9
  80051b:	48 89 d3             	mov    %rdx,%rbx
  80051e:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  800521:	49 63 f0             	movslq %r8d,%rsi
  800524:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800527:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80052c:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80052f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800535:	cd 30                	int    $0x30
}
  800537:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80053b:	c9                   	leave  
  80053c:	c3                   	ret    

000000000080053d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80053d:	55                   	push   %rbp
  80053e:	48 89 e5             	mov    %rsp,%rbp
  800541:	53                   	push   %rbx
  800542:	48 83 ec 08          	sub    $0x8,%rsp
  800546:	48 89 fa             	mov    %rdi,%rdx
  800549:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80054c:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800551:	bb 00 00 00 00       	mov    $0x0,%ebx
  800556:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80055b:	be 00 00 00 00       	mov    $0x0,%esi
  800560:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800566:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800568:	48 85 c0             	test   %rax,%rax
  80056b:	7f 06                	jg     800573 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80056d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800571:	c9                   	leave  
  800572:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800573:	49 89 c0             	mov    %rax,%r8
  800576:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80057b:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  800582:	00 00 00 
  800585:	be 26 00 00 00       	mov    $0x26,%esi
  80058a:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  800591:	00 00 00 
  800594:	b8 00 00 00 00       	mov    $0x0,%eax
  800599:	49 b9 66 19 80 00 00 	movabs $0x801966,%r9
  8005a0:	00 00 00 
  8005a3:	41 ff d1             	call   *%r9

00000000008005a6 <sys_gettime>:

int
sys_gettime(void) {
  8005a6:	55                   	push   %rbp
  8005a7:	48 89 e5             	mov    %rsp,%rbp
  8005aa:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005ab:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005bf:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005c4:	be 00 00 00 00       	mov    $0x0,%esi
  8005c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005cf:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8005d1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005d5:	c9                   	leave  
  8005d6:	c3                   	ret    

00000000008005d7 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8005d7:	55                   	push   %rbp
  8005d8:	48 89 e5             	mov    %rsp,%rbp
  8005db:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005dc:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005f5:	be 00 00 00 00       	mov    $0x0,%esi
  8005fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800600:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  800602:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800606:	c9                   	leave  
  800607:	c3                   	ret    

0000000000800608 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800608:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80060f:	ff ff ff 
  800612:	48 01 f8             	add    %rdi,%rax
  800615:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800619:	c3                   	ret    

000000000080061a <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80061a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800621:	ff ff ff 
  800624:	48 01 f8             	add    %rdi,%rax
  800627:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80062b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800631:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800635:	c3                   	ret    

0000000000800636 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  800636:	55                   	push   %rbp
  800637:	48 89 e5             	mov    %rsp,%rbp
  80063a:	41 57                	push   %r15
  80063c:	41 56                	push   %r14
  80063e:	41 55                	push   %r13
  800640:	41 54                	push   %r12
  800642:	53                   	push   %rbx
  800643:	48 83 ec 08          	sub    $0x8,%rsp
  800647:	49 89 ff             	mov    %rdi,%r15
  80064a:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80064f:	49 bc e4 15 80 00 00 	movabs $0x8015e4,%r12
  800656:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  800659:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  80065f:	48 89 df             	mov    %rbx,%rdi
  800662:	41 ff d4             	call   *%r12
  800665:	83 e0 04             	and    $0x4,%eax
  800668:	74 1a                	je     800684 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  80066a:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  800671:	4c 39 f3             	cmp    %r14,%rbx
  800674:	75 e9                	jne    80065f <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  800676:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  80067d:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  800682:	eb 03                	jmp    800687 <fd_alloc+0x51>
            *fd_store = fd;
  800684:	49 89 1f             	mov    %rbx,(%r15)
}
  800687:	48 83 c4 08          	add    $0x8,%rsp
  80068b:	5b                   	pop    %rbx
  80068c:	41 5c                	pop    %r12
  80068e:	41 5d                	pop    %r13
  800690:	41 5e                	pop    %r14
  800692:	41 5f                	pop    %r15
  800694:	5d                   	pop    %rbp
  800695:	c3                   	ret    

0000000000800696 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  800696:	83 ff 1f             	cmp    $0x1f,%edi
  800699:	77 39                	ja     8006d4 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80069b:	55                   	push   %rbp
  80069c:	48 89 e5             	mov    %rsp,%rbp
  80069f:	41 54                	push   %r12
  8006a1:	53                   	push   %rbx
  8006a2:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8006a5:	48 63 df             	movslq %edi,%rbx
  8006a8:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8006af:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8006b3:	48 89 df             	mov    %rbx,%rdi
  8006b6:	48 b8 e4 15 80 00 00 	movabs $0x8015e4,%rax
  8006bd:	00 00 00 
  8006c0:	ff d0                	call   *%rax
  8006c2:	a8 04                	test   $0x4,%al
  8006c4:	74 14                	je     8006da <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8006c6:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8006ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006cf:	5b                   	pop    %rbx
  8006d0:	41 5c                	pop    %r12
  8006d2:	5d                   	pop    %rbp
  8006d3:	c3                   	ret    
        return -E_INVAL;
  8006d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006d9:	c3                   	ret    
        return -E_INVAL;
  8006da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006df:	eb ee                	jmp    8006cf <fd_lookup+0x39>

00000000008006e1 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8006e1:	55                   	push   %rbp
  8006e2:	48 89 e5             	mov    %rsp,%rbp
  8006e5:	53                   	push   %rbx
  8006e6:	48 83 ec 08          	sub    $0x8,%rsp
  8006ea:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8006ed:	48 ba a0 2a 80 00 00 	movabs $0x802aa0,%rdx
  8006f4:	00 00 00 
  8006f7:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8006fe:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800701:	39 38                	cmp    %edi,(%rax)
  800703:	74 4b                	je     800750 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  800705:	48 83 c2 08          	add    $0x8,%rdx
  800709:	48 8b 02             	mov    (%rdx),%rax
  80070c:	48 85 c0             	test   %rax,%rax
  80070f:	75 f0                	jne    800701 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800711:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800718:	00 00 00 
  80071b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800721:	89 fa                	mov    %edi,%edx
  800723:	48 bf 10 2a 80 00 00 	movabs $0x802a10,%rdi
  80072a:	00 00 00 
  80072d:	b8 00 00 00 00       	mov    $0x0,%eax
  800732:	48 b9 b6 1a 80 00 00 	movabs $0x801ab6,%rcx
  800739:	00 00 00 
  80073c:	ff d1                	call   *%rcx
    *dev = 0;
  80073e:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  800745:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80074a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80074e:	c9                   	leave  
  80074f:	c3                   	ret    
            *dev = devtab[i];
  800750:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  800753:	b8 00 00 00 00       	mov    $0x0,%eax
  800758:	eb f0                	jmp    80074a <dev_lookup+0x69>

000000000080075a <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80075a:	55                   	push   %rbp
  80075b:	48 89 e5             	mov    %rsp,%rbp
  80075e:	41 55                	push   %r13
  800760:	41 54                	push   %r12
  800762:	53                   	push   %rbx
  800763:	48 83 ec 18          	sub    $0x18,%rsp
  800767:	49 89 fc             	mov    %rdi,%r12
  80076a:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80076d:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  800774:	ff ff ff 
  800777:	4c 01 e7             	add    %r12,%rdi
  80077a:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80077e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800782:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  800789:	00 00 00 
  80078c:	ff d0                	call   *%rax
  80078e:	89 c3                	mov    %eax,%ebx
  800790:	85 c0                	test   %eax,%eax
  800792:	78 06                	js     80079a <fd_close+0x40>
  800794:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  800798:	74 18                	je     8007b2 <fd_close+0x58>
        return (must_exist ? res : 0);
  80079a:	45 84 ed             	test   %r13b,%r13b
  80079d:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a2:	0f 44 d8             	cmove  %eax,%ebx
}
  8007a5:	89 d8                	mov    %ebx,%eax
  8007a7:	48 83 c4 18          	add    $0x18,%rsp
  8007ab:	5b                   	pop    %rbx
  8007ac:	41 5c                	pop    %r12
  8007ae:	41 5d                	pop    %r13
  8007b0:	5d                   	pop    %rbp
  8007b1:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8007b2:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8007b6:	41 8b 3c 24          	mov    (%r12),%edi
  8007ba:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  8007c1:	00 00 00 
  8007c4:	ff d0                	call   *%rax
  8007c6:	89 c3                	mov    %eax,%ebx
  8007c8:	85 c0                	test   %eax,%eax
  8007ca:	78 19                	js     8007e5 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8007cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8007d0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007d9:	48 85 c0             	test   %rax,%rax
  8007dc:	74 07                	je     8007e5 <fd_close+0x8b>
  8007de:	4c 89 e7             	mov    %r12,%rdi
  8007e1:	ff d0                	call   *%rax
  8007e3:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8007e5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8007ea:	4c 89 e6             	mov    %r12,%rsi
  8007ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8007f2:	48 b8 6f 03 80 00 00 	movabs $0x80036f,%rax
  8007f9:	00 00 00 
  8007fc:	ff d0                	call   *%rax
    return res;
  8007fe:	eb a5                	jmp    8007a5 <fd_close+0x4b>

0000000000800800 <close>:

int
close(int fdnum) {
  800800:	55                   	push   %rbp
  800801:	48 89 e5             	mov    %rsp,%rbp
  800804:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  800808:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80080c:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  800813:	00 00 00 
  800816:	ff d0                	call   *%rax
    if (res < 0) return res;
  800818:	85 c0                	test   %eax,%eax
  80081a:	78 15                	js     800831 <close+0x31>

    return fd_close(fd, 1);
  80081c:	be 01 00 00 00       	mov    $0x1,%esi
  800821:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800825:	48 b8 5a 07 80 00 00 	movabs $0x80075a,%rax
  80082c:	00 00 00 
  80082f:	ff d0                	call   *%rax
}
  800831:	c9                   	leave  
  800832:	c3                   	ret    

0000000000800833 <close_all>:

void
close_all(void) {
  800833:	55                   	push   %rbp
  800834:	48 89 e5             	mov    %rsp,%rbp
  800837:	41 54                	push   %r12
  800839:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80083a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80083f:	49 bc 00 08 80 00 00 	movabs $0x800800,%r12
  800846:	00 00 00 
  800849:	89 df                	mov    %ebx,%edi
  80084b:	41 ff d4             	call   *%r12
  80084e:	83 c3 01             	add    $0x1,%ebx
  800851:	83 fb 20             	cmp    $0x20,%ebx
  800854:	75 f3                	jne    800849 <close_all+0x16>
}
  800856:	5b                   	pop    %rbx
  800857:	41 5c                	pop    %r12
  800859:	5d                   	pop    %rbp
  80085a:	c3                   	ret    

000000000080085b <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80085b:	55                   	push   %rbp
  80085c:	48 89 e5             	mov    %rsp,%rbp
  80085f:	41 56                	push   %r14
  800861:	41 55                	push   %r13
  800863:	41 54                	push   %r12
  800865:	53                   	push   %rbx
  800866:	48 83 ec 10          	sub    $0x10,%rsp
  80086a:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80086d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800871:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  800878:	00 00 00 
  80087b:	ff d0                	call   *%rax
  80087d:	89 c3                	mov    %eax,%ebx
  80087f:	85 c0                	test   %eax,%eax
  800881:	0f 88 b7 00 00 00    	js     80093e <dup+0xe3>
    close(newfdnum);
  800887:	44 89 e7             	mov    %r12d,%edi
  80088a:	48 b8 00 08 80 00 00 	movabs $0x800800,%rax
  800891:	00 00 00 
  800894:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800896:	4d 63 ec             	movslq %r12d,%r13
  800899:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8008a0:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8008a4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8008a8:	49 be 1a 06 80 00 00 	movabs $0x80061a,%r14
  8008af:	00 00 00 
  8008b2:	41 ff d6             	call   *%r14
  8008b5:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8008b8:	4c 89 ef             	mov    %r13,%rdi
  8008bb:	41 ff d6             	call   *%r14
  8008be:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8008c1:	48 89 df             	mov    %rbx,%rdi
  8008c4:	48 b8 e4 15 80 00 00 	movabs $0x8015e4,%rax
  8008cb:	00 00 00 
  8008ce:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8008d0:	a8 04                	test   $0x4,%al
  8008d2:	74 2b                	je     8008ff <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8008d4:	41 89 c1             	mov    %eax,%r9d
  8008d7:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8008dd:	4c 89 f1             	mov    %r14,%rcx
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	48 89 de             	mov    %rbx,%rsi
  8008e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8008ed:	48 b8 0a 03 80 00 00 	movabs $0x80030a,%rax
  8008f4:	00 00 00 
  8008f7:	ff d0                	call   *%rax
  8008f9:	89 c3                	mov    %eax,%ebx
  8008fb:	85 c0                	test   %eax,%eax
  8008fd:	78 4e                	js     80094d <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8008ff:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800903:	48 b8 e4 15 80 00 00 	movabs $0x8015e4,%rax
  80090a:	00 00 00 
  80090d:	ff d0                	call   *%rax
  80090f:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  800912:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800918:	4c 89 e9             	mov    %r13,%rcx
  80091b:	ba 00 00 00 00       	mov    $0x0,%edx
  800920:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800924:	bf 00 00 00 00       	mov    $0x0,%edi
  800929:	48 b8 0a 03 80 00 00 	movabs $0x80030a,%rax
  800930:	00 00 00 
  800933:	ff d0                	call   *%rax
  800935:	89 c3                	mov    %eax,%ebx
  800937:	85 c0                	test   %eax,%eax
  800939:	78 12                	js     80094d <dup+0xf2>

    return newfdnum;
  80093b:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80093e:	89 d8                	mov    %ebx,%eax
  800940:	48 83 c4 10          	add    $0x10,%rsp
  800944:	5b                   	pop    %rbx
  800945:	41 5c                	pop    %r12
  800947:	41 5d                	pop    %r13
  800949:	41 5e                	pop    %r14
  80094b:	5d                   	pop    %rbp
  80094c:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80094d:	ba 00 10 00 00       	mov    $0x1000,%edx
  800952:	4c 89 ee             	mov    %r13,%rsi
  800955:	bf 00 00 00 00       	mov    $0x0,%edi
  80095a:	49 bc 6f 03 80 00 00 	movabs $0x80036f,%r12
  800961:	00 00 00 
  800964:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  800967:	ba 00 10 00 00       	mov    $0x1000,%edx
  80096c:	4c 89 f6             	mov    %r14,%rsi
  80096f:	bf 00 00 00 00       	mov    $0x0,%edi
  800974:	41 ff d4             	call   *%r12
    return res;
  800977:	eb c5                	jmp    80093e <dup+0xe3>

0000000000800979 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800979:	55                   	push   %rbp
  80097a:	48 89 e5             	mov    %rsp,%rbp
  80097d:	41 55                	push   %r13
  80097f:	41 54                	push   %r12
  800981:	53                   	push   %rbx
  800982:	48 83 ec 18          	sub    $0x18,%rsp
  800986:	89 fb                	mov    %edi,%ebx
  800988:	49 89 f4             	mov    %rsi,%r12
  80098b:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80098e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800992:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  800999:	00 00 00 
  80099c:	ff d0                	call   *%rax
  80099e:	85 c0                	test   %eax,%eax
  8009a0:	78 49                	js     8009eb <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8009a2:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8009a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009aa:	8b 38                	mov    (%rax),%edi
  8009ac:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  8009b3:	00 00 00 
  8009b6:	ff d0                	call   *%rax
  8009b8:	85 c0                	test   %eax,%eax
  8009ba:	78 33                	js     8009ef <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8009bc:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8009c0:	8b 47 08             	mov    0x8(%rdi),%eax
  8009c3:	83 e0 03             	and    $0x3,%eax
  8009c6:	83 f8 01             	cmp    $0x1,%eax
  8009c9:	74 28                	je     8009f3 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8009cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009cf:	48 8b 40 10          	mov    0x10(%rax),%rax
  8009d3:	48 85 c0             	test   %rax,%rax
  8009d6:	74 51                	je     800a29 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8009d8:	4c 89 ea             	mov    %r13,%rdx
  8009db:	4c 89 e6             	mov    %r12,%rsi
  8009de:	ff d0                	call   *%rax
}
  8009e0:	48 83 c4 18          	add    $0x18,%rsp
  8009e4:	5b                   	pop    %rbx
  8009e5:	41 5c                	pop    %r12
  8009e7:	41 5d                	pop    %r13
  8009e9:	5d                   	pop    %rbp
  8009ea:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8009eb:	48 98                	cltq   
  8009ed:	eb f1                	jmp    8009e0 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8009ef:	48 98                	cltq   
  8009f1:	eb ed                	jmp    8009e0 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8009f3:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8009fa:	00 00 00 
  8009fd:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800a03:	89 da                	mov    %ebx,%edx
  800a05:	48 bf 51 2a 80 00 00 	movabs $0x802a51,%rdi
  800a0c:	00 00 00 
  800a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a14:	48 b9 b6 1a 80 00 00 	movabs $0x801ab6,%rcx
  800a1b:	00 00 00 
  800a1e:	ff d1                	call   *%rcx
        return -E_INVAL;
  800a20:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800a27:	eb b7                	jmp    8009e0 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800a29:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800a30:	eb ae                	jmp    8009e0 <read+0x67>

0000000000800a32 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800a32:	55                   	push   %rbp
  800a33:	48 89 e5             	mov    %rsp,%rbp
  800a36:	41 57                	push   %r15
  800a38:	41 56                	push   %r14
  800a3a:	41 55                	push   %r13
  800a3c:	41 54                	push   %r12
  800a3e:	53                   	push   %rbx
  800a3f:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800a43:	48 85 d2             	test   %rdx,%rdx
  800a46:	74 54                	je     800a9c <readn+0x6a>
  800a48:	41 89 fd             	mov    %edi,%r13d
  800a4b:	49 89 f6             	mov    %rsi,%r14
  800a4e:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800a51:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800a56:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800a5b:	49 bf 79 09 80 00 00 	movabs $0x800979,%r15
  800a62:	00 00 00 
  800a65:	4c 89 e2             	mov    %r12,%rdx
  800a68:	48 29 f2             	sub    %rsi,%rdx
  800a6b:	4c 01 f6             	add    %r14,%rsi
  800a6e:	44 89 ef             	mov    %r13d,%edi
  800a71:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800a74:	85 c0                	test   %eax,%eax
  800a76:	78 20                	js     800a98 <readn+0x66>
    for (; inc && res < n; res += inc) {
  800a78:	01 c3                	add    %eax,%ebx
  800a7a:	85 c0                	test   %eax,%eax
  800a7c:	74 08                	je     800a86 <readn+0x54>
  800a7e:	48 63 f3             	movslq %ebx,%rsi
  800a81:	4c 39 e6             	cmp    %r12,%rsi
  800a84:	72 df                	jb     800a65 <readn+0x33>
    }
    return res;
  800a86:	48 63 c3             	movslq %ebx,%rax
}
  800a89:	48 83 c4 08          	add    $0x8,%rsp
  800a8d:	5b                   	pop    %rbx
  800a8e:	41 5c                	pop    %r12
  800a90:	41 5d                	pop    %r13
  800a92:	41 5e                	pop    %r14
  800a94:	41 5f                	pop    %r15
  800a96:	5d                   	pop    %rbp
  800a97:	c3                   	ret    
        if (inc < 0) return inc;
  800a98:	48 98                	cltq   
  800a9a:	eb ed                	jmp    800a89 <readn+0x57>
    int inc = 1, res = 0;
  800a9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aa1:	eb e3                	jmp    800a86 <readn+0x54>

0000000000800aa3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800aa3:	55                   	push   %rbp
  800aa4:	48 89 e5             	mov    %rsp,%rbp
  800aa7:	41 55                	push   %r13
  800aa9:	41 54                	push   %r12
  800aab:	53                   	push   %rbx
  800aac:	48 83 ec 18          	sub    $0x18,%rsp
  800ab0:	89 fb                	mov    %edi,%ebx
  800ab2:	49 89 f4             	mov    %rsi,%r12
  800ab5:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800ab8:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800abc:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  800ac3:	00 00 00 
  800ac6:	ff d0                	call   *%rax
  800ac8:	85 c0                	test   %eax,%eax
  800aca:	78 44                	js     800b10 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800acc:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800ad0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ad4:	8b 38                	mov    (%rax),%edi
  800ad6:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  800add:	00 00 00 
  800ae0:	ff d0                	call   *%rax
  800ae2:	85 c0                	test   %eax,%eax
  800ae4:	78 2e                	js     800b14 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ae6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800aea:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800aee:	74 28                	je     800b18 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800af0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800af4:	48 8b 40 18          	mov    0x18(%rax),%rax
  800af8:	48 85 c0             	test   %rax,%rax
  800afb:	74 51                	je     800b4e <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  800afd:	4c 89 ea             	mov    %r13,%rdx
  800b00:	4c 89 e6             	mov    %r12,%rsi
  800b03:	ff d0                	call   *%rax
}
  800b05:	48 83 c4 18          	add    $0x18,%rsp
  800b09:	5b                   	pop    %rbx
  800b0a:	41 5c                	pop    %r12
  800b0c:	41 5d                	pop    %r13
  800b0e:	5d                   	pop    %rbp
  800b0f:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b10:	48 98                	cltq   
  800b12:	eb f1                	jmp    800b05 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b14:	48 98                	cltq   
  800b16:	eb ed                	jmp    800b05 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b18:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800b1f:	00 00 00 
  800b22:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800b28:	89 da                	mov    %ebx,%edx
  800b2a:	48 bf 6d 2a 80 00 00 	movabs $0x802a6d,%rdi
  800b31:	00 00 00 
  800b34:	b8 00 00 00 00       	mov    $0x0,%eax
  800b39:	48 b9 b6 1a 80 00 00 	movabs $0x801ab6,%rcx
  800b40:	00 00 00 
  800b43:	ff d1                	call   *%rcx
        return -E_INVAL;
  800b45:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800b4c:	eb b7                	jmp    800b05 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800b4e:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800b55:	eb ae                	jmp    800b05 <write+0x62>

0000000000800b57 <seek>:

int
seek(int fdnum, off_t offset) {
  800b57:	55                   	push   %rbp
  800b58:	48 89 e5             	mov    %rsp,%rbp
  800b5b:	53                   	push   %rbx
  800b5c:	48 83 ec 18          	sub    $0x18,%rsp
  800b60:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b62:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b66:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  800b6d:	00 00 00 
  800b70:	ff d0                	call   *%rax
  800b72:	85 c0                	test   %eax,%eax
  800b74:	78 0c                	js     800b82 <seek+0x2b>

    fd->fd_offset = offset;
  800b76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b7a:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b82:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800b86:	c9                   	leave  
  800b87:	c3                   	ret    

0000000000800b88 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800b88:	55                   	push   %rbp
  800b89:	48 89 e5             	mov    %rsp,%rbp
  800b8c:	41 54                	push   %r12
  800b8e:	53                   	push   %rbx
  800b8f:	48 83 ec 10          	sub    $0x10,%rsp
  800b93:	89 fb                	mov    %edi,%ebx
  800b95:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b98:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b9c:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  800ba3:	00 00 00 
  800ba6:	ff d0                	call   *%rax
  800ba8:	85 c0                	test   %eax,%eax
  800baa:	78 36                	js     800be2 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bac:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800bb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb4:	8b 38                	mov    (%rax),%edi
  800bb6:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  800bbd:	00 00 00 
  800bc0:	ff d0                	call   *%rax
  800bc2:	85 c0                	test   %eax,%eax
  800bc4:	78 1c                	js     800be2 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bc6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800bca:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800bce:	74 1b                	je     800beb <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800bd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800bd4:	48 8b 40 30          	mov    0x30(%rax),%rax
  800bd8:	48 85 c0             	test   %rax,%rax
  800bdb:	74 42                	je     800c1f <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  800bdd:	44 89 e6             	mov    %r12d,%esi
  800be0:	ff d0                	call   *%rax
}
  800be2:	48 83 c4 10          	add    $0x10,%rsp
  800be6:	5b                   	pop    %rbx
  800be7:	41 5c                	pop    %r12
  800be9:	5d                   	pop    %rbp
  800bea:	c3                   	ret    
                thisenv->env_id, fdnum);
  800beb:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bf2:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800bf5:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800bfb:	89 da                	mov    %ebx,%edx
  800bfd:	48 bf 30 2a 80 00 00 	movabs $0x802a30,%rdi
  800c04:	00 00 00 
  800c07:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0c:	48 b9 b6 1a 80 00 00 	movabs $0x801ab6,%rcx
  800c13:	00 00 00 
  800c16:	ff d1                	call   *%rcx
        return -E_INVAL;
  800c18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c1d:	eb c3                	jmp    800be2 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c1f:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c24:	eb bc                	jmp    800be2 <ftruncate+0x5a>

0000000000800c26 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800c26:	55                   	push   %rbp
  800c27:	48 89 e5             	mov    %rsp,%rbp
  800c2a:	53                   	push   %rbx
  800c2b:	48 83 ec 18          	sub    $0x18,%rsp
  800c2f:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c32:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c36:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  800c3d:	00 00 00 
  800c40:	ff d0                	call   *%rax
  800c42:	85 c0                	test   %eax,%eax
  800c44:	78 4d                	js     800c93 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c46:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800c4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4e:	8b 38                	mov    (%rax),%edi
  800c50:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  800c57:	00 00 00 
  800c5a:	ff d0                	call   *%rax
  800c5c:	85 c0                	test   %eax,%eax
  800c5e:	78 33                	js     800c93 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c64:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800c69:	74 2e                	je     800c99 <fstat+0x73>

    stat->st_name[0] = 0;
  800c6b:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800c6e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800c75:	00 00 00 
    stat->st_isdir = 0;
  800c78:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800c7f:	00 00 00 
    stat->st_dev = dev;
  800c82:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800c89:	48 89 de             	mov    %rbx,%rsi
  800c8c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c90:	ff 50 28             	call   *0x28(%rax)
}
  800c93:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c97:	c9                   	leave  
  800c98:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c99:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c9e:	eb f3                	jmp    800c93 <fstat+0x6d>

0000000000800ca0 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800ca0:	55                   	push   %rbp
  800ca1:	48 89 e5             	mov    %rsp,%rbp
  800ca4:	41 54                	push   %r12
  800ca6:	53                   	push   %rbx
  800ca7:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800caa:	be 00 00 00 00       	mov    $0x0,%esi
  800caf:	48 b8 6b 0f 80 00 00 	movabs $0x800f6b,%rax
  800cb6:	00 00 00 
  800cb9:	ff d0                	call   *%rax
  800cbb:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	78 25                	js     800ce6 <stat+0x46>

    int res = fstat(fd, stat);
  800cc1:	4c 89 e6             	mov    %r12,%rsi
  800cc4:	89 c7                	mov    %eax,%edi
  800cc6:	48 b8 26 0c 80 00 00 	movabs $0x800c26,%rax
  800ccd:	00 00 00 
  800cd0:	ff d0                	call   *%rax
  800cd2:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800cd5:	89 df                	mov    %ebx,%edi
  800cd7:	48 b8 00 08 80 00 00 	movabs $0x800800,%rax
  800cde:	00 00 00 
  800ce1:	ff d0                	call   *%rax

    return res;
  800ce3:	44 89 e3             	mov    %r12d,%ebx
}
  800ce6:	89 d8                	mov    %ebx,%eax
  800ce8:	5b                   	pop    %rbx
  800ce9:	41 5c                	pop    %r12
  800ceb:	5d                   	pop    %rbp
  800cec:	c3                   	ret    

0000000000800ced <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800ced:	55                   	push   %rbp
  800cee:	48 89 e5             	mov    %rsp,%rbp
  800cf1:	41 54                	push   %r12
  800cf3:	53                   	push   %rbx
  800cf4:	48 83 ec 10          	sub    $0x10,%rsp
  800cf8:	41 89 fc             	mov    %edi,%r12d
  800cfb:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800cfe:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d05:	00 00 00 
  800d08:	83 38 00             	cmpl   $0x0,(%rax)
  800d0b:	74 5e                	je     800d6b <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800d0d:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800d13:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800d18:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800d1f:	00 00 00 
  800d22:	44 89 e6             	mov    %r12d,%esi
  800d25:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d2c:	00 00 00 
  800d2f:	8b 38                	mov    (%rax),%edi
  800d31:	48 b8 c7 28 80 00 00 	movabs $0x8028c7,%rax
  800d38:	00 00 00 
  800d3b:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800d3d:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800d44:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800d45:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d4a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d4e:	48 89 de             	mov    %rbx,%rsi
  800d51:	bf 00 00 00 00       	mov    $0x0,%edi
  800d56:	48 b8 28 28 80 00 00 	movabs $0x802828,%rax
  800d5d:	00 00 00 
  800d60:	ff d0                	call   *%rax
}
  800d62:	48 83 c4 10          	add    $0x10,%rsp
  800d66:	5b                   	pop    %rbx
  800d67:	41 5c                	pop    %r12
  800d69:	5d                   	pop    %rbp
  800d6a:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800d6b:	bf 03 00 00 00       	mov    $0x3,%edi
  800d70:	48 b8 6a 29 80 00 00 	movabs $0x80296a,%rax
  800d77:	00 00 00 
  800d7a:	ff d0                	call   *%rax
  800d7c:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800d83:	00 00 
  800d85:	eb 86                	jmp    800d0d <fsipc+0x20>

0000000000800d87 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800d87:	55                   	push   %rbp
  800d88:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d8b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800d92:	00 00 00 
  800d95:	8b 57 0c             	mov    0xc(%rdi),%edx
  800d98:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800d9a:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800d9d:	be 00 00 00 00       	mov    $0x0,%esi
  800da2:	bf 02 00 00 00       	mov    $0x2,%edi
  800da7:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  800dae:	00 00 00 
  800db1:	ff d0                	call   *%rax
}
  800db3:	5d                   	pop    %rbp
  800db4:	c3                   	ret    

0000000000800db5 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800db5:	55                   	push   %rbp
  800db6:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800db9:	8b 47 0c             	mov    0xc(%rdi),%eax
  800dbc:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800dc3:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800dc5:	be 00 00 00 00       	mov    $0x0,%esi
  800dca:	bf 06 00 00 00       	mov    $0x6,%edi
  800dcf:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  800dd6:	00 00 00 
  800dd9:	ff d0                	call   *%rax
}
  800ddb:	5d                   	pop    %rbp
  800ddc:	c3                   	ret    

0000000000800ddd <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800ddd:	55                   	push   %rbp
  800dde:	48 89 e5             	mov    %rsp,%rbp
  800de1:	53                   	push   %rbx
  800de2:	48 83 ec 08          	sub    $0x8,%rsp
  800de6:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800de9:	8b 47 0c             	mov    0xc(%rdi),%eax
  800dec:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800df3:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800df5:	be 00 00 00 00       	mov    $0x0,%esi
  800dfa:	bf 05 00 00 00       	mov    $0x5,%edi
  800dff:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  800e06:	00 00 00 
  800e09:	ff d0                	call   *%rax
    if (res < 0) return res;
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	78 40                	js     800e4f <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800e0f:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800e16:	00 00 00 
  800e19:	48 89 df             	mov    %rbx,%rdi
  800e1c:	48 b8 f7 23 80 00 00 	movabs $0x8023f7,%rax
  800e23:	00 00 00 
  800e26:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800e28:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e2f:	00 00 00 
  800e32:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  800e38:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e3e:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  800e44:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e4f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800e53:	c9                   	leave  
  800e54:	c3                   	ret    

0000000000800e55 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800e55:	55                   	push   %rbp
  800e56:	48 89 e5             	mov    %rsp,%rbp
  800e59:	41 57                	push   %r15
  800e5b:	41 56                	push   %r14
  800e5d:	41 55                	push   %r13
  800e5f:	41 54                	push   %r12
  800e61:	53                   	push   %rbx
  800e62:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  800e66:	48 85 d2             	test   %rdx,%rdx
  800e69:	0f 84 91 00 00 00    	je     800f00 <devfile_write+0xab>
  800e6f:	49 89 ff             	mov    %rdi,%r15
  800e72:	49 89 f4             	mov    %rsi,%r12
  800e75:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  800e78:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e7f:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  800e86:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  800e89:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  800e90:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  800e96:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  800e9a:	4c 89 ea             	mov    %r13,%rdx
  800e9d:	4c 89 e6             	mov    %r12,%rsi
  800ea0:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  800ea7:	00 00 00 
  800eaa:	48 b8 57 26 80 00 00 	movabs $0x802657,%rax
  800eb1:	00 00 00 
  800eb4:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800eb6:	41 8b 47 0c          	mov    0xc(%r15),%eax
  800eba:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  800ebd:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  800ec1:	be 00 00 00 00       	mov    $0x0,%esi
  800ec6:	bf 04 00 00 00       	mov    $0x4,%edi
  800ecb:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  800ed2:	00 00 00 
  800ed5:	ff d0                	call   *%rax
        if (res < 0)
  800ed7:	85 c0                	test   %eax,%eax
  800ed9:	78 21                	js     800efc <devfile_write+0xa7>
        buf += res;
  800edb:	48 63 d0             	movslq %eax,%rdx
  800ede:	49 01 d4             	add    %rdx,%r12
        ext += res;
  800ee1:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  800ee4:	48 29 d3             	sub    %rdx,%rbx
  800ee7:	75 a0                	jne    800e89 <devfile_write+0x34>
    return ext;
  800ee9:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  800eed:	48 83 c4 18          	add    $0x18,%rsp
  800ef1:	5b                   	pop    %rbx
  800ef2:	41 5c                	pop    %r12
  800ef4:	41 5d                	pop    %r13
  800ef6:	41 5e                	pop    %r14
  800ef8:	41 5f                	pop    %r15
  800efa:	5d                   	pop    %rbp
  800efb:	c3                   	ret    
            return res;
  800efc:	48 98                	cltq   
  800efe:	eb ed                	jmp    800eed <devfile_write+0x98>
    int ext = 0;
  800f00:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  800f07:	eb e0                	jmp    800ee9 <devfile_write+0x94>

0000000000800f09 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800f09:	55                   	push   %rbp
  800f0a:	48 89 e5             	mov    %rsp,%rbp
  800f0d:	41 54                	push   %r12
  800f0f:	53                   	push   %rbx
  800f10:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800f13:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f1a:	00 00 00 
  800f1d:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f20:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  800f22:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  800f26:	be 00 00 00 00       	mov    $0x0,%esi
  800f2b:	bf 03 00 00 00       	mov    $0x3,%edi
  800f30:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  800f37:	00 00 00 
  800f3a:	ff d0                	call   *%rax
    if (read < 0) 
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	78 27                	js     800f67 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  800f40:	48 63 d8             	movslq %eax,%rbx
  800f43:	48 89 da             	mov    %rbx,%rdx
  800f46:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800f4d:	00 00 00 
  800f50:	4c 89 e7             	mov    %r12,%rdi
  800f53:	48 b8 f2 25 80 00 00 	movabs $0x8025f2,%rax
  800f5a:	00 00 00 
  800f5d:	ff d0                	call   *%rax
    return read;
  800f5f:	48 89 d8             	mov    %rbx,%rax
}
  800f62:	5b                   	pop    %rbx
  800f63:	41 5c                	pop    %r12
  800f65:	5d                   	pop    %rbp
  800f66:	c3                   	ret    
		return read;
  800f67:	48 98                	cltq   
  800f69:	eb f7                	jmp    800f62 <devfile_read+0x59>

0000000000800f6b <open>:
open(const char *path, int mode) {
  800f6b:	55                   	push   %rbp
  800f6c:	48 89 e5             	mov    %rsp,%rbp
  800f6f:	41 55                	push   %r13
  800f71:	41 54                	push   %r12
  800f73:	53                   	push   %rbx
  800f74:	48 83 ec 18          	sub    $0x18,%rsp
  800f78:	49 89 fc             	mov    %rdi,%r12
  800f7b:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  800f7e:	48 b8 be 23 80 00 00 	movabs $0x8023be,%rax
  800f85:	00 00 00 
  800f88:	ff d0                	call   *%rax
  800f8a:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  800f90:	0f 87 8c 00 00 00    	ja     801022 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  800f96:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  800f9a:	48 b8 36 06 80 00 00 	movabs $0x800636,%rax
  800fa1:	00 00 00 
  800fa4:	ff d0                	call   *%rax
  800fa6:	89 c3                	mov    %eax,%ebx
  800fa8:	85 c0                	test   %eax,%eax
  800faa:	78 52                	js     800ffe <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  800fac:	4c 89 e6             	mov    %r12,%rsi
  800faf:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  800fb6:	00 00 00 
  800fb9:	48 b8 f7 23 80 00 00 	movabs $0x8023f7,%rax
  800fc0:	00 00 00 
  800fc3:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  800fc5:	44 89 e8             	mov    %r13d,%eax
  800fc8:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  800fcf:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fd1:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800fd5:	bf 01 00 00 00       	mov    $0x1,%edi
  800fda:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  800fe1:	00 00 00 
  800fe4:	ff d0                	call   *%rax
  800fe6:	89 c3                	mov    %eax,%ebx
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	78 1f                	js     80100b <open+0xa0>
    return fd2num(fd);
  800fec:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ff0:	48 b8 08 06 80 00 00 	movabs $0x800608,%rax
  800ff7:	00 00 00 
  800ffa:	ff d0                	call   *%rax
  800ffc:	89 c3                	mov    %eax,%ebx
}
  800ffe:	89 d8                	mov    %ebx,%eax
  801000:	48 83 c4 18          	add    $0x18,%rsp
  801004:	5b                   	pop    %rbx
  801005:	41 5c                	pop    %r12
  801007:	41 5d                	pop    %r13
  801009:	5d                   	pop    %rbp
  80100a:	c3                   	ret    
        fd_close(fd, 0);
  80100b:	be 00 00 00 00       	mov    $0x0,%esi
  801010:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801014:	48 b8 5a 07 80 00 00 	movabs $0x80075a,%rax
  80101b:	00 00 00 
  80101e:	ff d0                	call   *%rax
        return res;
  801020:	eb dc                	jmp    800ffe <open+0x93>
        return -E_BAD_PATH;
  801022:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801027:	eb d5                	jmp    800ffe <open+0x93>

0000000000801029 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801029:	55                   	push   %rbp
  80102a:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80102d:	be 00 00 00 00       	mov    $0x0,%esi
  801032:	bf 08 00 00 00       	mov    $0x8,%edi
  801037:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  80103e:	00 00 00 
  801041:	ff d0                	call   *%rax
}
  801043:	5d                   	pop    %rbp
  801044:	c3                   	ret    

0000000000801045 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801045:	55                   	push   %rbp
  801046:	48 89 e5             	mov    %rsp,%rbp
  801049:	41 54                	push   %r12
  80104b:	53                   	push   %rbx
  80104c:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80104f:	48 b8 1a 06 80 00 00 	movabs $0x80061a,%rax
  801056:	00 00 00 
  801059:	ff d0                	call   *%rax
  80105b:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80105e:	48 be c0 2a 80 00 00 	movabs $0x802ac0,%rsi
  801065:	00 00 00 
  801068:	48 89 df             	mov    %rbx,%rdi
  80106b:	48 b8 f7 23 80 00 00 	movabs $0x8023f7,%rax
  801072:	00 00 00 
  801075:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801077:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80107c:	41 2b 04 24          	sub    (%r12),%eax
  801080:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801086:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80108d:	00 00 00 
    stat->st_dev = &devpipe;
  801090:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801097:	00 00 00 
  80109a:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8010a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a6:	5b                   	pop    %rbx
  8010a7:	41 5c                	pop    %r12
  8010a9:	5d                   	pop    %rbp
  8010aa:	c3                   	ret    

00000000008010ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8010ab:	55                   	push   %rbp
  8010ac:	48 89 e5             	mov    %rsp,%rbp
  8010af:	41 54                	push   %r12
  8010b1:	53                   	push   %rbx
  8010b2:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8010b5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010ba:	48 89 fe             	mov    %rdi,%rsi
  8010bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8010c2:	49 bc 6f 03 80 00 00 	movabs $0x80036f,%r12
  8010c9:	00 00 00 
  8010cc:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8010cf:	48 89 df             	mov    %rbx,%rdi
  8010d2:	48 b8 1a 06 80 00 00 	movabs $0x80061a,%rax
  8010d9:	00 00 00 
  8010dc:	ff d0                	call   *%rax
  8010de:	48 89 c6             	mov    %rax,%rsi
  8010e1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8010eb:	41 ff d4             	call   *%r12
}
  8010ee:	5b                   	pop    %rbx
  8010ef:	41 5c                	pop    %r12
  8010f1:	5d                   	pop    %rbp
  8010f2:	c3                   	ret    

00000000008010f3 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8010f3:	55                   	push   %rbp
  8010f4:	48 89 e5             	mov    %rsp,%rbp
  8010f7:	41 57                	push   %r15
  8010f9:	41 56                	push   %r14
  8010fb:	41 55                	push   %r13
  8010fd:	41 54                	push   %r12
  8010ff:	53                   	push   %rbx
  801100:	48 83 ec 18          	sub    $0x18,%rsp
  801104:	49 89 fc             	mov    %rdi,%r12
  801107:	49 89 f5             	mov    %rsi,%r13
  80110a:	49 89 d7             	mov    %rdx,%r15
  80110d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801111:	48 b8 1a 06 80 00 00 	movabs $0x80061a,%rax
  801118:	00 00 00 
  80111b:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80111d:	4d 85 ff             	test   %r15,%r15
  801120:	0f 84 ac 00 00 00    	je     8011d2 <devpipe_write+0xdf>
  801126:	48 89 c3             	mov    %rax,%rbx
  801129:	4c 89 f8             	mov    %r15,%rax
  80112c:	4d 89 ef             	mov    %r13,%r15
  80112f:	49 01 c5             	add    %rax,%r13
  801132:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801136:	49 bd 77 02 80 00 00 	movabs $0x800277,%r13
  80113d:	00 00 00 
            sys_yield();
  801140:	49 be 14 02 80 00 00 	movabs $0x800214,%r14
  801147:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80114a:	8b 73 04             	mov    0x4(%rbx),%esi
  80114d:	48 63 ce             	movslq %esi,%rcx
  801150:	48 63 03             	movslq (%rbx),%rax
  801153:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801159:	48 39 c1             	cmp    %rax,%rcx
  80115c:	72 2e                	jb     80118c <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80115e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801163:	48 89 da             	mov    %rbx,%rdx
  801166:	be 00 10 00 00       	mov    $0x1000,%esi
  80116b:	4c 89 e7             	mov    %r12,%rdi
  80116e:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801171:	85 c0                	test   %eax,%eax
  801173:	74 63                	je     8011d8 <devpipe_write+0xe5>
            sys_yield();
  801175:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801178:	8b 73 04             	mov    0x4(%rbx),%esi
  80117b:	48 63 ce             	movslq %esi,%rcx
  80117e:	48 63 03             	movslq (%rbx),%rax
  801181:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801187:	48 39 c1             	cmp    %rax,%rcx
  80118a:	73 d2                	jae    80115e <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80118c:	41 0f b6 3f          	movzbl (%r15),%edi
  801190:	48 89 ca             	mov    %rcx,%rdx
  801193:	48 c1 ea 03          	shr    $0x3,%rdx
  801197:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80119e:	08 10 20 
  8011a1:	48 f7 e2             	mul    %rdx
  8011a4:	48 c1 ea 06          	shr    $0x6,%rdx
  8011a8:	48 89 d0             	mov    %rdx,%rax
  8011ab:	48 c1 e0 09          	shl    $0x9,%rax
  8011af:	48 29 d0             	sub    %rdx,%rax
  8011b2:	48 c1 e0 03          	shl    $0x3,%rax
  8011b6:	48 29 c1             	sub    %rax,%rcx
  8011b9:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8011be:	83 c6 01             	add    $0x1,%esi
  8011c1:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8011c4:	49 83 c7 01          	add    $0x1,%r15
  8011c8:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8011cc:	0f 85 78 ff ff ff    	jne    80114a <devpipe_write+0x57>
    return n;
  8011d2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8011d6:	eb 05                	jmp    8011dd <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8011d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011dd:	48 83 c4 18          	add    $0x18,%rsp
  8011e1:	5b                   	pop    %rbx
  8011e2:	41 5c                	pop    %r12
  8011e4:	41 5d                	pop    %r13
  8011e6:	41 5e                	pop    %r14
  8011e8:	41 5f                	pop    %r15
  8011ea:	5d                   	pop    %rbp
  8011eb:	c3                   	ret    

00000000008011ec <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8011ec:	55                   	push   %rbp
  8011ed:	48 89 e5             	mov    %rsp,%rbp
  8011f0:	41 57                	push   %r15
  8011f2:	41 56                	push   %r14
  8011f4:	41 55                	push   %r13
  8011f6:	41 54                	push   %r12
  8011f8:	53                   	push   %rbx
  8011f9:	48 83 ec 18          	sub    $0x18,%rsp
  8011fd:	49 89 fc             	mov    %rdi,%r12
  801200:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801204:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801208:	48 b8 1a 06 80 00 00 	movabs $0x80061a,%rax
  80120f:	00 00 00 
  801212:	ff d0                	call   *%rax
  801214:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  801217:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80121d:	49 bd 77 02 80 00 00 	movabs $0x800277,%r13
  801224:	00 00 00 
            sys_yield();
  801227:	49 be 14 02 80 00 00 	movabs $0x800214,%r14
  80122e:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801231:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801236:	74 7a                	je     8012b2 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801238:	8b 03                	mov    (%rbx),%eax
  80123a:	3b 43 04             	cmp    0x4(%rbx),%eax
  80123d:	75 26                	jne    801265 <devpipe_read+0x79>
            if (i > 0) return i;
  80123f:	4d 85 ff             	test   %r15,%r15
  801242:	75 74                	jne    8012b8 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801244:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801249:	48 89 da             	mov    %rbx,%rdx
  80124c:	be 00 10 00 00       	mov    $0x1000,%esi
  801251:	4c 89 e7             	mov    %r12,%rdi
  801254:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801257:	85 c0                	test   %eax,%eax
  801259:	74 6f                	je     8012ca <devpipe_read+0xde>
            sys_yield();
  80125b:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80125e:	8b 03                	mov    (%rbx),%eax
  801260:	3b 43 04             	cmp    0x4(%rbx),%eax
  801263:	74 df                	je     801244 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801265:	48 63 c8             	movslq %eax,%rcx
  801268:	48 89 ca             	mov    %rcx,%rdx
  80126b:	48 c1 ea 03          	shr    $0x3,%rdx
  80126f:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801276:	08 10 20 
  801279:	48 f7 e2             	mul    %rdx
  80127c:	48 c1 ea 06          	shr    $0x6,%rdx
  801280:	48 89 d0             	mov    %rdx,%rax
  801283:	48 c1 e0 09          	shl    $0x9,%rax
  801287:	48 29 d0             	sub    %rdx,%rax
  80128a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801291:	00 
  801292:	48 89 c8             	mov    %rcx,%rax
  801295:	48 29 d0             	sub    %rdx,%rax
  801298:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80129d:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8012a1:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8012a5:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012a8:	49 83 c7 01          	add    $0x1,%r15
  8012ac:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8012b0:	75 86                	jne    801238 <devpipe_read+0x4c>
    return n;
  8012b2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012b6:	eb 03                	jmp    8012bb <devpipe_read+0xcf>
            if (i > 0) return i;
  8012b8:	4c 89 f8             	mov    %r15,%rax
}
  8012bb:	48 83 c4 18          	add    $0x18,%rsp
  8012bf:	5b                   	pop    %rbx
  8012c0:	41 5c                	pop    %r12
  8012c2:	41 5d                	pop    %r13
  8012c4:	41 5e                	pop    %r14
  8012c6:	41 5f                	pop    %r15
  8012c8:	5d                   	pop    %rbp
  8012c9:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8012ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cf:	eb ea                	jmp    8012bb <devpipe_read+0xcf>

00000000008012d1 <pipe>:
pipe(int pfd[2]) {
  8012d1:	55                   	push   %rbp
  8012d2:	48 89 e5             	mov    %rsp,%rbp
  8012d5:	41 55                	push   %r13
  8012d7:	41 54                	push   %r12
  8012d9:	53                   	push   %rbx
  8012da:	48 83 ec 18          	sub    $0x18,%rsp
  8012de:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8012e1:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8012e5:	48 b8 36 06 80 00 00 	movabs $0x800636,%rax
  8012ec:	00 00 00 
  8012ef:	ff d0                	call   *%rax
  8012f1:	89 c3                	mov    %eax,%ebx
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	0f 88 a0 01 00 00    	js     80149b <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8012fb:	b9 46 00 00 00       	mov    $0x46,%ecx
  801300:	ba 00 10 00 00       	mov    $0x1000,%edx
  801305:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801309:	bf 00 00 00 00       	mov    $0x0,%edi
  80130e:	48 b8 a3 02 80 00 00 	movabs $0x8002a3,%rax
  801315:	00 00 00 
  801318:	ff d0                	call   *%rax
  80131a:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80131c:	85 c0                	test   %eax,%eax
  80131e:	0f 88 77 01 00 00    	js     80149b <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801324:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  801328:	48 b8 36 06 80 00 00 	movabs $0x800636,%rax
  80132f:	00 00 00 
  801332:	ff d0                	call   *%rax
  801334:	89 c3                	mov    %eax,%ebx
  801336:	85 c0                	test   %eax,%eax
  801338:	0f 88 43 01 00 00    	js     801481 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80133e:	b9 46 00 00 00       	mov    $0x46,%ecx
  801343:	ba 00 10 00 00       	mov    $0x1000,%edx
  801348:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80134c:	bf 00 00 00 00       	mov    $0x0,%edi
  801351:	48 b8 a3 02 80 00 00 	movabs $0x8002a3,%rax
  801358:	00 00 00 
  80135b:	ff d0                	call   *%rax
  80135d:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80135f:	85 c0                	test   %eax,%eax
  801361:	0f 88 1a 01 00 00    	js     801481 <pipe+0x1b0>
    va = fd2data(fd0);
  801367:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80136b:	48 b8 1a 06 80 00 00 	movabs $0x80061a,%rax
  801372:	00 00 00 
  801375:	ff d0                	call   *%rax
  801377:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80137a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80137f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801384:	48 89 c6             	mov    %rax,%rsi
  801387:	bf 00 00 00 00       	mov    $0x0,%edi
  80138c:	48 b8 a3 02 80 00 00 	movabs $0x8002a3,%rax
  801393:	00 00 00 
  801396:	ff d0                	call   *%rax
  801398:	89 c3                	mov    %eax,%ebx
  80139a:	85 c0                	test   %eax,%eax
  80139c:	0f 88 c5 00 00 00    	js     801467 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8013a2:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8013a6:	48 b8 1a 06 80 00 00 	movabs $0x80061a,%rax
  8013ad:	00 00 00 
  8013b0:	ff d0                	call   *%rax
  8013b2:	48 89 c1             	mov    %rax,%rcx
  8013b5:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8013bb:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8013c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c6:	4c 89 ee             	mov    %r13,%rsi
  8013c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8013ce:	48 b8 0a 03 80 00 00 	movabs $0x80030a,%rax
  8013d5:	00 00 00 
  8013d8:	ff d0                	call   *%rax
  8013da:	89 c3                	mov    %eax,%ebx
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	78 6e                	js     80144e <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8013e0:	be 00 10 00 00       	mov    $0x1000,%esi
  8013e5:	4c 89 ef             	mov    %r13,%rdi
  8013e8:	48 b8 45 02 80 00 00 	movabs $0x800245,%rax
  8013ef:	00 00 00 
  8013f2:	ff d0                	call   *%rax
  8013f4:	83 f8 02             	cmp    $0x2,%eax
  8013f7:	0f 85 ab 00 00 00    	jne    8014a8 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8013fd:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  801404:	00 00 
  801406:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80140a:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80140c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801410:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  801417:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80141b:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80141d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801421:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801428:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80142c:	48 bb 08 06 80 00 00 	movabs $0x800608,%rbx
  801433:	00 00 00 
  801436:	ff d3                	call   *%rbx
  801438:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80143c:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801440:	ff d3                	call   *%rbx
  801442:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  801447:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144c:	eb 4d                	jmp    80149b <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  80144e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801453:	4c 89 ee             	mov    %r13,%rsi
  801456:	bf 00 00 00 00       	mov    $0x0,%edi
  80145b:	48 b8 6f 03 80 00 00 	movabs $0x80036f,%rax
  801462:	00 00 00 
  801465:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  801467:	ba 00 10 00 00       	mov    $0x1000,%edx
  80146c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801470:	bf 00 00 00 00       	mov    $0x0,%edi
  801475:	48 b8 6f 03 80 00 00 	movabs $0x80036f,%rax
  80147c:	00 00 00 
  80147f:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  801481:	ba 00 10 00 00       	mov    $0x1000,%edx
  801486:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80148a:	bf 00 00 00 00       	mov    $0x0,%edi
  80148f:	48 b8 6f 03 80 00 00 	movabs $0x80036f,%rax
  801496:	00 00 00 
  801499:	ff d0                	call   *%rax
}
  80149b:	89 d8                	mov    %ebx,%eax
  80149d:	48 83 c4 18          	add    $0x18,%rsp
  8014a1:	5b                   	pop    %rbx
  8014a2:	41 5c                	pop    %r12
  8014a4:	41 5d                	pop    %r13
  8014a6:	5d                   	pop    %rbp
  8014a7:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014a8:	48 b9 f0 2a 80 00 00 	movabs $0x802af0,%rcx
  8014af:	00 00 00 
  8014b2:	48 ba c7 2a 80 00 00 	movabs $0x802ac7,%rdx
  8014b9:	00 00 00 
  8014bc:	be 2e 00 00 00       	mov    $0x2e,%esi
  8014c1:	48 bf dc 2a 80 00 00 	movabs $0x802adc,%rdi
  8014c8:	00 00 00 
  8014cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d0:	49 b8 66 19 80 00 00 	movabs $0x801966,%r8
  8014d7:	00 00 00 
  8014da:	41 ff d0             	call   *%r8

00000000008014dd <pipeisclosed>:
pipeisclosed(int fdnum) {
  8014dd:	55                   	push   %rbp
  8014de:	48 89 e5             	mov    %rsp,%rbp
  8014e1:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8014e5:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8014e9:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  8014f0:	00 00 00 
  8014f3:	ff d0                	call   *%rax
    if (res < 0) return res;
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	78 35                	js     80152e <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8014f9:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8014fd:	48 b8 1a 06 80 00 00 	movabs $0x80061a,%rax
  801504:	00 00 00 
  801507:	ff d0                	call   *%rax
  801509:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80150c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801511:	be 00 10 00 00       	mov    $0x1000,%esi
  801516:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80151a:	48 b8 77 02 80 00 00 	movabs $0x800277,%rax
  801521:	00 00 00 
  801524:	ff d0                	call   *%rax
  801526:	85 c0                	test   %eax,%eax
  801528:	0f 94 c0             	sete   %al
  80152b:	0f b6 c0             	movzbl %al,%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

0000000000801530 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801530:	48 89 f8             	mov    %rdi,%rax
  801533:	48 c1 e8 27          	shr    $0x27,%rax
  801537:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80153e:	01 00 00 
  801541:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801545:	f6 c2 01             	test   $0x1,%dl
  801548:	74 6d                	je     8015b7 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80154a:	48 89 f8             	mov    %rdi,%rax
  80154d:	48 c1 e8 1e          	shr    $0x1e,%rax
  801551:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801558:	01 00 00 
  80155b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80155f:	f6 c2 01             	test   $0x1,%dl
  801562:	74 62                	je     8015c6 <get_uvpt_entry+0x96>
  801564:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80156b:	01 00 00 
  80156e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801572:	f6 c2 80             	test   $0x80,%dl
  801575:	75 4f                	jne    8015c6 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801577:	48 89 f8             	mov    %rdi,%rax
  80157a:	48 c1 e8 15          	shr    $0x15,%rax
  80157e:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801585:	01 00 00 
  801588:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80158c:	f6 c2 01             	test   $0x1,%dl
  80158f:	74 44                	je     8015d5 <get_uvpt_entry+0xa5>
  801591:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801598:	01 00 00 
  80159b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80159f:	f6 c2 80             	test   $0x80,%dl
  8015a2:	75 31                	jne    8015d5 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8015a4:	48 c1 ef 0c          	shr    $0xc,%rdi
  8015a8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8015af:	01 00 00 
  8015b2:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8015b6:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8015b7:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8015be:	01 00 00 
  8015c1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015c5:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8015c6:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8015cd:	01 00 00 
  8015d0:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015d4:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8015d5:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8015dc:	01 00 00 
  8015df:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015e3:	c3                   	ret    

00000000008015e4 <get_prot>:

int
get_prot(void *va) {
  8015e4:	55                   	push   %rbp
  8015e5:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8015e8:	48 b8 30 15 80 00 00 	movabs $0x801530,%rax
  8015ef:	00 00 00 
  8015f2:	ff d0                	call   *%rax
  8015f4:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8015f7:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8015fc:	89 c1                	mov    %eax,%ecx
  8015fe:	83 c9 04             	or     $0x4,%ecx
  801601:	f6 c2 01             	test   $0x1,%dl
  801604:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  801607:	89 c1                	mov    %eax,%ecx
  801609:	83 c9 02             	or     $0x2,%ecx
  80160c:	f6 c2 02             	test   $0x2,%dl
  80160f:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  801612:	89 c1                	mov    %eax,%ecx
  801614:	83 c9 01             	or     $0x1,%ecx
  801617:	48 85 d2             	test   %rdx,%rdx
  80161a:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80161d:	89 c1                	mov    %eax,%ecx
  80161f:	83 c9 40             	or     $0x40,%ecx
  801622:	f6 c6 04             	test   $0x4,%dh
  801625:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801628:	5d                   	pop    %rbp
  801629:	c3                   	ret    

000000000080162a <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80162a:	55                   	push   %rbp
  80162b:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80162e:	48 b8 30 15 80 00 00 	movabs $0x801530,%rax
  801635:	00 00 00 
  801638:	ff d0                	call   *%rax
    return pte & PTE_D;
  80163a:	48 c1 e8 06          	shr    $0x6,%rax
  80163e:	83 e0 01             	and    $0x1,%eax
}
  801641:	5d                   	pop    %rbp
  801642:	c3                   	ret    

0000000000801643 <is_page_present>:

bool
is_page_present(void *va) {
  801643:	55                   	push   %rbp
  801644:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801647:	48 b8 30 15 80 00 00 	movabs $0x801530,%rax
  80164e:	00 00 00 
  801651:	ff d0                	call   *%rax
  801653:	83 e0 01             	and    $0x1,%eax
}
  801656:	5d                   	pop    %rbp
  801657:	c3                   	ret    

0000000000801658 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801658:	55                   	push   %rbp
  801659:	48 89 e5             	mov    %rsp,%rbp
  80165c:	41 57                	push   %r15
  80165e:	41 56                	push   %r14
  801660:	41 55                	push   %r13
  801662:	41 54                	push   %r12
  801664:	53                   	push   %rbx
  801665:	48 83 ec 28          	sub    $0x28,%rsp
  801669:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  80166d:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  801671:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  801676:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  80167d:	01 00 00 
  801680:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  801687:	01 00 00 
  80168a:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  801691:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  801694:	49 bf e4 15 80 00 00 	movabs $0x8015e4,%r15
  80169b:	00 00 00 
  80169e:	eb 16                	jmp    8016b6 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8016a0:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8016a7:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8016ae:	00 00 00 
  8016b1:	48 39 c3             	cmp    %rax,%rbx
  8016b4:	77 73                	ja     801729 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8016b6:	48 89 d8             	mov    %rbx,%rax
  8016b9:	48 c1 e8 27          	shr    $0x27,%rax
  8016bd:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8016c1:	a8 01                	test   $0x1,%al
  8016c3:	74 db                	je     8016a0 <foreach_shared_region+0x48>
  8016c5:	48 89 d8             	mov    %rbx,%rax
  8016c8:	48 c1 e8 1e          	shr    $0x1e,%rax
  8016cc:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8016d1:	a8 01                	test   $0x1,%al
  8016d3:	74 cb                	je     8016a0 <foreach_shared_region+0x48>
  8016d5:	48 89 d8             	mov    %rbx,%rax
  8016d8:	48 c1 e8 15          	shr    $0x15,%rax
  8016dc:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8016e0:	a8 01                	test   $0x1,%al
  8016e2:	74 bc                	je     8016a0 <foreach_shared_region+0x48>
        void *start = (void*)i;
  8016e4:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016e8:	48 89 df             	mov    %rbx,%rdi
  8016eb:	41 ff d7             	call   *%r15
  8016ee:	a8 40                	test   $0x40,%al
  8016f0:	75 09                	jne    8016fb <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8016f2:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8016f9:	eb ac                	jmp    8016a7 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016fb:	48 89 df             	mov    %rbx,%rdi
  8016fe:	48 b8 43 16 80 00 00 	movabs $0x801643,%rax
  801705:	00 00 00 
  801708:	ff d0                	call   *%rax
  80170a:	84 c0                	test   %al,%al
  80170c:	74 e4                	je     8016f2 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  80170e:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  801715:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801719:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80171d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801721:	ff d0                	call   *%rax
  801723:	85 c0                	test   %eax,%eax
  801725:	79 cb                	jns    8016f2 <foreach_shared_region+0x9a>
  801727:	eb 05                	jmp    80172e <foreach_shared_region+0xd6>
    }
    return 0;
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172e:	48 83 c4 28          	add    $0x28,%rsp
  801732:	5b                   	pop    %rbx
  801733:	41 5c                	pop    %r12
  801735:	41 5d                	pop    %r13
  801737:	41 5e                	pop    %r14
  801739:	41 5f                	pop    %r15
  80173b:	5d                   	pop    %rbp
  80173c:	c3                   	ret    

000000000080173d <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80173d:	b8 00 00 00 00       	mov    $0x0,%eax
  801742:	c3                   	ret    

0000000000801743 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  801743:	55                   	push   %rbp
  801744:	48 89 e5             	mov    %rsp,%rbp
  801747:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80174a:	48 be 14 2b 80 00 00 	movabs $0x802b14,%rsi
  801751:	00 00 00 
  801754:	48 b8 f7 23 80 00 00 	movabs $0x8023f7,%rax
  80175b:	00 00 00 
  80175e:	ff d0                	call   *%rax
    return 0;
}
  801760:	b8 00 00 00 00       	mov    $0x0,%eax
  801765:	5d                   	pop    %rbp
  801766:	c3                   	ret    

0000000000801767 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  801767:	55                   	push   %rbp
  801768:	48 89 e5             	mov    %rsp,%rbp
  80176b:	41 57                	push   %r15
  80176d:	41 56                	push   %r14
  80176f:	41 55                	push   %r13
  801771:	41 54                	push   %r12
  801773:	53                   	push   %rbx
  801774:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80177b:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  801782:	48 85 d2             	test   %rdx,%rdx
  801785:	74 78                	je     8017ff <devcons_write+0x98>
  801787:	49 89 d6             	mov    %rdx,%r14
  80178a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801790:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801795:	49 bf f2 25 80 00 00 	movabs $0x8025f2,%r15
  80179c:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80179f:	4c 89 f3             	mov    %r14,%rbx
  8017a2:	48 29 f3             	sub    %rsi,%rbx
  8017a5:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8017a9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8017ae:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8017b2:	4c 63 eb             	movslq %ebx,%r13
  8017b5:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8017bc:	4c 89 ea             	mov    %r13,%rdx
  8017bf:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017c6:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8017c9:	4c 89 ee             	mov    %r13,%rsi
  8017cc:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017d3:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8017da:	00 00 00 
  8017dd:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8017df:	41 01 dc             	add    %ebx,%r12d
  8017e2:	49 63 f4             	movslq %r12d,%rsi
  8017e5:	4c 39 f6             	cmp    %r14,%rsi
  8017e8:	72 b5                	jb     80179f <devcons_write+0x38>
    return res;
  8017ea:	49 63 c4             	movslq %r12d,%rax
}
  8017ed:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8017f4:	5b                   	pop    %rbx
  8017f5:	41 5c                	pop    %r12
  8017f7:	41 5d                	pop    %r13
  8017f9:	41 5e                	pop    %r14
  8017fb:	41 5f                	pop    %r15
  8017fd:	5d                   	pop    %rbp
  8017fe:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8017ff:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801805:	eb e3                	jmp    8017ea <devcons_write+0x83>

0000000000801807 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801807:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80180a:	ba 00 00 00 00       	mov    $0x0,%edx
  80180f:	48 85 c0             	test   %rax,%rax
  801812:	74 55                	je     801869 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801814:	55                   	push   %rbp
  801815:	48 89 e5             	mov    %rsp,%rbp
  801818:	41 55                	push   %r13
  80181a:	41 54                	push   %r12
  80181c:	53                   	push   %rbx
  80181d:	48 83 ec 08          	sub    $0x8,%rsp
  801821:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801824:	48 bb 47 01 80 00 00 	movabs $0x800147,%rbx
  80182b:	00 00 00 
  80182e:	49 bc 14 02 80 00 00 	movabs $0x800214,%r12
  801835:	00 00 00 
  801838:	eb 03                	jmp    80183d <devcons_read+0x36>
  80183a:	41 ff d4             	call   *%r12
  80183d:	ff d3                	call   *%rbx
  80183f:	85 c0                	test   %eax,%eax
  801841:	74 f7                	je     80183a <devcons_read+0x33>
    if (c < 0) return c;
  801843:	48 63 d0             	movslq %eax,%rdx
  801846:	78 13                	js     80185b <devcons_read+0x54>
    if (c == 0x04) return 0;
  801848:	ba 00 00 00 00       	mov    $0x0,%edx
  80184d:	83 f8 04             	cmp    $0x4,%eax
  801850:	74 09                	je     80185b <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  801852:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801856:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80185b:	48 89 d0             	mov    %rdx,%rax
  80185e:	48 83 c4 08          	add    $0x8,%rsp
  801862:	5b                   	pop    %rbx
  801863:	41 5c                	pop    %r12
  801865:	41 5d                	pop    %r13
  801867:	5d                   	pop    %rbp
  801868:	c3                   	ret    
  801869:	48 89 d0             	mov    %rdx,%rax
  80186c:	c3                   	ret    

000000000080186d <cputchar>:
cputchar(int ch) {
  80186d:	55                   	push   %rbp
  80186e:	48 89 e5             	mov    %rsp,%rbp
  801871:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801875:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801879:	be 01 00 00 00       	mov    $0x1,%esi
  80187e:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801882:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  801889:	00 00 00 
  80188c:	ff d0                	call   *%rax
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

0000000000801890 <getchar>:
getchar(void) {
  801890:	55                   	push   %rbp
  801891:	48 89 e5             	mov    %rsp,%rbp
  801894:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801898:	ba 01 00 00 00       	mov    $0x1,%edx
  80189d:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8018a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a6:	48 b8 79 09 80 00 00 	movabs $0x800979,%rax
  8018ad:	00 00 00 
  8018b0:	ff d0                	call   *%rax
  8018b2:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	78 06                	js     8018be <getchar+0x2e>
  8018b8:	74 08                	je     8018c2 <getchar+0x32>
  8018ba:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8018be:	89 d0                	mov    %edx,%eax
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8018c2:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8018c7:	eb f5                	jmp    8018be <getchar+0x2e>

00000000008018c9 <iscons>:
iscons(int fdnum) {
  8018c9:	55                   	push   %rbp
  8018ca:	48 89 e5             	mov    %rsp,%rbp
  8018cd:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8018d1:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018d5:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  8018dc:	00 00 00 
  8018df:	ff d0                	call   *%rax
    if (res < 0) return res;
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	78 18                	js     8018fd <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8018e5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018e9:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8018f0:	00 00 00 
  8018f3:	8b 00                	mov    (%rax),%eax
  8018f5:	39 02                	cmp    %eax,(%rdx)
  8018f7:	0f 94 c0             	sete   %al
  8018fa:	0f b6 c0             	movzbl %al,%eax
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

00000000008018ff <opencons>:
opencons(void) {
  8018ff:	55                   	push   %rbp
  801900:	48 89 e5             	mov    %rsp,%rbp
  801903:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801907:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80190b:	48 b8 36 06 80 00 00 	movabs $0x800636,%rax
  801912:	00 00 00 
  801915:	ff d0                	call   *%rax
  801917:	85 c0                	test   %eax,%eax
  801919:	78 49                	js     801964 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80191b:	b9 46 00 00 00       	mov    $0x46,%ecx
  801920:	ba 00 10 00 00       	mov    $0x1000,%edx
  801925:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801929:	bf 00 00 00 00       	mov    $0x0,%edi
  80192e:	48 b8 a3 02 80 00 00 	movabs $0x8002a3,%rax
  801935:	00 00 00 
  801938:	ff d0                	call   *%rax
  80193a:	85 c0                	test   %eax,%eax
  80193c:	78 26                	js     801964 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  80193e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801942:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801949:	00 00 
  80194b:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80194d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801951:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801958:	48 b8 08 06 80 00 00 	movabs $0x800608,%rax
  80195f:	00 00 00 
  801962:	ff d0                	call   *%rax
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

0000000000801966 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801966:	55                   	push   %rbp
  801967:	48 89 e5             	mov    %rsp,%rbp
  80196a:	41 56                	push   %r14
  80196c:	41 55                	push   %r13
  80196e:	41 54                	push   %r12
  801970:	53                   	push   %rbx
  801971:	48 83 ec 50          	sub    $0x50,%rsp
  801975:	49 89 fc             	mov    %rdi,%r12
  801978:	41 89 f5             	mov    %esi,%r13d
  80197b:	48 89 d3             	mov    %rdx,%rbx
  80197e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801982:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801986:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80198a:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801991:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801995:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801999:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80199d:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8019a1:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8019a8:	00 00 00 
  8019ab:	4c 8b 30             	mov    (%rax),%r14
  8019ae:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  8019b5:	00 00 00 
  8019b8:	ff d0                	call   *%rax
  8019ba:	89 c6                	mov    %eax,%esi
  8019bc:	45 89 e8             	mov    %r13d,%r8d
  8019bf:	4c 89 e1             	mov    %r12,%rcx
  8019c2:	4c 89 f2             	mov    %r14,%rdx
  8019c5:	48 bf 20 2b 80 00 00 	movabs $0x802b20,%rdi
  8019cc:	00 00 00 
  8019cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d4:	49 bc b6 1a 80 00 00 	movabs $0x801ab6,%r12
  8019db:	00 00 00 
  8019de:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8019e1:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8019e5:	48 89 df             	mov    %rbx,%rdi
  8019e8:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	call   *%rax
    cprintf("\n");
  8019f4:	48 bf d4 29 80 00 00 	movabs $0x8029d4,%rdi
  8019fb:	00 00 00 
  8019fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801a03:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801a06:	cc                   	int3   
  801a07:	eb fd                	jmp    801a06 <_panic+0xa0>

0000000000801a09 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801a09:	55                   	push   %rbp
  801a0a:	48 89 e5             	mov    %rsp,%rbp
  801a0d:	53                   	push   %rbx
  801a0e:	48 83 ec 08          	sub    $0x8,%rsp
  801a12:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801a15:	8b 06                	mov    (%rsi),%eax
  801a17:	8d 50 01             	lea    0x1(%rax),%edx
  801a1a:	89 16                	mov    %edx,(%rsi)
  801a1c:	48 98                	cltq   
  801a1e:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801a23:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801a29:	74 0a                	je     801a35 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801a2b:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801a2f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  801a35:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801a39:	be ff 00 00 00       	mov    $0xff,%esi
  801a3e:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  801a45:	00 00 00 
  801a48:	ff d0                	call   *%rax
        state->offset = 0;
  801a4a:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801a50:	eb d9                	jmp    801a2b <putch+0x22>

0000000000801a52 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801a52:	55                   	push   %rbp
  801a53:	48 89 e5             	mov    %rsp,%rbp
  801a56:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801a5d:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801a60:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801a67:	b9 21 00 00 00       	mov    $0x21,%ecx
  801a6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a71:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801a74:	48 89 f1             	mov    %rsi,%rcx
  801a77:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801a7e:	48 bf 09 1a 80 00 00 	movabs $0x801a09,%rdi
  801a85:	00 00 00 
  801a88:	48 b8 06 1c 80 00 00 	movabs $0x801c06,%rax
  801a8f:	00 00 00 
  801a92:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801a94:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801a9b:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801aa2:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  801aa9:	00 00 00 
  801aac:	ff d0                	call   *%rax

    return state.count;
}
  801aae:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

0000000000801ab6 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801ab6:	55                   	push   %rbp
  801ab7:	48 89 e5             	mov    %rsp,%rbp
  801aba:	48 83 ec 50          	sub    $0x50,%rsp
  801abe:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801ac2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801ac6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801aca:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801ace:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801ad2:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801ad9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801add:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ae1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801ae5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801ae9:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801aed:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  801af4:	00 00 00 
  801af7:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

0000000000801afb <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801afb:	55                   	push   %rbp
  801afc:	48 89 e5             	mov    %rsp,%rbp
  801aff:	41 57                	push   %r15
  801b01:	41 56                	push   %r14
  801b03:	41 55                	push   %r13
  801b05:	41 54                	push   %r12
  801b07:	53                   	push   %rbx
  801b08:	48 83 ec 18          	sub    $0x18,%rsp
  801b0c:	49 89 fc             	mov    %rdi,%r12
  801b0f:	49 89 f5             	mov    %rsi,%r13
  801b12:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801b16:	8b 45 10             	mov    0x10(%rbp),%eax
  801b19:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801b1c:	41 89 cf             	mov    %ecx,%r15d
  801b1f:	49 39 d7             	cmp    %rdx,%r15
  801b22:	76 5b                	jbe    801b7f <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801b24:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801b28:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801b2c:	85 db                	test   %ebx,%ebx
  801b2e:	7e 0e                	jle    801b3e <print_num+0x43>
            putch(padc, put_arg);
  801b30:	4c 89 ee             	mov    %r13,%rsi
  801b33:	44 89 f7             	mov    %r14d,%edi
  801b36:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801b39:	83 eb 01             	sub    $0x1,%ebx
  801b3c:	75 f2                	jne    801b30 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801b3e:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801b42:	48 b9 43 2b 80 00 00 	movabs $0x802b43,%rcx
  801b49:	00 00 00 
  801b4c:	48 b8 54 2b 80 00 00 	movabs $0x802b54,%rax
  801b53:	00 00 00 
  801b56:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801b5a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b63:	49 f7 f7             	div    %r15
  801b66:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801b6a:	4c 89 ee             	mov    %r13,%rsi
  801b6d:	41 ff d4             	call   *%r12
}
  801b70:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801b74:	5b                   	pop    %rbx
  801b75:	41 5c                	pop    %r12
  801b77:	41 5d                	pop    %r13
  801b79:	41 5e                	pop    %r14
  801b7b:	41 5f                	pop    %r15
  801b7d:	5d                   	pop    %rbp
  801b7e:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801b7f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b83:	ba 00 00 00 00       	mov    $0x0,%edx
  801b88:	49 f7 f7             	div    %r15
  801b8b:	48 83 ec 08          	sub    $0x8,%rsp
  801b8f:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801b93:	52                   	push   %rdx
  801b94:	45 0f be c9          	movsbl %r9b,%r9d
  801b98:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801b9c:	48 89 c2             	mov    %rax,%rdx
  801b9f:	48 b8 fb 1a 80 00 00 	movabs $0x801afb,%rax
  801ba6:	00 00 00 
  801ba9:	ff d0                	call   *%rax
  801bab:	48 83 c4 10          	add    $0x10,%rsp
  801baf:	eb 8d                	jmp    801b3e <print_num+0x43>

0000000000801bb1 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  801bb1:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801bb5:	48 8b 06             	mov    (%rsi),%rax
  801bb8:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801bbc:	73 0a                	jae    801bc8 <sprintputch+0x17>
        *state->start++ = ch;
  801bbe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bc2:	48 89 16             	mov    %rdx,(%rsi)
  801bc5:	40 88 38             	mov    %dil,(%rax)
    }
}
  801bc8:	c3                   	ret    

0000000000801bc9 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801bc9:	55                   	push   %rbp
  801bca:	48 89 e5             	mov    %rsp,%rbp
  801bcd:	48 83 ec 50          	sub    $0x50,%rsp
  801bd1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bd5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801bd9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801bdd:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801be4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801be8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801bec:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801bf0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801bf4:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801bf8:	48 b8 06 1c 80 00 00 	movabs $0x801c06,%rax
  801bff:	00 00 00 
  801c02:	ff d0                	call   *%rax
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

0000000000801c06 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801c06:	55                   	push   %rbp
  801c07:	48 89 e5             	mov    %rsp,%rbp
  801c0a:	41 57                	push   %r15
  801c0c:	41 56                	push   %r14
  801c0e:	41 55                	push   %r13
  801c10:	41 54                	push   %r12
  801c12:	53                   	push   %rbx
  801c13:	48 83 ec 48          	sub    $0x48,%rsp
  801c17:	49 89 fc             	mov    %rdi,%r12
  801c1a:	49 89 f6             	mov    %rsi,%r14
  801c1d:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  801c20:	48 8b 01             	mov    (%rcx),%rax
  801c23:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801c27:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801c2b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801c2f:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801c33:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801c37:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  801c3b:	41 0f b6 3f          	movzbl (%r15),%edi
  801c3f:	40 80 ff 25          	cmp    $0x25,%dil
  801c43:	74 18                	je     801c5d <vprintfmt+0x57>
            if (!ch) return;
  801c45:	40 84 ff             	test   %dil,%dil
  801c48:	0f 84 d1 06 00 00    	je     80231f <vprintfmt+0x719>
            putch(ch, put_arg);
  801c4e:	40 0f b6 ff          	movzbl %dil,%edi
  801c52:	4c 89 f6             	mov    %r14,%rsi
  801c55:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  801c58:	49 89 df             	mov    %rbx,%r15
  801c5b:	eb da                	jmp    801c37 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  801c5d:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  801c61:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c66:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  801c6a:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801c6f:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801c75:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801c7c:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  801c80:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  801c85:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  801c8b:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  801c8f:	44 0f b6 0b          	movzbl (%rbx),%r9d
  801c93:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  801c97:	3c 57                	cmp    $0x57,%al
  801c99:	0f 87 65 06 00 00    	ja     802304 <vprintfmt+0x6fe>
  801c9f:	0f b6 c0             	movzbl %al,%eax
  801ca2:	49 ba e0 2c 80 00 00 	movabs $0x802ce0,%r10
  801ca9:	00 00 00 
  801cac:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  801cb0:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  801cb3:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  801cb7:	eb d2                	jmp    801c8b <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  801cb9:	4c 89 fb             	mov    %r15,%rbx
  801cbc:	44 89 c1             	mov    %r8d,%ecx
  801cbf:	eb ca                	jmp    801c8b <vprintfmt+0x85>
            padc = ch;
  801cc1:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  801cc5:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801cc8:	eb c1                	jmp    801c8b <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801ccd:	83 f8 2f             	cmp    $0x2f,%eax
  801cd0:	77 24                	ja     801cf6 <vprintfmt+0xf0>
  801cd2:	41 89 c1             	mov    %eax,%r9d
  801cd5:	49 01 f1             	add    %rsi,%r9
  801cd8:	83 c0 08             	add    $0x8,%eax
  801cdb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801cde:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  801ce1:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  801ce4:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801ce8:	79 a1                	jns    801c8b <vprintfmt+0x85>
                width = precision;
  801cea:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  801cee:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801cf4:	eb 95                	jmp    801c8b <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cf6:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  801cfa:	49 8d 41 08          	lea    0x8(%r9),%rax
  801cfe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d02:	eb da                	jmp    801cde <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  801d04:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  801d08:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d0c:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  801d10:	3c 39                	cmp    $0x39,%al
  801d12:	77 1e                	ja     801d32 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  801d14:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  801d18:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  801d1d:	0f b6 c0             	movzbl %al,%eax
  801d20:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d25:	41 0f b6 07          	movzbl (%r15),%eax
  801d29:	3c 39                	cmp    $0x39,%al
  801d2b:	76 e7                	jbe    801d14 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  801d2d:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  801d30:	eb b2                	jmp    801ce4 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  801d32:	4c 89 fb             	mov    %r15,%rbx
  801d35:	eb ad                	jmp    801ce4 <vprintfmt+0xde>
            width = MAX(0, width);
  801d37:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	0f 48 c7             	cmovs  %edi,%eax
  801d3f:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801d42:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d45:	e9 41 ff ff ff       	jmp    801c8b <vprintfmt+0x85>
            lflag++;
  801d4a:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801d4d:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d50:	e9 36 ff ff ff       	jmp    801c8b <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  801d55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d58:	83 f8 2f             	cmp    $0x2f,%eax
  801d5b:	77 18                	ja     801d75 <vprintfmt+0x16f>
  801d5d:	89 c2                	mov    %eax,%edx
  801d5f:	48 01 f2             	add    %rsi,%rdx
  801d62:	83 c0 08             	add    $0x8,%eax
  801d65:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d68:	4c 89 f6             	mov    %r14,%rsi
  801d6b:	8b 3a                	mov    (%rdx),%edi
  801d6d:	41 ff d4             	call   *%r12
            break;
  801d70:	e9 c2 fe ff ff       	jmp    801c37 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  801d75:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801d79:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801d7d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d81:	eb e5                	jmp    801d68 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  801d83:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d86:	83 f8 2f             	cmp    $0x2f,%eax
  801d89:	77 5b                	ja     801de6 <vprintfmt+0x1e0>
  801d8b:	89 c2                	mov    %eax,%edx
  801d8d:	48 01 d6             	add    %rdx,%rsi
  801d90:	83 c0 08             	add    $0x8,%eax
  801d93:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d96:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  801d98:	89 c8                	mov    %ecx,%eax
  801d9a:	c1 f8 1f             	sar    $0x1f,%eax
  801d9d:	31 c1                	xor    %eax,%ecx
  801d9f:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  801da1:	83 f9 13             	cmp    $0x13,%ecx
  801da4:	7f 4e                	jg     801df4 <vprintfmt+0x1ee>
  801da6:	48 63 c1             	movslq %ecx,%rax
  801da9:	48 ba a0 2f 80 00 00 	movabs $0x802fa0,%rdx
  801db0:	00 00 00 
  801db3:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801db7:	48 85 c0             	test   %rax,%rax
  801dba:	74 38                	je     801df4 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  801dbc:	48 89 c1             	mov    %rax,%rcx
  801dbf:	48 ba d9 2a 80 00 00 	movabs $0x802ad9,%rdx
  801dc6:	00 00 00 
  801dc9:	4c 89 f6             	mov    %r14,%rsi
  801dcc:	4c 89 e7             	mov    %r12,%rdi
  801dcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd4:	49 b8 c9 1b 80 00 00 	movabs $0x801bc9,%r8
  801ddb:	00 00 00 
  801dde:	41 ff d0             	call   *%r8
  801de1:	e9 51 fe ff ff       	jmp    801c37 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  801de6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801dea:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801dee:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801df2:	eb a2                	jmp    801d96 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  801df4:	48 ba 6c 2b 80 00 00 	movabs $0x802b6c,%rdx
  801dfb:	00 00 00 
  801dfe:	4c 89 f6             	mov    %r14,%rsi
  801e01:	4c 89 e7             	mov    %r12,%rdi
  801e04:	b8 00 00 00 00       	mov    $0x0,%eax
  801e09:	49 b8 c9 1b 80 00 00 	movabs $0x801bc9,%r8
  801e10:	00 00 00 
  801e13:	41 ff d0             	call   *%r8
  801e16:	e9 1c fe ff ff       	jmp    801c37 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  801e1b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801e1e:	83 f8 2f             	cmp    $0x2f,%eax
  801e21:	77 55                	ja     801e78 <vprintfmt+0x272>
  801e23:	89 c2                	mov    %eax,%edx
  801e25:	48 01 d6             	add    %rdx,%rsi
  801e28:	83 c0 08             	add    $0x8,%eax
  801e2b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801e2e:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  801e31:	48 85 d2             	test   %rdx,%rdx
  801e34:	48 b8 65 2b 80 00 00 	movabs $0x802b65,%rax
  801e3b:	00 00 00 
  801e3e:	48 0f 45 c2          	cmovne %rdx,%rax
  801e42:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  801e46:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801e4a:	7e 06                	jle    801e52 <vprintfmt+0x24c>
  801e4c:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  801e50:	75 34                	jne    801e86 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801e52:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  801e56:	48 8d 58 01          	lea    0x1(%rax),%rbx
  801e5a:	0f b6 00             	movzbl (%rax),%eax
  801e5d:	84 c0                	test   %al,%al
  801e5f:	0f 84 b2 00 00 00    	je     801f17 <vprintfmt+0x311>
  801e65:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  801e69:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  801e6e:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  801e72:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  801e76:	eb 74                	jmp    801eec <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  801e78:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801e7c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801e80:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e84:	eb a8                	jmp    801e2e <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  801e86:	49 63 f5             	movslq %r13d,%rsi
  801e89:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  801e8d:	48 b8 d9 23 80 00 00 	movabs $0x8023d9,%rax
  801e94:	00 00 00 
  801e97:	ff d0                	call   *%rax
  801e99:	48 89 c2             	mov    %rax,%rdx
  801e9c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801e9f:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  801ea1:	8d 48 ff             	lea    -0x1(%rax),%ecx
  801ea4:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	7e a7                	jle    801e52 <vprintfmt+0x24c>
  801eab:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  801eaf:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  801eb3:	41 89 cd             	mov    %ecx,%r13d
  801eb6:	4c 89 f6             	mov    %r14,%rsi
  801eb9:	89 df                	mov    %ebx,%edi
  801ebb:	41 ff d4             	call   *%r12
  801ebe:	41 83 ed 01          	sub    $0x1,%r13d
  801ec2:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  801ec6:	75 ee                	jne    801eb6 <vprintfmt+0x2b0>
  801ec8:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  801ecc:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  801ed0:	eb 80                	jmp    801e52 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801ed2:	0f b6 f8             	movzbl %al,%edi
  801ed5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801ed9:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801edc:	41 83 ef 01          	sub    $0x1,%r15d
  801ee0:	48 83 c3 01          	add    $0x1,%rbx
  801ee4:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  801ee8:	84 c0                	test   %al,%al
  801eea:	74 1f                	je     801f0b <vprintfmt+0x305>
  801eec:	45 85 ed             	test   %r13d,%r13d
  801eef:	78 06                	js     801ef7 <vprintfmt+0x2f1>
  801ef1:	41 83 ed 01          	sub    $0x1,%r13d
  801ef5:	78 46                	js     801f3d <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801ef7:	45 84 f6             	test   %r14b,%r14b
  801efa:	74 d6                	je     801ed2 <vprintfmt+0x2cc>
  801efc:	8d 50 e0             	lea    -0x20(%rax),%edx
  801eff:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801f04:	80 fa 5e             	cmp    $0x5e,%dl
  801f07:	77 cc                	ja     801ed5 <vprintfmt+0x2cf>
  801f09:	eb c7                	jmp    801ed2 <vprintfmt+0x2cc>
  801f0b:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f0f:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f13:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  801f17:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801f1a:	8d 58 ff             	lea    -0x1(%rax),%ebx
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	0f 8e 12 fd ff ff    	jle    801c37 <vprintfmt+0x31>
  801f25:	4c 89 f6             	mov    %r14,%rsi
  801f28:	bf 20 00 00 00       	mov    $0x20,%edi
  801f2d:	41 ff d4             	call   *%r12
  801f30:	83 eb 01             	sub    $0x1,%ebx
  801f33:	83 fb ff             	cmp    $0xffffffff,%ebx
  801f36:	75 ed                	jne    801f25 <vprintfmt+0x31f>
  801f38:	e9 fa fc ff ff       	jmp    801c37 <vprintfmt+0x31>
  801f3d:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f41:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f45:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  801f49:	eb cc                	jmp    801f17 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  801f4b:	45 89 cd             	mov    %r9d,%r13d
  801f4e:	84 c9                	test   %cl,%cl
  801f50:	75 25                	jne    801f77 <vprintfmt+0x371>
    switch (lflag) {
  801f52:	85 d2                	test   %edx,%edx
  801f54:	74 57                	je     801fad <vprintfmt+0x3a7>
  801f56:	83 fa 01             	cmp    $0x1,%edx
  801f59:	74 78                	je     801fd3 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  801f5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f5e:	83 f8 2f             	cmp    $0x2f,%eax
  801f61:	0f 87 92 00 00 00    	ja     801ff9 <vprintfmt+0x3f3>
  801f67:	89 c2                	mov    %eax,%edx
  801f69:	48 01 d6             	add    %rdx,%rsi
  801f6c:	83 c0 08             	add    $0x8,%eax
  801f6f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f72:	48 8b 1e             	mov    (%rsi),%rbx
  801f75:	eb 16                	jmp    801f8d <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  801f77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f7a:	83 f8 2f             	cmp    $0x2f,%eax
  801f7d:	77 20                	ja     801f9f <vprintfmt+0x399>
  801f7f:	89 c2                	mov    %eax,%edx
  801f81:	48 01 d6             	add    %rdx,%rsi
  801f84:	83 c0 08             	add    $0x8,%eax
  801f87:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f8a:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  801f8d:	48 85 db             	test   %rbx,%rbx
  801f90:	78 78                	js     80200a <vprintfmt+0x404>
            num = i;
  801f92:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  801f95:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  801f9a:	e9 49 02 00 00       	jmp    8021e8 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801f9f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fa3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fa7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fab:	eb dd                	jmp    801f8a <vprintfmt+0x384>
        return va_arg(*ap, int);
  801fad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fb0:	83 f8 2f             	cmp    $0x2f,%eax
  801fb3:	77 10                	ja     801fc5 <vprintfmt+0x3bf>
  801fb5:	89 c2                	mov    %eax,%edx
  801fb7:	48 01 d6             	add    %rdx,%rsi
  801fba:	83 c0 08             	add    $0x8,%eax
  801fbd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fc0:	48 63 1e             	movslq (%rsi),%rbx
  801fc3:	eb c8                	jmp    801f8d <vprintfmt+0x387>
  801fc5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fc9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fcd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fd1:	eb ed                	jmp    801fc0 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  801fd3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fd6:	83 f8 2f             	cmp    $0x2f,%eax
  801fd9:	77 10                	ja     801feb <vprintfmt+0x3e5>
  801fdb:	89 c2                	mov    %eax,%edx
  801fdd:	48 01 d6             	add    %rdx,%rsi
  801fe0:	83 c0 08             	add    $0x8,%eax
  801fe3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fe6:	48 8b 1e             	mov    (%rsi),%rbx
  801fe9:	eb a2                	jmp    801f8d <vprintfmt+0x387>
  801feb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fef:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801ff3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ff7:	eb ed                	jmp    801fe6 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  801ff9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801ffd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802001:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802005:	e9 68 ff ff ff       	jmp    801f72 <vprintfmt+0x36c>
                putch('-', put_arg);
  80200a:	4c 89 f6             	mov    %r14,%rsi
  80200d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802012:	41 ff d4             	call   *%r12
                i = -i;
  802015:	48 f7 db             	neg    %rbx
  802018:	e9 75 ff ff ff       	jmp    801f92 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  80201d:	45 89 cd             	mov    %r9d,%r13d
  802020:	84 c9                	test   %cl,%cl
  802022:	75 2d                	jne    802051 <vprintfmt+0x44b>
    switch (lflag) {
  802024:	85 d2                	test   %edx,%edx
  802026:	74 57                	je     80207f <vprintfmt+0x479>
  802028:	83 fa 01             	cmp    $0x1,%edx
  80202b:	74 7f                	je     8020ac <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  80202d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802030:	83 f8 2f             	cmp    $0x2f,%eax
  802033:	0f 87 a1 00 00 00    	ja     8020da <vprintfmt+0x4d4>
  802039:	89 c2                	mov    %eax,%edx
  80203b:	48 01 d6             	add    %rdx,%rsi
  80203e:	83 c0 08             	add    $0x8,%eax
  802041:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802044:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802047:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80204c:	e9 97 01 00 00       	jmp    8021e8 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802051:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802054:	83 f8 2f             	cmp    $0x2f,%eax
  802057:	77 18                	ja     802071 <vprintfmt+0x46b>
  802059:	89 c2                	mov    %eax,%edx
  80205b:	48 01 d6             	add    %rdx,%rsi
  80205e:	83 c0 08             	add    $0x8,%eax
  802061:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802064:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802067:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80206c:	e9 77 01 00 00       	jmp    8021e8 <vprintfmt+0x5e2>
  802071:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802075:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802079:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80207d:	eb e5                	jmp    802064 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  80207f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802082:	83 f8 2f             	cmp    $0x2f,%eax
  802085:	77 17                	ja     80209e <vprintfmt+0x498>
  802087:	89 c2                	mov    %eax,%edx
  802089:	48 01 d6             	add    %rdx,%rsi
  80208c:	83 c0 08             	add    $0x8,%eax
  80208f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802092:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  802094:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802099:	e9 4a 01 00 00       	jmp    8021e8 <vprintfmt+0x5e2>
  80209e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020a2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020a6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020aa:	eb e6                	jmp    802092 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8020ac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020af:	83 f8 2f             	cmp    $0x2f,%eax
  8020b2:	77 18                	ja     8020cc <vprintfmt+0x4c6>
  8020b4:	89 c2                	mov    %eax,%edx
  8020b6:	48 01 d6             	add    %rdx,%rsi
  8020b9:	83 c0 08             	add    $0x8,%eax
  8020bc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020bf:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8020c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8020c7:	e9 1c 01 00 00       	jmp    8021e8 <vprintfmt+0x5e2>
  8020cc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020d0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020d4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020d8:	eb e5                	jmp    8020bf <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8020da:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020de:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020e2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020e6:	e9 59 ff ff ff       	jmp    802044 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8020eb:	45 89 cd             	mov    %r9d,%r13d
  8020ee:	84 c9                	test   %cl,%cl
  8020f0:	75 2d                	jne    80211f <vprintfmt+0x519>
    switch (lflag) {
  8020f2:	85 d2                	test   %edx,%edx
  8020f4:	74 57                	je     80214d <vprintfmt+0x547>
  8020f6:	83 fa 01             	cmp    $0x1,%edx
  8020f9:	74 7c                	je     802177 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8020fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020fe:	83 f8 2f             	cmp    $0x2f,%eax
  802101:	0f 87 9b 00 00 00    	ja     8021a2 <vprintfmt+0x59c>
  802107:	89 c2                	mov    %eax,%edx
  802109:	48 01 d6             	add    %rdx,%rsi
  80210c:	83 c0 08             	add    $0x8,%eax
  80210f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802112:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802115:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80211a:	e9 c9 00 00 00       	jmp    8021e8 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80211f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802122:	83 f8 2f             	cmp    $0x2f,%eax
  802125:	77 18                	ja     80213f <vprintfmt+0x539>
  802127:	89 c2                	mov    %eax,%edx
  802129:	48 01 d6             	add    %rdx,%rsi
  80212c:	83 c0 08             	add    $0x8,%eax
  80212f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802132:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802135:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80213a:	e9 a9 00 00 00       	jmp    8021e8 <vprintfmt+0x5e2>
  80213f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802143:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802147:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80214b:	eb e5                	jmp    802132 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  80214d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802150:	83 f8 2f             	cmp    $0x2f,%eax
  802153:	77 14                	ja     802169 <vprintfmt+0x563>
  802155:	89 c2                	mov    %eax,%edx
  802157:	48 01 d6             	add    %rdx,%rsi
  80215a:	83 c0 08             	add    $0x8,%eax
  80215d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802160:	8b 16                	mov    (%rsi),%edx
            base = 8;
  802162:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  802167:	eb 7f                	jmp    8021e8 <vprintfmt+0x5e2>
  802169:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80216d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802171:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802175:	eb e9                	jmp    802160 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  802177:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80217a:	83 f8 2f             	cmp    $0x2f,%eax
  80217d:	77 15                	ja     802194 <vprintfmt+0x58e>
  80217f:	89 c2                	mov    %eax,%edx
  802181:	48 01 d6             	add    %rdx,%rsi
  802184:	83 c0 08             	add    $0x8,%eax
  802187:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80218a:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80218d:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  802192:	eb 54                	jmp    8021e8 <vprintfmt+0x5e2>
  802194:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802198:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80219c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8021a0:	eb e8                	jmp    80218a <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8021a2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8021a6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8021aa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8021ae:	e9 5f ff ff ff       	jmp    802112 <vprintfmt+0x50c>
            putch('0', put_arg);
  8021b3:	45 89 cd             	mov    %r9d,%r13d
  8021b6:	4c 89 f6             	mov    %r14,%rsi
  8021b9:	bf 30 00 00 00       	mov    $0x30,%edi
  8021be:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8021c1:	4c 89 f6             	mov    %r14,%rsi
  8021c4:	bf 78 00 00 00       	mov    $0x78,%edi
  8021c9:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8021cc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021cf:	83 f8 2f             	cmp    $0x2f,%eax
  8021d2:	77 47                	ja     80221b <vprintfmt+0x615>
  8021d4:	89 c2                	mov    %eax,%edx
  8021d6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021da:	83 c0 08             	add    $0x8,%eax
  8021dd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021e0:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8021e3:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8021e8:	48 83 ec 08          	sub    $0x8,%rsp
  8021ec:	41 80 fd 58          	cmp    $0x58,%r13b
  8021f0:	0f 94 c0             	sete   %al
  8021f3:	0f b6 c0             	movzbl %al,%eax
  8021f6:	50                   	push   %rax
  8021f7:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  8021fc:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  802200:	4c 89 f6             	mov    %r14,%rsi
  802203:	4c 89 e7             	mov    %r12,%rdi
  802206:	48 b8 fb 1a 80 00 00 	movabs $0x801afb,%rax
  80220d:	00 00 00 
  802210:	ff d0                	call   *%rax
            break;
  802212:	48 83 c4 10          	add    $0x10,%rsp
  802216:	e9 1c fa ff ff       	jmp    801c37 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  80221b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80221f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802223:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802227:	eb b7                	jmp    8021e0 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  802229:	45 89 cd             	mov    %r9d,%r13d
  80222c:	84 c9                	test   %cl,%cl
  80222e:	75 2a                	jne    80225a <vprintfmt+0x654>
    switch (lflag) {
  802230:	85 d2                	test   %edx,%edx
  802232:	74 54                	je     802288 <vprintfmt+0x682>
  802234:	83 fa 01             	cmp    $0x1,%edx
  802237:	74 7c                	je     8022b5 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  802239:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80223c:	83 f8 2f             	cmp    $0x2f,%eax
  80223f:	0f 87 9e 00 00 00    	ja     8022e3 <vprintfmt+0x6dd>
  802245:	89 c2                	mov    %eax,%edx
  802247:	48 01 d6             	add    %rdx,%rsi
  80224a:	83 c0 08             	add    $0x8,%eax
  80224d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802250:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802253:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  802258:	eb 8e                	jmp    8021e8 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80225a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80225d:	83 f8 2f             	cmp    $0x2f,%eax
  802260:	77 18                	ja     80227a <vprintfmt+0x674>
  802262:	89 c2                	mov    %eax,%edx
  802264:	48 01 d6             	add    %rdx,%rsi
  802267:	83 c0 08             	add    $0x8,%eax
  80226a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80226d:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802270:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802275:	e9 6e ff ff ff       	jmp    8021e8 <vprintfmt+0x5e2>
  80227a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80227e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802282:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802286:	eb e5                	jmp    80226d <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  802288:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80228b:	83 f8 2f             	cmp    $0x2f,%eax
  80228e:	77 17                	ja     8022a7 <vprintfmt+0x6a1>
  802290:	89 c2                	mov    %eax,%edx
  802292:	48 01 d6             	add    %rdx,%rsi
  802295:	83 c0 08             	add    $0x8,%eax
  802298:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80229b:	8b 16                	mov    (%rsi),%edx
            base = 16;
  80229d:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8022a2:	e9 41 ff ff ff       	jmp    8021e8 <vprintfmt+0x5e2>
  8022a7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022ab:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022af:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022b3:	eb e6                	jmp    80229b <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8022b5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022b8:	83 f8 2f             	cmp    $0x2f,%eax
  8022bb:	77 18                	ja     8022d5 <vprintfmt+0x6cf>
  8022bd:	89 c2                	mov    %eax,%edx
  8022bf:	48 01 d6             	add    %rdx,%rsi
  8022c2:	83 c0 08             	add    $0x8,%eax
  8022c5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022c8:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8022cb:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8022d0:	e9 13 ff ff ff       	jmp    8021e8 <vprintfmt+0x5e2>
  8022d5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022d9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022dd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022e1:	eb e5                	jmp    8022c8 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  8022e3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022e7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022eb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022ef:	e9 5c ff ff ff       	jmp    802250 <vprintfmt+0x64a>
            putch(ch, put_arg);
  8022f4:	4c 89 f6             	mov    %r14,%rsi
  8022f7:	bf 25 00 00 00       	mov    $0x25,%edi
  8022fc:	41 ff d4             	call   *%r12
            break;
  8022ff:	e9 33 f9 ff ff       	jmp    801c37 <vprintfmt+0x31>
            putch('%', put_arg);
  802304:	4c 89 f6             	mov    %r14,%rsi
  802307:	bf 25 00 00 00       	mov    $0x25,%edi
  80230c:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  80230f:	49 83 ef 01          	sub    $0x1,%r15
  802313:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  802318:	75 f5                	jne    80230f <vprintfmt+0x709>
  80231a:	e9 18 f9 ff ff       	jmp    801c37 <vprintfmt+0x31>
}
  80231f:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802323:	5b                   	pop    %rbx
  802324:	41 5c                	pop    %r12
  802326:	41 5d                	pop    %r13
  802328:	41 5e                	pop    %r14
  80232a:	41 5f                	pop    %r15
  80232c:	5d                   	pop    %rbp
  80232d:	c3                   	ret    

000000000080232e <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  80232e:	55                   	push   %rbp
  80232f:	48 89 e5             	mov    %rsp,%rbp
  802332:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  802336:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80233a:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  80233f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802343:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  80234a:	48 85 ff             	test   %rdi,%rdi
  80234d:	74 2b                	je     80237a <vsnprintf+0x4c>
  80234f:	48 85 f6             	test   %rsi,%rsi
  802352:	74 26                	je     80237a <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  802354:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802358:	48 bf b1 1b 80 00 00 	movabs $0x801bb1,%rdi
  80235f:	00 00 00 
  802362:	48 b8 06 1c 80 00 00 	movabs $0x801c06,%rax
  802369:	00 00 00 
  80236c:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  80236e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802372:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  802375:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  80237a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80237f:	eb f7                	jmp    802378 <vsnprintf+0x4a>

0000000000802381 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  802381:	55                   	push   %rbp
  802382:	48 89 e5             	mov    %rsp,%rbp
  802385:	48 83 ec 50          	sub    $0x50,%rsp
  802389:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80238d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802391:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802395:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80239c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8023a0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023a4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8023a8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  8023ac:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8023b0:	48 b8 2e 23 80 00 00 	movabs $0x80232e,%rax
  8023b7:	00 00 00 
  8023ba:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  8023bc:	c9                   	leave  
  8023bd:	c3                   	ret    

00000000008023be <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  8023be:	80 3f 00             	cmpb   $0x0,(%rdi)
  8023c1:	74 10                	je     8023d3 <strlen+0x15>
    size_t n = 0;
  8023c3:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8023c8:	48 83 c0 01          	add    $0x1,%rax
  8023cc:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023d0:	75 f6                	jne    8023c8 <strlen+0xa>
  8023d2:	c3                   	ret    
    size_t n = 0;
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  8023d8:	c3                   	ret    

00000000008023d9 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  8023d9:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  8023de:	48 85 f6             	test   %rsi,%rsi
  8023e1:	74 10                	je     8023f3 <strnlen+0x1a>
  8023e3:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023e7:	74 09                	je     8023f2 <strnlen+0x19>
  8023e9:	48 83 c0 01          	add    $0x1,%rax
  8023ed:	48 39 c6             	cmp    %rax,%rsi
  8023f0:	75 f1                	jne    8023e3 <strnlen+0xa>
    return n;
}
  8023f2:	c3                   	ret    
    size_t n = 0;
  8023f3:	48 89 f0             	mov    %rsi,%rax
  8023f6:	c3                   	ret    

00000000008023f7 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fc:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  802400:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  802403:	48 83 c0 01          	add    $0x1,%rax
  802407:	84 d2                	test   %dl,%dl
  802409:	75 f1                	jne    8023fc <strcpy+0x5>
        ;
    return res;
}
  80240b:	48 89 f8             	mov    %rdi,%rax
  80240e:	c3                   	ret    

000000000080240f <strcat>:

char *
strcat(char *dst, const char *src) {
  80240f:	55                   	push   %rbp
  802410:	48 89 e5             	mov    %rsp,%rbp
  802413:	41 54                	push   %r12
  802415:	53                   	push   %rbx
  802416:	48 89 fb             	mov    %rdi,%rbx
  802419:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  80241c:	48 b8 be 23 80 00 00 	movabs $0x8023be,%rax
  802423:	00 00 00 
  802426:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  802428:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  80242c:	4c 89 e6             	mov    %r12,%rsi
  80242f:	48 b8 f7 23 80 00 00 	movabs $0x8023f7,%rax
  802436:	00 00 00 
  802439:	ff d0                	call   *%rax
    return dst;
}
  80243b:	48 89 d8             	mov    %rbx,%rax
  80243e:	5b                   	pop    %rbx
  80243f:	41 5c                	pop    %r12
  802441:	5d                   	pop    %rbp
  802442:	c3                   	ret    

0000000000802443 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  802443:	48 85 d2             	test   %rdx,%rdx
  802446:	74 1d                	je     802465 <strncpy+0x22>
  802448:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80244c:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  80244f:	48 83 c0 01          	add    $0x1,%rax
  802453:	0f b6 16             	movzbl (%rsi),%edx
  802456:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  802459:	80 fa 01             	cmp    $0x1,%dl
  80245c:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  802460:	48 39 c1             	cmp    %rax,%rcx
  802463:	75 ea                	jne    80244f <strncpy+0xc>
    }
    return ret;
}
  802465:	48 89 f8             	mov    %rdi,%rax
  802468:	c3                   	ret    

0000000000802469 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  802469:	48 89 f8             	mov    %rdi,%rax
  80246c:	48 85 d2             	test   %rdx,%rdx
  80246f:	74 24                	je     802495 <strlcpy+0x2c>
        while (--size > 0 && *src)
  802471:	48 83 ea 01          	sub    $0x1,%rdx
  802475:	74 1b                	je     802492 <strlcpy+0x29>
  802477:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80247b:	0f b6 16             	movzbl (%rsi),%edx
  80247e:	84 d2                	test   %dl,%dl
  802480:	74 10                	je     802492 <strlcpy+0x29>
            *dst++ = *src++;
  802482:	48 83 c6 01          	add    $0x1,%rsi
  802486:	48 83 c0 01          	add    $0x1,%rax
  80248a:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80248d:	48 39 c8             	cmp    %rcx,%rax
  802490:	75 e9                	jne    80247b <strlcpy+0x12>
        *dst = '\0';
  802492:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802495:	48 29 f8             	sub    %rdi,%rax
}
  802498:	c3                   	ret    

0000000000802499 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  802499:	0f b6 07             	movzbl (%rdi),%eax
  80249c:	84 c0                	test   %al,%al
  80249e:	74 13                	je     8024b3 <strcmp+0x1a>
  8024a0:	38 06                	cmp    %al,(%rsi)
  8024a2:	75 0f                	jne    8024b3 <strcmp+0x1a>
  8024a4:	48 83 c7 01          	add    $0x1,%rdi
  8024a8:	48 83 c6 01          	add    $0x1,%rsi
  8024ac:	0f b6 07             	movzbl (%rdi),%eax
  8024af:	84 c0                	test   %al,%al
  8024b1:	75 ed                	jne    8024a0 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8024b3:	0f b6 c0             	movzbl %al,%eax
  8024b6:	0f b6 16             	movzbl (%rsi),%edx
  8024b9:	29 d0                	sub    %edx,%eax
}
  8024bb:	c3                   	ret    

00000000008024bc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  8024bc:	48 85 d2             	test   %rdx,%rdx
  8024bf:	74 1f                	je     8024e0 <strncmp+0x24>
  8024c1:	0f b6 07             	movzbl (%rdi),%eax
  8024c4:	84 c0                	test   %al,%al
  8024c6:	74 1e                	je     8024e6 <strncmp+0x2a>
  8024c8:	3a 06                	cmp    (%rsi),%al
  8024ca:	75 1a                	jne    8024e6 <strncmp+0x2a>
  8024cc:	48 83 c7 01          	add    $0x1,%rdi
  8024d0:	48 83 c6 01          	add    $0x1,%rsi
  8024d4:	48 83 ea 01          	sub    $0x1,%rdx
  8024d8:	75 e7                	jne    8024c1 <strncmp+0x5>

    if (!n) return 0;
  8024da:	b8 00 00 00 00       	mov    $0x0,%eax
  8024df:	c3                   	ret    
  8024e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e5:	c3                   	ret    
  8024e6:	48 85 d2             	test   %rdx,%rdx
  8024e9:	74 09                	je     8024f4 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  8024eb:	0f b6 07             	movzbl (%rdi),%eax
  8024ee:	0f b6 16             	movzbl (%rsi),%edx
  8024f1:	29 d0                	sub    %edx,%eax
  8024f3:	c3                   	ret    
    if (!n) return 0;
  8024f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f9:	c3                   	ret    

00000000008024fa <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  8024fa:	0f b6 07             	movzbl (%rdi),%eax
  8024fd:	84 c0                	test   %al,%al
  8024ff:	74 18                	je     802519 <strchr+0x1f>
        if (*str == c) {
  802501:	0f be c0             	movsbl %al,%eax
  802504:	39 f0                	cmp    %esi,%eax
  802506:	74 17                	je     80251f <strchr+0x25>
    for (; *str; str++) {
  802508:	48 83 c7 01          	add    $0x1,%rdi
  80250c:	0f b6 07             	movzbl (%rdi),%eax
  80250f:	84 c0                	test   %al,%al
  802511:	75 ee                	jne    802501 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  802513:	b8 00 00 00 00       	mov    $0x0,%eax
  802518:	c3                   	ret    
  802519:	b8 00 00 00 00       	mov    $0x0,%eax
  80251e:	c3                   	ret    
  80251f:	48 89 f8             	mov    %rdi,%rax
}
  802522:	c3                   	ret    

0000000000802523 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  802523:	0f b6 07             	movzbl (%rdi),%eax
  802526:	84 c0                	test   %al,%al
  802528:	74 16                	je     802540 <strfind+0x1d>
  80252a:	0f be c0             	movsbl %al,%eax
  80252d:	39 f0                	cmp    %esi,%eax
  80252f:	74 13                	je     802544 <strfind+0x21>
  802531:	48 83 c7 01          	add    $0x1,%rdi
  802535:	0f b6 07             	movzbl (%rdi),%eax
  802538:	84 c0                	test   %al,%al
  80253a:	75 ee                	jne    80252a <strfind+0x7>
  80253c:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  80253f:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  802540:	48 89 f8             	mov    %rdi,%rax
  802543:	c3                   	ret    
  802544:	48 89 f8             	mov    %rdi,%rax
  802547:	c3                   	ret    

0000000000802548 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  802548:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80254b:	48 89 f8             	mov    %rdi,%rax
  80254e:	48 f7 d8             	neg    %rax
  802551:	83 e0 07             	and    $0x7,%eax
  802554:	49 89 d1             	mov    %rdx,%r9
  802557:	49 29 c1             	sub    %rax,%r9
  80255a:	78 32                	js     80258e <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80255c:	40 0f b6 c6          	movzbl %sil,%eax
  802560:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  802567:	01 01 01 
  80256a:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80256e:	40 f6 c7 07          	test   $0x7,%dil
  802572:	75 34                	jne    8025a8 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  802574:	4c 89 c9             	mov    %r9,%rcx
  802577:	48 c1 f9 03          	sar    $0x3,%rcx
  80257b:	74 08                	je     802585 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80257d:	fc                   	cld    
  80257e:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802581:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802585:	4d 85 c9             	test   %r9,%r9
  802588:	75 45                	jne    8025cf <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80258a:	4c 89 c0             	mov    %r8,%rax
  80258d:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  80258e:	48 85 d2             	test   %rdx,%rdx
  802591:	74 f7                	je     80258a <memset+0x42>
  802593:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  802596:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  802599:	48 83 c0 01          	add    $0x1,%rax
  80259d:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8025a1:	48 39 c2             	cmp    %rax,%rdx
  8025a4:	75 f3                	jne    802599 <memset+0x51>
  8025a6:	eb e2                	jmp    80258a <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8025a8:	40 f6 c7 01          	test   $0x1,%dil
  8025ac:	74 06                	je     8025b4 <memset+0x6c>
  8025ae:	88 07                	mov    %al,(%rdi)
  8025b0:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025b4:	40 f6 c7 02          	test   $0x2,%dil
  8025b8:	74 07                	je     8025c1 <memset+0x79>
  8025ba:	66 89 07             	mov    %ax,(%rdi)
  8025bd:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025c1:	40 f6 c7 04          	test   $0x4,%dil
  8025c5:	74 ad                	je     802574 <memset+0x2c>
  8025c7:	89 07                	mov    %eax,(%rdi)
  8025c9:	48 83 c7 04          	add    $0x4,%rdi
  8025cd:	eb a5                	jmp    802574 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025cf:	41 f6 c1 04          	test   $0x4,%r9b
  8025d3:	74 06                	je     8025db <memset+0x93>
  8025d5:	89 07                	mov    %eax,(%rdi)
  8025d7:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025db:	41 f6 c1 02          	test   $0x2,%r9b
  8025df:	74 07                	je     8025e8 <memset+0xa0>
  8025e1:	66 89 07             	mov    %ax,(%rdi)
  8025e4:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8025e8:	41 f6 c1 01          	test   $0x1,%r9b
  8025ec:	74 9c                	je     80258a <memset+0x42>
  8025ee:	88 07                	mov    %al,(%rdi)
  8025f0:	eb 98                	jmp    80258a <memset+0x42>

00000000008025f2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8025f2:	48 89 f8             	mov    %rdi,%rax
  8025f5:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8025f8:	48 39 fe             	cmp    %rdi,%rsi
  8025fb:	73 39                	jae    802636 <memmove+0x44>
  8025fd:	48 01 f2             	add    %rsi,%rdx
  802600:	48 39 fa             	cmp    %rdi,%rdx
  802603:	76 31                	jbe    802636 <memmove+0x44>
        s += n;
        d += n;
  802605:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802608:	48 89 d6             	mov    %rdx,%rsi
  80260b:	48 09 fe             	or     %rdi,%rsi
  80260e:	48 09 ce             	or     %rcx,%rsi
  802611:	40 f6 c6 07          	test   $0x7,%sil
  802615:	75 12                	jne    802629 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  802617:	48 83 ef 08          	sub    $0x8,%rdi
  80261b:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  80261f:	48 c1 e9 03          	shr    $0x3,%rcx
  802623:	fd                   	std    
  802624:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  802627:	fc                   	cld    
  802628:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  802629:	48 83 ef 01          	sub    $0x1,%rdi
  80262d:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  802631:	fd                   	std    
  802632:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  802634:	eb f1                	jmp    802627 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802636:	48 89 f2             	mov    %rsi,%rdx
  802639:	48 09 c2             	or     %rax,%rdx
  80263c:	48 09 ca             	or     %rcx,%rdx
  80263f:	f6 c2 07             	test   $0x7,%dl
  802642:	75 0c                	jne    802650 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  802644:	48 c1 e9 03          	shr    $0x3,%rcx
  802648:	48 89 c7             	mov    %rax,%rdi
  80264b:	fc                   	cld    
  80264c:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80264f:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  802650:	48 89 c7             	mov    %rax,%rdi
  802653:	fc                   	cld    
  802654:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  802656:	c3                   	ret    

0000000000802657 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  802657:	55                   	push   %rbp
  802658:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80265b:	48 b8 f2 25 80 00 00 	movabs $0x8025f2,%rax
  802662:	00 00 00 
  802665:	ff d0                	call   *%rax
}
  802667:	5d                   	pop    %rbp
  802668:	c3                   	ret    

0000000000802669 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802669:	55                   	push   %rbp
  80266a:	48 89 e5             	mov    %rsp,%rbp
  80266d:	41 57                	push   %r15
  80266f:	41 56                	push   %r14
  802671:	41 55                	push   %r13
  802673:	41 54                	push   %r12
  802675:	53                   	push   %rbx
  802676:	48 83 ec 08          	sub    $0x8,%rsp
  80267a:	49 89 fe             	mov    %rdi,%r14
  80267d:	49 89 f7             	mov    %rsi,%r15
  802680:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  802683:	48 89 f7             	mov    %rsi,%rdi
  802686:	48 b8 be 23 80 00 00 	movabs $0x8023be,%rax
  80268d:	00 00 00 
  802690:	ff d0                	call   *%rax
  802692:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  802695:	48 89 de             	mov    %rbx,%rsi
  802698:	4c 89 f7             	mov    %r14,%rdi
  80269b:	48 b8 d9 23 80 00 00 	movabs $0x8023d9,%rax
  8026a2:	00 00 00 
  8026a5:	ff d0                	call   *%rax
  8026a7:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8026aa:	48 39 c3             	cmp    %rax,%rbx
  8026ad:	74 36                	je     8026e5 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  8026af:	48 89 d8             	mov    %rbx,%rax
  8026b2:	4c 29 e8             	sub    %r13,%rax
  8026b5:	4c 39 e0             	cmp    %r12,%rax
  8026b8:	76 30                	jbe    8026ea <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  8026ba:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8026bf:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026c3:	4c 89 fe             	mov    %r15,%rsi
  8026c6:	48 b8 57 26 80 00 00 	movabs $0x802657,%rax
  8026cd:	00 00 00 
  8026d0:	ff d0                	call   *%rax
    return dstlen + srclen;
  8026d2:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8026d6:	48 83 c4 08          	add    $0x8,%rsp
  8026da:	5b                   	pop    %rbx
  8026db:	41 5c                	pop    %r12
  8026dd:	41 5d                	pop    %r13
  8026df:	41 5e                	pop    %r14
  8026e1:	41 5f                	pop    %r15
  8026e3:	5d                   	pop    %rbp
  8026e4:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8026e5:	4c 01 e0             	add    %r12,%rax
  8026e8:	eb ec                	jmp    8026d6 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8026ea:	48 83 eb 01          	sub    $0x1,%rbx
  8026ee:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026f2:	48 89 da             	mov    %rbx,%rdx
  8026f5:	4c 89 fe             	mov    %r15,%rsi
  8026f8:	48 b8 57 26 80 00 00 	movabs $0x802657,%rax
  8026ff:	00 00 00 
  802702:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  802704:	49 01 de             	add    %rbx,%r14
  802707:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  80270c:	eb c4                	jmp    8026d2 <strlcat+0x69>

000000000080270e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  80270e:	49 89 f0             	mov    %rsi,%r8
  802711:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  802714:	48 85 d2             	test   %rdx,%rdx
  802717:	74 2a                	je     802743 <memcmp+0x35>
  802719:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  80271e:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  802722:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  802727:	38 ca                	cmp    %cl,%dl
  802729:	75 0f                	jne    80273a <memcmp+0x2c>
    while (n-- > 0) {
  80272b:	48 83 c0 01          	add    $0x1,%rax
  80272f:	48 39 c6             	cmp    %rax,%rsi
  802732:	75 ea                	jne    80271e <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  802734:	b8 00 00 00 00       	mov    $0x0,%eax
  802739:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  80273a:	0f b6 c2             	movzbl %dl,%eax
  80273d:	0f b6 c9             	movzbl %cl,%ecx
  802740:	29 c8                	sub    %ecx,%eax
  802742:	c3                   	ret    
    return 0;
  802743:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802748:	c3                   	ret    

0000000000802749 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  802749:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80274d:	48 39 c7             	cmp    %rax,%rdi
  802750:	73 0f                	jae    802761 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802752:	40 38 37             	cmp    %sil,(%rdi)
  802755:	74 0e                	je     802765 <memfind+0x1c>
    for (; src < end; src++) {
  802757:	48 83 c7 01          	add    $0x1,%rdi
  80275b:	48 39 f8             	cmp    %rdi,%rax
  80275e:	75 f2                	jne    802752 <memfind+0x9>
  802760:	c3                   	ret    
  802761:	48 89 f8             	mov    %rdi,%rax
  802764:	c3                   	ret    
  802765:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802768:	c3                   	ret    

0000000000802769 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802769:	49 89 f2             	mov    %rsi,%r10
  80276c:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80276f:	0f b6 37             	movzbl (%rdi),%esi
  802772:	40 80 fe 20          	cmp    $0x20,%sil
  802776:	74 06                	je     80277e <strtol+0x15>
  802778:	40 80 fe 09          	cmp    $0x9,%sil
  80277c:	75 13                	jne    802791 <strtol+0x28>
  80277e:	48 83 c7 01          	add    $0x1,%rdi
  802782:	0f b6 37             	movzbl (%rdi),%esi
  802785:	40 80 fe 20          	cmp    $0x20,%sil
  802789:	74 f3                	je     80277e <strtol+0x15>
  80278b:	40 80 fe 09          	cmp    $0x9,%sil
  80278f:	74 ed                	je     80277e <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802791:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802794:	83 e0 fd             	and    $0xfffffffd,%eax
  802797:	3c 01                	cmp    $0x1,%al
  802799:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80279d:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  8027a4:	75 11                	jne    8027b7 <strtol+0x4e>
  8027a6:	80 3f 30             	cmpb   $0x30,(%rdi)
  8027a9:	74 16                	je     8027c1 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8027ab:	45 85 c0             	test   %r8d,%r8d
  8027ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8027b3:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8027b7:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8027bc:	4d 63 c8             	movslq %r8d,%r9
  8027bf:	eb 38                	jmp    8027f9 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8027c1:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8027c5:	74 11                	je     8027d8 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8027c7:	45 85 c0             	test   %r8d,%r8d
  8027ca:	75 eb                	jne    8027b7 <strtol+0x4e>
        s++;
  8027cc:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8027d0:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8027d6:	eb df                	jmp    8027b7 <strtol+0x4e>
        s += 2;
  8027d8:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8027dc:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8027e2:	eb d3                	jmp    8027b7 <strtol+0x4e>
            dig -= '0';
  8027e4:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8027e7:	0f b6 c8             	movzbl %al,%ecx
  8027ea:	44 39 c1             	cmp    %r8d,%ecx
  8027ed:	7d 1f                	jge    80280e <strtol+0xa5>
        val = val * base + dig;
  8027ef:	49 0f af d1          	imul   %r9,%rdx
  8027f3:	0f b6 c0             	movzbl %al,%eax
  8027f6:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8027f9:	48 83 c7 01          	add    $0x1,%rdi
  8027fd:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  802801:	3c 39                	cmp    $0x39,%al
  802803:	76 df                	jbe    8027e4 <strtol+0x7b>
        else if (dig - 'a' < 27)
  802805:	3c 7b                	cmp    $0x7b,%al
  802807:	77 05                	ja     80280e <strtol+0xa5>
            dig -= 'a' - 10;
  802809:	83 e8 57             	sub    $0x57,%eax
  80280c:	eb d9                	jmp    8027e7 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  80280e:	4d 85 d2             	test   %r10,%r10
  802811:	74 03                	je     802816 <strtol+0xad>
  802813:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802816:	48 89 d0             	mov    %rdx,%rax
  802819:	48 f7 d8             	neg    %rax
  80281c:	40 80 fe 2d          	cmp    $0x2d,%sil
  802820:	48 0f 44 d0          	cmove  %rax,%rdx
}
  802824:	48 89 d0             	mov    %rdx,%rax
  802827:	c3                   	ret    

0000000000802828 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802828:	55                   	push   %rbp
  802829:	48 89 e5             	mov    %rsp,%rbp
  80282c:	41 54                	push   %r12
  80282e:	53                   	push   %rbx
  80282f:	48 89 fb             	mov    %rdi,%rbx
  802832:	48 89 f7             	mov    %rsi,%rdi
  802835:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802838:	48 85 f6             	test   %rsi,%rsi
  80283b:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802842:	00 00 00 
  802845:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802849:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  80284e:	48 85 d2             	test   %rdx,%rdx
  802851:	74 02                	je     802855 <ipc_recv+0x2d>
  802853:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802855:	48 63 f6             	movslq %esi,%rsi
  802858:	48 b8 3d 05 80 00 00 	movabs $0x80053d,%rax
  80285f:	00 00 00 
  802862:	ff d0                	call   *%rax

    if (res < 0) {
  802864:	85 c0                	test   %eax,%eax
  802866:	78 45                	js     8028ad <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802868:	48 85 db             	test   %rbx,%rbx
  80286b:	74 12                	je     80287f <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  80286d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802874:	00 00 00 
  802877:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80287d:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  80287f:	4d 85 e4             	test   %r12,%r12
  802882:	74 14                	je     802898 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802884:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80288b:	00 00 00 
  80288e:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802894:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802898:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80289f:	00 00 00 
  8028a2:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8028a8:	5b                   	pop    %rbx
  8028a9:	41 5c                	pop    %r12
  8028ab:	5d                   	pop    %rbp
  8028ac:	c3                   	ret    
        if (from_env_store)
  8028ad:	48 85 db             	test   %rbx,%rbx
  8028b0:	74 06                	je     8028b8 <ipc_recv+0x90>
            *from_env_store = 0;
  8028b2:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8028b8:	4d 85 e4             	test   %r12,%r12
  8028bb:	74 eb                	je     8028a8 <ipc_recv+0x80>
            *perm_store = 0;
  8028bd:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028c4:	00 
  8028c5:	eb e1                	jmp    8028a8 <ipc_recv+0x80>

00000000008028c7 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028c7:	55                   	push   %rbp
  8028c8:	48 89 e5             	mov    %rsp,%rbp
  8028cb:	41 57                	push   %r15
  8028cd:	41 56                	push   %r14
  8028cf:	41 55                	push   %r13
  8028d1:	41 54                	push   %r12
  8028d3:	53                   	push   %rbx
  8028d4:	48 83 ec 18          	sub    $0x18,%rsp
  8028d8:	41 89 fd             	mov    %edi,%r13d
  8028db:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028de:	48 89 d3             	mov    %rdx,%rbx
  8028e1:	49 89 cc             	mov    %rcx,%r12
  8028e4:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028e8:	48 85 d2             	test   %rdx,%rdx
  8028eb:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8028f2:	00 00 00 
  8028f5:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028f9:	49 be 11 05 80 00 00 	movabs $0x800511,%r14
  802900:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802903:	49 bf 14 02 80 00 00 	movabs $0x800214,%r15
  80290a:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  80290d:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802910:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802914:	4c 89 e1             	mov    %r12,%rcx
  802917:	48 89 da             	mov    %rbx,%rdx
  80291a:	44 89 ef             	mov    %r13d,%edi
  80291d:	41 ff d6             	call   *%r14
  802920:	85 c0                	test   %eax,%eax
  802922:	79 37                	jns    80295b <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802924:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802927:	75 05                	jne    80292e <ipc_send+0x67>
          sys_yield();
  802929:	41 ff d7             	call   *%r15
  80292c:	eb df                	jmp    80290d <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  80292e:	89 c1                	mov    %eax,%ecx
  802930:	48 ba 5f 30 80 00 00 	movabs $0x80305f,%rdx
  802937:	00 00 00 
  80293a:	be 46 00 00 00       	mov    $0x46,%esi
  80293f:	48 bf 72 30 80 00 00 	movabs $0x803072,%rdi
  802946:	00 00 00 
  802949:	b8 00 00 00 00       	mov    $0x0,%eax
  80294e:	49 b8 66 19 80 00 00 	movabs $0x801966,%r8
  802955:	00 00 00 
  802958:	41 ff d0             	call   *%r8
      }
}
  80295b:	48 83 c4 18          	add    $0x18,%rsp
  80295f:	5b                   	pop    %rbx
  802960:	41 5c                	pop    %r12
  802962:	41 5d                	pop    %r13
  802964:	41 5e                	pop    %r14
  802966:	41 5f                	pop    %r15
  802968:	5d                   	pop    %rbp
  802969:	c3                   	ret    

000000000080296a <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  80296a:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80296f:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802976:	00 00 00 
  802979:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80297d:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802981:	48 c1 e2 04          	shl    $0x4,%rdx
  802985:	48 01 ca             	add    %rcx,%rdx
  802988:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  80298e:	39 fa                	cmp    %edi,%edx
  802990:	74 12                	je     8029a4 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802992:	48 83 c0 01          	add    $0x1,%rax
  802996:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80299c:	75 db                	jne    802979 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  80299e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a3:	c3                   	ret    
            return envs[i].env_id;
  8029a4:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8029a8:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8029ac:	48 c1 e0 04          	shl    $0x4,%rax
  8029b0:	48 89 c2             	mov    %rax,%rdx
  8029b3:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8029ba:	00 00 00 
  8029bd:	48 01 d0             	add    %rdx,%rax
  8029c0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029c6:	c3                   	ret    
  8029c7:	90                   	nop

00000000008029c8 <__rodata_start>:
  8029c8:	68 65 6c 6c 6f       	push   $0x6f6c6c65
  8029cd:	2c 20                	sub    $0x20,%al
  8029cf:	77 6f                	ja     802a40 <__rodata_start+0x78>
  8029d1:	72 6c                	jb     802a3f <__rodata_start+0x77>
  8029d3:	64 0a 00             	or     %fs:(%rax),%al
  8029d6:	3c 75                	cmp    $0x75,%al
  8029d8:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029d9:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8029dd:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029de:	3e 00 73 79          	ds add %dh,0x79(%rbx)
  8029e2:	73 63                	jae    802a47 <__rodata_start+0x7f>
  8029e4:	61                   	(bad)  
  8029e5:	6c                   	insb   (%dx),%es:(%rdi)
  8029e6:	6c                   	insb   (%dx),%es:(%rdi)
  8029e7:	20 25 7a 64 20 72    	and    %ah,0x7220647a(%rip)        # 72a08e67 <__bss_end+0x72200e67>
  8029ed:	65 74 75             	gs je  802a65 <__rodata_start+0x9d>
  8029f0:	72 6e                	jb     802a60 <__rodata_start+0x98>
  8029f2:	65 64 20 25 7a 64 20 	gs and %ah,%fs:0x2820647a(%rip)        # 28a08e74 <__bss_end+0x28200e74>
  8029f9:	28 
  8029fa:	3e 20 30             	ds and %dh,(%rax)
  8029fd:	29 00                	sub    %eax,(%rax)
  8029ff:	6c                   	insb   (%dx),%es:(%rdi)
  802a00:	69 62 2f 73 79 73 63 	imul   $0x63737973,0x2f(%rdx),%esp
  802a07:	61                   	(bad)  
  802a08:	6c                   	insb   (%dx),%es:(%rdi)
  802a09:	6c                   	insb   (%dx),%es:(%rdi)
  802a0a:	2e 63 00             	cs movsxd (%rax),%eax
  802a0d:	0f 1f 00             	nopl   (%rax)
  802a10:	5b                   	pop    %rbx
  802a11:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a16:	20 75 6e             	and    %dh,0x6e(%rbp)
  802a19:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802a1d:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a1e:	20 64 65 76          	and    %ah,0x76(%rbp,%riz,2)
  802a22:	69 63 65 20 74 79 70 	imul   $0x70797420,0x65(%rbx),%esp
  802a29:	65 20 25 64 0a 00 00 	and    %ah,%gs:0xa64(%rip)        # 803494 <error_string+0x4f4>
  802a30:	5b                   	pop    %rbx
  802a31:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a36:	20 66 74             	and    %ah,0x74(%rsi)
  802a39:	72 75                	jb     802ab0 <devtab+0x10>
  802a3b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a3c:	63 61 74             	movsxd 0x74(%rcx),%esp
  802a3f:	65 20 25 64 20 2d 2d 	and    %ah,%gs:0x2d2d2064(%rip)        # 2dad4aaa <__bss_end+0x2d2ccaaa>
  802a46:	20 62 61             	and    %ah,0x61(%rdx)
  802a49:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a4d:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a51:	5b                   	pop    %rbx
  802a52:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a57:	20 72 65             	and    %dh,0x65(%rdx)
  802a5a:	61                   	(bad)  
  802a5b:	64 20 25 64 20 2d 2d 	and    %ah,%fs:0x2d2d2064(%rip)        # 2dad4ac6 <__bss_end+0x2d2ccac6>
  802a62:	20 62 61             	and    %ah,0x61(%rdx)
  802a65:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a69:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a6d:	5b                   	pop    %rbx
  802a6e:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a73:	20 77 72             	and    %dh,0x72(%rdi)
  802a76:	69 74 65 20 25 64 20 	imul   $0x2d206425,0x20(%rbp,%riz,2),%esi
  802a7d:	2d 
  802a7e:	2d 20 62 61 64       	sub    $0x64616220,%eax
  802a83:	20 6d 6f             	and    %ch,0x6f(%rbp)
  802a86:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802a91:	00 00 00 
  802a94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802a9b:	00 00 00 
  802a9e:	66 90                	xchg   %ax,%ax

0000000000802aa0 <devtab>:
  802aa0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  802ab0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  802ac0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  802ad0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  802ae0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  802af0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  802b00:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  802b10:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  802b20:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  802b30:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  802b40:	3a 20 00 30 31 32 33 34 35 36 37 38 39 41 42 43     : .0123456789ABC
  802b50:	44 45 46 00 30 31 32 33 34 35 36 37 38 39 61 62     DEF.0123456789ab
  802b60:	63 64 65 66 00 28 6e 75 6c 6c 29 00 65 72 72 6f     cdef.(null).erro
  802b70:	72 20 25 64 00 75 6e 73 70 65 63 69 66 69 65 64     r %d.unspecified
  802b80:	20 65 72 72 6f 72 00 62 61 64 20 65 6e 76 69 72      error.bad envir
  802b90:	6f 6e 6d 65 6e 74 00 69 6e 76 61 6c 69 64 20 70     onment.invalid p
  802ba0:	61 72 61 6d 65 74 65 72 00 6f 75 74 20 6f 66 20     arameter.out of 
  802bb0:	6d 65 6d 6f 72 79 00 6f 75 74 20 6f 66 20 65 6e     memory.out of en
  802bc0:	76 69 72 6f 6e 6d 65 6e 74 73 00 63 6f 72 72 75     vironments.corru
  802bd0:	70 74 65 64 20 64 65 62 75 67 20 69 6e 66 6f 00     pted debug info.
  802be0:	73 65 67 6d 65 6e 74 61 74 69 6f 6e 20 66 61 75     segmentation fau
  802bf0:	6c 74 00 69 6e 76 61 6c 69 64 20 45 4c 46 20 69     lt.invalid ELF i
  802c00:	6d 61 67 65 00 6e 6f 20 73 75 63 68 20 73 79 73     mage.no such sys
  802c10:	74 65 6d 20 63 61 6c 6c 00 65 6e 74 72 79 20 6e     tem call.entry n
  802c20:	6f 74 20 66 6f 75 6e 64 00 65 6e 76 20 69 73 20     ot found.env is 
  802c30:	6e 6f 74 20 72 65 63 76 69 6e 67 00 75 6e 65 78     not recving.unex
  802c40:	70 65 63 74 65 64 20 65 6e 64 20 6f 66 20 66 69     pected end of fi
  802c50:	6c 65 00 6e 6f 20 66 72 65 65 20 73 70 61 63 65     le.no free space
  802c60:	20 6f 6e 20 64 69 73 6b 00 74 6f 6f 20 6d 61 6e      on disk.too man
  802c70:	79 20 66 69 6c 65 73 20 61 72 65 20 6f 70 65 6e     y files are open
  802c80:	00 66 69 6c 65 20 6f 72 20 62 6c 6f 63 6b 20 6e     .file or block n
  802c90:	6f 74 20 66 6f 75 6e 64 00 69 6e 76 61 6c 69 64     ot found.invalid
  802ca0:	20 70 61 74 68 00 66 69 6c 65 20 61 6c 72 65 61      path.file alrea
  802cb0:	64 79 20 65 78 69 73 74 73 00 6f 70 65 72 61 74     dy exists.operat
  802cc0:	69 6f 6e 20 6e 6f 74 20 73 75 70 70 6f 72 74 65     ion not supporte
  802cd0:	64 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00     d.f...........@.
  802ce0:	b0 1c 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .........#......
  802cf0:	f4 22 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .".......#......
  802d00:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802d10:	04 23 80 00 00 00 00 00 ca 1c 80 00 00 00 00 00     .#..............
  802d20:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802d30:	c1 1c 80 00 00 00 00 00 37 1d 80 00 00 00 00 00     ........7.......
  802d40:	04 23 80 00 00 00 00 00 c1 1c 80 00 00 00 00 00     .#..............
  802d50:	04 1d 80 00 00 00 00 00 04 1d 80 00 00 00 00 00     ................
  802d60:	04 1d 80 00 00 00 00 00 04 1d 80 00 00 00 00 00     ................
  802d70:	04 1d 80 00 00 00 00 00 04 1d 80 00 00 00 00 00     ................
  802d80:	04 1d 80 00 00 00 00 00 04 1d 80 00 00 00 00 00     ................
  802d90:	04 1d 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .........#......
  802da0:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802db0:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802dc0:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802dd0:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802de0:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802df0:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802e00:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802e10:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802e20:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802e30:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802e40:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802e50:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802e60:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802e70:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802e80:	04 23 80 00 00 00 00 00 29 22 80 00 00 00 00 00     .#......)"......
  802e90:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802ea0:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802eb0:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802ec0:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802ed0:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802ee0:	55 1d 80 00 00 00 00 00 4b 1f 80 00 00 00 00 00     U.......K.......
  802ef0:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802f00:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802f10:	83 1d 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .........#......
  802f20:	04 23 80 00 00 00 00 00 4a 1d 80 00 00 00 00 00     .#......J.......
  802f30:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802f40:	eb 20 80 00 00 00 00 00 b3 21 80 00 00 00 00 00     . .......!......
  802f50:	04 23 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .#.......#......
  802f60:	1b 1e 80 00 00 00 00 00 04 23 80 00 00 00 00 00     .........#......
  802f70:	1d 20 80 00 00 00 00 00 04 23 80 00 00 00 00 00     . .......#......
  802f80:	04 23 80 00 00 00 00 00 29 22 80 00 00 00 00 00     .#......)"......
  802f90:	04 23 80 00 00 00 00 00 b9 1c 80 00 00 00 00 00     .#..............

0000000000802fa0 <error_string>:
	...
  802fa8:	75 2b 80 00 00 00 00 00 87 2b 80 00 00 00 00 00     u+.......+......
  802fb8:	97 2b 80 00 00 00 00 00 a9 2b 80 00 00 00 00 00     .+.......+......
  802fc8:	b7 2b 80 00 00 00 00 00 cb 2b 80 00 00 00 00 00     .+.......+......
  802fd8:	e0 2b 80 00 00 00 00 00 f3 2b 80 00 00 00 00 00     .+.......+......
  802fe8:	05 2c 80 00 00 00 00 00 19 2c 80 00 00 00 00 00     .,.......,......
  802ff8:	29 2c 80 00 00 00 00 00 3c 2c 80 00 00 00 00 00     ),......<,......
  803008:	53 2c 80 00 00 00 00 00 69 2c 80 00 00 00 00 00     S,......i,......
  803018:	81 2c 80 00 00 00 00 00 99 2c 80 00 00 00 00 00     .,.......,......
  803028:	a6 2c 80 00 00 00 00 00 40 30 80 00 00 00 00 00     .,......@0......
  803038:	ba 2c 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .,......file is 
  803048:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803058:	75 74 61 62 6c 65 00 69 70 63 5f 73 65 6e 64 20     utable.ipc_send 
  803068:	65 72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69 70     error: %i.lib/ip
  803078:	63 2e 63 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     c.c.f.........f.
  803088:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803098:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8030a8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8030b8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8030c8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8030d8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8030e8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8030f8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803108:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803118:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803128:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803138:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803148:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803158:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803168:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803178:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803188:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803198:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8031a8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8031b8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8031c8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8031d8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8031e8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8031f8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803208:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803218:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803228:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803238:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803248:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803258:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803268:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803278:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803288:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803298:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8032a8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8032b8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8032c8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8032d8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8032e8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8032f8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803308:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803318:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803328:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803338:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803348:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803358:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803368:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803378:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803388:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803398:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8033a8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8033b8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8033c8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8033d8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8033e8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8033f8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803408:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803418:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803428:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803438:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803448:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803458:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803468:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803478:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803488:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803498:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8034a8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034b8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8034c8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034d8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8034e8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8034f8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803508:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803518:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803528:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803538:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803548:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803558:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803568:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803578:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803588:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803598:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035a8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8035b8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8035c8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035d8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8035e8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035f8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803608:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803618:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803628:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803638:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803648:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803658:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803668:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803678:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803688:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803698:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8036a8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8036b8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8036c8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036d8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8036e8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8036f8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803708:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803718:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803728:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803738:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803748:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803758:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803768:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803778:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803788:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803798:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8037a8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8037b8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8037c8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037d8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8037e8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8037f8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803808:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803818:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803828:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803838:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803848:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803858:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803868:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803878:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803888:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803898:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8038a8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8038b8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8038c8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038d8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8038e8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8038f8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803908:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803918:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803928:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803938:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803948:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803958:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803968:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803978:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803988:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803998:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8039a8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8039b8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8039c8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039d8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8039e8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8039f8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a08:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a18:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a28:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a38:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a48:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a58:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a68:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a78:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a88:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a98:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803aa8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ab8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ac8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ad8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ae8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803af8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b08:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b18:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b28:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b38:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b48:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b58:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b68:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b78:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b88:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b98:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ba8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803bb8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803bc8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803bd8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803be8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803bf8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c08:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c18:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c28:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c38:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c48:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c58:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c68:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c78:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c88:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c98:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ca8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803cb8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803cc8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803cd8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ce8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803cf8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d08:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d18:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d28:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d38:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d48:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d58:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d68:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d78:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d88:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d98:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803da8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803db8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803dc8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803dd8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803de8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803df8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e08:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e18:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e28:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e38:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e48:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e58:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e68:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e78:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e88:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e98:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ea8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803eb8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ec8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ed8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ee8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ef8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f08:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f18:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f28:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f38:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f48:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f58:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f68:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f78:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f88:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f98:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803fa8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803fb8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803fc8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803fd8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803fe8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ff8:	84 00 00 00 00 00 66 90                             ......f.
