
obj/user/faultbadhandler:     file format elf64-x86-64


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
  80001e:	e8 4e 00 00 00       	call   800071 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
 * we outrun the stack with invocations of the user-level handler */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
#ifndef __clang_analyzer__
    sys_alloc_region(0, (void *)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  800029:	b9 06 00 00 00       	mov    $0x6,%ecx
  80002e:	ba 00 10 00 00       	mov    $0x1000,%edx
  800033:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  80003a:	00 00 00 
  80003d:	bf 00 00 00 00       	mov    $0x0,%edi
  800042:	48 b8 cb 02 80 00 00 	movabs $0x8002cb,%rax
  800049:	00 00 00 
  80004c:	ff d0                	call   *%rax
    sys_env_set_pgfault_upcall(0, (void *)0xDEADBEEF);
  80004e:	be ef be ad de       	mov    $0xdeadbeef,%esi
  800053:	bf 00 00 00 00       	mov    $0x0,%edi
  800058:	48 b8 d0 04 80 00 00 	movabs $0x8004d0,%rax
  80005f:	00 00 00 
  800062:	ff d0                	call   *%rax
    *(volatile int *)0 = 0;
  800064:	c7 04 25 00 00 00 00 	movl   $0x0,0x0
  80006b:	00 00 00 00 
#endif
}
  80006f:	5d                   	pop    %rbp
  800070:	c3                   	ret    

0000000000800071 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800071:	55                   	push   %rbp
  800072:	48 89 e5             	mov    %rsp,%rbp
  800075:	41 56                	push   %r14
  800077:	41 55                	push   %r13
  800079:	41 54                	push   %r12
  80007b:	53                   	push   %rbx
  80007c:	41 89 fd             	mov    %edi,%r13d
  80007f:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800082:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800089:	00 00 00 
  80008c:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800093:	00 00 00 
  800096:	48 39 c2             	cmp    %rax,%rdx
  800099:	73 17                	jae    8000b2 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80009b:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80009e:	49 89 c4             	mov    %rax,%r12
  8000a1:	48 83 c3 08          	add    $0x8,%rbx
  8000a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000aa:	ff 53 f8             	call   *-0x8(%rbx)
  8000ad:	4c 39 e3             	cmp    %r12,%rbx
  8000b0:	72 ef                	jb     8000a1 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8000b2:	48 b8 0b 02 80 00 00 	movabs $0x80020b,%rax
  8000b9:	00 00 00 
  8000bc:	ff d0                	call   *%rax
  8000be:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000c3:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000c7:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000cb:	48 c1 e0 04          	shl    $0x4,%rax
  8000cf:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000d6:	00 00 00 
  8000d9:	48 01 d0             	add    %rdx,%rax
  8000dc:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000e3:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000e6:	45 85 ed             	test   %r13d,%r13d
  8000e9:	7e 0d                	jle    8000f8 <libmain+0x87>
  8000eb:	49 8b 06             	mov    (%r14),%rax
  8000ee:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000f5:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000f8:	4c 89 f6             	mov    %r14,%rsi
  8000fb:	44 89 ef             	mov    %r13d,%edi
  8000fe:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800105:	00 00 00 
  800108:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80010a:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800111:	00 00 00 
  800114:	ff d0                	call   *%rax
#endif
}
  800116:	5b                   	pop    %rbx
  800117:	41 5c                	pop    %r12
  800119:	41 5d                	pop    %r13
  80011b:	41 5e                	pop    %r14
  80011d:	5d                   	pop    %rbp
  80011e:	c3                   	ret    

000000000080011f <exit>:

#include <inc/lib.h>

void
exit(void) {
  80011f:	55                   	push   %rbp
  800120:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800123:	48 b8 5b 08 80 00 00 	movabs $0x80085b,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80012f:	bf 00 00 00 00       	mov    $0x0,%edi
  800134:	48 b8 a0 01 80 00 00 	movabs $0x8001a0,%rax
  80013b:	00 00 00 
  80013e:	ff d0                	call   *%rax
}
  800140:	5d                   	pop    %rbp
  800141:	c3                   	ret    

0000000000800142 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800142:	55                   	push   %rbp
  800143:	48 89 e5             	mov    %rsp,%rbp
  800146:	53                   	push   %rbx
  800147:	48 89 fa             	mov    %rdi,%rdx
  80014a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80014d:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800152:	bb 00 00 00 00       	mov    $0x0,%ebx
  800157:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80015c:	be 00 00 00 00       	mov    $0x0,%esi
  800161:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800167:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800169:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80016d:	c9                   	leave  
  80016e:	c3                   	ret    

000000000080016f <sys_cgetc>:

int
sys_cgetc(void) {
  80016f:	55                   	push   %rbp
  800170:	48 89 e5             	mov    %rsp,%rbp
  800173:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800174:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800179:	ba 00 00 00 00       	mov    $0x0,%edx
  80017e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800183:	bb 00 00 00 00       	mov    $0x0,%ebx
  800188:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80018d:	be 00 00 00 00       	mov    $0x0,%esi
  800192:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800198:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80019a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

00000000008001a0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8001a0:	55                   	push   %rbp
  8001a1:	48 89 e5             	mov    %rsp,%rbp
  8001a4:	53                   	push   %rbx
  8001a5:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8001a9:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8001ac:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001b1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001bb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001c0:	be 00 00 00 00       	mov    $0x0,%esi
  8001c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001cb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001cd:	48 85 c0             	test   %rax,%rax
  8001d0:	7f 06                	jg     8001d8 <sys_env_destroy+0x38>
}
  8001d2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001d8:	49 89 c0             	mov    %rax,%r8
  8001db:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001e0:	48 ba 00 2a 80 00 00 	movabs $0x802a00,%rdx
  8001e7:	00 00 00 
  8001ea:	be 26 00 00 00       	mov    $0x26,%esi
  8001ef:	48 bf 1f 2a 80 00 00 	movabs $0x802a1f,%rdi
  8001f6:	00 00 00 
  8001f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fe:	49 b9 8e 19 80 00 00 	movabs $0x80198e,%r9
  800205:	00 00 00 
  800208:	41 ff d1             	call   *%r9

000000000080020b <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80020b:	55                   	push   %rbp
  80020c:	48 89 e5             	mov    %rsp,%rbp
  80020f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800210:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800215:	ba 00 00 00 00       	mov    $0x0,%edx
  80021a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80021f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800224:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800229:	be 00 00 00 00       	mov    $0x0,%esi
  80022e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800234:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800236:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    

000000000080023c <sys_yield>:

void
sys_yield(void) {
  80023c:	55                   	push   %rbp
  80023d:	48 89 e5             	mov    %rsp,%rbp
  800240:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800241:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800246:	ba 00 00 00 00       	mov    $0x0,%edx
  80024b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800250:	bb 00 00 00 00       	mov    $0x0,%ebx
  800255:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80025a:	be 00 00 00 00       	mov    $0x0,%esi
  80025f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800265:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800267:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80026b:	c9                   	leave  
  80026c:	c3                   	ret    

000000000080026d <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80026d:	55                   	push   %rbp
  80026e:	48 89 e5             	mov    %rsp,%rbp
  800271:	53                   	push   %rbx
  800272:	48 89 fa             	mov    %rdi,%rdx
  800275:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800278:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80027d:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800284:	00 00 00 
  800287:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80028c:	be 00 00 00 00       	mov    $0x0,%esi
  800291:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800297:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800299:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

000000000080029f <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80029f:	55                   	push   %rbp
  8002a0:	48 89 e5             	mov    %rsp,%rbp
  8002a3:	53                   	push   %rbx
  8002a4:	49 89 f8             	mov    %rdi,%r8
  8002a7:	48 89 d3             	mov    %rdx,%rbx
  8002aa:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8002ad:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002b2:	4c 89 c2             	mov    %r8,%rdx
  8002b5:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002b8:	be 00 00 00 00       	mov    $0x0,%esi
  8002bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002c3:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002c9:	c9                   	leave  
  8002ca:	c3                   	ret    

00000000008002cb <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002cb:	55                   	push   %rbp
  8002cc:	48 89 e5             	mov    %rsp,%rbp
  8002cf:	53                   	push   %rbx
  8002d0:	48 83 ec 08          	sub    $0x8,%rsp
  8002d4:	89 f8                	mov    %edi,%eax
  8002d6:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002d9:	48 63 f9             	movslq %ecx,%rdi
  8002dc:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002df:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002e4:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002e7:	be 00 00 00 00       	mov    $0x0,%esi
  8002ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002f2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002f4:	48 85 c0             	test   %rax,%rax
  8002f7:	7f 06                	jg     8002ff <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002f9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002ff:	49 89 c0             	mov    %rax,%r8
  800302:	b9 04 00 00 00       	mov    $0x4,%ecx
  800307:	48 ba 00 2a 80 00 00 	movabs $0x802a00,%rdx
  80030e:	00 00 00 
  800311:	be 26 00 00 00       	mov    $0x26,%esi
  800316:	48 bf 1f 2a 80 00 00 	movabs $0x802a1f,%rdi
  80031d:	00 00 00 
  800320:	b8 00 00 00 00       	mov    $0x0,%eax
  800325:	49 b9 8e 19 80 00 00 	movabs $0x80198e,%r9
  80032c:	00 00 00 
  80032f:	41 ff d1             	call   *%r9

0000000000800332 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  800332:	55                   	push   %rbp
  800333:	48 89 e5             	mov    %rsp,%rbp
  800336:	53                   	push   %rbx
  800337:	48 83 ec 08          	sub    $0x8,%rsp
  80033b:	89 f8                	mov    %edi,%eax
  80033d:	49 89 f2             	mov    %rsi,%r10
  800340:	48 89 cf             	mov    %rcx,%rdi
  800343:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800346:	48 63 da             	movslq %edx,%rbx
  800349:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80034c:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800351:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800354:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800357:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800359:	48 85 c0             	test   %rax,%rax
  80035c:	7f 06                	jg     800364 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80035e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800362:	c9                   	leave  
  800363:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800364:	49 89 c0             	mov    %rax,%r8
  800367:	b9 05 00 00 00       	mov    $0x5,%ecx
  80036c:	48 ba 00 2a 80 00 00 	movabs $0x802a00,%rdx
  800373:	00 00 00 
  800376:	be 26 00 00 00       	mov    $0x26,%esi
  80037b:	48 bf 1f 2a 80 00 00 	movabs $0x802a1f,%rdi
  800382:	00 00 00 
  800385:	b8 00 00 00 00       	mov    $0x0,%eax
  80038a:	49 b9 8e 19 80 00 00 	movabs $0x80198e,%r9
  800391:	00 00 00 
  800394:	41 ff d1             	call   *%r9

0000000000800397 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  800397:	55                   	push   %rbp
  800398:	48 89 e5             	mov    %rsp,%rbp
  80039b:	53                   	push   %rbx
  80039c:	48 83 ec 08          	sub    $0x8,%rsp
  8003a0:	48 89 f1             	mov    %rsi,%rcx
  8003a3:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8003a6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8003a9:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8003ae:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003b3:	be 00 00 00 00       	mov    $0x0,%esi
  8003b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003be:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003c0:	48 85 c0             	test   %rax,%rax
  8003c3:	7f 06                	jg     8003cb <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8003c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003c9:	c9                   	leave  
  8003ca:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003cb:	49 89 c0             	mov    %rax,%r8
  8003ce:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003d3:	48 ba 00 2a 80 00 00 	movabs $0x802a00,%rdx
  8003da:	00 00 00 
  8003dd:	be 26 00 00 00       	mov    $0x26,%esi
  8003e2:	48 bf 1f 2a 80 00 00 	movabs $0x802a1f,%rdi
  8003e9:	00 00 00 
  8003ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f1:	49 b9 8e 19 80 00 00 	movabs $0x80198e,%r9
  8003f8:	00 00 00 
  8003fb:	41 ff d1             	call   *%r9

00000000008003fe <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8003fe:	55                   	push   %rbp
  8003ff:	48 89 e5             	mov    %rsp,%rbp
  800402:	53                   	push   %rbx
  800403:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  800407:	48 63 ce             	movslq %esi,%rcx
  80040a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80040d:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800412:	bb 00 00 00 00       	mov    $0x0,%ebx
  800417:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80041c:	be 00 00 00 00       	mov    $0x0,%esi
  800421:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800427:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800429:	48 85 c0             	test   %rax,%rax
  80042c:	7f 06                	jg     800434 <sys_env_set_status+0x36>
}
  80042e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800432:	c9                   	leave  
  800433:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800434:	49 89 c0             	mov    %rax,%r8
  800437:	b9 09 00 00 00       	mov    $0x9,%ecx
  80043c:	48 ba 00 2a 80 00 00 	movabs $0x802a00,%rdx
  800443:	00 00 00 
  800446:	be 26 00 00 00       	mov    $0x26,%esi
  80044b:	48 bf 1f 2a 80 00 00 	movabs $0x802a1f,%rdi
  800452:	00 00 00 
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	49 b9 8e 19 80 00 00 	movabs $0x80198e,%r9
  800461:	00 00 00 
  800464:	41 ff d1             	call   *%r9

0000000000800467 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  800467:	55                   	push   %rbp
  800468:	48 89 e5             	mov    %rsp,%rbp
  80046b:	53                   	push   %rbx
  80046c:	48 83 ec 08          	sub    $0x8,%rsp
  800470:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  800473:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800476:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80047b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800480:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800485:	be 00 00 00 00       	mov    $0x0,%esi
  80048a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800490:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800492:	48 85 c0             	test   %rax,%rax
  800495:	7f 06                	jg     80049d <sys_env_set_trapframe+0x36>
}
  800497:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80049d:	49 89 c0             	mov    %rax,%r8
  8004a0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8004a5:	48 ba 00 2a 80 00 00 	movabs $0x802a00,%rdx
  8004ac:	00 00 00 
  8004af:	be 26 00 00 00       	mov    $0x26,%esi
  8004b4:	48 bf 1f 2a 80 00 00 	movabs $0x802a1f,%rdi
  8004bb:	00 00 00 
  8004be:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c3:	49 b9 8e 19 80 00 00 	movabs $0x80198e,%r9
  8004ca:	00 00 00 
  8004cd:	41 ff d1             	call   *%r9

00000000008004d0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8004d0:	55                   	push   %rbp
  8004d1:	48 89 e5             	mov    %rsp,%rbp
  8004d4:	53                   	push   %rbx
  8004d5:	48 83 ec 08          	sub    $0x8,%rsp
  8004d9:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8004dc:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004df:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004e9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004ee:	be 00 00 00 00       	mov    $0x0,%esi
  8004f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004f9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004fb:	48 85 c0             	test   %rax,%rax
  8004fe:	7f 06                	jg     800506 <sys_env_set_pgfault_upcall+0x36>
}
  800500:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800504:	c9                   	leave  
  800505:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800506:	49 89 c0             	mov    %rax,%r8
  800509:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80050e:	48 ba 00 2a 80 00 00 	movabs $0x802a00,%rdx
  800515:	00 00 00 
  800518:	be 26 00 00 00       	mov    $0x26,%esi
  80051d:	48 bf 1f 2a 80 00 00 	movabs $0x802a1f,%rdi
  800524:	00 00 00 
  800527:	b8 00 00 00 00       	mov    $0x0,%eax
  80052c:	49 b9 8e 19 80 00 00 	movabs $0x80198e,%r9
  800533:	00 00 00 
  800536:	41 ff d1             	call   *%r9

0000000000800539 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  800539:	55                   	push   %rbp
  80053a:	48 89 e5             	mov    %rsp,%rbp
  80053d:	53                   	push   %rbx
  80053e:	89 f8                	mov    %edi,%eax
  800540:	49 89 f1             	mov    %rsi,%r9
  800543:	48 89 d3             	mov    %rdx,%rbx
  800546:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  800549:	49 63 f0             	movslq %r8d,%rsi
  80054c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80054f:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800554:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800557:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80055d:	cd 30                	int    $0x30
}
  80055f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800563:	c9                   	leave  
  800564:	c3                   	ret    

0000000000800565 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  800565:	55                   	push   %rbp
  800566:	48 89 e5             	mov    %rsp,%rbp
  800569:	53                   	push   %rbx
  80056a:	48 83 ec 08          	sub    $0x8,%rsp
  80056e:	48 89 fa             	mov    %rdi,%rdx
  800571:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800574:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800579:	bb 00 00 00 00       	mov    $0x0,%ebx
  80057e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800583:	be 00 00 00 00       	mov    $0x0,%esi
  800588:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80058e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800590:	48 85 c0             	test   %rax,%rax
  800593:	7f 06                	jg     80059b <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800595:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800599:	c9                   	leave  
  80059a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80059b:	49 89 c0             	mov    %rax,%r8
  80059e:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8005a3:	48 ba 00 2a 80 00 00 	movabs $0x802a00,%rdx
  8005aa:	00 00 00 
  8005ad:	be 26 00 00 00       	mov    $0x26,%esi
  8005b2:	48 bf 1f 2a 80 00 00 	movabs $0x802a1f,%rdi
  8005b9:	00 00 00 
  8005bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c1:	49 b9 8e 19 80 00 00 	movabs $0x80198e,%r9
  8005c8:	00 00 00 
  8005cb:	41 ff d1             	call   *%r9

00000000008005ce <sys_gettime>:

int
sys_gettime(void) {
  8005ce:	55                   	push   %rbp
  8005cf:	48 89 e5             	mov    %rsp,%rbp
  8005d2:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005d3:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005dd:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005e7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005ec:	be 00 00 00 00       	mov    $0x0,%esi
  8005f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005f7:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8005f9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005fd:	c9                   	leave  
  8005fe:	c3                   	ret    

00000000008005ff <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8005ff:	55                   	push   %rbp
  800600:	48 89 e5             	mov    %rsp,%rbp
  800603:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800604:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800609:	ba 00 00 00 00       	mov    $0x0,%edx
  80060e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800613:	bb 00 00 00 00       	mov    $0x0,%ebx
  800618:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80061d:	be 00 00 00 00       	mov    $0x0,%esi
  800622:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800628:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  80062a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80062e:	c9                   	leave  
  80062f:	c3                   	ret    

0000000000800630 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800630:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800637:	ff ff ff 
  80063a:	48 01 f8             	add    %rdi,%rax
  80063d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800641:	c3                   	ret    

0000000000800642 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800642:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800649:	ff ff ff 
  80064c:	48 01 f8             	add    %rdi,%rax
  80064f:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  800653:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800659:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80065d:	c3                   	ret    

000000000080065e <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80065e:	55                   	push   %rbp
  80065f:	48 89 e5             	mov    %rsp,%rbp
  800662:	41 57                	push   %r15
  800664:	41 56                	push   %r14
  800666:	41 55                	push   %r13
  800668:	41 54                	push   %r12
  80066a:	53                   	push   %rbx
  80066b:	48 83 ec 08          	sub    $0x8,%rsp
  80066f:	49 89 ff             	mov    %rdi,%r15
  800672:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  800677:	49 bc 0c 16 80 00 00 	movabs $0x80160c,%r12
  80067e:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  800681:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  800687:	48 89 df             	mov    %rbx,%rdi
  80068a:	41 ff d4             	call   *%r12
  80068d:	83 e0 04             	and    $0x4,%eax
  800690:	74 1a                	je     8006ac <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  800692:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  800699:	4c 39 f3             	cmp    %r14,%rbx
  80069c:	75 e9                	jne    800687 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  80069e:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8006a5:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8006aa:	eb 03                	jmp    8006af <fd_alloc+0x51>
            *fd_store = fd;
  8006ac:	49 89 1f             	mov    %rbx,(%r15)
}
  8006af:	48 83 c4 08          	add    $0x8,%rsp
  8006b3:	5b                   	pop    %rbx
  8006b4:	41 5c                	pop    %r12
  8006b6:	41 5d                	pop    %r13
  8006b8:	41 5e                	pop    %r14
  8006ba:	41 5f                	pop    %r15
  8006bc:	5d                   	pop    %rbp
  8006bd:	c3                   	ret    

