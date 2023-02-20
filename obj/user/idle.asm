
obj/user/idle:     file format elf64-x86-64


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
  80001e:	e8 2d 00 00 00       	call   800050 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:

#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	53                   	push   %rbx
  80002a:	48 83 ec 08          	sub    $0x8,%rsp
    binaryname = "idle";
  80002e:	48 b8 d0 29 80 00 00 	movabs $0x8029d0,%rax
  800035:	00 00 00 
  800038:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  80003f:	00 00 00 
     * Instead of busy-waiting like this,
     * a better way would be to use the processor's HLT instruction
     * to cause the processor to stop executing until the next interrupt -
     * doing so allows the processor to conserve power more effectively. */
    while (1) {
        sys_yield();
  800042:	48 bb 1b 02 80 00 00 	movabs $0x80021b,%rbx
  800049:	00 00 00 
  80004c:	ff d3                	call   *%rbx
    while (1) {
  80004e:	eb fc                	jmp    80004c <umain+0x27>

0000000000800050 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800050:	55                   	push   %rbp
  800051:	48 89 e5             	mov    %rsp,%rbp
  800054:	41 56                	push   %r14
  800056:	41 55                	push   %r13
  800058:	41 54                	push   %r12
  80005a:	53                   	push   %rbx
  80005b:	41 89 fd             	mov    %edi,%r13d
  80005e:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800061:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800068:	00 00 00 
  80006b:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800072:	00 00 00 
  800075:	48 39 c2             	cmp    %rax,%rdx
  800078:	73 17                	jae    800091 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80007a:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80007d:	49 89 c4             	mov    %rax,%r12
  800080:	48 83 c3 08          	add    $0x8,%rbx
  800084:	b8 00 00 00 00       	mov    $0x0,%eax
  800089:	ff 53 f8             	call   *-0x8(%rbx)
  80008c:	4c 39 e3             	cmp    %r12,%rbx
  80008f:	72 ef                	jb     800080 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800091:	48 b8 ea 01 80 00 00 	movabs $0x8001ea,%rax
  800098:	00 00 00 
  80009b:	ff d0                	call   *%rax
  80009d:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000a6:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000aa:	48 c1 e0 04          	shl    $0x4,%rax
  8000ae:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000b5:	00 00 00 
  8000b8:	48 01 d0             	add    %rdx,%rax
  8000bb:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000c2:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000c5:	45 85 ed             	test   %r13d,%r13d
  8000c8:	7e 0d                	jle    8000d7 <libmain+0x87>
  8000ca:	49 8b 06             	mov    (%r14),%rax
  8000cd:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000d4:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000d7:	4c 89 f6             	mov    %r14,%rsi
  8000da:	44 89 ef             	mov    %r13d,%edi
  8000dd:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000e9:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  8000f0:	00 00 00 
  8000f3:	ff d0                	call   *%rax
#endif
}
  8000f5:	5b                   	pop    %rbx
  8000f6:	41 5c                	pop    %r12
  8000f8:	41 5d                	pop    %r13
  8000fa:	41 5e                	pop    %r14
  8000fc:	5d                   	pop    %rbp
  8000fd:	c3                   	ret    

00000000008000fe <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000fe:	55                   	push   %rbp
  8000ff:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800102:	48 b8 3a 08 80 00 00 	movabs $0x80083a,%rax
  800109:	00 00 00 
  80010c:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80010e:	bf 00 00 00 00       	mov    $0x0,%edi
  800113:	48 b8 7f 01 80 00 00 	movabs $0x80017f,%rax
  80011a:	00 00 00 
  80011d:	ff d0                	call   *%rax
}
  80011f:	5d                   	pop    %rbp
  800120:	c3                   	ret    

0000000000800121 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800121:	55                   	push   %rbp
  800122:	48 89 e5             	mov    %rsp,%rbp
  800125:	53                   	push   %rbx
  800126:	48 89 fa             	mov    %rdi,%rdx
  800129:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80012c:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800131:	bb 00 00 00 00       	mov    $0x0,%ebx
  800136:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80013b:	be 00 00 00 00       	mov    $0x0,%esi
  800140:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800146:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800148:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80014c:	c9                   	leave  
  80014d:	c3                   	ret    

000000000080014e <sys_cgetc>:

int
sys_cgetc(void) {
  80014e:	55                   	push   %rbp
  80014f:	48 89 e5             	mov    %rsp,%rbp
  800152:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800153:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800158:	ba 00 00 00 00       	mov    $0x0,%edx
  80015d:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800162:	bb 00 00 00 00       	mov    $0x0,%ebx
  800167:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800177:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800179:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80017d:	c9                   	leave  
  80017e:	c3                   	ret    

000000000080017f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80017f:	55                   	push   %rbp
  800180:	48 89 e5             	mov    %rsp,%rbp
  800183:	53                   	push   %rbx
  800184:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800188:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80018b:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800190:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800195:	bb 00 00 00 00       	mov    $0x0,%ebx
  80019a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001aa:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001ac:	48 85 c0             	test   %rax,%rax
  8001af:	7f 06                	jg     8001b7 <sys_env_destroy+0x38>
}
  8001b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001b5:	c9                   	leave  
  8001b6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001b7:	49 89 c0             	mov    %rax,%r8
  8001ba:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001bf:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  8001c6:	00 00 00 
  8001c9:	be 26 00 00 00       	mov    $0x26,%esi
  8001ce:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  8001d5:	00 00 00 
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	49 b9 6d 19 80 00 00 	movabs $0x80196d,%r9
  8001e4:	00 00 00 
  8001e7:	41 ff d1             	call   *%r9

00000000008001ea <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001ea:	55                   	push   %rbp
  8001eb:	48 89 e5             	mov    %rsp,%rbp
  8001ee:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001ef:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8001f9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800203:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800208:	be 00 00 00 00       	mov    $0x0,%esi
  80020d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800213:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800215:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800219:	c9                   	leave  
  80021a:	c3                   	ret    

000000000080021b <sys_yield>:

void
sys_yield(void) {
  80021b:	55                   	push   %rbp
  80021c:	48 89 e5             	mov    %rsp,%rbp
  80021f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800220:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800225:	ba 00 00 00 00       	mov    $0x0,%edx
  80022a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80022f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800234:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800239:	be 00 00 00 00       	mov    $0x0,%esi
  80023e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800244:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800246:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80024a:	c9                   	leave  
  80024b:	c3                   	ret    

000000000080024c <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80024c:	55                   	push   %rbp
  80024d:	48 89 e5             	mov    %rsp,%rbp
  800250:	53                   	push   %rbx
  800251:	48 89 fa             	mov    %rdi,%rdx
  800254:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800257:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80025c:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800263:	00 00 00 
  800266:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80026b:	be 00 00 00 00       	mov    $0x0,%esi
  800270:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800276:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800278:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

000000000080027e <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80027e:	55                   	push   %rbp
  80027f:	48 89 e5             	mov    %rsp,%rbp
  800282:	53                   	push   %rbx
  800283:	49 89 f8             	mov    %rdi,%r8
  800286:	48 89 d3             	mov    %rdx,%rbx
  800289:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80028c:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800291:	4c 89 c2             	mov    %r8,%rdx
  800294:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800297:	be 00 00 00 00       	mov    $0x0,%esi
  80029c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002a2:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

00000000008002aa <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002aa:	55                   	push   %rbp
  8002ab:	48 89 e5             	mov    %rsp,%rbp
  8002ae:	53                   	push   %rbx
  8002af:	48 83 ec 08          	sub    $0x8,%rsp
  8002b3:	89 f8                	mov    %edi,%eax
  8002b5:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002b8:	48 63 f9             	movslq %ecx,%rdi
  8002bb:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002be:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002c3:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002c6:	be 00 00 00 00       	mov    $0x0,%esi
  8002cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002d1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002d3:	48 85 c0             	test   %rax,%rax
  8002d6:	7f 06                	jg     8002de <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002d8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002de:	49 89 c0             	mov    %rax,%r8
  8002e1:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002e6:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  8002ed:	00 00 00 
  8002f0:	be 26 00 00 00       	mov    $0x26,%esi
  8002f5:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  8002fc:	00 00 00 
  8002ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800304:	49 b9 6d 19 80 00 00 	movabs $0x80196d,%r9
  80030b:	00 00 00 
  80030e:	41 ff d1             	call   *%r9

0000000000800311 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  800311:	55                   	push   %rbp
  800312:	48 89 e5             	mov    %rsp,%rbp
  800315:	53                   	push   %rbx
  800316:	48 83 ec 08          	sub    $0x8,%rsp
  80031a:	89 f8                	mov    %edi,%eax
  80031c:	49 89 f2             	mov    %rsi,%r10
  80031f:	48 89 cf             	mov    %rcx,%rdi
  800322:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800325:	48 63 da             	movslq %edx,%rbx
  800328:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80032b:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800330:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800333:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800336:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800338:	48 85 c0             	test   %rax,%rax
  80033b:	7f 06                	jg     800343 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80033d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800341:	c9                   	leave  
  800342:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800343:	49 89 c0             	mov    %rax,%r8
  800346:	b9 05 00 00 00       	mov    $0x5,%ecx
  80034b:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  800352:	00 00 00 
  800355:	be 26 00 00 00       	mov    $0x26,%esi
  80035a:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  800361:	00 00 00 
  800364:	b8 00 00 00 00       	mov    $0x0,%eax
  800369:	49 b9 6d 19 80 00 00 	movabs $0x80196d,%r9
  800370:	00 00 00 
  800373:	41 ff d1             	call   *%r9

0000000000800376 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  800376:	55                   	push   %rbp
  800377:	48 89 e5             	mov    %rsp,%rbp
  80037a:	53                   	push   %rbx
  80037b:	48 83 ec 08          	sub    $0x8,%rsp
  80037f:	48 89 f1             	mov    %rsi,%rcx
  800382:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  800385:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800388:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80038d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800392:	be 00 00 00 00       	mov    $0x0,%esi
  800397:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80039d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80039f:	48 85 c0             	test   %rax,%rax
  8003a2:	7f 06                	jg     8003aa <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8003a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003a8:	c9                   	leave  
  8003a9:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003aa:	49 89 c0             	mov    %rax,%r8
  8003ad:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003b2:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  8003b9:	00 00 00 
  8003bc:	be 26 00 00 00       	mov    $0x26,%esi
  8003c1:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  8003c8:	00 00 00 
  8003cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d0:	49 b9 6d 19 80 00 00 	movabs $0x80196d,%r9
  8003d7:	00 00 00 
  8003da:	41 ff d1             	call   *%r9

00000000008003dd <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8003dd:	55                   	push   %rbp
  8003de:	48 89 e5             	mov    %rsp,%rbp
  8003e1:	53                   	push   %rbx
  8003e2:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8003e6:	48 63 ce             	movslq %esi,%rcx
  8003e9:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8003ec:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8003f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003f6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003fb:	be 00 00 00 00       	mov    $0x0,%esi
  800400:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800406:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800408:	48 85 c0             	test   %rax,%rax
  80040b:	7f 06                	jg     800413 <sys_env_set_status+0x36>
}
  80040d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800411:	c9                   	leave  
  800412:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800413:	49 89 c0             	mov    %rax,%r8
  800416:	b9 09 00 00 00       	mov    $0x9,%ecx
  80041b:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  800422:	00 00 00 
  800425:	be 26 00 00 00       	mov    $0x26,%esi
  80042a:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  800431:	00 00 00 
  800434:	b8 00 00 00 00       	mov    $0x0,%eax
  800439:	49 b9 6d 19 80 00 00 	movabs $0x80196d,%r9
  800440:	00 00 00 
  800443:	41 ff d1             	call   *%r9

0000000000800446 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  800446:	55                   	push   %rbp
  800447:	48 89 e5             	mov    %rsp,%rbp
  80044a:	53                   	push   %rbx
  80044b:	48 83 ec 08          	sub    $0x8,%rsp
  80044f:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  800452:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800455:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80045a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800464:	be 00 00 00 00       	mov    $0x0,%esi
  800469:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80046f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800471:	48 85 c0             	test   %rax,%rax
  800474:	7f 06                	jg     80047c <sys_env_set_trapframe+0x36>
}
  800476:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80047a:	c9                   	leave  
  80047b:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80047c:	49 89 c0             	mov    %rax,%r8
  80047f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800484:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  80048b:	00 00 00 
  80048e:	be 26 00 00 00       	mov    $0x26,%esi
  800493:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  80049a:	00 00 00 
  80049d:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a2:	49 b9 6d 19 80 00 00 	movabs $0x80196d,%r9
  8004a9:	00 00 00 
  8004ac:	41 ff d1             	call   *%r9

00000000008004af <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8004af:	55                   	push   %rbp
  8004b0:	48 89 e5             	mov    %rsp,%rbp
  8004b3:	53                   	push   %rbx
  8004b4:	48 83 ec 08          	sub    $0x8,%rsp
  8004b8:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8004bb:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004be:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004c8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004cd:	be 00 00 00 00       	mov    $0x0,%esi
  8004d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004d8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004da:	48 85 c0             	test   %rax,%rax
  8004dd:	7f 06                	jg     8004e5 <sys_env_set_pgfault_upcall+0x36>
}
  8004df:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004e3:	c9                   	leave  
  8004e4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004e5:	49 89 c0             	mov    %rax,%r8
  8004e8:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8004ed:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  8004f4:	00 00 00 
  8004f7:	be 26 00 00 00       	mov    $0x26,%esi
  8004fc:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  800503:	00 00 00 
  800506:	b8 00 00 00 00       	mov    $0x0,%eax
  80050b:	49 b9 6d 19 80 00 00 	movabs $0x80196d,%r9
  800512:	00 00 00 
  800515:	41 ff d1             	call   *%r9

0000000000800518 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  800518:	55                   	push   %rbp
  800519:	48 89 e5             	mov    %rsp,%rbp
  80051c:	53                   	push   %rbx
  80051d:	89 f8                	mov    %edi,%eax
  80051f:	49 89 f1             	mov    %rsi,%r9
  800522:	48 89 d3             	mov    %rdx,%rbx
  800525:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  800528:	49 63 f0             	movslq %r8d,%rsi
  80052b:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80052e:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800533:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800536:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80053c:	cd 30                	int    $0x30
}
  80053e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800542:	c9                   	leave  
  800543:	c3                   	ret    

0000000000800544 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  800544:	55                   	push   %rbp
  800545:	48 89 e5             	mov    %rsp,%rbp
  800548:	53                   	push   %rbx
  800549:	48 83 ec 08          	sub    $0x8,%rsp
  80054d:	48 89 fa             	mov    %rdi,%rdx
  800550:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800553:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800558:	bb 00 00 00 00       	mov    $0x0,%ebx
  80055d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800562:	be 00 00 00 00       	mov    $0x0,%esi
  800567:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80056d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80056f:	48 85 c0             	test   %rax,%rax
  800572:	7f 06                	jg     80057a <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800574:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800578:	c9                   	leave  
  800579:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80057a:	49 89 c0             	mov    %rax,%r8
  80057d:	b9 0e 00 00 00       	mov    $0xe,%ecx
  800582:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  800589:	00 00 00 
  80058c:	be 26 00 00 00       	mov    $0x26,%esi
  800591:	48 bf ff 29 80 00 00 	movabs $0x8029ff,%rdi
  800598:	00 00 00 
  80059b:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a0:	49 b9 6d 19 80 00 00 	movabs $0x80196d,%r9
  8005a7:	00 00 00 
  8005aa:	41 ff d1             	call   *%r9

00000000008005ad <sys_gettime>:

int
sys_gettime(void) {
  8005ad:	55                   	push   %rbp
  8005ae:	48 89 e5             	mov    %rsp,%rbp
  8005b1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005b2:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bc:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005c6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005cb:	be 00 00 00 00       	mov    $0x0,%esi
  8005d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005d6:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8005d8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005dc:	c9                   	leave  
  8005dd:	c3                   	ret    

00000000008005de <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8005de:	55                   	push   %rbp
  8005df:	48 89 e5             	mov    %rsp,%rbp
  8005e2:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005e3:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ed:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005fc:	be 00 00 00 00       	mov    $0x0,%esi
  800601:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800607:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  800609:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80060d:	c9                   	leave  
  80060e:	c3                   	ret    

000000000080060f <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80060f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800616:	ff ff ff 
  800619:	48 01 f8             	add    %rdi,%rax
  80061c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800620:	c3                   	ret    

0000000000800621 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800621:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800628:	ff ff ff 
  80062b:	48 01 f8             	add    %rdi,%rax
  80062e:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  800632:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800638:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80063c:	c3                   	ret    

000000000080063d <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80063d:	55                   	push   %rbp
  80063e:	48 89 e5             	mov    %rsp,%rbp
  800641:	41 57                	push   %r15
  800643:	41 56                	push   %r14
  800645:	41 55                	push   %r13
  800647:	41 54                	push   %r12
  800649:	53                   	push   %rbx
  80064a:	48 83 ec 08          	sub    $0x8,%rsp
  80064e:	49 89 ff             	mov    %rdi,%r15
  800651:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  800656:	49 bc eb 15 80 00 00 	movabs $0x8015eb,%r12
  80065d:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  800660:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  800666:	48 89 df             	mov    %rbx,%rdi
  800669:	41 ff d4             	call   *%r12
  80066c:	83 e0 04             	and    $0x4,%eax
  80066f:	74 1a                	je     80068b <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  800671:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  800678:	4c 39 f3             	cmp    %r14,%rbx
  80067b:	75 e9                	jne    800666 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  80067d:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  800684:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  800689:	eb 03                	jmp    80068e <fd_alloc+0x51>
            *fd_store = fd;
  80068b:	49 89 1f             	mov    %rbx,(%r15)
}
  80068e:	48 83 c4 08          	add    $0x8,%rsp
  800692:	5b                   	pop    %rbx
  800693:	41 5c                	pop    %r12
  800695:	41 5d                	pop    %r13
  800697:	41 5e                	pop    %r14
  800699:	41 5f                	pop    %r15
  80069b:	5d                   	pop    %rbp
  80069c:	c3                   	ret    

