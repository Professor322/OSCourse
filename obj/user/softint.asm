
obj/user/softint:     file format elf64-x86-64


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
  80001e:	e8 05 00 00 00       	call   800028 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv) {
    asm volatile("int $14"); /* page fault */
  800025:	cd 0e                	int    $0xe
}
  800027:	c3                   	ret    

0000000000800028 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800028:	55                   	push   %rbp
  800029:	48 89 e5             	mov    %rsp,%rbp
  80002c:	41 56                	push   %r14
  80002e:	41 55                	push   %r13
  800030:	41 54                	push   %r12
  800032:	53                   	push   %rbx
  800033:	41 89 fd             	mov    %edi,%r13d
  800036:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800039:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800040:	00 00 00 
  800043:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80004a:	00 00 00 
  80004d:	48 39 c2             	cmp    %rax,%rdx
  800050:	73 17                	jae    800069 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800052:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800055:	49 89 c4             	mov    %rax,%r12
  800058:	48 83 c3 08          	add    $0x8,%rbx
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	ff 53 f8             	call   *-0x8(%rbx)
  800064:	4c 39 e3             	cmp    %r12,%rbx
  800067:	72 ef                	jb     800058 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800069:	48 b8 c2 01 80 00 00 	movabs $0x8001c2,%rax
  800070:	00 00 00 
  800073:	ff d0                	call   *%rax
  800075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007a:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80007e:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800082:	48 c1 e0 04          	shl    $0x4,%rax
  800086:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  80008d:	00 00 00 
  800090:	48 01 d0             	add    %rdx,%rax
  800093:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80009a:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80009d:	45 85 ed             	test   %r13d,%r13d
  8000a0:	7e 0d                	jle    8000af <libmain+0x87>
  8000a2:	49 8b 06             	mov    (%r14),%rax
  8000a5:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000ac:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000af:	4c 89 f6             	mov    %r14,%rsi
  8000b2:	44 89 ef             	mov    %r13d,%edi
  8000b5:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000bc:	00 00 00 
  8000bf:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000c1:	48 b8 d6 00 80 00 00 	movabs $0x8000d6,%rax
  8000c8:	00 00 00 
  8000cb:	ff d0                	call   *%rax
#endif
}
  8000cd:	5b                   	pop    %rbx
  8000ce:	41 5c                	pop    %r12
  8000d0:	41 5d                	pop    %r13
  8000d2:	41 5e                	pop    %r14
  8000d4:	5d                   	pop    %rbp
  8000d5:	c3                   	ret    

00000000008000d6 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000d6:	55                   	push   %rbp
  8000d7:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000da:	48 b8 12 08 80 00 00 	movabs $0x800812,%rax
  8000e1:	00 00 00 
  8000e4:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8000e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8000eb:	48 b8 57 01 80 00 00 	movabs $0x800157,%rax
  8000f2:	00 00 00 
  8000f5:	ff d0                	call   *%rax
}
  8000f7:	5d                   	pop    %rbp
  8000f8:	c3                   	ret    

00000000008000f9 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8000f9:	55                   	push   %rbp
  8000fa:	48 89 e5             	mov    %rsp,%rbp
  8000fd:	53                   	push   %rbx
  8000fe:	48 89 fa             	mov    %rdi,%rdx
  800101:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800104:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800109:	bb 00 00 00 00       	mov    $0x0,%ebx
  80010e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800113:	be 00 00 00 00       	mov    $0x0,%esi
  800118:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80011e:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800120:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800124:	c9                   	leave  
  800125:	c3                   	ret    

0000000000800126 <sys_cgetc>:

int
sys_cgetc(void) {
  800126:	55                   	push   %rbp
  800127:	48 89 e5             	mov    %rsp,%rbp
  80012a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80012b:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80013a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80013f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800144:	be 00 00 00 00       	mov    $0x0,%esi
  800149:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80014f:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800151:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800155:	c9                   	leave  
  800156:	c3                   	ret    

0000000000800157 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800157:	55                   	push   %rbp
  800158:	48 89 e5             	mov    %rsp,%rbp
  80015b:	53                   	push   %rbx
  80015c:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800160:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800163:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800168:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80016d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800172:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800177:	be 00 00 00 00       	mov    $0x0,%esi
  80017c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800182:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800184:	48 85 c0             	test   %rax,%rax
  800187:	7f 06                	jg     80018f <sys_env_destroy+0x38>
}
  800189:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80018f:	49 89 c0             	mov    %rax,%r8
  800192:	b9 03 00 00 00       	mov    $0x3,%ecx
  800197:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  80019e:	00 00 00 
  8001a1:	be 26 00 00 00       	mov    $0x26,%esi
  8001a6:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  8001ad:	00 00 00 
  8001b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b5:	49 b9 45 19 80 00 00 	movabs $0x801945,%r9
  8001bc:	00 00 00 
  8001bf:	41 ff d1             	call   *%r9

00000000008001c2 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001c2:	55                   	push   %rbp
  8001c3:	48 89 e5             	mov    %rsp,%rbp
  8001c6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001c7:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8001d1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001db:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001e0:	be 00 00 00 00       	mov    $0x0,%esi
  8001e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001eb:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8001ed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001f1:	c9                   	leave  
  8001f2:	c3                   	ret    

00000000008001f3 <sys_yield>:

void
sys_yield(void) {
  8001f3:	55                   	push   %rbp
  8001f4:	48 89 e5             	mov    %rsp,%rbp
  8001f7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001f8:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800202:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800207:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800211:	be 00 00 00 00       	mov    $0x0,%esi
  800216:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80021c:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80021e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800222:	c9                   	leave  
  800223:	c3                   	ret    

0000000000800224 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  800224:	55                   	push   %rbp
  800225:	48 89 e5             	mov    %rsp,%rbp
  800228:	53                   	push   %rbx
  800229:	48 89 fa             	mov    %rdi,%rdx
  80022c:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80022f:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800234:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80023b:	00 00 00 
  80023e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800243:	be 00 00 00 00       	mov    $0x0,%esi
  800248:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80024e:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800250:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800254:	c9                   	leave  
  800255:	c3                   	ret    

0000000000800256 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  800256:	55                   	push   %rbp
  800257:	48 89 e5             	mov    %rsp,%rbp
  80025a:	53                   	push   %rbx
  80025b:	49 89 f8             	mov    %rdi,%r8
  80025e:	48 89 d3             	mov    %rdx,%rbx
  800261:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  800264:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800269:	4c 89 c2             	mov    %r8,%rdx
  80026c:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80026f:	be 00 00 00 00       	mov    $0x0,%esi
  800274:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80027a:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80027c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800280:	c9                   	leave  
  800281:	c3                   	ret    

0000000000800282 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  800282:	55                   	push   %rbp
  800283:	48 89 e5             	mov    %rsp,%rbp
  800286:	53                   	push   %rbx
  800287:	48 83 ec 08          	sub    $0x8,%rsp
  80028b:	89 f8                	mov    %edi,%eax
  80028d:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  800290:	48 63 f9             	movslq %ecx,%rdi
  800293:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800296:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80029b:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80029e:	be 00 00 00 00       	mov    $0x0,%esi
  8002a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002a9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002ab:	48 85 c0             	test   %rax,%rax
  8002ae:	7f 06                	jg     8002b6 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002b0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002b6:	49 89 c0             	mov    %rax,%r8
  8002b9:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002be:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  8002c5:	00 00 00 
  8002c8:	be 26 00 00 00       	mov    $0x26,%esi
  8002cd:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  8002d4:	00 00 00 
  8002d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dc:	49 b9 45 19 80 00 00 	movabs $0x801945,%r9
  8002e3:	00 00 00 
  8002e6:	41 ff d1             	call   *%r9

00000000008002e9 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8002e9:	55                   	push   %rbp
  8002ea:	48 89 e5             	mov    %rsp,%rbp
  8002ed:	53                   	push   %rbx
  8002ee:	48 83 ec 08          	sub    $0x8,%rsp
  8002f2:	89 f8                	mov    %edi,%eax
  8002f4:	49 89 f2             	mov    %rsi,%r10
  8002f7:	48 89 cf             	mov    %rcx,%rdi
  8002fa:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8002fd:	48 63 da             	movslq %edx,%rbx
  800300:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800303:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800308:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80030b:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80030e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800310:	48 85 c0             	test   %rax,%rax
  800313:	7f 06                	jg     80031b <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  800315:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800319:	c9                   	leave  
  80031a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80031b:	49 89 c0             	mov    %rax,%r8
  80031e:	b9 05 00 00 00       	mov    $0x5,%ecx
  800323:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  80032a:	00 00 00 
  80032d:	be 26 00 00 00       	mov    $0x26,%esi
  800332:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  800339:	00 00 00 
  80033c:	b8 00 00 00 00       	mov    $0x0,%eax
  800341:	49 b9 45 19 80 00 00 	movabs $0x801945,%r9
  800348:	00 00 00 
  80034b:	41 ff d1             	call   *%r9

000000000080034e <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80034e:	55                   	push   %rbp
  80034f:	48 89 e5             	mov    %rsp,%rbp
  800352:	53                   	push   %rbx
  800353:	48 83 ec 08          	sub    $0x8,%rsp
  800357:	48 89 f1             	mov    %rsi,%rcx
  80035a:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80035d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800360:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800365:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80036a:	be 00 00 00 00       	mov    $0x0,%esi
  80036f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800375:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800377:	48 85 c0             	test   %rax,%rax
  80037a:	7f 06                	jg     800382 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80037c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800380:	c9                   	leave  
  800381:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800382:	49 89 c0             	mov    %rax,%r8
  800385:	b9 06 00 00 00       	mov    $0x6,%ecx
  80038a:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  800391:	00 00 00 
  800394:	be 26 00 00 00       	mov    $0x26,%esi
  800399:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  8003a0:	00 00 00 
  8003a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a8:	49 b9 45 19 80 00 00 	movabs $0x801945,%r9
  8003af:	00 00 00 
  8003b2:	41 ff d1             	call   *%r9

00000000008003b5 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8003b5:	55                   	push   %rbp
  8003b6:	48 89 e5             	mov    %rsp,%rbp
  8003b9:	53                   	push   %rbx
  8003ba:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8003be:	48 63 ce             	movslq %esi,%rcx
  8003c1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8003c4:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8003c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003ce:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003d3:	be 00 00 00 00       	mov    $0x0,%esi
  8003d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003de:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003e0:	48 85 c0             	test   %rax,%rax
  8003e3:	7f 06                	jg     8003eb <sys_env_set_status+0x36>
}
  8003e5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003e9:	c9                   	leave  
  8003ea:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003eb:	49 89 c0             	mov    %rax,%r8
  8003ee:	b9 09 00 00 00       	mov    $0x9,%ecx
  8003f3:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  8003fa:	00 00 00 
  8003fd:	be 26 00 00 00       	mov    $0x26,%esi
  800402:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  800409:	00 00 00 
  80040c:	b8 00 00 00 00       	mov    $0x0,%eax
  800411:	49 b9 45 19 80 00 00 	movabs $0x801945,%r9
  800418:	00 00 00 
  80041b:	41 ff d1             	call   *%r9

000000000080041e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80041e:	55                   	push   %rbp
  80041f:	48 89 e5             	mov    %rsp,%rbp
  800422:	53                   	push   %rbx
  800423:	48 83 ec 08          	sub    $0x8,%rsp
  800427:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80042a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80042d:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800432:	bb 00 00 00 00       	mov    $0x0,%ebx
  800437:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80043c:	be 00 00 00 00       	mov    $0x0,%esi
  800441:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800447:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800449:	48 85 c0             	test   %rax,%rax
  80044c:	7f 06                	jg     800454 <sys_env_set_trapframe+0x36>
}
  80044e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800452:	c9                   	leave  
  800453:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800454:	49 89 c0             	mov    %rax,%r8
  800457:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80045c:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  800463:	00 00 00 
  800466:	be 26 00 00 00       	mov    $0x26,%esi
  80046b:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  800472:	00 00 00 
  800475:	b8 00 00 00 00       	mov    $0x0,%eax
  80047a:	49 b9 45 19 80 00 00 	movabs $0x801945,%r9
  800481:	00 00 00 
  800484:	41 ff d1             	call   *%r9

0000000000800487 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  800487:	55                   	push   %rbp
  800488:	48 89 e5             	mov    %rsp,%rbp
  80048b:	53                   	push   %rbx
  80048c:	48 83 ec 08          	sub    $0x8,%rsp
  800490:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  800493:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800496:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80049b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004a0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004a5:	be 00 00 00 00       	mov    $0x0,%esi
  8004aa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004b0:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004b2:	48 85 c0             	test   %rax,%rax
  8004b5:	7f 06                	jg     8004bd <sys_env_set_pgfault_upcall+0x36>
}
  8004b7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004bb:	c9                   	leave  
  8004bc:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004bd:	49 89 c0             	mov    %rax,%r8
  8004c0:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8004c5:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  8004cc:	00 00 00 
  8004cf:	be 26 00 00 00       	mov    $0x26,%esi
  8004d4:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  8004db:	00 00 00 
  8004de:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e3:	49 b9 45 19 80 00 00 	movabs $0x801945,%r9
  8004ea:	00 00 00 
  8004ed:	41 ff d1             	call   *%r9

00000000008004f0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8004f0:	55                   	push   %rbp
  8004f1:	48 89 e5             	mov    %rsp,%rbp
  8004f4:	53                   	push   %rbx
  8004f5:	89 f8                	mov    %edi,%eax
  8004f7:	49 89 f1             	mov    %rsi,%r9
  8004fa:	48 89 d3             	mov    %rdx,%rbx
  8004fd:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  800500:	49 63 f0             	movslq %r8d,%rsi
  800503:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800506:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80050b:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80050e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800514:	cd 30                	int    $0x30
}
  800516:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80051a:	c9                   	leave  
  80051b:	c3                   	ret    

000000000080051c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80051c:	55                   	push   %rbp
  80051d:	48 89 e5             	mov    %rsp,%rbp
  800520:	53                   	push   %rbx
  800521:	48 83 ec 08          	sub    $0x8,%rsp
  800525:	48 89 fa             	mov    %rdi,%rdx
  800528:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80052b:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800530:	bb 00 00 00 00       	mov    $0x0,%ebx
  800535:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80053a:	be 00 00 00 00       	mov    $0x0,%esi
  80053f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800545:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800547:	48 85 c0             	test   %rax,%rax
  80054a:	7f 06                	jg     800552 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80054c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800550:	c9                   	leave  
  800551:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800552:	49 89 c0             	mov    %rax,%r8
  800555:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80055a:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  800561:	00 00 00 
  800564:	be 26 00 00 00       	mov    $0x26,%esi
  800569:	48 bf d7 29 80 00 00 	movabs $0x8029d7,%rdi
  800570:	00 00 00 
  800573:	b8 00 00 00 00       	mov    $0x0,%eax
  800578:	49 b9 45 19 80 00 00 	movabs $0x801945,%r9
  80057f:	00 00 00 
  800582:	41 ff d1             	call   *%r9

0000000000800585 <sys_gettime>:

int
sys_gettime(void) {
  800585:	55                   	push   %rbp
  800586:	48 89 e5             	mov    %rsp,%rbp
  800589:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80058a:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80058f:	ba 00 00 00 00       	mov    $0x0,%edx
  800594:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800599:	bb 00 00 00 00       	mov    $0x0,%ebx
  80059e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005a3:	be 00 00 00 00       	mov    $0x0,%esi
  8005a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005ae:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8005b0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005b4:	c9                   	leave  
  8005b5:	c3                   	ret    

00000000008005b6 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8005b6:	55                   	push   %rbp
  8005b7:	48 89 e5             	mov    %rsp,%rbp
  8005ba:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005bb:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005cf:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005d4:	be 00 00 00 00       	mov    $0x0,%esi
  8005d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005df:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8005e1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005e5:	c9                   	leave  
  8005e6:	c3                   	ret    

00000000008005e7 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8005e7:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8005ee:	ff ff ff 
  8005f1:	48 01 f8             	add    %rdi,%rax
  8005f4:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8005f8:	c3                   	ret    

00000000008005f9 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8005f9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800600:	ff ff ff 
  800603:	48 01 f8             	add    %rdi,%rax
  800606:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80060a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800610:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800614:	c3                   	ret    

0000000000800615 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  800615:	55                   	push   %rbp
  800616:	48 89 e5             	mov    %rsp,%rbp
  800619:	41 57                	push   %r15
  80061b:	41 56                	push   %r14
  80061d:	41 55                	push   %r13
  80061f:	41 54                	push   %r12
  800621:	53                   	push   %rbx
  800622:	48 83 ec 08          	sub    $0x8,%rsp
  800626:	49 89 ff             	mov    %rdi,%r15
  800629:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80062e:	49 bc c3 15 80 00 00 	movabs $0x8015c3,%r12
  800635:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  800638:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  80063e:	48 89 df             	mov    %rbx,%rdi
  800641:	41 ff d4             	call   *%r12
  800644:	83 e0 04             	and    $0x4,%eax
  800647:	74 1a                	je     800663 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  800649:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  800650:	4c 39 f3             	cmp    %r14,%rbx
  800653:	75 e9                	jne    80063e <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  800655:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  80065c:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  800661:	eb 03                	jmp    800666 <fd_alloc+0x51>
            *fd_store = fd;
  800663:	49 89 1f             	mov    %rbx,(%r15)
}
  800666:	48 83 c4 08          	add    $0x8,%rsp
  80066a:	5b                   	pop    %rbx
  80066b:	41 5c                	pop    %r12
  80066d:	41 5d                	pop    %r13
  80066f:	41 5e                	pop    %r14
  800671:	41 5f                	pop    %r15
  800673:	5d                   	pop    %rbp
  800674:	c3                   	ret    

0000000000800675 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  800675:	83 ff 1f             	cmp    $0x1f,%edi
  800678:	77 39                	ja     8006b3 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80067a:	55                   	push   %rbp
  80067b:	48 89 e5             	mov    %rsp,%rbp
  80067e:	41 54                	push   %r12
  800680:	53                   	push   %rbx
  800681:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  800684:	48 63 df             	movslq %edi,%rbx
  800687:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80068e:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800692:	48 89 df             	mov    %rbx,%rdi
  800695:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  80069c:	00 00 00 
  80069f:	ff d0                	call   *%rax
  8006a1:	a8 04                	test   $0x4,%al
  8006a3:	74 14                	je     8006b9 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8006a5:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8006a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006ae:	5b                   	pop    %rbx
  8006af:	41 5c                	pop    %r12
  8006b1:	5d                   	pop    %rbp
  8006b2:	c3                   	ret    
        return -E_INVAL;
  8006b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006b8:	c3                   	ret    
        return -E_INVAL;
  8006b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006be:	eb ee                	jmp    8006ae <fd_lookup+0x39>

