
obj/user/faultwritekernel:     file format elf64-x86-64


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
  80001e:	e8 13 00 00 00       	call   800036 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv) {
    *(volatile unsigned *)0x8040000000 = 0;
  800025:	48 b8 00 00 00 40 80 	movabs $0x8040000000,%rax
  80002c:	00 00 00 
  80002f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  800035:	c3                   	ret    

0000000000800036 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800036:	55                   	push   %rbp
  800037:	48 89 e5             	mov    %rsp,%rbp
  80003a:	41 56                	push   %r14
  80003c:	41 55                	push   %r13
  80003e:	41 54                	push   %r12
  800040:	53                   	push   %rbx
  800041:	41 89 fd             	mov    %edi,%r13d
  800044:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800047:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80004e:	00 00 00 
  800051:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800058:	00 00 00 
  80005b:	48 39 c2             	cmp    %rax,%rdx
  80005e:	73 17                	jae    800077 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800060:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800063:	49 89 c4             	mov    %rax,%r12
  800066:	48 83 c3 08          	add    $0x8,%rbx
  80006a:	b8 00 00 00 00       	mov    $0x0,%eax
  80006f:	ff 53 f8             	call   *-0x8(%rbx)
  800072:	4c 39 e3             	cmp    %r12,%rbx
  800075:	72 ef                	jb     800066 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800077:	48 b8 d0 01 80 00 00 	movabs $0x8001d0,%rax
  80007e:	00 00 00 
  800081:	ff d0                	call   *%rax
  800083:	25 ff 03 00 00       	and    $0x3ff,%eax
  800088:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80008c:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800090:	48 c1 e0 04          	shl    $0x4,%rax
  800094:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  80009b:	00 00 00 
  80009e:	48 01 d0             	add    %rdx,%rax
  8000a1:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000a8:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000ab:	45 85 ed             	test   %r13d,%r13d
  8000ae:	7e 0d                	jle    8000bd <libmain+0x87>
  8000b0:	49 8b 06             	mov    (%r14),%rax
  8000b3:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000ba:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000bd:	4c 89 f6             	mov    %r14,%rsi
  8000c0:	44 89 ef             	mov    %r13d,%edi
  8000c3:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000ca:	00 00 00 
  8000cd:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000cf:	48 b8 e4 00 80 00 00 	movabs $0x8000e4,%rax
  8000d6:	00 00 00 
  8000d9:	ff d0                	call   *%rax
#endif
}
  8000db:	5b                   	pop    %rbx
  8000dc:	41 5c                	pop    %r12
  8000de:	41 5d                	pop    %r13
  8000e0:	41 5e                	pop    %r14
  8000e2:	5d                   	pop    %rbp
  8000e3:	c3                   	ret    

00000000008000e4 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000e4:	55                   	push   %rbp
  8000e5:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000e8:	48 b8 20 08 80 00 00 	movabs $0x800820,%rax
  8000ef:	00 00 00 
  8000f2:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8000f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8000f9:	48 b8 65 01 80 00 00 	movabs $0x800165,%rax
  800100:	00 00 00 
  800103:	ff d0                	call   *%rax
}
  800105:	5d                   	pop    %rbp
  800106:	c3                   	ret    

0000000000800107 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800107:	55                   	push   %rbp
  800108:	48 89 e5             	mov    %rsp,%rbp
  80010b:	53                   	push   %rbx
  80010c:	48 89 fa             	mov    %rdi,%rdx
  80010f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800117:	bb 00 00 00 00       	mov    $0x0,%ebx
  80011c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800121:	be 00 00 00 00       	mov    $0x0,%esi
  800126:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80012c:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80012e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800132:	c9                   	leave  
  800133:	c3                   	ret    

0000000000800134 <sys_cgetc>:

int
sys_cgetc(void) {
  800134:	55                   	push   %rbp
  800135:	48 89 e5             	mov    %rsp,%rbp
  800138:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800139:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80013e:	ba 00 00 00 00       	mov    $0x0,%edx
  800143:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800148:	bb 00 00 00 00       	mov    $0x0,%ebx
  80014d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800152:	be 00 00 00 00       	mov    $0x0,%esi
  800157:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80015d:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80015f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800163:	c9                   	leave  
  800164:	c3                   	ret    

0000000000800165 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800165:	55                   	push   %rbp
  800166:	48 89 e5             	mov    %rsp,%rbp
  800169:	53                   	push   %rbx
  80016a:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80016e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800171:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800176:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80017b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800180:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800185:	be 00 00 00 00       	mov    $0x0,%esi
  80018a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800190:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800192:	48 85 c0             	test   %rax,%rax
  800195:	7f 06                	jg     80019d <sys_env_destroy+0x38>
}
  800197:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80019b:	c9                   	leave  
  80019c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80019d:	49 89 c0             	mov    %rax,%r8
  8001a0:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001a5:	48 ba c8 29 80 00 00 	movabs $0x8029c8,%rdx
  8001ac:	00 00 00 
  8001af:	be 26 00 00 00       	mov    $0x26,%esi
  8001b4:	48 bf e7 29 80 00 00 	movabs $0x8029e7,%rdi
  8001bb:	00 00 00 
  8001be:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c3:	49 b9 53 19 80 00 00 	movabs $0x801953,%r9
  8001ca:	00 00 00 
  8001cd:	41 ff d1             	call   *%r9

00000000008001d0 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001d0:	55                   	push   %rbp
  8001d1:	48 89 e5             	mov    %rsp,%rbp
  8001d4:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001d5:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001da:	ba 00 00 00 00       	mov    $0x0,%edx
  8001df:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001ee:	be 00 00 00 00       	mov    $0x0,%esi
  8001f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001f9:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8001fb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    

0000000000800201 <sys_yield>:

void
sys_yield(void) {
  800201:	55                   	push   %rbp
  800202:	48 89 e5             	mov    %rsp,%rbp
  800205:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800206:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80020b:	ba 00 00 00 00       	mov    $0x0,%edx
  800210:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800215:	bb 00 00 00 00       	mov    $0x0,%ebx
  80021a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80021f:	be 00 00 00 00       	mov    $0x0,%esi
  800224:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80022a:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80022c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800230:	c9                   	leave  
  800231:	c3                   	ret    

0000000000800232 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  800232:	55                   	push   %rbp
  800233:	48 89 e5             	mov    %rsp,%rbp
  800236:	53                   	push   %rbx
  800237:	48 89 fa             	mov    %rdi,%rdx
  80023a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80023d:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800242:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800249:	00 00 00 
  80024c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800251:	be 00 00 00 00       	mov    $0x0,%esi
  800256:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80025c:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80025e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800262:	c9                   	leave  
  800263:	c3                   	ret    

0000000000800264 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  800264:	55                   	push   %rbp
  800265:	48 89 e5             	mov    %rsp,%rbp
  800268:	53                   	push   %rbx
  800269:	49 89 f8             	mov    %rdi,%r8
  80026c:	48 89 d3             	mov    %rdx,%rbx
  80026f:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  800272:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800277:	4c 89 c2             	mov    %r8,%rdx
  80027a:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80027d:	be 00 00 00 00       	mov    $0x0,%esi
  800282:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800288:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80028a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

0000000000800290 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  800290:	55                   	push   %rbp
  800291:	48 89 e5             	mov    %rsp,%rbp
  800294:	53                   	push   %rbx
  800295:	48 83 ec 08          	sub    $0x8,%rsp
  800299:	89 f8                	mov    %edi,%eax
  80029b:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80029e:	48 63 f9             	movslq %ecx,%rdi
  8002a1:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002a4:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002a9:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002ac:	be 00 00 00 00       	mov    $0x0,%esi
  8002b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002b7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002b9:	48 85 c0             	test   %rax,%rax
  8002bc:	7f 06                	jg     8002c4 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002be:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002c4:	49 89 c0             	mov    %rax,%r8
  8002c7:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002cc:	48 ba c8 29 80 00 00 	movabs $0x8029c8,%rdx
  8002d3:	00 00 00 
  8002d6:	be 26 00 00 00       	mov    $0x26,%esi
  8002db:	48 bf e7 29 80 00 00 	movabs $0x8029e7,%rdi
  8002e2:	00 00 00 
  8002e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ea:	49 b9 53 19 80 00 00 	movabs $0x801953,%r9
  8002f1:	00 00 00 
  8002f4:	41 ff d1             	call   *%r9

00000000008002f7 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8002f7:	55                   	push   %rbp
  8002f8:	48 89 e5             	mov    %rsp,%rbp
  8002fb:	53                   	push   %rbx
  8002fc:	48 83 ec 08          	sub    $0x8,%rsp
  800300:	89 f8                	mov    %edi,%eax
  800302:	49 89 f2             	mov    %rsi,%r10
  800305:	48 89 cf             	mov    %rcx,%rdi
  800308:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80030b:	48 63 da             	movslq %edx,%rbx
  80030e:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800311:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800316:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800319:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80031c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80031e:	48 85 c0             	test   %rax,%rax
  800321:	7f 06                	jg     800329 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  800323:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800327:	c9                   	leave  
  800328:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800329:	49 89 c0             	mov    %rax,%r8
  80032c:	b9 05 00 00 00       	mov    $0x5,%ecx
  800331:	48 ba c8 29 80 00 00 	movabs $0x8029c8,%rdx
  800338:	00 00 00 
  80033b:	be 26 00 00 00       	mov    $0x26,%esi
  800340:	48 bf e7 29 80 00 00 	movabs $0x8029e7,%rdi
  800347:	00 00 00 
  80034a:	b8 00 00 00 00       	mov    $0x0,%eax
  80034f:	49 b9 53 19 80 00 00 	movabs $0x801953,%r9
  800356:	00 00 00 
  800359:	41 ff d1             	call   *%r9

000000000080035c <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80035c:	55                   	push   %rbp
  80035d:	48 89 e5             	mov    %rsp,%rbp
  800360:	53                   	push   %rbx
  800361:	48 83 ec 08          	sub    $0x8,%rsp
  800365:	48 89 f1             	mov    %rsi,%rcx
  800368:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80036b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80036e:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800373:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800378:	be 00 00 00 00       	mov    $0x0,%esi
  80037d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800383:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800385:	48 85 c0             	test   %rax,%rax
  800388:	7f 06                	jg     800390 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80038a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800390:	49 89 c0             	mov    %rax,%r8
  800393:	b9 06 00 00 00       	mov    $0x6,%ecx
  800398:	48 ba c8 29 80 00 00 	movabs $0x8029c8,%rdx
  80039f:	00 00 00 
  8003a2:	be 26 00 00 00       	mov    $0x26,%esi
  8003a7:	48 bf e7 29 80 00 00 	movabs $0x8029e7,%rdi
  8003ae:	00 00 00 
  8003b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b6:	49 b9 53 19 80 00 00 	movabs $0x801953,%r9
  8003bd:	00 00 00 
  8003c0:	41 ff d1             	call   *%r9

00000000008003c3 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8003c3:	55                   	push   %rbp
  8003c4:	48 89 e5             	mov    %rsp,%rbp
  8003c7:	53                   	push   %rbx
  8003c8:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8003cc:	48 63 ce             	movslq %esi,%rcx
  8003cf:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8003d2:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8003d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003dc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003e1:	be 00 00 00 00       	mov    $0x0,%esi
  8003e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003ec:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003ee:	48 85 c0             	test   %rax,%rax
  8003f1:	7f 06                	jg     8003f9 <sys_env_set_status+0x36>
}
  8003f3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003f7:	c9                   	leave  
  8003f8:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003f9:	49 89 c0             	mov    %rax,%r8
  8003fc:	b9 09 00 00 00       	mov    $0x9,%ecx
  800401:	48 ba c8 29 80 00 00 	movabs $0x8029c8,%rdx
  800408:	00 00 00 
  80040b:	be 26 00 00 00       	mov    $0x26,%esi
  800410:	48 bf e7 29 80 00 00 	movabs $0x8029e7,%rdi
  800417:	00 00 00 
  80041a:	b8 00 00 00 00       	mov    $0x0,%eax
  80041f:	49 b9 53 19 80 00 00 	movabs $0x801953,%r9
  800426:	00 00 00 
  800429:	41 ff d1             	call   *%r9

000000000080042c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80042c:	55                   	push   %rbp
  80042d:	48 89 e5             	mov    %rsp,%rbp
  800430:	53                   	push   %rbx
  800431:	48 83 ec 08          	sub    $0x8,%rsp
  800435:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  800438:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80043b:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800440:	bb 00 00 00 00       	mov    $0x0,%ebx
  800445:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80044a:	be 00 00 00 00       	mov    $0x0,%esi
  80044f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800455:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800457:	48 85 c0             	test   %rax,%rax
  80045a:	7f 06                	jg     800462 <sys_env_set_trapframe+0x36>
}
  80045c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800460:	c9                   	leave  
  800461:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800462:	49 89 c0             	mov    %rax,%r8
  800465:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80046a:	48 ba c8 29 80 00 00 	movabs $0x8029c8,%rdx
  800471:	00 00 00 
  800474:	be 26 00 00 00       	mov    $0x26,%esi
  800479:	48 bf e7 29 80 00 00 	movabs $0x8029e7,%rdi
  800480:	00 00 00 
  800483:	b8 00 00 00 00       	mov    $0x0,%eax
  800488:	49 b9 53 19 80 00 00 	movabs $0x801953,%r9
  80048f:	00 00 00 
  800492:	41 ff d1             	call   *%r9

0000000000800495 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  800495:	55                   	push   %rbp
  800496:	48 89 e5             	mov    %rsp,%rbp
  800499:	53                   	push   %rbx
  80049a:	48 83 ec 08          	sub    $0x8,%rsp
  80049e:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8004a1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004a4:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004ae:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004b3:	be 00 00 00 00       	mov    $0x0,%esi
  8004b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004be:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004c0:	48 85 c0             	test   %rax,%rax
  8004c3:	7f 06                	jg     8004cb <sys_env_set_pgfault_upcall+0x36>
}
  8004c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004cb:	49 89 c0             	mov    %rax,%r8
  8004ce:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8004d3:	48 ba c8 29 80 00 00 	movabs $0x8029c8,%rdx
  8004da:	00 00 00 
  8004dd:	be 26 00 00 00       	mov    $0x26,%esi
  8004e2:	48 bf e7 29 80 00 00 	movabs $0x8029e7,%rdi
  8004e9:	00 00 00 
  8004ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f1:	49 b9 53 19 80 00 00 	movabs $0x801953,%r9
  8004f8:	00 00 00 
  8004fb:	41 ff d1             	call   *%r9

00000000008004fe <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8004fe:	55                   	push   %rbp
  8004ff:	48 89 e5             	mov    %rsp,%rbp
  800502:	53                   	push   %rbx
  800503:	89 f8                	mov    %edi,%eax
  800505:	49 89 f1             	mov    %rsi,%r9
  800508:	48 89 d3             	mov    %rdx,%rbx
  80050b:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80050e:	49 63 f0             	movslq %r8d,%rsi
  800511:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800514:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800519:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80051c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800522:	cd 30                	int    $0x30
}
  800524:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800528:	c9                   	leave  
  800529:	c3                   	ret    

000000000080052a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80052a:	55                   	push   %rbp
  80052b:	48 89 e5             	mov    %rsp,%rbp
  80052e:	53                   	push   %rbx
  80052f:	48 83 ec 08          	sub    $0x8,%rsp
  800533:	48 89 fa             	mov    %rdi,%rdx
  800536:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800539:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80053e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800543:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800548:	be 00 00 00 00       	mov    $0x0,%esi
  80054d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800553:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800555:	48 85 c0             	test   %rax,%rax
  800558:	7f 06                	jg     800560 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80055a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800560:	49 89 c0             	mov    %rax,%r8
  800563:	b9 0e 00 00 00       	mov    $0xe,%ecx
  800568:	48 ba c8 29 80 00 00 	movabs $0x8029c8,%rdx
  80056f:	00 00 00 
  800572:	be 26 00 00 00       	mov    $0x26,%esi
  800577:	48 bf e7 29 80 00 00 	movabs $0x8029e7,%rdi
  80057e:	00 00 00 
  800581:	b8 00 00 00 00       	mov    $0x0,%eax
  800586:	49 b9 53 19 80 00 00 	movabs $0x801953,%r9
  80058d:	00 00 00 
  800590:	41 ff d1             	call   *%r9

0000000000800593 <sys_gettime>:

int
sys_gettime(void) {
  800593:	55                   	push   %rbp
  800594:	48 89 e5             	mov    %rsp,%rbp
  800597:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800598:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80059d:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005ac:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005b1:	be 00 00 00 00       	mov    $0x0,%esi
  8005b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005bc:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8005be:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005c2:	c9                   	leave  
  8005c3:	c3                   	ret    

00000000008005c4 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8005c4:	55                   	push   %rbp
  8005c5:	48 89 e5             	mov    %rsp,%rbp
  8005c8:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005c9:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005dd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005e2:	be 00 00 00 00       	mov    $0x0,%esi
  8005e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005ed:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8005ef:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005f3:	c9                   	leave  
  8005f4:	c3                   	ret    

00000000008005f5 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8005f5:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8005fc:	ff ff ff 
  8005ff:	48 01 f8             	add    %rdi,%rax
  800602:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800606:	c3                   	ret    

0000000000800607 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800607:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80060e:	ff ff ff 
  800611:	48 01 f8             	add    %rdi,%rax
  800614:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  800618:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80061e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800622:	c3                   	ret    

0000000000800623 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  800623:	55                   	push   %rbp
  800624:	48 89 e5             	mov    %rsp,%rbp
  800627:	41 57                	push   %r15
  800629:	41 56                	push   %r14
  80062b:	41 55                	push   %r13
  80062d:	41 54                	push   %r12
  80062f:	53                   	push   %rbx
  800630:	48 83 ec 08          	sub    $0x8,%rsp
  800634:	49 89 ff             	mov    %rdi,%r15
  800637:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80063c:	49 bc d1 15 80 00 00 	movabs $0x8015d1,%r12
  800643:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  800646:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  80064c:	48 89 df             	mov    %rbx,%rdi
  80064f:	41 ff d4             	call   *%r12
  800652:	83 e0 04             	and    $0x4,%eax
  800655:	74 1a                	je     800671 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  800657:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80065e:	4c 39 f3             	cmp    %r14,%rbx
  800661:	75 e9                	jne    80064c <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  800663:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  80066a:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80066f:	eb 03                	jmp    800674 <fd_alloc+0x51>
            *fd_store = fd;
  800671:	49 89 1f             	mov    %rbx,(%r15)
}
  800674:	48 83 c4 08          	add    $0x8,%rsp
  800678:	5b                   	pop    %rbx
  800679:	41 5c                	pop    %r12
  80067b:	41 5d                	pop    %r13
  80067d:	41 5e                	pop    %r14
  80067f:	41 5f                	pop    %r15
  800681:	5d                   	pop    %rbp
  800682:	c3                   	ret    

