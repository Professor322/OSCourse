
obj/user/faultnostack:     file format elf64-x86-64


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
  80001e:	e8 2e 00 00 00       	call   800051 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

void _pgfault_upcall();

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
#ifndef __clang_analyzer__
    sys_env_set_pgfault_upcall(0, (void *)_pgfault_upcall);
  800029:	48 be 10 06 80 00 00 	movabs $0x800610,%rsi
  800030:	00 00 00 
  800033:	bf 00 00 00 00       	mov    $0x0,%edi
  800038:	48 b8 b0 04 80 00 00 	movabs $0x8004b0,%rax
  80003f:	00 00 00 
  800042:	ff d0                	call   *%rax
    *(volatile int *)0 = 0;
  800044:	c7 04 25 00 00 00 00 	movl   $0x0,0x0
  80004b:	00 00 00 00 
#endif
}
  80004f:	5d                   	pop    %rbp
  800050:	c3                   	ret    

0000000000800051 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800051:	55                   	push   %rbp
  800052:	48 89 e5             	mov    %rsp,%rbp
  800055:	41 56                	push   %r14
  800057:	41 55                	push   %r13
  800059:	41 54                	push   %r12
  80005b:	53                   	push   %rbx
  80005c:	41 89 fd             	mov    %edi,%r13d
  80005f:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800062:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800069:	00 00 00 
  80006c:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800073:	00 00 00 
  800076:	48 39 c2             	cmp    %rax,%rdx
  800079:	73 17                	jae    800092 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80007b:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80007e:	49 89 c4             	mov    %rax,%r12
  800081:	48 83 c3 08          	add    $0x8,%rbx
  800085:	b8 00 00 00 00       	mov    $0x0,%eax
  80008a:	ff 53 f8             	call   *-0x8(%rbx)
  80008d:	4c 39 e3             	cmp    %r12,%rbx
  800090:	72 ef                	jb     800081 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800092:	48 b8 eb 01 80 00 00 	movabs $0x8001eb,%rax
  800099:	00 00 00 
  80009c:	ff d0                	call   *%rax
  80009e:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a3:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000a7:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000ab:	48 c1 e0 04          	shl    $0x4,%rax
  8000af:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000b6:	00 00 00 
  8000b9:	48 01 d0             	add    %rdx,%rax
  8000bc:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000c3:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000c6:	45 85 ed             	test   %r13d,%r13d
  8000c9:	7e 0d                	jle    8000d8 <libmain+0x87>
  8000cb:	49 8b 06             	mov    (%r14),%rax
  8000ce:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000d5:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000d8:	4c 89 f6             	mov    %r14,%rsi
  8000db:	44 89 ef             	mov    %r13d,%edi
  8000de:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000ea:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	call   *%rax
#endif
}
  8000f6:	5b                   	pop    %rbx
  8000f7:	41 5c                	pop    %r12
  8000f9:	41 5d                	pop    %r13
  8000fb:	41 5e                	pop    %r14
  8000fd:	5d                   	pop    %rbp
  8000fe:	c3                   	ret    

00000000008000ff <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000ff:	55                   	push   %rbp
  800100:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800103:	48 b8 86 08 80 00 00 	movabs $0x800886,%rax
  80010a:	00 00 00 
  80010d:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80010f:	bf 00 00 00 00       	mov    $0x0,%edi
  800114:	48 b8 80 01 80 00 00 	movabs $0x800180,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	call   *%rax
}
  800120:	5d                   	pop    %rbp
  800121:	c3                   	ret    

0000000000800122 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800122:	55                   	push   %rbp
  800123:	48 89 e5             	mov    %rsp,%rbp
  800126:	53                   	push   %rbx
  800127:	48 89 fa             	mov    %rdi,%rdx
  80012a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80012d:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800132:	bb 00 00 00 00       	mov    $0x0,%ebx
  800137:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80013c:	be 00 00 00 00       	mov    $0x0,%esi
  800141:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800147:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800149:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80014d:	c9                   	leave  
  80014e:	c3                   	ret    

000000000080014f <sys_cgetc>:

int
sys_cgetc(void) {
  80014f:	55                   	push   %rbp
  800150:	48 89 e5             	mov    %rsp,%rbp
  800153:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800154:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800159:	ba 00 00 00 00       	mov    $0x0,%edx
  80015e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800163:	bb 00 00 00 00       	mov    $0x0,%ebx
  800168:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80016d:	be 00 00 00 00       	mov    $0x0,%esi
  800172:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800178:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80017a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80017e:	c9                   	leave  
  80017f:	c3                   	ret    

0000000000800180 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800180:	55                   	push   %rbp
  800181:	48 89 e5             	mov    %rsp,%rbp
  800184:	53                   	push   %rbx
  800185:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800189:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80018c:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800191:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800196:	bb 00 00 00 00       	mov    $0x0,%ebx
  80019b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001a0:	be 00 00 00 00       	mov    $0x0,%esi
  8001a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001ab:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001ad:	48 85 c0             	test   %rax,%rax
  8001b0:	7f 06                	jg     8001b8 <sys_env_destroy+0x38>
}
  8001b2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001b6:	c9                   	leave  
  8001b7:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001b8:	49 89 c0             	mov    %rax,%r8
  8001bb:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001c0:	48 ba d8 2c 80 00 00 	movabs $0x802cd8,%rdx
  8001c7:	00 00 00 
  8001ca:	be 26 00 00 00       	mov    $0x26,%esi
  8001cf:	48 bf f7 2c 80 00 00 	movabs $0x802cf7,%rdi
  8001d6:	00 00 00 
  8001d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001de:	49 b9 b9 19 80 00 00 	movabs $0x8019b9,%r9
  8001e5:	00 00 00 
  8001e8:	41 ff d1             	call   *%r9

00000000008001eb <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001eb:	55                   	push   %rbp
  8001ec:	48 89 e5             	mov    %rsp,%rbp
  8001ef:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001f0:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001fa:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800204:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800209:	be 00 00 00 00       	mov    $0x0,%esi
  80020e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800214:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800216:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80021a:	c9                   	leave  
  80021b:	c3                   	ret    

000000000080021c <sys_yield>:

void
sys_yield(void) {
  80021c:	55                   	push   %rbp
  80021d:	48 89 e5             	mov    %rsp,%rbp
  800220:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800221:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800226:	ba 00 00 00 00       	mov    $0x0,%edx
  80022b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800230:	bb 00 00 00 00       	mov    $0x0,%ebx
  800235:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80023a:	be 00 00 00 00       	mov    $0x0,%esi
  80023f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800245:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800247:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

000000000080024d <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80024d:	55                   	push   %rbp
  80024e:	48 89 e5             	mov    %rsp,%rbp
  800251:	53                   	push   %rbx
  800252:	48 89 fa             	mov    %rdi,%rdx
  800255:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800258:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80025d:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800264:	00 00 00 
  800267:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80026c:	be 00 00 00 00       	mov    $0x0,%esi
  800271:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800277:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800279:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

000000000080027f <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80027f:	55                   	push   %rbp
  800280:	48 89 e5             	mov    %rsp,%rbp
  800283:	53                   	push   %rbx
  800284:	49 89 f8             	mov    %rdi,%r8
  800287:	48 89 d3             	mov    %rdx,%rbx
  80028a:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80028d:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800292:	4c 89 c2             	mov    %r8,%rdx
  800295:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800298:	be 00 00 00 00       	mov    $0x0,%esi
  80029d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002a3:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002a5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002a9:	c9                   	leave  
  8002aa:	c3                   	ret    

00000000008002ab <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002ab:	55                   	push   %rbp
  8002ac:	48 89 e5             	mov    %rsp,%rbp
  8002af:	53                   	push   %rbx
  8002b0:	48 83 ec 08          	sub    $0x8,%rsp
  8002b4:	89 f8                	mov    %edi,%eax
  8002b6:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002b9:	48 63 f9             	movslq %ecx,%rdi
  8002bc:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002bf:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002c4:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002c7:	be 00 00 00 00       	mov    $0x0,%esi
  8002cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002d2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002d4:	48 85 c0             	test   %rax,%rax
  8002d7:	7f 06                	jg     8002df <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002d9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002dd:	c9                   	leave  
  8002de:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002df:	49 89 c0             	mov    %rax,%r8
  8002e2:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002e7:	48 ba d8 2c 80 00 00 	movabs $0x802cd8,%rdx
  8002ee:	00 00 00 
  8002f1:	be 26 00 00 00       	mov    $0x26,%esi
  8002f6:	48 bf f7 2c 80 00 00 	movabs $0x802cf7,%rdi
  8002fd:	00 00 00 
  800300:	b8 00 00 00 00       	mov    $0x0,%eax
  800305:	49 b9 b9 19 80 00 00 	movabs $0x8019b9,%r9
  80030c:	00 00 00 
  80030f:	41 ff d1             	call   *%r9

0000000000800312 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  800312:	55                   	push   %rbp
  800313:	48 89 e5             	mov    %rsp,%rbp
  800316:	53                   	push   %rbx
  800317:	48 83 ec 08          	sub    $0x8,%rsp
  80031b:	89 f8                	mov    %edi,%eax
  80031d:	49 89 f2             	mov    %rsi,%r10
  800320:	48 89 cf             	mov    %rcx,%rdi
  800323:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800326:	48 63 da             	movslq %edx,%rbx
  800329:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80032c:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800331:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800334:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800337:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800339:	48 85 c0             	test   %rax,%rax
  80033c:	7f 06                	jg     800344 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80033e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800342:	c9                   	leave  
  800343:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800344:	49 89 c0             	mov    %rax,%r8
  800347:	b9 05 00 00 00       	mov    $0x5,%ecx
  80034c:	48 ba d8 2c 80 00 00 	movabs $0x802cd8,%rdx
  800353:	00 00 00 
  800356:	be 26 00 00 00       	mov    $0x26,%esi
  80035b:	48 bf f7 2c 80 00 00 	movabs $0x802cf7,%rdi
  800362:	00 00 00 
  800365:	b8 00 00 00 00       	mov    $0x0,%eax
  80036a:	49 b9 b9 19 80 00 00 	movabs $0x8019b9,%r9
  800371:	00 00 00 
  800374:	41 ff d1             	call   *%r9

0000000000800377 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  800377:	55                   	push   %rbp
  800378:	48 89 e5             	mov    %rsp,%rbp
  80037b:	53                   	push   %rbx
  80037c:	48 83 ec 08          	sub    $0x8,%rsp
  800380:	48 89 f1             	mov    %rsi,%rcx
  800383:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  800386:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800389:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80038e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800393:	be 00 00 00 00       	mov    $0x0,%esi
  800398:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80039e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003a0:	48 85 c0             	test   %rax,%rax
  8003a3:	7f 06                	jg     8003ab <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8003a5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003a9:	c9                   	leave  
  8003aa:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003ab:	49 89 c0             	mov    %rax,%r8
  8003ae:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003b3:	48 ba d8 2c 80 00 00 	movabs $0x802cd8,%rdx
  8003ba:	00 00 00 
  8003bd:	be 26 00 00 00       	mov    $0x26,%esi
  8003c2:	48 bf f7 2c 80 00 00 	movabs $0x802cf7,%rdi
  8003c9:	00 00 00 
  8003cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d1:	49 b9 b9 19 80 00 00 	movabs $0x8019b9,%r9
  8003d8:	00 00 00 
  8003db:	41 ff d1             	call   *%r9

00000000008003de <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8003de:	55                   	push   %rbp
  8003df:	48 89 e5             	mov    %rsp,%rbp
  8003e2:	53                   	push   %rbx
  8003e3:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8003e7:	48 63 ce             	movslq %esi,%rcx
  8003ea:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8003ed:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8003f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003f7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003fc:	be 00 00 00 00       	mov    $0x0,%esi
  800401:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800407:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800409:	48 85 c0             	test   %rax,%rax
  80040c:	7f 06                	jg     800414 <sys_env_set_status+0x36>
}
  80040e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800412:	c9                   	leave  
  800413:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800414:	49 89 c0             	mov    %rax,%r8
  800417:	b9 09 00 00 00       	mov    $0x9,%ecx
  80041c:	48 ba d8 2c 80 00 00 	movabs $0x802cd8,%rdx
  800423:	00 00 00 
  800426:	be 26 00 00 00       	mov    $0x26,%esi
  80042b:	48 bf f7 2c 80 00 00 	movabs $0x802cf7,%rdi
  800432:	00 00 00 
  800435:	b8 00 00 00 00       	mov    $0x0,%eax
  80043a:	49 b9 b9 19 80 00 00 	movabs $0x8019b9,%r9
  800441:	00 00 00 
  800444:	41 ff d1             	call   *%r9

0000000000800447 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  800447:	55                   	push   %rbp
  800448:	48 89 e5             	mov    %rsp,%rbp
  80044b:	53                   	push   %rbx
  80044c:	48 83 ec 08          	sub    $0x8,%rsp
  800450:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  800453:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800456:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80045b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800460:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800465:	be 00 00 00 00       	mov    $0x0,%esi
  80046a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800470:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800472:	48 85 c0             	test   %rax,%rax
  800475:	7f 06                	jg     80047d <sys_env_set_trapframe+0x36>
}
  800477:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80047d:	49 89 c0             	mov    %rax,%r8
  800480:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800485:	48 ba d8 2c 80 00 00 	movabs $0x802cd8,%rdx
  80048c:	00 00 00 
  80048f:	be 26 00 00 00       	mov    $0x26,%esi
  800494:	48 bf f7 2c 80 00 00 	movabs $0x802cf7,%rdi
  80049b:	00 00 00 
  80049e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a3:	49 b9 b9 19 80 00 00 	movabs $0x8019b9,%r9
  8004aa:	00 00 00 
  8004ad:	41 ff d1             	call   *%r9

00000000008004b0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8004b0:	55                   	push   %rbp
  8004b1:	48 89 e5             	mov    %rsp,%rbp
  8004b4:	53                   	push   %rbx
  8004b5:	48 83 ec 08          	sub    $0x8,%rsp
  8004b9:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8004bc:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004bf:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004c9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004ce:	be 00 00 00 00       	mov    $0x0,%esi
  8004d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004d9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004db:	48 85 c0             	test   %rax,%rax
  8004de:	7f 06                	jg     8004e6 <sys_env_set_pgfault_upcall+0x36>
}
  8004e0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004e4:	c9                   	leave  
  8004e5:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004e6:	49 89 c0             	mov    %rax,%r8
  8004e9:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8004ee:	48 ba d8 2c 80 00 00 	movabs $0x802cd8,%rdx
  8004f5:	00 00 00 
  8004f8:	be 26 00 00 00       	mov    $0x26,%esi
  8004fd:	48 bf f7 2c 80 00 00 	movabs $0x802cf7,%rdi
  800504:	00 00 00 
  800507:	b8 00 00 00 00       	mov    $0x0,%eax
  80050c:	49 b9 b9 19 80 00 00 	movabs $0x8019b9,%r9
  800513:	00 00 00 
  800516:	41 ff d1             	call   *%r9

0000000000800519 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  800519:	55                   	push   %rbp
  80051a:	48 89 e5             	mov    %rsp,%rbp
  80051d:	53                   	push   %rbx
  80051e:	89 f8                	mov    %edi,%eax
  800520:	49 89 f1             	mov    %rsi,%r9
  800523:	48 89 d3             	mov    %rdx,%rbx
  800526:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  800529:	49 63 f0             	movslq %r8d,%rsi
  80052c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80052f:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800534:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800537:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80053d:	cd 30                	int    $0x30
}
  80053f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800543:	c9                   	leave  
  800544:	c3                   	ret    

0000000000800545 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  800545:	55                   	push   %rbp
  800546:	48 89 e5             	mov    %rsp,%rbp
  800549:	53                   	push   %rbx
  80054a:	48 83 ec 08          	sub    $0x8,%rsp
  80054e:	48 89 fa             	mov    %rdi,%rdx
  800551:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800554:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800559:	bb 00 00 00 00       	mov    $0x0,%ebx
  80055e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800563:	be 00 00 00 00       	mov    $0x0,%esi
  800568:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80056e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800570:	48 85 c0             	test   %rax,%rax
  800573:	7f 06                	jg     80057b <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800575:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800579:	c9                   	leave  
  80057a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80057b:	49 89 c0             	mov    %rax,%r8
  80057e:	b9 0e 00 00 00       	mov    $0xe,%ecx
  800583:	48 ba d8 2c 80 00 00 	movabs $0x802cd8,%rdx
  80058a:	00 00 00 
  80058d:	be 26 00 00 00       	mov    $0x26,%esi
  800592:	48 bf f7 2c 80 00 00 	movabs $0x802cf7,%rdi
  800599:	00 00 00 
  80059c:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a1:	49 b9 b9 19 80 00 00 	movabs $0x8019b9,%r9
  8005a8:	00 00 00 
  8005ab:	41 ff d1             	call   *%r9

00000000008005ae <sys_gettime>:

int
sys_gettime(void) {
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005b3:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bd:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005c7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005cc:	be 00 00 00 00       	mov    $0x0,%esi
  8005d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005d7:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8005d9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

00000000008005df <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8005df:	55                   	push   %rbp
  8005e0:	48 89 e5             	mov    %rsp,%rbp
  8005e3:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005e4:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ee:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005fd:	be 00 00 00 00       	mov    $0x0,%esi
  800602:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800608:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  80060a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80060e:	c9                   	leave  
  80060f:	c3                   	ret    

0000000000800610 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  800610:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  800613:	48 b8 7b 28 80 00 00 	movabs $0x80287b,%rax
  80061a:	00 00 00 
    call *%rax
  80061d:	ff d0                	call   *%rax
    # LAB 9: Your code here
    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (POPA).
    # LAB 9: Your code here
    #skip utf_fault_va
    popq %r15
  80061f:	41 5f                	pop    %r15
    #skip utf_err
    popq %r15
  800621:	41 5f                	pop    %r15
    #popping registers
    popq %r15
  800623:	41 5f                	pop    %r15
    popq %r14
  800625:	41 5e                	pop    %r14
    popq %r13
  800627:	41 5d                	pop    %r13
    popq %r12
  800629:	41 5c                	pop    %r12
    popq %r11
  80062b:	41 5b                	pop    %r11
    popq %r10
  80062d:	41 5a                	pop    %r10
    popq %r9
  80062f:	41 59                	pop    %r9
    popq %r8
  800631:	41 58                	pop    %r8
    popq %rsi
  800633:	5e                   	pop    %rsi
    popq %rdi
  800634:	5f                   	pop    %rdi
    popq %rbp
  800635:	5d                   	pop    %rbp
    popq %rdx
  800636:	5a                   	pop    %rdx
    popq %rcx
  800637:	59                   	pop    %rcx
    
    #loading rbx with utf_rsp 
    movq 32(%rsp), %rbx
  800638:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
    #loading rax with reg_rax
    movq 16(%rsp), %rax
  80063d:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    #one words allocated behind utf_rsp
    subq $8, %rbx
  800642:	48 83 eb 08          	sub    $0x8,%rbx
    #moving the value reg_rax just behind utf_rsp
    movq %rax, (%rbx)
  800646:	48 89 03             	mov    %rax,(%rbx)
    #new value of utf_rsp
    movq %rbx, 32(%rsp)
  800649:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)

    popq %rbx
  80064e:	5b                   	pop    %rbx
    popq %rax
  80064f:	58                   	pop    %rax
    # modifies rflags.
    # LAB 9: Your code here

    #rsp is looking at reg_rax right now
    #skip utf_rip to look at utf_rfalgs
    pushq 8(%rsp)
  800650:	ff 74 24 08          	push   0x8(%rsp)
    
    #setting RFLAGS with the value of utf_rflags
    popfq
  800654:	9d                   	popf   

    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
    movq 16(%rsp), %rsp
  800655:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    # Return to re-execute the instruction that faulted.
    ret
  80065a:	c3                   	ret    

000000000080065b <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80065b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800662:	ff ff ff 
  800665:	48 01 f8             	add    %rdi,%rax
  800668:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80066c:	c3                   	ret    

000000000080066d <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80066d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800674:	ff ff ff 
  800677:	48 01 f8             	add    %rdi,%rax
  80067a:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80067e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800684:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800688:	c3                   	ret    

0000000000800689 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  800689:	55                   	push   %rbp
  80068a:	48 89 e5             	mov    %rsp,%rbp
  80068d:	41 57                	push   %r15
  80068f:	41 56                	push   %r14
  800691:	41 55                	push   %r13
  800693:	41 54                	push   %r12
  800695:	53                   	push   %rbx
  800696:	48 83 ec 08          	sub    $0x8,%rsp
  80069a:	49 89 ff             	mov    %rdi,%r15
  80069d:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8006a2:	49 bc 37 16 80 00 00 	movabs $0x801637,%r12
  8006a9:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8006ac:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8006b2:	48 89 df             	mov    %rbx,%rdi
  8006b5:	41 ff d4             	call   *%r12
  8006b8:	83 e0 04             	and    $0x4,%eax
  8006bb:	74 1a                	je     8006d7 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8006bd:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8006c4:	4c 39 f3             	cmp    %r14,%rbx
  8006c7:	75 e9                	jne    8006b2 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8006c9:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8006d0:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8006d5:	eb 03                	jmp    8006da <fd_alloc+0x51>
            *fd_store = fd;
  8006d7:	49 89 1f             	mov    %rbx,(%r15)
}
  8006da:	48 83 c4 08          	add    $0x8,%rsp
  8006de:	5b                   	pop    %rbx
  8006df:	41 5c                	pop    %r12
  8006e1:	41 5d                	pop    %r13
  8006e3:	41 5e                	pop    %r14
  8006e5:	41 5f                	pop    %r15
  8006e7:	5d                   	pop    %rbp
  8006e8:	c3                   	ret    