00000000008006c0 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8006c0:	55                   	push   %rbp
  8006c1:	48 89 e5             	mov    %rsp,%rbp
  8006c4:	53                   	push   %rbx
  8006c5:	48 83 ec 08          	sub    $0x8,%rsp
  8006c9:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8006cc:	48 ba 80 2a 80 00 00 	movabs $0x802a80,%rdx
  8006d3:	00 00 00 
  8006d6:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8006dd:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8006e0:	39 38                	cmp    %edi,(%rax)
  8006e2:	74 4b                	je     80072f <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8006e4:	48 83 c2 08          	add    $0x8,%rdx
  8006e8:	48 8b 02             	mov    (%rdx),%rax
  8006eb:	48 85 c0             	test   %rax,%rax
  8006ee:	75 f0                	jne    8006e0 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8006f0:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8006f7:	00 00 00 
  8006fa:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800700:	89 fa                	mov    %edi,%edx
  800702:	48 bf e8 29 80 00 00 	movabs $0x8029e8,%rdi
  800709:	00 00 00 
  80070c:	b8 00 00 00 00       	mov    $0x0,%eax
  800711:	48 b9 95 1a 80 00 00 	movabs $0x801a95,%rcx
  800718:	00 00 00 
  80071b:	ff d1                	call   *%rcx
    *dev = 0;
  80071d:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  800724:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800729:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    
            *dev = devtab[i];
  80072f:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  800732:	b8 00 00 00 00       	mov    $0x0,%eax
  800737:	eb f0                	jmp    800729 <dev_lookup+0x69>

0000000000800739 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  800739:	55                   	push   %rbp
  80073a:	48 89 e5             	mov    %rsp,%rbp
  80073d:	41 55                	push   %r13
  80073f:	41 54                	push   %r12
  800741:	53                   	push   %rbx
  800742:	48 83 ec 18          	sub    $0x18,%rsp
  800746:	49 89 fc             	mov    %rdi,%r12
  800749:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80074c:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  800753:	ff ff ff 
  800756:	4c 01 e7             	add    %r12,%rdi
  800759:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80075d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800761:	48 b8 75 06 80 00 00 	movabs $0x800675,%rax
  800768:	00 00 00 
  80076b:	ff d0                	call   *%rax
  80076d:	89 c3                	mov    %eax,%ebx
  80076f:	85 c0                	test   %eax,%eax
  800771:	78 06                	js     800779 <fd_close+0x40>
  800773:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  800777:	74 18                	je     800791 <fd_close+0x58>
        return (must_exist ? res : 0);
  800779:	45 84 ed             	test   %r13b,%r13b
  80077c:	b8 00 00 00 00       	mov    $0x0,%eax
  800781:	0f 44 d8             	cmove  %eax,%ebx
}
  800784:	89 d8                	mov    %ebx,%eax
  800786:	48 83 c4 18          	add    $0x18,%rsp
  80078a:	5b                   	pop    %rbx
  80078b:	41 5c                	pop    %r12
  80078d:	41 5d                	pop    %r13
  80078f:	5d                   	pop    %rbp
  800790:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800791:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800795:	41 8b 3c 24          	mov    (%r12),%edi
  800799:	48 b8 c0 06 80 00 00 	movabs $0x8006c0,%rax
  8007a0:	00 00 00 
  8007a3:	ff d0                	call   *%rax
  8007a5:	89 c3                	mov    %eax,%ebx
  8007a7:	85 c0                	test   %eax,%eax
  8007a9:	78 19                	js     8007c4 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8007ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8007af:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007b8:	48 85 c0             	test   %rax,%rax
  8007bb:	74 07                	je     8007c4 <fd_close+0x8b>
  8007bd:	4c 89 e7             	mov    %r12,%rdi
  8007c0:	ff d0                	call   *%rax
  8007c2:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8007c4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8007c9:	4c 89 e6             	mov    %r12,%rsi
  8007cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8007d1:	48 b8 4e 03 80 00 00 	movabs $0x80034e,%rax
  8007d8:	00 00 00 
  8007db:	ff d0                	call   *%rax
    return res;
  8007dd:	eb a5                	jmp    800784 <fd_close+0x4b>

00000000008007df <close>:

int
close(int fdnum) {
  8007df:	55                   	push   %rbp
  8007e0:	48 89 e5             	mov    %rsp,%rbp
  8007e3:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8007e7:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8007eb:	48 b8 75 06 80 00 00 	movabs $0x800675,%rax
  8007f2:	00 00 00 
  8007f5:	ff d0                	call   *%rax
    if (res < 0) return res;
  8007f7:	85 c0                	test   %eax,%eax
  8007f9:	78 15                	js     800810 <close+0x31>

    return fd_close(fd, 1);
  8007fb:	be 01 00 00 00       	mov    $0x1,%esi
  800800:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800804:	48 b8 39 07 80 00 00 	movabs $0x800739,%rax
  80080b:	00 00 00 
  80080e:	ff d0                	call   *%rax
}
  800810:	c9                   	leave  
  800811:	c3                   	ret    

0000000000800812 <close_all>:

void
close_all(void) {
  800812:	55                   	push   %rbp
  800813:	48 89 e5             	mov    %rsp,%rbp
  800816:	41 54                	push   %r12
  800818:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  800819:	bb 00 00 00 00       	mov    $0x0,%ebx
  80081e:	49 bc df 07 80 00 00 	movabs $0x8007df,%r12
  800825:	00 00 00 
  800828:	89 df                	mov    %ebx,%edi
  80082a:	41 ff d4             	call   *%r12
  80082d:	83 c3 01             	add    $0x1,%ebx
  800830:	83 fb 20             	cmp    $0x20,%ebx
  800833:	75 f3                	jne    800828 <close_all+0x16>
}
  800835:	5b                   	pop    %rbx
  800836:	41 5c                	pop    %r12
  800838:	5d                   	pop    %rbp
  800839:	c3                   	ret    

000000000080083a <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80083a:	55                   	push   %rbp
  80083b:	48 89 e5             	mov    %rsp,%rbp
  80083e:	41 56                	push   %r14
  800840:	41 55                	push   %r13
  800842:	41 54                	push   %r12
  800844:	53                   	push   %rbx
  800845:	48 83 ec 10          	sub    $0x10,%rsp
  800849:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80084c:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800850:	48 b8 75 06 80 00 00 	movabs $0x800675,%rax
  800857:	00 00 00 
  80085a:	ff d0                	call   *%rax
  80085c:	89 c3                	mov    %eax,%ebx
  80085e:	85 c0                	test   %eax,%eax
  800860:	0f 88 b7 00 00 00    	js     80091d <dup+0xe3>
    close(newfdnum);
  800866:	44 89 e7             	mov    %r12d,%edi
  800869:	48 b8 df 07 80 00 00 	movabs $0x8007df,%rax
  800870:	00 00 00 
  800873:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800875:	4d 63 ec             	movslq %r12d,%r13
  800878:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80087f:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  800883:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800887:	49 be f9 05 80 00 00 	movabs $0x8005f9,%r14
  80088e:	00 00 00 
  800891:	41 ff d6             	call   *%r14
  800894:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  800897:	4c 89 ef             	mov    %r13,%rdi
  80089a:	41 ff d6             	call   *%r14
  80089d:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8008a0:	48 89 df             	mov    %rbx,%rdi
  8008a3:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  8008aa:	00 00 00 
  8008ad:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8008af:	a8 04                	test   $0x4,%al
  8008b1:	74 2b                	je     8008de <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8008b3:	41 89 c1             	mov    %eax,%r9d
  8008b6:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8008bc:	4c 89 f1             	mov    %r14,%rcx
  8008bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c4:	48 89 de             	mov    %rbx,%rsi
  8008c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8008cc:	48 b8 e9 02 80 00 00 	movabs $0x8002e9,%rax
  8008d3:	00 00 00 
  8008d6:	ff d0                	call   *%rax
  8008d8:	89 c3                	mov    %eax,%ebx
  8008da:	85 c0                	test   %eax,%eax
  8008dc:	78 4e                	js     80092c <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8008de:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8008e2:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  8008e9:	00 00 00 
  8008ec:	ff d0                	call   *%rax
  8008ee:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8008f1:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8008f7:	4c 89 e9             	mov    %r13,%rcx
  8008fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ff:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800903:	bf 00 00 00 00       	mov    $0x0,%edi
  800908:	48 b8 e9 02 80 00 00 	movabs $0x8002e9,%rax
  80090f:	00 00 00 
  800912:	ff d0                	call   *%rax
  800914:	89 c3                	mov    %eax,%ebx
  800916:	85 c0                	test   %eax,%eax
  800918:	78 12                	js     80092c <dup+0xf2>

    return newfdnum;
  80091a:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80091d:	89 d8                	mov    %ebx,%eax
  80091f:	48 83 c4 10          	add    $0x10,%rsp
  800923:	5b                   	pop    %rbx
  800924:	41 5c                	pop    %r12
  800926:	41 5d                	pop    %r13
  800928:	41 5e                	pop    %r14
  80092a:	5d                   	pop    %rbp
  80092b:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80092c:	ba 00 10 00 00       	mov    $0x1000,%edx
  800931:	4c 89 ee             	mov    %r13,%rsi
  800934:	bf 00 00 00 00       	mov    $0x0,%edi
  800939:	49 bc 4e 03 80 00 00 	movabs $0x80034e,%r12
  800940:	00 00 00 
  800943:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  800946:	ba 00 10 00 00       	mov    $0x1000,%edx
  80094b:	4c 89 f6             	mov    %r14,%rsi
  80094e:	bf 00 00 00 00       	mov    $0x0,%edi
  800953:	41 ff d4             	call   *%r12
    return res;
  800956:	eb c5                	jmp    80091d <dup+0xe3>

0000000000800958 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800958:	55                   	push   %rbp
  800959:	48 89 e5             	mov    %rsp,%rbp
  80095c:	41 55                	push   %r13
  80095e:	41 54                	push   %r12
  800960:	53                   	push   %rbx
  800961:	48 83 ec 18          	sub    $0x18,%rsp
  800965:	89 fb                	mov    %edi,%ebx
  800967:	49 89 f4             	mov    %rsi,%r12
  80096a:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80096d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800971:	48 b8 75 06 80 00 00 	movabs $0x800675,%rax
  800978:	00 00 00 
  80097b:	ff d0                	call   *%rax
  80097d:	85 c0                	test   %eax,%eax
  80097f:	78 49                	js     8009ca <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800981:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800985:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800989:	8b 38                	mov    (%rax),%edi
  80098b:	48 b8 c0 06 80 00 00 	movabs $0x8006c0,%rax
  800992:	00 00 00 
  800995:	ff d0                	call   *%rax
  800997:	85 c0                	test   %eax,%eax
  800999:	78 33                	js     8009ce <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80099b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80099f:	8b 47 08             	mov    0x8(%rdi),%eax
  8009a2:	83 e0 03             	and    $0x3,%eax
  8009a5:	83 f8 01             	cmp    $0x1,%eax
  8009a8:	74 28                	je     8009d2 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8009aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009ae:	48 8b 40 10          	mov    0x10(%rax),%rax
  8009b2:	48 85 c0             	test   %rax,%rax
  8009b5:	74 51                	je     800a08 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8009b7:	4c 89 ea             	mov    %r13,%rdx
  8009ba:	4c 89 e6             	mov    %r12,%rsi
  8009bd:	ff d0                	call   *%rax
}
  8009bf:	48 83 c4 18          	add    $0x18,%rsp
  8009c3:	5b                   	pop    %rbx
  8009c4:	41 5c                	pop    %r12
  8009c6:	41 5d                	pop    %r13
  8009c8:	5d                   	pop    %rbp
  8009c9:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8009ca:	48 98                	cltq   
  8009cc:	eb f1                	jmp    8009bf <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8009ce:	48 98                	cltq   
  8009d0:	eb ed                	jmp    8009bf <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8009d2:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8009d9:	00 00 00 
  8009dc:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8009e2:	89 da                	mov    %ebx,%edx
  8009e4:	48 bf 29 2a 80 00 00 	movabs $0x802a29,%rdi
  8009eb:	00 00 00 
  8009ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f3:	48 b9 95 1a 80 00 00 	movabs $0x801a95,%rcx
  8009fa:	00 00 00 
  8009fd:	ff d1                	call   *%rcx
        return -E_INVAL;
  8009ff:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800a06:	eb b7                	jmp    8009bf <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800a08:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800a0f:	eb ae                	jmp    8009bf <read+0x67>

0000000000800a11 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800a11:	55                   	push   %rbp
  800a12:	48 89 e5             	mov    %rsp,%rbp
  800a15:	41 57                	push   %r15
  800a17:	41 56                	push   %r14
  800a19:	41 55                	push   %r13
  800a1b:	41 54                	push   %r12
  800a1d:	53                   	push   %rbx
  800a1e:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800a22:	48 85 d2             	test   %rdx,%rdx
  800a25:	74 54                	je     800a7b <readn+0x6a>
  800a27:	41 89 fd             	mov    %edi,%r13d
  800a2a:	49 89 f6             	mov    %rsi,%r14
  800a2d:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800a30:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800a35:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800a3a:	49 bf 58 09 80 00 00 	movabs $0x800958,%r15
  800a41:	00 00 00 
  800a44:	4c 89 e2             	mov    %r12,%rdx
  800a47:	48 29 f2             	sub    %rsi,%rdx
  800a4a:	4c 01 f6             	add    %r14,%rsi
  800a4d:	44 89 ef             	mov    %r13d,%edi
  800a50:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800a53:	85 c0                	test   %eax,%eax
  800a55:	78 20                	js     800a77 <readn+0x66>
    for (; inc && res < n; res += inc) {
  800a57:	01 c3                	add    %eax,%ebx
  800a59:	85 c0                	test   %eax,%eax
  800a5b:	74 08                	je     800a65 <readn+0x54>
  800a5d:	48 63 f3             	movslq %ebx,%rsi
  800a60:	4c 39 e6             	cmp    %r12,%rsi
  800a63:	72 df                	jb     800a44 <readn+0x33>
    }
    return res;
  800a65:	48 63 c3             	movslq %ebx,%rax
}
  800a68:	48 83 c4 08          	add    $0x8,%rsp
  800a6c:	5b                   	pop    %rbx
  800a6d:	41 5c                	pop    %r12
  800a6f:	41 5d                	pop    %r13
  800a71:	41 5e                	pop    %r14
  800a73:	41 5f                	pop    %r15
  800a75:	5d                   	pop    %rbp
  800a76:	c3                   	ret    
        if (inc < 0) return inc;
  800a77:	48 98                	cltq   
  800a79:	eb ed                	jmp    800a68 <readn+0x57>
    int inc = 1, res = 0;
  800a7b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a80:	eb e3                	jmp    800a65 <readn+0x54>

0000000000800a82 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800a82:	55                   	push   %rbp
  800a83:	48 89 e5             	mov    %rsp,%rbp
  800a86:	41 55                	push   %r13
  800a88:	41 54                	push   %r12
  800a8a:	53                   	push   %rbx
  800a8b:	48 83 ec 18          	sub    $0x18,%rsp
  800a8f:	89 fb                	mov    %edi,%ebx
  800a91:	49 89 f4             	mov    %rsi,%r12
  800a94:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a97:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a9b:	48 b8 75 06 80 00 00 	movabs $0x800675,%rax
  800aa2:	00 00 00 
  800aa5:	ff d0                	call   *%rax
  800aa7:	85 c0                	test   %eax,%eax
  800aa9:	78 44                	js     800aef <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800aab:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800aaf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ab3:	8b 38                	mov    (%rax),%edi
  800ab5:	48 b8 c0 06 80 00 00 	movabs $0x8006c0,%rax
  800abc:	00 00 00 
  800abf:	ff d0                	call   *%rax
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	78 2e                	js     800af3 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ac5:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ac9:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800acd:	74 28                	je     800af7 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800acf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ad3:	48 8b 40 18          	mov    0x18(%rax),%rax
  800ad7:	48 85 c0             	test   %rax,%rax
  800ada:	74 51                	je     800b2d <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  800adc:	4c 89 ea             	mov    %r13,%rdx
  800adf:	4c 89 e6             	mov    %r12,%rsi
  800ae2:	ff d0                	call   *%rax
}
  800ae4:	48 83 c4 18          	add    $0x18,%rsp
  800ae8:	5b                   	pop    %rbx
  800ae9:	41 5c                	pop    %r12
  800aeb:	41 5d                	pop    %r13
  800aed:	5d                   	pop    %rbp
  800aee:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800aef:	48 98                	cltq   
  800af1:	eb f1                	jmp    800ae4 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800af3:	48 98                	cltq   
  800af5:	eb ed                	jmp    800ae4 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800af7:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800afe:	00 00 00 
  800b01:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800b07:	89 da                	mov    %ebx,%edx
  800b09:	48 bf 45 2a 80 00 00 	movabs $0x802a45,%rdi
  800b10:	00 00 00 
  800b13:	b8 00 00 00 00       	mov    $0x0,%eax
  800b18:	48 b9 95 1a 80 00 00 	movabs $0x801a95,%rcx
  800b1f:	00 00 00 
  800b22:	ff d1                	call   *%rcx
        return -E_INVAL;
  800b24:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800b2b:	eb b7                	jmp    800ae4 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800b2d:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800b34:	eb ae                	jmp    800ae4 <write+0x62>

0000000000800b36 <seek>:

int
seek(int fdnum, off_t offset) {
  800b36:	55                   	push   %rbp
  800b37:	48 89 e5             	mov    %rsp,%rbp
  800b3a:	53                   	push   %rbx
  800b3b:	48 83 ec 18          	sub    $0x18,%rsp
  800b3f:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b41:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b45:	48 b8 75 06 80 00 00 	movabs $0x800675,%rax
  800b4c:	00 00 00 
  800b4f:	ff d0                	call   *%rax
  800b51:	85 c0                	test   %eax,%eax
  800b53:	78 0c                	js     800b61 <seek+0x2b>

    fd->fd_offset = offset;
  800b55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b59:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800b5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b61:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

0000000000800b67 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800b67:	55                   	push   %rbp
  800b68:	48 89 e5             	mov    %rsp,%rbp
  800b6b:	41 54                	push   %r12
  800b6d:	53                   	push   %rbx
  800b6e:	48 83 ec 10          	sub    $0x10,%rsp
  800b72:	89 fb                	mov    %edi,%ebx
  800b74:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b77:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b7b:	48 b8 75 06 80 00 00 	movabs $0x800675,%rax
  800b82:	00 00 00 
  800b85:	ff d0                	call   *%rax
  800b87:	85 c0                	test   %eax,%eax
  800b89:	78 36                	js     800bc1 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b8b:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800b8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b93:	8b 38                	mov    (%rax),%edi
  800b95:	48 b8 c0 06 80 00 00 	movabs $0x8006c0,%rax
  800b9c:	00 00 00 
  800b9f:	ff d0                	call   *%rax
  800ba1:	85 c0                	test   %eax,%eax
  800ba3:	78 1c                	js     800bc1 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ba5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800ba9:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800bad:	74 1b                	je     800bca <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800baf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800bb3:	48 8b 40 30          	mov    0x30(%rax),%rax
  800bb7:	48 85 c0             	test   %rax,%rax
  800bba:	74 42                	je     800bfe <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  800bbc:	44 89 e6             	mov    %r12d,%esi
  800bbf:	ff d0                	call   *%rax
}
  800bc1:	48 83 c4 10          	add    $0x10,%rsp
  800bc5:	5b                   	pop    %rbx
  800bc6:	41 5c                	pop    %r12
  800bc8:	5d                   	pop    %rbp
  800bc9:	c3                   	ret    
                thisenv->env_id, fdnum);
  800bca:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bd1:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800bd4:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800bda:	89 da                	mov    %ebx,%edx
  800bdc:	48 bf 08 2a 80 00 00 	movabs $0x802a08,%rdi
  800be3:	00 00 00 
  800be6:	b8 00 00 00 00       	mov    $0x0,%eax
  800beb:	48 b9 95 1a 80 00 00 	movabs $0x801a95,%rcx
  800bf2:	00 00 00 
  800bf5:	ff d1                	call   *%rcx
        return -E_INVAL;
  800bf7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bfc:	eb c3                	jmp    800bc1 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800bfe:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c03:	eb bc                	jmp    800bc1 <ftruncate+0x5a>

0000000000800c05 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800c05:	55                   	push   %rbp
  800c06:	48 89 e5             	mov    %rsp,%rbp
  800c09:	53                   	push   %rbx
  800c0a:	48 83 ec 18          	sub    $0x18,%rsp
  800c0e:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c11:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c15:	48 b8 75 06 80 00 00 	movabs $0x800675,%rax
  800c1c:	00 00 00 
  800c1f:	ff d0                	call   *%rax
  800c21:	85 c0                	test   %eax,%eax
  800c23:	78 4d                	js     800c72 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c25:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800c29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2d:	8b 38                	mov    (%rax),%edi
  800c2f:	48 b8 c0 06 80 00 00 	movabs $0x8006c0,%rax
  800c36:	00 00 00 
  800c39:	ff d0                	call   *%rax
  800c3b:	85 c0                	test   %eax,%eax
  800c3d:	78 33                	js     800c72 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c43:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800c48:	74 2e                	je     800c78 <fstat+0x73>

    stat->st_name[0] = 0;
  800c4a:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800c4d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800c54:	00 00 00 
    stat->st_isdir = 0;
  800c57:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800c5e:	00 00 00 
    stat->st_dev = dev;
  800c61:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800c68:	48 89 de             	mov    %rbx,%rsi
  800c6b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c6f:	ff 50 28             	call   *0x28(%rax)
}
  800c72:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c78:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c7d:	eb f3                	jmp    800c72 <fstat+0x6d>

0000000000800c7f <stat>:

int
stat(const char *path, struct Stat *stat) {
  800c7f:	55                   	push   %rbp
  800c80:	48 89 e5             	mov    %rsp,%rbp
  800c83:	41 54                	push   %r12
  800c85:	53                   	push   %rbx
  800c86:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800c89:	be 00 00 00 00       	mov    $0x0,%esi
  800c8e:	48 b8 4a 0f 80 00 00 	movabs $0x800f4a,%rax
  800c95:	00 00 00 
  800c98:	ff d0                	call   *%rax
  800c9a:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800c9c:	85 c0                	test   %eax,%eax
  800c9e:	78 25                	js     800cc5 <stat+0x46>

    int res = fstat(fd, stat);
  800ca0:	4c 89 e6             	mov    %r12,%rsi
  800ca3:	89 c7                	mov    %eax,%edi
  800ca5:	48 b8 05 0c 80 00 00 	movabs $0x800c05,%rax
  800cac:	00 00 00 
  800caf:	ff d0                	call   *%rax
  800cb1:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800cb4:	89 df                	mov    %ebx,%edi
  800cb6:	48 b8 df 07 80 00 00 	movabs $0x8007df,%rax
  800cbd:	00 00 00 
  800cc0:	ff d0                	call   *%rax

    return res;
  800cc2:	44 89 e3             	mov    %r12d,%ebx
}
  800cc5:	89 d8                	mov    %ebx,%eax
  800cc7:	5b                   	pop    %rbx
  800cc8:	41 5c                	pop    %r12
  800cca:	5d                   	pop    %rbp
  800ccb:	c3                   	ret    

0000000000800ccc <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800ccc:	55                   	push   %rbp
  800ccd:	48 89 e5             	mov    %rsp,%rbp
  800cd0:	41 54                	push   %r12
  800cd2:	53                   	push   %rbx
  800cd3:	48 83 ec 10          	sub    $0x10,%rsp
  800cd7:	41 89 fc             	mov    %edi,%r12d
  800cda:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800cdd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800ce4:	00 00 00 
  800ce7:	83 38 00             	cmpl   $0x0,(%rax)
  800cea:	74 5e                	je     800d4a <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800cec:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800cf2:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800cf7:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800cfe:	00 00 00 
  800d01:	44 89 e6             	mov    %r12d,%esi
  800d04:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d0b:	00 00 00 
  800d0e:	8b 38                	mov    (%rax),%edi
  800d10:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  800d17:	00 00 00 
  800d1a:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800d1c:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800d23:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800d24:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d29:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d2d:	48 89 de             	mov    %rbx,%rsi
  800d30:	bf 00 00 00 00       	mov    $0x0,%edi
  800d35:	48 b8 07 28 80 00 00 	movabs $0x802807,%rax
  800d3c:	00 00 00 
  800d3f:	ff d0                	call   *%rax
}
  800d41:	48 83 c4 10          	add    $0x10,%rsp
  800d45:	5b                   	pop    %rbx
  800d46:	41 5c                	pop    %r12
  800d48:	5d                   	pop    %rbp
  800d49:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800d4a:	bf 03 00 00 00       	mov    $0x3,%edi
  800d4f:	48 b8 49 29 80 00 00 	movabs $0x802949,%rax
  800d56:	00 00 00 
  800d59:	ff d0                	call   *%rax
  800d5b:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800d62:	00 00 
  800d64:	eb 86                	jmp    800cec <fsipc+0x20>

0000000000800d66 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800d66:	55                   	push   %rbp
  800d67:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d6a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800d71:	00 00 00 
  800d74:	8b 57 0c             	mov    0xc(%rdi),%edx
  800d77:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800d79:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800d7c:	be 00 00 00 00       	mov    $0x0,%esi
  800d81:	bf 02 00 00 00       	mov    $0x2,%edi
  800d86:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  800d8d:	00 00 00 
  800d90:	ff d0                	call   *%rax
}
  800d92:	5d                   	pop    %rbp
  800d93:	c3                   	ret    

0000000000800d94 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800d94:	55                   	push   %rbp
  800d95:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800d98:	8b 47 0c             	mov    0xc(%rdi),%eax
  800d9b:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800da2:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800da4:	be 00 00 00 00       	mov    $0x0,%esi
  800da9:	bf 06 00 00 00       	mov    $0x6,%edi
  800dae:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  800db5:	00 00 00 
  800db8:	ff d0                	call   *%rax
}
  800dba:	5d                   	pop    %rbp
  800dbb:	c3                   	ret    

0000000000800dbc <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800dbc:	55                   	push   %rbp
  800dbd:	48 89 e5             	mov    %rsp,%rbp
  800dc0:	53                   	push   %rbx
  800dc1:	48 83 ec 08          	sub    $0x8,%rsp
  800dc5:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800dc8:	8b 47 0c             	mov    0xc(%rdi),%eax
  800dcb:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800dd2:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800dd4:	be 00 00 00 00       	mov    $0x0,%esi
  800dd9:	bf 05 00 00 00       	mov    $0x5,%edi
  800dde:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  800de5:	00 00 00 
  800de8:	ff d0                	call   *%rax
    if (res < 0) return res;
  800dea:	85 c0                	test   %eax,%eax
  800dec:	78 40                	js     800e2e <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800dee:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800df5:	00 00 00 
  800df8:	48 89 df             	mov    %rbx,%rdi
  800dfb:	48 b8 d6 23 80 00 00 	movabs $0x8023d6,%rax
  800e02:	00 00 00 
  800e05:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800e07:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e0e:	00 00 00 
  800e11:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  800e17:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e1d:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  800e23:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800e32:	c9                   	leave  
  800e33:	c3                   	ret    

0000000000800e34 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800e34:	55                   	push   %rbp
  800e35:	48 89 e5             	mov    %rsp,%rbp
  800e38:	41 57                	push   %r15
  800e3a:	41 56                	push   %r14
  800e3c:	41 55                	push   %r13
  800e3e:	41 54                	push   %r12
  800e40:	53                   	push   %rbx
  800e41:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  800e45:	48 85 d2             	test   %rdx,%rdx
  800e48:	0f 84 91 00 00 00    	je     800edf <devfile_write+0xab>
  800e4e:	49 89 ff             	mov    %rdi,%r15
  800e51:	49 89 f4             	mov    %rsi,%r12
  800e54:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  800e57:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e5e:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  800e65:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  800e68:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  800e6f:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  800e75:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  800e79:	4c 89 ea             	mov    %r13,%rdx
  800e7c:	4c 89 e6             	mov    %r12,%rsi
  800e7f:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  800e86:	00 00 00 
  800e89:	48 b8 36 26 80 00 00 	movabs $0x802636,%rax
  800e90:	00 00 00 
  800e93:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e95:	41 8b 47 0c          	mov    0xc(%r15),%eax
  800e99:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  800e9c:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  800ea0:	be 00 00 00 00       	mov    $0x0,%esi
  800ea5:	bf 04 00 00 00       	mov    $0x4,%edi
  800eaa:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  800eb1:	00 00 00 
  800eb4:	ff d0                	call   *%rax
        if (res < 0)
  800eb6:	85 c0                	test   %eax,%eax
  800eb8:	78 21                	js     800edb <devfile_write+0xa7>
        buf += res;
  800eba:	48 63 d0             	movslq %eax,%rdx
  800ebd:	49 01 d4             	add    %rdx,%r12
        ext += res;
  800ec0:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  800ec3:	48 29 d3             	sub    %rdx,%rbx
  800ec6:	75 a0                	jne    800e68 <devfile_write+0x34>
    return ext;
  800ec8:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  800ecc:	48 83 c4 18          	add    $0x18,%rsp
  800ed0:	5b                   	pop    %rbx
  800ed1:	41 5c                	pop    %r12
  800ed3:	41 5d                	pop    %r13
  800ed5:	41 5e                	pop    %r14
  800ed7:	41 5f                	pop    %r15
  800ed9:	5d                   	pop    %rbp
  800eda:	c3                   	ret    
            return res;
  800edb:	48 98                	cltq   
  800edd:	eb ed                	jmp    800ecc <devfile_write+0x98>
    int ext = 0;
  800edf:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  800ee6:	eb e0                	jmp    800ec8 <devfile_write+0x94>

0000000000800ee8 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800ee8:	55                   	push   %rbp
  800ee9:	48 89 e5             	mov    %rsp,%rbp
  800eec:	41 54                	push   %r12
  800eee:	53                   	push   %rbx
  800eef:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ef2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ef9:	00 00 00 
  800efc:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800eff:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  800f01:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  800f05:	be 00 00 00 00       	mov    $0x0,%esi
  800f0a:	bf 03 00 00 00       	mov    $0x3,%edi
  800f0f:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  800f16:	00 00 00 
  800f19:	ff d0                	call   *%rax
    if (read < 0) 
  800f1b:	85 c0                	test   %eax,%eax
  800f1d:	78 27                	js     800f46 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  800f1f:	48 63 d8             	movslq %eax,%rbx
  800f22:	48 89 da             	mov    %rbx,%rdx
  800f25:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800f2c:	00 00 00 
  800f2f:	4c 89 e7             	mov    %r12,%rdi
  800f32:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  800f39:	00 00 00 
  800f3c:	ff d0                	call   *%rax
    return read;
  800f3e:	48 89 d8             	mov    %rbx,%rax
}
  800f41:	5b                   	pop    %rbx
  800f42:	41 5c                	pop    %r12
  800f44:	5d                   	pop    %rbp
  800f45:	c3                   	ret    
		return read;
  800f46:	48 98                	cltq   
  800f48:	eb f7                	jmp    800f41 <devfile_read+0x59>

0000000000800f4a <open>:
open(const char *path, int mode) {
  800f4a:	55                   	push   %rbp
  800f4b:	48 89 e5             	mov    %rsp,%rbp
  800f4e:	41 55                	push   %r13
  800f50:	41 54                	push   %r12
  800f52:	53                   	push   %rbx
  800f53:	48 83 ec 18          	sub    $0x18,%rsp
  800f57:	49 89 fc             	mov    %rdi,%r12
  800f5a:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  800f5d:	48 b8 9d 23 80 00 00 	movabs $0x80239d,%rax
  800f64:	00 00 00 
  800f67:	ff d0                	call   *%rax
  800f69:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  800f6f:	0f 87 8c 00 00 00    	ja     801001 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  800f75:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  800f79:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  800f80:	00 00 00 
  800f83:	ff d0                	call   *%rax
  800f85:	89 c3                	mov    %eax,%ebx
  800f87:	85 c0                	test   %eax,%eax
  800f89:	78 52                	js     800fdd <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  800f8b:	4c 89 e6             	mov    %r12,%rsi
  800f8e:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  800f95:	00 00 00 
  800f98:	48 b8 d6 23 80 00 00 	movabs $0x8023d6,%rax
  800f9f:	00 00 00 
  800fa2:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  800fa4:	44 89 e8             	mov    %r13d,%eax
  800fa7:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  800fae:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fb0:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800fb4:	bf 01 00 00 00       	mov    $0x1,%edi
  800fb9:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  800fc0:	00 00 00 
  800fc3:	ff d0                	call   *%rax
  800fc5:	89 c3                	mov    %eax,%ebx
  800fc7:	85 c0                	test   %eax,%eax
  800fc9:	78 1f                	js     800fea <open+0xa0>
    return fd2num(fd);
  800fcb:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800fcf:	48 b8 e7 05 80 00 00 	movabs $0x8005e7,%rax
  800fd6:	00 00 00 
  800fd9:	ff d0                	call   *%rax
  800fdb:	89 c3                	mov    %eax,%ebx
}
  800fdd:	89 d8                	mov    %ebx,%eax
  800fdf:	48 83 c4 18          	add    $0x18,%rsp
  800fe3:	5b                   	pop    %rbx
  800fe4:	41 5c                	pop    %r12
  800fe6:	41 5d                	pop    %r13
  800fe8:	5d                   	pop    %rbp
  800fe9:	c3                   	ret    
        fd_close(fd, 0);
  800fea:	be 00 00 00 00       	mov    $0x0,%esi
  800fef:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ff3:	48 b8 39 07 80 00 00 	movabs $0x800739,%rax
  800ffa:	00 00 00 
  800ffd:	ff d0                	call   *%rax
        return res;
  800fff:	eb dc                	jmp    800fdd <open+0x93>
        return -E_BAD_PATH;
  801001:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801006:	eb d5                	jmp    800fdd <open+0x93>

0000000000801008 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801008:	55                   	push   %rbp
  801009:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80100c:	be 00 00 00 00       	mov    $0x0,%esi
  801011:	bf 08 00 00 00       	mov    $0x8,%edi
  801016:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  80101d:	00 00 00 
  801020:	ff d0                	call   *%rax
}
  801022:	5d                   	pop    %rbp
  801023:	c3                   	ret    

0000000000801024 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801024:	55                   	push   %rbp
  801025:	48 89 e5             	mov    %rsp,%rbp
  801028:	41 54                	push   %r12
  80102a:	53                   	push   %rbx
  80102b:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80102e:	48 b8 f9 05 80 00 00 	movabs $0x8005f9,%rax
  801035:	00 00 00 
  801038:	ff d0                	call   *%rax
  80103a:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80103d:	48 be a0 2a 80 00 00 	movabs $0x802aa0,%rsi
  801044:	00 00 00 
  801047:	48 89 df             	mov    %rbx,%rdi
  80104a:	48 b8 d6 23 80 00 00 	movabs $0x8023d6,%rax
  801051:	00 00 00 
  801054:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801056:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80105b:	41 2b 04 24          	sub    (%r12),%eax
  80105f:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801065:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80106c:	00 00 00 
    stat->st_dev = &devpipe;
  80106f:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801076:	00 00 00 
  801079:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801080:	b8 00 00 00 00       	mov    $0x0,%eax
  801085:	5b                   	pop    %rbx
  801086:	41 5c                	pop    %r12
  801088:	5d                   	pop    %rbp
  801089:	c3                   	ret    

000000000080108a <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	41 54                	push   %r12
  801090:	53                   	push   %rbx
  801091:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801094:	ba 00 10 00 00       	mov    $0x1000,%edx
  801099:	48 89 fe             	mov    %rdi,%rsi
  80109c:	bf 00 00 00 00       	mov    $0x0,%edi
  8010a1:	49 bc 4e 03 80 00 00 	movabs $0x80034e,%r12
  8010a8:	00 00 00 
  8010ab:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8010ae:	48 89 df             	mov    %rbx,%rdi
  8010b1:	48 b8 f9 05 80 00 00 	movabs $0x8005f9,%rax
  8010b8:	00 00 00 
  8010bb:	ff d0                	call   *%rax
  8010bd:	48 89 c6             	mov    %rax,%rsi
  8010c0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8010ca:	41 ff d4             	call   *%r12
}
  8010cd:	5b                   	pop    %rbx
  8010ce:	41 5c                	pop    %r12
  8010d0:	5d                   	pop    %rbp
  8010d1:	c3                   	ret    

