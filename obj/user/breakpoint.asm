
obj/user/breakpoint:     file format elf64-x86-64


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
  80001e:	e8 04 00 00 00       	call   800027 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv) {
    asm volatile("int $3");
  800025:	cc                   	int3   
}
  800026:	c3                   	ret    

0000000000800027 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800027:	55                   	push   %rbp
  800028:	48 89 e5             	mov    %rsp,%rbp
  80002b:	41 56                	push   %r14
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	41 89 fd             	mov    %edi,%r13d
  800035:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800038:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80003f:	00 00 00 
  800042:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800049:	00 00 00 
  80004c:	48 39 c2             	cmp    %rax,%rdx
  80004f:	73 17                	jae    800068 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800051:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800054:	49 89 c4             	mov    %rax,%r12
  800057:	48 83 c3 08          	add    $0x8,%rbx
  80005b:	b8 00 00 00 00       	mov    $0x0,%eax
  800060:	ff 53 f8             	call   *-0x8(%rbx)
  800063:	4c 39 e3             	cmp    %r12,%rbx
  800066:	72 ef                	jb     800057 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800068:	48 b8 c1 01 80 00 00 	movabs $0x8001c1,%rax
  80006f:	00 00 00 
  800072:	ff d0                	call   *%rax
  800074:	25 ff 03 00 00       	and    $0x3ff,%eax
  800079:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80007d:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800081:	48 c1 e0 04          	shl    $0x4,%rax
  800085:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  80008c:	00 00 00 
  80008f:	48 01 d0             	add    %rdx,%rax
  800092:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800099:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80009c:	45 85 ed             	test   %r13d,%r13d
  80009f:	7e 0d                	jle    8000ae <libmain+0x87>
  8000a1:	49 8b 06             	mov    (%r14),%rax
  8000a4:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000ab:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000ae:	4c 89 f6             	mov    %r14,%rsi
  8000b1:	44 89 ef             	mov    %r13d,%edi
  8000b4:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000bb:	00 00 00 
  8000be:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000c0:	48 b8 d5 00 80 00 00 	movabs $0x8000d5,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	call   *%rax
#endif
}
  8000cc:	5b                   	pop    %rbx
  8000cd:	41 5c                	pop    %r12
  8000cf:	41 5d                	pop    %r13
  8000d1:	41 5e                	pop    %r14
  8000d3:	5d                   	pop    %rbp
  8000d4:	c3                   	ret    

00000000008000d5 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000d5:	55                   	push   %rbp
  8000d6:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000d9:	48 b8 11 08 80 00 00 	movabs $0x800811,%rax
  8000e0:	00 00 00 
  8000e3:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8000e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ea:	48 b8 56 01 80 00 00 	movabs $0x800156,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	call   *%rax
}
  8000f6:	5d                   	pop    %rbp
  8000f7:	c3                   	ret    

00000000008000f8 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8000f8:	55                   	push   %rbp
  8000f9:	48 89 e5             	mov    %rsp,%rbp
  8000fc:	53                   	push   %rbx
  8000fd:	48 89 fa             	mov    %rdi,%rdx
  800100:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800108:	bb 00 00 00 00       	mov    $0x0,%ebx
  80010d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800112:	be 00 00 00 00       	mov    $0x0,%esi
  800117:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80011d:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80011f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800123:	c9                   	leave  
  800124:	c3                   	ret    

0000000000800125 <sys_cgetc>:

int
sys_cgetc(void) {
  800125:	55                   	push   %rbp
  800126:	48 89 e5             	mov    %rsp,%rbp
  800129:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80012a:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80012f:	ba 00 00 00 00       	mov    $0x0,%edx
  800134:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800139:	bb 00 00 00 00       	mov    $0x0,%ebx
  80013e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800143:	be 00 00 00 00       	mov    $0x0,%esi
  800148:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80014e:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800150:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800154:	c9                   	leave  
  800155:	c3                   	ret    

0000000000800156 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800156:	55                   	push   %rbp
  800157:	48 89 e5             	mov    %rsp,%rbp
  80015a:	53                   	push   %rbx
  80015b:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80015f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800162:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800167:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80016c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800171:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800176:	be 00 00 00 00       	mov    $0x0,%esi
  80017b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800181:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800183:	48 85 c0             	test   %rax,%rax
  800186:	7f 06                	jg     80018e <sys_env_destroy+0x38>
}
  800188:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80018c:	c9                   	leave  
  80018d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80018e:	49 89 c0             	mov    %rax,%r8
  800191:	b9 03 00 00 00       	mov    $0x3,%ecx
  800196:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  80019d:	00 00 00 
  8001a0:	be 26 00 00 00       	mov    $0x26,%esi
  8001a5:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  8001ac:	00 00 00 
  8001af:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b4:	49 b9 44 19 80 00 00 	movabs $0x801944,%r9
  8001bb:	00 00 00 
  8001be:	41 ff d1             	call   *%r9

00000000008001c1 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001c1:	55                   	push   %rbp
  8001c2:	48 89 e5             	mov    %rsp,%rbp
  8001c5:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001c6:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8001d0:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001da:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001df:	be 00 00 00 00       	mov    $0x0,%esi
  8001e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001ea:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8001ec:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

00000000008001f2 <sys_yield>:

void
sys_yield(void) {
  8001f2:	55                   	push   %rbp
  8001f3:	48 89 e5             	mov    %rsp,%rbp
  8001f6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001f7:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800201:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800206:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800210:	be 00 00 00 00       	mov    $0x0,%esi
  800215:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80021b:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80021d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800221:	c9                   	leave  
  800222:	c3                   	ret    

0000000000800223 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  800223:	55                   	push   %rbp
  800224:	48 89 e5             	mov    %rsp,%rbp
  800227:	53                   	push   %rbx
  800228:	48 89 fa             	mov    %rdi,%rdx
  80022b:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80022e:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800233:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80023a:	00 00 00 
  80023d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800242:	be 00 00 00 00       	mov    $0x0,%esi
  800247:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80024d:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80024f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800253:	c9                   	leave  
  800254:	c3                   	ret    

0000000000800255 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  800255:	55                   	push   %rbp
  800256:	48 89 e5             	mov    %rsp,%rbp
  800259:	53                   	push   %rbx
  80025a:	49 89 f8             	mov    %rdi,%r8
  80025d:	48 89 d3             	mov    %rdx,%rbx
  800260:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  800263:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800268:	4c 89 c2             	mov    %r8,%rdx
  80026b:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80026e:	be 00 00 00 00       	mov    $0x0,%esi
  800273:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800279:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80027b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80027f:	c9                   	leave  
  800280:	c3                   	ret    

0000000000800281 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  800281:	55                   	push   %rbp
  800282:	48 89 e5             	mov    %rsp,%rbp
  800285:	53                   	push   %rbx
  800286:	48 83 ec 08          	sub    $0x8,%rsp
  80028a:	89 f8                	mov    %edi,%eax
  80028c:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80028f:	48 63 f9             	movslq %ecx,%rdi
  800292:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800295:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80029a:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80029d:	be 00 00 00 00       	mov    $0x0,%esi
  8002a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002a8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002aa:	48 85 c0             	test   %rax,%rax
  8002ad:	7f 06                	jg     8002b5 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002af:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002b5:	49 89 c0             	mov    %rax,%r8
  8002b8:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002bd:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  8002c4:	00 00 00 
  8002c7:	be 26 00 00 00       	mov    $0x26,%esi
  8002cc:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  8002d3:	00 00 00 
  8002d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002db:	49 b9 44 19 80 00 00 	movabs $0x801944,%r9
  8002e2:	00 00 00 
  8002e5:	41 ff d1             	call   *%r9

00000000008002e8 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8002e8:	55                   	push   %rbp
  8002e9:	48 89 e5             	mov    %rsp,%rbp
  8002ec:	53                   	push   %rbx
  8002ed:	48 83 ec 08          	sub    $0x8,%rsp
  8002f1:	89 f8                	mov    %edi,%eax
  8002f3:	49 89 f2             	mov    %rsi,%r10
  8002f6:	48 89 cf             	mov    %rcx,%rdi
  8002f9:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8002fc:	48 63 da             	movslq %edx,%rbx
  8002ff:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800302:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800307:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80030a:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80030d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80030f:	48 85 c0             	test   %rax,%rax
  800312:	7f 06                	jg     80031a <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  800314:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800318:	c9                   	leave  
  800319:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80031a:	49 89 c0             	mov    %rax,%r8
  80031d:	b9 05 00 00 00       	mov    $0x5,%ecx
  800322:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  800329:	00 00 00 
  80032c:	be 26 00 00 00       	mov    $0x26,%esi
  800331:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  800338:	00 00 00 
  80033b:	b8 00 00 00 00       	mov    $0x0,%eax
  800340:	49 b9 44 19 80 00 00 	movabs $0x801944,%r9
  800347:	00 00 00 
  80034a:	41 ff d1             	call   *%r9

000000000080034d <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80034d:	55                   	push   %rbp
  80034e:	48 89 e5             	mov    %rsp,%rbp
  800351:	53                   	push   %rbx
  800352:	48 83 ec 08          	sub    $0x8,%rsp
  800356:	48 89 f1             	mov    %rsi,%rcx
  800359:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80035c:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80035f:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800364:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800369:	be 00 00 00 00       	mov    $0x0,%esi
  80036e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800374:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800376:	48 85 c0             	test   %rax,%rax
  800379:	7f 06                	jg     800381 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80037b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80037f:	c9                   	leave  
  800380:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800381:	49 89 c0             	mov    %rax,%r8
  800384:	b9 06 00 00 00       	mov    $0x6,%ecx
  800389:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  800390:	00 00 00 
  800393:	be 26 00 00 00       	mov    $0x26,%esi
  800398:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  80039f:	00 00 00 
  8003a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a7:	49 b9 44 19 80 00 00 	movabs $0x801944,%r9
  8003ae:	00 00 00 
  8003b1:	41 ff d1             	call   *%r9

00000000008003b4 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8003b4:	55                   	push   %rbp
  8003b5:	48 89 e5             	mov    %rsp,%rbp
  8003b8:	53                   	push   %rbx
  8003b9:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8003bd:	48 63 ce             	movslq %esi,%rcx
  8003c0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8003c3:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8003c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003cd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003d2:	be 00 00 00 00       	mov    $0x0,%esi
  8003d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003dd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003df:	48 85 c0             	test   %rax,%rax
  8003e2:	7f 06                	jg     8003ea <sys_env_set_status+0x36>
}
  8003e4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003e8:	c9                   	leave  
  8003e9:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003ea:	49 89 c0             	mov    %rax,%r8
  8003ed:	b9 09 00 00 00       	mov    $0x9,%ecx
  8003f2:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  8003f9:	00 00 00 
  8003fc:	be 26 00 00 00       	mov    $0x26,%esi
  800401:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  800408:	00 00 00 
  80040b:	b8 00 00 00 00       	mov    $0x0,%eax
  800410:	49 b9 44 19 80 00 00 	movabs $0x801944,%r9
  800417:	00 00 00 
  80041a:	41 ff d1             	call   *%r9

000000000080041d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80041d:	55                   	push   %rbp
  80041e:	48 89 e5             	mov    %rsp,%rbp
  800421:	53                   	push   %rbx
  800422:	48 83 ec 08          	sub    $0x8,%rsp
  800426:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  800429:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80042c:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800431:	bb 00 00 00 00       	mov    $0x0,%ebx
  800436:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80043b:	be 00 00 00 00       	mov    $0x0,%esi
  800440:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800446:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800448:	48 85 c0             	test   %rax,%rax
  80044b:	7f 06                	jg     800453 <sys_env_set_trapframe+0x36>
}
  80044d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800451:	c9                   	leave  
  800452:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800453:	49 89 c0             	mov    %rax,%r8
  800456:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80045b:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  800462:	00 00 00 
  800465:	be 26 00 00 00       	mov    $0x26,%esi
  80046a:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  800471:	00 00 00 
  800474:	b8 00 00 00 00       	mov    $0x0,%eax
  800479:	49 b9 44 19 80 00 00 	movabs $0x801944,%r9
  800480:	00 00 00 
  800483:	41 ff d1             	call   *%r9

0000000000800486 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  800486:	55                   	push   %rbp
  800487:	48 89 e5             	mov    %rsp,%rbp
  80048a:	53                   	push   %rbx
  80048b:	48 83 ec 08          	sub    $0x8,%rsp
  80048f:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  800492:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800495:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80049a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80049f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004a4:	be 00 00 00 00       	mov    $0x0,%esi
  8004a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004af:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004b1:	48 85 c0             	test   %rax,%rax
  8004b4:	7f 06                	jg     8004bc <sys_env_set_pgfault_upcall+0x36>
}
  8004b6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004bc:	49 89 c0             	mov    %rax,%r8
  8004bf:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8004c4:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  8004cb:	00 00 00 
  8004ce:	be 26 00 00 00       	mov    $0x26,%esi
  8004d3:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  8004da:	00 00 00 
  8004dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e2:	49 b9 44 19 80 00 00 	movabs $0x801944,%r9
  8004e9:	00 00 00 
  8004ec:	41 ff d1             	call   *%r9

00000000008004ef <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8004ef:	55                   	push   %rbp
  8004f0:	48 89 e5             	mov    %rsp,%rbp
  8004f3:	53                   	push   %rbx
  8004f4:	89 f8                	mov    %edi,%eax
  8004f6:	49 89 f1             	mov    %rsi,%r9
  8004f9:	48 89 d3             	mov    %rdx,%rbx
  8004fc:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8004ff:	49 63 f0             	movslq %r8d,%rsi
  800502:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800505:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80050a:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80050d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800513:	cd 30                	int    $0x30
}
  800515:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800519:	c9                   	leave  
  80051a:	c3                   	ret    

000000000080051b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	53                   	push   %rbx
  800520:	48 83 ec 08          	sub    $0x8,%rsp
  800524:	48 89 fa             	mov    %rdi,%rdx
  800527:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80052a:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80052f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800534:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800539:	be 00 00 00 00       	mov    $0x0,%esi
  80053e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800544:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800546:	48 85 c0             	test   %rax,%rax
  800549:	7f 06                	jg     800551 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80054b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80054f:	c9                   	leave  
  800550:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800551:	49 89 c0             	mov    %rax,%r8
  800554:	b9 0e 00 00 00       	mov    $0xe,%ecx
  800559:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  800560:	00 00 00 
  800563:	be 26 00 00 00       	mov    $0x26,%esi
  800568:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  80056f:	00 00 00 
  800572:	b8 00 00 00 00       	mov    $0x0,%eax
  800577:	49 b9 44 19 80 00 00 	movabs $0x801944,%r9
  80057e:	00 00 00 
  800581:	41 ff d1             	call   *%r9

0000000000800584 <sys_gettime>:

int
sys_gettime(void) {
  800584:	55                   	push   %rbp
  800585:	48 89 e5             	mov    %rsp,%rbp
  800588:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800589:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80058e:	ba 00 00 00 00       	mov    $0x0,%edx
  800593:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800598:	bb 00 00 00 00       	mov    $0x0,%ebx
  80059d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005a2:	be 00 00 00 00       	mov    $0x0,%esi
  8005a7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005ad:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8005af:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005b3:	c9                   	leave  
  8005b4:	c3                   	ret    

00000000008005b5 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8005b5:	55                   	push   %rbp
  8005b6:	48 89 e5             	mov    %rsp,%rbp
  8005b9:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005ba:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c4:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005ce:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005d3:	be 00 00 00 00       	mov    $0x0,%esi
  8005d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005de:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8005e0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

00000000008005e6 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8005e6:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8005ed:	ff ff ff 
  8005f0:	48 01 f8             	add    %rdi,%rax
  8005f3:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8005f7:	c3                   	ret    

00000000008005f8 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8005f8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8005ff:	ff ff ff 
  800602:	48 01 f8             	add    %rdi,%rax
  800605:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  800609:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80060f:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800613:	c3                   	ret    

0000000000800614 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  800614:	55                   	push   %rbp
  800615:	48 89 e5             	mov    %rsp,%rbp
  800618:	41 57                	push   %r15
  80061a:	41 56                	push   %r14
  80061c:	41 55                	push   %r13
  80061e:	41 54                	push   %r12
  800620:	53                   	push   %rbx
  800621:	48 83 ec 08          	sub    $0x8,%rsp
  800625:	49 89 ff             	mov    %rdi,%r15
  800628:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80062d:	49 bc c2 15 80 00 00 	movabs $0x8015c2,%r12
  800634:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  800637:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  80063d:	48 89 df             	mov    %rbx,%rdi
  800640:	41 ff d4             	call   *%r12
  800643:	83 e0 04             	and    $0x4,%eax
  800646:	74 1a                	je     800662 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  800648:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80064f:	4c 39 f3             	cmp    %r14,%rbx
  800652:	75 e9                	jne    80063d <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  800654:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  80065b:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  800660:	eb 03                	jmp    800665 <fd_alloc+0x51>
            *fd_store = fd;
  800662:	49 89 1f             	mov    %rbx,(%r15)
}
  800665:	48 83 c4 08          	add    $0x8,%rsp
  800669:	5b                   	pop    %rbx
  80066a:	41 5c                	pop    %r12
  80066c:	41 5d                	pop    %r13
  80066e:	41 5e                	pop    %r14
  800670:	41 5f                	pop    %r15
  800672:	5d                   	pop    %rbp
  800673:	c3                   	ret    

0000000000800674 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  800674:	83 ff 1f             	cmp    $0x1f,%edi
  800677:	77 39                	ja     8006b2 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  800679:	55                   	push   %rbp
  80067a:	48 89 e5             	mov    %rsp,%rbp
  80067d:	41 54                	push   %r12
  80067f:	53                   	push   %rbx
  800680:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  800683:	48 63 df             	movslq %edi,%rbx
  800686:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80068d:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800691:	48 89 df             	mov    %rbx,%rdi
  800694:	48 b8 c2 15 80 00 00 	movabs $0x8015c2,%rax
  80069b:	00 00 00 
  80069e:	ff d0                	call   *%rax
  8006a0:	a8 04                	test   $0x4,%al
  8006a2:	74 14                	je     8006b8 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8006a4:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8006a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006ad:	5b                   	pop    %rbx
  8006ae:	41 5c                	pop    %r12
  8006b0:	5d                   	pop    %rbp
  8006b1:	c3                   	ret    
        return -E_INVAL;
  8006b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006b7:	c3                   	ret    
        return -E_INVAL;
  8006b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006bd:	eb ee                	jmp    8006ad <fd_lookup+0x39>