0000000000800683 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  800683:	83 ff 1f             	cmp    $0x1f,%edi
  800686:	77 39                	ja     8006c1 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  800688:	55                   	push   %rbp
  800689:	48 89 e5             	mov    %rsp,%rbp
  80068c:	41 54                	push   %r12
  80068e:	53                   	push   %rbx
  80068f:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  800692:	48 63 df             	movslq %edi,%rbx
  800695:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80069c:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8006a0:	48 89 df             	mov    %rbx,%rdi
  8006a3:	48 b8 d1 15 80 00 00 	movabs $0x8015d1,%rax
  8006aa:	00 00 00 
  8006ad:	ff d0                	call   *%rax
  8006af:	a8 04                	test   $0x4,%al
  8006b1:	74 14                	je     8006c7 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8006b3:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8006b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006bc:	5b                   	pop    %rbx
  8006bd:	41 5c                	pop    %r12
  8006bf:	5d                   	pop    %rbp
  8006c0:	c3                   	ret    
        return -E_INVAL;
  8006c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006c6:	c3                   	ret    
        return -E_INVAL;
  8006c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006cc:	eb ee                	jmp    8006bc <fd_lookup+0x39>

00000000008006ce <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8006ce:	55                   	push   %rbp
  8006cf:	48 89 e5             	mov    %rsp,%rbp
  8006d2:	53                   	push   %rbx
  8006d3:	48 83 ec 08          	sub    $0x8,%rsp
  8006d7:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8006da:	48 ba 80 2a 80 00 00 	movabs $0x802a80,%rdx
  8006e1:	00 00 00 
  8006e4:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8006eb:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8006ee:	39 38                	cmp    %edi,(%rax)
  8006f0:	74 4b                	je     80073d <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8006f2:	48 83 c2 08          	add    $0x8,%rdx
  8006f6:	48 8b 02             	mov    (%rdx),%rax
  8006f9:	48 85 c0             	test   %rax,%rax
  8006fc:	75 f0                	jne    8006ee <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8006fe:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800705:	00 00 00 
  800708:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80070e:	89 fa                	mov    %edi,%edx
  800710:	48 bf f8 29 80 00 00 	movabs $0x8029f8,%rdi
  800717:	00 00 00 
  80071a:	b8 00 00 00 00       	mov    $0x0,%eax
  80071f:	48 b9 a3 1a 80 00 00 	movabs $0x801aa3,%rcx
  800726:	00 00 00 
  800729:	ff d1                	call   *%rcx
    *dev = 0;
  80072b:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  800732:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800737:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    
            *dev = devtab[i];
  80073d:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  800740:	b8 00 00 00 00       	mov    $0x0,%eax
  800745:	eb f0                	jmp    800737 <dev_lookup+0x69>

0000000000800747 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  800747:	55                   	push   %rbp
  800748:	48 89 e5             	mov    %rsp,%rbp
  80074b:	41 55                	push   %r13
  80074d:	41 54                	push   %r12
  80074f:	53                   	push   %rbx
  800750:	48 83 ec 18          	sub    $0x18,%rsp
  800754:	49 89 fc             	mov    %rdi,%r12
  800757:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80075a:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  800761:	ff ff ff 
  800764:	4c 01 e7             	add    %r12,%rdi
  800767:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80076b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80076f:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  800776:	00 00 00 
  800779:	ff d0                	call   *%rax
  80077b:	89 c3                	mov    %eax,%ebx
  80077d:	85 c0                	test   %eax,%eax
  80077f:	78 06                	js     800787 <fd_close+0x40>
  800781:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  800785:	74 18                	je     80079f <fd_close+0x58>
        return (must_exist ? res : 0);
  800787:	45 84 ed             	test   %r13b,%r13b
  80078a:	b8 00 00 00 00       	mov    $0x0,%eax
  80078f:	0f 44 d8             	cmove  %eax,%ebx
}
  800792:	89 d8                	mov    %ebx,%eax
  800794:	48 83 c4 18          	add    $0x18,%rsp
  800798:	5b                   	pop    %rbx
  800799:	41 5c                	pop    %r12
  80079b:	41 5d                	pop    %r13
  80079d:	5d                   	pop    %rbp
  80079e:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80079f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8007a3:	41 8b 3c 24          	mov    (%r12),%edi
  8007a7:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	call   *%rax
  8007b3:	89 c3                	mov    %eax,%ebx
  8007b5:	85 c0                	test   %eax,%eax
  8007b7:	78 19                	js     8007d2 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8007b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8007bd:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007c6:	48 85 c0             	test   %rax,%rax
  8007c9:	74 07                	je     8007d2 <fd_close+0x8b>
  8007cb:	4c 89 e7             	mov    %r12,%rdi
  8007ce:	ff d0                	call   *%rax
  8007d0:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8007d2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8007d7:	4c 89 e6             	mov    %r12,%rsi
  8007da:	bf 00 00 00 00       	mov    $0x0,%edi
  8007df:	48 b8 5c 03 80 00 00 	movabs $0x80035c,%rax
  8007e6:	00 00 00 
  8007e9:	ff d0                	call   *%rax
    return res;
  8007eb:	eb a5                	jmp    800792 <fd_close+0x4b>

00000000008007ed <close>:

int
close(int fdnum) {
  8007ed:	55                   	push   %rbp
  8007ee:	48 89 e5             	mov    %rsp,%rbp
  8007f1:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8007f5:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8007f9:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  800800:	00 00 00 
  800803:	ff d0                	call   *%rax
    if (res < 0) return res;
  800805:	85 c0                	test   %eax,%eax
  800807:	78 15                	js     80081e <close+0x31>

    return fd_close(fd, 1);
  800809:	be 01 00 00 00       	mov    $0x1,%esi
  80080e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800812:	48 b8 47 07 80 00 00 	movabs $0x800747,%rax
  800819:	00 00 00 
  80081c:	ff d0                	call   *%rax
}
  80081e:	c9                   	leave  
  80081f:	c3                   	ret    

0000000000800820 <close_all>:

void
close_all(void) {
  800820:	55                   	push   %rbp
  800821:	48 89 e5             	mov    %rsp,%rbp
  800824:	41 54                	push   %r12
  800826:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  800827:	bb 00 00 00 00       	mov    $0x0,%ebx
  80082c:	49 bc ed 07 80 00 00 	movabs $0x8007ed,%r12
  800833:	00 00 00 
  800836:	89 df                	mov    %ebx,%edi
  800838:	41 ff d4             	call   *%r12
  80083b:	83 c3 01             	add    $0x1,%ebx
  80083e:	83 fb 20             	cmp    $0x20,%ebx
  800841:	75 f3                	jne    800836 <close_all+0x16>
}
  800843:	5b                   	pop    %rbx
  800844:	41 5c                	pop    %r12
  800846:	5d                   	pop    %rbp
  800847:	c3                   	ret    

0000000000800848 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  800848:	55                   	push   %rbp
  800849:	48 89 e5             	mov    %rsp,%rbp
  80084c:	41 56                	push   %r14
  80084e:	41 55                	push   %r13
  800850:	41 54                	push   %r12
  800852:	53                   	push   %rbx
  800853:	48 83 ec 10          	sub    $0x10,%rsp
  800857:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80085a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80085e:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  800865:	00 00 00 
  800868:	ff d0                	call   *%rax
  80086a:	89 c3                	mov    %eax,%ebx
  80086c:	85 c0                	test   %eax,%eax
  80086e:	0f 88 b7 00 00 00    	js     80092b <dup+0xe3>
    close(newfdnum);
  800874:	44 89 e7             	mov    %r12d,%edi
  800877:	48 b8 ed 07 80 00 00 	movabs $0x8007ed,%rax
  80087e:	00 00 00 
  800881:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800883:	4d 63 ec             	movslq %r12d,%r13
  800886:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80088d:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  800891:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800895:	49 be 07 06 80 00 00 	movabs $0x800607,%r14
  80089c:	00 00 00 
  80089f:	41 ff d6             	call   *%r14
  8008a2:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8008a5:	4c 89 ef             	mov    %r13,%rdi
  8008a8:	41 ff d6             	call   *%r14
  8008ab:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8008ae:	48 89 df             	mov    %rbx,%rdi
  8008b1:	48 b8 d1 15 80 00 00 	movabs $0x8015d1,%rax
  8008b8:	00 00 00 
  8008bb:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8008bd:	a8 04                	test   $0x4,%al
  8008bf:	74 2b                	je     8008ec <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8008c1:	41 89 c1             	mov    %eax,%r9d
  8008c4:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8008ca:	4c 89 f1             	mov    %r14,%rcx
  8008cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d2:	48 89 de             	mov    %rbx,%rsi
  8008d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8008da:	48 b8 f7 02 80 00 00 	movabs $0x8002f7,%rax
  8008e1:	00 00 00 
  8008e4:	ff d0                	call   *%rax
  8008e6:	89 c3                	mov    %eax,%ebx
  8008e8:	85 c0                	test   %eax,%eax
  8008ea:	78 4e                	js     80093a <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8008ec:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8008f0:	48 b8 d1 15 80 00 00 	movabs $0x8015d1,%rax
  8008f7:	00 00 00 
  8008fa:	ff d0                	call   *%rax
  8008fc:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8008ff:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800905:	4c 89 e9             	mov    %r13,%rcx
  800908:	ba 00 00 00 00       	mov    $0x0,%edx
  80090d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800911:	bf 00 00 00 00       	mov    $0x0,%edi
  800916:	48 b8 f7 02 80 00 00 	movabs $0x8002f7,%rax
  80091d:	00 00 00 
  800920:	ff d0                	call   *%rax
  800922:	89 c3                	mov    %eax,%ebx
  800924:	85 c0                	test   %eax,%eax
  800926:	78 12                	js     80093a <dup+0xf2>

    return newfdnum;
  800928:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80092b:	89 d8                	mov    %ebx,%eax
  80092d:	48 83 c4 10          	add    $0x10,%rsp
  800931:	5b                   	pop    %rbx
  800932:	41 5c                	pop    %r12
  800934:	41 5d                	pop    %r13
  800936:	41 5e                	pop    %r14
  800938:	5d                   	pop    %rbp
  800939:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80093a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80093f:	4c 89 ee             	mov    %r13,%rsi
  800942:	bf 00 00 00 00       	mov    $0x0,%edi
  800947:	49 bc 5c 03 80 00 00 	movabs $0x80035c,%r12
  80094e:	00 00 00 
  800951:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  800954:	ba 00 10 00 00       	mov    $0x1000,%edx
  800959:	4c 89 f6             	mov    %r14,%rsi
  80095c:	bf 00 00 00 00       	mov    $0x0,%edi
  800961:	41 ff d4             	call   *%r12
    return res;
  800964:	eb c5                	jmp    80092b <dup+0xe3>

0000000000800966 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800966:	55                   	push   %rbp
  800967:	48 89 e5             	mov    %rsp,%rbp
  80096a:	41 55                	push   %r13
  80096c:	41 54                	push   %r12
  80096e:	53                   	push   %rbx
  80096f:	48 83 ec 18          	sub    $0x18,%rsp
  800973:	89 fb                	mov    %edi,%ebx
  800975:	49 89 f4             	mov    %rsi,%r12
  800978:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80097b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80097f:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  800986:	00 00 00 
  800989:	ff d0                	call   *%rax
  80098b:	85 c0                	test   %eax,%eax
  80098d:	78 49                	js     8009d8 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80098f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800993:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800997:	8b 38                	mov    (%rax),%edi
  800999:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  8009a0:	00 00 00 
  8009a3:	ff d0                	call   *%rax
  8009a5:	85 c0                	test   %eax,%eax
  8009a7:	78 33                	js     8009dc <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8009a9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8009ad:	8b 47 08             	mov    0x8(%rdi),%eax
  8009b0:	83 e0 03             	and    $0x3,%eax
  8009b3:	83 f8 01             	cmp    $0x1,%eax
  8009b6:	74 28                	je     8009e0 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8009b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009bc:	48 8b 40 10          	mov    0x10(%rax),%rax
  8009c0:	48 85 c0             	test   %rax,%rax
  8009c3:	74 51                	je     800a16 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8009c5:	4c 89 ea             	mov    %r13,%rdx
  8009c8:	4c 89 e6             	mov    %r12,%rsi
  8009cb:	ff d0                	call   *%rax
}
  8009cd:	48 83 c4 18          	add    $0x18,%rsp
  8009d1:	5b                   	pop    %rbx
  8009d2:	41 5c                	pop    %r12
  8009d4:	41 5d                	pop    %r13
  8009d6:	5d                   	pop    %rbp
  8009d7:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8009d8:	48 98                	cltq   
  8009da:	eb f1                	jmp    8009cd <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8009dc:	48 98                	cltq   
  8009de:	eb ed                	jmp    8009cd <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8009e0:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8009e7:	00 00 00 
  8009ea:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8009f0:	89 da                	mov    %ebx,%edx
  8009f2:	48 bf 39 2a 80 00 00 	movabs $0x802a39,%rdi
  8009f9:	00 00 00 
  8009fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800a01:	48 b9 a3 1a 80 00 00 	movabs $0x801aa3,%rcx
  800a08:	00 00 00 
  800a0b:	ff d1                	call   *%rcx
        return -E_INVAL;
  800a0d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800a14:	eb b7                	jmp    8009cd <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800a16:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800a1d:	eb ae                	jmp    8009cd <read+0x67>

0000000000800a1f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800a1f:	55                   	push   %rbp
  800a20:	48 89 e5             	mov    %rsp,%rbp
  800a23:	41 57                	push   %r15
  800a25:	41 56                	push   %r14
  800a27:	41 55                	push   %r13
  800a29:	41 54                	push   %r12
  800a2b:	53                   	push   %rbx
  800a2c:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800a30:	48 85 d2             	test   %rdx,%rdx
  800a33:	74 54                	je     800a89 <readn+0x6a>
  800a35:	41 89 fd             	mov    %edi,%r13d
  800a38:	49 89 f6             	mov    %rsi,%r14
  800a3b:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800a3e:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800a43:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800a48:	49 bf 66 09 80 00 00 	movabs $0x800966,%r15
  800a4f:	00 00 00 
  800a52:	4c 89 e2             	mov    %r12,%rdx
  800a55:	48 29 f2             	sub    %rsi,%rdx
  800a58:	4c 01 f6             	add    %r14,%rsi
  800a5b:	44 89 ef             	mov    %r13d,%edi
  800a5e:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800a61:	85 c0                	test   %eax,%eax
  800a63:	78 20                	js     800a85 <readn+0x66>
    for (; inc && res < n; res += inc) {
  800a65:	01 c3                	add    %eax,%ebx
  800a67:	85 c0                	test   %eax,%eax
  800a69:	74 08                	je     800a73 <readn+0x54>
  800a6b:	48 63 f3             	movslq %ebx,%rsi
  800a6e:	4c 39 e6             	cmp    %r12,%rsi
  800a71:	72 df                	jb     800a52 <readn+0x33>
    }
    return res;
  800a73:	48 63 c3             	movslq %ebx,%rax
}
  800a76:	48 83 c4 08          	add    $0x8,%rsp
  800a7a:	5b                   	pop    %rbx
  800a7b:	41 5c                	pop    %r12
  800a7d:	41 5d                	pop    %r13
  800a7f:	41 5e                	pop    %r14
  800a81:	41 5f                	pop    %r15
  800a83:	5d                   	pop    %rbp
  800a84:	c3                   	ret    
        if (inc < 0) return inc;
  800a85:	48 98                	cltq   
  800a87:	eb ed                	jmp    800a76 <readn+0x57>
    int inc = 1, res = 0;
  800a89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a8e:	eb e3                	jmp    800a73 <readn+0x54>

0000000000800a90 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800a90:	55                   	push   %rbp
  800a91:	48 89 e5             	mov    %rsp,%rbp
  800a94:	41 55                	push   %r13
  800a96:	41 54                	push   %r12
  800a98:	53                   	push   %rbx
  800a99:	48 83 ec 18          	sub    $0x18,%rsp
  800a9d:	89 fb                	mov    %edi,%ebx
  800a9f:	49 89 f4             	mov    %rsi,%r12
  800aa2:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800aa5:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800aa9:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  800ab0:	00 00 00 
  800ab3:	ff d0                	call   *%rax
  800ab5:	85 c0                	test   %eax,%eax
  800ab7:	78 44                	js     800afd <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800ab9:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800abd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ac1:	8b 38                	mov    (%rax),%edi
  800ac3:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	call   *%rax
  800acf:	85 c0                	test   %eax,%eax
  800ad1:	78 2e                	js     800b01 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ad3:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ad7:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800adb:	74 28                	je     800b05 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800add:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ae1:	48 8b 40 18          	mov    0x18(%rax),%rax
  800ae5:	48 85 c0             	test   %rax,%rax
  800ae8:	74 51                	je     800b3b <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  800aea:	4c 89 ea             	mov    %r13,%rdx
  800aed:	4c 89 e6             	mov    %r12,%rsi
  800af0:	ff d0                	call   *%rax
}
  800af2:	48 83 c4 18          	add    $0x18,%rsp
  800af6:	5b                   	pop    %rbx
  800af7:	41 5c                	pop    %r12
  800af9:	41 5d                	pop    %r13
  800afb:	5d                   	pop    %rbp
  800afc:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800afd:	48 98                	cltq   
  800aff:	eb f1                	jmp    800af2 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b01:	48 98                	cltq   
  800b03:	eb ed                	jmp    800af2 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b05:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800b0c:	00 00 00 
  800b0f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800b15:	89 da                	mov    %ebx,%edx
  800b17:	48 bf 55 2a 80 00 00 	movabs $0x802a55,%rdi
  800b1e:	00 00 00 
  800b21:	b8 00 00 00 00       	mov    $0x0,%eax
  800b26:	48 b9 a3 1a 80 00 00 	movabs $0x801aa3,%rcx
  800b2d:	00 00 00 
  800b30:	ff d1                	call   *%rcx
        return -E_INVAL;
  800b32:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800b39:	eb b7                	jmp    800af2 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800b3b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800b42:	eb ae                	jmp    800af2 <write+0x62>

0000000000800b44 <seek>:

int
seek(int fdnum, off_t offset) {
  800b44:	55                   	push   %rbp
  800b45:	48 89 e5             	mov    %rsp,%rbp
  800b48:	53                   	push   %rbx
  800b49:	48 83 ec 18          	sub    $0x18,%rsp
  800b4d:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b4f:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b53:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  800b5a:	00 00 00 
  800b5d:	ff d0                	call   *%rax
  800b5f:	85 c0                	test   %eax,%eax
  800b61:	78 0c                	js     800b6f <seek+0x2b>

    fd->fd_offset = offset;
  800b63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b67:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800b6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800b73:	c9                   	leave  
  800b74:	c3                   	ret    

0000000000800b75 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800b75:	55                   	push   %rbp
  800b76:	48 89 e5             	mov    %rsp,%rbp
  800b79:	41 54                	push   %r12
  800b7b:	53                   	push   %rbx
  800b7c:	48 83 ec 10          	sub    $0x10,%rsp
  800b80:	89 fb                	mov    %edi,%ebx
  800b82:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b85:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b89:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  800b90:	00 00 00 
  800b93:	ff d0                	call   *%rax
  800b95:	85 c0                	test   %eax,%eax
  800b97:	78 36                	js     800bcf <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b99:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba1:	8b 38                	mov    (%rax),%edi
  800ba3:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  800baa:	00 00 00 
  800bad:	ff d0                	call   *%rax
  800baf:	85 c0                	test   %eax,%eax
  800bb1:	78 1c                	js     800bcf <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bb3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800bb7:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800bbb:	74 1b                	je     800bd8 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800bbd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800bc1:	48 8b 40 30          	mov    0x30(%rax),%rax
  800bc5:	48 85 c0             	test   %rax,%rax
  800bc8:	74 42                	je     800c0c <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  800bca:	44 89 e6             	mov    %r12d,%esi
  800bcd:	ff d0                	call   *%rax
}
  800bcf:	48 83 c4 10          	add    $0x10,%rsp
  800bd3:	5b                   	pop    %rbx
  800bd4:	41 5c                	pop    %r12
  800bd6:	5d                   	pop    %rbp
  800bd7:	c3                   	ret    
                thisenv->env_id, fdnum);
  800bd8:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bdf:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800be2:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800be8:	89 da                	mov    %ebx,%edx
  800bea:	48 bf 18 2a 80 00 00 	movabs $0x802a18,%rdi
  800bf1:	00 00 00 
  800bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf9:	48 b9 a3 1a 80 00 00 	movabs $0x801aa3,%rcx
  800c00:	00 00 00 
  800c03:	ff d1                	call   *%rcx
        return -E_INVAL;
  800c05:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c0a:	eb c3                	jmp    800bcf <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c0c:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c11:	eb bc                	jmp    800bcf <ftruncate+0x5a>

0000000000800c13 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800c13:	55                   	push   %rbp
  800c14:	48 89 e5             	mov    %rsp,%rbp
  800c17:	53                   	push   %rbx
  800c18:	48 83 ec 18          	sub    $0x18,%rsp
  800c1c:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c1f:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c23:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  800c2a:	00 00 00 
  800c2d:	ff d0                	call   *%rax
  800c2f:	85 c0                	test   %eax,%eax
  800c31:	78 4d                	js     800c80 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c33:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800c37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c3b:	8b 38                	mov    (%rax),%edi
  800c3d:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  800c44:	00 00 00 
  800c47:	ff d0                	call   *%rax
  800c49:	85 c0                	test   %eax,%eax
  800c4b:	78 33                	js     800c80 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c51:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800c56:	74 2e                	je     800c86 <fstat+0x73>

    stat->st_name[0] = 0;
  800c58:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800c5b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800c62:	00 00 00 
    stat->st_isdir = 0;
  800c65:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800c6c:	00 00 00 
    stat->st_dev = dev;
  800c6f:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800c76:	48 89 de             	mov    %rbx,%rsi
  800c79:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c7d:	ff 50 28             	call   *0x28(%rax)
}
  800c80:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c86:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c8b:	eb f3                	jmp    800c80 <fstat+0x6d>

0000000000800c8d <stat>:

int
stat(const char *path, struct Stat *stat) {
  800c8d:	55                   	push   %rbp
  800c8e:	48 89 e5             	mov    %rsp,%rbp
  800c91:	41 54                	push   %r12
  800c93:	53                   	push   %rbx
  800c94:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800c97:	be 00 00 00 00       	mov    $0x0,%esi
  800c9c:	48 b8 58 0f 80 00 00 	movabs $0x800f58,%rax
  800ca3:	00 00 00 
  800ca6:	ff d0                	call   *%rax
  800ca8:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800caa:	85 c0                	test   %eax,%eax
  800cac:	78 25                	js     800cd3 <stat+0x46>

    int res = fstat(fd, stat);
  800cae:	4c 89 e6             	mov    %r12,%rsi
  800cb1:	89 c7                	mov    %eax,%edi
  800cb3:	48 b8 13 0c 80 00 00 	movabs $0x800c13,%rax
  800cba:	00 00 00 
  800cbd:	ff d0                	call   *%rax
  800cbf:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800cc2:	89 df                	mov    %ebx,%edi
  800cc4:	48 b8 ed 07 80 00 00 	movabs $0x8007ed,%rax
  800ccb:	00 00 00 
  800cce:	ff d0                	call   *%rax

    return res;
  800cd0:	44 89 e3             	mov    %r12d,%ebx
}
  800cd3:	89 d8                	mov    %ebx,%eax
  800cd5:	5b                   	pop    %rbx
  800cd6:	41 5c                	pop    %r12
  800cd8:	5d                   	pop    %rbp
  800cd9:	c3                   	ret    

0000000000800cda <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800cda:	55                   	push   %rbp
  800cdb:	48 89 e5             	mov    %rsp,%rbp
  800cde:	41 54                	push   %r12
  800ce0:	53                   	push   %rbx
  800ce1:	48 83 ec 10          	sub    $0x10,%rsp
  800ce5:	41 89 fc             	mov    %edi,%r12d
  800ce8:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800ceb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800cf2:	00 00 00 
  800cf5:	83 38 00             	cmpl   $0x0,(%rax)
  800cf8:	74 5e                	je     800d58 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800cfa:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800d00:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800d05:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800d0c:	00 00 00 
  800d0f:	44 89 e6             	mov    %r12d,%esi
  800d12:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d19:	00 00 00 
  800d1c:	8b 38                	mov    (%rax),%edi
  800d1e:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  800d25:	00 00 00 
  800d28:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800d2a:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800d31:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800d32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d37:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d3b:	48 89 de             	mov    %rbx,%rsi
  800d3e:	bf 00 00 00 00       	mov    $0x0,%edi
  800d43:	48 b8 15 28 80 00 00 	movabs $0x802815,%rax
  800d4a:	00 00 00 
  800d4d:	ff d0                	call   *%rax
}
  800d4f:	48 83 c4 10          	add    $0x10,%rsp
  800d53:	5b                   	pop    %rbx
  800d54:	41 5c                	pop    %r12
  800d56:	5d                   	pop    %rbp
  800d57:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800d58:	bf 03 00 00 00       	mov    $0x3,%edi
  800d5d:	48 b8 57 29 80 00 00 	movabs $0x802957,%rax
  800d64:	00 00 00 
  800d67:	ff d0                	call   *%rax
  800d69:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800d70:	00 00 
  800d72:	eb 86                	jmp    800cfa <fsipc+0x20>

0000000000800d74 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800d74:	55                   	push   %rbp
  800d75:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d78:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800d7f:	00 00 00 
  800d82:	8b 57 0c             	mov    0xc(%rdi),%edx
  800d85:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800d87:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800d8a:	be 00 00 00 00       	mov    $0x0,%esi
  800d8f:	bf 02 00 00 00       	mov    $0x2,%edi
  800d94:	48 b8 da 0c 80 00 00 	movabs $0x800cda,%rax
  800d9b:	00 00 00 
  800d9e:	ff d0                	call   *%rax
}
  800da0:	5d                   	pop    %rbp
  800da1:	c3                   	ret    

0000000000800da2 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800da2:	55                   	push   %rbp
  800da3:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800da6:	8b 47 0c             	mov    0xc(%rdi),%eax
  800da9:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800db0:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800db2:	be 00 00 00 00       	mov    $0x0,%esi
  800db7:	bf 06 00 00 00       	mov    $0x6,%edi
  800dbc:	48 b8 da 0c 80 00 00 	movabs $0x800cda,%rax
  800dc3:	00 00 00 
  800dc6:	ff d0                	call   *%rax
}
  800dc8:	5d                   	pop    %rbp
  800dc9:	c3                   	ret    

0000000000800dca <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800dca:	55                   	push   %rbp
  800dcb:	48 89 e5             	mov    %rsp,%rbp
  800dce:	53                   	push   %rbx
  800dcf:	48 83 ec 08          	sub    $0x8,%rsp
  800dd3:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800dd6:	8b 47 0c             	mov    0xc(%rdi),%eax
  800dd9:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800de0:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800de2:	be 00 00 00 00       	mov    $0x0,%esi
  800de7:	bf 05 00 00 00       	mov    $0x5,%edi
  800dec:	48 b8 da 0c 80 00 00 	movabs $0x800cda,%rax
  800df3:	00 00 00 
  800df6:	ff d0                	call   *%rax
    if (res < 0) return res;
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	78 40                	js     800e3c <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800dfc:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800e03:	00 00 00 
  800e06:	48 89 df             	mov    %rbx,%rdi
  800e09:	48 b8 e4 23 80 00 00 	movabs $0x8023e4,%rax
  800e10:	00 00 00 
  800e13:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800e15:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e1c:	00 00 00 
  800e1f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  800e25:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e2b:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  800e31:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800e37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e3c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

0000000000800e42 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800e42:	55                   	push   %rbp
  800e43:	48 89 e5             	mov    %rsp,%rbp
  800e46:	41 57                	push   %r15
  800e48:	41 56                	push   %r14
  800e4a:	41 55                	push   %r13
  800e4c:	41 54                	push   %r12
  800e4e:	53                   	push   %rbx
  800e4f:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  800e53:	48 85 d2             	test   %rdx,%rdx
  800e56:	0f 84 91 00 00 00    	je     800eed <devfile_write+0xab>
  800e5c:	49 89 ff             	mov    %rdi,%r15
  800e5f:	49 89 f4             	mov    %rsi,%r12
  800e62:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  800e65:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e6c:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  800e73:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  800e76:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  800e7d:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  800e83:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  800e87:	4c 89 ea             	mov    %r13,%rdx
  800e8a:	4c 89 e6             	mov    %r12,%rsi
  800e8d:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  800e94:	00 00 00 
  800e97:	48 b8 44 26 80 00 00 	movabs $0x802644,%rax
  800e9e:	00 00 00 
  800ea1:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800ea3:	41 8b 47 0c          	mov    0xc(%r15),%eax
  800ea7:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  800eaa:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  800eae:	be 00 00 00 00       	mov    $0x0,%esi
  800eb3:	bf 04 00 00 00       	mov    $0x4,%edi
  800eb8:	48 b8 da 0c 80 00 00 	movabs $0x800cda,%rax
  800ebf:	00 00 00 
  800ec2:	ff d0                	call   *%rax
        if (res < 0)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	78 21                	js     800ee9 <devfile_write+0xa7>
        buf += res;
  800ec8:	48 63 d0             	movslq %eax,%rdx
  800ecb:	49 01 d4             	add    %rdx,%r12
        ext += res;
  800ece:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  800ed1:	48 29 d3             	sub    %rdx,%rbx
  800ed4:	75 a0                	jne    800e76 <devfile_write+0x34>
    return ext;
  800ed6:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  800eda:	48 83 c4 18          	add    $0x18,%rsp
  800ede:	5b                   	pop    %rbx
  800edf:	41 5c                	pop    %r12
  800ee1:	41 5d                	pop    %r13
  800ee3:	41 5e                	pop    %r14
  800ee5:	41 5f                	pop    %r15
  800ee7:	5d                   	pop    %rbp
  800ee8:	c3                   	ret    
            return res;
  800ee9:	48 98                	cltq   
  800eeb:	eb ed                	jmp    800eda <devfile_write+0x98>
    int ext = 0;
  800eed:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  800ef4:	eb e0                	jmp    800ed6 <devfile_write+0x94>

0000000000800ef6 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800ef6:	55                   	push   %rbp
  800ef7:	48 89 e5             	mov    %rsp,%rbp
  800efa:	41 54                	push   %r12
  800efc:	53                   	push   %rbx
  800efd:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800f00:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f07:	00 00 00 
  800f0a:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f0d:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  800f0f:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  800f13:	be 00 00 00 00       	mov    $0x0,%esi
  800f18:	bf 03 00 00 00       	mov    $0x3,%edi
  800f1d:	48 b8 da 0c 80 00 00 	movabs $0x800cda,%rax
  800f24:	00 00 00 
  800f27:	ff d0                	call   *%rax
    if (read < 0) 
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	78 27                	js     800f54 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  800f2d:	48 63 d8             	movslq %eax,%rbx
  800f30:	48 89 da             	mov    %rbx,%rdx
  800f33:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800f3a:	00 00 00 
  800f3d:	4c 89 e7             	mov    %r12,%rdi
  800f40:	48 b8 df 25 80 00 00 	movabs $0x8025df,%rax
  800f47:	00 00 00 
  800f4a:	ff d0                	call   *%rax
    return read;
  800f4c:	48 89 d8             	mov    %rbx,%rax
}
  800f4f:	5b                   	pop    %rbx
  800f50:	41 5c                	pop    %r12
  800f52:	5d                   	pop    %rbp
  800f53:	c3                   	ret    
		return read;
  800f54:	48 98                	cltq   
  800f56:	eb f7                	jmp    800f4f <devfile_read+0x59>

0000000000800f58 <open>:
open(const char *path, int mode) {
  800f58:	55                   	push   %rbp
  800f59:	48 89 e5             	mov    %rsp,%rbp
  800f5c:	41 55                	push   %r13
  800f5e:	41 54                	push   %r12
  800f60:	53                   	push   %rbx
  800f61:	48 83 ec 18          	sub    $0x18,%rsp
  800f65:	49 89 fc             	mov    %rdi,%r12
  800f68:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  800f6b:	48 b8 ab 23 80 00 00 	movabs $0x8023ab,%rax
  800f72:	00 00 00 
  800f75:	ff d0                	call   *%rax
  800f77:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  800f7d:	0f 87 8c 00 00 00    	ja     80100f <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  800f83:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  800f87:	48 b8 23 06 80 00 00 	movabs $0x800623,%rax
  800f8e:	00 00 00 
  800f91:	ff d0                	call   *%rax
  800f93:	89 c3                	mov    %eax,%ebx
  800f95:	85 c0                	test   %eax,%eax
  800f97:	78 52                	js     800feb <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  800f99:	4c 89 e6             	mov    %r12,%rsi
  800f9c:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  800fa3:	00 00 00 
  800fa6:	48 b8 e4 23 80 00 00 	movabs $0x8023e4,%rax
  800fad:	00 00 00 
  800fb0:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  800fb2:	44 89 e8             	mov    %r13d,%eax
  800fb5:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  800fbc:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fbe:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800fc2:	bf 01 00 00 00       	mov    $0x1,%edi
  800fc7:	48 b8 da 0c 80 00 00 	movabs $0x800cda,%rax
  800fce:	00 00 00 
  800fd1:	ff d0                	call   *%rax
  800fd3:	89 c3                	mov    %eax,%ebx
  800fd5:	85 c0                	test   %eax,%eax
  800fd7:	78 1f                	js     800ff8 <open+0xa0>
    return fd2num(fd);
  800fd9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800fdd:	48 b8 f5 05 80 00 00 	movabs $0x8005f5,%rax
  800fe4:	00 00 00 
  800fe7:	ff d0                	call   *%rax
  800fe9:	89 c3                	mov    %eax,%ebx
}
  800feb:	89 d8                	mov    %ebx,%eax
  800fed:	48 83 c4 18          	add    $0x18,%rsp
  800ff1:	5b                   	pop    %rbx
  800ff2:	41 5c                	pop    %r12
  800ff4:	41 5d                	pop    %r13
  800ff6:	5d                   	pop    %rbp
  800ff7:	c3                   	ret    
        fd_close(fd, 0);
  800ff8:	be 00 00 00 00       	mov    $0x0,%esi
  800ffd:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801001:	48 b8 47 07 80 00 00 	movabs $0x800747,%rax
  801008:	00 00 00 
  80100b:	ff d0                	call   *%rax
        return res;
  80100d:	eb dc                	jmp    800feb <open+0x93>
        return -E_BAD_PATH;
  80100f:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801014:	eb d5                	jmp    800feb <open+0x93>

0000000000801016 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801016:	55                   	push   %rbp
  801017:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80101a:	be 00 00 00 00       	mov    $0x0,%esi
  80101f:	bf 08 00 00 00       	mov    $0x8,%edi
  801024:	48 b8 da 0c 80 00 00 	movabs $0x800cda,%rax
  80102b:	00 00 00 
  80102e:	ff d0                	call   *%rax
}
  801030:	5d                   	pop    %rbp
  801031:	c3                   	ret    

0000000000801032 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801032:	55                   	push   %rbp
  801033:	48 89 e5             	mov    %rsp,%rbp
  801036:	41 54                	push   %r12
  801038:	53                   	push   %rbx
  801039:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80103c:	48 b8 07 06 80 00 00 	movabs $0x800607,%rax
  801043:	00 00 00 
  801046:	ff d0                	call   *%rax
  801048:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80104b:	48 be a0 2a 80 00 00 	movabs $0x802aa0,%rsi
  801052:	00 00 00 
  801055:	48 89 df             	mov    %rbx,%rdi
  801058:	48 b8 e4 23 80 00 00 	movabs $0x8023e4,%rax
  80105f:	00 00 00 
  801062:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801064:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801069:	41 2b 04 24          	sub    (%r12),%eax
  80106d:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801073:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80107a:	00 00 00 
    stat->st_dev = &devpipe;
  80107d:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801084:	00 00 00 
  801087:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80108e:	b8 00 00 00 00       	mov    $0x0,%eax
  801093:	5b                   	pop    %rbx
  801094:	41 5c                	pop    %r12
  801096:	5d                   	pop    %rbp
  801097:	c3                   	ret    

0000000000801098 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801098:	55                   	push   %rbp
  801099:	48 89 e5             	mov    %rsp,%rbp
  80109c:	41 54                	push   %r12
  80109e:	53                   	push   %rbx
  80109f:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8010a2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010a7:	48 89 fe             	mov    %rdi,%rsi
  8010aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8010af:	49 bc 5c 03 80 00 00 	movabs $0x80035c,%r12
  8010b6:	00 00 00 
  8010b9:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8010bc:	48 89 df             	mov    %rbx,%rdi
  8010bf:	48 b8 07 06 80 00 00 	movabs $0x800607,%rax
  8010c6:	00 00 00 
  8010c9:	ff d0                	call   *%rax
  8010cb:	48 89 c6             	mov    %rax,%rsi
  8010ce:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8010d8:	41 ff d4             	call   *%r12
}
  8010db:	5b                   	pop    %rbx
  8010dc:	41 5c                	pop    %r12
  8010de:	5d                   	pop    %rbp
  8010df:	c3                   	ret    