00000000008010d2 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8010d2:	55                   	push   %rbp
  8010d3:	48 89 e5             	mov    %rsp,%rbp
  8010d6:	41 57                	push   %r15
  8010d8:	41 56                	push   %r14
  8010da:	41 55                	push   %r13
  8010dc:	41 54                	push   %r12
  8010de:	53                   	push   %rbx
  8010df:	48 83 ec 18          	sub    $0x18,%rsp
  8010e3:	49 89 fc             	mov    %rdi,%r12
  8010e6:	49 89 f5             	mov    %rsi,%r13
  8010e9:	49 89 d7             	mov    %rdx,%r15
  8010ec:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8010f0:	48 b8 f9 05 80 00 00 	movabs $0x8005f9,%rax
  8010f7:	00 00 00 
  8010fa:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8010fc:	4d 85 ff             	test   %r15,%r15
  8010ff:	0f 84 ac 00 00 00    	je     8011b1 <devpipe_write+0xdf>
  801105:	48 89 c3             	mov    %rax,%rbx
  801108:	4c 89 f8             	mov    %r15,%rax
  80110b:	4d 89 ef             	mov    %r13,%r15
  80110e:	49 01 c5             	add    %rax,%r13
  801111:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801115:	49 bd 56 02 80 00 00 	movabs $0x800256,%r13
  80111c:	00 00 00 
            sys_yield();
  80111f:	49 be f3 01 80 00 00 	movabs $0x8001f3,%r14
  801126:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801129:	8b 73 04             	mov    0x4(%rbx),%esi
  80112c:	48 63 ce             	movslq %esi,%rcx
  80112f:	48 63 03             	movslq (%rbx),%rax
  801132:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801138:	48 39 c1             	cmp    %rax,%rcx
  80113b:	72 2e                	jb     80116b <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80113d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801142:	48 89 da             	mov    %rbx,%rdx
  801145:	be 00 10 00 00       	mov    $0x1000,%esi
  80114a:	4c 89 e7             	mov    %r12,%rdi
  80114d:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801150:	85 c0                	test   %eax,%eax
  801152:	74 63                	je     8011b7 <devpipe_write+0xe5>
            sys_yield();
  801154:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801157:	8b 73 04             	mov    0x4(%rbx),%esi
  80115a:	48 63 ce             	movslq %esi,%rcx
  80115d:	48 63 03             	movslq (%rbx),%rax
  801160:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801166:	48 39 c1             	cmp    %rax,%rcx
  801169:	73 d2                	jae    80113d <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80116b:	41 0f b6 3f          	movzbl (%r15),%edi
  80116f:	48 89 ca             	mov    %rcx,%rdx
  801172:	48 c1 ea 03          	shr    $0x3,%rdx
  801176:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80117d:	08 10 20 
  801180:	48 f7 e2             	mul    %rdx
  801183:	48 c1 ea 06          	shr    $0x6,%rdx
  801187:	48 89 d0             	mov    %rdx,%rax
  80118a:	48 c1 e0 09          	shl    $0x9,%rax
  80118e:	48 29 d0             	sub    %rdx,%rax
  801191:	48 c1 e0 03          	shl    $0x3,%rax
  801195:	48 29 c1             	sub    %rax,%rcx
  801198:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80119d:	83 c6 01             	add    $0x1,%esi
  8011a0:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8011a3:	49 83 c7 01          	add    $0x1,%r15
  8011a7:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8011ab:	0f 85 78 ff ff ff    	jne    801129 <devpipe_write+0x57>
    return n;
  8011b1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8011b5:	eb 05                	jmp    8011bc <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8011b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011bc:	48 83 c4 18          	add    $0x18,%rsp
  8011c0:	5b                   	pop    %rbx
  8011c1:	41 5c                	pop    %r12
  8011c3:	41 5d                	pop    %r13
  8011c5:	41 5e                	pop    %r14
  8011c7:	41 5f                	pop    %r15
  8011c9:	5d                   	pop    %rbp
  8011ca:	c3                   	ret    

00000000008011cb <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8011cb:	55                   	push   %rbp
  8011cc:	48 89 e5             	mov    %rsp,%rbp
  8011cf:	41 57                	push   %r15
  8011d1:	41 56                	push   %r14
  8011d3:	41 55                	push   %r13
  8011d5:	41 54                	push   %r12
  8011d7:	53                   	push   %rbx
  8011d8:	48 83 ec 18          	sub    $0x18,%rsp
  8011dc:	49 89 fc             	mov    %rdi,%r12
  8011df:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8011e3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8011e7:	48 b8 f9 05 80 00 00 	movabs $0x8005f9,%rax
  8011ee:	00 00 00 
  8011f1:	ff d0                	call   *%rax
  8011f3:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8011f6:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8011fc:	49 bd 56 02 80 00 00 	movabs $0x800256,%r13
  801203:	00 00 00 
            sys_yield();
  801206:	49 be f3 01 80 00 00 	movabs $0x8001f3,%r14
  80120d:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801210:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801215:	74 7a                	je     801291 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801217:	8b 03                	mov    (%rbx),%eax
  801219:	3b 43 04             	cmp    0x4(%rbx),%eax
  80121c:	75 26                	jne    801244 <devpipe_read+0x79>
            if (i > 0) return i;
  80121e:	4d 85 ff             	test   %r15,%r15
  801221:	75 74                	jne    801297 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801223:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801228:	48 89 da             	mov    %rbx,%rdx
  80122b:	be 00 10 00 00       	mov    $0x1000,%esi
  801230:	4c 89 e7             	mov    %r12,%rdi
  801233:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801236:	85 c0                	test   %eax,%eax
  801238:	74 6f                	je     8012a9 <devpipe_read+0xde>
            sys_yield();
  80123a:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80123d:	8b 03                	mov    (%rbx),%eax
  80123f:	3b 43 04             	cmp    0x4(%rbx),%eax
  801242:	74 df                	je     801223 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801244:	48 63 c8             	movslq %eax,%rcx
  801247:	48 89 ca             	mov    %rcx,%rdx
  80124a:	48 c1 ea 03          	shr    $0x3,%rdx
  80124e:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801255:	08 10 20 
  801258:	48 f7 e2             	mul    %rdx
  80125b:	48 c1 ea 06          	shr    $0x6,%rdx
  80125f:	48 89 d0             	mov    %rdx,%rax
  801262:	48 c1 e0 09          	shl    $0x9,%rax
  801266:	48 29 d0             	sub    %rdx,%rax
  801269:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801270:	00 
  801271:	48 89 c8             	mov    %rcx,%rax
  801274:	48 29 d0             	sub    %rdx,%rax
  801277:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80127c:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801280:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  801284:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  801287:	49 83 c7 01          	add    $0x1,%r15
  80128b:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80128f:	75 86                	jne    801217 <devpipe_read+0x4c>
    return n;
  801291:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801295:	eb 03                	jmp    80129a <devpipe_read+0xcf>
            if (i > 0) return i;
  801297:	4c 89 f8             	mov    %r15,%rax
}
  80129a:	48 83 c4 18          	add    $0x18,%rsp
  80129e:	5b                   	pop    %rbx
  80129f:	41 5c                	pop    %r12
  8012a1:	41 5d                	pop    %r13
  8012a3:	41 5e                	pop    %r14
  8012a5:	41 5f                	pop    %r15
  8012a7:	5d                   	pop    %rbp
  8012a8:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8012a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ae:	eb ea                	jmp    80129a <devpipe_read+0xcf>

00000000008012b0 <pipe>:
pipe(int pfd[2]) {
  8012b0:	55                   	push   %rbp
  8012b1:	48 89 e5             	mov    %rsp,%rbp
  8012b4:	41 55                	push   %r13
  8012b6:	41 54                	push   %r12
  8012b8:	53                   	push   %rbx
  8012b9:	48 83 ec 18          	sub    $0x18,%rsp
  8012bd:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8012c0:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8012c4:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  8012cb:	00 00 00 
  8012ce:	ff d0                	call   *%rax
  8012d0:	89 c3                	mov    %eax,%ebx
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	0f 88 a0 01 00 00    	js     80147a <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8012da:	b9 46 00 00 00       	mov    $0x46,%ecx
  8012df:	ba 00 10 00 00       	mov    $0x1000,%edx
  8012e4:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8012e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8012ed:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  8012f4:	00 00 00 
  8012f7:	ff d0                	call   *%rax
  8012f9:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	0f 88 77 01 00 00    	js     80147a <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801303:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  801307:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  80130e:	00 00 00 
  801311:	ff d0                	call   *%rax
  801313:	89 c3                	mov    %eax,%ebx
  801315:	85 c0                	test   %eax,%eax
  801317:	0f 88 43 01 00 00    	js     801460 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80131d:	b9 46 00 00 00       	mov    $0x46,%ecx
  801322:	ba 00 10 00 00       	mov    $0x1000,%edx
  801327:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80132b:	bf 00 00 00 00       	mov    $0x0,%edi
  801330:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  801337:	00 00 00 
  80133a:	ff d0                	call   *%rax
  80133c:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80133e:	85 c0                	test   %eax,%eax
  801340:	0f 88 1a 01 00 00    	js     801460 <pipe+0x1b0>
    va = fd2data(fd0);
  801346:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80134a:	48 b8 f9 05 80 00 00 	movabs $0x8005f9,%rax
  801351:	00 00 00 
  801354:	ff d0                	call   *%rax
  801356:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801359:	b9 46 00 00 00       	mov    $0x46,%ecx
  80135e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801363:	48 89 c6             	mov    %rax,%rsi
  801366:	bf 00 00 00 00       	mov    $0x0,%edi
  80136b:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  801372:	00 00 00 
  801375:	ff d0                	call   *%rax
  801377:	89 c3                	mov    %eax,%ebx
  801379:	85 c0                	test   %eax,%eax
  80137b:	0f 88 c5 00 00 00    	js     801446 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  801381:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801385:	48 b8 f9 05 80 00 00 	movabs $0x8005f9,%rax
  80138c:	00 00 00 
  80138f:	ff d0                	call   *%rax
  801391:	48 89 c1             	mov    %rax,%rcx
  801394:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80139a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8013a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a5:	4c 89 ee             	mov    %r13,%rsi
  8013a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8013ad:	48 b8 e9 02 80 00 00 	movabs $0x8002e9,%rax
  8013b4:	00 00 00 
  8013b7:	ff d0                	call   *%rax
  8013b9:	89 c3                	mov    %eax,%ebx
  8013bb:	85 c0                	test   %eax,%eax
  8013bd:	78 6e                	js     80142d <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8013bf:	be 00 10 00 00       	mov    $0x1000,%esi
  8013c4:	4c 89 ef             	mov    %r13,%rdi
  8013c7:	48 b8 24 02 80 00 00 	movabs $0x800224,%rax
  8013ce:	00 00 00 
  8013d1:	ff d0                	call   *%rax
  8013d3:	83 f8 02             	cmp    $0x2,%eax
  8013d6:	0f 85 ab 00 00 00    	jne    801487 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8013dc:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8013e3:	00 00 
  8013e5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013e9:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8013eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013ef:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8013f6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8013fa:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8013fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801400:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801407:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80140b:	48 bb e7 05 80 00 00 	movabs $0x8005e7,%rbx
  801412:	00 00 00 
  801415:	ff d3                	call   *%rbx
  801417:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80141b:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80141f:	ff d3                	call   *%rbx
  801421:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  801426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142b:	eb 4d                	jmp    80147a <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  80142d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801432:	4c 89 ee             	mov    %r13,%rsi
  801435:	bf 00 00 00 00       	mov    $0x0,%edi
  80143a:	48 b8 4e 03 80 00 00 	movabs $0x80034e,%rax
  801441:	00 00 00 
  801444:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  801446:	ba 00 10 00 00       	mov    $0x1000,%edx
  80144b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80144f:	bf 00 00 00 00       	mov    $0x0,%edi
  801454:	48 b8 4e 03 80 00 00 	movabs $0x80034e,%rax
  80145b:	00 00 00 
  80145e:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  801460:	ba 00 10 00 00       	mov    $0x1000,%edx
  801465:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801469:	bf 00 00 00 00       	mov    $0x0,%edi
  80146e:	48 b8 4e 03 80 00 00 	movabs $0x80034e,%rax
  801475:	00 00 00 
  801478:	ff d0                	call   *%rax
}
  80147a:	89 d8                	mov    %ebx,%eax
  80147c:	48 83 c4 18          	add    $0x18,%rsp
  801480:	5b                   	pop    %rbx
  801481:	41 5c                	pop    %r12
  801483:	41 5d                	pop    %r13
  801485:	5d                   	pop    %rbp
  801486:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  801487:	48 b9 d0 2a 80 00 00 	movabs $0x802ad0,%rcx
  80148e:	00 00 00 
  801491:	48 ba a7 2a 80 00 00 	movabs $0x802aa7,%rdx
  801498:	00 00 00 
  80149b:	be 2e 00 00 00       	mov    $0x2e,%esi
  8014a0:	48 bf bc 2a 80 00 00 	movabs $0x802abc,%rdi
  8014a7:	00 00 00 
  8014aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8014af:	49 b8 45 19 80 00 00 	movabs $0x801945,%r8
  8014b6:	00 00 00 
  8014b9:	41 ff d0             	call   *%r8

00000000008014bc <pipeisclosed>:
pipeisclosed(int fdnum) {
  8014bc:	55                   	push   %rbp
  8014bd:	48 89 e5             	mov    %rsp,%rbp
  8014c0:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8014c4:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8014c8:	48 b8 75 06 80 00 00 	movabs $0x800675,%rax
  8014cf:	00 00 00 
  8014d2:	ff d0                	call   *%rax
    if (res < 0) return res;
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	78 35                	js     80150d <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8014d8:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8014dc:	48 b8 f9 05 80 00 00 	movabs $0x8005f9,%rax
  8014e3:	00 00 00 
  8014e6:	ff d0                	call   *%rax
  8014e8:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8014eb:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8014f0:	be 00 10 00 00       	mov    $0x1000,%esi
  8014f5:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8014f9:	48 b8 56 02 80 00 00 	movabs $0x800256,%rax
  801500:	00 00 00 
  801503:	ff d0                	call   *%rax
  801505:	85 c0                	test   %eax,%eax
  801507:	0f 94 c0             	sete   %al
  80150a:	0f b6 c0             	movzbl %al,%eax
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

000000000080150f <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80150f:	48 89 f8             	mov    %rdi,%rax
  801512:	48 c1 e8 27          	shr    $0x27,%rax
  801516:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80151d:	01 00 00 
  801520:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801524:	f6 c2 01             	test   $0x1,%dl
  801527:	74 6d                	je     801596 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801529:	48 89 f8             	mov    %rdi,%rax
  80152c:	48 c1 e8 1e          	shr    $0x1e,%rax
  801530:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801537:	01 00 00 
  80153a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80153e:	f6 c2 01             	test   $0x1,%dl
  801541:	74 62                	je     8015a5 <get_uvpt_entry+0x96>
  801543:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80154a:	01 00 00 
  80154d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801551:	f6 c2 80             	test   $0x80,%dl
  801554:	75 4f                	jne    8015a5 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801556:	48 89 f8             	mov    %rdi,%rax
  801559:	48 c1 e8 15          	shr    $0x15,%rax
  80155d:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801564:	01 00 00 
  801567:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80156b:	f6 c2 01             	test   $0x1,%dl
  80156e:	74 44                	je     8015b4 <get_uvpt_entry+0xa5>
  801570:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801577:	01 00 00 
  80157a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80157e:	f6 c2 80             	test   $0x80,%dl
  801581:	75 31                	jne    8015b4 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  801583:	48 c1 ef 0c          	shr    $0xc,%rdi
  801587:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80158e:	01 00 00 
  801591:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  801595:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801596:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80159d:	01 00 00 
  8015a0:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015a4:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8015a5:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8015ac:	01 00 00 
  8015af:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015b3:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8015b4:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8015bb:	01 00 00 
  8015be:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015c2:	c3                   	ret    

00000000008015c3 <get_prot>:

int
get_prot(void *va) {
  8015c3:	55                   	push   %rbp
  8015c4:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8015c7:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  8015ce:	00 00 00 
  8015d1:	ff d0                	call   *%rax
  8015d3:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8015d6:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8015db:	89 c1                	mov    %eax,%ecx
  8015dd:	83 c9 04             	or     $0x4,%ecx
  8015e0:	f6 c2 01             	test   $0x1,%dl
  8015e3:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8015e6:	89 c1                	mov    %eax,%ecx
  8015e8:	83 c9 02             	or     $0x2,%ecx
  8015eb:	f6 c2 02             	test   $0x2,%dl
  8015ee:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8015f1:	89 c1                	mov    %eax,%ecx
  8015f3:	83 c9 01             	or     $0x1,%ecx
  8015f6:	48 85 d2             	test   %rdx,%rdx
  8015f9:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8015fc:	89 c1                	mov    %eax,%ecx
  8015fe:	83 c9 40             	or     $0x40,%ecx
  801601:	f6 c6 04             	test   $0x4,%dh
  801604:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801607:	5d                   	pop    %rbp
  801608:	c3                   	ret    

0000000000801609 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801609:	55                   	push   %rbp
  80160a:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80160d:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  801614:	00 00 00 
  801617:	ff d0                	call   *%rax
    return pte & PTE_D;
  801619:	48 c1 e8 06          	shr    $0x6,%rax
  80161d:	83 e0 01             	and    $0x1,%eax
}
  801620:	5d                   	pop    %rbp
  801621:	c3                   	ret    

0000000000801622 <is_page_present>:

bool
is_page_present(void *va) {
  801622:	55                   	push   %rbp
  801623:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801626:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  80162d:	00 00 00 
  801630:	ff d0                	call   *%rax
  801632:	83 e0 01             	and    $0x1,%eax
}
  801635:	5d                   	pop    %rbp
  801636:	c3                   	ret    

0000000000801637 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801637:	55                   	push   %rbp
  801638:	48 89 e5             	mov    %rsp,%rbp
  80163b:	41 57                	push   %r15
  80163d:	41 56                	push   %r14
  80163f:	41 55                	push   %r13
  801641:	41 54                	push   %r12
  801643:	53                   	push   %rbx
  801644:	48 83 ec 28          	sub    $0x28,%rsp
  801648:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  80164c:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  801650:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  801655:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  80165c:	01 00 00 
  80165f:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  801666:	01 00 00 
  801669:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  801670:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  801673:	49 bf c3 15 80 00 00 	movabs $0x8015c3,%r15
  80167a:	00 00 00 
  80167d:	eb 16                	jmp    801695 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  80167f:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  801686:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  80168d:	00 00 00 
  801690:	48 39 c3             	cmp    %rax,%rbx
  801693:	77 73                	ja     801708 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  801695:	48 89 d8             	mov    %rbx,%rax
  801698:	48 c1 e8 27          	shr    $0x27,%rax
  80169c:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8016a0:	a8 01                	test   $0x1,%al
  8016a2:	74 db                	je     80167f <foreach_shared_region+0x48>
  8016a4:	48 89 d8             	mov    %rbx,%rax
  8016a7:	48 c1 e8 1e          	shr    $0x1e,%rax
  8016ab:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8016b0:	a8 01                	test   $0x1,%al
  8016b2:	74 cb                	je     80167f <foreach_shared_region+0x48>
  8016b4:	48 89 d8             	mov    %rbx,%rax
  8016b7:	48 c1 e8 15          	shr    $0x15,%rax
  8016bb:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8016bf:	a8 01                	test   $0x1,%al
  8016c1:	74 bc                	je     80167f <foreach_shared_region+0x48>
        void *start = (void*)i;
  8016c3:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016c7:	48 89 df             	mov    %rbx,%rdi
  8016ca:	41 ff d7             	call   *%r15
  8016cd:	a8 40                	test   $0x40,%al
  8016cf:	75 09                	jne    8016da <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8016d1:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8016d8:	eb ac                	jmp    801686 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016da:	48 89 df             	mov    %rbx,%rdi
  8016dd:	48 b8 22 16 80 00 00 	movabs $0x801622,%rax
  8016e4:	00 00 00 
  8016e7:	ff d0                	call   *%rax
  8016e9:	84 c0                	test   %al,%al
  8016eb:	74 e4                	je     8016d1 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  8016ed:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  8016f4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8016f8:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8016fc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801700:	ff d0                	call   *%rax
  801702:	85 c0                	test   %eax,%eax
  801704:	79 cb                	jns    8016d1 <foreach_shared_region+0x9a>
  801706:	eb 05                	jmp    80170d <foreach_shared_region+0xd6>
    }
    return 0;
  801708:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170d:	48 83 c4 28          	add    $0x28,%rsp
  801711:	5b                   	pop    %rbx
  801712:	41 5c                	pop    %r12
  801714:	41 5d                	pop    %r13
  801716:	41 5e                	pop    %r14
  801718:	41 5f                	pop    %r15
  80171a:	5d                   	pop    %rbp
  80171b:	c3                   	ret    