00000000008006bf <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8006bf:	55                   	push   %rbp
  8006c0:	48 89 e5             	mov    %rsp,%rbp
  8006c3:	53                   	push   %rbx
  8006c4:	48 83 ec 08          	sub    $0x8,%rsp
  8006c8:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8006cb:	48 ba 80 2a 80 00 00 	movabs $0x802a80,%rdx
  8006d2:	00 00 00 
  8006d5:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8006dc:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8006df:	39 38                	cmp    %edi,(%rax)
  8006e1:	74 4b                	je     80072e <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8006e3:	48 83 c2 08          	add    $0x8,%rdx
  8006e7:	48 8b 02             	mov    (%rdx),%rax
  8006ea:	48 85 c0             	test   %rax,%rax
  8006ed:	75 f0                	jne    8006df <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8006ef:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8006f6:	00 00 00 
  8006f9:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8006ff:	89 fa                	mov    %edi,%edx
  800701:	48 bf e8 29 80 00 00 	movabs $0x8029e8,%rdi
  800708:	00 00 00 
  80070b:	b8 00 00 00 00       	mov    $0x0,%eax
  800710:	48 b9 94 1a 80 00 00 	movabs $0x801a94,%rcx
  800717:	00 00 00 
  80071a:	ff d1                	call   *%rcx
    *dev = 0;
  80071c:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  800723:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800728:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80072c:	c9                   	leave  
  80072d:	c3                   	ret    
            *dev = devtab[i];
  80072e:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  800731:	b8 00 00 00 00       	mov    $0x0,%eax
  800736:	eb f0                	jmp    800728 <dev_lookup+0x69>

0000000000800738 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  800738:	55                   	push   %rbp
  800739:	48 89 e5             	mov    %rsp,%rbp
  80073c:	41 55                	push   %r13
  80073e:	41 54                	push   %r12
  800740:	53                   	push   %rbx
  800741:	48 83 ec 18          	sub    $0x18,%rsp
  800745:	49 89 fc             	mov    %rdi,%r12
  800748:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80074b:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  800752:	ff ff ff 
  800755:	4c 01 e7             	add    %r12,%rdi
  800758:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80075c:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800760:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  800767:	00 00 00 
  80076a:	ff d0                	call   *%rax
  80076c:	89 c3                	mov    %eax,%ebx
  80076e:	85 c0                	test   %eax,%eax
  800770:	78 06                	js     800778 <fd_close+0x40>
  800772:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  800776:	74 18                	je     800790 <fd_close+0x58>
        return (must_exist ? res : 0);
  800778:	45 84 ed             	test   %r13b,%r13b
  80077b:	b8 00 00 00 00       	mov    $0x0,%eax
  800780:	0f 44 d8             	cmove  %eax,%ebx
}
  800783:	89 d8                	mov    %ebx,%eax
  800785:	48 83 c4 18          	add    $0x18,%rsp
  800789:	5b                   	pop    %rbx
  80078a:	41 5c                	pop    %r12
  80078c:	41 5d                	pop    %r13
  80078e:	5d                   	pop    %rbp
  80078f:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800790:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800794:	41 8b 3c 24          	mov    (%r12),%edi
  800798:	48 b8 bf 06 80 00 00 	movabs $0x8006bf,%rax
  80079f:	00 00 00 
  8007a2:	ff d0                	call   *%rax
  8007a4:	89 c3                	mov    %eax,%ebx
  8007a6:	85 c0                	test   %eax,%eax
  8007a8:	78 19                	js     8007c3 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8007aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8007ae:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007b7:	48 85 c0             	test   %rax,%rax
  8007ba:	74 07                	je     8007c3 <fd_close+0x8b>
  8007bc:	4c 89 e7             	mov    %r12,%rdi
  8007bf:	ff d0                	call   *%rax
  8007c1:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8007c3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8007c8:	4c 89 e6             	mov    %r12,%rsi
  8007cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8007d0:	48 b8 4d 03 80 00 00 	movabs $0x80034d,%rax
  8007d7:	00 00 00 
  8007da:	ff d0                	call   *%rax
    return res;
  8007dc:	eb a5                	jmp    800783 <fd_close+0x4b>

00000000008007de <close>:

int
close(int fdnum) {
  8007de:	55                   	push   %rbp
  8007df:	48 89 e5             	mov    %rsp,%rbp
  8007e2:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8007e6:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8007ea:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  8007f1:	00 00 00 
  8007f4:	ff d0                	call   *%rax
    if (res < 0) return res;
  8007f6:	85 c0                	test   %eax,%eax
  8007f8:	78 15                	js     80080f <close+0x31>

    return fd_close(fd, 1);
  8007fa:	be 01 00 00 00       	mov    $0x1,%esi
  8007ff:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800803:	48 b8 38 07 80 00 00 	movabs $0x800738,%rax
  80080a:	00 00 00 
  80080d:	ff d0                	call   *%rax
}
  80080f:	c9                   	leave  
  800810:	c3                   	ret    

0000000000800811 <close_all>:

void
close_all(void) {
  800811:	55                   	push   %rbp
  800812:	48 89 e5             	mov    %rsp,%rbp
  800815:	41 54                	push   %r12
  800817:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  800818:	bb 00 00 00 00       	mov    $0x0,%ebx
  80081d:	49 bc de 07 80 00 00 	movabs $0x8007de,%r12
  800824:	00 00 00 
  800827:	89 df                	mov    %ebx,%edi
  800829:	41 ff d4             	call   *%r12
  80082c:	83 c3 01             	add    $0x1,%ebx
  80082f:	83 fb 20             	cmp    $0x20,%ebx
  800832:	75 f3                	jne    800827 <close_all+0x16>
}
  800834:	5b                   	pop    %rbx
  800835:	41 5c                	pop    %r12
  800837:	5d                   	pop    %rbp
  800838:	c3                   	ret    

0000000000800839 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  800839:	55                   	push   %rbp
  80083a:	48 89 e5             	mov    %rsp,%rbp
  80083d:	41 56                	push   %r14
  80083f:	41 55                	push   %r13
  800841:	41 54                	push   %r12
  800843:	53                   	push   %rbx
  800844:	48 83 ec 10          	sub    $0x10,%rsp
  800848:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80084b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80084f:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  800856:	00 00 00 
  800859:	ff d0                	call   *%rax
  80085b:	89 c3                	mov    %eax,%ebx
  80085d:	85 c0                	test   %eax,%eax
  80085f:	0f 88 b7 00 00 00    	js     80091c <dup+0xe3>
    close(newfdnum);
  800865:	44 89 e7             	mov    %r12d,%edi
  800868:	48 b8 de 07 80 00 00 	movabs $0x8007de,%rax
  80086f:	00 00 00 
  800872:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800874:	4d 63 ec             	movslq %r12d,%r13
  800877:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80087e:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  800882:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800886:	49 be f8 05 80 00 00 	movabs $0x8005f8,%r14
  80088d:	00 00 00 
  800890:	41 ff d6             	call   *%r14
  800893:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  800896:	4c 89 ef             	mov    %r13,%rdi
  800899:	41 ff d6             	call   *%r14
  80089c:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  80089f:	48 89 df             	mov    %rbx,%rdi
  8008a2:	48 b8 c2 15 80 00 00 	movabs $0x8015c2,%rax
  8008a9:	00 00 00 
  8008ac:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8008ae:	a8 04                	test   $0x4,%al
  8008b0:	74 2b                	je     8008dd <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8008b2:	41 89 c1             	mov    %eax,%r9d
  8008b5:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8008bb:	4c 89 f1             	mov    %r14,%rcx
  8008be:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c3:	48 89 de             	mov    %rbx,%rsi
  8008c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8008cb:	48 b8 e8 02 80 00 00 	movabs $0x8002e8,%rax
  8008d2:	00 00 00 
  8008d5:	ff d0                	call   *%rax
  8008d7:	89 c3                	mov    %eax,%ebx
  8008d9:	85 c0                	test   %eax,%eax
  8008db:	78 4e                	js     80092b <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8008dd:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8008e1:	48 b8 c2 15 80 00 00 	movabs $0x8015c2,%rax
  8008e8:	00 00 00 
  8008eb:	ff d0                	call   *%rax
  8008ed:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8008f0:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8008f6:	4c 89 e9             	mov    %r13,%rcx
  8008f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fe:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800902:	bf 00 00 00 00       	mov    $0x0,%edi
  800907:	48 b8 e8 02 80 00 00 	movabs $0x8002e8,%rax
  80090e:	00 00 00 
  800911:	ff d0                	call   *%rax
  800913:	89 c3                	mov    %eax,%ebx
  800915:	85 c0                	test   %eax,%eax
  800917:	78 12                	js     80092b <dup+0xf2>

    return newfdnum;
  800919:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80091c:	89 d8                	mov    %ebx,%eax
  80091e:	48 83 c4 10          	add    $0x10,%rsp
  800922:	5b                   	pop    %rbx
  800923:	41 5c                	pop    %r12
  800925:	41 5d                	pop    %r13
  800927:	41 5e                	pop    %r14
  800929:	5d                   	pop    %rbp
  80092a:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80092b:	ba 00 10 00 00       	mov    $0x1000,%edx
  800930:	4c 89 ee             	mov    %r13,%rsi
  800933:	bf 00 00 00 00       	mov    $0x0,%edi
  800938:	49 bc 4d 03 80 00 00 	movabs $0x80034d,%r12
  80093f:	00 00 00 
  800942:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  800945:	ba 00 10 00 00       	mov    $0x1000,%edx
  80094a:	4c 89 f6             	mov    %r14,%rsi
  80094d:	bf 00 00 00 00       	mov    $0x0,%edi
  800952:	41 ff d4             	call   *%r12
    return res;
  800955:	eb c5                	jmp    80091c <dup+0xe3>

0000000000800957 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800957:	55                   	push   %rbp
  800958:	48 89 e5             	mov    %rsp,%rbp
  80095b:	41 55                	push   %r13
  80095d:	41 54                	push   %r12
  80095f:	53                   	push   %rbx
  800960:	48 83 ec 18          	sub    $0x18,%rsp
  800964:	89 fb                	mov    %edi,%ebx
  800966:	49 89 f4             	mov    %rsi,%r12
  800969:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80096c:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800970:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  800977:	00 00 00 
  80097a:	ff d0                	call   *%rax
  80097c:	85 c0                	test   %eax,%eax
  80097e:	78 49                	js     8009c9 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800980:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800984:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800988:	8b 38                	mov    (%rax),%edi
  80098a:	48 b8 bf 06 80 00 00 	movabs $0x8006bf,%rax
  800991:	00 00 00 
  800994:	ff d0                	call   *%rax
  800996:	85 c0                	test   %eax,%eax
  800998:	78 33                	js     8009cd <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80099a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80099e:	8b 47 08             	mov    0x8(%rdi),%eax
  8009a1:	83 e0 03             	and    $0x3,%eax
  8009a4:	83 f8 01             	cmp    $0x1,%eax
  8009a7:	74 28                	je     8009d1 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8009a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009ad:	48 8b 40 10          	mov    0x10(%rax),%rax
  8009b1:	48 85 c0             	test   %rax,%rax
  8009b4:	74 51                	je     800a07 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8009b6:	4c 89 ea             	mov    %r13,%rdx
  8009b9:	4c 89 e6             	mov    %r12,%rsi
  8009bc:	ff d0                	call   *%rax
}
  8009be:	48 83 c4 18          	add    $0x18,%rsp
  8009c2:	5b                   	pop    %rbx
  8009c3:	41 5c                	pop    %r12
  8009c5:	41 5d                	pop    %r13
  8009c7:	5d                   	pop    %rbp
  8009c8:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8009c9:	48 98                	cltq   
  8009cb:	eb f1                	jmp    8009be <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8009cd:	48 98                	cltq   
  8009cf:	eb ed                	jmp    8009be <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8009d1:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8009d8:	00 00 00 
  8009db:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8009e1:	89 da                	mov    %ebx,%edx
  8009e3:	48 bf 29 2a 80 00 00 	movabs $0x802a29,%rdi
  8009ea:	00 00 00 
  8009ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f2:	48 b9 94 1a 80 00 00 	movabs $0x801a94,%rcx
  8009f9:	00 00 00 
  8009fc:	ff d1                	call   *%rcx
        return -E_INVAL;
  8009fe:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800a05:	eb b7                	jmp    8009be <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800a07:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800a0e:	eb ae                	jmp    8009be <read+0x67>

0000000000800a10 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800a10:	55                   	push   %rbp
  800a11:	48 89 e5             	mov    %rsp,%rbp
  800a14:	41 57                	push   %r15
  800a16:	41 56                	push   %r14
  800a18:	41 55                	push   %r13
  800a1a:	41 54                	push   %r12
  800a1c:	53                   	push   %rbx
  800a1d:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800a21:	48 85 d2             	test   %rdx,%rdx
  800a24:	74 54                	je     800a7a <readn+0x6a>
  800a26:	41 89 fd             	mov    %edi,%r13d
  800a29:	49 89 f6             	mov    %rsi,%r14
  800a2c:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800a2f:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800a34:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800a39:	49 bf 57 09 80 00 00 	movabs $0x800957,%r15
  800a40:	00 00 00 
  800a43:	4c 89 e2             	mov    %r12,%rdx
  800a46:	48 29 f2             	sub    %rsi,%rdx
  800a49:	4c 01 f6             	add    %r14,%rsi
  800a4c:	44 89 ef             	mov    %r13d,%edi
  800a4f:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800a52:	85 c0                	test   %eax,%eax
  800a54:	78 20                	js     800a76 <readn+0x66>
    for (; inc && res < n; res += inc) {
  800a56:	01 c3                	add    %eax,%ebx
  800a58:	85 c0                	test   %eax,%eax
  800a5a:	74 08                	je     800a64 <readn+0x54>
  800a5c:	48 63 f3             	movslq %ebx,%rsi
  800a5f:	4c 39 e6             	cmp    %r12,%rsi
  800a62:	72 df                	jb     800a43 <readn+0x33>
    }
    return res;
  800a64:	48 63 c3             	movslq %ebx,%rax
}
  800a67:	48 83 c4 08          	add    $0x8,%rsp
  800a6b:	5b                   	pop    %rbx
  800a6c:	41 5c                	pop    %r12
  800a6e:	41 5d                	pop    %r13
  800a70:	41 5e                	pop    %r14
  800a72:	41 5f                	pop    %r15
  800a74:	5d                   	pop    %rbp
  800a75:	c3                   	ret    
        if (inc < 0) return inc;
  800a76:	48 98                	cltq   
  800a78:	eb ed                	jmp    800a67 <readn+0x57>
    int inc = 1, res = 0;
  800a7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a7f:	eb e3                	jmp    800a64 <readn+0x54>

0000000000800a81 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800a81:	55                   	push   %rbp
  800a82:	48 89 e5             	mov    %rsp,%rbp
  800a85:	41 55                	push   %r13
  800a87:	41 54                	push   %r12
  800a89:	53                   	push   %rbx
  800a8a:	48 83 ec 18          	sub    $0x18,%rsp
  800a8e:	89 fb                	mov    %edi,%ebx
  800a90:	49 89 f4             	mov    %rsi,%r12
  800a93:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a96:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a9a:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  800aa1:	00 00 00 
  800aa4:	ff d0                	call   *%rax
  800aa6:	85 c0                	test   %eax,%eax
  800aa8:	78 44                	js     800aee <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800aaa:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800aae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ab2:	8b 38                	mov    (%rax),%edi
  800ab4:	48 b8 bf 06 80 00 00 	movabs $0x8006bf,%rax
  800abb:	00 00 00 
  800abe:	ff d0                	call   *%rax
  800ac0:	85 c0                	test   %eax,%eax
  800ac2:	78 2e                	js     800af2 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ac4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ac8:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800acc:	74 28                	je     800af6 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800ace:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ad2:	48 8b 40 18          	mov    0x18(%rax),%rax
  800ad6:	48 85 c0             	test   %rax,%rax
  800ad9:	74 51                	je     800b2c <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  800adb:	4c 89 ea             	mov    %r13,%rdx
  800ade:	4c 89 e6             	mov    %r12,%rsi
  800ae1:	ff d0                	call   *%rax
}
  800ae3:	48 83 c4 18          	add    $0x18,%rsp
  800ae7:	5b                   	pop    %rbx
  800ae8:	41 5c                	pop    %r12
  800aea:	41 5d                	pop    %r13
  800aec:	5d                   	pop    %rbp
  800aed:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800aee:	48 98                	cltq   
  800af0:	eb f1                	jmp    800ae3 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800af2:	48 98                	cltq   
  800af4:	eb ed                	jmp    800ae3 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800af6:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800afd:	00 00 00 
  800b00:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800b06:	89 da                	mov    %ebx,%edx
  800b08:	48 bf 45 2a 80 00 00 	movabs $0x802a45,%rdi
  800b0f:	00 00 00 
  800b12:	b8 00 00 00 00       	mov    $0x0,%eax
  800b17:	48 b9 94 1a 80 00 00 	movabs $0x801a94,%rcx
  800b1e:	00 00 00 
  800b21:	ff d1                	call   *%rcx
        return -E_INVAL;
  800b23:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800b2a:	eb b7                	jmp    800ae3 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800b2c:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800b33:	eb ae                	jmp    800ae3 <write+0x62>

0000000000800b35 <seek>:

int
seek(int fdnum, off_t offset) {
  800b35:	55                   	push   %rbp
  800b36:	48 89 e5             	mov    %rsp,%rbp
  800b39:	53                   	push   %rbx
  800b3a:	48 83 ec 18          	sub    $0x18,%rsp
  800b3e:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b40:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b44:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  800b4b:	00 00 00 
  800b4e:	ff d0                	call   *%rax
  800b50:	85 c0                	test   %eax,%eax
  800b52:	78 0c                	js     800b60 <seek+0x2b>

    fd->fd_offset = offset;
  800b54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b58:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b60:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

0000000000800b66 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800b66:	55                   	push   %rbp
  800b67:	48 89 e5             	mov    %rsp,%rbp
  800b6a:	41 54                	push   %r12
  800b6c:	53                   	push   %rbx
  800b6d:	48 83 ec 10          	sub    $0x10,%rsp
  800b71:	89 fb                	mov    %edi,%ebx
  800b73:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b76:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b7a:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  800b81:	00 00 00 
  800b84:	ff d0                	call   *%rax
  800b86:	85 c0                	test   %eax,%eax
  800b88:	78 36                	js     800bc0 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b8a:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800b8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b92:	8b 38                	mov    (%rax),%edi
  800b94:	48 b8 bf 06 80 00 00 	movabs $0x8006bf,%rax
  800b9b:	00 00 00 
  800b9e:	ff d0                	call   *%rax
  800ba0:	85 c0                	test   %eax,%eax
  800ba2:	78 1c                	js     800bc0 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ba4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800ba8:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800bac:	74 1b                	je     800bc9 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800bae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800bb2:	48 8b 40 30          	mov    0x30(%rax),%rax
  800bb6:	48 85 c0             	test   %rax,%rax
  800bb9:	74 42                	je     800bfd <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  800bbb:	44 89 e6             	mov    %r12d,%esi
  800bbe:	ff d0                	call   *%rax
}
  800bc0:	48 83 c4 10          	add    $0x10,%rsp
  800bc4:	5b                   	pop    %rbx
  800bc5:	41 5c                	pop    %r12
  800bc7:	5d                   	pop    %rbp
  800bc8:	c3                   	ret    
                thisenv->env_id, fdnum);
  800bc9:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bd0:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800bd3:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800bd9:	89 da                	mov    %ebx,%edx
  800bdb:	48 bf 08 2a 80 00 00 	movabs $0x802a08,%rdi
  800be2:	00 00 00 
  800be5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bea:	48 b9 94 1a 80 00 00 	movabs $0x801a94,%rcx
  800bf1:	00 00 00 
  800bf4:	ff d1                	call   *%rcx
        return -E_INVAL;
  800bf6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bfb:	eb c3                	jmp    800bc0 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800bfd:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c02:	eb bc                	jmp    800bc0 <ftruncate+0x5a>