00000000008006e9 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8006e9:	83 ff 1f             	cmp    $0x1f,%edi
  8006ec:	77 39                	ja     800727 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8006ee:	55                   	push   %rbp
  8006ef:	48 89 e5             	mov    %rsp,%rbp
  8006f2:	41 54                	push   %r12
  8006f4:	53                   	push   %rbx
  8006f5:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8006f8:	48 63 df             	movslq %edi,%rbx
  8006fb:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  800702:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800706:	48 89 df             	mov    %rbx,%rdi
  800709:	48 b8 37 16 80 00 00 	movabs $0x801637,%rax
  800710:	00 00 00 
  800713:	ff d0                	call   *%rax
  800715:	a8 04                	test   $0x4,%al
  800717:	74 14                	je     80072d <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  800719:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80071d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800722:	5b                   	pop    %rbx
  800723:	41 5c                	pop    %r12
  800725:	5d                   	pop    %rbp
  800726:	c3                   	ret    
        return -E_INVAL;
  800727:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80072c:	c3                   	ret    
        return -E_INVAL;
  80072d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800732:	eb ee                	jmp    800722 <fd_lookup+0x39>

0000000000800734 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  800734:	55                   	push   %rbp
  800735:	48 89 e5             	mov    %rsp,%rbp
  800738:	53                   	push   %rbx
  800739:	48 83 ec 08          	sub    $0x8,%rsp
  80073d:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  800740:	48 ba a0 2d 80 00 00 	movabs $0x802da0,%rdx
  800747:	00 00 00 
  80074a:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  800751:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800754:	39 38                	cmp    %edi,(%rax)
  800756:	74 4b                	je     8007a3 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  800758:	48 83 c2 08          	add    $0x8,%rdx
  80075c:	48 8b 02             	mov    (%rdx),%rax
  80075f:	48 85 c0             	test   %rax,%rax
  800762:	75 f0                	jne    800754 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800764:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80076b:	00 00 00 
  80076e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800774:	89 fa                	mov    %edi,%edx
  800776:	48 bf 08 2d 80 00 00 	movabs $0x802d08,%rdi
  80077d:	00 00 00 
  800780:	b8 00 00 00 00       	mov    $0x0,%eax
  800785:	48 b9 09 1b 80 00 00 	movabs $0x801b09,%rcx
  80078c:	00 00 00 
  80078f:	ff d1                	call   *%rcx
    *dev = 0;
  800791:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  800798:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80079d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8007a1:	c9                   	leave  
  8007a2:	c3                   	ret    
            *dev = devtab[i];
  8007a3:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	eb f0                	jmp    80079d <dev_lookup+0x69>

00000000008007ad <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8007ad:	55                   	push   %rbp
  8007ae:	48 89 e5             	mov    %rsp,%rbp
  8007b1:	41 55                	push   %r13
  8007b3:	41 54                	push   %r12
  8007b5:	53                   	push   %rbx
  8007b6:	48 83 ec 18          	sub    $0x18,%rsp
  8007ba:	49 89 fc             	mov    %rdi,%r12
  8007bd:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8007c0:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8007c7:	ff ff ff 
  8007ca:	4c 01 e7             	add    %r12,%rdi
  8007cd:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8007d1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8007d5:	48 b8 e9 06 80 00 00 	movabs $0x8006e9,%rax
  8007dc:	00 00 00 
  8007df:	ff d0                	call   *%rax
  8007e1:	89 c3                	mov    %eax,%ebx
  8007e3:	85 c0                	test   %eax,%eax
  8007e5:	78 06                	js     8007ed <fd_close+0x40>
  8007e7:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8007eb:	74 18                	je     800805 <fd_close+0x58>
        return (must_exist ? res : 0);
  8007ed:	45 84 ed             	test   %r13b,%r13b
  8007f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f5:	0f 44 d8             	cmove  %eax,%ebx
}
  8007f8:	89 d8                	mov    %ebx,%eax
  8007fa:	48 83 c4 18          	add    $0x18,%rsp
  8007fe:	5b                   	pop    %rbx
  8007ff:	41 5c                	pop    %r12
  800801:	41 5d                	pop    %r13
  800803:	5d                   	pop    %rbp
  800804:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800805:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800809:	41 8b 3c 24          	mov    (%r12),%edi
  80080d:	48 b8 34 07 80 00 00 	movabs $0x800734,%rax
  800814:	00 00 00 
  800817:	ff d0                	call   *%rax
  800819:	89 c3                	mov    %eax,%ebx
  80081b:	85 c0                	test   %eax,%eax
  80081d:	78 19                	js     800838 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80081f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800823:	48 8b 40 20          	mov    0x20(%rax),%rax
  800827:	bb 00 00 00 00       	mov    $0x0,%ebx
  80082c:	48 85 c0             	test   %rax,%rax
  80082f:	74 07                	je     800838 <fd_close+0x8b>
  800831:	4c 89 e7             	mov    %r12,%rdi
  800834:	ff d0                	call   *%rax
  800836:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  800838:	ba 00 10 00 00       	mov    $0x1000,%edx
  80083d:	4c 89 e6             	mov    %r12,%rsi
  800840:	bf 00 00 00 00       	mov    $0x0,%edi
  800845:	48 b8 77 03 80 00 00 	movabs $0x800377,%rax
  80084c:	00 00 00 
  80084f:	ff d0                	call   *%rax
    return res;
  800851:	eb a5                	jmp    8007f8 <fd_close+0x4b>

0000000000800853 <close>:

int
close(int fdnum) {
  800853:	55                   	push   %rbp
  800854:	48 89 e5             	mov    %rsp,%rbp
  800857:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80085b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80085f:	48 b8 e9 06 80 00 00 	movabs $0x8006e9,%rax
  800866:	00 00 00 
  800869:	ff d0                	call   *%rax
    if (res < 0) return res;
  80086b:	85 c0                	test   %eax,%eax
  80086d:	78 15                	js     800884 <close+0x31>

    return fd_close(fd, 1);
  80086f:	be 01 00 00 00       	mov    $0x1,%esi
  800874:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800878:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  80087f:	00 00 00 
  800882:	ff d0                	call   *%rax
}
  800884:	c9                   	leave  
  800885:	c3                   	ret    

0000000000800886 <close_all>:

void
close_all(void) {
  800886:	55                   	push   %rbp
  800887:	48 89 e5             	mov    %rsp,%rbp
  80088a:	41 54                	push   %r12
  80088c:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80088d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800892:	49 bc 53 08 80 00 00 	movabs $0x800853,%r12
  800899:	00 00 00 
  80089c:	89 df                	mov    %ebx,%edi
  80089e:	41 ff d4             	call   *%r12
  8008a1:	83 c3 01             	add    $0x1,%ebx
  8008a4:	83 fb 20             	cmp    $0x20,%ebx
  8008a7:	75 f3                	jne    80089c <close_all+0x16>
}
  8008a9:	5b                   	pop    %rbx
  8008aa:	41 5c                	pop    %r12
  8008ac:	5d                   	pop    %rbp
  8008ad:	c3                   	ret    

00000000008008ae <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8008ae:	55                   	push   %rbp
  8008af:	48 89 e5             	mov    %rsp,%rbp
  8008b2:	41 56                	push   %r14
  8008b4:	41 55                	push   %r13
  8008b6:	41 54                	push   %r12
  8008b8:	53                   	push   %rbx
  8008b9:	48 83 ec 10          	sub    $0x10,%rsp
  8008bd:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8008c0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8008c4:	48 b8 e9 06 80 00 00 	movabs $0x8006e9,%rax
  8008cb:	00 00 00 
  8008ce:	ff d0                	call   *%rax
  8008d0:	89 c3                	mov    %eax,%ebx
  8008d2:	85 c0                	test   %eax,%eax
  8008d4:	0f 88 b7 00 00 00    	js     800991 <dup+0xe3>
    close(newfdnum);
  8008da:	44 89 e7             	mov    %r12d,%edi
  8008dd:	48 b8 53 08 80 00 00 	movabs $0x800853,%rax
  8008e4:	00 00 00 
  8008e7:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8008e9:	4d 63 ec             	movslq %r12d,%r13
  8008ec:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8008f3:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8008f7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8008fb:	49 be 6d 06 80 00 00 	movabs $0x80066d,%r14
  800902:	00 00 00 
  800905:	41 ff d6             	call   *%r14
  800908:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  80090b:	4c 89 ef             	mov    %r13,%rdi
  80090e:	41 ff d6             	call   *%r14
  800911:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  800914:	48 89 df             	mov    %rbx,%rdi
  800917:	48 b8 37 16 80 00 00 	movabs $0x801637,%rax
  80091e:	00 00 00 
  800921:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  800923:	a8 04                	test   $0x4,%al
  800925:	74 2b                	je     800952 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  800927:	41 89 c1             	mov    %eax,%r9d
  80092a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800930:	4c 89 f1             	mov    %r14,%rcx
  800933:	ba 00 00 00 00       	mov    $0x0,%edx
  800938:	48 89 de             	mov    %rbx,%rsi
  80093b:	bf 00 00 00 00       	mov    $0x0,%edi
  800940:	48 b8 12 03 80 00 00 	movabs $0x800312,%rax
  800947:	00 00 00 
  80094a:	ff d0                	call   *%rax
  80094c:	89 c3                	mov    %eax,%ebx
  80094e:	85 c0                	test   %eax,%eax
  800950:	78 4e                	js     8009a0 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  800952:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800956:	48 b8 37 16 80 00 00 	movabs $0x801637,%rax
  80095d:	00 00 00 
  800960:	ff d0                	call   *%rax
  800962:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  800965:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80096b:	4c 89 e9             	mov    %r13,%rcx
  80096e:	ba 00 00 00 00       	mov    $0x0,%edx
  800973:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800977:	bf 00 00 00 00       	mov    $0x0,%edi
  80097c:	48 b8 12 03 80 00 00 	movabs $0x800312,%rax
  800983:	00 00 00 
  800986:	ff d0                	call   *%rax
  800988:	89 c3                	mov    %eax,%ebx
  80098a:	85 c0                	test   %eax,%eax
  80098c:	78 12                	js     8009a0 <dup+0xf2>

    return newfdnum;
  80098e:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  800991:	89 d8                	mov    %ebx,%eax
  800993:	48 83 c4 10          	add    $0x10,%rsp
  800997:	5b                   	pop    %rbx
  800998:	41 5c                	pop    %r12
  80099a:	41 5d                	pop    %r13
  80099c:	41 5e                	pop    %r14
  80099e:	5d                   	pop    %rbp
  80099f:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8009a0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009a5:	4c 89 ee             	mov    %r13,%rsi
  8009a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8009ad:	49 bc 77 03 80 00 00 	movabs $0x800377,%r12
  8009b4:	00 00 00 
  8009b7:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8009ba:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009bf:	4c 89 f6             	mov    %r14,%rsi
  8009c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8009c7:	41 ff d4             	call   *%r12
    return res;
  8009ca:	eb c5                	jmp    800991 <dup+0xe3>

00000000008009cc <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8009cc:	55                   	push   %rbp
  8009cd:	48 89 e5             	mov    %rsp,%rbp
  8009d0:	41 55                	push   %r13
  8009d2:	41 54                	push   %r12
  8009d4:	53                   	push   %rbx
  8009d5:	48 83 ec 18          	sub    $0x18,%rsp
  8009d9:	89 fb                	mov    %edi,%ebx
  8009db:	49 89 f4             	mov    %rsi,%r12
  8009de:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8009e1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8009e5:	48 b8 e9 06 80 00 00 	movabs $0x8006e9,%rax
  8009ec:	00 00 00 
  8009ef:	ff d0                	call   *%rax
  8009f1:	85 c0                	test   %eax,%eax
  8009f3:	78 49                	js     800a3e <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8009f5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8009f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009fd:	8b 38                	mov    (%rax),%edi
  8009ff:	48 b8 34 07 80 00 00 	movabs $0x800734,%rax
  800a06:	00 00 00 
  800a09:	ff d0                	call   *%rax
  800a0b:	85 c0                	test   %eax,%eax
  800a0d:	78 33                	js     800a42 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a0f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800a13:	8b 47 08             	mov    0x8(%rdi),%eax
  800a16:	83 e0 03             	and    $0x3,%eax
  800a19:	83 f8 01             	cmp    $0x1,%eax
  800a1c:	74 28                	je     800a46 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800a1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a22:	48 8b 40 10          	mov    0x10(%rax),%rax
  800a26:	48 85 c0             	test   %rax,%rax
  800a29:	74 51                	je     800a7c <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  800a2b:	4c 89 ea             	mov    %r13,%rdx
  800a2e:	4c 89 e6             	mov    %r12,%rsi
  800a31:	ff d0                	call   *%rax
}
  800a33:	48 83 c4 18          	add    $0x18,%rsp
  800a37:	5b                   	pop    %rbx
  800a38:	41 5c                	pop    %r12
  800a3a:	41 5d                	pop    %r13
  800a3c:	5d                   	pop    %rbp
  800a3d:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a3e:	48 98                	cltq   
  800a40:	eb f1                	jmp    800a33 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a42:	48 98                	cltq   
  800a44:	eb ed                	jmp    800a33 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800a46:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800a4d:	00 00 00 
  800a50:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800a56:	89 da                	mov    %ebx,%edx
  800a58:	48 bf 49 2d 80 00 00 	movabs $0x802d49,%rdi
  800a5f:	00 00 00 
  800a62:	b8 00 00 00 00       	mov    $0x0,%eax
  800a67:	48 b9 09 1b 80 00 00 	movabs $0x801b09,%rcx
  800a6e:	00 00 00 
  800a71:	ff d1                	call   *%rcx
        return -E_INVAL;
  800a73:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800a7a:	eb b7                	jmp    800a33 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800a7c:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800a83:	eb ae                	jmp    800a33 <read+0x67>

0000000000800a85 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800a85:	55                   	push   %rbp
  800a86:	48 89 e5             	mov    %rsp,%rbp
  800a89:	41 57                	push   %r15
  800a8b:	41 56                	push   %r14
  800a8d:	41 55                	push   %r13
  800a8f:	41 54                	push   %r12
  800a91:	53                   	push   %rbx
  800a92:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800a96:	48 85 d2             	test   %rdx,%rdx
  800a99:	74 54                	je     800aef <readn+0x6a>
  800a9b:	41 89 fd             	mov    %edi,%r13d
  800a9e:	49 89 f6             	mov    %rsi,%r14
  800aa1:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800aa4:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800aa9:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800aae:	49 bf cc 09 80 00 00 	movabs $0x8009cc,%r15
  800ab5:	00 00 00 
  800ab8:	4c 89 e2             	mov    %r12,%rdx
  800abb:	48 29 f2             	sub    %rsi,%rdx
  800abe:	4c 01 f6             	add    %r14,%rsi
  800ac1:	44 89 ef             	mov    %r13d,%edi
  800ac4:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800ac7:	85 c0                	test   %eax,%eax
  800ac9:	78 20                	js     800aeb <readn+0x66>
    for (; inc && res < n; res += inc) {
  800acb:	01 c3                	add    %eax,%ebx
  800acd:	85 c0                	test   %eax,%eax
  800acf:	74 08                	je     800ad9 <readn+0x54>
  800ad1:	48 63 f3             	movslq %ebx,%rsi
  800ad4:	4c 39 e6             	cmp    %r12,%rsi
  800ad7:	72 df                	jb     800ab8 <readn+0x33>
    }
    return res;
  800ad9:	48 63 c3             	movslq %ebx,%rax
}
  800adc:	48 83 c4 08          	add    $0x8,%rsp
  800ae0:	5b                   	pop    %rbx
  800ae1:	41 5c                	pop    %r12
  800ae3:	41 5d                	pop    %r13
  800ae5:	41 5e                	pop    %r14
  800ae7:	41 5f                	pop    %r15
  800ae9:	5d                   	pop    %rbp
  800aea:	c3                   	ret    
        if (inc < 0) return inc;
  800aeb:	48 98                	cltq   
  800aed:	eb ed                	jmp    800adc <readn+0x57>
    int inc = 1, res = 0;
  800aef:	bb 00 00 00 00       	mov    $0x0,%ebx
  800af4:	eb e3                	jmp    800ad9 <readn+0x54>

0000000000800af6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800af6:	55                   	push   %rbp
  800af7:	48 89 e5             	mov    %rsp,%rbp
  800afa:	41 55                	push   %r13
  800afc:	41 54                	push   %r12
  800afe:	53                   	push   %rbx
  800aff:	48 83 ec 18          	sub    $0x18,%rsp
  800b03:	89 fb                	mov    %edi,%ebx
  800b05:	49 89 f4             	mov    %rsi,%r12
  800b08:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b0b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800b0f:	48 b8 e9 06 80 00 00 	movabs $0x8006e9,%rax
  800b16:	00 00 00 
  800b19:	ff d0                	call   *%rax
  800b1b:	85 c0                	test   %eax,%eax
  800b1d:	78 44                	js     800b63 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b1f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800b23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b27:	8b 38                	mov    (%rax),%edi
  800b29:	48 b8 34 07 80 00 00 	movabs $0x800734,%rax
  800b30:	00 00 00 
  800b33:	ff d0                	call   *%rax
  800b35:	85 c0                	test   %eax,%eax
  800b37:	78 2e                	js     800b67 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b39:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800b3d:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800b41:	74 28                	je     800b6b <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800b43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b47:	48 8b 40 18          	mov    0x18(%rax),%rax
  800b4b:	48 85 c0             	test   %rax,%rax
  800b4e:	74 51                	je     800ba1 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  800b50:	4c 89 ea             	mov    %r13,%rdx
  800b53:	4c 89 e6             	mov    %r12,%rsi
  800b56:	ff d0                	call   *%rax
}
  800b58:	48 83 c4 18          	add    $0x18,%rsp
  800b5c:	5b                   	pop    %rbx
  800b5d:	41 5c                	pop    %r12
  800b5f:	41 5d                	pop    %r13
  800b61:	5d                   	pop    %rbp
  800b62:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b63:	48 98                	cltq   
  800b65:	eb f1                	jmp    800b58 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b67:	48 98                	cltq   
  800b69:	eb ed                	jmp    800b58 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b6b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800b72:	00 00 00 
  800b75:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800b7b:	89 da                	mov    %ebx,%edx
  800b7d:	48 bf 65 2d 80 00 00 	movabs $0x802d65,%rdi
  800b84:	00 00 00 
  800b87:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8c:	48 b9 09 1b 80 00 00 	movabs $0x801b09,%rcx
  800b93:	00 00 00 
  800b96:	ff d1                	call   *%rcx
        return -E_INVAL;
  800b98:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800b9f:	eb b7                	jmp    800b58 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800ba1:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800ba8:	eb ae                	jmp    800b58 <write+0x62>

0000000000800baa <seek>:

int
seek(int fdnum, off_t offset) {
  800baa:	55                   	push   %rbp
  800bab:	48 89 e5             	mov    %rsp,%rbp
  800bae:	53                   	push   %rbx
  800baf:	48 83 ec 18          	sub    $0x18,%rsp
  800bb3:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800bb5:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800bb9:	48 b8 e9 06 80 00 00 	movabs $0x8006e9,%rax
  800bc0:	00 00 00 
  800bc3:	ff d0                	call   *%rax
  800bc5:	85 c0                	test   %eax,%eax
  800bc7:	78 0c                	js     800bd5 <seek+0x2b>

    fd->fd_offset = offset;
  800bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bcd:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800bd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

0000000000800bdb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800bdb:	55                   	push   %rbp
  800bdc:	48 89 e5             	mov    %rsp,%rbp
  800bdf:	41 54                	push   %r12
  800be1:	53                   	push   %rbx
  800be2:	48 83 ec 10          	sub    $0x10,%rsp
  800be6:	89 fb                	mov    %edi,%ebx
  800be8:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800beb:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800bef:	48 b8 e9 06 80 00 00 	movabs $0x8006e9,%rax
  800bf6:	00 00 00 
  800bf9:	ff d0                	call   *%rax
  800bfb:	85 c0                	test   %eax,%eax
  800bfd:	78 36                	js     800c35 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bff:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c07:	8b 38                	mov    (%rax),%edi
  800c09:	48 b8 34 07 80 00 00 	movabs $0x800734,%rax
  800c10:	00 00 00 
  800c13:	ff d0                	call   *%rax
  800c15:	85 c0                	test   %eax,%eax
  800c17:	78 1c                	js     800c35 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c19:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c1d:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800c21:	74 1b                	je     800c3e <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c27:	48 8b 40 30          	mov    0x30(%rax),%rax
  800c2b:	48 85 c0             	test   %rax,%rax
  800c2e:	74 42                	je     800c72 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  800c30:	44 89 e6             	mov    %r12d,%esi
  800c33:	ff d0                	call   *%rax
}
  800c35:	48 83 c4 10          	add    $0x10,%rsp
  800c39:	5b                   	pop    %rbx
  800c3a:	41 5c                	pop    %r12
  800c3c:	5d                   	pop    %rbp
  800c3d:	c3                   	ret    
                thisenv->env_id, fdnum);
  800c3e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800c45:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c48:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800c4e:	89 da                	mov    %ebx,%edx
  800c50:	48 bf 28 2d 80 00 00 	movabs $0x802d28,%rdi
  800c57:	00 00 00 
  800c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5f:	48 b9 09 1b 80 00 00 	movabs $0x801b09,%rcx
  800c66:	00 00 00 
  800c69:	ff d1                	call   *%rcx
        return -E_INVAL;
  800c6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c70:	eb c3                	jmp    800c35 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c72:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c77:	eb bc                	jmp    800c35 <ftruncate+0x5a>