000000000080069d <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  80069d:	83 ff 1f             	cmp    $0x1f,%edi
  8006a0:	77 39                	ja     8006db <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8006a2:	55                   	push   %rbp
  8006a3:	48 89 e5             	mov    %rsp,%rbp
  8006a6:	41 54                	push   %r12
  8006a8:	53                   	push   %rbx
  8006a9:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8006ac:	48 63 df             	movslq %edi,%rbx
  8006af:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8006b6:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8006ba:	48 89 df             	mov    %rbx,%rdi
  8006bd:	48 b8 eb 15 80 00 00 	movabs $0x8015eb,%rax
  8006c4:	00 00 00 
  8006c7:	ff d0                	call   *%rax
  8006c9:	a8 04                	test   $0x4,%al
  8006cb:	74 14                	je     8006e1 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8006cd:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8006d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006d6:	5b                   	pop    %rbx
  8006d7:	41 5c                	pop    %r12
  8006d9:	5d                   	pop    %rbp
  8006da:	c3                   	ret    
        return -E_INVAL;
  8006db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006e0:	c3                   	ret    
        return -E_INVAL;
  8006e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006e6:	eb ee                	jmp    8006d6 <fd_lookup+0x39>

00000000008006e8 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8006e8:	55                   	push   %rbp
  8006e9:	48 89 e5             	mov    %rsp,%rbp
  8006ec:	53                   	push   %rbx
  8006ed:	48 83 ec 08          	sub    $0x8,%rsp
  8006f1:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8006f4:	48 ba a0 2a 80 00 00 	movabs $0x802aa0,%rdx
  8006fb:	00 00 00 
  8006fe:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  800705:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800708:	39 38                	cmp    %edi,(%rax)
  80070a:	74 4b                	je     800757 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  80070c:	48 83 c2 08          	add    $0x8,%rdx
  800710:	48 8b 02             	mov    (%rdx),%rax
  800713:	48 85 c0             	test   %rax,%rax
  800716:	75 f0                	jne    800708 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800718:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80071f:	00 00 00 
  800722:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800728:	89 fa                	mov    %edi,%edx
  80072a:	48 bf 10 2a 80 00 00 	movabs $0x802a10,%rdi
  800731:	00 00 00 
  800734:	b8 00 00 00 00       	mov    $0x0,%eax
  800739:	48 b9 bd 1a 80 00 00 	movabs $0x801abd,%rcx
  800740:	00 00 00 
  800743:	ff d1                	call   *%rcx
    *dev = 0;
  800745:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  80074c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800751:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800755:	c9                   	leave  
  800756:	c3                   	ret    
            *dev = devtab[i];
  800757:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  80075a:	b8 00 00 00 00       	mov    $0x0,%eax
  80075f:	eb f0                	jmp    800751 <dev_lookup+0x69>

0000000000800761 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  800761:	55                   	push   %rbp
  800762:	48 89 e5             	mov    %rsp,%rbp
  800765:	41 55                	push   %r13
  800767:	41 54                	push   %r12
  800769:	53                   	push   %rbx
  80076a:	48 83 ec 18          	sub    $0x18,%rsp
  80076e:	49 89 fc             	mov    %rdi,%r12
  800771:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800774:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80077b:	ff ff ff 
  80077e:	4c 01 e7             	add    %r12,%rdi
  800781:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  800785:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800789:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  800790:	00 00 00 
  800793:	ff d0                	call   *%rax
  800795:	89 c3                	mov    %eax,%ebx
  800797:	85 c0                	test   %eax,%eax
  800799:	78 06                	js     8007a1 <fd_close+0x40>
  80079b:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  80079f:	74 18                	je     8007b9 <fd_close+0x58>
        return (must_exist ? res : 0);
  8007a1:	45 84 ed             	test   %r13b,%r13b
  8007a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a9:	0f 44 d8             	cmove  %eax,%ebx
}
  8007ac:	89 d8                	mov    %ebx,%eax
  8007ae:	48 83 c4 18          	add    $0x18,%rsp
  8007b2:	5b                   	pop    %rbx
  8007b3:	41 5c                	pop    %r12
  8007b5:	41 5d                	pop    %r13
  8007b7:	5d                   	pop    %rbp
  8007b8:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8007b9:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8007bd:	41 8b 3c 24          	mov    (%r12),%edi
  8007c1:	48 b8 e8 06 80 00 00 	movabs $0x8006e8,%rax
  8007c8:	00 00 00 
  8007cb:	ff d0                	call   *%rax
  8007cd:	89 c3                	mov    %eax,%ebx
  8007cf:	85 c0                	test   %eax,%eax
  8007d1:	78 19                	js     8007ec <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8007d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8007d7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007e0:	48 85 c0             	test   %rax,%rax
  8007e3:	74 07                	je     8007ec <fd_close+0x8b>
  8007e5:	4c 89 e7             	mov    %r12,%rdi
  8007e8:	ff d0                	call   *%rax
  8007ea:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8007ec:	ba 00 10 00 00       	mov    $0x1000,%edx
  8007f1:	4c 89 e6             	mov    %r12,%rsi
  8007f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8007f9:	48 b8 76 03 80 00 00 	movabs $0x800376,%rax
  800800:	00 00 00 
  800803:	ff d0                	call   *%rax
    return res;
  800805:	eb a5                	jmp    8007ac <fd_close+0x4b>

0000000000800807 <close>:

int
close(int fdnum) {
  800807:	55                   	push   %rbp
  800808:	48 89 e5             	mov    %rsp,%rbp
  80080b:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80080f:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800813:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  80081a:	00 00 00 
  80081d:	ff d0                	call   *%rax
    if (res < 0) return res;
  80081f:	85 c0                	test   %eax,%eax
  800821:	78 15                	js     800838 <close+0x31>

    return fd_close(fd, 1);
  800823:	be 01 00 00 00       	mov    $0x1,%esi
  800828:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80082c:	48 b8 61 07 80 00 00 	movabs $0x800761,%rax
  800833:	00 00 00 
  800836:	ff d0                	call   *%rax
}
  800838:	c9                   	leave  
  800839:	c3                   	ret    

000000000080083a <close_all>:

void
close_all(void) {
  80083a:	55                   	push   %rbp
  80083b:	48 89 e5             	mov    %rsp,%rbp
  80083e:	41 54                	push   %r12
  800840:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  800841:	bb 00 00 00 00       	mov    $0x0,%ebx
  800846:	49 bc 07 08 80 00 00 	movabs $0x800807,%r12
  80084d:	00 00 00 
  800850:	89 df                	mov    %ebx,%edi
  800852:	41 ff d4             	call   *%r12
  800855:	83 c3 01             	add    $0x1,%ebx
  800858:	83 fb 20             	cmp    $0x20,%ebx
  80085b:	75 f3                	jne    800850 <close_all+0x16>
}
  80085d:	5b                   	pop    %rbx
  80085e:	41 5c                	pop    %r12
  800860:	5d                   	pop    %rbp
  800861:	c3                   	ret    

0000000000800862 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  800862:	55                   	push   %rbp
  800863:	48 89 e5             	mov    %rsp,%rbp
  800866:	41 56                	push   %r14
  800868:	41 55                	push   %r13
  80086a:	41 54                	push   %r12
  80086c:	53                   	push   %rbx
  80086d:	48 83 ec 10          	sub    $0x10,%rsp
  800871:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  800874:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800878:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  80087f:	00 00 00 
  800882:	ff d0                	call   *%rax
  800884:	89 c3                	mov    %eax,%ebx
  800886:	85 c0                	test   %eax,%eax
  800888:	0f 88 b7 00 00 00    	js     800945 <dup+0xe3>
    close(newfdnum);
  80088e:	44 89 e7             	mov    %r12d,%edi
  800891:	48 b8 07 08 80 00 00 	movabs $0x800807,%rax
  800898:	00 00 00 
  80089b:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80089d:	4d 63 ec             	movslq %r12d,%r13
  8008a0:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8008a7:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8008ab:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8008af:	49 be 21 06 80 00 00 	movabs $0x800621,%r14
  8008b6:	00 00 00 
  8008b9:	41 ff d6             	call   *%r14
  8008bc:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8008bf:	4c 89 ef             	mov    %r13,%rdi
  8008c2:	41 ff d6             	call   *%r14
  8008c5:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8008c8:	48 89 df             	mov    %rbx,%rdi
  8008cb:	48 b8 eb 15 80 00 00 	movabs $0x8015eb,%rax
  8008d2:	00 00 00 
  8008d5:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8008d7:	a8 04                	test   $0x4,%al
  8008d9:	74 2b                	je     800906 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8008db:	41 89 c1             	mov    %eax,%r9d
  8008de:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8008e4:	4c 89 f1             	mov    %r14,%rcx
  8008e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ec:	48 89 de             	mov    %rbx,%rsi
  8008ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8008f4:	48 b8 11 03 80 00 00 	movabs $0x800311,%rax
  8008fb:	00 00 00 
  8008fe:	ff d0                	call   *%rax
  800900:	89 c3                	mov    %eax,%ebx
  800902:	85 c0                	test   %eax,%eax
  800904:	78 4e                	js     800954 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  800906:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80090a:	48 b8 eb 15 80 00 00 	movabs $0x8015eb,%rax
  800911:	00 00 00 
  800914:	ff d0                	call   *%rax
  800916:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  800919:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80091f:	4c 89 e9             	mov    %r13,%rcx
  800922:	ba 00 00 00 00       	mov    $0x0,%edx
  800927:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80092b:	bf 00 00 00 00       	mov    $0x0,%edi
  800930:	48 b8 11 03 80 00 00 	movabs $0x800311,%rax
  800937:	00 00 00 
  80093a:	ff d0                	call   *%rax
  80093c:	89 c3                	mov    %eax,%ebx
  80093e:	85 c0                	test   %eax,%eax
  800940:	78 12                	js     800954 <dup+0xf2>

    return newfdnum;
  800942:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  800945:	89 d8                	mov    %ebx,%eax
  800947:	48 83 c4 10          	add    $0x10,%rsp
  80094b:	5b                   	pop    %rbx
  80094c:	41 5c                	pop    %r12
  80094e:	41 5d                	pop    %r13
  800950:	41 5e                	pop    %r14
  800952:	5d                   	pop    %rbp
  800953:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  800954:	ba 00 10 00 00       	mov    $0x1000,%edx
  800959:	4c 89 ee             	mov    %r13,%rsi
  80095c:	bf 00 00 00 00       	mov    $0x0,%edi
  800961:	49 bc 76 03 80 00 00 	movabs $0x800376,%r12
  800968:	00 00 00 
  80096b:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80096e:	ba 00 10 00 00       	mov    $0x1000,%edx
  800973:	4c 89 f6             	mov    %r14,%rsi
  800976:	bf 00 00 00 00       	mov    $0x0,%edi
  80097b:	41 ff d4             	call   *%r12
    return res;
  80097e:	eb c5                	jmp    800945 <dup+0xe3>

0000000000800980 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800980:	55                   	push   %rbp
  800981:	48 89 e5             	mov    %rsp,%rbp
  800984:	41 55                	push   %r13
  800986:	41 54                	push   %r12
  800988:	53                   	push   %rbx
  800989:	48 83 ec 18          	sub    $0x18,%rsp
  80098d:	89 fb                	mov    %edi,%ebx
  80098f:	49 89 f4             	mov    %rsi,%r12
  800992:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800995:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800999:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  8009a0:	00 00 00 
  8009a3:	ff d0                	call   *%rax
  8009a5:	85 c0                	test   %eax,%eax
  8009a7:	78 49                	js     8009f2 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8009a9:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8009ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009b1:	8b 38                	mov    (%rax),%edi
  8009b3:	48 b8 e8 06 80 00 00 	movabs $0x8006e8,%rax
  8009ba:	00 00 00 
  8009bd:	ff d0                	call   *%rax
  8009bf:	85 c0                	test   %eax,%eax
  8009c1:	78 33                	js     8009f6 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8009c3:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8009c7:	8b 47 08             	mov    0x8(%rdi),%eax
  8009ca:	83 e0 03             	and    $0x3,%eax
  8009cd:	83 f8 01             	cmp    $0x1,%eax
  8009d0:	74 28                	je     8009fa <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8009d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009d6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8009da:	48 85 c0             	test   %rax,%rax
  8009dd:	74 51                	je     800a30 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8009df:	4c 89 ea             	mov    %r13,%rdx
  8009e2:	4c 89 e6             	mov    %r12,%rsi
  8009e5:	ff d0                	call   *%rax
}
  8009e7:	48 83 c4 18          	add    $0x18,%rsp
  8009eb:	5b                   	pop    %rbx
  8009ec:	41 5c                	pop    %r12
  8009ee:	41 5d                	pop    %r13
  8009f0:	5d                   	pop    %rbp
  8009f1:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8009f2:	48 98                	cltq   
  8009f4:	eb f1                	jmp    8009e7 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8009f6:	48 98                	cltq   
  8009f8:	eb ed                	jmp    8009e7 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8009fa:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800a01:	00 00 00 
  800a04:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800a0a:	89 da                	mov    %ebx,%edx
  800a0c:	48 bf 51 2a 80 00 00 	movabs $0x802a51,%rdi
  800a13:	00 00 00 
  800a16:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1b:	48 b9 bd 1a 80 00 00 	movabs $0x801abd,%rcx
  800a22:	00 00 00 
  800a25:	ff d1                	call   *%rcx
        return -E_INVAL;
  800a27:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800a2e:	eb b7                	jmp    8009e7 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800a30:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800a37:	eb ae                	jmp    8009e7 <read+0x67>

0000000000800a39 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800a39:	55                   	push   %rbp
  800a3a:	48 89 e5             	mov    %rsp,%rbp
  800a3d:	41 57                	push   %r15
  800a3f:	41 56                	push   %r14
  800a41:	41 55                	push   %r13
  800a43:	41 54                	push   %r12
  800a45:	53                   	push   %rbx
  800a46:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800a4a:	48 85 d2             	test   %rdx,%rdx
  800a4d:	74 54                	je     800aa3 <readn+0x6a>
  800a4f:	41 89 fd             	mov    %edi,%r13d
  800a52:	49 89 f6             	mov    %rsi,%r14
  800a55:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800a58:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800a5d:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800a62:	49 bf 80 09 80 00 00 	movabs $0x800980,%r15
  800a69:	00 00 00 
  800a6c:	4c 89 e2             	mov    %r12,%rdx
  800a6f:	48 29 f2             	sub    %rsi,%rdx
  800a72:	4c 01 f6             	add    %r14,%rsi
  800a75:	44 89 ef             	mov    %r13d,%edi
  800a78:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800a7b:	85 c0                	test   %eax,%eax
  800a7d:	78 20                	js     800a9f <readn+0x66>
    for (; inc && res < n; res += inc) {
  800a7f:	01 c3                	add    %eax,%ebx
  800a81:	85 c0                	test   %eax,%eax
  800a83:	74 08                	je     800a8d <readn+0x54>
  800a85:	48 63 f3             	movslq %ebx,%rsi
  800a88:	4c 39 e6             	cmp    %r12,%rsi
  800a8b:	72 df                	jb     800a6c <readn+0x33>
    }
    return res;
  800a8d:	48 63 c3             	movslq %ebx,%rax
}
  800a90:	48 83 c4 08          	add    $0x8,%rsp
  800a94:	5b                   	pop    %rbx
  800a95:	41 5c                	pop    %r12
  800a97:	41 5d                	pop    %r13
  800a99:	41 5e                	pop    %r14
  800a9b:	41 5f                	pop    %r15
  800a9d:	5d                   	pop    %rbp
  800a9e:	c3                   	ret    
        if (inc < 0) return inc;
  800a9f:	48 98                	cltq   
  800aa1:	eb ed                	jmp    800a90 <readn+0x57>
    int inc = 1, res = 0;
  800aa3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aa8:	eb e3                	jmp    800a8d <readn+0x54>

0000000000800aaa <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800aaa:	55                   	push   %rbp
  800aab:	48 89 e5             	mov    %rsp,%rbp
  800aae:	41 55                	push   %r13
  800ab0:	41 54                	push   %r12
  800ab2:	53                   	push   %rbx
  800ab3:	48 83 ec 18          	sub    $0x18,%rsp
  800ab7:	89 fb                	mov    %edi,%ebx
  800ab9:	49 89 f4             	mov    %rsi,%r12
  800abc:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800abf:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800ac3:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	call   *%rax
  800acf:	85 c0                	test   %eax,%eax
  800ad1:	78 44                	js     800b17 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800ad3:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800ad7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800adb:	8b 38                	mov    (%rax),%edi
  800add:	48 b8 e8 06 80 00 00 	movabs $0x8006e8,%rax
  800ae4:	00 00 00 
  800ae7:	ff d0                	call   *%rax
  800ae9:	85 c0                	test   %eax,%eax
  800aeb:	78 2e                	js     800b1b <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800aed:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800af1:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800af5:	74 28                	je     800b1f <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800af7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800afb:	48 8b 40 18          	mov    0x18(%rax),%rax
  800aff:	48 85 c0             	test   %rax,%rax
  800b02:	74 51                	je     800b55 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  800b04:	4c 89 ea             	mov    %r13,%rdx
  800b07:	4c 89 e6             	mov    %r12,%rsi
  800b0a:	ff d0                	call   *%rax
}
  800b0c:	48 83 c4 18          	add    $0x18,%rsp
  800b10:	5b                   	pop    %rbx
  800b11:	41 5c                	pop    %r12
  800b13:	41 5d                	pop    %r13
  800b15:	5d                   	pop    %rbp
  800b16:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b17:	48 98                	cltq   
  800b19:	eb f1                	jmp    800b0c <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b1b:	48 98                	cltq   
  800b1d:	eb ed                	jmp    800b0c <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b1f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800b26:	00 00 00 
  800b29:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800b2f:	89 da                	mov    %ebx,%edx
  800b31:	48 bf 6d 2a 80 00 00 	movabs $0x802a6d,%rdi
  800b38:	00 00 00 
  800b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b40:	48 b9 bd 1a 80 00 00 	movabs $0x801abd,%rcx
  800b47:	00 00 00 
  800b4a:	ff d1                	call   *%rcx
        return -E_INVAL;
  800b4c:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800b53:	eb b7                	jmp    800b0c <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800b55:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800b5c:	eb ae                	jmp    800b0c <write+0x62>

0000000000800b5e <seek>:

int
seek(int fdnum, off_t offset) {
  800b5e:	55                   	push   %rbp
  800b5f:	48 89 e5             	mov    %rsp,%rbp
  800b62:	53                   	push   %rbx
  800b63:	48 83 ec 18          	sub    $0x18,%rsp
  800b67:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b69:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b6d:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  800b74:	00 00 00 
  800b77:	ff d0                	call   *%rax
  800b79:	85 c0                	test   %eax,%eax
  800b7b:	78 0c                	js     800b89 <seek+0x2b>

    fd->fd_offset = offset;
  800b7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b81:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800b84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b89:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800b8d:	c9                   	leave  
  800b8e:	c3                   	ret    

0000000000800b8f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800b8f:	55                   	push   %rbp
  800b90:	48 89 e5             	mov    %rsp,%rbp
  800b93:	41 54                	push   %r12
  800b95:	53                   	push   %rbx
  800b96:	48 83 ec 10          	sub    $0x10,%rsp
  800b9a:	89 fb                	mov    %edi,%ebx
  800b9c:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b9f:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800ba3:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  800baa:	00 00 00 
  800bad:	ff d0                	call   *%rax
  800baf:	85 c0                	test   %eax,%eax
  800bb1:	78 36                	js     800be9 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bb3:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800bb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbb:	8b 38                	mov    (%rax),%edi
  800bbd:	48 b8 e8 06 80 00 00 	movabs $0x8006e8,%rax
  800bc4:	00 00 00 
  800bc7:	ff d0                	call   *%rax
  800bc9:	85 c0                	test   %eax,%eax
  800bcb:	78 1c                	js     800be9 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bcd:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800bd1:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800bd5:	74 1b                	je     800bf2 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800bd7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800bdb:	48 8b 40 30          	mov    0x30(%rax),%rax
  800bdf:	48 85 c0             	test   %rax,%rax
  800be2:	74 42                	je     800c26 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  800be4:	44 89 e6             	mov    %r12d,%esi
  800be7:	ff d0                	call   *%rax
}
  800be9:	48 83 c4 10          	add    $0x10,%rsp
  800bed:	5b                   	pop    %rbx
  800bee:	41 5c                	pop    %r12
  800bf0:	5d                   	pop    %rbp
  800bf1:	c3                   	ret    
                thisenv->env_id, fdnum);
  800bf2:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bf9:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800bfc:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800c02:	89 da                	mov    %ebx,%edx
  800c04:	48 bf 30 2a 80 00 00 	movabs $0x802a30,%rdi
  800c0b:	00 00 00 
  800c0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c13:	48 b9 bd 1a 80 00 00 	movabs $0x801abd,%rcx
  800c1a:	00 00 00 
  800c1d:	ff d1                	call   *%rcx
        return -E_INVAL;
  800c1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c24:	eb c3                	jmp    800be9 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c26:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c2b:	eb bc                	jmp    800be9 <ftruncate+0x5a>

0000000000800c2d <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800c2d:	55                   	push   %rbp
  800c2e:	48 89 e5             	mov    %rsp,%rbp
  800c31:	53                   	push   %rbx
  800c32:	48 83 ec 18          	sub    $0x18,%rsp
  800c36:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c39:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c3d:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  800c44:	00 00 00 
  800c47:	ff d0                	call   *%rax
  800c49:	85 c0                	test   %eax,%eax
  800c4b:	78 4d                	js     800c9a <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c4d:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800c51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c55:	8b 38                	mov    (%rax),%edi
  800c57:	48 b8 e8 06 80 00 00 	movabs $0x8006e8,%rax
  800c5e:	00 00 00 
  800c61:	ff d0                	call   *%rax
  800c63:	85 c0                	test   %eax,%eax
  800c65:	78 33                	js     800c9a <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c6b:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800c70:	74 2e                	je     800ca0 <fstat+0x73>

    stat->st_name[0] = 0;
  800c72:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800c75:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800c7c:	00 00 00 
    stat->st_isdir = 0;
  800c7f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800c86:	00 00 00 
    stat->st_dev = dev;
  800c89:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800c90:	48 89 de             	mov    %rbx,%rsi
  800c93:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c97:	ff 50 28             	call   *0x28(%rax)
}
  800c9a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800ca0:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800ca5:	eb f3                	jmp    800c9a <fstat+0x6d>

0000000000800ca7 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800ca7:	55                   	push   %rbp
  800ca8:	48 89 e5             	mov    %rsp,%rbp
  800cab:	41 54                	push   %r12
  800cad:	53                   	push   %rbx
  800cae:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800cb1:	be 00 00 00 00       	mov    $0x0,%esi
  800cb6:	48 b8 72 0f 80 00 00 	movabs $0x800f72,%rax
  800cbd:	00 00 00 
  800cc0:	ff d0                	call   *%rax
  800cc2:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800cc4:	85 c0                	test   %eax,%eax
  800cc6:	78 25                	js     800ced <stat+0x46>

    int res = fstat(fd, stat);
  800cc8:	4c 89 e6             	mov    %r12,%rsi
  800ccb:	89 c7                	mov    %eax,%edi
  800ccd:	48 b8 2d 0c 80 00 00 	movabs $0x800c2d,%rax
  800cd4:	00 00 00 
  800cd7:	ff d0                	call   *%rax
  800cd9:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800cdc:	89 df                	mov    %ebx,%edi
  800cde:	48 b8 07 08 80 00 00 	movabs $0x800807,%rax
  800ce5:	00 00 00 
  800ce8:	ff d0                	call   *%rax

    return res;
  800cea:	44 89 e3             	mov    %r12d,%ebx
}
  800ced:	89 d8                	mov    %ebx,%eax
  800cef:	5b                   	pop    %rbx
  800cf0:	41 5c                	pop    %r12
  800cf2:	5d                   	pop    %rbp
  800cf3:	c3                   	ret    

0000000000800cf4 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800cf4:	55                   	push   %rbp
  800cf5:	48 89 e5             	mov    %rsp,%rbp
  800cf8:	41 54                	push   %r12
  800cfa:	53                   	push   %rbx
  800cfb:	48 83 ec 10          	sub    $0x10,%rsp
  800cff:	41 89 fc             	mov    %edi,%r12d
  800d02:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800d05:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d0c:	00 00 00 
  800d0f:	83 38 00             	cmpl   $0x0,(%rax)
  800d12:	74 5e                	je     800d72 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800d14:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800d1a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800d1f:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800d26:	00 00 00 
  800d29:	44 89 e6             	mov    %r12d,%esi
  800d2c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d33:	00 00 00 
  800d36:	8b 38                	mov    (%rax),%edi
  800d38:	48 b8 ce 28 80 00 00 	movabs $0x8028ce,%rax
  800d3f:	00 00 00 
  800d42:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800d44:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800d4b:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800d4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d51:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d55:	48 89 de             	mov    %rbx,%rsi
  800d58:	bf 00 00 00 00       	mov    $0x0,%edi
  800d5d:	48 b8 2f 28 80 00 00 	movabs $0x80282f,%rax
  800d64:	00 00 00 
  800d67:	ff d0                	call   *%rax
}
  800d69:	48 83 c4 10          	add    $0x10,%rsp
  800d6d:	5b                   	pop    %rbx
  800d6e:	41 5c                	pop    %r12
  800d70:	5d                   	pop    %rbp
  800d71:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800d72:	bf 03 00 00 00       	mov    $0x3,%edi
  800d77:	48 b8 71 29 80 00 00 	movabs $0x802971,%rax
  800d7e:	00 00 00 
  800d81:	ff d0                	call   *%rax
  800d83:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800d8a:	00 00 
  800d8c:	eb 86                	jmp    800d14 <fsipc+0x20>

0000000000800d8e <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800d8e:	55                   	push   %rbp
  800d8f:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d92:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800d99:	00 00 00 
  800d9c:	8b 57 0c             	mov    0xc(%rdi),%edx
  800d9f:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800da1:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800da4:	be 00 00 00 00       	mov    $0x0,%esi
  800da9:	bf 02 00 00 00       	mov    $0x2,%edi
  800dae:	48 b8 f4 0c 80 00 00 	movabs $0x800cf4,%rax
  800db5:	00 00 00 
  800db8:	ff d0                	call   *%rax
}
  800dba:	5d                   	pop    %rbp
  800dbb:	c3                   	ret    

0000000000800dbc <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800dbc:	55                   	push   %rbp
  800dbd:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800dc0:	8b 47 0c             	mov    0xc(%rdi),%eax
  800dc3:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800dca:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800dcc:	be 00 00 00 00       	mov    $0x0,%esi
  800dd1:	bf 06 00 00 00       	mov    $0x6,%edi
  800dd6:	48 b8 f4 0c 80 00 00 	movabs $0x800cf4,%rax
  800ddd:	00 00 00 
  800de0:	ff d0                	call   *%rax
}
  800de2:	5d                   	pop    %rbp
  800de3:	c3                   	ret    

0000000000800de4 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800de4:	55                   	push   %rbp
  800de5:	48 89 e5             	mov    %rsp,%rbp
  800de8:	53                   	push   %rbx
  800de9:	48 83 ec 08          	sub    $0x8,%rsp
  800ded:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800df0:	8b 47 0c             	mov    0xc(%rdi),%eax
  800df3:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800dfa:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800dfc:	be 00 00 00 00       	mov    $0x0,%esi
  800e01:	bf 05 00 00 00       	mov    $0x5,%edi
  800e06:	48 b8 f4 0c 80 00 00 	movabs $0x800cf4,%rax
  800e0d:	00 00 00 
  800e10:	ff d0                	call   *%rax
    if (res < 0) return res;
  800e12:	85 c0                	test   %eax,%eax
  800e14:	78 40                	js     800e56 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800e16:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800e1d:	00 00 00 
  800e20:	48 89 df             	mov    %rbx,%rdi
  800e23:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  800e2a:	00 00 00 
  800e2d:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800e2f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e36:	00 00 00 
  800e39:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  800e3f:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e45:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  800e4b:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800e51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e56:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800e5a:	c9                   	leave  
  800e5b:	c3                   	ret    

0000000000800e5c <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800e5c:	55                   	push   %rbp
  800e5d:	48 89 e5             	mov    %rsp,%rbp
  800e60:	41 57                	push   %r15
  800e62:	41 56                	push   %r14
  800e64:	41 55                	push   %r13
  800e66:	41 54                	push   %r12
  800e68:	53                   	push   %rbx
  800e69:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  800e6d:	48 85 d2             	test   %rdx,%rdx
  800e70:	0f 84 91 00 00 00    	je     800f07 <devfile_write+0xab>
  800e76:	49 89 ff             	mov    %rdi,%r15
  800e79:	49 89 f4             	mov    %rsi,%r12
  800e7c:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  800e7f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e86:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  800e8d:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  800e90:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  800e97:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  800e9d:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  800ea1:	4c 89 ea             	mov    %r13,%rdx
  800ea4:	4c 89 e6             	mov    %r12,%rsi
  800ea7:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  800eae:	00 00 00 
  800eb1:	48 b8 5e 26 80 00 00 	movabs $0x80265e,%rax
  800eb8:	00 00 00 
  800ebb:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800ebd:	41 8b 47 0c          	mov    0xc(%r15),%eax
  800ec1:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  800ec4:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  800ec8:	be 00 00 00 00       	mov    $0x0,%esi
  800ecd:	bf 04 00 00 00       	mov    $0x4,%edi
  800ed2:	48 b8 f4 0c 80 00 00 	movabs $0x800cf4,%rax
  800ed9:	00 00 00 
  800edc:	ff d0                	call   *%rax
        if (res < 0)
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	78 21                	js     800f03 <devfile_write+0xa7>
        buf += res;
  800ee2:	48 63 d0             	movslq %eax,%rdx
  800ee5:	49 01 d4             	add    %rdx,%r12
        ext += res;
  800ee8:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  800eeb:	48 29 d3             	sub    %rdx,%rbx
  800eee:	75 a0                	jne    800e90 <devfile_write+0x34>
    return ext;
  800ef0:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  800ef4:	48 83 c4 18          	add    $0x18,%rsp
  800ef8:	5b                   	pop    %rbx
  800ef9:	41 5c                	pop    %r12
  800efb:	41 5d                	pop    %r13
  800efd:	41 5e                	pop    %r14
  800eff:	41 5f                	pop    %r15
  800f01:	5d                   	pop    %rbp
  800f02:	c3                   	ret    
            return res;
  800f03:	48 98                	cltq   
  800f05:	eb ed                	jmp    800ef4 <devfile_write+0x98>
    int ext = 0;
  800f07:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  800f0e:	eb e0                	jmp    800ef0 <devfile_write+0x94>

0000000000800f10 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800f10:	55                   	push   %rbp
  800f11:	48 89 e5             	mov    %rsp,%rbp
  800f14:	41 54                	push   %r12
  800f16:	53                   	push   %rbx
  800f17:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800f1a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f21:	00 00 00 
  800f24:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f27:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  800f29:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  800f2d:	be 00 00 00 00       	mov    $0x0,%esi
  800f32:	bf 03 00 00 00       	mov    $0x3,%edi
  800f37:	48 b8 f4 0c 80 00 00 	movabs $0x800cf4,%rax
  800f3e:	00 00 00 
  800f41:	ff d0                	call   *%rax
    if (read < 0) 
  800f43:	85 c0                	test   %eax,%eax
  800f45:	78 27                	js     800f6e <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  800f47:	48 63 d8             	movslq %eax,%rbx
  800f4a:	48 89 da             	mov    %rbx,%rdx
  800f4d:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800f54:	00 00 00 
  800f57:	4c 89 e7             	mov    %r12,%rdi
  800f5a:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  800f61:	00 00 00 
  800f64:	ff d0                	call   *%rax
    return read;
  800f66:	48 89 d8             	mov    %rbx,%rax
}
  800f69:	5b                   	pop    %rbx
  800f6a:	41 5c                	pop    %r12
  800f6c:	5d                   	pop    %rbp
  800f6d:	c3                   	ret    
		return read;
  800f6e:	48 98                	cltq   
  800f70:	eb f7                	jmp    800f69 <devfile_read+0x59>

0000000000800f72 <open>:
open(const char *path, int mode) {
  800f72:	55                   	push   %rbp
  800f73:	48 89 e5             	mov    %rsp,%rbp
  800f76:	41 55                	push   %r13
  800f78:	41 54                	push   %r12
  800f7a:	53                   	push   %rbx
  800f7b:	48 83 ec 18          	sub    $0x18,%rsp
  800f7f:	49 89 fc             	mov    %rdi,%r12
  800f82:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  800f85:	48 b8 c5 23 80 00 00 	movabs $0x8023c5,%rax
  800f8c:	00 00 00 
  800f8f:	ff d0                	call   *%rax
  800f91:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  800f97:	0f 87 8c 00 00 00    	ja     801029 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  800f9d:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  800fa1:	48 b8 3d 06 80 00 00 	movabs $0x80063d,%rax
  800fa8:	00 00 00 
  800fab:	ff d0                	call   *%rax
  800fad:	89 c3                	mov    %eax,%ebx
  800faf:	85 c0                	test   %eax,%eax
  800fb1:	78 52                	js     801005 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  800fb3:	4c 89 e6             	mov    %r12,%rsi
  800fb6:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  800fbd:	00 00 00 
  800fc0:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  800fc7:	00 00 00 
  800fca:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  800fcc:	44 89 e8             	mov    %r13d,%eax
  800fcf:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  800fd6:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fd8:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800fdc:	bf 01 00 00 00       	mov    $0x1,%edi
  800fe1:	48 b8 f4 0c 80 00 00 	movabs $0x800cf4,%rax
  800fe8:	00 00 00 
  800feb:	ff d0                	call   *%rax
  800fed:	89 c3                	mov    %eax,%ebx
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	78 1f                	js     801012 <open+0xa0>
    return fd2num(fd);
  800ff3:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ff7:	48 b8 0f 06 80 00 00 	movabs $0x80060f,%rax
  800ffe:	00 00 00 
  801001:	ff d0                	call   *%rax
  801003:	89 c3                	mov    %eax,%ebx
}
  801005:	89 d8                	mov    %ebx,%eax
  801007:	48 83 c4 18          	add    $0x18,%rsp
  80100b:	5b                   	pop    %rbx
  80100c:	41 5c                	pop    %r12
  80100e:	41 5d                	pop    %r13
  801010:	5d                   	pop    %rbp
  801011:	c3                   	ret    
        fd_close(fd, 0);
  801012:	be 00 00 00 00       	mov    $0x0,%esi
  801017:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80101b:	48 b8 61 07 80 00 00 	movabs $0x800761,%rax
  801022:	00 00 00 
  801025:	ff d0                	call   *%rax
        return res;
  801027:	eb dc                	jmp    801005 <open+0x93>
        return -E_BAD_PATH;
  801029:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80102e:	eb d5                	jmp    801005 <open+0x93>

0000000000801030 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801030:	55                   	push   %rbp
  801031:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801034:	be 00 00 00 00       	mov    $0x0,%esi
  801039:	bf 08 00 00 00       	mov    $0x8,%edi
  80103e:	48 b8 f4 0c 80 00 00 	movabs $0x800cf4,%rax
  801045:	00 00 00 
  801048:	ff d0                	call   *%rax
}
  80104a:	5d                   	pop    %rbp
  80104b:	c3                   	ret    

000000000080104c <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80104c:	55                   	push   %rbp
  80104d:	48 89 e5             	mov    %rsp,%rbp
  801050:	41 54                	push   %r12
  801052:	53                   	push   %rbx
  801053:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801056:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  80105d:	00 00 00 
  801060:	ff d0                	call   *%rax
  801062:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801065:	48 be c0 2a 80 00 00 	movabs $0x802ac0,%rsi
  80106c:	00 00 00 
  80106f:	48 89 df             	mov    %rbx,%rdi
  801072:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  801079:	00 00 00 
  80107c:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80107e:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801083:	41 2b 04 24          	sub    (%r12),%eax
  801087:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80108d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801094:	00 00 00 
    stat->st_dev = &devpipe;
  801097:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80109e:	00 00 00 
  8010a1:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8010a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ad:	5b                   	pop    %rbx
  8010ae:	41 5c                	pop    %r12
  8010b0:	5d                   	pop    %rbp
  8010b1:	c3                   	ret    

00000000008010b2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8010b2:	55                   	push   %rbp
  8010b3:	48 89 e5             	mov    %rsp,%rbp
  8010b6:	41 54                	push   %r12
  8010b8:	53                   	push   %rbx
  8010b9:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8010bc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010c1:	48 89 fe             	mov    %rdi,%rsi
  8010c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8010c9:	49 bc 76 03 80 00 00 	movabs $0x800376,%r12
  8010d0:	00 00 00 
  8010d3:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8010d6:	48 89 df             	mov    %rbx,%rdi
  8010d9:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  8010e0:	00 00 00 
  8010e3:	ff d0                	call   *%rax
  8010e5:	48 89 c6             	mov    %rax,%rsi
  8010e8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8010f2:	41 ff d4             	call   *%r12
}
  8010f5:	5b                   	pop    %rbx
  8010f6:	41 5c                	pop    %r12
  8010f8:	5d                   	pop    %rbp
  8010f9:	c3                   	ret    