0000000000800c04 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800c04:	55                   	push   %rbp
  800c05:	48 89 e5             	mov    %rsp,%rbp
  800c08:	53                   	push   %rbx
  800c09:	48 83 ec 18          	sub    $0x18,%rsp
  800c0d:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c10:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c14:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  800c1b:	00 00 00 
  800c1e:	ff d0                	call   *%rax
  800c20:	85 c0                	test   %eax,%eax
  800c22:	78 4d                	js     800c71 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c24:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800c28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2c:	8b 38                	mov    (%rax),%edi
  800c2e:	48 b8 bf 06 80 00 00 	movabs $0x8006bf,%rax
  800c35:	00 00 00 
  800c38:	ff d0                	call   *%rax
  800c3a:	85 c0                	test   %eax,%eax
  800c3c:	78 33                	js     800c71 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c42:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800c47:	74 2e                	je     800c77 <fstat+0x73>

    stat->st_name[0] = 0;
  800c49:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800c4c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800c53:	00 00 00 
    stat->st_isdir = 0;
  800c56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800c5d:	00 00 00 
    stat->st_dev = dev;
  800c60:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800c67:	48 89 de             	mov    %rbx,%rsi
  800c6a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c6e:	ff 50 28             	call   *0x28(%rax)
}
  800c71:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c77:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c7c:	eb f3                	jmp    800c71 <fstat+0x6d>

0000000000800c7e <stat>:

int
stat(const char *path, struct Stat *stat) {
  800c7e:	55                   	push   %rbp
  800c7f:	48 89 e5             	mov    %rsp,%rbp
  800c82:	41 54                	push   %r12
  800c84:	53                   	push   %rbx
  800c85:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800c88:	be 00 00 00 00       	mov    $0x0,%esi
  800c8d:	48 b8 49 0f 80 00 00 	movabs $0x800f49,%rax
  800c94:	00 00 00 
  800c97:	ff d0                	call   *%rax
  800c99:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	78 25                	js     800cc4 <stat+0x46>

    int res = fstat(fd, stat);
  800c9f:	4c 89 e6             	mov    %r12,%rsi
  800ca2:	89 c7                	mov    %eax,%edi
  800ca4:	48 b8 04 0c 80 00 00 	movabs $0x800c04,%rax
  800cab:	00 00 00 
  800cae:	ff d0                	call   *%rax
  800cb0:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800cb3:	89 df                	mov    %ebx,%edi
  800cb5:	48 b8 de 07 80 00 00 	movabs $0x8007de,%rax
  800cbc:	00 00 00 
  800cbf:	ff d0                	call   *%rax

    return res;
  800cc1:	44 89 e3             	mov    %r12d,%ebx
}
  800cc4:	89 d8                	mov    %ebx,%eax
  800cc6:	5b                   	pop    %rbx
  800cc7:	41 5c                	pop    %r12
  800cc9:	5d                   	pop    %rbp
  800cca:	c3                   	ret    

0000000000800ccb <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800ccb:	55                   	push   %rbp
  800ccc:	48 89 e5             	mov    %rsp,%rbp
  800ccf:	41 54                	push   %r12
  800cd1:	53                   	push   %rbx
  800cd2:	48 83 ec 10          	sub    $0x10,%rsp
  800cd6:	41 89 fc             	mov    %edi,%r12d
  800cd9:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800cdc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800ce3:	00 00 00 
  800ce6:	83 38 00             	cmpl   $0x0,(%rax)
  800ce9:	74 5e                	je     800d49 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800ceb:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800cf1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800cf6:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800cfd:	00 00 00 
  800d00:	44 89 e6             	mov    %r12d,%esi
  800d03:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d0a:	00 00 00 
  800d0d:	8b 38                	mov    (%rax),%edi
  800d0f:	48 b8 a5 28 80 00 00 	movabs $0x8028a5,%rax
  800d16:	00 00 00 
  800d19:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800d1b:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800d22:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800d23:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d28:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d2c:	48 89 de             	mov    %rbx,%rsi
  800d2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d34:	48 b8 06 28 80 00 00 	movabs $0x802806,%rax
  800d3b:	00 00 00 
  800d3e:	ff d0                	call   *%rax
}
  800d40:	48 83 c4 10          	add    $0x10,%rsp
  800d44:	5b                   	pop    %rbx
  800d45:	41 5c                	pop    %r12
  800d47:	5d                   	pop    %rbp
  800d48:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800d49:	bf 03 00 00 00       	mov    $0x3,%edi
  800d4e:	48 b8 48 29 80 00 00 	movabs $0x802948,%rax
  800d55:	00 00 00 
  800d58:	ff d0                	call   *%rax
  800d5a:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800d61:	00 00 
  800d63:	eb 86                	jmp    800ceb <fsipc+0x20>

0000000000800d65 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800d65:	55                   	push   %rbp
  800d66:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d69:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800d70:	00 00 00 
  800d73:	8b 57 0c             	mov    0xc(%rdi),%edx
  800d76:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800d78:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800d7b:	be 00 00 00 00       	mov    $0x0,%esi
  800d80:	bf 02 00 00 00       	mov    $0x2,%edi
  800d85:	48 b8 cb 0c 80 00 00 	movabs $0x800ccb,%rax
  800d8c:	00 00 00 
  800d8f:	ff d0                	call   *%rax
}
  800d91:	5d                   	pop    %rbp
  800d92:	c3                   	ret    

0000000000800d93 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800d93:	55                   	push   %rbp
  800d94:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800d97:	8b 47 0c             	mov    0xc(%rdi),%eax
  800d9a:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800da1:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800da3:	be 00 00 00 00       	mov    $0x0,%esi
  800da8:	bf 06 00 00 00       	mov    $0x6,%edi
  800dad:	48 b8 cb 0c 80 00 00 	movabs $0x800ccb,%rax
  800db4:	00 00 00 
  800db7:	ff d0                	call   *%rax
}
  800db9:	5d                   	pop    %rbp
  800dba:	c3                   	ret    

0000000000800dbb <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800dbb:	55                   	push   %rbp
  800dbc:	48 89 e5             	mov    %rsp,%rbp
  800dbf:	53                   	push   %rbx
  800dc0:	48 83 ec 08          	sub    $0x8,%rsp
  800dc4:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800dc7:	8b 47 0c             	mov    0xc(%rdi),%eax
  800dca:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800dd1:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800dd3:	be 00 00 00 00       	mov    $0x0,%esi
  800dd8:	bf 05 00 00 00       	mov    $0x5,%edi
  800ddd:	48 b8 cb 0c 80 00 00 	movabs $0x800ccb,%rax
  800de4:	00 00 00 
  800de7:	ff d0                	call   *%rax
    if (res < 0) return res;
  800de9:	85 c0                	test   %eax,%eax
  800deb:	78 40                	js     800e2d <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800ded:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800df4:	00 00 00 
  800df7:	48 89 df             	mov    %rbx,%rdi
  800dfa:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  800e01:	00 00 00 
  800e04:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800e06:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e0d:	00 00 00 
  800e10:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  800e16:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e1c:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  800e22:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800e31:	c9                   	leave  
  800e32:	c3                   	ret    

0000000000800e33 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800e33:	55                   	push   %rbp
  800e34:	48 89 e5             	mov    %rsp,%rbp
  800e37:	41 57                	push   %r15
  800e39:	41 56                	push   %r14
  800e3b:	41 55                	push   %r13
  800e3d:	41 54                	push   %r12
  800e3f:	53                   	push   %rbx
  800e40:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  800e44:	48 85 d2             	test   %rdx,%rdx
  800e47:	0f 84 91 00 00 00    	je     800ede <devfile_write+0xab>
  800e4d:	49 89 ff             	mov    %rdi,%r15
  800e50:	49 89 f4             	mov    %rsi,%r12
  800e53:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  800e56:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e5d:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  800e64:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  800e67:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  800e6e:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  800e74:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  800e78:	4c 89 ea             	mov    %r13,%rdx
  800e7b:	4c 89 e6             	mov    %r12,%rsi
  800e7e:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  800e85:	00 00 00 
  800e88:	48 b8 35 26 80 00 00 	movabs $0x802635,%rax
  800e8f:	00 00 00 
  800e92:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e94:	41 8b 47 0c          	mov    0xc(%r15),%eax
  800e98:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  800e9b:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  800e9f:	be 00 00 00 00       	mov    $0x0,%esi
  800ea4:	bf 04 00 00 00       	mov    $0x4,%edi
  800ea9:	48 b8 cb 0c 80 00 00 	movabs $0x800ccb,%rax
  800eb0:	00 00 00 
  800eb3:	ff d0                	call   *%rax
        if (res < 0)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	78 21                	js     800eda <devfile_write+0xa7>
        buf += res;
  800eb9:	48 63 d0             	movslq %eax,%rdx
  800ebc:	49 01 d4             	add    %rdx,%r12
        ext += res;
  800ebf:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  800ec2:	48 29 d3             	sub    %rdx,%rbx
  800ec5:	75 a0                	jne    800e67 <devfile_write+0x34>
    return ext;
  800ec7:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  800ecb:	48 83 c4 18          	add    $0x18,%rsp
  800ecf:	5b                   	pop    %rbx
  800ed0:	41 5c                	pop    %r12
  800ed2:	41 5d                	pop    %r13
  800ed4:	41 5e                	pop    %r14
  800ed6:	41 5f                	pop    %r15
  800ed8:	5d                   	pop    %rbp
  800ed9:	c3                   	ret    
            return res;
  800eda:	48 98                	cltq   
  800edc:	eb ed                	jmp    800ecb <devfile_write+0x98>
    int ext = 0;
  800ede:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  800ee5:	eb e0                	jmp    800ec7 <devfile_write+0x94>

0000000000800ee7 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800ee7:	55                   	push   %rbp
  800ee8:	48 89 e5             	mov    %rsp,%rbp
  800eeb:	41 54                	push   %r12
  800eed:	53                   	push   %rbx
  800eee:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ef1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ef8:	00 00 00 
  800efb:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800efe:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  800f00:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  800f04:	be 00 00 00 00       	mov    $0x0,%esi
  800f09:	bf 03 00 00 00       	mov    $0x3,%edi
  800f0e:	48 b8 cb 0c 80 00 00 	movabs $0x800ccb,%rax
  800f15:	00 00 00 
  800f18:	ff d0                	call   *%rax
    if (read < 0) 
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	78 27                	js     800f45 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  800f1e:	48 63 d8             	movslq %eax,%rbx
  800f21:	48 89 da             	mov    %rbx,%rdx
  800f24:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800f2b:	00 00 00 
  800f2e:	4c 89 e7             	mov    %r12,%rdi
  800f31:	48 b8 d0 25 80 00 00 	movabs $0x8025d0,%rax
  800f38:	00 00 00 
  800f3b:	ff d0                	call   *%rax
    return read;
  800f3d:	48 89 d8             	mov    %rbx,%rax
}
  800f40:	5b                   	pop    %rbx
  800f41:	41 5c                	pop    %r12
  800f43:	5d                   	pop    %rbp
  800f44:	c3                   	ret    
		return read;
  800f45:	48 98                	cltq   
  800f47:	eb f7                	jmp    800f40 <devfile_read+0x59>

0000000000800f49 <open>:
open(const char *path, int mode) {
  800f49:	55                   	push   %rbp
  800f4a:	48 89 e5             	mov    %rsp,%rbp
  800f4d:	41 55                	push   %r13
  800f4f:	41 54                	push   %r12
  800f51:	53                   	push   %rbx
  800f52:	48 83 ec 18          	sub    $0x18,%rsp
  800f56:	49 89 fc             	mov    %rdi,%r12
  800f59:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  800f5c:	48 b8 9c 23 80 00 00 	movabs $0x80239c,%rax
  800f63:	00 00 00 
  800f66:	ff d0                	call   *%rax
  800f68:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  800f6e:	0f 87 8c 00 00 00    	ja     801000 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  800f74:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  800f78:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  800f7f:	00 00 00 
  800f82:	ff d0                	call   *%rax
  800f84:	89 c3                	mov    %eax,%ebx
  800f86:	85 c0                	test   %eax,%eax
  800f88:	78 52                	js     800fdc <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  800f8a:	4c 89 e6             	mov    %r12,%rsi
  800f8d:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  800f94:	00 00 00 
  800f97:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  800f9e:	00 00 00 
  800fa1:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  800fa3:	44 89 e8             	mov    %r13d,%eax
  800fa6:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  800fad:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  800faf:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800fb3:	bf 01 00 00 00       	mov    $0x1,%edi
  800fb8:	48 b8 cb 0c 80 00 00 	movabs $0x800ccb,%rax
  800fbf:	00 00 00 
  800fc2:	ff d0                	call   *%rax
  800fc4:	89 c3                	mov    %eax,%ebx
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	78 1f                	js     800fe9 <open+0xa0>
    return fd2num(fd);
  800fca:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800fce:	48 b8 e6 05 80 00 00 	movabs $0x8005e6,%rax
  800fd5:	00 00 00 
  800fd8:	ff d0                	call   *%rax
  800fda:	89 c3                	mov    %eax,%ebx
}
  800fdc:	89 d8                	mov    %ebx,%eax
  800fde:	48 83 c4 18          	add    $0x18,%rsp
  800fe2:	5b                   	pop    %rbx
  800fe3:	41 5c                	pop    %r12
  800fe5:	41 5d                	pop    %r13
  800fe7:	5d                   	pop    %rbp
  800fe8:	c3                   	ret    
        fd_close(fd, 0);
  800fe9:	be 00 00 00 00       	mov    $0x0,%esi
  800fee:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ff2:	48 b8 38 07 80 00 00 	movabs $0x800738,%rax
  800ff9:	00 00 00 
  800ffc:	ff d0                	call   *%rax
        return res;
  800ffe:	eb dc                	jmp    800fdc <open+0x93>
        return -E_BAD_PATH;
  801000:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801005:	eb d5                	jmp    800fdc <open+0x93>

0000000000801007 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801007:	55                   	push   %rbp
  801008:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80100b:	be 00 00 00 00       	mov    $0x0,%esi
  801010:	bf 08 00 00 00       	mov    $0x8,%edi
  801015:	48 b8 cb 0c 80 00 00 	movabs $0x800ccb,%rax
  80101c:	00 00 00 
  80101f:	ff d0                	call   *%rax
}
  801021:	5d                   	pop    %rbp
  801022:	c3                   	ret    

0000000000801023 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801023:	55                   	push   %rbp
  801024:	48 89 e5             	mov    %rsp,%rbp
  801027:	41 54                	push   %r12
  801029:	53                   	push   %rbx
  80102a:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80102d:	48 b8 f8 05 80 00 00 	movabs $0x8005f8,%rax
  801034:	00 00 00 
  801037:	ff d0                	call   *%rax
  801039:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80103c:	48 be a0 2a 80 00 00 	movabs $0x802aa0,%rsi
  801043:	00 00 00 
  801046:	48 89 df             	mov    %rbx,%rdi
  801049:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  801050:	00 00 00 
  801053:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801055:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80105a:	41 2b 04 24          	sub    (%r12),%eax
  80105e:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801064:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80106b:	00 00 00 
    stat->st_dev = &devpipe;
  80106e:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801075:	00 00 00 
  801078:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80107f:	b8 00 00 00 00       	mov    $0x0,%eax
  801084:	5b                   	pop    %rbx
  801085:	41 5c                	pop    %r12
  801087:	5d                   	pop    %rbp
  801088:	c3                   	ret    

0000000000801089 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801089:	55                   	push   %rbp
  80108a:	48 89 e5             	mov    %rsp,%rbp
  80108d:	41 54                	push   %r12
  80108f:	53                   	push   %rbx
  801090:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801093:	ba 00 10 00 00       	mov    $0x1000,%edx
  801098:	48 89 fe             	mov    %rdi,%rsi
  80109b:	bf 00 00 00 00       	mov    $0x0,%edi
  8010a0:	49 bc 4d 03 80 00 00 	movabs $0x80034d,%r12
  8010a7:	00 00 00 
  8010aa:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8010ad:	48 89 df             	mov    %rbx,%rdi
  8010b0:	48 b8 f8 05 80 00 00 	movabs $0x8005f8,%rax
  8010b7:	00 00 00 
  8010ba:	ff d0                	call   *%rax
  8010bc:	48 89 c6             	mov    %rax,%rsi
  8010bf:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8010c9:	41 ff d4             	call   *%r12
}
  8010cc:	5b                   	pop    %rbx
  8010cd:	41 5c                	pop    %r12
  8010cf:	5d                   	pop    %rbp
  8010d0:	c3                   	ret    