0000000000800c79 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800c79:	55                   	push   %rbp
  800c7a:	48 89 e5             	mov    %rsp,%rbp
  800c7d:	53                   	push   %rbx
  800c7e:	48 83 ec 18          	sub    $0x18,%rsp
  800c82:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c85:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c89:	48 b8 e9 06 80 00 00 	movabs $0x8006e9,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	call   *%rax
  800c95:	85 c0                	test   %eax,%eax
  800c97:	78 4d                	js     800ce6 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c99:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800c9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca1:	8b 38                	mov    (%rax),%edi
  800ca3:	48 b8 34 07 80 00 00 	movabs $0x800734,%rax
  800caa:	00 00 00 
  800cad:	ff d0                	call   *%rax
  800caf:	85 c0                	test   %eax,%eax
  800cb1:	78 33                	js     800ce6 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800cb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800cb7:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800cbc:	74 2e                	je     800cec <fstat+0x73>

    stat->st_name[0] = 0;
  800cbe:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800cc1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800cc8:	00 00 00 
    stat->st_isdir = 0;
  800ccb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800cd2:	00 00 00 
    stat->st_dev = dev;
  800cd5:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800cdc:	48 89 de             	mov    %rbx,%rsi
  800cdf:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800ce3:	ff 50 28             	call   *0x28(%rax)
}
  800ce6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800cea:	c9                   	leave  
  800ceb:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800cec:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800cf1:	eb f3                	jmp    800ce6 <fstat+0x6d>

0000000000800cf3 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800cf3:	55                   	push   %rbp
  800cf4:	48 89 e5             	mov    %rsp,%rbp
  800cf7:	41 54                	push   %r12
  800cf9:	53                   	push   %rbx
  800cfa:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800cfd:	be 00 00 00 00       	mov    $0x0,%esi
  800d02:	48 b8 be 0f 80 00 00 	movabs $0x800fbe,%rax
  800d09:	00 00 00 
  800d0c:	ff d0                	call   *%rax
  800d0e:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800d10:	85 c0                	test   %eax,%eax
  800d12:	78 25                	js     800d39 <stat+0x46>

    int res = fstat(fd, stat);
  800d14:	4c 89 e6             	mov    %r12,%rsi
  800d17:	89 c7                	mov    %eax,%edi
  800d19:	48 b8 79 0c 80 00 00 	movabs $0x800c79,%rax
  800d20:	00 00 00 
  800d23:	ff d0                	call   *%rax
  800d25:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800d28:	89 df                	mov    %ebx,%edi
  800d2a:	48 b8 53 08 80 00 00 	movabs $0x800853,%rax
  800d31:	00 00 00 
  800d34:	ff d0                	call   *%rax

    return res;
  800d36:	44 89 e3             	mov    %r12d,%ebx
}
  800d39:	89 d8                	mov    %ebx,%eax
  800d3b:	5b                   	pop    %rbx
  800d3c:	41 5c                	pop    %r12
  800d3e:	5d                   	pop    %rbp
  800d3f:	c3                   	ret    

0000000000800d40 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800d40:	55                   	push   %rbp
  800d41:	48 89 e5             	mov    %rsp,%rbp
  800d44:	41 54                	push   %r12
  800d46:	53                   	push   %rbx
  800d47:	48 83 ec 10          	sub    $0x10,%rsp
  800d4b:	41 89 fc             	mov    %edi,%r12d
  800d4e:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800d51:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d58:	00 00 00 
  800d5b:	83 38 00             	cmpl   $0x0,(%rax)
  800d5e:	74 5e                	je     800dbe <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800d60:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800d66:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800d6b:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800d72:	00 00 00 
  800d75:	44 89 e6             	mov    %r12d,%esi
  800d78:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d7f:	00 00 00 
  800d82:	8b 38                	mov    (%rax),%edi
  800d84:	48 b8 c3 2b 80 00 00 	movabs $0x802bc3,%rax
  800d8b:	00 00 00 
  800d8e:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800d90:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800d97:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800d98:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d9d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800da1:	48 89 de             	mov    %rbx,%rsi
  800da4:	bf 00 00 00 00       	mov    $0x0,%edi
  800da9:	48 b8 24 2b 80 00 00 	movabs $0x802b24,%rax
  800db0:	00 00 00 
  800db3:	ff d0                	call   *%rax
}
  800db5:	48 83 c4 10          	add    $0x10,%rsp
  800db9:	5b                   	pop    %rbx
  800dba:	41 5c                	pop    %r12
  800dbc:	5d                   	pop    %rbp
  800dbd:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800dbe:	bf 03 00 00 00       	mov    $0x3,%edi
  800dc3:	48 b8 66 2c 80 00 00 	movabs $0x802c66,%rax
  800dca:	00 00 00 
  800dcd:	ff d0                	call   *%rax
  800dcf:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800dd6:	00 00 
  800dd8:	eb 86                	jmp    800d60 <fsipc+0x20>

0000000000800dda <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800dda:	55                   	push   %rbp
  800ddb:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800dde:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800de5:	00 00 00 
  800de8:	8b 57 0c             	mov    0xc(%rdi),%edx
  800deb:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800ded:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800df0:	be 00 00 00 00       	mov    $0x0,%esi
  800df5:	bf 02 00 00 00       	mov    $0x2,%edi
  800dfa:	48 b8 40 0d 80 00 00 	movabs $0x800d40,%rax
  800e01:	00 00 00 
  800e04:	ff d0                	call   *%rax
}
  800e06:	5d                   	pop    %rbp
  800e07:	c3                   	ret    

0000000000800e08 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800e08:	55                   	push   %rbp
  800e09:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800e0c:	8b 47 0c             	mov    0xc(%rdi),%eax
  800e0f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800e16:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800e18:	be 00 00 00 00       	mov    $0x0,%esi
  800e1d:	bf 06 00 00 00       	mov    $0x6,%edi
  800e22:	48 b8 40 0d 80 00 00 	movabs $0x800d40,%rax
  800e29:	00 00 00 
  800e2c:	ff d0                	call   *%rax
}
  800e2e:	5d                   	pop    %rbp
  800e2f:	c3                   	ret    

0000000000800e30 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800e30:	55                   	push   %rbp
  800e31:	48 89 e5             	mov    %rsp,%rbp
  800e34:	53                   	push   %rbx
  800e35:	48 83 ec 08          	sub    $0x8,%rsp
  800e39:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800e3c:	8b 47 0c             	mov    0xc(%rdi),%eax
  800e3f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800e46:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800e48:	be 00 00 00 00       	mov    $0x0,%esi
  800e4d:	bf 05 00 00 00       	mov    $0x5,%edi
  800e52:	48 b8 40 0d 80 00 00 	movabs $0x800d40,%rax
  800e59:	00 00 00 
  800e5c:	ff d0                	call   *%rax
    if (res < 0) return res;
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	78 40                	js     800ea2 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800e62:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800e69:	00 00 00 
  800e6c:	48 89 df             	mov    %rbx,%rdi
  800e6f:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  800e76:	00 00 00 
  800e79:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800e7b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e82:	00 00 00 
  800e85:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  800e8b:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e91:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  800e97:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800e9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800ea6:	c9                   	leave  
  800ea7:	c3                   	ret    

0000000000800ea8 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800ea8:	55                   	push   %rbp
  800ea9:	48 89 e5             	mov    %rsp,%rbp
  800eac:	41 57                	push   %r15
  800eae:	41 56                	push   %r14
  800eb0:	41 55                	push   %r13
  800eb2:	41 54                	push   %r12
  800eb4:	53                   	push   %rbx
  800eb5:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  800eb9:	48 85 d2             	test   %rdx,%rdx
  800ebc:	0f 84 91 00 00 00    	je     800f53 <devfile_write+0xab>
  800ec2:	49 89 ff             	mov    %rdi,%r15
  800ec5:	49 89 f4             	mov    %rsi,%r12
  800ec8:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  800ecb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800ed2:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  800ed9:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  800edc:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  800ee3:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  800ee9:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  800eed:	4c 89 ea             	mov    %r13,%rdx
  800ef0:	4c 89 e6             	mov    %r12,%rsi
  800ef3:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  800efa:	00 00 00 
  800efd:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  800f04:	00 00 00 
  800f07:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800f09:	41 8b 47 0c          	mov    0xc(%r15),%eax
  800f0d:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  800f10:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  800f14:	be 00 00 00 00       	mov    $0x0,%esi
  800f19:	bf 04 00 00 00       	mov    $0x4,%edi
  800f1e:	48 b8 40 0d 80 00 00 	movabs $0x800d40,%rax
  800f25:	00 00 00 
  800f28:	ff d0                	call   *%rax
        if (res < 0)
  800f2a:	85 c0                	test   %eax,%eax
  800f2c:	78 21                	js     800f4f <devfile_write+0xa7>
        buf += res;
  800f2e:	48 63 d0             	movslq %eax,%rdx
  800f31:	49 01 d4             	add    %rdx,%r12
        ext += res;
  800f34:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  800f37:	48 29 d3             	sub    %rdx,%rbx
  800f3a:	75 a0                	jne    800edc <devfile_write+0x34>
    return ext;
  800f3c:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  800f40:	48 83 c4 18          	add    $0x18,%rsp
  800f44:	5b                   	pop    %rbx
  800f45:	41 5c                	pop    %r12
  800f47:	41 5d                	pop    %r13
  800f49:	41 5e                	pop    %r14
  800f4b:	41 5f                	pop    %r15
  800f4d:	5d                   	pop    %rbp
  800f4e:	c3                   	ret    
            return res;
  800f4f:	48 98                	cltq   
  800f51:	eb ed                	jmp    800f40 <devfile_write+0x98>
    int ext = 0;
  800f53:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  800f5a:	eb e0                	jmp    800f3c <devfile_write+0x94>

0000000000800f5c <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800f5c:	55                   	push   %rbp
  800f5d:	48 89 e5             	mov    %rsp,%rbp
  800f60:	41 54                	push   %r12
  800f62:	53                   	push   %rbx
  800f63:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800f66:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f6d:	00 00 00 
  800f70:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f73:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  800f75:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  800f79:	be 00 00 00 00       	mov    $0x0,%esi
  800f7e:	bf 03 00 00 00       	mov    $0x3,%edi
  800f83:	48 b8 40 0d 80 00 00 	movabs $0x800d40,%rax
  800f8a:	00 00 00 
  800f8d:	ff d0                	call   *%rax
    if (read < 0) 
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	78 27                	js     800fba <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  800f93:	48 63 d8             	movslq %eax,%rbx
  800f96:	48 89 da             	mov    %rbx,%rdx
  800f99:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800fa0:	00 00 00 
  800fa3:	4c 89 e7             	mov    %r12,%rdi
  800fa6:	48 b8 45 26 80 00 00 	movabs $0x802645,%rax
  800fad:	00 00 00 
  800fb0:	ff d0                	call   *%rax
    return read;
  800fb2:	48 89 d8             	mov    %rbx,%rax
}
  800fb5:	5b                   	pop    %rbx
  800fb6:	41 5c                	pop    %r12
  800fb8:	5d                   	pop    %rbp
  800fb9:	c3                   	ret    
		return read;
  800fba:	48 98                	cltq   
  800fbc:	eb f7                	jmp    800fb5 <devfile_read+0x59>

0000000000800fbe <open>:
open(const char *path, int mode) {
  800fbe:	55                   	push   %rbp
  800fbf:	48 89 e5             	mov    %rsp,%rbp
  800fc2:	41 55                	push   %r13
  800fc4:	41 54                	push   %r12
  800fc6:	53                   	push   %rbx
  800fc7:	48 83 ec 18          	sub    $0x18,%rsp
  800fcb:	49 89 fc             	mov    %rdi,%r12
  800fce:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  800fd1:	48 b8 11 24 80 00 00 	movabs $0x802411,%rax
  800fd8:	00 00 00 
  800fdb:	ff d0                	call   *%rax
  800fdd:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  800fe3:	0f 87 8c 00 00 00    	ja     801075 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  800fe9:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  800fed:	48 b8 89 06 80 00 00 	movabs $0x800689,%rax
  800ff4:	00 00 00 
  800ff7:	ff d0                	call   *%rax
  800ff9:	89 c3                	mov    %eax,%ebx
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	78 52                	js     801051 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  800fff:	4c 89 e6             	mov    %r12,%rsi
  801002:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  801009:	00 00 00 
  80100c:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  801013:	00 00 00 
  801016:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801018:	44 89 e8             	mov    %r13d,%eax
  80101b:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  801022:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801024:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801028:	bf 01 00 00 00       	mov    $0x1,%edi
  80102d:	48 b8 40 0d 80 00 00 	movabs $0x800d40,%rax
  801034:	00 00 00 
  801037:	ff d0                	call   *%rax
  801039:	89 c3                	mov    %eax,%ebx
  80103b:	85 c0                	test   %eax,%eax
  80103d:	78 1f                	js     80105e <open+0xa0>
    return fd2num(fd);
  80103f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801043:	48 b8 5b 06 80 00 00 	movabs $0x80065b,%rax
  80104a:	00 00 00 
  80104d:	ff d0                	call   *%rax
  80104f:	89 c3                	mov    %eax,%ebx
}
  801051:	89 d8                	mov    %ebx,%eax
  801053:	48 83 c4 18          	add    $0x18,%rsp
  801057:	5b                   	pop    %rbx
  801058:	41 5c                	pop    %r12
  80105a:	41 5d                	pop    %r13
  80105c:	5d                   	pop    %rbp
  80105d:	c3                   	ret    
        fd_close(fd, 0);
  80105e:	be 00 00 00 00       	mov    $0x0,%esi
  801063:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801067:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  80106e:	00 00 00 
  801071:	ff d0                	call   *%rax
        return res;
  801073:	eb dc                	jmp    801051 <open+0x93>
        return -E_BAD_PATH;
  801075:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80107a:	eb d5                	jmp    801051 <open+0x93>

000000000080107c <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80107c:	55                   	push   %rbp
  80107d:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801080:	be 00 00 00 00       	mov    $0x0,%esi
  801085:	bf 08 00 00 00       	mov    $0x8,%edi
  80108a:	48 b8 40 0d 80 00 00 	movabs $0x800d40,%rax
  801091:	00 00 00 
  801094:	ff d0                	call   *%rax
}
  801096:	5d                   	pop    %rbp
  801097:	c3                   	ret    

0000000000801098 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801098:	55                   	push   %rbp
  801099:	48 89 e5             	mov    %rsp,%rbp
  80109c:	41 54                	push   %r12
  80109e:	53                   	push   %rbx
  80109f:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8010a2:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  8010a9:	00 00 00 
  8010ac:	ff d0                	call   *%rax
  8010ae:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8010b1:	48 be c0 2d 80 00 00 	movabs $0x802dc0,%rsi
  8010b8:	00 00 00 
  8010bb:	48 89 df             	mov    %rbx,%rdi
  8010be:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  8010c5:	00 00 00 
  8010c8:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8010ca:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8010cf:	41 2b 04 24          	sub    (%r12),%eax
  8010d3:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8010d9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8010e0:	00 00 00 
    stat->st_dev = &devpipe;
  8010e3:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8010ea:	00 00 00 
  8010ed:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8010f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f9:	5b                   	pop    %rbx
  8010fa:	41 5c                	pop    %r12
  8010fc:	5d                   	pop    %rbp
  8010fd:	c3                   	ret    

00000000008010fe <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8010fe:	55                   	push   %rbp
  8010ff:	48 89 e5             	mov    %rsp,%rbp
  801102:	41 54                	push   %r12
  801104:	53                   	push   %rbx
  801105:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801108:	ba 00 10 00 00       	mov    $0x1000,%edx
  80110d:	48 89 fe             	mov    %rdi,%rsi
  801110:	bf 00 00 00 00       	mov    $0x0,%edi
  801115:	49 bc 77 03 80 00 00 	movabs $0x800377,%r12
  80111c:	00 00 00 
  80111f:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  801122:	48 89 df             	mov    %rbx,%rdi
  801125:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  80112c:	00 00 00 
  80112f:	ff d0                	call   *%rax
  801131:	48 89 c6             	mov    %rax,%rsi
  801134:	ba 00 10 00 00       	mov    $0x1000,%edx
  801139:	bf 00 00 00 00       	mov    $0x0,%edi
  80113e:	41 ff d4             	call   *%r12
}
  801141:	5b                   	pop    %rbx
  801142:	41 5c                	pop    %r12
  801144:	5d                   	pop    %rbp
  801145:	c3                   	ret    

0000000000801146 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  801146:	55                   	push   %rbp
  801147:	48 89 e5             	mov    %rsp,%rbp
  80114a:	41 57                	push   %r15
  80114c:	41 56                	push   %r14
  80114e:	41 55                	push   %r13
  801150:	41 54                	push   %r12
  801152:	53                   	push   %rbx
  801153:	48 83 ec 18          	sub    $0x18,%rsp
  801157:	49 89 fc             	mov    %rdi,%r12
  80115a:	49 89 f5             	mov    %rsi,%r13
  80115d:	49 89 d7             	mov    %rdx,%r15
  801160:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801164:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  80116b:	00 00 00 
  80116e:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801170:	4d 85 ff             	test   %r15,%r15
  801173:	0f 84 ac 00 00 00    	je     801225 <devpipe_write+0xdf>
  801179:	48 89 c3             	mov    %rax,%rbx
  80117c:	4c 89 f8             	mov    %r15,%rax
  80117f:	4d 89 ef             	mov    %r13,%r15
  801182:	49 01 c5             	add    %rax,%r13
  801185:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801189:	49 bd 7f 02 80 00 00 	movabs $0x80027f,%r13
  801190:	00 00 00 
            sys_yield();
  801193:	49 be 1c 02 80 00 00 	movabs $0x80021c,%r14
  80119a:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80119d:	8b 73 04             	mov    0x4(%rbx),%esi
  8011a0:	48 63 ce             	movslq %esi,%rcx
  8011a3:	48 63 03             	movslq (%rbx),%rax
  8011a6:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8011ac:	48 39 c1             	cmp    %rax,%rcx
  8011af:	72 2e                	jb     8011df <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8011b1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8011b6:	48 89 da             	mov    %rbx,%rdx
  8011b9:	be 00 10 00 00       	mov    $0x1000,%esi
  8011be:	4c 89 e7             	mov    %r12,%rdi
  8011c1:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8011c4:	85 c0                	test   %eax,%eax
  8011c6:	74 63                	je     80122b <devpipe_write+0xe5>
            sys_yield();
  8011c8:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8011cb:	8b 73 04             	mov    0x4(%rbx),%esi
  8011ce:	48 63 ce             	movslq %esi,%rcx
  8011d1:	48 63 03             	movslq (%rbx),%rax
  8011d4:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8011da:	48 39 c1             	cmp    %rax,%rcx
  8011dd:	73 d2                	jae    8011b1 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8011df:	41 0f b6 3f          	movzbl (%r15),%edi
  8011e3:	48 89 ca             	mov    %rcx,%rdx
  8011e6:	48 c1 ea 03          	shr    $0x3,%rdx
  8011ea:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8011f1:	08 10 20 
  8011f4:	48 f7 e2             	mul    %rdx
  8011f7:	48 c1 ea 06          	shr    $0x6,%rdx
  8011fb:	48 89 d0             	mov    %rdx,%rax
  8011fe:	48 c1 e0 09          	shl    $0x9,%rax
  801202:	48 29 d0             	sub    %rdx,%rax
  801205:	48 c1 e0 03          	shl    $0x3,%rax
  801209:	48 29 c1             	sub    %rax,%rcx
  80120c:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  801211:	83 c6 01             	add    $0x1,%esi
  801214:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  801217:	49 83 c7 01          	add    $0x1,%r15
  80121b:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  80121f:	0f 85 78 ff ff ff    	jne    80119d <devpipe_write+0x57>
    return n;
  801225:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801229:	eb 05                	jmp    801230 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  80122b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801230:	48 83 c4 18          	add    $0x18,%rsp
  801234:	5b                   	pop    %rbx
  801235:	41 5c                	pop    %r12
  801237:	41 5d                	pop    %r13
  801239:	41 5e                	pop    %r14
  80123b:	41 5f                	pop    %r15
  80123d:	5d                   	pop    %rbp
  80123e:	c3                   	ret    