00000000008006be <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8006be:	83 ff 1f             	cmp    $0x1f,%edi
  8006c1:	77 39                	ja     8006fc <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8006c3:	55                   	push   %rbp
  8006c4:	48 89 e5             	mov    %rsp,%rbp
  8006c7:	41 54                	push   %r12
  8006c9:	53                   	push   %rbx
  8006ca:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8006cd:	48 63 df             	movslq %edi,%rbx
  8006d0:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8006d7:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8006db:	48 89 df             	mov    %rbx,%rdi
  8006de:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  8006e5:	00 00 00 
  8006e8:	ff d0                	call   *%rax
  8006ea:	a8 04                	test   $0x4,%al
  8006ec:	74 14                	je     800702 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8006ee:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8006f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006f7:	5b                   	pop    %rbx
  8006f8:	41 5c                	pop    %r12
  8006fa:	5d                   	pop    %rbp
  8006fb:	c3                   	ret    
        return -E_INVAL;
  8006fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800701:	c3                   	ret    
        return -E_INVAL;
  800702:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800707:	eb ee                	jmp    8006f7 <fd_lookup+0x39>

0000000000800709 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  800709:	55                   	push   %rbp
  80070a:	48 89 e5             	mov    %rsp,%rbp
  80070d:	53                   	push   %rbx
  80070e:	48 83 ec 08          	sub    $0x8,%rsp
  800712:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  800715:	48 ba c0 2a 80 00 00 	movabs $0x802ac0,%rdx
  80071c:	00 00 00 
  80071f:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  800726:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800729:	39 38                	cmp    %edi,(%rax)
  80072b:	74 4b                	je     800778 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  80072d:	48 83 c2 08          	add    $0x8,%rdx
  800731:	48 8b 02             	mov    (%rdx),%rax
  800734:	48 85 c0             	test   %rax,%rax
  800737:	75 f0                	jne    800729 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800739:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800740:	00 00 00 
  800743:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800749:	89 fa                	mov    %edi,%edx
  80074b:	48 bf 30 2a 80 00 00 	movabs $0x802a30,%rdi
  800752:	00 00 00 
  800755:	b8 00 00 00 00       	mov    $0x0,%eax
  80075a:	48 b9 de 1a 80 00 00 	movabs $0x801ade,%rcx
  800761:	00 00 00 
  800764:	ff d1                	call   *%rcx
    *dev = 0;
  800766:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  80076d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800772:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800776:	c9                   	leave  
  800777:	c3                   	ret    
            *dev = devtab[i];
  800778:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  80077b:	b8 00 00 00 00       	mov    $0x0,%eax
  800780:	eb f0                	jmp    800772 <dev_lookup+0x69>

0000000000800782 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  800782:	55                   	push   %rbp
  800783:	48 89 e5             	mov    %rsp,%rbp
  800786:	41 55                	push   %r13
  800788:	41 54                	push   %r12
  80078a:	53                   	push   %rbx
  80078b:	48 83 ec 18          	sub    $0x18,%rsp
  80078f:	49 89 fc             	mov    %rdi,%r12
  800792:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800795:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80079c:	ff ff ff 
  80079f:	4c 01 e7             	add    %r12,%rdi
  8007a2:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8007a6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8007aa:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  8007b1:	00 00 00 
  8007b4:	ff d0                	call   *%rax
  8007b6:	89 c3                	mov    %eax,%ebx
  8007b8:	85 c0                	test   %eax,%eax
  8007ba:	78 06                	js     8007c2 <fd_close+0x40>
  8007bc:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8007c0:	74 18                	je     8007da <fd_close+0x58>
        return (must_exist ? res : 0);
  8007c2:	45 84 ed             	test   %r13b,%r13b
  8007c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ca:	0f 44 d8             	cmove  %eax,%ebx
}
  8007cd:	89 d8                	mov    %ebx,%eax
  8007cf:	48 83 c4 18          	add    $0x18,%rsp
  8007d3:	5b                   	pop    %rbx
  8007d4:	41 5c                	pop    %r12
  8007d6:	41 5d                	pop    %r13
  8007d8:	5d                   	pop    %rbp
  8007d9:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8007da:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8007de:	41 8b 3c 24          	mov    (%r12),%edi
  8007e2:	48 b8 09 07 80 00 00 	movabs $0x800709,%rax
  8007e9:	00 00 00 
  8007ec:	ff d0                	call   *%rax
  8007ee:	89 c3                	mov    %eax,%ebx
  8007f0:	85 c0                	test   %eax,%eax
  8007f2:	78 19                	js     80080d <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8007f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8007f8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800801:	48 85 c0             	test   %rax,%rax
  800804:	74 07                	je     80080d <fd_close+0x8b>
  800806:	4c 89 e7             	mov    %r12,%rdi
  800809:	ff d0                	call   *%rax
  80080b:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80080d:	ba 00 10 00 00       	mov    $0x1000,%edx
  800812:	4c 89 e6             	mov    %r12,%rsi
  800815:	bf 00 00 00 00       	mov    $0x0,%edi
  80081a:	48 b8 97 03 80 00 00 	movabs $0x800397,%rax
  800821:	00 00 00 
  800824:	ff d0                	call   *%rax
    return res;
  800826:	eb a5                	jmp    8007cd <fd_close+0x4b>

0000000000800828 <close>:

int
close(int fdnum) {
  800828:	55                   	push   %rbp
  800829:	48 89 e5             	mov    %rsp,%rbp
  80082c:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  800830:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800834:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  80083b:	00 00 00 
  80083e:	ff d0                	call   *%rax
    if (res < 0) return res;
  800840:	85 c0                	test   %eax,%eax
  800842:	78 15                	js     800859 <close+0x31>

    return fd_close(fd, 1);
  800844:	be 01 00 00 00       	mov    $0x1,%esi
  800849:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80084d:	48 b8 82 07 80 00 00 	movabs $0x800782,%rax
  800854:	00 00 00 
  800857:	ff d0                	call   *%rax
}
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

000000000080085b <close_all>:

void
close_all(void) {
  80085b:	55                   	push   %rbp
  80085c:	48 89 e5             	mov    %rsp,%rbp
  80085f:	41 54                	push   %r12
  800861:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  800862:	bb 00 00 00 00       	mov    $0x0,%ebx
  800867:	49 bc 28 08 80 00 00 	movabs $0x800828,%r12
  80086e:	00 00 00 
  800871:	89 df                	mov    %ebx,%edi
  800873:	41 ff d4             	call   *%r12
  800876:	83 c3 01             	add    $0x1,%ebx
  800879:	83 fb 20             	cmp    $0x20,%ebx
  80087c:	75 f3                	jne    800871 <close_all+0x16>
}
  80087e:	5b                   	pop    %rbx
  80087f:	41 5c                	pop    %r12
  800881:	5d                   	pop    %rbp
  800882:	c3                   	ret    

0000000000800883 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  800883:	55                   	push   %rbp
  800884:	48 89 e5             	mov    %rsp,%rbp
  800887:	41 56                	push   %r14
  800889:	41 55                	push   %r13
  80088b:	41 54                	push   %r12
  80088d:	53                   	push   %rbx
  80088e:	48 83 ec 10          	sub    $0x10,%rsp
  800892:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  800895:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800899:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  8008a0:	00 00 00 
  8008a3:	ff d0                	call   *%rax
  8008a5:	89 c3                	mov    %eax,%ebx
  8008a7:	85 c0                	test   %eax,%eax
  8008a9:	0f 88 b7 00 00 00    	js     800966 <dup+0xe3>
    close(newfdnum);
  8008af:	44 89 e7             	mov    %r12d,%edi
  8008b2:	48 b8 28 08 80 00 00 	movabs $0x800828,%rax
  8008b9:	00 00 00 
  8008bc:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8008be:	4d 63 ec             	movslq %r12d,%r13
  8008c1:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8008c8:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8008cc:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8008d0:	49 be 42 06 80 00 00 	movabs $0x800642,%r14
  8008d7:	00 00 00 
  8008da:	41 ff d6             	call   *%r14
  8008dd:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8008e0:	4c 89 ef             	mov    %r13,%rdi
  8008e3:	41 ff d6             	call   *%r14
  8008e6:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8008e9:	48 89 df             	mov    %rbx,%rdi
  8008ec:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  8008f3:	00 00 00 
  8008f6:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8008f8:	a8 04                	test   $0x4,%al
  8008fa:	74 2b                	je     800927 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8008fc:	41 89 c1             	mov    %eax,%r9d
  8008ff:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800905:	4c 89 f1             	mov    %r14,%rcx
  800908:	ba 00 00 00 00       	mov    $0x0,%edx
  80090d:	48 89 de             	mov    %rbx,%rsi
  800910:	bf 00 00 00 00       	mov    $0x0,%edi
  800915:	48 b8 32 03 80 00 00 	movabs $0x800332,%rax
  80091c:	00 00 00 
  80091f:	ff d0                	call   *%rax
  800921:	89 c3                	mov    %eax,%ebx
  800923:	85 c0                	test   %eax,%eax
  800925:	78 4e                	js     800975 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  800927:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80092b:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  800932:	00 00 00 
  800935:	ff d0                	call   *%rax
  800937:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  80093a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800940:	4c 89 e9             	mov    %r13,%rcx
  800943:	ba 00 00 00 00       	mov    $0x0,%edx
  800948:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80094c:	bf 00 00 00 00       	mov    $0x0,%edi
  800951:	48 b8 32 03 80 00 00 	movabs $0x800332,%rax
  800958:	00 00 00 
  80095b:	ff d0                	call   *%rax
  80095d:	89 c3                	mov    %eax,%ebx
  80095f:	85 c0                	test   %eax,%eax
  800961:	78 12                	js     800975 <dup+0xf2>

    return newfdnum;
  800963:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  800966:	89 d8                	mov    %ebx,%eax
  800968:	48 83 c4 10          	add    $0x10,%rsp
  80096c:	5b                   	pop    %rbx
  80096d:	41 5c                	pop    %r12
  80096f:	41 5d                	pop    %r13
  800971:	41 5e                	pop    %r14
  800973:	5d                   	pop    %rbp
  800974:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  800975:	ba 00 10 00 00       	mov    $0x1000,%edx
  80097a:	4c 89 ee             	mov    %r13,%rsi
  80097d:	bf 00 00 00 00       	mov    $0x0,%edi
  800982:	49 bc 97 03 80 00 00 	movabs $0x800397,%r12
  800989:	00 00 00 
  80098c:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80098f:	ba 00 10 00 00       	mov    $0x1000,%edx
  800994:	4c 89 f6             	mov    %r14,%rsi
  800997:	bf 00 00 00 00       	mov    $0x0,%edi
  80099c:	41 ff d4             	call   *%r12
    return res;
  80099f:	eb c5                	jmp    800966 <dup+0xe3>

00000000008009a1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8009a1:	55                   	push   %rbp
  8009a2:	48 89 e5             	mov    %rsp,%rbp
  8009a5:	41 55                	push   %r13
  8009a7:	41 54                	push   %r12
  8009a9:	53                   	push   %rbx
  8009aa:	48 83 ec 18          	sub    $0x18,%rsp
  8009ae:	89 fb                	mov    %edi,%ebx
  8009b0:	49 89 f4             	mov    %rsi,%r12
  8009b3:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8009b6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8009ba:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  8009c1:	00 00 00 
  8009c4:	ff d0                	call   *%rax
  8009c6:	85 c0                	test   %eax,%eax
  8009c8:	78 49                	js     800a13 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8009ca:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8009ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009d2:	8b 38                	mov    (%rax),%edi
  8009d4:	48 b8 09 07 80 00 00 	movabs $0x800709,%rax
  8009db:	00 00 00 
  8009de:	ff d0                	call   *%rax
  8009e0:	85 c0                	test   %eax,%eax
  8009e2:	78 33                	js     800a17 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8009e4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8009e8:	8b 47 08             	mov    0x8(%rdi),%eax
  8009eb:	83 e0 03             	and    $0x3,%eax
  8009ee:	83 f8 01             	cmp    $0x1,%eax
  8009f1:	74 28                	je     800a1b <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8009f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009f7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8009fb:	48 85 c0             	test   %rax,%rax
  8009fe:	74 51                	je     800a51 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  800a00:	4c 89 ea             	mov    %r13,%rdx
  800a03:	4c 89 e6             	mov    %r12,%rsi
  800a06:	ff d0                	call   *%rax
}
  800a08:	48 83 c4 18          	add    $0x18,%rsp
  800a0c:	5b                   	pop    %rbx
  800a0d:	41 5c                	pop    %r12
  800a0f:	41 5d                	pop    %r13
  800a11:	5d                   	pop    %rbp
  800a12:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a13:	48 98                	cltq   
  800a15:	eb f1                	jmp    800a08 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a17:	48 98                	cltq   
  800a19:	eb ed                	jmp    800a08 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800a1b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800a22:	00 00 00 
  800a25:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800a2b:	89 da                	mov    %ebx,%edx
  800a2d:	48 bf 71 2a 80 00 00 	movabs $0x802a71,%rdi
  800a34:	00 00 00 
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	48 b9 de 1a 80 00 00 	movabs $0x801ade,%rcx
  800a43:	00 00 00 
  800a46:	ff d1                	call   *%rcx
        return -E_INVAL;
  800a48:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800a4f:	eb b7                	jmp    800a08 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800a51:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800a58:	eb ae                	jmp    800a08 <read+0x67>

0000000000800a5a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800a5a:	55                   	push   %rbp
  800a5b:	48 89 e5             	mov    %rsp,%rbp
  800a5e:	41 57                	push   %r15
  800a60:	41 56                	push   %r14
  800a62:	41 55                	push   %r13
  800a64:	41 54                	push   %r12
  800a66:	53                   	push   %rbx
  800a67:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800a6b:	48 85 d2             	test   %rdx,%rdx
  800a6e:	74 54                	je     800ac4 <readn+0x6a>
  800a70:	41 89 fd             	mov    %edi,%r13d
  800a73:	49 89 f6             	mov    %rsi,%r14
  800a76:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800a79:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800a7e:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800a83:	49 bf a1 09 80 00 00 	movabs $0x8009a1,%r15
  800a8a:	00 00 00 
  800a8d:	4c 89 e2             	mov    %r12,%rdx
  800a90:	48 29 f2             	sub    %rsi,%rdx
  800a93:	4c 01 f6             	add    %r14,%rsi
  800a96:	44 89 ef             	mov    %r13d,%edi
  800a99:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800a9c:	85 c0                	test   %eax,%eax
  800a9e:	78 20                	js     800ac0 <readn+0x66>
    for (; inc && res < n; res += inc) {
  800aa0:	01 c3                	add    %eax,%ebx
  800aa2:	85 c0                	test   %eax,%eax
  800aa4:	74 08                	je     800aae <readn+0x54>
  800aa6:	48 63 f3             	movslq %ebx,%rsi
  800aa9:	4c 39 e6             	cmp    %r12,%rsi
  800aac:	72 df                	jb     800a8d <readn+0x33>
    }
    return res;
  800aae:	48 63 c3             	movslq %ebx,%rax
}
  800ab1:	48 83 c4 08          	add    $0x8,%rsp
  800ab5:	5b                   	pop    %rbx
  800ab6:	41 5c                	pop    %r12
  800ab8:	41 5d                	pop    %r13
  800aba:	41 5e                	pop    %r14
  800abc:	41 5f                	pop    %r15
  800abe:	5d                   	pop    %rbp
  800abf:	c3                   	ret    
        if (inc < 0) return inc;
  800ac0:	48 98                	cltq   
  800ac2:	eb ed                	jmp    800ab1 <readn+0x57>
    int inc = 1, res = 0;
  800ac4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ac9:	eb e3                	jmp    800aae <readn+0x54>

0000000000800acb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800acb:	55                   	push   %rbp
  800acc:	48 89 e5             	mov    %rsp,%rbp
  800acf:	41 55                	push   %r13
  800ad1:	41 54                	push   %r12
  800ad3:	53                   	push   %rbx
  800ad4:	48 83 ec 18          	sub    $0x18,%rsp
  800ad8:	89 fb                	mov    %edi,%ebx
  800ada:	49 89 f4             	mov    %rsi,%r12
  800add:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800ae0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800ae4:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  800aeb:	00 00 00 
  800aee:	ff d0                	call   *%rax
  800af0:	85 c0                	test   %eax,%eax
  800af2:	78 44                	js     800b38 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800af4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800af8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800afc:	8b 38                	mov    (%rax),%edi
  800afe:	48 b8 09 07 80 00 00 	movabs $0x800709,%rax
  800b05:	00 00 00 
  800b08:	ff d0                	call   *%rax
  800b0a:	85 c0                	test   %eax,%eax
  800b0c:	78 2e                	js     800b3c <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b0e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800b12:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800b16:	74 28                	je     800b40 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800b18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b1c:	48 8b 40 18          	mov    0x18(%rax),%rax
  800b20:	48 85 c0             	test   %rax,%rax
  800b23:	74 51                	je     800b76 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  800b25:	4c 89 ea             	mov    %r13,%rdx
  800b28:	4c 89 e6             	mov    %r12,%rsi
  800b2b:	ff d0                	call   *%rax
}
  800b2d:	48 83 c4 18          	add    $0x18,%rsp
  800b31:	5b                   	pop    %rbx
  800b32:	41 5c                	pop    %r12
  800b34:	41 5d                	pop    %r13
  800b36:	5d                   	pop    %rbp
  800b37:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b38:	48 98                	cltq   
  800b3a:	eb f1                	jmp    800b2d <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b3c:	48 98                	cltq   
  800b3e:	eb ed                	jmp    800b2d <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b40:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800b47:	00 00 00 
  800b4a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800b50:	89 da                	mov    %ebx,%edx
  800b52:	48 bf 8d 2a 80 00 00 	movabs $0x802a8d,%rdi
  800b59:	00 00 00 
  800b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b61:	48 b9 de 1a 80 00 00 	movabs $0x801ade,%rcx
  800b68:	00 00 00 
  800b6b:	ff d1                	call   *%rcx
        return -E_INVAL;
  800b6d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800b74:	eb b7                	jmp    800b2d <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800b76:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800b7d:	eb ae                	jmp    800b2d <write+0x62>

0000000000800b7f <seek>:

int
seek(int fdnum, off_t offset) {
  800b7f:	55                   	push   %rbp
  800b80:	48 89 e5             	mov    %rsp,%rbp
  800b83:	53                   	push   %rbx
  800b84:	48 83 ec 18          	sub    $0x18,%rsp
  800b88:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b8a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b8e:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  800b95:	00 00 00 
  800b98:	ff d0                	call   *%rax
  800b9a:	85 c0                	test   %eax,%eax
  800b9c:	78 0c                	js     800baa <seek+0x2b>

    fd->fd_offset = offset;
  800b9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba2:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800ba5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800baa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800bae:	c9                   	leave  
  800baf:	c3                   	ret    

0000000000800bb0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800bb0:	55                   	push   %rbp
  800bb1:	48 89 e5             	mov    %rsp,%rbp
  800bb4:	41 54                	push   %r12
  800bb6:	53                   	push   %rbx
  800bb7:	48 83 ec 10          	sub    $0x10,%rsp
  800bbb:	89 fb                	mov    %edi,%ebx
  800bbd:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800bc0:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800bc4:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  800bcb:	00 00 00 
  800bce:	ff d0                	call   *%rax
  800bd0:	85 c0                	test   %eax,%eax
  800bd2:	78 36                	js     800c0a <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bd4:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800bd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdc:	8b 38                	mov    (%rax),%edi
  800bde:	48 b8 09 07 80 00 00 	movabs $0x800709,%rax
  800be5:	00 00 00 
  800be8:	ff d0                	call   *%rax
  800bea:	85 c0                	test   %eax,%eax
  800bec:	78 1c                	js     800c0a <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bee:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800bf2:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800bf6:	74 1b                	je     800c13 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800bf8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800bfc:	48 8b 40 30          	mov    0x30(%rax),%rax
  800c00:	48 85 c0             	test   %rax,%rax
  800c03:	74 42                	je     800c47 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  800c05:	44 89 e6             	mov    %r12d,%esi
  800c08:	ff d0                	call   *%rax
}
  800c0a:	48 83 c4 10          	add    $0x10,%rsp
  800c0e:	5b                   	pop    %rbx
  800c0f:	41 5c                	pop    %r12
  800c11:	5d                   	pop    %rbp
  800c12:	c3                   	ret    
                thisenv->env_id, fdnum);
  800c13:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800c1a:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c1d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800c23:	89 da                	mov    %ebx,%edx
  800c25:	48 bf 50 2a 80 00 00 	movabs $0x802a50,%rdi
  800c2c:	00 00 00 
  800c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c34:	48 b9 de 1a 80 00 00 	movabs $0x801ade,%rcx
  800c3b:	00 00 00 
  800c3e:	ff d1                	call   *%rcx
        return -E_INVAL;
  800c40:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c45:	eb c3                	jmp    800c0a <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c47:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c4c:	eb bc                	jmp    800c0a <ftruncate+0x5a>