00000000008010d1 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8010d1:	55                   	push   %rbp
  8010d2:	48 89 e5             	mov    %rsp,%rbp
  8010d5:	41 57                	push   %r15
  8010d7:	41 56                	push   %r14
  8010d9:	41 55                	push   %r13
  8010db:	41 54                	push   %r12
  8010dd:	53                   	push   %rbx
  8010de:	48 83 ec 18          	sub    $0x18,%rsp
  8010e2:	49 89 fc             	mov    %rdi,%r12
  8010e5:	49 89 f5             	mov    %rsi,%r13
  8010e8:	49 89 d7             	mov    %rdx,%r15
  8010eb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8010ef:	48 b8 f8 05 80 00 00 	movabs $0x8005f8,%rax
  8010f6:	00 00 00 
  8010f9:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8010fb:	4d 85 ff             	test   %r15,%r15
  8010fe:	0f 84 ac 00 00 00    	je     8011b0 <devpipe_write+0xdf>
  801104:	48 89 c3             	mov    %rax,%rbx
  801107:	4c 89 f8             	mov    %r15,%rax
  80110a:	4d 89 ef             	mov    %r13,%r15
  80110d:	49 01 c5             	add    %rax,%r13
  801110:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801114:	49 bd 55 02 80 00 00 	movabs $0x800255,%r13
  80111b:	00 00 00 
            sys_yield();
  80111e:	49 be f2 01 80 00 00 	movabs $0x8001f2,%r14
  801125:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801128:	8b 73 04             	mov    0x4(%rbx),%esi
  80112b:	48 63 ce             	movslq %esi,%rcx
  80112e:	48 63 03             	movslq (%rbx),%rax
  801131:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801137:	48 39 c1             	cmp    %rax,%rcx
  80113a:	72 2e                	jb     80116a <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80113c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801141:	48 89 da             	mov    %rbx,%rdx
  801144:	be 00 10 00 00       	mov    $0x1000,%esi
  801149:	4c 89 e7             	mov    %r12,%rdi
  80114c:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80114f:	85 c0                	test   %eax,%eax
  801151:	74 63                	je     8011b6 <devpipe_write+0xe5>
            sys_yield();
  801153:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801156:	8b 73 04             	mov    0x4(%rbx),%esi
  801159:	48 63 ce             	movslq %esi,%rcx
  80115c:	48 63 03             	movslq (%rbx),%rax
  80115f:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801165:	48 39 c1             	cmp    %rax,%rcx
  801168:	73 d2                	jae    80113c <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80116a:	41 0f b6 3f          	movzbl (%r15),%edi
  80116e:	48 89 ca             	mov    %rcx,%rdx
  801171:	48 c1 ea 03          	shr    $0x3,%rdx
  801175:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80117c:	08 10 20 
  80117f:	48 f7 e2             	mul    %rdx
  801182:	48 c1 ea 06          	shr    $0x6,%rdx
  801186:	48 89 d0             	mov    %rdx,%rax
  801189:	48 c1 e0 09          	shl    $0x9,%rax
  80118d:	48 29 d0             	sub    %rdx,%rax
  801190:	48 c1 e0 03          	shl    $0x3,%rax
  801194:	48 29 c1             	sub    %rax,%rcx
  801197:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80119c:	83 c6 01             	add    $0x1,%esi
  80119f:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8011a2:	49 83 c7 01          	add    $0x1,%r15
  8011a6:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8011aa:	0f 85 78 ff ff ff    	jne    801128 <devpipe_write+0x57>
    return n;
  8011b0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8011b4:	eb 05                	jmp    8011bb <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8011b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011bb:	48 83 c4 18          	add    $0x18,%rsp
  8011bf:	5b                   	pop    %rbx
  8011c0:	41 5c                	pop    %r12
  8011c2:	41 5d                	pop    %r13
  8011c4:	41 5e                	pop    %r14
  8011c6:	41 5f                	pop    %r15
  8011c8:	5d                   	pop    %rbp
  8011c9:	c3                   	ret    

00000000008011ca <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8011ca:	55                   	push   %rbp
  8011cb:	48 89 e5             	mov    %rsp,%rbp
  8011ce:	41 57                	push   %r15
  8011d0:	41 56                	push   %r14
  8011d2:	41 55                	push   %r13
  8011d4:	41 54                	push   %r12
  8011d6:	53                   	push   %rbx
  8011d7:	48 83 ec 18          	sub    $0x18,%rsp
  8011db:	49 89 fc             	mov    %rdi,%r12
  8011de:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8011e2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8011e6:	48 b8 f8 05 80 00 00 	movabs $0x8005f8,%rax
  8011ed:	00 00 00 
  8011f0:	ff d0                	call   *%rax
  8011f2:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8011f5:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8011fb:	49 bd 55 02 80 00 00 	movabs $0x800255,%r13
  801202:	00 00 00 
            sys_yield();
  801205:	49 be f2 01 80 00 00 	movabs $0x8001f2,%r14
  80120c:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80120f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801214:	74 7a                	je     801290 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801216:	8b 03                	mov    (%rbx),%eax
  801218:	3b 43 04             	cmp    0x4(%rbx),%eax
  80121b:	75 26                	jne    801243 <devpipe_read+0x79>
            if (i > 0) return i;
  80121d:	4d 85 ff             	test   %r15,%r15
  801220:	75 74                	jne    801296 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801222:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801227:	48 89 da             	mov    %rbx,%rdx
  80122a:	be 00 10 00 00       	mov    $0x1000,%esi
  80122f:	4c 89 e7             	mov    %r12,%rdi
  801232:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801235:	85 c0                	test   %eax,%eax
  801237:	74 6f                	je     8012a8 <devpipe_read+0xde>
            sys_yield();
  801239:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80123c:	8b 03                	mov    (%rbx),%eax
  80123e:	3b 43 04             	cmp    0x4(%rbx),%eax
  801241:	74 df                	je     801222 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801243:	48 63 c8             	movslq %eax,%rcx
  801246:	48 89 ca             	mov    %rcx,%rdx
  801249:	48 c1 ea 03          	shr    $0x3,%rdx
  80124d:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801254:	08 10 20 
  801257:	48 f7 e2             	mul    %rdx
  80125a:	48 c1 ea 06          	shr    $0x6,%rdx
  80125e:	48 89 d0             	mov    %rdx,%rax
  801261:	48 c1 e0 09          	shl    $0x9,%rax
  801265:	48 29 d0             	sub    %rdx,%rax
  801268:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80126f:	00 
  801270:	48 89 c8             	mov    %rcx,%rax
  801273:	48 29 d0             	sub    %rdx,%rax
  801276:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80127b:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80127f:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  801283:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  801286:	49 83 c7 01          	add    $0x1,%r15
  80128a:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80128e:	75 86                	jne    801216 <devpipe_read+0x4c>
    return n;
  801290:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801294:	eb 03                	jmp    801299 <devpipe_read+0xcf>
            if (i > 0) return i;
  801296:	4c 89 f8             	mov    %r15,%rax
}
  801299:	48 83 c4 18          	add    $0x18,%rsp
  80129d:	5b                   	pop    %rbx
  80129e:	41 5c                	pop    %r12
  8012a0:	41 5d                	pop    %r13
  8012a2:	41 5e                	pop    %r14
  8012a4:	41 5f                	pop    %r15
  8012a6:	5d                   	pop    %rbp
  8012a7:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8012a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ad:	eb ea                	jmp    801299 <devpipe_read+0xcf>

00000000008012af <pipe>:
pipe(int pfd[2]) {
  8012af:	55                   	push   %rbp
  8012b0:	48 89 e5             	mov    %rsp,%rbp
  8012b3:	41 55                	push   %r13
  8012b5:	41 54                	push   %r12
  8012b7:	53                   	push   %rbx
  8012b8:	48 83 ec 18          	sub    $0x18,%rsp
  8012bc:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8012bf:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8012c3:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  8012ca:	00 00 00 
  8012cd:	ff d0                	call   *%rax
  8012cf:	89 c3                	mov    %eax,%ebx
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	0f 88 a0 01 00 00    	js     801479 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8012d9:	b9 46 00 00 00       	mov    $0x46,%ecx
  8012de:	ba 00 10 00 00       	mov    $0x1000,%edx
  8012e3:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8012e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8012ec:	48 b8 81 02 80 00 00 	movabs $0x800281,%rax
  8012f3:	00 00 00 
  8012f6:	ff d0                	call   *%rax
  8012f8:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	0f 88 77 01 00 00    	js     801479 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801302:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  801306:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  80130d:	00 00 00 
  801310:	ff d0                	call   *%rax
  801312:	89 c3                	mov    %eax,%ebx
  801314:	85 c0                	test   %eax,%eax
  801316:	0f 88 43 01 00 00    	js     80145f <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80131c:	b9 46 00 00 00       	mov    $0x46,%ecx
  801321:	ba 00 10 00 00       	mov    $0x1000,%edx
  801326:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80132a:	bf 00 00 00 00       	mov    $0x0,%edi
  80132f:	48 b8 81 02 80 00 00 	movabs $0x800281,%rax
  801336:	00 00 00 
  801339:	ff d0                	call   *%rax
  80133b:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80133d:	85 c0                	test   %eax,%eax
  80133f:	0f 88 1a 01 00 00    	js     80145f <pipe+0x1b0>
    va = fd2data(fd0);
  801345:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801349:	48 b8 f8 05 80 00 00 	movabs $0x8005f8,%rax
  801350:	00 00 00 
  801353:	ff d0                	call   *%rax
  801355:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801358:	b9 46 00 00 00       	mov    $0x46,%ecx
  80135d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801362:	48 89 c6             	mov    %rax,%rsi
  801365:	bf 00 00 00 00       	mov    $0x0,%edi
  80136a:	48 b8 81 02 80 00 00 	movabs $0x800281,%rax
  801371:	00 00 00 
  801374:	ff d0                	call   *%rax
  801376:	89 c3                	mov    %eax,%ebx
  801378:	85 c0                	test   %eax,%eax
  80137a:	0f 88 c5 00 00 00    	js     801445 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  801380:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801384:	48 b8 f8 05 80 00 00 	movabs $0x8005f8,%rax
  80138b:	00 00 00 
  80138e:	ff d0                	call   *%rax
  801390:	48 89 c1             	mov    %rax,%rcx
  801393:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  801399:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80139f:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a4:	4c 89 ee             	mov    %r13,%rsi
  8013a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8013ac:	48 b8 e8 02 80 00 00 	movabs $0x8002e8,%rax
  8013b3:	00 00 00 
  8013b6:	ff d0                	call   *%rax
  8013b8:	89 c3                	mov    %eax,%ebx
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	78 6e                	js     80142c <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8013be:	be 00 10 00 00       	mov    $0x1000,%esi
  8013c3:	4c 89 ef             	mov    %r13,%rdi
  8013c6:	48 b8 23 02 80 00 00 	movabs $0x800223,%rax
  8013cd:	00 00 00 
  8013d0:	ff d0                	call   *%rax
  8013d2:	83 f8 02             	cmp    $0x2,%eax
  8013d5:	0f 85 ab 00 00 00    	jne    801486 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8013db:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8013e2:	00 00 
  8013e4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013e8:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8013ea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013ee:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8013f5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8013f9:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8013fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013ff:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801406:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80140a:	48 bb e6 05 80 00 00 	movabs $0x8005e6,%rbx
  801411:	00 00 00 
  801414:	ff d3                	call   *%rbx
  801416:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80141a:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80141e:	ff d3                	call   *%rbx
  801420:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  801425:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142a:	eb 4d                	jmp    801479 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  80142c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801431:	4c 89 ee             	mov    %r13,%rsi
  801434:	bf 00 00 00 00       	mov    $0x0,%edi
  801439:	48 b8 4d 03 80 00 00 	movabs $0x80034d,%rax
  801440:	00 00 00 
  801443:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  801445:	ba 00 10 00 00       	mov    $0x1000,%edx
  80144a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80144e:	bf 00 00 00 00       	mov    $0x0,%edi
  801453:	48 b8 4d 03 80 00 00 	movabs $0x80034d,%rax
  80145a:	00 00 00 
  80145d:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80145f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801464:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801468:	bf 00 00 00 00       	mov    $0x0,%edi
  80146d:	48 b8 4d 03 80 00 00 	movabs $0x80034d,%rax
  801474:	00 00 00 
  801477:	ff d0                	call   *%rax
}
  801479:	89 d8                	mov    %ebx,%eax
  80147b:	48 83 c4 18          	add    $0x18,%rsp
  80147f:	5b                   	pop    %rbx
  801480:	41 5c                	pop    %r12
  801482:	41 5d                	pop    %r13
  801484:	5d                   	pop    %rbp
  801485:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  801486:	48 b9 d0 2a 80 00 00 	movabs $0x802ad0,%rcx
  80148d:	00 00 00 
  801490:	48 ba a7 2a 80 00 00 	movabs $0x802aa7,%rdx
  801497:	00 00 00 
  80149a:	be 2e 00 00 00       	mov    $0x2e,%esi
  80149f:	48 bf bc 2a 80 00 00 	movabs $0x802abc,%rdi
  8014a6:	00 00 00 
  8014a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ae:	49 b8 44 19 80 00 00 	movabs $0x801944,%r8
  8014b5:	00 00 00 
  8014b8:	41 ff d0             	call   *%r8

00000000008014bb <pipeisclosed>:
pipeisclosed(int fdnum) {
  8014bb:	55                   	push   %rbp
  8014bc:	48 89 e5             	mov    %rsp,%rbp
  8014bf:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8014c3:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8014c7:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  8014ce:	00 00 00 
  8014d1:	ff d0                	call   *%rax
    if (res < 0) return res;
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	78 35                	js     80150c <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8014d7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8014db:	48 b8 f8 05 80 00 00 	movabs $0x8005f8,%rax
  8014e2:	00 00 00 
  8014e5:	ff d0                	call   *%rax
  8014e7:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8014ea:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8014ef:	be 00 10 00 00       	mov    $0x1000,%esi
  8014f4:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8014f8:	48 b8 55 02 80 00 00 	movabs $0x800255,%rax
  8014ff:	00 00 00 
  801502:	ff d0                	call   *%rax
  801504:	85 c0                	test   %eax,%eax
  801506:	0f 94 c0             	sete   %al
  801509:	0f b6 c0             	movzbl %al,%eax
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

000000000080150e <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80150e:	48 89 f8             	mov    %rdi,%rax
  801511:	48 c1 e8 27          	shr    $0x27,%rax
  801515:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80151c:	01 00 00 
  80151f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801523:	f6 c2 01             	test   $0x1,%dl
  801526:	74 6d                	je     801595 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801528:	48 89 f8             	mov    %rdi,%rax
  80152b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80152f:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801536:	01 00 00 
  801539:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80153d:	f6 c2 01             	test   $0x1,%dl
  801540:	74 62                	je     8015a4 <get_uvpt_entry+0x96>
  801542:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801549:	01 00 00 
  80154c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801550:	f6 c2 80             	test   $0x80,%dl
  801553:	75 4f                	jne    8015a4 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801555:	48 89 f8             	mov    %rdi,%rax
  801558:	48 c1 e8 15          	shr    $0x15,%rax
  80155c:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801563:	01 00 00 
  801566:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80156a:	f6 c2 01             	test   $0x1,%dl
  80156d:	74 44                	je     8015b3 <get_uvpt_entry+0xa5>
  80156f:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801576:	01 00 00 
  801579:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80157d:	f6 c2 80             	test   $0x80,%dl
  801580:	75 31                	jne    8015b3 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  801582:	48 c1 ef 0c          	shr    $0xc,%rdi
  801586:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80158d:	01 00 00 
  801590:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  801594:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801595:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80159c:	01 00 00 
  80159f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015a3:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8015a4:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8015ab:	01 00 00 
  8015ae:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015b2:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8015b3:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8015ba:	01 00 00 
  8015bd:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015c1:	c3                   	ret    

00000000008015c2 <get_prot>:

int
get_prot(void *va) {
  8015c2:	55                   	push   %rbp
  8015c3:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8015c6:	48 b8 0e 15 80 00 00 	movabs $0x80150e,%rax
  8015cd:	00 00 00 
  8015d0:	ff d0                	call   *%rax
  8015d2:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8015d5:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8015da:	89 c1                	mov    %eax,%ecx
  8015dc:	83 c9 04             	or     $0x4,%ecx
  8015df:	f6 c2 01             	test   $0x1,%dl
  8015e2:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8015e5:	89 c1                	mov    %eax,%ecx
  8015e7:	83 c9 02             	or     $0x2,%ecx
  8015ea:	f6 c2 02             	test   $0x2,%dl
  8015ed:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8015f0:	89 c1                	mov    %eax,%ecx
  8015f2:	83 c9 01             	or     $0x1,%ecx
  8015f5:	48 85 d2             	test   %rdx,%rdx
  8015f8:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8015fb:	89 c1                	mov    %eax,%ecx
  8015fd:	83 c9 40             	or     $0x40,%ecx
  801600:	f6 c6 04             	test   $0x4,%dh
  801603:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801606:	5d                   	pop    %rbp
  801607:	c3                   	ret    

0000000000801608 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801608:	55                   	push   %rbp
  801609:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80160c:	48 b8 0e 15 80 00 00 	movabs $0x80150e,%rax
  801613:	00 00 00 
  801616:	ff d0                	call   *%rax
    return pte & PTE_D;
  801618:	48 c1 e8 06          	shr    $0x6,%rax
  80161c:	83 e0 01             	and    $0x1,%eax
}
  80161f:	5d                   	pop    %rbp
  801620:	c3                   	ret    

0000000000801621 <is_page_present>:

bool
is_page_present(void *va) {
  801621:	55                   	push   %rbp
  801622:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801625:	48 b8 0e 15 80 00 00 	movabs $0x80150e,%rax
  80162c:	00 00 00 
  80162f:	ff d0                	call   *%rax
  801631:	83 e0 01             	and    $0x1,%eax
}
  801634:	5d                   	pop    %rbp
  801635:	c3                   	ret    

0000000000801636 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801636:	55                   	push   %rbp
  801637:	48 89 e5             	mov    %rsp,%rbp
  80163a:	41 57                	push   %r15
  80163c:	41 56                	push   %r14
  80163e:	41 55                	push   %r13
  801640:	41 54                	push   %r12
  801642:	53                   	push   %rbx
  801643:	48 83 ec 28          	sub    $0x28,%rsp
  801647:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  80164b:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  80164f:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  801654:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  80165b:	01 00 00 
  80165e:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  801665:	01 00 00 
  801668:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  80166f:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  801672:	49 bf c2 15 80 00 00 	movabs $0x8015c2,%r15
  801679:	00 00 00 
  80167c:	eb 16                	jmp    801694 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  80167e:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  801685:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  80168c:	00 00 00 
  80168f:	48 39 c3             	cmp    %rax,%rbx
  801692:	77 73                	ja     801707 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  801694:	48 89 d8             	mov    %rbx,%rax
  801697:	48 c1 e8 27          	shr    $0x27,%rax
  80169b:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  80169f:	a8 01                	test   $0x1,%al
  8016a1:	74 db                	je     80167e <foreach_shared_region+0x48>
  8016a3:	48 89 d8             	mov    %rbx,%rax
  8016a6:	48 c1 e8 1e          	shr    $0x1e,%rax
  8016aa:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8016af:	a8 01                	test   $0x1,%al
  8016b1:	74 cb                	je     80167e <foreach_shared_region+0x48>
  8016b3:	48 89 d8             	mov    %rbx,%rax
  8016b6:	48 c1 e8 15          	shr    $0x15,%rax
  8016ba:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8016be:	a8 01                	test   $0x1,%al
  8016c0:	74 bc                	je     80167e <foreach_shared_region+0x48>
        void *start = (void*)i;
  8016c2:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016c6:	48 89 df             	mov    %rbx,%rdi
  8016c9:	41 ff d7             	call   *%r15
  8016cc:	a8 40                	test   $0x40,%al
  8016ce:	75 09                	jne    8016d9 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8016d0:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8016d7:	eb ac                	jmp    801685 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016d9:	48 89 df             	mov    %rbx,%rdi
  8016dc:	48 b8 21 16 80 00 00 	movabs $0x801621,%rax
  8016e3:	00 00 00 
  8016e6:	ff d0                	call   *%rax
  8016e8:	84 c0                	test   %al,%al
  8016ea:	74 e4                	je     8016d0 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  8016ec:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  8016f3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8016f7:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8016fb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8016ff:	ff d0                	call   *%rax
  801701:	85 c0                	test   %eax,%eax
  801703:	79 cb                	jns    8016d0 <foreach_shared_region+0x9a>
  801705:	eb 05                	jmp    80170c <foreach_shared_region+0xd6>
    }
    return 0;
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170c:	48 83 c4 28          	add    $0x28,%rsp
  801710:	5b                   	pop    %rbx
  801711:	41 5c                	pop    %r12
  801713:	41 5d                	pop    %r13
  801715:	41 5e                	pop    %r14
  801717:	41 5f                	pop    %r15
  801719:	5d                   	pop    %rbp
  80171a:	c3                   	ret    