000000000080123f <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80123f:	55                   	push   %rbp
  801240:	48 89 e5             	mov    %rsp,%rbp
  801243:	41 57                	push   %r15
  801245:	41 56                	push   %r14
  801247:	41 55                	push   %r13
  801249:	41 54                	push   %r12
  80124b:	53                   	push   %rbx
  80124c:	48 83 ec 18          	sub    $0x18,%rsp
  801250:	49 89 fc             	mov    %rdi,%r12
  801253:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801257:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80125b:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  801262:	00 00 00 
  801265:	ff d0                	call   *%rax
  801267:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80126a:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801270:	49 bd 7f 02 80 00 00 	movabs $0x80027f,%r13
  801277:	00 00 00 
            sys_yield();
  80127a:	49 be 1c 02 80 00 00 	movabs $0x80021c,%r14
  801281:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801284:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801289:	74 7a                	je     801305 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80128b:	8b 03                	mov    (%rbx),%eax
  80128d:	3b 43 04             	cmp    0x4(%rbx),%eax
  801290:	75 26                	jne    8012b8 <devpipe_read+0x79>
            if (i > 0) return i;
  801292:	4d 85 ff             	test   %r15,%r15
  801295:	75 74                	jne    80130b <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801297:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80129c:	48 89 da             	mov    %rbx,%rdx
  80129f:	be 00 10 00 00       	mov    $0x1000,%esi
  8012a4:	4c 89 e7             	mov    %r12,%rdi
  8012a7:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	74 6f                	je     80131d <devpipe_read+0xde>
            sys_yield();
  8012ae:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8012b1:	8b 03                	mov    (%rbx),%eax
  8012b3:	3b 43 04             	cmp    0x4(%rbx),%eax
  8012b6:	74 df                	je     801297 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8012b8:	48 63 c8             	movslq %eax,%rcx
  8012bb:	48 89 ca             	mov    %rcx,%rdx
  8012be:	48 c1 ea 03          	shr    $0x3,%rdx
  8012c2:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8012c9:	08 10 20 
  8012cc:	48 f7 e2             	mul    %rdx
  8012cf:	48 c1 ea 06          	shr    $0x6,%rdx
  8012d3:	48 89 d0             	mov    %rdx,%rax
  8012d6:	48 c1 e0 09          	shl    $0x9,%rax
  8012da:	48 29 d0             	sub    %rdx,%rax
  8012dd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8012e4:	00 
  8012e5:	48 89 c8             	mov    %rcx,%rax
  8012e8:	48 29 d0             	sub    %rdx,%rax
  8012eb:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8012f0:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8012f4:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8012f8:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012fb:	49 83 c7 01          	add    $0x1,%r15
  8012ff:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  801303:	75 86                	jne    80128b <devpipe_read+0x4c>
    return n;
  801305:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801309:	eb 03                	jmp    80130e <devpipe_read+0xcf>
            if (i > 0) return i;
  80130b:	4c 89 f8             	mov    %r15,%rax
}
  80130e:	48 83 c4 18          	add    $0x18,%rsp
  801312:	5b                   	pop    %rbx
  801313:	41 5c                	pop    %r12
  801315:	41 5d                	pop    %r13
  801317:	41 5e                	pop    %r14
  801319:	41 5f                	pop    %r15
  80131b:	5d                   	pop    %rbp
  80131c:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  80131d:	b8 00 00 00 00       	mov    $0x0,%eax
  801322:	eb ea                	jmp    80130e <devpipe_read+0xcf>

0000000000801324 <pipe>:
pipe(int pfd[2]) {
  801324:	55                   	push   %rbp
  801325:	48 89 e5             	mov    %rsp,%rbp
  801328:	41 55                	push   %r13
  80132a:	41 54                	push   %r12
  80132c:	53                   	push   %rbx
  80132d:	48 83 ec 18          	sub    $0x18,%rsp
  801331:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  801334:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801338:	48 b8 89 06 80 00 00 	movabs $0x800689,%rax
  80133f:	00 00 00 
  801342:	ff d0                	call   *%rax
  801344:	89 c3                	mov    %eax,%ebx
  801346:	85 c0                	test   %eax,%eax
  801348:	0f 88 a0 01 00 00    	js     8014ee <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80134e:	b9 46 00 00 00       	mov    $0x46,%ecx
  801353:	ba 00 10 00 00       	mov    $0x1000,%edx
  801358:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80135c:	bf 00 00 00 00       	mov    $0x0,%edi
  801361:	48 b8 ab 02 80 00 00 	movabs $0x8002ab,%rax
  801368:	00 00 00 
  80136b:	ff d0                	call   *%rax
  80136d:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80136f:	85 c0                	test   %eax,%eax
  801371:	0f 88 77 01 00 00    	js     8014ee <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801377:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80137b:	48 b8 89 06 80 00 00 	movabs $0x800689,%rax
  801382:	00 00 00 
  801385:	ff d0                	call   *%rax
  801387:	89 c3                	mov    %eax,%ebx
  801389:	85 c0                	test   %eax,%eax
  80138b:	0f 88 43 01 00 00    	js     8014d4 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  801391:	b9 46 00 00 00       	mov    $0x46,%ecx
  801396:	ba 00 10 00 00       	mov    $0x1000,%edx
  80139b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80139f:	bf 00 00 00 00       	mov    $0x0,%edi
  8013a4:	48 b8 ab 02 80 00 00 	movabs $0x8002ab,%rax
  8013ab:	00 00 00 
  8013ae:	ff d0                	call   *%rax
  8013b0:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	0f 88 1a 01 00 00    	js     8014d4 <pipe+0x1b0>
    va = fd2data(fd0);
  8013ba:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8013be:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  8013c5:	00 00 00 
  8013c8:	ff d0                	call   *%rax
  8013ca:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8013cd:	b9 46 00 00 00       	mov    $0x46,%ecx
  8013d2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8013d7:	48 89 c6             	mov    %rax,%rsi
  8013da:	bf 00 00 00 00       	mov    $0x0,%edi
  8013df:	48 b8 ab 02 80 00 00 	movabs $0x8002ab,%rax
  8013e6:	00 00 00 
  8013e9:	ff d0                	call   *%rax
  8013eb:	89 c3                	mov    %eax,%ebx
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	0f 88 c5 00 00 00    	js     8014ba <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8013f5:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8013f9:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  801400:	00 00 00 
  801403:	ff d0                	call   *%rax
  801405:	48 89 c1             	mov    %rax,%rcx
  801408:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80140e:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801414:	ba 00 00 00 00       	mov    $0x0,%edx
  801419:	4c 89 ee             	mov    %r13,%rsi
  80141c:	bf 00 00 00 00       	mov    $0x0,%edi
  801421:	48 b8 12 03 80 00 00 	movabs $0x800312,%rax
  801428:	00 00 00 
  80142b:	ff d0                	call   *%rax
  80142d:	89 c3                	mov    %eax,%ebx
  80142f:	85 c0                	test   %eax,%eax
  801431:	78 6e                	js     8014a1 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  801433:	be 00 10 00 00       	mov    $0x1000,%esi
  801438:	4c 89 ef             	mov    %r13,%rdi
  80143b:	48 b8 4d 02 80 00 00 	movabs $0x80024d,%rax
  801442:	00 00 00 
  801445:	ff d0                	call   *%rax
  801447:	83 f8 02             	cmp    $0x2,%eax
  80144a:	0f 85 ab 00 00 00    	jne    8014fb <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  801450:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  801457:	00 00 
  801459:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80145d:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80145f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801463:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80146a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80146e:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801470:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801474:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80147b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80147f:	48 bb 5b 06 80 00 00 	movabs $0x80065b,%rbx
  801486:	00 00 00 
  801489:	ff d3                	call   *%rbx
  80148b:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80148f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801493:	ff d3                	call   *%rbx
  801495:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80149a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80149f:	eb 4d                	jmp    8014ee <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8014a1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8014a6:	4c 89 ee             	mov    %r13,%rsi
  8014a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8014ae:	48 b8 77 03 80 00 00 	movabs $0x800377,%rax
  8014b5:	00 00 00 
  8014b8:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8014ba:	ba 00 10 00 00       	mov    $0x1000,%edx
  8014bf:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8014c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8014c8:	48 b8 77 03 80 00 00 	movabs $0x800377,%rax
  8014cf:	00 00 00 
  8014d2:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8014d4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8014d9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8014dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8014e2:	48 b8 77 03 80 00 00 	movabs $0x800377,%rax
  8014e9:	00 00 00 
  8014ec:	ff d0                	call   *%rax
}
  8014ee:	89 d8                	mov    %ebx,%eax
  8014f0:	48 83 c4 18          	add    $0x18,%rsp
  8014f4:	5b                   	pop    %rbx
  8014f5:	41 5c                	pop    %r12
  8014f7:	41 5d                	pop    %r13
  8014f9:	5d                   	pop    %rbp
  8014fa:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014fb:	48 b9 f0 2d 80 00 00 	movabs $0x802df0,%rcx
  801502:	00 00 00 
  801505:	48 ba c7 2d 80 00 00 	movabs $0x802dc7,%rdx
  80150c:	00 00 00 
  80150f:	be 2e 00 00 00       	mov    $0x2e,%esi
  801514:	48 bf dc 2d 80 00 00 	movabs $0x802ddc,%rdi
  80151b:	00 00 00 
  80151e:	b8 00 00 00 00       	mov    $0x0,%eax
  801523:	49 b8 b9 19 80 00 00 	movabs $0x8019b9,%r8
  80152a:	00 00 00 
  80152d:	41 ff d0             	call   *%r8

0000000000801530 <pipeisclosed>:
pipeisclosed(int fdnum) {
  801530:	55                   	push   %rbp
  801531:	48 89 e5             	mov    %rsp,%rbp
  801534:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801538:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80153c:	48 b8 e9 06 80 00 00 	movabs $0x8006e9,%rax
  801543:	00 00 00 
  801546:	ff d0                	call   *%rax
    if (res < 0) return res;
  801548:	85 c0                	test   %eax,%eax
  80154a:	78 35                	js     801581 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80154c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801550:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  801557:	00 00 00 
  80155a:	ff d0                	call   *%rax
  80155c:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80155f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801564:	be 00 10 00 00       	mov    $0x1000,%esi
  801569:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80156d:	48 b8 7f 02 80 00 00 	movabs $0x80027f,%rax
  801574:	00 00 00 
  801577:	ff d0                	call   *%rax
  801579:	85 c0                	test   %eax,%eax
  80157b:	0f 94 c0             	sete   %al
  80157e:	0f b6 c0             	movzbl %al,%eax
}
  801581:	c9                   	leave  
  801582:	c3                   	ret    

0000000000801583 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801583:	48 89 f8             	mov    %rdi,%rax
  801586:	48 c1 e8 27          	shr    $0x27,%rax
  80158a:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  801591:	01 00 00 
  801594:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801598:	f6 c2 01             	test   $0x1,%dl
  80159b:	74 6d                	je     80160a <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80159d:	48 89 f8             	mov    %rdi,%rax
  8015a0:	48 c1 e8 1e          	shr    $0x1e,%rax
  8015a4:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8015ab:	01 00 00 
  8015ae:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8015b2:	f6 c2 01             	test   $0x1,%dl
  8015b5:	74 62                	je     801619 <get_uvpt_entry+0x96>
  8015b7:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8015be:	01 00 00 
  8015c1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8015c5:	f6 c2 80             	test   $0x80,%dl
  8015c8:	75 4f                	jne    801619 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8015ca:	48 89 f8             	mov    %rdi,%rax
  8015cd:	48 c1 e8 15          	shr    $0x15,%rax
  8015d1:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8015d8:	01 00 00 
  8015db:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8015df:	f6 c2 01             	test   $0x1,%dl
  8015e2:	74 44                	je     801628 <get_uvpt_entry+0xa5>
  8015e4:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8015eb:	01 00 00 
  8015ee:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8015f2:	f6 c2 80             	test   $0x80,%dl
  8015f5:	75 31                	jne    801628 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8015f7:	48 c1 ef 0c          	shr    $0xc,%rdi
  8015fb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801602:	01 00 00 
  801605:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  801609:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80160a:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  801611:	01 00 00 
  801614:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801618:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801619:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801620:	01 00 00 
  801623:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801627:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801628:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80162f:	01 00 00 
  801632:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801636:	c3                   	ret    

0000000000801637 <get_prot>:

int
get_prot(void *va) {
  801637:	55                   	push   %rbp
  801638:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80163b:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  801642:	00 00 00 
  801645:	ff d0                	call   *%rax
  801647:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80164a:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  80164f:	89 c1                	mov    %eax,%ecx
  801651:	83 c9 04             	or     $0x4,%ecx
  801654:	f6 c2 01             	test   $0x1,%dl
  801657:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80165a:	89 c1                	mov    %eax,%ecx
  80165c:	83 c9 02             	or     $0x2,%ecx
  80165f:	f6 c2 02             	test   $0x2,%dl
  801662:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  801665:	89 c1                	mov    %eax,%ecx
  801667:	83 c9 01             	or     $0x1,%ecx
  80166a:	48 85 d2             	test   %rdx,%rdx
  80166d:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801670:	89 c1                	mov    %eax,%ecx
  801672:	83 c9 40             	or     $0x40,%ecx
  801675:	f6 c6 04             	test   $0x4,%dh
  801678:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80167b:	5d                   	pop    %rbp
  80167c:	c3                   	ret    

000000000080167d <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80167d:	55                   	push   %rbp
  80167e:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801681:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  801688:	00 00 00 
  80168b:	ff d0                	call   *%rax
    return pte & PTE_D;
  80168d:	48 c1 e8 06          	shr    $0x6,%rax
  801691:	83 e0 01             	and    $0x1,%eax
}
  801694:	5d                   	pop    %rbp
  801695:	c3                   	ret    

0000000000801696 <is_page_present>:

bool
is_page_present(void *va) {
  801696:	55                   	push   %rbp
  801697:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80169a:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  8016a1:	00 00 00 
  8016a4:	ff d0                	call   *%rax
  8016a6:	83 e0 01             	and    $0x1,%eax
}
  8016a9:	5d                   	pop    %rbp
  8016aa:	c3                   	ret    

00000000008016ab <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8016ab:	55                   	push   %rbp
  8016ac:	48 89 e5             	mov    %rsp,%rbp
  8016af:	41 57                	push   %r15
  8016b1:	41 56                	push   %r14
  8016b3:	41 55                	push   %r13
  8016b5:	41 54                	push   %r12
  8016b7:	53                   	push   %rbx
  8016b8:	48 83 ec 28          	sub    $0x28,%rsp
  8016bc:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8016c0:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8016c4:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8016c9:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8016d0:	01 00 00 
  8016d3:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8016da:	01 00 00 
  8016dd:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8016e4:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016e7:	49 bf 37 16 80 00 00 	movabs $0x801637,%r15
  8016ee:	00 00 00 
  8016f1:	eb 16                	jmp    801709 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8016f3:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8016fa:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  801701:	00 00 00 
  801704:	48 39 c3             	cmp    %rax,%rbx
  801707:	77 73                	ja     80177c <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  801709:	48 89 d8             	mov    %rbx,%rax
  80170c:	48 c1 e8 27          	shr    $0x27,%rax
  801710:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  801714:	a8 01                	test   $0x1,%al
  801716:	74 db                	je     8016f3 <foreach_shared_region+0x48>
  801718:	48 89 d8             	mov    %rbx,%rax
  80171b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80171f:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  801724:	a8 01                	test   $0x1,%al
  801726:	74 cb                	je     8016f3 <foreach_shared_region+0x48>
  801728:	48 89 d8             	mov    %rbx,%rax
  80172b:	48 c1 e8 15          	shr    $0x15,%rax
  80172f:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  801733:	a8 01                	test   $0x1,%al
  801735:	74 bc                	je     8016f3 <foreach_shared_region+0x48>
        void *start = (void*)i;
  801737:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80173b:	48 89 df             	mov    %rbx,%rdi
  80173e:	41 ff d7             	call   *%r15
  801741:	a8 40                	test   $0x40,%al
  801743:	75 09                	jne    80174e <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  801745:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80174c:	eb ac                	jmp    8016fa <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80174e:	48 89 df             	mov    %rbx,%rdi
  801751:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801758:	00 00 00 
  80175b:	ff d0                	call   *%rax
  80175d:	84 c0                	test   %al,%al
  80175f:	74 e4                	je     801745 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  801761:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  801768:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80176c:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  801770:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801774:	ff d0                	call   *%rax
  801776:	85 c0                	test   %eax,%eax
  801778:	79 cb                	jns    801745 <foreach_shared_region+0x9a>
  80177a:	eb 05                	jmp    801781 <foreach_shared_region+0xd6>
    }
    return 0;
  80177c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801781:	48 83 c4 28          	add    $0x28,%rsp
  801785:	5b                   	pop    %rbx
  801786:	41 5c                	pop    %r12
  801788:	41 5d                	pop    %r13
  80178a:	41 5e                	pop    %r14
  80178c:	41 5f                	pop    %r15
  80178e:	5d                   	pop    %rbp
  80178f:	c3                   	ret    

0000000000801790 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
  801795:	c3                   	ret    

0000000000801796 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  801796:	55                   	push   %rbp
  801797:	48 89 e5             	mov    %rsp,%rbp
  80179a:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80179d:	48 be 14 2e 80 00 00 	movabs $0x802e14,%rsi
  8017a4:	00 00 00 
  8017a7:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  8017ae:	00 00 00 
  8017b1:	ff d0                	call   *%rax
    return 0;
}
  8017b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b8:	5d                   	pop    %rbp
  8017b9:	c3                   	ret    

00000000008017ba <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8017ba:	55                   	push   %rbp
  8017bb:	48 89 e5             	mov    %rsp,%rbp
  8017be:	41 57                	push   %r15
  8017c0:	41 56                	push   %r14
  8017c2:	41 55                	push   %r13
  8017c4:	41 54                	push   %r12
  8017c6:	53                   	push   %rbx
  8017c7:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8017ce:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8017d5:	48 85 d2             	test   %rdx,%rdx
  8017d8:	74 78                	je     801852 <devcons_write+0x98>
  8017da:	49 89 d6             	mov    %rdx,%r14
  8017dd:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8017e3:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8017e8:	49 bf 45 26 80 00 00 	movabs $0x802645,%r15
  8017ef:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8017f2:	4c 89 f3             	mov    %r14,%rbx
  8017f5:	48 29 f3             	sub    %rsi,%rbx
  8017f8:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8017fc:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801801:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801805:	4c 63 eb             	movslq %ebx,%r13
  801808:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  80180f:	4c 89 ea             	mov    %r13,%rdx
  801812:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801819:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  80181c:	4c 89 ee             	mov    %r13,%rsi
  80181f:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801826:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  80182d:	00 00 00 
  801830:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801832:	41 01 dc             	add    %ebx,%r12d
  801835:	49 63 f4             	movslq %r12d,%rsi
  801838:	4c 39 f6             	cmp    %r14,%rsi
  80183b:	72 b5                	jb     8017f2 <devcons_write+0x38>
    return res;
  80183d:	49 63 c4             	movslq %r12d,%rax
}
  801840:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801847:	5b                   	pop    %rbx
  801848:	41 5c                	pop    %r12
  80184a:	41 5d                	pop    %r13
  80184c:	41 5e                	pop    %r14
  80184e:	41 5f                	pop    %r15
  801850:	5d                   	pop    %rbp
  801851:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  801852:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801858:	eb e3                	jmp    80183d <devcons_write+0x83>

000000000080185a <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80185a:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80185d:	ba 00 00 00 00       	mov    $0x0,%edx
  801862:	48 85 c0             	test   %rax,%rax
  801865:	74 55                	je     8018bc <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801867:	55                   	push   %rbp
  801868:	48 89 e5             	mov    %rsp,%rbp
  80186b:	41 55                	push   %r13
  80186d:	41 54                	push   %r12
  80186f:	53                   	push   %rbx
  801870:	48 83 ec 08          	sub    $0x8,%rsp
  801874:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801877:	48 bb 4f 01 80 00 00 	movabs $0x80014f,%rbx
  80187e:	00 00 00 
  801881:	49 bc 1c 02 80 00 00 	movabs $0x80021c,%r12
  801888:	00 00 00 
  80188b:	eb 03                	jmp    801890 <devcons_read+0x36>
  80188d:	41 ff d4             	call   *%r12
  801890:	ff d3                	call   *%rbx
  801892:	85 c0                	test   %eax,%eax
  801894:	74 f7                	je     80188d <devcons_read+0x33>
    if (c < 0) return c;
  801896:	48 63 d0             	movslq %eax,%rdx
  801899:	78 13                	js     8018ae <devcons_read+0x54>
    if (c == 0x04) return 0;
  80189b:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a0:	83 f8 04             	cmp    $0x4,%eax
  8018a3:	74 09                	je     8018ae <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  8018a5:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8018a9:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8018ae:	48 89 d0             	mov    %rdx,%rax
  8018b1:	48 83 c4 08          	add    $0x8,%rsp
  8018b5:	5b                   	pop    %rbx
  8018b6:	41 5c                	pop    %r12
  8018b8:	41 5d                	pop    %r13
  8018ba:	5d                   	pop    %rbp
  8018bb:	c3                   	ret    
  8018bc:	48 89 d0             	mov    %rdx,%rax
  8018bf:	c3                   	ret    

