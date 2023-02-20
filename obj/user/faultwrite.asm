
obj/user/faultwrite:     file format elf64-x86-64


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
  80001e:	e8 0e 00 00 00       	call   800031 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv) {
#ifndef __clang_analyzer__
    *(volatile unsigned *)0 = 0;
  800025:	c7 04 25 00 00 00 00 	movl   $0x0,0x0
  80002c:	00 00 00 00 
#endif
}
  800030:	c3                   	ret    

0000000000800031 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800031:	55                   	push   %rbp
  800032:	48 89 e5             	mov    %rsp,%rbp
  800035:	41 56                	push   %r14
  800037:	41 55                	push   %r13
  800039:	41 54                	push   %r12
  80003b:	53                   	push   %rbx
  80003c:	41 89 fd             	mov    %edi,%r13d
  80003f:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800042:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800049:	00 00 00 
  80004c:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800053:	00 00 00 
  800056:	48 39 c2             	cmp    %rax,%rdx
  800059:	73 17                	jae    800072 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80005b:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80005e:	49 89 c4             	mov    %rax,%r12
  800061:	48 83 c3 08          	add    $0x8,%rbx
  800065:	b8 00 00 00 00       	mov    $0x0,%eax
  80006a:	ff 53 f8             	call   *-0x8(%rbx)
  80006d:	4c 39 e3             	cmp    %r12,%rbx
  800070:	72 ef                	jb     800061 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800072:	48 b8 cb 01 80 00 00 	movabs $0x8001cb,%rax
  800079:	00 00 00 
  80007c:	ff d0                	call   *%rax
  80007e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800083:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800087:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80008b:	48 c1 e0 04          	shl    $0x4,%rax
  80008f:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  800096:	00 00 00 
  800099:	48 01 d0             	add    %rdx,%rax
  80009c:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000a3:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000a6:	45 85 ed             	test   %r13d,%r13d
  8000a9:	7e 0d                	jle    8000b8 <libmain+0x87>
  8000ab:	49 8b 06             	mov    (%r14),%rax
  8000ae:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000b5:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000b8:	4c 89 f6             	mov    %r14,%rsi
  8000bb:	44 89 ef             	mov    %r13d,%edi
  8000be:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000ca:	48 b8 df 00 80 00 00 	movabs $0x8000df,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	call   *%rax
#endif
}
  8000d6:	5b                   	pop    %rbx
  8000d7:	41 5c                	pop    %r12
  8000d9:	41 5d                	pop    %r13
  8000db:	41 5e                	pop    %r14
  8000dd:	5d                   	pop    %rbp
  8000de:	c3                   	ret    

00000000008000df <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000df:	55                   	push   %rbp
  8000e0:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000e3:	48 b8 1b 08 80 00 00 	movabs $0x80081b,%rax
  8000ea:	00 00 00 
  8000ed:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8000ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8000f4:	48 b8 60 01 80 00 00 	movabs $0x800160,%rax
  8000fb:	00 00 00 
  8000fe:	ff d0                	call   *%rax
}
  800100:	5d                   	pop    %rbp
  800101:	c3                   	ret    

0000000000800102 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800102:	55                   	push   %rbp
  800103:	48 89 e5             	mov    %rsp,%rbp
  800106:	53                   	push   %rbx
  800107:	48 89 fa             	mov    %rdi,%rdx
  80010a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80010d:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800112:	bb 00 00 00 00       	mov    $0x0,%ebx
  800117:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80011c:	be 00 00 00 00       	mov    $0x0,%esi
  800121:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800127:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800129:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

000000000080012f <sys_cgetc>:

int
sys_cgetc(void) {
  80012f:	55                   	push   %rbp
  800130:	48 89 e5             	mov    %rsp,%rbp
  800133:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800134:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800139:	ba 00 00 00 00       	mov    $0x0,%edx
  80013e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800143:	bb 00 00 00 00       	mov    $0x0,%ebx
  800148:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80014d:	be 00 00 00 00       	mov    $0x0,%esi
  800152:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800158:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80015a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80015e:	c9                   	leave  
  80015f:	c3                   	ret    

0000000000800160 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800160:	55                   	push   %rbp
  800161:	48 89 e5             	mov    %rsp,%rbp
  800164:	53                   	push   %rbx
  800165:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800169:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80016c:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800171:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800176:	bb 00 00 00 00       	mov    $0x0,%ebx
  80017b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800180:	be 00 00 00 00       	mov    $0x0,%esi
  800185:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80018b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80018d:	48 85 c0             	test   %rax,%rax
  800190:	7f 06                	jg     800198 <sys_env_destroy+0x38>
}
  800192:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800196:	c9                   	leave  
  800197:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800198:	49 89 c0             	mov    %rax,%r8
  80019b:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001a0:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  8001a7:	00 00 00 
  8001aa:	be 26 00 00 00       	mov    $0x26,%esi
  8001af:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  8001b6:	00 00 00 
  8001b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001be:	49 b9 4e 19 80 00 00 	movabs $0x80194e,%r9
  8001c5:	00 00 00 
  8001c8:	41 ff d1             	call   *%r9

00000000008001cb <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001cb:	55                   	push   %rbp
  8001cc:	48 89 e5             	mov    %rsp,%rbp
  8001cf:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001d0:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001da:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001e9:	be 00 00 00 00       	mov    $0x0,%esi
  8001ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001f4:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8001f6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

00000000008001fc <sys_yield>:

void
sys_yield(void) {
  8001fc:	55                   	push   %rbp
  8001fd:	48 89 e5             	mov    %rsp,%rbp
  800200:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800201:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800206:	ba 00 00 00 00       	mov    $0x0,%edx
  80020b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800210:	bb 00 00 00 00       	mov    $0x0,%ebx
  800215:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80021a:	be 00 00 00 00       	mov    $0x0,%esi
  80021f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800225:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800227:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80022b:	c9                   	leave  
  80022c:	c3                   	ret    

000000000080022d <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80022d:	55                   	push   %rbp
  80022e:	48 89 e5             	mov    %rsp,%rbp
  800231:	53                   	push   %rbx
  800232:	48 89 fa             	mov    %rdi,%rdx
  800235:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800238:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80023d:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800244:	00 00 00 
  800247:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80024c:	be 00 00 00 00       	mov    $0x0,%esi
  800251:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800257:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800259:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80025d:	c9                   	leave  
  80025e:	c3                   	ret    

000000000080025f <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80025f:	55                   	push   %rbp
  800260:	48 89 e5             	mov    %rsp,%rbp
  800263:	53                   	push   %rbx
  800264:	49 89 f8             	mov    %rdi,%r8
  800267:	48 89 d3             	mov    %rdx,%rbx
  80026a:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80026d:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800272:	4c 89 c2             	mov    %r8,%rdx
  800275:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800278:	be 00 00 00 00       	mov    $0x0,%esi
  80027d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800283:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  800285:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800289:	c9                   	leave  
  80028a:	c3                   	ret    

000000000080028b <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80028b:	55                   	push   %rbp
  80028c:	48 89 e5             	mov    %rsp,%rbp
  80028f:	53                   	push   %rbx
  800290:	48 83 ec 08          	sub    $0x8,%rsp
  800294:	89 f8                	mov    %edi,%eax
  800296:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  800299:	48 63 f9             	movslq %ecx,%rdi
  80029c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80029f:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002a4:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002a7:	be 00 00 00 00       	mov    $0x0,%esi
  8002ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002b2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002b4:	48 85 c0             	test   %rax,%rax
  8002b7:	7f 06                	jg     8002bf <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002b9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002bd:	c9                   	leave  
  8002be:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002bf:	49 89 c0             	mov    %rax,%r8
  8002c2:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002c7:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  8002ce:	00 00 00 
  8002d1:	be 26 00 00 00       	mov    $0x26,%esi
  8002d6:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  8002dd:	00 00 00 
  8002e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e5:	49 b9 4e 19 80 00 00 	movabs $0x80194e,%r9
  8002ec:	00 00 00 
  8002ef:	41 ff d1             	call   *%r9

00000000008002f2 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8002f2:	55                   	push   %rbp
  8002f3:	48 89 e5             	mov    %rsp,%rbp
  8002f6:	53                   	push   %rbx
  8002f7:	48 83 ec 08          	sub    $0x8,%rsp
  8002fb:	89 f8                	mov    %edi,%eax
  8002fd:	49 89 f2             	mov    %rsi,%r10
  800300:	48 89 cf             	mov    %rcx,%rdi
  800303:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800306:	48 63 da             	movslq %edx,%rbx
  800309:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80030c:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800311:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800314:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800317:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800319:	48 85 c0             	test   %rax,%rax
  80031c:	7f 06                	jg     800324 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80031e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800322:	c9                   	leave  
  800323:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800324:	49 89 c0             	mov    %rax,%r8
  800327:	b9 05 00 00 00       	mov    $0x5,%ecx
  80032c:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  800333:	00 00 00 
  800336:	be 26 00 00 00       	mov    $0x26,%esi
  80033b:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  800342:	00 00 00 
  800345:	b8 00 00 00 00       	mov    $0x0,%eax
  80034a:	49 b9 4e 19 80 00 00 	movabs $0x80194e,%r9
  800351:	00 00 00 
  800354:	41 ff d1             	call   *%r9

0000000000800357 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  800357:	55                   	push   %rbp
  800358:	48 89 e5             	mov    %rsp,%rbp
  80035b:	53                   	push   %rbx
  80035c:	48 83 ec 08          	sub    $0x8,%rsp
  800360:	48 89 f1             	mov    %rsi,%rcx
  800363:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  800366:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800369:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80036e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800373:	be 00 00 00 00       	mov    $0x0,%esi
  800378:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80037e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800380:	48 85 c0             	test   %rax,%rax
  800383:	7f 06                	jg     80038b <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  800385:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800389:	c9                   	leave  
  80038a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80038b:	49 89 c0             	mov    %rax,%r8
  80038e:	b9 06 00 00 00       	mov    $0x6,%ecx
  800393:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  80039a:	00 00 00 
  80039d:	be 26 00 00 00       	mov    $0x26,%esi
  8003a2:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  8003a9:	00 00 00 
  8003ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b1:	49 b9 4e 19 80 00 00 	movabs $0x80194e,%r9
  8003b8:	00 00 00 
  8003bb:	41 ff d1             	call   *%r9

00000000008003be <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8003be:	55                   	push   %rbp
  8003bf:	48 89 e5             	mov    %rsp,%rbp
  8003c2:	53                   	push   %rbx
  8003c3:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8003c7:	48 63 ce             	movslq %esi,%rcx
  8003ca:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8003cd:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8003d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003dc:	be 00 00 00 00       	mov    $0x0,%esi
  8003e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003e7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003e9:	48 85 c0             	test   %rax,%rax
  8003ec:	7f 06                	jg     8003f4 <sys_env_set_status+0x36>
}
  8003ee:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003f4:	49 89 c0             	mov    %rax,%r8
  8003f7:	b9 09 00 00 00       	mov    $0x9,%ecx
  8003fc:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  800403:	00 00 00 
  800406:	be 26 00 00 00       	mov    $0x26,%esi
  80040b:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  800412:	00 00 00 
  800415:	b8 00 00 00 00       	mov    $0x0,%eax
  80041a:	49 b9 4e 19 80 00 00 	movabs $0x80194e,%r9
  800421:	00 00 00 
  800424:	41 ff d1             	call   *%r9

0000000000800427 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  800427:	55                   	push   %rbp
  800428:	48 89 e5             	mov    %rsp,%rbp
  80042b:	53                   	push   %rbx
  80042c:	48 83 ec 08          	sub    $0x8,%rsp
  800430:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  800433:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800436:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80043b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800440:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800445:	be 00 00 00 00       	mov    $0x0,%esi
  80044a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800450:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800452:	48 85 c0             	test   %rax,%rax
  800455:	7f 06                	jg     80045d <sys_env_set_trapframe+0x36>
}
  800457:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80045b:	c9                   	leave  
  80045c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80045d:	49 89 c0             	mov    %rax,%r8
  800460:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800465:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  80046c:	00 00 00 
  80046f:	be 26 00 00 00       	mov    $0x26,%esi
  800474:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  80047b:	00 00 00 
  80047e:	b8 00 00 00 00       	mov    $0x0,%eax
  800483:	49 b9 4e 19 80 00 00 	movabs $0x80194e,%r9
  80048a:	00 00 00 
  80048d:	41 ff d1             	call   *%r9

0000000000800490 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  800490:	55                   	push   %rbp
  800491:	48 89 e5             	mov    %rsp,%rbp
  800494:	53                   	push   %rbx
  800495:	48 83 ec 08          	sub    $0x8,%rsp
  800499:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80049c:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80049f:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004a9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004ae:	be 00 00 00 00       	mov    $0x0,%esi
  8004b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004b9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004bb:	48 85 c0             	test   %rax,%rax
  8004be:	7f 06                	jg     8004c6 <sys_env_set_pgfault_upcall+0x36>
}
  8004c0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004c6:	49 89 c0             	mov    %rax,%r8
  8004c9:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8004ce:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  8004d5:	00 00 00 
  8004d8:	be 26 00 00 00       	mov    $0x26,%esi
  8004dd:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  8004e4:	00 00 00 
  8004e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ec:	49 b9 4e 19 80 00 00 	movabs $0x80194e,%r9
  8004f3:	00 00 00 
  8004f6:	41 ff d1             	call   *%r9

00000000008004f9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8004f9:	55                   	push   %rbp
  8004fa:	48 89 e5             	mov    %rsp,%rbp
  8004fd:	53                   	push   %rbx
  8004fe:	89 f8                	mov    %edi,%eax
  800500:	49 89 f1             	mov    %rsi,%r9
  800503:	48 89 d3             	mov    %rdx,%rbx
  800506:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  800509:	49 63 f0             	movslq %r8d,%rsi
  80050c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80050f:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800514:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800517:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80051d:	cd 30                	int    $0x30
}
  80051f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800523:	c9                   	leave  
  800524:	c3                   	ret    

0000000000800525 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  800525:	55                   	push   %rbp
  800526:	48 89 e5             	mov    %rsp,%rbp
  800529:	53                   	push   %rbx
  80052a:	48 83 ec 08          	sub    $0x8,%rsp
  80052e:	48 89 fa             	mov    %rdi,%rdx
  800531:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800534:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800539:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800543:	be 00 00 00 00       	mov    $0x0,%esi
  800548:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80054e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800550:	48 85 c0             	test   %rax,%rax
  800553:	7f 06                	jg     80055b <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800555:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800559:	c9                   	leave  
  80055a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80055b:	49 89 c0             	mov    %rax,%r8
  80055e:	b9 0e 00 00 00       	mov    $0xe,%ecx
  800563:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  80056a:	00 00 00 
  80056d:	be 26 00 00 00       	mov    $0x26,%esi
  800572:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  800579:	00 00 00 
  80057c:	b8 00 00 00 00       	mov    $0x0,%eax
  800581:	49 b9 4e 19 80 00 00 	movabs $0x80194e,%r9
  800588:	00 00 00 
  80058b:	41 ff d1             	call   *%r9

000000000080058e <sys_gettime>:

int
sys_gettime(void) {
  80058e:	55                   	push   %rbp
  80058f:	48 89 e5             	mov    %rsp,%rbp
  800592:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800593:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
  80059d:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005a7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005ac:	be 00 00 00 00       	mov    $0x0,%esi
  8005b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005b7:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8005b9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005bd:	c9                   	leave  
  8005be:	c3                   	ret    

00000000008005bf <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8005bf:	55                   	push   %rbp
  8005c0:	48 89 e5             	mov    %rsp,%rbp
  8005c3:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005c4:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ce:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005d8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005dd:	be 00 00 00 00       	mov    $0x0,%esi
  8005e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005e8:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8005ea:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005ee:	c9                   	leave  
  8005ef:	c3                   	ret    

00000000008005f0 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8005f0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8005f7:	ff ff ff 
  8005fa:	48 01 f8             	add    %rdi,%rax
  8005fd:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800601:	c3                   	ret    

0000000000800602 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800602:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800609:	ff ff ff 
  80060c:	48 01 f8             	add    %rdi,%rax
  80060f:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  800613:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800619:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80061d:	c3                   	ret    

000000000080061e <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80061e:	55                   	push   %rbp
  80061f:	48 89 e5             	mov    %rsp,%rbp
  800622:	41 57                	push   %r15
  800624:	41 56                	push   %r14
  800626:	41 55                	push   %r13
  800628:	41 54                	push   %r12
  80062a:	53                   	push   %rbx
  80062b:	48 83 ec 08          	sub    $0x8,%rsp
  80062f:	49 89 ff             	mov    %rdi,%r15
  800632:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  800637:	49 bc cc 15 80 00 00 	movabs $0x8015cc,%r12
  80063e:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  800641:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  800647:	48 89 df             	mov    %rbx,%rdi
  80064a:	41 ff d4             	call   *%r12
  80064d:	83 e0 04             	and    $0x4,%eax
  800650:	74 1a                	je     80066c <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  800652:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  800659:	4c 39 f3             	cmp    %r14,%rbx
  80065c:	75 e9                	jne    800647 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  80065e:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  800665:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80066a:	eb 03                	jmp    80066f <fd_alloc+0x51>
            *fd_store = fd;
  80066c:	49 89 1f             	mov    %rbx,(%r15)
}
  80066f:	48 83 c4 08          	add    $0x8,%rsp
  800673:	5b                   	pop    %rbx
  800674:	41 5c                	pop    %r12
  800676:	41 5d                	pop    %r13
  800678:	41 5e                	pop    %r14
  80067a:	41 5f                	pop    %r15
  80067c:	5d                   	pop    %rbp
  80067d:	c3                   	ret    

000000000080067e <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  80067e:	83 ff 1f             	cmp    $0x1f,%edi
  800681:	77 39                	ja     8006bc <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  800683:	55                   	push   %rbp
  800684:	48 89 e5             	mov    %rsp,%rbp
  800687:	41 54                	push   %r12
  800689:	53                   	push   %rbx
  80068a:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80068d:	48 63 df             	movslq %edi,%rbx
  800690:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  800697:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  80069b:	48 89 df             	mov    %rbx,%rdi
  80069e:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  8006a5:	00 00 00 
  8006a8:	ff d0                	call   *%rax
  8006aa:	a8 04                	test   $0x4,%al
  8006ac:	74 14                	je     8006c2 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8006ae:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8006b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006b7:	5b                   	pop    %rbx
  8006b8:	41 5c                	pop    %r12
  8006ba:	5d                   	pop    %rbp
  8006bb:	c3                   	ret    
        return -E_INVAL;
  8006bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006c1:	c3                   	ret    
        return -E_INVAL;
  8006c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006c7:	eb ee                	jmp    8006b7 <fd_lookup+0x39>

