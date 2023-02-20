
obj/user/buggyhello:     file format elf64-x86-64


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
  80001e:	e8 1e 00 00 00       	call   800041 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
 * kernel should destroy user environment in response */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
    sys_cputs((char *)1, 1);
  800029:	be 01 00 00 00       	mov    $0x1,%esi
  80002e:	bf 01 00 00 00       	mov    $0x1,%edi
  800033:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  80003a:	00 00 00 
  80003d:	ff d0                	call   *%rax
}
  80003f:	5d                   	pop    %rbp
  800040:	c3                   	ret    

0000000000800041 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800041:	55                   	push   %rbp
  800042:	48 89 e5             	mov    %rsp,%rbp
  800045:	41 56                	push   %r14
  800047:	41 55                	push   %r13
  800049:	41 54                	push   %r12
  80004b:	53                   	push   %rbx
  80004c:	41 89 fd             	mov    %edi,%r13d
  80004f:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800052:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800059:	00 00 00 
  80005c:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800063:	00 00 00 
  800066:	48 39 c2             	cmp    %rax,%rdx
  800069:	73 17                	jae    800082 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80006b:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80006e:	49 89 c4             	mov    %rax,%r12
  800071:	48 83 c3 08          	add    $0x8,%rbx
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
  80007a:	ff 53 f8             	call   *-0x8(%rbx)
  80007d:	4c 39 e3             	cmp    %r12,%rbx
  800080:	72 ef                	jb     800071 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800082:	48 b8 db 01 80 00 00 	movabs $0x8001db,%rax
  800089:	00 00 00 
  80008c:	ff d0                	call   *%rax
  80008e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800093:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800097:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80009b:	48 c1 e0 04          	shl    $0x4,%rax
  80009f:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000a6:	00 00 00 
  8000a9:	48 01 d0             	add    %rdx,%rax
  8000ac:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000b3:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000b6:	45 85 ed             	test   %r13d,%r13d
  8000b9:	7e 0d                	jle    8000c8 <libmain+0x87>
  8000bb:	49 8b 06             	mov    (%r14),%rax
  8000be:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000c5:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000c8:	4c 89 f6             	mov    %r14,%rsi
  8000cb:	44 89 ef             	mov    %r13d,%edi
  8000ce:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000d5:	00 00 00 
  8000d8:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000da:	48 b8 ef 00 80 00 00 	movabs $0x8000ef,%rax
  8000e1:	00 00 00 
  8000e4:	ff d0                	call   *%rax
#endif
}
  8000e6:	5b                   	pop    %rbx
  8000e7:	41 5c                	pop    %r12
  8000e9:	41 5d                	pop    %r13
  8000eb:	41 5e                	pop    %r14
  8000ed:	5d                   	pop    %rbp
  8000ee:	c3                   	ret    

00000000008000ef <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000ef:	55                   	push   %rbp
  8000f0:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000f3:	48 b8 2b 08 80 00 00 	movabs $0x80082b,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8000ff:	bf 00 00 00 00       	mov    $0x0,%edi
  800104:	48 b8 70 01 80 00 00 	movabs $0x800170,%rax
  80010b:	00 00 00 
  80010e:	ff d0                	call   *%rax
}
  800110:	5d                   	pop    %rbp
  800111:	c3                   	ret    

0000000000800112 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800112:	55                   	push   %rbp
  800113:	48 89 e5             	mov    %rsp,%rbp
  800116:	53                   	push   %rbx
  800117:	48 89 fa             	mov    %rdi,%rdx
  80011a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80011d:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800122:	bb 00 00 00 00       	mov    $0x0,%ebx
  800127:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80012c:	be 00 00 00 00       	mov    $0x0,%esi
  800131:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800137:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800139:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80013d:	c9                   	leave  
  80013e:	c3                   	ret    

000000000080013f <sys_cgetc>:

int
sys_cgetc(void) {
  80013f:	55                   	push   %rbp
  800140:	48 89 e5             	mov    %rsp,%rbp
  800143:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800144:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800149:	ba 00 00 00 00       	mov    $0x0,%edx
  80014e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800153:	bb 00 00 00 00       	mov    $0x0,%ebx
  800158:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80015d:	be 00 00 00 00       	mov    $0x0,%esi
  800162:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800168:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80016a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80016e:	c9                   	leave  
  80016f:	c3                   	ret    

0000000000800170 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800170:	55                   	push   %rbp
  800171:	48 89 e5             	mov    %rsp,%rbp
  800174:	53                   	push   %rbx
  800175:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800179:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80017c:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800181:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800186:	bb 00 00 00 00       	mov    $0x0,%ebx
  80018b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800190:	be 00 00 00 00       	mov    $0x0,%esi
  800195:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80019b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80019d:	48 85 c0             	test   %rax,%rax
  8001a0:	7f 06                	jg     8001a8 <sys_env_destroy+0x38>
}
  8001a2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001a6:	c9                   	leave  
  8001a7:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001a8:	49 89 c0             	mov    %rax,%r8
  8001ab:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001b0:	48 ba d0 29 80 00 00 	movabs $0x8029d0,%rdx
  8001b7:	00 00 00 
  8001ba:	be 26 00 00 00       	mov    $0x26,%esi
  8001bf:	48 bf ef 29 80 00 00 	movabs $0x8029ef,%rdi
  8001c6:	00 00 00 
  8001c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ce:	49 b9 5e 19 80 00 00 	movabs $0x80195e,%r9
  8001d5:	00 00 00 
  8001d8:	41 ff d1             	call   *%r9

00000000008001db <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001db:	55                   	push   %rbp
  8001dc:	48 89 e5             	mov    %rsp,%rbp
  8001df:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001e0:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001f9:	be 00 00 00 00       	mov    $0x0,%esi
  8001fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800204:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800206:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

000000000080020c <sys_yield>:

void
sys_yield(void) {
  80020c:	55                   	push   %rbp
  80020d:	48 89 e5             	mov    %rsp,%rbp
  800210:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800211:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800216:	ba 00 00 00 00       	mov    $0x0,%edx
  80021b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800220:	bb 00 00 00 00       	mov    $0x0,%ebx
  800225:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80022a:	be 00 00 00 00       	mov    $0x0,%esi
  80022f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800235:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800237:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80023b:	c9                   	leave  
  80023c:	c3                   	ret    

000000000080023d <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80023d:	55                   	push   %rbp
  80023e:	48 89 e5             	mov    %rsp,%rbp
  800241:	53                   	push   %rbx
  800242:	48 89 fa             	mov    %rdi,%rdx
  800245:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800248:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80024d:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800254:	00 00 00 
  800257:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80025c:	be 00 00 00 00       	mov    $0x0,%esi
  800261:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800267:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800269:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

000000000080026f <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80026f:	55                   	push   %rbp
  800270:	48 89 e5             	mov    %rsp,%rbp
  800273:	53                   	push   %rbx
  800274:	49 89 f8             	mov    %rdi,%r8
  800277:	48 89 d3             	mov    %rdx,%rbx
  80027a:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80027d:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800282:	4c 89 c2             	mov    %r8,%rdx
  800285:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800288:	be 00 00 00 00       	mov    $0x0,%esi
  80028d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800293:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  800295:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800299:	c9                   	leave  
  80029a:	c3                   	ret    

000000000080029b <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80029b:	55                   	push   %rbp
  80029c:	48 89 e5             	mov    %rsp,%rbp
  80029f:	53                   	push   %rbx
  8002a0:	48 83 ec 08          	sub    $0x8,%rsp
  8002a4:	89 f8                	mov    %edi,%eax
  8002a6:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002a9:	48 63 f9             	movslq %ecx,%rdi
  8002ac:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002af:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002b4:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002b7:	be 00 00 00 00       	mov    $0x0,%esi
  8002bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002c2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002c4:	48 85 c0             	test   %rax,%rax
  8002c7:	7f 06                	jg     8002cf <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002c9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002cf:	49 89 c0             	mov    %rax,%r8
  8002d2:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002d7:	48 ba d0 29 80 00 00 	movabs $0x8029d0,%rdx
  8002de:	00 00 00 
  8002e1:	be 26 00 00 00       	mov    $0x26,%esi
  8002e6:	48 bf ef 29 80 00 00 	movabs $0x8029ef,%rdi
  8002ed:	00 00 00 
  8002f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f5:	49 b9 5e 19 80 00 00 	movabs $0x80195e,%r9
  8002fc:	00 00 00 
  8002ff:	41 ff d1             	call   *%r9

0000000000800302 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  800302:	55                   	push   %rbp
  800303:	48 89 e5             	mov    %rsp,%rbp
  800306:	53                   	push   %rbx
  800307:	48 83 ec 08          	sub    $0x8,%rsp
  80030b:	89 f8                	mov    %edi,%eax
  80030d:	49 89 f2             	mov    %rsi,%r10
  800310:	48 89 cf             	mov    %rcx,%rdi
  800313:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800316:	48 63 da             	movslq %edx,%rbx
  800319:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80031c:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800321:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800324:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800327:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800329:	48 85 c0             	test   %rax,%rax
  80032c:	7f 06                	jg     800334 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80032e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800332:	c9                   	leave  
  800333:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800334:	49 89 c0             	mov    %rax,%r8
  800337:	b9 05 00 00 00       	mov    $0x5,%ecx
  80033c:	48 ba d0 29 80 00 00 	movabs $0x8029d0,%rdx
  800343:	00 00 00 
  800346:	be 26 00 00 00       	mov    $0x26,%esi
  80034b:	48 bf ef 29 80 00 00 	movabs $0x8029ef,%rdi
  800352:	00 00 00 
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	49 b9 5e 19 80 00 00 	movabs $0x80195e,%r9
  800361:	00 00 00 
  800364:	41 ff d1             	call   *%r9

0000000000800367 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  800367:	55                   	push   %rbp
  800368:	48 89 e5             	mov    %rsp,%rbp
  80036b:	53                   	push   %rbx
  80036c:	48 83 ec 08          	sub    $0x8,%rsp
  800370:	48 89 f1             	mov    %rsi,%rcx
  800373:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  800376:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800379:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80037e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800383:	be 00 00 00 00       	mov    $0x0,%esi
  800388:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80038e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800390:	48 85 c0             	test   %rax,%rax
  800393:	7f 06                	jg     80039b <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  800395:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800399:	c9                   	leave  
  80039a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80039b:	49 89 c0             	mov    %rax,%r8
  80039e:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003a3:	48 ba d0 29 80 00 00 	movabs $0x8029d0,%rdx
  8003aa:	00 00 00 
  8003ad:	be 26 00 00 00       	mov    $0x26,%esi
  8003b2:	48 bf ef 29 80 00 00 	movabs $0x8029ef,%rdi
  8003b9:	00 00 00 
  8003bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c1:	49 b9 5e 19 80 00 00 	movabs $0x80195e,%r9
  8003c8:	00 00 00 
  8003cb:	41 ff d1             	call   *%r9

00000000008003ce <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8003ce:	55                   	push   %rbp
  8003cf:	48 89 e5             	mov    %rsp,%rbp
  8003d2:	53                   	push   %rbx
  8003d3:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8003d7:	48 63 ce             	movslq %esi,%rcx
  8003da:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8003dd:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8003e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003e7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003ec:	be 00 00 00 00       	mov    $0x0,%esi
  8003f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003f7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003f9:	48 85 c0             	test   %rax,%rax
  8003fc:	7f 06                	jg     800404 <sys_env_set_status+0x36>
}
  8003fe:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800402:	c9                   	leave  
  800403:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800404:	49 89 c0             	mov    %rax,%r8
  800407:	b9 09 00 00 00       	mov    $0x9,%ecx
  80040c:	48 ba d0 29 80 00 00 	movabs $0x8029d0,%rdx
  800413:	00 00 00 
  800416:	be 26 00 00 00       	mov    $0x26,%esi
  80041b:	48 bf ef 29 80 00 00 	movabs $0x8029ef,%rdi
  800422:	00 00 00 
  800425:	b8 00 00 00 00       	mov    $0x0,%eax
  80042a:	49 b9 5e 19 80 00 00 	movabs $0x80195e,%r9
  800431:	00 00 00 
  800434:	41 ff d1             	call   *%r9

0000000000800437 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  800437:	55                   	push   %rbp
  800438:	48 89 e5             	mov    %rsp,%rbp
  80043b:	53                   	push   %rbx
  80043c:	48 83 ec 08          	sub    $0x8,%rsp
  800440:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  800443:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800446:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80044b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800450:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800455:	be 00 00 00 00       	mov    $0x0,%esi
  80045a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800460:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800462:	48 85 c0             	test   %rax,%rax
  800465:	7f 06                	jg     80046d <sys_env_set_trapframe+0x36>
}
  800467:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80046b:	c9                   	leave  
  80046c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80046d:	49 89 c0             	mov    %rax,%r8
  800470:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800475:	48 ba d0 29 80 00 00 	movabs $0x8029d0,%rdx
  80047c:	00 00 00 
  80047f:	be 26 00 00 00       	mov    $0x26,%esi
  800484:	48 bf ef 29 80 00 00 	movabs $0x8029ef,%rdi
  80048b:	00 00 00 
  80048e:	b8 00 00 00 00       	mov    $0x0,%eax
  800493:	49 b9 5e 19 80 00 00 	movabs $0x80195e,%r9
  80049a:	00 00 00 
  80049d:	41 ff d1             	call   *%r9

00000000008004a0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8004a0:	55                   	push   %rbp
  8004a1:	48 89 e5             	mov    %rsp,%rbp
  8004a4:	53                   	push   %rbx
  8004a5:	48 83 ec 08          	sub    $0x8,%rsp
  8004a9:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8004ac:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004af:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004b9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004be:	be 00 00 00 00       	mov    $0x0,%esi
  8004c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004c9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004cb:	48 85 c0             	test   %rax,%rax
  8004ce:	7f 06                	jg     8004d6 <sys_env_set_pgfault_upcall+0x36>
}
  8004d0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004d6:	49 89 c0             	mov    %rax,%r8
  8004d9:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8004de:	48 ba d0 29 80 00 00 	movabs $0x8029d0,%rdx
  8004e5:	00 00 00 
  8004e8:	be 26 00 00 00       	mov    $0x26,%esi
  8004ed:	48 bf ef 29 80 00 00 	movabs $0x8029ef,%rdi
  8004f4:	00 00 00 
  8004f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fc:	49 b9 5e 19 80 00 00 	movabs $0x80195e,%r9
  800503:	00 00 00 
  800506:	41 ff d1             	call   *%r9

0000000000800509 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  800509:	55                   	push   %rbp
  80050a:	48 89 e5             	mov    %rsp,%rbp
  80050d:	53                   	push   %rbx
  80050e:	89 f8                	mov    %edi,%eax
  800510:	49 89 f1             	mov    %rsi,%r9
  800513:	48 89 d3             	mov    %rdx,%rbx
  800516:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  800519:	49 63 f0             	movslq %r8d,%rsi
  80051c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80051f:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800524:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800527:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80052d:	cd 30                	int    $0x30
}
  80052f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800533:	c9                   	leave  
  800534:	c3                   	ret    

0000000000800535 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  800535:	55                   	push   %rbp
  800536:	48 89 e5             	mov    %rsp,%rbp
  800539:	53                   	push   %rbx
  80053a:	48 83 ec 08          	sub    $0x8,%rsp
  80053e:	48 89 fa             	mov    %rdi,%rdx
  800541:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800544:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800549:	bb 00 00 00 00       	mov    $0x0,%ebx
  80054e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800553:	be 00 00 00 00       	mov    $0x0,%esi
  800558:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80055e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800560:	48 85 c0             	test   %rax,%rax
  800563:	7f 06                	jg     80056b <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800565:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800569:	c9                   	leave  
  80056a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80056b:	49 89 c0             	mov    %rax,%r8
  80056e:	b9 0e 00 00 00       	mov    $0xe,%ecx
  800573:	48 ba d0 29 80 00 00 	movabs $0x8029d0,%rdx
  80057a:	00 00 00 
  80057d:	be 26 00 00 00       	mov    $0x26,%esi
  800582:	48 bf ef 29 80 00 00 	movabs $0x8029ef,%rdi
  800589:	00 00 00 
  80058c:	b8 00 00 00 00       	mov    $0x0,%eax
  800591:	49 b9 5e 19 80 00 00 	movabs $0x80195e,%r9
  800598:	00 00 00 
  80059b:	41 ff d1             	call   *%r9

000000000080059e <sys_gettime>:

int
sys_gettime(void) {
  80059e:	55                   	push   %rbp
  80059f:	48 89 e5             	mov    %rsp,%rbp
  8005a2:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005a3:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ad:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005b7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005bc:	be 00 00 00 00       	mov    $0x0,%esi
  8005c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005c7:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8005c9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    

00000000008005cf <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8005cf:	55                   	push   %rbp
  8005d0:	48 89 e5             	mov    %rsp,%rbp
  8005d3:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005d4:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005de:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005e8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005ed:	be 00 00 00 00       	mov    $0x0,%esi
  8005f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005f8:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8005fa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005fe:	c9                   	leave  
  8005ff:	c3                   	ret    

0000000000800600 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800600:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800607:	ff ff ff 
  80060a:	48 01 f8             	add    %rdi,%rax
  80060d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800611:	c3                   	ret    

0000000000800612 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800612:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800619:	ff ff ff 
  80061c:	48 01 f8             	add    %rdi,%rax
  80061f:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  800623:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800629:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80062d:	c3                   	ret    

000000000080062e <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80062e:	55                   	push   %rbp
  80062f:	48 89 e5             	mov    %rsp,%rbp
  800632:	41 57                	push   %r15
  800634:	41 56                	push   %r14
  800636:	41 55                	push   %r13
  800638:	41 54                	push   %r12
  80063a:	53                   	push   %rbx
  80063b:	48 83 ec 08          	sub    $0x8,%rsp
  80063f:	49 89 ff             	mov    %rdi,%r15
  800642:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  800647:	49 bc dc 15 80 00 00 	movabs $0x8015dc,%r12
  80064e:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  800651:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  800657:	48 89 df             	mov    %rbx,%rdi
  80065a:	41 ff d4             	call   *%r12
  80065d:	83 e0 04             	and    $0x4,%eax
  800660:	74 1a                	je     80067c <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  800662:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  800669:	4c 39 f3             	cmp    %r14,%rbx
  80066c:	75 e9                	jne    800657 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  80066e:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  800675:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80067a:	eb 03                	jmp    80067f <fd_alloc+0x51>
            *fd_store = fd;
  80067c:	49 89 1f             	mov    %rbx,(%r15)
}
  80067f:	48 83 c4 08          	add    $0x8,%rsp
  800683:	5b                   	pop    %rbx
  800684:	41 5c                	pop    %r12
  800686:	41 5d                	pop    %r13
  800688:	41 5e                	pop    %r14
  80068a:	41 5f                	pop    %r15
  80068c:	5d                   	pop    %rbp
  80068d:	c3                   	ret    

000000000080068e <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  80068e:	83 ff 1f             	cmp    $0x1f,%edi
  800691:	77 39                	ja     8006cc <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  800693:	55                   	push   %rbp
  800694:	48 89 e5             	mov    %rsp,%rbp
  800697:	41 54                	push   %r12
  800699:	53                   	push   %rbx
  80069a:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80069d:	48 63 df             	movslq %edi,%rbx
  8006a0:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8006a7:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8006ab:	48 89 df             	mov    %rbx,%rdi
  8006ae:	48 b8 dc 15 80 00 00 	movabs $0x8015dc,%rax
  8006b5:	00 00 00 
  8006b8:	ff d0                	call   *%rax
  8006ba:	a8 04                	test   $0x4,%al
  8006bc:	74 14                	je     8006d2 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8006be:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8006c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006c7:	5b                   	pop    %rbx
  8006c8:	41 5c                	pop    %r12
  8006ca:	5d                   	pop    %rbp
  8006cb:	c3                   	ret    
        return -E_INVAL;
  8006cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006d1:	c3                   	ret    
        return -E_INVAL;
  8006d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006d7:	eb ee                	jmp    8006c7 <fd_lookup+0x39>