00000000008018c0 <cputchar>:
cputchar(int ch) {
  8018c0:	55                   	push   %rbp
  8018c1:	48 89 e5             	mov    %rsp,%rbp
  8018c4:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8018c8:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8018cc:	be 01 00 00 00       	mov    $0x1,%esi
  8018d1:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8018d5:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  8018dc:	00 00 00 
  8018df:	ff d0                	call   *%rax
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

00000000008018e3 <getchar>:
getchar(void) {
  8018e3:	55                   	push   %rbp
  8018e4:	48 89 e5             	mov    %rsp,%rbp
  8018e7:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8018eb:	ba 01 00 00 00       	mov    $0x1,%edx
  8018f0:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8018f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8018f9:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  801900:	00 00 00 
  801903:	ff d0                	call   *%rax
  801905:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801907:	85 c0                	test   %eax,%eax
  801909:	78 06                	js     801911 <getchar+0x2e>
  80190b:	74 08                	je     801915 <getchar+0x32>
  80190d:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801911:	89 d0                	mov    %edx,%eax
  801913:	c9                   	leave  
  801914:	c3                   	ret    
    return res < 0 ? res : res ? c :
  801915:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  80191a:	eb f5                	jmp    801911 <getchar+0x2e>

000000000080191c <iscons>:
iscons(int fdnum) {
  80191c:	55                   	push   %rbp
  80191d:	48 89 e5             	mov    %rsp,%rbp
  801920:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801924:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801928:	48 b8 e9 06 80 00 00 	movabs $0x8006e9,%rax
  80192f:	00 00 00 
  801932:	ff d0                	call   *%rax
    if (res < 0) return res;
  801934:	85 c0                	test   %eax,%eax
  801936:	78 18                	js     801950 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  801938:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80193c:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801943:	00 00 00 
  801946:	8b 00                	mov    (%rax),%eax
  801948:	39 02                	cmp    %eax,(%rdx)
  80194a:	0f 94 c0             	sete   %al
  80194d:	0f b6 c0             	movzbl %al,%eax
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

0000000000801952 <opencons>:
opencons(void) {
  801952:	55                   	push   %rbp
  801953:	48 89 e5             	mov    %rsp,%rbp
  801956:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  80195a:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80195e:	48 b8 89 06 80 00 00 	movabs $0x800689,%rax
  801965:	00 00 00 
  801968:	ff d0                	call   *%rax
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 49                	js     8019b7 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80196e:	b9 46 00 00 00       	mov    $0x46,%ecx
  801973:	ba 00 10 00 00       	mov    $0x1000,%edx
  801978:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80197c:	bf 00 00 00 00       	mov    $0x0,%edi
  801981:	48 b8 ab 02 80 00 00 	movabs $0x8002ab,%rax
  801988:	00 00 00 
  80198b:	ff d0                	call   *%rax
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 26                	js     8019b7 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  801991:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801995:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  80199c:	00 00 
  80199e:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  8019a0:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8019a4:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  8019ab:	48 b8 5b 06 80 00 00 	movabs $0x80065b,%rax
  8019b2:	00 00 00 
  8019b5:	ff d0                	call   *%rax
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

00000000008019b9 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8019b9:	55                   	push   %rbp
  8019ba:	48 89 e5             	mov    %rsp,%rbp
  8019bd:	41 56                	push   %r14
  8019bf:	41 55                	push   %r13
  8019c1:	41 54                	push   %r12
  8019c3:	53                   	push   %rbx
  8019c4:	48 83 ec 50          	sub    $0x50,%rsp
  8019c8:	49 89 fc             	mov    %rdi,%r12
  8019cb:	41 89 f5             	mov    %esi,%r13d
  8019ce:	48 89 d3             	mov    %rdx,%rbx
  8019d1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8019d5:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8019d9:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8019dd:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8019e4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019e8:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8019ec:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8019f0:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8019f4:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8019fb:	00 00 00 
  8019fe:	4c 8b 30             	mov    (%rax),%r14
  801a01:	48 b8 eb 01 80 00 00 	movabs $0x8001eb,%rax
  801a08:	00 00 00 
  801a0b:	ff d0                	call   *%rax
  801a0d:	89 c6                	mov    %eax,%esi
  801a0f:	45 89 e8             	mov    %r13d,%r8d
  801a12:	4c 89 e1             	mov    %r12,%rcx
  801a15:	4c 89 f2             	mov    %r14,%rdx
  801a18:	48 bf 20 2e 80 00 00 	movabs $0x802e20,%rdi
  801a1f:	00 00 00 
  801a22:	b8 00 00 00 00       	mov    $0x0,%eax
  801a27:	49 bc 09 1b 80 00 00 	movabs $0x801b09,%r12
  801a2e:	00 00 00 
  801a31:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801a34:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801a38:	48 89 df             	mov    %rbx,%rdi
  801a3b:	48 b8 a5 1a 80 00 00 	movabs $0x801aa5,%rax
  801a42:	00 00 00 
  801a45:	ff d0                	call   *%rax
    cprintf("\n");
  801a47:	48 bf 63 2d 80 00 00 	movabs $0x802d63,%rdi
  801a4e:	00 00 00 
  801a51:	b8 00 00 00 00       	mov    $0x0,%eax
  801a56:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801a59:	cc                   	int3   
  801a5a:	eb fd                	jmp    801a59 <_panic+0xa0>

0000000000801a5c <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801a5c:	55                   	push   %rbp
  801a5d:	48 89 e5             	mov    %rsp,%rbp
  801a60:	53                   	push   %rbx
  801a61:	48 83 ec 08          	sub    $0x8,%rsp
  801a65:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801a68:	8b 06                	mov    (%rsi),%eax
  801a6a:	8d 50 01             	lea    0x1(%rax),%edx
  801a6d:	89 16                	mov    %edx,(%rsi)
  801a6f:	48 98                	cltq   
  801a71:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801a76:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801a7c:	74 0a                	je     801a88 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801a7e:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801a82:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  801a88:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801a8c:	be ff 00 00 00       	mov    $0xff,%esi
  801a91:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  801a98:	00 00 00 
  801a9b:	ff d0                	call   *%rax
        state->offset = 0;
  801a9d:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801aa3:	eb d9                	jmp    801a7e <putch+0x22>

0000000000801aa5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801aa5:	55                   	push   %rbp
  801aa6:	48 89 e5             	mov    %rsp,%rbp
  801aa9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801ab0:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801ab3:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801aba:	b9 21 00 00 00       	mov    $0x21,%ecx
  801abf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac4:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801ac7:	48 89 f1             	mov    %rsi,%rcx
  801aca:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801ad1:	48 bf 5c 1a 80 00 00 	movabs $0x801a5c,%rdi
  801ad8:	00 00 00 
  801adb:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  801ae2:	00 00 00 
  801ae5:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801ae7:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801aee:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801af5:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  801afc:	00 00 00 
  801aff:	ff d0                	call   *%rax

    return state.count;
}
  801b01:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

0000000000801b09 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801b09:	55                   	push   %rbp
  801b0a:	48 89 e5             	mov    %rsp,%rbp
  801b0d:	48 83 ec 50          	sub    $0x50,%rsp
  801b11:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801b15:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801b19:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b1d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801b21:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801b25:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801b2c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801b30:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801b34:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801b38:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801b3c:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801b40:	48 b8 a5 1a 80 00 00 	movabs $0x801aa5,%rax
  801b47:	00 00 00 
  801b4a:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

0000000000801b4e <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801b4e:	55                   	push   %rbp
  801b4f:	48 89 e5             	mov    %rsp,%rbp
  801b52:	41 57                	push   %r15
  801b54:	41 56                	push   %r14
  801b56:	41 55                	push   %r13
  801b58:	41 54                	push   %r12
  801b5a:	53                   	push   %rbx
  801b5b:	48 83 ec 18          	sub    $0x18,%rsp
  801b5f:	49 89 fc             	mov    %rdi,%r12
  801b62:	49 89 f5             	mov    %rsi,%r13
  801b65:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801b69:	8b 45 10             	mov    0x10(%rbp),%eax
  801b6c:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801b6f:	41 89 cf             	mov    %ecx,%r15d
  801b72:	49 39 d7             	cmp    %rdx,%r15
  801b75:	76 5b                	jbe    801bd2 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801b77:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801b7b:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801b7f:	85 db                	test   %ebx,%ebx
  801b81:	7e 0e                	jle    801b91 <print_num+0x43>
            putch(padc, put_arg);
  801b83:	4c 89 ee             	mov    %r13,%rsi
  801b86:	44 89 f7             	mov    %r14d,%edi
  801b89:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801b8c:	83 eb 01             	sub    $0x1,%ebx
  801b8f:	75 f2                	jne    801b83 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801b91:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801b95:	48 b9 43 2e 80 00 00 	movabs $0x802e43,%rcx
  801b9c:	00 00 00 
  801b9f:	48 b8 54 2e 80 00 00 	movabs $0x802e54,%rax
  801ba6:	00 00 00 
  801ba9:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801bad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801bb1:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb6:	49 f7 f7             	div    %r15
  801bb9:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801bbd:	4c 89 ee             	mov    %r13,%rsi
  801bc0:	41 ff d4             	call   *%r12
}
  801bc3:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801bc7:	5b                   	pop    %rbx
  801bc8:	41 5c                	pop    %r12
  801bca:	41 5d                	pop    %r13
  801bcc:	41 5e                	pop    %r14
  801bce:	41 5f                	pop    %r15
  801bd0:	5d                   	pop    %rbp
  801bd1:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801bd2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801bd6:	ba 00 00 00 00       	mov    $0x0,%edx
  801bdb:	49 f7 f7             	div    %r15
  801bde:	48 83 ec 08          	sub    $0x8,%rsp
  801be2:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801be6:	52                   	push   %rdx
  801be7:	45 0f be c9          	movsbl %r9b,%r9d
  801beb:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801bef:	48 89 c2             	mov    %rax,%rdx
  801bf2:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  801bf9:	00 00 00 
  801bfc:	ff d0                	call   *%rax
  801bfe:	48 83 c4 10          	add    $0x10,%rsp
  801c02:	eb 8d                	jmp    801b91 <print_num+0x43>

0000000000801c04 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  801c04:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801c08:	48 8b 06             	mov    (%rsi),%rax
  801c0b:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801c0f:	73 0a                	jae    801c1b <sprintputch+0x17>
        *state->start++ = ch;
  801c11:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c15:	48 89 16             	mov    %rdx,(%rsi)
  801c18:	40 88 38             	mov    %dil,(%rax)
    }
}
  801c1b:	c3                   	ret    

0000000000801c1c <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801c1c:	55                   	push   %rbp
  801c1d:	48 89 e5             	mov    %rsp,%rbp
  801c20:	48 83 ec 50          	sub    $0x50,%rsp
  801c24:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c28:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801c2c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801c30:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801c37:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c3b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801c3f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801c43:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801c47:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801c4b:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  801c52:	00 00 00 
  801c55:	ff d0                	call   *%rax
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