00000000008006c9 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8006c9:	55                   	push   %rbp
  8006ca:	48 89 e5             	mov    %rsp,%rbp
  8006cd:	53                   	push   %rbx
  8006ce:	48 83 ec 08          	sub    $0x8,%rsp
  8006d2:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8006d5:	48 ba 80 2a 80 00 00 	movabs $0x802a80,%rdx
  8006dc:	00 00 00 
  8006df:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8006e6:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8006e9:	39 38                	cmp    %edi,(%rax)
  8006eb:	74 4b                	je     800738 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8006ed:	48 83 c2 08          	add    $0x8,%rdx
  8006f1:	48 8b 02             	mov    (%rdx),%rax
  8006f4:	48 85 c0             	test   %rax,%rax
  8006f7:	75 f0                	jne    8006e9 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8006f9:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800700:	00 00 00 
  800703:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800709:	89 fa                	mov    %edi,%edx
  80070b:	48 bf f0 29 80 00 00 	movabs $0x8029f0,%rdi
  800712:	00 00 00 
  800715:	b8 00 00 00 00       	mov    $0x0,%eax
  80071a:	48 b9 9e 1a 80 00 00 	movabs $0x801a9e,%rcx
  800721:	00 00 00 
  800724:	ff d1                	call   *%rcx
    *dev = 0;
  800726:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  80072d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800732:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800736:	c9                   	leave  
  800737:	c3                   	ret    
            *dev = devtab[i];
  800738:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  80073b:	b8 00 00 00 00       	mov    $0x0,%eax
  800740:	eb f0                	jmp    800732 <dev_lookup+0x69>

0000000000800742 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  800742:	55                   	push   %rbp
  800743:	48 89 e5             	mov    %rsp,%rbp
  800746:	41 55                	push   %r13
  800748:	41 54                	push   %r12
  80074a:	53                   	push   %rbx
  80074b:	48 83 ec 18          	sub    $0x18,%rsp
  80074f:	49 89 fc             	mov    %rdi,%r12
  800752:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800755:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80075c:	ff ff ff 
  80075f:	4c 01 e7             	add    %r12,%rdi
  800762:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  800766:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80076a:	48 b8 7e 06 80 00 00 	movabs $0x80067e,%rax
  800771:	00 00 00 
  800774:	ff d0                	call   *%rax
  800776:	89 c3                	mov    %eax,%ebx
  800778:	85 c0                	test   %eax,%eax
  80077a:	78 06                	js     800782 <fd_close+0x40>
  80077c:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  800780:	74 18                	je     80079a <fd_close+0x58>
        return (must_exist ? res : 0);
  800782:	45 84 ed             	test   %r13b,%r13b
  800785:	b8 00 00 00 00       	mov    $0x0,%eax
  80078a:	0f 44 d8             	cmove  %eax,%ebx
}
  80078d:	89 d8                	mov    %ebx,%eax
  80078f:	48 83 c4 18          	add    $0x18,%rsp
  800793:	5b                   	pop    %rbx
  800794:	41 5c                	pop    %r12
  800796:	41 5d                	pop    %r13
  800798:	5d                   	pop    %rbp
  800799:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80079a:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80079e:	41 8b 3c 24          	mov    (%r12),%edi
  8007a2:	48 b8 c9 06 80 00 00 	movabs $0x8006c9,%rax
  8007a9:	00 00 00 
  8007ac:	ff d0                	call   *%rax
  8007ae:	89 c3                	mov    %eax,%ebx
  8007b0:	85 c0                	test   %eax,%eax
  8007b2:	78 19                	js     8007cd <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8007b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8007b8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007c1:	48 85 c0             	test   %rax,%rax
  8007c4:	74 07                	je     8007cd <fd_close+0x8b>
  8007c6:	4c 89 e7             	mov    %r12,%rdi
  8007c9:	ff d0                	call   *%rax
  8007cb:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8007cd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8007d2:	4c 89 e6             	mov    %r12,%rsi
  8007d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8007da:	48 b8 57 03 80 00 00 	movabs $0x800357,%rax
  8007e1:	00 00 00 
  8007e4:	ff d0                	call   *%rax
    return res;
  8007e6:	eb a5                	jmp    80078d <fd_close+0x4b>

00000000008007e8 <close>:

int
close(int fdnum) {
  8007e8:	55                   	push   %rbp
  8007e9:	48 89 e5             	mov    %rsp,%rbp
  8007ec:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8007f0:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8007f4:	48 b8 7e 06 80 00 00 	movabs $0x80067e,%rax
  8007fb:	00 00 00 
  8007fe:	ff d0                	call   *%rax
    if (res < 0) return res;
  800800:	85 c0                	test   %eax,%eax
  800802:	78 15                	js     800819 <close+0x31>

    return fd_close(fd, 1);
  800804:	be 01 00 00 00       	mov    $0x1,%esi
  800809:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80080d:	48 b8 42 07 80 00 00 	movabs $0x800742,%rax
  800814:	00 00 00 
  800817:	ff d0                	call   *%rax
}
  800819:	c9                   	leave  
  80081a:	c3                   	ret    

000000000080081b <close_all>:

void
close_all(void) {
  80081b:	55                   	push   %rbp
  80081c:	48 89 e5             	mov    %rsp,%rbp
  80081f:	41 54                	push   %r12
  800821:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  800822:	bb 00 00 00 00       	mov    $0x0,%ebx
  800827:	49 bc e8 07 80 00 00 	movabs $0x8007e8,%r12
  80082e:	00 00 00 
  800831:	89 df                	mov    %ebx,%edi
  800833:	41 ff d4             	call   *%r12
  800836:	83 c3 01             	add    $0x1,%ebx
  800839:	83 fb 20             	cmp    $0x20,%ebx
  80083c:	75 f3                	jne    800831 <close_all+0x16>
}
  80083e:	5b                   	pop    %rbx
  80083f:	41 5c                	pop    %r12
  800841:	5d                   	pop    %rbp
  800842:	c3                   	ret    

0000000000800843 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  800843:	55                   	push   %rbp
  800844:	48 89 e5             	mov    %rsp,%rbp
  800847:	41 56                	push   %r14
  800849:	41 55                	push   %r13
  80084b:	41 54                	push   %r12
  80084d:	53                   	push   %rbx
  80084e:	48 83 ec 10          	sub    $0x10,%rsp
  800852:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  800855:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800859:	48 b8 7e 06 80 00 00 	movabs $0x80067e,%rax
  800860:	00 00 00 
  800863:	ff d0                	call   *%rax
  800865:	89 c3                	mov    %eax,%ebx
  800867:	85 c0                	test   %eax,%eax
  800869:	0f 88 b7 00 00 00    	js     800926 <dup+0xe3>
    close(newfdnum);
  80086f:	44 89 e7             	mov    %r12d,%edi
  800872:	48 b8 e8 07 80 00 00 	movabs $0x8007e8,%rax
  800879:	00 00 00 
  80087c:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80087e:	4d 63 ec             	movslq %r12d,%r13
  800881:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  800888:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  80088c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800890:	49 be 02 06 80 00 00 	movabs $0x800602,%r14
  800897:	00 00 00 
  80089a:	41 ff d6             	call   *%r14
  80089d:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8008a0:	4c 89 ef             	mov    %r13,%rdi
  8008a3:	41 ff d6             	call   *%r14
  8008a6:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8008a9:	48 89 df             	mov    %rbx,%rdi
  8008ac:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  8008b3:	00 00 00 
  8008b6:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8008b8:	a8 04                	test   $0x4,%al
  8008ba:	74 2b                	je     8008e7 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8008bc:	41 89 c1             	mov    %eax,%r9d
  8008bf:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8008c5:	4c 89 f1             	mov    %r14,%rcx
  8008c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cd:	48 89 de             	mov    %rbx,%rsi
  8008d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8008d5:	48 b8 f2 02 80 00 00 	movabs $0x8002f2,%rax
  8008dc:	00 00 00 
  8008df:	ff d0                	call   *%rax
  8008e1:	89 c3                	mov    %eax,%ebx
  8008e3:	85 c0                	test   %eax,%eax
  8008e5:	78 4e                	js     800935 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8008e7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8008eb:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  8008f2:	00 00 00 
  8008f5:	ff d0                	call   *%rax
  8008f7:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8008fa:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800900:	4c 89 e9             	mov    %r13,%rcx
  800903:	ba 00 00 00 00       	mov    $0x0,%edx
  800908:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80090c:	bf 00 00 00 00       	mov    $0x0,%edi
  800911:	48 b8 f2 02 80 00 00 	movabs $0x8002f2,%rax
  800918:	00 00 00 
  80091b:	ff d0                	call   *%rax
  80091d:	89 c3                	mov    %eax,%ebx
  80091f:	85 c0                	test   %eax,%eax
  800921:	78 12                	js     800935 <dup+0xf2>

    return newfdnum;
  800923:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  800926:	89 d8                	mov    %ebx,%eax
  800928:	48 83 c4 10          	add    $0x10,%rsp
  80092c:	5b                   	pop    %rbx
  80092d:	41 5c                	pop    %r12
  80092f:	41 5d                	pop    %r13
  800931:	41 5e                	pop    %r14
  800933:	5d                   	pop    %rbp
  800934:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  800935:	ba 00 10 00 00       	mov    $0x1000,%edx
  80093a:	4c 89 ee             	mov    %r13,%rsi
  80093d:	bf 00 00 00 00       	mov    $0x0,%edi
  800942:	49 bc 57 03 80 00 00 	movabs $0x800357,%r12
  800949:	00 00 00 
  80094c:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80094f:	ba 00 10 00 00       	mov    $0x1000,%edx
  800954:	4c 89 f6             	mov    %r14,%rsi
  800957:	bf 00 00 00 00       	mov    $0x0,%edi
  80095c:	41 ff d4             	call   *%r12
    return res;
  80095f:	eb c5                	jmp    800926 <dup+0xe3>

0000000000800961 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800961:	55                   	push   %rbp
  800962:	48 89 e5             	mov    %rsp,%rbp
  800965:	41 55                	push   %r13
  800967:	41 54                	push   %r12
  800969:	53                   	push   %rbx
  80096a:	48 83 ec 18          	sub    $0x18,%rsp
  80096e:	89 fb                	mov    %edi,%ebx
  800970:	49 89 f4             	mov    %rsi,%r12
  800973:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800976:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80097a:	48 b8 7e 06 80 00 00 	movabs $0x80067e,%rax
  800981:	00 00 00 
  800984:	ff d0                	call   *%rax
  800986:	85 c0                	test   %eax,%eax
  800988:	78 49                	js     8009d3 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80098a:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80098e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800992:	8b 38                	mov    (%rax),%edi
  800994:	48 b8 c9 06 80 00 00 	movabs $0x8006c9,%rax
  80099b:	00 00 00 
  80099e:	ff d0                	call   *%rax
  8009a0:	85 c0                	test   %eax,%eax
  8009a2:	78 33                	js     8009d7 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8009a4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8009a8:	8b 47 08             	mov    0x8(%rdi),%eax
  8009ab:	83 e0 03             	and    $0x3,%eax
  8009ae:	83 f8 01             	cmp    $0x1,%eax
  8009b1:	74 28                	je     8009db <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8009b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009b7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8009bb:	48 85 c0             	test   %rax,%rax
  8009be:	74 51                	je     800a11 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8009c0:	4c 89 ea             	mov    %r13,%rdx
  8009c3:	4c 89 e6             	mov    %r12,%rsi
  8009c6:	ff d0                	call   *%rax
}
  8009c8:	48 83 c4 18          	add    $0x18,%rsp
  8009cc:	5b                   	pop    %rbx
  8009cd:	41 5c                	pop    %r12
  8009cf:	41 5d                	pop    %r13
  8009d1:	5d                   	pop    %rbp
  8009d2:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8009d3:	48 98                	cltq   
  8009d5:	eb f1                	jmp    8009c8 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8009d7:	48 98                	cltq   
  8009d9:	eb ed                	jmp    8009c8 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8009db:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8009e2:	00 00 00 
  8009e5:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8009eb:	89 da                	mov    %ebx,%edx
  8009ed:	48 bf 31 2a 80 00 00 	movabs $0x802a31,%rdi
  8009f4:	00 00 00 
  8009f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fc:	48 b9 9e 1a 80 00 00 	movabs $0x801a9e,%rcx
  800a03:	00 00 00 
  800a06:	ff d1                	call   *%rcx
        return -E_INVAL;
  800a08:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800a0f:	eb b7                	jmp    8009c8 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800a11:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800a18:	eb ae                	jmp    8009c8 <read+0x67>

0000000000800a1a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800a1a:	55                   	push   %rbp
  800a1b:	48 89 e5             	mov    %rsp,%rbp
  800a1e:	41 57                	push   %r15
  800a20:	41 56                	push   %r14
  800a22:	41 55                	push   %r13
  800a24:	41 54                	push   %r12
  800a26:	53                   	push   %rbx
  800a27:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800a2b:	48 85 d2             	test   %rdx,%rdx
  800a2e:	74 54                	je     800a84 <readn+0x6a>
  800a30:	41 89 fd             	mov    %edi,%r13d
  800a33:	49 89 f6             	mov    %rsi,%r14
  800a36:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800a39:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800a3e:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800a43:	49 bf 61 09 80 00 00 	movabs $0x800961,%r15
  800a4a:	00 00 00 
  800a4d:	4c 89 e2             	mov    %r12,%rdx
  800a50:	48 29 f2             	sub    %rsi,%rdx
  800a53:	4c 01 f6             	add    %r14,%rsi
  800a56:	44 89 ef             	mov    %r13d,%edi
  800a59:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800a5c:	85 c0                	test   %eax,%eax
  800a5e:	78 20                	js     800a80 <readn+0x66>
    for (; inc && res < n; res += inc) {
  800a60:	01 c3                	add    %eax,%ebx
  800a62:	85 c0                	test   %eax,%eax
  800a64:	74 08                	je     800a6e <readn+0x54>
  800a66:	48 63 f3             	movslq %ebx,%rsi
  800a69:	4c 39 e6             	cmp    %r12,%rsi
  800a6c:	72 df                	jb     800a4d <readn+0x33>
    }
    return res;
  800a6e:	48 63 c3             	movslq %ebx,%rax
}
  800a71:	48 83 c4 08          	add    $0x8,%rsp
  800a75:	5b                   	pop    %rbx
  800a76:	41 5c                	pop    %r12
  800a78:	41 5d                	pop    %r13
  800a7a:	41 5e                	pop    %r14
  800a7c:	41 5f                	pop    %r15
  800a7e:	5d                   	pop    %rbp
  800a7f:	c3                   	ret    
        if (inc < 0) return inc;
  800a80:	48 98                	cltq   
  800a82:	eb ed                	jmp    800a71 <readn+0x57>
    int inc = 1, res = 0;
  800a84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a89:	eb e3                	jmp    800a6e <readn+0x54>

0000000000800a8b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800a8b:	55                   	push   %rbp
  800a8c:	48 89 e5             	mov    %rsp,%rbp
  800a8f:	41 55                	push   %r13
  800a91:	41 54                	push   %r12
  800a93:	53                   	push   %rbx
  800a94:	48 83 ec 18          	sub    $0x18,%rsp
  800a98:	89 fb                	mov    %edi,%ebx
  800a9a:	49 89 f4             	mov    %rsi,%r12
  800a9d:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800aa0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800aa4:	48 b8 7e 06 80 00 00 	movabs $0x80067e,%rax
  800aab:	00 00 00 
  800aae:	ff d0                	call   *%rax
  800ab0:	85 c0                	test   %eax,%eax
  800ab2:	78 44                	js     800af8 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800ab4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800ab8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800abc:	8b 38                	mov    (%rax),%edi
  800abe:	48 b8 c9 06 80 00 00 	movabs $0x8006c9,%rax
  800ac5:	00 00 00 
  800ac8:	ff d0                	call   *%rax
  800aca:	85 c0                	test   %eax,%eax
  800acc:	78 2e                	js     800afc <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ace:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ad2:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800ad6:	74 28                	je     800b00 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800ad8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800adc:	48 8b 40 18          	mov    0x18(%rax),%rax
  800ae0:	48 85 c0             	test   %rax,%rax
  800ae3:	74 51                	je     800b36 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  800ae5:	4c 89 ea             	mov    %r13,%rdx
  800ae8:	4c 89 e6             	mov    %r12,%rsi
  800aeb:	ff d0                	call   *%rax
}
  800aed:	48 83 c4 18          	add    $0x18,%rsp
  800af1:	5b                   	pop    %rbx
  800af2:	41 5c                	pop    %r12
  800af4:	41 5d                	pop    %r13
  800af6:	5d                   	pop    %rbp
  800af7:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800af8:	48 98                	cltq   
  800afa:	eb f1                	jmp    800aed <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800afc:	48 98                	cltq   
  800afe:	eb ed                	jmp    800aed <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b00:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800b07:	00 00 00 
  800b0a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800b10:	89 da                	mov    %ebx,%edx
  800b12:	48 bf 4d 2a 80 00 00 	movabs $0x802a4d,%rdi
  800b19:	00 00 00 
  800b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b21:	48 b9 9e 1a 80 00 00 	movabs $0x801a9e,%rcx
  800b28:	00 00 00 
  800b2b:	ff d1                	call   *%rcx
        return -E_INVAL;
  800b2d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800b34:	eb b7                	jmp    800aed <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800b36:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800b3d:	eb ae                	jmp    800aed <write+0x62>

0000000000800b3f <seek>:

int
seek(int fdnum, off_t offset) {
  800b3f:	55                   	push   %rbp
  800b40:	48 89 e5             	mov    %rsp,%rbp
  800b43:	53                   	push   %rbx
  800b44:	48 83 ec 18          	sub    $0x18,%rsp
  800b48:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b4a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b4e:	48 b8 7e 06 80 00 00 	movabs $0x80067e,%rax
  800b55:	00 00 00 
  800b58:	ff d0                	call   *%rax
  800b5a:	85 c0                	test   %eax,%eax
  800b5c:	78 0c                	js     800b6a <seek+0x2b>

    fd->fd_offset = offset;
  800b5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b62:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800b65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800b6e:	c9                   	leave  
  800b6f:	c3                   	ret    

0000000000800b70 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800b70:	55                   	push   %rbp
  800b71:	48 89 e5             	mov    %rsp,%rbp
  800b74:	41 54                	push   %r12
  800b76:	53                   	push   %rbx
  800b77:	48 83 ec 10          	sub    $0x10,%rsp
  800b7b:	89 fb                	mov    %edi,%ebx
  800b7d:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b80:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b84:	48 b8 7e 06 80 00 00 	movabs $0x80067e,%rax
  800b8b:	00 00 00 
  800b8e:	ff d0                	call   *%rax
  800b90:	85 c0                	test   %eax,%eax
  800b92:	78 36                	js     800bca <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b94:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800b98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9c:	8b 38                	mov    (%rax),%edi
  800b9e:	48 b8 c9 06 80 00 00 	movabs $0x8006c9,%rax
  800ba5:	00 00 00 
  800ba8:	ff d0                	call   *%rax
  800baa:	85 c0                	test   %eax,%eax
  800bac:	78 1c                	js     800bca <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bae:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800bb2:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800bb6:	74 1b                	je     800bd3 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800bb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800bbc:	48 8b 40 30          	mov    0x30(%rax),%rax
  800bc0:	48 85 c0             	test   %rax,%rax
  800bc3:	74 42                	je     800c07 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  800bc5:	44 89 e6             	mov    %r12d,%esi
  800bc8:	ff d0                	call   *%rax
}
  800bca:	48 83 c4 10          	add    $0x10,%rsp
  800bce:	5b                   	pop    %rbx
  800bcf:	41 5c                	pop    %r12
  800bd1:	5d                   	pop    %rbp
  800bd2:	c3                   	ret    
                thisenv->env_id, fdnum);
  800bd3:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bda:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800bdd:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800be3:	89 da                	mov    %ebx,%edx
  800be5:	48 bf 10 2a 80 00 00 	movabs $0x802a10,%rdi
  800bec:	00 00 00 
  800bef:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf4:	48 b9 9e 1a 80 00 00 	movabs $0x801a9e,%rcx
  800bfb:	00 00 00 
  800bfe:	ff d1                	call   *%rcx
        return -E_INVAL;
  800c00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c05:	eb c3                	jmp    800bca <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c07:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c0c:	eb bc                	jmp    800bca <ftruncate+0x5a>