00000000008006d9 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8006d9:	55                   	push   %rbp
  8006da:	48 89 e5             	mov    %rsp,%rbp
  8006dd:	53                   	push   %rbx
  8006de:	48 83 ec 08          	sub    $0x8,%rsp
  8006e2:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8006e5:	48 ba 80 2a 80 00 00 	movabs $0x802a80,%rdx
  8006ec:	00 00 00 
  8006ef:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8006f6:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8006f9:	39 38                	cmp    %edi,(%rax)
  8006fb:	74 4b                	je     800748 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8006fd:	48 83 c2 08          	add    $0x8,%rdx
  800701:	48 8b 02             	mov    (%rdx),%rax
  800704:	48 85 c0             	test   %rax,%rax
  800707:	75 f0                	jne    8006f9 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800709:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800710:	00 00 00 
  800713:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800719:	89 fa                	mov    %edi,%edx
  80071b:	48 bf 00 2a 80 00 00 	movabs $0x802a00,%rdi
  800722:	00 00 00 
  800725:	b8 00 00 00 00       	mov    $0x0,%eax
  80072a:	48 b9 ae 1a 80 00 00 	movabs $0x801aae,%rcx
  800731:	00 00 00 
  800734:	ff d1                	call   *%rcx
    *dev = 0;
  800736:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  80073d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800742:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800746:	c9                   	leave  
  800747:	c3                   	ret    
            *dev = devtab[i];
  800748:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  80074b:	b8 00 00 00 00       	mov    $0x0,%eax
  800750:	eb f0                	jmp    800742 <dev_lookup+0x69>

0000000000800752 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  800752:	55                   	push   %rbp
  800753:	48 89 e5             	mov    %rsp,%rbp
  800756:	41 55                	push   %r13
  800758:	41 54                	push   %r12
  80075a:	53                   	push   %rbx
  80075b:	48 83 ec 18          	sub    $0x18,%rsp
  80075f:	49 89 fc             	mov    %rdi,%r12
  800762:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800765:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80076c:	ff ff ff 
  80076f:	4c 01 e7             	add    %r12,%rdi
  800772:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  800776:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80077a:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  800781:	00 00 00 
  800784:	ff d0                	call   *%rax
  800786:	89 c3                	mov    %eax,%ebx
  800788:	85 c0                	test   %eax,%eax
  80078a:	78 06                	js     800792 <fd_close+0x40>
  80078c:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  800790:	74 18                	je     8007aa <fd_close+0x58>
        return (must_exist ? res : 0);
  800792:	45 84 ed             	test   %r13b,%r13b
  800795:	b8 00 00 00 00       	mov    $0x0,%eax
  80079a:	0f 44 d8             	cmove  %eax,%ebx
}
  80079d:	89 d8                	mov    %ebx,%eax
  80079f:	48 83 c4 18          	add    $0x18,%rsp
  8007a3:	5b                   	pop    %rbx
  8007a4:	41 5c                	pop    %r12
  8007a6:	41 5d                	pop    %r13
  8007a8:	5d                   	pop    %rbp
  8007a9:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8007aa:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8007ae:	41 8b 3c 24          	mov    (%r12),%edi
  8007b2:	48 b8 d9 06 80 00 00 	movabs $0x8006d9,%rax
  8007b9:	00 00 00 
  8007bc:	ff d0                	call   *%rax
  8007be:	89 c3                	mov    %eax,%ebx
  8007c0:	85 c0                	test   %eax,%eax
  8007c2:	78 19                	js     8007dd <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8007c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8007c8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007d1:	48 85 c0             	test   %rax,%rax
  8007d4:	74 07                	je     8007dd <fd_close+0x8b>
  8007d6:	4c 89 e7             	mov    %r12,%rdi
  8007d9:	ff d0                	call   *%rax
  8007db:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8007dd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8007e2:	4c 89 e6             	mov    %r12,%rsi
  8007e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8007ea:	48 b8 67 03 80 00 00 	movabs $0x800367,%rax
  8007f1:	00 00 00 
  8007f4:	ff d0                	call   *%rax
    return res;
  8007f6:	eb a5                	jmp    80079d <fd_close+0x4b>

00000000008007f8 <close>:

int
close(int fdnum) {
  8007f8:	55                   	push   %rbp
  8007f9:	48 89 e5             	mov    %rsp,%rbp
  8007fc:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  800800:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800804:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  80080b:	00 00 00 
  80080e:	ff d0                	call   *%rax
    if (res < 0) return res;
  800810:	85 c0                	test   %eax,%eax
  800812:	78 15                	js     800829 <close+0x31>

    return fd_close(fd, 1);
  800814:	be 01 00 00 00       	mov    $0x1,%esi
  800819:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80081d:	48 b8 52 07 80 00 00 	movabs $0x800752,%rax
  800824:	00 00 00 
  800827:	ff d0                	call   *%rax
}
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

000000000080082b <close_all>:

void
close_all(void) {
  80082b:	55                   	push   %rbp
  80082c:	48 89 e5             	mov    %rsp,%rbp
  80082f:	41 54                	push   %r12
  800831:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  800832:	bb 00 00 00 00       	mov    $0x0,%ebx
  800837:	49 bc f8 07 80 00 00 	movabs $0x8007f8,%r12
  80083e:	00 00 00 
  800841:	89 df                	mov    %ebx,%edi
  800843:	41 ff d4             	call   *%r12
  800846:	83 c3 01             	add    $0x1,%ebx
  800849:	83 fb 20             	cmp    $0x20,%ebx
  80084c:	75 f3                	jne    800841 <close_all+0x16>
}
  80084e:	5b                   	pop    %rbx
  80084f:	41 5c                	pop    %r12
  800851:	5d                   	pop    %rbp
  800852:	c3                   	ret    

0000000000800853 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  800853:	55                   	push   %rbp
  800854:	48 89 e5             	mov    %rsp,%rbp
  800857:	41 56                	push   %r14
  800859:	41 55                	push   %r13
  80085b:	41 54                	push   %r12
  80085d:	53                   	push   %rbx
  80085e:	48 83 ec 10          	sub    $0x10,%rsp
  800862:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  800865:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800869:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  800870:	00 00 00 
  800873:	ff d0                	call   *%rax
  800875:	89 c3                	mov    %eax,%ebx
  800877:	85 c0                	test   %eax,%eax
  800879:	0f 88 b7 00 00 00    	js     800936 <dup+0xe3>
    close(newfdnum);
  80087f:	44 89 e7             	mov    %r12d,%edi
  800882:	48 b8 f8 07 80 00 00 	movabs $0x8007f8,%rax
  800889:	00 00 00 
  80088c:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80088e:	4d 63 ec             	movslq %r12d,%r13
  800891:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  800898:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  80089c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8008a0:	49 be 12 06 80 00 00 	movabs $0x800612,%r14
  8008a7:	00 00 00 
  8008aa:	41 ff d6             	call   *%r14
  8008ad:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8008b0:	4c 89 ef             	mov    %r13,%rdi
  8008b3:	41 ff d6             	call   *%r14
  8008b6:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8008b9:	48 89 df             	mov    %rbx,%rdi
  8008bc:	48 b8 dc 15 80 00 00 	movabs $0x8015dc,%rax
  8008c3:	00 00 00 
  8008c6:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8008c8:	a8 04                	test   $0x4,%al
  8008ca:	74 2b                	je     8008f7 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8008cc:	41 89 c1             	mov    %eax,%r9d
  8008cf:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8008d5:	4c 89 f1             	mov    %r14,%rcx
  8008d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dd:	48 89 de             	mov    %rbx,%rsi
  8008e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8008e5:	48 b8 02 03 80 00 00 	movabs $0x800302,%rax
  8008ec:	00 00 00 
  8008ef:	ff d0                	call   *%rax
  8008f1:	89 c3                	mov    %eax,%ebx
  8008f3:	85 c0                	test   %eax,%eax
  8008f5:	78 4e                	js     800945 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8008f7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8008fb:	48 b8 dc 15 80 00 00 	movabs $0x8015dc,%rax
  800902:	00 00 00 
  800905:	ff d0                	call   *%rax
  800907:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  80090a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800910:	4c 89 e9             	mov    %r13,%rcx
  800913:	ba 00 00 00 00       	mov    $0x0,%edx
  800918:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80091c:	bf 00 00 00 00       	mov    $0x0,%edi
  800921:	48 b8 02 03 80 00 00 	movabs $0x800302,%rax
  800928:	00 00 00 
  80092b:	ff d0                	call   *%rax
  80092d:	89 c3                	mov    %eax,%ebx
  80092f:	85 c0                	test   %eax,%eax
  800931:	78 12                	js     800945 <dup+0xf2>

    return newfdnum;
  800933:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  800936:	89 d8                	mov    %ebx,%eax
  800938:	48 83 c4 10          	add    $0x10,%rsp
  80093c:	5b                   	pop    %rbx
  80093d:	41 5c                	pop    %r12
  80093f:	41 5d                	pop    %r13
  800941:	41 5e                	pop    %r14
  800943:	5d                   	pop    %rbp
  800944:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  800945:	ba 00 10 00 00       	mov    $0x1000,%edx
  80094a:	4c 89 ee             	mov    %r13,%rsi
  80094d:	bf 00 00 00 00       	mov    $0x0,%edi
  800952:	49 bc 67 03 80 00 00 	movabs $0x800367,%r12
  800959:	00 00 00 
  80095c:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80095f:	ba 00 10 00 00       	mov    $0x1000,%edx
  800964:	4c 89 f6             	mov    %r14,%rsi
  800967:	bf 00 00 00 00       	mov    $0x0,%edi
  80096c:	41 ff d4             	call   *%r12
    return res;
  80096f:	eb c5                	jmp    800936 <dup+0xe3>

0000000000800971 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800971:	55                   	push   %rbp
  800972:	48 89 e5             	mov    %rsp,%rbp
  800975:	41 55                	push   %r13
  800977:	41 54                	push   %r12
  800979:	53                   	push   %rbx
  80097a:	48 83 ec 18          	sub    $0x18,%rsp
  80097e:	89 fb                	mov    %edi,%ebx
  800980:	49 89 f4             	mov    %rsi,%r12
  800983:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800986:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80098a:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  800991:	00 00 00 
  800994:	ff d0                	call   *%rax
  800996:	85 c0                	test   %eax,%eax
  800998:	78 49                	js     8009e3 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80099a:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80099e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009a2:	8b 38                	mov    (%rax),%edi
  8009a4:	48 b8 d9 06 80 00 00 	movabs $0x8006d9,%rax
  8009ab:	00 00 00 
  8009ae:	ff d0                	call   *%rax
  8009b0:	85 c0                	test   %eax,%eax
  8009b2:	78 33                	js     8009e7 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8009b4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8009b8:	8b 47 08             	mov    0x8(%rdi),%eax
  8009bb:	83 e0 03             	and    $0x3,%eax
  8009be:	83 f8 01             	cmp    $0x1,%eax
  8009c1:	74 28                	je     8009eb <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8009c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009c7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8009cb:	48 85 c0             	test   %rax,%rax
  8009ce:	74 51                	je     800a21 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8009d0:	4c 89 ea             	mov    %r13,%rdx
  8009d3:	4c 89 e6             	mov    %r12,%rsi
  8009d6:	ff d0                	call   *%rax
}
  8009d8:	48 83 c4 18          	add    $0x18,%rsp
  8009dc:	5b                   	pop    %rbx
  8009dd:	41 5c                	pop    %r12
  8009df:	41 5d                	pop    %r13
  8009e1:	5d                   	pop    %rbp
  8009e2:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8009e3:	48 98                	cltq   
  8009e5:	eb f1                	jmp    8009d8 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8009e7:	48 98                	cltq   
  8009e9:	eb ed                	jmp    8009d8 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8009eb:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8009f2:	00 00 00 
  8009f5:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8009fb:	89 da                	mov    %ebx,%edx
  8009fd:	48 bf 41 2a 80 00 00 	movabs $0x802a41,%rdi
  800a04:	00 00 00 
  800a07:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0c:	48 b9 ae 1a 80 00 00 	movabs $0x801aae,%rcx
  800a13:	00 00 00 
  800a16:	ff d1                	call   *%rcx
        return -E_INVAL;
  800a18:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800a1f:	eb b7                	jmp    8009d8 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800a21:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800a28:	eb ae                	jmp    8009d8 <read+0x67>

0000000000800a2a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800a2a:	55                   	push   %rbp
  800a2b:	48 89 e5             	mov    %rsp,%rbp
  800a2e:	41 57                	push   %r15
  800a30:	41 56                	push   %r14
  800a32:	41 55                	push   %r13
  800a34:	41 54                	push   %r12
  800a36:	53                   	push   %rbx
  800a37:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800a3b:	48 85 d2             	test   %rdx,%rdx
  800a3e:	74 54                	je     800a94 <readn+0x6a>
  800a40:	41 89 fd             	mov    %edi,%r13d
  800a43:	49 89 f6             	mov    %rsi,%r14
  800a46:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800a49:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800a4e:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800a53:	49 bf 71 09 80 00 00 	movabs $0x800971,%r15
  800a5a:	00 00 00 
  800a5d:	4c 89 e2             	mov    %r12,%rdx
  800a60:	48 29 f2             	sub    %rsi,%rdx
  800a63:	4c 01 f6             	add    %r14,%rsi
  800a66:	44 89 ef             	mov    %r13d,%edi
  800a69:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800a6c:	85 c0                	test   %eax,%eax
  800a6e:	78 20                	js     800a90 <readn+0x66>
    for (; inc && res < n; res += inc) {
  800a70:	01 c3                	add    %eax,%ebx
  800a72:	85 c0                	test   %eax,%eax
  800a74:	74 08                	je     800a7e <readn+0x54>
  800a76:	48 63 f3             	movslq %ebx,%rsi
  800a79:	4c 39 e6             	cmp    %r12,%rsi
  800a7c:	72 df                	jb     800a5d <readn+0x33>
    }
    return res;
  800a7e:	48 63 c3             	movslq %ebx,%rax
}
  800a81:	48 83 c4 08          	add    $0x8,%rsp
  800a85:	5b                   	pop    %rbx
  800a86:	41 5c                	pop    %r12
  800a88:	41 5d                	pop    %r13
  800a8a:	41 5e                	pop    %r14
  800a8c:	41 5f                	pop    %r15
  800a8e:	5d                   	pop    %rbp
  800a8f:	c3                   	ret    
        if (inc < 0) return inc;
  800a90:	48 98                	cltq   
  800a92:	eb ed                	jmp    800a81 <readn+0x57>
    int inc = 1, res = 0;
  800a94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a99:	eb e3                	jmp    800a7e <readn+0x54>

0000000000800a9b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800a9b:	55                   	push   %rbp
  800a9c:	48 89 e5             	mov    %rsp,%rbp
  800a9f:	41 55                	push   %r13
  800aa1:	41 54                	push   %r12
  800aa3:	53                   	push   %rbx
  800aa4:	48 83 ec 18          	sub    $0x18,%rsp
  800aa8:	89 fb                	mov    %edi,%ebx
  800aaa:	49 89 f4             	mov    %rsi,%r12
  800aad:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800ab0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800ab4:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  800abb:	00 00 00 
  800abe:	ff d0                	call   *%rax
  800ac0:	85 c0                	test   %eax,%eax
  800ac2:	78 44                	js     800b08 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800ac4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800ac8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800acc:	8b 38                	mov    (%rax),%edi
  800ace:	48 b8 d9 06 80 00 00 	movabs $0x8006d9,%rax
  800ad5:	00 00 00 
  800ad8:	ff d0                	call   *%rax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	78 2e                	js     800b0c <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ade:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ae2:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800ae6:	74 28                	je     800b10 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800ae8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800aec:	48 8b 40 18          	mov    0x18(%rax),%rax
  800af0:	48 85 c0             	test   %rax,%rax
  800af3:	74 51                	je     800b46 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  800af5:	4c 89 ea             	mov    %r13,%rdx
  800af8:	4c 89 e6             	mov    %r12,%rsi
  800afb:	ff d0                	call   *%rax
}
  800afd:	48 83 c4 18          	add    $0x18,%rsp
  800b01:	5b                   	pop    %rbx
  800b02:	41 5c                	pop    %r12
  800b04:	41 5d                	pop    %r13
  800b06:	5d                   	pop    %rbp
  800b07:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b08:	48 98                	cltq   
  800b0a:	eb f1                	jmp    800afd <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b0c:	48 98                	cltq   
  800b0e:	eb ed                	jmp    800afd <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b10:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800b17:	00 00 00 
  800b1a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800b20:	89 da                	mov    %ebx,%edx
  800b22:	48 bf 5d 2a 80 00 00 	movabs $0x802a5d,%rdi
  800b29:	00 00 00 
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b31:	48 b9 ae 1a 80 00 00 	movabs $0x801aae,%rcx
  800b38:	00 00 00 
  800b3b:	ff d1                	call   *%rcx
        return -E_INVAL;
  800b3d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800b44:	eb b7                	jmp    800afd <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800b46:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800b4d:	eb ae                	jmp    800afd <write+0x62>

0000000000800b4f <seek>:

int
seek(int fdnum, off_t offset) {
  800b4f:	55                   	push   %rbp
  800b50:	48 89 e5             	mov    %rsp,%rbp
  800b53:	53                   	push   %rbx
  800b54:	48 83 ec 18          	sub    $0x18,%rsp
  800b58:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b5a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b5e:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  800b65:	00 00 00 
  800b68:	ff d0                	call   *%rax
  800b6a:	85 c0                	test   %eax,%eax
  800b6c:	78 0c                	js     800b7a <seek+0x2b>

    fd->fd_offset = offset;
  800b6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b72:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800b75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800b7e:	c9                   	leave  
  800b7f:	c3                   	ret    

0000000000800b80 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800b80:	55                   	push   %rbp
  800b81:	48 89 e5             	mov    %rsp,%rbp
  800b84:	41 54                	push   %r12
  800b86:	53                   	push   %rbx
  800b87:	48 83 ec 10          	sub    $0x10,%rsp
  800b8b:	89 fb                	mov    %edi,%ebx
  800b8d:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b90:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b94:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  800b9b:	00 00 00 
  800b9e:	ff d0                	call   *%rax
  800ba0:	85 c0                	test   %eax,%eax
  800ba2:	78 36                	js     800bda <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800ba4:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800ba8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bac:	8b 38                	mov    (%rax),%edi
  800bae:	48 b8 d9 06 80 00 00 	movabs $0x8006d9,%rax
  800bb5:	00 00 00 
  800bb8:	ff d0                	call   *%rax
  800bba:	85 c0                	test   %eax,%eax
  800bbc:	78 1c                	js     800bda <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bbe:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800bc2:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800bc6:	74 1b                	je     800be3 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800bc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800bcc:	48 8b 40 30          	mov    0x30(%rax),%rax
  800bd0:	48 85 c0             	test   %rax,%rax
  800bd3:	74 42                	je     800c17 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  800bd5:	44 89 e6             	mov    %r12d,%esi
  800bd8:	ff d0                	call   *%rax
}
  800bda:	48 83 c4 10          	add    $0x10,%rsp
  800bde:	5b                   	pop    %rbx
  800bdf:	41 5c                	pop    %r12
  800be1:	5d                   	pop    %rbp
  800be2:	c3                   	ret    
                thisenv->env_id, fdnum);
  800be3:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bea:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800bed:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800bf3:	89 da                	mov    %ebx,%edx
  800bf5:	48 bf 20 2a 80 00 00 	movabs $0x802a20,%rdi
  800bfc:	00 00 00 
  800bff:	b8 00 00 00 00       	mov    $0x0,%eax
  800c04:	48 b9 ae 1a 80 00 00 	movabs $0x801aae,%rcx
  800c0b:	00 00 00 
  800c0e:	ff d1                	call   *%rcx
        return -E_INVAL;
  800c10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c15:	eb c3                	jmp    800bda <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c17:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c1c:	eb bc                	jmp    800bda <ftruncate+0x5a>