00000000008010fa <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8010fa:	55                   	push   %rbp
  8010fb:	48 89 e5             	mov    %rsp,%rbp
  8010fe:	41 57                	push   %r15
  801100:	41 56                	push   %r14
  801102:	41 55                	push   %r13
  801104:	41 54                	push   %r12
  801106:	53                   	push   %rbx
  801107:	48 83 ec 18          	sub    $0x18,%rsp
  80110b:	49 89 fc             	mov    %rdi,%r12
  80110e:	49 89 f5             	mov    %rsi,%r13
  801111:	49 89 d7             	mov    %rdx,%r15
  801114:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801118:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  80111f:	00 00 00 
  801122:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801124:	4d 85 ff             	test   %r15,%r15
  801127:	0f 84 ac 00 00 00    	je     8011d9 <devpipe_write+0xdf>
  80112d:	48 89 c3             	mov    %rax,%rbx
  801130:	4c 89 f8             	mov    %r15,%rax
  801133:	4d 89 ef             	mov    %r13,%r15
  801136:	49 01 c5             	add    %rax,%r13
  801139:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80113d:	49 bd 7e 02 80 00 00 	movabs $0x80027e,%r13
  801144:	00 00 00 
            sys_yield();
  801147:	49 be 1b 02 80 00 00 	movabs $0x80021b,%r14
  80114e:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801151:	8b 73 04             	mov    0x4(%rbx),%esi
  801154:	48 63 ce             	movslq %esi,%rcx
  801157:	48 63 03             	movslq (%rbx),%rax
  80115a:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801160:	48 39 c1             	cmp    %rax,%rcx
  801163:	72 2e                	jb     801193 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801165:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80116a:	48 89 da             	mov    %rbx,%rdx
  80116d:	be 00 10 00 00       	mov    $0x1000,%esi
  801172:	4c 89 e7             	mov    %r12,%rdi
  801175:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801178:	85 c0                	test   %eax,%eax
  80117a:	74 63                	je     8011df <devpipe_write+0xe5>
            sys_yield();
  80117c:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80117f:	8b 73 04             	mov    0x4(%rbx),%esi
  801182:	48 63 ce             	movslq %esi,%rcx
  801185:	48 63 03             	movslq (%rbx),%rax
  801188:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80118e:	48 39 c1             	cmp    %rax,%rcx
  801191:	73 d2                	jae    801165 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801193:	41 0f b6 3f          	movzbl (%r15),%edi
  801197:	48 89 ca             	mov    %rcx,%rdx
  80119a:	48 c1 ea 03          	shr    $0x3,%rdx
  80119e:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8011a5:	08 10 20 
  8011a8:	48 f7 e2             	mul    %rdx
  8011ab:	48 c1 ea 06          	shr    $0x6,%rdx
  8011af:	48 89 d0             	mov    %rdx,%rax
  8011b2:	48 c1 e0 09          	shl    $0x9,%rax
  8011b6:	48 29 d0             	sub    %rdx,%rax
  8011b9:	48 c1 e0 03          	shl    $0x3,%rax
  8011bd:	48 29 c1             	sub    %rax,%rcx
  8011c0:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8011c5:	83 c6 01             	add    $0x1,%esi
  8011c8:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8011cb:	49 83 c7 01          	add    $0x1,%r15
  8011cf:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8011d3:	0f 85 78 ff ff ff    	jne    801151 <devpipe_write+0x57>
    return n;
  8011d9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8011dd:	eb 05                	jmp    8011e4 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8011df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e4:	48 83 c4 18          	add    $0x18,%rsp
  8011e8:	5b                   	pop    %rbx
  8011e9:	41 5c                	pop    %r12
  8011eb:	41 5d                	pop    %r13
  8011ed:	41 5e                	pop    %r14
  8011ef:	41 5f                	pop    %r15
  8011f1:	5d                   	pop    %rbp
  8011f2:	c3                   	ret    

00000000008011f3 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8011f3:	55                   	push   %rbp
  8011f4:	48 89 e5             	mov    %rsp,%rbp
  8011f7:	41 57                	push   %r15
  8011f9:	41 56                	push   %r14
  8011fb:	41 55                	push   %r13
  8011fd:	41 54                	push   %r12
  8011ff:	53                   	push   %rbx
  801200:	48 83 ec 18          	sub    $0x18,%rsp
  801204:	49 89 fc             	mov    %rdi,%r12
  801207:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80120b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80120f:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  801216:	00 00 00 
  801219:	ff d0                	call   *%rax
  80121b:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80121e:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801224:	49 bd 7e 02 80 00 00 	movabs $0x80027e,%r13
  80122b:	00 00 00 
            sys_yield();
  80122e:	49 be 1b 02 80 00 00 	movabs $0x80021b,%r14
  801235:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801238:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80123d:	74 7a                	je     8012b9 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80123f:	8b 03                	mov    (%rbx),%eax
  801241:	3b 43 04             	cmp    0x4(%rbx),%eax
  801244:	75 26                	jne    80126c <devpipe_read+0x79>
            if (i > 0) return i;
  801246:	4d 85 ff             	test   %r15,%r15
  801249:	75 74                	jne    8012bf <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80124b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801250:	48 89 da             	mov    %rbx,%rdx
  801253:	be 00 10 00 00       	mov    $0x1000,%esi
  801258:	4c 89 e7             	mov    %r12,%rdi
  80125b:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80125e:	85 c0                	test   %eax,%eax
  801260:	74 6f                	je     8012d1 <devpipe_read+0xde>
            sys_yield();
  801262:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801265:	8b 03                	mov    (%rbx),%eax
  801267:	3b 43 04             	cmp    0x4(%rbx),%eax
  80126a:	74 df                	je     80124b <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80126c:	48 63 c8             	movslq %eax,%rcx
  80126f:	48 89 ca             	mov    %rcx,%rdx
  801272:	48 c1 ea 03          	shr    $0x3,%rdx
  801276:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80127d:	08 10 20 
  801280:	48 f7 e2             	mul    %rdx
  801283:	48 c1 ea 06          	shr    $0x6,%rdx
  801287:	48 89 d0             	mov    %rdx,%rax
  80128a:	48 c1 e0 09          	shl    $0x9,%rax
  80128e:	48 29 d0             	sub    %rdx,%rax
  801291:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801298:	00 
  801299:	48 89 c8             	mov    %rcx,%rax
  80129c:	48 29 d0             	sub    %rdx,%rax
  80129f:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8012a4:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8012a8:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8012ac:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012af:	49 83 c7 01          	add    $0x1,%r15
  8012b3:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8012b7:	75 86                	jne    80123f <devpipe_read+0x4c>
    return n;
  8012b9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012bd:	eb 03                	jmp    8012c2 <devpipe_read+0xcf>
            if (i > 0) return i;
  8012bf:	4c 89 f8             	mov    %r15,%rax
}
  8012c2:	48 83 c4 18          	add    $0x18,%rsp
  8012c6:	5b                   	pop    %rbx
  8012c7:	41 5c                	pop    %r12
  8012c9:	41 5d                	pop    %r13
  8012cb:	41 5e                	pop    %r14
  8012cd:	41 5f                	pop    %r15
  8012cf:	5d                   	pop    %rbp
  8012d0:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8012d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d6:	eb ea                	jmp    8012c2 <devpipe_read+0xcf>

00000000008012d8 <pipe>:
pipe(int pfd[2]) {
  8012d8:	55                   	push   %rbp
  8012d9:	48 89 e5             	mov    %rsp,%rbp
  8012dc:	41 55                	push   %r13
  8012de:	41 54                	push   %r12
  8012e0:	53                   	push   %rbx
  8012e1:	48 83 ec 18          	sub    $0x18,%rsp
  8012e5:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8012e8:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8012ec:	48 b8 3d 06 80 00 00 	movabs $0x80063d,%rax
  8012f3:	00 00 00 
  8012f6:	ff d0                	call   *%rax
  8012f8:	89 c3                	mov    %eax,%ebx
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	0f 88 a0 01 00 00    	js     8014a2 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  801302:	b9 46 00 00 00       	mov    $0x46,%ecx
  801307:	ba 00 10 00 00       	mov    $0x1000,%edx
  80130c:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801310:	bf 00 00 00 00       	mov    $0x0,%edi
  801315:	48 b8 aa 02 80 00 00 	movabs $0x8002aa,%rax
  80131c:	00 00 00 
  80131f:	ff d0                	call   *%rax
  801321:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801323:	85 c0                	test   %eax,%eax
  801325:	0f 88 77 01 00 00    	js     8014a2 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80132b:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80132f:	48 b8 3d 06 80 00 00 	movabs $0x80063d,%rax
  801336:	00 00 00 
  801339:	ff d0                	call   *%rax
  80133b:	89 c3                	mov    %eax,%ebx
  80133d:	85 c0                	test   %eax,%eax
  80133f:	0f 88 43 01 00 00    	js     801488 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  801345:	b9 46 00 00 00       	mov    $0x46,%ecx
  80134a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80134f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801353:	bf 00 00 00 00       	mov    $0x0,%edi
  801358:	48 b8 aa 02 80 00 00 	movabs $0x8002aa,%rax
  80135f:	00 00 00 
  801362:	ff d0                	call   *%rax
  801364:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  801366:	85 c0                	test   %eax,%eax
  801368:	0f 88 1a 01 00 00    	js     801488 <pipe+0x1b0>
    va = fd2data(fd0);
  80136e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801372:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  801379:	00 00 00 
  80137c:	ff d0                	call   *%rax
  80137e:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801381:	b9 46 00 00 00       	mov    $0x46,%ecx
  801386:	ba 00 10 00 00       	mov    $0x1000,%edx
  80138b:	48 89 c6             	mov    %rax,%rsi
  80138e:	bf 00 00 00 00       	mov    $0x0,%edi
  801393:	48 b8 aa 02 80 00 00 	movabs $0x8002aa,%rax
  80139a:	00 00 00 
  80139d:	ff d0                	call   *%rax
  80139f:	89 c3                	mov    %eax,%ebx
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	0f 88 c5 00 00 00    	js     80146e <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8013a9:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8013ad:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  8013b4:	00 00 00 
  8013b7:	ff d0                	call   *%rax
  8013b9:	48 89 c1             	mov    %rax,%rcx
  8013bc:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8013c2:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8013c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013cd:	4c 89 ee             	mov    %r13,%rsi
  8013d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8013d5:	48 b8 11 03 80 00 00 	movabs $0x800311,%rax
  8013dc:	00 00 00 
  8013df:	ff d0                	call   *%rax
  8013e1:	89 c3                	mov    %eax,%ebx
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	78 6e                	js     801455 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8013e7:	be 00 10 00 00       	mov    $0x1000,%esi
  8013ec:	4c 89 ef             	mov    %r13,%rdi
  8013ef:	48 b8 4c 02 80 00 00 	movabs $0x80024c,%rax
  8013f6:	00 00 00 
  8013f9:	ff d0                	call   *%rax
  8013fb:	83 f8 02             	cmp    $0x2,%eax
  8013fe:	0f 85 ab 00 00 00    	jne    8014af <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  801404:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80140b:	00 00 
  80140d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801411:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  801413:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801417:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80141e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801422:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801424:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801428:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80142f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801433:	48 bb 0f 06 80 00 00 	movabs $0x80060f,%rbx
  80143a:	00 00 00 
  80143d:	ff d3                	call   *%rbx
  80143f:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801443:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801447:	ff d3                	call   *%rbx
  801449:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80144e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801453:	eb 4d                	jmp    8014a2 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  801455:	ba 00 10 00 00       	mov    $0x1000,%edx
  80145a:	4c 89 ee             	mov    %r13,%rsi
  80145d:	bf 00 00 00 00       	mov    $0x0,%edi
  801462:	48 b8 76 03 80 00 00 	movabs $0x800376,%rax
  801469:	00 00 00 
  80146c:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80146e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801473:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801477:	bf 00 00 00 00       	mov    $0x0,%edi
  80147c:	48 b8 76 03 80 00 00 	movabs $0x800376,%rax
  801483:	00 00 00 
  801486:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  801488:	ba 00 10 00 00       	mov    $0x1000,%edx
  80148d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801491:	bf 00 00 00 00       	mov    $0x0,%edi
  801496:	48 b8 76 03 80 00 00 	movabs $0x800376,%rax
  80149d:	00 00 00 
  8014a0:	ff d0                	call   *%rax
}
  8014a2:	89 d8                	mov    %ebx,%eax
  8014a4:	48 83 c4 18          	add    $0x18,%rsp
  8014a8:	5b                   	pop    %rbx
  8014a9:	41 5c                	pop    %r12
  8014ab:	41 5d                	pop    %r13
  8014ad:	5d                   	pop    %rbp
  8014ae:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014af:	48 b9 f0 2a 80 00 00 	movabs $0x802af0,%rcx
  8014b6:	00 00 00 
  8014b9:	48 ba c7 2a 80 00 00 	movabs $0x802ac7,%rdx
  8014c0:	00 00 00 
  8014c3:	be 2e 00 00 00       	mov    $0x2e,%esi
  8014c8:	48 bf dc 2a 80 00 00 	movabs $0x802adc,%rdi
  8014cf:	00 00 00 
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	49 b8 6d 19 80 00 00 	movabs $0x80196d,%r8
  8014de:	00 00 00 
  8014e1:	41 ff d0             	call   *%r8

00000000008014e4 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8014e4:	55                   	push   %rbp
  8014e5:	48 89 e5             	mov    %rsp,%rbp
  8014e8:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8014ec:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8014f0:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  8014f7:	00 00 00 
  8014fa:	ff d0                	call   *%rax
    if (res < 0) return res;
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	78 35                	js     801535 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  801500:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801504:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  80150b:	00 00 00 
  80150e:	ff d0                	call   *%rax
  801510:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801513:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801518:	be 00 10 00 00       	mov    $0x1000,%esi
  80151d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801521:	48 b8 7e 02 80 00 00 	movabs $0x80027e,%rax
  801528:	00 00 00 
  80152b:	ff d0                	call   *%rax
  80152d:	85 c0                	test   %eax,%eax
  80152f:	0f 94 c0             	sete   %al
  801532:	0f b6 c0             	movzbl %al,%eax
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

0000000000801537 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801537:	48 89 f8             	mov    %rdi,%rax
  80153a:	48 c1 e8 27          	shr    $0x27,%rax
  80153e:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  801545:	01 00 00 
  801548:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80154c:	f6 c2 01             	test   $0x1,%dl
  80154f:	74 6d                	je     8015be <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801551:	48 89 f8             	mov    %rdi,%rax
  801554:	48 c1 e8 1e          	shr    $0x1e,%rax
  801558:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80155f:	01 00 00 
  801562:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801566:	f6 c2 01             	test   $0x1,%dl
  801569:	74 62                	je     8015cd <get_uvpt_entry+0x96>
  80156b:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801572:	01 00 00 
  801575:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801579:	f6 c2 80             	test   $0x80,%dl
  80157c:	75 4f                	jne    8015cd <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80157e:	48 89 f8             	mov    %rdi,%rax
  801581:	48 c1 e8 15          	shr    $0x15,%rax
  801585:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80158c:	01 00 00 
  80158f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801593:	f6 c2 01             	test   $0x1,%dl
  801596:	74 44                	je     8015dc <get_uvpt_entry+0xa5>
  801598:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80159f:	01 00 00 
  8015a2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8015a6:	f6 c2 80             	test   $0x80,%dl
  8015a9:	75 31                	jne    8015dc <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8015ab:	48 c1 ef 0c          	shr    $0xc,%rdi
  8015af:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8015b6:	01 00 00 
  8015b9:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8015bd:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8015be:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8015c5:	01 00 00 
  8015c8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015cc:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8015cd:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8015d4:	01 00 00 
  8015d7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015db:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8015dc:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8015e3:	01 00 00 
  8015e6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015ea:	c3                   	ret    

00000000008015eb <get_prot>:

int
get_prot(void *va) {
  8015eb:	55                   	push   %rbp
  8015ec:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8015ef:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  8015f6:	00 00 00 
  8015f9:	ff d0                	call   *%rax
  8015fb:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8015fe:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  801603:	89 c1                	mov    %eax,%ecx
  801605:	83 c9 04             	or     $0x4,%ecx
  801608:	f6 c2 01             	test   $0x1,%dl
  80160b:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80160e:	89 c1                	mov    %eax,%ecx
  801610:	83 c9 02             	or     $0x2,%ecx
  801613:	f6 c2 02             	test   $0x2,%dl
  801616:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  801619:	89 c1                	mov    %eax,%ecx
  80161b:	83 c9 01             	or     $0x1,%ecx
  80161e:	48 85 d2             	test   %rdx,%rdx
  801621:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801624:	89 c1                	mov    %eax,%ecx
  801626:	83 c9 40             	or     $0x40,%ecx
  801629:	f6 c6 04             	test   $0x4,%dh
  80162c:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80162f:	5d                   	pop    %rbp
  801630:	c3                   	ret    

0000000000801631 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801631:	55                   	push   %rbp
  801632:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801635:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  80163c:	00 00 00 
  80163f:	ff d0                	call   *%rax
    return pte & PTE_D;
  801641:	48 c1 e8 06          	shr    $0x6,%rax
  801645:	83 e0 01             	and    $0x1,%eax
}
  801648:	5d                   	pop    %rbp
  801649:	c3                   	ret    

000000000080164a <is_page_present>:

bool
is_page_present(void *va) {
  80164a:	55                   	push   %rbp
  80164b:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80164e:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  801655:	00 00 00 
  801658:	ff d0                	call   *%rax
  80165a:	83 e0 01             	and    $0x1,%eax
}
  80165d:	5d                   	pop    %rbp
  80165e:	c3                   	ret    