0000000000800c4e <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800c4e:	55                   	push   %rbp
  800c4f:	48 89 e5             	mov    %rsp,%rbp
  800c52:	53                   	push   %rbx
  800c53:	48 83 ec 18          	sub    $0x18,%rsp
  800c57:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c5a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c5e:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  800c65:	00 00 00 
  800c68:	ff d0                	call   *%rax
  800c6a:	85 c0                	test   %eax,%eax
  800c6c:	78 4d                	js     800cbb <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c6e:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800c72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c76:	8b 38                	mov    (%rax),%edi
  800c78:	48 b8 09 07 80 00 00 	movabs $0x800709,%rax
  800c7f:	00 00 00 
  800c82:	ff d0                	call   *%rax
  800c84:	85 c0                	test   %eax,%eax
  800c86:	78 33                	js     800cbb <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c8c:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800c91:	74 2e                	je     800cc1 <fstat+0x73>

    stat->st_name[0] = 0;
  800c93:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800c96:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800c9d:	00 00 00 
    stat->st_isdir = 0;
  800ca0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800ca7:	00 00 00 
    stat->st_dev = dev;
  800caa:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800cb1:	48 89 de             	mov    %rbx,%rsi
  800cb4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800cb8:	ff 50 28             	call   *0x28(%rax)
}
  800cbb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800cc1:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800cc6:	eb f3                	jmp    800cbb <fstat+0x6d>

0000000000800cc8 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800cc8:	55                   	push   %rbp
  800cc9:	48 89 e5             	mov    %rsp,%rbp
  800ccc:	41 54                	push   %r12
  800cce:	53                   	push   %rbx
  800ccf:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800cd2:	be 00 00 00 00       	mov    $0x0,%esi
  800cd7:	48 b8 93 0f 80 00 00 	movabs $0x800f93,%rax
  800cde:	00 00 00 
  800ce1:	ff d0                	call   *%rax
  800ce3:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	78 25                	js     800d0e <stat+0x46>

    int res = fstat(fd, stat);
  800ce9:	4c 89 e6             	mov    %r12,%rsi
  800cec:	89 c7                	mov    %eax,%edi
  800cee:	48 b8 4e 0c 80 00 00 	movabs $0x800c4e,%rax
  800cf5:	00 00 00 
  800cf8:	ff d0                	call   *%rax
  800cfa:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800cfd:	89 df                	mov    %ebx,%edi
  800cff:	48 b8 28 08 80 00 00 	movabs $0x800828,%rax
  800d06:	00 00 00 
  800d09:	ff d0                	call   *%rax

    return res;
  800d0b:	44 89 e3             	mov    %r12d,%ebx
}
  800d0e:	89 d8                	mov    %ebx,%eax
  800d10:	5b                   	pop    %rbx
  800d11:	41 5c                	pop    %r12
  800d13:	5d                   	pop    %rbp
  800d14:	c3                   	ret    

0000000000800d15 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800d15:	55                   	push   %rbp
  800d16:	48 89 e5             	mov    %rsp,%rbp
  800d19:	41 54                	push   %r12
  800d1b:	53                   	push   %rbx
  800d1c:	48 83 ec 10          	sub    $0x10,%rsp
  800d20:	41 89 fc             	mov    %edi,%r12d
  800d23:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800d26:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d2d:	00 00 00 
  800d30:	83 38 00             	cmpl   $0x0,(%rax)
  800d33:	74 5e                	je     800d93 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800d35:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800d3b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800d40:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800d47:	00 00 00 
  800d4a:	44 89 e6             	mov    %r12d,%esi
  800d4d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d54:	00 00 00 
  800d57:	8b 38                	mov    (%rax),%edi
  800d59:	48 b8 ef 28 80 00 00 	movabs $0x8028ef,%rax
  800d60:	00 00 00 
  800d63:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800d65:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800d6c:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800d6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d72:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d76:	48 89 de             	mov    %rbx,%rsi
  800d79:	bf 00 00 00 00       	mov    $0x0,%edi
  800d7e:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  800d85:	00 00 00 
  800d88:	ff d0                	call   *%rax
}
  800d8a:	48 83 c4 10          	add    $0x10,%rsp
  800d8e:	5b                   	pop    %rbx
  800d8f:	41 5c                	pop    %r12
  800d91:	5d                   	pop    %rbp
  800d92:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800d93:	bf 03 00 00 00       	mov    $0x3,%edi
  800d98:	48 b8 92 29 80 00 00 	movabs $0x802992,%rax
  800d9f:	00 00 00 
  800da2:	ff d0                	call   *%rax
  800da4:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800dab:	00 00 
  800dad:	eb 86                	jmp    800d35 <fsipc+0x20>

0000000000800daf <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800daf:	55                   	push   %rbp
  800db0:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800db3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800dba:	00 00 00 
  800dbd:	8b 57 0c             	mov    0xc(%rdi),%edx
  800dc0:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800dc2:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800dc5:	be 00 00 00 00       	mov    $0x0,%esi
  800dca:	bf 02 00 00 00       	mov    $0x2,%edi
  800dcf:	48 b8 15 0d 80 00 00 	movabs $0x800d15,%rax
  800dd6:	00 00 00 
  800dd9:	ff d0                	call   *%rax
}
  800ddb:	5d                   	pop    %rbp
  800ddc:	c3                   	ret    

0000000000800ddd <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800ddd:	55                   	push   %rbp
  800dde:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800de1:	8b 47 0c             	mov    0xc(%rdi),%eax
  800de4:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800deb:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800ded:	be 00 00 00 00       	mov    $0x0,%esi
  800df2:	bf 06 00 00 00       	mov    $0x6,%edi
  800df7:	48 b8 15 0d 80 00 00 	movabs $0x800d15,%rax
  800dfe:	00 00 00 
  800e01:	ff d0                	call   *%rax
}
  800e03:	5d                   	pop    %rbp
  800e04:	c3                   	ret    

0000000000800e05 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800e05:	55                   	push   %rbp
  800e06:	48 89 e5             	mov    %rsp,%rbp
  800e09:	53                   	push   %rbx
  800e0a:	48 83 ec 08          	sub    $0x8,%rsp
  800e0e:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800e11:	8b 47 0c             	mov    0xc(%rdi),%eax
  800e14:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800e1b:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800e1d:	be 00 00 00 00       	mov    $0x0,%esi
  800e22:	bf 05 00 00 00       	mov    $0x5,%edi
  800e27:	48 b8 15 0d 80 00 00 	movabs $0x800d15,%rax
  800e2e:	00 00 00 
  800e31:	ff d0                	call   *%rax
    if (res < 0) return res;
  800e33:	85 c0                	test   %eax,%eax
  800e35:	78 40                	js     800e77 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800e37:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800e3e:	00 00 00 
  800e41:	48 89 df             	mov    %rbx,%rdi
  800e44:	48 b8 1f 24 80 00 00 	movabs $0x80241f,%rax
  800e4b:	00 00 00 
  800e4e:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800e50:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e57:	00 00 00 
  800e5a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  800e60:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e66:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  800e6c:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800e72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e77:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

0000000000800e7d <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800e7d:	55                   	push   %rbp
  800e7e:	48 89 e5             	mov    %rsp,%rbp
  800e81:	41 57                	push   %r15
  800e83:	41 56                	push   %r14
  800e85:	41 55                	push   %r13
  800e87:	41 54                	push   %r12
  800e89:	53                   	push   %rbx
  800e8a:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  800e8e:	48 85 d2             	test   %rdx,%rdx
  800e91:	0f 84 91 00 00 00    	je     800f28 <devfile_write+0xab>
  800e97:	49 89 ff             	mov    %rdi,%r15
  800e9a:	49 89 f4             	mov    %rsi,%r12
  800e9d:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  800ea0:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800ea7:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  800eae:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  800eb1:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  800eb8:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  800ebe:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  800ec2:	4c 89 ea             	mov    %r13,%rdx
  800ec5:	4c 89 e6             	mov    %r12,%rsi
  800ec8:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  800ecf:	00 00 00 
  800ed2:	48 b8 7f 26 80 00 00 	movabs $0x80267f,%rax
  800ed9:	00 00 00 
  800edc:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800ede:	41 8b 47 0c          	mov    0xc(%r15),%eax
  800ee2:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  800ee5:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  800ee9:	be 00 00 00 00       	mov    $0x0,%esi
  800eee:	bf 04 00 00 00       	mov    $0x4,%edi
  800ef3:	48 b8 15 0d 80 00 00 	movabs $0x800d15,%rax
  800efa:	00 00 00 
  800efd:	ff d0                	call   *%rax
        if (res < 0)
  800eff:	85 c0                	test   %eax,%eax
  800f01:	78 21                	js     800f24 <devfile_write+0xa7>
        buf += res;
  800f03:	48 63 d0             	movslq %eax,%rdx
  800f06:	49 01 d4             	add    %rdx,%r12
        ext += res;
  800f09:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  800f0c:	48 29 d3             	sub    %rdx,%rbx
  800f0f:	75 a0                	jne    800eb1 <devfile_write+0x34>
    return ext;
  800f11:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  800f15:	48 83 c4 18          	add    $0x18,%rsp
  800f19:	5b                   	pop    %rbx
  800f1a:	41 5c                	pop    %r12
  800f1c:	41 5d                	pop    %r13
  800f1e:	41 5e                	pop    %r14
  800f20:	41 5f                	pop    %r15
  800f22:	5d                   	pop    %rbp
  800f23:	c3                   	ret    
            return res;
  800f24:	48 98                	cltq   
  800f26:	eb ed                	jmp    800f15 <devfile_write+0x98>
    int ext = 0;
  800f28:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  800f2f:	eb e0                	jmp    800f11 <devfile_write+0x94>

0000000000800f31 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800f31:	55                   	push   %rbp
  800f32:	48 89 e5             	mov    %rsp,%rbp
  800f35:	41 54                	push   %r12
  800f37:	53                   	push   %rbx
  800f38:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800f3b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f42:	00 00 00 
  800f45:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f48:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  800f4a:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  800f4e:	be 00 00 00 00       	mov    $0x0,%esi
  800f53:	bf 03 00 00 00       	mov    $0x3,%edi
  800f58:	48 b8 15 0d 80 00 00 	movabs $0x800d15,%rax
  800f5f:	00 00 00 
  800f62:	ff d0                	call   *%rax
    if (read < 0) 
  800f64:	85 c0                	test   %eax,%eax
  800f66:	78 27                	js     800f8f <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  800f68:	48 63 d8             	movslq %eax,%rbx
  800f6b:	48 89 da             	mov    %rbx,%rdx
  800f6e:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800f75:	00 00 00 
  800f78:	4c 89 e7             	mov    %r12,%rdi
  800f7b:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  800f82:	00 00 00 
  800f85:	ff d0                	call   *%rax
    return read;
  800f87:	48 89 d8             	mov    %rbx,%rax
}
  800f8a:	5b                   	pop    %rbx
  800f8b:	41 5c                	pop    %r12
  800f8d:	5d                   	pop    %rbp
  800f8e:	c3                   	ret    
		return read;
  800f8f:	48 98                	cltq   
  800f91:	eb f7                	jmp    800f8a <devfile_read+0x59>

0000000000800f93 <open>:
open(const char *path, int mode) {
  800f93:	55                   	push   %rbp
  800f94:	48 89 e5             	mov    %rsp,%rbp
  800f97:	41 55                	push   %r13
  800f99:	41 54                	push   %r12
  800f9b:	53                   	push   %rbx
  800f9c:	48 83 ec 18          	sub    $0x18,%rsp
  800fa0:	49 89 fc             	mov    %rdi,%r12
  800fa3:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  800fa6:	48 b8 e6 23 80 00 00 	movabs $0x8023e6,%rax
  800fad:	00 00 00 
  800fb0:	ff d0                	call   *%rax
  800fb2:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  800fb8:	0f 87 8c 00 00 00    	ja     80104a <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  800fbe:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  800fc2:	48 b8 5e 06 80 00 00 	movabs $0x80065e,%rax
  800fc9:	00 00 00 
  800fcc:	ff d0                	call   *%rax
  800fce:	89 c3                	mov    %eax,%ebx
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	78 52                	js     801026 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  800fd4:	4c 89 e6             	mov    %r12,%rsi
  800fd7:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  800fde:	00 00 00 
  800fe1:	48 b8 1f 24 80 00 00 	movabs $0x80241f,%rax
  800fe8:	00 00 00 
  800feb:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  800fed:	44 89 e8             	mov    %r13d,%eax
  800ff0:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  800ff7:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  800ff9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800ffd:	bf 01 00 00 00       	mov    $0x1,%edi
  801002:	48 b8 15 0d 80 00 00 	movabs $0x800d15,%rax
  801009:	00 00 00 
  80100c:	ff d0                	call   *%rax
  80100e:	89 c3                	mov    %eax,%ebx
  801010:	85 c0                	test   %eax,%eax
  801012:	78 1f                	js     801033 <open+0xa0>
    return fd2num(fd);
  801014:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801018:	48 b8 30 06 80 00 00 	movabs $0x800630,%rax
  80101f:	00 00 00 
  801022:	ff d0                	call   *%rax
  801024:	89 c3                	mov    %eax,%ebx
}
  801026:	89 d8                	mov    %ebx,%eax
  801028:	48 83 c4 18          	add    $0x18,%rsp
  80102c:	5b                   	pop    %rbx
  80102d:	41 5c                	pop    %r12
  80102f:	41 5d                	pop    %r13
  801031:	5d                   	pop    %rbp
  801032:	c3                   	ret    
        fd_close(fd, 0);
  801033:	be 00 00 00 00       	mov    $0x0,%esi
  801038:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80103c:	48 b8 82 07 80 00 00 	movabs $0x800782,%rax
  801043:	00 00 00 
  801046:	ff d0                	call   *%rax
        return res;
  801048:	eb dc                	jmp    801026 <open+0x93>
        return -E_BAD_PATH;
  80104a:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80104f:	eb d5                	jmp    801026 <open+0x93>

0000000000801051 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801051:	55                   	push   %rbp
  801052:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801055:	be 00 00 00 00       	mov    $0x0,%esi
  80105a:	bf 08 00 00 00       	mov    $0x8,%edi
  80105f:	48 b8 15 0d 80 00 00 	movabs $0x800d15,%rax
  801066:	00 00 00 
  801069:	ff d0                	call   *%rax
}
  80106b:	5d                   	pop    %rbp
  80106c:	c3                   	ret    

000000000080106d <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80106d:	55                   	push   %rbp
  80106e:	48 89 e5             	mov    %rsp,%rbp
  801071:	41 54                	push   %r12
  801073:	53                   	push   %rbx
  801074:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801077:	48 b8 42 06 80 00 00 	movabs $0x800642,%rax
  80107e:	00 00 00 
  801081:	ff d0                	call   *%rax
  801083:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801086:	48 be e0 2a 80 00 00 	movabs $0x802ae0,%rsi
  80108d:	00 00 00 
  801090:	48 89 df             	mov    %rbx,%rdi
  801093:	48 b8 1f 24 80 00 00 	movabs $0x80241f,%rax
  80109a:	00 00 00 
  80109d:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80109f:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8010a4:	41 2b 04 24          	sub    (%r12),%eax
  8010a8:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8010ae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8010b5:	00 00 00 
    stat->st_dev = &devpipe;
  8010b8:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8010bf:	00 00 00 
  8010c2:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8010c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ce:	5b                   	pop    %rbx
  8010cf:	41 5c                	pop    %r12
  8010d1:	5d                   	pop    %rbp
  8010d2:	c3                   	ret    

00000000008010d3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8010d3:	55                   	push   %rbp
  8010d4:	48 89 e5             	mov    %rsp,%rbp
  8010d7:	41 54                	push   %r12
  8010d9:	53                   	push   %rbx
  8010da:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8010dd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010e2:	48 89 fe             	mov    %rdi,%rsi
  8010e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8010ea:	49 bc 97 03 80 00 00 	movabs $0x800397,%r12
  8010f1:	00 00 00 
  8010f4:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8010f7:	48 89 df             	mov    %rbx,%rdi
  8010fa:	48 b8 42 06 80 00 00 	movabs $0x800642,%rax
  801101:	00 00 00 
  801104:	ff d0                	call   *%rax
  801106:	48 89 c6             	mov    %rax,%rsi
  801109:	ba 00 10 00 00       	mov    $0x1000,%edx
  80110e:	bf 00 00 00 00       	mov    $0x0,%edi
  801113:	41 ff d4             	call   *%r12
}
  801116:	5b                   	pop    %rbx
  801117:	41 5c                	pop    %r12
  801119:	5d                   	pop    %rbp
  80111a:	c3                   	ret    

000000000080111b <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  80111b:	55                   	push   %rbp
  80111c:	48 89 e5             	mov    %rsp,%rbp
  80111f:	41 57                	push   %r15
  801121:	41 56                	push   %r14
  801123:	41 55                	push   %r13
  801125:	41 54                	push   %r12
  801127:	53                   	push   %rbx
  801128:	48 83 ec 18          	sub    $0x18,%rsp
  80112c:	49 89 fc             	mov    %rdi,%r12
  80112f:	49 89 f5             	mov    %rsi,%r13
  801132:	49 89 d7             	mov    %rdx,%r15
  801135:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801139:	48 b8 42 06 80 00 00 	movabs $0x800642,%rax
  801140:	00 00 00 
  801143:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801145:	4d 85 ff             	test   %r15,%r15
  801148:	0f 84 ac 00 00 00    	je     8011fa <devpipe_write+0xdf>
  80114e:	48 89 c3             	mov    %rax,%rbx
  801151:	4c 89 f8             	mov    %r15,%rax
  801154:	4d 89 ef             	mov    %r13,%r15
  801157:	49 01 c5             	add    %rax,%r13
  80115a:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80115e:	49 bd 9f 02 80 00 00 	movabs $0x80029f,%r13
  801165:	00 00 00 
            sys_yield();
  801168:	49 be 3c 02 80 00 00 	movabs $0x80023c,%r14
  80116f:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801172:	8b 73 04             	mov    0x4(%rbx),%esi
  801175:	48 63 ce             	movslq %esi,%rcx
  801178:	48 63 03             	movslq (%rbx),%rax
  80117b:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801181:	48 39 c1             	cmp    %rax,%rcx
  801184:	72 2e                	jb     8011b4 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801186:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80118b:	48 89 da             	mov    %rbx,%rdx
  80118e:	be 00 10 00 00       	mov    $0x1000,%esi
  801193:	4c 89 e7             	mov    %r12,%rdi
  801196:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801199:	85 c0                	test   %eax,%eax
  80119b:	74 63                	je     801200 <devpipe_write+0xe5>
            sys_yield();
  80119d:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8011a0:	8b 73 04             	mov    0x4(%rbx),%esi
  8011a3:	48 63 ce             	movslq %esi,%rcx
  8011a6:	48 63 03             	movslq (%rbx),%rax
  8011a9:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8011af:	48 39 c1             	cmp    %rax,%rcx
  8011b2:	73 d2                	jae    801186 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8011b4:	41 0f b6 3f          	movzbl (%r15),%edi
  8011b8:	48 89 ca             	mov    %rcx,%rdx
  8011bb:	48 c1 ea 03          	shr    $0x3,%rdx
  8011bf:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8011c6:	08 10 20 
  8011c9:	48 f7 e2             	mul    %rdx
  8011cc:	48 c1 ea 06          	shr    $0x6,%rdx
  8011d0:	48 89 d0             	mov    %rdx,%rax
  8011d3:	48 c1 e0 09          	shl    $0x9,%rax
  8011d7:	48 29 d0             	sub    %rdx,%rax
  8011da:	48 c1 e0 03          	shl    $0x3,%rax
  8011de:	48 29 c1             	sub    %rax,%rcx
  8011e1:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8011e6:	83 c6 01             	add    $0x1,%esi
  8011e9:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8011ec:	49 83 c7 01          	add    $0x1,%r15
  8011f0:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8011f4:	0f 85 78 ff ff ff    	jne    801172 <devpipe_write+0x57>
    return n;
  8011fa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8011fe:	eb 05                	jmp    801205 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  801200:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801205:	48 83 c4 18          	add    $0x18,%rsp
  801209:	5b                   	pop    %rbx
  80120a:	41 5c                	pop    %r12
  80120c:	41 5d                	pop    %r13
  80120e:	41 5e                	pop    %r14
  801210:	41 5f                	pop    %r15
  801212:	5d                   	pop    %rbp
  801213:	c3                   	ret    