0000000000800c1e <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800c1e:	55                   	push   %rbp
  800c1f:	48 89 e5             	mov    %rsp,%rbp
  800c22:	53                   	push   %rbx
  800c23:	48 83 ec 18          	sub    $0x18,%rsp
  800c27:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c2a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c2e:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  800c35:	00 00 00 
  800c38:	ff d0                	call   *%rax
  800c3a:	85 c0                	test   %eax,%eax
  800c3c:	78 4d                	js     800c8b <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c3e:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800c42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c46:	8b 38                	mov    (%rax),%edi
  800c48:	48 b8 d9 06 80 00 00 	movabs $0x8006d9,%rax
  800c4f:	00 00 00 
  800c52:	ff d0                	call   *%rax
  800c54:	85 c0                	test   %eax,%eax
  800c56:	78 33                	js     800c8b <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c5c:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800c61:	74 2e                	je     800c91 <fstat+0x73>

    stat->st_name[0] = 0;
  800c63:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800c66:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800c6d:	00 00 00 
    stat->st_isdir = 0;
  800c70:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800c77:	00 00 00 
    stat->st_dev = dev;
  800c7a:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800c81:	48 89 de             	mov    %rbx,%rsi
  800c84:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c88:	ff 50 28             	call   *0x28(%rax)
}
  800c8b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c8f:	c9                   	leave  
  800c90:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c91:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c96:	eb f3                	jmp    800c8b <fstat+0x6d>

0000000000800c98 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800c98:	55                   	push   %rbp
  800c99:	48 89 e5             	mov    %rsp,%rbp
  800c9c:	41 54                	push   %r12
  800c9e:	53                   	push   %rbx
  800c9f:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800ca2:	be 00 00 00 00       	mov    $0x0,%esi
  800ca7:	48 b8 63 0f 80 00 00 	movabs $0x800f63,%rax
  800cae:	00 00 00 
  800cb1:	ff d0                	call   *%rax
  800cb3:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800cb5:	85 c0                	test   %eax,%eax
  800cb7:	78 25                	js     800cde <stat+0x46>

    int res = fstat(fd, stat);
  800cb9:	4c 89 e6             	mov    %r12,%rsi
  800cbc:	89 c7                	mov    %eax,%edi
  800cbe:	48 b8 1e 0c 80 00 00 	movabs $0x800c1e,%rax
  800cc5:	00 00 00 
  800cc8:	ff d0                	call   *%rax
  800cca:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800ccd:	89 df                	mov    %ebx,%edi
  800ccf:	48 b8 f8 07 80 00 00 	movabs $0x8007f8,%rax
  800cd6:	00 00 00 
  800cd9:	ff d0                	call   *%rax

    return res;
  800cdb:	44 89 e3             	mov    %r12d,%ebx
}
  800cde:	89 d8                	mov    %ebx,%eax
  800ce0:	5b                   	pop    %rbx
  800ce1:	41 5c                	pop    %r12
  800ce3:	5d                   	pop    %rbp
  800ce4:	c3                   	ret    

0000000000800ce5 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800ce5:	55                   	push   %rbp
  800ce6:	48 89 e5             	mov    %rsp,%rbp
  800ce9:	41 54                	push   %r12
  800ceb:	53                   	push   %rbx
  800cec:	48 83 ec 10          	sub    $0x10,%rsp
  800cf0:	41 89 fc             	mov    %edi,%r12d
  800cf3:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800cf6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800cfd:	00 00 00 
  800d00:	83 38 00             	cmpl   $0x0,(%rax)
  800d03:	74 5e                	je     800d63 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800d05:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800d0b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800d10:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800d17:	00 00 00 
  800d1a:	44 89 e6             	mov    %r12d,%esi
  800d1d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d24:	00 00 00 
  800d27:	8b 38                	mov    (%rax),%edi
  800d29:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  800d30:	00 00 00 
  800d33:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800d35:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800d3c:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800d3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d42:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d46:	48 89 de             	mov    %rbx,%rsi
  800d49:	bf 00 00 00 00       	mov    $0x0,%edi
  800d4e:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  800d55:	00 00 00 
  800d58:	ff d0                	call   *%rax
}
  800d5a:	48 83 c4 10          	add    $0x10,%rsp
  800d5e:	5b                   	pop    %rbx
  800d5f:	41 5c                	pop    %r12
  800d61:	5d                   	pop    %rbp
  800d62:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800d63:	bf 03 00 00 00       	mov    $0x3,%edi
  800d68:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  800d6f:	00 00 00 
  800d72:	ff d0                	call   *%rax
  800d74:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800d7b:	00 00 
  800d7d:	eb 86                	jmp    800d05 <fsipc+0x20>

0000000000800d7f <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800d7f:	55                   	push   %rbp
  800d80:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d83:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800d8a:	00 00 00 
  800d8d:	8b 57 0c             	mov    0xc(%rdi),%edx
  800d90:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800d92:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800d95:	be 00 00 00 00       	mov    $0x0,%esi
  800d9a:	bf 02 00 00 00       	mov    $0x2,%edi
  800d9f:	48 b8 e5 0c 80 00 00 	movabs $0x800ce5,%rax
  800da6:	00 00 00 
  800da9:	ff d0                	call   *%rax
}
  800dab:	5d                   	pop    %rbp
  800dac:	c3                   	ret    

0000000000800dad <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800dad:	55                   	push   %rbp
  800dae:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800db1:	8b 47 0c             	mov    0xc(%rdi),%eax
  800db4:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800dbb:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800dbd:	be 00 00 00 00       	mov    $0x0,%esi
  800dc2:	bf 06 00 00 00       	mov    $0x6,%edi
  800dc7:	48 b8 e5 0c 80 00 00 	movabs $0x800ce5,%rax
  800dce:	00 00 00 
  800dd1:	ff d0                	call   *%rax
}
  800dd3:	5d                   	pop    %rbp
  800dd4:	c3                   	ret    

0000000000800dd5 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800dd5:	55                   	push   %rbp
  800dd6:	48 89 e5             	mov    %rsp,%rbp
  800dd9:	53                   	push   %rbx
  800dda:	48 83 ec 08          	sub    $0x8,%rsp
  800dde:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800de1:	8b 47 0c             	mov    0xc(%rdi),%eax
  800de4:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800deb:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800ded:	be 00 00 00 00       	mov    $0x0,%esi
  800df2:	bf 05 00 00 00       	mov    $0x5,%edi
  800df7:	48 b8 e5 0c 80 00 00 	movabs $0x800ce5,%rax
  800dfe:	00 00 00 
  800e01:	ff d0                	call   *%rax
    if (res < 0) return res;
  800e03:	85 c0                	test   %eax,%eax
  800e05:	78 40                	js     800e47 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800e07:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800e0e:	00 00 00 
  800e11:	48 89 df             	mov    %rbx,%rdi
  800e14:	48 b8 ef 23 80 00 00 	movabs $0x8023ef,%rax
  800e1b:	00 00 00 
  800e1e:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800e20:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e27:	00 00 00 
  800e2a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  800e30:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e36:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  800e3c:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800e42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e47:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

0000000000800e4d <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800e4d:	55                   	push   %rbp
  800e4e:	48 89 e5             	mov    %rsp,%rbp
  800e51:	41 57                	push   %r15
  800e53:	41 56                	push   %r14
  800e55:	41 55                	push   %r13
  800e57:	41 54                	push   %r12
  800e59:	53                   	push   %rbx
  800e5a:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  800e5e:	48 85 d2             	test   %rdx,%rdx
  800e61:	0f 84 91 00 00 00    	je     800ef8 <devfile_write+0xab>
  800e67:	49 89 ff             	mov    %rdi,%r15
  800e6a:	49 89 f4             	mov    %rsi,%r12
  800e6d:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  800e70:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e77:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  800e7e:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  800e81:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  800e88:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  800e8e:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  800e92:	4c 89 ea             	mov    %r13,%rdx
  800e95:	4c 89 e6             	mov    %r12,%rsi
  800e98:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  800e9f:	00 00 00 
  800ea2:	48 b8 4f 26 80 00 00 	movabs $0x80264f,%rax
  800ea9:	00 00 00 
  800eac:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800eae:	41 8b 47 0c          	mov    0xc(%r15),%eax
  800eb2:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  800eb5:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  800eb9:	be 00 00 00 00       	mov    $0x0,%esi
  800ebe:	bf 04 00 00 00       	mov    $0x4,%edi
  800ec3:	48 b8 e5 0c 80 00 00 	movabs $0x800ce5,%rax
  800eca:	00 00 00 
  800ecd:	ff d0                	call   *%rax
        if (res < 0)
  800ecf:	85 c0                	test   %eax,%eax
  800ed1:	78 21                	js     800ef4 <devfile_write+0xa7>
        buf += res;
  800ed3:	48 63 d0             	movslq %eax,%rdx
  800ed6:	49 01 d4             	add    %rdx,%r12
        ext += res;
  800ed9:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  800edc:	48 29 d3             	sub    %rdx,%rbx
  800edf:	75 a0                	jne    800e81 <devfile_write+0x34>
    return ext;
  800ee1:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  800ee5:	48 83 c4 18          	add    $0x18,%rsp
  800ee9:	5b                   	pop    %rbx
  800eea:	41 5c                	pop    %r12
  800eec:	41 5d                	pop    %r13
  800eee:	41 5e                	pop    %r14
  800ef0:	41 5f                	pop    %r15
  800ef2:	5d                   	pop    %rbp
  800ef3:	c3                   	ret    
            return res;
  800ef4:	48 98                	cltq   
  800ef6:	eb ed                	jmp    800ee5 <devfile_write+0x98>
    int ext = 0;
  800ef8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  800eff:	eb e0                	jmp    800ee1 <devfile_write+0x94>

0000000000800f01 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800f01:	55                   	push   %rbp
  800f02:	48 89 e5             	mov    %rsp,%rbp
  800f05:	41 54                	push   %r12
  800f07:	53                   	push   %rbx
  800f08:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800f0b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f12:	00 00 00 
  800f15:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f18:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  800f1a:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  800f1e:	be 00 00 00 00       	mov    $0x0,%esi
  800f23:	bf 03 00 00 00       	mov    $0x3,%edi
  800f28:	48 b8 e5 0c 80 00 00 	movabs $0x800ce5,%rax
  800f2f:	00 00 00 
  800f32:	ff d0                	call   *%rax
    if (read < 0) 
  800f34:	85 c0                	test   %eax,%eax
  800f36:	78 27                	js     800f5f <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  800f38:	48 63 d8             	movslq %eax,%rbx
  800f3b:	48 89 da             	mov    %rbx,%rdx
  800f3e:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800f45:	00 00 00 
  800f48:	4c 89 e7             	mov    %r12,%rdi
  800f4b:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  800f52:	00 00 00 
  800f55:	ff d0                	call   *%rax
    return read;
  800f57:	48 89 d8             	mov    %rbx,%rax
}
  800f5a:	5b                   	pop    %rbx
  800f5b:	41 5c                	pop    %r12
  800f5d:	5d                   	pop    %rbp
  800f5e:	c3                   	ret    
		return read;
  800f5f:	48 98                	cltq   
  800f61:	eb f7                	jmp    800f5a <devfile_read+0x59>

0000000000800f63 <open>:
open(const char *path, int mode) {
  800f63:	55                   	push   %rbp
  800f64:	48 89 e5             	mov    %rsp,%rbp
  800f67:	41 55                	push   %r13
  800f69:	41 54                	push   %r12
  800f6b:	53                   	push   %rbx
  800f6c:	48 83 ec 18          	sub    $0x18,%rsp
  800f70:	49 89 fc             	mov    %rdi,%r12
  800f73:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  800f76:	48 b8 b6 23 80 00 00 	movabs $0x8023b6,%rax
  800f7d:	00 00 00 
  800f80:	ff d0                	call   *%rax
  800f82:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  800f88:	0f 87 8c 00 00 00    	ja     80101a <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  800f8e:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  800f92:	48 b8 2e 06 80 00 00 	movabs $0x80062e,%rax
  800f99:	00 00 00 
  800f9c:	ff d0                	call   *%rax
  800f9e:	89 c3                	mov    %eax,%ebx
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	78 52                	js     800ff6 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  800fa4:	4c 89 e6             	mov    %r12,%rsi
  800fa7:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  800fae:	00 00 00 
  800fb1:	48 b8 ef 23 80 00 00 	movabs $0x8023ef,%rax
  800fb8:	00 00 00 
  800fbb:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  800fbd:	44 89 e8             	mov    %r13d,%eax
  800fc0:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  800fc7:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fc9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800fcd:	bf 01 00 00 00       	mov    $0x1,%edi
  800fd2:	48 b8 e5 0c 80 00 00 	movabs $0x800ce5,%rax
  800fd9:	00 00 00 
  800fdc:	ff d0                	call   *%rax
  800fde:	89 c3                	mov    %eax,%ebx
  800fe0:	85 c0                	test   %eax,%eax
  800fe2:	78 1f                	js     801003 <open+0xa0>
    return fd2num(fd);
  800fe4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800fe8:	48 b8 00 06 80 00 00 	movabs $0x800600,%rax
  800fef:	00 00 00 
  800ff2:	ff d0                	call   *%rax
  800ff4:	89 c3                	mov    %eax,%ebx
}
  800ff6:	89 d8                	mov    %ebx,%eax
  800ff8:	48 83 c4 18          	add    $0x18,%rsp
  800ffc:	5b                   	pop    %rbx
  800ffd:	41 5c                	pop    %r12
  800fff:	41 5d                	pop    %r13
  801001:	5d                   	pop    %rbp
  801002:	c3                   	ret    
        fd_close(fd, 0);
  801003:	be 00 00 00 00       	mov    $0x0,%esi
  801008:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80100c:	48 b8 52 07 80 00 00 	movabs $0x800752,%rax
  801013:	00 00 00 
  801016:	ff d0                	call   *%rax
        return res;
  801018:	eb dc                	jmp    800ff6 <open+0x93>
        return -E_BAD_PATH;
  80101a:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80101f:	eb d5                	jmp    800ff6 <open+0x93>

0000000000801021 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801021:	55                   	push   %rbp
  801022:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801025:	be 00 00 00 00       	mov    $0x0,%esi
  80102a:	bf 08 00 00 00       	mov    $0x8,%edi
  80102f:	48 b8 e5 0c 80 00 00 	movabs $0x800ce5,%rax
  801036:	00 00 00 
  801039:	ff d0                	call   *%rax
}
  80103b:	5d                   	pop    %rbp
  80103c:	c3                   	ret    

000000000080103d <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80103d:	55                   	push   %rbp
  80103e:	48 89 e5             	mov    %rsp,%rbp
  801041:	41 54                	push   %r12
  801043:	53                   	push   %rbx
  801044:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801047:	48 b8 12 06 80 00 00 	movabs $0x800612,%rax
  80104e:	00 00 00 
  801051:	ff d0                	call   *%rax
  801053:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801056:	48 be a0 2a 80 00 00 	movabs $0x802aa0,%rsi
  80105d:	00 00 00 
  801060:	48 89 df             	mov    %rbx,%rdi
  801063:	48 b8 ef 23 80 00 00 	movabs $0x8023ef,%rax
  80106a:	00 00 00 
  80106d:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80106f:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801074:	41 2b 04 24          	sub    (%r12),%eax
  801078:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80107e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801085:	00 00 00 
    stat->st_dev = &devpipe;
  801088:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80108f:	00 00 00 
  801092:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801099:	b8 00 00 00 00       	mov    $0x0,%eax
  80109e:	5b                   	pop    %rbx
  80109f:	41 5c                	pop    %r12
  8010a1:	5d                   	pop    %rbp
  8010a2:	c3                   	ret    

00000000008010a3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8010a3:	55                   	push   %rbp
  8010a4:	48 89 e5             	mov    %rsp,%rbp
  8010a7:	41 54                	push   %r12
  8010a9:	53                   	push   %rbx
  8010aa:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8010ad:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010b2:	48 89 fe             	mov    %rdi,%rsi
  8010b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8010ba:	49 bc 67 03 80 00 00 	movabs $0x800367,%r12
  8010c1:	00 00 00 
  8010c4:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8010c7:	48 89 df             	mov    %rbx,%rdi
  8010ca:	48 b8 12 06 80 00 00 	movabs $0x800612,%rax
  8010d1:	00 00 00 
  8010d4:	ff d0                	call   *%rax
  8010d6:	48 89 c6             	mov    %rax,%rsi
  8010d9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010de:	bf 00 00 00 00       	mov    $0x0,%edi
  8010e3:	41 ff d4             	call   *%r12
}
  8010e6:	5b                   	pop    %rbx
  8010e7:	41 5c                	pop    %r12
  8010e9:	5d                   	pop    %rbp
  8010ea:	c3                   	ret    

00000000008010eb <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8010eb:	55                   	push   %rbp
  8010ec:	48 89 e5             	mov    %rsp,%rbp
  8010ef:	41 57                	push   %r15
  8010f1:	41 56                	push   %r14
  8010f3:	41 55                	push   %r13
  8010f5:	41 54                	push   %r12
  8010f7:	53                   	push   %rbx
  8010f8:	48 83 ec 18          	sub    $0x18,%rsp
  8010fc:	49 89 fc             	mov    %rdi,%r12
  8010ff:	49 89 f5             	mov    %rsi,%r13
  801102:	49 89 d7             	mov    %rdx,%r15
  801105:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801109:	48 b8 12 06 80 00 00 	movabs $0x800612,%rax
  801110:	00 00 00 
  801113:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801115:	4d 85 ff             	test   %r15,%r15
  801118:	0f 84 ac 00 00 00    	je     8011ca <devpipe_write+0xdf>
  80111e:	48 89 c3             	mov    %rax,%rbx
  801121:	4c 89 f8             	mov    %r15,%rax
  801124:	4d 89 ef             	mov    %r13,%r15
  801127:	49 01 c5             	add    %rax,%r13
  80112a:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80112e:	49 bd 6f 02 80 00 00 	movabs $0x80026f,%r13
  801135:	00 00 00 
            sys_yield();
  801138:	49 be 0c 02 80 00 00 	movabs $0x80020c,%r14
  80113f:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801142:	8b 73 04             	mov    0x4(%rbx),%esi
  801145:	48 63 ce             	movslq %esi,%rcx
  801148:	48 63 03             	movslq (%rbx),%rax
  80114b:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801151:	48 39 c1             	cmp    %rax,%rcx
  801154:	72 2e                	jb     801184 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801156:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80115b:	48 89 da             	mov    %rbx,%rdx
  80115e:	be 00 10 00 00       	mov    $0x1000,%esi
  801163:	4c 89 e7             	mov    %r12,%rdi
  801166:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801169:	85 c0                	test   %eax,%eax
  80116b:	74 63                	je     8011d0 <devpipe_write+0xe5>
            sys_yield();
  80116d:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801170:	8b 73 04             	mov    0x4(%rbx),%esi
  801173:	48 63 ce             	movslq %esi,%rcx
  801176:	48 63 03             	movslq (%rbx),%rax
  801179:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80117f:	48 39 c1             	cmp    %rax,%rcx
  801182:	73 d2                	jae    801156 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801184:	41 0f b6 3f          	movzbl (%r15),%edi
  801188:	48 89 ca             	mov    %rcx,%rdx
  80118b:	48 c1 ea 03          	shr    $0x3,%rdx
  80118f:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801196:	08 10 20 
  801199:	48 f7 e2             	mul    %rdx
  80119c:	48 c1 ea 06          	shr    $0x6,%rdx
  8011a0:	48 89 d0             	mov    %rdx,%rax
  8011a3:	48 c1 e0 09          	shl    $0x9,%rax
  8011a7:	48 29 d0             	sub    %rdx,%rax
  8011aa:	48 c1 e0 03          	shl    $0x3,%rax
  8011ae:	48 29 c1             	sub    %rax,%rcx
  8011b1:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8011b6:	83 c6 01             	add    $0x1,%esi
  8011b9:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8011bc:	49 83 c7 01          	add    $0x1,%r15
  8011c0:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8011c4:	0f 85 78 ff ff ff    	jne    801142 <devpipe_write+0x57>
    return n;
  8011ca:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8011ce:	eb 05                	jmp    8011d5 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8011d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d5:	48 83 c4 18          	add    $0x18,%rsp
  8011d9:	5b                   	pop    %rbx
  8011da:	41 5c                	pop    %r12
  8011dc:	41 5d                	pop    %r13
  8011de:	41 5e                	pop    %r14
  8011e0:	41 5f                	pop    %r15
  8011e2:	5d                   	pop    %rbp
  8011e3:	c3                   	ret    