00000000008010e0 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8010e0:	55                   	push   %rbp
  8010e1:	48 89 e5             	mov    %rsp,%rbp
  8010e4:	41 57                	push   %r15
  8010e6:	41 56                	push   %r14
  8010e8:	41 55                	push   %r13
  8010ea:	41 54                	push   %r12
  8010ec:	53                   	push   %rbx
  8010ed:	48 83 ec 18          	sub    $0x18,%rsp
  8010f1:	49 89 fc             	mov    %rdi,%r12
  8010f4:	49 89 f5             	mov    %rsi,%r13
  8010f7:	49 89 d7             	mov    %rdx,%r15
  8010fa:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8010fe:	48 b8 07 06 80 00 00 	movabs $0x800607,%rax
  801105:	00 00 00 
  801108:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80110a:	4d 85 ff             	test   %r15,%r15
  80110d:	0f 84 ac 00 00 00    	je     8011bf <devpipe_write+0xdf>
  801113:	48 89 c3             	mov    %rax,%rbx
  801116:	4c 89 f8             	mov    %r15,%rax
  801119:	4d 89 ef             	mov    %r13,%r15
  80111c:	49 01 c5             	add    %rax,%r13
  80111f:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801123:	49 bd 64 02 80 00 00 	movabs $0x800264,%r13
  80112a:	00 00 00 
            sys_yield();
  80112d:	49 be 01 02 80 00 00 	movabs $0x800201,%r14
  801134:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801137:	8b 73 04             	mov    0x4(%rbx),%esi
  80113a:	48 63 ce             	movslq %esi,%rcx
  80113d:	48 63 03             	movslq (%rbx),%rax
  801140:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801146:	48 39 c1             	cmp    %rax,%rcx
  801149:	72 2e                	jb     801179 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80114b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801150:	48 89 da             	mov    %rbx,%rdx
  801153:	be 00 10 00 00       	mov    $0x1000,%esi
  801158:	4c 89 e7             	mov    %r12,%rdi
  80115b:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80115e:	85 c0                	test   %eax,%eax
  801160:	74 63                	je     8011c5 <devpipe_write+0xe5>
            sys_yield();
  801162:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801165:	8b 73 04             	mov    0x4(%rbx),%esi
  801168:	48 63 ce             	movslq %esi,%rcx
  80116b:	48 63 03             	movslq (%rbx),%rax
  80116e:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801174:	48 39 c1             	cmp    %rax,%rcx
  801177:	73 d2                	jae    80114b <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801179:	41 0f b6 3f          	movzbl (%r15),%edi
  80117d:	48 89 ca             	mov    %rcx,%rdx
  801180:	48 c1 ea 03          	shr    $0x3,%rdx
  801184:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80118b:	08 10 20 
  80118e:	48 f7 e2             	mul    %rdx
  801191:	48 c1 ea 06          	shr    $0x6,%rdx
  801195:	48 89 d0             	mov    %rdx,%rax
  801198:	48 c1 e0 09          	shl    $0x9,%rax
  80119c:	48 29 d0             	sub    %rdx,%rax
  80119f:	48 c1 e0 03          	shl    $0x3,%rax
  8011a3:	48 29 c1             	sub    %rax,%rcx
  8011a6:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8011ab:	83 c6 01             	add    $0x1,%esi
  8011ae:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8011b1:	49 83 c7 01          	add    $0x1,%r15
  8011b5:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8011b9:	0f 85 78 ff ff ff    	jne    801137 <devpipe_write+0x57>
    return n;
  8011bf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8011c3:	eb 05                	jmp    8011ca <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8011c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ca:	48 83 c4 18          	add    $0x18,%rsp
  8011ce:	5b                   	pop    %rbx
  8011cf:	41 5c                	pop    %r12
  8011d1:	41 5d                	pop    %r13
  8011d3:	41 5e                	pop    %r14
  8011d5:	41 5f                	pop    %r15
  8011d7:	5d                   	pop    %rbp
  8011d8:	c3                   	ret    

00000000008011d9 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8011d9:	55                   	push   %rbp
  8011da:	48 89 e5             	mov    %rsp,%rbp
  8011dd:	41 57                	push   %r15
  8011df:	41 56                	push   %r14
  8011e1:	41 55                	push   %r13
  8011e3:	41 54                	push   %r12
  8011e5:	53                   	push   %rbx
  8011e6:	48 83 ec 18          	sub    $0x18,%rsp
  8011ea:	49 89 fc             	mov    %rdi,%r12
  8011ed:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8011f1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8011f5:	48 b8 07 06 80 00 00 	movabs $0x800607,%rax
  8011fc:	00 00 00 
  8011ff:	ff d0                	call   *%rax
  801201:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  801204:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80120a:	49 bd 64 02 80 00 00 	movabs $0x800264,%r13
  801211:	00 00 00 
            sys_yield();
  801214:	49 be 01 02 80 00 00 	movabs $0x800201,%r14
  80121b:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80121e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801223:	74 7a                	je     80129f <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801225:	8b 03                	mov    (%rbx),%eax
  801227:	3b 43 04             	cmp    0x4(%rbx),%eax
  80122a:	75 26                	jne    801252 <devpipe_read+0x79>
            if (i > 0) return i;
  80122c:	4d 85 ff             	test   %r15,%r15
  80122f:	75 74                	jne    8012a5 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801231:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801236:	48 89 da             	mov    %rbx,%rdx
  801239:	be 00 10 00 00       	mov    $0x1000,%esi
  80123e:	4c 89 e7             	mov    %r12,%rdi
  801241:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801244:	85 c0                	test   %eax,%eax
  801246:	74 6f                	je     8012b7 <devpipe_read+0xde>
            sys_yield();
  801248:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80124b:	8b 03                	mov    (%rbx),%eax
  80124d:	3b 43 04             	cmp    0x4(%rbx),%eax
  801250:	74 df                	je     801231 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801252:	48 63 c8             	movslq %eax,%rcx
  801255:	48 89 ca             	mov    %rcx,%rdx
  801258:	48 c1 ea 03          	shr    $0x3,%rdx
  80125c:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801263:	08 10 20 
  801266:	48 f7 e2             	mul    %rdx
  801269:	48 c1 ea 06          	shr    $0x6,%rdx
  80126d:	48 89 d0             	mov    %rdx,%rax
  801270:	48 c1 e0 09          	shl    $0x9,%rax
  801274:	48 29 d0             	sub    %rdx,%rax
  801277:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80127e:	00 
  80127f:	48 89 c8             	mov    %rcx,%rax
  801282:	48 29 d0             	sub    %rdx,%rax
  801285:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80128a:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80128e:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  801292:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  801295:	49 83 c7 01          	add    $0x1,%r15
  801299:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80129d:	75 86                	jne    801225 <devpipe_read+0x4c>
    return n;
  80129f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012a3:	eb 03                	jmp    8012a8 <devpipe_read+0xcf>
            if (i > 0) return i;
  8012a5:	4c 89 f8             	mov    %r15,%rax
}
  8012a8:	48 83 c4 18          	add    $0x18,%rsp
  8012ac:	5b                   	pop    %rbx
  8012ad:	41 5c                	pop    %r12
  8012af:	41 5d                	pop    %r13
  8012b1:	41 5e                	pop    %r14
  8012b3:	41 5f                	pop    %r15
  8012b5:	5d                   	pop    %rbp
  8012b6:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8012b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bc:	eb ea                	jmp    8012a8 <devpipe_read+0xcf>

00000000008012be <pipe>:
pipe(int pfd[2]) {
  8012be:	55                   	push   %rbp
  8012bf:	48 89 e5             	mov    %rsp,%rbp
  8012c2:	41 55                	push   %r13
  8012c4:	41 54                	push   %r12
  8012c6:	53                   	push   %rbx
  8012c7:	48 83 ec 18          	sub    $0x18,%rsp
  8012cb:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8012ce:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8012d2:	48 b8 23 06 80 00 00 	movabs $0x800623,%rax
  8012d9:	00 00 00 
  8012dc:	ff d0                	call   *%rax
  8012de:	89 c3                	mov    %eax,%ebx
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	0f 88 a0 01 00 00    	js     801488 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8012e8:	b9 46 00 00 00       	mov    $0x46,%ecx
  8012ed:	ba 00 10 00 00       	mov    $0x1000,%edx
  8012f2:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8012f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8012fb:	48 b8 90 02 80 00 00 	movabs $0x800290,%rax
  801302:	00 00 00 
  801305:	ff d0                	call   *%rax
  801307:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801309:	85 c0                	test   %eax,%eax
  80130b:	0f 88 77 01 00 00    	js     801488 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801311:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  801315:	48 b8 23 06 80 00 00 	movabs $0x800623,%rax
  80131c:	00 00 00 
  80131f:	ff d0                	call   *%rax
  801321:	89 c3                	mov    %eax,%ebx
  801323:	85 c0                	test   %eax,%eax
  801325:	0f 88 43 01 00 00    	js     80146e <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80132b:	b9 46 00 00 00       	mov    $0x46,%ecx
  801330:	ba 00 10 00 00       	mov    $0x1000,%edx
  801335:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801339:	bf 00 00 00 00       	mov    $0x0,%edi
  80133e:	48 b8 90 02 80 00 00 	movabs $0x800290,%rax
  801345:	00 00 00 
  801348:	ff d0                	call   *%rax
  80134a:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80134c:	85 c0                	test   %eax,%eax
  80134e:	0f 88 1a 01 00 00    	js     80146e <pipe+0x1b0>
    va = fd2data(fd0);
  801354:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801358:	48 b8 07 06 80 00 00 	movabs $0x800607,%rax
  80135f:	00 00 00 
  801362:	ff d0                	call   *%rax
  801364:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801367:	b9 46 00 00 00       	mov    $0x46,%ecx
  80136c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801371:	48 89 c6             	mov    %rax,%rsi
  801374:	bf 00 00 00 00       	mov    $0x0,%edi
  801379:	48 b8 90 02 80 00 00 	movabs $0x800290,%rax
  801380:	00 00 00 
  801383:	ff d0                	call   *%rax
  801385:	89 c3                	mov    %eax,%ebx
  801387:	85 c0                	test   %eax,%eax
  801389:	0f 88 c5 00 00 00    	js     801454 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80138f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801393:	48 b8 07 06 80 00 00 	movabs $0x800607,%rax
  80139a:	00 00 00 
  80139d:	ff d0                	call   *%rax
  80139f:	48 89 c1             	mov    %rax,%rcx
  8013a2:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8013a8:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8013ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b3:	4c 89 ee             	mov    %r13,%rsi
  8013b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8013bb:	48 b8 f7 02 80 00 00 	movabs $0x8002f7,%rax
  8013c2:	00 00 00 
  8013c5:	ff d0                	call   *%rax
  8013c7:	89 c3                	mov    %eax,%ebx
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	78 6e                	js     80143b <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8013cd:	be 00 10 00 00       	mov    $0x1000,%esi
  8013d2:	4c 89 ef             	mov    %r13,%rdi
  8013d5:	48 b8 32 02 80 00 00 	movabs $0x800232,%rax
  8013dc:	00 00 00 
  8013df:	ff d0                	call   *%rax
  8013e1:	83 f8 02             	cmp    $0x2,%eax
  8013e4:	0f 85 ab 00 00 00    	jne    801495 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8013ea:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8013f1:	00 00 
  8013f3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013f7:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8013f9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013fd:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  801404:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801408:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80140a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80140e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801415:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801419:	48 bb f5 05 80 00 00 	movabs $0x8005f5,%rbx
  801420:	00 00 00 
  801423:	ff d3                	call   *%rbx
  801425:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801429:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80142d:	ff d3                	call   *%rbx
  80142f:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  801434:	bb 00 00 00 00       	mov    $0x0,%ebx
  801439:	eb 4d                	jmp    801488 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  80143b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801440:	4c 89 ee             	mov    %r13,%rsi
  801443:	bf 00 00 00 00       	mov    $0x0,%edi
  801448:	48 b8 5c 03 80 00 00 	movabs $0x80035c,%rax
  80144f:	00 00 00 
  801452:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  801454:	ba 00 10 00 00       	mov    $0x1000,%edx
  801459:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80145d:	bf 00 00 00 00       	mov    $0x0,%edi
  801462:	48 b8 5c 03 80 00 00 	movabs $0x80035c,%rax
  801469:	00 00 00 
  80146c:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80146e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801473:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801477:	bf 00 00 00 00       	mov    $0x0,%edi
  80147c:	48 b8 5c 03 80 00 00 	movabs $0x80035c,%rax
  801483:	00 00 00 
  801486:	ff d0                	call   *%rax
}
  801488:	89 d8                	mov    %ebx,%eax
  80148a:	48 83 c4 18          	add    $0x18,%rsp
  80148e:	5b                   	pop    %rbx
  80148f:	41 5c                	pop    %r12
  801491:	41 5d                	pop    %r13
  801493:	5d                   	pop    %rbp
  801494:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  801495:	48 b9 d0 2a 80 00 00 	movabs $0x802ad0,%rcx
  80149c:	00 00 00 
  80149f:	48 ba a7 2a 80 00 00 	movabs $0x802aa7,%rdx
  8014a6:	00 00 00 
  8014a9:	be 2e 00 00 00       	mov    $0x2e,%esi
  8014ae:	48 bf bc 2a 80 00 00 	movabs $0x802abc,%rdi
  8014b5:	00 00 00 
  8014b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bd:	49 b8 53 19 80 00 00 	movabs $0x801953,%r8
  8014c4:	00 00 00 
  8014c7:	41 ff d0             	call   *%r8

00000000008014ca <pipeisclosed>:
pipeisclosed(int fdnum) {
  8014ca:	55                   	push   %rbp
  8014cb:	48 89 e5             	mov    %rsp,%rbp
  8014ce:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8014d2:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8014d6:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  8014dd:	00 00 00 
  8014e0:	ff d0                	call   *%rax
    if (res < 0) return res;
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	78 35                	js     80151b <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8014e6:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8014ea:	48 b8 07 06 80 00 00 	movabs $0x800607,%rax
  8014f1:	00 00 00 
  8014f4:	ff d0                	call   *%rax
  8014f6:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8014f9:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8014fe:	be 00 10 00 00       	mov    $0x1000,%esi
  801503:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801507:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  80150e:	00 00 00 
  801511:	ff d0                	call   *%rax
  801513:	85 c0                	test   %eax,%eax
  801515:	0f 94 c0             	sete   %al
  801518:	0f b6 c0             	movzbl %al,%eax
}
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    

000000000080151d <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80151d:	48 89 f8             	mov    %rdi,%rax
  801520:	48 c1 e8 27          	shr    $0x27,%rax
  801524:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80152b:	01 00 00 
  80152e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801532:	f6 c2 01             	test   $0x1,%dl
  801535:	74 6d                	je     8015a4 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801537:	48 89 f8             	mov    %rdi,%rax
  80153a:	48 c1 e8 1e          	shr    $0x1e,%rax
  80153e:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801545:	01 00 00 
  801548:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80154c:	f6 c2 01             	test   $0x1,%dl
  80154f:	74 62                	je     8015b3 <get_uvpt_entry+0x96>
  801551:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801558:	01 00 00 
  80155b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80155f:	f6 c2 80             	test   $0x80,%dl
  801562:	75 4f                	jne    8015b3 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801564:	48 89 f8             	mov    %rdi,%rax
  801567:	48 c1 e8 15          	shr    $0x15,%rax
  80156b:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801572:	01 00 00 
  801575:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801579:	f6 c2 01             	test   $0x1,%dl
  80157c:	74 44                	je     8015c2 <get_uvpt_entry+0xa5>
  80157e:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801585:	01 00 00 
  801588:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80158c:	f6 c2 80             	test   $0x80,%dl
  80158f:	75 31                	jne    8015c2 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  801591:	48 c1 ef 0c          	shr    $0xc,%rdi
  801595:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80159c:	01 00 00 
  80159f:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8015a3:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8015a4:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8015ab:	01 00 00 
  8015ae:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015b2:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8015b3:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8015ba:	01 00 00 
  8015bd:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015c1:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8015c2:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8015c9:	01 00 00 
  8015cc:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015d0:	c3                   	ret    

00000000008015d1 <get_prot>:

int
get_prot(void *va) {
  8015d1:	55                   	push   %rbp
  8015d2:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8015d5:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  8015dc:	00 00 00 
  8015df:	ff d0                	call   *%rax
  8015e1:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8015e4:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8015e9:	89 c1                	mov    %eax,%ecx
  8015eb:	83 c9 04             	or     $0x4,%ecx
  8015ee:	f6 c2 01             	test   $0x1,%dl
  8015f1:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8015f4:	89 c1                	mov    %eax,%ecx
  8015f6:	83 c9 02             	or     $0x2,%ecx
  8015f9:	f6 c2 02             	test   $0x2,%dl
  8015fc:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8015ff:	89 c1                	mov    %eax,%ecx
  801601:	83 c9 01             	or     $0x1,%ecx
  801604:	48 85 d2             	test   %rdx,%rdx
  801607:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80160a:	89 c1                	mov    %eax,%ecx
  80160c:	83 c9 40             	or     $0x40,%ecx
  80160f:	f6 c6 04             	test   $0x4,%dh
  801612:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801615:	5d                   	pop    %rbp
  801616:	c3                   	ret    

0000000000801617 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801617:	55                   	push   %rbp
  801618:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80161b:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  801622:	00 00 00 
  801625:	ff d0                	call   *%rax
    return pte & PTE_D;
  801627:	48 c1 e8 06          	shr    $0x6,%rax
  80162b:	83 e0 01             	and    $0x1,%eax
}
  80162e:	5d                   	pop    %rbp
  80162f:	c3                   	ret    

0000000000801630 <is_page_present>:

bool
is_page_present(void *va) {
  801630:	55                   	push   %rbp
  801631:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801634:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  80163b:	00 00 00 
  80163e:	ff d0                	call   *%rax
  801640:	83 e0 01             	and    $0x1,%eax
}
  801643:	5d                   	pop    %rbp
  801644:	c3                   	ret    

0000000000801645 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801645:	55                   	push   %rbp
  801646:	48 89 e5             	mov    %rsp,%rbp
  801649:	41 57                	push   %r15
  80164b:	41 56                	push   %r14
  80164d:	41 55                	push   %r13
  80164f:	41 54                	push   %r12
  801651:	53                   	push   %rbx
  801652:	48 83 ec 28          	sub    $0x28,%rsp
  801656:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  80165a:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  80165e:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  801663:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  80166a:	01 00 00 
  80166d:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  801674:	01 00 00 
  801677:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  80167e:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  801681:	49 bf d1 15 80 00 00 	movabs $0x8015d1,%r15
  801688:	00 00 00 
  80168b:	eb 16                	jmp    8016a3 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  80168d:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  801694:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  80169b:	00 00 00 
  80169e:	48 39 c3             	cmp    %rax,%rbx
  8016a1:	77 73                	ja     801716 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8016a3:	48 89 d8             	mov    %rbx,%rax
  8016a6:	48 c1 e8 27          	shr    $0x27,%rax
  8016aa:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8016ae:	a8 01                	test   $0x1,%al
  8016b0:	74 db                	je     80168d <foreach_shared_region+0x48>
  8016b2:	48 89 d8             	mov    %rbx,%rax
  8016b5:	48 c1 e8 1e          	shr    $0x1e,%rax
  8016b9:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8016be:	a8 01                	test   $0x1,%al
  8016c0:	74 cb                	je     80168d <foreach_shared_region+0x48>
  8016c2:	48 89 d8             	mov    %rbx,%rax
  8016c5:	48 c1 e8 15          	shr    $0x15,%rax
  8016c9:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8016cd:	a8 01                	test   $0x1,%al
  8016cf:	74 bc                	je     80168d <foreach_shared_region+0x48>
        void *start = (void*)i;
  8016d1:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016d5:	48 89 df             	mov    %rbx,%rdi
  8016d8:	41 ff d7             	call   *%r15
  8016db:	a8 40                	test   $0x40,%al
  8016dd:	75 09                	jne    8016e8 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8016df:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8016e6:	eb ac                	jmp    801694 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016e8:	48 89 df             	mov    %rbx,%rdi
  8016eb:	48 b8 30 16 80 00 00 	movabs $0x801630,%rax
  8016f2:	00 00 00 
  8016f5:	ff d0                	call   *%rax
  8016f7:	84 c0                	test   %al,%al
  8016f9:	74 e4                	je     8016df <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  8016fb:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  801702:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801706:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80170a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80170e:	ff d0                	call   *%rax
  801710:	85 c0                	test   %eax,%eax
  801712:	79 cb                	jns    8016df <foreach_shared_region+0x9a>
  801714:	eb 05                	jmp    80171b <foreach_shared_region+0xd6>
    }
    return 0;
  801716:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171b:	48 83 c4 28          	add    $0x28,%rsp
  80171f:	5b                   	pop    %rbx
  801720:	41 5c                	pop    %r12
  801722:	41 5d                	pop    %r13
  801724:	41 5e                	pop    %r14
  801726:	41 5f                	pop    %r15
  801728:	5d                   	pop    %rbp
  801729:	c3                   	ret    