0000000000801214 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  801214:	55                   	push   %rbp
  801215:	48 89 e5             	mov    %rsp,%rbp
  801218:	41 57                	push   %r15
  80121a:	41 56                	push   %r14
  80121c:	41 55                	push   %r13
  80121e:	41 54                	push   %r12
  801220:	53                   	push   %rbx
  801221:	48 83 ec 18          	sub    $0x18,%rsp
  801225:	49 89 fc             	mov    %rdi,%r12
  801228:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80122c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801230:	48 b8 42 06 80 00 00 	movabs $0x800642,%rax
  801237:	00 00 00 
  80123a:	ff d0                	call   *%rax
  80123c:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80123f:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801245:	49 bd 9f 02 80 00 00 	movabs $0x80029f,%r13
  80124c:	00 00 00 
            sys_yield();
  80124f:	49 be 3c 02 80 00 00 	movabs $0x80023c,%r14
  801256:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801259:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80125e:	74 7a                	je     8012da <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801260:	8b 03                	mov    (%rbx),%eax
  801262:	3b 43 04             	cmp    0x4(%rbx),%eax
  801265:	75 26                	jne    80128d <devpipe_read+0x79>
            if (i > 0) return i;
  801267:	4d 85 ff             	test   %r15,%r15
  80126a:	75 74                	jne    8012e0 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80126c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801271:	48 89 da             	mov    %rbx,%rdx
  801274:	be 00 10 00 00       	mov    $0x1000,%esi
  801279:	4c 89 e7             	mov    %r12,%rdi
  80127c:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80127f:	85 c0                	test   %eax,%eax
  801281:	74 6f                	je     8012f2 <devpipe_read+0xde>
            sys_yield();
  801283:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801286:	8b 03                	mov    (%rbx),%eax
  801288:	3b 43 04             	cmp    0x4(%rbx),%eax
  80128b:	74 df                	je     80126c <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80128d:	48 63 c8             	movslq %eax,%rcx
  801290:	48 89 ca             	mov    %rcx,%rdx
  801293:	48 c1 ea 03          	shr    $0x3,%rdx
  801297:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80129e:	08 10 20 
  8012a1:	48 f7 e2             	mul    %rdx
  8012a4:	48 c1 ea 06          	shr    $0x6,%rdx
  8012a8:	48 89 d0             	mov    %rdx,%rax
  8012ab:	48 c1 e0 09          	shl    $0x9,%rax
  8012af:	48 29 d0             	sub    %rdx,%rax
  8012b2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8012b9:	00 
  8012ba:	48 89 c8             	mov    %rcx,%rax
  8012bd:	48 29 d0             	sub    %rdx,%rax
  8012c0:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8012c5:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8012c9:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8012cd:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012d0:	49 83 c7 01          	add    $0x1,%r15
  8012d4:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8012d8:	75 86                	jne    801260 <devpipe_read+0x4c>
    return n;
  8012da:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012de:	eb 03                	jmp    8012e3 <devpipe_read+0xcf>
            if (i > 0) return i;
  8012e0:	4c 89 f8             	mov    %r15,%rax
}
  8012e3:	48 83 c4 18          	add    $0x18,%rsp
  8012e7:	5b                   	pop    %rbx
  8012e8:	41 5c                	pop    %r12
  8012ea:	41 5d                	pop    %r13
  8012ec:	41 5e                	pop    %r14
  8012ee:	41 5f                	pop    %r15
  8012f0:	5d                   	pop    %rbp
  8012f1:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8012f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f7:	eb ea                	jmp    8012e3 <devpipe_read+0xcf>

00000000008012f9 <pipe>:
pipe(int pfd[2]) {
  8012f9:	55                   	push   %rbp
  8012fa:	48 89 e5             	mov    %rsp,%rbp
  8012fd:	41 55                	push   %r13
  8012ff:	41 54                	push   %r12
  801301:	53                   	push   %rbx
  801302:	48 83 ec 18          	sub    $0x18,%rsp
  801306:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  801309:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80130d:	48 b8 5e 06 80 00 00 	movabs $0x80065e,%rax
  801314:	00 00 00 
  801317:	ff d0                	call   *%rax
  801319:	89 c3                	mov    %eax,%ebx
  80131b:	85 c0                	test   %eax,%eax
  80131d:	0f 88 a0 01 00 00    	js     8014c3 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  801323:	b9 46 00 00 00       	mov    $0x46,%ecx
  801328:	ba 00 10 00 00       	mov    $0x1000,%edx
  80132d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801331:	bf 00 00 00 00       	mov    $0x0,%edi
  801336:	48 b8 cb 02 80 00 00 	movabs $0x8002cb,%rax
  80133d:	00 00 00 
  801340:	ff d0                	call   *%rax
  801342:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801344:	85 c0                	test   %eax,%eax
  801346:	0f 88 77 01 00 00    	js     8014c3 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80134c:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  801350:	48 b8 5e 06 80 00 00 	movabs $0x80065e,%rax
  801357:	00 00 00 
  80135a:	ff d0                	call   *%rax
  80135c:	89 c3                	mov    %eax,%ebx
  80135e:	85 c0                	test   %eax,%eax
  801360:	0f 88 43 01 00 00    	js     8014a9 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  801366:	b9 46 00 00 00       	mov    $0x46,%ecx
  80136b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801370:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801374:	bf 00 00 00 00       	mov    $0x0,%edi
  801379:	48 b8 cb 02 80 00 00 	movabs $0x8002cb,%rax
  801380:	00 00 00 
  801383:	ff d0                	call   *%rax
  801385:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  801387:	85 c0                	test   %eax,%eax
  801389:	0f 88 1a 01 00 00    	js     8014a9 <pipe+0x1b0>
    va = fd2data(fd0);
  80138f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801393:	48 b8 42 06 80 00 00 	movabs $0x800642,%rax
  80139a:	00 00 00 
  80139d:	ff d0                	call   *%rax
  80139f:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8013a2:	b9 46 00 00 00       	mov    $0x46,%ecx
  8013a7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8013ac:	48 89 c6             	mov    %rax,%rsi
  8013af:	bf 00 00 00 00       	mov    $0x0,%edi
  8013b4:	48 b8 cb 02 80 00 00 	movabs $0x8002cb,%rax
  8013bb:	00 00 00 
  8013be:	ff d0                	call   *%rax
  8013c0:	89 c3                	mov    %eax,%ebx
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	0f 88 c5 00 00 00    	js     80148f <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8013ca:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8013ce:	48 b8 42 06 80 00 00 	movabs $0x800642,%rax
  8013d5:	00 00 00 
  8013d8:	ff d0                	call   *%rax
  8013da:	48 89 c1             	mov    %rax,%rcx
  8013dd:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8013e3:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8013e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ee:	4c 89 ee             	mov    %r13,%rsi
  8013f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8013f6:	48 b8 32 03 80 00 00 	movabs $0x800332,%rax
  8013fd:	00 00 00 
  801400:	ff d0                	call   *%rax
  801402:	89 c3                	mov    %eax,%ebx
  801404:	85 c0                	test   %eax,%eax
  801406:	78 6e                	js     801476 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  801408:	be 00 10 00 00       	mov    $0x1000,%esi
  80140d:	4c 89 ef             	mov    %r13,%rdi
  801410:	48 b8 6d 02 80 00 00 	movabs $0x80026d,%rax
  801417:	00 00 00 
  80141a:	ff d0                	call   *%rax
  80141c:	83 f8 02             	cmp    $0x2,%eax
  80141f:	0f 85 ab 00 00 00    	jne    8014d0 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  801425:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80142c:	00 00 
  80142e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801432:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  801434:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801438:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80143f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801443:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801445:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801449:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801450:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801454:	48 bb 30 06 80 00 00 	movabs $0x800630,%rbx
  80145b:	00 00 00 
  80145e:	ff d3                	call   *%rbx
  801460:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801464:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801468:	ff d3                	call   *%rbx
  80146a:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80146f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801474:	eb 4d                	jmp    8014c3 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  801476:	ba 00 10 00 00       	mov    $0x1000,%edx
  80147b:	4c 89 ee             	mov    %r13,%rsi
  80147e:	bf 00 00 00 00       	mov    $0x0,%edi
  801483:	48 b8 97 03 80 00 00 	movabs $0x800397,%rax
  80148a:	00 00 00 
  80148d:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80148f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801494:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801498:	bf 00 00 00 00       	mov    $0x0,%edi
  80149d:	48 b8 97 03 80 00 00 	movabs $0x800397,%rax
  8014a4:	00 00 00 
  8014a7:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8014a9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8014ae:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8014b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8014b7:	48 b8 97 03 80 00 00 	movabs $0x800397,%rax
  8014be:	00 00 00 
  8014c1:	ff d0                	call   *%rax
}
  8014c3:	89 d8                	mov    %ebx,%eax
  8014c5:	48 83 c4 18          	add    $0x18,%rsp
  8014c9:	5b                   	pop    %rbx
  8014ca:	41 5c                	pop    %r12
  8014cc:	41 5d                	pop    %r13
  8014ce:	5d                   	pop    %rbp
  8014cf:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014d0:	48 b9 10 2b 80 00 00 	movabs $0x802b10,%rcx
  8014d7:	00 00 00 
  8014da:	48 ba e7 2a 80 00 00 	movabs $0x802ae7,%rdx
  8014e1:	00 00 00 
  8014e4:	be 2e 00 00 00       	mov    $0x2e,%esi
  8014e9:	48 bf fc 2a 80 00 00 	movabs $0x802afc,%rdi
  8014f0:	00 00 00 
  8014f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f8:	49 b8 8e 19 80 00 00 	movabs $0x80198e,%r8
  8014ff:	00 00 00 
  801502:	41 ff d0             	call   *%r8

0000000000801505 <pipeisclosed>:
pipeisclosed(int fdnum) {
  801505:	55                   	push   %rbp
  801506:	48 89 e5             	mov    %rsp,%rbp
  801509:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80150d:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801511:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  801518:	00 00 00 
  80151b:	ff d0                	call   *%rax
    if (res < 0) return res;
  80151d:	85 c0                	test   %eax,%eax
  80151f:	78 35                	js     801556 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  801521:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801525:	48 b8 42 06 80 00 00 	movabs $0x800642,%rax
  80152c:	00 00 00 
  80152f:	ff d0                	call   *%rax
  801531:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801534:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801539:	be 00 10 00 00       	mov    $0x1000,%esi
  80153e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801542:	48 b8 9f 02 80 00 00 	movabs $0x80029f,%rax
  801549:	00 00 00 
  80154c:	ff d0                	call   *%rax
  80154e:	85 c0                	test   %eax,%eax
  801550:	0f 94 c0             	sete   %al
  801553:	0f b6 c0             	movzbl %al,%eax
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

0000000000801558 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801558:	48 89 f8             	mov    %rdi,%rax
  80155b:	48 c1 e8 27          	shr    $0x27,%rax
  80155f:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  801566:	01 00 00 
  801569:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80156d:	f6 c2 01             	test   $0x1,%dl
  801570:	74 6d                	je     8015df <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801572:	48 89 f8             	mov    %rdi,%rax
  801575:	48 c1 e8 1e          	shr    $0x1e,%rax
  801579:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801580:	01 00 00 
  801583:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801587:	f6 c2 01             	test   $0x1,%dl
  80158a:	74 62                	je     8015ee <get_uvpt_entry+0x96>
  80158c:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801593:	01 00 00 
  801596:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80159a:	f6 c2 80             	test   $0x80,%dl
  80159d:	75 4f                	jne    8015ee <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80159f:	48 89 f8             	mov    %rdi,%rax
  8015a2:	48 c1 e8 15          	shr    $0x15,%rax
  8015a6:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8015ad:	01 00 00 
  8015b0:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8015b4:	f6 c2 01             	test   $0x1,%dl
  8015b7:	74 44                	je     8015fd <get_uvpt_entry+0xa5>
  8015b9:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8015c0:	01 00 00 
  8015c3:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8015c7:	f6 c2 80             	test   $0x80,%dl
  8015ca:	75 31                	jne    8015fd <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8015cc:	48 c1 ef 0c          	shr    $0xc,%rdi
  8015d0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8015d7:	01 00 00 
  8015da:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8015de:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8015df:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8015e6:	01 00 00 
  8015e9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015ed:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8015ee:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8015f5:	01 00 00 
  8015f8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015fc:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8015fd:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801604:	01 00 00 
  801607:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80160b:	c3                   	ret    

000000000080160c <get_prot>:

int
get_prot(void *va) {
  80160c:	55                   	push   %rbp
  80160d:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801610:	48 b8 58 15 80 00 00 	movabs $0x801558,%rax
  801617:	00 00 00 
  80161a:	ff d0                	call   *%rax
  80161c:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80161f:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  801624:	89 c1                	mov    %eax,%ecx
  801626:	83 c9 04             	or     $0x4,%ecx
  801629:	f6 c2 01             	test   $0x1,%dl
  80162c:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80162f:	89 c1                	mov    %eax,%ecx
  801631:	83 c9 02             	or     $0x2,%ecx
  801634:	f6 c2 02             	test   $0x2,%dl
  801637:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80163a:	89 c1                	mov    %eax,%ecx
  80163c:	83 c9 01             	or     $0x1,%ecx
  80163f:	48 85 d2             	test   %rdx,%rdx
  801642:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801645:	89 c1                	mov    %eax,%ecx
  801647:	83 c9 40             	or     $0x40,%ecx
  80164a:	f6 c6 04             	test   $0x4,%dh
  80164d:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801650:	5d                   	pop    %rbp
  801651:	c3                   	ret    

0000000000801652 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801652:	55                   	push   %rbp
  801653:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801656:	48 b8 58 15 80 00 00 	movabs $0x801558,%rax
  80165d:	00 00 00 
  801660:	ff d0                	call   *%rax
    return pte & PTE_D;
  801662:	48 c1 e8 06          	shr    $0x6,%rax
  801666:	83 e0 01             	and    $0x1,%eax
}
  801669:	5d                   	pop    %rbp
  80166a:	c3                   	ret    

000000000080166b <is_page_present>:

bool
is_page_present(void *va) {
  80166b:	55                   	push   %rbp
  80166c:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80166f:	48 b8 58 15 80 00 00 	movabs $0x801558,%rax
  801676:	00 00 00 
  801679:	ff d0                	call   *%rax
  80167b:	83 e0 01             	and    $0x1,%eax
}
  80167e:	5d                   	pop    %rbp
  80167f:	c3                   	ret    

0000000000801680 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801680:	55                   	push   %rbp
  801681:	48 89 e5             	mov    %rsp,%rbp
  801684:	41 57                	push   %r15
  801686:	41 56                	push   %r14
  801688:	41 55                	push   %r13
  80168a:	41 54                	push   %r12
  80168c:	53                   	push   %rbx
  80168d:	48 83 ec 28          	sub    $0x28,%rsp
  801691:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  801695:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  801699:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  80169e:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8016a5:	01 00 00 
  8016a8:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8016af:	01 00 00 
  8016b2:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8016b9:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016bc:	49 bf 0c 16 80 00 00 	movabs $0x80160c,%r15
  8016c3:	00 00 00 
  8016c6:	eb 16                	jmp    8016de <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8016c8:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8016cf:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8016d6:	00 00 00 
  8016d9:	48 39 c3             	cmp    %rax,%rbx
  8016dc:	77 73                	ja     801751 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8016de:	48 89 d8             	mov    %rbx,%rax
  8016e1:	48 c1 e8 27          	shr    $0x27,%rax
  8016e5:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8016e9:	a8 01                	test   $0x1,%al
  8016eb:	74 db                	je     8016c8 <foreach_shared_region+0x48>
  8016ed:	48 89 d8             	mov    %rbx,%rax
  8016f0:	48 c1 e8 1e          	shr    $0x1e,%rax
  8016f4:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8016f9:	a8 01                	test   $0x1,%al
  8016fb:	74 cb                	je     8016c8 <foreach_shared_region+0x48>
  8016fd:	48 89 d8             	mov    %rbx,%rax
  801700:	48 c1 e8 15          	shr    $0x15,%rax
  801704:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  801708:	a8 01                	test   $0x1,%al
  80170a:	74 bc                	je     8016c8 <foreach_shared_region+0x48>
        void *start = (void*)i;
  80170c:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  801710:	48 89 df             	mov    %rbx,%rdi
  801713:	41 ff d7             	call   *%r15
  801716:	a8 40                	test   $0x40,%al
  801718:	75 09                	jne    801723 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  80171a:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801721:	eb ac                	jmp    8016cf <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  801723:	48 89 df             	mov    %rbx,%rdi
  801726:	48 b8 6b 16 80 00 00 	movabs $0x80166b,%rax
  80172d:	00 00 00 
  801730:	ff d0                	call   *%rax
  801732:	84 c0                	test   %al,%al
  801734:	74 e4                	je     80171a <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  801736:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  80173d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801741:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  801745:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801749:	ff d0                	call   *%rax
  80174b:	85 c0                	test   %eax,%eax
  80174d:	79 cb                	jns    80171a <foreach_shared_region+0x9a>
  80174f:	eb 05                	jmp    801756 <foreach_shared_region+0xd6>
    }
    return 0;
  801751:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801756:	48 83 c4 28          	add    $0x28,%rsp
  80175a:	5b                   	pop    %rbx
  80175b:	41 5c                	pop    %r12
  80175d:	41 5d                	pop    %r13
  80175f:	41 5e                	pop    %r14
  801761:	41 5f                	pop    %r15
  801763:	5d                   	pop    %rbp
  801764:	c3                   	ret    

0000000000801765 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
  80176a:	c3                   	ret    

000000000080176b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80176b:	55                   	push   %rbp
  80176c:	48 89 e5             	mov    %rsp,%rbp
  80176f:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  801772:	48 be 34 2b 80 00 00 	movabs $0x802b34,%rsi
  801779:	00 00 00 
  80177c:	48 b8 1f 24 80 00 00 	movabs $0x80241f,%rax
  801783:	00 00 00 
  801786:	ff d0                	call   *%rax
    return 0;
}
  801788:	b8 00 00 00 00       	mov    $0x0,%eax
  80178d:	5d                   	pop    %rbp
  80178e:	c3                   	ret    