000000000080171b <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80171b:	b8 00 00 00 00       	mov    $0x0,%eax
  801720:	c3                   	ret    

0000000000801721 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  801721:	55                   	push   %rbp
  801722:	48 89 e5             	mov    %rsp,%rbp
  801725:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  801728:	48 be f4 2a 80 00 00 	movabs $0x802af4,%rsi
  80172f:	00 00 00 
  801732:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  801739:	00 00 00 
  80173c:	ff d0                	call   *%rax
    return 0;
}
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
  801743:	5d                   	pop    %rbp
  801744:	c3                   	ret    

0000000000801745 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  801745:	55                   	push   %rbp
  801746:	48 89 e5             	mov    %rsp,%rbp
  801749:	41 57                	push   %r15
  80174b:	41 56                	push   %r14
  80174d:	41 55                	push   %r13
  80174f:	41 54                	push   %r12
  801751:	53                   	push   %rbx
  801752:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  801759:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  801760:	48 85 d2             	test   %rdx,%rdx
  801763:	74 78                	je     8017dd <devcons_write+0x98>
  801765:	49 89 d6             	mov    %rdx,%r14
  801768:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80176e:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801773:	49 bf d0 25 80 00 00 	movabs $0x8025d0,%r15
  80177a:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80177d:	4c 89 f3             	mov    %r14,%rbx
  801780:	48 29 f3             	sub    %rsi,%rbx
  801783:	48 83 fb 7f          	cmp    $0x7f,%rbx
  801787:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80178c:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801790:	4c 63 eb             	movslq %ebx,%r13
  801793:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  80179a:	4c 89 ea             	mov    %r13,%rdx
  80179d:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017a4:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8017a7:	4c 89 ee             	mov    %r13,%rsi
  8017aa:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017b1:	48 b8 f8 00 80 00 00 	movabs $0x8000f8,%rax
  8017b8:	00 00 00 
  8017bb:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8017bd:	41 01 dc             	add    %ebx,%r12d
  8017c0:	49 63 f4             	movslq %r12d,%rsi
  8017c3:	4c 39 f6             	cmp    %r14,%rsi
  8017c6:	72 b5                	jb     80177d <devcons_write+0x38>
    return res;
  8017c8:	49 63 c4             	movslq %r12d,%rax
}
  8017cb:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8017d2:	5b                   	pop    %rbx
  8017d3:	41 5c                	pop    %r12
  8017d5:	41 5d                	pop    %r13
  8017d7:	41 5e                	pop    %r14
  8017d9:	41 5f                	pop    %r15
  8017db:	5d                   	pop    %rbp
  8017dc:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8017dd:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8017e3:	eb e3                	jmp    8017c8 <devcons_write+0x83>

00000000008017e5 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8017e5:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8017e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ed:	48 85 c0             	test   %rax,%rax
  8017f0:	74 55                	je     801847 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8017f2:	55                   	push   %rbp
  8017f3:	48 89 e5             	mov    %rsp,%rbp
  8017f6:	41 55                	push   %r13
  8017f8:	41 54                	push   %r12
  8017fa:	53                   	push   %rbx
  8017fb:	48 83 ec 08          	sub    $0x8,%rsp
  8017ff:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801802:	48 bb 25 01 80 00 00 	movabs $0x800125,%rbx
  801809:	00 00 00 
  80180c:	49 bc f2 01 80 00 00 	movabs $0x8001f2,%r12
  801813:	00 00 00 
  801816:	eb 03                	jmp    80181b <devcons_read+0x36>
  801818:	41 ff d4             	call   *%r12
  80181b:	ff d3                	call   *%rbx
  80181d:	85 c0                	test   %eax,%eax
  80181f:	74 f7                	je     801818 <devcons_read+0x33>
    if (c < 0) return c;
  801821:	48 63 d0             	movslq %eax,%rdx
  801824:	78 13                	js     801839 <devcons_read+0x54>
    if (c == 0x04) return 0;
  801826:	ba 00 00 00 00       	mov    $0x0,%edx
  80182b:	83 f8 04             	cmp    $0x4,%eax
  80182e:	74 09                	je     801839 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  801830:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801834:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801839:	48 89 d0             	mov    %rdx,%rax
  80183c:	48 83 c4 08          	add    $0x8,%rsp
  801840:	5b                   	pop    %rbx
  801841:	41 5c                	pop    %r12
  801843:	41 5d                	pop    %r13
  801845:	5d                   	pop    %rbp
  801846:	c3                   	ret    
  801847:	48 89 d0             	mov    %rdx,%rax
  80184a:	c3                   	ret    

000000000080184b <cputchar>:
cputchar(int ch) {
  80184b:	55                   	push   %rbp
  80184c:	48 89 e5             	mov    %rsp,%rbp
  80184f:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801853:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801857:	be 01 00 00 00       	mov    $0x1,%esi
  80185c:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801860:	48 b8 f8 00 80 00 00 	movabs $0x8000f8,%rax
  801867:	00 00 00 
  80186a:	ff d0                	call   *%rax
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

000000000080186e <getchar>:
getchar(void) {
  80186e:	55                   	push   %rbp
  80186f:	48 89 e5             	mov    %rsp,%rbp
  801872:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801876:	ba 01 00 00 00       	mov    $0x1,%edx
  80187b:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  80187f:	bf 00 00 00 00       	mov    $0x0,%edi
  801884:	48 b8 57 09 80 00 00 	movabs $0x800957,%rax
  80188b:	00 00 00 
  80188e:	ff d0                	call   *%rax
  801890:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801892:	85 c0                	test   %eax,%eax
  801894:	78 06                	js     80189c <getchar+0x2e>
  801896:	74 08                	je     8018a0 <getchar+0x32>
  801898:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  80189c:	89 d0                	mov    %edx,%eax
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8018a0:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8018a5:	eb f5                	jmp    80189c <getchar+0x2e>

00000000008018a7 <iscons>:
iscons(int fdnum) {
  8018a7:	55                   	push   %rbp
  8018a8:	48 89 e5             	mov    %rsp,%rbp
  8018ab:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8018af:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018b3:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  8018ba:	00 00 00 
  8018bd:	ff d0                	call   *%rax
    if (res < 0) return res;
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	78 18                	js     8018db <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8018c3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018c7:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8018ce:	00 00 00 
  8018d1:	8b 00                	mov    (%rax),%eax
  8018d3:	39 02                	cmp    %eax,(%rdx)
  8018d5:	0f 94 c0             	sete   %al
  8018d8:	0f b6 c0             	movzbl %al,%eax
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

00000000008018dd <opencons>:
opencons(void) {
  8018dd:	55                   	push   %rbp
  8018de:	48 89 e5             	mov    %rsp,%rbp
  8018e1:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8018e5:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8018e9:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  8018f0:	00 00 00 
  8018f3:	ff d0                	call   *%rax
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	78 49                	js     801942 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8018f9:	b9 46 00 00 00       	mov    $0x46,%ecx
  8018fe:	ba 00 10 00 00       	mov    $0x1000,%edx
  801903:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801907:	bf 00 00 00 00       	mov    $0x0,%edi
  80190c:	48 b8 81 02 80 00 00 	movabs $0x800281,%rax
  801913:	00 00 00 
  801916:	ff d0                	call   *%rax
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 26                	js     801942 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  80191c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801920:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801927:	00 00 
  801929:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80192b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80192f:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801936:	48 b8 e6 05 80 00 00 	movabs $0x8005e6,%rax
  80193d:	00 00 00 
  801940:	ff d0                	call   *%rax
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

0000000000801944 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801944:	55                   	push   %rbp
  801945:	48 89 e5             	mov    %rsp,%rbp
  801948:	41 56                	push   %r14
  80194a:	41 55                	push   %r13
  80194c:	41 54                	push   %r12
  80194e:	53                   	push   %rbx
  80194f:	48 83 ec 50          	sub    $0x50,%rsp
  801953:	49 89 fc             	mov    %rdi,%r12
  801956:	41 89 f5             	mov    %esi,%r13d
  801959:	48 89 d3             	mov    %rdx,%rbx
  80195c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801960:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801964:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801968:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  80196f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801973:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801977:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80197b:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  80197f:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801986:	00 00 00 
  801989:	4c 8b 30             	mov    (%rax),%r14
  80198c:	48 b8 c1 01 80 00 00 	movabs $0x8001c1,%rax
  801993:	00 00 00 
  801996:	ff d0                	call   *%rax
  801998:	89 c6                	mov    %eax,%esi
  80199a:	45 89 e8             	mov    %r13d,%r8d
  80199d:	4c 89 e1             	mov    %r12,%rcx
  8019a0:	4c 89 f2             	mov    %r14,%rdx
  8019a3:	48 bf 00 2b 80 00 00 	movabs $0x802b00,%rdi
  8019aa:	00 00 00 
  8019ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b2:	49 bc 94 1a 80 00 00 	movabs $0x801a94,%r12
  8019b9:	00 00 00 
  8019bc:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8019bf:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8019c3:	48 89 df             	mov    %rbx,%rdi
  8019c6:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  8019cd:	00 00 00 
  8019d0:	ff d0                	call   *%rax
    cprintf("\n");
  8019d2:	48 bf 43 2a 80 00 00 	movabs $0x802a43,%rdi
  8019d9:	00 00 00 
  8019dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e1:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8019e4:	cc                   	int3   
  8019e5:	eb fd                	jmp    8019e4 <_panic+0xa0>

00000000008019e7 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8019e7:	55                   	push   %rbp
  8019e8:	48 89 e5             	mov    %rsp,%rbp
  8019eb:	53                   	push   %rbx
  8019ec:	48 83 ec 08          	sub    $0x8,%rsp
  8019f0:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8019f3:	8b 06                	mov    (%rsi),%eax
  8019f5:	8d 50 01             	lea    0x1(%rax),%edx
  8019f8:	89 16                	mov    %edx,(%rsi)
  8019fa:	48 98                	cltq   
  8019fc:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801a01:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801a07:	74 0a                	je     801a13 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801a09:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801a0d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  801a13:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801a17:	be ff 00 00 00       	mov    $0xff,%esi
  801a1c:	48 b8 f8 00 80 00 00 	movabs $0x8000f8,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	call   *%rax
        state->offset = 0;
  801a28:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801a2e:	eb d9                	jmp    801a09 <putch+0x22>

0000000000801a30 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801a30:	55                   	push   %rbp
  801a31:	48 89 e5             	mov    %rsp,%rbp
  801a34:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801a3b:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801a3e:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801a45:	b9 21 00 00 00       	mov    $0x21,%ecx
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4f:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801a52:	48 89 f1             	mov    %rsi,%rcx
  801a55:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801a5c:	48 bf e7 19 80 00 00 	movabs $0x8019e7,%rdi
  801a63:	00 00 00 
  801a66:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801a6d:	00 00 00 
  801a70:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801a72:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801a79:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801a80:	48 b8 f8 00 80 00 00 	movabs $0x8000f8,%rax
  801a87:	00 00 00 
  801a8a:	ff d0                	call   *%rax

    return state.count;
}
  801a8c:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

0000000000801a94 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801a94:	55                   	push   %rbp
  801a95:	48 89 e5             	mov    %rsp,%rbp
  801a98:	48 83 ec 50          	sub    $0x50,%rsp
  801a9c:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801aa0:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801aa4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801aa8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801aac:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801ab0:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801ab7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801abb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801abf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801ac3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801ac7:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801acb:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  801ad2:	00 00 00 
  801ad5:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

0000000000801ad9 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801ad9:	55                   	push   %rbp
  801ada:	48 89 e5             	mov    %rsp,%rbp
  801add:	41 57                	push   %r15
  801adf:	41 56                	push   %r14
  801ae1:	41 55                	push   %r13
  801ae3:	41 54                	push   %r12
  801ae5:	53                   	push   %rbx
  801ae6:	48 83 ec 18          	sub    $0x18,%rsp
  801aea:	49 89 fc             	mov    %rdi,%r12
  801aed:	49 89 f5             	mov    %rsi,%r13
  801af0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801af4:	8b 45 10             	mov    0x10(%rbp),%eax
  801af7:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801afa:	41 89 cf             	mov    %ecx,%r15d
  801afd:	49 39 d7             	cmp    %rdx,%r15
  801b00:	76 5b                	jbe    801b5d <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801b02:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801b06:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801b0a:	85 db                	test   %ebx,%ebx
  801b0c:	7e 0e                	jle    801b1c <print_num+0x43>
            putch(padc, put_arg);
  801b0e:	4c 89 ee             	mov    %r13,%rsi
  801b11:	44 89 f7             	mov    %r14d,%edi
  801b14:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801b17:	83 eb 01             	sub    $0x1,%ebx
  801b1a:	75 f2                	jne    801b0e <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801b1c:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801b20:	48 b9 23 2b 80 00 00 	movabs $0x802b23,%rcx
  801b27:	00 00 00 
  801b2a:	48 b8 34 2b 80 00 00 	movabs $0x802b34,%rax
  801b31:	00 00 00 
  801b34:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801b38:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b41:	49 f7 f7             	div    %r15
  801b44:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801b48:	4c 89 ee             	mov    %r13,%rsi
  801b4b:	41 ff d4             	call   *%r12
}
  801b4e:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801b52:	5b                   	pop    %rbx
  801b53:	41 5c                	pop    %r12
  801b55:	41 5d                	pop    %r13
  801b57:	41 5e                	pop    %r14
  801b59:	41 5f                	pop    %r15
  801b5b:	5d                   	pop    %rbp
  801b5c:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801b5d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b61:	ba 00 00 00 00       	mov    $0x0,%edx
  801b66:	49 f7 f7             	div    %r15
  801b69:	48 83 ec 08          	sub    $0x8,%rsp
  801b6d:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801b71:	52                   	push   %rdx
  801b72:	45 0f be c9          	movsbl %r9b,%r9d
  801b76:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801b7a:	48 89 c2             	mov    %rax,%rdx
  801b7d:	48 b8 d9 1a 80 00 00 	movabs $0x801ad9,%rax
  801b84:	00 00 00 
  801b87:	ff d0                	call   *%rax
  801b89:	48 83 c4 10          	add    $0x10,%rsp
  801b8d:	eb 8d                	jmp    801b1c <print_num+0x43>

0000000000801b8f <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  801b8f:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801b93:	48 8b 06             	mov    (%rsi),%rax
  801b96:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801b9a:	73 0a                	jae    801ba6 <sprintputch+0x17>
        *state->start++ = ch;
  801b9c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ba0:	48 89 16             	mov    %rdx,(%rsi)
  801ba3:	40 88 38             	mov    %dil,(%rax)
    }
}
  801ba6:	c3                   	ret    

0000000000801ba7 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801ba7:	55                   	push   %rbp
  801ba8:	48 89 e5             	mov    %rsp,%rbp
  801bab:	48 83 ec 50          	sub    $0x50,%rsp
  801baf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bb3:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801bb7:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801bbb:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801bc2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801bc6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801bca:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801bce:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801bd2:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801bd6:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801bdd:	00 00 00 
  801be0:	ff d0                	call   *%rax
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