000000000080172a <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80172a:	b8 00 00 00 00       	mov    $0x0,%eax
  80172f:	c3                   	ret    

0000000000801730 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  801730:	55                   	push   %rbp
  801731:	48 89 e5             	mov    %rsp,%rbp
  801734:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  801737:	48 be f4 2a 80 00 00 	movabs $0x802af4,%rsi
  80173e:	00 00 00 
  801741:	48 b8 e4 23 80 00 00 	movabs $0x8023e4,%rax
  801748:	00 00 00 
  80174b:	ff d0                	call   *%rax
    return 0;
}
  80174d:	b8 00 00 00 00       	mov    $0x0,%eax
  801752:	5d                   	pop    %rbp
  801753:	c3                   	ret    

0000000000801754 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  801754:	55                   	push   %rbp
  801755:	48 89 e5             	mov    %rsp,%rbp
  801758:	41 57                	push   %r15
  80175a:	41 56                	push   %r14
  80175c:	41 55                	push   %r13
  80175e:	41 54                	push   %r12
  801760:	53                   	push   %rbx
  801761:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  801768:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80176f:	48 85 d2             	test   %rdx,%rdx
  801772:	74 78                	je     8017ec <devcons_write+0x98>
  801774:	49 89 d6             	mov    %rdx,%r14
  801777:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80177d:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801782:	49 bf df 25 80 00 00 	movabs $0x8025df,%r15
  801789:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80178c:	4c 89 f3             	mov    %r14,%rbx
  80178f:	48 29 f3             	sub    %rsi,%rbx
  801792:	48 83 fb 7f          	cmp    $0x7f,%rbx
  801796:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80179b:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  80179f:	4c 63 eb             	movslq %ebx,%r13
  8017a2:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8017a9:	4c 89 ea             	mov    %r13,%rdx
  8017ac:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017b3:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8017b6:	4c 89 ee             	mov    %r13,%rsi
  8017b9:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017c0:	48 b8 07 01 80 00 00 	movabs $0x800107,%rax
  8017c7:	00 00 00 
  8017ca:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8017cc:	41 01 dc             	add    %ebx,%r12d
  8017cf:	49 63 f4             	movslq %r12d,%rsi
  8017d2:	4c 39 f6             	cmp    %r14,%rsi
  8017d5:	72 b5                	jb     80178c <devcons_write+0x38>
    return res;
  8017d7:	49 63 c4             	movslq %r12d,%rax
}
  8017da:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8017e1:	5b                   	pop    %rbx
  8017e2:	41 5c                	pop    %r12
  8017e4:	41 5d                	pop    %r13
  8017e6:	41 5e                	pop    %r14
  8017e8:	41 5f                	pop    %r15
  8017ea:	5d                   	pop    %rbp
  8017eb:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8017ec:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8017f2:	eb e3                	jmp    8017d7 <devcons_write+0x83>

00000000008017f4 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8017f4:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8017f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fc:	48 85 c0             	test   %rax,%rax
  8017ff:	74 55                	je     801856 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801801:	55                   	push   %rbp
  801802:	48 89 e5             	mov    %rsp,%rbp
  801805:	41 55                	push   %r13
  801807:	41 54                	push   %r12
  801809:	53                   	push   %rbx
  80180a:	48 83 ec 08          	sub    $0x8,%rsp
  80180e:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801811:	48 bb 34 01 80 00 00 	movabs $0x800134,%rbx
  801818:	00 00 00 
  80181b:	49 bc 01 02 80 00 00 	movabs $0x800201,%r12
  801822:	00 00 00 
  801825:	eb 03                	jmp    80182a <devcons_read+0x36>
  801827:	41 ff d4             	call   *%r12
  80182a:	ff d3                	call   *%rbx
  80182c:	85 c0                	test   %eax,%eax
  80182e:	74 f7                	je     801827 <devcons_read+0x33>
    if (c < 0) return c;
  801830:	48 63 d0             	movslq %eax,%rdx
  801833:	78 13                	js     801848 <devcons_read+0x54>
    if (c == 0x04) return 0;
  801835:	ba 00 00 00 00       	mov    $0x0,%edx
  80183a:	83 f8 04             	cmp    $0x4,%eax
  80183d:	74 09                	je     801848 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  80183f:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801843:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801848:	48 89 d0             	mov    %rdx,%rax
  80184b:	48 83 c4 08          	add    $0x8,%rsp
  80184f:	5b                   	pop    %rbx
  801850:	41 5c                	pop    %r12
  801852:	41 5d                	pop    %r13
  801854:	5d                   	pop    %rbp
  801855:	c3                   	ret    
  801856:	48 89 d0             	mov    %rdx,%rax
  801859:	c3                   	ret    

000000000080185a <cputchar>:
cputchar(int ch) {
  80185a:	55                   	push   %rbp
  80185b:	48 89 e5             	mov    %rsp,%rbp
  80185e:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801862:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801866:	be 01 00 00 00       	mov    $0x1,%esi
  80186b:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80186f:	48 b8 07 01 80 00 00 	movabs $0x800107,%rax
  801876:	00 00 00 
  801879:	ff d0                	call   *%rax
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

000000000080187d <getchar>:
getchar(void) {
  80187d:	55                   	push   %rbp
  80187e:	48 89 e5             	mov    %rsp,%rbp
  801881:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801885:	ba 01 00 00 00       	mov    $0x1,%edx
  80188a:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  80188e:	bf 00 00 00 00       	mov    $0x0,%edi
  801893:	48 b8 66 09 80 00 00 	movabs $0x800966,%rax
  80189a:	00 00 00 
  80189d:	ff d0                	call   *%rax
  80189f:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	78 06                	js     8018ab <getchar+0x2e>
  8018a5:	74 08                	je     8018af <getchar+0x32>
  8018a7:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8018ab:	89 d0                	mov    %edx,%eax
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8018af:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8018b4:	eb f5                	jmp    8018ab <getchar+0x2e>

00000000008018b6 <iscons>:
iscons(int fdnum) {
  8018b6:	55                   	push   %rbp
  8018b7:	48 89 e5             	mov    %rsp,%rbp
  8018ba:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8018be:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018c2:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  8018c9:	00 00 00 
  8018cc:	ff d0                	call   *%rax
    if (res < 0) return res;
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	78 18                	js     8018ea <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8018d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018d6:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8018dd:	00 00 00 
  8018e0:	8b 00                	mov    (%rax),%eax
  8018e2:	39 02                	cmp    %eax,(%rdx)
  8018e4:	0f 94 c0             	sete   %al
  8018e7:	0f b6 c0             	movzbl %al,%eax
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

00000000008018ec <opencons>:
opencons(void) {
  8018ec:	55                   	push   %rbp
  8018ed:	48 89 e5             	mov    %rsp,%rbp
  8018f0:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8018f4:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8018f8:	48 b8 23 06 80 00 00 	movabs $0x800623,%rax
  8018ff:	00 00 00 
  801902:	ff d0                	call   *%rax
  801904:	85 c0                	test   %eax,%eax
  801906:	78 49                	js     801951 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801908:	b9 46 00 00 00       	mov    $0x46,%ecx
  80190d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801912:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801916:	bf 00 00 00 00       	mov    $0x0,%edi
  80191b:	48 b8 90 02 80 00 00 	movabs $0x800290,%rax
  801922:	00 00 00 
  801925:	ff d0                	call   *%rax
  801927:	85 c0                	test   %eax,%eax
  801929:	78 26                	js     801951 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  80192b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80192f:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801936:	00 00 
  801938:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80193a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80193e:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801945:	48 b8 f5 05 80 00 00 	movabs $0x8005f5,%rax
  80194c:	00 00 00 
  80194f:	ff d0                	call   *%rax
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

0000000000801953 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801953:	55                   	push   %rbp
  801954:	48 89 e5             	mov    %rsp,%rbp
  801957:	41 56                	push   %r14
  801959:	41 55                	push   %r13
  80195b:	41 54                	push   %r12
  80195d:	53                   	push   %rbx
  80195e:	48 83 ec 50          	sub    $0x50,%rsp
  801962:	49 89 fc             	mov    %rdi,%r12
  801965:	41 89 f5             	mov    %esi,%r13d
  801968:	48 89 d3             	mov    %rdx,%rbx
  80196b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80196f:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801973:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801977:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  80197e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801982:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801986:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80198a:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  80198e:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801995:	00 00 00 
  801998:	4c 8b 30             	mov    (%rax),%r14
  80199b:	48 b8 d0 01 80 00 00 	movabs $0x8001d0,%rax
  8019a2:	00 00 00 
  8019a5:	ff d0                	call   *%rax
  8019a7:	89 c6                	mov    %eax,%esi
  8019a9:	45 89 e8             	mov    %r13d,%r8d
  8019ac:	4c 89 e1             	mov    %r12,%rcx
  8019af:	4c 89 f2             	mov    %r14,%rdx
  8019b2:	48 bf 00 2b 80 00 00 	movabs $0x802b00,%rdi
  8019b9:	00 00 00 
  8019bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c1:	49 bc a3 1a 80 00 00 	movabs $0x801aa3,%r12
  8019c8:	00 00 00 
  8019cb:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8019ce:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8019d2:	48 89 df             	mov    %rbx,%rdi
  8019d5:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  8019dc:	00 00 00 
  8019df:	ff d0                	call   *%rax
    cprintf("\n");
  8019e1:	48 bf 53 2a 80 00 00 	movabs $0x802a53,%rdi
  8019e8:	00 00 00 
  8019eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f0:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8019f3:	cc                   	int3   
  8019f4:	eb fd                	jmp    8019f3 <_panic+0xa0>

00000000008019f6 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8019f6:	55                   	push   %rbp
  8019f7:	48 89 e5             	mov    %rsp,%rbp
  8019fa:	53                   	push   %rbx
  8019fb:	48 83 ec 08          	sub    $0x8,%rsp
  8019ff:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801a02:	8b 06                	mov    (%rsi),%eax
  801a04:	8d 50 01             	lea    0x1(%rax),%edx
  801a07:	89 16                	mov    %edx,(%rsi)
  801a09:	48 98                	cltq   
  801a0b:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801a10:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801a16:	74 0a                	je     801a22 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801a18:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801a1c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  801a22:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801a26:	be ff 00 00 00       	mov    $0xff,%esi
  801a2b:	48 b8 07 01 80 00 00 	movabs $0x800107,%rax
  801a32:	00 00 00 
  801a35:	ff d0                	call   *%rax
        state->offset = 0;
  801a37:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801a3d:	eb d9                	jmp    801a18 <putch+0x22>

0000000000801a3f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801a3f:	55                   	push   %rbp
  801a40:	48 89 e5             	mov    %rsp,%rbp
  801a43:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801a4a:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801a4d:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801a54:	b9 21 00 00 00       	mov    $0x21,%ecx
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5e:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801a61:	48 89 f1             	mov    %rsi,%rcx
  801a64:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801a6b:	48 bf f6 19 80 00 00 	movabs $0x8019f6,%rdi
  801a72:	00 00 00 
  801a75:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801a7c:	00 00 00 
  801a7f:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801a81:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801a88:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801a8f:	48 b8 07 01 80 00 00 	movabs $0x800107,%rax
  801a96:	00 00 00 
  801a99:	ff d0                	call   *%rax

    return state.count;
}
  801a9b:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

0000000000801aa3 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801aa3:	55                   	push   %rbp
  801aa4:	48 89 e5             	mov    %rsp,%rbp
  801aa7:	48 83 ec 50          	sub    $0x50,%rsp
  801aab:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801aaf:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801ab3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ab7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801abb:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801abf:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801ac6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801aca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ace:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801ad2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801ad6:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801ada:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  801ae1:	00 00 00 
  801ae4:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

0000000000801ae8 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801ae8:	55                   	push   %rbp
  801ae9:	48 89 e5             	mov    %rsp,%rbp
  801aec:	41 57                	push   %r15
  801aee:	41 56                	push   %r14
  801af0:	41 55                	push   %r13
  801af2:	41 54                	push   %r12
  801af4:	53                   	push   %rbx
  801af5:	48 83 ec 18          	sub    $0x18,%rsp
  801af9:	49 89 fc             	mov    %rdi,%r12
  801afc:	49 89 f5             	mov    %rsi,%r13
  801aff:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801b03:	8b 45 10             	mov    0x10(%rbp),%eax
  801b06:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801b09:	41 89 cf             	mov    %ecx,%r15d
  801b0c:	49 39 d7             	cmp    %rdx,%r15
  801b0f:	76 5b                	jbe    801b6c <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801b11:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801b15:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801b19:	85 db                	test   %ebx,%ebx
  801b1b:	7e 0e                	jle    801b2b <print_num+0x43>
            putch(padc, put_arg);
  801b1d:	4c 89 ee             	mov    %r13,%rsi
  801b20:	44 89 f7             	mov    %r14d,%edi
  801b23:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801b26:	83 eb 01             	sub    $0x1,%ebx
  801b29:	75 f2                	jne    801b1d <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801b2b:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801b2f:	48 b9 23 2b 80 00 00 	movabs $0x802b23,%rcx
  801b36:	00 00 00 
  801b39:	48 b8 34 2b 80 00 00 	movabs $0x802b34,%rax
  801b40:	00 00 00 
  801b43:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801b47:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b50:	49 f7 f7             	div    %r15
  801b53:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801b57:	4c 89 ee             	mov    %r13,%rsi
  801b5a:	41 ff d4             	call   *%r12
}
  801b5d:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801b61:	5b                   	pop    %rbx
  801b62:	41 5c                	pop    %r12
  801b64:	41 5d                	pop    %r13
  801b66:	41 5e                	pop    %r14
  801b68:	41 5f                	pop    %r15
  801b6a:	5d                   	pop    %rbp
  801b6b:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801b6c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b70:	ba 00 00 00 00       	mov    $0x0,%edx
  801b75:	49 f7 f7             	div    %r15
  801b78:	48 83 ec 08          	sub    $0x8,%rsp
  801b7c:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801b80:	52                   	push   %rdx
  801b81:	45 0f be c9          	movsbl %r9b,%r9d
  801b85:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801b89:	48 89 c2             	mov    %rax,%rdx
  801b8c:	48 b8 e8 1a 80 00 00 	movabs $0x801ae8,%rax
  801b93:	00 00 00 
  801b96:	ff d0                	call   *%rax
  801b98:	48 83 c4 10          	add    $0x10,%rsp
  801b9c:	eb 8d                	jmp    801b2b <print_num+0x43>

0000000000801b9e <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  801b9e:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801ba2:	48 8b 06             	mov    (%rsi),%rax
  801ba5:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801ba9:	73 0a                	jae    801bb5 <sprintputch+0x17>
        *state->start++ = ch;
  801bab:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801baf:	48 89 16             	mov    %rdx,(%rsi)
  801bb2:	40 88 38             	mov    %dil,(%rax)
    }
}
  801bb5:	c3                   	ret    

0000000000801bb6 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801bb6:	55                   	push   %rbp
  801bb7:	48 89 e5             	mov    %rsp,%rbp
  801bba:	48 83 ec 50          	sub    $0x50,%rsp
  801bbe:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bc2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801bc6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801bca:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801bd1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801bd5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801bd9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801bdd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801be1:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801be5:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801bec:	00 00 00 
  801bef:	ff d0                	call   *%rax
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