000000000080178f <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80178f:	55                   	push   %rbp
  801790:	48 89 e5             	mov    %rsp,%rbp
  801793:	41 57                	push   %r15
  801795:	41 56                	push   %r14
  801797:	41 55                	push   %r13
  801799:	41 54                	push   %r12
  80179b:	53                   	push   %rbx
  80179c:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8017a3:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8017aa:	48 85 d2             	test   %rdx,%rdx
  8017ad:	74 78                	je     801827 <devcons_write+0x98>
  8017af:	49 89 d6             	mov    %rdx,%r14
  8017b2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8017b8:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8017bd:	49 bf 1a 26 80 00 00 	movabs $0x80261a,%r15
  8017c4:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8017c7:	4c 89 f3             	mov    %r14,%rbx
  8017ca:	48 29 f3             	sub    %rsi,%rbx
  8017cd:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8017d1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8017d6:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8017da:	4c 63 eb             	movslq %ebx,%r13
  8017dd:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8017e4:	4c 89 ea             	mov    %r13,%rdx
  8017e7:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017ee:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8017f1:	4c 89 ee             	mov    %r13,%rsi
  8017f4:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017fb:	48 b8 42 01 80 00 00 	movabs $0x800142,%rax
  801802:	00 00 00 
  801805:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801807:	41 01 dc             	add    %ebx,%r12d
  80180a:	49 63 f4             	movslq %r12d,%rsi
  80180d:	4c 39 f6             	cmp    %r14,%rsi
  801810:	72 b5                	jb     8017c7 <devcons_write+0x38>
    return res;
  801812:	49 63 c4             	movslq %r12d,%rax
}
  801815:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80181c:	5b                   	pop    %rbx
  80181d:	41 5c                	pop    %r12
  80181f:	41 5d                	pop    %r13
  801821:	41 5e                	pop    %r14
  801823:	41 5f                	pop    %r15
  801825:	5d                   	pop    %rbp
  801826:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  801827:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80182d:	eb e3                	jmp    801812 <devcons_write+0x83>

000000000080182f <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80182f:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801832:	ba 00 00 00 00       	mov    $0x0,%edx
  801837:	48 85 c0             	test   %rax,%rax
  80183a:	74 55                	je     801891 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80183c:	55                   	push   %rbp
  80183d:	48 89 e5             	mov    %rsp,%rbp
  801840:	41 55                	push   %r13
  801842:	41 54                	push   %r12
  801844:	53                   	push   %rbx
  801845:	48 83 ec 08          	sub    $0x8,%rsp
  801849:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  80184c:	48 bb 6f 01 80 00 00 	movabs $0x80016f,%rbx
  801853:	00 00 00 
  801856:	49 bc 3c 02 80 00 00 	movabs $0x80023c,%r12
  80185d:	00 00 00 
  801860:	eb 03                	jmp    801865 <devcons_read+0x36>
  801862:	41 ff d4             	call   *%r12
  801865:	ff d3                	call   *%rbx
  801867:	85 c0                	test   %eax,%eax
  801869:	74 f7                	je     801862 <devcons_read+0x33>
    if (c < 0) return c;
  80186b:	48 63 d0             	movslq %eax,%rdx
  80186e:	78 13                	js     801883 <devcons_read+0x54>
    if (c == 0x04) return 0;
  801870:	ba 00 00 00 00       	mov    $0x0,%edx
  801875:	83 f8 04             	cmp    $0x4,%eax
  801878:	74 09                	je     801883 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  80187a:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80187e:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801883:	48 89 d0             	mov    %rdx,%rax
  801886:	48 83 c4 08          	add    $0x8,%rsp
  80188a:	5b                   	pop    %rbx
  80188b:	41 5c                	pop    %r12
  80188d:	41 5d                	pop    %r13
  80188f:	5d                   	pop    %rbp
  801890:	c3                   	ret    
  801891:	48 89 d0             	mov    %rdx,%rax
  801894:	c3                   	ret    