0000000000801be4 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801be4:	55                   	push   %rbp
  801be5:	48 89 e5             	mov    %rsp,%rbp
  801be8:	41 57                	push   %r15
  801bea:	41 56                	push   %r14
  801bec:	41 55                	push   %r13
  801bee:	41 54                	push   %r12
  801bf0:	53                   	push   %rbx
  801bf1:	48 83 ec 48          	sub    $0x48,%rsp
  801bf5:	49 89 fc             	mov    %rdi,%r12
  801bf8:	49 89 f6             	mov    %rsi,%r14
  801bfb:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  801bfe:	48 8b 01             	mov    (%rcx),%rax
  801c01:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801c05:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801c09:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801c0d:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801c11:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801c15:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  801c19:	41 0f b6 3f          	movzbl (%r15),%edi
  801c1d:	40 80 ff 25          	cmp    $0x25,%dil
  801c21:	74 18                	je     801c3b <vprintfmt+0x57>
            if (!ch) return;
  801c23:	40 84 ff             	test   %dil,%dil
  801c26:	0f 84 d1 06 00 00    	je     8022fd <vprintfmt+0x719>
            putch(ch, put_arg);
  801c2c:	40 0f b6 ff          	movzbl %dil,%edi
  801c30:	4c 89 f6             	mov    %r14,%rsi
  801c33:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  801c36:	49 89 df             	mov    %rbx,%r15
  801c39:	eb da                	jmp    801c15 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  801c3b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  801c3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c44:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  801c48:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801c4d:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801c53:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801c5a:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  801c5e:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  801c63:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  801c69:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  801c6d:	44 0f b6 0b          	movzbl (%rbx),%r9d
  801c71:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  801c75:	3c 57                	cmp    $0x57,%al
  801c77:	0f 87 65 06 00 00    	ja     8022e2 <vprintfmt+0x6fe>
  801c7d:	0f b6 c0             	movzbl %al,%eax
  801c80:	49 ba c0 2c 80 00 00 	movabs $0x802cc0,%r10
  801c87:	00 00 00 
  801c8a:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  801c8e:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  801c91:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  801c95:	eb d2                	jmp    801c69 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  801c97:	4c 89 fb             	mov    %r15,%rbx
  801c9a:	44 89 c1             	mov    %r8d,%ecx
  801c9d:	eb ca                	jmp    801c69 <vprintfmt+0x85>
            padc = ch;
  801c9f:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  801ca3:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801ca6:	eb c1                	jmp    801c69 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801ca8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801cab:	83 f8 2f             	cmp    $0x2f,%eax
  801cae:	77 24                	ja     801cd4 <vprintfmt+0xf0>
  801cb0:	41 89 c1             	mov    %eax,%r9d
  801cb3:	49 01 f1             	add    %rsi,%r9
  801cb6:	83 c0 08             	add    $0x8,%eax
  801cb9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801cbc:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  801cbf:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  801cc2:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801cc6:	79 a1                	jns    801c69 <vprintfmt+0x85>
                width = precision;
  801cc8:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  801ccc:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801cd2:	eb 95                	jmp    801c69 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cd4:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  801cd8:	49 8d 41 08          	lea    0x8(%r9),%rax
  801cdc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ce0:	eb da                	jmp    801cbc <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  801ce2:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  801ce6:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801cea:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  801cee:	3c 39                	cmp    $0x39,%al
  801cf0:	77 1e                	ja     801d10 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  801cf2:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  801cf6:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  801cfb:	0f b6 c0             	movzbl %al,%eax
  801cfe:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d03:	41 0f b6 07          	movzbl (%r15),%eax
  801d07:	3c 39                	cmp    $0x39,%al
  801d09:	76 e7                	jbe    801cf2 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  801d0b:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  801d0e:	eb b2                	jmp    801cc2 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  801d10:	4c 89 fb             	mov    %r15,%rbx
  801d13:	eb ad                	jmp    801cc2 <vprintfmt+0xde>
            width = MAX(0, width);
  801d15:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	0f 48 c7             	cmovs  %edi,%eax
  801d1d:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801d20:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d23:	e9 41 ff ff ff       	jmp    801c69 <vprintfmt+0x85>
            lflag++;
  801d28:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801d2b:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d2e:	e9 36 ff ff ff       	jmp    801c69 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  801d33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d36:	83 f8 2f             	cmp    $0x2f,%eax
  801d39:	77 18                	ja     801d53 <vprintfmt+0x16f>
  801d3b:	89 c2                	mov    %eax,%edx
  801d3d:	48 01 f2             	add    %rsi,%rdx
  801d40:	83 c0 08             	add    $0x8,%eax
  801d43:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d46:	4c 89 f6             	mov    %r14,%rsi
  801d49:	8b 3a                	mov    (%rdx),%edi
  801d4b:	41 ff d4             	call   *%r12
            break;
  801d4e:	e9 c2 fe ff ff       	jmp    801c15 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  801d53:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801d57:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801d5b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d5f:	eb e5                	jmp    801d46 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  801d61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d64:	83 f8 2f             	cmp    $0x2f,%eax
  801d67:	77 5b                	ja     801dc4 <vprintfmt+0x1e0>
  801d69:	89 c2                	mov    %eax,%edx
  801d6b:	48 01 d6             	add    %rdx,%rsi
  801d6e:	83 c0 08             	add    $0x8,%eax
  801d71:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d74:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  801d76:	89 c8                	mov    %ecx,%eax
  801d78:	c1 f8 1f             	sar    $0x1f,%eax
  801d7b:	31 c1                	xor    %eax,%ecx
  801d7d:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  801d7f:	83 f9 13             	cmp    $0x13,%ecx
  801d82:	7f 4e                	jg     801dd2 <vprintfmt+0x1ee>
  801d84:	48 63 c1             	movslq %ecx,%rax
  801d87:	48 ba 80 2f 80 00 00 	movabs $0x802f80,%rdx
  801d8e:	00 00 00 
  801d91:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801d95:	48 85 c0             	test   %rax,%rax
  801d98:	74 38                	je     801dd2 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  801d9a:	48 89 c1             	mov    %rax,%rcx
  801d9d:	48 ba b9 2a 80 00 00 	movabs $0x802ab9,%rdx
  801da4:	00 00 00 
  801da7:	4c 89 f6             	mov    %r14,%rsi
  801daa:	4c 89 e7             	mov    %r12,%rdi
  801dad:	b8 00 00 00 00       	mov    $0x0,%eax
  801db2:	49 b8 a7 1b 80 00 00 	movabs $0x801ba7,%r8
  801db9:	00 00 00 
  801dbc:	41 ff d0             	call   *%r8
  801dbf:	e9 51 fe ff ff       	jmp    801c15 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  801dc4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801dc8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801dcc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801dd0:	eb a2                	jmp    801d74 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  801dd2:	48 ba 4c 2b 80 00 00 	movabs $0x802b4c,%rdx
  801dd9:	00 00 00 
  801ddc:	4c 89 f6             	mov    %r14,%rsi
  801ddf:	4c 89 e7             	mov    %r12,%rdi
  801de2:	b8 00 00 00 00       	mov    $0x0,%eax
  801de7:	49 b8 a7 1b 80 00 00 	movabs $0x801ba7,%r8
  801dee:	00 00 00 
  801df1:	41 ff d0             	call   *%r8
  801df4:	e9 1c fe ff ff       	jmp    801c15 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  801df9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801dfc:	83 f8 2f             	cmp    $0x2f,%eax
  801dff:	77 55                	ja     801e56 <vprintfmt+0x272>
  801e01:	89 c2                	mov    %eax,%edx
  801e03:	48 01 d6             	add    %rdx,%rsi
  801e06:	83 c0 08             	add    $0x8,%eax
  801e09:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801e0c:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  801e0f:	48 85 d2             	test   %rdx,%rdx
  801e12:	48 b8 45 2b 80 00 00 	movabs $0x802b45,%rax
  801e19:	00 00 00 
  801e1c:	48 0f 45 c2          	cmovne %rdx,%rax
  801e20:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  801e24:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801e28:	7e 06                	jle    801e30 <vprintfmt+0x24c>
  801e2a:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  801e2e:	75 34                	jne    801e64 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801e30:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  801e34:	48 8d 58 01          	lea    0x1(%rax),%rbx
  801e38:	0f b6 00             	movzbl (%rax),%eax
  801e3b:	84 c0                	test   %al,%al
  801e3d:	0f 84 b2 00 00 00    	je     801ef5 <vprintfmt+0x311>
  801e43:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  801e47:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  801e4c:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  801e50:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  801e54:	eb 74                	jmp    801eca <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  801e56:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801e5a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801e5e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e62:	eb a8                	jmp    801e0c <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  801e64:	49 63 f5             	movslq %r13d,%rsi
  801e67:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  801e6b:	48 b8 b7 23 80 00 00 	movabs $0x8023b7,%rax
  801e72:	00 00 00 
  801e75:	ff d0                	call   *%rax
  801e77:	48 89 c2             	mov    %rax,%rdx
  801e7a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801e7d:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  801e7f:	8d 48 ff             	lea    -0x1(%rax),%ecx
  801e82:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  801e85:	85 c0                	test   %eax,%eax
  801e87:	7e a7                	jle    801e30 <vprintfmt+0x24c>
  801e89:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  801e8d:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  801e91:	41 89 cd             	mov    %ecx,%r13d
  801e94:	4c 89 f6             	mov    %r14,%rsi
  801e97:	89 df                	mov    %ebx,%edi
  801e99:	41 ff d4             	call   *%r12
  801e9c:	41 83 ed 01          	sub    $0x1,%r13d
  801ea0:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  801ea4:	75 ee                	jne    801e94 <vprintfmt+0x2b0>
  801ea6:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  801eaa:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  801eae:	eb 80                	jmp    801e30 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801eb0:	0f b6 f8             	movzbl %al,%edi
  801eb3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801eb7:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801eba:	41 83 ef 01          	sub    $0x1,%r15d
  801ebe:	48 83 c3 01          	add    $0x1,%rbx
  801ec2:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  801ec6:	84 c0                	test   %al,%al
  801ec8:	74 1f                	je     801ee9 <vprintfmt+0x305>
  801eca:	45 85 ed             	test   %r13d,%r13d
  801ecd:	78 06                	js     801ed5 <vprintfmt+0x2f1>
  801ecf:	41 83 ed 01          	sub    $0x1,%r13d
  801ed3:	78 46                	js     801f1b <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801ed5:	45 84 f6             	test   %r14b,%r14b
  801ed8:	74 d6                	je     801eb0 <vprintfmt+0x2cc>
  801eda:	8d 50 e0             	lea    -0x20(%rax),%edx
  801edd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801ee2:	80 fa 5e             	cmp    $0x5e,%dl
  801ee5:	77 cc                	ja     801eb3 <vprintfmt+0x2cf>
  801ee7:	eb c7                	jmp    801eb0 <vprintfmt+0x2cc>
  801ee9:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801eed:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801ef1:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  801ef5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801ef8:	8d 58 ff             	lea    -0x1(%rax),%ebx
  801efb:	85 c0                	test   %eax,%eax
  801efd:	0f 8e 12 fd ff ff    	jle    801c15 <vprintfmt+0x31>
  801f03:	4c 89 f6             	mov    %r14,%rsi
  801f06:	bf 20 00 00 00       	mov    $0x20,%edi
  801f0b:	41 ff d4             	call   *%r12
  801f0e:	83 eb 01             	sub    $0x1,%ebx
  801f11:	83 fb ff             	cmp    $0xffffffff,%ebx
  801f14:	75 ed                	jne    801f03 <vprintfmt+0x31f>
  801f16:	e9 fa fc ff ff       	jmp    801c15 <vprintfmt+0x31>
  801f1b:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f1f:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f23:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  801f27:	eb cc                	jmp    801ef5 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  801f29:	45 89 cd             	mov    %r9d,%r13d
  801f2c:	84 c9                	test   %cl,%cl
  801f2e:	75 25                	jne    801f55 <vprintfmt+0x371>
    switch (lflag) {
  801f30:	85 d2                	test   %edx,%edx
  801f32:	74 57                	je     801f8b <vprintfmt+0x3a7>
  801f34:	83 fa 01             	cmp    $0x1,%edx
  801f37:	74 78                	je     801fb1 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  801f39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f3c:	83 f8 2f             	cmp    $0x2f,%eax
  801f3f:	0f 87 92 00 00 00    	ja     801fd7 <vprintfmt+0x3f3>
  801f45:	89 c2                	mov    %eax,%edx
  801f47:	48 01 d6             	add    %rdx,%rsi
  801f4a:	83 c0 08             	add    $0x8,%eax
  801f4d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f50:	48 8b 1e             	mov    (%rsi),%rbx
  801f53:	eb 16                	jmp    801f6b <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  801f55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f58:	83 f8 2f             	cmp    $0x2f,%eax
  801f5b:	77 20                	ja     801f7d <vprintfmt+0x399>
  801f5d:	89 c2                	mov    %eax,%edx
  801f5f:	48 01 d6             	add    %rdx,%rsi
  801f62:	83 c0 08             	add    $0x8,%eax
  801f65:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f68:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  801f6b:	48 85 db             	test   %rbx,%rbx
  801f6e:	78 78                	js     801fe8 <vprintfmt+0x404>
            num = i;
  801f70:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  801f73:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  801f78:	e9 49 02 00 00       	jmp    8021c6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801f7d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801f81:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801f85:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f89:	eb dd                	jmp    801f68 <vprintfmt+0x384>
        return va_arg(*ap, int);
  801f8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f8e:	83 f8 2f             	cmp    $0x2f,%eax
  801f91:	77 10                	ja     801fa3 <vprintfmt+0x3bf>
  801f93:	89 c2                	mov    %eax,%edx
  801f95:	48 01 d6             	add    %rdx,%rsi
  801f98:	83 c0 08             	add    $0x8,%eax
  801f9b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f9e:	48 63 1e             	movslq (%rsi),%rbx
  801fa1:	eb c8                	jmp    801f6b <vprintfmt+0x387>
  801fa3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fa7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fab:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801faf:	eb ed                	jmp    801f9e <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  801fb1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fb4:	83 f8 2f             	cmp    $0x2f,%eax
  801fb7:	77 10                	ja     801fc9 <vprintfmt+0x3e5>
  801fb9:	89 c2                	mov    %eax,%edx
  801fbb:	48 01 d6             	add    %rdx,%rsi
  801fbe:	83 c0 08             	add    $0x8,%eax
  801fc1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fc4:	48 8b 1e             	mov    (%rsi),%rbx
  801fc7:	eb a2                	jmp    801f6b <vprintfmt+0x387>
  801fc9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fcd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fd1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fd5:	eb ed                	jmp    801fc4 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  801fd7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fdb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fdf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fe3:	e9 68 ff ff ff       	jmp    801f50 <vprintfmt+0x36c>
                putch('-', put_arg);
  801fe8:	4c 89 f6             	mov    %r14,%rsi
  801feb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801ff0:	41 ff d4             	call   *%r12
                i = -i;
  801ff3:	48 f7 db             	neg    %rbx
  801ff6:	e9 75 ff ff ff       	jmp    801f70 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  801ffb:	45 89 cd             	mov    %r9d,%r13d
  801ffe:	84 c9                	test   %cl,%cl
  802000:	75 2d                	jne    80202f <vprintfmt+0x44b>
    switch (lflag) {
  802002:	85 d2                	test   %edx,%edx
  802004:	74 57                	je     80205d <vprintfmt+0x479>
  802006:	83 fa 01             	cmp    $0x1,%edx
  802009:	74 7f                	je     80208a <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  80200b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80200e:	83 f8 2f             	cmp    $0x2f,%eax
  802011:	0f 87 a1 00 00 00    	ja     8020b8 <vprintfmt+0x4d4>
  802017:	89 c2                	mov    %eax,%edx
  802019:	48 01 d6             	add    %rdx,%rsi
  80201c:	83 c0 08             	add    $0x8,%eax
  80201f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802022:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802025:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80202a:	e9 97 01 00 00       	jmp    8021c6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80202f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802032:	83 f8 2f             	cmp    $0x2f,%eax
  802035:	77 18                	ja     80204f <vprintfmt+0x46b>
  802037:	89 c2                	mov    %eax,%edx
  802039:	48 01 d6             	add    %rdx,%rsi
  80203c:	83 c0 08             	add    $0x8,%eax
  80203f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802042:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802045:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80204a:	e9 77 01 00 00       	jmp    8021c6 <vprintfmt+0x5e2>
  80204f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802053:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802057:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80205b:	eb e5                	jmp    802042 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  80205d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802060:	83 f8 2f             	cmp    $0x2f,%eax
  802063:	77 17                	ja     80207c <vprintfmt+0x498>
  802065:	89 c2                	mov    %eax,%edx
  802067:	48 01 d6             	add    %rdx,%rsi
  80206a:	83 c0 08             	add    $0x8,%eax
  80206d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802070:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  802072:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802077:	e9 4a 01 00 00       	jmp    8021c6 <vprintfmt+0x5e2>
  80207c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802080:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802084:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802088:	eb e6                	jmp    802070 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  80208a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80208d:	83 f8 2f             	cmp    $0x2f,%eax
  802090:	77 18                	ja     8020aa <vprintfmt+0x4c6>
  802092:	89 c2                	mov    %eax,%edx
  802094:	48 01 d6             	add    %rdx,%rsi
  802097:	83 c0 08             	add    $0x8,%eax
  80209a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80209d:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8020a0:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8020a5:	e9 1c 01 00 00       	jmp    8021c6 <vprintfmt+0x5e2>
  8020aa:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020ae:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020b2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020b6:	eb e5                	jmp    80209d <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8020b8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020bc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020c0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020c4:	e9 59 ff ff ff       	jmp    802022 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8020c9:	45 89 cd             	mov    %r9d,%r13d
  8020cc:	84 c9                	test   %cl,%cl
  8020ce:	75 2d                	jne    8020fd <vprintfmt+0x519>
    switch (lflag) {
  8020d0:	85 d2                	test   %edx,%edx
  8020d2:	74 57                	je     80212b <vprintfmt+0x547>
  8020d4:	83 fa 01             	cmp    $0x1,%edx
  8020d7:	74 7c                	je     802155 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8020d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020dc:	83 f8 2f             	cmp    $0x2f,%eax
  8020df:	0f 87 9b 00 00 00    	ja     802180 <vprintfmt+0x59c>
  8020e5:	89 c2                	mov    %eax,%edx
  8020e7:	48 01 d6             	add    %rdx,%rsi
  8020ea:	83 c0 08             	add    $0x8,%eax
  8020ed:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020f0:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8020f3:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8020f8:	e9 c9 00 00 00       	jmp    8021c6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8020fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802100:	83 f8 2f             	cmp    $0x2f,%eax
  802103:	77 18                	ja     80211d <vprintfmt+0x539>
  802105:	89 c2                	mov    %eax,%edx
  802107:	48 01 d6             	add    %rdx,%rsi
  80210a:	83 c0 08             	add    $0x8,%eax
  80210d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802110:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802113:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802118:	e9 a9 00 00 00       	jmp    8021c6 <vprintfmt+0x5e2>
  80211d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802121:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802125:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802129:	eb e5                	jmp    802110 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  80212b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80212e:	83 f8 2f             	cmp    $0x2f,%eax
  802131:	77 14                	ja     802147 <vprintfmt+0x563>
  802133:	89 c2                	mov    %eax,%edx
  802135:	48 01 d6             	add    %rdx,%rsi
  802138:	83 c0 08             	add    $0x8,%eax
  80213b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80213e:	8b 16                	mov    (%rsi),%edx
            base = 8;
  802140:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  802145:	eb 7f                	jmp    8021c6 <vprintfmt+0x5e2>
  802147:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80214b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80214f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802153:	eb e9                	jmp    80213e <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  802155:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802158:	83 f8 2f             	cmp    $0x2f,%eax
  80215b:	77 15                	ja     802172 <vprintfmt+0x58e>
  80215d:	89 c2                	mov    %eax,%edx
  80215f:	48 01 d6             	add    %rdx,%rsi
  802162:	83 c0 08             	add    $0x8,%eax
  802165:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802168:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80216b:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  802170:	eb 54                	jmp    8021c6 <vprintfmt+0x5e2>
  802172:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802176:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80217a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80217e:	eb e8                	jmp    802168 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  802180:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802184:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802188:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80218c:	e9 5f ff ff ff       	jmp    8020f0 <vprintfmt+0x50c>
            putch('0', put_arg);
  802191:	45 89 cd             	mov    %r9d,%r13d
  802194:	4c 89 f6             	mov    %r14,%rsi
  802197:	bf 30 00 00 00       	mov    $0x30,%edi
  80219c:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  80219f:	4c 89 f6             	mov    %r14,%rsi
  8021a2:	bf 78 00 00 00       	mov    $0x78,%edi
  8021a7:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8021aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021ad:	83 f8 2f             	cmp    $0x2f,%eax
  8021b0:	77 47                	ja     8021f9 <vprintfmt+0x615>
  8021b2:	89 c2                	mov    %eax,%edx
  8021b4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021b8:	83 c0 08             	add    $0x8,%eax
  8021bb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021be:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8021c1:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8021c6:	48 83 ec 08          	sub    $0x8,%rsp
  8021ca:	41 80 fd 58          	cmp    $0x58,%r13b
  8021ce:	0f 94 c0             	sete   %al
  8021d1:	0f b6 c0             	movzbl %al,%eax
  8021d4:	50                   	push   %rax
  8021d5:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  8021da:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8021de:	4c 89 f6             	mov    %r14,%rsi
  8021e1:	4c 89 e7             	mov    %r12,%rdi
  8021e4:	48 b8 d9 1a 80 00 00 	movabs $0x801ad9,%rax
  8021eb:	00 00 00 
  8021ee:	ff d0                	call   *%rax
            break;
  8021f0:	48 83 c4 10          	add    $0x10,%rsp
  8021f4:	e9 1c fa ff ff       	jmp    801c15 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  8021f9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8021fd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802201:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802205:	eb b7                	jmp    8021be <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  802207:	45 89 cd             	mov    %r9d,%r13d
  80220a:	84 c9                	test   %cl,%cl
  80220c:	75 2a                	jne    802238 <vprintfmt+0x654>
    switch (lflag) {
  80220e:	85 d2                	test   %edx,%edx
  802210:	74 54                	je     802266 <vprintfmt+0x682>
  802212:	83 fa 01             	cmp    $0x1,%edx
  802215:	74 7c                	je     802293 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  802217:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80221a:	83 f8 2f             	cmp    $0x2f,%eax
  80221d:	0f 87 9e 00 00 00    	ja     8022c1 <vprintfmt+0x6dd>
  802223:	89 c2                	mov    %eax,%edx
  802225:	48 01 d6             	add    %rdx,%rsi
  802228:	83 c0 08             	add    $0x8,%eax
  80222b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80222e:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802231:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  802236:	eb 8e                	jmp    8021c6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802238:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80223b:	83 f8 2f             	cmp    $0x2f,%eax
  80223e:	77 18                	ja     802258 <vprintfmt+0x674>
  802240:	89 c2                	mov    %eax,%edx
  802242:	48 01 d6             	add    %rdx,%rsi
  802245:	83 c0 08             	add    $0x8,%eax
  802248:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80224b:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80224e:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802253:	e9 6e ff ff ff       	jmp    8021c6 <vprintfmt+0x5e2>
  802258:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80225c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802260:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802264:	eb e5                	jmp    80224b <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  802266:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802269:	83 f8 2f             	cmp    $0x2f,%eax
  80226c:	77 17                	ja     802285 <vprintfmt+0x6a1>
  80226e:	89 c2                	mov    %eax,%edx
  802270:	48 01 d6             	add    %rdx,%rsi
  802273:	83 c0 08             	add    $0x8,%eax
  802276:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802279:	8b 16                	mov    (%rsi),%edx
            base = 16;
  80227b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  802280:	e9 41 ff ff ff       	jmp    8021c6 <vprintfmt+0x5e2>
  802285:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802289:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80228d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802291:	eb e6                	jmp    802279 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  802293:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802296:	83 f8 2f             	cmp    $0x2f,%eax
  802299:	77 18                	ja     8022b3 <vprintfmt+0x6cf>
  80229b:	89 c2                	mov    %eax,%edx
  80229d:	48 01 d6             	add    %rdx,%rsi
  8022a0:	83 c0 08             	add    $0x8,%eax
  8022a3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022a6:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8022a9:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8022ae:	e9 13 ff ff ff       	jmp    8021c6 <vprintfmt+0x5e2>
  8022b3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022b7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022bb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022bf:	eb e5                	jmp    8022a6 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  8022c1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022c5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022c9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022cd:	e9 5c ff ff ff       	jmp    80222e <vprintfmt+0x64a>
            putch(ch, put_arg);
  8022d2:	4c 89 f6             	mov    %r14,%rsi
  8022d5:	bf 25 00 00 00       	mov    $0x25,%edi
  8022da:	41 ff d4             	call   *%r12
            break;
  8022dd:	e9 33 f9 ff ff       	jmp    801c15 <vprintfmt+0x31>
            putch('%', put_arg);
  8022e2:	4c 89 f6             	mov    %r14,%rsi
  8022e5:	bf 25 00 00 00       	mov    $0x25,%edi
  8022ea:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  8022ed:	49 83 ef 01          	sub    $0x1,%r15
  8022f1:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  8022f6:	75 f5                	jne    8022ed <vprintfmt+0x709>
  8022f8:	e9 18 f9 ff ff       	jmp    801c15 <vprintfmt+0x31>
}
  8022fd:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802301:	5b                   	pop    %rbx
  802302:	41 5c                	pop    %r12
  802304:	41 5d                	pop    %r13
  802306:	41 5e                	pop    %r14
  802308:	41 5f                	pop    %r15
  80230a:	5d                   	pop    %rbp
  80230b:	c3                   	ret    

000000000080230c <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  80230c:	55                   	push   %rbp
  80230d:	48 89 e5             	mov    %rsp,%rbp
  802310:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  802314:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802318:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  80231d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802321:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  802328:	48 85 ff             	test   %rdi,%rdi
  80232b:	74 2b                	je     802358 <vsnprintf+0x4c>
  80232d:	48 85 f6             	test   %rsi,%rsi
  802330:	74 26                	je     802358 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  802332:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802336:	48 bf 8f 1b 80 00 00 	movabs $0x801b8f,%rdi
  80233d:	00 00 00 
  802340:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  802347:	00 00 00 
  80234a:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  80234c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802350:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  802353:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  802358:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80235d:	eb f7                	jmp    802356 <vsnprintf+0x4a>

000000000080235f <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  80235f:	55                   	push   %rbp
  802360:	48 89 e5             	mov    %rsp,%rbp
  802363:	48 83 ec 50          	sub    $0x50,%rsp
  802367:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80236b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80236f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802373:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80237a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80237e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802382:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802386:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  80238a:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80238e:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  802395:	00 00 00 
  802398:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

000000000080239c <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  80239c:	80 3f 00             	cmpb   $0x0,(%rdi)
  80239f:	74 10                	je     8023b1 <strlen+0x15>
    size_t n = 0;
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8023a6:	48 83 c0 01          	add    $0x1,%rax
  8023aa:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023ae:	75 f6                	jne    8023a6 <strlen+0xa>
  8023b0:	c3                   	ret    
    size_t n = 0;
  8023b1:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  8023b6:	c3                   	ret    

00000000008023b7 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  8023b7:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  8023bc:	48 85 f6             	test   %rsi,%rsi
  8023bf:	74 10                	je     8023d1 <strnlen+0x1a>
  8023c1:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023c5:	74 09                	je     8023d0 <strnlen+0x19>
  8023c7:	48 83 c0 01          	add    $0x1,%rax
  8023cb:	48 39 c6             	cmp    %rax,%rsi
  8023ce:	75 f1                	jne    8023c1 <strnlen+0xa>
    return n;
}
  8023d0:	c3                   	ret    
    size_t n = 0;
  8023d1:	48 89 f0             	mov    %rsi,%rax
  8023d4:	c3                   	ret    

00000000008023d5 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023da:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  8023de:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  8023e1:	48 83 c0 01          	add    $0x1,%rax
  8023e5:	84 d2                	test   %dl,%dl
  8023e7:	75 f1                	jne    8023da <strcpy+0x5>
        ;
    return res;
}
  8023e9:	48 89 f8             	mov    %rdi,%rax
  8023ec:	c3                   	ret    

00000000008023ed <strcat>:

char *
strcat(char *dst, const char *src) {
  8023ed:	55                   	push   %rbp
  8023ee:	48 89 e5             	mov    %rsp,%rbp
  8023f1:	41 54                	push   %r12
  8023f3:	53                   	push   %rbx
  8023f4:	48 89 fb             	mov    %rdi,%rbx
  8023f7:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8023fa:	48 b8 9c 23 80 00 00 	movabs $0x80239c,%rax
  802401:	00 00 00 
  802404:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  802406:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  80240a:	4c 89 e6             	mov    %r12,%rsi
  80240d:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  802414:	00 00 00 
  802417:	ff d0                	call   *%rax
    return dst;
}
  802419:	48 89 d8             	mov    %rbx,%rax
  80241c:	5b                   	pop    %rbx
  80241d:	41 5c                	pop    %r12
  80241f:	5d                   	pop    %rbp
  802420:	c3                   	ret    

0000000000802421 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  802421:	48 85 d2             	test   %rdx,%rdx
  802424:	74 1d                	je     802443 <strncpy+0x22>
  802426:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80242a:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  80242d:	48 83 c0 01          	add    $0x1,%rax
  802431:	0f b6 16             	movzbl (%rsi),%edx
  802434:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  802437:	80 fa 01             	cmp    $0x1,%dl
  80243a:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  80243e:	48 39 c1             	cmp    %rax,%rcx
  802441:	75 ea                	jne    80242d <strncpy+0xc>
    }
    return ret;
}
  802443:	48 89 f8             	mov    %rdi,%rax
  802446:	c3                   	ret    