000000000080165f <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80165f:	55                   	push   %rbp
  801660:	48 89 e5             	mov    %rsp,%rbp
  801663:	41 57                	push   %r15
  801665:	41 56                	push   %r14
  801667:	41 55                	push   %r13
  801669:	41 54                	push   %r12
  80166b:	53                   	push   %rbx
  80166c:	48 83 ec 28          	sub    $0x28,%rsp
  801670:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  801674:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  801678:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  80167d:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  801684:	01 00 00 
  801687:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  80168e:	01 00 00 
  801691:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  801698:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80169b:	49 bf eb 15 80 00 00 	movabs $0x8015eb,%r15
  8016a2:	00 00 00 
  8016a5:	eb 16                	jmp    8016bd <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8016a7:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8016ae:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8016b5:	00 00 00 
  8016b8:	48 39 c3             	cmp    %rax,%rbx
  8016bb:	77 73                	ja     801730 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8016bd:	48 89 d8             	mov    %rbx,%rax
  8016c0:	48 c1 e8 27          	shr    $0x27,%rax
  8016c4:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8016c8:	a8 01                	test   $0x1,%al
  8016ca:	74 db                	je     8016a7 <foreach_shared_region+0x48>
  8016cc:	48 89 d8             	mov    %rbx,%rax
  8016cf:	48 c1 e8 1e          	shr    $0x1e,%rax
  8016d3:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8016d8:	a8 01                	test   $0x1,%al
  8016da:	74 cb                	je     8016a7 <foreach_shared_region+0x48>
  8016dc:	48 89 d8             	mov    %rbx,%rax
  8016df:	48 c1 e8 15          	shr    $0x15,%rax
  8016e3:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8016e7:	a8 01                	test   $0x1,%al
  8016e9:	74 bc                	je     8016a7 <foreach_shared_region+0x48>
        void *start = (void*)i;
  8016eb:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016ef:	48 89 df             	mov    %rbx,%rdi
  8016f2:	41 ff d7             	call   *%r15
  8016f5:	a8 40                	test   $0x40,%al
  8016f7:	75 09                	jne    801702 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8016f9:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801700:	eb ac                	jmp    8016ae <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  801702:	48 89 df             	mov    %rbx,%rdi
  801705:	48 b8 4a 16 80 00 00 	movabs $0x80164a,%rax
  80170c:	00 00 00 
  80170f:	ff d0                	call   *%rax
  801711:	84 c0                	test   %al,%al
  801713:	74 e4                	je     8016f9 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  801715:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  80171c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801720:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  801724:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801728:	ff d0                	call   *%rax
  80172a:	85 c0                	test   %eax,%eax
  80172c:	79 cb                	jns    8016f9 <foreach_shared_region+0x9a>
  80172e:	eb 05                	jmp    801735 <foreach_shared_region+0xd6>
    }
    return 0;
  801730:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801735:	48 83 c4 28          	add    $0x28,%rsp
  801739:	5b                   	pop    %rbx
  80173a:	41 5c                	pop    %r12
  80173c:	41 5d                	pop    %r13
  80173e:	41 5e                	pop    %r14
  801740:	41 5f                	pop    %r15
  801742:	5d                   	pop    %rbp
  801743:	c3                   	ret    

0000000000801744 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  801744:	b8 00 00 00 00       	mov    $0x0,%eax
  801749:	c3                   	ret    

000000000080174a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80174a:	55                   	push   %rbp
  80174b:	48 89 e5             	mov    %rsp,%rbp
  80174e:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  801751:	48 be 14 2b 80 00 00 	movabs $0x802b14,%rsi
  801758:	00 00 00 
  80175b:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  801762:	00 00 00 
  801765:	ff d0                	call   *%rax
    return 0;
}
  801767:	b8 00 00 00 00       	mov    $0x0,%eax
  80176c:	5d                   	pop    %rbp
  80176d:	c3                   	ret    

000000000080176e <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80176e:	55                   	push   %rbp
  80176f:	48 89 e5             	mov    %rsp,%rbp
  801772:	41 57                	push   %r15
  801774:	41 56                	push   %r14
  801776:	41 55                	push   %r13
  801778:	41 54                	push   %r12
  80177a:	53                   	push   %rbx
  80177b:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  801782:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  801789:	48 85 d2             	test   %rdx,%rdx
  80178c:	74 78                	je     801806 <devcons_write+0x98>
  80178e:	49 89 d6             	mov    %rdx,%r14
  801791:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801797:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  80179c:	49 bf f9 25 80 00 00 	movabs $0x8025f9,%r15
  8017a3:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8017a6:	4c 89 f3             	mov    %r14,%rbx
  8017a9:	48 29 f3             	sub    %rsi,%rbx
  8017ac:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8017b0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8017b5:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8017b9:	4c 63 eb             	movslq %ebx,%r13
  8017bc:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8017c3:	4c 89 ea             	mov    %r13,%rdx
  8017c6:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017cd:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8017d0:	4c 89 ee             	mov    %r13,%rsi
  8017d3:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017da:	48 b8 21 01 80 00 00 	movabs $0x800121,%rax
  8017e1:	00 00 00 
  8017e4:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8017e6:	41 01 dc             	add    %ebx,%r12d
  8017e9:	49 63 f4             	movslq %r12d,%rsi
  8017ec:	4c 39 f6             	cmp    %r14,%rsi
  8017ef:	72 b5                	jb     8017a6 <devcons_write+0x38>
    return res;
  8017f1:	49 63 c4             	movslq %r12d,%rax
}
  8017f4:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8017fb:	5b                   	pop    %rbx
  8017fc:	41 5c                	pop    %r12
  8017fe:	41 5d                	pop    %r13
  801800:	41 5e                	pop    %r14
  801802:	41 5f                	pop    %r15
  801804:	5d                   	pop    %rbp
  801805:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  801806:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80180c:	eb e3                	jmp    8017f1 <devcons_write+0x83>

000000000080180e <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80180e:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801811:	ba 00 00 00 00       	mov    $0x0,%edx
  801816:	48 85 c0             	test   %rax,%rax
  801819:	74 55                	je     801870 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80181b:	55                   	push   %rbp
  80181c:	48 89 e5             	mov    %rsp,%rbp
  80181f:	41 55                	push   %r13
  801821:	41 54                	push   %r12
  801823:	53                   	push   %rbx
  801824:	48 83 ec 08          	sub    $0x8,%rsp
  801828:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  80182b:	48 bb 4e 01 80 00 00 	movabs $0x80014e,%rbx
  801832:	00 00 00 
  801835:	49 bc 1b 02 80 00 00 	movabs $0x80021b,%r12
  80183c:	00 00 00 
  80183f:	eb 03                	jmp    801844 <devcons_read+0x36>
  801841:	41 ff d4             	call   *%r12
  801844:	ff d3                	call   *%rbx
  801846:	85 c0                	test   %eax,%eax
  801848:	74 f7                	je     801841 <devcons_read+0x33>
    if (c < 0) return c;
  80184a:	48 63 d0             	movslq %eax,%rdx
  80184d:	78 13                	js     801862 <devcons_read+0x54>
    if (c == 0x04) return 0;
  80184f:	ba 00 00 00 00       	mov    $0x0,%edx
  801854:	83 f8 04             	cmp    $0x4,%eax
  801857:	74 09                	je     801862 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  801859:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80185d:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801862:	48 89 d0             	mov    %rdx,%rax
  801865:	48 83 c4 08          	add    $0x8,%rsp
  801869:	5b                   	pop    %rbx
  80186a:	41 5c                	pop    %r12
  80186c:	41 5d                	pop    %r13
  80186e:	5d                   	pop    %rbp
  80186f:	c3                   	ret    
  801870:	48 89 d0             	mov    %rdx,%rax
  801873:	c3                   	ret    