0000000000801c59 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801c59:	55                   	push   %rbp
  801c5a:	48 89 e5             	mov    %rsp,%rbp
  801c5d:	41 57                	push   %r15
  801c5f:	41 56                	push   %r14
  801c61:	41 55                	push   %r13
  801c63:	41 54                	push   %r12
  801c65:	53                   	push   %rbx
  801c66:	48 83 ec 48          	sub    $0x48,%rsp
  801c6a:	49 89 fc             	mov    %rdi,%r12
  801c6d:	49 89 f6             	mov    %rsi,%r14
  801c70:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  801c73:	48 8b 01             	mov    (%rcx),%rax
  801c76:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801c7a:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801c7e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801c82:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801c86:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801c8a:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  801c8e:	41 0f b6 3f          	movzbl (%r15),%edi
  801c92:	40 80 ff 25          	cmp    $0x25,%dil
  801c96:	74 18                	je     801cb0 <vprintfmt+0x57>
            if (!ch) return;
  801c98:	40 84 ff             	test   %dil,%dil
  801c9b:	0f 84 d1 06 00 00    	je     802372 <vprintfmt+0x719>
            putch(ch, put_arg);
  801ca1:	40 0f b6 ff          	movzbl %dil,%edi
  801ca5:	4c 89 f6             	mov    %r14,%rsi
  801ca8:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  801cab:	49 89 df             	mov    %rbx,%r15
  801cae:	eb da                	jmp    801c8a <vprintfmt+0x31>
            precision = va_arg(aq, int);
  801cb0:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  801cb4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb9:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  801cbd:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801cc2:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801cc8:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801ccf:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  801cd3:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  801cd8:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  801cde:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  801ce2:	44 0f b6 0b          	movzbl (%rbx),%r9d
  801ce6:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  801cea:	3c 57                	cmp    $0x57,%al
  801cec:	0f 87 65 06 00 00    	ja     802357 <vprintfmt+0x6fe>
  801cf2:	0f b6 c0             	movzbl %al,%eax
  801cf5:	49 ba e0 2f 80 00 00 	movabs $0x802fe0,%r10
  801cfc:	00 00 00 
  801cff:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  801d03:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  801d06:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  801d0a:	eb d2                	jmp    801cde <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  801d0c:	4c 89 fb             	mov    %r15,%rbx
  801d0f:	44 89 c1             	mov    %r8d,%ecx
  801d12:	eb ca                	jmp    801cde <vprintfmt+0x85>
            padc = ch;
  801d14:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  801d18:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d1b:	eb c1                	jmp    801cde <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801d1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d20:	83 f8 2f             	cmp    $0x2f,%eax
  801d23:	77 24                	ja     801d49 <vprintfmt+0xf0>
  801d25:	41 89 c1             	mov    %eax,%r9d
  801d28:	49 01 f1             	add    %rsi,%r9
  801d2b:	83 c0 08             	add    $0x8,%eax
  801d2e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d31:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  801d34:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  801d37:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801d3b:	79 a1                	jns    801cde <vprintfmt+0x85>
                width = precision;
  801d3d:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  801d41:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801d47:	eb 95                	jmp    801cde <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801d49:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  801d4d:	49 8d 41 08          	lea    0x8(%r9),%rax
  801d51:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d55:	eb da                	jmp    801d31 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  801d57:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  801d5b:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d5f:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  801d63:	3c 39                	cmp    $0x39,%al
  801d65:	77 1e                	ja     801d85 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  801d67:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  801d6b:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  801d70:	0f b6 c0             	movzbl %al,%eax
  801d73:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d78:	41 0f b6 07          	movzbl (%r15),%eax
  801d7c:	3c 39                	cmp    $0x39,%al
  801d7e:	76 e7                	jbe    801d67 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  801d80:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  801d83:	eb b2                	jmp    801d37 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  801d85:	4c 89 fb             	mov    %r15,%rbx
  801d88:	eb ad                	jmp    801d37 <vprintfmt+0xde>
            width = MAX(0, width);
  801d8a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	0f 48 c7             	cmovs  %edi,%eax
  801d92:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801d95:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d98:	e9 41 ff ff ff       	jmp    801cde <vprintfmt+0x85>
            lflag++;
  801d9d:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801da0:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801da3:	e9 36 ff ff ff       	jmp    801cde <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  801da8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801dab:	83 f8 2f             	cmp    $0x2f,%eax
  801dae:	77 18                	ja     801dc8 <vprintfmt+0x16f>
  801db0:	89 c2                	mov    %eax,%edx
  801db2:	48 01 f2             	add    %rsi,%rdx
  801db5:	83 c0 08             	add    $0x8,%eax
  801db8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801dbb:	4c 89 f6             	mov    %r14,%rsi
  801dbe:	8b 3a                	mov    (%rdx),%edi
  801dc0:	41 ff d4             	call   *%r12
            break;
  801dc3:	e9 c2 fe ff ff       	jmp    801c8a <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  801dc8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801dcc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801dd0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801dd4:	eb e5                	jmp    801dbb <vprintfmt+0x162>
            int err = va_arg(aq, int);
  801dd6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801dd9:	83 f8 2f             	cmp    $0x2f,%eax
  801ddc:	77 5b                	ja     801e39 <vprintfmt+0x1e0>
  801dde:	89 c2                	mov    %eax,%edx
  801de0:	48 01 d6             	add    %rdx,%rsi
  801de3:	83 c0 08             	add    $0x8,%eax
  801de6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801de9:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  801deb:	89 c8                	mov    %ecx,%eax
  801ded:	c1 f8 1f             	sar    $0x1f,%eax
  801df0:	31 c1                	xor    %eax,%ecx
  801df2:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  801df4:	83 f9 13             	cmp    $0x13,%ecx
  801df7:	7f 4e                	jg     801e47 <vprintfmt+0x1ee>
  801df9:	48 63 c1             	movslq %ecx,%rax
  801dfc:	48 ba a0 32 80 00 00 	movabs $0x8032a0,%rdx
  801e03:	00 00 00 
  801e06:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801e0a:	48 85 c0             	test   %rax,%rax
  801e0d:	74 38                	je     801e47 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  801e0f:	48 89 c1             	mov    %rax,%rcx
  801e12:	48 ba d9 2d 80 00 00 	movabs $0x802dd9,%rdx
  801e19:	00 00 00 
  801e1c:	4c 89 f6             	mov    %r14,%rsi
  801e1f:	4c 89 e7             	mov    %r12,%rdi
  801e22:	b8 00 00 00 00       	mov    $0x0,%eax
  801e27:	49 b8 1c 1c 80 00 00 	movabs $0x801c1c,%r8
  801e2e:	00 00 00 
  801e31:	41 ff d0             	call   *%r8
  801e34:	e9 51 fe ff ff       	jmp    801c8a <vprintfmt+0x31>
            int err = va_arg(aq, int);
  801e39:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801e3d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801e41:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e45:	eb a2                	jmp    801de9 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  801e47:	48 ba 6c 2e 80 00 00 	movabs $0x802e6c,%rdx
  801e4e:	00 00 00 
  801e51:	4c 89 f6             	mov    %r14,%rsi
  801e54:	4c 89 e7             	mov    %r12,%rdi
  801e57:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5c:	49 b8 1c 1c 80 00 00 	movabs $0x801c1c,%r8
  801e63:	00 00 00 
  801e66:	41 ff d0             	call   *%r8
  801e69:	e9 1c fe ff ff       	jmp    801c8a <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  801e6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801e71:	83 f8 2f             	cmp    $0x2f,%eax
  801e74:	77 55                	ja     801ecb <vprintfmt+0x272>
  801e76:	89 c2                	mov    %eax,%edx
  801e78:	48 01 d6             	add    %rdx,%rsi
  801e7b:	83 c0 08             	add    $0x8,%eax
  801e7e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801e81:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  801e84:	48 85 d2             	test   %rdx,%rdx
  801e87:	48 b8 65 2e 80 00 00 	movabs $0x802e65,%rax
  801e8e:	00 00 00 
  801e91:	48 0f 45 c2          	cmovne %rdx,%rax
  801e95:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  801e99:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801e9d:	7e 06                	jle    801ea5 <vprintfmt+0x24c>
  801e9f:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  801ea3:	75 34                	jne    801ed9 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801ea5:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  801ea9:	48 8d 58 01          	lea    0x1(%rax),%rbx
  801ead:	0f b6 00             	movzbl (%rax),%eax
  801eb0:	84 c0                	test   %al,%al
  801eb2:	0f 84 b2 00 00 00    	je     801f6a <vprintfmt+0x311>
  801eb8:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  801ebc:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  801ec1:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  801ec5:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  801ec9:	eb 74                	jmp    801f3f <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  801ecb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801ecf:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801ed3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ed7:	eb a8                	jmp    801e81 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  801ed9:	49 63 f5             	movslq %r13d,%rsi
  801edc:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  801ee0:	48 b8 2c 24 80 00 00 	movabs $0x80242c,%rax
  801ee7:	00 00 00 
  801eea:	ff d0                	call   *%rax
  801eec:	48 89 c2             	mov    %rax,%rdx
  801eef:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801ef2:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  801ef4:	8d 48 ff             	lea    -0x1(%rax),%ecx
  801ef7:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  801efa:	85 c0                	test   %eax,%eax
  801efc:	7e a7                	jle    801ea5 <vprintfmt+0x24c>
  801efe:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  801f02:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  801f06:	41 89 cd             	mov    %ecx,%r13d
  801f09:	4c 89 f6             	mov    %r14,%rsi
  801f0c:	89 df                	mov    %ebx,%edi
  801f0e:	41 ff d4             	call   *%r12
  801f11:	41 83 ed 01          	sub    $0x1,%r13d
  801f15:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  801f19:	75 ee                	jne    801f09 <vprintfmt+0x2b0>
  801f1b:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  801f1f:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  801f23:	eb 80                	jmp    801ea5 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801f25:	0f b6 f8             	movzbl %al,%edi
  801f28:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801f2c:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801f2f:	41 83 ef 01          	sub    $0x1,%r15d
  801f33:	48 83 c3 01          	add    $0x1,%rbx
  801f37:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  801f3b:	84 c0                	test   %al,%al
  801f3d:	74 1f                	je     801f5e <vprintfmt+0x305>
  801f3f:	45 85 ed             	test   %r13d,%r13d
  801f42:	78 06                	js     801f4a <vprintfmt+0x2f1>
  801f44:	41 83 ed 01          	sub    $0x1,%r13d
  801f48:	78 46                	js     801f90 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801f4a:	45 84 f6             	test   %r14b,%r14b
  801f4d:	74 d6                	je     801f25 <vprintfmt+0x2cc>
  801f4f:	8d 50 e0             	lea    -0x20(%rax),%edx
  801f52:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801f57:	80 fa 5e             	cmp    $0x5e,%dl
  801f5a:	77 cc                	ja     801f28 <vprintfmt+0x2cf>
  801f5c:	eb c7                	jmp    801f25 <vprintfmt+0x2cc>
  801f5e:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f62:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f66:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  801f6a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801f6d:	8d 58 ff             	lea    -0x1(%rax),%ebx
  801f70:	85 c0                	test   %eax,%eax
  801f72:	0f 8e 12 fd ff ff    	jle    801c8a <vprintfmt+0x31>
  801f78:	4c 89 f6             	mov    %r14,%rsi
  801f7b:	bf 20 00 00 00       	mov    $0x20,%edi
  801f80:	41 ff d4             	call   *%r12
  801f83:	83 eb 01             	sub    $0x1,%ebx
  801f86:	83 fb ff             	cmp    $0xffffffff,%ebx
  801f89:	75 ed                	jne    801f78 <vprintfmt+0x31f>
  801f8b:	e9 fa fc ff ff       	jmp    801c8a <vprintfmt+0x31>
  801f90:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f94:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f98:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  801f9c:	eb cc                	jmp    801f6a <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  801f9e:	45 89 cd             	mov    %r9d,%r13d
  801fa1:	84 c9                	test   %cl,%cl
  801fa3:	75 25                	jne    801fca <vprintfmt+0x371>
    switch (lflag) {
  801fa5:	85 d2                	test   %edx,%edx
  801fa7:	74 57                	je     802000 <vprintfmt+0x3a7>
  801fa9:	83 fa 01             	cmp    $0x1,%edx
  801fac:	74 78                	je     802026 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  801fae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fb1:	83 f8 2f             	cmp    $0x2f,%eax
  801fb4:	0f 87 92 00 00 00    	ja     80204c <vprintfmt+0x3f3>
  801fba:	89 c2                	mov    %eax,%edx
  801fbc:	48 01 d6             	add    %rdx,%rsi
  801fbf:	83 c0 08             	add    $0x8,%eax
  801fc2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fc5:	48 8b 1e             	mov    (%rsi),%rbx
  801fc8:	eb 16                	jmp    801fe0 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  801fca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fcd:	83 f8 2f             	cmp    $0x2f,%eax
  801fd0:	77 20                	ja     801ff2 <vprintfmt+0x399>
  801fd2:	89 c2                	mov    %eax,%edx
  801fd4:	48 01 d6             	add    %rdx,%rsi
  801fd7:	83 c0 08             	add    $0x8,%eax
  801fda:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fdd:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  801fe0:	48 85 db             	test   %rbx,%rbx
  801fe3:	78 78                	js     80205d <vprintfmt+0x404>
            num = i;
  801fe5:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  801fe8:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  801fed:	e9 49 02 00 00       	jmp    80223b <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801ff2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801ff6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801ffa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ffe:	eb dd                	jmp    801fdd <vprintfmt+0x384>
        return va_arg(*ap, int);
  802000:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802003:	83 f8 2f             	cmp    $0x2f,%eax
  802006:	77 10                	ja     802018 <vprintfmt+0x3bf>
  802008:	89 c2                	mov    %eax,%edx
  80200a:	48 01 d6             	add    %rdx,%rsi
  80200d:	83 c0 08             	add    $0x8,%eax
  802010:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802013:	48 63 1e             	movslq (%rsi),%rbx
  802016:	eb c8                	jmp    801fe0 <vprintfmt+0x387>
  802018:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80201c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802020:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802024:	eb ed                	jmp    802013 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  802026:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802029:	83 f8 2f             	cmp    $0x2f,%eax
  80202c:	77 10                	ja     80203e <vprintfmt+0x3e5>
  80202e:	89 c2                	mov    %eax,%edx
  802030:	48 01 d6             	add    %rdx,%rsi
  802033:	83 c0 08             	add    $0x8,%eax
  802036:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802039:	48 8b 1e             	mov    (%rsi),%rbx
  80203c:	eb a2                	jmp    801fe0 <vprintfmt+0x387>
  80203e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802042:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802046:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80204a:	eb ed                	jmp    802039 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  80204c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802050:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802054:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802058:	e9 68 ff ff ff       	jmp    801fc5 <vprintfmt+0x36c>
                putch('-', put_arg);
  80205d:	4c 89 f6             	mov    %r14,%rsi
  802060:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802065:	41 ff d4             	call   *%r12
                i = -i;
  802068:	48 f7 db             	neg    %rbx
  80206b:	e9 75 ff ff ff       	jmp    801fe5 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  802070:	45 89 cd             	mov    %r9d,%r13d
  802073:	84 c9                	test   %cl,%cl
  802075:	75 2d                	jne    8020a4 <vprintfmt+0x44b>
    switch (lflag) {
  802077:	85 d2                	test   %edx,%edx
  802079:	74 57                	je     8020d2 <vprintfmt+0x479>
  80207b:	83 fa 01             	cmp    $0x1,%edx
  80207e:	74 7f                	je     8020ff <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  802080:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802083:	83 f8 2f             	cmp    $0x2f,%eax
  802086:	0f 87 a1 00 00 00    	ja     80212d <vprintfmt+0x4d4>
  80208c:	89 c2                	mov    %eax,%edx
  80208e:	48 01 d6             	add    %rdx,%rsi
  802091:	83 c0 08             	add    $0x8,%eax
  802094:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802097:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80209a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80209f:	e9 97 01 00 00       	jmp    80223b <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8020a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020a7:	83 f8 2f             	cmp    $0x2f,%eax
  8020aa:	77 18                	ja     8020c4 <vprintfmt+0x46b>
  8020ac:	89 c2                	mov    %eax,%edx
  8020ae:	48 01 d6             	add    %rdx,%rsi
  8020b1:	83 c0 08             	add    $0x8,%eax
  8020b4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020b7:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8020ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8020bf:	e9 77 01 00 00       	jmp    80223b <vprintfmt+0x5e2>
  8020c4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020c8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020cc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020d0:	eb e5                	jmp    8020b7 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8020d2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020d5:	83 f8 2f             	cmp    $0x2f,%eax
  8020d8:	77 17                	ja     8020f1 <vprintfmt+0x498>
  8020da:	89 c2                	mov    %eax,%edx
  8020dc:	48 01 d6             	add    %rdx,%rsi
  8020df:	83 c0 08             	add    $0x8,%eax
  8020e2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020e5:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8020e7:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8020ec:	e9 4a 01 00 00       	jmp    80223b <vprintfmt+0x5e2>
  8020f1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020f5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020f9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020fd:	eb e6                	jmp    8020e5 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8020ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802102:	83 f8 2f             	cmp    $0x2f,%eax
  802105:	77 18                	ja     80211f <vprintfmt+0x4c6>
  802107:	89 c2                	mov    %eax,%edx
  802109:	48 01 d6             	add    %rdx,%rsi
  80210c:	83 c0 08             	add    $0x8,%eax
  80210f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802112:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802115:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80211a:	e9 1c 01 00 00       	jmp    80223b <vprintfmt+0x5e2>
  80211f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802123:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802127:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80212b:	eb e5                	jmp    802112 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  80212d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802131:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802135:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802139:	e9 59 ff ff ff       	jmp    802097 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  80213e:	45 89 cd             	mov    %r9d,%r13d
  802141:	84 c9                	test   %cl,%cl
  802143:	75 2d                	jne    802172 <vprintfmt+0x519>
    switch (lflag) {
  802145:	85 d2                	test   %edx,%edx
  802147:	74 57                	je     8021a0 <vprintfmt+0x547>
  802149:	83 fa 01             	cmp    $0x1,%edx
  80214c:	74 7c                	je     8021ca <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  80214e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802151:	83 f8 2f             	cmp    $0x2f,%eax
  802154:	0f 87 9b 00 00 00    	ja     8021f5 <vprintfmt+0x59c>
  80215a:	89 c2                	mov    %eax,%edx
  80215c:	48 01 d6             	add    %rdx,%rsi
  80215f:	83 c0 08             	add    $0x8,%eax
  802162:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802165:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802168:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80216d:	e9 c9 00 00 00       	jmp    80223b <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802172:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802175:	83 f8 2f             	cmp    $0x2f,%eax
  802178:	77 18                	ja     802192 <vprintfmt+0x539>
  80217a:	89 c2                	mov    %eax,%edx
  80217c:	48 01 d6             	add    %rdx,%rsi
  80217f:	83 c0 08             	add    $0x8,%eax
  802182:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802185:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802188:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80218d:	e9 a9 00 00 00       	jmp    80223b <vprintfmt+0x5e2>
  802192:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802196:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80219a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80219e:	eb e5                	jmp    802185 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  8021a0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021a3:	83 f8 2f             	cmp    $0x2f,%eax
  8021a6:	77 14                	ja     8021bc <vprintfmt+0x563>
  8021a8:	89 c2                	mov    %eax,%edx
  8021aa:	48 01 d6             	add    %rdx,%rsi
  8021ad:	83 c0 08             	add    $0x8,%eax
  8021b0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021b3:	8b 16                	mov    (%rsi),%edx
            base = 8;
  8021b5:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8021ba:	eb 7f                	jmp    80223b <vprintfmt+0x5e2>
  8021bc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8021c0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8021c4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8021c8:	eb e9                	jmp    8021b3 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  8021ca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021cd:	83 f8 2f             	cmp    $0x2f,%eax
  8021d0:	77 15                	ja     8021e7 <vprintfmt+0x58e>
  8021d2:	89 c2                	mov    %eax,%edx
  8021d4:	48 01 d6             	add    %rdx,%rsi
  8021d7:	83 c0 08             	add    $0x8,%eax
  8021da:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021dd:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8021e0:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8021e5:	eb 54                	jmp    80223b <vprintfmt+0x5e2>
  8021e7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8021eb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8021ef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8021f3:	eb e8                	jmp    8021dd <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8021f5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8021f9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8021fd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802201:	e9 5f ff ff ff       	jmp    802165 <vprintfmt+0x50c>
            putch('0', put_arg);
  802206:	45 89 cd             	mov    %r9d,%r13d
  802209:	4c 89 f6             	mov    %r14,%rsi
  80220c:	bf 30 00 00 00       	mov    $0x30,%edi
  802211:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  802214:	4c 89 f6             	mov    %r14,%rsi
  802217:	bf 78 00 00 00       	mov    $0x78,%edi
  80221c:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  80221f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802222:	83 f8 2f             	cmp    $0x2f,%eax
  802225:	77 47                	ja     80226e <vprintfmt+0x615>
  802227:	89 c2                	mov    %eax,%edx
  802229:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80222d:	83 c0 08             	add    $0x8,%eax
  802230:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802233:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802236:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80223b:	48 83 ec 08          	sub    $0x8,%rsp
  80223f:	41 80 fd 58          	cmp    $0x58,%r13b
  802243:	0f 94 c0             	sete   %al
  802246:	0f b6 c0             	movzbl %al,%eax
  802249:	50                   	push   %rax
  80224a:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  80224f:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  802253:	4c 89 f6             	mov    %r14,%rsi
  802256:	4c 89 e7             	mov    %r12,%rdi
  802259:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  802260:	00 00 00 
  802263:	ff d0                	call   *%rax
            break;
  802265:	48 83 c4 10          	add    $0x10,%rsp
  802269:	e9 1c fa ff ff       	jmp    801c8a <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  80226e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802272:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802276:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80227a:	eb b7                	jmp    802233 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  80227c:	45 89 cd             	mov    %r9d,%r13d
  80227f:	84 c9                	test   %cl,%cl
  802281:	75 2a                	jne    8022ad <vprintfmt+0x654>
    switch (lflag) {
  802283:	85 d2                	test   %edx,%edx
  802285:	74 54                	je     8022db <vprintfmt+0x682>
  802287:	83 fa 01             	cmp    $0x1,%edx
  80228a:	74 7c                	je     802308 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  80228c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80228f:	83 f8 2f             	cmp    $0x2f,%eax
  802292:	0f 87 9e 00 00 00    	ja     802336 <vprintfmt+0x6dd>
  802298:	89 c2                	mov    %eax,%edx
  80229a:	48 01 d6             	add    %rdx,%rsi
  80229d:	83 c0 08             	add    $0x8,%eax
  8022a0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022a3:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8022a6:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8022ab:	eb 8e                	jmp    80223b <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8022ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022b0:	83 f8 2f             	cmp    $0x2f,%eax
  8022b3:	77 18                	ja     8022cd <vprintfmt+0x674>
  8022b5:	89 c2                	mov    %eax,%edx
  8022b7:	48 01 d6             	add    %rdx,%rsi
  8022ba:	83 c0 08             	add    $0x8,%eax
  8022bd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022c0:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8022c3:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8022c8:	e9 6e ff ff ff       	jmp    80223b <vprintfmt+0x5e2>
  8022cd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022d1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022d5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022d9:	eb e5                	jmp    8022c0 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  8022db:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022de:	83 f8 2f             	cmp    $0x2f,%eax
  8022e1:	77 17                	ja     8022fa <vprintfmt+0x6a1>
  8022e3:	89 c2                	mov    %eax,%edx
  8022e5:	48 01 d6             	add    %rdx,%rsi
  8022e8:	83 c0 08             	add    $0x8,%eax
  8022eb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022ee:	8b 16                	mov    (%rsi),%edx
            base = 16;
  8022f0:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8022f5:	e9 41 ff ff ff       	jmp    80223b <vprintfmt+0x5e2>
  8022fa:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022fe:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802302:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802306:	eb e6                	jmp    8022ee <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  802308:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80230b:	83 f8 2f             	cmp    $0x2f,%eax
  80230e:	77 18                	ja     802328 <vprintfmt+0x6cf>
  802310:	89 c2                	mov    %eax,%edx
  802312:	48 01 d6             	add    %rdx,%rsi
  802315:	83 c0 08             	add    $0x8,%eax
  802318:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80231b:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80231e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  802323:	e9 13 ff ff ff       	jmp    80223b <vprintfmt+0x5e2>
  802328:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80232c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802330:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802334:	eb e5                	jmp    80231b <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  802336:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80233a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80233e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802342:	e9 5c ff ff ff       	jmp    8022a3 <vprintfmt+0x64a>
            putch(ch, put_arg);
  802347:	4c 89 f6             	mov    %r14,%rsi
  80234a:	bf 25 00 00 00       	mov    $0x25,%edi
  80234f:	41 ff d4             	call   *%r12
            break;
  802352:	e9 33 f9 ff ff       	jmp    801c8a <vprintfmt+0x31>
            putch('%', put_arg);
  802357:	4c 89 f6             	mov    %r14,%rsi
  80235a:	bf 25 00 00 00       	mov    $0x25,%edi
  80235f:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  802362:	49 83 ef 01          	sub    $0x1,%r15
  802366:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  80236b:	75 f5                	jne    802362 <vprintfmt+0x709>
  80236d:	e9 18 f9 ff ff       	jmp    801c8a <vprintfmt+0x31>
}
  802372:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802376:	5b                   	pop    %rbx
  802377:	41 5c                	pop    %r12
  802379:	41 5d                	pop    %r13
  80237b:	41 5e                	pop    %r14
  80237d:	41 5f                	pop    %r15
  80237f:	5d                   	pop    %rbp
  802380:	c3                   	ret    

0000000000802381 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  802381:	55                   	push   %rbp
  802382:	48 89 e5             	mov    %rsp,%rbp
  802385:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  802389:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80238d:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  802392:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802396:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  80239d:	48 85 ff             	test   %rdi,%rdi
  8023a0:	74 2b                	je     8023cd <vsnprintf+0x4c>
  8023a2:	48 85 f6             	test   %rsi,%rsi
  8023a5:	74 26                	je     8023cd <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8023a7:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8023ab:	48 bf 04 1c 80 00 00 	movabs $0x801c04,%rdi
  8023b2:	00 00 00 
  8023b5:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  8023bc:	00 00 00 
  8023bf:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8023c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c5:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8023c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  8023cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023d2:	eb f7                	jmp    8023cb <vsnprintf+0x4a>

00000000008023d4 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8023d4:	55                   	push   %rbp
  8023d5:	48 89 e5             	mov    %rsp,%rbp
  8023d8:	48 83 ec 50          	sub    $0x50,%rsp
  8023dc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8023e0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8023e4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8023e8:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8023ef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8023f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023f7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8023fb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  8023ff:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  802403:	48 b8 81 23 80 00 00 	movabs $0x802381,%rax
  80240a:	00 00 00 
  80240d:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

0000000000802411 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  802411:	80 3f 00             	cmpb   $0x0,(%rdi)
  802414:	74 10                	je     802426 <strlen+0x15>
    size_t n = 0;
  802416:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  80241b:	48 83 c0 01          	add    $0x1,%rax
  80241f:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  802423:	75 f6                	jne    80241b <strlen+0xa>
  802425:	c3                   	ret    
    size_t n = 0;
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  80242b:	c3                   	ret    

000000000080242c <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  80242c:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  802431:	48 85 f6             	test   %rsi,%rsi
  802434:	74 10                	je     802446 <strnlen+0x1a>
  802436:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  80243a:	74 09                	je     802445 <strnlen+0x19>
  80243c:	48 83 c0 01          	add    $0x1,%rax
  802440:	48 39 c6             	cmp    %rax,%rsi
  802443:	75 f1                	jne    802436 <strnlen+0xa>
    return n;
}
  802445:	c3                   	ret    
    size_t n = 0;
  802446:	48 89 f0             	mov    %rsi,%rax
  802449:	c3                   	ret    

000000000080244a <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80244a:	b8 00 00 00 00       	mov    $0x0,%eax
  80244f:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  802453:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  802456:	48 83 c0 01          	add    $0x1,%rax
  80245a:	84 d2                	test   %dl,%dl
  80245c:	75 f1                	jne    80244f <strcpy+0x5>
        ;
    return res;
}
  80245e:	48 89 f8             	mov    %rdi,%rax
  802461:	c3                   	ret    

0000000000802462 <strcat>:

char *
strcat(char *dst, const char *src) {
  802462:	55                   	push   %rbp
  802463:	48 89 e5             	mov    %rsp,%rbp
  802466:	41 54                	push   %r12
  802468:	53                   	push   %rbx
  802469:	48 89 fb             	mov    %rdi,%rbx
  80246c:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  80246f:	48 b8 11 24 80 00 00 	movabs $0x802411,%rax
  802476:	00 00 00 
  802479:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  80247b:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  80247f:	4c 89 e6             	mov    %r12,%rsi
  802482:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  802489:	00 00 00 
  80248c:	ff d0                	call   *%rax
    return dst;
}
  80248e:	48 89 d8             	mov    %rbx,%rax
  802491:	5b                   	pop    %rbx
  802492:	41 5c                	pop    %r12
  802494:	5d                   	pop    %rbp
  802495:	c3                   	ret    

0000000000802496 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  802496:	48 85 d2             	test   %rdx,%rdx
  802499:	74 1d                	je     8024b8 <strncpy+0x22>
  80249b:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80249f:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  8024a2:	48 83 c0 01          	add    $0x1,%rax
  8024a6:	0f b6 16             	movzbl (%rsi),%edx
  8024a9:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8024ac:	80 fa 01             	cmp    $0x1,%dl
  8024af:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8024b3:	48 39 c1             	cmp    %rax,%rcx
  8024b6:	75 ea                	jne    8024a2 <strncpy+0xc>
    }
    return ret;
}
  8024b8:	48 89 f8             	mov    %rdi,%rax
  8024bb:	c3                   	ret    

00000000008024bc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  8024bc:	48 89 f8             	mov    %rdi,%rax
  8024bf:	48 85 d2             	test   %rdx,%rdx
  8024c2:	74 24                	je     8024e8 <strlcpy+0x2c>
        while (--size > 0 && *src)
  8024c4:	48 83 ea 01          	sub    $0x1,%rdx
  8024c8:	74 1b                	je     8024e5 <strlcpy+0x29>
  8024ca:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8024ce:	0f b6 16             	movzbl (%rsi),%edx
  8024d1:	84 d2                	test   %dl,%dl
  8024d3:	74 10                	je     8024e5 <strlcpy+0x29>
            *dst++ = *src++;
  8024d5:	48 83 c6 01          	add    $0x1,%rsi
  8024d9:	48 83 c0 01          	add    $0x1,%rax
  8024dd:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  8024e0:	48 39 c8             	cmp    %rcx,%rax
  8024e3:	75 e9                	jne    8024ce <strlcpy+0x12>
        *dst = '\0';
  8024e5:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  8024e8:	48 29 f8             	sub    %rdi,%rax
}
  8024eb:	c3                   	ret    

00000000008024ec <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  8024ec:	0f b6 07             	movzbl (%rdi),%eax
  8024ef:	84 c0                	test   %al,%al
  8024f1:	74 13                	je     802506 <strcmp+0x1a>
  8024f3:	38 06                	cmp    %al,(%rsi)
  8024f5:	75 0f                	jne    802506 <strcmp+0x1a>
  8024f7:	48 83 c7 01          	add    $0x1,%rdi
  8024fb:	48 83 c6 01          	add    $0x1,%rsi
  8024ff:	0f b6 07             	movzbl (%rdi),%eax
  802502:	84 c0                	test   %al,%al
  802504:	75 ed                	jne    8024f3 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  802506:	0f b6 c0             	movzbl %al,%eax
  802509:	0f b6 16             	movzbl (%rsi),%edx
  80250c:	29 d0                	sub    %edx,%eax
}
  80250e:	c3                   	ret    