0000000000801bf3 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801bf3:	55                   	push   %rbp
  801bf4:	48 89 e5             	mov    %rsp,%rbp
  801bf7:	41 57                	push   %r15
  801bf9:	41 56                	push   %r14
  801bfb:	41 55                	push   %r13
  801bfd:	41 54                	push   %r12
  801bff:	53                   	push   %rbx
  801c00:	48 83 ec 48          	sub    $0x48,%rsp
  801c04:	49 89 fc             	mov    %rdi,%r12
  801c07:	49 89 f6             	mov    %rsi,%r14
  801c0a:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  801c0d:	48 8b 01             	mov    (%rcx),%rax
  801c10:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801c14:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801c18:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801c1c:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801c20:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801c24:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  801c28:	41 0f b6 3f          	movzbl (%r15),%edi
  801c2c:	40 80 ff 25          	cmp    $0x25,%dil
  801c30:	74 18                	je     801c4a <vprintfmt+0x57>
            if (!ch) return;
  801c32:	40 84 ff             	test   %dil,%dil
  801c35:	0f 84 d1 06 00 00    	je     80230c <vprintfmt+0x719>
            putch(ch, put_arg);
  801c3b:	40 0f b6 ff          	movzbl %dil,%edi
  801c3f:	4c 89 f6             	mov    %r14,%rsi
  801c42:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  801c45:	49 89 df             	mov    %rbx,%r15
  801c48:	eb da                	jmp    801c24 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  801c4a:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  801c4e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c53:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  801c57:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801c5c:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801c62:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801c69:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  801c6d:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  801c72:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  801c78:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  801c7c:	44 0f b6 0b          	movzbl (%rbx),%r9d
  801c80:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  801c84:	3c 57                	cmp    $0x57,%al
  801c86:	0f 87 65 06 00 00    	ja     8022f1 <vprintfmt+0x6fe>
  801c8c:	0f b6 c0             	movzbl %al,%eax
  801c8f:	49 ba c0 2c 80 00 00 	movabs $0x802cc0,%r10
  801c96:	00 00 00 
  801c99:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  801c9d:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  801ca0:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  801ca4:	eb d2                	jmp    801c78 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  801ca6:	4c 89 fb             	mov    %r15,%rbx
  801ca9:	44 89 c1             	mov    %r8d,%ecx
  801cac:	eb ca                	jmp    801c78 <vprintfmt+0x85>
            padc = ch;
  801cae:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  801cb2:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801cb5:	eb c1                	jmp    801c78 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cb7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801cba:	83 f8 2f             	cmp    $0x2f,%eax
  801cbd:	77 24                	ja     801ce3 <vprintfmt+0xf0>
  801cbf:	41 89 c1             	mov    %eax,%r9d
  801cc2:	49 01 f1             	add    %rsi,%r9
  801cc5:	83 c0 08             	add    $0x8,%eax
  801cc8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801ccb:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  801cce:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  801cd1:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801cd5:	79 a1                	jns    801c78 <vprintfmt+0x85>
                width = precision;
  801cd7:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  801cdb:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801ce1:	eb 95                	jmp    801c78 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801ce3:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  801ce7:	49 8d 41 08          	lea    0x8(%r9),%rax
  801ceb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801cef:	eb da                	jmp    801ccb <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  801cf1:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  801cf5:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801cf9:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  801cfd:	3c 39                	cmp    $0x39,%al
  801cff:	77 1e                	ja     801d1f <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  801d01:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  801d05:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  801d0a:	0f b6 c0             	movzbl %al,%eax
  801d0d:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d12:	41 0f b6 07          	movzbl (%r15),%eax
  801d16:	3c 39                	cmp    $0x39,%al
  801d18:	76 e7                	jbe    801d01 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  801d1a:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  801d1d:	eb b2                	jmp    801cd1 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  801d1f:	4c 89 fb             	mov    %r15,%rbx
  801d22:	eb ad                	jmp    801cd1 <vprintfmt+0xde>
            width = MAX(0, width);
  801d24:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801d27:	85 c0                	test   %eax,%eax
  801d29:	0f 48 c7             	cmovs  %edi,%eax
  801d2c:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801d2f:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d32:	e9 41 ff ff ff       	jmp    801c78 <vprintfmt+0x85>
            lflag++;
  801d37:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801d3a:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d3d:	e9 36 ff ff ff       	jmp    801c78 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  801d42:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d45:	83 f8 2f             	cmp    $0x2f,%eax
  801d48:	77 18                	ja     801d62 <vprintfmt+0x16f>
  801d4a:	89 c2                	mov    %eax,%edx
  801d4c:	48 01 f2             	add    %rsi,%rdx
  801d4f:	83 c0 08             	add    $0x8,%eax
  801d52:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d55:	4c 89 f6             	mov    %r14,%rsi
  801d58:	8b 3a                	mov    (%rdx),%edi
  801d5a:	41 ff d4             	call   *%r12
            break;
  801d5d:	e9 c2 fe ff ff       	jmp    801c24 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  801d62:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801d66:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801d6a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d6e:	eb e5                	jmp    801d55 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  801d70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d73:	83 f8 2f             	cmp    $0x2f,%eax
  801d76:	77 5b                	ja     801dd3 <vprintfmt+0x1e0>
  801d78:	89 c2                	mov    %eax,%edx
  801d7a:	48 01 d6             	add    %rdx,%rsi
  801d7d:	83 c0 08             	add    $0x8,%eax
  801d80:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d83:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  801d85:	89 c8                	mov    %ecx,%eax
  801d87:	c1 f8 1f             	sar    $0x1f,%eax
  801d8a:	31 c1                	xor    %eax,%ecx
  801d8c:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  801d8e:	83 f9 13             	cmp    $0x13,%ecx
  801d91:	7f 4e                	jg     801de1 <vprintfmt+0x1ee>
  801d93:	48 63 c1             	movslq %ecx,%rax
  801d96:	48 ba 80 2f 80 00 00 	movabs $0x802f80,%rdx
  801d9d:	00 00 00 
  801da0:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801da4:	48 85 c0             	test   %rax,%rax
  801da7:	74 38                	je     801de1 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  801da9:	48 89 c1             	mov    %rax,%rcx
  801dac:	48 ba b9 2a 80 00 00 	movabs $0x802ab9,%rdx
  801db3:	00 00 00 
  801db6:	4c 89 f6             	mov    %r14,%rsi
  801db9:	4c 89 e7             	mov    %r12,%rdi
  801dbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc1:	49 b8 b6 1b 80 00 00 	movabs $0x801bb6,%r8
  801dc8:	00 00 00 
  801dcb:	41 ff d0             	call   *%r8
  801dce:	e9 51 fe ff ff       	jmp    801c24 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  801dd3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801dd7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801ddb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ddf:	eb a2                	jmp    801d83 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  801de1:	48 ba 4c 2b 80 00 00 	movabs $0x802b4c,%rdx
  801de8:	00 00 00 
  801deb:	4c 89 f6             	mov    %r14,%rsi
  801dee:	4c 89 e7             	mov    %r12,%rdi
  801df1:	b8 00 00 00 00       	mov    $0x0,%eax
  801df6:	49 b8 b6 1b 80 00 00 	movabs $0x801bb6,%r8
  801dfd:	00 00 00 
  801e00:	41 ff d0             	call   *%r8
  801e03:	e9 1c fe ff ff       	jmp    801c24 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  801e08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801e0b:	83 f8 2f             	cmp    $0x2f,%eax
  801e0e:	77 55                	ja     801e65 <vprintfmt+0x272>
  801e10:	89 c2                	mov    %eax,%edx
  801e12:	48 01 d6             	add    %rdx,%rsi
  801e15:	83 c0 08             	add    $0x8,%eax
  801e18:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801e1b:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  801e1e:	48 85 d2             	test   %rdx,%rdx
  801e21:	48 b8 45 2b 80 00 00 	movabs $0x802b45,%rax
  801e28:	00 00 00 
  801e2b:	48 0f 45 c2          	cmovne %rdx,%rax
  801e2f:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  801e33:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801e37:	7e 06                	jle    801e3f <vprintfmt+0x24c>
  801e39:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  801e3d:	75 34                	jne    801e73 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801e3f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  801e43:	48 8d 58 01          	lea    0x1(%rax),%rbx
  801e47:	0f b6 00             	movzbl (%rax),%eax
  801e4a:	84 c0                	test   %al,%al
  801e4c:	0f 84 b2 00 00 00    	je     801f04 <vprintfmt+0x311>
  801e52:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  801e56:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  801e5b:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  801e5f:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  801e63:	eb 74                	jmp    801ed9 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  801e65:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801e69:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801e6d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e71:	eb a8                	jmp    801e1b <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  801e73:	49 63 f5             	movslq %r13d,%rsi
  801e76:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  801e7a:	48 b8 c6 23 80 00 00 	movabs $0x8023c6,%rax
  801e81:	00 00 00 
  801e84:	ff d0                	call   *%rax
  801e86:	48 89 c2             	mov    %rax,%rdx
  801e89:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801e8c:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  801e8e:	8d 48 ff             	lea    -0x1(%rax),%ecx
  801e91:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  801e94:	85 c0                	test   %eax,%eax
  801e96:	7e a7                	jle    801e3f <vprintfmt+0x24c>
  801e98:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  801e9c:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  801ea0:	41 89 cd             	mov    %ecx,%r13d
  801ea3:	4c 89 f6             	mov    %r14,%rsi
  801ea6:	89 df                	mov    %ebx,%edi
  801ea8:	41 ff d4             	call   *%r12
  801eab:	41 83 ed 01          	sub    $0x1,%r13d
  801eaf:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  801eb3:	75 ee                	jne    801ea3 <vprintfmt+0x2b0>
  801eb5:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  801eb9:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  801ebd:	eb 80                	jmp    801e3f <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801ebf:	0f b6 f8             	movzbl %al,%edi
  801ec2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801ec6:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801ec9:	41 83 ef 01          	sub    $0x1,%r15d
  801ecd:	48 83 c3 01          	add    $0x1,%rbx
  801ed1:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  801ed5:	84 c0                	test   %al,%al
  801ed7:	74 1f                	je     801ef8 <vprintfmt+0x305>
  801ed9:	45 85 ed             	test   %r13d,%r13d
  801edc:	78 06                	js     801ee4 <vprintfmt+0x2f1>
  801ede:	41 83 ed 01          	sub    $0x1,%r13d
  801ee2:	78 46                	js     801f2a <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801ee4:	45 84 f6             	test   %r14b,%r14b
  801ee7:	74 d6                	je     801ebf <vprintfmt+0x2cc>
  801ee9:	8d 50 e0             	lea    -0x20(%rax),%edx
  801eec:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801ef1:	80 fa 5e             	cmp    $0x5e,%dl
  801ef4:	77 cc                	ja     801ec2 <vprintfmt+0x2cf>
  801ef6:	eb c7                	jmp    801ebf <vprintfmt+0x2cc>
  801ef8:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801efc:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f00:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  801f04:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801f07:	8d 58 ff             	lea    -0x1(%rax),%ebx
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	0f 8e 12 fd ff ff    	jle    801c24 <vprintfmt+0x31>
  801f12:	4c 89 f6             	mov    %r14,%rsi
  801f15:	bf 20 00 00 00       	mov    $0x20,%edi
  801f1a:	41 ff d4             	call   *%r12
  801f1d:	83 eb 01             	sub    $0x1,%ebx
  801f20:	83 fb ff             	cmp    $0xffffffff,%ebx
  801f23:	75 ed                	jne    801f12 <vprintfmt+0x31f>
  801f25:	e9 fa fc ff ff       	jmp    801c24 <vprintfmt+0x31>
  801f2a:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f2e:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f32:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  801f36:	eb cc                	jmp    801f04 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  801f38:	45 89 cd             	mov    %r9d,%r13d
  801f3b:	84 c9                	test   %cl,%cl
  801f3d:	75 25                	jne    801f64 <vprintfmt+0x371>
    switch (lflag) {
  801f3f:	85 d2                	test   %edx,%edx
  801f41:	74 57                	je     801f9a <vprintfmt+0x3a7>
  801f43:	83 fa 01             	cmp    $0x1,%edx
  801f46:	74 78                	je     801fc0 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  801f48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f4b:	83 f8 2f             	cmp    $0x2f,%eax
  801f4e:	0f 87 92 00 00 00    	ja     801fe6 <vprintfmt+0x3f3>
  801f54:	89 c2                	mov    %eax,%edx
  801f56:	48 01 d6             	add    %rdx,%rsi
  801f59:	83 c0 08             	add    $0x8,%eax
  801f5c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f5f:	48 8b 1e             	mov    (%rsi),%rbx
  801f62:	eb 16                	jmp    801f7a <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  801f64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f67:	83 f8 2f             	cmp    $0x2f,%eax
  801f6a:	77 20                	ja     801f8c <vprintfmt+0x399>
  801f6c:	89 c2                	mov    %eax,%edx
  801f6e:	48 01 d6             	add    %rdx,%rsi
  801f71:	83 c0 08             	add    $0x8,%eax
  801f74:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f77:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  801f7a:	48 85 db             	test   %rbx,%rbx
  801f7d:	78 78                	js     801ff7 <vprintfmt+0x404>
            num = i;
  801f7f:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  801f82:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  801f87:	e9 49 02 00 00       	jmp    8021d5 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801f8c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801f90:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801f94:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f98:	eb dd                	jmp    801f77 <vprintfmt+0x384>
        return va_arg(*ap, int);
  801f9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f9d:	83 f8 2f             	cmp    $0x2f,%eax
  801fa0:	77 10                	ja     801fb2 <vprintfmt+0x3bf>
  801fa2:	89 c2                	mov    %eax,%edx
  801fa4:	48 01 d6             	add    %rdx,%rsi
  801fa7:	83 c0 08             	add    $0x8,%eax
  801faa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fad:	48 63 1e             	movslq (%rsi),%rbx
  801fb0:	eb c8                	jmp    801f7a <vprintfmt+0x387>
  801fb2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fb6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fbe:	eb ed                	jmp    801fad <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  801fc0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fc3:	83 f8 2f             	cmp    $0x2f,%eax
  801fc6:	77 10                	ja     801fd8 <vprintfmt+0x3e5>
  801fc8:	89 c2                	mov    %eax,%edx
  801fca:	48 01 d6             	add    %rdx,%rsi
  801fcd:	83 c0 08             	add    $0x8,%eax
  801fd0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fd3:	48 8b 1e             	mov    (%rsi),%rbx
  801fd6:	eb a2                	jmp    801f7a <vprintfmt+0x387>
  801fd8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fdc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fe0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fe4:	eb ed                	jmp    801fd3 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  801fe6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fea:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fee:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ff2:	e9 68 ff ff ff       	jmp    801f5f <vprintfmt+0x36c>
                putch('-', put_arg);
  801ff7:	4c 89 f6             	mov    %r14,%rsi
  801ffa:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801fff:	41 ff d4             	call   *%r12
                i = -i;
  802002:	48 f7 db             	neg    %rbx
  802005:	e9 75 ff ff ff       	jmp    801f7f <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  80200a:	45 89 cd             	mov    %r9d,%r13d
  80200d:	84 c9                	test   %cl,%cl
  80200f:	75 2d                	jne    80203e <vprintfmt+0x44b>
    switch (lflag) {
  802011:	85 d2                	test   %edx,%edx
  802013:	74 57                	je     80206c <vprintfmt+0x479>
  802015:	83 fa 01             	cmp    $0x1,%edx
  802018:	74 7f                	je     802099 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  80201a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80201d:	83 f8 2f             	cmp    $0x2f,%eax
  802020:	0f 87 a1 00 00 00    	ja     8020c7 <vprintfmt+0x4d4>
  802026:	89 c2                	mov    %eax,%edx
  802028:	48 01 d6             	add    %rdx,%rsi
  80202b:	83 c0 08             	add    $0x8,%eax
  80202e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802031:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802034:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  802039:	e9 97 01 00 00       	jmp    8021d5 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80203e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802041:	83 f8 2f             	cmp    $0x2f,%eax
  802044:	77 18                	ja     80205e <vprintfmt+0x46b>
  802046:	89 c2                	mov    %eax,%edx
  802048:	48 01 d6             	add    %rdx,%rsi
  80204b:	83 c0 08             	add    $0x8,%eax
  80204e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802051:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802054:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802059:	e9 77 01 00 00       	jmp    8021d5 <vprintfmt+0x5e2>
  80205e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802062:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802066:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80206a:	eb e5                	jmp    802051 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  80206c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80206f:	83 f8 2f             	cmp    $0x2f,%eax
  802072:	77 17                	ja     80208b <vprintfmt+0x498>
  802074:	89 c2                	mov    %eax,%edx
  802076:	48 01 d6             	add    %rdx,%rsi
  802079:	83 c0 08             	add    $0x8,%eax
  80207c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80207f:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  802081:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802086:	e9 4a 01 00 00       	jmp    8021d5 <vprintfmt+0x5e2>
  80208b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80208f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802093:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802097:	eb e6                	jmp    80207f <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  802099:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80209c:	83 f8 2f             	cmp    $0x2f,%eax
  80209f:	77 18                	ja     8020b9 <vprintfmt+0x4c6>
  8020a1:	89 c2                	mov    %eax,%edx
  8020a3:	48 01 d6             	add    %rdx,%rsi
  8020a6:	83 c0 08             	add    $0x8,%eax
  8020a9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020ac:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8020af:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8020b4:	e9 1c 01 00 00       	jmp    8021d5 <vprintfmt+0x5e2>
  8020b9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020bd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020c1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020c5:	eb e5                	jmp    8020ac <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8020c7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020cb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020cf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020d3:	e9 59 ff ff ff       	jmp    802031 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8020d8:	45 89 cd             	mov    %r9d,%r13d
  8020db:	84 c9                	test   %cl,%cl
  8020dd:	75 2d                	jne    80210c <vprintfmt+0x519>
    switch (lflag) {
  8020df:	85 d2                	test   %edx,%edx
  8020e1:	74 57                	je     80213a <vprintfmt+0x547>
  8020e3:	83 fa 01             	cmp    $0x1,%edx
  8020e6:	74 7c                	je     802164 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8020e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020eb:	83 f8 2f             	cmp    $0x2f,%eax
  8020ee:	0f 87 9b 00 00 00    	ja     80218f <vprintfmt+0x59c>
  8020f4:	89 c2                	mov    %eax,%edx
  8020f6:	48 01 d6             	add    %rdx,%rsi
  8020f9:	83 c0 08             	add    $0x8,%eax
  8020fc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020ff:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802102:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802107:	e9 c9 00 00 00       	jmp    8021d5 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80210c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80210f:	83 f8 2f             	cmp    $0x2f,%eax
  802112:	77 18                	ja     80212c <vprintfmt+0x539>
  802114:	89 c2                	mov    %eax,%edx
  802116:	48 01 d6             	add    %rdx,%rsi
  802119:	83 c0 08             	add    $0x8,%eax
  80211c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80211f:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802122:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802127:	e9 a9 00 00 00       	jmp    8021d5 <vprintfmt+0x5e2>
  80212c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802130:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802134:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802138:	eb e5                	jmp    80211f <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  80213a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80213d:	83 f8 2f             	cmp    $0x2f,%eax
  802140:	77 14                	ja     802156 <vprintfmt+0x563>
  802142:	89 c2                	mov    %eax,%edx
  802144:	48 01 d6             	add    %rdx,%rsi
  802147:	83 c0 08             	add    $0x8,%eax
  80214a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80214d:	8b 16                	mov    (%rsi),%edx
            base = 8;
  80214f:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  802154:	eb 7f                	jmp    8021d5 <vprintfmt+0x5e2>
  802156:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80215a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80215e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802162:	eb e9                	jmp    80214d <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  802164:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802167:	83 f8 2f             	cmp    $0x2f,%eax
  80216a:	77 15                	ja     802181 <vprintfmt+0x58e>
  80216c:	89 c2                	mov    %eax,%edx
  80216e:	48 01 d6             	add    %rdx,%rsi
  802171:	83 c0 08             	add    $0x8,%eax
  802174:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802177:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80217a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80217f:	eb 54                	jmp    8021d5 <vprintfmt+0x5e2>
  802181:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802185:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802189:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80218d:	eb e8                	jmp    802177 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  80218f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802193:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802197:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80219b:	e9 5f ff ff ff       	jmp    8020ff <vprintfmt+0x50c>
            putch('0', put_arg);
  8021a0:	45 89 cd             	mov    %r9d,%r13d
  8021a3:	4c 89 f6             	mov    %r14,%rsi
  8021a6:	bf 30 00 00 00       	mov    $0x30,%edi
  8021ab:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8021ae:	4c 89 f6             	mov    %r14,%rsi
  8021b1:	bf 78 00 00 00       	mov    $0x78,%edi
  8021b6:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8021b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021bc:	83 f8 2f             	cmp    $0x2f,%eax
  8021bf:	77 47                	ja     802208 <vprintfmt+0x615>
  8021c1:	89 c2                	mov    %eax,%edx
  8021c3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021c7:	83 c0 08             	add    $0x8,%eax
  8021ca:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021cd:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8021d0:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8021d5:	48 83 ec 08          	sub    $0x8,%rsp
  8021d9:	41 80 fd 58          	cmp    $0x58,%r13b
  8021dd:	0f 94 c0             	sete   %al
  8021e0:	0f b6 c0             	movzbl %al,%eax
  8021e3:	50                   	push   %rax
  8021e4:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  8021e9:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8021ed:	4c 89 f6             	mov    %r14,%rsi
  8021f0:	4c 89 e7             	mov    %r12,%rdi
  8021f3:	48 b8 e8 1a 80 00 00 	movabs $0x801ae8,%rax
  8021fa:	00 00 00 
  8021fd:	ff d0                	call   *%rax
            break;
  8021ff:	48 83 c4 10          	add    $0x10,%rsp
  802203:	e9 1c fa ff ff       	jmp    801c24 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  802208:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80220c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802210:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802214:	eb b7                	jmp    8021cd <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  802216:	45 89 cd             	mov    %r9d,%r13d
  802219:	84 c9                	test   %cl,%cl
  80221b:	75 2a                	jne    802247 <vprintfmt+0x654>
    switch (lflag) {
  80221d:	85 d2                	test   %edx,%edx
  80221f:	74 54                	je     802275 <vprintfmt+0x682>
  802221:	83 fa 01             	cmp    $0x1,%edx
  802224:	74 7c                	je     8022a2 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  802226:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802229:	83 f8 2f             	cmp    $0x2f,%eax
  80222c:	0f 87 9e 00 00 00    	ja     8022d0 <vprintfmt+0x6dd>
  802232:	89 c2                	mov    %eax,%edx
  802234:	48 01 d6             	add    %rdx,%rsi
  802237:	83 c0 08             	add    $0x8,%eax
  80223a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80223d:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802240:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  802245:	eb 8e                	jmp    8021d5 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802247:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80224a:	83 f8 2f             	cmp    $0x2f,%eax
  80224d:	77 18                	ja     802267 <vprintfmt+0x674>
  80224f:	89 c2                	mov    %eax,%edx
  802251:	48 01 d6             	add    %rdx,%rsi
  802254:	83 c0 08             	add    $0x8,%eax
  802257:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80225a:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80225d:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802262:	e9 6e ff ff ff       	jmp    8021d5 <vprintfmt+0x5e2>
  802267:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80226b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80226f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802273:	eb e5                	jmp    80225a <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  802275:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802278:	83 f8 2f             	cmp    $0x2f,%eax
  80227b:	77 17                	ja     802294 <vprintfmt+0x6a1>
  80227d:	89 c2                	mov    %eax,%edx
  80227f:	48 01 d6             	add    %rdx,%rsi
  802282:	83 c0 08             	add    $0x8,%eax
  802285:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802288:	8b 16                	mov    (%rsi),%edx
            base = 16;
  80228a:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  80228f:	e9 41 ff ff ff       	jmp    8021d5 <vprintfmt+0x5e2>
  802294:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802298:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80229c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022a0:	eb e6                	jmp    802288 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8022a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022a5:	83 f8 2f             	cmp    $0x2f,%eax
  8022a8:	77 18                	ja     8022c2 <vprintfmt+0x6cf>
  8022aa:	89 c2                	mov    %eax,%edx
  8022ac:	48 01 d6             	add    %rdx,%rsi
  8022af:	83 c0 08             	add    $0x8,%eax
  8022b2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022b5:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8022b8:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8022bd:	e9 13 ff ff ff       	jmp    8021d5 <vprintfmt+0x5e2>
  8022c2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022c6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022ce:	eb e5                	jmp    8022b5 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  8022d0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022d4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022d8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022dc:	e9 5c ff ff ff       	jmp    80223d <vprintfmt+0x64a>
            putch(ch, put_arg);
  8022e1:	4c 89 f6             	mov    %r14,%rsi
  8022e4:	bf 25 00 00 00       	mov    $0x25,%edi
  8022e9:	41 ff d4             	call   *%r12
            break;
  8022ec:	e9 33 f9 ff ff       	jmp    801c24 <vprintfmt+0x31>
            putch('%', put_arg);
  8022f1:	4c 89 f6             	mov    %r14,%rsi
  8022f4:	bf 25 00 00 00       	mov    $0x25,%edi
  8022f9:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  8022fc:	49 83 ef 01          	sub    $0x1,%r15
  802300:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  802305:	75 f5                	jne    8022fc <vprintfmt+0x709>
  802307:	e9 18 f9 ff ff       	jmp    801c24 <vprintfmt+0x31>
}
  80230c:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802310:	5b                   	pop    %rbx
  802311:	41 5c                	pop    %r12
  802313:	41 5d                	pop    %r13
  802315:	41 5e                	pop    %r14
  802317:	41 5f                	pop    %r15
  802319:	5d                   	pop    %rbp
  80231a:	c3                   	ret    

000000000080231b <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  80231b:	55                   	push   %rbp
  80231c:	48 89 e5             	mov    %rsp,%rbp
  80231f:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  802323:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802327:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  80232c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802330:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  802337:	48 85 ff             	test   %rdi,%rdi
  80233a:	74 2b                	je     802367 <vsnprintf+0x4c>
  80233c:	48 85 f6             	test   %rsi,%rsi
  80233f:	74 26                	je     802367 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  802341:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802345:	48 bf 9e 1b 80 00 00 	movabs $0x801b9e,%rdi
  80234c:	00 00 00 
  80234f:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802356:	00 00 00 
  802359:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  80235b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80235f:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  802362:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  802367:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80236c:	eb f7                	jmp    802365 <vsnprintf+0x4a>

000000000080236e <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  80236e:	55                   	push   %rbp
  80236f:	48 89 e5             	mov    %rsp,%rbp
  802372:	48 83 ec 50          	sub    $0x50,%rsp
  802376:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80237a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80237e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802382:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  802389:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80238d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802391:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802395:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  802399:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80239d:	48 b8 1b 23 80 00 00 	movabs $0x80231b,%rax
  8023a4:	00 00 00 
  8023a7:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

00000000008023ab <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  8023ab:	80 3f 00             	cmpb   $0x0,(%rdi)
  8023ae:	74 10                	je     8023c0 <strlen+0x15>
    size_t n = 0;
  8023b0:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8023b5:	48 83 c0 01          	add    $0x1,%rax
  8023b9:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023bd:	75 f6                	jne    8023b5 <strlen+0xa>
  8023bf:	c3                   	ret    
    size_t n = 0;
  8023c0:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  8023c5:	c3                   	ret    

00000000008023c6 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  8023cb:	48 85 f6             	test   %rsi,%rsi
  8023ce:	74 10                	je     8023e0 <strnlen+0x1a>
  8023d0:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023d4:	74 09                	je     8023df <strnlen+0x19>
  8023d6:	48 83 c0 01          	add    $0x1,%rax
  8023da:	48 39 c6             	cmp    %rax,%rsi
  8023dd:	75 f1                	jne    8023d0 <strnlen+0xa>
    return n;
}
  8023df:	c3                   	ret    
    size_t n = 0;
  8023e0:	48 89 f0             	mov    %rsi,%rax
  8023e3:	c3                   	ret    

00000000008023e4 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8023e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e9:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  8023ed:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  8023f0:	48 83 c0 01          	add    $0x1,%rax
  8023f4:	84 d2                	test   %dl,%dl
  8023f6:	75 f1                	jne    8023e9 <strcpy+0x5>
        ;
    return res;
}
  8023f8:	48 89 f8             	mov    %rdi,%rax
  8023fb:	c3                   	ret    

00000000008023fc <strcat>:

char *
strcat(char *dst, const char *src) {
  8023fc:	55                   	push   %rbp
  8023fd:	48 89 e5             	mov    %rsp,%rbp
  802400:	41 54                	push   %r12
  802402:	53                   	push   %rbx
  802403:	48 89 fb             	mov    %rdi,%rbx
  802406:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  802409:	48 b8 ab 23 80 00 00 	movabs $0x8023ab,%rax
  802410:	00 00 00 
  802413:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  802415:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  802419:	4c 89 e6             	mov    %r12,%rsi
  80241c:	48 b8 e4 23 80 00 00 	movabs $0x8023e4,%rax
  802423:	00 00 00 
  802426:	ff d0                	call   *%rax
    return dst;
}
  802428:	48 89 d8             	mov    %rbx,%rax
  80242b:	5b                   	pop    %rbx
  80242c:	41 5c                	pop    %r12
  80242e:	5d                   	pop    %rbp
  80242f:	c3                   	ret    

0000000000802430 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  802430:	48 85 d2             	test   %rdx,%rdx
  802433:	74 1d                	je     802452 <strncpy+0x22>
  802435:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802439:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  80243c:	48 83 c0 01          	add    $0x1,%rax
  802440:	0f b6 16             	movzbl (%rsi),%edx
  802443:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  802446:	80 fa 01             	cmp    $0x1,%dl
  802449:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  80244d:	48 39 c1             	cmp    %rax,%rcx
  802450:	75 ea                	jne    80243c <strncpy+0xc>
    }
    return ret;
}
  802452:	48 89 f8             	mov    %rdi,%rax
  802455:	c3                   	ret    