000000000080171c <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
  801721:	c3                   	ret    

0000000000801722 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  801722:	55                   	push   %rbp
  801723:	48 89 e5             	mov    %rsp,%rbp
  801726:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  801729:	48 be f4 2a 80 00 00 	movabs $0x802af4,%rsi
  801730:	00 00 00 
  801733:	48 b8 d6 23 80 00 00 	movabs $0x8023d6,%rax
  80173a:	00 00 00 
  80173d:	ff d0                	call   *%rax
    return 0;
}
  80173f:	b8 00 00 00 00       	mov    $0x0,%eax
  801744:	5d                   	pop    %rbp
  801745:	c3                   	ret    

0000000000801746 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  801746:	55                   	push   %rbp
  801747:	48 89 e5             	mov    %rsp,%rbp
  80174a:	41 57                	push   %r15
  80174c:	41 56                	push   %r14
  80174e:	41 55                	push   %r13
  801750:	41 54                	push   %r12
  801752:	53                   	push   %rbx
  801753:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80175a:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  801761:	48 85 d2             	test   %rdx,%rdx
  801764:	74 78                	je     8017de <devcons_write+0x98>
  801766:	49 89 d6             	mov    %rdx,%r14
  801769:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80176f:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801774:	49 bf d1 25 80 00 00 	movabs $0x8025d1,%r15
  80177b:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80177e:	4c 89 f3             	mov    %r14,%rbx
  801781:	48 29 f3             	sub    %rsi,%rbx
  801784:	48 83 fb 7f          	cmp    $0x7f,%rbx
  801788:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80178d:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801791:	4c 63 eb             	movslq %ebx,%r13
  801794:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  80179b:	4c 89 ea             	mov    %r13,%rdx
  80179e:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017a5:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8017a8:	4c 89 ee             	mov    %r13,%rsi
  8017ab:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017b2:	48 b8 f9 00 80 00 00 	movabs $0x8000f9,%rax
  8017b9:	00 00 00 
  8017bc:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8017be:	41 01 dc             	add    %ebx,%r12d
  8017c1:	49 63 f4             	movslq %r12d,%rsi
  8017c4:	4c 39 f6             	cmp    %r14,%rsi
  8017c7:	72 b5                	jb     80177e <devcons_write+0x38>
    return res;
  8017c9:	49 63 c4             	movslq %r12d,%rax
}
  8017cc:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8017d3:	5b                   	pop    %rbx
  8017d4:	41 5c                	pop    %r12
  8017d6:	41 5d                	pop    %r13
  8017d8:	41 5e                	pop    %r14
  8017da:	41 5f                	pop    %r15
  8017dc:	5d                   	pop    %rbp
  8017dd:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8017de:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8017e4:	eb e3                	jmp    8017c9 <devcons_write+0x83>

00000000008017e6 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8017e6:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8017e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ee:	48 85 c0             	test   %rax,%rax
  8017f1:	74 55                	je     801848 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8017f3:	55                   	push   %rbp
  8017f4:	48 89 e5             	mov    %rsp,%rbp
  8017f7:	41 55                	push   %r13
  8017f9:	41 54                	push   %r12
  8017fb:	53                   	push   %rbx
  8017fc:	48 83 ec 08          	sub    $0x8,%rsp
  801800:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801803:	48 bb 26 01 80 00 00 	movabs $0x800126,%rbx
  80180a:	00 00 00 
  80180d:	49 bc f3 01 80 00 00 	movabs $0x8001f3,%r12
  801814:	00 00 00 
  801817:	eb 03                	jmp    80181c <devcons_read+0x36>
  801819:	41 ff d4             	call   *%r12
  80181c:	ff d3                	call   *%rbx
  80181e:	85 c0                	test   %eax,%eax
  801820:	74 f7                	je     801819 <devcons_read+0x33>
    if (c < 0) return c;
  801822:	48 63 d0             	movslq %eax,%rdx
  801825:	78 13                	js     80183a <devcons_read+0x54>
    if (c == 0x04) return 0;
  801827:	ba 00 00 00 00       	mov    $0x0,%edx
  80182c:	83 f8 04             	cmp    $0x4,%eax
  80182f:	74 09                	je     80183a <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  801831:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801835:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80183a:	48 89 d0             	mov    %rdx,%rax
  80183d:	48 83 c4 08          	add    $0x8,%rsp
  801841:	5b                   	pop    %rbx
  801842:	41 5c                	pop    %r12
  801844:	41 5d                	pop    %r13
  801846:	5d                   	pop    %rbp
  801847:	c3                   	ret    
  801848:	48 89 d0             	mov    %rdx,%rax
  80184b:	c3                   	ret    

000000000080184c <cputchar>:
cputchar(int ch) {
  80184c:	55                   	push   %rbp
  80184d:	48 89 e5             	mov    %rsp,%rbp
  801850:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801854:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801858:	be 01 00 00 00       	mov    $0x1,%esi
  80185d:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801861:	48 b8 f9 00 80 00 00 	movabs $0x8000f9,%rax
  801868:	00 00 00 
  80186b:	ff d0                	call   *%rax
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

000000000080186f <getchar>:
getchar(void) {
  80186f:	55                   	push   %rbp
  801870:	48 89 e5             	mov    %rsp,%rbp
  801873:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801877:	ba 01 00 00 00       	mov    $0x1,%edx
  80187c:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801880:	bf 00 00 00 00       	mov    $0x0,%edi
  801885:	48 b8 58 09 80 00 00 	movabs $0x800958,%rax
  80188c:	00 00 00 
  80188f:	ff d0                	call   *%rax
  801891:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801893:	85 c0                	test   %eax,%eax
  801895:	78 06                	js     80189d <getchar+0x2e>
  801897:	74 08                	je     8018a1 <getchar+0x32>
  801899:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  80189d:	89 d0                	mov    %edx,%eax
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8018a1:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8018a6:	eb f5                	jmp    80189d <getchar+0x2e>

00000000008018a8 <iscons>:
iscons(int fdnum) {
  8018a8:	55                   	push   %rbp
  8018a9:	48 89 e5             	mov    %rsp,%rbp
  8018ac:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8018b0:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018b4:	48 b8 75 06 80 00 00 	movabs $0x800675,%rax
  8018bb:	00 00 00 
  8018be:	ff d0                	call   *%rax
    if (res < 0) return res;
  8018c0:	85 c0                	test   %eax,%eax
  8018c2:	78 18                	js     8018dc <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8018c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018c8:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8018cf:	00 00 00 
  8018d2:	8b 00                	mov    (%rax),%eax
  8018d4:	39 02                	cmp    %eax,(%rdx)
  8018d6:	0f 94 c0             	sete   %al
  8018d9:	0f b6 c0             	movzbl %al,%eax
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

00000000008018de <opencons>:
opencons(void) {
  8018de:	55                   	push   %rbp
  8018df:	48 89 e5             	mov    %rsp,%rbp
  8018e2:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8018e6:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8018ea:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  8018f1:	00 00 00 
  8018f4:	ff d0                	call   *%rax
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	78 49                	js     801943 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8018fa:	b9 46 00 00 00       	mov    $0x46,%ecx
  8018ff:	ba 00 10 00 00       	mov    $0x1000,%edx
  801904:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801908:	bf 00 00 00 00       	mov    $0x0,%edi
  80190d:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  801914:	00 00 00 
  801917:	ff d0                	call   *%rax
  801919:	85 c0                	test   %eax,%eax
  80191b:	78 26                	js     801943 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  80191d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801921:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801928:	00 00 
  80192a:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80192c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801930:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801937:	48 b8 e7 05 80 00 00 	movabs $0x8005e7,%rax
  80193e:	00 00 00 
  801941:	ff d0                	call   *%rax
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

0000000000801945 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801945:	55                   	push   %rbp
  801946:	48 89 e5             	mov    %rsp,%rbp
  801949:	41 56                	push   %r14
  80194b:	41 55                	push   %r13
  80194d:	41 54                	push   %r12
  80194f:	53                   	push   %rbx
  801950:	48 83 ec 50          	sub    $0x50,%rsp
  801954:	49 89 fc             	mov    %rdi,%r12
  801957:	41 89 f5             	mov    %esi,%r13d
  80195a:	48 89 d3             	mov    %rdx,%rbx
  80195d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801961:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801965:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801969:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801970:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801974:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801978:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80197c:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801980:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801987:	00 00 00 
  80198a:	4c 8b 30             	mov    (%rax),%r14
  80198d:	48 b8 c2 01 80 00 00 	movabs $0x8001c2,%rax
  801994:	00 00 00 
  801997:	ff d0                	call   *%rax
  801999:	89 c6                	mov    %eax,%esi
  80199b:	45 89 e8             	mov    %r13d,%r8d
  80199e:	4c 89 e1             	mov    %r12,%rcx
  8019a1:	4c 89 f2             	mov    %r14,%rdx
  8019a4:	48 bf 00 2b 80 00 00 	movabs $0x802b00,%rdi
  8019ab:	00 00 00 
  8019ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b3:	49 bc 95 1a 80 00 00 	movabs $0x801a95,%r12
  8019ba:	00 00 00 
  8019bd:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8019c0:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8019c4:	48 89 df             	mov    %rbx,%rdi
  8019c7:	48 b8 31 1a 80 00 00 	movabs $0x801a31,%rax
  8019ce:	00 00 00 
  8019d1:	ff d0                	call   *%rax
    cprintf("\n");
  8019d3:	48 bf 43 2a 80 00 00 	movabs $0x802a43,%rdi
  8019da:	00 00 00 
  8019dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e2:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8019e5:	cc                   	int3   
  8019e6:	eb fd                	jmp    8019e5 <_panic+0xa0>

00000000008019e8 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8019e8:	55                   	push   %rbp
  8019e9:	48 89 e5             	mov    %rsp,%rbp
  8019ec:	53                   	push   %rbx
  8019ed:	48 83 ec 08          	sub    $0x8,%rsp
  8019f1:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8019f4:	8b 06                	mov    (%rsi),%eax
  8019f6:	8d 50 01             	lea    0x1(%rax),%edx
  8019f9:	89 16                	mov    %edx,(%rsi)
  8019fb:	48 98                	cltq   
  8019fd:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801a02:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801a08:	74 0a                	je     801a14 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801a0a:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801a0e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  801a14:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801a18:	be ff 00 00 00       	mov    $0xff,%esi
  801a1d:	48 b8 f9 00 80 00 00 	movabs $0x8000f9,%rax
  801a24:	00 00 00 
  801a27:	ff d0                	call   *%rax
        state->offset = 0;
  801a29:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801a2f:	eb d9                	jmp    801a0a <putch+0x22>

0000000000801a31 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801a31:	55                   	push   %rbp
  801a32:	48 89 e5             	mov    %rsp,%rbp
  801a35:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801a3c:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801a3f:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801a46:	b9 21 00 00 00       	mov    $0x21,%ecx
  801a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a50:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801a53:	48 89 f1             	mov    %rsi,%rcx
  801a56:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801a5d:	48 bf e8 19 80 00 00 	movabs $0x8019e8,%rdi
  801a64:	00 00 00 
  801a67:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  801a6e:	00 00 00 
  801a71:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801a73:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801a7a:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801a81:	48 b8 f9 00 80 00 00 	movabs $0x8000f9,%rax
  801a88:	00 00 00 
  801a8b:	ff d0                	call   *%rax

    return state.count;
}
  801a8d:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

0000000000801a95 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801a95:	55                   	push   %rbp
  801a96:	48 89 e5             	mov    %rsp,%rbp
  801a99:	48 83 ec 50          	sub    $0x50,%rsp
  801a9d:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801aa1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801aa5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801aa9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801aad:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801ab1:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801ab8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801abc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ac0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801ac4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801ac8:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801acc:	48 b8 31 1a 80 00 00 	movabs $0x801a31,%rax
  801ad3:	00 00 00 
  801ad6:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

0000000000801ada <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801ada:	55                   	push   %rbp
  801adb:	48 89 e5             	mov    %rsp,%rbp
  801ade:	41 57                	push   %r15
  801ae0:	41 56                	push   %r14
  801ae2:	41 55                	push   %r13
  801ae4:	41 54                	push   %r12
  801ae6:	53                   	push   %rbx
  801ae7:	48 83 ec 18          	sub    $0x18,%rsp
  801aeb:	49 89 fc             	mov    %rdi,%r12
  801aee:	49 89 f5             	mov    %rsi,%r13
  801af1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801af5:	8b 45 10             	mov    0x10(%rbp),%eax
  801af8:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801afb:	41 89 cf             	mov    %ecx,%r15d
  801afe:	49 39 d7             	cmp    %rdx,%r15
  801b01:	76 5b                	jbe    801b5e <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801b03:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801b07:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801b0b:	85 db                	test   %ebx,%ebx
  801b0d:	7e 0e                	jle    801b1d <print_num+0x43>
            putch(padc, put_arg);
  801b0f:	4c 89 ee             	mov    %r13,%rsi
  801b12:	44 89 f7             	mov    %r14d,%edi
  801b15:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801b18:	83 eb 01             	sub    $0x1,%ebx
  801b1b:	75 f2                	jne    801b0f <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801b1d:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801b21:	48 b9 23 2b 80 00 00 	movabs $0x802b23,%rcx
  801b28:	00 00 00 
  801b2b:	48 b8 34 2b 80 00 00 	movabs $0x802b34,%rax
  801b32:	00 00 00 
  801b35:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801b39:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b42:	49 f7 f7             	div    %r15
  801b45:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801b49:	4c 89 ee             	mov    %r13,%rsi
  801b4c:	41 ff d4             	call   *%r12
}
  801b4f:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801b53:	5b                   	pop    %rbx
  801b54:	41 5c                	pop    %r12
  801b56:	41 5d                	pop    %r13
  801b58:	41 5e                	pop    %r14
  801b5a:	41 5f                	pop    %r15
  801b5c:	5d                   	pop    %rbp
  801b5d:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801b5e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b62:	ba 00 00 00 00       	mov    $0x0,%edx
  801b67:	49 f7 f7             	div    %r15
  801b6a:	48 83 ec 08          	sub    $0x8,%rsp
  801b6e:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801b72:	52                   	push   %rdx
  801b73:	45 0f be c9          	movsbl %r9b,%r9d
  801b77:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801b7b:	48 89 c2             	mov    %rax,%rdx
  801b7e:	48 b8 da 1a 80 00 00 	movabs $0x801ada,%rax
  801b85:	00 00 00 
  801b88:	ff d0                	call   *%rax
  801b8a:	48 83 c4 10          	add    $0x10,%rsp
  801b8e:	eb 8d                	jmp    801b1d <print_num+0x43>

0000000000801b90 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  801b90:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801b94:	48 8b 06             	mov    (%rsi),%rax
  801b97:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801b9b:	73 0a                	jae    801ba7 <sprintputch+0x17>
        *state->start++ = ch;
  801b9d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ba1:	48 89 16             	mov    %rdx,(%rsi)
  801ba4:	40 88 38             	mov    %dil,(%rax)
    }
}
  801ba7:	c3                   	ret    

0000000000801ba8 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801ba8:	55                   	push   %rbp
  801ba9:	48 89 e5             	mov    %rsp,%rbp
  801bac:	48 83 ec 50          	sub    $0x50,%rsp
  801bb0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bb4:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801bb8:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801bbc:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801bc3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801bc7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801bcb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801bcf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801bd3:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801bd7:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  801bde:	00 00 00 
  801be1:	ff d0                	call   *%rax
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