0000000000802447 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  802447:	48 89 f8             	mov    %rdi,%rax
  80244a:	48 85 d2             	test   %rdx,%rdx
  80244d:	74 24                	je     802473 <strlcpy+0x2c>
        while (--size > 0 && *src)
  80244f:	48 83 ea 01          	sub    $0x1,%rdx
  802453:	74 1b                	je     802470 <strlcpy+0x29>
  802455:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802459:	0f b6 16             	movzbl (%rsi),%edx
  80245c:	84 d2                	test   %dl,%dl
  80245e:	74 10                	je     802470 <strlcpy+0x29>
            *dst++ = *src++;
  802460:	48 83 c6 01          	add    $0x1,%rsi
  802464:	48 83 c0 01          	add    $0x1,%rax
  802468:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80246b:	48 39 c8             	cmp    %rcx,%rax
  80246e:	75 e9                	jne    802459 <strlcpy+0x12>
        *dst = '\0';
  802470:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802473:	48 29 f8             	sub    %rdi,%rax
}
  802476:	c3                   	ret    

0000000000802477 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  802477:	0f b6 07             	movzbl (%rdi),%eax
  80247a:	84 c0                	test   %al,%al
  80247c:	74 13                	je     802491 <strcmp+0x1a>
  80247e:	38 06                	cmp    %al,(%rsi)
  802480:	75 0f                	jne    802491 <strcmp+0x1a>
  802482:	48 83 c7 01          	add    $0x1,%rdi
  802486:	48 83 c6 01          	add    $0x1,%rsi
  80248a:	0f b6 07             	movzbl (%rdi),%eax
  80248d:	84 c0                	test   %al,%al
  80248f:	75 ed                	jne    80247e <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  802491:	0f b6 c0             	movzbl %al,%eax
  802494:	0f b6 16             	movzbl (%rsi),%edx
  802497:	29 d0                	sub    %edx,%eax
}
  802499:	c3                   	ret    

000000000080249a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  80249a:	48 85 d2             	test   %rdx,%rdx
  80249d:	74 1f                	je     8024be <strncmp+0x24>
  80249f:	0f b6 07             	movzbl (%rdi),%eax
  8024a2:	84 c0                	test   %al,%al
  8024a4:	74 1e                	je     8024c4 <strncmp+0x2a>
  8024a6:	3a 06                	cmp    (%rsi),%al
  8024a8:	75 1a                	jne    8024c4 <strncmp+0x2a>
  8024aa:	48 83 c7 01          	add    $0x1,%rdi
  8024ae:	48 83 c6 01          	add    $0x1,%rsi
  8024b2:	48 83 ea 01          	sub    $0x1,%rdx
  8024b6:	75 e7                	jne    80249f <strncmp+0x5>

    if (!n) return 0;
  8024b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bd:	c3                   	ret    
  8024be:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c3:	c3                   	ret    
  8024c4:	48 85 d2             	test   %rdx,%rdx
  8024c7:	74 09                	je     8024d2 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  8024c9:	0f b6 07             	movzbl (%rdi),%eax
  8024cc:	0f b6 16             	movzbl (%rsi),%edx
  8024cf:	29 d0                	sub    %edx,%eax
  8024d1:	c3                   	ret    
    if (!n) return 0;
  8024d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d7:	c3                   	ret    

00000000008024d8 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  8024d8:	0f b6 07             	movzbl (%rdi),%eax
  8024db:	84 c0                	test   %al,%al
  8024dd:	74 18                	je     8024f7 <strchr+0x1f>
        if (*str == c) {
  8024df:	0f be c0             	movsbl %al,%eax
  8024e2:	39 f0                	cmp    %esi,%eax
  8024e4:	74 17                	je     8024fd <strchr+0x25>
    for (; *str; str++) {
  8024e6:	48 83 c7 01          	add    $0x1,%rdi
  8024ea:	0f b6 07             	movzbl (%rdi),%eax
  8024ed:	84 c0                	test   %al,%al
  8024ef:	75 ee                	jne    8024df <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  8024f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f6:	c3                   	ret    
  8024f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fc:	c3                   	ret    
  8024fd:	48 89 f8             	mov    %rdi,%rax
}
  802500:	c3                   	ret    

0000000000802501 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  802501:	0f b6 07             	movzbl (%rdi),%eax
  802504:	84 c0                	test   %al,%al
  802506:	74 16                	je     80251e <strfind+0x1d>
  802508:	0f be c0             	movsbl %al,%eax
  80250b:	39 f0                	cmp    %esi,%eax
  80250d:	74 13                	je     802522 <strfind+0x21>
  80250f:	48 83 c7 01          	add    $0x1,%rdi
  802513:	0f b6 07             	movzbl (%rdi),%eax
  802516:	84 c0                	test   %al,%al
  802518:	75 ee                	jne    802508 <strfind+0x7>
  80251a:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  80251d:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  80251e:	48 89 f8             	mov    %rdi,%rax
  802521:	c3                   	ret    
  802522:	48 89 f8             	mov    %rdi,%rax
  802525:	c3                   	ret    

0000000000802526 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  802526:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  802529:	48 89 f8             	mov    %rdi,%rax
  80252c:	48 f7 d8             	neg    %rax
  80252f:	83 e0 07             	and    $0x7,%eax
  802532:	49 89 d1             	mov    %rdx,%r9
  802535:	49 29 c1             	sub    %rax,%r9
  802538:	78 32                	js     80256c <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80253a:	40 0f b6 c6          	movzbl %sil,%eax
  80253e:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  802545:	01 01 01 
  802548:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80254c:	40 f6 c7 07          	test   $0x7,%dil
  802550:	75 34                	jne    802586 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  802552:	4c 89 c9             	mov    %r9,%rcx
  802555:	48 c1 f9 03          	sar    $0x3,%rcx
  802559:	74 08                	je     802563 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80255b:	fc                   	cld    
  80255c:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  80255f:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802563:	4d 85 c9             	test   %r9,%r9
  802566:	75 45                	jne    8025ad <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  802568:	4c 89 c0             	mov    %r8,%rax
  80256b:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  80256c:	48 85 d2             	test   %rdx,%rdx
  80256f:	74 f7                	je     802568 <memset+0x42>
  802571:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  802574:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  802577:	48 83 c0 01          	add    $0x1,%rax
  80257b:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80257f:	48 39 c2             	cmp    %rax,%rdx
  802582:	75 f3                	jne    802577 <memset+0x51>
  802584:	eb e2                	jmp    802568 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  802586:	40 f6 c7 01          	test   $0x1,%dil
  80258a:	74 06                	je     802592 <memset+0x6c>
  80258c:	88 07                	mov    %al,(%rdi)
  80258e:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  802592:	40 f6 c7 02          	test   $0x2,%dil
  802596:	74 07                	je     80259f <memset+0x79>
  802598:	66 89 07             	mov    %ax,(%rdi)
  80259b:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  80259f:	40 f6 c7 04          	test   $0x4,%dil
  8025a3:	74 ad                	je     802552 <memset+0x2c>
  8025a5:	89 07                	mov    %eax,(%rdi)
  8025a7:	48 83 c7 04          	add    $0x4,%rdi
  8025ab:	eb a5                	jmp    802552 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025ad:	41 f6 c1 04          	test   $0x4,%r9b
  8025b1:	74 06                	je     8025b9 <memset+0x93>
  8025b3:	89 07                	mov    %eax,(%rdi)
  8025b5:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025b9:	41 f6 c1 02          	test   $0x2,%r9b
  8025bd:	74 07                	je     8025c6 <memset+0xa0>
  8025bf:	66 89 07             	mov    %ax,(%rdi)
  8025c2:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8025c6:	41 f6 c1 01          	test   $0x1,%r9b
  8025ca:	74 9c                	je     802568 <memset+0x42>
  8025cc:	88 07                	mov    %al,(%rdi)
  8025ce:	eb 98                	jmp    802568 <memset+0x42>

00000000008025d0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8025d0:	48 89 f8             	mov    %rdi,%rax
  8025d3:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8025d6:	48 39 fe             	cmp    %rdi,%rsi
  8025d9:	73 39                	jae    802614 <memmove+0x44>
  8025db:	48 01 f2             	add    %rsi,%rdx
  8025de:	48 39 fa             	cmp    %rdi,%rdx
  8025e1:	76 31                	jbe    802614 <memmove+0x44>
        s += n;
        d += n;
  8025e3:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8025e6:	48 89 d6             	mov    %rdx,%rsi
  8025e9:	48 09 fe             	or     %rdi,%rsi
  8025ec:	48 09 ce             	or     %rcx,%rsi
  8025ef:	40 f6 c6 07          	test   $0x7,%sil
  8025f3:	75 12                	jne    802607 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8025f5:	48 83 ef 08          	sub    $0x8,%rdi
  8025f9:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8025fd:	48 c1 e9 03          	shr    $0x3,%rcx
  802601:	fd                   	std    
  802602:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  802605:	fc                   	cld    
  802606:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  802607:	48 83 ef 01          	sub    $0x1,%rdi
  80260b:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80260f:	fd                   	std    
  802610:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  802612:	eb f1                	jmp    802605 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802614:	48 89 f2             	mov    %rsi,%rdx
  802617:	48 09 c2             	or     %rax,%rdx
  80261a:	48 09 ca             	or     %rcx,%rdx
  80261d:	f6 c2 07             	test   $0x7,%dl
  802620:	75 0c                	jne    80262e <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  802622:	48 c1 e9 03          	shr    $0x3,%rcx
  802626:	48 89 c7             	mov    %rax,%rdi
  802629:	fc                   	cld    
  80262a:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80262d:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80262e:	48 89 c7             	mov    %rax,%rdi
  802631:	fc                   	cld    
  802632:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  802634:	c3                   	ret    

0000000000802635 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  802635:	55                   	push   %rbp
  802636:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802639:	48 b8 d0 25 80 00 00 	movabs $0x8025d0,%rax
  802640:	00 00 00 
  802643:	ff d0                	call   *%rax
}
  802645:	5d                   	pop    %rbp
  802646:	c3                   	ret    