0000000000801874 <cputchar>:
cputchar(int ch) {
  801874:	55                   	push   %rbp
  801875:	48 89 e5             	mov    %rsp,%rbp
  801878:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  80187c:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801880:	be 01 00 00 00       	mov    $0x1,%esi
  801885:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801889:	48 b8 21 01 80 00 00 	movabs $0x800121,%rax
  801890:	00 00 00 
  801893:	ff d0                	call   *%rax
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

0000000000801897 <getchar>:
getchar(void) {
  801897:	55                   	push   %rbp
  801898:	48 89 e5             	mov    %rsp,%rbp
  80189b:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  80189f:	ba 01 00 00 00       	mov    $0x1,%edx
  8018a4:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8018a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8018ad:	48 b8 80 09 80 00 00 	movabs $0x800980,%rax
  8018b4:	00 00 00 
  8018b7:	ff d0                	call   *%rax
  8018b9:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	78 06                	js     8018c5 <getchar+0x2e>
  8018bf:	74 08                	je     8018c9 <getchar+0x32>
  8018c1:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8018c5:	89 d0                	mov    %edx,%eax
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8018c9:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8018ce:	eb f5                	jmp    8018c5 <getchar+0x2e>

00000000008018d0 <iscons>:
iscons(int fdnum) {
  8018d0:	55                   	push   %rbp
  8018d1:	48 89 e5             	mov    %rsp,%rbp
  8018d4:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8018d8:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018dc:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  8018e3:	00 00 00 
  8018e6:	ff d0                	call   *%rax
    if (res < 0) return res;
  8018e8:	85 c0                	test   %eax,%eax
  8018ea:	78 18                	js     801904 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8018ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018f0:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8018f7:	00 00 00 
  8018fa:	8b 00                	mov    (%rax),%eax
  8018fc:	39 02                	cmp    %eax,(%rdx)
  8018fe:	0f 94 c0             	sete   %al
  801901:	0f b6 c0             	movzbl %al,%eax
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

0000000000801906 <opencons>:
opencons(void) {
  801906:	55                   	push   %rbp
  801907:	48 89 e5             	mov    %rsp,%rbp
  80190a:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  80190e:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801912:	48 b8 3d 06 80 00 00 	movabs $0x80063d,%rax
  801919:	00 00 00 
  80191c:	ff d0                	call   *%rax
  80191e:	85 c0                	test   %eax,%eax
  801920:	78 49                	js     80196b <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801922:	b9 46 00 00 00       	mov    $0x46,%ecx
  801927:	ba 00 10 00 00       	mov    $0x1000,%edx
  80192c:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801930:	bf 00 00 00 00       	mov    $0x0,%edi
  801935:	48 b8 aa 02 80 00 00 	movabs $0x8002aa,%rax
  80193c:	00 00 00 
  80193f:	ff d0                	call   *%rax
  801941:	85 c0                	test   %eax,%eax
  801943:	78 26                	js     80196b <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  801945:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801949:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801950:	00 00 
  801952:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801954:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801958:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80195f:	48 b8 0f 06 80 00 00 	movabs $0x80060f,%rax
  801966:	00 00 00 
  801969:	ff d0                	call   *%rax
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

000000000080196d <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80196d:	55                   	push   %rbp
  80196e:	48 89 e5             	mov    %rsp,%rbp
  801971:	41 56                	push   %r14
  801973:	41 55                	push   %r13
  801975:	41 54                	push   %r12
  801977:	53                   	push   %rbx
  801978:	48 83 ec 50          	sub    $0x50,%rsp
  80197c:	49 89 fc             	mov    %rdi,%r12
  80197f:	41 89 f5             	mov    %esi,%r13d
  801982:	48 89 d3             	mov    %rdx,%rbx
  801985:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801989:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80198d:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801991:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801998:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80199c:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8019a0:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8019a4:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8019a8:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8019af:	00 00 00 
  8019b2:	4c 8b 30             	mov    (%rax),%r14
  8019b5:	48 b8 ea 01 80 00 00 	movabs $0x8001ea,%rax
  8019bc:	00 00 00 
  8019bf:	ff d0                	call   *%rax
  8019c1:	89 c6                	mov    %eax,%esi
  8019c3:	45 89 e8             	mov    %r13d,%r8d
  8019c6:	4c 89 e1             	mov    %r12,%rcx
  8019c9:	4c 89 f2             	mov    %r14,%rdx
  8019cc:	48 bf 20 2b 80 00 00 	movabs $0x802b20,%rdi
  8019d3:	00 00 00 
  8019d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019db:	49 bc bd 1a 80 00 00 	movabs $0x801abd,%r12
  8019e2:	00 00 00 
  8019e5:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8019e8:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8019ec:	48 89 df             	mov    %rbx,%rdi
  8019ef:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  8019f6:	00 00 00 
  8019f9:	ff d0                	call   *%rax
    cprintf("\n");
  8019fb:	48 bf 6b 2a 80 00 00 	movabs $0x802a6b,%rdi
  801a02:	00 00 00 
  801a05:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0a:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801a0d:	cc                   	int3   
  801a0e:	eb fd                	jmp    801a0d <_panic+0xa0>

0000000000801a10 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801a10:	55                   	push   %rbp
  801a11:	48 89 e5             	mov    %rsp,%rbp
  801a14:	53                   	push   %rbx
  801a15:	48 83 ec 08          	sub    $0x8,%rsp
  801a19:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801a1c:	8b 06                	mov    (%rsi),%eax
  801a1e:	8d 50 01             	lea    0x1(%rax),%edx
  801a21:	89 16                	mov    %edx,(%rsi)
  801a23:	48 98                	cltq   
  801a25:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801a2a:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801a30:	74 0a                	je     801a3c <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801a32:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801a36:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  801a3c:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801a40:	be ff 00 00 00       	mov    $0xff,%esi
  801a45:	48 b8 21 01 80 00 00 	movabs $0x800121,%rax
  801a4c:	00 00 00 
  801a4f:	ff d0                	call   *%rax
        state->offset = 0;
  801a51:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801a57:	eb d9                	jmp    801a32 <putch+0x22>

0000000000801a59 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801a59:	55                   	push   %rbp
  801a5a:	48 89 e5             	mov    %rsp,%rbp
  801a5d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801a64:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801a67:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801a6e:	b9 21 00 00 00       	mov    $0x21,%ecx
  801a73:	b8 00 00 00 00       	mov    $0x0,%eax
  801a78:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801a7b:	48 89 f1             	mov    %rsi,%rcx
  801a7e:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801a85:	48 bf 10 1a 80 00 00 	movabs $0x801a10,%rdi
  801a8c:	00 00 00 
  801a8f:	48 b8 0d 1c 80 00 00 	movabs $0x801c0d,%rax
  801a96:	00 00 00 
  801a99:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801a9b:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801aa2:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801aa9:	48 b8 21 01 80 00 00 	movabs $0x800121,%rax
  801ab0:	00 00 00 
  801ab3:	ff d0                	call   *%rax

    return state.count;
}
  801ab5:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

0000000000801abd <cprintf>:

int
cprintf(const char *fmt, ...) {
  801abd:	55                   	push   %rbp
  801abe:	48 89 e5             	mov    %rsp,%rbp
  801ac1:	48 83 ec 50          	sub    $0x50,%rsp
  801ac5:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801ac9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801acd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ad1:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801ad5:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801ad9:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801ae0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ae4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ae8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801aec:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801af0:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801af4:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  801afb:	00 00 00 
  801afe:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

0000000000801b02 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801b02:	55                   	push   %rbp
  801b03:	48 89 e5             	mov    %rsp,%rbp
  801b06:	41 57                	push   %r15
  801b08:	41 56                	push   %r14
  801b0a:	41 55                	push   %r13
  801b0c:	41 54                	push   %r12
  801b0e:	53                   	push   %rbx
  801b0f:	48 83 ec 18          	sub    $0x18,%rsp
  801b13:	49 89 fc             	mov    %rdi,%r12
  801b16:	49 89 f5             	mov    %rsi,%r13
  801b19:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801b1d:	8b 45 10             	mov    0x10(%rbp),%eax
  801b20:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801b23:	41 89 cf             	mov    %ecx,%r15d
  801b26:	49 39 d7             	cmp    %rdx,%r15
  801b29:	76 5b                	jbe    801b86 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801b2b:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801b2f:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801b33:	85 db                	test   %ebx,%ebx
  801b35:	7e 0e                	jle    801b45 <print_num+0x43>
            putch(padc, put_arg);
  801b37:	4c 89 ee             	mov    %r13,%rsi
  801b3a:	44 89 f7             	mov    %r14d,%edi
  801b3d:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801b40:	83 eb 01             	sub    $0x1,%ebx
  801b43:	75 f2                	jne    801b37 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801b45:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801b49:	48 b9 43 2b 80 00 00 	movabs $0x802b43,%rcx
  801b50:	00 00 00 
  801b53:	48 b8 54 2b 80 00 00 	movabs $0x802b54,%rax
  801b5a:	00 00 00 
  801b5d:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801b61:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b65:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6a:	49 f7 f7             	div    %r15
  801b6d:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801b71:	4c 89 ee             	mov    %r13,%rsi
  801b74:	41 ff d4             	call   *%r12
}
  801b77:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801b7b:	5b                   	pop    %rbx
  801b7c:	41 5c                	pop    %r12
  801b7e:	41 5d                	pop    %r13
  801b80:	41 5e                	pop    %r14
  801b82:	41 5f                	pop    %r15
  801b84:	5d                   	pop    %rbp
  801b85:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801b86:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8f:	49 f7 f7             	div    %r15
  801b92:	48 83 ec 08          	sub    $0x8,%rsp
  801b96:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801b9a:	52                   	push   %rdx
  801b9b:	45 0f be c9          	movsbl %r9b,%r9d
  801b9f:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801ba3:	48 89 c2             	mov    %rax,%rdx
  801ba6:	48 b8 02 1b 80 00 00 	movabs $0x801b02,%rax
  801bad:	00 00 00 
  801bb0:	ff d0                	call   *%rax
  801bb2:	48 83 c4 10          	add    $0x10,%rsp
  801bb6:	eb 8d                	jmp    801b45 <print_num+0x43>

0000000000801bb8 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  801bb8:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801bbc:	48 8b 06             	mov    (%rsi),%rax
  801bbf:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801bc3:	73 0a                	jae    801bcf <sprintputch+0x17>
        *state->start++ = ch;
  801bc5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bc9:	48 89 16             	mov    %rdx,(%rsi)
  801bcc:	40 88 38             	mov    %dil,(%rax)
    }
}
  801bcf:	c3                   	ret    

0000000000801bd0 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801bd0:	55                   	push   %rbp
  801bd1:	48 89 e5             	mov    %rsp,%rbp
  801bd4:	48 83 ec 50          	sub    $0x50,%rsp
  801bd8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bdc:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801be0:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801be4:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801beb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801bef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801bf3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801bf7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801bfb:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801bff:	48 b8 0d 1c 80 00 00 	movabs $0x801c0d,%rax
  801c06:	00 00 00 
  801c09:	ff d0                	call   *%rax
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

0000000000801c0d <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801c0d:	55                   	push   %rbp
  801c0e:	48 89 e5             	mov    %rsp,%rbp
  801c11:	41 57                	push   %r15
  801c13:	41 56                	push   %r14
  801c15:	41 55                	push   %r13
  801c17:	41 54                	push   %r12
  801c19:	53                   	push   %rbx
  801c1a:	48 83 ec 48          	sub    $0x48,%rsp
  801c1e:	49 89 fc             	mov    %rdi,%r12
  801c21:	49 89 f6             	mov    %rsi,%r14
  801c24:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  801c27:	48 8b 01             	mov    (%rcx),%rax
  801c2a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801c2e:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801c32:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801c36:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801c3a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801c3e:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  801c42:	41 0f b6 3f          	movzbl (%r15),%edi
  801c46:	40 80 ff 25          	cmp    $0x25,%dil
  801c4a:	74 18                	je     801c64 <vprintfmt+0x57>
            if (!ch) return;
  801c4c:	40 84 ff             	test   %dil,%dil
  801c4f:	0f 84 d1 06 00 00    	je     802326 <vprintfmt+0x719>
            putch(ch, put_arg);
  801c55:	40 0f b6 ff          	movzbl %dil,%edi
  801c59:	4c 89 f6             	mov    %r14,%rsi
  801c5c:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  801c5f:	49 89 df             	mov    %rbx,%r15
  801c62:	eb da                	jmp    801c3e <vprintfmt+0x31>
            precision = va_arg(aq, int);
  801c64:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  801c68:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c6d:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  801c71:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801c76:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801c7c:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801c83:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  801c87:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  801c8c:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  801c92:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  801c96:	44 0f b6 0b          	movzbl (%rbx),%r9d
  801c9a:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  801c9e:	3c 57                	cmp    $0x57,%al
  801ca0:	0f 87 65 06 00 00    	ja     80230b <vprintfmt+0x6fe>
  801ca6:	0f b6 c0             	movzbl %al,%eax
  801ca9:	49 ba e0 2c 80 00 00 	movabs $0x802ce0,%r10
  801cb0:	00 00 00 
  801cb3:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  801cb7:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  801cba:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  801cbe:	eb d2                	jmp    801c92 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  801cc0:	4c 89 fb             	mov    %r15,%rbx
  801cc3:	44 89 c1             	mov    %r8d,%ecx
  801cc6:	eb ca                	jmp    801c92 <vprintfmt+0x85>
            padc = ch;
  801cc8:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  801ccc:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801ccf:	eb c1                	jmp    801c92 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cd1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801cd4:	83 f8 2f             	cmp    $0x2f,%eax
  801cd7:	77 24                	ja     801cfd <vprintfmt+0xf0>
  801cd9:	41 89 c1             	mov    %eax,%r9d
  801cdc:	49 01 f1             	add    %rsi,%r9
  801cdf:	83 c0 08             	add    $0x8,%eax
  801ce2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801ce5:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  801ce8:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  801ceb:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801cef:	79 a1                	jns    801c92 <vprintfmt+0x85>
                width = precision;
  801cf1:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  801cf5:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801cfb:	eb 95                	jmp    801c92 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cfd:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  801d01:	49 8d 41 08          	lea    0x8(%r9),%rax
  801d05:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d09:	eb da                	jmp    801ce5 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  801d0b:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  801d0f:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d13:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  801d17:	3c 39                	cmp    $0x39,%al
  801d19:	77 1e                	ja     801d39 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  801d1b:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  801d1f:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  801d24:	0f b6 c0             	movzbl %al,%eax
  801d27:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d2c:	41 0f b6 07          	movzbl (%r15),%eax
  801d30:	3c 39                	cmp    $0x39,%al
  801d32:	76 e7                	jbe    801d1b <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  801d34:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  801d37:	eb b2                	jmp    801ceb <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  801d39:	4c 89 fb             	mov    %r15,%rbx
  801d3c:	eb ad                	jmp    801ceb <vprintfmt+0xde>
            width = MAX(0, width);
  801d3e:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801d41:	85 c0                	test   %eax,%eax
  801d43:	0f 48 c7             	cmovs  %edi,%eax
  801d46:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801d49:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d4c:	e9 41 ff ff ff       	jmp    801c92 <vprintfmt+0x85>
            lflag++;
  801d51:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801d54:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d57:	e9 36 ff ff ff       	jmp    801c92 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  801d5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d5f:	83 f8 2f             	cmp    $0x2f,%eax
  801d62:	77 18                	ja     801d7c <vprintfmt+0x16f>
  801d64:	89 c2                	mov    %eax,%edx
  801d66:	48 01 f2             	add    %rsi,%rdx
  801d69:	83 c0 08             	add    $0x8,%eax
  801d6c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d6f:	4c 89 f6             	mov    %r14,%rsi
  801d72:	8b 3a                	mov    (%rdx),%edi
  801d74:	41 ff d4             	call   *%r12
            break;
  801d77:	e9 c2 fe ff ff       	jmp    801c3e <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  801d7c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801d80:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801d84:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d88:	eb e5                	jmp    801d6f <vprintfmt+0x162>
            int err = va_arg(aq, int);
  801d8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d8d:	83 f8 2f             	cmp    $0x2f,%eax
  801d90:	77 5b                	ja     801ded <vprintfmt+0x1e0>
  801d92:	89 c2                	mov    %eax,%edx
  801d94:	48 01 d6             	add    %rdx,%rsi
  801d97:	83 c0 08             	add    $0x8,%eax
  801d9a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d9d:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  801d9f:	89 c8                	mov    %ecx,%eax
  801da1:	c1 f8 1f             	sar    $0x1f,%eax
  801da4:	31 c1                	xor    %eax,%ecx
  801da6:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  801da8:	83 f9 13             	cmp    $0x13,%ecx
  801dab:	7f 4e                	jg     801dfb <vprintfmt+0x1ee>
  801dad:	48 63 c1             	movslq %ecx,%rax
  801db0:	48 ba a0 2f 80 00 00 	movabs $0x802fa0,%rdx
  801db7:	00 00 00 
  801dba:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801dbe:	48 85 c0             	test   %rax,%rax
  801dc1:	74 38                	je     801dfb <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  801dc3:	48 89 c1             	mov    %rax,%rcx
  801dc6:	48 ba d9 2a 80 00 00 	movabs $0x802ad9,%rdx
  801dcd:	00 00 00 
  801dd0:	4c 89 f6             	mov    %r14,%rsi
  801dd3:	4c 89 e7             	mov    %r12,%rdi
  801dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddb:	49 b8 d0 1b 80 00 00 	movabs $0x801bd0,%r8
  801de2:	00 00 00 
  801de5:	41 ff d0             	call   *%r8
  801de8:	e9 51 fe ff ff       	jmp    801c3e <vprintfmt+0x31>
            int err = va_arg(aq, int);
  801ded:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801df1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801df5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801df9:	eb a2                	jmp    801d9d <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  801dfb:	48 ba 6c 2b 80 00 00 	movabs $0x802b6c,%rdx
  801e02:	00 00 00 
  801e05:	4c 89 f6             	mov    %r14,%rsi
  801e08:	4c 89 e7             	mov    %r12,%rdi
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e10:	49 b8 d0 1b 80 00 00 	movabs $0x801bd0,%r8
  801e17:	00 00 00 
  801e1a:	41 ff d0             	call   *%r8
  801e1d:	e9 1c fe ff ff       	jmp    801c3e <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  801e22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801e25:	83 f8 2f             	cmp    $0x2f,%eax
  801e28:	77 55                	ja     801e7f <vprintfmt+0x272>
  801e2a:	89 c2                	mov    %eax,%edx
  801e2c:	48 01 d6             	add    %rdx,%rsi
  801e2f:	83 c0 08             	add    $0x8,%eax
  801e32:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801e35:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  801e38:	48 85 d2             	test   %rdx,%rdx
  801e3b:	48 b8 65 2b 80 00 00 	movabs $0x802b65,%rax
  801e42:	00 00 00 
  801e45:	48 0f 45 c2          	cmovne %rdx,%rax
  801e49:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  801e4d:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801e51:	7e 06                	jle    801e59 <vprintfmt+0x24c>
  801e53:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  801e57:	75 34                	jne    801e8d <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801e59:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  801e5d:	48 8d 58 01          	lea    0x1(%rax),%rbx
  801e61:	0f b6 00             	movzbl (%rax),%eax
  801e64:	84 c0                	test   %al,%al
  801e66:	0f 84 b2 00 00 00    	je     801f1e <vprintfmt+0x311>
  801e6c:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  801e70:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  801e75:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  801e79:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  801e7d:	eb 74                	jmp    801ef3 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  801e7f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801e83:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801e87:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e8b:	eb a8                	jmp    801e35 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  801e8d:	49 63 f5             	movslq %r13d,%rsi
  801e90:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  801e94:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  801e9b:	00 00 00 
  801e9e:	ff d0                	call   *%rax
  801ea0:	48 89 c2             	mov    %rax,%rdx
  801ea3:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801ea6:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  801ea8:	8d 48 ff             	lea    -0x1(%rax),%ecx
  801eab:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	7e a7                	jle    801e59 <vprintfmt+0x24c>
  801eb2:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  801eb6:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  801eba:	41 89 cd             	mov    %ecx,%r13d
  801ebd:	4c 89 f6             	mov    %r14,%rsi
  801ec0:	89 df                	mov    %ebx,%edi
  801ec2:	41 ff d4             	call   *%r12
  801ec5:	41 83 ed 01          	sub    $0x1,%r13d
  801ec9:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  801ecd:	75 ee                	jne    801ebd <vprintfmt+0x2b0>
  801ecf:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  801ed3:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  801ed7:	eb 80                	jmp    801e59 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801ed9:	0f b6 f8             	movzbl %al,%edi
  801edc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801ee0:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801ee3:	41 83 ef 01          	sub    $0x1,%r15d
  801ee7:	48 83 c3 01          	add    $0x1,%rbx
  801eeb:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  801eef:	84 c0                	test   %al,%al
  801ef1:	74 1f                	je     801f12 <vprintfmt+0x305>
  801ef3:	45 85 ed             	test   %r13d,%r13d
  801ef6:	78 06                	js     801efe <vprintfmt+0x2f1>
  801ef8:	41 83 ed 01          	sub    $0x1,%r13d
  801efc:	78 46                	js     801f44 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801efe:	45 84 f6             	test   %r14b,%r14b
  801f01:	74 d6                	je     801ed9 <vprintfmt+0x2cc>
  801f03:	8d 50 e0             	lea    -0x20(%rax),%edx
  801f06:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801f0b:	80 fa 5e             	cmp    $0x5e,%dl
  801f0e:	77 cc                	ja     801edc <vprintfmt+0x2cf>
  801f10:	eb c7                	jmp    801ed9 <vprintfmt+0x2cc>
  801f12:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f16:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f1a:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  801f1e:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801f21:	8d 58 ff             	lea    -0x1(%rax),%ebx
  801f24:	85 c0                	test   %eax,%eax
  801f26:	0f 8e 12 fd ff ff    	jle    801c3e <vprintfmt+0x31>
  801f2c:	4c 89 f6             	mov    %r14,%rsi
  801f2f:	bf 20 00 00 00       	mov    $0x20,%edi
  801f34:	41 ff d4             	call   *%r12
  801f37:	83 eb 01             	sub    $0x1,%ebx
  801f3a:	83 fb ff             	cmp    $0xffffffff,%ebx
  801f3d:	75 ed                	jne    801f2c <vprintfmt+0x31f>
  801f3f:	e9 fa fc ff ff       	jmp    801c3e <vprintfmt+0x31>
  801f44:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f48:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f4c:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  801f50:	eb cc                	jmp    801f1e <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  801f52:	45 89 cd             	mov    %r9d,%r13d
  801f55:	84 c9                	test   %cl,%cl
  801f57:	75 25                	jne    801f7e <vprintfmt+0x371>
    switch (lflag) {
  801f59:	85 d2                	test   %edx,%edx
  801f5b:	74 57                	je     801fb4 <vprintfmt+0x3a7>
  801f5d:	83 fa 01             	cmp    $0x1,%edx
  801f60:	74 78                	je     801fda <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  801f62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f65:	83 f8 2f             	cmp    $0x2f,%eax
  801f68:	0f 87 92 00 00 00    	ja     802000 <vprintfmt+0x3f3>
  801f6e:	89 c2                	mov    %eax,%edx
  801f70:	48 01 d6             	add    %rdx,%rsi
  801f73:	83 c0 08             	add    $0x8,%eax
  801f76:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f79:	48 8b 1e             	mov    (%rsi),%rbx
  801f7c:	eb 16                	jmp    801f94 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  801f7e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f81:	83 f8 2f             	cmp    $0x2f,%eax
  801f84:	77 20                	ja     801fa6 <vprintfmt+0x399>
  801f86:	89 c2                	mov    %eax,%edx
  801f88:	48 01 d6             	add    %rdx,%rsi
  801f8b:	83 c0 08             	add    $0x8,%eax
  801f8e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f91:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  801f94:	48 85 db             	test   %rbx,%rbx
  801f97:	78 78                	js     802011 <vprintfmt+0x404>
            num = i;
  801f99:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  801f9c:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  801fa1:	e9 49 02 00 00       	jmp    8021ef <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801fa6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801faa:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fb2:	eb dd                	jmp    801f91 <vprintfmt+0x384>
        return va_arg(*ap, int);
  801fb4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fb7:	83 f8 2f             	cmp    $0x2f,%eax
  801fba:	77 10                	ja     801fcc <vprintfmt+0x3bf>
  801fbc:	89 c2                	mov    %eax,%edx
  801fbe:	48 01 d6             	add    %rdx,%rsi
  801fc1:	83 c0 08             	add    $0x8,%eax
  801fc4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fc7:	48 63 1e             	movslq (%rsi),%rbx
  801fca:	eb c8                	jmp    801f94 <vprintfmt+0x387>
  801fcc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fd0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fd4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fd8:	eb ed                	jmp    801fc7 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  801fda:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fdd:	83 f8 2f             	cmp    $0x2f,%eax
  801fe0:	77 10                	ja     801ff2 <vprintfmt+0x3e5>
  801fe2:	89 c2                	mov    %eax,%edx
  801fe4:	48 01 d6             	add    %rdx,%rsi
  801fe7:	83 c0 08             	add    $0x8,%eax
  801fea:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fed:	48 8b 1e             	mov    (%rsi),%rbx
  801ff0:	eb a2                	jmp    801f94 <vprintfmt+0x387>
  801ff2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801ff6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801ffa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ffe:	eb ed                	jmp    801fed <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  802000:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802004:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802008:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80200c:	e9 68 ff ff ff       	jmp    801f79 <vprintfmt+0x36c>
                putch('-', put_arg);
  802011:	4c 89 f6             	mov    %r14,%rsi
  802014:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802019:	41 ff d4             	call   *%r12
                i = -i;
  80201c:	48 f7 db             	neg    %rbx
  80201f:	e9 75 ff ff ff       	jmp    801f99 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  802024:	45 89 cd             	mov    %r9d,%r13d
  802027:	84 c9                	test   %cl,%cl
  802029:	75 2d                	jne    802058 <vprintfmt+0x44b>
    switch (lflag) {
  80202b:	85 d2                	test   %edx,%edx
  80202d:	74 57                	je     802086 <vprintfmt+0x479>
  80202f:	83 fa 01             	cmp    $0x1,%edx
  802032:	74 7f                	je     8020b3 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  802034:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802037:	83 f8 2f             	cmp    $0x2f,%eax
  80203a:	0f 87 a1 00 00 00    	ja     8020e1 <vprintfmt+0x4d4>
  802040:	89 c2                	mov    %eax,%edx
  802042:	48 01 d6             	add    %rdx,%rsi
  802045:	83 c0 08             	add    $0x8,%eax
  802048:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80204b:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80204e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  802053:	e9 97 01 00 00       	jmp    8021ef <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802058:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80205b:	83 f8 2f             	cmp    $0x2f,%eax
  80205e:	77 18                	ja     802078 <vprintfmt+0x46b>
  802060:	89 c2                	mov    %eax,%edx
  802062:	48 01 d6             	add    %rdx,%rsi
  802065:	83 c0 08             	add    $0x8,%eax
  802068:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80206b:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80206e:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802073:	e9 77 01 00 00       	jmp    8021ef <vprintfmt+0x5e2>
  802078:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80207c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802080:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802084:	eb e5                	jmp    80206b <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  802086:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802089:	83 f8 2f             	cmp    $0x2f,%eax
  80208c:	77 17                	ja     8020a5 <vprintfmt+0x498>
  80208e:	89 c2                	mov    %eax,%edx
  802090:	48 01 d6             	add    %rdx,%rsi
  802093:	83 c0 08             	add    $0x8,%eax
  802096:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802099:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  80209b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8020a0:	e9 4a 01 00 00       	jmp    8021ef <vprintfmt+0x5e2>
  8020a5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020a9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020ad:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020b1:	eb e6                	jmp    802099 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8020b3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020b6:	83 f8 2f             	cmp    $0x2f,%eax
  8020b9:	77 18                	ja     8020d3 <vprintfmt+0x4c6>
  8020bb:	89 c2                	mov    %eax,%edx
  8020bd:	48 01 d6             	add    %rdx,%rsi
  8020c0:	83 c0 08             	add    $0x8,%eax
  8020c3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020c6:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8020c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8020ce:	e9 1c 01 00 00       	jmp    8021ef <vprintfmt+0x5e2>
  8020d3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020d7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020db:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020df:	eb e5                	jmp    8020c6 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8020e1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020e5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020e9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020ed:	e9 59 ff ff ff       	jmp    80204b <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8020f2:	45 89 cd             	mov    %r9d,%r13d
  8020f5:	84 c9                	test   %cl,%cl
  8020f7:	75 2d                	jne    802126 <vprintfmt+0x519>
    switch (lflag) {
  8020f9:	85 d2                	test   %edx,%edx
  8020fb:	74 57                	je     802154 <vprintfmt+0x547>
  8020fd:	83 fa 01             	cmp    $0x1,%edx
  802100:	74 7c                	je     80217e <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  802102:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802105:	83 f8 2f             	cmp    $0x2f,%eax
  802108:	0f 87 9b 00 00 00    	ja     8021a9 <vprintfmt+0x59c>
  80210e:	89 c2                	mov    %eax,%edx
  802110:	48 01 d6             	add    %rdx,%rsi
  802113:	83 c0 08             	add    $0x8,%eax
  802116:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802119:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80211c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802121:	e9 c9 00 00 00       	jmp    8021ef <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802126:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802129:	83 f8 2f             	cmp    $0x2f,%eax
  80212c:	77 18                	ja     802146 <vprintfmt+0x539>
  80212e:	89 c2                	mov    %eax,%edx
  802130:	48 01 d6             	add    %rdx,%rsi
  802133:	83 c0 08             	add    $0x8,%eax
  802136:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802139:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80213c:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802141:	e9 a9 00 00 00       	jmp    8021ef <vprintfmt+0x5e2>
  802146:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80214a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80214e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802152:	eb e5                	jmp    802139 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  802154:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802157:	83 f8 2f             	cmp    $0x2f,%eax
  80215a:	77 14                	ja     802170 <vprintfmt+0x563>
  80215c:	89 c2                	mov    %eax,%edx
  80215e:	48 01 d6             	add    %rdx,%rsi
  802161:	83 c0 08             	add    $0x8,%eax
  802164:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802167:	8b 16                	mov    (%rsi),%edx
            base = 8;
  802169:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80216e:	eb 7f                	jmp    8021ef <vprintfmt+0x5e2>
  802170:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802174:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802178:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80217c:	eb e9                	jmp    802167 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  80217e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802181:	83 f8 2f             	cmp    $0x2f,%eax
  802184:	77 15                	ja     80219b <vprintfmt+0x58e>
  802186:	89 c2                	mov    %eax,%edx
  802188:	48 01 d6             	add    %rdx,%rsi
  80218b:	83 c0 08             	add    $0x8,%eax
  80218e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802191:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802194:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  802199:	eb 54                	jmp    8021ef <vprintfmt+0x5e2>
  80219b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80219f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8021a3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8021a7:	eb e8                	jmp    802191 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8021a9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8021ad:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8021b1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8021b5:	e9 5f ff ff ff       	jmp    802119 <vprintfmt+0x50c>
            putch('0', put_arg);
  8021ba:	45 89 cd             	mov    %r9d,%r13d
  8021bd:	4c 89 f6             	mov    %r14,%rsi
  8021c0:	bf 30 00 00 00       	mov    $0x30,%edi
  8021c5:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8021c8:	4c 89 f6             	mov    %r14,%rsi
  8021cb:	bf 78 00 00 00       	mov    $0x78,%edi
  8021d0:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8021d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021d6:	83 f8 2f             	cmp    $0x2f,%eax
  8021d9:	77 47                	ja     802222 <vprintfmt+0x615>
  8021db:	89 c2                	mov    %eax,%edx
  8021dd:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021e1:	83 c0 08             	add    $0x8,%eax
  8021e4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021e7:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8021ea:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8021ef:	48 83 ec 08          	sub    $0x8,%rsp
  8021f3:	41 80 fd 58          	cmp    $0x58,%r13b
  8021f7:	0f 94 c0             	sete   %al
  8021fa:	0f b6 c0             	movzbl %al,%eax
  8021fd:	50                   	push   %rax
  8021fe:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  802203:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  802207:	4c 89 f6             	mov    %r14,%rsi
  80220a:	4c 89 e7             	mov    %r12,%rdi
  80220d:	48 b8 02 1b 80 00 00 	movabs $0x801b02,%rax
  802214:	00 00 00 
  802217:	ff d0                	call   *%rax
            break;
  802219:	48 83 c4 10          	add    $0x10,%rsp
  80221d:	e9 1c fa ff ff       	jmp    801c3e <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  802222:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802226:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80222a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80222e:	eb b7                	jmp    8021e7 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  802230:	45 89 cd             	mov    %r9d,%r13d
  802233:	84 c9                	test   %cl,%cl
  802235:	75 2a                	jne    802261 <vprintfmt+0x654>
    switch (lflag) {
  802237:	85 d2                	test   %edx,%edx
  802239:	74 54                	je     80228f <vprintfmt+0x682>
  80223b:	83 fa 01             	cmp    $0x1,%edx
  80223e:	74 7c                	je     8022bc <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  802240:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802243:	83 f8 2f             	cmp    $0x2f,%eax
  802246:	0f 87 9e 00 00 00    	ja     8022ea <vprintfmt+0x6dd>
  80224c:	89 c2                	mov    %eax,%edx
  80224e:	48 01 d6             	add    %rdx,%rsi
  802251:	83 c0 08             	add    $0x8,%eax
  802254:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802257:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80225a:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  80225f:	eb 8e                	jmp    8021ef <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802261:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802264:	83 f8 2f             	cmp    $0x2f,%eax
  802267:	77 18                	ja     802281 <vprintfmt+0x674>
  802269:	89 c2                	mov    %eax,%edx
  80226b:	48 01 d6             	add    %rdx,%rsi
  80226e:	83 c0 08             	add    $0x8,%eax
  802271:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802274:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802277:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80227c:	e9 6e ff ff ff       	jmp    8021ef <vprintfmt+0x5e2>
  802281:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802285:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802289:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80228d:	eb e5                	jmp    802274 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  80228f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802292:	83 f8 2f             	cmp    $0x2f,%eax
  802295:	77 17                	ja     8022ae <vprintfmt+0x6a1>
  802297:	89 c2                	mov    %eax,%edx
  802299:	48 01 d6             	add    %rdx,%rsi
  80229c:	83 c0 08             	add    $0x8,%eax
  80229f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022a2:	8b 16                	mov    (%rsi),%edx
            base = 16;
  8022a4:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8022a9:	e9 41 ff ff ff       	jmp    8021ef <vprintfmt+0x5e2>
  8022ae:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022b2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022b6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022ba:	eb e6                	jmp    8022a2 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8022bc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022bf:	83 f8 2f             	cmp    $0x2f,%eax
  8022c2:	77 18                	ja     8022dc <vprintfmt+0x6cf>
  8022c4:	89 c2                	mov    %eax,%edx
  8022c6:	48 01 d6             	add    %rdx,%rsi
  8022c9:	83 c0 08             	add    $0x8,%eax
  8022cc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022cf:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8022d2:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8022d7:	e9 13 ff ff ff       	jmp    8021ef <vprintfmt+0x5e2>
  8022dc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022e0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022e4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022e8:	eb e5                	jmp    8022cf <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  8022ea:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022ee:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022f2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022f6:	e9 5c ff ff ff       	jmp    802257 <vprintfmt+0x64a>
            putch(ch, put_arg);
  8022fb:	4c 89 f6             	mov    %r14,%rsi
  8022fe:	bf 25 00 00 00       	mov    $0x25,%edi
  802303:	41 ff d4             	call   *%r12
            break;
  802306:	e9 33 f9 ff ff       	jmp    801c3e <vprintfmt+0x31>
            putch('%', put_arg);
  80230b:	4c 89 f6             	mov    %r14,%rsi
  80230e:	bf 25 00 00 00       	mov    $0x25,%edi
  802313:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  802316:	49 83 ef 01          	sub    $0x1,%r15
  80231a:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  80231f:	75 f5                	jne    802316 <vprintfmt+0x709>
  802321:	e9 18 f9 ff ff       	jmp    801c3e <vprintfmt+0x31>
}
  802326:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80232a:	5b                   	pop    %rbx
  80232b:	41 5c                	pop    %r12
  80232d:	41 5d                	pop    %r13
  80232f:	41 5e                	pop    %r14
  802331:	41 5f                	pop    %r15
  802333:	5d                   	pop    %rbp
  802334:	c3                   	ret    

0000000000802335 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  802335:	55                   	push   %rbp
  802336:	48 89 e5             	mov    %rsp,%rbp
  802339:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  80233d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802341:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  802346:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80234a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  802351:	48 85 ff             	test   %rdi,%rdi
  802354:	74 2b                	je     802381 <vsnprintf+0x4c>
  802356:	48 85 f6             	test   %rsi,%rsi
  802359:	74 26                	je     802381 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  80235b:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80235f:	48 bf b8 1b 80 00 00 	movabs $0x801bb8,%rdi
  802366:	00 00 00 
  802369:	48 b8 0d 1c 80 00 00 	movabs $0x801c0d,%rax
  802370:	00 00 00 
  802373:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  802375:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802379:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  80237c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  802381:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802386:	eb f7                	jmp    80237f <vsnprintf+0x4a>

0000000000802388 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  802388:	55                   	push   %rbp
  802389:	48 89 e5             	mov    %rsp,%rbp
  80238c:	48 83 ec 50          	sub    $0x50,%rsp
  802390:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802394:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802398:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80239c:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8023a3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8023a7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023ab:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8023af:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  8023b3:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8023b7:	48 b8 35 23 80 00 00 	movabs $0x802335,%rax
  8023be:	00 00 00 
  8023c1:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

00000000008023c5 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  8023c5:	80 3f 00             	cmpb   $0x0,(%rdi)
  8023c8:	74 10                	je     8023da <strlen+0x15>
    size_t n = 0;
  8023ca:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8023cf:	48 83 c0 01          	add    $0x1,%rax
  8023d3:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023d7:	75 f6                	jne    8023cf <strlen+0xa>
  8023d9:	c3                   	ret    
    size_t n = 0;
  8023da:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  8023df:	c3                   	ret    

00000000008023e0 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  8023e0:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  8023e5:	48 85 f6             	test   %rsi,%rsi
  8023e8:	74 10                	je     8023fa <strnlen+0x1a>
  8023ea:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023ee:	74 09                	je     8023f9 <strnlen+0x19>
  8023f0:	48 83 c0 01          	add    $0x1,%rax
  8023f4:	48 39 c6             	cmp    %rax,%rsi
  8023f7:	75 f1                	jne    8023ea <strnlen+0xa>
    return n;
}
  8023f9:	c3                   	ret    
    size_t n = 0;
  8023fa:	48 89 f0             	mov    %rsi,%rax
  8023fd:	c3                   	ret    

00000000008023fe <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8023fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802403:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  802407:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  80240a:	48 83 c0 01          	add    $0x1,%rax
  80240e:	84 d2                	test   %dl,%dl
  802410:	75 f1                	jne    802403 <strcpy+0x5>
        ;
    return res;
}
  802412:	48 89 f8             	mov    %rdi,%rax
  802415:	c3                   	ret    

0000000000802416 <strcat>:

char *
strcat(char *dst, const char *src) {
  802416:	55                   	push   %rbp
  802417:	48 89 e5             	mov    %rsp,%rbp
  80241a:	41 54                	push   %r12
  80241c:	53                   	push   %rbx
  80241d:	48 89 fb             	mov    %rdi,%rbx
  802420:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  802423:	48 b8 c5 23 80 00 00 	movabs $0x8023c5,%rax
  80242a:	00 00 00 
  80242d:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  80242f:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  802433:	4c 89 e6             	mov    %r12,%rsi
  802436:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  80243d:	00 00 00 
  802440:	ff d0                	call   *%rax
    return dst;
}
  802442:	48 89 d8             	mov    %rbx,%rax
  802445:	5b                   	pop    %rbx
  802446:	41 5c                	pop    %r12
  802448:	5d                   	pop    %rbp
  802449:	c3                   	ret    

000000000080244a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  80244a:	48 85 d2             	test   %rdx,%rdx
  80244d:	74 1d                	je     80246c <strncpy+0x22>
  80244f:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802453:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  802456:	48 83 c0 01          	add    $0x1,%rax
  80245a:	0f b6 16             	movzbl (%rsi),%edx
  80245d:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  802460:	80 fa 01             	cmp    $0x1,%dl
  802463:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  802467:	48 39 c1             	cmp    %rax,%rcx
  80246a:	75 ea                	jne    802456 <strncpy+0xc>
    }
    return ret;
}
  80246c:	48 89 f8             	mov    %rdi,%rax
  80246f:	c3                   	ret    