0000000000800c0e <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800c0e:	55                   	push   %rbp
  800c0f:	48 89 e5             	mov    %rsp,%rbp
  800c12:	53                   	push   %rbx
  800c13:	48 83 ec 18          	sub    $0x18,%rsp
  800c17:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c1a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c1e:	48 b8 7e 06 80 00 00 	movabs $0x80067e,%rax
  800c25:	00 00 00 
  800c28:	ff d0                	call   *%rax
  800c2a:	85 c0                	test   %eax,%eax
  800c2c:	78 4d                	js     800c7b <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c2e:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800c32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c36:	8b 38                	mov    (%rax),%edi
  800c38:	48 b8 c9 06 80 00 00 	movabs $0x8006c9,%rax
  800c3f:	00 00 00 
  800c42:	ff d0                	call   *%rax
  800c44:	85 c0                	test   %eax,%eax
  800c46:	78 33                	js     800c7b <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c4c:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800c51:	74 2e                	je     800c81 <fstat+0x73>

    stat->st_name[0] = 0;
  800c53:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800c56:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800c5d:	00 00 00 
    stat->st_isdir = 0;
  800c60:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800c67:	00 00 00 
    stat->st_dev = dev;
  800c6a:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800c71:	48 89 de             	mov    %rbx,%rsi
  800c74:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c78:	ff 50 28             	call   *0x28(%rax)
}
  800c7b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c81:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c86:	eb f3                	jmp    800c7b <fstat+0x6d>

0000000000800c88 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800c88:	55                   	push   %rbp
  800c89:	48 89 e5             	mov    %rsp,%rbp
  800c8c:	41 54                	push   %r12
  800c8e:	53                   	push   %rbx
  800c8f:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800c92:	be 00 00 00 00       	mov    $0x0,%esi
  800c97:	48 b8 53 0f 80 00 00 	movabs $0x800f53,%rax
  800c9e:	00 00 00 
  800ca1:	ff d0                	call   *%rax
  800ca3:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	78 25                	js     800cce <stat+0x46>

    int res = fstat(fd, stat);
  800ca9:	4c 89 e6             	mov    %r12,%rsi
  800cac:	89 c7                	mov    %eax,%edi
  800cae:	48 b8 0e 0c 80 00 00 	movabs $0x800c0e,%rax
  800cb5:	00 00 00 
  800cb8:	ff d0                	call   *%rax
  800cba:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800cbd:	89 df                	mov    %ebx,%edi
  800cbf:	48 b8 e8 07 80 00 00 	movabs $0x8007e8,%rax
  800cc6:	00 00 00 
  800cc9:	ff d0                	call   *%rax

    return res;
  800ccb:	44 89 e3             	mov    %r12d,%ebx
}
  800cce:	89 d8                	mov    %ebx,%eax
  800cd0:	5b                   	pop    %rbx
  800cd1:	41 5c                	pop    %r12
  800cd3:	5d                   	pop    %rbp
  800cd4:	c3                   	ret    

0000000000800cd5 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800cd5:	55                   	push   %rbp
  800cd6:	48 89 e5             	mov    %rsp,%rbp
  800cd9:	41 54                	push   %r12
  800cdb:	53                   	push   %rbx
  800cdc:	48 83 ec 10          	sub    $0x10,%rsp
  800ce0:	41 89 fc             	mov    %edi,%r12d
  800ce3:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800ce6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800ced:	00 00 00 
  800cf0:	83 38 00             	cmpl   $0x0,(%rax)
  800cf3:	74 5e                	je     800d53 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800cf5:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800cfb:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800d00:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800d07:	00 00 00 
  800d0a:	44 89 e6             	mov    %r12d,%esi
  800d0d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d14:	00 00 00 
  800d17:	8b 38                	mov    (%rax),%edi
  800d19:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  800d20:	00 00 00 
  800d23:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800d25:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800d2c:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800d2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d32:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d36:	48 89 de             	mov    %rbx,%rsi
  800d39:	bf 00 00 00 00       	mov    $0x0,%edi
  800d3e:	48 b8 10 28 80 00 00 	movabs $0x802810,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	call   *%rax
}
  800d4a:	48 83 c4 10          	add    $0x10,%rsp
  800d4e:	5b                   	pop    %rbx
  800d4f:	41 5c                	pop    %r12
  800d51:	5d                   	pop    %rbp
  800d52:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800d53:	bf 03 00 00 00       	mov    $0x3,%edi
  800d58:	48 b8 52 29 80 00 00 	movabs $0x802952,%rax
  800d5f:	00 00 00 
  800d62:	ff d0                	call   *%rax
  800d64:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800d6b:	00 00 
  800d6d:	eb 86                	jmp    800cf5 <fsipc+0x20>

0000000000800d6f <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800d6f:	55                   	push   %rbp
  800d70:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d73:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800d7a:	00 00 00 
  800d7d:	8b 57 0c             	mov    0xc(%rdi),%edx
  800d80:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800d82:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800d85:	be 00 00 00 00       	mov    $0x0,%esi
  800d8a:	bf 02 00 00 00       	mov    $0x2,%edi
  800d8f:	48 b8 d5 0c 80 00 00 	movabs $0x800cd5,%rax
  800d96:	00 00 00 
  800d99:	ff d0                	call   *%rax
}
  800d9b:	5d                   	pop    %rbp
  800d9c:	c3                   	ret    

0000000000800d9d <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800d9d:	55                   	push   %rbp
  800d9e:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800da1:	8b 47 0c             	mov    0xc(%rdi),%eax
  800da4:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800dab:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800dad:	be 00 00 00 00       	mov    $0x0,%esi
  800db2:	bf 06 00 00 00       	mov    $0x6,%edi
  800db7:	48 b8 d5 0c 80 00 00 	movabs $0x800cd5,%rax
  800dbe:	00 00 00 
  800dc1:	ff d0                	call   *%rax
}
  800dc3:	5d                   	pop    %rbp
  800dc4:	c3                   	ret    

0000000000800dc5 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800dc5:	55                   	push   %rbp
  800dc6:	48 89 e5             	mov    %rsp,%rbp
  800dc9:	53                   	push   %rbx
  800dca:	48 83 ec 08          	sub    $0x8,%rsp
  800dce:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800dd1:	8b 47 0c             	mov    0xc(%rdi),%eax
  800dd4:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ddb:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800ddd:	be 00 00 00 00       	mov    $0x0,%esi
  800de2:	bf 05 00 00 00       	mov    $0x5,%edi
  800de7:	48 b8 d5 0c 80 00 00 	movabs $0x800cd5,%rax
  800dee:	00 00 00 
  800df1:	ff d0                	call   *%rax
    if (res < 0) return res;
  800df3:	85 c0                	test   %eax,%eax
  800df5:	78 40                	js     800e37 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800df7:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800dfe:	00 00 00 
  800e01:	48 89 df             	mov    %rbx,%rdi
  800e04:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  800e0b:	00 00 00 
  800e0e:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800e10:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e17:	00 00 00 
  800e1a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  800e20:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e26:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  800e2c:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800e32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e37:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

0000000000800e3d <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800e3d:	55                   	push   %rbp
  800e3e:	48 89 e5             	mov    %rsp,%rbp
  800e41:	41 57                	push   %r15
  800e43:	41 56                	push   %r14
  800e45:	41 55                	push   %r13
  800e47:	41 54                	push   %r12
  800e49:	53                   	push   %rbx
  800e4a:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  800e4e:	48 85 d2             	test   %rdx,%rdx
  800e51:	0f 84 91 00 00 00    	je     800ee8 <devfile_write+0xab>
  800e57:	49 89 ff             	mov    %rdi,%r15
  800e5a:	49 89 f4             	mov    %rsi,%r12
  800e5d:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  800e60:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e67:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  800e6e:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  800e71:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  800e78:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  800e7e:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  800e82:	4c 89 ea             	mov    %r13,%rdx
  800e85:	4c 89 e6             	mov    %r12,%rsi
  800e88:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  800e8f:	00 00 00 
  800e92:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  800e99:	00 00 00 
  800e9c:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e9e:	41 8b 47 0c          	mov    0xc(%r15),%eax
  800ea2:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  800ea5:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  800ea9:	be 00 00 00 00       	mov    $0x0,%esi
  800eae:	bf 04 00 00 00       	mov    $0x4,%edi
  800eb3:	48 b8 d5 0c 80 00 00 	movabs $0x800cd5,%rax
  800eba:	00 00 00 
  800ebd:	ff d0                	call   *%rax
        if (res < 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	78 21                	js     800ee4 <devfile_write+0xa7>
        buf += res;
  800ec3:	48 63 d0             	movslq %eax,%rdx
  800ec6:	49 01 d4             	add    %rdx,%r12
        ext += res;
  800ec9:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  800ecc:	48 29 d3             	sub    %rdx,%rbx
  800ecf:	75 a0                	jne    800e71 <devfile_write+0x34>
    return ext;
  800ed1:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  800ed5:	48 83 c4 18          	add    $0x18,%rsp
  800ed9:	5b                   	pop    %rbx
  800eda:	41 5c                	pop    %r12
  800edc:	41 5d                	pop    %r13
  800ede:	41 5e                	pop    %r14
  800ee0:	41 5f                	pop    %r15
  800ee2:	5d                   	pop    %rbp
  800ee3:	c3                   	ret    
            return res;
  800ee4:	48 98                	cltq   
  800ee6:	eb ed                	jmp    800ed5 <devfile_write+0x98>
    int ext = 0;
  800ee8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  800eef:	eb e0                	jmp    800ed1 <devfile_write+0x94>

0000000000800ef1 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800ef1:	55                   	push   %rbp
  800ef2:	48 89 e5             	mov    %rsp,%rbp
  800ef5:	41 54                	push   %r12
  800ef7:	53                   	push   %rbx
  800ef8:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800efb:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f02:	00 00 00 
  800f05:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f08:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  800f0a:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  800f0e:	be 00 00 00 00       	mov    $0x0,%esi
  800f13:	bf 03 00 00 00       	mov    $0x3,%edi
  800f18:	48 b8 d5 0c 80 00 00 	movabs $0x800cd5,%rax
  800f1f:	00 00 00 
  800f22:	ff d0                	call   *%rax
    if (read < 0) 
  800f24:	85 c0                	test   %eax,%eax
  800f26:	78 27                	js     800f4f <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  800f28:	48 63 d8             	movslq %eax,%rbx
  800f2b:	48 89 da             	mov    %rbx,%rdx
  800f2e:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800f35:	00 00 00 
  800f38:	4c 89 e7             	mov    %r12,%rdi
  800f3b:	48 b8 da 25 80 00 00 	movabs $0x8025da,%rax
  800f42:	00 00 00 
  800f45:	ff d0                	call   *%rax
    return read;
  800f47:	48 89 d8             	mov    %rbx,%rax
}
  800f4a:	5b                   	pop    %rbx
  800f4b:	41 5c                	pop    %r12
  800f4d:	5d                   	pop    %rbp
  800f4e:	c3                   	ret    
		return read;
  800f4f:	48 98                	cltq   
  800f51:	eb f7                	jmp    800f4a <devfile_read+0x59>

0000000000800f53 <open>:
open(const char *path, int mode) {
  800f53:	55                   	push   %rbp
  800f54:	48 89 e5             	mov    %rsp,%rbp
  800f57:	41 55                	push   %r13
  800f59:	41 54                	push   %r12
  800f5b:	53                   	push   %rbx
  800f5c:	48 83 ec 18          	sub    $0x18,%rsp
  800f60:	49 89 fc             	mov    %rdi,%r12
  800f63:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  800f66:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  800f6d:	00 00 00 
  800f70:	ff d0                	call   *%rax
  800f72:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  800f78:	0f 87 8c 00 00 00    	ja     80100a <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  800f7e:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  800f82:	48 b8 1e 06 80 00 00 	movabs $0x80061e,%rax
  800f89:	00 00 00 
  800f8c:	ff d0                	call   *%rax
  800f8e:	89 c3                	mov    %eax,%ebx
  800f90:	85 c0                	test   %eax,%eax
  800f92:	78 52                	js     800fe6 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  800f94:	4c 89 e6             	mov    %r12,%rsi
  800f97:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  800f9e:	00 00 00 
  800fa1:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  800fa8:	00 00 00 
  800fab:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  800fad:	44 89 e8             	mov    %r13d,%eax
  800fb0:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  800fb7:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fb9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800fbd:	bf 01 00 00 00       	mov    $0x1,%edi
  800fc2:	48 b8 d5 0c 80 00 00 	movabs $0x800cd5,%rax
  800fc9:	00 00 00 
  800fcc:	ff d0                	call   *%rax
  800fce:	89 c3                	mov    %eax,%ebx
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	78 1f                	js     800ff3 <open+0xa0>
    return fd2num(fd);
  800fd4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800fd8:	48 b8 f0 05 80 00 00 	movabs $0x8005f0,%rax
  800fdf:	00 00 00 
  800fe2:	ff d0                	call   *%rax
  800fe4:	89 c3                	mov    %eax,%ebx
}
  800fe6:	89 d8                	mov    %ebx,%eax
  800fe8:	48 83 c4 18          	add    $0x18,%rsp
  800fec:	5b                   	pop    %rbx
  800fed:	41 5c                	pop    %r12
  800fef:	41 5d                	pop    %r13
  800ff1:	5d                   	pop    %rbp
  800ff2:	c3                   	ret    
        fd_close(fd, 0);
  800ff3:	be 00 00 00 00       	mov    $0x0,%esi
  800ff8:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ffc:	48 b8 42 07 80 00 00 	movabs $0x800742,%rax
  801003:	00 00 00 
  801006:	ff d0                	call   *%rax
        return res;
  801008:	eb dc                	jmp    800fe6 <open+0x93>
        return -E_BAD_PATH;
  80100a:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80100f:	eb d5                	jmp    800fe6 <open+0x93>

0000000000801011 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801011:	55                   	push   %rbp
  801012:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801015:	be 00 00 00 00       	mov    $0x0,%esi
  80101a:	bf 08 00 00 00       	mov    $0x8,%edi
  80101f:	48 b8 d5 0c 80 00 00 	movabs $0x800cd5,%rax
  801026:	00 00 00 
  801029:	ff d0                	call   *%rax
}
  80102b:	5d                   	pop    %rbp
  80102c:	c3                   	ret    

000000000080102d <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80102d:	55                   	push   %rbp
  80102e:	48 89 e5             	mov    %rsp,%rbp
  801031:	41 54                	push   %r12
  801033:	53                   	push   %rbx
  801034:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801037:	48 b8 02 06 80 00 00 	movabs $0x800602,%rax
  80103e:	00 00 00 
  801041:	ff d0                	call   *%rax
  801043:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801046:	48 be a0 2a 80 00 00 	movabs $0x802aa0,%rsi
  80104d:	00 00 00 
  801050:	48 89 df             	mov    %rbx,%rdi
  801053:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  80105a:	00 00 00 
  80105d:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80105f:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801064:	41 2b 04 24          	sub    (%r12),%eax
  801068:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80106e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801075:	00 00 00 
    stat->st_dev = &devpipe;
  801078:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80107f:	00 00 00 
  801082:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801089:	b8 00 00 00 00       	mov    $0x0,%eax
  80108e:	5b                   	pop    %rbx
  80108f:	41 5c                	pop    %r12
  801091:	5d                   	pop    %rbp
  801092:	c3                   	ret    

0000000000801093 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801093:	55                   	push   %rbp
  801094:	48 89 e5             	mov    %rsp,%rbp
  801097:	41 54                	push   %r12
  801099:	53                   	push   %rbx
  80109a:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80109d:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010a2:	48 89 fe             	mov    %rdi,%rsi
  8010a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8010aa:	49 bc 57 03 80 00 00 	movabs $0x800357,%r12
  8010b1:	00 00 00 
  8010b4:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8010b7:	48 89 df             	mov    %rbx,%rdi
  8010ba:	48 b8 02 06 80 00 00 	movabs $0x800602,%rax
  8010c1:	00 00 00 
  8010c4:	ff d0                	call   *%rax
  8010c6:	48 89 c6             	mov    %rax,%rsi
  8010c9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8010d3:	41 ff d4             	call   *%r12
}
  8010d6:	5b                   	pop    %rbx
  8010d7:	41 5c                	pop    %r12
  8010d9:	5d                   	pop    %rbp
  8010da:	c3                   	ret    