000000000080250f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  80250f:	48 85 d2             	test   %rdx,%rdx
  802512:	74 1f                	je     802533 <strncmp+0x24>
  802514:	0f b6 07             	movzbl (%rdi),%eax
  802517:	84 c0                	test   %al,%al
  802519:	74 1e                	je     802539 <strncmp+0x2a>
  80251b:	3a 06                	cmp    (%rsi),%al
  80251d:	75 1a                	jne    802539 <strncmp+0x2a>
  80251f:	48 83 c7 01          	add    $0x1,%rdi
  802523:	48 83 c6 01          	add    $0x1,%rsi
  802527:	48 83 ea 01          	sub    $0x1,%rdx
  80252b:	75 e7                	jne    802514 <strncmp+0x5>

    if (!n) return 0;
  80252d:	b8 00 00 00 00       	mov    $0x0,%eax
  802532:	c3                   	ret    
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	c3                   	ret    
  802539:	48 85 d2             	test   %rdx,%rdx
  80253c:	74 09                	je     802547 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  80253e:	0f b6 07             	movzbl (%rdi),%eax
  802541:	0f b6 16             	movzbl (%rsi),%edx
  802544:	29 d0                	sub    %edx,%eax
  802546:	c3                   	ret    
    if (!n) return 0;
  802547:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80254c:	c3                   	ret    

000000000080254d <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  80254d:	0f b6 07             	movzbl (%rdi),%eax
  802550:	84 c0                	test   %al,%al
  802552:	74 18                	je     80256c <strchr+0x1f>
        if (*str == c) {
  802554:	0f be c0             	movsbl %al,%eax
  802557:	39 f0                	cmp    %esi,%eax
  802559:	74 17                	je     802572 <strchr+0x25>
    for (; *str; str++) {
  80255b:	48 83 c7 01          	add    $0x1,%rdi
  80255f:	0f b6 07             	movzbl (%rdi),%eax
  802562:	84 c0                	test   %al,%al
  802564:	75 ee                	jne    802554 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  802566:	b8 00 00 00 00       	mov    $0x0,%eax
  80256b:	c3                   	ret    
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
  802571:	c3                   	ret    
  802572:	48 89 f8             	mov    %rdi,%rax
}
  802575:	c3                   	ret    

0000000000802576 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  802576:	0f b6 07             	movzbl (%rdi),%eax
  802579:	84 c0                	test   %al,%al
  80257b:	74 16                	je     802593 <strfind+0x1d>
  80257d:	0f be c0             	movsbl %al,%eax
  802580:	39 f0                	cmp    %esi,%eax
  802582:	74 13                	je     802597 <strfind+0x21>
  802584:	48 83 c7 01          	add    $0x1,%rdi
  802588:	0f b6 07             	movzbl (%rdi),%eax
  80258b:	84 c0                	test   %al,%al
  80258d:	75 ee                	jne    80257d <strfind+0x7>
  80258f:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  802592:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  802593:	48 89 f8             	mov    %rdi,%rax
  802596:	c3                   	ret    
  802597:	48 89 f8             	mov    %rdi,%rax
  80259a:	c3                   	ret    

000000000080259b <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80259b:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80259e:	48 89 f8             	mov    %rdi,%rax
  8025a1:	48 f7 d8             	neg    %rax
  8025a4:	83 e0 07             	and    $0x7,%eax
  8025a7:	49 89 d1             	mov    %rdx,%r9
  8025aa:	49 29 c1             	sub    %rax,%r9
  8025ad:	78 32                	js     8025e1 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8025af:	40 0f b6 c6          	movzbl %sil,%eax
  8025b3:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  8025ba:	01 01 01 
  8025bd:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  8025c1:	40 f6 c7 07          	test   $0x7,%dil
  8025c5:	75 34                	jne    8025fb <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  8025c7:	4c 89 c9             	mov    %r9,%rcx
  8025ca:	48 c1 f9 03          	sar    $0x3,%rcx
  8025ce:	74 08                	je     8025d8 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8025d0:	fc                   	cld    
  8025d1:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8025d4:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8025d8:	4d 85 c9             	test   %r9,%r9
  8025db:	75 45                	jne    802622 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8025dd:	4c 89 c0             	mov    %r8,%rax
  8025e0:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  8025e1:	48 85 d2             	test   %rdx,%rdx
  8025e4:	74 f7                	je     8025dd <memset+0x42>
  8025e6:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  8025e9:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8025ec:	48 83 c0 01          	add    $0x1,%rax
  8025f0:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8025f4:	48 39 c2             	cmp    %rax,%rdx
  8025f7:	75 f3                	jne    8025ec <memset+0x51>
  8025f9:	eb e2                	jmp    8025dd <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8025fb:	40 f6 c7 01          	test   $0x1,%dil
  8025ff:	74 06                	je     802607 <memset+0x6c>
  802601:	88 07                	mov    %al,(%rdi)
  802603:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  802607:	40 f6 c7 02          	test   $0x2,%dil
  80260b:	74 07                	je     802614 <memset+0x79>
  80260d:	66 89 07             	mov    %ax,(%rdi)
  802610:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  802614:	40 f6 c7 04          	test   $0x4,%dil
  802618:	74 ad                	je     8025c7 <memset+0x2c>
  80261a:	89 07                	mov    %eax,(%rdi)
  80261c:	48 83 c7 04          	add    $0x4,%rdi
  802620:	eb a5                	jmp    8025c7 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  802622:	41 f6 c1 04          	test   $0x4,%r9b
  802626:	74 06                	je     80262e <memset+0x93>
  802628:	89 07                	mov    %eax,(%rdi)
  80262a:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80262e:	41 f6 c1 02          	test   $0x2,%r9b
  802632:	74 07                	je     80263b <memset+0xa0>
  802634:	66 89 07             	mov    %ax,(%rdi)
  802637:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80263b:	41 f6 c1 01          	test   $0x1,%r9b
  80263f:	74 9c                	je     8025dd <memset+0x42>
  802641:	88 07                	mov    %al,(%rdi)
  802643:	eb 98                	jmp    8025dd <memset+0x42>

0000000000802645 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  802645:	48 89 f8             	mov    %rdi,%rax
  802648:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  80264b:	48 39 fe             	cmp    %rdi,%rsi
  80264e:	73 39                	jae    802689 <memmove+0x44>
  802650:	48 01 f2             	add    %rsi,%rdx
  802653:	48 39 fa             	cmp    %rdi,%rdx
  802656:	76 31                	jbe    802689 <memmove+0x44>
        s += n;
        d += n;
  802658:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80265b:	48 89 d6             	mov    %rdx,%rsi
  80265e:	48 09 fe             	or     %rdi,%rsi
  802661:	48 09 ce             	or     %rcx,%rsi
  802664:	40 f6 c6 07          	test   $0x7,%sil
  802668:	75 12                	jne    80267c <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80266a:	48 83 ef 08          	sub    $0x8,%rdi
  80266e:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  802672:	48 c1 e9 03          	shr    $0x3,%rcx
  802676:	fd                   	std    
  802677:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80267a:	fc                   	cld    
  80267b:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80267c:	48 83 ef 01          	sub    $0x1,%rdi
  802680:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  802684:	fd                   	std    
  802685:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  802687:	eb f1                	jmp    80267a <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802689:	48 89 f2             	mov    %rsi,%rdx
  80268c:	48 09 c2             	or     %rax,%rdx
  80268f:	48 09 ca             	or     %rcx,%rdx
  802692:	f6 c2 07             	test   $0x7,%dl
  802695:	75 0c                	jne    8026a3 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  802697:	48 c1 e9 03          	shr    $0x3,%rcx
  80269b:	48 89 c7             	mov    %rax,%rdi
  80269e:	fc                   	cld    
  80269f:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8026a2:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8026a3:	48 89 c7             	mov    %rax,%rdi
  8026a6:	fc                   	cld    
  8026a7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8026a9:	c3                   	ret    

00000000008026aa <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8026aa:	55                   	push   %rbp
  8026ab:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8026ae:	48 b8 45 26 80 00 00 	movabs $0x802645,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	call   *%rax
}
  8026ba:	5d                   	pop    %rbp
  8026bb:	c3                   	ret    

00000000008026bc <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8026bc:	55                   	push   %rbp
  8026bd:	48 89 e5             	mov    %rsp,%rbp
  8026c0:	41 57                	push   %r15
  8026c2:	41 56                	push   %r14
  8026c4:	41 55                	push   %r13
  8026c6:	41 54                	push   %r12
  8026c8:	53                   	push   %rbx
  8026c9:	48 83 ec 08          	sub    $0x8,%rsp
  8026cd:	49 89 fe             	mov    %rdi,%r14
  8026d0:	49 89 f7             	mov    %rsi,%r15
  8026d3:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8026d6:	48 89 f7             	mov    %rsi,%rdi
  8026d9:	48 b8 11 24 80 00 00 	movabs $0x802411,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	call   *%rax
  8026e5:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8026e8:	48 89 de             	mov    %rbx,%rsi
  8026eb:	4c 89 f7             	mov    %r14,%rdi
  8026ee:	48 b8 2c 24 80 00 00 	movabs $0x80242c,%rax
  8026f5:	00 00 00 
  8026f8:	ff d0                	call   *%rax
  8026fa:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8026fd:	48 39 c3             	cmp    %rax,%rbx
  802700:	74 36                	je     802738 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  802702:	48 89 d8             	mov    %rbx,%rax
  802705:	4c 29 e8             	sub    %r13,%rax
  802708:	4c 39 e0             	cmp    %r12,%rax
  80270b:	76 30                	jbe    80273d <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  80270d:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  802712:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  802716:	4c 89 fe             	mov    %r15,%rsi
  802719:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802720:	00 00 00 
  802723:	ff d0                	call   *%rax
    return dstlen + srclen;
  802725:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  802729:	48 83 c4 08          	add    $0x8,%rsp
  80272d:	5b                   	pop    %rbx
  80272e:	41 5c                	pop    %r12
  802730:	41 5d                	pop    %r13
  802732:	41 5e                	pop    %r14
  802734:	41 5f                	pop    %r15
  802736:	5d                   	pop    %rbp
  802737:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  802738:	4c 01 e0             	add    %r12,%rax
  80273b:	eb ec                	jmp    802729 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  80273d:	48 83 eb 01          	sub    $0x1,%rbx
  802741:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  802745:	48 89 da             	mov    %rbx,%rdx
  802748:	4c 89 fe             	mov    %r15,%rsi
  80274b:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802752:	00 00 00 
  802755:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  802757:	49 01 de             	add    %rbx,%r14
  80275a:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  80275f:	eb c4                	jmp    802725 <strlcat+0x69>

0000000000802761 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  802761:	49 89 f0             	mov    %rsi,%r8
  802764:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  802767:	48 85 d2             	test   %rdx,%rdx
  80276a:	74 2a                	je     802796 <memcmp+0x35>
  80276c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  802771:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  802775:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80277a:	38 ca                	cmp    %cl,%dl
  80277c:	75 0f                	jne    80278d <memcmp+0x2c>
    while (n-- > 0) {
  80277e:	48 83 c0 01          	add    $0x1,%rax
  802782:	48 39 c6             	cmp    %rax,%rsi
  802785:	75 ea                	jne    802771 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  802787:	b8 00 00 00 00       	mov    $0x0,%eax
  80278c:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  80278d:	0f b6 c2             	movzbl %dl,%eax
  802790:	0f b6 c9             	movzbl %cl,%ecx
  802793:	29 c8                	sub    %ecx,%eax
  802795:	c3                   	ret    
    return 0;
  802796:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80279b:	c3                   	ret    

000000000080279c <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80279c:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8027a0:	48 39 c7             	cmp    %rax,%rdi
  8027a3:	73 0f                	jae    8027b4 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8027a5:	40 38 37             	cmp    %sil,(%rdi)
  8027a8:	74 0e                	je     8027b8 <memfind+0x1c>
    for (; src < end; src++) {
  8027aa:	48 83 c7 01          	add    $0x1,%rdi
  8027ae:	48 39 f8             	cmp    %rdi,%rax
  8027b1:	75 f2                	jne    8027a5 <memfind+0x9>
  8027b3:	c3                   	ret    
  8027b4:	48 89 f8             	mov    %rdi,%rax
  8027b7:	c3                   	ret    
  8027b8:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8027bb:	c3                   	ret    

00000000008027bc <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8027bc:	49 89 f2             	mov    %rsi,%r10
  8027bf:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8027c2:	0f b6 37             	movzbl (%rdi),%esi
  8027c5:	40 80 fe 20          	cmp    $0x20,%sil
  8027c9:	74 06                	je     8027d1 <strtol+0x15>
  8027cb:	40 80 fe 09          	cmp    $0x9,%sil
  8027cf:	75 13                	jne    8027e4 <strtol+0x28>
  8027d1:	48 83 c7 01          	add    $0x1,%rdi
  8027d5:	0f b6 37             	movzbl (%rdi),%esi
  8027d8:	40 80 fe 20          	cmp    $0x20,%sil
  8027dc:	74 f3                	je     8027d1 <strtol+0x15>
  8027de:	40 80 fe 09          	cmp    $0x9,%sil
  8027e2:	74 ed                	je     8027d1 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8027e4:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8027e7:	83 e0 fd             	and    $0xfffffffd,%eax
  8027ea:	3c 01                	cmp    $0x1,%al
  8027ec:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8027f0:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  8027f7:	75 11                	jne    80280a <strtol+0x4e>
  8027f9:	80 3f 30             	cmpb   $0x30,(%rdi)
  8027fc:	74 16                	je     802814 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8027fe:	45 85 c0             	test   %r8d,%r8d
  802801:	b8 0a 00 00 00       	mov    $0xa,%eax
  802806:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  80280a:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80280f:	4d 63 c8             	movslq %r8d,%r9
  802812:	eb 38                	jmp    80284c <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802814:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  802818:	74 11                	je     80282b <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  80281a:	45 85 c0             	test   %r8d,%r8d
  80281d:	75 eb                	jne    80280a <strtol+0x4e>
        s++;
  80281f:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  802823:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  802829:	eb df                	jmp    80280a <strtol+0x4e>
        s += 2;
  80282b:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  80282f:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  802835:	eb d3                	jmp    80280a <strtol+0x4e>
            dig -= '0';
  802837:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  80283a:	0f b6 c8             	movzbl %al,%ecx
  80283d:	44 39 c1             	cmp    %r8d,%ecx
  802840:	7d 1f                	jge    802861 <strtol+0xa5>
        val = val * base + dig;
  802842:	49 0f af d1          	imul   %r9,%rdx
  802846:	0f b6 c0             	movzbl %al,%eax
  802849:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  80284c:	48 83 c7 01          	add    $0x1,%rdi
  802850:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  802854:	3c 39                	cmp    $0x39,%al
  802856:	76 df                	jbe    802837 <strtol+0x7b>
        else if (dig - 'a' < 27)
  802858:	3c 7b                	cmp    $0x7b,%al
  80285a:	77 05                	ja     802861 <strtol+0xa5>
            dig -= 'a' - 10;
  80285c:	83 e8 57             	sub    $0x57,%eax
  80285f:	eb d9                	jmp    80283a <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  802861:	4d 85 d2             	test   %r10,%r10
  802864:	74 03                	je     802869 <strtol+0xad>
  802866:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802869:	48 89 d0             	mov    %rdx,%rax
  80286c:	48 f7 d8             	neg    %rax
  80286f:	40 80 fe 2d          	cmp    $0x2d,%sil
  802873:	48 0f 44 d0          	cmove  %rax,%rdx
}
  802877:	48 89 d0             	mov    %rdx,%rax
  80287a:	c3                   	ret    

000000000080287b <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  80287b:	55                   	push   %rbp
  80287c:	48 89 e5             	mov    %rsp,%rbp
  80287f:	41 56                	push   %r14
  802881:	41 55                	push   %r13
  802883:	41 54                	push   %r12
  802885:	53                   	push   %rbx
  802886:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  802889:	48 b8 68 70 80 00 00 	movabs $0x807068,%rax
  802890:	00 00 00 
  802893:	48 83 38 00          	cmpq   $0x0,(%rax)
  802897:	74 27                	je     8028c0 <_handle_vectored_pagefault+0x45>
  802899:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  80289e:	49 bd 20 70 80 00 00 	movabs $0x807020,%r13
  8028a5:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8028a8:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  8028ab:	4c 89 e7             	mov    %r12,%rdi
  8028ae:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  8028b3:	84 c0                	test   %al,%al
  8028b5:	75 45                	jne    8028fc <_handle_vectored_pagefault+0x81>
    for (size_t i = 0; i < _pfhandler_off; i++)
  8028b7:	48 83 c3 01          	add    $0x1,%rbx
  8028bb:	49 39 1e             	cmp    %rbx,(%r14)
  8028be:	77 eb                	ja     8028ab <_handle_vectored_pagefault+0x30>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  8028c0:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  8028c7:	00 
  8028c8:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  8028cd:	4d 8b 04 24          	mov    (%r12),%r8
  8028d1:	48 ba 60 33 80 00 00 	movabs $0x803360,%rdx
  8028d8:	00 00 00 
  8028db:	be 1d 00 00 00       	mov    $0x1d,%esi
  8028e0:	48 bf 90 33 80 00 00 	movabs $0x803390,%rdi
  8028e7:	00 00 00 
  8028ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ef:	49 ba b9 19 80 00 00 	movabs $0x8019b9,%r10
  8028f6:	00 00 00 
  8028f9:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  8028fc:	5b                   	pop    %rbx
  8028fd:	41 5c                	pop    %r12
  8028ff:	41 5d                	pop    %r13
  802901:	41 5e                	pop    %r14
  802903:	5d                   	pop    %rbp
  802904:	c3                   	ret    

0000000000802905 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  802905:	55                   	push   %rbp
  802906:	48 89 e5             	mov    %rsp,%rbp
  802909:	53                   	push   %rbx
  80290a:	48 83 ec 08          	sub    $0x8,%rsp
  80290e:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  802911:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802918:	00 00 00 
  80291b:	80 38 00             	cmpb   $0x0,(%rax)
  80291e:	74 58                	je     802978 <add_pgfault_handler+0x73>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  802920:	48 b8 68 70 80 00 00 	movabs $0x807068,%rax
  802927:	00 00 00 
  80292a:	48 8b 10             	mov    (%rax),%rdx
  80292d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  802932:	48 b9 20 70 80 00 00 	movabs $0x807020,%rcx
  802939:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  80293c:	48 85 d2             	test   %rdx,%rdx
  80293f:	74 19                	je     80295a <add_pgfault_handler+0x55>
        if (handler == _pfhandler_vec[i]) return 0;
  802941:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  802945:	0f 84 16 01 00 00    	je     802a61 <add_pgfault_handler+0x15c>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80294b:	48 83 c0 01          	add    $0x1,%rax
  80294f:	48 39 d0             	cmp    %rdx,%rax
  802952:	75 ed                	jne    802941 <add_pgfault_handler+0x3c>

    if (_pfhandler_off == MAX_PFHANDLER)
  802954:	48 83 fa 08          	cmp    $0x8,%rdx
  802958:	74 7f                	je     8029d9 <add_pgfault_handler+0xd4>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  80295a:	48 8d 42 01          	lea    0x1(%rdx),%rax
  80295e:	48 a3 68 70 80 00 00 	movabs %rax,0x807068
  802965:	00 00 00 
  802968:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80296f:	00 00 00 
  802972:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)
  802976:	eb 61                	jmp    8029d9 <add_pgfault_handler+0xd4>
        res = sys_alloc_region(sys_getenvid(), (void *)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  802978:	48 b8 eb 01 80 00 00 	movabs $0x8001eb,%rax
  80297f:	00 00 00 
  802982:	ff d0                	call   *%rax
  802984:	89 c7                	mov    %eax,%edi
  802986:	b9 06 00 00 00       	mov    $0x6,%ecx
  80298b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802990:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  802997:	00 00 00 
  80299a:	48 b8 ab 02 80 00 00 	movabs $0x8002ab,%rax
  8029a1:	00 00 00 
  8029a4:	ff d0                	call   *%rax
        if (res < 0)
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	78 5d                	js     802a07 <add_pgfault_handler+0x102>
        _pfhandler_vec[_pfhandler_off++] = handler;
  8029aa:	48 ba 68 70 80 00 00 	movabs $0x807068,%rdx
  8029b1:	00 00 00 
  8029b4:	48 8b 02             	mov    (%rdx),%rax
  8029b7:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8029bb:	48 89 0a             	mov    %rcx,(%rdx)
  8029be:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  8029c5:	00 00 00 
  8029c8:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  8029cc:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8029d3:	00 00 00 
  8029d6:	c6 00 01             	movb   $0x1,(%rax)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8029d9:	48 b8 eb 01 80 00 00 	movabs $0x8001eb,%rax
  8029e0:	00 00 00 
  8029e3:	ff d0                	call   *%rax
  8029e5:	89 c7                	mov    %eax,%edi
  8029e7:	48 be 10 06 80 00 00 	movabs $0x800610,%rsi
  8029ee:	00 00 00 
  8029f1:	48 b8 b0 04 80 00 00 	movabs $0x8004b0,%rax
  8029f8:	00 00 00 
  8029fb:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	78 33                	js     802a34 <add_pgfault_handler+0x12f>
    return res;
}
  802a01:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802a05:	c9                   	leave  
  802a06:	c3                   	ret    
            panic("sys_alloc_region: %i", res);
  802a07:	89 c1                	mov    %eax,%ecx
  802a09:	48 ba 9e 33 80 00 00 	movabs $0x80339e,%rdx
  802a10:	00 00 00 
  802a13:	be 2f 00 00 00       	mov    $0x2f,%esi
  802a18:	48 bf 90 33 80 00 00 	movabs $0x803390,%rdi
  802a1f:	00 00 00 
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
  802a27:	49 b8 b9 19 80 00 00 	movabs $0x8019b9,%r8
  802a2e:	00 00 00 
  802a31:	41 ff d0             	call   *%r8
    if (res < 0) panic("set_pgfault_handler: %i", res);
  802a34:	89 c1                	mov    %eax,%ecx
  802a36:	48 ba b3 33 80 00 00 	movabs $0x8033b3,%rdx
  802a3d:	00 00 00 
  802a40:	be 3f 00 00 00       	mov    $0x3f,%esi
  802a45:	48 bf 90 33 80 00 00 	movabs $0x803390,%rdi
  802a4c:	00 00 00 
  802a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a54:	49 b8 b9 19 80 00 00 	movabs $0x8019b9,%r8
  802a5b:	00 00 00 
  802a5e:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  802a61:	b8 00 00 00 00       	mov    $0x0,%eax
  802a66:	eb 99                	jmp    802a01 <add_pgfault_handler+0xfc>