00000000008011e4 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8011e4:	55                   	push   %rbp
  8011e5:	48 89 e5             	mov    %rsp,%rbp
  8011e8:	41 57                	push   %r15
  8011ea:	41 56                	push   %r14
  8011ec:	41 55                	push   %r13
  8011ee:	41 54                	push   %r12
  8011f0:	53                   	push   %rbx
  8011f1:	48 83 ec 18          	sub    $0x18,%rsp
  8011f5:	49 89 fc             	mov    %rdi,%r12
  8011f8:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8011fc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801200:	48 b8 12 06 80 00 00 	movabs $0x800612,%rax
  801207:	00 00 00 
  80120a:	ff d0                	call   *%rax
  80120c:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80120f:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801215:	49 bd 6f 02 80 00 00 	movabs $0x80026f,%r13
  80121c:	00 00 00 
            sys_yield();
  80121f:	49 be 0c 02 80 00 00 	movabs $0x80020c,%r14
  801226:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801229:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80122e:	74 7a                	je     8012aa <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801230:	8b 03                	mov    (%rbx),%eax
  801232:	3b 43 04             	cmp    0x4(%rbx),%eax
  801235:	75 26                	jne    80125d <devpipe_read+0x79>
            if (i > 0) return i;
  801237:	4d 85 ff             	test   %r15,%r15
  80123a:	75 74                	jne    8012b0 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80123c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801241:	48 89 da             	mov    %rbx,%rdx
  801244:	be 00 10 00 00       	mov    $0x1000,%esi
  801249:	4c 89 e7             	mov    %r12,%rdi
  80124c:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80124f:	85 c0                	test   %eax,%eax
  801251:	74 6f                	je     8012c2 <devpipe_read+0xde>
            sys_yield();
  801253:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801256:	8b 03                	mov    (%rbx),%eax
  801258:	3b 43 04             	cmp    0x4(%rbx),%eax
  80125b:	74 df                	je     80123c <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80125d:	48 63 c8             	movslq %eax,%rcx
  801260:	48 89 ca             	mov    %rcx,%rdx
  801263:	48 c1 ea 03          	shr    $0x3,%rdx
  801267:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80126e:	08 10 20 
  801271:	48 f7 e2             	mul    %rdx
  801274:	48 c1 ea 06          	shr    $0x6,%rdx
  801278:	48 89 d0             	mov    %rdx,%rax
  80127b:	48 c1 e0 09          	shl    $0x9,%rax
  80127f:	48 29 d0             	sub    %rdx,%rax
  801282:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801289:	00 
  80128a:	48 89 c8             	mov    %rcx,%rax
  80128d:	48 29 d0             	sub    %rdx,%rax
  801290:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  801295:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801299:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80129d:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012a0:	49 83 c7 01          	add    $0x1,%r15
  8012a4:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8012a8:	75 86                	jne    801230 <devpipe_read+0x4c>
    return n;
  8012aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012ae:	eb 03                	jmp    8012b3 <devpipe_read+0xcf>
            if (i > 0) return i;
  8012b0:	4c 89 f8             	mov    %r15,%rax
}
  8012b3:	48 83 c4 18          	add    $0x18,%rsp
  8012b7:	5b                   	pop    %rbx
  8012b8:	41 5c                	pop    %r12
  8012ba:	41 5d                	pop    %r13
  8012bc:	41 5e                	pop    %r14
  8012be:	41 5f                	pop    %r15
  8012c0:	5d                   	pop    %rbp
  8012c1:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8012c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c7:	eb ea                	jmp    8012b3 <devpipe_read+0xcf>

00000000008012c9 <pipe>:
pipe(int pfd[2]) {
  8012c9:	55                   	push   %rbp
  8012ca:	48 89 e5             	mov    %rsp,%rbp
  8012cd:	41 55                	push   %r13
  8012cf:	41 54                	push   %r12
  8012d1:	53                   	push   %rbx
  8012d2:	48 83 ec 18          	sub    $0x18,%rsp
  8012d6:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8012d9:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8012dd:	48 b8 2e 06 80 00 00 	movabs $0x80062e,%rax
  8012e4:	00 00 00 
  8012e7:	ff d0                	call   *%rax
  8012e9:	89 c3                	mov    %eax,%ebx
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	0f 88 a0 01 00 00    	js     801493 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8012f3:	b9 46 00 00 00       	mov    $0x46,%ecx
  8012f8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8012fd:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801301:	bf 00 00 00 00       	mov    $0x0,%edi
  801306:	48 b8 9b 02 80 00 00 	movabs $0x80029b,%rax
  80130d:	00 00 00 
  801310:	ff d0                	call   *%rax
  801312:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801314:	85 c0                	test   %eax,%eax
  801316:	0f 88 77 01 00 00    	js     801493 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80131c:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  801320:	48 b8 2e 06 80 00 00 	movabs $0x80062e,%rax
  801327:	00 00 00 
  80132a:	ff d0                	call   *%rax
  80132c:	89 c3                	mov    %eax,%ebx
  80132e:	85 c0                	test   %eax,%eax
  801330:	0f 88 43 01 00 00    	js     801479 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  801336:	b9 46 00 00 00       	mov    $0x46,%ecx
  80133b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801340:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801344:	bf 00 00 00 00       	mov    $0x0,%edi
  801349:	48 b8 9b 02 80 00 00 	movabs $0x80029b,%rax
  801350:	00 00 00 
  801353:	ff d0                	call   *%rax
  801355:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  801357:	85 c0                	test   %eax,%eax
  801359:	0f 88 1a 01 00 00    	js     801479 <pipe+0x1b0>
    va = fd2data(fd0);
  80135f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801363:	48 b8 12 06 80 00 00 	movabs $0x800612,%rax
  80136a:	00 00 00 
  80136d:	ff d0                	call   *%rax
  80136f:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801372:	b9 46 00 00 00       	mov    $0x46,%ecx
  801377:	ba 00 10 00 00       	mov    $0x1000,%edx
  80137c:	48 89 c6             	mov    %rax,%rsi
  80137f:	bf 00 00 00 00       	mov    $0x0,%edi
  801384:	48 b8 9b 02 80 00 00 	movabs $0x80029b,%rax
  80138b:	00 00 00 
  80138e:	ff d0                	call   *%rax
  801390:	89 c3                	mov    %eax,%ebx
  801392:	85 c0                	test   %eax,%eax
  801394:	0f 88 c5 00 00 00    	js     80145f <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80139a:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80139e:	48 b8 12 06 80 00 00 	movabs $0x800612,%rax
  8013a5:	00 00 00 
  8013a8:	ff d0                	call   *%rax
  8013aa:	48 89 c1             	mov    %rax,%rcx
  8013ad:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8013b3:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8013b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8013be:	4c 89 ee             	mov    %r13,%rsi
  8013c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8013c6:	48 b8 02 03 80 00 00 	movabs $0x800302,%rax
  8013cd:	00 00 00 
  8013d0:	ff d0                	call   *%rax
  8013d2:	89 c3                	mov    %eax,%ebx
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	78 6e                	js     801446 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8013d8:	be 00 10 00 00       	mov    $0x1000,%esi
  8013dd:	4c 89 ef             	mov    %r13,%rdi
  8013e0:	48 b8 3d 02 80 00 00 	movabs $0x80023d,%rax
  8013e7:	00 00 00 
  8013ea:	ff d0                	call   *%rax
  8013ec:	83 f8 02             	cmp    $0x2,%eax
  8013ef:	0f 85 ab 00 00 00    	jne    8014a0 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8013f5:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8013fc:	00 00 
  8013fe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801402:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  801404:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801408:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80140f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801413:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801415:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801419:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801420:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801424:	48 bb 00 06 80 00 00 	movabs $0x800600,%rbx
  80142b:	00 00 00 
  80142e:	ff d3                	call   *%rbx
  801430:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801434:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801438:	ff d3                	call   *%rbx
  80143a:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80143f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801444:	eb 4d                	jmp    801493 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  801446:	ba 00 10 00 00       	mov    $0x1000,%edx
  80144b:	4c 89 ee             	mov    %r13,%rsi
  80144e:	bf 00 00 00 00       	mov    $0x0,%edi
  801453:	48 b8 67 03 80 00 00 	movabs $0x800367,%rax
  80145a:	00 00 00 
  80145d:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80145f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801464:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801468:	bf 00 00 00 00       	mov    $0x0,%edi
  80146d:	48 b8 67 03 80 00 00 	movabs $0x800367,%rax
  801474:	00 00 00 
  801477:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  801479:	ba 00 10 00 00       	mov    $0x1000,%edx
  80147e:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801482:	bf 00 00 00 00       	mov    $0x0,%edi
  801487:	48 b8 67 03 80 00 00 	movabs $0x800367,%rax
  80148e:	00 00 00 
  801491:	ff d0                	call   *%rax
}
  801493:	89 d8                	mov    %ebx,%eax
  801495:	48 83 c4 18          	add    $0x18,%rsp
  801499:	5b                   	pop    %rbx
  80149a:	41 5c                	pop    %r12
  80149c:	41 5d                	pop    %r13
  80149e:	5d                   	pop    %rbp
  80149f:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014a0:	48 b9 d0 2a 80 00 00 	movabs $0x802ad0,%rcx
  8014a7:	00 00 00 
  8014aa:	48 ba a7 2a 80 00 00 	movabs $0x802aa7,%rdx
  8014b1:	00 00 00 
  8014b4:	be 2e 00 00 00       	mov    $0x2e,%esi
  8014b9:	48 bf bc 2a 80 00 00 	movabs $0x802abc,%rdi
  8014c0:	00 00 00 
  8014c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c8:	49 b8 5e 19 80 00 00 	movabs $0x80195e,%r8
  8014cf:	00 00 00 
  8014d2:	41 ff d0             	call   *%r8

00000000008014d5 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8014d5:	55                   	push   %rbp
  8014d6:	48 89 e5             	mov    %rsp,%rbp
  8014d9:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8014dd:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8014e1:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  8014e8:	00 00 00 
  8014eb:	ff d0                	call   *%rax
    if (res < 0) return res;
  8014ed:	85 c0                	test   %eax,%eax
  8014ef:	78 35                	js     801526 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8014f1:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8014f5:	48 b8 12 06 80 00 00 	movabs $0x800612,%rax
  8014fc:	00 00 00 
  8014ff:	ff d0                	call   *%rax
  801501:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801504:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801509:	be 00 10 00 00       	mov    $0x1000,%esi
  80150e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801512:	48 b8 6f 02 80 00 00 	movabs $0x80026f,%rax
  801519:	00 00 00 
  80151c:	ff d0                	call   *%rax
  80151e:	85 c0                	test   %eax,%eax
  801520:	0f 94 c0             	sete   %al
  801523:	0f b6 c0             	movzbl %al,%eax
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

0000000000801528 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801528:	48 89 f8             	mov    %rdi,%rax
  80152b:	48 c1 e8 27          	shr    $0x27,%rax
  80152f:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  801536:	01 00 00 
  801539:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80153d:	f6 c2 01             	test   $0x1,%dl
  801540:	74 6d                	je     8015af <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801542:	48 89 f8             	mov    %rdi,%rax
  801545:	48 c1 e8 1e          	shr    $0x1e,%rax
  801549:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801550:	01 00 00 
  801553:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801557:	f6 c2 01             	test   $0x1,%dl
  80155a:	74 62                	je     8015be <get_uvpt_entry+0x96>
  80155c:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801563:	01 00 00 
  801566:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80156a:	f6 c2 80             	test   $0x80,%dl
  80156d:	75 4f                	jne    8015be <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80156f:	48 89 f8             	mov    %rdi,%rax
  801572:	48 c1 e8 15          	shr    $0x15,%rax
  801576:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80157d:	01 00 00 
  801580:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801584:	f6 c2 01             	test   $0x1,%dl
  801587:	74 44                	je     8015cd <get_uvpt_entry+0xa5>
  801589:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801590:	01 00 00 
  801593:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801597:	f6 c2 80             	test   $0x80,%dl
  80159a:	75 31                	jne    8015cd <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  80159c:	48 c1 ef 0c          	shr    $0xc,%rdi
  8015a0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8015a7:	01 00 00 
  8015aa:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8015ae:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8015af:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8015b6:	01 00 00 
  8015b9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015bd:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8015be:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8015c5:	01 00 00 
  8015c8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015cc:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8015cd:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8015d4:	01 00 00 
  8015d7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015db:	c3                   	ret    

00000000008015dc <get_prot>:

int
get_prot(void *va) {
  8015dc:	55                   	push   %rbp
  8015dd:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8015e0:	48 b8 28 15 80 00 00 	movabs $0x801528,%rax
  8015e7:	00 00 00 
  8015ea:	ff d0                	call   *%rax
  8015ec:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8015ef:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8015f4:	89 c1                	mov    %eax,%ecx
  8015f6:	83 c9 04             	or     $0x4,%ecx
  8015f9:	f6 c2 01             	test   $0x1,%dl
  8015fc:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8015ff:	89 c1                	mov    %eax,%ecx
  801601:	83 c9 02             	or     $0x2,%ecx
  801604:	f6 c2 02             	test   $0x2,%dl
  801607:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80160a:	89 c1                	mov    %eax,%ecx
  80160c:	83 c9 01             	or     $0x1,%ecx
  80160f:	48 85 d2             	test   %rdx,%rdx
  801612:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801615:	89 c1                	mov    %eax,%ecx
  801617:	83 c9 40             	or     $0x40,%ecx
  80161a:	f6 c6 04             	test   $0x4,%dh
  80161d:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801620:	5d                   	pop    %rbp
  801621:	c3                   	ret    

0000000000801622 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801622:	55                   	push   %rbp
  801623:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801626:	48 b8 28 15 80 00 00 	movabs $0x801528,%rax
  80162d:	00 00 00 
  801630:	ff d0                	call   *%rax
    return pte & PTE_D;
  801632:	48 c1 e8 06          	shr    $0x6,%rax
  801636:	83 e0 01             	and    $0x1,%eax
}
  801639:	5d                   	pop    %rbp
  80163a:	c3                   	ret    

000000000080163b <is_page_present>:

bool
is_page_present(void *va) {
  80163b:	55                   	push   %rbp
  80163c:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80163f:	48 b8 28 15 80 00 00 	movabs $0x801528,%rax
  801646:	00 00 00 
  801649:	ff d0                	call   *%rax
  80164b:	83 e0 01             	and    $0x1,%eax
}
  80164e:	5d                   	pop    %rbp
  80164f:	c3                   	ret    

0000000000801650 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801650:	55                   	push   %rbp
  801651:	48 89 e5             	mov    %rsp,%rbp
  801654:	41 57                	push   %r15
  801656:	41 56                	push   %r14
  801658:	41 55                	push   %r13
  80165a:	41 54                	push   %r12
  80165c:	53                   	push   %rbx
  80165d:	48 83 ec 28          	sub    $0x28,%rsp
  801661:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  801665:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  801669:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  80166e:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  801675:	01 00 00 
  801678:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  80167f:	01 00 00 
  801682:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  801689:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80168c:	49 bf dc 15 80 00 00 	movabs $0x8015dc,%r15
  801693:	00 00 00 
  801696:	eb 16                	jmp    8016ae <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  801698:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  80169f:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8016a6:	00 00 00 
  8016a9:	48 39 c3             	cmp    %rax,%rbx
  8016ac:	77 73                	ja     801721 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8016ae:	48 89 d8             	mov    %rbx,%rax
  8016b1:	48 c1 e8 27          	shr    $0x27,%rax
  8016b5:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8016b9:	a8 01                	test   $0x1,%al
  8016bb:	74 db                	je     801698 <foreach_shared_region+0x48>
  8016bd:	48 89 d8             	mov    %rbx,%rax
  8016c0:	48 c1 e8 1e          	shr    $0x1e,%rax
  8016c4:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8016c9:	a8 01                	test   $0x1,%al
  8016cb:	74 cb                	je     801698 <foreach_shared_region+0x48>
  8016cd:	48 89 d8             	mov    %rbx,%rax
  8016d0:	48 c1 e8 15          	shr    $0x15,%rax
  8016d4:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8016d8:	a8 01                	test   $0x1,%al
  8016da:	74 bc                	je     801698 <foreach_shared_region+0x48>
        void *start = (void*)i;
  8016dc:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016e0:	48 89 df             	mov    %rbx,%rdi
  8016e3:	41 ff d7             	call   *%r15
  8016e6:	a8 40                	test   $0x40,%al
  8016e8:	75 09                	jne    8016f3 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8016ea:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8016f1:	eb ac                	jmp    80169f <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016f3:	48 89 df             	mov    %rbx,%rdi
  8016f6:	48 b8 3b 16 80 00 00 	movabs $0x80163b,%rax
  8016fd:	00 00 00 
  801700:	ff d0                	call   *%rax
  801702:	84 c0                	test   %al,%al
  801704:	74 e4                	je     8016ea <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  801706:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  80170d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801711:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  801715:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801719:	ff d0                	call   *%rax
  80171b:	85 c0                	test   %eax,%eax
  80171d:	79 cb                	jns    8016ea <foreach_shared_region+0x9a>
  80171f:	eb 05                	jmp    801726 <foreach_shared_region+0xd6>
    }
    return 0;
  801721:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801726:	48 83 c4 28          	add    $0x28,%rsp
  80172a:	5b                   	pop    %rbx
  80172b:	41 5c                	pop    %r12
  80172d:	41 5d                	pop    %r13
  80172f:	41 5e                	pop    %r14
  801731:	41 5f                	pop    %r15
  801733:	5d                   	pop    %rbp
  801734:	c3                   	ret    

0000000000801735 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
  80173a:	c3                   	ret    

000000000080173b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80173b:	55                   	push   %rbp
  80173c:	48 89 e5             	mov    %rsp,%rbp
  80173f:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  801742:	48 be f4 2a 80 00 00 	movabs $0x802af4,%rsi
  801749:	00 00 00 
  80174c:	48 b8 ef 23 80 00 00 	movabs $0x8023ef,%rax
  801753:	00 00 00 
  801756:	ff d0                	call   *%rax
    return 0;
}
  801758:	b8 00 00 00 00       	mov    $0x0,%eax
  80175d:	5d                   	pop    %rbp
  80175e:	c3                   	ret    

000000000080175f <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80175f:	55                   	push   %rbp
  801760:	48 89 e5             	mov    %rsp,%rbp
  801763:	41 57                	push   %r15
  801765:	41 56                	push   %r14
  801767:	41 55                	push   %r13
  801769:	41 54                	push   %r12
  80176b:	53                   	push   %rbx
  80176c:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  801773:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80177a:	48 85 d2             	test   %rdx,%rdx
  80177d:	74 78                	je     8017f7 <devcons_write+0x98>
  80177f:	49 89 d6             	mov    %rdx,%r14
  801782:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801788:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  80178d:	49 bf ea 25 80 00 00 	movabs $0x8025ea,%r15
  801794:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801797:	4c 89 f3             	mov    %r14,%rbx
  80179a:	48 29 f3             	sub    %rsi,%rbx
  80179d:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8017a1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8017a6:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8017aa:	4c 63 eb             	movslq %ebx,%r13
  8017ad:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8017b4:	4c 89 ea             	mov    %r13,%rdx
  8017b7:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017be:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8017c1:	4c 89 ee             	mov    %r13,%rsi
  8017c4:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017cb:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  8017d2:	00 00 00 
  8017d5:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8017d7:	41 01 dc             	add    %ebx,%r12d
  8017da:	49 63 f4             	movslq %r12d,%rsi
  8017dd:	4c 39 f6             	cmp    %r14,%rsi
  8017e0:	72 b5                	jb     801797 <devcons_write+0x38>
    return res;
  8017e2:	49 63 c4             	movslq %r12d,%rax
}
  8017e5:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8017ec:	5b                   	pop    %rbx
  8017ed:	41 5c                	pop    %r12
  8017ef:	41 5d                	pop    %r13
  8017f1:	41 5e                	pop    %r14
  8017f3:	41 5f                	pop    %r15
  8017f5:	5d                   	pop    %rbp
  8017f6:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8017f7:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8017fd:	eb e3                	jmp    8017e2 <devcons_write+0x83>