0000000000801895 <cputchar>:
cputchar(int ch) {
  801895:	55                   	push   %rbp
  801896:	48 89 e5             	mov    %rsp,%rbp
  801899:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  80189d:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8018a1:	be 01 00 00 00       	mov    $0x1,%esi
  8018a6:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8018aa:	48 b8 42 01 80 00 00 	movabs $0x800142,%rax
  8018b1:	00 00 00 
  8018b4:	ff d0                	call   *%rax
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

00000000008018b8 <getchar>:
getchar(void) {
  8018b8:	55                   	push   %rbp
  8018b9:	48 89 e5             	mov    %rsp,%rbp
  8018bc:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8018c0:	ba 01 00 00 00       	mov    $0x1,%edx
  8018c5:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8018c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8018ce:	48 b8 a1 09 80 00 00 	movabs $0x8009a1,%rax
  8018d5:	00 00 00 
  8018d8:	ff d0                	call   *%rax
  8018da:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	78 06                	js     8018e6 <getchar+0x2e>
  8018e0:	74 08                	je     8018ea <getchar+0x32>
  8018e2:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8018e6:	89 d0                	mov    %edx,%eax
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8018ea:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8018ef:	eb f5                	jmp    8018e6 <getchar+0x2e>

00000000008018f1 <iscons>:
iscons(int fdnum) {
  8018f1:	55                   	push   %rbp
  8018f2:	48 89 e5             	mov    %rsp,%rbp
  8018f5:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8018f9:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018fd:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  801904:	00 00 00 
  801907:	ff d0                	call   *%rax
    if (res < 0) return res;
  801909:	85 c0                	test   %eax,%eax
  80190b:	78 18                	js     801925 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  80190d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801911:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801918:	00 00 00 
  80191b:	8b 00                	mov    (%rax),%eax
  80191d:	39 02                	cmp    %eax,(%rdx)
  80191f:	0f 94 c0             	sete   %al
  801922:	0f b6 c0             	movzbl %al,%eax
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

0000000000801927 <opencons>:
opencons(void) {
  801927:	55                   	push   %rbp
  801928:	48 89 e5             	mov    %rsp,%rbp
  80192b:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  80192f:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801933:	48 b8 5e 06 80 00 00 	movabs $0x80065e,%rax
  80193a:	00 00 00 
  80193d:	ff d0                	call   *%rax
  80193f:	85 c0                	test   %eax,%eax
  801941:	78 49                	js     80198c <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801943:	b9 46 00 00 00       	mov    $0x46,%ecx
  801948:	ba 00 10 00 00       	mov    $0x1000,%edx
  80194d:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801951:	bf 00 00 00 00       	mov    $0x0,%edi
  801956:	48 b8 cb 02 80 00 00 	movabs $0x8002cb,%rax
  80195d:	00 00 00 
  801960:	ff d0                	call   *%rax
  801962:	85 c0                	test   %eax,%eax
  801964:	78 26                	js     80198c <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  801966:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80196a:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801971:	00 00 
  801973:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801975:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801979:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801980:	48 b8 30 06 80 00 00 	movabs $0x800630,%rax
  801987:	00 00 00 
  80198a:	ff d0                	call   *%rax
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

000000000080198e <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80198e:	55                   	push   %rbp
  80198f:	48 89 e5             	mov    %rsp,%rbp
  801992:	41 56                	push   %r14
  801994:	41 55                	push   %r13
  801996:	41 54                	push   %r12
  801998:	53                   	push   %rbx
  801999:	48 83 ec 50          	sub    $0x50,%rsp
  80199d:	49 89 fc             	mov    %rdi,%r12
  8019a0:	41 89 f5             	mov    %esi,%r13d
  8019a3:	48 89 d3             	mov    %rdx,%rbx
  8019a6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8019aa:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8019ae:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8019b2:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8019b9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019bd:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8019c1:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8019c5:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8019c9:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8019d0:	00 00 00 
  8019d3:	4c 8b 30             	mov    (%rax),%r14
  8019d6:	48 b8 0b 02 80 00 00 	movabs $0x80020b,%rax
  8019dd:	00 00 00 
  8019e0:	ff d0                	call   *%rax
  8019e2:	89 c6                	mov    %eax,%esi
  8019e4:	45 89 e8             	mov    %r13d,%r8d
  8019e7:	4c 89 e1             	mov    %r12,%rcx
  8019ea:	4c 89 f2             	mov    %r14,%rdx
  8019ed:	48 bf 40 2b 80 00 00 	movabs $0x802b40,%rdi
  8019f4:	00 00 00 
  8019f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fc:	49 bc de 1a 80 00 00 	movabs $0x801ade,%r12
  801a03:	00 00 00 
  801a06:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801a09:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801a0d:	48 89 df             	mov    %rbx,%rdi
  801a10:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  801a17:	00 00 00 
  801a1a:	ff d0                	call   *%rax
    cprintf("\n");
  801a1c:	48 bf 8b 2a 80 00 00 	movabs $0x802a8b,%rdi
  801a23:	00 00 00 
  801a26:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2b:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801a2e:	cc                   	int3   
  801a2f:	eb fd                	jmp    801a2e <_panic+0xa0>

0000000000801a31 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801a31:	55                   	push   %rbp
  801a32:	48 89 e5             	mov    %rsp,%rbp
  801a35:	53                   	push   %rbx
  801a36:	48 83 ec 08          	sub    $0x8,%rsp
  801a3a:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801a3d:	8b 06                	mov    (%rsi),%eax
  801a3f:	8d 50 01             	lea    0x1(%rax),%edx
  801a42:	89 16                	mov    %edx,(%rsi)
  801a44:	48 98                	cltq   
  801a46:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801a4b:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801a51:	74 0a                	je     801a5d <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801a53:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801a57:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  801a5d:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801a61:	be ff 00 00 00       	mov    $0xff,%esi
  801a66:	48 b8 42 01 80 00 00 	movabs $0x800142,%rax
  801a6d:	00 00 00 
  801a70:	ff d0                	call   *%rax
        state->offset = 0;
  801a72:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801a78:	eb d9                	jmp    801a53 <putch+0x22>

0000000000801a7a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801a7a:	55                   	push   %rbp
  801a7b:	48 89 e5             	mov    %rsp,%rbp
  801a7e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801a85:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801a88:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801a8f:	b9 21 00 00 00       	mov    $0x21,%ecx
  801a94:	b8 00 00 00 00       	mov    $0x0,%eax
  801a99:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801a9c:	48 89 f1             	mov    %rsi,%rcx
  801a9f:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801aa6:	48 bf 31 1a 80 00 00 	movabs $0x801a31,%rdi
  801aad:	00 00 00 
  801ab0:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  801ab7:	00 00 00 
  801aba:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801abc:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801ac3:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801aca:	48 b8 42 01 80 00 00 	movabs $0x800142,%rax
  801ad1:	00 00 00 
  801ad4:	ff d0                	call   *%rax

    return state.count;
}
  801ad6:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

0000000000801ade <cprintf>:

int
cprintf(const char *fmt, ...) {
  801ade:	55                   	push   %rbp
  801adf:	48 89 e5             	mov    %rsp,%rbp
  801ae2:	48 83 ec 50          	sub    $0x50,%rsp
  801ae6:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801aea:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801aee:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801af2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801af6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801afa:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801b01:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801b05:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801b09:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801b0d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801b11:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801b15:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  801b1c:	00 00 00 
  801b1f:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

0000000000801b23 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801b23:	55                   	push   %rbp
  801b24:	48 89 e5             	mov    %rsp,%rbp
  801b27:	41 57                	push   %r15
  801b29:	41 56                	push   %r14
  801b2b:	41 55                	push   %r13
  801b2d:	41 54                	push   %r12
  801b2f:	53                   	push   %rbx
  801b30:	48 83 ec 18          	sub    $0x18,%rsp
  801b34:	49 89 fc             	mov    %rdi,%r12
  801b37:	49 89 f5             	mov    %rsi,%r13
  801b3a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801b3e:	8b 45 10             	mov    0x10(%rbp),%eax
  801b41:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801b44:	41 89 cf             	mov    %ecx,%r15d
  801b47:	49 39 d7             	cmp    %rdx,%r15
  801b4a:	76 5b                	jbe    801ba7 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801b4c:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801b50:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801b54:	85 db                	test   %ebx,%ebx
  801b56:	7e 0e                	jle    801b66 <print_num+0x43>
            putch(padc, put_arg);
  801b58:	4c 89 ee             	mov    %r13,%rsi
  801b5b:	44 89 f7             	mov    %r14d,%edi
  801b5e:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801b61:	83 eb 01             	sub    $0x1,%ebx
  801b64:	75 f2                	jne    801b58 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801b66:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801b6a:	48 b9 63 2b 80 00 00 	movabs $0x802b63,%rcx
  801b71:	00 00 00 
  801b74:	48 b8 74 2b 80 00 00 	movabs $0x802b74,%rax
  801b7b:	00 00 00 
  801b7e:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801b82:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b86:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8b:	49 f7 f7             	div    %r15
  801b8e:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801b92:	4c 89 ee             	mov    %r13,%rsi
  801b95:	41 ff d4             	call   *%r12
}
  801b98:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801b9c:	5b                   	pop    %rbx
  801b9d:	41 5c                	pop    %r12
  801b9f:	41 5d                	pop    %r13
  801ba1:	41 5e                	pop    %r14
  801ba3:	41 5f                	pop    %r15
  801ba5:	5d                   	pop    %rbp
  801ba6:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801ba7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801bab:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb0:	49 f7 f7             	div    %r15
  801bb3:	48 83 ec 08          	sub    $0x8,%rsp
  801bb7:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801bbb:	52                   	push   %rdx
  801bbc:	45 0f be c9          	movsbl %r9b,%r9d
  801bc0:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801bc4:	48 89 c2             	mov    %rax,%rdx
  801bc7:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  801bce:	00 00 00 
  801bd1:	ff d0                	call   *%rax
  801bd3:	48 83 c4 10          	add    $0x10,%rsp
  801bd7:	eb 8d                	jmp    801b66 <print_num+0x43>

0000000000801bd9 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  801bd9:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801bdd:	48 8b 06             	mov    (%rsi),%rax
  801be0:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801be4:	73 0a                	jae    801bf0 <sprintputch+0x17>
        *state->start++ = ch;
  801be6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bea:	48 89 16             	mov    %rdx,(%rsi)
  801bed:	40 88 38             	mov    %dil,(%rax)
    }
}
  801bf0:	c3                   	ret    

0000000000801bf1 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801bf1:	55                   	push   %rbp
  801bf2:	48 89 e5             	mov    %rsp,%rbp
  801bf5:	48 83 ec 50          	sub    $0x50,%rsp
  801bf9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bfd:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801c01:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801c05:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801c0c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c10:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801c14:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801c18:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801c1c:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801c20:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  801c27:	00 00 00 
  801c2a:	ff d0                	call   *%rax
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

0000000000801c2e <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801c2e:	55                   	push   %rbp
  801c2f:	48 89 e5             	mov    %rsp,%rbp
  801c32:	41 57                	push   %r15
  801c34:	41 56                	push   %r14
  801c36:	41 55                	push   %r13
  801c38:	41 54                	push   %r12
  801c3a:	53                   	push   %rbx
  801c3b:	48 83 ec 48          	sub    $0x48,%rsp
  801c3f:	49 89 fc             	mov    %rdi,%r12
  801c42:	49 89 f6             	mov    %rsi,%r14
  801c45:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  801c48:	48 8b 01             	mov    (%rcx),%rax
  801c4b:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801c4f:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801c53:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801c57:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801c5b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801c5f:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  801c63:	41 0f b6 3f          	movzbl (%r15),%edi
  801c67:	40 80 ff 25          	cmp    $0x25,%dil
  801c6b:	74 18                	je     801c85 <vprintfmt+0x57>
            if (!ch) return;
  801c6d:	40 84 ff             	test   %dil,%dil
  801c70:	0f 84 d1 06 00 00    	je     802347 <vprintfmt+0x719>
            putch(ch, put_arg);
  801c76:	40 0f b6 ff          	movzbl %dil,%edi
  801c7a:	4c 89 f6             	mov    %r14,%rsi
  801c7d:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  801c80:	49 89 df             	mov    %rbx,%r15
  801c83:	eb da                	jmp    801c5f <vprintfmt+0x31>
            precision = va_arg(aq, int);
  801c85:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  801c89:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c8e:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  801c92:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801c97:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801c9d:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801ca4:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  801ca8:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  801cad:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  801cb3:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  801cb7:	44 0f b6 0b          	movzbl (%rbx),%r9d
  801cbb:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  801cbf:	3c 57                	cmp    $0x57,%al
  801cc1:	0f 87 65 06 00 00    	ja     80232c <vprintfmt+0x6fe>
  801cc7:	0f b6 c0             	movzbl %al,%eax
  801cca:	49 ba 00 2d 80 00 00 	movabs $0x802d00,%r10
  801cd1:	00 00 00 
  801cd4:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  801cd8:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  801cdb:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  801cdf:	eb d2                	jmp    801cb3 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  801ce1:	4c 89 fb             	mov    %r15,%rbx
  801ce4:	44 89 c1             	mov    %r8d,%ecx
  801ce7:	eb ca                	jmp    801cb3 <vprintfmt+0x85>
            padc = ch;
  801ce9:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  801ced:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801cf0:	eb c1                	jmp    801cb3 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cf2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801cf5:	83 f8 2f             	cmp    $0x2f,%eax
  801cf8:	77 24                	ja     801d1e <vprintfmt+0xf0>
  801cfa:	41 89 c1             	mov    %eax,%r9d
  801cfd:	49 01 f1             	add    %rsi,%r9
  801d00:	83 c0 08             	add    $0x8,%eax
  801d03:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d06:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  801d09:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  801d0c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801d10:	79 a1                	jns    801cb3 <vprintfmt+0x85>
                width = precision;
  801d12:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  801d16:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801d1c:	eb 95                	jmp    801cb3 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801d1e:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  801d22:	49 8d 41 08          	lea    0x8(%r9),%rax
  801d26:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d2a:	eb da                	jmp    801d06 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  801d2c:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  801d30:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d34:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  801d38:	3c 39                	cmp    $0x39,%al
  801d3a:	77 1e                	ja     801d5a <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  801d3c:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  801d40:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  801d45:	0f b6 c0             	movzbl %al,%eax
  801d48:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d4d:	41 0f b6 07          	movzbl (%r15),%eax
  801d51:	3c 39                	cmp    $0x39,%al
  801d53:	76 e7                	jbe    801d3c <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  801d55:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  801d58:	eb b2                	jmp    801d0c <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  801d5a:	4c 89 fb             	mov    %r15,%rbx
  801d5d:	eb ad                	jmp    801d0c <vprintfmt+0xde>
            width = MAX(0, width);
  801d5f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801d62:	85 c0                	test   %eax,%eax
  801d64:	0f 48 c7             	cmovs  %edi,%eax
  801d67:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801d6a:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d6d:	e9 41 ff ff ff       	jmp    801cb3 <vprintfmt+0x85>
            lflag++;
  801d72:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801d75:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d78:	e9 36 ff ff ff       	jmp    801cb3 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  801d7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d80:	83 f8 2f             	cmp    $0x2f,%eax
  801d83:	77 18                	ja     801d9d <vprintfmt+0x16f>
  801d85:	89 c2                	mov    %eax,%edx
  801d87:	48 01 f2             	add    %rsi,%rdx
  801d8a:	83 c0 08             	add    $0x8,%eax
  801d8d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d90:	4c 89 f6             	mov    %r14,%rsi
  801d93:	8b 3a                	mov    (%rdx),%edi
  801d95:	41 ff d4             	call   *%r12
            break;
  801d98:	e9 c2 fe ff ff       	jmp    801c5f <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  801d9d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801da1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801da5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801da9:	eb e5                	jmp    801d90 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  801dab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801dae:	83 f8 2f             	cmp    $0x2f,%eax
  801db1:	77 5b                	ja     801e0e <vprintfmt+0x1e0>
  801db3:	89 c2                	mov    %eax,%edx
  801db5:	48 01 d6             	add    %rdx,%rsi
  801db8:	83 c0 08             	add    $0x8,%eax
  801dbb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801dbe:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  801dc0:	89 c8                	mov    %ecx,%eax
  801dc2:	c1 f8 1f             	sar    $0x1f,%eax
  801dc5:	31 c1                	xor    %eax,%ecx
  801dc7:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  801dc9:	83 f9 13             	cmp    $0x13,%ecx
  801dcc:	7f 4e                	jg     801e1c <vprintfmt+0x1ee>
  801dce:	48 63 c1             	movslq %ecx,%rax
  801dd1:	48 ba c0 2f 80 00 00 	movabs $0x802fc0,%rdx
  801dd8:	00 00 00 
  801ddb:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801ddf:	48 85 c0             	test   %rax,%rax
  801de2:	74 38                	je     801e1c <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  801de4:	48 89 c1             	mov    %rax,%rcx
  801de7:	48 ba f9 2a 80 00 00 	movabs $0x802af9,%rdx
  801dee:	00 00 00 
  801df1:	4c 89 f6             	mov    %r14,%rsi
  801df4:	4c 89 e7             	mov    %r12,%rdi
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfc:	49 b8 f1 1b 80 00 00 	movabs $0x801bf1,%r8
  801e03:	00 00 00 
  801e06:	41 ff d0             	call   *%r8
  801e09:	e9 51 fe ff ff       	jmp    801c5f <vprintfmt+0x31>
            int err = va_arg(aq, int);
  801e0e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801e12:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801e16:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e1a:	eb a2                	jmp    801dbe <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  801e1c:	48 ba 8c 2b 80 00 00 	movabs $0x802b8c,%rdx
  801e23:	00 00 00 
  801e26:	4c 89 f6             	mov    %r14,%rsi
  801e29:	4c 89 e7             	mov    %r12,%rdi
  801e2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e31:	49 b8 f1 1b 80 00 00 	movabs $0x801bf1,%r8
  801e38:	00 00 00 
  801e3b:	41 ff d0             	call   *%r8
  801e3e:	e9 1c fe ff ff       	jmp    801c5f <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  801e43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801e46:	83 f8 2f             	cmp    $0x2f,%eax
  801e49:	77 55                	ja     801ea0 <vprintfmt+0x272>
  801e4b:	89 c2                	mov    %eax,%edx
  801e4d:	48 01 d6             	add    %rdx,%rsi
  801e50:	83 c0 08             	add    $0x8,%eax
  801e53:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801e56:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  801e59:	48 85 d2             	test   %rdx,%rdx
  801e5c:	48 b8 85 2b 80 00 00 	movabs $0x802b85,%rax
  801e63:	00 00 00 
  801e66:	48 0f 45 c2          	cmovne %rdx,%rax
  801e6a:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  801e6e:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801e72:	7e 06                	jle    801e7a <vprintfmt+0x24c>
  801e74:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  801e78:	75 34                	jne    801eae <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801e7a:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  801e7e:	48 8d 58 01          	lea    0x1(%rax),%rbx
  801e82:	0f b6 00             	movzbl (%rax),%eax
  801e85:	84 c0                	test   %al,%al
  801e87:	0f 84 b2 00 00 00    	je     801f3f <vprintfmt+0x311>
  801e8d:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  801e91:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  801e96:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  801e9a:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  801e9e:	eb 74                	jmp    801f14 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  801ea0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801ea4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801ea8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801eac:	eb a8                	jmp    801e56 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  801eae:	49 63 f5             	movslq %r13d,%rsi
  801eb1:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  801eb5:	48 b8 01 24 80 00 00 	movabs $0x802401,%rax
  801ebc:	00 00 00 
  801ebf:	ff d0                	call   *%rax
  801ec1:	48 89 c2             	mov    %rax,%rdx
  801ec4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801ec7:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  801ec9:	8d 48 ff             	lea    -0x1(%rax),%ecx
  801ecc:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	7e a7                	jle    801e7a <vprintfmt+0x24c>
  801ed3:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  801ed7:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  801edb:	41 89 cd             	mov    %ecx,%r13d
  801ede:	4c 89 f6             	mov    %r14,%rsi
  801ee1:	89 df                	mov    %ebx,%edi
  801ee3:	41 ff d4             	call   *%r12
  801ee6:	41 83 ed 01          	sub    $0x1,%r13d
  801eea:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  801eee:	75 ee                	jne    801ede <vprintfmt+0x2b0>
  801ef0:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  801ef4:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  801ef8:	eb 80                	jmp    801e7a <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801efa:	0f b6 f8             	movzbl %al,%edi
  801efd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801f01:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801f04:	41 83 ef 01          	sub    $0x1,%r15d
  801f08:	48 83 c3 01          	add    $0x1,%rbx
  801f0c:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  801f10:	84 c0                	test   %al,%al
  801f12:	74 1f                	je     801f33 <vprintfmt+0x305>
  801f14:	45 85 ed             	test   %r13d,%r13d
  801f17:	78 06                	js     801f1f <vprintfmt+0x2f1>
  801f19:	41 83 ed 01          	sub    $0x1,%r13d
  801f1d:	78 46                	js     801f65 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801f1f:	45 84 f6             	test   %r14b,%r14b
  801f22:	74 d6                	je     801efa <vprintfmt+0x2cc>
  801f24:	8d 50 e0             	lea    -0x20(%rax),%edx
  801f27:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801f2c:	80 fa 5e             	cmp    $0x5e,%dl
  801f2f:	77 cc                	ja     801efd <vprintfmt+0x2cf>
  801f31:	eb c7                	jmp    801efa <vprintfmt+0x2cc>
  801f33:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f37:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f3b:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  801f3f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801f42:	8d 58 ff             	lea    -0x1(%rax),%ebx
  801f45:	85 c0                	test   %eax,%eax
  801f47:	0f 8e 12 fd ff ff    	jle    801c5f <vprintfmt+0x31>
  801f4d:	4c 89 f6             	mov    %r14,%rsi
  801f50:	bf 20 00 00 00       	mov    $0x20,%edi
  801f55:	41 ff d4             	call   *%r12
  801f58:	83 eb 01             	sub    $0x1,%ebx
  801f5b:	83 fb ff             	cmp    $0xffffffff,%ebx
  801f5e:	75 ed                	jne    801f4d <vprintfmt+0x31f>
  801f60:	e9 fa fc ff ff       	jmp    801c5f <vprintfmt+0x31>
  801f65:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f69:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f6d:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  801f71:	eb cc                	jmp    801f3f <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  801f73:	45 89 cd             	mov    %r9d,%r13d
  801f76:	84 c9                	test   %cl,%cl
  801f78:	75 25                	jne    801f9f <vprintfmt+0x371>
    switch (lflag) {
  801f7a:	85 d2                	test   %edx,%edx
  801f7c:	74 57                	je     801fd5 <vprintfmt+0x3a7>
  801f7e:	83 fa 01             	cmp    $0x1,%edx
  801f81:	74 78                	je     801ffb <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  801f83:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f86:	83 f8 2f             	cmp    $0x2f,%eax
  801f89:	0f 87 92 00 00 00    	ja     802021 <vprintfmt+0x3f3>
  801f8f:	89 c2                	mov    %eax,%edx
  801f91:	48 01 d6             	add    %rdx,%rsi
  801f94:	83 c0 08             	add    $0x8,%eax
  801f97:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f9a:	48 8b 1e             	mov    (%rsi),%rbx
  801f9d:	eb 16                	jmp    801fb5 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  801f9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fa2:	83 f8 2f             	cmp    $0x2f,%eax
  801fa5:	77 20                	ja     801fc7 <vprintfmt+0x399>
  801fa7:	89 c2                	mov    %eax,%edx
  801fa9:	48 01 d6             	add    %rdx,%rsi
  801fac:	83 c0 08             	add    $0x8,%eax
  801faf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fb2:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  801fb5:	48 85 db             	test   %rbx,%rbx
  801fb8:	78 78                	js     802032 <vprintfmt+0x404>
            num = i;
  801fba:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  801fbd:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  801fc2:	e9 49 02 00 00       	jmp    802210 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801fc7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fcb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fcf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fd3:	eb dd                	jmp    801fb2 <vprintfmt+0x384>
        return va_arg(*ap, int);
  801fd5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fd8:	83 f8 2f             	cmp    $0x2f,%eax
  801fdb:	77 10                	ja     801fed <vprintfmt+0x3bf>
  801fdd:	89 c2                	mov    %eax,%edx
  801fdf:	48 01 d6             	add    %rdx,%rsi
  801fe2:	83 c0 08             	add    $0x8,%eax
  801fe5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fe8:	48 63 1e             	movslq (%rsi),%rbx
  801feb:	eb c8                	jmp    801fb5 <vprintfmt+0x387>
  801fed:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801ff1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801ff5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ff9:	eb ed                	jmp    801fe8 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  801ffb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801ffe:	83 f8 2f             	cmp    $0x2f,%eax
  802001:	77 10                	ja     802013 <vprintfmt+0x3e5>
  802003:	89 c2                	mov    %eax,%edx
  802005:	48 01 d6             	add    %rdx,%rsi
  802008:	83 c0 08             	add    $0x8,%eax
  80200b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80200e:	48 8b 1e             	mov    (%rsi),%rbx
  802011:	eb a2                	jmp    801fb5 <vprintfmt+0x387>
  802013:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802017:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80201b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80201f:	eb ed                	jmp    80200e <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  802021:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802025:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802029:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80202d:	e9 68 ff ff ff       	jmp    801f9a <vprintfmt+0x36c>
                putch('-', put_arg);
  802032:	4c 89 f6             	mov    %r14,%rsi
  802035:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80203a:	41 ff d4             	call   *%r12
                i = -i;
  80203d:	48 f7 db             	neg    %rbx
  802040:	e9 75 ff ff ff       	jmp    801fba <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  802045:	45 89 cd             	mov    %r9d,%r13d
  802048:	84 c9                	test   %cl,%cl
  80204a:	75 2d                	jne    802079 <vprintfmt+0x44b>
    switch (lflag) {
  80204c:	85 d2                	test   %edx,%edx
  80204e:	74 57                	je     8020a7 <vprintfmt+0x479>
  802050:	83 fa 01             	cmp    $0x1,%edx
  802053:	74 7f                	je     8020d4 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  802055:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802058:	83 f8 2f             	cmp    $0x2f,%eax
  80205b:	0f 87 a1 00 00 00    	ja     802102 <vprintfmt+0x4d4>
  802061:	89 c2                	mov    %eax,%edx
  802063:	48 01 d6             	add    %rdx,%rsi
  802066:	83 c0 08             	add    $0x8,%eax
  802069:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80206c:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80206f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  802074:	e9 97 01 00 00       	jmp    802210 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802079:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80207c:	83 f8 2f             	cmp    $0x2f,%eax
  80207f:	77 18                	ja     802099 <vprintfmt+0x46b>
  802081:	89 c2                	mov    %eax,%edx
  802083:	48 01 d6             	add    %rdx,%rsi
  802086:	83 c0 08             	add    $0x8,%eax
  802089:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80208c:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80208f:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802094:	e9 77 01 00 00       	jmp    802210 <vprintfmt+0x5e2>
  802099:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80209d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020a1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020a5:	eb e5                	jmp    80208c <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8020a7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020aa:	83 f8 2f             	cmp    $0x2f,%eax
  8020ad:	77 17                	ja     8020c6 <vprintfmt+0x498>
  8020af:	89 c2                	mov    %eax,%edx
  8020b1:	48 01 d6             	add    %rdx,%rsi
  8020b4:	83 c0 08             	add    $0x8,%eax
  8020b7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020ba:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8020bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8020c1:	e9 4a 01 00 00       	jmp    802210 <vprintfmt+0x5e2>
  8020c6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020ca:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020ce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020d2:	eb e6                	jmp    8020ba <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8020d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020d7:	83 f8 2f             	cmp    $0x2f,%eax
  8020da:	77 18                	ja     8020f4 <vprintfmt+0x4c6>
  8020dc:	89 c2                	mov    %eax,%edx
  8020de:	48 01 d6             	add    %rdx,%rsi
  8020e1:	83 c0 08             	add    $0x8,%eax
  8020e4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020e7:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8020ea:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8020ef:	e9 1c 01 00 00       	jmp    802210 <vprintfmt+0x5e2>
  8020f4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020f8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020fc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802100:	eb e5                	jmp    8020e7 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  802102:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802106:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80210a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80210e:	e9 59 ff ff ff       	jmp    80206c <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  802113:	45 89 cd             	mov    %r9d,%r13d
  802116:	84 c9                	test   %cl,%cl
  802118:	75 2d                	jne    802147 <vprintfmt+0x519>
    switch (lflag) {
  80211a:	85 d2                	test   %edx,%edx
  80211c:	74 57                	je     802175 <vprintfmt+0x547>
  80211e:	83 fa 01             	cmp    $0x1,%edx
  802121:	74 7c                	je     80219f <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  802123:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802126:	83 f8 2f             	cmp    $0x2f,%eax
  802129:	0f 87 9b 00 00 00    	ja     8021ca <vprintfmt+0x59c>
  80212f:	89 c2                	mov    %eax,%edx
  802131:	48 01 d6             	add    %rdx,%rsi
  802134:	83 c0 08             	add    $0x8,%eax
  802137:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80213a:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80213d:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802142:	e9 c9 00 00 00       	jmp    802210 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802147:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80214a:	83 f8 2f             	cmp    $0x2f,%eax
  80214d:	77 18                	ja     802167 <vprintfmt+0x539>
  80214f:	89 c2                	mov    %eax,%edx
  802151:	48 01 d6             	add    %rdx,%rsi
  802154:	83 c0 08             	add    $0x8,%eax
  802157:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80215a:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80215d:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802162:	e9 a9 00 00 00       	jmp    802210 <vprintfmt+0x5e2>
  802167:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80216b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80216f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802173:	eb e5                	jmp    80215a <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  802175:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802178:	83 f8 2f             	cmp    $0x2f,%eax
  80217b:	77 14                	ja     802191 <vprintfmt+0x563>
  80217d:	89 c2                	mov    %eax,%edx
  80217f:	48 01 d6             	add    %rdx,%rsi
  802182:	83 c0 08             	add    $0x8,%eax
  802185:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802188:	8b 16                	mov    (%rsi),%edx
            base = 8;
  80218a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80218f:	eb 7f                	jmp    802210 <vprintfmt+0x5e2>
  802191:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802195:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802199:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80219d:	eb e9                	jmp    802188 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  80219f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021a2:	83 f8 2f             	cmp    $0x2f,%eax
  8021a5:	77 15                	ja     8021bc <vprintfmt+0x58e>
  8021a7:	89 c2                	mov    %eax,%edx
  8021a9:	48 01 d6             	add    %rdx,%rsi
  8021ac:	83 c0 08             	add    $0x8,%eax
  8021af:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021b2:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8021b5:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8021ba:	eb 54                	jmp    802210 <vprintfmt+0x5e2>
  8021bc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8021c0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8021c4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8021c8:	eb e8                	jmp    8021b2 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8021ca:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8021ce:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8021d2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8021d6:	e9 5f ff ff ff       	jmp    80213a <vprintfmt+0x50c>
            putch('0', put_arg);
  8021db:	45 89 cd             	mov    %r9d,%r13d
  8021de:	4c 89 f6             	mov    %r14,%rsi
  8021e1:	bf 30 00 00 00       	mov    $0x30,%edi
  8021e6:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8021e9:	4c 89 f6             	mov    %r14,%rsi
  8021ec:	bf 78 00 00 00       	mov    $0x78,%edi
  8021f1:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8021f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021f7:	83 f8 2f             	cmp    $0x2f,%eax
  8021fa:	77 47                	ja     802243 <vprintfmt+0x615>
  8021fc:	89 c2                	mov    %eax,%edx
  8021fe:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802202:	83 c0 08             	add    $0x8,%eax
  802205:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802208:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80220b:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  802210:	48 83 ec 08          	sub    $0x8,%rsp
  802214:	41 80 fd 58          	cmp    $0x58,%r13b
  802218:	0f 94 c0             	sete   %al
  80221b:	0f b6 c0             	movzbl %al,%eax
  80221e:	50                   	push   %rax
  80221f:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  802224:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  802228:	4c 89 f6             	mov    %r14,%rsi
  80222b:	4c 89 e7             	mov    %r12,%rdi
  80222e:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  802235:	00 00 00 
  802238:	ff d0                	call   *%rax
            break;
  80223a:	48 83 c4 10          	add    $0x10,%rsp
  80223e:	e9 1c fa ff ff       	jmp    801c5f <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  802243:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802247:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80224b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80224f:	eb b7                	jmp    802208 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  802251:	45 89 cd             	mov    %r9d,%r13d
  802254:	84 c9                	test   %cl,%cl
  802256:	75 2a                	jne    802282 <vprintfmt+0x654>
    switch (lflag) {
  802258:	85 d2                	test   %edx,%edx
  80225a:	74 54                	je     8022b0 <vprintfmt+0x682>
  80225c:	83 fa 01             	cmp    $0x1,%edx
  80225f:	74 7c                	je     8022dd <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  802261:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802264:	83 f8 2f             	cmp    $0x2f,%eax
  802267:	0f 87 9e 00 00 00    	ja     80230b <vprintfmt+0x6dd>
  80226d:	89 c2                	mov    %eax,%edx
  80226f:	48 01 d6             	add    %rdx,%rsi
  802272:	83 c0 08             	add    $0x8,%eax
  802275:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802278:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80227b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  802280:	eb 8e                	jmp    802210 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802282:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802285:	83 f8 2f             	cmp    $0x2f,%eax
  802288:	77 18                	ja     8022a2 <vprintfmt+0x674>
  80228a:	89 c2                	mov    %eax,%edx
  80228c:	48 01 d6             	add    %rdx,%rsi
  80228f:	83 c0 08             	add    $0x8,%eax
  802292:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802295:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802298:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80229d:	e9 6e ff ff ff       	jmp    802210 <vprintfmt+0x5e2>
  8022a2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022a6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022aa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022ae:	eb e5                	jmp    802295 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  8022b0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022b3:	83 f8 2f             	cmp    $0x2f,%eax
  8022b6:	77 17                	ja     8022cf <vprintfmt+0x6a1>
  8022b8:	89 c2                	mov    %eax,%edx
  8022ba:	48 01 d6             	add    %rdx,%rsi
  8022bd:	83 c0 08             	add    $0x8,%eax
  8022c0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022c3:	8b 16                	mov    (%rsi),%edx
            base = 16;
  8022c5:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8022ca:	e9 41 ff ff ff       	jmp    802210 <vprintfmt+0x5e2>
  8022cf:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022d3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022d7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022db:	eb e6                	jmp    8022c3 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8022dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022e0:	83 f8 2f             	cmp    $0x2f,%eax
  8022e3:	77 18                	ja     8022fd <vprintfmt+0x6cf>
  8022e5:	89 c2                	mov    %eax,%edx
  8022e7:	48 01 d6             	add    %rdx,%rsi
  8022ea:	83 c0 08             	add    $0x8,%eax
  8022ed:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022f0:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8022f3:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8022f8:	e9 13 ff ff ff       	jmp    802210 <vprintfmt+0x5e2>
  8022fd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802301:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802305:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802309:	eb e5                	jmp    8022f0 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  80230b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80230f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802313:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802317:	e9 5c ff ff ff       	jmp    802278 <vprintfmt+0x64a>
            putch(ch, put_arg);
  80231c:	4c 89 f6             	mov    %r14,%rsi
  80231f:	bf 25 00 00 00       	mov    $0x25,%edi
  802324:	41 ff d4             	call   *%r12
            break;
  802327:	e9 33 f9 ff ff       	jmp    801c5f <vprintfmt+0x31>
            putch('%', put_arg);
  80232c:	4c 89 f6             	mov    %r14,%rsi
  80232f:	bf 25 00 00 00       	mov    $0x25,%edi
  802334:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  802337:	49 83 ef 01          	sub    $0x1,%r15
  80233b:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  802340:	75 f5                	jne    802337 <vprintfmt+0x709>
  802342:	e9 18 f9 ff ff       	jmp    801c5f <vprintfmt+0x31>
}
  802347:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80234b:	5b                   	pop    %rbx
  80234c:	41 5c                	pop    %r12
  80234e:	41 5d                	pop    %r13
  802350:	41 5e                	pop    %r14
  802352:	41 5f                	pop    %r15
  802354:	5d                   	pop    %rbp
  802355:	c3                   	ret    

0000000000802356 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  802356:	55                   	push   %rbp
  802357:	48 89 e5             	mov    %rsp,%rbp
  80235a:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  80235e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802362:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  802367:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80236b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  802372:	48 85 ff             	test   %rdi,%rdi
  802375:	74 2b                	je     8023a2 <vsnprintf+0x4c>
  802377:	48 85 f6             	test   %rsi,%rsi
  80237a:	74 26                	je     8023a2 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  80237c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802380:	48 bf d9 1b 80 00 00 	movabs $0x801bd9,%rdi
  802387:	00 00 00 
  80238a:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  802391:	00 00 00 
  802394:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  802396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239a:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  80239d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  8023a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023a7:	eb f7                	jmp    8023a0 <vsnprintf+0x4a>

00000000008023a9 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8023a9:	55                   	push   %rbp
  8023aa:	48 89 e5             	mov    %rsp,%rbp
  8023ad:	48 83 ec 50          	sub    $0x50,%rsp
  8023b1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8023b5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8023b9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8023bd:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8023c4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8023c8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023cc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8023d0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  8023d4:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8023d8:	48 b8 56 23 80 00 00 	movabs $0x802356,%rax
  8023df:	00 00 00 
  8023e2:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

00000000008023e6 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  8023e6:	80 3f 00             	cmpb   $0x0,(%rdi)
  8023e9:	74 10                	je     8023fb <strlen+0x15>
    size_t n = 0;
  8023eb:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8023f0:	48 83 c0 01          	add    $0x1,%rax
  8023f4:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023f8:	75 f6                	jne    8023f0 <strlen+0xa>
  8023fa:	c3                   	ret    
    size_t n = 0;
  8023fb:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  802400:	c3                   	ret    

0000000000802401 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  802401:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  802406:	48 85 f6             	test   %rsi,%rsi
  802409:	74 10                	je     80241b <strnlen+0x1a>
  80240b:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  80240f:	74 09                	je     80241a <strnlen+0x19>
  802411:	48 83 c0 01          	add    $0x1,%rax
  802415:	48 39 c6             	cmp    %rax,%rsi
  802418:	75 f1                	jne    80240b <strnlen+0xa>
    return n;
}
  80241a:	c3                   	ret    
    size_t n = 0;
  80241b:	48 89 f0             	mov    %rsi,%rax
  80241e:	c3                   	ret    

000000000080241f <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80241f:	b8 00 00 00 00       	mov    $0x0,%eax
  802424:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  802428:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  80242b:	48 83 c0 01          	add    $0x1,%rax
  80242f:	84 d2                	test   %dl,%dl
  802431:	75 f1                	jne    802424 <strcpy+0x5>
        ;
    return res;
}
  802433:	48 89 f8             	mov    %rdi,%rax
  802436:	c3                   	ret    

0000000000802437 <strcat>:

char *
strcat(char *dst, const char *src) {
  802437:	55                   	push   %rbp
  802438:	48 89 e5             	mov    %rsp,%rbp
  80243b:	41 54                	push   %r12
  80243d:	53                   	push   %rbx
  80243e:	48 89 fb             	mov    %rdi,%rbx
  802441:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  802444:	48 b8 e6 23 80 00 00 	movabs $0x8023e6,%rax
  80244b:	00 00 00 
  80244e:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  802450:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  802454:	4c 89 e6             	mov    %r12,%rsi
  802457:	48 b8 1f 24 80 00 00 	movabs $0x80241f,%rax
  80245e:	00 00 00 
  802461:	ff d0                	call   *%rax
    return dst;
}
  802463:	48 89 d8             	mov    %rbx,%rax
  802466:	5b                   	pop    %rbx
  802467:	41 5c                	pop    %r12
  802469:	5d                   	pop    %rbp
  80246a:	c3                   	ret    

000000000080246b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  80246b:	48 85 d2             	test   %rdx,%rdx
  80246e:	74 1d                	je     80248d <strncpy+0x22>
  802470:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802474:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  802477:	48 83 c0 01          	add    $0x1,%rax
  80247b:	0f b6 16             	movzbl (%rsi),%edx
  80247e:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  802481:	80 fa 01             	cmp    $0x1,%dl
  802484:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  802488:	48 39 c1             	cmp    %rax,%rcx
  80248b:	75 ea                	jne    802477 <strncpy+0xc>
    }
    return ret;
}
  80248d:	48 89 f8             	mov    %rdi,%rax
  802490:	c3                   	ret    