00000000008010db <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8010db:	55                   	push   %rbp
  8010dc:	48 89 e5             	mov    %rsp,%rbp
  8010df:	41 57                	push   %r15
  8010e1:	41 56                	push   %r14
  8010e3:	41 55                	push   %r13
  8010e5:	41 54                	push   %r12
  8010e7:	53                   	push   %rbx
  8010e8:	48 83 ec 18          	sub    $0x18,%rsp
  8010ec:	49 89 fc             	mov    %rdi,%r12
  8010ef:	49 89 f5             	mov    %rsi,%r13
  8010f2:	49 89 d7             	mov    %rdx,%r15
  8010f5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8010f9:	48 b8 02 06 80 00 00 	movabs $0x800602,%rax
  801100:	00 00 00 
  801103:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801105:	4d 85 ff             	test   %r15,%r15
  801108:	0f 84 ac 00 00 00    	je     8011ba <devpipe_write+0xdf>
  80110e:	48 89 c3             	mov    %rax,%rbx
  801111:	4c 89 f8             	mov    %r15,%rax
  801114:	4d 89 ef             	mov    %r13,%r15
  801117:	49 01 c5             	add    %rax,%r13
  80111a:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80111e:	49 bd 5f 02 80 00 00 	movabs $0x80025f,%r13
  801125:	00 00 00 
            sys_yield();
  801128:	49 be fc 01 80 00 00 	movabs $0x8001fc,%r14
  80112f:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801132:	8b 73 04             	mov    0x4(%rbx),%esi
  801135:	48 63 ce             	movslq %esi,%rcx
  801138:	48 63 03             	movslq (%rbx),%rax
  80113b:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801141:	48 39 c1             	cmp    %rax,%rcx
  801144:	72 2e                	jb     801174 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801146:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80114b:	48 89 da             	mov    %rbx,%rdx
  80114e:	be 00 10 00 00       	mov    $0x1000,%esi
  801153:	4c 89 e7             	mov    %r12,%rdi
  801156:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801159:	85 c0                	test   %eax,%eax
  80115b:	74 63                	je     8011c0 <devpipe_write+0xe5>
            sys_yield();
  80115d:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801160:	8b 73 04             	mov    0x4(%rbx),%esi
  801163:	48 63 ce             	movslq %esi,%rcx
  801166:	48 63 03             	movslq (%rbx),%rax
  801169:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80116f:	48 39 c1             	cmp    %rax,%rcx
  801172:	73 d2                	jae    801146 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801174:	41 0f b6 3f          	movzbl (%r15),%edi
  801178:	48 89 ca             	mov    %rcx,%rdx
  80117b:	48 c1 ea 03          	shr    $0x3,%rdx
  80117f:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801186:	08 10 20 
  801189:	48 f7 e2             	mul    %rdx
  80118c:	48 c1 ea 06          	shr    $0x6,%rdx
  801190:	48 89 d0             	mov    %rdx,%rax
  801193:	48 c1 e0 09          	shl    $0x9,%rax
  801197:	48 29 d0             	sub    %rdx,%rax
  80119a:	48 c1 e0 03          	shl    $0x3,%rax
  80119e:	48 29 c1             	sub    %rax,%rcx
  8011a1:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8011a6:	83 c6 01             	add    $0x1,%esi
  8011a9:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8011ac:	49 83 c7 01          	add    $0x1,%r15
  8011b0:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8011b4:	0f 85 78 ff ff ff    	jne    801132 <devpipe_write+0x57>
    return n;
  8011ba:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8011be:	eb 05                	jmp    8011c5 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c5:	48 83 c4 18          	add    $0x18,%rsp
  8011c9:	5b                   	pop    %rbx
  8011ca:	41 5c                	pop    %r12
  8011cc:	41 5d                	pop    %r13
  8011ce:	41 5e                	pop    %r14
  8011d0:	41 5f                	pop    %r15
  8011d2:	5d                   	pop    %rbp
  8011d3:	c3                   	ret    

00000000008011d4 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8011d4:	55                   	push   %rbp
  8011d5:	48 89 e5             	mov    %rsp,%rbp
  8011d8:	41 57                	push   %r15
  8011da:	41 56                	push   %r14
  8011dc:	41 55                	push   %r13
  8011de:	41 54                	push   %r12
  8011e0:	53                   	push   %rbx
  8011e1:	48 83 ec 18          	sub    $0x18,%rsp
  8011e5:	49 89 fc             	mov    %rdi,%r12
  8011e8:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8011ec:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8011f0:	48 b8 02 06 80 00 00 	movabs $0x800602,%rax
  8011f7:	00 00 00 
  8011fa:	ff d0                	call   *%rax
  8011fc:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8011ff:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801205:	49 bd 5f 02 80 00 00 	movabs $0x80025f,%r13
  80120c:	00 00 00 
            sys_yield();
  80120f:	49 be fc 01 80 00 00 	movabs $0x8001fc,%r14
  801216:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801219:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80121e:	74 7a                	je     80129a <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801220:	8b 03                	mov    (%rbx),%eax
  801222:	3b 43 04             	cmp    0x4(%rbx),%eax
  801225:	75 26                	jne    80124d <devpipe_read+0x79>
            if (i > 0) return i;
  801227:	4d 85 ff             	test   %r15,%r15
  80122a:	75 74                	jne    8012a0 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80122c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801231:	48 89 da             	mov    %rbx,%rdx
  801234:	be 00 10 00 00       	mov    $0x1000,%esi
  801239:	4c 89 e7             	mov    %r12,%rdi
  80123c:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80123f:	85 c0                	test   %eax,%eax
  801241:	74 6f                	je     8012b2 <devpipe_read+0xde>
            sys_yield();
  801243:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801246:	8b 03                	mov    (%rbx),%eax
  801248:	3b 43 04             	cmp    0x4(%rbx),%eax
  80124b:	74 df                	je     80122c <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80124d:	48 63 c8             	movslq %eax,%rcx
  801250:	48 89 ca             	mov    %rcx,%rdx
  801253:	48 c1 ea 03          	shr    $0x3,%rdx
  801257:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80125e:	08 10 20 
  801261:	48 f7 e2             	mul    %rdx
  801264:	48 c1 ea 06          	shr    $0x6,%rdx
  801268:	48 89 d0             	mov    %rdx,%rax
  80126b:	48 c1 e0 09          	shl    $0x9,%rax
  80126f:	48 29 d0             	sub    %rdx,%rax
  801272:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801279:	00 
  80127a:	48 89 c8             	mov    %rcx,%rax
  80127d:	48 29 d0             	sub    %rdx,%rax
  801280:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  801285:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801289:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80128d:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  801290:	49 83 c7 01          	add    $0x1,%r15
  801294:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  801298:	75 86                	jne    801220 <devpipe_read+0x4c>
    return n;
  80129a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80129e:	eb 03                	jmp    8012a3 <devpipe_read+0xcf>
            if (i > 0) return i;
  8012a0:	4c 89 f8             	mov    %r15,%rax
}
  8012a3:	48 83 c4 18          	add    $0x18,%rsp
  8012a7:	5b                   	pop    %rbx
  8012a8:	41 5c                	pop    %r12
  8012aa:	41 5d                	pop    %r13
  8012ac:	41 5e                	pop    %r14
  8012ae:	41 5f                	pop    %r15
  8012b0:	5d                   	pop    %rbp
  8012b1:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8012b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b7:	eb ea                	jmp    8012a3 <devpipe_read+0xcf>

00000000008012b9 <pipe>:
pipe(int pfd[2]) {
  8012b9:	55                   	push   %rbp
  8012ba:	48 89 e5             	mov    %rsp,%rbp
  8012bd:	41 55                	push   %r13
  8012bf:	41 54                	push   %r12
  8012c1:	53                   	push   %rbx
  8012c2:	48 83 ec 18          	sub    $0x18,%rsp
  8012c6:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8012c9:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8012cd:	48 b8 1e 06 80 00 00 	movabs $0x80061e,%rax
  8012d4:	00 00 00 
  8012d7:	ff d0                	call   *%rax
  8012d9:	89 c3                	mov    %eax,%ebx
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	0f 88 a0 01 00 00    	js     801483 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8012e3:	b9 46 00 00 00       	mov    $0x46,%ecx
  8012e8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8012ed:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8012f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8012f6:	48 b8 8b 02 80 00 00 	movabs $0x80028b,%rax
  8012fd:	00 00 00 
  801300:	ff d0                	call   *%rax
  801302:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801304:	85 c0                	test   %eax,%eax
  801306:	0f 88 77 01 00 00    	js     801483 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80130c:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  801310:	48 b8 1e 06 80 00 00 	movabs $0x80061e,%rax
  801317:	00 00 00 
  80131a:	ff d0                	call   *%rax
  80131c:	89 c3                	mov    %eax,%ebx
  80131e:	85 c0                	test   %eax,%eax
  801320:	0f 88 43 01 00 00    	js     801469 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  801326:	b9 46 00 00 00       	mov    $0x46,%ecx
  80132b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801330:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801334:	bf 00 00 00 00       	mov    $0x0,%edi
  801339:	48 b8 8b 02 80 00 00 	movabs $0x80028b,%rax
  801340:	00 00 00 
  801343:	ff d0                	call   *%rax
  801345:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  801347:	85 c0                	test   %eax,%eax
  801349:	0f 88 1a 01 00 00    	js     801469 <pipe+0x1b0>
    va = fd2data(fd0);
  80134f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801353:	48 b8 02 06 80 00 00 	movabs $0x800602,%rax
  80135a:	00 00 00 
  80135d:	ff d0                	call   *%rax
  80135f:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801362:	b9 46 00 00 00       	mov    $0x46,%ecx
  801367:	ba 00 10 00 00       	mov    $0x1000,%edx
  80136c:	48 89 c6             	mov    %rax,%rsi
  80136f:	bf 00 00 00 00       	mov    $0x0,%edi
  801374:	48 b8 8b 02 80 00 00 	movabs $0x80028b,%rax
  80137b:	00 00 00 
  80137e:	ff d0                	call   *%rax
  801380:	89 c3                	mov    %eax,%ebx
  801382:	85 c0                	test   %eax,%eax
  801384:	0f 88 c5 00 00 00    	js     80144f <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80138a:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80138e:	48 b8 02 06 80 00 00 	movabs $0x800602,%rax
  801395:	00 00 00 
  801398:	ff d0                	call   *%rax
  80139a:	48 89 c1             	mov    %rax,%rcx
  80139d:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8013a3:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8013a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ae:	4c 89 ee             	mov    %r13,%rsi
  8013b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8013b6:	48 b8 f2 02 80 00 00 	movabs $0x8002f2,%rax
  8013bd:	00 00 00 
  8013c0:	ff d0                	call   *%rax
  8013c2:	89 c3                	mov    %eax,%ebx
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	78 6e                	js     801436 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8013c8:	be 00 10 00 00       	mov    $0x1000,%esi
  8013cd:	4c 89 ef             	mov    %r13,%rdi
  8013d0:	48 b8 2d 02 80 00 00 	movabs $0x80022d,%rax
  8013d7:	00 00 00 
  8013da:	ff d0                	call   *%rax
  8013dc:	83 f8 02             	cmp    $0x2,%eax
  8013df:	0f 85 ab 00 00 00    	jne    801490 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8013e5:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8013ec:	00 00 
  8013ee:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013f2:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8013f4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013f8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8013ff:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801403:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801405:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801409:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801410:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801414:	48 bb f0 05 80 00 00 	movabs $0x8005f0,%rbx
  80141b:	00 00 00 
  80141e:	ff d3                	call   *%rbx
  801420:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801424:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801428:	ff d3                	call   *%rbx
  80142a:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80142f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801434:	eb 4d                	jmp    801483 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  801436:	ba 00 10 00 00       	mov    $0x1000,%edx
  80143b:	4c 89 ee             	mov    %r13,%rsi
  80143e:	bf 00 00 00 00       	mov    $0x0,%edi
  801443:	48 b8 57 03 80 00 00 	movabs $0x800357,%rax
  80144a:	00 00 00 
  80144d:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80144f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801454:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801458:	bf 00 00 00 00       	mov    $0x0,%edi
  80145d:	48 b8 57 03 80 00 00 	movabs $0x800357,%rax
  801464:	00 00 00 
  801467:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  801469:	ba 00 10 00 00       	mov    $0x1000,%edx
  80146e:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801472:	bf 00 00 00 00       	mov    $0x0,%edi
  801477:	48 b8 57 03 80 00 00 	movabs $0x800357,%rax
  80147e:	00 00 00 
  801481:	ff d0                	call   *%rax
}
  801483:	89 d8                	mov    %ebx,%eax
  801485:	48 83 c4 18          	add    $0x18,%rsp
  801489:	5b                   	pop    %rbx
  80148a:	41 5c                	pop    %r12
  80148c:	41 5d                	pop    %r13
  80148e:	5d                   	pop    %rbp
  80148f:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  801490:	48 b9 d0 2a 80 00 00 	movabs $0x802ad0,%rcx
  801497:	00 00 00 
  80149a:	48 ba a7 2a 80 00 00 	movabs $0x802aa7,%rdx
  8014a1:	00 00 00 
  8014a4:	be 2e 00 00 00       	mov    $0x2e,%esi
  8014a9:	48 bf bc 2a 80 00 00 	movabs $0x802abc,%rdi
  8014b0:	00 00 00 
  8014b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b8:	49 b8 4e 19 80 00 00 	movabs $0x80194e,%r8
  8014bf:	00 00 00 
  8014c2:	41 ff d0             	call   *%r8

00000000008014c5 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8014c5:	55                   	push   %rbp
  8014c6:	48 89 e5             	mov    %rsp,%rbp
  8014c9:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8014cd:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8014d1:	48 b8 7e 06 80 00 00 	movabs $0x80067e,%rax
  8014d8:	00 00 00 
  8014db:	ff d0                	call   *%rax
    if (res < 0) return res;
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	78 35                	js     801516 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8014e1:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8014e5:	48 b8 02 06 80 00 00 	movabs $0x800602,%rax
  8014ec:	00 00 00 
  8014ef:	ff d0                	call   *%rax
  8014f1:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8014f4:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8014f9:	be 00 10 00 00       	mov    $0x1000,%esi
  8014fe:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801502:	48 b8 5f 02 80 00 00 	movabs $0x80025f,%rax
  801509:	00 00 00 
  80150c:	ff d0                	call   *%rax
  80150e:	85 c0                	test   %eax,%eax
  801510:	0f 94 c0             	sete   %al
  801513:	0f b6 c0             	movzbl %al,%eax
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

0000000000801518 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801518:	48 89 f8             	mov    %rdi,%rax
  80151b:	48 c1 e8 27          	shr    $0x27,%rax
  80151f:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  801526:	01 00 00 
  801529:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80152d:	f6 c2 01             	test   $0x1,%dl
  801530:	74 6d                	je     80159f <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801532:	48 89 f8             	mov    %rdi,%rax
  801535:	48 c1 e8 1e          	shr    $0x1e,%rax
  801539:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801540:	01 00 00 
  801543:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801547:	f6 c2 01             	test   $0x1,%dl
  80154a:	74 62                	je     8015ae <get_uvpt_entry+0x96>
  80154c:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801553:	01 00 00 
  801556:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80155a:	f6 c2 80             	test   $0x80,%dl
  80155d:	75 4f                	jne    8015ae <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80155f:	48 89 f8             	mov    %rdi,%rax
  801562:	48 c1 e8 15          	shr    $0x15,%rax
  801566:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80156d:	01 00 00 
  801570:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801574:	f6 c2 01             	test   $0x1,%dl
  801577:	74 44                	je     8015bd <get_uvpt_entry+0xa5>
  801579:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801580:	01 00 00 
  801583:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801587:	f6 c2 80             	test   $0x80,%dl
  80158a:	75 31                	jne    8015bd <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  80158c:	48 c1 ef 0c          	shr    $0xc,%rdi
  801590:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801597:	01 00 00 
  80159a:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80159e:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80159f:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8015a6:	01 00 00 
  8015a9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015ad:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8015ae:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8015b5:	01 00 00 
  8015b8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015bc:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8015bd:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8015c4:	01 00 00 
  8015c7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015cb:	c3                   	ret    

00000000008015cc <get_prot>:

int
get_prot(void *va) {
  8015cc:	55                   	push   %rbp
  8015cd:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8015d0:	48 b8 18 15 80 00 00 	movabs $0x801518,%rax
  8015d7:	00 00 00 
  8015da:	ff d0                	call   *%rax
  8015dc:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8015df:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8015e4:	89 c1                	mov    %eax,%ecx
  8015e6:	83 c9 04             	or     $0x4,%ecx
  8015e9:	f6 c2 01             	test   $0x1,%dl
  8015ec:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8015ef:	89 c1                	mov    %eax,%ecx
  8015f1:	83 c9 02             	or     $0x2,%ecx
  8015f4:	f6 c2 02             	test   $0x2,%dl
  8015f7:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8015fa:	89 c1                	mov    %eax,%ecx
  8015fc:	83 c9 01             	or     $0x1,%ecx
  8015ff:	48 85 d2             	test   %rdx,%rdx
  801602:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801605:	89 c1                	mov    %eax,%ecx
  801607:	83 c9 40             	or     $0x40,%ecx
  80160a:	f6 c6 04             	test   $0x4,%dh
  80160d:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801610:	5d                   	pop    %rbp
  801611:	c3                   	ret    

0000000000801612 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801612:	55                   	push   %rbp
  801613:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801616:	48 b8 18 15 80 00 00 	movabs $0x801518,%rax
  80161d:	00 00 00 
  801620:	ff d0                	call   *%rax
    return pte & PTE_D;
  801622:	48 c1 e8 06          	shr    $0x6,%rax
  801626:	83 e0 01             	and    $0x1,%eax
}
  801629:	5d                   	pop    %rbp
  80162a:	c3                   	ret    

000000000080162b <is_page_present>:

bool
is_page_present(void *va) {
  80162b:	55                   	push   %rbp
  80162c:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80162f:	48 b8 18 15 80 00 00 	movabs $0x801518,%rax
  801636:	00 00 00 
  801639:	ff d0                	call   *%rax
  80163b:	83 e0 01             	and    $0x1,%eax
}
  80163e:	5d                   	pop    %rbp
  80163f:	c3                   	ret    

0000000000801640 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801640:	55                   	push   %rbp
  801641:	48 89 e5             	mov    %rsp,%rbp
  801644:	41 57                	push   %r15
  801646:	41 56                	push   %r14
  801648:	41 55                	push   %r13
  80164a:	41 54                	push   %r12
  80164c:	53                   	push   %rbx
  80164d:	48 83 ec 28          	sub    $0x28,%rsp
  801651:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  801655:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  801659:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  80165e:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  801665:	01 00 00 
  801668:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  80166f:	01 00 00 
  801672:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  801679:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80167c:	49 bf cc 15 80 00 00 	movabs $0x8015cc,%r15
  801683:	00 00 00 
  801686:	eb 16                	jmp    80169e <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  801688:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  80168f:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  801696:	00 00 00 
  801699:	48 39 c3             	cmp    %rax,%rbx
  80169c:	77 73                	ja     801711 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  80169e:	48 89 d8             	mov    %rbx,%rax
  8016a1:	48 c1 e8 27          	shr    $0x27,%rax
  8016a5:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8016a9:	a8 01                	test   $0x1,%al
  8016ab:	74 db                	je     801688 <foreach_shared_region+0x48>
  8016ad:	48 89 d8             	mov    %rbx,%rax
  8016b0:	48 c1 e8 1e          	shr    $0x1e,%rax
  8016b4:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8016b9:	a8 01                	test   $0x1,%al
  8016bb:	74 cb                	je     801688 <foreach_shared_region+0x48>
  8016bd:	48 89 d8             	mov    %rbx,%rax
  8016c0:	48 c1 e8 15          	shr    $0x15,%rax
  8016c4:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8016c8:	a8 01                	test   $0x1,%al
  8016ca:	74 bc                	je     801688 <foreach_shared_region+0x48>
        void *start = (void*)i;
  8016cc:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016d0:	48 89 df             	mov    %rbx,%rdi
  8016d3:	41 ff d7             	call   *%r15
  8016d6:	a8 40                	test   $0x40,%al
  8016d8:	75 09                	jne    8016e3 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8016da:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8016e1:	eb ac                	jmp    80168f <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016e3:	48 89 df             	mov    %rbx,%rdi
  8016e6:	48 b8 2b 16 80 00 00 	movabs $0x80162b,%rax
  8016ed:	00 00 00 
  8016f0:	ff d0                	call   *%rax
  8016f2:	84 c0                	test   %al,%al
  8016f4:	74 e4                	je     8016da <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  8016f6:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  8016fd:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801701:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  801705:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801709:	ff d0                	call   *%rax
  80170b:	85 c0                	test   %eax,%eax
  80170d:	79 cb                	jns    8016da <foreach_shared_region+0x9a>
  80170f:	eb 05                	jmp    801716 <foreach_shared_region+0xd6>
    }
    return 0;
  801711:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801716:	48 83 c4 28          	add    $0x28,%rsp
  80171a:	5b                   	pop    %rbx
  80171b:	41 5c                	pop    %r12
  80171d:	41 5d                	pop    %r13
  80171f:	41 5e                	pop    %r14
  801721:	41 5f                	pop    %r15
  801723:	5d                   	pop    %rbp
  801724:	c3                   	ret    