0000000000802456 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  802456:	48 89 f8             	mov    %rdi,%rax
  802459:	48 85 d2             	test   %rdx,%rdx
  80245c:	74 24                	je     802482 <strlcpy+0x2c>
        while (--size > 0 && *src)
  80245e:	48 83 ea 01          	sub    $0x1,%rdx
  802462:	74 1b                	je     80247f <strlcpy+0x29>
  802464:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802468:	0f b6 16             	movzbl (%rsi),%edx
  80246b:	84 d2                	test   %dl,%dl
  80246d:	74 10                	je     80247f <strlcpy+0x29>
            *dst++ = *src++;
  80246f:	48 83 c6 01          	add    $0x1,%rsi
  802473:	48 83 c0 01          	add    $0x1,%rax
  802477:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80247a:	48 39 c8             	cmp    %rcx,%rax
  80247d:	75 e9                	jne    802468 <strlcpy+0x12>
        *dst = '\0';
  80247f:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802482:	48 29 f8             	sub    %rdi,%rax
}
  802485:	c3                   	ret    

0000000000802486 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  802486:	0f b6 07             	movzbl (%rdi),%eax
  802489:	84 c0                	test   %al,%al
  80248b:	74 13                	je     8024a0 <strcmp+0x1a>
  80248d:	38 06                	cmp    %al,(%rsi)
  80248f:	75 0f                	jne    8024a0 <strcmp+0x1a>
  802491:	48 83 c7 01          	add    $0x1,%rdi
  802495:	48 83 c6 01          	add    $0x1,%rsi
  802499:	0f b6 07             	movzbl (%rdi),%eax
  80249c:	84 c0                	test   %al,%al
  80249e:	75 ed                	jne    80248d <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8024a0:	0f b6 c0             	movzbl %al,%eax
  8024a3:	0f b6 16             	movzbl (%rsi),%edx
  8024a6:	29 d0                	sub    %edx,%eax
}
  8024a8:	c3                   	ret    

00000000008024a9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  8024a9:	48 85 d2             	test   %rdx,%rdx
  8024ac:	74 1f                	je     8024cd <strncmp+0x24>
  8024ae:	0f b6 07             	movzbl (%rdi),%eax
  8024b1:	84 c0                	test   %al,%al
  8024b3:	74 1e                	je     8024d3 <strncmp+0x2a>
  8024b5:	3a 06                	cmp    (%rsi),%al
  8024b7:	75 1a                	jne    8024d3 <strncmp+0x2a>
  8024b9:	48 83 c7 01          	add    $0x1,%rdi
  8024bd:	48 83 c6 01          	add    $0x1,%rsi
  8024c1:	48 83 ea 01          	sub    $0x1,%rdx
  8024c5:	75 e7                	jne    8024ae <strncmp+0x5>

    if (!n) return 0;
  8024c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cc:	c3                   	ret    
  8024cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d2:	c3                   	ret    
  8024d3:	48 85 d2             	test   %rdx,%rdx
  8024d6:	74 09                	je     8024e1 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  8024d8:	0f b6 07             	movzbl (%rdi),%eax
  8024db:	0f b6 16             	movzbl (%rsi),%edx
  8024de:	29 d0                	sub    %edx,%eax
  8024e0:	c3                   	ret    
    if (!n) return 0;
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e6:	c3                   	ret    

00000000008024e7 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  8024e7:	0f b6 07             	movzbl (%rdi),%eax
  8024ea:	84 c0                	test   %al,%al
  8024ec:	74 18                	je     802506 <strchr+0x1f>
        if (*str == c) {
  8024ee:	0f be c0             	movsbl %al,%eax
  8024f1:	39 f0                	cmp    %esi,%eax
  8024f3:	74 17                	je     80250c <strchr+0x25>
    for (; *str; str++) {
  8024f5:	48 83 c7 01          	add    $0x1,%rdi
  8024f9:	0f b6 07             	movzbl (%rdi),%eax
  8024fc:	84 c0                	test   %al,%al
  8024fe:	75 ee                	jne    8024ee <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  802500:	b8 00 00 00 00       	mov    $0x0,%eax
  802505:	c3                   	ret    
  802506:	b8 00 00 00 00       	mov    $0x0,%eax
  80250b:	c3                   	ret    
  80250c:	48 89 f8             	mov    %rdi,%rax
}
  80250f:	c3                   	ret    

0000000000802510 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  802510:	0f b6 07             	movzbl (%rdi),%eax
  802513:	84 c0                	test   %al,%al
  802515:	74 16                	je     80252d <strfind+0x1d>
  802517:	0f be c0             	movsbl %al,%eax
  80251a:	39 f0                	cmp    %esi,%eax
  80251c:	74 13                	je     802531 <strfind+0x21>
  80251e:	48 83 c7 01          	add    $0x1,%rdi
  802522:	0f b6 07             	movzbl (%rdi),%eax
  802525:	84 c0                	test   %al,%al
  802527:	75 ee                	jne    802517 <strfind+0x7>
  802529:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  80252c:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  80252d:	48 89 f8             	mov    %rdi,%rax
  802530:	c3                   	ret    
  802531:	48 89 f8             	mov    %rdi,%rax
  802534:	c3                   	ret    

0000000000802535 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  802535:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  802538:	48 89 f8             	mov    %rdi,%rax
  80253b:	48 f7 d8             	neg    %rax
  80253e:	83 e0 07             	and    $0x7,%eax
  802541:	49 89 d1             	mov    %rdx,%r9
  802544:	49 29 c1             	sub    %rax,%r9
  802547:	78 32                	js     80257b <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  802549:	40 0f b6 c6          	movzbl %sil,%eax
  80254d:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  802554:	01 01 01 
  802557:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80255b:	40 f6 c7 07          	test   $0x7,%dil
  80255f:	75 34                	jne    802595 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  802561:	4c 89 c9             	mov    %r9,%rcx
  802564:	48 c1 f9 03          	sar    $0x3,%rcx
  802568:	74 08                	je     802572 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80256a:	fc                   	cld    
  80256b:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  80256e:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802572:	4d 85 c9             	test   %r9,%r9
  802575:	75 45                	jne    8025bc <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  802577:	4c 89 c0             	mov    %r8,%rax
  80257a:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  80257b:	48 85 d2             	test   %rdx,%rdx
  80257e:	74 f7                	je     802577 <memset+0x42>
  802580:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  802583:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  802586:	48 83 c0 01          	add    $0x1,%rax
  80258a:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80258e:	48 39 c2             	cmp    %rax,%rdx
  802591:	75 f3                	jne    802586 <memset+0x51>
  802593:	eb e2                	jmp    802577 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  802595:	40 f6 c7 01          	test   $0x1,%dil
  802599:	74 06                	je     8025a1 <memset+0x6c>
  80259b:	88 07                	mov    %al,(%rdi)
  80259d:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025a1:	40 f6 c7 02          	test   $0x2,%dil
  8025a5:	74 07                	je     8025ae <memset+0x79>
  8025a7:	66 89 07             	mov    %ax,(%rdi)
  8025aa:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025ae:	40 f6 c7 04          	test   $0x4,%dil
  8025b2:	74 ad                	je     802561 <memset+0x2c>
  8025b4:	89 07                	mov    %eax,(%rdi)
  8025b6:	48 83 c7 04          	add    $0x4,%rdi
  8025ba:	eb a5                	jmp    802561 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025bc:	41 f6 c1 04          	test   $0x4,%r9b
  8025c0:	74 06                	je     8025c8 <memset+0x93>
  8025c2:	89 07                	mov    %eax,(%rdi)
  8025c4:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025c8:	41 f6 c1 02          	test   $0x2,%r9b
  8025cc:	74 07                	je     8025d5 <memset+0xa0>
  8025ce:	66 89 07             	mov    %ax,(%rdi)
  8025d1:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8025d5:	41 f6 c1 01          	test   $0x1,%r9b
  8025d9:	74 9c                	je     802577 <memset+0x42>
  8025db:	88 07                	mov    %al,(%rdi)
  8025dd:	eb 98                	jmp    802577 <memset+0x42>

00000000008025df <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8025df:	48 89 f8             	mov    %rdi,%rax
  8025e2:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8025e5:	48 39 fe             	cmp    %rdi,%rsi
  8025e8:	73 39                	jae    802623 <memmove+0x44>
  8025ea:	48 01 f2             	add    %rsi,%rdx
  8025ed:	48 39 fa             	cmp    %rdi,%rdx
  8025f0:	76 31                	jbe    802623 <memmove+0x44>
        s += n;
        d += n;
  8025f2:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8025f5:	48 89 d6             	mov    %rdx,%rsi
  8025f8:	48 09 fe             	or     %rdi,%rsi
  8025fb:	48 09 ce             	or     %rcx,%rsi
  8025fe:	40 f6 c6 07          	test   $0x7,%sil
  802602:	75 12                	jne    802616 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  802604:	48 83 ef 08          	sub    $0x8,%rdi
  802608:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  80260c:	48 c1 e9 03          	shr    $0x3,%rcx
  802610:	fd                   	std    
  802611:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  802614:	fc                   	cld    
  802615:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  802616:	48 83 ef 01          	sub    $0x1,%rdi
  80261a:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80261e:	fd                   	std    
  80261f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  802621:	eb f1                	jmp    802614 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802623:	48 89 f2             	mov    %rsi,%rdx
  802626:	48 09 c2             	or     %rax,%rdx
  802629:	48 09 ca             	or     %rcx,%rdx
  80262c:	f6 c2 07             	test   $0x7,%dl
  80262f:	75 0c                	jne    80263d <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  802631:	48 c1 e9 03          	shr    $0x3,%rcx
  802635:	48 89 c7             	mov    %rax,%rdi
  802638:	fc                   	cld    
  802639:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80263c:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80263d:	48 89 c7             	mov    %rax,%rdi
  802640:	fc                   	cld    
  802641:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  802643:	c3                   	ret    

0000000000802644 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  802644:	55                   	push   %rbp
  802645:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802648:	48 b8 df 25 80 00 00 	movabs $0x8025df,%rax
  80264f:	00 00 00 
  802652:	ff d0                	call   *%rax
}
  802654:	5d                   	pop    %rbp
  802655:	c3                   	ret    