00000000008017ff <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8017ff:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801802:	ba 00 00 00 00       	mov    $0x0,%edx
  801807:	48 85 c0             	test   %rax,%rax
  80180a:	74 55                	je     801861 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80180c:	55                   	push   %rbp
  80180d:	48 89 e5             	mov    %rsp,%rbp
  801810:	41 55                	push   %r13
  801812:	41 54                	push   %r12
  801814:	53                   	push   %rbx
  801815:	48 83 ec 08          	sub    $0x8,%rsp
  801819:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  80181c:	48 bb 3f 01 80 00 00 	movabs $0x80013f,%rbx
  801823:	00 00 00 
  801826:	49 bc 0c 02 80 00 00 	movabs $0x80020c,%r12
  80182d:	00 00 00 
  801830:	eb 03                	jmp    801835 <devcons_read+0x36>
  801832:	41 ff d4             	call   *%r12
  801835:	ff d3                	call   *%rbx
  801837:	85 c0                	test   %eax,%eax
  801839:	74 f7                	je     801832 <devcons_read+0x33>
    if (c < 0) return c;
  80183b:	48 63 d0             	movslq %eax,%rdx
  80183e:	78 13                	js     801853 <devcons_read+0x54>
    if (c == 0x04) return 0;
  801840:	ba 00 00 00 00       	mov    $0x0,%edx
  801845:	83 f8 04             	cmp    $0x4,%eax
  801848:	74 09                	je     801853 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  80184a:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80184e:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801853:	48 89 d0             	mov    %rdx,%rax
  801856:	48 83 c4 08          	add    $0x8,%rsp
  80185a:	5b                   	pop    %rbx
  80185b:	41 5c                	pop    %r12
  80185d:	41 5d                	pop    %r13
  80185f:	5d                   	pop    %rbp
  801860:	c3                   	ret    
  801861:	48 89 d0             	mov    %rdx,%rax
  801864:	c3                   	ret    