0000000000801725 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
  80172a:	c3                   	ret    

000000000080172b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80172b:	55                   	push   %rbp
  80172c:	48 89 e5             	mov    %rsp,%rbp
  80172f:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  801732:	48 be f4 2a 80 00 00 	movabs $0x802af4,%rsi
  801739:	00 00 00 
  80173c:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  801743:	00 00 00 
  801746:	ff d0                	call   *%rax
    return 0;
}
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
  80174d:	5d                   	pop    %rbp
  80174e:	c3                   	ret    

000000000080174f <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80174f:	55                   	push   %rbp
  801750:	48 89 e5             	mov    %rsp,%rbp
  801753:	41 57                	push   %r15
  801755:	41 56                	push   %r14
  801757:	41 55                	push   %r13
  801759:	41 54                	push   %r12
  80175b:	53                   	push   %rbx
  80175c:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  801763:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80176a:	48 85 d2             	test   %rdx,%rdx
  80176d:	74 78                	je     8017e7 <devcons_write+0x98>
  80176f:	49 89 d6             	mov    %rdx,%r14
  801772:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801778:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  80177d:	49 bf da 25 80 00 00 	movabs $0x8025da,%r15
  801784:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801787:	4c 89 f3             	mov    %r14,%rbx
  80178a:	48 29 f3             	sub    %rsi,%rbx
  80178d:	48 83 fb 7f          	cmp    $0x7f,%rbx
  801791:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801796:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  80179a:	4c 63 eb             	movslq %ebx,%r13
  80179d:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8017a4:	4c 89 ea             	mov    %r13,%rdx
  8017a7:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017ae:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8017b1:	4c 89 ee             	mov    %r13,%rsi
  8017b4:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017bb:	48 b8 02 01 80 00 00 	movabs $0x800102,%rax
  8017c2:	00 00 00 
  8017c5:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8017c7:	41 01 dc             	add    %ebx,%r12d
  8017ca:	49 63 f4             	movslq %r12d,%rsi
  8017cd:	4c 39 f6             	cmp    %r14,%rsi
  8017d0:	72 b5                	jb     801787 <devcons_write+0x38>
    return res;
  8017d2:	49 63 c4             	movslq %r12d,%rax
}
  8017d5:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8017dc:	5b                   	pop    %rbx
  8017dd:	41 5c                	pop    %r12
  8017df:	41 5d                	pop    %r13
  8017e1:	41 5e                	pop    %r14
  8017e3:	41 5f                	pop    %r15
  8017e5:	5d                   	pop    %rbp
  8017e6:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8017e7:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8017ed:	eb e3                	jmp    8017d2 <devcons_write+0x83>

00000000008017ef <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8017ef:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8017f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f7:	48 85 c0             	test   %rax,%rax
  8017fa:	74 55                	je     801851 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8017fc:	55                   	push   %rbp
  8017fd:	48 89 e5             	mov    %rsp,%rbp
  801800:	41 55                	push   %r13
  801802:	41 54                	push   %r12
  801804:	53                   	push   %rbx
  801805:	48 83 ec 08          	sub    $0x8,%rsp
  801809:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  80180c:	48 bb 2f 01 80 00 00 	movabs $0x80012f,%rbx
  801813:	00 00 00 
  801816:	49 bc fc 01 80 00 00 	movabs $0x8001fc,%r12
  80181d:	00 00 00 
  801820:	eb 03                	jmp    801825 <devcons_read+0x36>
  801822:	41 ff d4             	call   *%r12
  801825:	ff d3                	call   *%rbx
  801827:	85 c0                	test   %eax,%eax
  801829:	74 f7                	je     801822 <devcons_read+0x33>
    if (c < 0) return c;
  80182b:	48 63 d0             	movslq %eax,%rdx
  80182e:	78 13                	js     801843 <devcons_read+0x54>
    if (c == 0x04) return 0;
  801830:	ba 00 00 00 00       	mov    $0x0,%edx
  801835:	83 f8 04             	cmp    $0x4,%eax
  801838:	74 09                	je     801843 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  80183a:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80183e:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801843:	48 89 d0             	mov    %rdx,%rax
  801846:	48 83 c4 08          	add    $0x8,%rsp
  80184a:	5b                   	pop    %rbx
  80184b:	41 5c                	pop    %r12
  80184d:	41 5d                	pop    %r13
  80184f:	5d                   	pop    %rbp
  801850:	c3                   	ret    
  801851:	48 89 d0             	mov    %rdx,%rax
  801854:	c3                   	ret    