0000000000802470 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  802470:	48 89 f8             	mov    %rdi,%rax
  802473:	48 85 d2             	test   %rdx,%rdx
  802476:	74 24                	je     80249c <strlcpy+0x2c>
        while (--size > 0 && *src)
  802478:	48 83 ea 01          	sub    $0x1,%rdx
  80247c:	74 1b                	je     802499 <strlcpy+0x29>
  80247e:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802482:	0f b6 16             	movzbl (%rsi),%edx
  802485:	84 d2                	test   %dl,%dl
  802487:	74 10                	je     802499 <strlcpy+0x29>
            *dst++ = *src++;
  802489:	48 83 c6 01          	add    $0x1,%rsi
  80248d:	48 83 c0 01          	add    $0x1,%rax
  802491:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  802494:	48 39 c8             	cmp    %rcx,%rax
  802497:	75 e9                	jne    802482 <strlcpy+0x12>
        *dst = '\0';
  802499:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  80249c:	48 29 f8             	sub    %rdi,%rax
}
  80249f:	c3                   	ret    

00000000008024a0 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  8024a0:	0f b6 07             	movzbl (%rdi),%eax
  8024a3:	84 c0                	test   %al,%al
  8024a5:	74 13                	je     8024ba <strcmp+0x1a>
  8024a7:	38 06                	cmp    %al,(%rsi)
  8024a9:	75 0f                	jne    8024ba <strcmp+0x1a>
  8024ab:	48 83 c7 01          	add    $0x1,%rdi
  8024af:	48 83 c6 01          	add    $0x1,%rsi
  8024b3:	0f b6 07             	movzbl (%rdi),%eax
  8024b6:	84 c0                	test   %al,%al
  8024b8:	75 ed                	jne    8024a7 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8024ba:	0f b6 c0             	movzbl %al,%eax
  8024bd:	0f b6 16             	movzbl (%rsi),%edx
  8024c0:	29 d0                	sub    %edx,%eax
}
  8024c2:	c3                   	ret    

00000000008024c3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  8024c3:	48 85 d2             	test   %rdx,%rdx
  8024c6:	74 1f                	je     8024e7 <strncmp+0x24>
  8024c8:	0f b6 07             	movzbl (%rdi),%eax
  8024cb:	84 c0                	test   %al,%al
  8024cd:	74 1e                	je     8024ed <strncmp+0x2a>
  8024cf:	3a 06                	cmp    (%rsi),%al
  8024d1:	75 1a                	jne    8024ed <strncmp+0x2a>
  8024d3:	48 83 c7 01          	add    $0x1,%rdi
  8024d7:	48 83 c6 01          	add    $0x1,%rsi
  8024db:	48 83 ea 01          	sub    $0x1,%rdx
  8024df:	75 e7                	jne    8024c8 <strncmp+0x5>

    if (!n) return 0;
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e6:	c3                   	ret    
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ec:	c3                   	ret    
  8024ed:	48 85 d2             	test   %rdx,%rdx
  8024f0:	74 09                	je     8024fb <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  8024f2:	0f b6 07             	movzbl (%rdi),%eax
  8024f5:	0f b6 16             	movzbl (%rsi),%edx
  8024f8:	29 d0                	sub    %edx,%eax
  8024fa:	c3                   	ret    
    if (!n) return 0;
  8024fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802500:	c3                   	ret    

0000000000802501 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  802501:	0f b6 07             	movzbl (%rdi),%eax
  802504:	84 c0                	test   %al,%al
  802506:	74 18                	je     802520 <strchr+0x1f>
        if (*str == c) {
  802508:	0f be c0             	movsbl %al,%eax
  80250b:	39 f0                	cmp    %esi,%eax
  80250d:	74 17                	je     802526 <strchr+0x25>
    for (; *str; str++) {
  80250f:	48 83 c7 01          	add    $0x1,%rdi
  802513:	0f b6 07             	movzbl (%rdi),%eax
  802516:	84 c0                	test   %al,%al
  802518:	75 ee                	jne    802508 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  80251a:	b8 00 00 00 00       	mov    $0x0,%eax
  80251f:	c3                   	ret    
  802520:	b8 00 00 00 00       	mov    $0x0,%eax
  802525:	c3                   	ret    
  802526:	48 89 f8             	mov    %rdi,%rax
}
  802529:	c3                   	ret    

000000000080252a <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  80252a:	0f b6 07             	movzbl (%rdi),%eax
  80252d:	84 c0                	test   %al,%al
  80252f:	74 16                	je     802547 <strfind+0x1d>
  802531:	0f be c0             	movsbl %al,%eax
  802534:	39 f0                	cmp    %esi,%eax
  802536:	74 13                	je     80254b <strfind+0x21>
  802538:	48 83 c7 01          	add    $0x1,%rdi
  80253c:	0f b6 07             	movzbl (%rdi),%eax
  80253f:	84 c0                	test   %al,%al
  802541:	75 ee                	jne    802531 <strfind+0x7>
  802543:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  802546:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  802547:	48 89 f8             	mov    %rdi,%rax
  80254a:	c3                   	ret    
  80254b:	48 89 f8             	mov    %rdi,%rax
  80254e:	c3                   	ret    

000000000080254f <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80254f:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  802552:	48 89 f8             	mov    %rdi,%rax
  802555:	48 f7 d8             	neg    %rax
  802558:	83 e0 07             	and    $0x7,%eax
  80255b:	49 89 d1             	mov    %rdx,%r9
  80255e:	49 29 c1             	sub    %rax,%r9
  802561:	78 32                	js     802595 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  802563:	40 0f b6 c6          	movzbl %sil,%eax
  802567:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  80256e:	01 01 01 
  802571:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  802575:	40 f6 c7 07          	test   $0x7,%dil
  802579:	75 34                	jne    8025af <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80257b:	4c 89 c9             	mov    %r9,%rcx
  80257e:	48 c1 f9 03          	sar    $0x3,%rcx
  802582:	74 08                	je     80258c <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  802584:	fc                   	cld    
  802585:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802588:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  80258c:	4d 85 c9             	test   %r9,%r9
  80258f:	75 45                	jne    8025d6 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  802591:	4c 89 c0             	mov    %r8,%rax
  802594:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  802595:	48 85 d2             	test   %rdx,%rdx
  802598:	74 f7                	je     802591 <memset+0x42>
  80259a:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  80259d:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8025a0:	48 83 c0 01          	add    $0x1,%rax
  8025a4:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8025a8:	48 39 c2             	cmp    %rax,%rdx
  8025ab:	75 f3                	jne    8025a0 <memset+0x51>
  8025ad:	eb e2                	jmp    802591 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8025af:	40 f6 c7 01          	test   $0x1,%dil
  8025b3:	74 06                	je     8025bb <memset+0x6c>
  8025b5:	88 07                	mov    %al,(%rdi)
  8025b7:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025bb:	40 f6 c7 02          	test   $0x2,%dil
  8025bf:	74 07                	je     8025c8 <memset+0x79>
  8025c1:	66 89 07             	mov    %ax,(%rdi)
  8025c4:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025c8:	40 f6 c7 04          	test   $0x4,%dil
  8025cc:	74 ad                	je     80257b <memset+0x2c>
  8025ce:	89 07                	mov    %eax,(%rdi)
  8025d0:	48 83 c7 04          	add    $0x4,%rdi
  8025d4:	eb a5                	jmp    80257b <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025d6:	41 f6 c1 04          	test   $0x4,%r9b
  8025da:	74 06                	je     8025e2 <memset+0x93>
  8025dc:	89 07                	mov    %eax,(%rdi)
  8025de:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025e2:	41 f6 c1 02          	test   $0x2,%r9b
  8025e6:	74 07                	je     8025ef <memset+0xa0>
  8025e8:	66 89 07             	mov    %ax,(%rdi)
  8025eb:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8025ef:	41 f6 c1 01          	test   $0x1,%r9b
  8025f3:	74 9c                	je     802591 <memset+0x42>
  8025f5:	88 07                	mov    %al,(%rdi)
  8025f7:	eb 98                	jmp    802591 <memset+0x42>

00000000008025f9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8025f9:	48 89 f8             	mov    %rdi,%rax
  8025fc:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8025ff:	48 39 fe             	cmp    %rdi,%rsi
  802602:	73 39                	jae    80263d <memmove+0x44>
  802604:	48 01 f2             	add    %rsi,%rdx
  802607:	48 39 fa             	cmp    %rdi,%rdx
  80260a:	76 31                	jbe    80263d <memmove+0x44>
        s += n;
        d += n;
  80260c:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80260f:	48 89 d6             	mov    %rdx,%rsi
  802612:	48 09 fe             	or     %rdi,%rsi
  802615:	48 09 ce             	or     %rcx,%rsi
  802618:	40 f6 c6 07          	test   $0x7,%sil
  80261c:	75 12                	jne    802630 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80261e:	48 83 ef 08          	sub    $0x8,%rdi
  802622:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  802626:	48 c1 e9 03          	shr    $0x3,%rcx
  80262a:	fd                   	std    
  80262b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80262e:	fc                   	cld    
  80262f:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  802630:	48 83 ef 01          	sub    $0x1,%rdi
  802634:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  802638:	fd                   	std    
  802639:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  80263b:	eb f1                	jmp    80262e <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80263d:	48 89 f2             	mov    %rsi,%rdx
  802640:	48 09 c2             	or     %rax,%rdx
  802643:	48 09 ca             	or     %rcx,%rdx
  802646:	f6 c2 07             	test   $0x7,%dl
  802649:	75 0c                	jne    802657 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80264b:	48 c1 e9 03          	shr    $0x3,%rcx
  80264f:	48 89 c7             	mov    %rax,%rdi
  802652:	fc                   	cld    
  802653:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  802656:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  802657:	48 89 c7             	mov    %rax,%rdi
  80265a:	fc                   	cld    
  80265b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  80265d:	c3                   	ret    

000000000080265e <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  80265e:	55                   	push   %rbp
  80265f:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802662:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  802669:	00 00 00 
  80266c:	ff d0                	call   *%rax
}
  80266e:	5d                   	pop    %rbp
  80266f:	c3                   	ret    