0000000000801be5 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801be5:	55                   	push   %rbp
  801be6:	48 89 e5             	mov    %rsp,%rbp
  801be9:	41 57                	push   %r15
  801beb:	41 56                	push   %r14
  801bed:	41 55                	push   %r13
  801bef:	41 54                	push   %r12
  801bf1:	53                   	push   %rbx
  801bf2:	48 83 ec 48          	sub    $0x48,%rsp
  801bf6:	49 89 fc             	mov    %rdi,%r12
  801bf9:	49 89 f6             	mov    %rsi,%r14
  801bfc:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  801bff:	48 8b 01             	mov    (%rcx),%rax
  801c02:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801c06:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801c0a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801c0e:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801c12:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801c16:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  801c1a:	41 0f b6 3f          	movzbl (%r15),%edi
  801c1e:	40 80 ff 25          	cmp    $0x25,%dil
  801c22:	74 18                	je     801c3c <vprintfmt+0x57>
            if (!ch) return;
  801c24:	40 84 ff             	test   %dil,%dil
  801c27:	0f 84 d1 06 00 00    	je     8022fe <vprintfmt+0x719>
            putch(ch, put_arg);
  801c2d:	40 0f b6 ff          	movzbl %dil,%edi
  801c31:	4c 89 f6             	mov    %r14,%rsi
  801c34:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  801c37:	49 89 df             	mov    %rbx,%r15
  801c3a:	eb da                	jmp    801c16 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  801c3c:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  801c40:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c45:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  801c49:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801c4e:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801c54:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801c5b:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  801c5f:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  801c64:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  801c6a:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  801c6e:	44 0f b6 0b          	movzbl (%rbx),%r9d
  801c72:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  801c76:	3c 57                	cmp    $0x57,%al
  801c78:	0f 87 65 06 00 00    	ja     8022e3 <vprintfmt+0x6fe>
  801c7e:	0f b6 c0             	movzbl %al,%eax
  801c81:	49 ba c0 2c 80 00 00 	movabs $0x802cc0,%r10
  801c88:	00 00 00 
  801c8b:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  801c8f:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  801c92:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  801c96:	eb d2                	jmp    801c6a <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  801c98:	4c 89 fb             	mov    %r15,%rbx
  801c9b:	44 89 c1             	mov    %r8d,%ecx
  801c9e:	eb ca                	jmp    801c6a <vprintfmt+0x85>
            padc = ch;
  801ca0:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  801ca4:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801ca7:	eb c1                	jmp    801c6a <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801ca9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801cac:	83 f8 2f             	cmp    $0x2f,%eax
  801caf:	77 24                	ja     801cd5 <vprintfmt+0xf0>
  801cb1:	41 89 c1             	mov    %eax,%r9d
  801cb4:	49 01 f1             	add    %rsi,%r9
  801cb7:	83 c0 08             	add    $0x8,%eax
  801cba:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801cbd:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  801cc0:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  801cc3:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801cc7:	79 a1                	jns    801c6a <vprintfmt+0x85>
                width = precision;
  801cc9:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  801ccd:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801cd3:	eb 95                	jmp    801c6a <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cd5:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  801cd9:	49 8d 41 08          	lea    0x8(%r9),%rax
  801cdd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ce1:	eb da                	jmp    801cbd <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  801ce3:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  801ce7:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801ceb:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  801cef:	3c 39                	cmp    $0x39,%al
  801cf1:	77 1e                	ja     801d11 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  801cf3:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  801cf7:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  801cfc:	0f b6 c0             	movzbl %al,%eax
  801cff:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d04:	41 0f b6 07          	movzbl (%r15),%eax
  801d08:	3c 39                	cmp    $0x39,%al
  801d0a:	76 e7                	jbe    801cf3 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  801d0c:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  801d0f:	eb b2                	jmp    801cc3 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  801d11:	4c 89 fb             	mov    %r15,%rbx
  801d14:	eb ad                	jmp    801cc3 <vprintfmt+0xde>
            width = MAX(0, width);
  801d16:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801d19:	85 c0                	test   %eax,%eax
  801d1b:	0f 48 c7             	cmovs  %edi,%eax
  801d1e:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801d21:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d24:	e9 41 ff ff ff       	jmp    801c6a <vprintfmt+0x85>
            lflag++;
  801d29:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801d2c:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d2f:	e9 36 ff ff ff       	jmp    801c6a <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  801d34:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d37:	83 f8 2f             	cmp    $0x2f,%eax
  801d3a:	77 18                	ja     801d54 <vprintfmt+0x16f>
  801d3c:	89 c2                	mov    %eax,%edx
  801d3e:	48 01 f2             	add    %rsi,%rdx
  801d41:	83 c0 08             	add    $0x8,%eax
  801d44:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d47:	4c 89 f6             	mov    %r14,%rsi
  801d4a:	8b 3a                	mov    (%rdx),%edi
  801d4c:	41 ff d4             	call   *%r12
            break;
  801d4f:	e9 c2 fe ff ff       	jmp    801c16 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  801d54:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801d58:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801d5c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d60:	eb e5                	jmp    801d47 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  801d62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d65:	83 f8 2f             	cmp    $0x2f,%eax
  801d68:	77 5b                	ja     801dc5 <vprintfmt+0x1e0>
  801d6a:	89 c2                	mov    %eax,%edx
  801d6c:	48 01 d6             	add    %rdx,%rsi
  801d6f:	83 c0 08             	add    $0x8,%eax
  801d72:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d75:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  801d77:	89 c8                	mov    %ecx,%eax
  801d79:	c1 f8 1f             	sar    $0x1f,%eax
  801d7c:	31 c1                	xor    %eax,%ecx
  801d7e:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  801d80:	83 f9 13             	cmp    $0x13,%ecx
  801d83:	7f 4e                	jg     801dd3 <vprintfmt+0x1ee>
  801d85:	48 63 c1             	movslq %ecx,%rax
  801d88:	48 ba 80 2f 80 00 00 	movabs $0x802f80,%rdx
  801d8f:	00 00 00 
  801d92:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801d96:	48 85 c0             	test   %rax,%rax
  801d99:	74 38                	je     801dd3 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  801d9b:	48 89 c1             	mov    %rax,%rcx
  801d9e:	48 ba b9 2a 80 00 00 	movabs $0x802ab9,%rdx
  801da5:	00 00 00 
  801da8:	4c 89 f6             	mov    %r14,%rsi
  801dab:	4c 89 e7             	mov    %r12,%rdi
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
  801db3:	49 b8 a8 1b 80 00 00 	movabs $0x801ba8,%r8
  801dba:	00 00 00 
  801dbd:	41 ff d0             	call   *%r8
  801dc0:	e9 51 fe ff ff       	jmp    801c16 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  801dc5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801dc9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801dcd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801dd1:	eb a2                	jmp    801d75 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  801dd3:	48 ba 4c 2b 80 00 00 	movabs $0x802b4c,%rdx
  801dda:	00 00 00 
  801ddd:	4c 89 f6             	mov    %r14,%rsi
  801de0:	4c 89 e7             	mov    %r12,%rdi
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
  801de8:	49 b8 a8 1b 80 00 00 	movabs $0x801ba8,%r8
  801def:	00 00 00 
  801df2:	41 ff d0             	call   *%r8
  801df5:	e9 1c fe ff ff       	jmp    801c16 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  801dfa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801dfd:	83 f8 2f             	cmp    $0x2f,%eax
  801e00:	77 55                	ja     801e57 <vprintfmt+0x272>
  801e02:	89 c2                	mov    %eax,%edx
  801e04:	48 01 d6             	add    %rdx,%rsi
  801e07:	83 c0 08             	add    $0x8,%eax
  801e0a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801e0d:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  801e10:	48 85 d2             	test   %rdx,%rdx
  801e13:	48 b8 45 2b 80 00 00 	movabs $0x802b45,%rax
  801e1a:	00 00 00 
  801e1d:	48 0f 45 c2          	cmovne %rdx,%rax
  801e21:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  801e25:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801e29:	7e 06                	jle    801e31 <vprintfmt+0x24c>
  801e2b:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  801e2f:	75 34                	jne    801e65 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801e31:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  801e35:	48 8d 58 01          	lea    0x1(%rax),%rbx
  801e39:	0f b6 00             	movzbl (%rax),%eax
  801e3c:	84 c0                	test   %al,%al
  801e3e:	0f 84 b2 00 00 00    	je     801ef6 <vprintfmt+0x311>
  801e44:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  801e48:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  801e4d:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  801e51:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  801e55:	eb 74                	jmp    801ecb <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  801e57:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801e5b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801e5f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e63:	eb a8                	jmp    801e0d <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  801e65:	49 63 f5             	movslq %r13d,%rsi
  801e68:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  801e6c:	48 b8 b8 23 80 00 00 	movabs $0x8023b8,%rax
  801e73:	00 00 00 
  801e76:	ff d0                	call   *%rax
  801e78:	48 89 c2             	mov    %rax,%rdx
  801e7b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801e7e:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  801e80:	8d 48 ff             	lea    -0x1(%rax),%ecx
  801e83:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  801e86:	85 c0                	test   %eax,%eax
  801e88:	7e a7                	jle    801e31 <vprintfmt+0x24c>
  801e8a:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  801e8e:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  801e92:	41 89 cd             	mov    %ecx,%r13d
  801e95:	4c 89 f6             	mov    %r14,%rsi
  801e98:	89 df                	mov    %ebx,%edi
  801e9a:	41 ff d4             	call   *%r12
  801e9d:	41 83 ed 01          	sub    $0x1,%r13d
  801ea1:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  801ea5:	75 ee                	jne    801e95 <vprintfmt+0x2b0>
  801ea7:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  801eab:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  801eaf:	eb 80                	jmp    801e31 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801eb1:	0f b6 f8             	movzbl %al,%edi
  801eb4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801eb8:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801ebb:	41 83 ef 01          	sub    $0x1,%r15d
  801ebf:	48 83 c3 01          	add    $0x1,%rbx
  801ec3:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  801ec7:	84 c0                	test   %al,%al
  801ec9:	74 1f                	je     801eea <vprintfmt+0x305>
  801ecb:	45 85 ed             	test   %r13d,%r13d
  801ece:	78 06                	js     801ed6 <vprintfmt+0x2f1>
  801ed0:	41 83 ed 01          	sub    $0x1,%r13d
  801ed4:	78 46                	js     801f1c <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801ed6:	45 84 f6             	test   %r14b,%r14b
  801ed9:	74 d6                	je     801eb1 <vprintfmt+0x2cc>
  801edb:	8d 50 e0             	lea    -0x20(%rax),%edx
  801ede:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801ee3:	80 fa 5e             	cmp    $0x5e,%dl
  801ee6:	77 cc                	ja     801eb4 <vprintfmt+0x2cf>
  801ee8:	eb c7                	jmp    801eb1 <vprintfmt+0x2cc>
  801eea:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801eee:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801ef2:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  801ef6:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801ef9:	8d 58 ff             	lea    -0x1(%rax),%ebx
  801efc:	85 c0                	test   %eax,%eax
  801efe:	0f 8e 12 fd ff ff    	jle    801c16 <vprintfmt+0x31>
  801f04:	4c 89 f6             	mov    %r14,%rsi
  801f07:	bf 20 00 00 00       	mov    $0x20,%edi
  801f0c:	41 ff d4             	call   *%r12
  801f0f:	83 eb 01             	sub    $0x1,%ebx
  801f12:	83 fb ff             	cmp    $0xffffffff,%ebx
  801f15:	75 ed                	jne    801f04 <vprintfmt+0x31f>
  801f17:	e9 fa fc ff ff       	jmp    801c16 <vprintfmt+0x31>
  801f1c:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f20:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f24:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  801f28:	eb cc                	jmp    801ef6 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  801f2a:	45 89 cd             	mov    %r9d,%r13d
  801f2d:	84 c9                	test   %cl,%cl
  801f2f:	75 25                	jne    801f56 <vprintfmt+0x371>
    switch (lflag) {
  801f31:	85 d2                	test   %edx,%edx
  801f33:	74 57                	je     801f8c <vprintfmt+0x3a7>
  801f35:	83 fa 01             	cmp    $0x1,%edx
  801f38:	74 78                	je     801fb2 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  801f3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f3d:	83 f8 2f             	cmp    $0x2f,%eax
  801f40:	0f 87 92 00 00 00    	ja     801fd8 <vprintfmt+0x3f3>
  801f46:	89 c2                	mov    %eax,%edx
  801f48:	48 01 d6             	add    %rdx,%rsi
  801f4b:	83 c0 08             	add    $0x8,%eax
  801f4e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f51:	48 8b 1e             	mov    (%rsi),%rbx
  801f54:	eb 16                	jmp    801f6c <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  801f56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f59:	83 f8 2f             	cmp    $0x2f,%eax
  801f5c:	77 20                	ja     801f7e <vprintfmt+0x399>
  801f5e:	89 c2                	mov    %eax,%edx
  801f60:	48 01 d6             	add    %rdx,%rsi
  801f63:	83 c0 08             	add    $0x8,%eax
  801f66:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f69:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  801f6c:	48 85 db             	test   %rbx,%rbx
  801f6f:	78 78                	js     801fe9 <vprintfmt+0x404>
            num = i;
  801f71:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  801f74:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  801f79:	e9 49 02 00 00       	jmp    8021c7 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801f7e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801f82:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801f86:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f8a:	eb dd                	jmp    801f69 <vprintfmt+0x384>
        return va_arg(*ap, int);
  801f8c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f8f:	83 f8 2f             	cmp    $0x2f,%eax
  801f92:	77 10                	ja     801fa4 <vprintfmt+0x3bf>
  801f94:	89 c2                	mov    %eax,%edx
  801f96:	48 01 d6             	add    %rdx,%rsi
  801f99:	83 c0 08             	add    $0x8,%eax
  801f9c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f9f:	48 63 1e             	movslq (%rsi),%rbx
  801fa2:	eb c8                	jmp    801f6c <vprintfmt+0x387>
  801fa4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fa8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fac:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fb0:	eb ed                	jmp    801f9f <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  801fb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fb5:	83 f8 2f             	cmp    $0x2f,%eax
  801fb8:	77 10                	ja     801fca <vprintfmt+0x3e5>
  801fba:	89 c2                	mov    %eax,%edx
  801fbc:	48 01 d6             	add    %rdx,%rsi
  801fbf:	83 c0 08             	add    $0x8,%eax
  801fc2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fc5:	48 8b 1e             	mov    (%rsi),%rbx
  801fc8:	eb a2                	jmp    801f6c <vprintfmt+0x387>
  801fca:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fce:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fd2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fd6:	eb ed                	jmp    801fc5 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  801fd8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fdc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fe0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fe4:	e9 68 ff ff ff       	jmp    801f51 <vprintfmt+0x36c>
                putch('-', put_arg);
  801fe9:	4c 89 f6             	mov    %r14,%rsi
  801fec:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801ff1:	41 ff d4             	call   *%r12
                i = -i;
  801ff4:	48 f7 db             	neg    %rbx
  801ff7:	e9 75 ff ff ff       	jmp    801f71 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  801ffc:	45 89 cd             	mov    %r9d,%r13d
  801fff:	84 c9                	test   %cl,%cl
  802001:	75 2d                	jne    802030 <vprintfmt+0x44b>
    switch (lflag) {
  802003:	85 d2                	test   %edx,%edx
  802005:	74 57                	je     80205e <vprintfmt+0x479>
  802007:	83 fa 01             	cmp    $0x1,%edx
  80200a:	74 7f                	je     80208b <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  80200c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80200f:	83 f8 2f             	cmp    $0x2f,%eax
  802012:	0f 87 a1 00 00 00    	ja     8020b9 <vprintfmt+0x4d4>
  802018:	89 c2                	mov    %eax,%edx
  80201a:	48 01 d6             	add    %rdx,%rsi
  80201d:	83 c0 08             	add    $0x8,%eax
  802020:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802023:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802026:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80202b:	e9 97 01 00 00       	jmp    8021c7 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802030:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802033:	83 f8 2f             	cmp    $0x2f,%eax
  802036:	77 18                	ja     802050 <vprintfmt+0x46b>
  802038:	89 c2                	mov    %eax,%edx
  80203a:	48 01 d6             	add    %rdx,%rsi
  80203d:	83 c0 08             	add    $0x8,%eax
  802040:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802043:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802046:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80204b:	e9 77 01 00 00       	jmp    8021c7 <vprintfmt+0x5e2>
  802050:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802054:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802058:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80205c:	eb e5                	jmp    802043 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  80205e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802061:	83 f8 2f             	cmp    $0x2f,%eax
  802064:	77 17                	ja     80207d <vprintfmt+0x498>
  802066:	89 c2                	mov    %eax,%edx
  802068:	48 01 d6             	add    %rdx,%rsi
  80206b:	83 c0 08             	add    $0x8,%eax
  80206e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802071:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  802073:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802078:	e9 4a 01 00 00       	jmp    8021c7 <vprintfmt+0x5e2>
  80207d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802081:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802085:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802089:	eb e6                	jmp    802071 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  80208b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80208e:	83 f8 2f             	cmp    $0x2f,%eax
  802091:	77 18                	ja     8020ab <vprintfmt+0x4c6>
  802093:	89 c2                	mov    %eax,%edx
  802095:	48 01 d6             	add    %rdx,%rsi
  802098:	83 c0 08             	add    $0x8,%eax
  80209b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80209e:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8020a1:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8020a6:	e9 1c 01 00 00       	jmp    8021c7 <vprintfmt+0x5e2>
  8020ab:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020af:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020b3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020b7:	eb e5                	jmp    80209e <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8020b9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020bd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020c1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020c5:	e9 59 ff ff ff       	jmp    802023 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8020ca:	45 89 cd             	mov    %r9d,%r13d
  8020cd:	84 c9                	test   %cl,%cl
  8020cf:	75 2d                	jne    8020fe <vprintfmt+0x519>
    switch (lflag) {
  8020d1:	85 d2                	test   %edx,%edx
  8020d3:	74 57                	je     80212c <vprintfmt+0x547>
  8020d5:	83 fa 01             	cmp    $0x1,%edx
  8020d8:	74 7c                	je     802156 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8020da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020dd:	83 f8 2f             	cmp    $0x2f,%eax
  8020e0:	0f 87 9b 00 00 00    	ja     802181 <vprintfmt+0x59c>
  8020e6:	89 c2                	mov    %eax,%edx
  8020e8:	48 01 d6             	add    %rdx,%rsi
  8020eb:	83 c0 08             	add    $0x8,%eax
  8020ee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020f1:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8020f4:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8020f9:	e9 c9 00 00 00       	jmp    8021c7 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8020fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802101:	83 f8 2f             	cmp    $0x2f,%eax
  802104:	77 18                	ja     80211e <vprintfmt+0x539>
  802106:	89 c2                	mov    %eax,%edx
  802108:	48 01 d6             	add    %rdx,%rsi
  80210b:	83 c0 08             	add    $0x8,%eax
  80210e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802111:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802114:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802119:	e9 a9 00 00 00       	jmp    8021c7 <vprintfmt+0x5e2>
  80211e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802122:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802126:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80212a:	eb e5                	jmp    802111 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  80212c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80212f:	83 f8 2f             	cmp    $0x2f,%eax
  802132:	77 14                	ja     802148 <vprintfmt+0x563>
  802134:	89 c2                	mov    %eax,%edx
  802136:	48 01 d6             	add    %rdx,%rsi
  802139:	83 c0 08             	add    $0x8,%eax
  80213c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80213f:	8b 16                	mov    (%rsi),%edx
            base = 8;
  802141:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  802146:	eb 7f                	jmp    8021c7 <vprintfmt+0x5e2>
  802148:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80214c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802150:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802154:	eb e9                	jmp    80213f <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  802156:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802159:	83 f8 2f             	cmp    $0x2f,%eax
  80215c:	77 15                	ja     802173 <vprintfmt+0x58e>
  80215e:	89 c2                	mov    %eax,%edx
  802160:	48 01 d6             	add    %rdx,%rsi
  802163:	83 c0 08             	add    $0x8,%eax
  802166:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802169:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80216c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  802171:	eb 54                	jmp    8021c7 <vprintfmt+0x5e2>
  802173:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802177:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80217b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80217f:	eb e8                	jmp    802169 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  802181:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802185:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802189:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80218d:	e9 5f ff ff ff       	jmp    8020f1 <vprintfmt+0x50c>
            putch('0', put_arg);
  802192:	45 89 cd             	mov    %r9d,%r13d
  802195:	4c 89 f6             	mov    %r14,%rsi
  802198:	bf 30 00 00 00       	mov    $0x30,%edi
  80219d:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8021a0:	4c 89 f6             	mov    %r14,%rsi
  8021a3:	bf 78 00 00 00       	mov    $0x78,%edi
  8021a8:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8021ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021ae:	83 f8 2f             	cmp    $0x2f,%eax
  8021b1:	77 47                	ja     8021fa <vprintfmt+0x615>
  8021b3:	89 c2                	mov    %eax,%edx
  8021b5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021b9:	83 c0 08             	add    $0x8,%eax
  8021bc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021bf:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8021c2:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8021c7:	48 83 ec 08          	sub    $0x8,%rsp
  8021cb:	41 80 fd 58          	cmp    $0x58,%r13b
  8021cf:	0f 94 c0             	sete   %al
  8021d2:	0f b6 c0             	movzbl %al,%eax
  8021d5:	50                   	push   %rax
  8021d6:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  8021db:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8021df:	4c 89 f6             	mov    %r14,%rsi
  8021e2:	4c 89 e7             	mov    %r12,%rdi
  8021e5:	48 b8 da 1a 80 00 00 	movabs $0x801ada,%rax
  8021ec:	00 00 00 
  8021ef:	ff d0                	call   *%rax
            break;
  8021f1:	48 83 c4 10          	add    $0x10,%rsp
  8021f5:	e9 1c fa ff ff       	jmp    801c16 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  8021fa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8021fe:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802202:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802206:	eb b7                	jmp    8021bf <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  802208:	45 89 cd             	mov    %r9d,%r13d
  80220b:	84 c9                	test   %cl,%cl
  80220d:	75 2a                	jne    802239 <vprintfmt+0x654>
    switch (lflag) {
  80220f:	85 d2                	test   %edx,%edx
  802211:	74 54                	je     802267 <vprintfmt+0x682>
  802213:	83 fa 01             	cmp    $0x1,%edx
  802216:	74 7c                	je     802294 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  802218:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80221b:	83 f8 2f             	cmp    $0x2f,%eax
  80221e:	0f 87 9e 00 00 00    	ja     8022c2 <vprintfmt+0x6dd>
  802224:	89 c2                	mov    %eax,%edx
  802226:	48 01 d6             	add    %rdx,%rsi
  802229:	83 c0 08             	add    $0x8,%eax
  80222c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80222f:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802232:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  802237:	eb 8e                	jmp    8021c7 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802239:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80223c:	83 f8 2f             	cmp    $0x2f,%eax
  80223f:	77 18                	ja     802259 <vprintfmt+0x674>
  802241:	89 c2                	mov    %eax,%edx
  802243:	48 01 d6             	add    %rdx,%rsi
  802246:	83 c0 08             	add    $0x8,%eax
  802249:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80224c:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80224f:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802254:	e9 6e ff ff ff       	jmp    8021c7 <vprintfmt+0x5e2>
  802259:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80225d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802261:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802265:	eb e5                	jmp    80224c <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  802267:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80226a:	83 f8 2f             	cmp    $0x2f,%eax
  80226d:	77 17                	ja     802286 <vprintfmt+0x6a1>
  80226f:	89 c2                	mov    %eax,%edx
  802271:	48 01 d6             	add    %rdx,%rsi
  802274:	83 c0 08             	add    $0x8,%eax
  802277:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80227a:	8b 16                	mov    (%rsi),%edx
            base = 16;
  80227c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  802281:	e9 41 ff ff ff       	jmp    8021c7 <vprintfmt+0x5e2>
  802286:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80228a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80228e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802292:	eb e6                	jmp    80227a <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  802294:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802297:	83 f8 2f             	cmp    $0x2f,%eax
  80229a:	77 18                	ja     8022b4 <vprintfmt+0x6cf>
  80229c:	89 c2                	mov    %eax,%edx
  80229e:	48 01 d6             	add    %rdx,%rsi
  8022a1:	83 c0 08             	add    $0x8,%eax
  8022a4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022a7:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8022aa:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8022af:	e9 13 ff ff ff       	jmp    8021c7 <vprintfmt+0x5e2>
  8022b4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022b8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022c0:	eb e5                	jmp    8022a7 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  8022c2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022c6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022ce:	e9 5c ff ff ff       	jmp    80222f <vprintfmt+0x64a>
            putch(ch, put_arg);
  8022d3:	4c 89 f6             	mov    %r14,%rsi
  8022d6:	bf 25 00 00 00       	mov    $0x25,%edi
  8022db:	41 ff d4             	call   *%r12
            break;
  8022de:	e9 33 f9 ff ff       	jmp    801c16 <vprintfmt+0x31>
            putch('%', put_arg);
  8022e3:	4c 89 f6             	mov    %r14,%rsi
  8022e6:	bf 25 00 00 00       	mov    $0x25,%edi
  8022eb:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  8022ee:	49 83 ef 01          	sub    $0x1,%r15
  8022f2:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  8022f7:	75 f5                	jne    8022ee <vprintfmt+0x709>
  8022f9:	e9 18 f9 ff ff       	jmp    801c16 <vprintfmt+0x31>
}
  8022fe:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802302:	5b                   	pop    %rbx
  802303:	41 5c                	pop    %r12
  802305:	41 5d                	pop    %r13
  802307:	41 5e                	pop    %r14
  802309:	41 5f                	pop    %r15
  80230b:	5d                   	pop    %rbp
  80230c:	c3                   	ret    

000000000080230d <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  80230d:	55                   	push   %rbp
  80230e:	48 89 e5             	mov    %rsp,%rbp
  802311:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  802315:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802319:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  80231e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802322:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  802329:	48 85 ff             	test   %rdi,%rdi
  80232c:	74 2b                	je     802359 <vsnprintf+0x4c>
  80232e:	48 85 f6             	test   %rsi,%rsi
  802331:	74 26                	je     802359 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  802333:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802337:	48 bf 90 1b 80 00 00 	movabs $0x801b90,%rdi
  80233e:	00 00 00 
  802341:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  802348:	00 00 00 
  80234b:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  80234d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802351:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  802354:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  802359:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80235e:	eb f7                	jmp    802357 <vsnprintf+0x4a>

0000000000802360 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  802360:	55                   	push   %rbp
  802361:	48 89 e5             	mov    %rsp,%rbp
  802364:	48 83 ec 50          	sub    $0x50,%rsp
  802368:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80236c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802370:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802374:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80237b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80237f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802383:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802387:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  80238b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80238f:	48 b8 0d 23 80 00 00 	movabs $0x80230d,%rax
  802396:	00 00 00 
  802399:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

000000000080239d <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  80239d:	80 3f 00             	cmpb   $0x0,(%rdi)
  8023a0:	74 10                	je     8023b2 <strlen+0x15>
    size_t n = 0;
  8023a2:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8023a7:	48 83 c0 01          	add    $0x1,%rax
  8023ab:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023af:	75 f6                	jne    8023a7 <strlen+0xa>
  8023b1:	c3                   	ret    
    size_t n = 0;
  8023b2:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  8023b7:	c3                   	ret    

00000000008023b8 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  8023b8:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  8023bd:	48 85 f6             	test   %rsi,%rsi
  8023c0:	74 10                	je     8023d2 <strnlen+0x1a>
  8023c2:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023c6:	74 09                	je     8023d1 <strnlen+0x19>
  8023c8:	48 83 c0 01          	add    $0x1,%rax
  8023cc:	48 39 c6             	cmp    %rax,%rsi
  8023cf:	75 f1                	jne    8023c2 <strnlen+0xa>
    return n;
}
  8023d1:	c3                   	ret    
    size_t n = 0;
  8023d2:	48 89 f0             	mov    %rsi,%rax
  8023d5:	c3                   	ret    

00000000008023d6 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8023d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023db:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  8023df:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  8023e2:	48 83 c0 01          	add    $0x1,%rax
  8023e6:	84 d2                	test   %dl,%dl
  8023e8:	75 f1                	jne    8023db <strcpy+0x5>
        ;
    return res;
}
  8023ea:	48 89 f8             	mov    %rdi,%rax
  8023ed:	c3                   	ret    

00000000008023ee <strcat>:

char *
strcat(char *dst, const char *src) {
  8023ee:	55                   	push   %rbp
  8023ef:	48 89 e5             	mov    %rsp,%rbp
  8023f2:	41 54                	push   %r12
  8023f4:	53                   	push   %rbx
  8023f5:	48 89 fb             	mov    %rdi,%rbx
  8023f8:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8023fb:	48 b8 9d 23 80 00 00 	movabs $0x80239d,%rax
  802402:	00 00 00 
  802405:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  802407:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  80240b:	4c 89 e6             	mov    %r12,%rsi
  80240e:	48 b8 d6 23 80 00 00 	movabs $0x8023d6,%rax
  802415:	00 00 00 
  802418:	ff d0                	call   *%rax
    return dst;
}
  80241a:	48 89 d8             	mov    %rbx,%rax
  80241d:	5b                   	pop    %rbx
  80241e:	41 5c                	pop    %r12
  802420:	5d                   	pop    %rbp
  802421:	c3                   	ret    

0000000000802422 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  802422:	48 85 d2             	test   %rdx,%rdx
  802425:	74 1d                	je     802444 <strncpy+0x22>
  802427:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80242b:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  80242e:	48 83 c0 01          	add    $0x1,%rax
  802432:	0f b6 16             	movzbl (%rsi),%edx
  802435:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  802438:	80 fa 01             	cmp    $0x1,%dl
  80243b:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  80243f:	48 39 c1             	cmp    %rax,%rcx
  802442:	75 ea                	jne    80242e <strncpy+0xc>
    }
    return ret;
}
  802444:	48 89 f8             	mov    %rdi,%rax
  802447:	c3                   	ret    