0000000000802491 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  802491:	48 89 f8             	mov    %rdi,%rax
  802494:	48 85 d2             	test   %rdx,%rdx
  802497:	74 24                	je     8024bd <strlcpy+0x2c>
        while (--size > 0 && *src)
  802499:	48 83 ea 01          	sub    $0x1,%rdx
  80249d:	74 1b                	je     8024ba <strlcpy+0x29>
  80249f:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8024a3:	0f b6 16             	movzbl (%rsi),%edx
  8024a6:	84 d2                	test   %dl,%dl
  8024a8:	74 10                	je     8024ba <strlcpy+0x29>
            *dst++ = *src++;
  8024aa:	48 83 c6 01          	add    $0x1,%rsi
  8024ae:	48 83 c0 01          	add    $0x1,%rax
  8024b2:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  8024b5:	48 39 c8             	cmp    %rcx,%rax
  8024b8:	75 e9                	jne    8024a3 <strlcpy+0x12>
        *dst = '\0';
  8024ba:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  8024bd:	48 29 f8             	sub    %rdi,%rax
}
  8024c0:	c3                   	ret    

00000000008024c1 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  8024c1:	0f b6 07             	movzbl (%rdi),%eax
  8024c4:	84 c0                	test   %al,%al
  8024c6:	74 13                	je     8024db <strcmp+0x1a>
  8024c8:	38 06                	cmp    %al,(%rsi)
  8024ca:	75 0f                	jne    8024db <strcmp+0x1a>
  8024cc:	48 83 c7 01          	add    $0x1,%rdi
  8024d0:	48 83 c6 01          	add    $0x1,%rsi
  8024d4:	0f b6 07             	movzbl (%rdi),%eax
  8024d7:	84 c0                	test   %al,%al
  8024d9:	75 ed                	jne    8024c8 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8024db:	0f b6 c0             	movzbl %al,%eax
  8024de:	0f b6 16             	movzbl (%rsi),%edx
  8024e1:	29 d0                	sub    %edx,%eax
}
  8024e3:	c3                   	ret    

00000000008024e4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  8024e4:	48 85 d2             	test   %rdx,%rdx
  8024e7:	74 1f                	je     802508 <strncmp+0x24>
  8024e9:	0f b6 07             	movzbl (%rdi),%eax
  8024ec:	84 c0                	test   %al,%al
  8024ee:	74 1e                	je     80250e <strncmp+0x2a>
  8024f0:	3a 06                	cmp    (%rsi),%al
  8024f2:	75 1a                	jne    80250e <strncmp+0x2a>
  8024f4:	48 83 c7 01          	add    $0x1,%rdi
  8024f8:	48 83 c6 01          	add    $0x1,%rsi
  8024fc:	48 83 ea 01          	sub    $0x1,%rdx
  802500:	75 e7                	jne    8024e9 <strncmp+0x5>

    if (!n) return 0;
  802502:	b8 00 00 00 00       	mov    $0x0,%eax
  802507:	c3                   	ret    
  802508:	b8 00 00 00 00       	mov    $0x0,%eax
  80250d:	c3                   	ret    
  80250e:	48 85 d2             	test   %rdx,%rdx
  802511:	74 09                	je     80251c <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  802513:	0f b6 07             	movzbl (%rdi),%eax
  802516:	0f b6 16             	movzbl (%rsi),%edx
  802519:	29 d0                	sub    %edx,%eax
  80251b:	c3                   	ret    
    if (!n) return 0;
  80251c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802521:	c3                   	ret    

0000000000802522 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  802522:	0f b6 07             	movzbl (%rdi),%eax
  802525:	84 c0                	test   %al,%al
  802527:	74 18                	je     802541 <strchr+0x1f>
        if (*str == c) {
  802529:	0f be c0             	movsbl %al,%eax
  80252c:	39 f0                	cmp    %esi,%eax
  80252e:	74 17                	je     802547 <strchr+0x25>
    for (; *str; str++) {
  802530:	48 83 c7 01          	add    $0x1,%rdi
  802534:	0f b6 07             	movzbl (%rdi),%eax
  802537:	84 c0                	test   %al,%al
  802539:	75 ee                	jne    802529 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  80253b:	b8 00 00 00 00       	mov    $0x0,%eax
  802540:	c3                   	ret    
  802541:	b8 00 00 00 00       	mov    $0x0,%eax
  802546:	c3                   	ret    
  802547:	48 89 f8             	mov    %rdi,%rax
}
  80254a:	c3                   	ret    

000000000080254b <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  80254b:	0f b6 07             	movzbl (%rdi),%eax
  80254e:	84 c0                	test   %al,%al
  802550:	74 16                	je     802568 <strfind+0x1d>
  802552:	0f be c0             	movsbl %al,%eax
  802555:	39 f0                	cmp    %esi,%eax
  802557:	74 13                	je     80256c <strfind+0x21>
  802559:	48 83 c7 01          	add    $0x1,%rdi
  80255d:	0f b6 07             	movzbl (%rdi),%eax
  802560:	84 c0                	test   %al,%al
  802562:	75 ee                	jne    802552 <strfind+0x7>
  802564:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  802567:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  802568:	48 89 f8             	mov    %rdi,%rax
  80256b:	c3                   	ret    
  80256c:	48 89 f8             	mov    %rdi,%rax
  80256f:	c3                   	ret    

0000000000802570 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  802570:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  802573:	48 89 f8             	mov    %rdi,%rax
  802576:	48 f7 d8             	neg    %rax
  802579:	83 e0 07             	and    $0x7,%eax
  80257c:	49 89 d1             	mov    %rdx,%r9
  80257f:	49 29 c1             	sub    %rax,%r9
  802582:	78 32                	js     8025b6 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  802584:	40 0f b6 c6          	movzbl %sil,%eax
  802588:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  80258f:	01 01 01 
  802592:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  802596:	40 f6 c7 07          	test   $0x7,%dil
  80259a:	75 34                	jne    8025d0 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80259c:	4c 89 c9             	mov    %r9,%rcx
  80259f:	48 c1 f9 03          	sar    $0x3,%rcx
  8025a3:	74 08                	je     8025ad <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8025a5:	fc                   	cld    
  8025a6:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8025a9:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8025ad:	4d 85 c9             	test   %r9,%r9
  8025b0:	75 45                	jne    8025f7 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8025b2:	4c 89 c0             	mov    %r8,%rax
  8025b5:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  8025b6:	48 85 d2             	test   %rdx,%rdx
  8025b9:	74 f7                	je     8025b2 <memset+0x42>
  8025bb:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  8025be:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8025c1:	48 83 c0 01          	add    $0x1,%rax
  8025c5:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8025c9:	48 39 c2             	cmp    %rax,%rdx
  8025cc:	75 f3                	jne    8025c1 <memset+0x51>
  8025ce:	eb e2                	jmp    8025b2 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8025d0:	40 f6 c7 01          	test   $0x1,%dil
  8025d4:	74 06                	je     8025dc <memset+0x6c>
  8025d6:	88 07                	mov    %al,(%rdi)
  8025d8:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025dc:	40 f6 c7 02          	test   $0x2,%dil
  8025e0:	74 07                	je     8025e9 <memset+0x79>
  8025e2:	66 89 07             	mov    %ax,(%rdi)
  8025e5:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025e9:	40 f6 c7 04          	test   $0x4,%dil
  8025ed:	74 ad                	je     80259c <memset+0x2c>
  8025ef:	89 07                	mov    %eax,(%rdi)
  8025f1:	48 83 c7 04          	add    $0x4,%rdi
  8025f5:	eb a5                	jmp    80259c <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025f7:	41 f6 c1 04          	test   $0x4,%r9b
  8025fb:	74 06                	je     802603 <memset+0x93>
  8025fd:	89 07                	mov    %eax,(%rdi)
  8025ff:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  802603:	41 f6 c1 02          	test   $0x2,%r9b
  802607:	74 07                	je     802610 <memset+0xa0>
  802609:	66 89 07             	mov    %ax,(%rdi)
  80260c:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  802610:	41 f6 c1 01          	test   $0x1,%r9b
  802614:	74 9c                	je     8025b2 <memset+0x42>
  802616:	88 07                	mov    %al,(%rdi)
  802618:	eb 98                	jmp    8025b2 <memset+0x42>

000000000080261a <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  80261a:	48 89 f8             	mov    %rdi,%rax
  80261d:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  802620:	48 39 fe             	cmp    %rdi,%rsi
  802623:	73 39                	jae    80265e <memmove+0x44>
  802625:	48 01 f2             	add    %rsi,%rdx
  802628:	48 39 fa             	cmp    %rdi,%rdx
  80262b:	76 31                	jbe    80265e <memmove+0x44>
        s += n;
        d += n;
  80262d:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802630:	48 89 d6             	mov    %rdx,%rsi
  802633:	48 09 fe             	or     %rdi,%rsi
  802636:	48 09 ce             	or     %rcx,%rsi
  802639:	40 f6 c6 07          	test   $0x7,%sil
  80263d:	75 12                	jne    802651 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80263f:	48 83 ef 08          	sub    $0x8,%rdi
  802643:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  802647:	48 c1 e9 03          	shr    $0x3,%rcx
  80264b:	fd                   	std    
  80264c:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80264f:	fc                   	cld    
  802650:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  802651:	48 83 ef 01          	sub    $0x1,%rdi
  802655:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  802659:	fd                   	std    
  80265a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  80265c:	eb f1                	jmp    80264f <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80265e:	48 89 f2             	mov    %rsi,%rdx
  802661:	48 09 c2             	or     %rax,%rdx
  802664:	48 09 ca             	or     %rcx,%rdx
  802667:	f6 c2 07             	test   $0x7,%dl
  80266a:	75 0c                	jne    802678 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80266c:	48 c1 e9 03          	shr    $0x3,%rcx
  802670:	48 89 c7             	mov    %rax,%rdi
  802673:	fc                   	cld    
  802674:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  802677:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  802678:	48 89 c7             	mov    %rax,%rdi
  80267b:	fc                   	cld    
  80267c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  80267e:	c3                   	ret    

000000000080267f <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  80267f:	55                   	push   %rbp
  802680:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802683:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  80268a:	00 00 00 
  80268d:	ff d0                	call   *%rax
}
  80268f:	5d                   	pop    %rbp
  802690:	c3                   	ret    

0000000000802691 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802691:	55                   	push   %rbp
  802692:	48 89 e5             	mov    %rsp,%rbp
  802695:	41 57                	push   %r15
  802697:	41 56                	push   %r14
  802699:	41 55                	push   %r13
  80269b:	41 54                	push   %r12
  80269d:	53                   	push   %rbx
  80269e:	48 83 ec 08          	sub    $0x8,%rsp
  8026a2:	49 89 fe             	mov    %rdi,%r14
  8026a5:	49 89 f7             	mov    %rsi,%r15
  8026a8:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8026ab:	48 89 f7             	mov    %rsi,%rdi
  8026ae:	48 b8 e6 23 80 00 00 	movabs $0x8023e6,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	call   *%rax
  8026ba:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8026bd:	48 89 de             	mov    %rbx,%rsi
  8026c0:	4c 89 f7             	mov    %r14,%rdi
  8026c3:	48 b8 01 24 80 00 00 	movabs $0x802401,%rax
  8026ca:	00 00 00 
  8026cd:	ff d0                	call   *%rax
  8026cf:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8026d2:	48 39 c3             	cmp    %rax,%rbx
  8026d5:	74 36                	je     80270d <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  8026d7:	48 89 d8             	mov    %rbx,%rax
  8026da:	4c 29 e8             	sub    %r13,%rax
  8026dd:	4c 39 e0             	cmp    %r12,%rax
  8026e0:	76 30                	jbe    802712 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  8026e2:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8026e7:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026eb:	4c 89 fe             	mov    %r15,%rsi
  8026ee:	48 b8 7f 26 80 00 00 	movabs $0x80267f,%rax
  8026f5:	00 00 00 
  8026f8:	ff d0                	call   *%rax
    return dstlen + srclen;
  8026fa:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8026fe:	48 83 c4 08          	add    $0x8,%rsp
  802702:	5b                   	pop    %rbx
  802703:	41 5c                	pop    %r12
  802705:	41 5d                	pop    %r13
  802707:	41 5e                	pop    %r14
  802709:	41 5f                	pop    %r15
  80270b:	5d                   	pop    %rbp
  80270c:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  80270d:	4c 01 e0             	add    %r12,%rax
  802710:	eb ec                	jmp    8026fe <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  802712:	48 83 eb 01          	sub    $0x1,%rbx
  802716:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80271a:	48 89 da             	mov    %rbx,%rdx
  80271d:	4c 89 fe             	mov    %r15,%rsi
  802720:	48 b8 7f 26 80 00 00 	movabs $0x80267f,%rax
  802727:	00 00 00 
  80272a:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80272c:	49 01 de             	add    %rbx,%r14
  80272f:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  802734:	eb c4                	jmp    8026fa <strlcat+0x69>