0000000000802a68 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  802a68:	55                   	push   %rbp
  802a69:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  802a6c:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802a73:	00 00 00 
  802a76:	80 38 00             	cmpb   $0x0,(%rax)
  802a79:	74 33                	je     802aae <remove_pgfault_handler+0x46>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  802a7b:	48 a1 68 70 80 00 00 	movabs 0x807068,%rax
  802a82:	00 00 00 
  802a85:	ba 00 00 00 00       	mov    $0x0,%edx
        if (_pfhandler_vec[i] == handler) {
  802a8a:	48 b9 20 70 80 00 00 	movabs $0x807020,%rcx
  802a91:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  802a94:	48 85 c0             	test   %rax,%rax
  802a97:	0f 84 85 00 00 00    	je     802b22 <remove_pgfault_handler+0xba>
        if (_pfhandler_vec[i] == handler) {
  802a9d:	48 39 3c d1          	cmp    %rdi,(%rcx,%rdx,8)
  802aa1:	74 40                	je     802ae3 <remove_pgfault_handler+0x7b>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  802aa3:	48 83 c2 01          	add    $0x1,%rdx
  802aa7:	48 39 c2             	cmp    %rax,%rdx
  802aaa:	75 f1                	jne    802a9d <remove_pgfault_handler+0x35>
  802aac:	eb 74                	jmp    802b22 <remove_pgfault_handler+0xba>
    assert(_pfhandler_inititiallized);
  802aae:	48 b9 cb 33 80 00 00 	movabs $0x8033cb,%rcx
  802ab5:	00 00 00 
  802ab8:	48 ba c7 2d 80 00 00 	movabs $0x802dc7,%rdx
  802abf:	00 00 00 
  802ac2:	be 45 00 00 00       	mov    $0x45,%esi
  802ac7:	48 bf 90 33 80 00 00 	movabs $0x803390,%rdi
  802ace:	00 00 00 
  802ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad6:	49 b8 b9 19 80 00 00 	movabs $0x8019b9,%r8
  802add:	00 00 00 
  802ae0:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  802ae3:	48 8d 0c d5 08 00 00 	lea    0x8(,%rdx,8),%rcx
  802aea:	00 
  802aeb:	48 83 e8 01          	sub    $0x1,%rax
  802aef:	48 29 d0             	sub    %rdx,%rax
  802af2:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  802af9:	00 00 00 
  802afc:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
  802b00:	48 8d 7c 0a f8       	lea    -0x8(%rdx,%rcx,1),%rdi
  802b05:	48 89 c2             	mov    %rax,%rdx
  802b08:	48 b8 45 26 80 00 00 	movabs $0x802645,%rax
  802b0f:	00 00 00 
  802b12:	ff d0                	call   *%rax
            _pfhandler_off--;
  802b14:	48 b8 68 70 80 00 00 	movabs $0x807068,%rax
  802b1b:	00 00 00 
  802b1e:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  802b22:	5d                   	pop    %rbp
  802b23:	c3                   	ret    

0000000000802b24 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802b24:	55                   	push   %rbp
  802b25:	48 89 e5             	mov    %rsp,%rbp
  802b28:	41 54                	push   %r12
  802b2a:	53                   	push   %rbx
  802b2b:	48 89 fb             	mov    %rdi,%rbx
  802b2e:	48 89 f7             	mov    %rsi,%rdi
  802b31:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802b34:	48 85 f6             	test   %rsi,%rsi
  802b37:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b3e:	00 00 00 
  802b41:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802b45:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802b4a:	48 85 d2             	test   %rdx,%rdx
  802b4d:	74 02                	je     802b51 <ipc_recv+0x2d>
  802b4f:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802b51:	48 63 f6             	movslq %esi,%rsi
  802b54:	48 b8 45 05 80 00 00 	movabs $0x800545,%rax
  802b5b:	00 00 00 
  802b5e:	ff d0                	call   *%rax

    if (res < 0) {
  802b60:	85 c0                	test   %eax,%eax
  802b62:	78 45                	js     802ba9 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802b64:	48 85 db             	test   %rbx,%rbx
  802b67:	74 12                	je     802b7b <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802b69:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b70:	00 00 00 
  802b73:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b79:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802b7b:	4d 85 e4             	test   %r12,%r12
  802b7e:	74 14                	je     802b94 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802b80:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b87:	00 00 00 
  802b8a:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b90:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802b94:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b9b:	00 00 00 
  802b9e:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802ba4:	5b                   	pop    %rbx
  802ba5:	41 5c                	pop    %r12
  802ba7:	5d                   	pop    %rbp
  802ba8:	c3                   	ret    
        if (from_env_store)
  802ba9:	48 85 db             	test   %rbx,%rbx
  802bac:	74 06                	je     802bb4 <ipc_recv+0x90>
            *from_env_store = 0;
  802bae:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802bb4:	4d 85 e4             	test   %r12,%r12
  802bb7:	74 eb                	je     802ba4 <ipc_recv+0x80>
            *perm_store = 0;
  802bb9:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802bc0:	00 
  802bc1:	eb e1                	jmp    802ba4 <ipc_recv+0x80>

0000000000802bc3 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802bc3:	55                   	push   %rbp
  802bc4:	48 89 e5             	mov    %rsp,%rbp
  802bc7:	41 57                	push   %r15
  802bc9:	41 56                	push   %r14
  802bcb:	41 55                	push   %r13
  802bcd:	41 54                	push   %r12
  802bcf:	53                   	push   %rbx
  802bd0:	48 83 ec 18          	sub    $0x18,%rsp
  802bd4:	41 89 fd             	mov    %edi,%r13d
  802bd7:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802bda:	48 89 d3             	mov    %rdx,%rbx
  802bdd:	49 89 cc             	mov    %rcx,%r12
  802be0:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802be4:	48 85 d2             	test   %rdx,%rdx
  802be7:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bee:	00 00 00 
  802bf1:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802bf5:	49 be 19 05 80 00 00 	movabs $0x800519,%r14
  802bfc:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802bff:	49 bf 1c 02 80 00 00 	movabs $0x80021c,%r15
  802c06:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802c09:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802c0c:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802c10:	4c 89 e1             	mov    %r12,%rcx
  802c13:	48 89 da             	mov    %rbx,%rdx
  802c16:	44 89 ef             	mov    %r13d,%edi
  802c19:	41 ff d6             	call   *%r14
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	79 37                	jns    802c57 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c20:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c23:	75 05                	jne    802c2a <ipc_send+0x67>
          sys_yield();
  802c25:	41 ff d7             	call   *%r15
  802c28:	eb df                	jmp    802c09 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802c2a:	89 c1                	mov    %eax,%ecx
  802c2c:	48 ba e5 33 80 00 00 	movabs $0x8033e5,%rdx
  802c33:	00 00 00 
  802c36:	be 46 00 00 00       	mov    $0x46,%esi
  802c3b:	48 bf f8 33 80 00 00 	movabs $0x8033f8,%rdi
  802c42:	00 00 00 
  802c45:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4a:	49 b8 b9 19 80 00 00 	movabs $0x8019b9,%r8
  802c51:	00 00 00 
  802c54:	41 ff d0             	call   *%r8
      }
}
  802c57:	48 83 c4 18          	add    $0x18,%rsp
  802c5b:	5b                   	pop    %rbx
  802c5c:	41 5c                	pop    %r12
  802c5e:	41 5d                	pop    %r13
  802c60:	41 5e                	pop    %r14
  802c62:	41 5f                	pop    %r15
  802c64:	5d                   	pop    %rbp
  802c65:	c3                   	ret    

0000000000802c66 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802c66:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c6b:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802c72:	00 00 00 
  802c75:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c79:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c7d:	48 c1 e2 04          	shl    $0x4,%rdx
  802c81:	48 01 ca             	add    %rcx,%rdx
  802c84:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c8a:	39 fa                	cmp    %edi,%edx
  802c8c:	74 12                	je     802ca0 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802c8e:	48 83 c0 01          	add    $0x1,%rax
  802c92:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c98:	75 db                	jne    802c75 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802c9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c9f:	c3                   	ret    
            return envs[i].env_id;
  802ca0:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802ca4:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802ca8:	48 c1 e0 04          	shl    $0x4,%rax
  802cac:	48 89 c2             	mov    %rax,%rdx
  802caf:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802cb6:	00 00 00 
  802cb9:	48 01 d0             	add    %rdx,%rax
  802cbc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cc2:	c3                   	ret    
  802cc3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000802cc8 <__rodata_start>:
  802cc8:	3c 75                	cmp    $0x75,%al
  802cca:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ccb:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802ccf:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cd0:	3e 00 66 0f          	ds add %ah,0xf(%rsi)
  802cd4:	1f                   	(bad)  
  802cd5:	44 00 00             	add    %r8b,(%rax)
  802cd8:	73 79                	jae    802d53 <__rodata_start+0x8b>
  802cda:	73 63                	jae    802d3f <__rodata_start+0x77>
  802cdc:	61                   	(bad)  
  802cdd:	6c                   	insb   (%dx),%es:(%rdi)
  802cde:	6c                   	insb   (%dx),%es:(%rdi)
  802cdf:	20 25 7a 64 20 72    	and    %ah,0x7220647a(%rip)        # 72a0915f <__bss_end+0x7220115f>
  802ce5:	65 74 75             	gs je  802d5d <__rodata_start+0x95>
  802ce8:	72 6e                	jb     802d58 <__rodata_start+0x90>
  802cea:	65 64 20 25 7a 64 20 	gs and %ah,%fs:0x2820647a(%rip)        # 28a0916c <__bss_end+0x2820116c>
  802cf1:	28 
  802cf2:	3e 20 30             	ds and %dh,(%rax)
  802cf5:	29 00                	sub    %eax,(%rax)
  802cf7:	6c                   	insb   (%dx),%es:(%rdi)
  802cf8:	69 62 2f 73 79 73 63 	imul   $0x63737973,0x2f(%rdx),%esp
  802cff:	61                   	(bad)  
  802d00:	6c                   	insb   (%dx),%es:(%rdi)
  802d01:	6c                   	insb   (%dx),%es:(%rdi)
  802d02:	2e 63 00             	cs movsxd (%rax),%eax
  802d05:	0f 1f 00             	nopl   (%rax)
  802d08:	5b                   	pop    %rbx
  802d09:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802d0e:	20 75 6e             	and    %dh,0x6e(%rbp)
  802d11:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802d15:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d16:	20 64 65 76          	and    %ah,0x76(%rbp,%riz,2)
  802d1a:	69 63 65 20 74 79 70 	imul   $0x70797420,0x65(%rbx),%esp
  802d21:	65 20 25 64 0a 00 00 	and    %ah,%gs:0xa64(%rip)        # 80378c <error_string+0x4ec>
  802d28:	5b                   	pop    %rbx
  802d29:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802d2e:	20 66 74             	and    %ah,0x74(%rsi)
  802d31:	72 75                	jb     802da8 <devtab+0x8>
  802d33:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d34:	63 61 74             	movsxd 0x74(%rcx),%esp
  802d37:	65 20 25 64 20 2d 2d 	and    %ah,%gs:0x2d2d2064(%rip)        # 2dad4da2 <__bss_end+0x2d2ccda2>
  802d3e:	20 62 61             	and    %ah,0x61(%rdx)
  802d41:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802d45:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802d49:	5b                   	pop    %rbx
  802d4a:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802d4f:	20 72 65             	and    %dh,0x65(%rdx)
  802d52:	61                   	(bad)  
  802d53:	64 20 25 64 20 2d 2d 	and    %ah,%fs:0x2d2d2064(%rip)        # 2dad4dbe <__bss_end+0x2d2ccdbe>
  802d5a:	20 62 61             	and    %ah,0x61(%rdx)
  802d5d:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802d61:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802d65:	5b                   	pop    %rbx
  802d66:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802d6b:	20 77 72             	and    %dh,0x72(%rdi)
  802d6e:	69 74 65 20 25 64 20 	imul   $0x2d206425,0x20(%rbp,%riz,2),%esi
  802d75:	2d 
  802d76:	2d 20 62 61 64       	sub    $0x64616220,%eax
  802d7b:	20 6d 6f             	and    %ch,0x6f(%rbp)
  802d7e:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802d82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d89:	00 00 00 
  802d8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d93:	00 00 00 
  802d96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d9d:	00 00 00 

0000000000802da0 <devtab>:
  802da0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  802db0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  802dc0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  802dd0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  802de0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  802df0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  802e00:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  802e10:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  802e20:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  802e30:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  802e40:	3a 20 00 30 31 32 33 34 35 36 37 38 39 41 42 43     : .0123456789ABC
  802e50:	44 45 46 00 30 31 32 33 34 35 36 37 38 39 61 62     DEF.0123456789ab
  802e60:	63 64 65 66 00 28 6e 75 6c 6c 29 00 65 72 72 6f     cdef.(null).erro
  802e70:	72 20 25 64 00 75 6e 73 70 65 63 69 66 69 65 64     r %d.unspecified
  802e80:	20 65 72 72 6f 72 00 62 61 64 20 65 6e 76 69 72      error.bad envir
  802e90:	6f 6e 6d 65 6e 74 00 69 6e 76 61 6c 69 64 20 70     onment.invalid p
  802ea0:	61 72 61 6d 65 74 65 72 00 6f 75 74 20 6f 66 20     arameter.out of 
  802eb0:	6d 65 6d 6f 72 79 00 6f 75 74 20 6f 66 20 65 6e     memory.out of en
  802ec0:	76 69 72 6f 6e 6d 65 6e 74 73 00 63 6f 72 72 75     vironments.corru
  802ed0:	70 74 65 64 20 64 65 62 75 67 20 69 6e 66 6f 00     pted debug info.
  802ee0:	73 65 67 6d 65 6e 74 61 74 69 6f 6e 20 66 61 75     segmentation fau
  802ef0:	6c 74 00 69 6e 76 61 6c 69 64 20 45 4c 46 20 69     lt.invalid ELF i
  802f00:	6d 61 67 65 00 6e 6f 20 73 75 63 68 20 73 79 73     mage.no such sys
  802f10:	74 65 6d 20 63 61 6c 6c 00 65 6e 74 72 79 20 6e     tem call.entry n
  802f20:	6f 74 20 66 6f 75 6e 64 00 65 6e 76 20 69 73 20     ot found.env is 
  802f30:	6e 6f 74 20 72 65 63 76 69 6e 67 00 75 6e 65 78     not recving.unex
  802f40:	70 65 63 74 65 64 20 65 6e 64 20 6f 66 20 66 69     pected end of fi
  802f50:	6c 65 00 6e 6f 20 66 72 65 65 20 73 70 61 63 65     le.no free space
  802f60:	20 6f 6e 20 64 69 73 6b 00 74 6f 6f 20 6d 61 6e      on disk.too man
  802f70:	79 20 66 69 6c 65 73 20 61 72 65 20 6f 70 65 6e     y files are open
  802f80:	00 66 69 6c 65 20 6f 72 20 62 6c 6f 63 6b 20 6e     .file or block n
  802f90:	6f 74 20 66 6f 75 6e 64 00 69 6e 76 61 6c 69 64     ot found.invalid
  802fa0:	20 70 61 74 68 00 66 69 6c 65 20 61 6c 72 65 61      path.file alrea
  802fb0:	64 79 20 65 78 69 73 74 73 00 6f 70 65 72 61 74     dy exists.operat
  802fc0:	69 6f 6e 20 6e 6f 74 20 73 75 70 70 6f 72 74 65     ion not supporte
  802fd0:	64 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00     d.f...........@.
  802fe0:	03 1d 80 00 00 00 00 00 57 23 80 00 00 00 00 00     ........W#......
  802ff0:	47 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     G#......W#......
  803000:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803010:	57 23 80 00 00 00 00 00 1d 1d 80 00 00 00 00 00     W#..............
  803020:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803030:	14 1d 80 00 00 00 00 00 8a 1d 80 00 00 00 00 00     ................
  803040:	57 23 80 00 00 00 00 00 14 1d 80 00 00 00 00 00     W#..............
  803050:	57 1d 80 00 00 00 00 00 57 1d 80 00 00 00 00 00     W.......W.......
  803060:	57 1d 80 00 00 00 00 00 57 1d 80 00 00 00 00 00     W.......W.......
  803070:	57 1d 80 00 00 00 00 00 57 1d 80 00 00 00 00 00     W.......W.......
  803080:	57 1d 80 00 00 00 00 00 57 1d 80 00 00 00 00 00     W.......W.......
  803090:	57 1d 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W.......W#......
  8030a0:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  8030b0:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  8030c0:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  8030d0:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  8030e0:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  8030f0:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803100:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803110:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803120:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803130:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803140:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803150:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803160:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803170:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803180:	57 23 80 00 00 00 00 00 7c 22 80 00 00 00 00 00     W#......|"......
  803190:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  8031a0:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  8031b0:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  8031c0:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  8031d0:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  8031e0:	a8 1d 80 00 00 00 00 00 9e 1f 80 00 00 00 00 00     ................
  8031f0:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803200:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803210:	d6 1d 80 00 00 00 00 00 57 23 80 00 00 00 00 00     ........W#......
  803220:	57 23 80 00 00 00 00 00 9d 1d 80 00 00 00 00 00     W#..............
  803230:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803240:	3e 21 80 00 00 00 00 00 06 22 80 00 00 00 00 00     >!......."......
  803250:	57 23 80 00 00 00 00 00 57 23 80 00 00 00 00 00     W#......W#......
  803260:	6e 1e 80 00 00 00 00 00 57 23 80 00 00 00 00 00     n.......W#......
  803270:	70 20 80 00 00 00 00 00 57 23 80 00 00 00 00 00     p ......W#......
  803280:	57 23 80 00 00 00 00 00 7c 22 80 00 00 00 00 00     W#......|"......
  803290:	57 23 80 00 00 00 00 00 0c 1d 80 00 00 00 00 00     W#..............

00000000008032a0 <error_string>:
	...
  8032a8:	75 2e 80 00 00 00 00 00 87 2e 80 00 00 00 00 00     u...............
  8032b8:	97 2e 80 00 00 00 00 00 a9 2e 80 00 00 00 00 00     ................
  8032c8:	b7 2e 80 00 00 00 00 00 cb 2e 80 00 00 00 00 00     ................
  8032d8:	e0 2e 80 00 00 00 00 00 f3 2e 80 00 00 00 00 00     ................
  8032e8:	05 2f 80 00 00 00 00 00 19 2f 80 00 00 00 00 00     ./......./......
  8032f8:	29 2f 80 00 00 00 00 00 3c 2f 80 00 00 00 00 00     )/......</......
  803308:	53 2f 80 00 00 00 00 00 69 2f 80 00 00 00 00 00     S/......i/......
  803318:	81 2f 80 00 00 00 00 00 99 2f 80 00 00 00 00 00     ./......./......
  803328:	a6 2f 80 00 00 00 00 00 40 33 80 00 00 00 00 00     ./......@3......
  803338:	ba 2f 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     ./......file is 
  803348:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803358:	75 74 61 62 6c 65 00 90 55 73 65 72 73 70 61 63     utable..Userspac
  803368:	65 20 70 61 67 65 20 66 61 75 6c 74 20 72 69 70     e page fault rip
  803378:	3d 25 30 38 6c 58 20 76 61 3d 25 30 38 6c 58 20     =%08lX va=%08lX 
  803388:	65 72 72 3d 25 78 0a 00 6c 69 62 2f 70 67 66 61     err=%x..lib/pgfa
  803398:	75 6c 74 2e 63 00 73 79 73 5f 61 6c 6c 6f 63 5f     ult.c.sys_alloc_
  8033a8:	72 65 67 69 6f 6e 3a 20 25 69 00 73 65 74 5f 70     region: %i.set_p
  8033b8:	67 66 61 75 6c 74 5f 68 61 6e 64 6c 65 72 3a 20     gfault_handler: 
  8033c8:	25 69 00 5f 70 66 68 61 6e 64 6c 65 72 5f 69 6e     %i._pfhandler_in
  8033d8:	69 74 69 74 69 61 6c 6c 69 7a 65 64 00 69 70 63     ititiallized.ipc
  8033e8:	5f 73 65 6e 64 20 65 72 72 6f 72 3a 20 25 69 00     _send error: %i.
  8033f8:	6c 69 62 2f 69 70 63 2e 63 00 66 2e 0f 1f 84 00     lib/ipc.c.f.....
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