0000000000802448 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  802448:	48 89 f8             	mov    %rdi,%rax
  80244b:	48 85 d2             	test   %rdx,%rdx
  80244e:	74 24                	je     802474 <strlcpy+0x2c>
        while (--size > 0 && *src)
  802450:	48 83 ea 01          	sub    $0x1,%rdx
  802454:	74 1b                	je     802471 <strlcpy+0x29>
  802456:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80245a:	0f b6 16             	movzbl (%rsi),%edx
  80245d:	84 d2                	test   %dl,%dl
  80245f:	74 10                	je     802471 <strlcpy+0x29>
            *dst++ = *src++;
  802461:	48 83 c6 01          	add    $0x1,%rsi
  802465:	48 83 c0 01          	add    $0x1,%rax
  802469:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80246c:	48 39 c8             	cmp    %rcx,%rax
  80246f:	75 e9                	jne    80245a <strlcpy+0x12>
        *dst = '\0';
  802471:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802474:	48 29 f8             	sub    %rdi,%rax
}
  802477:	c3                   	ret    

0000000000802478 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  802478:	0f b6 07             	movzbl (%rdi),%eax
  80247b:	84 c0                	test   %al,%al
  80247d:	74 13                	je     802492 <strcmp+0x1a>
  80247f:	38 06                	cmp    %al,(%rsi)
  802481:	75 0f                	jne    802492 <strcmp+0x1a>
  802483:	48 83 c7 01          	add    $0x1,%rdi
  802487:	48 83 c6 01          	add    $0x1,%rsi
  80248b:	0f b6 07             	movzbl (%rdi),%eax
  80248e:	84 c0                	test   %al,%al
  802490:	75 ed                	jne    80247f <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  802492:	0f b6 c0             	movzbl %al,%eax
  802495:	0f b6 16             	movzbl (%rsi),%edx
  802498:	29 d0                	sub    %edx,%eax
}
  80249a:	c3                   	ret    

000000000080249b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  80249b:	48 85 d2             	test   %rdx,%rdx
  80249e:	74 1f                	je     8024bf <strncmp+0x24>
  8024a0:	0f b6 07             	movzbl (%rdi),%eax
  8024a3:	84 c0                	test   %al,%al
  8024a5:	74 1e                	je     8024c5 <strncmp+0x2a>
  8024a7:	3a 06                	cmp    (%rsi),%al
  8024a9:	75 1a                	jne    8024c5 <strncmp+0x2a>
  8024ab:	48 83 c7 01          	add    $0x1,%rdi
  8024af:	48 83 c6 01          	add    $0x1,%rsi
  8024b3:	48 83 ea 01          	sub    $0x1,%rdx
  8024b7:	75 e7                	jne    8024a0 <strncmp+0x5>

    if (!n) return 0;
  8024b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024be:	c3                   	ret    
  8024bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c4:	c3                   	ret    
  8024c5:	48 85 d2             	test   %rdx,%rdx
  8024c8:	74 09                	je     8024d3 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  8024ca:	0f b6 07             	movzbl (%rdi),%eax
  8024cd:	0f b6 16             	movzbl (%rsi),%edx
  8024d0:	29 d0                	sub    %edx,%eax
  8024d2:	c3                   	ret    
    if (!n) return 0;
  8024d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d8:	c3                   	ret    

00000000008024d9 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  8024d9:	0f b6 07             	movzbl (%rdi),%eax
  8024dc:	84 c0                	test   %al,%al
  8024de:	74 18                	je     8024f8 <strchr+0x1f>
        if (*str == c) {
  8024e0:	0f be c0             	movsbl %al,%eax
  8024e3:	39 f0                	cmp    %esi,%eax
  8024e5:	74 17                	je     8024fe <strchr+0x25>
    for (; *str; str++) {
  8024e7:	48 83 c7 01          	add    $0x1,%rdi
  8024eb:	0f b6 07             	movzbl (%rdi),%eax
  8024ee:	84 c0                	test   %al,%al
  8024f0:	75 ee                	jne    8024e0 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f7:	c3                   	ret    
  8024f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fd:	c3                   	ret    
  8024fe:	48 89 f8             	mov    %rdi,%rax
}
  802501:	c3                   	ret    

0000000000802502 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  802502:	0f b6 07             	movzbl (%rdi),%eax
  802505:	84 c0                	test   %al,%al
  802507:	74 16                	je     80251f <strfind+0x1d>
  802509:	0f be c0             	movsbl %al,%eax
  80250c:	39 f0                	cmp    %esi,%eax
  80250e:	74 13                	je     802523 <strfind+0x21>
  802510:	48 83 c7 01          	add    $0x1,%rdi
  802514:	0f b6 07             	movzbl (%rdi),%eax
  802517:	84 c0                	test   %al,%al
  802519:	75 ee                	jne    802509 <strfind+0x7>
  80251b:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  80251e:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  80251f:	48 89 f8             	mov    %rdi,%rax
  802522:	c3                   	ret    
  802523:	48 89 f8             	mov    %rdi,%rax
  802526:	c3                   	ret    

0000000000802527 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  802527:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80252a:	48 89 f8             	mov    %rdi,%rax
  80252d:	48 f7 d8             	neg    %rax
  802530:	83 e0 07             	and    $0x7,%eax
  802533:	49 89 d1             	mov    %rdx,%r9
  802536:	49 29 c1             	sub    %rax,%r9
  802539:	78 32                	js     80256d <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80253b:	40 0f b6 c6          	movzbl %sil,%eax
  80253f:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  802546:	01 01 01 
  802549:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80254d:	40 f6 c7 07          	test   $0x7,%dil
  802551:	75 34                	jne    802587 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  802553:	4c 89 c9             	mov    %r9,%rcx
  802556:	48 c1 f9 03          	sar    $0x3,%rcx
  80255a:	74 08                	je     802564 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80255c:	fc                   	cld    
  80255d:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802560:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802564:	4d 85 c9             	test   %r9,%r9
  802567:	75 45                	jne    8025ae <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  802569:	4c 89 c0             	mov    %r8,%rax
  80256c:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  80256d:	48 85 d2             	test   %rdx,%rdx
  802570:	74 f7                	je     802569 <memset+0x42>
  802572:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  802575:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  802578:	48 83 c0 01          	add    $0x1,%rax
  80257c:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  802580:	48 39 c2             	cmp    %rax,%rdx
  802583:	75 f3                	jne    802578 <memset+0x51>
  802585:	eb e2                	jmp    802569 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  802587:	40 f6 c7 01          	test   $0x1,%dil
  80258b:	74 06                	je     802593 <memset+0x6c>
  80258d:	88 07                	mov    %al,(%rdi)
  80258f:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  802593:	40 f6 c7 02          	test   $0x2,%dil
  802597:	74 07                	je     8025a0 <memset+0x79>
  802599:	66 89 07             	mov    %ax,(%rdi)
  80259c:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025a0:	40 f6 c7 04          	test   $0x4,%dil
  8025a4:	74 ad                	je     802553 <memset+0x2c>
  8025a6:	89 07                	mov    %eax,(%rdi)
  8025a8:	48 83 c7 04          	add    $0x4,%rdi
  8025ac:	eb a5                	jmp    802553 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025ae:	41 f6 c1 04          	test   $0x4,%r9b
  8025b2:	74 06                	je     8025ba <memset+0x93>
  8025b4:	89 07                	mov    %eax,(%rdi)
  8025b6:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025ba:	41 f6 c1 02          	test   $0x2,%r9b
  8025be:	74 07                	je     8025c7 <memset+0xa0>
  8025c0:	66 89 07             	mov    %ax,(%rdi)
  8025c3:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8025c7:	41 f6 c1 01          	test   $0x1,%r9b
  8025cb:	74 9c                	je     802569 <memset+0x42>
  8025cd:	88 07                	mov    %al,(%rdi)
  8025cf:	eb 98                	jmp    802569 <memset+0x42>

00000000008025d1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8025d1:	48 89 f8             	mov    %rdi,%rax
  8025d4:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8025d7:	48 39 fe             	cmp    %rdi,%rsi
  8025da:	73 39                	jae    802615 <memmove+0x44>
  8025dc:	48 01 f2             	add    %rsi,%rdx
  8025df:	48 39 fa             	cmp    %rdi,%rdx
  8025e2:	76 31                	jbe    802615 <memmove+0x44>
        s += n;
        d += n;
  8025e4:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8025e7:	48 89 d6             	mov    %rdx,%rsi
  8025ea:	48 09 fe             	or     %rdi,%rsi
  8025ed:	48 09 ce             	or     %rcx,%rsi
  8025f0:	40 f6 c6 07          	test   $0x7,%sil
  8025f4:	75 12                	jne    802608 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8025f6:	48 83 ef 08          	sub    $0x8,%rdi
  8025fa:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8025fe:	48 c1 e9 03          	shr    $0x3,%rcx
  802602:	fd                   	std    
  802603:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  802606:	fc                   	cld    
  802607:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  802608:	48 83 ef 01          	sub    $0x1,%rdi
  80260c:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  802610:	fd                   	std    
  802611:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  802613:	eb f1                	jmp    802606 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802615:	48 89 f2             	mov    %rsi,%rdx
  802618:	48 09 c2             	or     %rax,%rdx
  80261b:	48 09 ca             	or     %rcx,%rdx
  80261e:	f6 c2 07             	test   $0x7,%dl
  802621:	75 0c                	jne    80262f <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  802623:	48 c1 e9 03          	shr    $0x3,%rcx
  802627:	48 89 c7             	mov    %rax,%rdi
  80262a:	fc                   	cld    
  80262b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80262e:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80262f:	48 89 c7             	mov    %rax,%rdi
  802632:	fc                   	cld    
  802633:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  802635:	c3                   	ret    

0000000000802636 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  802636:	55                   	push   %rbp
  802637:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80263a:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  802641:	00 00 00 
  802644:	ff d0                	call   *%rax
}
  802646:	5d                   	pop    %rbp
  802647:	c3                   	ret    