0000000000801855 <cputchar>:
cputchar(int ch) {
  801855:	55                   	push   %rbp
  801856:	48 89 e5             	mov    %rsp,%rbp
  801859:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  80185d:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801861:	be 01 00 00 00       	mov    $0x1,%esi
  801866:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80186a:	48 b8 02 01 80 00 00 	movabs $0x800102,%rax
  801871:	00 00 00 
  801874:	ff d0                	call   *%rax
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

0000000000801878 <getchar>:
getchar(void) {
  801878:	55                   	push   %rbp
  801879:	48 89 e5             	mov    %rsp,%rbp
  80187c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801880:	ba 01 00 00 00       	mov    $0x1,%edx
  801885:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801889:	bf 00 00 00 00       	mov    $0x0,%edi
  80188e:	48 b8 61 09 80 00 00 	movabs $0x800961,%rax
  801895:	00 00 00 
  801898:	ff d0                	call   *%rax
  80189a:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  80189c:	85 c0                	test   %eax,%eax
  80189e:	78 06                	js     8018a6 <getchar+0x2e>
  8018a0:	74 08                	je     8018aa <getchar+0x32>
  8018a2:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8018a6:	89 d0                	mov    %edx,%eax
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8018aa:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8018af:	eb f5                	jmp    8018a6 <getchar+0x2e>

00000000008018b1 <iscons>:
iscons(int fdnum) {
  8018b1:	55                   	push   %rbp
  8018b2:	48 89 e5             	mov    %rsp,%rbp
  8018b5:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8018b9:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018bd:	48 b8 7e 06 80 00 00 	movabs $0x80067e,%rax
  8018c4:	00 00 00 
  8018c7:	ff d0                	call   *%rax
    if (res < 0) return res;
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	78 18                	js     8018e5 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8018cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018d1:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8018d8:	00 00 00 
  8018db:	8b 00                	mov    (%rax),%eax
  8018dd:	39 02                	cmp    %eax,(%rdx)
  8018df:	0f 94 c0             	sete   %al
  8018e2:	0f b6 c0             	movzbl %al,%eax
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

00000000008018e7 <opencons>:
opencons(void) {
  8018e7:	55                   	push   %rbp
  8018e8:	48 89 e5             	mov    %rsp,%rbp
  8018eb:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8018ef:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8018f3:	48 b8 1e 06 80 00 00 	movabs $0x80061e,%rax
  8018fa:	00 00 00 
  8018fd:	ff d0                	call   *%rax
  8018ff:	85 c0                	test   %eax,%eax
  801901:	78 49                	js     80194c <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801903:	b9 46 00 00 00       	mov    $0x46,%ecx
  801908:	ba 00 10 00 00       	mov    $0x1000,%edx
  80190d:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801911:	bf 00 00 00 00       	mov    $0x0,%edi
  801916:	48 b8 8b 02 80 00 00 	movabs $0x80028b,%rax
  80191d:	00 00 00 
  801920:	ff d0                	call   *%rax
  801922:	85 c0                	test   %eax,%eax
  801924:	78 26                	js     80194c <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  801926:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80192a:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801931:	00 00 
  801933:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801935:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801939:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801940:	48 b8 f0 05 80 00 00 	movabs $0x8005f0,%rax
  801947:	00 00 00 
  80194a:	ff d0                	call   *%rax
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

000000000080194e <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80194e:	55                   	push   %rbp
  80194f:	48 89 e5             	mov    %rsp,%rbp
  801952:	41 56                	push   %r14
  801954:	41 55                	push   %r13
  801956:	41 54                	push   %r12
  801958:	53                   	push   %rbx
  801959:	48 83 ec 50          	sub    $0x50,%rsp
  80195d:	49 89 fc             	mov    %rdi,%r12
  801960:	41 89 f5             	mov    %esi,%r13d
  801963:	48 89 d3             	mov    %rdx,%rbx
  801966:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80196a:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80196e:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801972:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801979:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80197d:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801981:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801985:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801989:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801990:	00 00 00 
  801993:	4c 8b 30             	mov    (%rax),%r14
  801996:	48 b8 cb 01 80 00 00 	movabs $0x8001cb,%rax
  80199d:	00 00 00 
  8019a0:	ff d0                	call   *%rax
  8019a2:	89 c6                	mov    %eax,%esi
  8019a4:	45 89 e8             	mov    %r13d,%r8d
  8019a7:	4c 89 e1             	mov    %r12,%rcx
  8019aa:	4c 89 f2             	mov    %r14,%rdx
  8019ad:	48 bf 00 2b 80 00 00 	movabs $0x802b00,%rdi
  8019b4:	00 00 00 
  8019b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bc:	49 bc 9e 1a 80 00 00 	movabs $0x801a9e,%r12
  8019c3:	00 00 00 
  8019c6:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8019c9:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8019cd:	48 89 df             	mov    %rbx,%rdi
  8019d0:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  8019d7:	00 00 00 
  8019da:	ff d0                	call   *%rax
    cprintf("\n");
  8019dc:	48 bf 4b 2a 80 00 00 	movabs $0x802a4b,%rdi
  8019e3:	00 00 00 
  8019e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019eb:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8019ee:	cc                   	int3   
  8019ef:	eb fd                	jmp    8019ee <_panic+0xa0>

00000000008019f1 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8019f1:	55                   	push   %rbp
  8019f2:	48 89 e5             	mov    %rsp,%rbp
  8019f5:	53                   	push   %rbx
  8019f6:	48 83 ec 08          	sub    $0x8,%rsp
  8019fa:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8019fd:	8b 06                	mov    (%rsi),%eax
  8019ff:	8d 50 01             	lea    0x1(%rax),%edx
  801a02:	89 16                	mov    %edx,(%rsi)
  801a04:	48 98                	cltq   
  801a06:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801a0b:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801a11:	74 0a                	je     801a1d <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801a13:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801a17:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  801a1d:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801a21:	be ff 00 00 00       	mov    $0xff,%esi
  801a26:	48 b8 02 01 80 00 00 	movabs $0x800102,%rax
  801a2d:	00 00 00 
  801a30:	ff d0                	call   *%rax
        state->offset = 0;
  801a32:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801a38:	eb d9                	jmp    801a13 <putch+0x22>

0000000000801a3a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801a3a:	55                   	push   %rbp
  801a3b:	48 89 e5             	mov    %rsp,%rbp
  801a3e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801a45:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801a48:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801a4f:	b9 21 00 00 00       	mov    $0x21,%ecx
  801a54:	b8 00 00 00 00       	mov    $0x0,%eax
  801a59:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801a5c:	48 89 f1             	mov    %rsi,%rcx
  801a5f:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801a66:	48 bf f1 19 80 00 00 	movabs $0x8019f1,%rdi
  801a6d:	00 00 00 
  801a70:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  801a77:	00 00 00 
  801a7a:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801a7c:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801a83:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801a8a:	48 b8 02 01 80 00 00 	movabs $0x800102,%rax
  801a91:	00 00 00 
  801a94:	ff d0                	call   *%rax

    return state.count;
}
  801a96:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

0000000000801a9e <cprintf>:

int
cprintf(const char *fmt, ...) {
  801a9e:	55                   	push   %rbp
  801a9f:	48 89 e5             	mov    %rsp,%rbp
  801aa2:	48 83 ec 50          	sub    $0x50,%rsp
  801aa6:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801aaa:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801aae:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ab2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801ab6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801aba:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801ac1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ac5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ac9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801acd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801ad1:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801ad5:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  801adc:	00 00 00 
  801adf:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

0000000000801ae3 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801ae3:	55                   	push   %rbp
  801ae4:	48 89 e5             	mov    %rsp,%rbp
  801ae7:	41 57                	push   %r15
  801ae9:	41 56                	push   %r14
  801aeb:	41 55                	push   %r13
  801aed:	41 54                	push   %r12
  801aef:	53                   	push   %rbx
  801af0:	48 83 ec 18          	sub    $0x18,%rsp
  801af4:	49 89 fc             	mov    %rdi,%r12
  801af7:	49 89 f5             	mov    %rsi,%r13
  801afa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801afe:	8b 45 10             	mov    0x10(%rbp),%eax
  801b01:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801b04:	41 89 cf             	mov    %ecx,%r15d
  801b07:	49 39 d7             	cmp    %rdx,%r15
  801b0a:	76 5b                	jbe    801b67 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801b0c:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801b10:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801b14:	85 db                	test   %ebx,%ebx
  801b16:	7e 0e                	jle    801b26 <print_num+0x43>
            putch(padc, put_arg);
  801b18:	4c 89 ee             	mov    %r13,%rsi
  801b1b:	44 89 f7             	mov    %r14d,%edi
  801b1e:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801b21:	83 eb 01             	sub    $0x1,%ebx
  801b24:	75 f2                	jne    801b18 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801b26:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801b2a:	48 b9 23 2b 80 00 00 	movabs $0x802b23,%rcx
  801b31:	00 00 00 
  801b34:	48 b8 34 2b 80 00 00 	movabs $0x802b34,%rax
  801b3b:	00 00 00 
  801b3e:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801b42:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b46:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4b:	49 f7 f7             	div    %r15
  801b4e:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801b52:	4c 89 ee             	mov    %r13,%rsi
  801b55:	41 ff d4             	call   *%r12
}
  801b58:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801b5c:	5b                   	pop    %rbx
  801b5d:	41 5c                	pop    %r12
  801b5f:	41 5d                	pop    %r13
  801b61:	41 5e                	pop    %r14
  801b63:	41 5f                	pop    %r15
  801b65:	5d                   	pop    %rbp
  801b66:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801b67:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b70:	49 f7 f7             	div    %r15
  801b73:	48 83 ec 08          	sub    $0x8,%rsp
  801b77:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801b7b:	52                   	push   %rdx
  801b7c:	45 0f be c9          	movsbl %r9b,%r9d
  801b80:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801b84:	48 89 c2             	mov    %rax,%rdx
  801b87:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  801b8e:	00 00 00 
  801b91:	ff d0                	call   *%rax
  801b93:	48 83 c4 10          	add    $0x10,%rsp
  801b97:	eb 8d                	jmp    801b26 <print_num+0x43>

0000000000801b99 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  801b99:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801b9d:	48 8b 06             	mov    (%rsi),%rax
  801ba0:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801ba4:	73 0a                	jae    801bb0 <sprintputch+0x17>
        *state->start++ = ch;
  801ba6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801baa:	48 89 16             	mov    %rdx,(%rsi)
  801bad:	40 88 38             	mov    %dil,(%rax)
    }
}
  801bb0:	c3                   	ret    

0000000000801bb1 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801bb1:	55                   	push   %rbp
  801bb2:	48 89 e5             	mov    %rsp,%rbp
  801bb5:	48 83 ec 50          	sub    $0x50,%rsp
  801bb9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bbd:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801bc1:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801bc5:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801bcc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801bd0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801bd4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801bd8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801bdc:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801be0:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  801be7:	00 00 00 
  801bea:	ff d0                	call   *%rax
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

0000000000801bee <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801bee:	55                   	push   %rbp
  801bef:	48 89 e5             	mov    %rsp,%rbp
  801bf2:	41 57                	push   %r15
  801bf4:	41 56                	push   %r14
  801bf6:	41 55                	push   %r13
  801bf8:	41 54                	push   %r12
  801bfa:	53                   	push   %rbx
  801bfb:	48 83 ec 48          	sub    $0x48,%rsp
  801bff:	49 89 fc             	mov    %rdi,%r12
  801c02:	49 89 f6             	mov    %rsi,%r14
  801c05:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  801c08:	48 8b 01             	mov    (%rcx),%rax
  801c0b:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801c0f:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801c13:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801c17:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801c1b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801c1f:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  801c23:	41 0f b6 3f          	movzbl (%r15),%edi
  801c27:	40 80 ff 25          	cmp    $0x25,%dil
  801c2b:	74 18                	je     801c45 <vprintfmt+0x57>
            if (!ch) return;
  801c2d:	40 84 ff             	test   %dil,%dil
  801c30:	0f 84 d1 06 00 00    	je     802307 <vprintfmt+0x719>
            putch(ch, put_arg);
  801c36:	40 0f b6 ff          	movzbl %dil,%edi
  801c3a:	4c 89 f6             	mov    %r14,%rsi
  801c3d:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  801c40:	49 89 df             	mov    %rbx,%r15
  801c43:	eb da                	jmp    801c1f <vprintfmt+0x31>
            precision = va_arg(aq, int);
  801c45:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  801c49:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c4e:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  801c52:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801c57:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801c5d:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801c64:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  801c68:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  801c6d:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  801c73:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  801c77:	44 0f b6 0b          	movzbl (%rbx),%r9d
  801c7b:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  801c7f:	3c 57                	cmp    $0x57,%al
  801c81:	0f 87 65 06 00 00    	ja     8022ec <vprintfmt+0x6fe>
  801c87:	0f b6 c0             	movzbl %al,%eax
  801c8a:	49 ba c0 2c 80 00 00 	movabs $0x802cc0,%r10
  801c91:	00 00 00 
  801c94:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  801c98:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  801c9b:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  801c9f:	eb d2                	jmp    801c73 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  801ca1:	4c 89 fb             	mov    %r15,%rbx
  801ca4:	44 89 c1             	mov    %r8d,%ecx
  801ca7:	eb ca                	jmp    801c73 <vprintfmt+0x85>
            padc = ch;
  801ca9:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  801cad:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801cb0:	eb c1                	jmp    801c73 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801cb5:	83 f8 2f             	cmp    $0x2f,%eax
  801cb8:	77 24                	ja     801cde <vprintfmt+0xf0>
  801cba:	41 89 c1             	mov    %eax,%r9d
  801cbd:	49 01 f1             	add    %rsi,%r9
  801cc0:	83 c0 08             	add    $0x8,%eax
  801cc3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801cc6:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  801cc9:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  801ccc:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801cd0:	79 a1                	jns    801c73 <vprintfmt+0x85>
                width = precision;
  801cd2:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  801cd6:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801cdc:	eb 95                	jmp    801c73 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cde:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  801ce2:	49 8d 41 08          	lea    0x8(%r9),%rax
  801ce6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801cea:	eb da                	jmp    801cc6 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  801cec:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  801cf0:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801cf4:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  801cf8:	3c 39                	cmp    $0x39,%al
  801cfa:	77 1e                	ja     801d1a <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  801cfc:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  801d00:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  801d05:	0f b6 c0             	movzbl %al,%eax
  801d08:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d0d:	41 0f b6 07          	movzbl (%r15),%eax
  801d11:	3c 39                	cmp    $0x39,%al
  801d13:	76 e7                	jbe    801cfc <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  801d15:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  801d18:	eb b2                	jmp    801ccc <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  801d1a:	4c 89 fb             	mov    %r15,%rbx
  801d1d:	eb ad                	jmp    801ccc <vprintfmt+0xde>
            width = MAX(0, width);
  801d1f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801d22:	85 c0                	test   %eax,%eax
  801d24:	0f 48 c7             	cmovs  %edi,%eax
  801d27:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801d2a:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d2d:	e9 41 ff ff ff       	jmp    801c73 <vprintfmt+0x85>
            lflag++;
  801d32:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801d35:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d38:	e9 36 ff ff ff       	jmp    801c73 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  801d3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d40:	83 f8 2f             	cmp    $0x2f,%eax
  801d43:	77 18                	ja     801d5d <vprintfmt+0x16f>
  801d45:	89 c2                	mov    %eax,%edx
  801d47:	48 01 f2             	add    %rsi,%rdx
  801d4a:	83 c0 08             	add    $0x8,%eax
  801d4d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d50:	4c 89 f6             	mov    %r14,%rsi
  801d53:	8b 3a                	mov    (%rdx),%edi
  801d55:	41 ff d4             	call   *%r12
            break;
  801d58:	e9 c2 fe ff ff       	jmp    801c1f <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  801d5d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801d61:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801d65:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d69:	eb e5                	jmp    801d50 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  801d6b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d6e:	83 f8 2f             	cmp    $0x2f,%eax
  801d71:	77 5b                	ja     801dce <vprintfmt+0x1e0>
  801d73:	89 c2                	mov    %eax,%edx
  801d75:	48 01 d6             	add    %rdx,%rsi
  801d78:	83 c0 08             	add    $0x8,%eax
  801d7b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d7e:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  801d80:	89 c8                	mov    %ecx,%eax
  801d82:	c1 f8 1f             	sar    $0x1f,%eax
  801d85:	31 c1                	xor    %eax,%ecx
  801d87:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  801d89:	83 f9 13             	cmp    $0x13,%ecx
  801d8c:	7f 4e                	jg     801ddc <vprintfmt+0x1ee>
  801d8e:	48 63 c1             	movslq %ecx,%rax
  801d91:	48 ba 80 2f 80 00 00 	movabs $0x802f80,%rdx
  801d98:	00 00 00 
  801d9b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801d9f:	48 85 c0             	test   %rax,%rax
  801da2:	74 38                	je     801ddc <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  801da4:	48 89 c1             	mov    %rax,%rcx
  801da7:	48 ba b9 2a 80 00 00 	movabs $0x802ab9,%rdx
  801dae:	00 00 00 
  801db1:	4c 89 f6             	mov    %r14,%rsi
  801db4:	4c 89 e7             	mov    %r12,%rdi
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbc:	49 b8 b1 1b 80 00 00 	movabs $0x801bb1,%r8
  801dc3:	00 00 00 
  801dc6:	41 ff d0             	call   *%r8
  801dc9:	e9 51 fe ff ff       	jmp    801c1f <vprintfmt+0x31>
            int err = va_arg(aq, int);
  801dce:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801dd2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801dd6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801dda:	eb a2                	jmp    801d7e <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  801ddc:	48 ba 4c 2b 80 00 00 	movabs $0x802b4c,%rdx
  801de3:	00 00 00 
  801de6:	4c 89 f6             	mov    %r14,%rsi
  801de9:	4c 89 e7             	mov    %r12,%rdi
  801dec:	b8 00 00 00 00       	mov    $0x0,%eax
  801df1:	49 b8 b1 1b 80 00 00 	movabs $0x801bb1,%r8
  801df8:	00 00 00 
  801dfb:	41 ff d0             	call   *%r8
  801dfe:	e9 1c fe ff ff       	jmp    801c1f <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  801e03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801e06:	83 f8 2f             	cmp    $0x2f,%eax
  801e09:	77 55                	ja     801e60 <vprintfmt+0x272>
  801e0b:	89 c2                	mov    %eax,%edx
  801e0d:	48 01 d6             	add    %rdx,%rsi
  801e10:	83 c0 08             	add    $0x8,%eax
  801e13:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801e16:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  801e19:	48 85 d2             	test   %rdx,%rdx
  801e1c:	48 b8 45 2b 80 00 00 	movabs $0x802b45,%rax
  801e23:	00 00 00 
  801e26:	48 0f 45 c2          	cmovne %rdx,%rax
  801e2a:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  801e2e:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801e32:	7e 06                	jle    801e3a <vprintfmt+0x24c>
  801e34:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  801e38:	75 34                	jne    801e6e <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801e3a:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  801e3e:	48 8d 58 01          	lea    0x1(%rax),%rbx
  801e42:	0f b6 00             	movzbl (%rax),%eax
  801e45:	84 c0                	test   %al,%al
  801e47:	0f 84 b2 00 00 00    	je     801eff <vprintfmt+0x311>
  801e4d:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  801e51:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  801e56:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  801e5a:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  801e5e:	eb 74                	jmp    801ed4 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  801e60:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801e64:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801e68:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e6c:	eb a8                	jmp    801e16 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  801e6e:	49 63 f5             	movslq %r13d,%rsi
  801e71:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  801e75:	48 b8 c1 23 80 00 00 	movabs $0x8023c1,%rax
  801e7c:	00 00 00 
  801e7f:	ff d0                	call   *%rax
  801e81:	48 89 c2             	mov    %rax,%rdx
  801e84:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801e87:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  801e89:	8d 48 ff             	lea    -0x1(%rax),%ecx
  801e8c:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  801e8f:	85 c0                	test   %eax,%eax
  801e91:	7e a7                	jle    801e3a <vprintfmt+0x24c>
  801e93:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  801e97:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  801e9b:	41 89 cd             	mov    %ecx,%r13d
  801e9e:	4c 89 f6             	mov    %r14,%rsi
  801ea1:	89 df                	mov    %ebx,%edi
  801ea3:	41 ff d4             	call   *%r12
  801ea6:	41 83 ed 01          	sub    $0x1,%r13d
  801eaa:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  801eae:	75 ee                	jne    801e9e <vprintfmt+0x2b0>
  801eb0:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  801eb4:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  801eb8:	eb 80                	jmp    801e3a <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801eba:	0f b6 f8             	movzbl %al,%edi
  801ebd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801ec1:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801ec4:	41 83 ef 01          	sub    $0x1,%r15d
  801ec8:	48 83 c3 01          	add    $0x1,%rbx
  801ecc:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  801ed0:	84 c0                	test   %al,%al
  801ed2:	74 1f                	je     801ef3 <vprintfmt+0x305>
  801ed4:	45 85 ed             	test   %r13d,%r13d
  801ed7:	78 06                	js     801edf <vprintfmt+0x2f1>
  801ed9:	41 83 ed 01          	sub    $0x1,%r13d
  801edd:	78 46                	js     801f25 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801edf:	45 84 f6             	test   %r14b,%r14b
  801ee2:	74 d6                	je     801eba <vprintfmt+0x2cc>
  801ee4:	8d 50 e0             	lea    -0x20(%rax),%edx
  801ee7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801eec:	80 fa 5e             	cmp    $0x5e,%dl
  801eef:	77 cc                	ja     801ebd <vprintfmt+0x2cf>
  801ef1:	eb c7                	jmp    801eba <vprintfmt+0x2cc>
  801ef3:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801ef7:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801efb:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  801eff:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801f02:	8d 58 ff             	lea    -0x1(%rax),%ebx
  801f05:	85 c0                	test   %eax,%eax
  801f07:	0f 8e 12 fd ff ff    	jle    801c1f <vprintfmt+0x31>
  801f0d:	4c 89 f6             	mov    %r14,%rsi
  801f10:	bf 20 00 00 00       	mov    $0x20,%edi
  801f15:	41 ff d4             	call   *%r12
  801f18:	83 eb 01             	sub    $0x1,%ebx
  801f1b:	83 fb ff             	cmp    $0xffffffff,%ebx
  801f1e:	75 ed                	jne    801f0d <vprintfmt+0x31f>
  801f20:	e9 fa fc ff ff       	jmp    801c1f <vprintfmt+0x31>
  801f25:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f29:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f2d:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  801f31:	eb cc                	jmp    801eff <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  801f33:	45 89 cd             	mov    %r9d,%r13d
  801f36:	84 c9                	test   %cl,%cl
  801f38:	75 25                	jne    801f5f <vprintfmt+0x371>
    switch (lflag) {
  801f3a:	85 d2                	test   %edx,%edx
  801f3c:	74 57                	je     801f95 <vprintfmt+0x3a7>
  801f3e:	83 fa 01             	cmp    $0x1,%edx
  801f41:	74 78                	je     801fbb <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  801f43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f46:	83 f8 2f             	cmp    $0x2f,%eax
  801f49:	0f 87 92 00 00 00    	ja     801fe1 <vprintfmt+0x3f3>
  801f4f:	89 c2                	mov    %eax,%edx
  801f51:	48 01 d6             	add    %rdx,%rsi
  801f54:	83 c0 08             	add    $0x8,%eax
  801f57:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f5a:	48 8b 1e             	mov    (%rsi),%rbx
  801f5d:	eb 16                	jmp    801f75 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  801f5f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f62:	83 f8 2f             	cmp    $0x2f,%eax
  801f65:	77 20                	ja     801f87 <vprintfmt+0x399>
  801f67:	89 c2                	mov    %eax,%edx
  801f69:	48 01 d6             	add    %rdx,%rsi
  801f6c:	83 c0 08             	add    $0x8,%eax
  801f6f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f72:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  801f75:	48 85 db             	test   %rbx,%rbx
  801f78:	78 78                	js     801ff2 <vprintfmt+0x404>
            num = i;
  801f7a:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  801f7d:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  801f82:	e9 49 02 00 00       	jmp    8021d0 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801f87:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801f8b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801f8f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f93:	eb dd                	jmp    801f72 <vprintfmt+0x384>
        return va_arg(*ap, int);
  801f95:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f98:	83 f8 2f             	cmp    $0x2f,%eax
  801f9b:	77 10                	ja     801fad <vprintfmt+0x3bf>
  801f9d:	89 c2                	mov    %eax,%edx
  801f9f:	48 01 d6             	add    %rdx,%rsi
  801fa2:	83 c0 08             	add    $0x8,%eax
  801fa5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fa8:	48 63 1e             	movslq (%rsi),%rbx
  801fab:	eb c8                	jmp    801f75 <vprintfmt+0x387>
  801fad:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fb1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fb5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fb9:	eb ed                	jmp    801fa8 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  801fbb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fbe:	83 f8 2f             	cmp    $0x2f,%eax
  801fc1:	77 10                	ja     801fd3 <vprintfmt+0x3e5>
  801fc3:	89 c2                	mov    %eax,%edx
  801fc5:	48 01 d6             	add    %rdx,%rsi
  801fc8:	83 c0 08             	add    $0x8,%eax
  801fcb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fce:	48 8b 1e             	mov    (%rsi),%rbx
  801fd1:	eb a2                	jmp    801f75 <vprintfmt+0x387>
  801fd3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fd7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fdb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fdf:	eb ed                	jmp    801fce <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  801fe1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fe5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fe9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fed:	e9 68 ff ff ff       	jmp    801f5a <vprintfmt+0x36c>
                putch('-', put_arg);
  801ff2:	4c 89 f6             	mov    %r14,%rsi
  801ff5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801ffa:	41 ff d4             	call   *%r12
                i = -i;
  801ffd:	48 f7 db             	neg    %rbx
  802000:	e9 75 ff ff ff       	jmp    801f7a <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  802005:	45 89 cd             	mov    %r9d,%r13d
  802008:	84 c9                	test   %cl,%cl
  80200a:	75 2d                	jne    802039 <vprintfmt+0x44b>
    switch (lflag) {
  80200c:	85 d2                	test   %edx,%edx
  80200e:	74 57                	je     802067 <vprintfmt+0x479>
  802010:	83 fa 01             	cmp    $0x1,%edx
  802013:	74 7f                	je     802094 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  802015:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802018:	83 f8 2f             	cmp    $0x2f,%eax
  80201b:	0f 87 a1 00 00 00    	ja     8020c2 <vprintfmt+0x4d4>
  802021:	89 c2                	mov    %eax,%edx
  802023:	48 01 d6             	add    %rdx,%rsi
  802026:	83 c0 08             	add    $0x8,%eax
  802029:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80202c:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80202f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  802034:	e9 97 01 00 00       	jmp    8021d0 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802039:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80203c:	83 f8 2f             	cmp    $0x2f,%eax
  80203f:	77 18                	ja     802059 <vprintfmt+0x46b>
  802041:	89 c2                	mov    %eax,%edx
  802043:	48 01 d6             	add    %rdx,%rsi
  802046:	83 c0 08             	add    $0x8,%eax
  802049:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80204c:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80204f:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802054:	e9 77 01 00 00       	jmp    8021d0 <vprintfmt+0x5e2>
  802059:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80205d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802061:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802065:	eb e5                	jmp    80204c <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  802067:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80206a:	83 f8 2f             	cmp    $0x2f,%eax
  80206d:	77 17                	ja     802086 <vprintfmt+0x498>
  80206f:	89 c2                	mov    %eax,%edx
  802071:	48 01 d6             	add    %rdx,%rsi
  802074:	83 c0 08             	add    $0x8,%eax
  802077:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80207a:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  80207c:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802081:	e9 4a 01 00 00       	jmp    8021d0 <vprintfmt+0x5e2>
  802086:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80208a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80208e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802092:	eb e6                	jmp    80207a <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  802094:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802097:	83 f8 2f             	cmp    $0x2f,%eax
  80209a:	77 18                	ja     8020b4 <vprintfmt+0x4c6>
  80209c:	89 c2                	mov    %eax,%edx
  80209e:	48 01 d6             	add    %rdx,%rsi
  8020a1:	83 c0 08             	add    $0x8,%eax
  8020a4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020a7:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8020aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8020af:	e9 1c 01 00 00       	jmp    8021d0 <vprintfmt+0x5e2>
  8020b4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020b8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020c0:	eb e5                	jmp    8020a7 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8020c2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020c6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020ce:	e9 59 ff ff ff       	jmp    80202c <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8020d3:	45 89 cd             	mov    %r9d,%r13d
  8020d6:	84 c9                	test   %cl,%cl
  8020d8:	75 2d                	jne    802107 <vprintfmt+0x519>
    switch (lflag) {
  8020da:	85 d2                	test   %edx,%edx
  8020dc:	74 57                	je     802135 <vprintfmt+0x547>
  8020de:	83 fa 01             	cmp    $0x1,%edx
  8020e1:	74 7c                	je     80215f <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8020e3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020e6:	83 f8 2f             	cmp    $0x2f,%eax
  8020e9:	0f 87 9b 00 00 00    	ja     80218a <vprintfmt+0x59c>
  8020ef:	89 c2                	mov    %eax,%edx
  8020f1:	48 01 d6             	add    %rdx,%rsi
  8020f4:	83 c0 08             	add    $0x8,%eax
  8020f7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020fa:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8020fd:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802102:	e9 c9 00 00 00       	jmp    8021d0 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802107:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80210a:	83 f8 2f             	cmp    $0x2f,%eax
  80210d:	77 18                	ja     802127 <vprintfmt+0x539>
  80210f:	89 c2                	mov    %eax,%edx
  802111:	48 01 d6             	add    %rdx,%rsi
  802114:	83 c0 08             	add    $0x8,%eax
  802117:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80211a:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80211d:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802122:	e9 a9 00 00 00       	jmp    8021d0 <vprintfmt+0x5e2>
  802127:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80212b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80212f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802133:	eb e5                	jmp    80211a <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  802135:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802138:	83 f8 2f             	cmp    $0x2f,%eax
  80213b:	77 14                	ja     802151 <vprintfmt+0x563>
  80213d:	89 c2                	mov    %eax,%edx
  80213f:	48 01 d6             	add    %rdx,%rsi
  802142:	83 c0 08             	add    $0x8,%eax
  802145:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802148:	8b 16                	mov    (%rsi),%edx
            base = 8;
  80214a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80214f:	eb 7f                	jmp    8021d0 <vprintfmt+0x5e2>
  802151:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802155:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802159:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80215d:	eb e9                	jmp    802148 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  80215f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802162:	83 f8 2f             	cmp    $0x2f,%eax
  802165:	77 15                	ja     80217c <vprintfmt+0x58e>
  802167:	89 c2                	mov    %eax,%edx
  802169:	48 01 d6             	add    %rdx,%rsi
  80216c:	83 c0 08             	add    $0x8,%eax
  80216f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802172:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802175:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80217a:	eb 54                	jmp    8021d0 <vprintfmt+0x5e2>
  80217c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802180:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802184:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802188:	eb e8                	jmp    802172 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  80218a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80218e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802192:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802196:	e9 5f ff ff ff       	jmp    8020fa <vprintfmt+0x50c>
            putch('0', put_arg);
  80219b:	45 89 cd             	mov    %r9d,%r13d
  80219e:	4c 89 f6             	mov    %r14,%rsi
  8021a1:	bf 30 00 00 00       	mov    $0x30,%edi
  8021a6:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8021a9:	4c 89 f6             	mov    %r14,%rsi
  8021ac:	bf 78 00 00 00       	mov    $0x78,%edi
  8021b1:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8021b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021b7:	83 f8 2f             	cmp    $0x2f,%eax
  8021ba:	77 47                	ja     802203 <vprintfmt+0x615>
  8021bc:	89 c2                	mov    %eax,%edx
  8021be:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021c2:	83 c0 08             	add    $0x8,%eax
  8021c5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021c8:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8021cb:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8021d0:	48 83 ec 08          	sub    $0x8,%rsp
  8021d4:	41 80 fd 58          	cmp    $0x58,%r13b
  8021d8:	0f 94 c0             	sete   %al
  8021db:	0f b6 c0             	movzbl %al,%eax
  8021de:	50                   	push   %rax
  8021df:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  8021e4:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8021e8:	4c 89 f6             	mov    %r14,%rsi
  8021eb:	4c 89 e7             	mov    %r12,%rdi
  8021ee:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  8021f5:	00 00 00 
  8021f8:	ff d0                	call   *%rax
            break;
  8021fa:	48 83 c4 10          	add    $0x10,%rsp
  8021fe:	e9 1c fa ff ff       	jmp    801c1f <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  802203:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802207:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80220b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80220f:	eb b7                	jmp    8021c8 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  802211:	45 89 cd             	mov    %r9d,%r13d
  802214:	84 c9                	test   %cl,%cl
  802216:	75 2a                	jne    802242 <vprintfmt+0x654>
    switch (lflag) {
  802218:	85 d2                	test   %edx,%edx
  80221a:	74 54                	je     802270 <vprintfmt+0x682>
  80221c:	83 fa 01             	cmp    $0x1,%edx
  80221f:	74 7c                	je     80229d <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  802221:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802224:	83 f8 2f             	cmp    $0x2f,%eax
  802227:	0f 87 9e 00 00 00    	ja     8022cb <vprintfmt+0x6dd>
  80222d:	89 c2                	mov    %eax,%edx
  80222f:	48 01 d6             	add    %rdx,%rsi
  802232:	83 c0 08             	add    $0x8,%eax
  802235:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802238:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80223b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  802240:	eb 8e                	jmp    8021d0 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802242:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802245:	83 f8 2f             	cmp    $0x2f,%eax
  802248:	77 18                	ja     802262 <vprintfmt+0x674>
  80224a:	89 c2                	mov    %eax,%edx
  80224c:	48 01 d6             	add    %rdx,%rsi
  80224f:	83 c0 08             	add    $0x8,%eax
  802252:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802255:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802258:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80225d:	e9 6e ff ff ff       	jmp    8021d0 <vprintfmt+0x5e2>
  802262:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802266:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80226a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80226e:	eb e5                	jmp    802255 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  802270:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802273:	83 f8 2f             	cmp    $0x2f,%eax
  802276:	77 17                	ja     80228f <vprintfmt+0x6a1>
  802278:	89 c2                	mov    %eax,%edx
  80227a:	48 01 d6             	add    %rdx,%rsi
  80227d:	83 c0 08             	add    $0x8,%eax
  802280:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802283:	8b 16                	mov    (%rsi),%edx
            base = 16;
  802285:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  80228a:	e9 41 ff ff ff       	jmp    8021d0 <vprintfmt+0x5e2>
  80228f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802293:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802297:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80229b:	eb e6                	jmp    802283 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  80229d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022a0:	83 f8 2f             	cmp    $0x2f,%eax
  8022a3:	77 18                	ja     8022bd <vprintfmt+0x6cf>
  8022a5:	89 c2                	mov    %eax,%edx
  8022a7:	48 01 d6             	add    %rdx,%rsi
  8022aa:	83 c0 08             	add    $0x8,%eax
  8022ad:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022b0:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8022b3:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8022b8:	e9 13 ff ff ff       	jmp    8021d0 <vprintfmt+0x5e2>
  8022bd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022c1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022c5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022c9:	eb e5                	jmp    8022b0 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  8022cb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022cf:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022d7:	e9 5c ff ff ff       	jmp    802238 <vprintfmt+0x64a>
            putch(ch, put_arg);
  8022dc:	4c 89 f6             	mov    %r14,%rsi
  8022df:	bf 25 00 00 00       	mov    $0x25,%edi
  8022e4:	41 ff d4             	call   *%r12
            break;
  8022e7:	e9 33 f9 ff ff       	jmp    801c1f <vprintfmt+0x31>
            putch('%', put_arg);
  8022ec:	4c 89 f6             	mov    %r14,%rsi
  8022ef:	bf 25 00 00 00       	mov    $0x25,%edi
  8022f4:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  8022f7:	49 83 ef 01          	sub    $0x1,%r15
  8022fb:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  802300:	75 f5                	jne    8022f7 <vprintfmt+0x709>
  802302:	e9 18 f9 ff ff       	jmp    801c1f <vprintfmt+0x31>
}
  802307:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80230b:	5b                   	pop    %rbx
  80230c:	41 5c                	pop    %r12
  80230e:	41 5d                	pop    %r13
  802310:	41 5e                	pop    %r14
  802312:	41 5f                	pop    %r15
  802314:	5d                   	pop    %rbp
  802315:	c3                   	ret    

0000000000802316 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  802316:	55                   	push   %rbp
  802317:	48 89 e5             	mov    %rsp,%rbp
  80231a:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  80231e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802322:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  802327:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80232b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  802332:	48 85 ff             	test   %rdi,%rdi
  802335:	74 2b                	je     802362 <vsnprintf+0x4c>
  802337:	48 85 f6             	test   %rsi,%rsi
  80233a:	74 26                	je     802362 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  80233c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802340:	48 bf 99 1b 80 00 00 	movabs $0x801b99,%rdi
  802347:	00 00 00 
  80234a:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  802351:	00 00 00 
  802354:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  802356:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80235a:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  80235d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802360:	c9                   	leave  
  802361:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  802362:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802367:	eb f7                	jmp    802360 <vsnprintf+0x4a>

0000000000802369 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  802369:	55                   	push   %rbp
  80236a:	48 89 e5             	mov    %rsp,%rbp
  80236d:	48 83 ec 50          	sub    $0x50,%rsp
  802371:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802375:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802379:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80237d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  802384:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802388:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80238c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802390:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  802394:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  802398:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  80239f:	00 00 00 
  8023a2:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

00000000008023a6 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  8023a6:	80 3f 00             	cmpb   $0x0,(%rdi)
  8023a9:	74 10                	je     8023bb <strlen+0x15>
    size_t n = 0;
  8023ab:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8023b0:	48 83 c0 01          	add    $0x1,%rax
  8023b4:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023b8:	75 f6                	jne    8023b0 <strlen+0xa>
  8023ba:	c3                   	ret    
    size_t n = 0;
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  8023c0:	c3                   	ret    

00000000008023c1 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  8023c1:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  8023c6:	48 85 f6             	test   %rsi,%rsi
  8023c9:	74 10                	je     8023db <strnlen+0x1a>
  8023cb:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023cf:	74 09                	je     8023da <strnlen+0x19>
  8023d1:	48 83 c0 01          	add    $0x1,%rax
  8023d5:	48 39 c6             	cmp    %rax,%rsi
  8023d8:	75 f1                	jne    8023cb <strnlen+0xa>
    return n;
}
  8023da:	c3                   	ret    
    size_t n = 0;
  8023db:	48 89 f0             	mov    %rsi,%rax
  8023de:	c3                   	ret    

00000000008023df <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8023df:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e4:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  8023e8:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  8023eb:	48 83 c0 01          	add    $0x1,%rax
  8023ef:	84 d2                	test   %dl,%dl
  8023f1:	75 f1                	jne    8023e4 <strcpy+0x5>
        ;
    return res;
}
  8023f3:	48 89 f8             	mov    %rdi,%rax
  8023f6:	c3                   	ret    

00000000008023f7 <strcat>:

char *
strcat(char *dst, const char *src) {
  8023f7:	55                   	push   %rbp
  8023f8:	48 89 e5             	mov    %rsp,%rbp
  8023fb:	41 54                	push   %r12
  8023fd:	53                   	push   %rbx
  8023fe:	48 89 fb             	mov    %rdi,%rbx
  802401:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  802404:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  80240b:	00 00 00 
  80240e:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  802410:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  802414:	4c 89 e6             	mov    %r12,%rsi
  802417:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  80241e:	00 00 00 
  802421:	ff d0                	call   *%rax
    return dst;
}
  802423:	48 89 d8             	mov    %rbx,%rax
  802426:	5b                   	pop    %rbx
  802427:	41 5c                	pop    %r12
  802429:	5d                   	pop    %rbp
  80242a:	c3                   	ret    

000000000080242b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  80242b:	48 85 d2             	test   %rdx,%rdx
  80242e:	74 1d                	je     80244d <strncpy+0x22>
  802430:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802434:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  802437:	48 83 c0 01          	add    $0x1,%rax
  80243b:	0f b6 16             	movzbl (%rsi),%edx
  80243e:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  802441:	80 fa 01             	cmp    $0x1,%dl
  802444:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  802448:	48 39 c1             	cmp    %rax,%rcx
  80244b:	75 ea                	jne    802437 <strncpy+0xc>
    }
    return ret;
}
  80244d:	48 89 f8             	mov    %rdi,%rax
  802450:	c3                   	ret    