0000000000801865 <cputchar>:
cputchar(int ch) {
  801865:	55                   	push   %rbp
  801866:	48 89 e5             	mov    %rsp,%rbp
  801869:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  80186d:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801871:	be 01 00 00 00       	mov    $0x1,%esi
  801876:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80187a:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  801881:	00 00 00 
  801884:	ff d0                	call   *%rax
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

0000000000801888 <getchar>:
getchar(void) {
  801888:	55                   	push   %rbp
  801889:	48 89 e5             	mov    %rsp,%rbp
  80188c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801890:	ba 01 00 00 00       	mov    $0x1,%edx
  801895:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801899:	bf 00 00 00 00       	mov    $0x0,%edi
  80189e:	48 b8 71 09 80 00 00 	movabs $0x800971,%rax
  8018a5:	00 00 00 
  8018a8:	ff d0                	call   *%rax
  8018aa:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 06                	js     8018b6 <getchar+0x2e>
  8018b0:	74 08                	je     8018ba <getchar+0x32>
  8018b2:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8018b6:	89 d0                	mov    %edx,%eax
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8018ba:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8018bf:	eb f5                	jmp    8018b6 <getchar+0x2e>

00000000008018c1 <iscons>:
iscons(int fdnum) {
  8018c1:	55                   	push   %rbp
  8018c2:	48 89 e5             	mov    %rsp,%rbp
  8018c5:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8018c9:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018cd:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  8018d4:	00 00 00 
  8018d7:	ff d0                	call   *%rax
    if (res < 0) return res;
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	78 18                	js     8018f5 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8018dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018e1:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8018e8:	00 00 00 
  8018eb:	8b 00                	mov    (%rax),%eax
  8018ed:	39 02                	cmp    %eax,(%rdx)
  8018ef:	0f 94 c0             	sete   %al
  8018f2:	0f b6 c0             	movzbl %al,%eax
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

00000000008018f7 <opencons>:
opencons(void) {
  8018f7:	55                   	push   %rbp
  8018f8:	48 89 e5             	mov    %rsp,%rbp
  8018fb:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8018ff:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801903:	48 b8 2e 06 80 00 00 	movabs $0x80062e,%rax
  80190a:	00 00 00 
  80190d:	ff d0                	call   *%rax
  80190f:	85 c0                	test   %eax,%eax
  801911:	78 49                	js     80195c <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801913:	b9 46 00 00 00       	mov    $0x46,%ecx
  801918:	ba 00 10 00 00       	mov    $0x1000,%edx
  80191d:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801921:	bf 00 00 00 00       	mov    $0x0,%edi
  801926:	48 b8 9b 02 80 00 00 	movabs $0x80029b,%rax
  80192d:	00 00 00 
  801930:	ff d0                	call   *%rax
  801932:	85 c0                	test   %eax,%eax
  801934:	78 26                	js     80195c <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  801936:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80193a:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801941:	00 00 
  801943:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801945:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801949:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801950:	48 b8 00 06 80 00 00 	movabs $0x800600,%rax
  801957:	00 00 00 
  80195a:	ff d0                	call   *%rax
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

000000000080195e <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80195e:	55                   	push   %rbp
  80195f:	48 89 e5             	mov    %rsp,%rbp
  801962:	41 56                	push   %r14
  801964:	41 55                	push   %r13
  801966:	41 54                	push   %r12
  801968:	53                   	push   %rbx
  801969:	48 83 ec 50          	sub    $0x50,%rsp
  80196d:	49 89 fc             	mov    %rdi,%r12
  801970:	41 89 f5             	mov    %esi,%r13d
  801973:	48 89 d3             	mov    %rdx,%rbx
  801976:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80197a:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80197e:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801982:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801989:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80198d:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801991:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801995:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801999:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8019a0:	00 00 00 
  8019a3:	4c 8b 30             	mov    (%rax),%r14
  8019a6:	48 b8 db 01 80 00 00 	movabs $0x8001db,%rax
  8019ad:	00 00 00 
  8019b0:	ff d0                	call   *%rax
  8019b2:	89 c6                	mov    %eax,%esi
  8019b4:	45 89 e8             	mov    %r13d,%r8d
  8019b7:	4c 89 e1             	mov    %r12,%rcx
  8019ba:	4c 89 f2             	mov    %r14,%rdx
  8019bd:	48 bf 00 2b 80 00 00 	movabs $0x802b00,%rdi
  8019c4:	00 00 00 
  8019c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019cc:	49 bc ae 1a 80 00 00 	movabs $0x801aae,%r12
  8019d3:	00 00 00 
  8019d6:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8019d9:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8019dd:	48 89 df             	mov    %rbx,%rdi
  8019e0:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  8019e7:	00 00 00 
  8019ea:	ff d0                	call   *%rax
    cprintf("\n");
  8019ec:	48 bf 5b 2a 80 00 00 	movabs $0x802a5b,%rdi
  8019f3:	00 00 00 
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fb:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8019fe:	cc                   	int3   
  8019ff:	eb fd                	jmp    8019fe <_panic+0xa0>

0000000000801a01 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801a01:	55                   	push   %rbp
  801a02:	48 89 e5             	mov    %rsp,%rbp
  801a05:	53                   	push   %rbx
  801a06:	48 83 ec 08          	sub    $0x8,%rsp
  801a0a:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801a0d:	8b 06                	mov    (%rsi),%eax
  801a0f:	8d 50 01             	lea    0x1(%rax),%edx
  801a12:	89 16                	mov    %edx,(%rsi)
  801a14:	48 98                	cltq   
  801a16:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801a1b:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801a21:	74 0a                	je     801a2d <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801a23:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801a27:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  801a2d:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801a31:	be ff 00 00 00       	mov    $0xff,%esi
  801a36:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  801a3d:	00 00 00 
  801a40:	ff d0                	call   *%rax
        state->offset = 0;
  801a42:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801a48:	eb d9                	jmp    801a23 <putch+0x22>

0000000000801a4a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801a4a:	55                   	push   %rbp
  801a4b:	48 89 e5             	mov    %rsp,%rbp
  801a4e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801a55:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801a58:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801a5f:	b9 21 00 00 00       	mov    $0x21,%ecx
  801a64:	b8 00 00 00 00       	mov    $0x0,%eax
  801a69:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801a6c:	48 89 f1             	mov    %rsi,%rcx
  801a6f:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801a76:	48 bf 01 1a 80 00 00 	movabs $0x801a01,%rdi
  801a7d:	00 00 00 
  801a80:	48 b8 fe 1b 80 00 00 	movabs $0x801bfe,%rax
  801a87:	00 00 00 
  801a8a:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801a8c:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801a93:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801a9a:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  801aa1:	00 00 00 
  801aa4:	ff d0                	call   *%rax

    return state.count;
}
  801aa6:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

0000000000801aae <cprintf>:

int
cprintf(const char *fmt, ...) {
  801aae:	55                   	push   %rbp
  801aaf:	48 89 e5             	mov    %rsp,%rbp
  801ab2:	48 83 ec 50          	sub    $0x50,%rsp
  801ab6:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801aba:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801abe:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ac2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801ac6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801aca:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801ad1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ad5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ad9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801add:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801ae1:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801ae5:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  801aec:	00 00 00 
  801aef:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

0000000000801af3 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801af3:	55                   	push   %rbp
  801af4:	48 89 e5             	mov    %rsp,%rbp
  801af7:	41 57                	push   %r15
  801af9:	41 56                	push   %r14
  801afb:	41 55                	push   %r13
  801afd:	41 54                	push   %r12
  801aff:	53                   	push   %rbx
  801b00:	48 83 ec 18          	sub    $0x18,%rsp
  801b04:	49 89 fc             	mov    %rdi,%r12
  801b07:	49 89 f5             	mov    %rsi,%r13
  801b0a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801b0e:	8b 45 10             	mov    0x10(%rbp),%eax
  801b11:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801b14:	41 89 cf             	mov    %ecx,%r15d
  801b17:	49 39 d7             	cmp    %rdx,%r15
  801b1a:	76 5b                	jbe    801b77 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801b1c:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801b20:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801b24:	85 db                	test   %ebx,%ebx
  801b26:	7e 0e                	jle    801b36 <print_num+0x43>
            putch(padc, put_arg);
  801b28:	4c 89 ee             	mov    %r13,%rsi
  801b2b:	44 89 f7             	mov    %r14d,%edi
  801b2e:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801b31:	83 eb 01             	sub    $0x1,%ebx
  801b34:	75 f2                	jne    801b28 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801b36:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801b3a:	48 b9 23 2b 80 00 00 	movabs $0x802b23,%rcx
  801b41:	00 00 00 
  801b44:	48 b8 34 2b 80 00 00 	movabs $0x802b34,%rax
  801b4b:	00 00 00 
  801b4e:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801b52:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b56:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5b:	49 f7 f7             	div    %r15
  801b5e:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801b62:	4c 89 ee             	mov    %r13,%rsi
  801b65:	41 ff d4             	call   *%r12
}
  801b68:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801b6c:	5b                   	pop    %rbx
  801b6d:	41 5c                	pop    %r12
  801b6f:	41 5d                	pop    %r13
  801b71:	41 5e                	pop    %r14
  801b73:	41 5f                	pop    %r15
  801b75:	5d                   	pop    %rbp
  801b76:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801b77:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b80:	49 f7 f7             	div    %r15
  801b83:	48 83 ec 08          	sub    $0x8,%rsp
  801b87:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801b8b:	52                   	push   %rdx
  801b8c:	45 0f be c9          	movsbl %r9b,%r9d
  801b90:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801b94:	48 89 c2             	mov    %rax,%rdx
  801b97:	48 b8 f3 1a 80 00 00 	movabs $0x801af3,%rax
  801b9e:	00 00 00 
  801ba1:	ff d0                	call   *%rax
  801ba3:	48 83 c4 10          	add    $0x10,%rsp
  801ba7:	eb 8d                	jmp    801b36 <print_num+0x43>

0000000000801ba9 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  801ba9:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801bad:	48 8b 06             	mov    (%rsi),%rax
  801bb0:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801bb4:	73 0a                	jae    801bc0 <sprintputch+0x17>
        *state->start++ = ch;
  801bb6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bba:	48 89 16             	mov    %rdx,(%rsi)
  801bbd:	40 88 38             	mov    %dil,(%rax)
    }
}
  801bc0:	c3                   	ret    

0000000000801bc1 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801bc1:	55                   	push   %rbp
  801bc2:	48 89 e5             	mov    %rsp,%rbp
  801bc5:	48 83 ec 50          	sub    $0x50,%rsp
  801bc9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bcd:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801bd1:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801bd5:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801bdc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801be0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801be4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801be8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801bec:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801bf0:	48 b8 fe 1b 80 00 00 	movabs $0x801bfe,%rax
  801bf7:	00 00 00 
  801bfa:	ff d0                	call   *%rax
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

0000000000801bfe <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801bfe:	55                   	push   %rbp
  801bff:	48 89 e5             	mov    %rsp,%rbp
  801c02:	41 57                	push   %r15
  801c04:	41 56                	push   %r14
  801c06:	41 55                	push   %r13
  801c08:	41 54                	push   %r12
  801c0a:	53                   	push   %rbx
  801c0b:	48 83 ec 48          	sub    $0x48,%rsp
  801c0f:	49 89 fc             	mov    %rdi,%r12
  801c12:	49 89 f6             	mov    %rsi,%r14
  801c15:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  801c18:	48 8b 01             	mov    (%rcx),%rax
  801c1b:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801c1f:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801c23:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801c27:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801c2b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801c2f:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  801c33:	41 0f b6 3f          	movzbl (%r15),%edi
  801c37:	40 80 ff 25          	cmp    $0x25,%dil
  801c3b:	74 18                	je     801c55 <vprintfmt+0x57>
            if (!ch) return;
  801c3d:	40 84 ff             	test   %dil,%dil
  801c40:	0f 84 d1 06 00 00    	je     802317 <vprintfmt+0x719>
            putch(ch, put_arg);
  801c46:	40 0f b6 ff          	movzbl %dil,%edi
  801c4a:	4c 89 f6             	mov    %r14,%rsi
  801c4d:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  801c50:	49 89 df             	mov    %rbx,%r15
  801c53:	eb da                	jmp    801c2f <vprintfmt+0x31>
            precision = va_arg(aq, int);
  801c55:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  801c59:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c5e:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  801c62:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801c67:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801c6d:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801c74:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  801c78:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  801c7d:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  801c83:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  801c87:	44 0f b6 0b          	movzbl (%rbx),%r9d
  801c8b:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  801c8f:	3c 57                	cmp    $0x57,%al
  801c91:	0f 87 65 06 00 00    	ja     8022fc <vprintfmt+0x6fe>
  801c97:	0f b6 c0             	movzbl %al,%eax
  801c9a:	49 ba c0 2c 80 00 00 	movabs $0x802cc0,%r10
  801ca1:	00 00 00 
  801ca4:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  801ca8:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  801cab:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  801caf:	eb d2                	jmp    801c83 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  801cb1:	4c 89 fb             	mov    %r15,%rbx
  801cb4:	44 89 c1             	mov    %r8d,%ecx
  801cb7:	eb ca                	jmp    801c83 <vprintfmt+0x85>
            padc = ch;
  801cb9:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  801cbd:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801cc0:	eb c1                	jmp    801c83 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cc2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801cc5:	83 f8 2f             	cmp    $0x2f,%eax
  801cc8:	77 24                	ja     801cee <vprintfmt+0xf0>
  801cca:	41 89 c1             	mov    %eax,%r9d
  801ccd:	49 01 f1             	add    %rsi,%r9
  801cd0:	83 c0 08             	add    $0x8,%eax
  801cd3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801cd6:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  801cd9:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  801cdc:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801ce0:	79 a1                	jns    801c83 <vprintfmt+0x85>
                width = precision;
  801ce2:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  801ce6:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801cec:	eb 95                	jmp    801c83 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cee:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  801cf2:	49 8d 41 08          	lea    0x8(%r9),%rax
  801cf6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801cfa:	eb da                	jmp    801cd6 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  801cfc:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  801d00:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d04:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  801d08:	3c 39                	cmp    $0x39,%al
  801d0a:	77 1e                	ja     801d2a <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  801d0c:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  801d10:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  801d15:	0f b6 c0             	movzbl %al,%eax
  801d18:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d1d:	41 0f b6 07          	movzbl (%r15),%eax
  801d21:	3c 39                	cmp    $0x39,%al
  801d23:	76 e7                	jbe    801d0c <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  801d25:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  801d28:	eb b2                	jmp    801cdc <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  801d2a:	4c 89 fb             	mov    %r15,%rbx
  801d2d:	eb ad                	jmp    801cdc <vprintfmt+0xde>
            width = MAX(0, width);
  801d2f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801d32:	85 c0                	test   %eax,%eax
  801d34:	0f 48 c7             	cmovs  %edi,%eax
  801d37:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801d3a:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d3d:	e9 41 ff ff ff       	jmp    801c83 <vprintfmt+0x85>
            lflag++;
  801d42:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801d45:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d48:	e9 36 ff ff ff       	jmp    801c83 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  801d4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d50:	83 f8 2f             	cmp    $0x2f,%eax
  801d53:	77 18                	ja     801d6d <vprintfmt+0x16f>
  801d55:	89 c2                	mov    %eax,%edx
  801d57:	48 01 f2             	add    %rsi,%rdx
  801d5a:	83 c0 08             	add    $0x8,%eax
  801d5d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d60:	4c 89 f6             	mov    %r14,%rsi
  801d63:	8b 3a                	mov    (%rdx),%edi
  801d65:	41 ff d4             	call   *%r12
            break;
  801d68:	e9 c2 fe ff ff       	jmp    801c2f <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  801d6d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801d71:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801d75:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d79:	eb e5                	jmp    801d60 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  801d7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d7e:	83 f8 2f             	cmp    $0x2f,%eax
  801d81:	77 5b                	ja     801dde <vprintfmt+0x1e0>
  801d83:	89 c2                	mov    %eax,%edx
  801d85:	48 01 d6             	add    %rdx,%rsi
  801d88:	83 c0 08             	add    $0x8,%eax
  801d8b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d8e:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  801d90:	89 c8                	mov    %ecx,%eax
  801d92:	c1 f8 1f             	sar    $0x1f,%eax
  801d95:	31 c1                	xor    %eax,%ecx
  801d97:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  801d99:	83 f9 13             	cmp    $0x13,%ecx
  801d9c:	7f 4e                	jg     801dec <vprintfmt+0x1ee>
  801d9e:	48 63 c1             	movslq %ecx,%rax
  801da1:	48 ba 80 2f 80 00 00 	movabs $0x802f80,%rdx
  801da8:	00 00 00 
  801dab:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801daf:	48 85 c0             	test   %rax,%rax
  801db2:	74 38                	je     801dec <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  801db4:	48 89 c1             	mov    %rax,%rcx
  801db7:	48 ba b9 2a 80 00 00 	movabs $0x802ab9,%rdx
  801dbe:	00 00 00 
  801dc1:	4c 89 f6             	mov    %r14,%rsi
  801dc4:	4c 89 e7             	mov    %r12,%rdi
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcc:	49 b8 c1 1b 80 00 00 	movabs $0x801bc1,%r8
  801dd3:	00 00 00 
  801dd6:	41 ff d0             	call   *%r8
  801dd9:	e9 51 fe ff ff       	jmp    801c2f <vprintfmt+0x31>
            int err = va_arg(aq, int);
  801dde:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801de2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801de6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801dea:	eb a2                	jmp    801d8e <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  801dec:	48 ba 4c 2b 80 00 00 	movabs $0x802b4c,%rdx
  801df3:	00 00 00 
  801df6:	4c 89 f6             	mov    %r14,%rsi
  801df9:	4c 89 e7             	mov    %r12,%rdi
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801e01:	49 b8 c1 1b 80 00 00 	movabs $0x801bc1,%r8
  801e08:	00 00 00 
  801e0b:	41 ff d0             	call   *%r8
  801e0e:	e9 1c fe ff ff       	jmp    801c2f <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  801e13:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801e16:	83 f8 2f             	cmp    $0x2f,%eax
  801e19:	77 55                	ja     801e70 <vprintfmt+0x272>
  801e1b:	89 c2                	mov    %eax,%edx
  801e1d:	48 01 d6             	add    %rdx,%rsi
  801e20:	83 c0 08             	add    $0x8,%eax
  801e23:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801e26:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  801e29:	48 85 d2             	test   %rdx,%rdx
  801e2c:	48 b8 45 2b 80 00 00 	movabs $0x802b45,%rax
  801e33:	00 00 00 
  801e36:	48 0f 45 c2          	cmovne %rdx,%rax
  801e3a:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  801e3e:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801e42:	7e 06                	jle    801e4a <vprintfmt+0x24c>
  801e44:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  801e48:	75 34                	jne    801e7e <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801e4a:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  801e4e:	48 8d 58 01          	lea    0x1(%rax),%rbx
  801e52:	0f b6 00             	movzbl (%rax),%eax
  801e55:	84 c0                	test   %al,%al
  801e57:	0f 84 b2 00 00 00    	je     801f0f <vprintfmt+0x311>
  801e5d:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  801e61:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  801e66:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  801e6a:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  801e6e:	eb 74                	jmp    801ee4 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  801e70:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801e74:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801e78:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e7c:	eb a8                	jmp    801e26 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  801e7e:	49 63 f5             	movslq %r13d,%rsi
  801e81:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  801e85:	48 b8 d1 23 80 00 00 	movabs $0x8023d1,%rax
  801e8c:	00 00 00 
  801e8f:	ff d0                	call   *%rax
  801e91:	48 89 c2             	mov    %rax,%rdx
  801e94:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801e97:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  801e99:	8d 48 ff             	lea    -0x1(%rax),%ecx
  801e9c:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	7e a7                	jle    801e4a <vprintfmt+0x24c>
  801ea3:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  801ea7:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  801eab:	41 89 cd             	mov    %ecx,%r13d
  801eae:	4c 89 f6             	mov    %r14,%rsi
  801eb1:	89 df                	mov    %ebx,%edi
  801eb3:	41 ff d4             	call   *%r12
  801eb6:	41 83 ed 01          	sub    $0x1,%r13d
  801eba:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  801ebe:	75 ee                	jne    801eae <vprintfmt+0x2b0>
  801ec0:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  801ec4:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  801ec8:	eb 80                	jmp    801e4a <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801eca:	0f b6 f8             	movzbl %al,%edi
  801ecd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801ed1:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801ed4:	41 83 ef 01          	sub    $0x1,%r15d
  801ed8:	48 83 c3 01          	add    $0x1,%rbx
  801edc:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  801ee0:	84 c0                	test   %al,%al
  801ee2:	74 1f                	je     801f03 <vprintfmt+0x305>
  801ee4:	45 85 ed             	test   %r13d,%r13d
  801ee7:	78 06                	js     801eef <vprintfmt+0x2f1>
  801ee9:	41 83 ed 01          	sub    $0x1,%r13d
  801eed:	78 46                	js     801f35 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801eef:	45 84 f6             	test   %r14b,%r14b
  801ef2:	74 d6                	je     801eca <vprintfmt+0x2cc>
  801ef4:	8d 50 e0             	lea    -0x20(%rax),%edx
  801ef7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801efc:	80 fa 5e             	cmp    $0x5e,%dl
  801eff:	77 cc                	ja     801ecd <vprintfmt+0x2cf>
  801f01:	eb c7                	jmp    801eca <vprintfmt+0x2cc>
  801f03:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f07:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f0b:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  801f0f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801f12:	8d 58 ff             	lea    -0x1(%rax),%ebx
  801f15:	85 c0                	test   %eax,%eax
  801f17:	0f 8e 12 fd ff ff    	jle    801c2f <vprintfmt+0x31>
  801f1d:	4c 89 f6             	mov    %r14,%rsi
  801f20:	bf 20 00 00 00       	mov    $0x20,%edi
  801f25:	41 ff d4             	call   *%r12
  801f28:	83 eb 01             	sub    $0x1,%ebx
  801f2b:	83 fb ff             	cmp    $0xffffffff,%ebx
  801f2e:	75 ed                	jne    801f1d <vprintfmt+0x31f>
  801f30:	e9 fa fc ff ff       	jmp    801c2f <vprintfmt+0x31>
  801f35:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f39:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f3d:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  801f41:	eb cc                	jmp    801f0f <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  801f43:	45 89 cd             	mov    %r9d,%r13d
  801f46:	84 c9                	test   %cl,%cl
  801f48:	75 25                	jne    801f6f <vprintfmt+0x371>
    switch (lflag) {
  801f4a:	85 d2                	test   %edx,%edx
  801f4c:	74 57                	je     801fa5 <vprintfmt+0x3a7>
  801f4e:	83 fa 01             	cmp    $0x1,%edx
  801f51:	74 78                	je     801fcb <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  801f53:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f56:	83 f8 2f             	cmp    $0x2f,%eax
  801f59:	0f 87 92 00 00 00    	ja     801ff1 <vprintfmt+0x3f3>
  801f5f:	89 c2                	mov    %eax,%edx
  801f61:	48 01 d6             	add    %rdx,%rsi
  801f64:	83 c0 08             	add    $0x8,%eax
  801f67:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f6a:	48 8b 1e             	mov    (%rsi),%rbx
  801f6d:	eb 16                	jmp    801f85 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  801f6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f72:	83 f8 2f             	cmp    $0x2f,%eax
  801f75:	77 20                	ja     801f97 <vprintfmt+0x399>
  801f77:	89 c2                	mov    %eax,%edx
  801f79:	48 01 d6             	add    %rdx,%rsi
  801f7c:	83 c0 08             	add    $0x8,%eax
  801f7f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f82:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  801f85:	48 85 db             	test   %rbx,%rbx
  801f88:	78 78                	js     802002 <vprintfmt+0x404>
            num = i;
  801f8a:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  801f8d:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  801f92:	e9 49 02 00 00       	jmp    8021e0 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801f97:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801f9b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801f9f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fa3:	eb dd                	jmp    801f82 <vprintfmt+0x384>
        return va_arg(*ap, int);
  801fa5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fa8:	83 f8 2f             	cmp    $0x2f,%eax
  801fab:	77 10                	ja     801fbd <vprintfmt+0x3bf>
  801fad:	89 c2                	mov    %eax,%edx
  801faf:	48 01 d6             	add    %rdx,%rsi
  801fb2:	83 c0 08             	add    $0x8,%eax
  801fb5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fb8:	48 63 1e             	movslq (%rsi),%rbx
  801fbb:	eb c8                	jmp    801f85 <vprintfmt+0x387>
  801fbd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fc1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fc5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fc9:	eb ed                	jmp    801fb8 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  801fcb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fce:	83 f8 2f             	cmp    $0x2f,%eax
  801fd1:	77 10                	ja     801fe3 <vprintfmt+0x3e5>
  801fd3:	89 c2                	mov    %eax,%edx
  801fd5:	48 01 d6             	add    %rdx,%rsi
  801fd8:	83 c0 08             	add    $0x8,%eax
  801fdb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fde:	48 8b 1e             	mov    (%rsi),%rbx
  801fe1:	eb a2                	jmp    801f85 <vprintfmt+0x387>
  801fe3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fe7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801feb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fef:	eb ed                	jmp    801fde <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  801ff1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801ff5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801ff9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ffd:	e9 68 ff ff ff       	jmp    801f6a <vprintfmt+0x36c>
                putch('-', put_arg);
  802002:	4c 89 f6             	mov    %r14,%rsi
  802005:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80200a:	41 ff d4             	call   *%r12
                i = -i;
  80200d:	48 f7 db             	neg    %rbx
  802010:	e9 75 ff ff ff       	jmp    801f8a <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  802015:	45 89 cd             	mov    %r9d,%r13d
  802018:	84 c9                	test   %cl,%cl
  80201a:	75 2d                	jne    802049 <vprintfmt+0x44b>
    switch (lflag) {
  80201c:	85 d2                	test   %edx,%edx
  80201e:	74 57                	je     802077 <vprintfmt+0x479>
  802020:	83 fa 01             	cmp    $0x1,%edx
  802023:	74 7f                	je     8020a4 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  802025:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802028:	83 f8 2f             	cmp    $0x2f,%eax
  80202b:	0f 87 a1 00 00 00    	ja     8020d2 <vprintfmt+0x4d4>
  802031:	89 c2                	mov    %eax,%edx
  802033:	48 01 d6             	add    %rdx,%rsi
  802036:	83 c0 08             	add    $0x8,%eax
  802039:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80203c:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80203f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  802044:	e9 97 01 00 00       	jmp    8021e0 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802049:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80204c:	83 f8 2f             	cmp    $0x2f,%eax
  80204f:	77 18                	ja     802069 <vprintfmt+0x46b>
  802051:	89 c2                	mov    %eax,%edx
  802053:	48 01 d6             	add    %rdx,%rsi
  802056:	83 c0 08             	add    $0x8,%eax
  802059:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80205c:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80205f:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802064:	e9 77 01 00 00       	jmp    8021e0 <vprintfmt+0x5e2>
  802069:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80206d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802071:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802075:	eb e5                	jmp    80205c <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  802077:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80207a:	83 f8 2f             	cmp    $0x2f,%eax
  80207d:	77 17                	ja     802096 <vprintfmt+0x498>
  80207f:	89 c2                	mov    %eax,%edx
  802081:	48 01 d6             	add    %rdx,%rsi
  802084:	83 c0 08             	add    $0x8,%eax
  802087:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80208a:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  80208c:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802091:	e9 4a 01 00 00       	jmp    8021e0 <vprintfmt+0x5e2>
  802096:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80209a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80209e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020a2:	eb e6                	jmp    80208a <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8020a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020a7:	83 f8 2f             	cmp    $0x2f,%eax
  8020aa:	77 18                	ja     8020c4 <vprintfmt+0x4c6>
  8020ac:	89 c2                	mov    %eax,%edx
  8020ae:	48 01 d6             	add    %rdx,%rsi
  8020b1:	83 c0 08             	add    $0x8,%eax
  8020b4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020b7:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8020ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8020bf:	e9 1c 01 00 00       	jmp    8021e0 <vprintfmt+0x5e2>
  8020c4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020c8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020cc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020d0:	eb e5                	jmp    8020b7 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8020d2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020d6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020da:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020de:	e9 59 ff ff ff       	jmp    80203c <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8020e3:	45 89 cd             	mov    %r9d,%r13d
  8020e6:	84 c9                	test   %cl,%cl
  8020e8:	75 2d                	jne    802117 <vprintfmt+0x519>
    switch (lflag) {
  8020ea:	85 d2                	test   %edx,%edx
  8020ec:	74 57                	je     802145 <vprintfmt+0x547>
  8020ee:	83 fa 01             	cmp    $0x1,%edx
  8020f1:	74 7c                	je     80216f <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8020f3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020f6:	83 f8 2f             	cmp    $0x2f,%eax
  8020f9:	0f 87 9b 00 00 00    	ja     80219a <vprintfmt+0x59c>
  8020ff:	89 c2                	mov    %eax,%edx
  802101:	48 01 d6             	add    %rdx,%rsi
  802104:	83 c0 08             	add    $0x8,%eax
  802107:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80210a:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80210d:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802112:	e9 c9 00 00 00       	jmp    8021e0 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802117:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80211a:	83 f8 2f             	cmp    $0x2f,%eax
  80211d:	77 18                	ja     802137 <vprintfmt+0x539>
  80211f:	89 c2                	mov    %eax,%edx
  802121:	48 01 d6             	add    %rdx,%rsi
  802124:	83 c0 08             	add    $0x8,%eax
  802127:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80212a:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80212d:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802132:	e9 a9 00 00 00       	jmp    8021e0 <vprintfmt+0x5e2>
  802137:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80213b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80213f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802143:	eb e5                	jmp    80212a <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  802145:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802148:	83 f8 2f             	cmp    $0x2f,%eax
  80214b:	77 14                	ja     802161 <vprintfmt+0x563>
  80214d:	89 c2                	mov    %eax,%edx
  80214f:	48 01 d6             	add    %rdx,%rsi
  802152:	83 c0 08             	add    $0x8,%eax
  802155:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802158:	8b 16                	mov    (%rsi),%edx
            base = 8;
  80215a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80215f:	eb 7f                	jmp    8021e0 <vprintfmt+0x5e2>
  802161:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802165:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802169:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80216d:	eb e9                	jmp    802158 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  80216f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802172:	83 f8 2f             	cmp    $0x2f,%eax
  802175:	77 15                	ja     80218c <vprintfmt+0x58e>
  802177:	89 c2                	mov    %eax,%edx
  802179:	48 01 d6             	add    %rdx,%rsi
  80217c:	83 c0 08             	add    $0x8,%eax
  80217f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802182:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802185:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80218a:	eb 54                	jmp    8021e0 <vprintfmt+0x5e2>
  80218c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802190:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802194:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802198:	eb e8                	jmp    802182 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  80219a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80219e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8021a2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8021a6:	e9 5f ff ff ff       	jmp    80210a <vprintfmt+0x50c>
            putch('0', put_arg);
  8021ab:	45 89 cd             	mov    %r9d,%r13d
  8021ae:	4c 89 f6             	mov    %r14,%rsi
  8021b1:	bf 30 00 00 00       	mov    $0x30,%edi
  8021b6:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8021b9:	4c 89 f6             	mov    %r14,%rsi
  8021bc:	bf 78 00 00 00       	mov    $0x78,%edi
  8021c1:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8021c4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021c7:	83 f8 2f             	cmp    $0x2f,%eax
  8021ca:	77 47                	ja     802213 <vprintfmt+0x615>
  8021cc:	89 c2                	mov    %eax,%edx
  8021ce:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021d2:	83 c0 08             	add    $0x8,%eax
  8021d5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021d8:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8021db:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8021e0:	48 83 ec 08          	sub    $0x8,%rsp
  8021e4:	41 80 fd 58          	cmp    $0x58,%r13b
  8021e8:	0f 94 c0             	sete   %al
  8021eb:	0f b6 c0             	movzbl %al,%eax
  8021ee:	50                   	push   %rax
  8021ef:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  8021f4:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8021f8:	4c 89 f6             	mov    %r14,%rsi
  8021fb:	4c 89 e7             	mov    %r12,%rdi
  8021fe:	48 b8 f3 1a 80 00 00 	movabs $0x801af3,%rax
  802205:	00 00 00 
  802208:	ff d0                	call   *%rax
            break;
  80220a:	48 83 c4 10          	add    $0x10,%rsp
  80220e:	e9 1c fa ff ff       	jmp    801c2f <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  802213:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802217:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80221b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80221f:	eb b7                	jmp    8021d8 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  802221:	45 89 cd             	mov    %r9d,%r13d
  802224:	84 c9                	test   %cl,%cl
  802226:	75 2a                	jne    802252 <vprintfmt+0x654>
    switch (lflag) {
  802228:	85 d2                	test   %edx,%edx
  80222a:	74 54                	je     802280 <vprintfmt+0x682>
  80222c:	83 fa 01             	cmp    $0x1,%edx
  80222f:	74 7c                	je     8022ad <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  802231:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802234:	83 f8 2f             	cmp    $0x2f,%eax
  802237:	0f 87 9e 00 00 00    	ja     8022db <vprintfmt+0x6dd>
  80223d:	89 c2                	mov    %eax,%edx
  80223f:	48 01 d6             	add    %rdx,%rsi
  802242:	83 c0 08             	add    $0x8,%eax
  802245:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802248:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80224b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  802250:	eb 8e                	jmp    8021e0 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802252:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802255:	83 f8 2f             	cmp    $0x2f,%eax
  802258:	77 18                	ja     802272 <vprintfmt+0x674>
  80225a:	89 c2                	mov    %eax,%edx
  80225c:	48 01 d6             	add    %rdx,%rsi
  80225f:	83 c0 08             	add    $0x8,%eax
  802262:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802265:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802268:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80226d:	e9 6e ff ff ff       	jmp    8021e0 <vprintfmt+0x5e2>
  802272:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802276:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80227a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80227e:	eb e5                	jmp    802265 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  802280:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802283:	83 f8 2f             	cmp    $0x2f,%eax
  802286:	77 17                	ja     80229f <vprintfmt+0x6a1>
  802288:	89 c2                	mov    %eax,%edx
  80228a:	48 01 d6             	add    %rdx,%rsi
  80228d:	83 c0 08             	add    $0x8,%eax
  802290:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802293:	8b 16                	mov    (%rsi),%edx
            base = 16;
  802295:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  80229a:	e9 41 ff ff ff       	jmp    8021e0 <vprintfmt+0x5e2>
  80229f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022a3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022a7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022ab:	eb e6                	jmp    802293 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8022ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022b0:	83 f8 2f             	cmp    $0x2f,%eax
  8022b3:	77 18                	ja     8022cd <vprintfmt+0x6cf>
  8022b5:	89 c2                	mov    %eax,%edx
  8022b7:	48 01 d6             	add    %rdx,%rsi
  8022ba:	83 c0 08             	add    $0x8,%eax
  8022bd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022c0:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8022c3:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8022c8:	e9 13 ff ff ff       	jmp    8021e0 <vprintfmt+0x5e2>
  8022cd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022d1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022d5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022d9:	eb e5                	jmp    8022c0 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  8022db:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022df:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022e3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022e7:	e9 5c ff ff ff       	jmp    802248 <vprintfmt+0x64a>
            putch(ch, put_arg);
  8022ec:	4c 89 f6             	mov    %r14,%rsi
  8022ef:	bf 25 00 00 00       	mov    $0x25,%edi
  8022f4:	41 ff d4             	call   *%r12
            break;
  8022f7:	e9 33 f9 ff ff       	jmp    801c2f <vprintfmt+0x31>
            putch('%', put_arg);
  8022fc:	4c 89 f6             	mov    %r14,%rsi
  8022ff:	bf 25 00 00 00       	mov    $0x25,%edi
  802304:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  802307:	49 83 ef 01          	sub    $0x1,%r15
  80230b:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  802310:	75 f5                	jne    802307 <vprintfmt+0x709>
  802312:	e9 18 f9 ff ff       	jmp    801c2f <vprintfmt+0x31>
}
  802317:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80231b:	5b                   	pop    %rbx
  80231c:	41 5c                	pop    %r12
  80231e:	41 5d                	pop    %r13
  802320:	41 5e                	pop    %r14
  802322:	41 5f                	pop    %r15
  802324:	5d                   	pop    %rbp
  802325:	c3                   	ret    

0000000000802326 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  802326:	55                   	push   %rbp
  802327:	48 89 e5             	mov    %rsp,%rbp
  80232a:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  80232e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802332:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  802337:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80233b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  802342:	48 85 ff             	test   %rdi,%rdi
  802345:	74 2b                	je     802372 <vsnprintf+0x4c>
  802347:	48 85 f6             	test   %rsi,%rsi
  80234a:	74 26                	je     802372 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  80234c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802350:	48 bf a9 1b 80 00 00 	movabs $0x801ba9,%rdi
  802357:	00 00 00 
  80235a:	48 b8 fe 1b 80 00 00 	movabs $0x801bfe,%rax
  802361:	00 00 00 
  802364:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  802366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236a:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  80236d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  802372:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802377:	eb f7                	jmp    802370 <vsnprintf+0x4a>

0000000000802379 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  802379:	55                   	push   %rbp
  80237a:	48 89 e5             	mov    %rsp,%rbp
  80237d:	48 83 ec 50          	sub    $0x50,%rsp
  802381:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802385:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802389:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80238d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  802394:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802398:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80239c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8023a0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  8023a4:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8023a8:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  8023af:	00 00 00 
  8023b2:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

00000000008023b6 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  8023b6:	80 3f 00             	cmpb   $0x0,(%rdi)
  8023b9:	74 10                	je     8023cb <strlen+0x15>
    size_t n = 0;
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8023c0:	48 83 c0 01          	add    $0x1,%rax
  8023c4:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023c8:	75 f6                	jne    8023c0 <strlen+0xa>
  8023ca:	c3                   	ret    
    size_t n = 0;
  8023cb:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  8023d0:	c3                   	ret    

00000000008023d1 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  8023d1:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  8023d6:	48 85 f6             	test   %rsi,%rsi
  8023d9:	74 10                	je     8023eb <strnlen+0x1a>
  8023db:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023df:	74 09                	je     8023ea <strnlen+0x19>
  8023e1:	48 83 c0 01          	add    $0x1,%rax
  8023e5:	48 39 c6             	cmp    %rax,%rsi
  8023e8:	75 f1                	jne    8023db <strnlen+0xa>
    return n;
}
  8023ea:	c3                   	ret    
    size_t n = 0;
  8023eb:	48 89 f0             	mov    %rsi,%rax
  8023ee:	c3                   	ret    

00000000008023ef <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8023ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f4:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  8023f8:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  8023fb:	48 83 c0 01          	add    $0x1,%rax
  8023ff:	84 d2                	test   %dl,%dl
  802401:	75 f1                	jne    8023f4 <strcpy+0x5>
        ;
    return res;
}
  802403:	48 89 f8             	mov    %rdi,%rax
  802406:	c3                   	ret    

0000000000802407 <strcat>:

char *
strcat(char *dst, const char *src) {
  802407:	55                   	push   %rbp
  802408:	48 89 e5             	mov    %rsp,%rbp
  80240b:	41 54                	push   %r12
  80240d:	53                   	push   %rbx
  80240e:	48 89 fb             	mov    %rdi,%rbx
  802411:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  802414:	48 b8 b6 23 80 00 00 	movabs $0x8023b6,%rax
  80241b:	00 00 00 
  80241e:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  802420:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  802424:	4c 89 e6             	mov    %r12,%rsi
  802427:	48 b8 ef 23 80 00 00 	movabs $0x8023ef,%rax
  80242e:	00 00 00 
  802431:	ff d0                	call   *%rax
    return dst;
}
  802433:	48 89 d8             	mov    %rbx,%rax
  802436:	5b                   	pop    %rbx
  802437:	41 5c                	pop    %r12
  802439:	5d                   	pop    %rbp
  80243a:	c3                   	ret    

000000000080243b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  80243b:	48 85 d2             	test   %rdx,%rdx
  80243e:	74 1d                	je     80245d <strncpy+0x22>
  802440:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802444:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  802447:	48 83 c0 01          	add    $0x1,%rax
  80244b:	0f b6 16             	movzbl (%rsi),%edx
  80244e:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  802451:	80 fa 01             	cmp    $0x1,%dl
  802454:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  802458:	48 39 c1             	cmp    %rax,%rcx
  80245b:	75 ea                	jne    802447 <strncpy+0xc>
    }
    return ret;
}
  80245d:	48 89 f8             	mov    %rdi,%rax
  802460:	c3                   	ret    