0000000000802670 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802670:	55                   	push   %rbp
  802671:	48 89 e5             	mov    %rsp,%rbp
  802674:	41 57                	push   %r15
  802676:	41 56                	push   %r14
  802678:	41 55                	push   %r13
  80267a:	41 54                	push   %r12
  80267c:	53                   	push   %rbx
  80267d:	48 83 ec 08          	sub    $0x8,%rsp
  802681:	49 89 fe             	mov    %rdi,%r14
  802684:	49 89 f7             	mov    %rsi,%r15
  802687:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  80268a:	48 89 f7             	mov    %rsi,%rdi
  80268d:	48 b8 c5 23 80 00 00 	movabs $0x8023c5,%rax
  802694:	00 00 00 
  802697:	ff d0                	call   *%rax
  802699:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80269c:	48 89 de             	mov    %rbx,%rsi
  80269f:	4c 89 f7             	mov    %r14,%rdi
  8026a2:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  8026a9:	00 00 00 
  8026ac:	ff d0                	call   *%rax
  8026ae:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8026b1:	48 39 c3             	cmp    %rax,%rbx
  8026b4:	74 36                	je     8026ec <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  8026b6:	48 89 d8             	mov    %rbx,%rax
  8026b9:	4c 29 e8             	sub    %r13,%rax
  8026bc:	4c 39 e0             	cmp    %r12,%rax
  8026bf:	76 30                	jbe    8026f1 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  8026c1:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8026c6:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026ca:	4c 89 fe             	mov    %r15,%rsi
  8026cd:	48 b8 5e 26 80 00 00 	movabs $0x80265e,%rax
  8026d4:	00 00 00 
  8026d7:	ff d0                	call   *%rax
    return dstlen + srclen;
  8026d9:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8026dd:	48 83 c4 08          	add    $0x8,%rsp
  8026e1:	5b                   	pop    %rbx
  8026e2:	41 5c                	pop    %r12
  8026e4:	41 5d                	pop    %r13
  8026e6:	41 5e                	pop    %r14
  8026e8:	41 5f                	pop    %r15
  8026ea:	5d                   	pop    %rbp
  8026eb:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8026ec:	4c 01 e0             	add    %r12,%rax
  8026ef:	eb ec                	jmp    8026dd <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8026f1:	48 83 eb 01          	sub    $0x1,%rbx
  8026f5:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026f9:	48 89 da             	mov    %rbx,%rdx
  8026fc:	4c 89 fe             	mov    %r15,%rsi
  8026ff:	48 b8 5e 26 80 00 00 	movabs $0x80265e,%rax
  802706:	00 00 00 
  802709:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80270b:	49 01 de             	add    %rbx,%r14
  80270e:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  802713:	eb c4                	jmp    8026d9 <strlcat+0x69>

0000000000802715 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  802715:	49 89 f0             	mov    %rsi,%r8
  802718:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  80271b:	48 85 d2             	test   %rdx,%rdx
  80271e:	74 2a                	je     80274a <memcmp+0x35>
  802720:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  802725:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  802729:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80272e:	38 ca                	cmp    %cl,%dl
  802730:	75 0f                	jne    802741 <memcmp+0x2c>
    while (n-- > 0) {
  802732:	48 83 c0 01          	add    $0x1,%rax
  802736:	48 39 c6             	cmp    %rax,%rsi
  802739:	75 ea                	jne    802725 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80273b:	b8 00 00 00 00       	mov    $0x0,%eax
  802740:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  802741:	0f b6 c2             	movzbl %dl,%eax
  802744:	0f b6 c9             	movzbl %cl,%ecx
  802747:	29 c8                	sub    %ecx,%eax
  802749:	c3                   	ret    
    return 0;
  80274a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80274f:	c3                   	ret    

0000000000802750 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  802750:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802754:	48 39 c7             	cmp    %rax,%rdi
  802757:	73 0f                	jae    802768 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802759:	40 38 37             	cmp    %sil,(%rdi)
  80275c:	74 0e                	je     80276c <memfind+0x1c>
    for (; src < end; src++) {
  80275e:	48 83 c7 01          	add    $0x1,%rdi
  802762:	48 39 f8             	cmp    %rdi,%rax
  802765:	75 f2                	jne    802759 <memfind+0x9>
  802767:	c3                   	ret    
  802768:	48 89 f8             	mov    %rdi,%rax
  80276b:	c3                   	ret    
  80276c:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80276f:	c3                   	ret    

0000000000802770 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802770:	49 89 f2             	mov    %rsi,%r10
  802773:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802776:	0f b6 37             	movzbl (%rdi),%esi
  802779:	40 80 fe 20          	cmp    $0x20,%sil
  80277d:	74 06                	je     802785 <strtol+0x15>
  80277f:	40 80 fe 09          	cmp    $0x9,%sil
  802783:	75 13                	jne    802798 <strtol+0x28>
  802785:	48 83 c7 01          	add    $0x1,%rdi
  802789:	0f b6 37             	movzbl (%rdi),%esi
  80278c:	40 80 fe 20          	cmp    $0x20,%sil
  802790:	74 f3                	je     802785 <strtol+0x15>
  802792:	40 80 fe 09          	cmp    $0x9,%sil
  802796:	74 ed                	je     802785 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802798:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  80279b:	83 e0 fd             	and    $0xfffffffd,%eax
  80279e:	3c 01                	cmp    $0x1,%al
  8027a0:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8027a4:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  8027ab:	75 11                	jne    8027be <strtol+0x4e>
  8027ad:	80 3f 30             	cmpb   $0x30,(%rdi)
  8027b0:	74 16                	je     8027c8 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8027b2:	45 85 c0             	test   %r8d,%r8d
  8027b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8027ba:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8027be:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8027c3:	4d 63 c8             	movslq %r8d,%r9
  8027c6:	eb 38                	jmp    802800 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8027c8:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8027cc:	74 11                	je     8027df <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8027ce:	45 85 c0             	test   %r8d,%r8d
  8027d1:	75 eb                	jne    8027be <strtol+0x4e>
        s++;
  8027d3:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8027d7:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8027dd:	eb df                	jmp    8027be <strtol+0x4e>
        s += 2;
  8027df:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8027e3:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8027e9:	eb d3                	jmp    8027be <strtol+0x4e>
            dig -= '0';
  8027eb:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8027ee:	0f b6 c8             	movzbl %al,%ecx
  8027f1:	44 39 c1             	cmp    %r8d,%ecx
  8027f4:	7d 1f                	jge    802815 <strtol+0xa5>
        val = val * base + dig;
  8027f6:	49 0f af d1          	imul   %r9,%rdx
  8027fa:	0f b6 c0             	movzbl %al,%eax
  8027fd:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  802800:	48 83 c7 01          	add    $0x1,%rdi
  802804:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  802808:	3c 39                	cmp    $0x39,%al
  80280a:	76 df                	jbe    8027eb <strtol+0x7b>
        else if (dig - 'a' < 27)
  80280c:	3c 7b                	cmp    $0x7b,%al
  80280e:	77 05                	ja     802815 <strtol+0xa5>
            dig -= 'a' - 10;
  802810:	83 e8 57             	sub    $0x57,%eax
  802813:	eb d9                	jmp    8027ee <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  802815:	4d 85 d2             	test   %r10,%r10
  802818:	74 03                	je     80281d <strtol+0xad>
  80281a:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80281d:	48 89 d0             	mov    %rdx,%rax
  802820:	48 f7 d8             	neg    %rax
  802823:	40 80 fe 2d          	cmp    $0x2d,%sil
  802827:	48 0f 44 d0          	cmove  %rax,%rdx
}
  80282b:	48 89 d0             	mov    %rdx,%rax
  80282e:	c3                   	ret    

000000000080282f <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80282f:	55                   	push   %rbp
  802830:	48 89 e5             	mov    %rsp,%rbp
  802833:	41 54                	push   %r12
  802835:	53                   	push   %rbx
  802836:	48 89 fb             	mov    %rdi,%rbx
  802839:	48 89 f7             	mov    %rsi,%rdi
  80283c:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  80283f:	48 85 f6             	test   %rsi,%rsi
  802842:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802849:	00 00 00 
  80284c:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802850:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802855:	48 85 d2             	test   %rdx,%rdx
  802858:	74 02                	je     80285c <ipc_recv+0x2d>
  80285a:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  80285c:	48 63 f6             	movslq %esi,%rsi
  80285f:	48 b8 44 05 80 00 00 	movabs $0x800544,%rax
  802866:	00 00 00 
  802869:	ff d0                	call   *%rax

    if (res < 0) {
  80286b:	85 c0                	test   %eax,%eax
  80286d:	78 45                	js     8028b4 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  80286f:	48 85 db             	test   %rbx,%rbx
  802872:	74 12                	je     802886 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802874:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80287b:	00 00 00 
  80287e:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802884:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802886:	4d 85 e4             	test   %r12,%r12
  802889:	74 14                	je     80289f <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  80288b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802892:	00 00 00 
  802895:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  80289b:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  80289f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8028a6:	00 00 00 
  8028a9:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8028af:	5b                   	pop    %rbx
  8028b0:	41 5c                	pop    %r12
  8028b2:	5d                   	pop    %rbp
  8028b3:	c3                   	ret    
        if (from_env_store)
  8028b4:	48 85 db             	test   %rbx,%rbx
  8028b7:	74 06                	je     8028bf <ipc_recv+0x90>
            *from_env_store = 0;
  8028b9:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8028bf:	4d 85 e4             	test   %r12,%r12
  8028c2:	74 eb                	je     8028af <ipc_recv+0x80>
            *perm_store = 0;
  8028c4:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028cb:	00 
  8028cc:	eb e1                	jmp    8028af <ipc_recv+0x80>

00000000008028ce <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028ce:	55                   	push   %rbp
  8028cf:	48 89 e5             	mov    %rsp,%rbp
  8028d2:	41 57                	push   %r15
  8028d4:	41 56                	push   %r14
  8028d6:	41 55                	push   %r13
  8028d8:	41 54                	push   %r12
  8028da:	53                   	push   %rbx
  8028db:	48 83 ec 18          	sub    $0x18,%rsp
  8028df:	41 89 fd             	mov    %edi,%r13d
  8028e2:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028e5:	48 89 d3             	mov    %rdx,%rbx
  8028e8:	49 89 cc             	mov    %rcx,%r12
  8028eb:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028ef:	48 85 d2             	test   %rdx,%rdx
  8028f2:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8028f9:	00 00 00 
  8028fc:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802900:	49 be 18 05 80 00 00 	movabs $0x800518,%r14
  802907:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  80290a:	49 bf 1b 02 80 00 00 	movabs $0x80021b,%r15
  802911:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802914:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802917:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  80291b:	4c 89 e1             	mov    %r12,%rcx
  80291e:	48 89 da             	mov    %rbx,%rdx
  802921:	44 89 ef             	mov    %r13d,%edi
  802924:	41 ff d6             	call   *%r14
  802927:	85 c0                	test   %eax,%eax
  802929:	79 37                	jns    802962 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  80292b:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80292e:	75 05                	jne    802935 <ipc_send+0x67>
          sys_yield();
  802930:	41 ff d7             	call   *%r15
  802933:	eb df                	jmp    802914 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802935:	89 c1                	mov    %eax,%ecx
  802937:	48 ba 5f 30 80 00 00 	movabs $0x80305f,%rdx
  80293e:	00 00 00 
  802941:	be 46 00 00 00       	mov    $0x46,%esi
  802946:	48 bf 72 30 80 00 00 	movabs $0x803072,%rdi
  80294d:	00 00 00 
  802950:	b8 00 00 00 00       	mov    $0x0,%eax
  802955:	49 b8 6d 19 80 00 00 	movabs $0x80196d,%r8
  80295c:	00 00 00 
  80295f:	41 ff d0             	call   *%r8
      }
}
  802962:	48 83 c4 18          	add    $0x18,%rsp
  802966:	5b                   	pop    %rbx
  802967:	41 5c                	pop    %r12
  802969:	41 5d                	pop    %r13
  80296b:	41 5e                	pop    %r14
  80296d:	41 5f                	pop    %r15
  80296f:	5d                   	pop    %rbp
  802970:	c3                   	ret    

0000000000802971 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802971:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802976:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  80297d:	00 00 00 
  802980:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802984:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802988:	48 c1 e2 04          	shl    $0x4,%rdx
  80298c:	48 01 ca             	add    %rcx,%rdx
  80298f:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802995:	39 fa                	cmp    %edi,%edx
  802997:	74 12                	je     8029ab <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802999:	48 83 c0 01          	add    $0x1,%rax
  80299d:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8029a3:	75 db                	jne    802980 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8029a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029aa:	c3                   	ret    
            return envs[i].env_id;
  8029ab:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8029af:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8029b3:	48 c1 e0 04          	shl    $0x4,%rax
  8029b7:	48 89 c2             	mov    %rax,%rdx
  8029ba:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8029c1:	00 00 00 
  8029c4:	48 01 d0             	add    %rdx,%rax
  8029c7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029cd:	c3                   	ret    
  8029ce:	66 90                	xchg   %ax,%ax

00000000008029d0 <__rodata_start>:
  8029d0:	69 64 6c 65 00 3c 75 	imul   $0x6e753c00,0x65(%rsp,%rbp,2),%esp
  8029d7:	6e 
  8029d8:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8029dc:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029dd:	3e 00 90 73 79 73 63 	ds add %dl,0x63737973(%rax)
  8029e4:	61                   	(bad)  
  8029e5:	6c                   	insb   (%dx),%es:(%rdi)
  8029e6:	6c                   	insb   (%dx),%es:(%rdi)
  8029e7:	20 25 7a 64 20 72    	and    %ah,0x7220647a(%rip)        # 72a08e67 <__bss_end+0x72200e67>
  8029ed:	65 74 75             	gs je  802a65 <__rodata_start+0x95>
  8029f0:	72 6e                	jb     802a60 <__rodata_start+0x90>
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
  802ce0:	b7 1c 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .........#......
  802cf0:	fb 22 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .".......#......
  802d00:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802d10:	0b 23 80 00 00 00 00 00 d1 1c 80 00 00 00 00 00     .#..............
  802d20:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802d30:	c8 1c 80 00 00 00 00 00 3e 1d 80 00 00 00 00 00     ........>.......
  802d40:	0b 23 80 00 00 00 00 00 c8 1c 80 00 00 00 00 00     .#..............
  802d50:	0b 1d 80 00 00 00 00 00 0b 1d 80 00 00 00 00 00     ................
  802d60:	0b 1d 80 00 00 00 00 00 0b 1d 80 00 00 00 00 00     ................
  802d70:	0b 1d 80 00 00 00 00 00 0b 1d 80 00 00 00 00 00     ................
  802d80:	0b 1d 80 00 00 00 00 00 0b 1d 80 00 00 00 00 00     ................
  802d90:	0b 1d 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .........#......
  802da0:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802db0:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802dc0:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802dd0:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802de0:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802df0:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802e00:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802e10:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802e20:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802e30:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802e40:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802e50:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802e60:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802e70:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802e80:	0b 23 80 00 00 00 00 00 30 22 80 00 00 00 00 00     .#......0"......
  802e90:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802ea0:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802eb0:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802ec0:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802ed0:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802ee0:	5c 1d 80 00 00 00 00 00 52 1f 80 00 00 00 00 00     \.......R.......
  802ef0:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802f00:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802f10:	8a 1d 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .........#......
  802f20:	0b 23 80 00 00 00 00 00 51 1d 80 00 00 00 00 00     .#......Q.......
  802f30:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802f40:	f2 20 80 00 00 00 00 00 ba 21 80 00 00 00 00 00     . .......!......
  802f50:	0b 23 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     .#.......#......
  802f60:	22 1e 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     "........#......
  802f70:	24 20 80 00 00 00 00 00 0b 23 80 00 00 00 00 00     $ .......#......
  802f80:	0b 23 80 00 00 00 00 00 30 22 80 00 00 00 00 00     .#......0"......
  802f90:	0b 23 80 00 00 00 00 00 c0 1c 80 00 00 00 00 00     .#..............

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