0000000000802656 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802656:	55                   	push   %rbp
  802657:	48 89 e5             	mov    %rsp,%rbp
  80265a:	41 57                	push   %r15
  80265c:	41 56                	push   %r14
  80265e:	41 55                	push   %r13
  802660:	41 54                	push   %r12
  802662:	53                   	push   %rbx
  802663:	48 83 ec 08          	sub    $0x8,%rsp
  802667:	49 89 fe             	mov    %rdi,%r14
  80266a:	49 89 f7             	mov    %rsi,%r15
  80266d:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  802670:	48 89 f7             	mov    %rsi,%rdi
  802673:	48 b8 ab 23 80 00 00 	movabs $0x8023ab,%rax
  80267a:	00 00 00 
  80267d:	ff d0                	call   *%rax
  80267f:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  802682:	48 89 de             	mov    %rbx,%rsi
  802685:	4c 89 f7             	mov    %r14,%rdi
  802688:	48 b8 c6 23 80 00 00 	movabs $0x8023c6,%rax
  80268f:	00 00 00 
  802692:	ff d0                	call   *%rax
  802694:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  802697:	48 39 c3             	cmp    %rax,%rbx
  80269a:	74 36                	je     8026d2 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  80269c:	48 89 d8             	mov    %rbx,%rax
  80269f:	4c 29 e8             	sub    %r13,%rax
  8026a2:	4c 39 e0             	cmp    %r12,%rax
  8026a5:	76 30                	jbe    8026d7 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  8026a7:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8026ac:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026b0:	4c 89 fe             	mov    %r15,%rsi
  8026b3:	48 b8 44 26 80 00 00 	movabs $0x802644,%rax
  8026ba:	00 00 00 
  8026bd:	ff d0                	call   *%rax
    return dstlen + srclen;
  8026bf:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8026c3:	48 83 c4 08          	add    $0x8,%rsp
  8026c7:	5b                   	pop    %rbx
  8026c8:	41 5c                	pop    %r12
  8026ca:	41 5d                	pop    %r13
  8026cc:	41 5e                	pop    %r14
  8026ce:	41 5f                	pop    %r15
  8026d0:	5d                   	pop    %rbp
  8026d1:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8026d2:	4c 01 e0             	add    %r12,%rax
  8026d5:	eb ec                	jmp    8026c3 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8026d7:	48 83 eb 01          	sub    $0x1,%rbx
  8026db:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026df:	48 89 da             	mov    %rbx,%rdx
  8026e2:	4c 89 fe             	mov    %r15,%rsi
  8026e5:	48 b8 44 26 80 00 00 	movabs $0x802644,%rax
  8026ec:	00 00 00 
  8026ef:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8026f1:	49 01 de             	add    %rbx,%r14
  8026f4:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8026f9:	eb c4                	jmp    8026bf <strlcat+0x69>

00000000008026fb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8026fb:	49 89 f0             	mov    %rsi,%r8
  8026fe:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  802701:	48 85 d2             	test   %rdx,%rdx
  802704:	74 2a                	je     802730 <memcmp+0x35>
  802706:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  80270b:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  80270f:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  802714:	38 ca                	cmp    %cl,%dl
  802716:	75 0f                	jne    802727 <memcmp+0x2c>
    while (n-- > 0) {
  802718:	48 83 c0 01          	add    $0x1,%rax
  80271c:	48 39 c6             	cmp    %rax,%rsi
  80271f:	75 ea                	jne    80270b <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  802721:	b8 00 00 00 00       	mov    $0x0,%eax
  802726:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  802727:	0f b6 c2             	movzbl %dl,%eax
  80272a:	0f b6 c9             	movzbl %cl,%ecx
  80272d:	29 c8                	sub    %ecx,%eax
  80272f:	c3                   	ret    
    return 0;
  802730:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802735:	c3                   	ret    

0000000000802736 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  802736:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80273a:	48 39 c7             	cmp    %rax,%rdi
  80273d:	73 0f                	jae    80274e <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  80273f:	40 38 37             	cmp    %sil,(%rdi)
  802742:	74 0e                	je     802752 <memfind+0x1c>
    for (; src < end; src++) {
  802744:	48 83 c7 01          	add    $0x1,%rdi
  802748:	48 39 f8             	cmp    %rdi,%rax
  80274b:	75 f2                	jne    80273f <memfind+0x9>
  80274d:	c3                   	ret    
  80274e:	48 89 f8             	mov    %rdi,%rax
  802751:	c3                   	ret    
  802752:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802755:	c3                   	ret    

0000000000802756 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802756:	49 89 f2             	mov    %rsi,%r10
  802759:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80275c:	0f b6 37             	movzbl (%rdi),%esi
  80275f:	40 80 fe 20          	cmp    $0x20,%sil
  802763:	74 06                	je     80276b <strtol+0x15>
  802765:	40 80 fe 09          	cmp    $0x9,%sil
  802769:	75 13                	jne    80277e <strtol+0x28>
  80276b:	48 83 c7 01          	add    $0x1,%rdi
  80276f:	0f b6 37             	movzbl (%rdi),%esi
  802772:	40 80 fe 20          	cmp    $0x20,%sil
  802776:	74 f3                	je     80276b <strtol+0x15>
  802778:	40 80 fe 09          	cmp    $0x9,%sil
  80277c:	74 ed                	je     80276b <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  80277e:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802781:	83 e0 fd             	and    $0xfffffffd,%eax
  802784:	3c 01                	cmp    $0x1,%al
  802786:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80278a:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  802791:	75 11                	jne    8027a4 <strtol+0x4e>
  802793:	80 3f 30             	cmpb   $0x30,(%rdi)
  802796:	74 16                	je     8027ae <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802798:	45 85 c0             	test   %r8d,%r8d
  80279b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8027a0:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8027a4:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8027a9:	4d 63 c8             	movslq %r8d,%r9
  8027ac:	eb 38                	jmp    8027e6 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8027ae:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8027b2:	74 11                	je     8027c5 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8027b4:	45 85 c0             	test   %r8d,%r8d
  8027b7:	75 eb                	jne    8027a4 <strtol+0x4e>
        s++;
  8027b9:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8027bd:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8027c3:	eb df                	jmp    8027a4 <strtol+0x4e>
        s += 2;
  8027c5:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8027c9:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8027cf:	eb d3                	jmp    8027a4 <strtol+0x4e>
            dig -= '0';
  8027d1:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8027d4:	0f b6 c8             	movzbl %al,%ecx
  8027d7:	44 39 c1             	cmp    %r8d,%ecx
  8027da:	7d 1f                	jge    8027fb <strtol+0xa5>
        val = val * base + dig;
  8027dc:	49 0f af d1          	imul   %r9,%rdx
  8027e0:	0f b6 c0             	movzbl %al,%eax
  8027e3:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8027e6:	48 83 c7 01          	add    $0x1,%rdi
  8027ea:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8027ee:	3c 39                	cmp    $0x39,%al
  8027f0:	76 df                	jbe    8027d1 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8027f2:	3c 7b                	cmp    $0x7b,%al
  8027f4:	77 05                	ja     8027fb <strtol+0xa5>
            dig -= 'a' - 10;
  8027f6:	83 e8 57             	sub    $0x57,%eax
  8027f9:	eb d9                	jmp    8027d4 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8027fb:	4d 85 d2             	test   %r10,%r10
  8027fe:	74 03                	je     802803 <strtol+0xad>
  802800:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802803:	48 89 d0             	mov    %rdx,%rax
  802806:	48 f7 d8             	neg    %rax
  802809:	40 80 fe 2d          	cmp    $0x2d,%sil
  80280d:	48 0f 44 d0          	cmove  %rax,%rdx
}
  802811:	48 89 d0             	mov    %rdx,%rax
  802814:	c3                   	ret    

0000000000802815 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802815:	55                   	push   %rbp
  802816:	48 89 e5             	mov    %rsp,%rbp
  802819:	41 54                	push   %r12
  80281b:	53                   	push   %rbx
  80281c:	48 89 fb             	mov    %rdi,%rbx
  80281f:	48 89 f7             	mov    %rsi,%rdi
  802822:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802825:	48 85 f6             	test   %rsi,%rsi
  802828:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80282f:	00 00 00 
  802832:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802836:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  80283b:	48 85 d2             	test   %rdx,%rdx
  80283e:	74 02                	je     802842 <ipc_recv+0x2d>
  802840:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802842:	48 63 f6             	movslq %esi,%rsi
  802845:	48 b8 2a 05 80 00 00 	movabs $0x80052a,%rax
  80284c:	00 00 00 
  80284f:	ff d0                	call   *%rax

    if (res < 0) {
  802851:	85 c0                	test   %eax,%eax
  802853:	78 45                	js     80289a <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802855:	48 85 db             	test   %rbx,%rbx
  802858:	74 12                	je     80286c <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  80285a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802861:	00 00 00 
  802864:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80286a:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  80286c:	4d 85 e4             	test   %r12,%r12
  80286f:	74 14                	je     802885 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802871:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802878:	00 00 00 
  80287b:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802881:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802885:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80288c:	00 00 00 
  80288f:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802895:	5b                   	pop    %rbx
  802896:	41 5c                	pop    %r12
  802898:	5d                   	pop    %rbp
  802899:	c3                   	ret    
        if (from_env_store)
  80289a:	48 85 db             	test   %rbx,%rbx
  80289d:	74 06                	je     8028a5 <ipc_recv+0x90>
            *from_env_store = 0;
  80289f:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8028a5:	4d 85 e4             	test   %r12,%r12
  8028a8:	74 eb                	je     802895 <ipc_recv+0x80>
            *perm_store = 0;
  8028aa:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028b1:	00 
  8028b2:	eb e1                	jmp    802895 <ipc_recv+0x80>

00000000008028b4 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028b4:	55                   	push   %rbp
  8028b5:	48 89 e5             	mov    %rsp,%rbp
  8028b8:	41 57                	push   %r15
  8028ba:	41 56                	push   %r14
  8028bc:	41 55                	push   %r13
  8028be:	41 54                	push   %r12
  8028c0:	53                   	push   %rbx
  8028c1:	48 83 ec 18          	sub    $0x18,%rsp
  8028c5:	41 89 fd             	mov    %edi,%r13d
  8028c8:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028cb:	48 89 d3             	mov    %rdx,%rbx
  8028ce:	49 89 cc             	mov    %rcx,%r12
  8028d1:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028d5:	48 85 d2             	test   %rdx,%rdx
  8028d8:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8028df:	00 00 00 
  8028e2:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028e6:	49 be fe 04 80 00 00 	movabs $0x8004fe,%r14
  8028ed:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  8028f0:	49 bf 01 02 80 00 00 	movabs $0x800201,%r15
  8028f7:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028fa:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8028fd:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802901:	4c 89 e1             	mov    %r12,%rcx
  802904:	48 89 da             	mov    %rbx,%rdx
  802907:	44 89 ef             	mov    %r13d,%edi
  80290a:	41 ff d6             	call   *%r14
  80290d:	85 c0                	test   %eax,%eax
  80290f:	79 37                	jns    802948 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802911:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802914:	75 05                	jne    80291b <ipc_send+0x67>
          sys_yield();
  802916:	41 ff d7             	call   *%r15
  802919:	eb df                	jmp    8028fa <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  80291b:	89 c1                	mov    %eax,%ecx
  80291d:	48 ba 3f 30 80 00 00 	movabs $0x80303f,%rdx
  802924:	00 00 00 
  802927:	be 46 00 00 00       	mov    $0x46,%esi
  80292c:	48 bf 52 30 80 00 00 	movabs $0x803052,%rdi
  802933:	00 00 00 
  802936:	b8 00 00 00 00       	mov    $0x0,%eax
  80293b:	49 b8 53 19 80 00 00 	movabs $0x801953,%r8
  802942:	00 00 00 
  802945:	41 ff d0             	call   *%r8
      }
}
  802948:	48 83 c4 18          	add    $0x18,%rsp
  80294c:	5b                   	pop    %rbx
  80294d:	41 5c                	pop    %r12
  80294f:	41 5d                	pop    %r13
  802951:	41 5e                	pop    %r14
  802953:	41 5f                	pop    %r15
  802955:	5d                   	pop    %rbp
  802956:	c3                   	ret    

0000000000802957 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802957:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80295c:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802963:	00 00 00 
  802966:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80296a:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80296e:	48 c1 e2 04          	shl    $0x4,%rdx
  802972:	48 01 ca             	add    %rcx,%rdx
  802975:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  80297b:	39 fa                	cmp    %edi,%edx
  80297d:	74 12                	je     802991 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  80297f:	48 83 c0 01          	add    $0x1,%rax
  802983:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802989:	75 db                	jne    802966 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  80298b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802990:	c3                   	ret    
            return envs[i].env_id;
  802991:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802995:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802999:	48 c1 e0 04          	shl    $0x4,%rax
  80299d:	48 89 c2             	mov    %rax,%rdx
  8029a0:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8029a7:	00 00 00 
  8029aa:	48 01 d0             	add    %rdx,%rax
  8029ad:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029b3:	c3                   	ret    
  8029b4:	0f 1f 40 00          	nopl   0x0(%rax)

00000000008029b8 <__rodata_start>:
  8029b8:	3c 75                	cmp    $0x75,%al
  8029ba:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029bb:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8029bf:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029c0:	3e 00 66 0f          	ds add %ah,0xf(%rsi)
  8029c4:	1f                   	(bad)  
  8029c5:	44 00 00             	add    %r8b,(%rax)
  8029c8:	73 79                	jae    802a43 <__rodata_start+0x8b>
  8029ca:	73 63                	jae    802a2f <__rodata_start+0x77>
  8029cc:	61                   	(bad)  
  8029cd:	6c                   	insb   (%dx),%es:(%rdi)
  8029ce:	6c                   	insb   (%dx),%es:(%rdi)
  8029cf:	20 25 7a 64 20 72    	and    %ah,0x7220647a(%rip)        # 72a08e4f <__bss_end+0x72200e4f>
  8029d5:	65 74 75             	gs je  802a4d <__rodata_start+0x95>
  8029d8:	72 6e                	jb     802a48 <__rodata_start+0x90>
  8029da:	65 64 20 25 7a 64 20 	gs and %ah,%fs:0x2820647a(%rip)        # 28a08e5c <__bss_end+0x28200e5c>
  8029e1:	28 
  8029e2:	3e 20 30             	ds and %dh,(%rax)
  8029e5:	29 00                	sub    %eax,(%rax)
  8029e7:	6c                   	insb   (%dx),%es:(%rdi)
  8029e8:	69 62 2f 73 79 73 63 	imul   $0x63737973,0x2f(%rdx),%esp
  8029ef:	61                   	(bad)  
  8029f0:	6c                   	insb   (%dx),%es:(%rdi)
  8029f1:	6c                   	insb   (%dx),%es:(%rdi)
  8029f2:	2e 63 00             	cs movsxd (%rax),%eax
  8029f5:	0f 1f 00             	nopl   (%rax)
  8029f8:	5b                   	pop    %rbx
  8029f9:	25 30 38 78 5d       	and    $0x5d783830,%eax
  8029fe:	20 75 6e             	and    %dh,0x6e(%rbp)
  802a01:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802a05:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a06:	20 64 65 76          	and    %ah,0x76(%rbp,%riz,2)
  802a0a:	69 63 65 20 74 79 70 	imul   $0x70797420,0x65(%rbx),%esp
  802a11:	65 20 25 64 0a 00 00 	and    %ah,%gs:0xa64(%rip)        # 80347c <error_string+0x4fc>
  802a18:	5b                   	pop    %rbx
  802a19:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a1e:	20 66 74             	and    %ah,0x74(%rsi)
  802a21:	72 75                	jb     802a98 <devtab+0x18>
  802a23:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a24:	63 61 74             	movsxd 0x74(%rcx),%esp
  802a27:	65 20 25 64 20 2d 2d 	and    %ah,%gs:0x2d2d2064(%rip)        # 2dad4a92 <__bss_end+0x2d2cca92>
  802a2e:	20 62 61             	and    %ah,0x61(%rdx)
  802a31:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a35:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a39:	5b                   	pop    %rbx
  802a3a:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a3f:	20 72 65             	and    %dh,0x65(%rdx)
  802a42:	61                   	(bad)  
  802a43:	64 20 25 64 20 2d 2d 	and    %ah,%fs:0x2d2d2064(%rip)        # 2dad4aae <__bss_end+0x2d2ccaae>
  802a4a:	20 62 61             	and    %ah,0x61(%rdx)
  802a4d:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a51:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a55:	5b                   	pop    %rbx
  802a56:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a5b:	20 77 72             	and    %dh,0x72(%rdi)
  802a5e:	69 74 65 20 25 64 20 	imul   $0x2d206425,0x20(%rbp,%riz,2),%esi
  802a65:	2d 
  802a66:	2d 20 62 61 64       	sub    $0x64616220,%eax
  802a6b:	20 6d 6f             	and    %ch,0x6f(%rbp)
  802a6e:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802a79:	00 00 00 
  802a7c:	0f 1f 40 00          	nopl   0x0(%rax)

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
  802cc0:	9d 1c 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ........."......
  802cd0:	e1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802ce0:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802cf0:	f1 22 80 00 00 00 00 00 b7 1c 80 00 00 00 00 00     ."..............
  802d00:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802d10:	ae 1c 80 00 00 00 00 00 24 1d 80 00 00 00 00 00     ........$.......
  802d20:	f1 22 80 00 00 00 00 00 ae 1c 80 00 00 00 00 00     ."..............
  802d30:	f1 1c 80 00 00 00 00 00 f1 1c 80 00 00 00 00 00     ................
  802d40:	f1 1c 80 00 00 00 00 00 f1 1c 80 00 00 00 00 00     ................
  802d50:	f1 1c 80 00 00 00 00 00 f1 1c 80 00 00 00 00 00     ................
  802d60:	f1 1c 80 00 00 00 00 00 f1 1c 80 00 00 00 00 00     ................
  802d70:	f1 1c 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ........."......
  802d80:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802d90:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802da0:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802db0:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802dc0:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802dd0:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802de0:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802df0:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802e00:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802e10:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802e20:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802e30:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802e40:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802e50:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802e60:	f1 22 80 00 00 00 00 00 16 22 80 00 00 00 00 00     ."......."......
  802e70:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802e80:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802e90:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802ea0:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802eb0:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802ec0:	42 1d 80 00 00 00 00 00 38 1f 80 00 00 00 00 00     B.......8.......
  802ed0:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802ee0:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802ef0:	70 1d 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     p........"......
  802f00:	f1 22 80 00 00 00 00 00 37 1d 80 00 00 00 00 00     ."......7.......
  802f10:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802f20:	d8 20 80 00 00 00 00 00 a0 21 80 00 00 00 00 00     . .......!......
  802f30:	f1 22 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ."......."......
  802f40:	08 1e 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     ........."......
  802f50:	0a 20 80 00 00 00 00 00 f1 22 80 00 00 00 00 00     . ......."......
  802f60:	f1 22 80 00 00 00 00 00 16 22 80 00 00 00 00 00     ."......."......
  802f70:	f1 22 80 00 00 00 00 00 a6 1c 80 00 00 00 00 00     ."..............

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