0000000000802461 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  802461:	48 89 f8             	mov    %rdi,%rax
  802464:	48 85 d2             	test   %rdx,%rdx
  802467:	74 24                	je     80248d <strlcpy+0x2c>
        while (--size > 0 && *src)
  802469:	48 83 ea 01          	sub    $0x1,%rdx
  80246d:	74 1b                	je     80248a <strlcpy+0x29>
  80246f:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802473:	0f b6 16             	movzbl (%rsi),%edx
  802476:	84 d2                	test   %dl,%dl
  802478:	74 10                	je     80248a <strlcpy+0x29>
            *dst++ = *src++;
  80247a:	48 83 c6 01          	add    $0x1,%rsi
  80247e:	48 83 c0 01          	add    $0x1,%rax
  802482:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  802485:	48 39 c8             	cmp    %rcx,%rax
  802488:	75 e9                	jne    802473 <strlcpy+0x12>
        *dst = '\0';
  80248a:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  80248d:	48 29 f8             	sub    %rdi,%rax
}
  802490:	c3                   	ret    

0000000000802491 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  802491:	0f b6 07             	movzbl (%rdi),%eax
  802494:	84 c0                	test   %al,%al
  802496:	74 13                	je     8024ab <strcmp+0x1a>
  802498:	38 06                	cmp    %al,(%rsi)
  80249a:	75 0f                	jne    8024ab <strcmp+0x1a>
  80249c:	48 83 c7 01          	add    $0x1,%rdi
  8024a0:	48 83 c6 01          	add    $0x1,%rsi
  8024a4:	0f b6 07             	movzbl (%rdi),%eax
  8024a7:	84 c0                	test   %al,%al
  8024a9:	75 ed                	jne    802498 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8024ab:	0f b6 c0             	movzbl %al,%eax
  8024ae:	0f b6 16             	movzbl (%rsi),%edx
  8024b1:	29 d0                	sub    %edx,%eax
}
  8024b3:	c3                   	ret    

00000000008024b4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  8024b4:	48 85 d2             	test   %rdx,%rdx
  8024b7:	74 1f                	je     8024d8 <strncmp+0x24>
  8024b9:	0f b6 07             	movzbl (%rdi),%eax
  8024bc:	84 c0                	test   %al,%al
  8024be:	74 1e                	je     8024de <strncmp+0x2a>
  8024c0:	3a 06                	cmp    (%rsi),%al
  8024c2:	75 1a                	jne    8024de <strncmp+0x2a>
  8024c4:	48 83 c7 01          	add    $0x1,%rdi
  8024c8:	48 83 c6 01          	add    $0x1,%rsi
  8024cc:	48 83 ea 01          	sub    $0x1,%rdx
  8024d0:	75 e7                	jne    8024b9 <strncmp+0x5>

    if (!n) return 0;
  8024d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d7:	c3                   	ret    
  8024d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024dd:	c3                   	ret    
  8024de:	48 85 d2             	test   %rdx,%rdx
  8024e1:	74 09                	je     8024ec <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  8024e3:	0f b6 07             	movzbl (%rdi),%eax
  8024e6:	0f b6 16             	movzbl (%rsi),%edx
  8024e9:	29 d0                	sub    %edx,%eax
  8024eb:	c3                   	ret    
    if (!n) return 0;
  8024ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f1:	c3                   	ret    

00000000008024f2 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  8024f2:	0f b6 07             	movzbl (%rdi),%eax
  8024f5:	84 c0                	test   %al,%al
  8024f7:	74 18                	je     802511 <strchr+0x1f>
        if (*str == c) {
  8024f9:	0f be c0             	movsbl %al,%eax
  8024fc:	39 f0                	cmp    %esi,%eax
  8024fe:	74 17                	je     802517 <strchr+0x25>
    for (; *str; str++) {
  802500:	48 83 c7 01          	add    $0x1,%rdi
  802504:	0f b6 07             	movzbl (%rdi),%eax
  802507:	84 c0                	test   %al,%al
  802509:	75 ee                	jne    8024f9 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  80250b:	b8 00 00 00 00       	mov    $0x0,%eax
  802510:	c3                   	ret    
  802511:	b8 00 00 00 00       	mov    $0x0,%eax
  802516:	c3                   	ret    
  802517:	48 89 f8             	mov    %rdi,%rax
}
  80251a:	c3                   	ret    

000000000080251b <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  80251b:	0f b6 07             	movzbl (%rdi),%eax
  80251e:	84 c0                	test   %al,%al
  802520:	74 16                	je     802538 <strfind+0x1d>
  802522:	0f be c0             	movsbl %al,%eax
  802525:	39 f0                	cmp    %esi,%eax
  802527:	74 13                	je     80253c <strfind+0x21>
  802529:	48 83 c7 01          	add    $0x1,%rdi
  80252d:	0f b6 07             	movzbl (%rdi),%eax
  802530:	84 c0                	test   %al,%al
  802532:	75 ee                	jne    802522 <strfind+0x7>
  802534:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  802537:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  802538:	48 89 f8             	mov    %rdi,%rax
  80253b:	c3                   	ret    
  80253c:	48 89 f8             	mov    %rdi,%rax
  80253f:	c3                   	ret    

0000000000802540 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  802540:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  802543:	48 89 f8             	mov    %rdi,%rax
  802546:	48 f7 d8             	neg    %rax
  802549:	83 e0 07             	and    $0x7,%eax
  80254c:	49 89 d1             	mov    %rdx,%r9
  80254f:	49 29 c1             	sub    %rax,%r9
  802552:	78 32                	js     802586 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  802554:	40 0f b6 c6          	movzbl %sil,%eax
  802558:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  80255f:	01 01 01 
  802562:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  802566:	40 f6 c7 07          	test   $0x7,%dil
  80256a:	75 34                	jne    8025a0 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80256c:	4c 89 c9             	mov    %r9,%rcx
  80256f:	48 c1 f9 03          	sar    $0x3,%rcx
  802573:	74 08                	je     80257d <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  802575:	fc                   	cld    
  802576:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802579:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  80257d:	4d 85 c9             	test   %r9,%r9
  802580:	75 45                	jne    8025c7 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  802582:	4c 89 c0             	mov    %r8,%rax
  802585:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  802586:	48 85 d2             	test   %rdx,%rdx
  802589:	74 f7                	je     802582 <memset+0x42>
  80258b:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  80258e:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  802591:	48 83 c0 01          	add    $0x1,%rax
  802595:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  802599:	48 39 c2             	cmp    %rax,%rdx
  80259c:	75 f3                	jne    802591 <memset+0x51>
  80259e:	eb e2                	jmp    802582 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8025a0:	40 f6 c7 01          	test   $0x1,%dil
  8025a4:	74 06                	je     8025ac <memset+0x6c>
  8025a6:	88 07                	mov    %al,(%rdi)
  8025a8:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025ac:	40 f6 c7 02          	test   $0x2,%dil
  8025b0:	74 07                	je     8025b9 <memset+0x79>
  8025b2:	66 89 07             	mov    %ax,(%rdi)
  8025b5:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025b9:	40 f6 c7 04          	test   $0x4,%dil
  8025bd:	74 ad                	je     80256c <memset+0x2c>
  8025bf:	89 07                	mov    %eax,(%rdi)
  8025c1:	48 83 c7 04          	add    $0x4,%rdi
  8025c5:	eb a5                	jmp    80256c <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025c7:	41 f6 c1 04          	test   $0x4,%r9b
  8025cb:	74 06                	je     8025d3 <memset+0x93>
  8025cd:	89 07                	mov    %eax,(%rdi)
  8025cf:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025d3:	41 f6 c1 02          	test   $0x2,%r9b
  8025d7:	74 07                	je     8025e0 <memset+0xa0>
  8025d9:	66 89 07             	mov    %ax,(%rdi)
  8025dc:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8025e0:	41 f6 c1 01          	test   $0x1,%r9b
  8025e4:	74 9c                	je     802582 <memset+0x42>
  8025e6:	88 07                	mov    %al,(%rdi)
  8025e8:	eb 98                	jmp    802582 <memset+0x42>

00000000008025ea <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8025ea:	48 89 f8             	mov    %rdi,%rax
  8025ed:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8025f0:	48 39 fe             	cmp    %rdi,%rsi
  8025f3:	73 39                	jae    80262e <memmove+0x44>
  8025f5:	48 01 f2             	add    %rsi,%rdx
  8025f8:	48 39 fa             	cmp    %rdi,%rdx
  8025fb:	76 31                	jbe    80262e <memmove+0x44>
        s += n;
        d += n;
  8025fd:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802600:	48 89 d6             	mov    %rdx,%rsi
  802603:	48 09 fe             	or     %rdi,%rsi
  802606:	48 09 ce             	or     %rcx,%rsi
  802609:	40 f6 c6 07          	test   $0x7,%sil
  80260d:	75 12                	jne    802621 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80260f:	48 83 ef 08          	sub    $0x8,%rdi
  802613:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  802617:	48 c1 e9 03          	shr    $0x3,%rcx
  80261b:	fd                   	std    
  80261c:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80261f:	fc                   	cld    
  802620:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  802621:	48 83 ef 01          	sub    $0x1,%rdi
  802625:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  802629:	fd                   	std    
  80262a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  80262c:	eb f1                	jmp    80261f <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80262e:	48 89 f2             	mov    %rsi,%rdx
  802631:	48 09 c2             	or     %rax,%rdx
  802634:	48 09 ca             	or     %rcx,%rdx
  802637:	f6 c2 07             	test   $0x7,%dl
  80263a:	75 0c                	jne    802648 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80263c:	48 c1 e9 03          	shr    $0x3,%rcx
  802640:	48 89 c7             	mov    %rax,%rdi
  802643:	fc                   	cld    
  802644:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  802647:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  802648:	48 89 c7             	mov    %rax,%rdi
  80264b:	fc                   	cld    
  80264c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  80264e:	c3                   	ret    

000000000080264f <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  80264f:	55                   	push   %rbp
  802650:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802653:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  80265a:	00 00 00 
  80265d:	ff d0                	call   *%rax
}
  80265f:	5d                   	pop    %rbp
  802660:	c3                   	ret    

0000000000802661 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802661:	55                   	push   %rbp
  802662:	48 89 e5             	mov    %rsp,%rbp
  802665:	41 57                	push   %r15
  802667:	41 56                	push   %r14
  802669:	41 55                	push   %r13
  80266b:	41 54                	push   %r12
  80266d:	53                   	push   %rbx
  80266e:	48 83 ec 08          	sub    $0x8,%rsp
  802672:	49 89 fe             	mov    %rdi,%r14
  802675:	49 89 f7             	mov    %rsi,%r15
  802678:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  80267b:	48 89 f7             	mov    %rsi,%rdi
  80267e:	48 b8 b6 23 80 00 00 	movabs $0x8023b6,%rax
  802685:	00 00 00 
  802688:	ff d0                	call   *%rax
  80268a:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80268d:	48 89 de             	mov    %rbx,%rsi
  802690:	4c 89 f7             	mov    %r14,%rdi
  802693:	48 b8 d1 23 80 00 00 	movabs $0x8023d1,%rax
  80269a:	00 00 00 
  80269d:	ff d0                	call   *%rax
  80269f:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8026a2:	48 39 c3             	cmp    %rax,%rbx
  8026a5:	74 36                	je     8026dd <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  8026a7:	48 89 d8             	mov    %rbx,%rax
  8026aa:	4c 29 e8             	sub    %r13,%rax
  8026ad:	4c 39 e0             	cmp    %r12,%rax
  8026b0:	76 30                	jbe    8026e2 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  8026b2:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8026b7:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026bb:	4c 89 fe             	mov    %r15,%rsi
  8026be:	48 b8 4f 26 80 00 00 	movabs $0x80264f,%rax
  8026c5:	00 00 00 
  8026c8:	ff d0                	call   *%rax
    return dstlen + srclen;
  8026ca:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8026ce:	48 83 c4 08          	add    $0x8,%rsp
  8026d2:	5b                   	pop    %rbx
  8026d3:	41 5c                	pop    %r12
  8026d5:	41 5d                	pop    %r13
  8026d7:	41 5e                	pop    %r14
  8026d9:	41 5f                	pop    %r15
  8026db:	5d                   	pop    %rbp
  8026dc:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8026dd:	4c 01 e0             	add    %r12,%rax
  8026e0:	eb ec                	jmp    8026ce <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8026e2:	48 83 eb 01          	sub    $0x1,%rbx
  8026e6:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026ea:	48 89 da             	mov    %rbx,%rdx
  8026ed:	4c 89 fe             	mov    %r15,%rsi
  8026f0:	48 b8 4f 26 80 00 00 	movabs $0x80264f,%rax
  8026f7:	00 00 00 
  8026fa:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8026fc:	49 01 de             	add    %rbx,%r14
  8026ff:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  802704:	eb c4                	jmp    8026ca <strlcat+0x69>