0000000000802736 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  802736:	49 89 f0             	mov    %rsi,%r8
  802739:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  80273c:	48 85 d2             	test   %rdx,%rdx
  80273f:	74 2a                	je     80276b <memcmp+0x35>
  802741:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  802746:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  80274a:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80274f:	38 ca                	cmp    %cl,%dl
  802751:	75 0f                	jne    802762 <memcmp+0x2c>
    while (n-- > 0) {
  802753:	48 83 c0 01          	add    $0x1,%rax
  802757:	48 39 c6             	cmp    %rax,%rsi
  80275a:	75 ea                	jne    802746 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
  802761:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  802762:	0f b6 c2             	movzbl %dl,%eax
  802765:	0f b6 c9             	movzbl %cl,%ecx
  802768:	29 c8                	sub    %ecx,%eax
  80276a:	c3                   	ret    
    return 0;
  80276b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802770:	c3                   	ret    

0000000000802771 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  802771:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802775:	48 39 c7             	cmp    %rax,%rdi
  802778:	73 0f                	jae    802789 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  80277a:	40 38 37             	cmp    %sil,(%rdi)
  80277d:	74 0e                	je     80278d <memfind+0x1c>
    for (; src < end; src++) {
  80277f:	48 83 c7 01          	add    $0x1,%rdi
  802783:	48 39 f8             	cmp    %rdi,%rax
  802786:	75 f2                	jne    80277a <memfind+0x9>
  802788:	c3                   	ret    
  802789:	48 89 f8             	mov    %rdi,%rax
  80278c:	c3                   	ret    
  80278d:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802790:	c3                   	ret    

0000000000802791 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802791:	49 89 f2             	mov    %rsi,%r10
  802794:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802797:	0f b6 37             	movzbl (%rdi),%esi
  80279a:	40 80 fe 20          	cmp    $0x20,%sil
  80279e:	74 06                	je     8027a6 <strtol+0x15>
  8027a0:	40 80 fe 09          	cmp    $0x9,%sil
  8027a4:	75 13                	jne    8027b9 <strtol+0x28>
  8027a6:	48 83 c7 01          	add    $0x1,%rdi
  8027aa:	0f b6 37             	movzbl (%rdi),%esi
  8027ad:	40 80 fe 20          	cmp    $0x20,%sil
  8027b1:	74 f3                	je     8027a6 <strtol+0x15>
  8027b3:	40 80 fe 09          	cmp    $0x9,%sil
  8027b7:	74 ed                	je     8027a6 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8027b9:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8027bc:	83 e0 fd             	and    $0xfffffffd,%eax
  8027bf:	3c 01                	cmp    $0x1,%al
  8027c1:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8027c5:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  8027cc:	75 11                	jne    8027df <strtol+0x4e>
  8027ce:	80 3f 30             	cmpb   $0x30,(%rdi)
  8027d1:	74 16                	je     8027e9 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8027d3:	45 85 c0             	test   %r8d,%r8d
  8027d6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8027db:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8027df:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8027e4:	4d 63 c8             	movslq %r8d,%r9
  8027e7:	eb 38                	jmp    802821 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8027e9:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8027ed:	74 11                	je     802800 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8027ef:	45 85 c0             	test   %r8d,%r8d
  8027f2:	75 eb                	jne    8027df <strtol+0x4e>
        s++;
  8027f4:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8027f8:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8027fe:	eb df                	jmp    8027df <strtol+0x4e>
        s += 2;
  802800:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  802804:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  80280a:	eb d3                	jmp    8027df <strtol+0x4e>
            dig -= '0';
  80280c:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  80280f:	0f b6 c8             	movzbl %al,%ecx
  802812:	44 39 c1             	cmp    %r8d,%ecx
  802815:	7d 1f                	jge    802836 <strtol+0xa5>
        val = val * base + dig;
  802817:	49 0f af d1          	imul   %r9,%rdx
  80281b:	0f b6 c0             	movzbl %al,%eax
  80281e:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  802821:	48 83 c7 01          	add    $0x1,%rdi
  802825:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  802829:	3c 39                	cmp    $0x39,%al
  80282b:	76 df                	jbe    80280c <strtol+0x7b>
        else if (dig - 'a' < 27)
  80282d:	3c 7b                	cmp    $0x7b,%al
  80282f:	77 05                	ja     802836 <strtol+0xa5>
            dig -= 'a' - 10;
  802831:	83 e8 57             	sub    $0x57,%eax
  802834:	eb d9                	jmp    80280f <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  802836:	4d 85 d2             	test   %r10,%r10
  802839:	74 03                	je     80283e <strtol+0xad>
  80283b:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80283e:	48 89 d0             	mov    %rdx,%rax
  802841:	48 f7 d8             	neg    %rax
  802844:	40 80 fe 2d          	cmp    $0x2d,%sil
  802848:	48 0f 44 d0          	cmove  %rax,%rdx
}
  80284c:	48 89 d0             	mov    %rdx,%rax
  80284f:	c3                   	ret    

0000000000802850 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802850:	55                   	push   %rbp
  802851:	48 89 e5             	mov    %rsp,%rbp
  802854:	41 54                	push   %r12
  802856:	53                   	push   %rbx
  802857:	48 89 fb             	mov    %rdi,%rbx
  80285a:	48 89 f7             	mov    %rsi,%rdi
  80285d:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802860:	48 85 f6             	test   %rsi,%rsi
  802863:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80286a:	00 00 00 
  80286d:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802871:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802876:	48 85 d2             	test   %rdx,%rdx
  802879:	74 02                	je     80287d <ipc_recv+0x2d>
  80287b:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  80287d:	48 63 f6             	movslq %esi,%rsi
  802880:	48 b8 65 05 80 00 00 	movabs $0x800565,%rax
  802887:	00 00 00 
  80288a:	ff d0                	call   *%rax

    if (res < 0) {
  80288c:	85 c0                	test   %eax,%eax
  80288e:	78 45                	js     8028d5 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802890:	48 85 db             	test   %rbx,%rbx
  802893:	74 12                	je     8028a7 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802895:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80289c:	00 00 00 
  80289f:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  8028a5:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  8028a7:	4d 85 e4             	test   %r12,%r12
  8028aa:	74 14                	je     8028c0 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  8028ac:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8028b3:	00 00 00 
  8028b6:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8028bc:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  8028c0:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8028c7:	00 00 00 
  8028ca:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8028d0:	5b                   	pop    %rbx
  8028d1:	41 5c                	pop    %r12
  8028d3:	5d                   	pop    %rbp
  8028d4:	c3                   	ret    
        if (from_env_store)
  8028d5:	48 85 db             	test   %rbx,%rbx
  8028d8:	74 06                	je     8028e0 <ipc_recv+0x90>
            *from_env_store = 0;
  8028da:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8028e0:	4d 85 e4             	test   %r12,%r12
  8028e3:	74 eb                	je     8028d0 <ipc_recv+0x80>
            *perm_store = 0;
  8028e5:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028ec:	00 
  8028ed:	eb e1                	jmp    8028d0 <ipc_recv+0x80>

00000000008028ef <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028ef:	55                   	push   %rbp
  8028f0:	48 89 e5             	mov    %rsp,%rbp
  8028f3:	41 57                	push   %r15
  8028f5:	41 56                	push   %r14
  8028f7:	41 55                	push   %r13
  8028f9:	41 54                	push   %r12
  8028fb:	53                   	push   %rbx
  8028fc:	48 83 ec 18          	sub    $0x18,%rsp
  802900:	41 89 fd             	mov    %edi,%r13d
  802903:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802906:	48 89 d3             	mov    %rdx,%rbx
  802909:	49 89 cc             	mov    %rcx,%r12
  80290c:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802910:	48 85 d2             	test   %rdx,%rdx
  802913:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80291a:	00 00 00 
  80291d:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802921:	49 be 39 05 80 00 00 	movabs $0x800539,%r14
  802928:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  80292b:	49 bf 3c 02 80 00 00 	movabs $0x80023c,%r15
  802932:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802935:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802938:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  80293c:	4c 89 e1             	mov    %r12,%rcx
  80293f:	48 89 da             	mov    %rbx,%rdx
  802942:	44 89 ef             	mov    %r13d,%edi
  802945:	41 ff d6             	call   *%r14
  802948:	85 c0                	test   %eax,%eax
  80294a:	79 37                	jns    802983 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  80294c:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80294f:	75 05                	jne    802956 <ipc_send+0x67>
          sys_yield();
  802951:	41 ff d7             	call   *%r15
  802954:	eb df                	jmp    802935 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802956:	89 c1                	mov    %eax,%ecx
  802958:	48 ba 7f 30 80 00 00 	movabs $0x80307f,%rdx
  80295f:	00 00 00 
  802962:	be 46 00 00 00       	mov    $0x46,%esi
  802967:	48 bf 92 30 80 00 00 	movabs $0x803092,%rdi
  80296e:	00 00 00 
  802971:	b8 00 00 00 00       	mov    $0x0,%eax
  802976:	49 b8 8e 19 80 00 00 	movabs $0x80198e,%r8
  80297d:	00 00 00 
  802980:	41 ff d0             	call   *%r8
      }
}
  802983:	48 83 c4 18          	add    $0x18,%rsp
  802987:	5b                   	pop    %rbx
  802988:	41 5c                	pop    %r12
  80298a:	41 5d                	pop    %r13
  80298c:	41 5e                	pop    %r14
  80298e:	41 5f                	pop    %r15
  802990:	5d                   	pop    %rbp
  802991:	c3                   	ret    

0000000000802992 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802992:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802997:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  80299e:	00 00 00 
  8029a1:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8029a5:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8029a9:	48 c1 e2 04          	shl    $0x4,%rdx
  8029ad:	48 01 ca             	add    %rcx,%rdx
  8029b0:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8029b6:	39 fa                	cmp    %edi,%edx
  8029b8:	74 12                	je     8029cc <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  8029ba:	48 83 c0 01          	add    $0x1,%rax
  8029be:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8029c4:	75 db                	jne    8029a1 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8029c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029cb:	c3                   	ret    
            return envs[i].env_id;
  8029cc:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8029d0:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8029d4:	48 c1 e0 04          	shl    $0x4,%rax
  8029d8:	48 89 c2             	mov    %rax,%rdx
  8029db:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8029e2:	00 00 00 
  8029e5:	48 01 d0             	add    %rdx,%rax
  8029e8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029ee:	c3                   	ret    
  8029ef:	90                   	nop

00000000008029f0 <__rodata_start>:
  8029f0:	3c 75                	cmp    $0x75,%al
  8029f2:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029f3:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8029f7:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029f8:	3e 00 66 0f          	ds add %ah,0xf(%rsi)
  8029fc:	1f                   	(bad)  
  8029fd:	44 00 00             	add    %r8b,(%rax)
  802a00:	73 79                	jae    802a7b <__rodata_start+0x8b>
  802a02:	73 63                	jae    802a67 <__rodata_start+0x77>
  802a04:	61                   	(bad)  
  802a05:	6c                   	insb   (%dx),%es:(%rdi)
  802a06:	6c                   	insb   (%dx),%es:(%rdi)
  802a07:	20 25 7a 64 20 72    	and    %ah,0x7220647a(%rip)        # 72a08e87 <__bss_end+0x72200e87>
  802a0d:	65 74 75             	gs je  802a85 <__rodata_start+0x95>
  802a10:	72 6e                	jb     802a80 <__rodata_start+0x90>
  802a12:	65 64 20 25 7a 64 20 	gs and %ah,%fs:0x2820647a(%rip)        # 28a08e94 <__bss_end+0x28200e94>
  802a19:	28 
  802a1a:	3e 20 30             	ds and %dh,(%rax)
  802a1d:	29 00                	sub    %eax,(%rax)
  802a1f:	6c                   	insb   (%dx),%es:(%rdi)
  802a20:	69 62 2f 73 79 73 63 	imul   $0x63737973,0x2f(%rdx),%esp
  802a27:	61                   	(bad)  
  802a28:	6c                   	insb   (%dx),%es:(%rdi)
  802a29:	6c                   	insb   (%dx),%es:(%rdi)
  802a2a:	2e 63 00             	cs movsxd (%rax),%eax
  802a2d:	0f 1f 00             	nopl   (%rax)
  802a30:	5b                   	pop    %rbx
  802a31:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a36:	20 75 6e             	and    %dh,0x6e(%rbp)
  802a39:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802a3d:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a3e:	20 64 65 76          	and    %ah,0x76(%rbp,%riz,2)
  802a42:	69 63 65 20 74 79 70 	imul   $0x70797420,0x65(%rbx),%esp
  802a49:	65 20 25 64 0a 00 00 	and    %ah,%gs:0xa64(%rip)        # 8034b4 <error_string+0x4f4>
  802a50:	5b                   	pop    %rbx
  802a51:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a56:	20 66 74             	and    %ah,0x74(%rsi)
  802a59:	72 75                	jb     802ad0 <devtab+0x10>
  802a5b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a5c:	63 61 74             	movsxd 0x74(%rcx),%esp
  802a5f:	65 20 25 64 20 2d 2d 	and    %ah,%gs:0x2d2d2064(%rip)        # 2dad4aca <__bss_end+0x2d2ccaca>
  802a66:	20 62 61             	and    %ah,0x61(%rdx)
  802a69:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a6d:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a71:	5b                   	pop    %rbx
  802a72:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a77:	20 72 65             	and    %dh,0x65(%rdx)
  802a7a:	61                   	(bad)  
  802a7b:	64 20 25 64 20 2d 2d 	and    %ah,%fs:0x2d2d2064(%rip)        # 2dad4ae6 <__bss_end+0x2d2ccae6>
  802a82:	20 62 61             	and    %ah,0x61(%rdx)
  802a85:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a89:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a8d:	5b                   	pop    %rbx
  802a8e:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a93:	20 77 72             	and    %dh,0x72(%rdi)
  802a96:	69 74 65 20 25 64 20 	imul   $0x2d206425,0x20(%rbp,%riz,2),%esi
  802a9d:	2d 
  802a9e:	2d 20 62 61 64       	sub    $0x64616220,%eax
  802aa3:	20 6d 6f             	and    %ch,0x6f(%rbp)
  802aa6:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802aaa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ab1:	00 00 00 
  802ab4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802abb:	00 00 00 
  802abe:	66 90                	xchg   %ax,%ax

0000000000802ac0 <devtab>:
  802ac0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  802ad0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  802ae0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  802af0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  802b00:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  802b10:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  802b20:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  802b30:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  802b40:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  802b50:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  802b60:	3a 20 00 30 31 32 33 34 35 36 37 38 39 41 42 43     : .0123456789ABC
  802b70:	44 45 46 00 30 31 32 33 34 35 36 37 38 39 61 62     DEF.0123456789ab
  802b80:	63 64 65 66 00 28 6e 75 6c 6c 29 00 65 72 72 6f     cdef.(null).erro
  802b90:	72 20 25 64 00 75 6e 73 70 65 63 69 66 69 65 64     r %d.unspecified
  802ba0:	20 65 72 72 6f 72 00 62 61 64 20 65 6e 76 69 72      error.bad envir
  802bb0:	6f 6e 6d 65 6e 74 00 69 6e 76 61 6c 69 64 20 70     onment.invalid p
  802bc0:	61 72 61 6d 65 74 65 72 00 6f 75 74 20 6f 66 20     arameter.out of 
  802bd0:	6d 65 6d 6f 72 79 00 6f 75 74 20 6f 66 20 65 6e     memory.out of en
  802be0:	76 69 72 6f 6e 6d 65 6e 74 73 00 63 6f 72 72 75     vironments.corru
  802bf0:	70 74 65 64 20 64 65 62 75 67 20 69 6e 66 6f 00     pted debug info.
  802c00:	73 65 67 6d 65 6e 74 61 74 69 6f 6e 20 66 61 75     segmentation fau
  802c10:	6c 74 00 69 6e 76 61 6c 69 64 20 45 4c 46 20 69     lt.invalid ELF i
  802c20:	6d 61 67 65 00 6e 6f 20 73 75 63 68 20 73 79 73     mage.no such sys
  802c30:	74 65 6d 20 63 61 6c 6c 00 65 6e 74 72 79 20 6e     tem call.entry n
  802c40:	6f 74 20 66 6f 75 6e 64 00 65 6e 76 20 69 73 20     ot found.env is 
  802c50:	6e 6f 74 20 72 65 63 76 69 6e 67 00 75 6e 65 78     not recving.unex
  802c60:	70 65 63 74 65 64 20 65 6e 64 20 6f 66 20 66 69     pected end of fi
  802c70:	6c 65 00 6e 6f 20 66 72 65 65 20 73 70 61 63 65     le.no free space
  802c80:	20 6f 6e 20 64 69 73 6b 00 74 6f 6f 20 6d 61 6e      on disk.too man
  802c90:	79 20 66 69 6c 65 73 20 61 72 65 20 6f 70 65 6e     y files are open
  802ca0:	00 66 69 6c 65 20 6f 72 20 62 6c 6f 63 6b 20 6e     .file or block n
  802cb0:	6f 74 20 66 6f 75 6e 64 00 69 6e 76 61 6c 69 64     ot found.invalid
  802cc0:	20 70 61 74 68 00 66 69 6c 65 20 61 6c 72 65 61      path.file alrea
  802cd0:	64 79 20 65 78 69 73 74 73 00 6f 70 65 72 61 74     dy exists.operat
  802ce0:	69 6f 6e 20 6e 6f 74 20 73 75 70 70 6f 72 74 65     ion not supporte
  802cf0:	64 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00     d.f...........@.
  802d00:	d8 1c 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ........,#......
  802d10:	1c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     .#......,#......
  802d20:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802d30:	2c 23 80 00 00 00 00 00 f2 1c 80 00 00 00 00 00     ,#..............
  802d40:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802d50:	e9 1c 80 00 00 00 00 00 5f 1d 80 00 00 00 00 00     ........_.......
  802d60:	2c 23 80 00 00 00 00 00 e9 1c 80 00 00 00 00 00     ,#..............
  802d70:	2c 1d 80 00 00 00 00 00 2c 1d 80 00 00 00 00 00     ,.......,.......
  802d80:	2c 1d 80 00 00 00 00 00 2c 1d 80 00 00 00 00 00     ,.......,.......
  802d90:	2c 1d 80 00 00 00 00 00 2c 1d 80 00 00 00 00 00     ,.......,.......
  802da0:	2c 1d 80 00 00 00 00 00 2c 1d 80 00 00 00 00 00     ,.......,.......
  802db0:	2c 1d 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,.......,#......
  802dc0:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802dd0:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802de0:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802df0:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802e00:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802e10:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802e20:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802e30:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802e40:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802e50:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802e60:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802e70:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802e80:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802e90:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802ea0:	2c 23 80 00 00 00 00 00 51 22 80 00 00 00 00 00     ,#......Q"......
  802eb0:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802ec0:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802ed0:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802ee0:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802ef0:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802f00:	7d 1d 80 00 00 00 00 00 73 1f 80 00 00 00 00 00     }.......s.......
  802f10:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802f20:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802f30:	ab 1d 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ........,#......
  802f40:	2c 23 80 00 00 00 00 00 72 1d 80 00 00 00 00 00     ,#......r.......
  802f50:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802f60:	13 21 80 00 00 00 00 00 db 21 80 00 00 00 00 00     .!.......!......
  802f70:	2c 23 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     ,#......,#......
  802f80:	43 1e 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     C.......,#......
  802f90:	45 20 80 00 00 00 00 00 2c 23 80 00 00 00 00 00     E ......,#......
  802fa0:	2c 23 80 00 00 00 00 00 51 22 80 00 00 00 00 00     ,#......Q"......
  802fb0:	2c 23 80 00 00 00 00 00 e1 1c 80 00 00 00 00 00     ,#..............

0000000000802fc0 <error_string>:
	...
  802fc8:	95 2b 80 00 00 00 00 00 a7 2b 80 00 00 00 00 00     .+.......+......
  802fd8:	b7 2b 80 00 00 00 00 00 c9 2b 80 00 00 00 00 00     .+.......+......
  802fe8:	d7 2b 80 00 00 00 00 00 eb 2b 80 00 00 00 00 00     .+.......+......
  802ff8:	00 2c 80 00 00 00 00 00 13 2c 80 00 00 00 00 00     .,.......,......
  803008:	25 2c 80 00 00 00 00 00 39 2c 80 00 00 00 00 00     %,......9,......
  803018:	49 2c 80 00 00 00 00 00 5c 2c 80 00 00 00 00 00     I,......\,......
  803028:	73 2c 80 00 00 00 00 00 89 2c 80 00 00 00 00 00     s,.......,......
  803038:	a1 2c 80 00 00 00 00 00 b9 2c 80 00 00 00 00 00     .,.......,......
  803048:	c6 2c 80 00 00 00 00 00 60 30 80 00 00 00 00 00     .,......`0......
  803058:	da 2c 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .,......file is 
  803068:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803078:	75 74 61 62 6c 65 00 69 70 63 5f 73 65 6e 64 20     utable.ipc_send 
  803088:	65 72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69 70     error: %i.lib/ip
  803098:	63 2e 63 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     c.c.f.........f.
  8030a8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8030b8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8030c8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8030d8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8030e8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8030f8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803108:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803118:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803128:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803138:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803148:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803158:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803168:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803178:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803188:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803198:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8031a8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8031b8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8031c8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8031d8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8031e8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8031f8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803208:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803218:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803228:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803238:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803248:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803258:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803268:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803278:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803288:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803298:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8032a8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8032b8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8032c8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8032d8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8032e8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8032f8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803308:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803318:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803328:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803338:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803348:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803358:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803368:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803378:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803388:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803398:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8033a8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8033b8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8033c8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8033d8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8033e8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8033f8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803408:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803418:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803428:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803438:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803448:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803458:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803468:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803478:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803488:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803498:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034a8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8034b8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8034c8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034d8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8034e8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034f8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803508:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803518:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803528:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803538:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803548:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803558:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803568:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803578:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803588:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803598:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035a8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8035b8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035c8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8035d8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8035e8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035f8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803608:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803618:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803628:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803638:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803648:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803658:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803668:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803678:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803688:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803698:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036a8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8036b8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8036c8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8036d8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8036e8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036f8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803708:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803718:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803728:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803738:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803748:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803758:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803768:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803778:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803788:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803798:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037a8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8037b8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8037c8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8037d8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8037e8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037f8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803808:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803818:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803828:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803838:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803848:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803858:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803868:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803878:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803888:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803898:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038a8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8038b8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8038c8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8038d8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8038e8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038f8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803908:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803918:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803928:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803938:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803948:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803958:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803968:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803978:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803988:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803998:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039a8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8039b8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8039c8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8039d8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8039e8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039f8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a08:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a18:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a28:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a38:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a48:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a58:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a68:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a78:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a88:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a98:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803aa8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ab8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ac8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ad8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ae8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803af8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b08:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b18:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b28:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b38:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b48:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b58:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b68:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b78:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b88:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b98:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ba8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803bb8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803bc8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803bd8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803be8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803bf8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c08:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c18:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c28:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c38:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c48:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c58:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c68:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c78:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c88:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c98:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ca8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803cb8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803cc8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803cd8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ce8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803cf8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d08:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d18:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d28:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d38:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d48:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d58:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d68:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d78:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d88:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d98:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803da8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803db8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803dc8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803dd8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803de8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803df8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e08:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e18:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e28:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e38:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e48:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e58:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e68:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e78:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e88:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e98:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ea8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803eb8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ec8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ed8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ee8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ef8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f08:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f18:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f28:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f38:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f48:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f58:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f68:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f78:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f88:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f98:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803fa8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803fb8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803fc8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803fd8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803fe8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ff8:	0f 1f 84 00 00 00 00 00                             ........