0000000000802647 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802647:	55                   	push   %rbp
  802648:	48 89 e5             	mov    %rsp,%rbp
  80264b:	41 57                	push   %r15
  80264d:	41 56                	push   %r14
  80264f:	41 55                	push   %r13
  802651:	41 54                	push   %r12
  802653:	53                   	push   %rbx
  802654:	48 83 ec 08          	sub    $0x8,%rsp
  802658:	49 89 fe             	mov    %rdi,%r14
  80265b:	49 89 f7             	mov    %rsi,%r15
  80265e:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  802661:	48 89 f7             	mov    %rsi,%rdi
  802664:	48 b8 9c 23 80 00 00 	movabs $0x80239c,%rax
  80266b:	00 00 00 
  80266e:	ff d0                	call   *%rax
  802670:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  802673:	48 89 de             	mov    %rbx,%rsi
  802676:	4c 89 f7             	mov    %r14,%rdi
  802679:	48 b8 b7 23 80 00 00 	movabs $0x8023b7,%rax
  802680:	00 00 00 
  802683:	ff d0                	call   *%rax
  802685:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  802688:	48 39 c3             	cmp    %rax,%rbx
  80268b:	74 36                	je     8026c3 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  80268d:	48 89 d8             	mov    %rbx,%rax
  802690:	4c 29 e8             	sub    %r13,%rax
  802693:	4c 39 e0             	cmp    %r12,%rax
  802696:	76 30                	jbe    8026c8 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  802698:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  80269d:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026a1:	4c 89 fe             	mov    %r15,%rsi
  8026a4:	48 b8 35 26 80 00 00 	movabs $0x802635,%rax
  8026ab:	00 00 00 
  8026ae:	ff d0                	call   *%rax
    return dstlen + srclen;
  8026b0:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8026b4:	48 83 c4 08          	add    $0x8,%rsp
  8026b8:	5b                   	pop    %rbx
  8026b9:	41 5c                	pop    %r12
  8026bb:	41 5d                	pop    %r13
  8026bd:	41 5e                	pop    %r14
  8026bf:	41 5f                	pop    %r15
  8026c1:	5d                   	pop    %rbp
  8026c2:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8026c3:	4c 01 e0             	add    %r12,%rax
  8026c6:	eb ec                	jmp    8026b4 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8026c8:	48 83 eb 01          	sub    $0x1,%rbx
  8026cc:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026d0:	48 89 da             	mov    %rbx,%rdx
  8026d3:	4c 89 fe             	mov    %r15,%rsi
  8026d6:	48 b8 35 26 80 00 00 	movabs $0x802635,%rax
  8026dd:	00 00 00 
  8026e0:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8026e2:	49 01 de             	add    %rbx,%r14
  8026e5:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8026ea:	eb c4                	jmp    8026b0 <strlcat+0x69>

00000000008026ec <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8026ec:	49 89 f0             	mov    %rsi,%r8
  8026ef:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8026f2:	48 85 d2             	test   %rdx,%rdx
  8026f5:	74 2a                	je     802721 <memcmp+0x35>
  8026f7:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8026fc:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  802700:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  802705:	38 ca                	cmp    %cl,%dl
  802707:	75 0f                	jne    802718 <memcmp+0x2c>
    while (n-- > 0) {
  802709:	48 83 c0 01          	add    $0x1,%rax
  80270d:	48 39 c6             	cmp    %rax,%rsi
  802710:	75 ea                	jne    8026fc <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  802712:	b8 00 00 00 00       	mov    $0x0,%eax
  802717:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  802718:	0f b6 c2             	movzbl %dl,%eax
  80271b:	0f b6 c9             	movzbl %cl,%ecx
  80271e:	29 c8                	sub    %ecx,%eax
  802720:	c3                   	ret    
    return 0;
  802721:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802726:	c3                   	ret    

0000000000802727 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  802727:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80272b:	48 39 c7             	cmp    %rax,%rdi
  80272e:	73 0f                	jae    80273f <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802730:	40 38 37             	cmp    %sil,(%rdi)
  802733:	74 0e                	je     802743 <memfind+0x1c>
    for (; src < end; src++) {
  802735:	48 83 c7 01          	add    $0x1,%rdi
  802739:	48 39 f8             	cmp    %rdi,%rax
  80273c:	75 f2                	jne    802730 <memfind+0x9>
  80273e:	c3                   	ret    
  80273f:	48 89 f8             	mov    %rdi,%rax
  802742:	c3                   	ret    
  802743:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802746:	c3                   	ret    

0000000000802747 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802747:	49 89 f2             	mov    %rsi,%r10
  80274a:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80274d:	0f b6 37             	movzbl (%rdi),%esi
  802750:	40 80 fe 20          	cmp    $0x20,%sil
  802754:	74 06                	je     80275c <strtol+0x15>
  802756:	40 80 fe 09          	cmp    $0x9,%sil
  80275a:	75 13                	jne    80276f <strtol+0x28>
  80275c:	48 83 c7 01          	add    $0x1,%rdi
  802760:	0f b6 37             	movzbl (%rdi),%esi
  802763:	40 80 fe 20          	cmp    $0x20,%sil
  802767:	74 f3                	je     80275c <strtol+0x15>
  802769:	40 80 fe 09          	cmp    $0x9,%sil
  80276d:	74 ed                	je     80275c <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  80276f:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802772:	83 e0 fd             	and    $0xfffffffd,%eax
  802775:	3c 01                	cmp    $0x1,%al
  802777:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80277b:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  802782:	75 11                	jne    802795 <strtol+0x4e>
  802784:	80 3f 30             	cmpb   $0x30,(%rdi)
  802787:	74 16                	je     80279f <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802789:	45 85 c0             	test   %r8d,%r8d
  80278c:	b8 0a 00 00 00       	mov    $0xa,%eax
  802791:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  802795:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80279a:	4d 63 c8             	movslq %r8d,%r9
  80279d:	eb 38                	jmp    8027d7 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80279f:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8027a3:	74 11                	je     8027b6 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8027a5:	45 85 c0             	test   %r8d,%r8d
  8027a8:	75 eb                	jne    802795 <strtol+0x4e>
        s++;
  8027aa:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8027ae:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8027b4:	eb df                	jmp    802795 <strtol+0x4e>
        s += 2;
  8027b6:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8027ba:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8027c0:	eb d3                	jmp    802795 <strtol+0x4e>
            dig -= '0';
  8027c2:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8027c5:	0f b6 c8             	movzbl %al,%ecx
  8027c8:	44 39 c1             	cmp    %r8d,%ecx
  8027cb:	7d 1f                	jge    8027ec <strtol+0xa5>
        val = val * base + dig;
  8027cd:	49 0f af d1          	imul   %r9,%rdx
  8027d1:	0f b6 c0             	movzbl %al,%eax
  8027d4:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8027d7:	48 83 c7 01          	add    $0x1,%rdi
  8027db:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8027df:	3c 39                	cmp    $0x39,%al
  8027e1:	76 df                	jbe    8027c2 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8027e3:	3c 7b                	cmp    $0x7b,%al
  8027e5:	77 05                	ja     8027ec <strtol+0xa5>
            dig -= 'a' - 10;
  8027e7:	83 e8 57             	sub    $0x57,%eax
  8027ea:	eb d9                	jmp    8027c5 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8027ec:	4d 85 d2             	test   %r10,%r10
  8027ef:	74 03                	je     8027f4 <strtol+0xad>
  8027f1:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8027f4:	48 89 d0             	mov    %rdx,%rax
  8027f7:	48 f7 d8             	neg    %rax
  8027fa:	40 80 fe 2d          	cmp    $0x2d,%sil
  8027fe:	48 0f 44 d0          	cmove  %rax,%rdx
}
  802802:	48 89 d0             	mov    %rdx,%rax
  802805:	c3                   	ret    

0000000000802806 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802806:	55                   	push   %rbp
  802807:	48 89 e5             	mov    %rsp,%rbp
  80280a:	41 54                	push   %r12
  80280c:	53                   	push   %rbx
  80280d:	48 89 fb             	mov    %rdi,%rbx
  802810:	48 89 f7             	mov    %rsi,%rdi
  802813:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802816:	48 85 f6             	test   %rsi,%rsi
  802819:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802820:	00 00 00 
  802823:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802827:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  80282c:	48 85 d2             	test   %rdx,%rdx
  80282f:	74 02                	je     802833 <ipc_recv+0x2d>
  802831:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802833:	48 63 f6             	movslq %esi,%rsi
  802836:	48 b8 1b 05 80 00 00 	movabs $0x80051b,%rax
  80283d:	00 00 00 
  802840:	ff d0                	call   *%rax

    if (res < 0) {
  802842:	85 c0                	test   %eax,%eax
  802844:	78 45                	js     80288b <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802846:	48 85 db             	test   %rbx,%rbx
  802849:	74 12                	je     80285d <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  80284b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802852:	00 00 00 
  802855:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80285b:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  80285d:	4d 85 e4             	test   %r12,%r12
  802860:	74 14                	je     802876 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802862:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802869:	00 00 00 
  80286c:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802872:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802876:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80287d:	00 00 00 
  802880:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802886:	5b                   	pop    %rbx
  802887:	41 5c                	pop    %r12
  802889:	5d                   	pop    %rbp
  80288a:	c3                   	ret    
        if (from_env_store)
  80288b:	48 85 db             	test   %rbx,%rbx
  80288e:	74 06                	je     802896 <ipc_recv+0x90>
            *from_env_store = 0;
  802890:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802896:	4d 85 e4             	test   %r12,%r12
  802899:	74 eb                	je     802886 <ipc_recv+0x80>
            *perm_store = 0;
  80289b:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028a2:	00 
  8028a3:	eb e1                	jmp    802886 <ipc_recv+0x80>

00000000008028a5 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028a5:	55                   	push   %rbp
  8028a6:	48 89 e5             	mov    %rsp,%rbp
  8028a9:	41 57                	push   %r15
  8028ab:	41 56                	push   %r14
  8028ad:	41 55                	push   %r13
  8028af:	41 54                	push   %r12
  8028b1:	53                   	push   %rbx
  8028b2:	48 83 ec 18          	sub    $0x18,%rsp
  8028b6:	41 89 fd             	mov    %edi,%r13d
  8028b9:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028bc:	48 89 d3             	mov    %rdx,%rbx
  8028bf:	49 89 cc             	mov    %rcx,%r12
  8028c2:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028c6:	48 85 d2             	test   %rdx,%rdx
  8028c9:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8028d0:	00 00 00 
  8028d3:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028d7:	49 be ef 04 80 00 00 	movabs $0x8004ef,%r14
  8028de:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  8028e1:	49 bf f2 01 80 00 00 	movabs $0x8001f2,%r15
  8028e8:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028eb:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8028ee:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  8028f2:	4c 89 e1             	mov    %r12,%rcx
  8028f5:	48 89 da             	mov    %rbx,%rdx
  8028f8:	44 89 ef             	mov    %r13d,%edi
  8028fb:	41 ff d6             	call   *%r14
  8028fe:	85 c0                	test   %eax,%eax
  802900:	79 37                	jns    802939 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802902:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802905:	75 05                	jne    80290c <ipc_send+0x67>
          sys_yield();
  802907:	41 ff d7             	call   *%r15
  80290a:	eb df                	jmp    8028eb <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  80290c:	89 c1                	mov    %eax,%ecx
  80290e:	48 ba 3f 30 80 00 00 	movabs $0x80303f,%rdx
  802915:	00 00 00 
  802918:	be 46 00 00 00       	mov    $0x46,%esi
  80291d:	48 bf 52 30 80 00 00 	movabs $0x803052,%rdi
  802924:	00 00 00 
  802927:	b8 00 00 00 00       	mov    $0x0,%eax
  80292c:	49 b8 44 19 80 00 00 	movabs $0x801944,%r8
  802933:	00 00 00 
  802936:	41 ff d0             	call   *%r8
      }
}
  802939:	48 83 c4 18          	add    $0x18,%rsp
  80293d:	5b                   	pop    %rbx
  80293e:	41 5c                	pop    %r12
  802940:	41 5d                	pop    %r13
  802942:	41 5e                	pop    %r14
  802944:	41 5f                	pop    %r15
  802946:	5d                   	pop    %rbp
  802947:	c3                   	ret    

0000000000802948 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802948:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80294d:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802954:	00 00 00 
  802957:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80295b:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80295f:	48 c1 e2 04          	shl    $0x4,%rdx
  802963:	48 01 ca             	add    %rcx,%rdx
  802966:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  80296c:	39 fa                	cmp    %edi,%edx
  80296e:	74 12                	je     802982 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802970:	48 83 c0 01          	add    $0x1,%rax
  802974:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80297a:	75 db                	jne    802957 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  80297c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802981:	c3                   	ret    
            return envs[i].env_id;
  802982:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802986:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80298a:	48 c1 e0 04          	shl    $0x4,%rax
  80298e:	48 89 c2             	mov    %rax,%rdx
  802991:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802998:	00 00 00 
  80299b:	48 01 d0             	add    %rdx,%rax
  80299e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029a4:	c3                   	ret    
  8029a5:	0f 1f 00             	nopl   (%rax)

00000000008029a8 <__rodata_start>:
  8029a8:	3c 75                	cmp    $0x75,%al
  8029aa:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029ab:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8029af:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029b0:	3e 00 66 0f          	ds add %ah,0xf(%rsi)
  8029b4:	1f                   	(bad)  
  8029b5:	44 00 00             	add    %r8b,(%rax)
  8029b8:	73 79                	jae    802a33 <__rodata_start+0x8b>
  8029ba:	73 63                	jae    802a1f <__rodata_start+0x77>
  8029bc:	61                   	(bad)  
  8029bd:	6c                   	insb   (%dx),%es:(%rdi)
  8029be:	6c                   	insb   (%dx),%es:(%rdi)
  8029bf:	20 25 7a 64 20 72    	and    %ah,0x7220647a(%rip)        # 72a08e3f <__bss_end+0x72200e3f>
  8029c5:	65 74 75             	gs je  802a3d <__rodata_start+0x95>
  8029c8:	72 6e                	jb     802a38 <__rodata_start+0x90>
  8029ca:	65 64 20 25 7a 64 20 	gs and %ah,%fs:0x2820647a(%rip)        # 28a08e4c <__bss_end+0x28200e4c>
  8029d1:	28 
  8029d2:	3e 20 30             	ds and %dh,(%rax)
  8029d5:	29 00                	sub    %eax,(%rax)
  8029d7:	6c                   	insb   (%dx),%es:(%rdi)
  8029d8:	69 62 2f 73 79 73 63 	imul   $0x63737973,0x2f(%rdx),%esp
  8029df:	61                   	(bad)  
  8029e0:	6c                   	insb   (%dx),%es:(%rdi)
  8029e1:	6c                   	insb   (%dx),%es:(%rdi)
  8029e2:	2e 63 00             	cs movsxd (%rax),%eax
  8029e5:	0f 1f 00             	nopl   (%rax)
  8029e8:	5b                   	pop    %rbx
  8029e9:	25 30 38 78 5d       	and    $0x5d783830,%eax
  8029ee:	20 75 6e             	and    %dh,0x6e(%rbp)
  8029f1:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8029f5:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029f6:	20 64 65 76          	and    %ah,0x76(%rbp,%riz,2)
  8029fa:	69 63 65 20 74 79 70 	imul   $0x70797420,0x65(%rbx),%esp
  802a01:	65 20 25 64 0a 00 00 	and    %ah,%gs:0xa64(%rip)        # 80346c <error_string+0x4ec>
  802a08:	5b                   	pop    %rbx
  802a09:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a0e:	20 66 74             	and    %ah,0x74(%rsi)
  802a11:	72 75                	jb     802a88 <devtab+0x8>
  802a13:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a14:	63 61 74             	movsxd 0x74(%rcx),%esp
  802a17:	65 20 25 64 20 2d 2d 	and    %ah,%gs:0x2d2d2064(%rip)        # 2dad4a82 <__bss_end+0x2d2cca82>
  802a1e:	20 62 61             	and    %ah,0x61(%rdx)
  802a21:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a25:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a29:	5b                   	pop    %rbx
  802a2a:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a2f:	20 72 65             	and    %dh,0x65(%rdx)
  802a32:	61                   	(bad)  
  802a33:	64 20 25 64 20 2d 2d 	and    %ah,%fs:0x2d2d2064(%rip)        # 2dad4a9e <__bss_end+0x2d2cca9e>
  802a3a:	20 62 61             	and    %ah,0x61(%rdx)
  802a3d:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a41:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a45:	5b                   	pop    %rbx
  802a46:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a4b:	20 77 72             	and    %dh,0x72(%rdi)
  802a4e:	69 74 65 20 25 64 20 	imul   $0x2d206425,0x20(%rbp,%riz,2),%esi
  802a55:	2d 
  802a56:	2d 20 62 61 64       	sub    $0x64616220,%eax
  802a5b:	20 6d 6f             	and    %ch,0x6f(%rbp)
  802a5e:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802a69:	00 00 00 
  802a6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802a73:	00 00 00 
  802a76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802a7d:	00 00 00 

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
  802cc0:	8e 1c 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ........."......
  802cd0:	d2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802ce0:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802cf0:	e2 22 80 00 00 00 00 00 a8 1c 80 00 00 00 00 00     ."..............
  802d00:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802d10:	9f 1c 80 00 00 00 00 00 15 1d 80 00 00 00 00 00     ................
  802d20:	e2 22 80 00 00 00 00 00 9f 1c 80 00 00 00 00 00     ."..............
  802d30:	e2 1c 80 00 00 00 00 00 e2 1c 80 00 00 00 00 00     ................
  802d40:	e2 1c 80 00 00 00 00 00 e2 1c 80 00 00 00 00 00     ................
  802d50:	e2 1c 80 00 00 00 00 00 e2 1c 80 00 00 00 00 00     ................
  802d60:	e2 1c 80 00 00 00 00 00 e2 1c 80 00 00 00 00 00     ................
  802d70:	e2 1c 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ........."......
  802d80:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802d90:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802da0:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802db0:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802dc0:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802dd0:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802de0:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802df0:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802e00:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802e10:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802e20:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802e30:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802e40:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802e50:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802e60:	e2 22 80 00 00 00 00 00 07 22 80 00 00 00 00 00     ."......."......
  802e70:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802e80:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802e90:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802ea0:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802eb0:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802ec0:	33 1d 80 00 00 00 00 00 29 1f 80 00 00 00 00 00     3.......).......
  802ed0:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802ee0:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802ef0:	61 1d 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     a........"......
  802f00:	e2 22 80 00 00 00 00 00 28 1d 80 00 00 00 00 00     ."......(.......
  802f10:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802f20:	c9 20 80 00 00 00 00 00 91 21 80 00 00 00 00 00     . .......!......
  802f30:	e2 22 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ."......."......
  802f40:	f9 1d 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ........."......
  802f50:	fb 1f 80 00 00 00 00 00 e2 22 80 00 00 00 00 00     ........."......
  802f60:	e2 22 80 00 00 00 00 00 07 22 80 00 00 00 00 00     ."......."......
  802f70:	e2 22 80 00 00 00 00 00 97 1c 80 00 00 00 00 00     ."..............

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