0000000000802706 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  802706:	49 89 f0             	mov    %rsi,%r8
  802709:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  80270c:	48 85 d2             	test   %rdx,%rdx
  80270f:	74 2a                	je     80273b <memcmp+0x35>
  802711:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  802716:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  80271a:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80271f:	38 ca                	cmp    %cl,%dl
  802721:	75 0f                	jne    802732 <memcmp+0x2c>
    while (n-- > 0) {
  802723:	48 83 c0 01          	add    $0x1,%rax
  802727:	48 39 c6             	cmp    %rax,%rsi
  80272a:	75 ea                	jne    802716 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
  802731:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  802732:	0f b6 c2             	movzbl %dl,%eax
  802735:	0f b6 c9             	movzbl %cl,%ecx
  802738:	29 c8                	sub    %ecx,%eax
  80273a:	c3                   	ret    
    return 0;
  80273b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802740:	c3                   	ret    

0000000000802741 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  802741:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802745:	48 39 c7             	cmp    %rax,%rdi
  802748:	73 0f                	jae    802759 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  80274a:	40 38 37             	cmp    %sil,(%rdi)
  80274d:	74 0e                	je     80275d <memfind+0x1c>
    for (; src < end; src++) {
  80274f:	48 83 c7 01          	add    $0x1,%rdi
  802753:	48 39 f8             	cmp    %rdi,%rax
  802756:	75 f2                	jne    80274a <memfind+0x9>
  802758:	c3                   	ret    
  802759:	48 89 f8             	mov    %rdi,%rax
  80275c:	c3                   	ret    
  80275d:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802760:	c3                   	ret    

0000000000802761 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802761:	49 89 f2             	mov    %rsi,%r10
  802764:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802767:	0f b6 37             	movzbl (%rdi),%esi
  80276a:	40 80 fe 20          	cmp    $0x20,%sil
  80276e:	74 06                	je     802776 <strtol+0x15>
  802770:	40 80 fe 09          	cmp    $0x9,%sil
  802774:	75 13                	jne    802789 <strtol+0x28>
  802776:	48 83 c7 01          	add    $0x1,%rdi
  80277a:	0f b6 37             	movzbl (%rdi),%esi
  80277d:	40 80 fe 20          	cmp    $0x20,%sil
  802781:	74 f3                	je     802776 <strtol+0x15>
  802783:	40 80 fe 09          	cmp    $0x9,%sil
  802787:	74 ed                	je     802776 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802789:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  80278c:	83 e0 fd             	and    $0xfffffffd,%eax
  80278f:	3c 01                	cmp    $0x1,%al
  802791:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802795:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  80279c:	75 11                	jne    8027af <strtol+0x4e>
  80279e:	80 3f 30             	cmpb   $0x30,(%rdi)
  8027a1:	74 16                	je     8027b9 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8027a3:	45 85 c0             	test   %r8d,%r8d
  8027a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8027ab:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8027af:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8027b4:	4d 63 c8             	movslq %r8d,%r9
  8027b7:	eb 38                	jmp    8027f1 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8027b9:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8027bd:	74 11                	je     8027d0 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8027bf:	45 85 c0             	test   %r8d,%r8d
  8027c2:	75 eb                	jne    8027af <strtol+0x4e>
        s++;
  8027c4:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8027c8:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8027ce:	eb df                	jmp    8027af <strtol+0x4e>
        s += 2;
  8027d0:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8027d4:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8027da:	eb d3                	jmp    8027af <strtol+0x4e>
            dig -= '0';
  8027dc:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8027df:	0f b6 c8             	movzbl %al,%ecx
  8027e2:	44 39 c1             	cmp    %r8d,%ecx
  8027e5:	7d 1f                	jge    802806 <strtol+0xa5>
        val = val * base + dig;
  8027e7:	49 0f af d1          	imul   %r9,%rdx
  8027eb:	0f b6 c0             	movzbl %al,%eax
  8027ee:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8027f1:	48 83 c7 01          	add    $0x1,%rdi
  8027f5:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8027f9:	3c 39                	cmp    $0x39,%al
  8027fb:	76 df                	jbe    8027dc <strtol+0x7b>
        else if (dig - 'a' < 27)
  8027fd:	3c 7b                	cmp    $0x7b,%al
  8027ff:	77 05                	ja     802806 <strtol+0xa5>
            dig -= 'a' - 10;
  802801:	83 e8 57             	sub    $0x57,%eax
  802804:	eb d9                	jmp    8027df <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  802806:	4d 85 d2             	test   %r10,%r10
  802809:	74 03                	je     80280e <strtol+0xad>
  80280b:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80280e:	48 89 d0             	mov    %rdx,%rax
  802811:	48 f7 d8             	neg    %rax
  802814:	40 80 fe 2d          	cmp    $0x2d,%sil
  802818:	48 0f 44 d0          	cmove  %rax,%rdx
}
  80281c:	48 89 d0             	mov    %rdx,%rax
  80281f:	c3                   	ret    

0000000000802820 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802820:	55                   	push   %rbp
  802821:	48 89 e5             	mov    %rsp,%rbp
  802824:	41 54                	push   %r12
  802826:	53                   	push   %rbx
  802827:	48 89 fb             	mov    %rdi,%rbx
  80282a:	48 89 f7             	mov    %rsi,%rdi
  80282d:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802830:	48 85 f6             	test   %rsi,%rsi
  802833:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80283a:	00 00 00 
  80283d:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802841:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802846:	48 85 d2             	test   %rdx,%rdx
  802849:	74 02                	je     80284d <ipc_recv+0x2d>
  80284b:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  80284d:	48 63 f6             	movslq %esi,%rsi
  802850:	48 b8 35 05 80 00 00 	movabs $0x800535,%rax
  802857:	00 00 00 
  80285a:	ff d0                	call   *%rax

    if (res < 0) {
  80285c:	85 c0                	test   %eax,%eax
  80285e:	78 45                	js     8028a5 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802860:	48 85 db             	test   %rbx,%rbx
  802863:	74 12                	je     802877 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802865:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80286c:	00 00 00 
  80286f:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802875:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802877:	4d 85 e4             	test   %r12,%r12
  80287a:	74 14                	je     802890 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  80287c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802883:	00 00 00 
  802886:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  80288c:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802890:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802897:	00 00 00 
  80289a:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8028a0:	5b                   	pop    %rbx
  8028a1:	41 5c                	pop    %r12
  8028a3:	5d                   	pop    %rbp
  8028a4:	c3                   	ret    
        if (from_env_store)
  8028a5:	48 85 db             	test   %rbx,%rbx
  8028a8:	74 06                	je     8028b0 <ipc_recv+0x90>
            *from_env_store = 0;
  8028aa:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8028b0:	4d 85 e4             	test   %r12,%r12
  8028b3:	74 eb                	je     8028a0 <ipc_recv+0x80>
            *perm_store = 0;
  8028b5:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028bc:	00 
  8028bd:	eb e1                	jmp    8028a0 <ipc_recv+0x80>

00000000008028bf <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028bf:	55                   	push   %rbp
  8028c0:	48 89 e5             	mov    %rsp,%rbp
  8028c3:	41 57                	push   %r15
  8028c5:	41 56                	push   %r14
  8028c7:	41 55                	push   %r13
  8028c9:	41 54                	push   %r12
  8028cb:	53                   	push   %rbx
  8028cc:	48 83 ec 18          	sub    $0x18,%rsp
  8028d0:	41 89 fd             	mov    %edi,%r13d
  8028d3:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028d6:	48 89 d3             	mov    %rdx,%rbx
  8028d9:	49 89 cc             	mov    %rcx,%r12
  8028dc:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028e0:	48 85 d2             	test   %rdx,%rdx
  8028e3:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8028ea:	00 00 00 
  8028ed:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028f1:	49 be 09 05 80 00 00 	movabs $0x800509,%r14
  8028f8:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  8028fb:	49 bf 0c 02 80 00 00 	movabs $0x80020c,%r15
  802902:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802905:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802908:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  80290c:	4c 89 e1             	mov    %r12,%rcx
  80290f:	48 89 da             	mov    %rbx,%rdx
  802912:	44 89 ef             	mov    %r13d,%edi
  802915:	41 ff d6             	call   *%r14
  802918:	85 c0                	test   %eax,%eax
  80291a:	79 37                	jns    802953 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  80291c:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80291f:	75 05                	jne    802926 <ipc_send+0x67>
          sys_yield();
  802921:	41 ff d7             	call   *%r15
  802924:	eb df                	jmp    802905 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802926:	89 c1                	mov    %eax,%ecx
  802928:	48 ba 3f 30 80 00 00 	movabs $0x80303f,%rdx
  80292f:	00 00 00 
  802932:	be 46 00 00 00       	mov    $0x46,%esi
  802937:	48 bf 52 30 80 00 00 	movabs $0x803052,%rdi
  80293e:	00 00 00 
  802941:	b8 00 00 00 00       	mov    $0x0,%eax
  802946:	49 b8 5e 19 80 00 00 	movabs $0x80195e,%r8
  80294d:	00 00 00 
  802950:	41 ff d0             	call   *%r8
      }
}
  802953:	48 83 c4 18          	add    $0x18,%rsp
  802957:	5b                   	pop    %rbx
  802958:	41 5c                	pop    %r12
  80295a:	41 5d                	pop    %r13
  80295c:	41 5e                	pop    %r14
  80295e:	41 5f                	pop    %r15
  802960:	5d                   	pop    %rbp
  802961:	c3                   	ret    

0000000000802962 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802962:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802967:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  80296e:	00 00 00 
  802971:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802975:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802979:	48 c1 e2 04          	shl    $0x4,%rdx
  80297d:	48 01 ca             	add    %rcx,%rdx
  802980:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802986:	39 fa                	cmp    %edi,%edx
  802988:	74 12                	je     80299c <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  80298a:	48 83 c0 01          	add    $0x1,%rax
  80298e:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802994:	75 db                	jne    802971 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802996:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80299b:	c3                   	ret    
            return envs[i].env_id;
  80299c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8029a0:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8029a4:	48 c1 e0 04          	shl    $0x4,%rax
  8029a8:	48 89 c2             	mov    %rax,%rdx
  8029ab:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8029b2:	00 00 00 
  8029b5:	48 01 d0             	add    %rdx,%rax
  8029b8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029be:	c3                   	ret    
  8029bf:	90                   	nop

00000000008029c0 <__rodata_start>:
  8029c0:	3c 75                	cmp    $0x75,%al
  8029c2:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029c3:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8029c7:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029c8:	3e 00 66 0f          	ds add %ah,0xf(%rsi)
  8029cc:	1f                   	(bad)  
  8029cd:	44 00 00             	add    %r8b,(%rax)
  8029d0:	73 79                	jae    802a4b <__rodata_start+0x8b>
  8029d2:	73 63                	jae    802a37 <__rodata_start+0x77>
  8029d4:	61                   	(bad)  
  8029d5:	6c                   	insb   (%dx),%es:(%rdi)
  8029d6:	6c                   	insb   (%dx),%es:(%rdi)
  8029d7:	20 25 7a 64 20 72    	and    %ah,0x7220647a(%rip)        # 72a08e57 <__bss_end+0x72200e57>
  8029dd:	65 74 75             	gs je  802a55 <__rodata_start+0x95>
  8029e0:	72 6e                	jb     802a50 <__rodata_start+0x90>
  8029e2:	65 64 20 25 7a 64 20 	gs and %ah,%fs:0x2820647a(%rip)        # 28a08e64 <__bss_end+0x28200e64>
  8029e9:	28 
  8029ea:	3e 20 30             	ds and %dh,(%rax)
  8029ed:	29 00                	sub    %eax,(%rax)
  8029ef:	6c                   	insb   (%dx),%es:(%rdi)
  8029f0:	69 62 2f 73 79 73 63 	imul   $0x63737973,0x2f(%rdx),%esp
  8029f7:	61                   	(bad)  
  8029f8:	6c                   	insb   (%dx),%es:(%rdi)
  8029f9:	6c                   	insb   (%dx),%es:(%rdi)
  8029fa:	2e 63 00             	cs movsxd (%rax),%eax
  8029fd:	0f 1f 00             	nopl   (%rax)
  802a00:	5b                   	pop    %rbx
  802a01:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a06:	20 75 6e             	and    %dh,0x6e(%rbp)
  802a09:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802a0d:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a0e:	20 64 65 76          	and    %ah,0x76(%rbp,%riz,2)
  802a12:	69 63 65 20 74 79 70 	imul   $0x70797420,0x65(%rbx),%esp
  802a19:	65 20 25 64 0a 00 00 	and    %ah,%gs:0xa64(%rip)        # 803484 <error_string+0x504>
  802a20:	5b                   	pop    %rbx
  802a21:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a26:	20 66 74             	and    %ah,0x74(%rsi)
  802a29:	72 75                	jb     802aa0 <devtab+0x20>
  802a2b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a2c:	63 61 74             	movsxd 0x74(%rcx),%esp
  802a2f:	65 20 25 64 20 2d 2d 	and    %ah,%gs:0x2d2d2064(%rip)        # 2dad4a9a <__bss_end+0x2d2cca9a>
  802a36:	20 62 61             	and    %ah,0x61(%rdx)
  802a39:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a3d:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a41:	5b                   	pop    %rbx
  802a42:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a47:	20 72 65             	and    %dh,0x65(%rdx)
  802a4a:	61                   	(bad)  
  802a4b:	64 20 25 64 20 2d 2d 	and    %ah,%fs:0x2d2d2064(%rip)        # 2dad4ab6 <__bss_end+0x2d2ccab6>
  802a52:	20 62 61             	and    %ah,0x61(%rdx)
  802a55:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a59:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a5d:	5b                   	pop    %rbx
  802a5e:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a63:	20 77 72             	and    %dh,0x72(%rdi)
  802a66:	69 74 65 20 25 64 20 	imul   $0x2d206425,0x20(%rbp,%riz,2),%esi
  802a6d:	2d 
  802a6e:	2d 20 62 61 64       	sub    $0x64616220,%eax
  802a73:	20 6d 6f             	and    %ch,0x6f(%rbp)
  802a76:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a7a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000802a80 <devtab>:
  802a80:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  802a90:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  802aa0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  802ab0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  802ac0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  802ad0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  802ae0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  802af0:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  802b00:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  802b10:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  802b20:	3a 20 00 30 31 32 33 34 35 36 37 38 39 41 42 43     : .0123456789ABC
  802b30:	44 45 46 00 30 31 32 33 34 35 36 37 38 39 61 62     DEF.0123456789ab
  802b40:	63 64 65 66 00 28 6e 75 6c 6c 29 00 65 72 72 6f     cdef.(null).erro
  802b50:	72 20 25 64 00 75 6e 73 70 65 63 69 66 69 65 64     r %d.unspecified
  802b60:	20 65 72 72 6f 72 00 62 61 64 20 65 6e 76 69 72      error.bad envir
  802b70:	6f 6e 6d 65 6e 74 00 69 6e 76 61 6c 69 64 20 70     onment.invalid p
  802b80:	61 72 61 6d 65 74 65 72 00 6f 75 74 20 6f 66 20     arameter.out of 
  802b90:	6d 65 6d 6f 72 79 00 6f 75 74 20 6f 66 20 65 6e     memory.out of en
  802ba0:	76 69 72 6f 6e 6d 65 6e 74 73 00 63 6f 72 72 75     vironments.corru
  802bb0:	70 74 65 64 20 64 65 62 75 67 20 69 6e 66 6f 00     pted debug info.
  802bc0:	73 65 67 6d 65 6e 74 61 74 69 6f 6e 20 66 61 75     segmentation fau
  802bd0:	6c 74 00 69 6e 76 61 6c 69 64 20 45 4c 46 20 69     lt.invalid ELF i
  802be0:	6d 61 67 65 00 6e 6f 20 73 75 63 68 20 73 79 73     mage.no such sys
  802bf0:	74 65 6d 20 63 61 6c 6c 00 65 6e 74 72 79 20 6e     tem call.entry n
  802c00:	6f 74 20 66 6f 75 6e 64 00 65 6e 76 20 69 73 20     ot found.env is 
  802c10:	6e 6f 74 20 72 65 63 76 69 6e 67 00 75 6e 65 78     not recving.unex
  802c20:	70 65 63 74 65 64 20 65 6e 64 20 6f 66 20 66 69     pected end of fi
  802c30:	6c 65 00 6e 6f 20 66 72 65 65 20 73 70 61 63 65     le.no free space
  802c40:	20 6f 6e 20 64 69 73 6b 00 74 6f 6f 20 6d 61 6e      on disk.too man
  802c50:	79 20 66 69 6c 65 73 20 61 72 65 20 6f 70 65 6e     y files are open
  802c60:	00 66 69 6c 65 20 6f 72 20 62 6c 6f 63 6b 20 6e     .file or block n
  802c70:	6f 74 20 66 6f 75 6e 64 00 69 6e 76 61 6c 69 64     ot found.invalid
  802c80:	20 70 61 74 68 00 66 69 6c 65 20 61 6c 72 65 61      path.file alrea
  802c90:	64 79 20 65 78 69 73 74 73 00 6f 70 65 72 61 74     dy exists.operat
  802ca0:	69 6f 6e 20 6e 6f 74 20 73 75 70 70 6f 72 74 65     ion not supporte
  802cb0:	64 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00     d.f...........@.
  802cc0:	a8 1c 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ........."......
  802cd0:	ec 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802ce0:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802cf0:	fc 22 80 00 00 00 00 00 c2 1c 80 00 00 00 00 00     ."..............
  802d00:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802d10:	b9 1c 80 00 00 00 00 00 2f 1d 80 00 00 00 00 00     ......../.......
  802d20:	fc 22 80 00 00 00 00 00 b9 1c 80 00 00 00 00 00     ."..............
  802d30:	fc 1c 80 00 00 00 00 00 fc 1c 80 00 00 00 00 00     ................
  802d40:	fc 1c 80 00 00 00 00 00 fc 1c 80 00 00 00 00 00     ................
  802d50:	fc 1c 80 00 00 00 00 00 fc 1c 80 00 00 00 00 00     ................
  802d60:	fc 1c 80 00 00 00 00 00 fc 1c 80 00 00 00 00 00     ................
  802d70:	fc 1c 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ........."......
  802d80:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802d90:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802da0:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802db0:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802dc0:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802dd0:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802de0:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802df0:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802e00:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802e10:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802e20:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802e30:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802e40:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802e50:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802e60:	fc 22 80 00 00 00 00 00 21 22 80 00 00 00 00 00     ."......!"......
  802e70:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802e80:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802e90:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802ea0:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802eb0:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802ec0:	4d 1d 80 00 00 00 00 00 43 1f 80 00 00 00 00 00     M.......C.......
  802ed0:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802ee0:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802ef0:	7b 1d 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     {........"......
  802f00:	fc 22 80 00 00 00 00 00 42 1d 80 00 00 00 00 00     ."......B.......
  802f10:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802f20:	e3 20 80 00 00 00 00 00 ab 21 80 00 00 00 00 00     . .......!......
  802f30:	fc 22 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ."......."......
  802f40:	13 1e 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     ........."......
  802f50:	15 20 80 00 00 00 00 00 fc 22 80 00 00 00 00 00     . ......."......
  802f60:	fc 22 80 00 00 00 00 00 21 22 80 00 00 00 00 00     ."......!"......
  802f70:	fc 22 80 00 00 00 00 00 b1 1c 80 00 00 00 00 00     ."..............

0000000000802f80 <error_string>:
	...
  802f88:	55 2b 80 00 00 00 00 00 67 2b 80 00 00 00 00 00     U+......g+......
  802f98:	77 2b 80 00 00 00 00 00 89 2b 80 00 00 00 00 00     w+.......+......
  802fa8:	97 2b 80 00 00 00 00 00 ab 2b 80 00 00 00 00 00     .+.......+......
  802fb8:	c0 2b 80 00 00 00 00 00 d3 2b 80 00 00 00 00 00     .+.......+......
  802fc8:	e5 2b 80 00 00 00 00 00 f9 2b 80 00 00 00 00 00     .+.......+......
  802fd8:	09 2c 80 00 00 00 00 00 1c 2c 80 00 00 00 00 00     .,.......,......
  802fe8:	33 2c 80 00 00 00 00 00 49 2c 80 00 00 00 00 00     3,......I,......
  802ff8:	61 2c 80 00 00 00 00 00 79 2c 80 00 00 00 00 00     a,......y,......
  803008:	86 2c 80 00 00 00 00 00 20 30 80 00 00 00 00 00     .,...... 0......
  803018:	9a 2c 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .,......file is 
  803028:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803038:	75 74 61 62 6c 65 00 69 70 63 5f 73 65 6e 64 20     utable.ipc_send 
  803048:	65 72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69 70     error: %i.lib/ip
  803058:	63 2e 63 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     c.c.f.........f.
  803068:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803078:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803088:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803098:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8030a8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8030b8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8030c8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8030d8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8030e8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8030f8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803108:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803118:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803128:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803138:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803148:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803158:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803168:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803178:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803188:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803198:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8031a8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8031b8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8031c8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8031d8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8031e8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8031f8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803208:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803218:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803228:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803238:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803248:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803258:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803268:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803278:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803288:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803298:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8032a8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8032b8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8032c8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8032d8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8032e8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8032f8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803308:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803318:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803328:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803338:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803348:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803358:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803368:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803378:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803388:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803398:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8033a8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8033b8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8033c8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8033d8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8033e8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8033f8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803408:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803418:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803428:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803438:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803448:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803458:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803468:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803478:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803488:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803498:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8034a8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034b8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8034c8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8034d8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034e8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8034f8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803508:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803518:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803528:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803538:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803548:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803558:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803568:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803578:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803588:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803598:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8035a8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035b8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8035c8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035d8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8035e8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8035f8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803608:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803618:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803628:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803638:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803648:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803658:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803668:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803678:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803688:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803698:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8036a8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036b8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8036c8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8036d8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8036e8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8036f8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803708:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803718:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803728:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803738:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803748:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803758:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803768:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803778:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803788:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803798:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8037a8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037b8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8037c8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8037d8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8037e8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8037f8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803808:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803818:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803828:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803838:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803848:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803858:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803868:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803878:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803888:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803898:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8038a8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038b8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8038c8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8038d8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8038e8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8038f8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803908:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803918:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803928:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803938:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803948:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803958:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803968:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803978:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803988:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803998:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8039a8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039b8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8039c8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8039d8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8039e8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8039f8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a08:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a18:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a28:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a38:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a48:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a58:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a68:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a78:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a88:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a98:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803aa8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ab8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ac8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ad8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ae8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803af8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b08:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b18:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b28:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b38:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b48:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b58:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b68:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b78:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b88:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b98:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ba8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803bb8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803bc8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803bd8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803be8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803bf8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c08:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c18:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c28:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c38:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c48:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c58:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c68:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c78:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c88:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c98:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ca8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803cb8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803cc8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803cd8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ce8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803cf8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d08:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d18:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d28:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d38:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d48:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d58:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d68:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d78:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d88:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d98:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803da8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803db8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803dc8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803dd8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803de8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803df8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e08:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e18:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e28:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e38:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e48:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e58:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e68:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e78:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e88:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e98:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ea8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803eb8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ec8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ed8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ee8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ef8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f08:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f18:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f28:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f38:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f48:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f58:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f68:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f78:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f88:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f98:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803fa8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803fb8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803fc8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803fd8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803fe8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ff8:	00 00 00 00 0f 1f 40 00                             ......@.