0000000000802648 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802648:	55                   	push   %rbp
  802649:	48 89 e5             	mov    %rsp,%rbp
  80264c:	41 57                	push   %r15
  80264e:	41 56                	push   %r14
  802650:	41 55                	push   %r13
  802652:	41 54                	push   %r12
  802654:	53                   	push   %rbx
  802655:	48 83 ec 08          	sub    $0x8,%rsp
  802659:	49 89 fe             	mov    %rdi,%r14
  80265c:	49 89 f7             	mov    %rsi,%r15
  80265f:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  802662:	48 89 f7             	mov    %rsi,%rdi
  802665:	48 b8 9d 23 80 00 00 	movabs $0x80239d,%rax
  80266c:	00 00 00 
  80266f:	ff d0                	call   *%rax
  802671:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  802674:	48 89 de             	mov    %rbx,%rsi
  802677:	4c 89 f7             	mov    %r14,%rdi
  80267a:	48 b8 b8 23 80 00 00 	movabs $0x8023b8,%rax
  802681:	00 00 00 
  802684:	ff d0                	call   *%rax
  802686:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  802689:	48 39 c3             	cmp    %rax,%rbx
  80268c:	74 36                	je     8026c4 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  80268e:	48 89 d8             	mov    %rbx,%rax
  802691:	4c 29 e8             	sub    %r13,%rax
  802694:	4c 39 e0             	cmp    %r12,%rax
  802697:	76 30                	jbe    8026c9 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  802699:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  80269e:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026a2:	4c 89 fe             	mov    %r15,%rsi
  8026a5:	48 b8 36 26 80 00 00 	movabs $0x802636,%rax
  8026ac:	00 00 00 
  8026af:	ff d0                	call   *%rax
    return dstlen + srclen;
  8026b1:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8026b5:	48 83 c4 08          	add    $0x8,%rsp
  8026b9:	5b                   	pop    %rbx
  8026ba:	41 5c                	pop    %r12
  8026bc:	41 5d                	pop    %r13
  8026be:	41 5e                	pop    %r14
  8026c0:	41 5f                	pop    %r15
  8026c2:	5d                   	pop    %rbp
  8026c3:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8026c4:	4c 01 e0             	add    %r12,%rax
  8026c7:	eb ec                	jmp    8026b5 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8026c9:	48 83 eb 01          	sub    $0x1,%rbx
  8026cd:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026d1:	48 89 da             	mov    %rbx,%rdx
  8026d4:	4c 89 fe             	mov    %r15,%rsi
  8026d7:	48 b8 36 26 80 00 00 	movabs $0x802636,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8026e3:	49 01 de             	add    %rbx,%r14
  8026e6:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8026eb:	eb c4                	jmp    8026b1 <strlcat+0x69>

00000000008026ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8026ed:	49 89 f0             	mov    %rsi,%r8
  8026f0:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8026f3:	48 85 d2             	test   %rdx,%rdx
  8026f6:	74 2a                	je     802722 <memcmp+0x35>
  8026f8:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8026fd:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  802701:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  802706:	38 ca                	cmp    %cl,%dl
  802708:	75 0f                	jne    802719 <memcmp+0x2c>
    while (n-- > 0) {
  80270a:	48 83 c0 01          	add    $0x1,%rax
  80270e:	48 39 c6             	cmp    %rax,%rsi
  802711:	75 ea                	jne    8026fd <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  802713:	b8 00 00 00 00       	mov    $0x0,%eax
  802718:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  802719:	0f b6 c2             	movzbl %dl,%eax
  80271c:	0f b6 c9             	movzbl %cl,%ecx
  80271f:	29 c8                	sub    %ecx,%eax
  802721:	c3                   	ret    
    return 0;
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802727:	c3                   	ret    

0000000000802728 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  802728:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80272c:	48 39 c7             	cmp    %rax,%rdi
  80272f:	73 0f                	jae    802740 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802731:	40 38 37             	cmp    %sil,(%rdi)
  802734:	74 0e                	je     802744 <memfind+0x1c>
    for (; src < end; src++) {
  802736:	48 83 c7 01          	add    $0x1,%rdi
  80273a:	48 39 f8             	cmp    %rdi,%rax
  80273d:	75 f2                	jne    802731 <memfind+0x9>
  80273f:	c3                   	ret    
  802740:	48 89 f8             	mov    %rdi,%rax
  802743:	c3                   	ret    
  802744:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802747:	c3                   	ret    

0000000000802748 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802748:	49 89 f2             	mov    %rsi,%r10
  80274b:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80274e:	0f b6 37             	movzbl (%rdi),%esi
  802751:	40 80 fe 20          	cmp    $0x20,%sil
  802755:	74 06                	je     80275d <strtol+0x15>
  802757:	40 80 fe 09          	cmp    $0x9,%sil
  80275b:	75 13                	jne    802770 <strtol+0x28>
  80275d:	48 83 c7 01          	add    $0x1,%rdi
  802761:	0f b6 37             	movzbl (%rdi),%esi
  802764:	40 80 fe 20          	cmp    $0x20,%sil
  802768:	74 f3                	je     80275d <strtol+0x15>
  80276a:	40 80 fe 09          	cmp    $0x9,%sil
  80276e:	74 ed                	je     80275d <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802770:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802773:	83 e0 fd             	and    $0xfffffffd,%eax
  802776:	3c 01                	cmp    $0x1,%al
  802778:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80277c:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  802783:	75 11                	jne    802796 <strtol+0x4e>
  802785:	80 3f 30             	cmpb   $0x30,(%rdi)
  802788:	74 16                	je     8027a0 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80278a:	45 85 c0             	test   %r8d,%r8d
  80278d:	b8 0a 00 00 00       	mov    $0xa,%eax
  802792:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  802796:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80279b:	4d 63 c8             	movslq %r8d,%r9
  80279e:	eb 38                	jmp    8027d8 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8027a0:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8027a4:	74 11                	je     8027b7 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8027a6:	45 85 c0             	test   %r8d,%r8d
  8027a9:	75 eb                	jne    802796 <strtol+0x4e>
        s++;
  8027ab:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8027af:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8027b5:	eb df                	jmp    802796 <strtol+0x4e>
        s += 2;
  8027b7:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8027bb:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8027c1:	eb d3                	jmp    802796 <strtol+0x4e>
            dig -= '0';
  8027c3:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8027c6:	0f b6 c8             	movzbl %al,%ecx
  8027c9:	44 39 c1             	cmp    %r8d,%ecx
  8027cc:	7d 1f                	jge    8027ed <strtol+0xa5>
        val = val * base + dig;
  8027ce:	49 0f af d1          	imul   %r9,%rdx
  8027d2:	0f b6 c0             	movzbl %al,%eax
  8027d5:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8027d8:	48 83 c7 01          	add    $0x1,%rdi
  8027dc:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8027e0:	3c 39                	cmp    $0x39,%al
  8027e2:	76 df                	jbe    8027c3 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8027e4:	3c 7b                	cmp    $0x7b,%al
  8027e6:	77 05                	ja     8027ed <strtol+0xa5>
            dig -= 'a' - 10;
  8027e8:	83 e8 57             	sub    $0x57,%eax
  8027eb:	eb d9                	jmp    8027c6 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8027ed:	4d 85 d2             	test   %r10,%r10
  8027f0:	74 03                	je     8027f5 <strtol+0xad>
  8027f2:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8027f5:	48 89 d0             	mov    %rdx,%rax
  8027f8:	48 f7 d8             	neg    %rax
  8027fb:	40 80 fe 2d          	cmp    $0x2d,%sil
  8027ff:	48 0f 44 d0          	cmove  %rax,%rdx
}
  802803:	48 89 d0             	mov    %rdx,%rax
  802806:	c3                   	ret    

0000000000802807 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802807:	55                   	push   %rbp
  802808:	48 89 e5             	mov    %rsp,%rbp
  80280b:	41 54                	push   %r12
  80280d:	53                   	push   %rbx
  80280e:	48 89 fb             	mov    %rdi,%rbx
  802811:	48 89 f7             	mov    %rsi,%rdi
  802814:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802817:	48 85 f6             	test   %rsi,%rsi
  80281a:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802821:	00 00 00 
  802824:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802828:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  80282d:	48 85 d2             	test   %rdx,%rdx
  802830:	74 02                	je     802834 <ipc_recv+0x2d>
  802832:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802834:	48 63 f6             	movslq %esi,%rsi
  802837:	48 b8 1c 05 80 00 00 	movabs $0x80051c,%rax
  80283e:	00 00 00 
  802841:	ff d0                	call   *%rax

    if (res < 0) {
  802843:	85 c0                	test   %eax,%eax
  802845:	78 45                	js     80288c <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802847:	48 85 db             	test   %rbx,%rbx
  80284a:	74 12                	je     80285e <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  80284c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802853:	00 00 00 
  802856:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80285c:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  80285e:	4d 85 e4             	test   %r12,%r12
  802861:	74 14                	je     802877 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802863:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80286a:	00 00 00 
  80286d:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802873:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802877:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80287e:	00 00 00 
  802881:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802887:	5b                   	pop    %rbx
  802888:	41 5c                	pop    %r12
  80288a:	5d                   	pop    %rbp
  80288b:	c3                   	ret    
        if (from_env_store)
  80288c:	48 85 db             	test   %rbx,%rbx
  80288f:	74 06                	je     802897 <ipc_recv+0x90>
            *from_env_store = 0;
  802891:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802897:	4d 85 e4             	test   %r12,%r12
  80289a:	74 eb                	je     802887 <ipc_recv+0x80>
            *perm_store = 0;
  80289c:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028a3:	00 
  8028a4:	eb e1                	jmp    802887 <ipc_recv+0x80>

00000000008028a6 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028a6:	55                   	push   %rbp
  8028a7:	48 89 e5             	mov    %rsp,%rbp
  8028aa:	41 57                	push   %r15
  8028ac:	41 56                	push   %r14
  8028ae:	41 55                	push   %r13
  8028b0:	41 54                	push   %r12
  8028b2:	53                   	push   %rbx
  8028b3:	48 83 ec 18          	sub    $0x18,%rsp
  8028b7:	41 89 fd             	mov    %edi,%r13d
  8028ba:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028bd:	48 89 d3             	mov    %rdx,%rbx
  8028c0:	49 89 cc             	mov    %rcx,%r12
  8028c3:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028c7:	48 85 d2             	test   %rdx,%rdx
  8028ca:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8028d1:	00 00 00 
  8028d4:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028d8:	49 be f0 04 80 00 00 	movabs $0x8004f0,%r14
  8028df:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  8028e2:	49 bf f3 01 80 00 00 	movabs $0x8001f3,%r15
  8028e9:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028ec:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8028ef:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  8028f3:	4c 89 e1             	mov    %r12,%rcx
  8028f6:	48 89 da             	mov    %rbx,%rdx
  8028f9:	44 89 ef             	mov    %r13d,%edi
  8028fc:	41 ff d6             	call   *%r14
  8028ff:	85 c0                	test   %eax,%eax
  802901:	79 37                	jns    80293a <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802903:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802906:	75 05                	jne    80290d <ipc_send+0x67>
          sys_yield();
  802908:	41 ff d7             	call   *%r15
  80290b:	eb df                	jmp    8028ec <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  80290d:	89 c1                	mov    %eax,%ecx
  80290f:	48 ba 3f 30 80 00 00 	movabs $0x80303f,%rdx
  802916:	00 00 00 
  802919:	be 46 00 00 00       	mov    $0x46,%esi
  80291e:	48 bf 52 30 80 00 00 	movabs $0x803052,%rdi
  802925:	00 00 00 
  802928:	b8 00 00 00 00       	mov    $0x0,%eax
  80292d:	49 b8 45 19 80 00 00 	movabs $0x801945,%r8
  802934:	00 00 00 
  802937:	41 ff d0             	call   *%r8
      }
}
  80293a:	48 83 c4 18          	add    $0x18,%rsp
  80293e:	5b                   	pop    %rbx
  80293f:	41 5c                	pop    %r12
  802941:	41 5d                	pop    %r13
  802943:	41 5e                	pop    %r14
  802945:	41 5f                	pop    %r15
  802947:	5d                   	pop    %rbp
  802948:	c3                   	ret    

0000000000802949 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802949:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80294e:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802955:	00 00 00 
  802958:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80295c:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802960:	48 c1 e2 04          	shl    $0x4,%rdx
  802964:	48 01 ca             	add    %rcx,%rdx
  802967:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  80296d:	39 fa                	cmp    %edi,%edx
  80296f:	74 12                	je     802983 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802971:	48 83 c0 01          	add    $0x1,%rax
  802975:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80297b:	75 db                	jne    802958 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  80297d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802982:	c3                   	ret    
            return envs[i].env_id;
  802983:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802987:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80298b:	48 c1 e0 04          	shl    $0x4,%rax
  80298f:	48 89 c2             	mov    %rax,%rdx
  802992:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802999:	00 00 00 
  80299c:	48 01 d0             	add    %rdx,%rax
  80299f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029a5:	c3                   	ret    
  8029a6:	66 90                	xchg   %ax,%ax

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
  802cc0:	8f 1c 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ........."......
  802cd0:	d3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802ce0:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802cf0:	e3 22 80 00 00 00 00 00 a9 1c 80 00 00 00 00 00     ."..............
  802d00:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802d10:	a0 1c 80 00 00 00 00 00 16 1d 80 00 00 00 00 00     ................
  802d20:	e3 22 80 00 00 00 00 00 a0 1c 80 00 00 00 00 00     ."..............
  802d30:	e3 1c 80 00 00 00 00 00 e3 1c 80 00 00 00 00 00     ................
  802d40:	e3 1c 80 00 00 00 00 00 e3 1c 80 00 00 00 00 00     ................
  802d50:	e3 1c 80 00 00 00 00 00 e3 1c 80 00 00 00 00 00     ................
  802d60:	e3 1c 80 00 00 00 00 00 e3 1c 80 00 00 00 00 00     ................
  802d70:	e3 1c 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ........."......
  802d80:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802d90:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802da0:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802db0:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802dc0:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802dd0:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802de0:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802df0:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802e00:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802e10:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802e20:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802e30:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802e40:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802e50:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802e60:	e3 22 80 00 00 00 00 00 08 22 80 00 00 00 00 00     ."......."......
  802e70:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802e80:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802e90:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802ea0:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802eb0:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802ec0:	34 1d 80 00 00 00 00 00 2a 1f 80 00 00 00 00 00     4.......*.......
  802ed0:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802ee0:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802ef0:	62 1d 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     b........"......
  802f00:	e3 22 80 00 00 00 00 00 29 1d 80 00 00 00 00 00     ."......).......
  802f10:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802f20:	ca 20 80 00 00 00 00 00 92 21 80 00 00 00 00 00     . .......!......
  802f30:	e3 22 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ."......."......
  802f40:	fa 1d 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ........."......
  802f50:	fc 1f 80 00 00 00 00 00 e3 22 80 00 00 00 00 00     ........."......
  802f60:	e3 22 80 00 00 00 00 00 08 22 80 00 00 00 00 00     ."......."......
  802f70:	e3 22 80 00 00 00 00 00 98 1c 80 00 00 00 00 00     ."..............

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