0000000000802451 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  802451:	48 89 f8             	mov    %rdi,%rax
  802454:	48 85 d2             	test   %rdx,%rdx
  802457:	74 24                	je     80247d <strlcpy+0x2c>
        while (--size > 0 && *src)
  802459:	48 83 ea 01          	sub    $0x1,%rdx
  80245d:	74 1b                	je     80247a <strlcpy+0x29>
  80245f:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802463:	0f b6 16             	movzbl (%rsi),%edx
  802466:	84 d2                	test   %dl,%dl
  802468:	74 10                	je     80247a <strlcpy+0x29>
            *dst++ = *src++;
  80246a:	48 83 c6 01          	add    $0x1,%rsi
  80246e:	48 83 c0 01          	add    $0x1,%rax
  802472:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  802475:	48 39 c8             	cmp    %rcx,%rax
  802478:	75 e9                	jne    802463 <strlcpy+0x12>
        *dst = '\0';
  80247a:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  80247d:	48 29 f8             	sub    %rdi,%rax
}
  802480:	c3                   	ret    

0000000000802481 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  802481:	0f b6 07             	movzbl (%rdi),%eax
  802484:	84 c0                	test   %al,%al
  802486:	74 13                	je     80249b <strcmp+0x1a>
  802488:	38 06                	cmp    %al,(%rsi)
  80248a:	75 0f                	jne    80249b <strcmp+0x1a>
  80248c:	48 83 c7 01          	add    $0x1,%rdi
  802490:	48 83 c6 01          	add    $0x1,%rsi
  802494:	0f b6 07             	movzbl (%rdi),%eax
  802497:	84 c0                	test   %al,%al
  802499:	75 ed                	jne    802488 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  80249b:	0f b6 c0             	movzbl %al,%eax
  80249e:	0f b6 16             	movzbl (%rsi),%edx
  8024a1:	29 d0                	sub    %edx,%eax
}
  8024a3:	c3                   	ret    

00000000008024a4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  8024a4:	48 85 d2             	test   %rdx,%rdx
  8024a7:	74 1f                	je     8024c8 <strncmp+0x24>
  8024a9:	0f b6 07             	movzbl (%rdi),%eax
  8024ac:	84 c0                	test   %al,%al
  8024ae:	74 1e                	je     8024ce <strncmp+0x2a>
  8024b0:	3a 06                	cmp    (%rsi),%al
  8024b2:	75 1a                	jne    8024ce <strncmp+0x2a>
  8024b4:	48 83 c7 01          	add    $0x1,%rdi
  8024b8:	48 83 c6 01          	add    $0x1,%rsi
  8024bc:	48 83 ea 01          	sub    $0x1,%rdx
  8024c0:	75 e7                	jne    8024a9 <strncmp+0x5>

    if (!n) return 0;
  8024c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c7:	c3                   	ret    
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cd:	c3                   	ret    
  8024ce:	48 85 d2             	test   %rdx,%rdx
  8024d1:	74 09                	je     8024dc <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  8024d3:	0f b6 07             	movzbl (%rdi),%eax
  8024d6:	0f b6 16             	movzbl (%rsi),%edx
  8024d9:	29 d0                	sub    %edx,%eax
  8024db:	c3                   	ret    
    if (!n) return 0;
  8024dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e1:	c3                   	ret    

00000000008024e2 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  8024e2:	0f b6 07             	movzbl (%rdi),%eax
  8024e5:	84 c0                	test   %al,%al
  8024e7:	74 18                	je     802501 <strchr+0x1f>
        if (*str == c) {
  8024e9:	0f be c0             	movsbl %al,%eax
  8024ec:	39 f0                	cmp    %esi,%eax
  8024ee:	74 17                	je     802507 <strchr+0x25>
    for (; *str; str++) {
  8024f0:	48 83 c7 01          	add    $0x1,%rdi
  8024f4:	0f b6 07             	movzbl (%rdi),%eax
  8024f7:	84 c0                	test   %al,%al
  8024f9:	75 ee                	jne    8024e9 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  8024fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802500:	c3                   	ret    
  802501:	b8 00 00 00 00       	mov    $0x0,%eax
  802506:	c3                   	ret    
  802507:	48 89 f8             	mov    %rdi,%rax
}
  80250a:	c3                   	ret    

000000000080250b <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  80250b:	0f b6 07             	movzbl (%rdi),%eax
  80250e:	84 c0                	test   %al,%al
  802510:	74 16                	je     802528 <strfind+0x1d>
  802512:	0f be c0             	movsbl %al,%eax
  802515:	39 f0                	cmp    %esi,%eax
  802517:	74 13                	je     80252c <strfind+0x21>
  802519:	48 83 c7 01          	add    $0x1,%rdi
  80251d:	0f b6 07             	movzbl (%rdi),%eax
  802520:	84 c0                	test   %al,%al
  802522:	75 ee                	jne    802512 <strfind+0x7>
  802524:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  802527:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  802528:	48 89 f8             	mov    %rdi,%rax
  80252b:	c3                   	ret    
  80252c:	48 89 f8             	mov    %rdi,%rax
  80252f:	c3                   	ret    

0000000000802530 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  802530:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  802533:	48 89 f8             	mov    %rdi,%rax
  802536:	48 f7 d8             	neg    %rax
  802539:	83 e0 07             	and    $0x7,%eax
  80253c:	49 89 d1             	mov    %rdx,%r9
  80253f:	49 29 c1             	sub    %rax,%r9
  802542:	78 32                	js     802576 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  802544:	40 0f b6 c6          	movzbl %sil,%eax
  802548:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  80254f:	01 01 01 
  802552:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  802556:	40 f6 c7 07          	test   $0x7,%dil
  80255a:	75 34                	jne    802590 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80255c:	4c 89 c9             	mov    %r9,%rcx
  80255f:	48 c1 f9 03          	sar    $0x3,%rcx
  802563:	74 08                	je     80256d <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  802565:	fc                   	cld    
  802566:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802569:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  80256d:	4d 85 c9             	test   %r9,%r9
  802570:	75 45                	jne    8025b7 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  802572:	4c 89 c0             	mov    %r8,%rax
  802575:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  802576:	48 85 d2             	test   %rdx,%rdx
  802579:	74 f7                	je     802572 <memset+0x42>
  80257b:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  80257e:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  802581:	48 83 c0 01          	add    $0x1,%rax
  802585:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  802589:	48 39 c2             	cmp    %rax,%rdx
  80258c:	75 f3                	jne    802581 <memset+0x51>
  80258e:	eb e2                	jmp    802572 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  802590:	40 f6 c7 01          	test   $0x1,%dil
  802594:	74 06                	je     80259c <memset+0x6c>
  802596:	88 07                	mov    %al,(%rdi)
  802598:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  80259c:	40 f6 c7 02          	test   $0x2,%dil
  8025a0:	74 07                	je     8025a9 <memset+0x79>
  8025a2:	66 89 07             	mov    %ax,(%rdi)
  8025a5:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025a9:	40 f6 c7 04          	test   $0x4,%dil
  8025ad:	74 ad                	je     80255c <memset+0x2c>
  8025af:	89 07                	mov    %eax,(%rdi)
  8025b1:	48 83 c7 04          	add    $0x4,%rdi
  8025b5:	eb a5                	jmp    80255c <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025b7:	41 f6 c1 04          	test   $0x4,%r9b
  8025bb:	74 06                	je     8025c3 <memset+0x93>
  8025bd:	89 07                	mov    %eax,(%rdi)
  8025bf:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025c3:	41 f6 c1 02          	test   $0x2,%r9b
  8025c7:	74 07                	je     8025d0 <memset+0xa0>
  8025c9:	66 89 07             	mov    %ax,(%rdi)
  8025cc:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8025d0:	41 f6 c1 01          	test   $0x1,%r9b
  8025d4:	74 9c                	je     802572 <memset+0x42>
  8025d6:	88 07                	mov    %al,(%rdi)
  8025d8:	eb 98                	jmp    802572 <memset+0x42>

00000000008025da <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8025da:	48 89 f8             	mov    %rdi,%rax
  8025dd:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8025e0:	48 39 fe             	cmp    %rdi,%rsi
  8025e3:	73 39                	jae    80261e <memmove+0x44>
  8025e5:	48 01 f2             	add    %rsi,%rdx
  8025e8:	48 39 fa             	cmp    %rdi,%rdx
  8025eb:	76 31                	jbe    80261e <memmove+0x44>
        s += n;
        d += n;
  8025ed:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8025f0:	48 89 d6             	mov    %rdx,%rsi
  8025f3:	48 09 fe             	or     %rdi,%rsi
  8025f6:	48 09 ce             	or     %rcx,%rsi
  8025f9:	40 f6 c6 07          	test   $0x7,%sil
  8025fd:	75 12                	jne    802611 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8025ff:	48 83 ef 08          	sub    $0x8,%rdi
  802603:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  802607:	48 c1 e9 03          	shr    $0x3,%rcx
  80260b:	fd                   	std    
  80260c:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80260f:	fc                   	cld    
  802610:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  802611:	48 83 ef 01          	sub    $0x1,%rdi
  802615:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  802619:	fd                   	std    
  80261a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  80261c:	eb f1                	jmp    80260f <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80261e:	48 89 f2             	mov    %rsi,%rdx
  802621:	48 09 c2             	or     %rax,%rdx
  802624:	48 09 ca             	or     %rcx,%rdx
  802627:	f6 c2 07             	test   $0x7,%dl
  80262a:	75 0c                	jne    802638 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80262c:	48 c1 e9 03          	shr    $0x3,%rcx
  802630:	48 89 c7             	mov    %rax,%rdi
  802633:	fc                   	cld    
  802634:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  802637:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  802638:	48 89 c7             	mov    %rax,%rdi
  80263b:	fc                   	cld    
  80263c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  80263e:	c3                   	ret    

000000000080263f <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  80263f:	55                   	push   %rbp
  802640:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802643:	48 b8 da 25 80 00 00 	movabs $0x8025da,%rax
  80264a:	00 00 00 
  80264d:	ff d0                	call   *%rax
}
  80264f:	5d                   	pop    %rbp
  802650:	c3                   	ret    

0000000000802651 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802651:	55                   	push   %rbp
  802652:	48 89 e5             	mov    %rsp,%rbp
  802655:	41 57                	push   %r15
  802657:	41 56                	push   %r14
  802659:	41 55                	push   %r13
  80265b:	41 54                	push   %r12
  80265d:	53                   	push   %rbx
  80265e:	48 83 ec 08          	sub    $0x8,%rsp
  802662:	49 89 fe             	mov    %rdi,%r14
  802665:	49 89 f7             	mov    %rsi,%r15
  802668:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  80266b:	48 89 f7             	mov    %rsi,%rdi
  80266e:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  802675:	00 00 00 
  802678:	ff d0                	call   *%rax
  80267a:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80267d:	48 89 de             	mov    %rbx,%rsi
  802680:	4c 89 f7             	mov    %r14,%rdi
  802683:	48 b8 c1 23 80 00 00 	movabs $0x8023c1,%rax
  80268a:	00 00 00 
  80268d:	ff d0                	call   *%rax
  80268f:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  802692:	48 39 c3             	cmp    %rax,%rbx
  802695:	74 36                	je     8026cd <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  802697:	48 89 d8             	mov    %rbx,%rax
  80269a:	4c 29 e8             	sub    %r13,%rax
  80269d:	4c 39 e0             	cmp    %r12,%rax
  8026a0:	76 30                	jbe    8026d2 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  8026a2:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8026a7:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026ab:	4c 89 fe             	mov    %r15,%rsi
  8026ae:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	call   *%rax
    return dstlen + srclen;
  8026ba:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8026be:	48 83 c4 08          	add    $0x8,%rsp
  8026c2:	5b                   	pop    %rbx
  8026c3:	41 5c                	pop    %r12
  8026c5:	41 5d                	pop    %r13
  8026c7:	41 5e                	pop    %r14
  8026c9:	41 5f                	pop    %r15
  8026cb:	5d                   	pop    %rbp
  8026cc:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8026cd:	4c 01 e0             	add    %r12,%rax
  8026d0:	eb ec                	jmp    8026be <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8026d2:	48 83 eb 01          	sub    $0x1,%rbx
  8026d6:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026da:	48 89 da             	mov    %rbx,%rdx
  8026dd:	4c 89 fe             	mov    %r15,%rsi
  8026e0:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  8026e7:	00 00 00 
  8026ea:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8026ec:	49 01 de             	add    %rbx,%r14
  8026ef:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8026f4:	eb c4                	jmp    8026ba <strlcat+0x69>

00000000008026f6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8026f6:	49 89 f0             	mov    %rsi,%r8
  8026f9:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8026fc:	48 85 d2             	test   %rdx,%rdx
  8026ff:	74 2a                	je     80272b <memcmp+0x35>
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  802706:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  80270a:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80270f:	38 ca                	cmp    %cl,%dl
  802711:	75 0f                	jne    802722 <memcmp+0x2c>
    while (n-- > 0) {
  802713:	48 83 c0 01          	add    $0x1,%rax
  802717:	48 39 c6             	cmp    %rax,%rsi
  80271a:	75 ea                	jne    802706 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80271c:	b8 00 00 00 00       	mov    $0x0,%eax
  802721:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  802722:	0f b6 c2             	movzbl %dl,%eax
  802725:	0f b6 c9             	movzbl %cl,%ecx
  802728:	29 c8                	sub    %ecx,%eax
  80272a:	c3                   	ret    
    return 0;
  80272b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802730:	c3                   	ret    

0000000000802731 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  802731:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802735:	48 39 c7             	cmp    %rax,%rdi
  802738:	73 0f                	jae    802749 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  80273a:	40 38 37             	cmp    %sil,(%rdi)
  80273d:	74 0e                	je     80274d <memfind+0x1c>
    for (; src < end; src++) {
  80273f:	48 83 c7 01          	add    $0x1,%rdi
  802743:	48 39 f8             	cmp    %rdi,%rax
  802746:	75 f2                	jne    80273a <memfind+0x9>
  802748:	c3                   	ret    
  802749:	48 89 f8             	mov    %rdi,%rax
  80274c:	c3                   	ret    
  80274d:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802750:	c3                   	ret    

0000000000802751 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802751:	49 89 f2             	mov    %rsi,%r10
  802754:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802757:	0f b6 37             	movzbl (%rdi),%esi
  80275a:	40 80 fe 20          	cmp    $0x20,%sil
  80275e:	74 06                	je     802766 <strtol+0x15>
  802760:	40 80 fe 09          	cmp    $0x9,%sil
  802764:	75 13                	jne    802779 <strtol+0x28>
  802766:	48 83 c7 01          	add    $0x1,%rdi
  80276a:	0f b6 37             	movzbl (%rdi),%esi
  80276d:	40 80 fe 20          	cmp    $0x20,%sil
  802771:	74 f3                	je     802766 <strtol+0x15>
  802773:	40 80 fe 09          	cmp    $0x9,%sil
  802777:	74 ed                	je     802766 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802779:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  80277c:	83 e0 fd             	and    $0xfffffffd,%eax
  80277f:	3c 01                	cmp    $0x1,%al
  802781:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802785:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  80278c:	75 11                	jne    80279f <strtol+0x4e>
  80278e:	80 3f 30             	cmpb   $0x30,(%rdi)
  802791:	74 16                	je     8027a9 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802793:	45 85 c0             	test   %r8d,%r8d
  802796:	b8 0a 00 00 00       	mov    $0xa,%eax
  80279b:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  80279f:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8027a4:	4d 63 c8             	movslq %r8d,%r9
  8027a7:	eb 38                	jmp    8027e1 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8027a9:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8027ad:	74 11                	je     8027c0 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8027af:	45 85 c0             	test   %r8d,%r8d
  8027b2:	75 eb                	jne    80279f <strtol+0x4e>
        s++;
  8027b4:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8027b8:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8027be:	eb df                	jmp    80279f <strtol+0x4e>
        s += 2;
  8027c0:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8027c4:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8027ca:	eb d3                	jmp    80279f <strtol+0x4e>
            dig -= '0';
  8027cc:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8027cf:	0f b6 c8             	movzbl %al,%ecx
  8027d2:	44 39 c1             	cmp    %r8d,%ecx
  8027d5:	7d 1f                	jge    8027f6 <strtol+0xa5>
        val = val * base + dig;
  8027d7:	49 0f af d1          	imul   %r9,%rdx
  8027db:	0f b6 c0             	movzbl %al,%eax
  8027de:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8027e1:	48 83 c7 01          	add    $0x1,%rdi
  8027e5:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8027e9:	3c 39                	cmp    $0x39,%al
  8027eb:	76 df                	jbe    8027cc <strtol+0x7b>
        else if (dig - 'a' < 27)
  8027ed:	3c 7b                	cmp    $0x7b,%al
  8027ef:	77 05                	ja     8027f6 <strtol+0xa5>
            dig -= 'a' - 10;
  8027f1:	83 e8 57             	sub    $0x57,%eax
  8027f4:	eb d9                	jmp    8027cf <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8027f6:	4d 85 d2             	test   %r10,%r10
  8027f9:	74 03                	je     8027fe <strtol+0xad>
  8027fb:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8027fe:	48 89 d0             	mov    %rdx,%rax
  802801:	48 f7 d8             	neg    %rax
  802804:	40 80 fe 2d          	cmp    $0x2d,%sil
  802808:	48 0f 44 d0          	cmove  %rax,%rdx
}
  80280c:	48 89 d0             	mov    %rdx,%rax
  80280f:	c3                   	ret    

0000000000802810 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802810:	55                   	push   %rbp
  802811:	48 89 e5             	mov    %rsp,%rbp
  802814:	41 54                	push   %r12
  802816:	53                   	push   %rbx
  802817:	48 89 fb             	mov    %rdi,%rbx
  80281a:	48 89 f7             	mov    %rsi,%rdi
  80281d:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802820:	48 85 f6             	test   %rsi,%rsi
  802823:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80282a:	00 00 00 
  80282d:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802831:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802836:	48 85 d2             	test   %rdx,%rdx
  802839:	74 02                	je     80283d <ipc_recv+0x2d>
  80283b:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  80283d:	48 63 f6             	movslq %esi,%rsi
  802840:	48 b8 25 05 80 00 00 	movabs $0x800525,%rax
  802847:	00 00 00 
  80284a:	ff d0                	call   *%rax

    if (res < 0) {
  80284c:	85 c0                	test   %eax,%eax
  80284e:	78 45                	js     802895 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802850:	48 85 db             	test   %rbx,%rbx
  802853:	74 12                	je     802867 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802855:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80285c:	00 00 00 
  80285f:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802865:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802867:	4d 85 e4             	test   %r12,%r12
  80286a:	74 14                	je     802880 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  80286c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802873:	00 00 00 
  802876:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  80287c:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802880:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802887:	00 00 00 
  80288a:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802890:	5b                   	pop    %rbx
  802891:	41 5c                	pop    %r12
  802893:	5d                   	pop    %rbp
  802894:	c3                   	ret    
        if (from_env_store)
  802895:	48 85 db             	test   %rbx,%rbx
  802898:	74 06                	je     8028a0 <ipc_recv+0x90>
            *from_env_store = 0;
  80289a:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8028a0:	4d 85 e4             	test   %r12,%r12
  8028a3:	74 eb                	je     802890 <ipc_recv+0x80>
            *perm_store = 0;
  8028a5:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028ac:	00 
  8028ad:	eb e1                	jmp    802890 <ipc_recv+0x80>

00000000008028af <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028af:	55                   	push   %rbp
  8028b0:	48 89 e5             	mov    %rsp,%rbp
  8028b3:	41 57                	push   %r15
  8028b5:	41 56                	push   %r14
  8028b7:	41 55                	push   %r13
  8028b9:	41 54                	push   %r12
  8028bb:	53                   	push   %rbx
  8028bc:	48 83 ec 18          	sub    $0x18,%rsp
  8028c0:	41 89 fd             	mov    %edi,%r13d
  8028c3:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028c6:	48 89 d3             	mov    %rdx,%rbx
  8028c9:	49 89 cc             	mov    %rcx,%r12
  8028cc:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028d0:	48 85 d2             	test   %rdx,%rdx
  8028d3:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8028da:	00 00 00 
  8028dd:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028e1:	49 be f9 04 80 00 00 	movabs $0x8004f9,%r14
  8028e8:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  8028eb:	49 bf fc 01 80 00 00 	movabs $0x8001fc,%r15
  8028f2:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028f5:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8028f8:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  8028fc:	4c 89 e1             	mov    %r12,%rcx
  8028ff:	48 89 da             	mov    %rbx,%rdx
  802902:	44 89 ef             	mov    %r13d,%edi
  802905:	41 ff d6             	call   *%r14
  802908:	85 c0                	test   %eax,%eax
  80290a:	79 37                	jns    802943 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  80290c:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80290f:	75 05                	jne    802916 <ipc_send+0x67>
          sys_yield();
  802911:	41 ff d7             	call   *%r15
  802914:	eb df                	jmp    8028f5 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802916:	89 c1                	mov    %eax,%ecx
  802918:	48 ba 3f 30 80 00 00 	movabs $0x80303f,%rdx
  80291f:	00 00 00 
  802922:	be 46 00 00 00       	mov    $0x46,%esi
  802927:	48 bf 52 30 80 00 00 	movabs $0x803052,%rdi
  80292e:	00 00 00 
  802931:	b8 00 00 00 00       	mov    $0x0,%eax
  802936:	49 b8 4e 19 80 00 00 	movabs $0x80194e,%r8
  80293d:	00 00 00 
  802940:	41 ff d0             	call   *%r8
      }
}
  802943:	48 83 c4 18          	add    $0x18,%rsp
  802947:	5b                   	pop    %rbx
  802948:	41 5c                	pop    %r12
  80294a:	41 5d                	pop    %r13
  80294c:	41 5e                	pop    %r14
  80294e:	41 5f                	pop    %r15
  802950:	5d                   	pop    %rbp
  802951:	c3                   	ret    

0000000000802952 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802952:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802957:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  80295e:	00 00 00 
  802961:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802965:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802969:	48 c1 e2 04          	shl    $0x4,%rdx
  80296d:	48 01 ca             	add    %rcx,%rdx
  802970:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802976:	39 fa                	cmp    %edi,%edx
  802978:	74 12                	je     80298c <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  80297a:	48 83 c0 01          	add    $0x1,%rax
  80297e:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802984:	75 db                	jne    802961 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802986:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80298b:	c3                   	ret    
            return envs[i].env_id;
  80298c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802990:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802994:	48 c1 e0 04          	shl    $0x4,%rax
  802998:	48 89 c2             	mov    %rax,%rdx
  80299b:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8029a2:	00 00 00 
  8029a5:	48 01 d0             	add    %rdx,%rax
  8029a8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029ae:	c3                   	ret    
  8029af:	90                   	nop

00000000008029b0 <__rodata_start>:
  8029b0:	3c 75                	cmp    $0x75,%al
  8029b2:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029b3:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8029b7:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029b8:	3e 00 66 0f          	ds add %ah,0xf(%rsi)
  8029bc:	1f                   	(bad)  
  8029bd:	44 00 00             	add    %r8b,(%rax)
  8029c0:	73 79                	jae    802a3b <__rodata_start+0x8b>
  8029c2:	73 63                	jae    802a27 <__rodata_start+0x77>
  8029c4:	61                   	(bad)  
  8029c5:	6c                   	insb   (%dx),%es:(%rdi)
  8029c6:	6c                   	insb   (%dx),%es:(%rdi)
  8029c7:	20 25 7a 64 20 72    	and    %ah,0x7220647a(%rip)        # 72a08e47 <__bss_end+0x72200e47>
  8029cd:	65 74 75             	gs je  802a45 <__rodata_start+0x95>
  8029d0:	72 6e                	jb     802a40 <__rodata_start+0x90>
  8029d2:	65 64 20 25 7a 64 20 	gs and %ah,%fs:0x2820647a(%rip)        # 28a08e54 <__bss_end+0x28200e54>
  8029d9:	28 
  8029da:	3e 20 30             	ds and %dh,(%rax)
  8029dd:	29 00                	sub    %eax,(%rax)
  8029df:	6c                   	insb   (%dx),%es:(%rdi)
  8029e0:	69 62 2f 73 79 73 63 	imul   $0x63737973,0x2f(%rdx),%esp
  8029e7:	61                   	(bad)  
  8029e8:	6c                   	insb   (%dx),%es:(%rdi)
  8029e9:	6c                   	insb   (%dx),%es:(%rdi)
  8029ea:	2e 63 00             	cs movsxd (%rax),%eax
  8029ed:	0f 1f 00             	nopl   (%rax)
  8029f0:	5b                   	pop    %rbx
  8029f1:	25 30 38 78 5d       	and    $0x5d783830,%eax
  8029f6:	20 75 6e             	and    %dh,0x6e(%rbp)
  8029f9:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8029fd:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029fe:	20 64 65 76          	and    %ah,0x76(%rbp,%riz,2)
  802a02:	69 63 65 20 74 79 70 	imul   $0x70797420,0x65(%rbx),%esp
  802a09:	65 20 25 64 0a 00 00 	and    %ah,%gs:0xa64(%rip)        # 803474 <error_string+0x4f4>
  802a10:	5b                   	pop    %rbx
  802a11:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a16:	20 66 74             	and    %ah,0x74(%rsi)
  802a19:	72 75                	jb     802a90 <devtab+0x10>
  802a1b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a1c:	63 61 74             	movsxd 0x74(%rcx),%esp
  802a1f:	65 20 25 64 20 2d 2d 	and    %ah,%gs:0x2d2d2064(%rip)        # 2dad4a8a <__bss_end+0x2d2cca8a>
  802a26:	20 62 61             	and    %ah,0x61(%rdx)
  802a29:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a2d:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a31:	5b                   	pop    %rbx
  802a32:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a37:	20 72 65             	and    %dh,0x65(%rdx)
  802a3a:	61                   	(bad)  
  802a3b:	64 20 25 64 20 2d 2d 	and    %ah,%fs:0x2d2d2064(%rip)        # 2dad4aa6 <__bss_end+0x2d2ccaa6>
  802a42:	20 62 61             	and    %ah,0x61(%rdx)
  802a45:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a49:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a4d:	5b                   	pop    %rbx
  802a4e:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a53:	20 77 72             	and    %dh,0x72(%rdi)
  802a56:	69 74 65 20 25 64 20 	imul   $0x2d206425,0x20(%rbp,%riz,2),%esi
  802a5d:	2d 
  802a5e:	2d 20 62 61 64       	sub    $0x64616220,%eax
  802a63:	20 6d 6f             	and    %ch,0x6f(%rbp)
  802a66:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802a71:	00 00 00 
  802a74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802a7b:	00 00 00 
  802a7e:	66 90                	xchg   %ax,%ax

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
  802cc0:	98 1c 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ........."......
  802cd0:	dc 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802ce0:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802cf0:	ec 22 80 00 00 00 00 00 b2 1c 80 00 00 00 00 00     ."..............
  802d00:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802d10:	a9 1c 80 00 00 00 00 00 1f 1d 80 00 00 00 00 00     ................
  802d20:	ec 22 80 00 00 00 00 00 a9 1c 80 00 00 00 00 00     ."..............
  802d30:	ec 1c 80 00 00 00 00 00 ec 1c 80 00 00 00 00 00     ................
  802d40:	ec 1c 80 00 00 00 00 00 ec 1c 80 00 00 00 00 00     ................
  802d50:	ec 1c 80 00 00 00 00 00 ec 1c 80 00 00 00 00 00     ................
  802d60:	ec 1c 80 00 00 00 00 00 ec 1c 80 00 00 00 00 00     ................
  802d70:	ec 1c 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ........."......
  802d80:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802d90:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802da0:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802db0:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802dc0:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802dd0:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802de0:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802df0:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802e00:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802e10:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802e20:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802e30:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802e40:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802e50:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802e60:	ec 22 80 00 00 00 00 00 11 22 80 00 00 00 00 00     ."......."......
  802e70:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802e80:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802e90:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802ea0:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802eb0:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802ec0:	3d 1d 80 00 00 00 00 00 33 1f 80 00 00 00 00 00     =.......3.......
  802ed0:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802ee0:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802ef0:	6b 1d 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     k........"......
  802f00:	ec 22 80 00 00 00 00 00 32 1d 80 00 00 00 00 00     ."......2.......
  802f10:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802f20:	d3 20 80 00 00 00 00 00 9b 21 80 00 00 00 00 00     . .......!......
  802f30:	ec 22 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ."......."......
  802f40:	03 1e 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     ........."......
  802f50:	05 20 80 00 00 00 00 00 ec 22 80 00 00 00 00 00     . ......."......
  802f60:	ec 22 80 00 00 00 00 00 11 22 80 00 00 00 00 00     ."......."......
  802f70:	ec 22 80 00 00 00 00 00 a1 1c 80 00 00 00 00 00     ."..............

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
