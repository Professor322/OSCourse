
obj/user/badsegment:     file format elf64-x86-64


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
  80001e:	e8 09 00 00 00       	call   80002c <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv) {
    /* Try to load the kernel's TSS selector into the DS register. */
    asm volatile("movw $0x38,%ax; movw %ax,%ds");
  800025:	66 b8 38 00          	mov    $0x38,%ax
  800029:	8e d8                	mov    %eax,%ds
}
  80002b:	c3                   	ret    

000000000080002c <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80002c:	55                   	push   %rbp
  80002d:	48 89 e5             	mov    %rsp,%rbp
  800030:	41 56                	push   %r14
  800032:	41 55                	push   %r13
  800034:	41 54                	push   %r12
  800036:	53                   	push   %rbx
  800037:	41 89 fd             	mov    %edi,%r13d
  80003a:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80003d:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800044:	00 00 00 
  800047:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80004e:	00 00 00 
  800051:	48 39 c2             	cmp    %rax,%rdx
  800054:	73 17                	jae    80006d <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800056:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800059:	49 89 c4             	mov    %rax,%r12
  80005c:	48 83 c3 08          	add    $0x8,%rbx
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	ff 53 f8             	call   *-0x8(%rbx)
  800068:	4c 39 e3             	cmp    %r12,%rbx
  80006b:	72 ef                	jb     80005c <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80006d:	48 b8 c6 01 80 00 00 	movabs $0x8001c6,%rax
  800074:	00 00 00 
  800077:	ff d0                	call   *%rax
  800079:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007e:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800082:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800086:	48 c1 e0 04          	shl    $0x4,%rax
  80008a:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  800091:	00 00 00 
  800094:	48 01 d0             	add    %rdx,%rax
  800097:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80009e:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000a1:	45 85 ed             	test   %r13d,%r13d
  8000a4:	7e 0d                	jle    8000b3 <libmain+0x87>
  8000a6:	49 8b 06             	mov    (%r14),%rax
  8000a9:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000b0:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000b3:	4c 89 f6             	mov    %r14,%rsi
  8000b6:	44 89 ef             	mov    %r13d,%edi
  8000b9:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000c5:	48 b8 da 00 80 00 00 	movabs $0x8000da,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	call   *%rax
#endif
}
  8000d1:	5b                   	pop    %rbx
  8000d2:	41 5c                	pop    %r12
  8000d4:	41 5d                	pop    %r13
  8000d6:	41 5e                	pop    %r14
  8000d8:	5d                   	pop    %rbp
  8000d9:	c3                   	ret    

00000000008000da <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000da:	55                   	push   %rbp
  8000db:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000de:	48 b8 16 08 80 00 00 	movabs $0x800816,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8000ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ef:	48 b8 5b 01 80 00 00 	movabs $0x80015b,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	call   *%rax
}
  8000fb:	5d                   	pop    %rbp
  8000fc:	c3                   	ret    

00000000008000fd <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8000fd:	55                   	push   %rbp
  8000fe:	48 89 e5             	mov    %rsp,%rbp
  800101:	53                   	push   %rbx
  800102:	48 89 fa             	mov    %rdi,%rdx
  800105:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800108:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80010d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800112:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800117:	be 00 00 00 00       	mov    $0x0,%esi
  80011c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800122:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800124:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800128:	c9                   	leave  
  800129:	c3                   	ret    

000000000080012a <sys_cgetc>:

int
sys_cgetc(void) {
  80012a:	55                   	push   %rbp
  80012b:	48 89 e5             	mov    %rsp,%rbp
  80012e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80012f:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800134:	ba 00 00 00 00       	mov    $0x0,%edx
  800139:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80013e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800143:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800148:	be 00 00 00 00       	mov    $0x0,%esi
  80014d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800153:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800155:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800159:	c9                   	leave  
  80015a:	c3                   	ret    

000000000080015b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80015b:	55                   	push   %rbp
  80015c:	48 89 e5             	mov    %rsp,%rbp
  80015f:	53                   	push   %rbx
  800160:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800164:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800167:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80016c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800171:	bb 00 00 00 00       	mov    $0x0,%ebx
  800176:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80017b:	be 00 00 00 00       	mov    $0x0,%esi
  800180:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800186:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800188:	48 85 c0             	test   %rax,%rax
  80018b:	7f 06                	jg     800193 <sys_env_destroy+0x38>
}
  80018d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800191:	c9                   	leave  
  800192:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800193:	49 89 c0             	mov    %rax,%r8
  800196:	b9 03 00 00 00       	mov    $0x3,%ecx
  80019b:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  8001a2:	00 00 00 
  8001a5:	be 26 00 00 00       	mov    $0x26,%esi
  8001aa:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  8001b1:	00 00 00 
  8001b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b9:	49 b9 49 19 80 00 00 	movabs $0x801949,%r9
  8001c0:	00 00 00 
  8001c3:	41 ff d1             	call   *%r9

00000000008001c6 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001c6:	55                   	push   %rbp
  8001c7:	48 89 e5             	mov    %rsp,%rbp
  8001ca:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001cb:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8001d5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001df:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001e4:	be 00 00 00 00       	mov    $0x0,%esi
  8001e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001ef:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8001f1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    

00000000008001f7 <sys_yield>:

void
sys_yield(void) {
  8001f7:	55                   	push   %rbp
  8001f8:	48 89 e5             	mov    %rsp,%rbp
  8001fb:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001fc:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800201:	ba 00 00 00 00       	mov    $0x0,%edx
  800206:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80020b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800210:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800215:	be 00 00 00 00       	mov    $0x0,%esi
  80021a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800220:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800222:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800226:	c9                   	leave  
  800227:	c3                   	ret    

0000000000800228 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  800228:	55                   	push   %rbp
  800229:	48 89 e5             	mov    %rsp,%rbp
  80022c:	53                   	push   %rbx
  80022d:	48 89 fa             	mov    %rdi,%rdx
  800230:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800233:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800238:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80023f:	00 00 00 
  800242:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800247:	be 00 00 00 00       	mov    $0x0,%esi
  80024c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800252:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800254:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800258:	c9                   	leave  
  800259:	c3                   	ret    

000000000080025a <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80025a:	55                   	push   %rbp
  80025b:	48 89 e5             	mov    %rsp,%rbp
  80025e:	53                   	push   %rbx
  80025f:	49 89 f8             	mov    %rdi,%r8
  800262:	48 89 d3             	mov    %rdx,%rbx
  800265:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  800268:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80026d:	4c 89 c2             	mov    %r8,%rdx
  800270:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800273:	be 00 00 00 00       	mov    $0x0,%esi
  800278:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80027e:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  800280:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800284:	c9                   	leave  
  800285:	c3                   	ret    

0000000000800286 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  800286:	55                   	push   %rbp
  800287:	48 89 e5             	mov    %rsp,%rbp
  80028a:	53                   	push   %rbx
  80028b:	48 83 ec 08          	sub    $0x8,%rsp
  80028f:	89 f8                	mov    %edi,%eax
  800291:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  800294:	48 63 f9             	movslq %ecx,%rdi
  800297:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80029a:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80029f:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002a2:	be 00 00 00 00       	mov    $0x0,%esi
  8002a7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002ad:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002af:	48 85 c0             	test   %rax,%rax
  8002b2:	7f 06                	jg     8002ba <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002b4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002b8:	c9                   	leave  
  8002b9:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002ba:	49 89 c0             	mov    %rax,%r8
  8002bd:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002c2:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  8002c9:	00 00 00 
  8002cc:	be 26 00 00 00       	mov    $0x26,%esi
  8002d1:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  8002d8:	00 00 00 
  8002db:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e0:	49 b9 49 19 80 00 00 	movabs $0x801949,%r9
  8002e7:	00 00 00 
  8002ea:	41 ff d1             	call   *%r9

00000000008002ed <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8002ed:	55                   	push   %rbp
  8002ee:	48 89 e5             	mov    %rsp,%rbp
  8002f1:	53                   	push   %rbx
  8002f2:	48 83 ec 08          	sub    $0x8,%rsp
  8002f6:	89 f8                	mov    %edi,%eax
  8002f8:	49 89 f2             	mov    %rsi,%r10
  8002fb:	48 89 cf             	mov    %rcx,%rdi
  8002fe:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800301:	48 63 da             	movslq %edx,%rbx
  800304:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800307:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80030c:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80030f:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800312:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800314:	48 85 c0             	test   %rax,%rax
  800317:	7f 06                	jg     80031f <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  800319:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80031f:	49 89 c0             	mov    %rax,%r8
  800322:	b9 05 00 00 00       	mov    $0x5,%ecx
  800327:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  80032e:	00 00 00 
  800331:	be 26 00 00 00       	mov    $0x26,%esi
  800336:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  80033d:	00 00 00 
  800340:	b8 00 00 00 00       	mov    $0x0,%eax
  800345:	49 b9 49 19 80 00 00 	movabs $0x801949,%r9
  80034c:	00 00 00 
  80034f:	41 ff d1             	call   *%r9

0000000000800352 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  800352:	55                   	push   %rbp
  800353:	48 89 e5             	mov    %rsp,%rbp
  800356:	53                   	push   %rbx
  800357:	48 83 ec 08          	sub    $0x8,%rsp
  80035b:	48 89 f1             	mov    %rsi,%rcx
  80035e:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  800361:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800364:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800369:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80036e:	be 00 00 00 00       	mov    $0x0,%esi
  800373:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800379:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80037b:	48 85 c0             	test   %rax,%rax
  80037e:	7f 06                	jg     800386 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  800380:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800384:	c9                   	leave  
  800385:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800386:	49 89 c0             	mov    %rax,%r8
  800389:	b9 06 00 00 00       	mov    $0x6,%ecx
  80038e:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  800395:	00 00 00 
  800398:	be 26 00 00 00       	mov    $0x26,%esi
  80039d:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  8003a4:	00 00 00 
  8003a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ac:	49 b9 49 19 80 00 00 	movabs $0x801949,%r9
  8003b3:	00 00 00 
  8003b6:	41 ff d1             	call   *%r9

00000000008003b9 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8003b9:	55                   	push   %rbp
  8003ba:	48 89 e5             	mov    %rsp,%rbp
  8003bd:	53                   	push   %rbx
  8003be:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8003c2:	48 63 ce             	movslq %esi,%rcx
  8003c5:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8003c8:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8003cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003d7:	be 00 00 00 00       	mov    $0x0,%esi
  8003dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003e2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003e4:	48 85 c0             	test   %rax,%rax
  8003e7:	7f 06                	jg     8003ef <sys_env_set_status+0x36>
}
  8003e9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003ef:	49 89 c0             	mov    %rax,%r8
  8003f2:	b9 09 00 00 00       	mov    $0x9,%ecx
  8003f7:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  8003fe:	00 00 00 
  800401:	be 26 00 00 00       	mov    $0x26,%esi
  800406:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  80040d:	00 00 00 
  800410:	b8 00 00 00 00       	mov    $0x0,%eax
  800415:	49 b9 49 19 80 00 00 	movabs $0x801949,%r9
  80041c:	00 00 00 
  80041f:	41 ff d1             	call   *%r9

0000000000800422 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  800422:	55                   	push   %rbp
  800423:	48 89 e5             	mov    %rsp,%rbp
  800426:	53                   	push   %rbx
  800427:	48 83 ec 08          	sub    $0x8,%rsp
  80042b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80042e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800431:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800436:	bb 00 00 00 00       	mov    $0x0,%ebx
  80043b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800440:	be 00 00 00 00       	mov    $0x0,%esi
  800445:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80044b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80044d:	48 85 c0             	test   %rax,%rax
  800450:	7f 06                	jg     800458 <sys_env_set_trapframe+0x36>
}
  800452:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800456:	c9                   	leave  
  800457:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800458:	49 89 c0             	mov    %rax,%r8
  80045b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800460:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  800467:	00 00 00 
  80046a:	be 26 00 00 00       	mov    $0x26,%esi
  80046f:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  800476:	00 00 00 
  800479:	b8 00 00 00 00       	mov    $0x0,%eax
  80047e:	49 b9 49 19 80 00 00 	movabs $0x801949,%r9
  800485:	00 00 00 
  800488:	41 ff d1             	call   *%r9

000000000080048b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80048b:	55                   	push   %rbp
  80048c:	48 89 e5             	mov    %rsp,%rbp
  80048f:	53                   	push   %rbx
  800490:	48 83 ec 08          	sub    $0x8,%rsp
  800494:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  800497:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80049a:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80049f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004a4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004a9:	be 00 00 00 00       	mov    $0x0,%esi
  8004ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004b4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004b6:	48 85 c0             	test   %rax,%rax
  8004b9:	7f 06                	jg     8004c1 <sys_env_set_pgfault_upcall+0x36>
}
  8004bb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004bf:	c9                   	leave  
  8004c0:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004c1:	49 89 c0             	mov    %rax,%r8
  8004c4:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8004c9:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  8004d0:	00 00 00 
  8004d3:	be 26 00 00 00       	mov    $0x26,%esi
  8004d8:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  8004df:	00 00 00 
  8004e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e7:	49 b9 49 19 80 00 00 	movabs $0x801949,%r9
  8004ee:	00 00 00 
  8004f1:	41 ff d1             	call   *%r9

00000000008004f4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8004f4:	55                   	push   %rbp
  8004f5:	48 89 e5             	mov    %rsp,%rbp
  8004f8:	53                   	push   %rbx
  8004f9:	89 f8                	mov    %edi,%eax
  8004fb:	49 89 f1             	mov    %rsi,%r9
  8004fe:	48 89 d3             	mov    %rdx,%rbx
  800501:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  800504:	49 63 f0             	movslq %r8d,%rsi
  800507:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80050a:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80050f:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800512:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800518:	cd 30                	int    $0x30
}
  80051a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80051e:	c9                   	leave  
  80051f:	c3                   	ret    

0000000000800520 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  800520:	55                   	push   %rbp
  800521:	48 89 e5             	mov    %rsp,%rbp
  800524:	53                   	push   %rbx
  800525:	48 83 ec 08          	sub    $0x8,%rsp
  800529:	48 89 fa             	mov    %rdi,%rdx
  80052c:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80052f:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800534:	bb 00 00 00 00       	mov    $0x0,%ebx
  800539:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80053e:	be 00 00 00 00       	mov    $0x0,%esi
  800543:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800549:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80054b:	48 85 c0             	test   %rax,%rax
  80054e:	7f 06                	jg     800556 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800550:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800554:	c9                   	leave  
  800555:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800556:	49 89 c0             	mov    %rax,%r8
  800559:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80055e:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  800565:	00 00 00 
  800568:	be 26 00 00 00       	mov    $0x26,%esi
  80056d:	48 bf df 29 80 00 00 	movabs $0x8029df,%rdi
  800574:	00 00 00 
  800577:	b8 00 00 00 00       	mov    $0x0,%eax
  80057c:	49 b9 49 19 80 00 00 	movabs $0x801949,%r9
  800583:	00 00 00 
  800586:	41 ff d1             	call   *%r9

0000000000800589 <sys_gettime>:

int
sys_gettime(void) {
  800589:	55                   	push   %rbp
  80058a:	48 89 e5             	mov    %rsp,%rbp
  80058d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80058e:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800593:	ba 00 00 00 00       	mov    $0x0,%edx
  800598:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80059d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005a2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005a7:	be 00 00 00 00       	mov    $0x0,%esi
  8005ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005b2:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8005b4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005b8:	c9                   	leave  
  8005b9:	c3                   	ret    

00000000008005ba <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8005ba:	55                   	push   %rbp
  8005bb:	48 89 e5             	mov    %rsp,%rbp
  8005be:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005bf:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005d3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005d8:	be 00 00 00 00       	mov    $0x0,%esi
  8005dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005e3:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8005e5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005e9:	c9                   	leave  
  8005ea:	c3                   	ret    

00000000008005eb <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8005eb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8005f2:	ff ff ff 
  8005f5:	48 01 f8             	add    %rdi,%rax
  8005f8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8005fc:	c3                   	ret    

00000000008005fd <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8005fd:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800604:	ff ff ff 
  800607:	48 01 f8             	add    %rdi,%rax
  80060a:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80060e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800614:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800618:	c3                   	ret    

0000000000800619 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  800619:	55                   	push   %rbp
  80061a:	48 89 e5             	mov    %rsp,%rbp
  80061d:	41 57                	push   %r15
  80061f:	41 56                	push   %r14
  800621:	41 55                	push   %r13
  800623:	41 54                	push   %r12
  800625:	53                   	push   %rbx
  800626:	48 83 ec 08          	sub    $0x8,%rsp
  80062a:	49 89 ff             	mov    %rdi,%r15
  80062d:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  800632:	49 bc c7 15 80 00 00 	movabs $0x8015c7,%r12
  800639:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80063c:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  800642:	48 89 df             	mov    %rbx,%rdi
  800645:	41 ff d4             	call   *%r12
  800648:	83 e0 04             	and    $0x4,%eax
  80064b:	74 1a                	je     800667 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  80064d:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  800654:	4c 39 f3             	cmp    %r14,%rbx
  800657:	75 e9                	jne    800642 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  800659:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  800660:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  800665:	eb 03                	jmp    80066a <fd_alloc+0x51>
            *fd_store = fd;
  800667:	49 89 1f             	mov    %rbx,(%r15)
}
  80066a:	48 83 c4 08          	add    $0x8,%rsp
  80066e:	5b                   	pop    %rbx
  80066f:	41 5c                	pop    %r12
  800671:	41 5d                	pop    %r13
  800673:	41 5e                	pop    %r14
  800675:	41 5f                	pop    %r15
  800677:	5d                   	pop    %rbp
  800678:	c3                   	ret    

0000000000800679 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  800679:	83 ff 1f             	cmp    $0x1f,%edi
  80067c:	77 39                	ja     8006b7 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80067e:	55                   	push   %rbp
  80067f:	48 89 e5             	mov    %rsp,%rbp
  800682:	41 54                	push   %r12
  800684:	53                   	push   %rbx
  800685:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  800688:	48 63 df             	movslq %edi,%rbx
  80068b:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  800692:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800696:	48 89 df             	mov    %rbx,%rdi
  800699:	48 b8 c7 15 80 00 00 	movabs $0x8015c7,%rax
  8006a0:	00 00 00 
  8006a3:	ff d0                	call   *%rax
  8006a5:	a8 04                	test   $0x4,%al
  8006a7:	74 14                	je     8006bd <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8006a9:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8006ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006b2:	5b                   	pop    %rbx
  8006b3:	41 5c                	pop    %r12
  8006b5:	5d                   	pop    %rbp
  8006b6:	c3                   	ret    
        return -E_INVAL;
  8006b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006bc:	c3                   	ret    
        return -E_INVAL;
  8006bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006c2:	eb ee                	jmp    8006b2 <fd_lookup+0x39>

00000000008006c4 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8006c4:	55                   	push   %rbp
  8006c5:	48 89 e5             	mov    %rsp,%rbp
  8006c8:	53                   	push   %rbx
  8006c9:	48 83 ec 08          	sub    $0x8,%rsp
  8006cd:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8006d0:	48 ba 80 2a 80 00 00 	movabs $0x802a80,%rdx
  8006d7:	00 00 00 
  8006da:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8006e1:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8006e4:	39 38                	cmp    %edi,(%rax)
  8006e6:	74 4b                	je     800733 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8006e8:	48 83 c2 08          	add    $0x8,%rdx
  8006ec:	48 8b 02             	mov    (%rdx),%rax
  8006ef:	48 85 c0             	test   %rax,%rax
  8006f2:	75 f0                	jne    8006e4 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8006f4:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8006fb:	00 00 00 
  8006fe:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800704:	89 fa                	mov    %edi,%edx
  800706:	48 bf f0 29 80 00 00 	movabs $0x8029f0,%rdi
  80070d:	00 00 00 
  800710:	b8 00 00 00 00       	mov    $0x0,%eax
  800715:	48 b9 99 1a 80 00 00 	movabs $0x801a99,%rcx
  80071c:	00 00 00 
  80071f:	ff d1                	call   *%rcx
    *dev = 0;
  800721:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  800728:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80072d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800731:	c9                   	leave  
  800732:	c3                   	ret    
            *dev = devtab[i];
  800733:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  800736:	b8 00 00 00 00       	mov    $0x0,%eax
  80073b:	eb f0                	jmp    80072d <dev_lookup+0x69>

000000000080073d <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80073d:	55                   	push   %rbp
  80073e:	48 89 e5             	mov    %rsp,%rbp
  800741:	41 55                	push   %r13
  800743:	41 54                	push   %r12
  800745:	53                   	push   %rbx
  800746:	48 83 ec 18          	sub    $0x18,%rsp
  80074a:	49 89 fc             	mov    %rdi,%r12
  80074d:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800750:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  800757:	ff ff ff 
  80075a:	4c 01 e7             	add    %r12,%rdi
  80075d:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  800761:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800765:	48 b8 79 06 80 00 00 	movabs $0x800679,%rax
  80076c:	00 00 00 
  80076f:	ff d0                	call   *%rax
  800771:	89 c3                	mov    %eax,%ebx
  800773:	85 c0                	test   %eax,%eax
  800775:	78 06                	js     80077d <fd_close+0x40>
  800777:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  80077b:	74 18                	je     800795 <fd_close+0x58>
        return (must_exist ? res : 0);
  80077d:	45 84 ed             	test   %r13b,%r13b
  800780:	b8 00 00 00 00       	mov    $0x0,%eax
  800785:	0f 44 d8             	cmove  %eax,%ebx
}
  800788:	89 d8                	mov    %ebx,%eax
  80078a:	48 83 c4 18          	add    $0x18,%rsp
  80078e:	5b                   	pop    %rbx
  80078f:	41 5c                	pop    %r12
  800791:	41 5d                	pop    %r13
  800793:	5d                   	pop    %rbp
  800794:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800795:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800799:	41 8b 3c 24          	mov    (%r12),%edi
  80079d:	48 b8 c4 06 80 00 00 	movabs $0x8006c4,%rax
  8007a4:	00 00 00 
  8007a7:	ff d0                	call   *%rax
  8007a9:	89 c3                	mov    %eax,%ebx
  8007ab:	85 c0                	test   %eax,%eax
  8007ad:	78 19                	js     8007c8 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8007af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8007b3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007bc:	48 85 c0             	test   %rax,%rax
  8007bf:	74 07                	je     8007c8 <fd_close+0x8b>
  8007c1:	4c 89 e7             	mov    %r12,%rdi
  8007c4:	ff d0                	call   *%rax
  8007c6:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8007c8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8007cd:	4c 89 e6             	mov    %r12,%rsi
  8007d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8007d5:	48 b8 52 03 80 00 00 	movabs $0x800352,%rax
  8007dc:	00 00 00 
  8007df:	ff d0                	call   *%rax
    return res;
  8007e1:	eb a5                	jmp    800788 <fd_close+0x4b>

00000000008007e3 <close>:

int
close(int fdnum) {
  8007e3:	55                   	push   %rbp
  8007e4:	48 89 e5             	mov    %rsp,%rbp
  8007e7:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8007eb:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8007ef:	48 b8 79 06 80 00 00 	movabs $0x800679,%rax
  8007f6:	00 00 00 
  8007f9:	ff d0                	call   *%rax
    if (res < 0) return res;
  8007fb:	85 c0                	test   %eax,%eax
  8007fd:	78 15                	js     800814 <close+0x31>

    return fd_close(fd, 1);
  8007ff:	be 01 00 00 00       	mov    $0x1,%esi
  800804:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800808:	48 b8 3d 07 80 00 00 	movabs $0x80073d,%rax
  80080f:	00 00 00 
  800812:	ff d0                	call   *%rax
}
  800814:	c9                   	leave  
  800815:	c3                   	ret    

0000000000800816 <close_all>:

void
close_all(void) {
  800816:	55                   	push   %rbp
  800817:	48 89 e5             	mov    %rsp,%rbp
  80081a:	41 54                	push   %r12
  80081c:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80081d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800822:	49 bc e3 07 80 00 00 	movabs $0x8007e3,%r12
  800829:	00 00 00 
  80082c:	89 df                	mov    %ebx,%edi
  80082e:	41 ff d4             	call   *%r12
  800831:	83 c3 01             	add    $0x1,%ebx
  800834:	83 fb 20             	cmp    $0x20,%ebx
  800837:	75 f3                	jne    80082c <close_all+0x16>
}
  800839:	5b                   	pop    %rbx
  80083a:	41 5c                	pop    %r12
  80083c:	5d                   	pop    %rbp
  80083d:	c3                   	ret    

000000000080083e <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80083e:	55                   	push   %rbp
  80083f:	48 89 e5             	mov    %rsp,%rbp
  800842:	41 56                	push   %r14
  800844:	41 55                	push   %r13
  800846:	41 54                	push   %r12
  800848:	53                   	push   %rbx
  800849:	48 83 ec 10          	sub    $0x10,%rsp
  80084d:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  800850:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800854:	48 b8 79 06 80 00 00 	movabs $0x800679,%rax
  80085b:	00 00 00 
  80085e:	ff d0                	call   *%rax
  800860:	89 c3                	mov    %eax,%ebx
  800862:	85 c0                	test   %eax,%eax
  800864:	0f 88 b7 00 00 00    	js     800921 <dup+0xe3>
    close(newfdnum);
  80086a:	44 89 e7             	mov    %r12d,%edi
  80086d:	48 b8 e3 07 80 00 00 	movabs $0x8007e3,%rax
  800874:	00 00 00 
  800877:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800879:	4d 63 ec             	movslq %r12d,%r13
  80087c:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  800883:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  800887:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80088b:	49 be fd 05 80 00 00 	movabs $0x8005fd,%r14
  800892:	00 00 00 
  800895:	41 ff d6             	call   *%r14
  800898:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  80089b:	4c 89 ef             	mov    %r13,%rdi
  80089e:	41 ff d6             	call   *%r14
  8008a1:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8008a4:	48 89 df             	mov    %rbx,%rdi
  8008a7:	48 b8 c7 15 80 00 00 	movabs $0x8015c7,%rax
  8008ae:	00 00 00 
  8008b1:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8008b3:	a8 04                	test   $0x4,%al
  8008b5:	74 2b                	je     8008e2 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8008b7:	41 89 c1             	mov    %eax,%r9d
  8008ba:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8008c0:	4c 89 f1             	mov    %r14,%rcx
  8008c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c8:	48 89 de             	mov    %rbx,%rsi
  8008cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8008d0:	48 b8 ed 02 80 00 00 	movabs $0x8002ed,%rax
  8008d7:	00 00 00 
  8008da:	ff d0                	call   *%rax
  8008dc:	89 c3                	mov    %eax,%ebx
  8008de:	85 c0                	test   %eax,%eax
  8008e0:	78 4e                	js     800930 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8008e2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8008e6:	48 b8 c7 15 80 00 00 	movabs $0x8015c7,%rax
  8008ed:	00 00 00 
  8008f0:	ff d0                	call   *%rax
  8008f2:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8008f5:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8008fb:	4c 89 e9             	mov    %r13,%rcx
  8008fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800903:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800907:	bf 00 00 00 00       	mov    $0x0,%edi
  80090c:	48 b8 ed 02 80 00 00 	movabs $0x8002ed,%rax
  800913:	00 00 00 
  800916:	ff d0                	call   *%rax
  800918:	89 c3                	mov    %eax,%ebx
  80091a:	85 c0                	test   %eax,%eax
  80091c:	78 12                	js     800930 <dup+0xf2>

    return newfdnum;
  80091e:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  800921:	89 d8                	mov    %ebx,%eax
  800923:	48 83 c4 10          	add    $0x10,%rsp
  800927:	5b                   	pop    %rbx
  800928:	41 5c                	pop    %r12
  80092a:	41 5d                	pop    %r13
  80092c:	41 5e                	pop    %r14
  80092e:	5d                   	pop    %rbp
  80092f:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  800930:	ba 00 10 00 00       	mov    $0x1000,%edx
  800935:	4c 89 ee             	mov    %r13,%rsi
  800938:	bf 00 00 00 00       	mov    $0x0,%edi
  80093d:	49 bc 52 03 80 00 00 	movabs $0x800352,%r12
  800944:	00 00 00 
  800947:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80094a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80094f:	4c 89 f6             	mov    %r14,%rsi
  800952:	bf 00 00 00 00       	mov    $0x0,%edi
  800957:	41 ff d4             	call   *%r12
    return res;
  80095a:	eb c5                	jmp    800921 <dup+0xe3>

000000000080095c <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  80095c:	55                   	push   %rbp
  80095d:	48 89 e5             	mov    %rsp,%rbp
  800960:	41 55                	push   %r13
  800962:	41 54                	push   %r12
  800964:	53                   	push   %rbx
  800965:	48 83 ec 18          	sub    $0x18,%rsp
  800969:	89 fb                	mov    %edi,%ebx
  80096b:	49 89 f4             	mov    %rsi,%r12
  80096e:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800971:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800975:	48 b8 79 06 80 00 00 	movabs $0x800679,%rax
  80097c:	00 00 00 
  80097f:	ff d0                	call   *%rax
  800981:	85 c0                	test   %eax,%eax
  800983:	78 49                	js     8009ce <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800985:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800989:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80098d:	8b 38                	mov    (%rax),%edi
  80098f:	48 b8 c4 06 80 00 00 	movabs $0x8006c4,%rax
  800996:	00 00 00 
  800999:	ff d0                	call   *%rax
  80099b:	85 c0                	test   %eax,%eax
  80099d:	78 33                	js     8009d2 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80099f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8009a3:	8b 47 08             	mov    0x8(%rdi),%eax
  8009a6:	83 e0 03             	and    $0x3,%eax
  8009a9:	83 f8 01             	cmp    $0x1,%eax
  8009ac:	74 28                	je     8009d6 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8009ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009b2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8009b6:	48 85 c0             	test   %rax,%rax
  8009b9:	74 51                	je     800a0c <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8009bb:	4c 89 ea             	mov    %r13,%rdx
  8009be:	4c 89 e6             	mov    %r12,%rsi
  8009c1:	ff d0                	call   *%rax
}
  8009c3:	48 83 c4 18          	add    $0x18,%rsp
  8009c7:	5b                   	pop    %rbx
  8009c8:	41 5c                	pop    %r12
  8009ca:	41 5d                	pop    %r13
  8009cc:	5d                   	pop    %rbp
  8009cd:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8009ce:	48 98                	cltq   
  8009d0:	eb f1                	jmp    8009c3 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8009d2:	48 98                	cltq   
  8009d4:	eb ed                	jmp    8009c3 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8009d6:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8009dd:	00 00 00 
  8009e0:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8009e6:	89 da                	mov    %ebx,%edx
  8009e8:	48 bf 31 2a 80 00 00 	movabs $0x802a31,%rdi
  8009ef:	00 00 00 
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f7:	48 b9 99 1a 80 00 00 	movabs $0x801a99,%rcx
  8009fe:	00 00 00 
  800a01:	ff d1                	call   *%rcx
        return -E_INVAL;
  800a03:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800a0a:	eb b7                	jmp    8009c3 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800a0c:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800a13:	eb ae                	jmp    8009c3 <read+0x67>

0000000000800a15 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800a15:	55                   	push   %rbp
  800a16:	48 89 e5             	mov    %rsp,%rbp
  800a19:	41 57                	push   %r15
  800a1b:	41 56                	push   %r14
  800a1d:	41 55                	push   %r13
  800a1f:	41 54                	push   %r12
  800a21:	53                   	push   %rbx
  800a22:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800a26:	48 85 d2             	test   %rdx,%rdx
  800a29:	74 54                	je     800a7f <readn+0x6a>
  800a2b:	41 89 fd             	mov    %edi,%r13d
  800a2e:	49 89 f6             	mov    %rsi,%r14
  800a31:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800a34:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800a39:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800a3e:	49 bf 5c 09 80 00 00 	movabs $0x80095c,%r15
  800a45:	00 00 00 
  800a48:	4c 89 e2             	mov    %r12,%rdx
  800a4b:	48 29 f2             	sub    %rsi,%rdx
  800a4e:	4c 01 f6             	add    %r14,%rsi
  800a51:	44 89 ef             	mov    %r13d,%edi
  800a54:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800a57:	85 c0                	test   %eax,%eax
  800a59:	78 20                	js     800a7b <readn+0x66>
    for (; inc && res < n; res += inc) {
  800a5b:	01 c3                	add    %eax,%ebx
  800a5d:	85 c0                	test   %eax,%eax
  800a5f:	74 08                	je     800a69 <readn+0x54>
  800a61:	48 63 f3             	movslq %ebx,%rsi
  800a64:	4c 39 e6             	cmp    %r12,%rsi
  800a67:	72 df                	jb     800a48 <readn+0x33>
    }
    return res;
  800a69:	48 63 c3             	movslq %ebx,%rax
}
  800a6c:	48 83 c4 08          	add    $0x8,%rsp
  800a70:	5b                   	pop    %rbx
  800a71:	41 5c                	pop    %r12
  800a73:	41 5d                	pop    %r13
  800a75:	41 5e                	pop    %r14
  800a77:	41 5f                	pop    %r15
  800a79:	5d                   	pop    %rbp
  800a7a:	c3                   	ret    
        if (inc < 0) return inc;
  800a7b:	48 98                	cltq   
  800a7d:	eb ed                	jmp    800a6c <readn+0x57>
    int inc = 1, res = 0;
  800a7f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a84:	eb e3                	jmp    800a69 <readn+0x54>

0000000000800a86 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800a86:	55                   	push   %rbp
  800a87:	48 89 e5             	mov    %rsp,%rbp
  800a8a:	41 55                	push   %r13
  800a8c:	41 54                	push   %r12
  800a8e:	53                   	push   %rbx
  800a8f:	48 83 ec 18          	sub    $0x18,%rsp
  800a93:	89 fb                	mov    %edi,%ebx
  800a95:	49 89 f4             	mov    %rsi,%r12
  800a98:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a9b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a9f:	48 b8 79 06 80 00 00 	movabs $0x800679,%rax
  800aa6:	00 00 00 
  800aa9:	ff d0                	call   *%rax
  800aab:	85 c0                	test   %eax,%eax
  800aad:	78 44                	js     800af3 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800aaf:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800ab3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ab7:	8b 38                	mov    (%rax),%edi
  800ab9:	48 b8 c4 06 80 00 00 	movabs $0x8006c4,%rax
  800ac0:	00 00 00 
  800ac3:	ff d0                	call   *%rax
  800ac5:	85 c0                	test   %eax,%eax
  800ac7:	78 2e                	js     800af7 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ac9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800acd:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800ad1:	74 28                	je     800afb <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800ad3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ad7:	48 8b 40 18          	mov    0x18(%rax),%rax
  800adb:	48 85 c0             	test   %rax,%rax
  800ade:	74 51                	je     800b31 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  800ae0:	4c 89 ea             	mov    %r13,%rdx
  800ae3:	4c 89 e6             	mov    %r12,%rsi
  800ae6:	ff d0                	call   *%rax
}
  800ae8:	48 83 c4 18          	add    $0x18,%rsp
  800aec:	5b                   	pop    %rbx
  800aed:	41 5c                	pop    %r12
  800aef:	41 5d                	pop    %r13
  800af1:	5d                   	pop    %rbp
  800af2:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800af3:	48 98                	cltq   
  800af5:	eb f1                	jmp    800ae8 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800af7:	48 98                	cltq   
  800af9:	eb ed                	jmp    800ae8 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800afb:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800b02:	00 00 00 
  800b05:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800b0b:	89 da                	mov    %ebx,%edx
  800b0d:	48 bf 4d 2a 80 00 00 	movabs $0x802a4d,%rdi
  800b14:	00 00 00 
  800b17:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1c:	48 b9 99 1a 80 00 00 	movabs $0x801a99,%rcx
  800b23:	00 00 00 
  800b26:	ff d1                	call   *%rcx
        return -E_INVAL;
  800b28:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800b2f:	eb b7                	jmp    800ae8 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800b31:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800b38:	eb ae                	jmp    800ae8 <write+0x62>

0000000000800b3a <seek>:

int
seek(int fdnum, off_t offset) {
  800b3a:	55                   	push   %rbp
  800b3b:	48 89 e5             	mov    %rsp,%rbp
  800b3e:	53                   	push   %rbx
  800b3f:	48 83 ec 18          	sub    $0x18,%rsp
  800b43:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b45:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b49:	48 b8 79 06 80 00 00 	movabs $0x800679,%rax
  800b50:	00 00 00 
  800b53:	ff d0                	call   *%rax
  800b55:	85 c0                	test   %eax,%eax
  800b57:	78 0c                	js     800b65 <seek+0x2b>

    fd->fd_offset = offset;
  800b59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5d:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800b60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b65:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800b69:	c9                   	leave  
  800b6a:	c3                   	ret    

0000000000800b6b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800b6b:	55                   	push   %rbp
  800b6c:	48 89 e5             	mov    %rsp,%rbp
  800b6f:	41 54                	push   %r12
  800b71:	53                   	push   %rbx
  800b72:	48 83 ec 10          	sub    $0x10,%rsp
  800b76:	89 fb                	mov    %edi,%ebx
  800b78:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b7b:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b7f:	48 b8 79 06 80 00 00 	movabs $0x800679,%rax
  800b86:	00 00 00 
  800b89:	ff d0                	call   *%rax
  800b8b:	85 c0                	test   %eax,%eax
  800b8d:	78 36                	js     800bc5 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b8f:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800b93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b97:	8b 38                	mov    (%rax),%edi
  800b99:	48 b8 c4 06 80 00 00 	movabs $0x8006c4,%rax
  800ba0:	00 00 00 
  800ba3:	ff d0                	call   *%rax
  800ba5:	85 c0                	test   %eax,%eax
  800ba7:	78 1c                	js     800bc5 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ba9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800bad:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800bb1:	74 1b                	je     800bce <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800bb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800bb7:	48 8b 40 30          	mov    0x30(%rax),%rax
  800bbb:	48 85 c0             	test   %rax,%rax
  800bbe:	74 42                	je     800c02 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  800bc0:	44 89 e6             	mov    %r12d,%esi
  800bc3:	ff d0                	call   *%rax
}
  800bc5:	48 83 c4 10          	add    $0x10,%rsp
  800bc9:	5b                   	pop    %rbx
  800bca:	41 5c                	pop    %r12
  800bcc:	5d                   	pop    %rbp
  800bcd:	c3                   	ret    
                thisenv->env_id, fdnum);
  800bce:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bd5:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800bd8:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800bde:	89 da                	mov    %ebx,%edx
  800be0:	48 bf 10 2a 80 00 00 	movabs $0x802a10,%rdi
  800be7:	00 00 00 
  800bea:	b8 00 00 00 00       	mov    $0x0,%eax
  800bef:	48 b9 99 1a 80 00 00 	movabs $0x801a99,%rcx
  800bf6:	00 00 00 
  800bf9:	ff d1                	call   *%rcx
        return -E_INVAL;
  800bfb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c00:	eb c3                	jmp    800bc5 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c02:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c07:	eb bc                	jmp    800bc5 <ftruncate+0x5a>

0000000000800c09 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800c09:	55                   	push   %rbp
  800c0a:	48 89 e5             	mov    %rsp,%rbp
  800c0d:	53                   	push   %rbx
  800c0e:	48 83 ec 18          	sub    $0x18,%rsp
  800c12:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c15:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c19:	48 b8 79 06 80 00 00 	movabs $0x800679,%rax
  800c20:	00 00 00 
  800c23:	ff d0                	call   *%rax
  800c25:	85 c0                	test   %eax,%eax
  800c27:	78 4d                	js     800c76 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c29:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800c2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c31:	8b 38                	mov    (%rax),%edi
  800c33:	48 b8 c4 06 80 00 00 	movabs $0x8006c4,%rax
  800c3a:	00 00 00 
  800c3d:	ff d0                	call   *%rax
  800c3f:	85 c0                	test   %eax,%eax
  800c41:	78 33                	js     800c76 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c47:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800c4c:	74 2e                	je     800c7c <fstat+0x73>

    stat->st_name[0] = 0;
  800c4e:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800c51:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800c58:	00 00 00 
    stat->st_isdir = 0;
  800c5b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800c62:	00 00 00 
    stat->st_dev = dev;
  800c65:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800c6c:	48 89 de             	mov    %rbx,%rsi
  800c6f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c73:	ff 50 28             	call   *0x28(%rax)
}
  800c76:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c7a:	c9                   	leave  
  800c7b:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c7c:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c81:	eb f3                	jmp    800c76 <fstat+0x6d>

0000000000800c83 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800c83:	55                   	push   %rbp
  800c84:	48 89 e5             	mov    %rsp,%rbp
  800c87:	41 54                	push   %r12
  800c89:	53                   	push   %rbx
  800c8a:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800c8d:	be 00 00 00 00       	mov    $0x0,%esi
  800c92:	48 b8 4e 0f 80 00 00 	movabs $0x800f4e,%rax
  800c99:	00 00 00 
  800c9c:	ff d0                	call   *%rax
  800c9e:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	78 25                	js     800cc9 <stat+0x46>

    int res = fstat(fd, stat);
  800ca4:	4c 89 e6             	mov    %r12,%rsi
  800ca7:	89 c7                	mov    %eax,%edi
  800ca9:	48 b8 09 0c 80 00 00 	movabs $0x800c09,%rax
  800cb0:	00 00 00 
  800cb3:	ff d0                	call   *%rax
  800cb5:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800cb8:	89 df                	mov    %ebx,%edi
  800cba:	48 b8 e3 07 80 00 00 	movabs $0x8007e3,%rax
  800cc1:	00 00 00 
  800cc4:	ff d0                	call   *%rax

    return res;
  800cc6:	44 89 e3             	mov    %r12d,%ebx
}
  800cc9:	89 d8                	mov    %ebx,%eax
  800ccb:	5b                   	pop    %rbx
  800ccc:	41 5c                	pop    %r12
  800cce:	5d                   	pop    %rbp
  800ccf:	c3                   	ret    

0000000000800cd0 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800cd0:	55                   	push   %rbp
  800cd1:	48 89 e5             	mov    %rsp,%rbp
  800cd4:	41 54                	push   %r12
  800cd6:	53                   	push   %rbx
  800cd7:	48 83 ec 10          	sub    $0x10,%rsp
  800cdb:	41 89 fc             	mov    %edi,%r12d
  800cde:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800ce1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800ce8:	00 00 00 
  800ceb:	83 38 00             	cmpl   $0x0,(%rax)
  800cee:	74 5e                	je     800d4e <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800cf0:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800cf6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800cfb:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800d02:	00 00 00 
  800d05:	44 89 e6             	mov    %r12d,%esi
  800d08:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d0f:	00 00 00 
  800d12:	8b 38                	mov    (%rax),%edi
  800d14:	48 b8 aa 28 80 00 00 	movabs $0x8028aa,%rax
  800d1b:	00 00 00 
  800d1e:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800d20:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800d27:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800d28:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d2d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d31:	48 89 de             	mov    %rbx,%rsi
  800d34:	bf 00 00 00 00       	mov    $0x0,%edi
  800d39:	48 b8 0b 28 80 00 00 	movabs $0x80280b,%rax
  800d40:	00 00 00 
  800d43:	ff d0                	call   *%rax
}
  800d45:	48 83 c4 10          	add    $0x10,%rsp
  800d49:	5b                   	pop    %rbx
  800d4a:	41 5c                	pop    %r12
  800d4c:	5d                   	pop    %rbp
  800d4d:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800d4e:	bf 03 00 00 00       	mov    $0x3,%edi
  800d53:	48 b8 4d 29 80 00 00 	movabs $0x80294d,%rax
  800d5a:	00 00 00 
  800d5d:	ff d0                	call   *%rax
  800d5f:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800d66:	00 00 
  800d68:	eb 86                	jmp    800cf0 <fsipc+0x20>

0000000000800d6a <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800d6a:	55                   	push   %rbp
  800d6b:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d6e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800d75:	00 00 00 
  800d78:	8b 57 0c             	mov    0xc(%rdi),%edx
  800d7b:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800d7d:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800d80:	be 00 00 00 00       	mov    $0x0,%esi
  800d85:	bf 02 00 00 00       	mov    $0x2,%edi
  800d8a:	48 b8 d0 0c 80 00 00 	movabs $0x800cd0,%rax
  800d91:	00 00 00 
  800d94:	ff d0                	call   *%rax
}
  800d96:	5d                   	pop    %rbp
  800d97:	c3                   	ret    

0000000000800d98 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800d98:	55                   	push   %rbp
  800d99:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800d9c:	8b 47 0c             	mov    0xc(%rdi),%eax
  800d9f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800da6:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800da8:	be 00 00 00 00       	mov    $0x0,%esi
  800dad:	bf 06 00 00 00       	mov    $0x6,%edi
  800db2:	48 b8 d0 0c 80 00 00 	movabs $0x800cd0,%rax
  800db9:	00 00 00 
  800dbc:	ff d0                	call   *%rax
}
  800dbe:	5d                   	pop    %rbp
  800dbf:	c3                   	ret    

0000000000800dc0 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800dc0:	55                   	push   %rbp
  800dc1:	48 89 e5             	mov    %rsp,%rbp
  800dc4:	53                   	push   %rbx
  800dc5:	48 83 ec 08          	sub    $0x8,%rsp
  800dc9:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800dcc:	8b 47 0c             	mov    0xc(%rdi),%eax
  800dcf:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800dd6:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800dd8:	be 00 00 00 00       	mov    $0x0,%esi
  800ddd:	bf 05 00 00 00       	mov    $0x5,%edi
  800de2:	48 b8 d0 0c 80 00 00 	movabs $0x800cd0,%rax
  800de9:	00 00 00 
  800dec:	ff d0                	call   *%rax
    if (res < 0) return res;
  800dee:	85 c0                	test   %eax,%eax
  800df0:	78 40                	js     800e32 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800df2:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800df9:	00 00 00 
  800dfc:	48 89 df             	mov    %rbx,%rdi
  800dff:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  800e06:	00 00 00 
  800e09:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800e0b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e12:	00 00 00 
  800e15:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  800e1b:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e21:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  800e27:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800e2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e32:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800e36:	c9                   	leave  
  800e37:	c3                   	ret    

0000000000800e38 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800e38:	55                   	push   %rbp
  800e39:	48 89 e5             	mov    %rsp,%rbp
  800e3c:	41 57                	push   %r15
  800e3e:	41 56                	push   %r14
  800e40:	41 55                	push   %r13
  800e42:	41 54                	push   %r12
  800e44:	53                   	push   %rbx
  800e45:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  800e49:	48 85 d2             	test   %rdx,%rdx
  800e4c:	0f 84 91 00 00 00    	je     800ee3 <devfile_write+0xab>
  800e52:	49 89 ff             	mov    %rdi,%r15
  800e55:	49 89 f4             	mov    %rsi,%r12
  800e58:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  800e5b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e62:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  800e69:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  800e6c:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  800e73:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  800e79:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  800e7d:	4c 89 ea             	mov    %r13,%rdx
  800e80:	4c 89 e6             	mov    %r12,%rsi
  800e83:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  800e8a:	00 00 00 
  800e8d:	48 b8 3a 26 80 00 00 	movabs $0x80263a,%rax
  800e94:	00 00 00 
  800e97:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e99:	41 8b 47 0c          	mov    0xc(%r15),%eax
  800e9d:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  800ea0:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  800ea4:	be 00 00 00 00       	mov    $0x0,%esi
  800ea9:	bf 04 00 00 00       	mov    $0x4,%edi
  800eae:	48 b8 d0 0c 80 00 00 	movabs $0x800cd0,%rax
  800eb5:	00 00 00 
  800eb8:	ff d0                	call   *%rax
        if (res < 0)
  800eba:	85 c0                	test   %eax,%eax
  800ebc:	78 21                	js     800edf <devfile_write+0xa7>
        buf += res;
  800ebe:	48 63 d0             	movslq %eax,%rdx
  800ec1:	49 01 d4             	add    %rdx,%r12
        ext += res;
  800ec4:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  800ec7:	48 29 d3             	sub    %rdx,%rbx
  800eca:	75 a0                	jne    800e6c <devfile_write+0x34>
    return ext;
  800ecc:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  800ed0:	48 83 c4 18          	add    $0x18,%rsp
  800ed4:	5b                   	pop    %rbx
  800ed5:	41 5c                	pop    %r12
  800ed7:	41 5d                	pop    %r13
  800ed9:	41 5e                	pop    %r14
  800edb:	41 5f                	pop    %r15
  800edd:	5d                   	pop    %rbp
  800ede:	c3                   	ret    
            return res;
  800edf:	48 98                	cltq   
  800ee1:	eb ed                	jmp    800ed0 <devfile_write+0x98>
    int ext = 0;
  800ee3:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  800eea:	eb e0                	jmp    800ecc <devfile_write+0x94>

0000000000800eec <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800eec:	55                   	push   %rbp
  800eed:	48 89 e5             	mov    %rsp,%rbp
  800ef0:	41 54                	push   %r12
  800ef2:	53                   	push   %rbx
  800ef3:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ef6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800efd:	00 00 00 
  800f00:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f03:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  800f05:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  800f09:	be 00 00 00 00       	mov    $0x0,%esi
  800f0e:	bf 03 00 00 00       	mov    $0x3,%edi
  800f13:	48 b8 d0 0c 80 00 00 	movabs $0x800cd0,%rax
  800f1a:	00 00 00 
  800f1d:	ff d0                	call   *%rax
    if (read < 0) 
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	78 27                	js     800f4a <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  800f23:	48 63 d8             	movslq %eax,%rbx
  800f26:	48 89 da             	mov    %rbx,%rdx
  800f29:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800f30:	00 00 00 
  800f33:	4c 89 e7             	mov    %r12,%rdi
  800f36:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  800f3d:	00 00 00 
  800f40:	ff d0                	call   *%rax
    return read;
  800f42:	48 89 d8             	mov    %rbx,%rax
}
  800f45:	5b                   	pop    %rbx
  800f46:	41 5c                	pop    %r12
  800f48:	5d                   	pop    %rbp
  800f49:	c3                   	ret    
		return read;
  800f4a:	48 98                	cltq   
  800f4c:	eb f7                	jmp    800f45 <devfile_read+0x59>

0000000000800f4e <open>:
open(const char *path, int mode) {
  800f4e:	55                   	push   %rbp
  800f4f:	48 89 e5             	mov    %rsp,%rbp
  800f52:	41 55                	push   %r13
  800f54:	41 54                	push   %r12
  800f56:	53                   	push   %rbx
  800f57:	48 83 ec 18          	sub    $0x18,%rsp
  800f5b:	49 89 fc             	mov    %rdi,%r12
  800f5e:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  800f61:	48 b8 a1 23 80 00 00 	movabs $0x8023a1,%rax
  800f68:	00 00 00 
  800f6b:	ff d0                	call   *%rax
  800f6d:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  800f73:	0f 87 8c 00 00 00    	ja     801005 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  800f79:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  800f7d:	48 b8 19 06 80 00 00 	movabs $0x800619,%rax
  800f84:	00 00 00 
  800f87:	ff d0                	call   *%rax
  800f89:	89 c3                	mov    %eax,%ebx
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	78 52                	js     800fe1 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  800f8f:	4c 89 e6             	mov    %r12,%rsi
  800f92:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  800f99:	00 00 00 
  800f9c:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  800fa3:	00 00 00 
  800fa6:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  800fa8:	44 89 e8             	mov    %r13d,%eax
  800fab:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  800fb2:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fb4:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800fb8:	bf 01 00 00 00       	mov    $0x1,%edi
  800fbd:	48 b8 d0 0c 80 00 00 	movabs $0x800cd0,%rax
  800fc4:	00 00 00 
  800fc7:	ff d0                	call   *%rax
  800fc9:	89 c3                	mov    %eax,%ebx
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	78 1f                	js     800fee <open+0xa0>
    return fd2num(fd);
  800fcf:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800fd3:	48 b8 eb 05 80 00 00 	movabs $0x8005eb,%rax
  800fda:	00 00 00 
  800fdd:	ff d0                	call   *%rax
  800fdf:	89 c3                	mov    %eax,%ebx
}
  800fe1:	89 d8                	mov    %ebx,%eax
  800fe3:	48 83 c4 18          	add    $0x18,%rsp
  800fe7:	5b                   	pop    %rbx
  800fe8:	41 5c                	pop    %r12
  800fea:	41 5d                	pop    %r13
  800fec:	5d                   	pop    %rbp
  800fed:	c3                   	ret    
        fd_close(fd, 0);
  800fee:	be 00 00 00 00       	mov    $0x0,%esi
  800ff3:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ff7:	48 b8 3d 07 80 00 00 	movabs $0x80073d,%rax
  800ffe:	00 00 00 
  801001:	ff d0                	call   *%rax
        return res;
  801003:	eb dc                	jmp    800fe1 <open+0x93>
        return -E_BAD_PATH;
  801005:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80100a:	eb d5                	jmp    800fe1 <open+0x93>

000000000080100c <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80100c:	55                   	push   %rbp
  80100d:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801010:	be 00 00 00 00       	mov    $0x0,%esi
  801015:	bf 08 00 00 00       	mov    $0x8,%edi
  80101a:	48 b8 d0 0c 80 00 00 	movabs $0x800cd0,%rax
  801021:	00 00 00 
  801024:	ff d0                	call   *%rax
}
  801026:	5d                   	pop    %rbp
  801027:	c3                   	ret    

0000000000801028 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801028:	55                   	push   %rbp
  801029:	48 89 e5             	mov    %rsp,%rbp
  80102c:	41 54                	push   %r12
  80102e:	53                   	push   %rbx
  80102f:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801032:	48 b8 fd 05 80 00 00 	movabs $0x8005fd,%rax
  801039:	00 00 00 
  80103c:	ff d0                	call   *%rax
  80103e:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801041:	48 be a0 2a 80 00 00 	movabs $0x802aa0,%rsi
  801048:	00 00 00 
  80104b:	48 89 df             	mov    %rbx,%rdi
  80104e:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  801055:	00 00 00 
  801058:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80105a:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80105f:	41 2b 04 24          	sub    (%r12),%eax
  801063:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801069:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801070:	00 00 00 
    stat->st_dev = &devpipe;
  801073:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80107a:	00 00 00 
  80107d:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801084:	b8 00 00 00 00       	mov    $0x0,%eax
  801089:	5b                   	pop    %rbx
  80108a:	41 5c                	pop    %r12
  80108c:	5d                   	pop    %rbp
  80108d:	c3                   	ret    

000000000080108e <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80108e:	55                   	push   %rbp
  80108f:	48 89 e5             	mov    %rsp,%rbp
  801092:	41 54                	push   %r12
  801094:	53                   	push   %rbx
  801095:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801098:	ba 00 10 00 00       	mov    $0x1000,%edx
  80109d:	48 89 fe             	mov    %rdi,%rsi
  8010a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8010a5:	49 bc 52 03 80 00 00 	movabs $0x800352,%r12
  8010ac:	00 00 00 
  8010af:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8010b2:	48 89 df             	mov    %rbx,%rdi
  8010b5:	48 b8 fd 05 80 00 00 	movabs $0x8005fd,%rax
  8010bc:	00 00 00 
  8010bf:	ff d0                	call   *%rax
  8010c1:	48 89 c6             	mov    %rax,%rsi
  8010c4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8010ce:	41 ff d4             	call   *%r12
}
  8010d1:	5b                   	pop    %rbx
  8010d2:	41 5c                	pop    %r12
  8010d4:	5d                   	pop    %rbp
  8010d5:	c3                   	ret    

00000000008010d6 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8010d6:	55                   	push   %rbp
  8010d7:	48 89 e5             	mov    %rsp,%rbp
  8010da:	41 57                	push   %r15
  8010dc:	41 56                	push   %r14
  8010de:	41 55                	push   %r13
  8010e0:	41 54                	push   %r12
  8010e2:	53                   	push   %rbx
  8010e3:	48 83 ec 18          	sub    $0x18,%rsp
  8010e7:	49 89 fc             	mov    %rdi,%r12
  8010ea:	49 89 f5             	mov    %rsi,%r13
  8010ed:	49 89 d7             	mov    %rdx,%r15
  8010f0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8010f4:	48 b8 fd 05 80 00 00 	movabs $0x8005fd,%rax
  8010fb:	00 00 00 
  8010fe:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801100:	4d 85 ff             	test   %r15,%r15
  801103:	0f 84 ac 00 00 00    	je     8011b5 <devpipe_write+0xdf>
  801109:	48 89 c3             	mov    %rax,%rbx
  80110c:	4c 89 f8             	mov    %r15,%rax
  80110f:	4d 89 ef             	mov    %r13,%r15
  801112:	49 01 c5             	add    %rax,%r13
  801115:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801119:	49 bd 5a 02 80 00 00 	movabs $0x80025a,%r13
  801120:	00 00 00 
            sys_yield();
  801123:	49 be f7 01 80 00 00 	movabs $0x8001f7,%r14
  80112a:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80112d:	8b 73 04             	mov    0x4(%rbx),%esi
  801130:	48 63 ce             	movslq %esi,%rcx
  801133:	48 63 03             	movslq (%rbx),%rax
  801136:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80113c:	48 39 c1             	cmp    %rax,%rcx
  80113f:	72 2e                	jb     80116f <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801141:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801146:	48 89 da             	mov    %rbx,%rdx
  801149:	be 00 10 00 00       	mov    $0x1000,%esi
  80114e:	4c 89 e7             	mov    %r12,%rdi
  801151:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801154:	85 c0                	test   %eax,%eax
  801156:	74 63                	je     8011bb <devpipe_write+0xe5>
            sys_yield();
  801158:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80115b:	8b 73 04             	mov    0x4(%rbx),%esi
  80115e:	48 63 ce             	movslq %esi,%rcx
  801161:	48 63 03             	movslq (%rbx),%rax
  801164:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80116a:	48 39 c1             	cmp    %rax,%rcx
  80116d:	73 d2                	jae    801141 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80116f:	41 0f b6 3f          	movzbl (%r15),%edi
  801173:	48 89 ca             	mov    %rcx,%rdx
  801176:	48 c1 ea 03          	shr    $0x3,%rdx
  80117a:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801181:	08 10 20 
  801184:	48 f7 e2             	mul    %rdx
  801187:	48 c1 ea 06          	shr    $0x6,%rdx
  80118b:	48 89 d0             	mov    %rdx,%rax
  80118e:	48 c1 e0 09          	shl    $0x9,%rax
  801192:	48 29 d0             	sub    %rdx,%rax
  801195:	48 c1 e0 03          	shl    $0x3,%rax
  801199:	48 29 c1             	sub    %rax,%rcx
  80119c:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8011a1:	83 c6 01             	add    $0x1,%esi
  8011a4:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8011a7:	49 83 c7 01          	add    $0x1,%r15
  8011ab:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8011af:	0f 85 78 ff ff ff    	jne    80112d <devpipe_write+0x57>
    return n;
  8011b5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8011b9:	eb 05                	jmp    8011c0 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8011bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c0:	48 83 c4 18          	add    $0x18,%rsp
  8011c4:	5b                   	pop    %rbx
  8011c5:	41 5c                	pop    %r12
  8011c7:	41 5d                	pop    %r13
  8011c9:	41 5e                	pop    %r14
  8011cb:	41 5f                	pop    %r15
  8011cd:	5d                   	pop    %rbp
  8011ce:	c3                   	ret    

00000000008011cf <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8011cf:	55                   	push   %rbp
  8011d0:	48 89 e5             	mov    %rsp,%rbp
  8011d3:	41 57                	push   %r15
  8011d5:	41 56                	push   %r14
  8011d7:	41 55                	push   %r13
  8011d9:	41 54                	push   %r12
  8011db:	53                   	push   %rbx
  8011dc:	48 83 ec 18          	sub    $0x18,%rsp
  8011e0:	49 89 fc             	mov    %rdi,%r12
  8011e3:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8011e7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8011eb:	48 b8 fd 05 80 00 00 	movabs $0x8005fd,%rax
  8011f2:	00 00 00 
  8011f5:	ff d0                	call   *%rax
  8011f7:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8011fa:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801200:	49 bd 5a 02 80 00 00 	movabs $0x80025a,%r13
  801207:	00 00 00 
            sys_yield();
  80120a:	49 be f7 01 80 00 00 	movabs $0x8001f7,%r14
  801211:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801214:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801219:	74 7a                	je     801295 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80121b:	8b 03                	mov    (%rbx),%eax
  80121d:	3b 43 04             	cmp    0x4(%rbx),%eax
  801220:	75 26                	jne    801248 <devpipe_read+0x79>
            if (i > 0) return i;
  801222:	4d 85 ff             	test   %r15,%r15
  801225:	75 74                	jne    80129b <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801227:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80122c:	48 89 da             	mov    %rbx,%rdx
  80122f:	be 00 10 00 00       	mov    $0x1000,%esi
  801234:	4c 89 e7             	mov    %r12,%rdi
  801237:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80123a:	85 c0                	test   %eax,%eax
  80123c:	74 6f                	je     8012ad <devpipe_read+0xde>
            sys_yield();
  80123e:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801241:	8b 03                	mov    (%rbx),%eax
  801243:	3b 43 04             	cmp    0x4(%rbx),%eax
  801246:	74 df                	je     801227 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801248:	48 63 c8             	movslq %eax,%rcx
  80124b:	48 89 ca             	mov    %rcx,%rdx
  80124e:	48 c1 ea 03          	shr    $0x3,%rdx
  801252:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801259:	08 10 20 
  80125c:	48 f7 e2             	mul    %rdx
  80125f:	48 c1 ea 06          	shr    $0x6,%rdx
  801263:	48 89 d0             	mov    %rdx,%rax
  801266:	48 c1 e0 09          	shl    $0x9,%rax
  80126a:	48 29 d0             	sub    %rdx,%rax
  80126d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801274:	00 
  801275:	48 89 c8             	mov    %rcx,%rax
  801278:	48 29 d0             	sub    %rdx,%rax
  80127b:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  801280:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801284:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  801288:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80128b:	49 83 c7 01          	add    $0x1,%r15
  80128f:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  801293:	75 86                	jne    80121b <devpipe_read+0x4c>
    return n;
  801295:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801299:	eb 03                	jmp    80129e <devpipe_read+0xcf>
            if (i > 0) return i;
  80129b:	4c 89 f8             	mov    %r15,%rax
}
  80129e:	48 83 c4 18          	add    $0x18,%rsp
  8012a2:	5b                   	pop    %rbx
  8012a3:	41 5c                	pop    %r12
  8012a5:	41 5d                	pop    %r13
  8012a7:	41 5e                	pop    %r14
  8012a9:	41 5f                	pop    %r15
  8012ab:	5d                   	pop    %rbp
  8012ac:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8012ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b2:	eb ea                	jmp    80129e <devpipe_read+0xcf>

00000000008012b4 <pipe>:
pipe(int pfd[2]) {
  8012b4:	55                   	push   %rbp
  8012b5:	48 89 e5             	mov    %rsp,%rbp
  8012b8:	41 55                	push   %r13
  8012ba:	41 54                	push   %r12
  8012bc:	53                   	push   %rbx
  8012bd:	48 83 ec 18          	sub    $0x18,%rsp
  8012c1:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8012c4:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8012c8:	48 b8 19 06 80 00 00 	movabs $0x800619,%rax
  8012cf:	00 00 00 
  8012d2:	ff d0                	call   *%rax
  8012d4:	89 c3                	mov    %eax,%ebx
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	0f 88 a0 01 00 00    	js     80147e <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8012de:	b9 46 00 00 00       	mov    $0x46,%ecx
  8012e3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8012e8:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8012ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8012f1:	48 b8 86 02 80 00 00 	movabs $0x800286,%rax
  8012f8:	00 00 00 
  8012fb:	ff d0                	call   *%rax
  8012fd:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8012ff:	85 c0                	test   %eax,%eax
  801301:	0f 88 77 01 00 00    	js     80147e <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801307:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80130b:	48 b8 19 06 80 00 00 	movabs $0x800619,%rax
  801312:	00 00 00 
  801315:	ff d0                	call   *%rax
  801317:	89 c3                	mov    %eax,%ebx
  801319:	85 c0                	test   %eax,%eax
  80131b:	0f 88 43 01 00 00    	js     801464 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  801321:	b9 46 00 00 00       	mov    $0x46,%ecx
  801326:	ba 00 10 00 00       	mov    $0x1000,%edx
  80132b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80132f:	bf 00 00 00 00       	mov    $0x0,%edi
  801334:	48 b8 86 02 80 00 00 	movabs $0x800286,%rax
  80133b:	00 00 00 
  80133e:	ff d0                	call   *%rax
  801340:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  801342:	85 c0                	test   %eax,%eax
  801344:	0f 88 1a 01 00 00    	js     801464 <pipe+0x1b0>
    va = fd2data(fd0);
  80134a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80134e:	48 b8 fd 05 80 00 00 	movabs $0x8005fd,%rax
  801355:	00 00 00 
  801358:	ff d0                	call   *%rax
  80135a:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80135d:	b9 46 00 00 00       	mov    $0x46,%ecx
  801362:	ba 00 10 00 00       	mov    $0x1000,%edx
  801367:	48 89 c6             	mov    %rax,%rsi
  80136a:	bf 00 00 00 00       	mov    $0x0,%edi
  80136f:	48 b8 86 02 80 00 00 	movabs $0x800286,%rax
  801376:	00 00 00 
  801379:	ff d0                	call   *%rax
  80137b:	89 c3                	mov    %eax,%ebx
  80137d:	85 c0                	test   %eax,%eax
  80137f:	0f 88 c5 00 00 00    	js     80144a <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  801385:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801389:	48 b8 fd 05 80 00 00 	movabs $0x8005fd,%rax
  801390:	00 00 00 
  801393:	ff d0                	call   *%rax
  801395:	48 89 c1             	mov    %rax,%rcx
  801398:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80139e:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8013a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a9:	4c 89 ee             	mov    %r13,%rsi
  8013ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8013b1:	48 b8 ed 02 80 00 00 	movabs $0x8002ed,%rax
  8013b8:	00 00 00 
  8013bb:	ff d0                	call   *%rax
  8013bd:	89 c3                	mov    %eax,%ebx
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	78 6e                	js     801431 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8013c3:	be 00 10 00 00       	mov    $0x1000,%esi
  8013c8:	4c 89 ef             	mov    %r13,%rdi
  8013cb:	48 b8 28 02 80 00 00 	movabs $0x800228,%rax
  8013d2:	00 00 00 
  8013d5:	ff d0                	call   *%rax
  8013d7:	83 f8 02             	cmp    $0x2,%eax
  8013da:	0f 85 ab 00 00 00    	jne    80148b <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8013e0:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8013e7:	00 00 
  8013e9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013ed:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8013ef:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013f3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8013fa:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8013fe:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801400:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801404:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80140b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80140f:	48 bb eb 05 80 00 00 	movabs $0x8005eb,%rbx
  801416:	00 00 00 
  801419:	ff d3                	call   *%rbx
  80141b:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80141f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801423:	ff d3                	call   *%rbx
  801425:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80142a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142f:	eb 4d                	jmp    80147e <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  801431:	ba 00 10 00 00       	mov    $0x1000,%edx
  801436:	4c 89 ee             	mov    %r13,%rsi
  801439:	bf 00 00 00 00       	mov    $0x0,%edi
  80143e:	48 b8 52 03 80 00 00 	movabs $0x800352,%rax
  801445:	00 00 00 
  801448:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80144a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80144f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801453:	bf 00 00 00 00       	mov    $0x0,%edi
  801458:	48 b8 52 03 80 00 00 	movabs $0x800352,%rax
  80145f:	00 00 00 
  801462:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  801464:	ba 00 10 00 00       	mov    $0x1000,%edx
  801469:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80146d:	bf 00 00 00 00       	mov    $0x0,%edi
  801472:	48 b8 52 03 80 00 00 	movabs $0x800352,%rax
  801479:	00 00 00 
  80147c:	ff d0                	call   *%rax
}
  80147e:	89 d8                	mov    %ebx,%eax
  801480:	48 83 c4 18          	add    $0x18,%rsp
  801484:	5b                   	pop    %rbx
  801485:	41 5c                	pop    %r12
  801487:	41 5d                	pop    %r13
  801489:	5d                   	pop    %rbp
  80148a:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80148b:	48 b9 d0 2a 80 00 00 	movabs $0x802ad0,%rcx
  801492:	00 00 00 
  801495:	48 ba a7 2a 80 00 00 	movabs $0x802aa7,%rdx
  80149c:	00 00 00 
  80149f:	be 2e 00 00 00       	mov    $0x2e,%esi
  8014a4:	48 bf bc 2a 80 00 00 	movabs $0x802abc,%rdi
  8014ab:	00 00 00 
  8014ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b3:	49 b8 49 19 80 00 00 	movabs $0x801949,%r8
  8014ba:	00 00 00 
  8014bd:	41 ff d0             	call   *%r8

00000000008014c0 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8014c0:	55                   	push   %rbp
  8014c1:	48 89 e5             	mov    %rsp,%rbp
  8014c4:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8014c8:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8014cc:	48 b8 79 06 80 00 00 	movabs $0x800679,%rax
  8014d3:	00 00 00 
  8014d6:	ff d0                	call   *%rax
    if (res < 0) return res;
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	78 35                	js     801511 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8014dc:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8014e0:	48 b8 fd 05 80 00 00 	movabs $0x8005fd,%rax
  8014e7:	00 00 00 
  8014ea:	ff d0                	call   *%rax
  8014ec:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8014ef:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8014f4:	be 00 10 00 00       	mov    $0x1000,%esi
  8014f9:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8014fd:	48 b8 5a 02 80 00 00 	movabs $0x80025a,%rax
  801504:	00 00 00 
  801507:	ff d0                	call   *%rax
  801509:	85 c0                	test   %eax,%eax
  80150b:	0f 94 c0             	sete   %al
  80150e:	0f b6 c0             	movzbl %al,%eax
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

0000000000801513 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801513:	48 89 f8             	mov    %rdi,%rax
  801516:	48 c1 e8 27          	shr    $0x27,%rax
  80151a:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  801521:	01 00 00 
  801524:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801528:	f6 c2 01             	test   $0x1,%dl
  80152b:	74 6d                	je     80159a <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80152d:	48 89 f8             	mov    %rdi,%rax
  801530:	48 c1 e8 1e          	shr    $0x1e,%rax
  801534:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80153b:	01 00 00 
  80153e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801542:	f6 c2 01             	test   $0x1,%dl
  801545:	74 62                	je     8015a9 <get_uvpt_entry+0x96>
  801547:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80154e:	01 00 00 
  801551:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801555:	f6 c2 80             	test   $0x80,%dl
  801558:	75 4f                	jne    8015a9 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80155a:	48 89 f8             	mov    %rdi,%rax
  80155d:	48 c1 e8 15          	shr    $0x15,%rax
  801561:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801568:	01 00 00 
  80156b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80156f:	f6 c2 01             	test   $0x1,%dl
  801572:	74 44                	je     8015b8 <get_uvpt_entry+0xa5>
  801574:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80157b:	01 00 00 
  80157e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801582:	f6 c2 80             	test   $0x80,%dl
  801585:	75 31                	jne    8015b8 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  801587:	48 c1 ef 0c          	shr    $0xc,%rdi
  80158b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801592:	01 00 00 
  801595:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  801599:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80159a:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8015a1:	01 00 00 
  8015a4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015a8:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8015a9:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8015b0:	01 00 00 
  8015b3:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015b7:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8015b8:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8015bf:	01 00 00 
  8015c2:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015c6:	c3                   	ret    

00000000008015c7 <get_prot>:

int
get_prot(void *va) {
  8015c7:	55                   	push   %rbp
  8015c8:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8015cb:	48 b8 13 15 80 00 00 	movabs $0x801513,%rax
  8015d2:	00 00 00 
  8015d5:	ff d0                	call   *%rax
  8015d7:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8015da:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8015df:	89 c1                	mov    %eax,%ecx
  8015e1:	83 c9 04             	or     $0x4,%ecx
  8015e4:	f6 c2 01             	test   $0x1,%dl
  8015e7:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8015ea:	89 c1                	mov    %eax,%ecx
  8015ec:	83 c9 02             	or     $0x2,%ecx
  8015ef:	f6 c2 02             	test   $0x2,%dl
  8015f2:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8015f5:	89 c1                	mov    %eax,%ecx
  8015f7:	83 c9 01             	or     $0x1,%ecx
  8015fa:	48 85 d2             	test   %rdx,%rdx
  8015fd:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801600:	89 c1                	mov    %eax,%ecx
  801602:	83 c9 40             	or     $0x40,%ecx
  801605:	f6 c6 04             	test   $0x4,%dh
  801608:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80160b:	5d                   	pop    %rbp
  80160c:	c3                   	ret    

000000000080160d <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80160d:	55                   	push   %rbp
  80160e:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801611:	48 b8 13 15 80 00 00 	movabs $0x801513,%rax
  801618:	00 00 00 
  80161b:	ff d0                	call   *%rax
    return pte & PTE_D;
  80161d:	48 c1 e8 06          	shr    $0x6,%rax
  801621:	83 e0 01             	and    $0x1,%eax
}
  801624:	5d                   	pop    %rbp
  801625:	c3                   	ret    

0000000000801626 <is_page_present>:

bool
is_page_present(void *va) {
  801626:	55                   	push   %rbp
  801627:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80162a:	48 b8 13 15 80 00 00 	movabs $0x801513,%rax
  801631:	00 00 00 
  801634:	ff d0                	call   *%rax
  801636:	83 e0 01             	and    $0x1,%eax
}
  801639:	5d                   	pop    %rbp
  80163a:	c3                   	ret    

000000000080163b <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80163b:	55                   	push   %rbp
  80163c:	48 89 e5             	mov    %rsp,%rbp
  80163f:	41 57                	push   %r15
  801641:	41 56                	push   %r14
  801643:	41 55                	push   %r13
  801645:	41 54                	push   %r12
  801647:	53                   	push   %rbx
  801648:	48 83 ec 28          	sub    $0x28,%rsp
  80164c:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  801650:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  801654:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  801659:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  801660:	01 00 00 
  801663:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  80166a:	01 00 00 
  80166d:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  801674:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  801677:	49 bf c7 15 80 00 00 	movabs $0x8015c7,%r15
  80167e:	00 00 00 
  801681:	eb 16                	jmp    801699 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  801683:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  80168a:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  801691:	00 00 00 
  801694:	48 39 c3             	cmp    %rax,%rbx
  801697:	77 73                	ja     80170c <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  801699:	48 89 d8             	mov    %rbx,%rax
  80169c:	48 c1 e8 27          	shr    $0x27,%rax
  8016a0:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8016a4:	a8 01                	test   $0x1,%al
  8016a6:	74 db                	je     801683 <foreach_shared_region+0x48>
  8016a8:	48 89 d8             	mov    %rbx,%rax
  8016ab:	48 c1 e8 1e          	shr    $0x1e,%rax
  8016af:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8016b4:	a8 01                	test   $0x1,%al
  8016b6:	74 cb                	je     801683 <foreach_shared_region+0x48>
  8016b8:	48 89 d8             	mov    %rbx,%rax
  8016bb:	48 c1 e8 15          	shr    $0x15,%rax
  8016bf:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8016c3:	a8 01                	test   $0x1,%al
  8016c5:	74 bc                	je     801683 <foreach_shared_region+0x48>
        void *start = (void*)i;
  8016c7:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016cb:	48 89 df             	mov    %rbx,%rdi
  8016ce:	41 ff d7             	call   *%r15
  8016d1:	a8 40                	test   $0x40,%al
  8016d3:	75 09                	jne    8016de <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8016d5:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8016dc:	eb ac                	jmp    80168a <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016de:	48 89 df             	mov    %rbx,%rdi
  8016e1:	48 b8 26 16 80 00 00 	movabs $0x801626,%rax
  8016e8:	00 00 00 
  8016eb:	ff d0                	call   *%rax
  8016ed:	84 c0                	test   %al,%al
  8016ef:	74 e4                	je     8016d5 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  8016f1:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  8016f8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8016fc:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  801700:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801704:	ff d0                	call   *%rax
  801706:	85 c0                	test   %eax,%eax
  801708:	79 cb                	jns    8016d5 <foreach_shared_region+0x9a>
  80170a:	eb 05                	jmp    801711 <foreach_shared_region+0xd6>
    }
    return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801711:	48 83 c4 28          	add    $0x28,%rsp
  801715:	5b                   	pop    %rbx
  801716:	41 5c                	pop    %r12
  801718:	41 5d                	pop    %r13
  80171a:	41 5e                	pop    %r14
  80171c:	41 5f                	pop    %r15
  80171e:	5d                   	pop    %rbp
  80171f:	c3                   	ret    

0000000000801720 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  801720:	b8 00 00 00 00       	mov    $0x0,%eax
  801725:	c3                   	ret    

0000000000801726 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  801726:	55                   	push   %rbp
  801727:	48 89 e5             	mov    %rsp,%rbp
  80172a:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80172d:	48 be f4 2a 80 00 00 	movabs $0x802af4,%rsi
  801734:	00 00 00 
  801737:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  80173e:	00 00 00 
  801741:	ff d0                	call   *%rax
    return 0;
}
  801743:	b8 00 00 00 00       	mov    $0x0,%eax
  801748:	5d                   	pop    %rbp
  801749:	c3                   	ret    

000000000080174a <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80174a:	55                   	push   %rbp
  80174b:	48 89 e5             	mov    %rsp,%rbp
  80174e:	41 57                	push   %r15
  801750:	41 56                	push   %r14
  801752:	41 55                	push   %r13
  801754:	41 54                	push   %r12
  801756:	53                   	push   %rbx
  801757:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80175e:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  801765:	48 85 d2             	test   %rdx,%rdx
  801768:	74 78                	je     8017e2 <devcons_write+0x98>
  80176a:	49 89 d6             	mov    %rdx,%r14
  80176d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801773:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801778:	49 bf d5 25 80 00 00 	movabs $0x8025d5,%r15
  80177f:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801782:	4c 89 f3             	mov    %r14,%rbx
  801785:	48 29 f3             	sub    %rsi,%rbx
  801788:	48 83 fb 7f          	cmp    $0x7f,%rbx
  80178c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801791:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801795:	4c 63 eb             	movslq %ebx,%r13
  801798:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  80179f:	4c 89 ea             	mov    %r13,%rdx
  8017a2:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017a9:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8017ac:	4c 89 ee             	mov    %r13,%rsi
  8017af:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017b6:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  8017bd:	00 00 00 
  8017c0:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8017c2:	41 01 dc             	add    %ebx,%r12d
  8017c5:	49 63 f4             	movslq %r12d,%rsi
  8017c8:	4c 39 f6             	cmp    %r14,%rsi
  8017cb:	72 b5                	jb     801782 <devcons_write+0x38>
    return res;
  8017cd:	49 63 c4             	movslq %r12d,%rax
}
  8017d0:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8017d7:	5b                   	pop    %rbx
  8017d8:	41 5c                	pop    %r12
  8017da:	41 5d                	pop    %r13
  8017dc:	41 5e                	pop    %r14
  8017de:	41 5f                	pop    %r15
  8017e0:	5d                   	pop    %rbp
  8017e1:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8017e2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8017e8:	eb e3                	jmp    8017cd <devcons_write+0x83>

00000000008017ea <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8017ea:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8017ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f2:	48 85 c0             	test   %rax,%rax
  8017f5:	74 55                	je     80184c <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8017f7:	55                   	push   %rbp
  8017f8:	48 89 e5             	mov    %rsp,%rbp
  8017fb:	41 55                	push   %r13
  8017fd:	41 54                	push   %r12
  8017ff:	53                   	push   %rbx
  801800:	48 83 ec 08          	sub    $0x8,%rsp
  801804:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801807:	48 bb 2a 01 80 00 00 	movabs $0x80012a,%rbx
  80180e:	00 00 00 
  801811:	49 bc f7 01 80 00 00 	movabs $0x8001f7,%r12
  801818:	00 00 00 
  80181b:	eb 03                	jmp    801820 <devcons_read+0x36>
  80181d:	41 ff d4             	call   *%r12
  801820:	ff d3                	call   *%rbx
  801822:	85 c0                	test   %eax,%eax
  801824:	74 f7                	je     80181d <devcons_read+0x33>
    if (c < 0) return c;
  801826:	48 63 d0             	movslq %eax,%rdx
  801829:	78 13                	js     80183e <devcons_read+0x54>
    if (c == 0x04) return 0;
  80182b:	ba 00 00 00 00       	mov    $0x0,%edx
  801830:	83 f8 04             	cmp    $0x4,%eax
  801833:	74 09                	je     80183e <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  801835:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801839:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80183e:	48 89 d0             	mov    %rdx,%rax
  801841:	48 83 c4 08          	add    $0x8,%rsp
  801845:	5b                   	pop    %rbx
  801846:	41 5c                	pop    %r12
  801848:	41 5d                	pop    %r13
  80184a:	5d                   	pop    %rbp
  80184b:	c3                   	ret    
  80184c:	48 89 d0             	mov    %rdx,%rax
  80184f:	c3                   	ret    

0000000000801850 <cputchar>:
cputchar(int ch) {
  801850:	55                   	push   %rbp
  801851:	48 89 e5             	mov    %rsp,%rbp
  801854:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801858:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80185c:	be 01 00 00 00       	mov    $0x1,%esi
  801861:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801865:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  80186c:	00 00 00 
  80186f:	ff d0                	call   *%rax
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

0000000000801873 <getchar>:
getchar(void) {
  801873:	55                   	push   %rbp
  801874:	48 89 e5             	mov    %rsp,%rbp
  801877:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  80187b:	ba 01 00 00 00       	mov    $0x1,%edx
  801880:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801884:	bf 00 00 00 00       	mov    $0x0,%edi
  801889:	48 b8 5c 09 80 00 00 	movabs $0x80095c,%rax
  801890:	00 00 00 
  801893:	ff d0                	call   *%rax
  801895:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801897:	85 c0                	test   %eax,%eax
  801899:	78 06                	js     8018a1 <getchar+0x2e>
  80189b:	74 08                	je     8018a5 <getchar+0x32>
  80189d:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8018a1:	89 d0                	mov    %edx,%eax
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8018a5:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8018aa:	eb f5                	jmp    8018a1 <getchar+0x2e>

00000000008018ac <iscons>:
iscons(int fdnum) {
  8018ac:	55                   	push   %rbp
  8018ad:	48 89 e5             	mov    %rsp,%rbp
  8018b0:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8018b4:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018b8:	48 b8 79 06 80 00 00 	movabs $0x800679,%rax
  8018bf:	00 00 00 
  8018c2:	ff d0                	call   *%rax
    if (res < 0) return res;
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	78 18                	js     8018e0 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8018c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018cc:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8018d3:	00 00 00 
  8018d6:	8b 00                	mov    (%rax),%eax
  8018d8:	39 02                	cmp    %eax,(%rdx)
  8018da:	0f 94 c0             	sete   %al
  8018dd:	0f b6 c0             	movzbl %al,%eax
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

00000000008018e2 <opencons>:
opencons(void) {
  8018e2:	55                   	push   %rbp
  8018e3:	48 89 e5             	mov    %rsp,%rbp
  8018e6:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8018ea:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8018ee:	48 b8 19 06 80 00 00 	movabs $0x800619,%rax
  8018f5:	00 00 00 
  8018f8:	ff d0                	call   *%rax
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	78 49                	js     801947 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8018fe:	b9 46 00 00 00       	mov    $0x46,%ecx
  801903:	ba 00 10 00 00       	mov    $0x1000,%edx
  801908:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80190c:	bf 00 00 00 00       	mov    $0x0,%edi
  801911:	48 b8 86 02 80 00 00 	movabs $0x800286,%rax
  801918:	00 00 00 
  80191b:	ff d0                	call   *%rax
  80191d:	85 c0                	test   %eax,%eax
  80191f:	78 26                	js     801947 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  801921:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801925:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  80192c:	00 00 
  80192e:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801930:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801934:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80193b:	48 b8 eb 05 80 00 00 	movabs $0x8005eb,%rax
  801942:	00 00 00 
  801945:	ff d0                	call   *%rax
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

0000000000801949 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801949:	55                   	push   %rbp
  80194a:	48 89 e5             	mov    %rsp,%rbp
  80194d:	41 56                	push   %r14
  80194f:	41 55                	push   %r13
  801951:	41 54                	push   %r12
  801953:	53                   	push   %rbx
  801954:	48 83 ec 50          	sub    $0x50,%rsp
  801958:	49 89 fc             	mov    %rdi,%r12
  80195b:	41 89 f5             	mov    %esi,%r13d
  80195e:	48 89 d3             	mov    %rdx,%rbx
  801961:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801965:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801969:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80196d:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801974:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801978:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80197c:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801980:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801984:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80198b:	00 00 00 
  80198e:	4c 8b 30             	mov    (%rax),%r14
  801991:	48 b8 c6 01 80 00 00 	movabs $0x8001c6,%rax
  801998:	00 00 00 
  80199b:	ff d0                	call   *%rax
  80199d:	89 c6                	mov    %eax,%esi
  80199f:	45 89 e8             	mov    %r13d,%r8d
  8019a2:	4c 89 e1             	mov    %r12,%rcx
  8019a5:	4c 89 f2             	mov    %r14,%rdx
  8019a8:	48 bf 00 2b 80 00 00 	movabs $0x802b00,%rdi
  8019af:	00 00 00 
  8019b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b7:	49 bc 99 1a 80 00 00 	movabs $0x801a99,%r12
  8019be:	00 00 00 
  8019c1:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8019c4:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8019c8:	48 89 df             	mov    %rbx,%rdi
  8019cb:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  8019d2:	00 00 00 
  8019d5:	ff d0                	call   *%rax
    cprintf("\n");
  8019d7:	48 bf 4b 2a 80 00 00 	movabs $0x802a4b,%rdi
  8019de:	00 00 00 
  8019e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e6:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8019e9:	cc                   	int3   
  8019ea:	eb fd                	jmp    8019e9 <_panic+0xa0>

00000000008019ec <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8019ec:	55                   	push   %rbp
  8019ed:	48 89 e5             	mov    %rsp,%rbp
  8019f0:	53                   	push   %rbx
  8019f1:	48 83 ec 08          	sub    $0x8,%rsp
  8019f5:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8019f8:	8b 06                	mov    (%rsi),%eax
  8019fa:	8d 50 01             	lea    0x1(%rax),%edx
  8019fd:	89 16                	mov    %edx,(%rsi)
  8019ff:	48 98                	cltq   
  801a01:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801a06:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801a0c:	74 0a                	je     801a18 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801a0e:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801a12:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  801a18:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801a1c:	be ff 00 00 00       	mov    $0xff,%esi
  801a21:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  801a28:	00 00 00 
  801a2b:	ff d0                	call   *%rax
        state->offset = 0;
  801a2d:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801a33:	eb d9                	jmp    801a0e <putch+0x22>

0000000000801a35 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801a35:	55                   	push   %rbp
  801a36:	48 89 e5             	mov    %rsp,%rbp
  801a39:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801a40:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801a43:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801a4a:	b9 21 00 00 00       	mov    $0x21,%ecx
  801a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a54:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801a57:	48 89 f1             	mov    %rsi,%rcx
  801a5a:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801a61:	48 bf ec 19 80 00 00 	movabs $0x8019ec,%rdi
  801a68:	00 00 00 
  801a6b:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  801a72:	00 00 00 
  801a75:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801a77:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801a7e:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801a85:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  801a8c:	00 00 00 
  801a8f:	ff d0                	call   *%rax

    return state.count;
}
  801a91:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

0000000000801a99 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801a99:	55                   	push   %rbp
  801a9a:	48 89 e5             	mov    %rsp,%rbp
  801a9d:	48 83 ec 50          	sub    $0x50,%rsp
  801aa1:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801aa5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801aa9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801aad:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801ab1:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801ab5:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801abc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ac0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ac4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801ac8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801acc:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801ad0:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  801ad7:	00 00 00 
  801ada:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

0000000000801ade <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801ade:	55                   	push   %rbp
  801adf:	48 89 e5             	mov    %rsp,%rbp
  801ae2:	41 57                	push   %r15
  801ae4:	41 56                	push   %r14
  801ae6:	41 55                	push   %r13
  801ae8:	41 54                	push   %r12
  801aea:	53                   	push   %rbx
  801aeb:	48 83 ec 18          	sub    $0x18,%rsp
  801aef:	49 89 fc             	mov    %rdi,%r12
  801af2:	49 89 f5             	mov    %rsi,%r13
  801af5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801af9:	8b 45 10             	mov    0x10(%rbp),%eax
  801afc:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801aff:	41 89 cf             	mov    %ecx,%r15d
  801b02:	49 39 d7             	cmp    %rdx,%r15
  801b05:	76 5b                	jbe    801b62 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801b07:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801b0b:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801b0f:	85 db                	test   %ebx,%ebx
  801b11:	7e 0e                	jle    801b21 <print_num+0x43>
            putch(padc, put_arg);
  801b13:	4c 89 ee             	mov    %r13,%rsi
  801b16:	44 89 f7             	mov    %r14d,%edi
  801b19:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801b1c:	83 eb 01             	sub    $0x1,%ebx
  801b1f:	75 f2                	jne    801b13 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801b21:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801b25:	48 b9 23 2b 80 00 00 	movabs $0x802b23,%rcx
  801b2c:	00 00 00 
  801b2f:	48 b8 34 2b 80 00 00 	movabs $0x802b34,%rax
  801b36:	00 00 00 
  801b39:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801b3d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b41:	ba 00 00 00 00       	mov    $0x0,%edx
  801b46:	49 f7 f7             	div    %r15
  801b49:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801b4d:	4c 89 ee             	mov    %r13,%rsi
  801b50:	41 ff d4             	call   *%r12
}
  801b53:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801b57:	5b                   	pop    %rbx
  801b58:	41 5c                	pop    %r12
  801b5a:	41 5d                	pop    %r13
  801b5c:	41 5e                	pop    %r14
  801b5e:	41 5f                	pop    %r15
  801b60:	5d                   	pop    %rbp
  801b61:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801b62:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b66:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6b:	49 f7 f7             	div    %r15
  801b6e:	48 83 ec 08          	sub    $0x8,%rsp
  801b72:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801b76:	52                   	push   %rdx
  801b77:	45 0f be c9          	movsbl %r9b,%r9d
  801b7b:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801b7f:	48 89 c2             	mov    %rax,%rdx
  801b82:	48 b8 de 1a 80 00 00 	movabs $0x801ade,%rax
  801b89:	00 00 00 
  801b8c:	ff d0                	call   *%rax
  801b8e:	48 83 c4 10          	add    $0x10,%rsp
  801b92:	eb 8d                	jmp    801b21 <print_num+0x43>

0000000000801b94 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  801b94:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801b98:	48 8b 06             	mov    (%rsi),%rax
  801b9b:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801b9f:	73 0a                	jae    801bab <sprintputch+0x17>
        *state->start++ = ch;
  801ba1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ba5:	48 89 16             	mov    %rdx,(%rsi)
  801ba8:	40 88 38             	mov    %dil,(%rax)
    }
}
  801bab:	c3                   	ret    

0000000000801bac <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801bac:	55                   	push   %rbp
  801bad:	48 89 e5             	mov    %rsp,%rbp
  801bb0:	48 83 ec 50          	sub    $0x50,%rsp
  801bb4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bb8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801bbc:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801bc0:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801bc7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801bcb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801bcf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801bd3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801bd7:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801bdb:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  801be2:	00 00 00 
  801be5:	ff d0                	call   *%rax
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

0000000000801be9 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801be9:	55                   	push   %rbp
  801bea:	48 89 e5             	mov    %rsp,%rbp
  801bed:	41 57                	push   %r15
  801bef:	41 56                	push   %r14
  801bf1:	41 55                	push   %r13
  801bf3:	41 54                	push   %r12
  801bf5:	53                   	push   %rbx
  801bf6:	48 83 ec 48          	sub    $0x48,%rsp
  801bfa:	49 89 fc             	mov    %rdi,%r12
  801bfd:	49 89 f6             	mov    %rsi,%r14
  801c00:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  801c03:	48 8b 01             	mov    (%rcx),%rax
  801c06:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801c0a:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801c0e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801c12:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801c16:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801c1a:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  801c1e:	41 0f b6 3f          	movzbl (%r15),%edi
  801c22:	40 80 ff 25          	cmp    $0x25,%dil
  801c26:	74 18                	je     801c40 <vprintfmt+0x57>
            if (!ch) return;
  801c28:	40 84 ff             	test   %dil,%dil
  801c2b:	0f 84 d1 06 00 00    	je     802302 <vprintfmt+0x719>
            putch(ch, put_arg);
  801c31:	40 0f b6 ff          	movzbl %dil,%edi
  801c35:	4c 89 f6             	mov    %r14,%rsi
  801c38:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  801c3b:	49 89 df             	mov    %rbx,%r15
  801c3e:	eb da                	jmp    801c1a <vprintfmt+0x31>
            precision = va_arg(aq, int);
  801c40:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  801c44:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c49:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  801c4d:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801c52:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801c58:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801c5f:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  801c63:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  801c68:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  801c6e:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  801c72:	44 0f b6 0b          	movzbl (%rbx),%r9d
  801c76:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  801c7a:	3c 57                	cmp    $0x57,%al
  801c7c:	0f 87 65 06 00 00    	ja     8022e7 <vprintfmt+0x6fe>
  801c82:	0f b6 c0             	movzbl %al,%eax
  801c85:	49 ba c0 2c 80 00 00 	movabs $0x802cc0,%r10
  801c8c:	00 00 00 
  801c8f:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  801c93:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  801c96:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  801c9a:	eb d2                	jmp    801c6e <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  801c9c:	4c 89 fb             	mov    %r15,%rbx
  801c9f:	44 89 c1             	mov    %r8d,%ecx
  801ca2:	eb ca                	jmp    801c6e <vprintfmt+0x85>
            padc = ch;
  801ca4:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  801ca8:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801cab:	eb c1                	jmp    801c6e <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801cb0:	83 f8 2f             	cmp    $0x2f,%eax
  801cb3:	77 24                	ja     801cd9 <vprintfmt+0xf0>
  801cb5:	41 89 c1             	mov    %eax,%r9d
  801cb8:	49 01 f1             	add    %rsi,%r9
  801cbb:	83 c0 08             	add    $0x8,%eax
  801cbe:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801cc1:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  801cc4:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  801cc7:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801ccb:	79 a1                	jns    801c6e <vprintfmt+0x85>
                width = precision;
  801ccd:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  801cd1:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801cd7:	eb 95                	jmp    801c6e <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cd9:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  801cdd:	49 8d 41 08          	lea    0x8(%r9),%rax
  801ce1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ce5:	eb da                	jmp    801cc1 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  801ce7:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  801ceb:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801cef:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  801cf3:	3c 39                	cmp    $0x39,%al
  801cf5:	77 1e                	ja     801d15 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  801cf7:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  801cfb:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  801d00:	0f b6 c0             	movzbl %al,%eax
  801d03:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d08:	41 0f b6 07          	movzbl (%r15),%eax
  801d0c:	3c 39                	cmp    $0x39,%al
  801d0e:	76 e7                	jbe    801cf7 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  801d10:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  801d13:	eb b2                	jmp    801cc7 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  801d15:	4c 89 fb             	mov    %r15,%rbx
  801d18:	eb ad                	jmp    801cc7 <vprintfmt+0xde>
            width = MAX(0, width);
  801d1a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801d1d:	85 c0                	test   %eax,%eax
  801d1f:	0f 48 c7             	cmovs  %edi,%eax
  801d22:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801d25:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d28:	e9 41 ff ff ff       	jmp    801c6e <vprintfmt+0x85>
            lflag++;
  801d2d:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801d30:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d33:	e9 36 ff ff ff       	jmp    801c6e <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  801d38:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d3b:	83 f8 2f             	cmp    $0x2f,%eax
  801d3e:	77 18                	ja     801d58 <vprintfmt+0x16f>
  801d40:	89 c2                	mov    %eax,%edx
  801d42:	48 01 f2             	add    %rsi,%rdx
  801d45:	83 c0 08             	add    $0x8,%eax
  801d48:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d4b:	4c 89 f6             	mov    %r14,%rsi
  801d4e:	8b 3a                	mov    (%rdx),%edi
  801d50:	41 ff d4             	call   *%r12
            break;
  801d53:	e9 c2 fe ff ff       	jmp    801c1a <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  801d58:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801d5c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801d60:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d64:	eb e5                	jmp    801d4b <vprintfmt+0x162>
            int err = va_arg(aq, int);
  801d66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d69:	83 f8 2f             	cmp    $0x2f,%eax
  801d6c:	77 5b                	ja     801dc9 <vprintfmt+0x1e0>
  801d6e:	89 c2                	mov    %eax,%edx
  801d70:	48 01 d6             	add    %rdx,%rsi
  801d73:	83 c0 08             	add    $0x8,%eax
  801d76:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d79:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  801d7b:	89 c8                	mov    %ecx,%eax
  801d7d:	c1 f8 1f             	sar    $0x1f,%eax
  801d80:	31 c1                	xor    %eax,%ecx
  801d82:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  801d84:	83 f9 13             	cmp    $0x13,%ecx
  801d87:	7f 4e                	jg     801dd7 <vprintfmt+0x1ee>
  801d89:	48 63 c1             	movslq %ecx,%rax
  801d8c:	48 ba 80 2f 80 00 00 	movabs $0x802f80,%rdx
  801d93:	00 00 00 
  801d96:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801d9a:	48 85 c0             	test   %rax,%rax
  801d9d:	74 38                	je     801dd7 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  801d9f:	48 89 c1             	mov    %rax,%rcx
  801da2:	48 ba b9 2a 80 00 00 	movabs $0x802ab9,%rdx
  801da9:	00 00 00 
  801dac:	4c 89 f6             	mov    %r14,%rsi
  801daf:	4c 89 e7             	mov    %r12,%rdi
  801db2:	b8 00 00 00 00       	mov    $0x0,%eax
  801db7:	49 b8 ac 1b 80 00 00 	movabs $0x801bac,%r8
  801dbe:	00 00 00 
  801dc1:	41 ff d0             	call   *%r8
  801dc4:	e9 51 fe ff ff       	jmp    801c1a <vprintfmt+0x31>
            int err = va_arg(aq, int);
  801dc9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801dcd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801dd1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801dd5:	eb a2                	jmp    801d79 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  801dd7:	48 ba 4c 2b 80 00 00 	movabs $0x802b4c,%rdx
  801dde:	00 00 00 
  801de1:	4c 89 f6             	mov    %r14,%rsi
  801de4:	4c 89 e7             	mov    %r12,%rdi
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dec:	49 b8 ac 1b 80 00 00 	movabs $0x801bac,%r8
  801df3:	00 00 00 
  801df6:	41 ff d0             	call   *%r8
  801df9:	e9 1c fe ff ff       	jmp    801c1a <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  801dfe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801e01:	83 f8 2f             	cmp    $0x2f,%eax
  801e04:	77 55                	ja     801e5b <vprintfmt+0x272>
  801e06:	89 c2                	mov    %eax,%edx
  801e08:	48 01 d6             	add    %rdx,%rsi
  801e0b:	83 c0 08             	add    $0x8,%eax
  801e0e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801e11:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  801e14:	48 85 d2             	test   %rdx,%rdx
  801e17:	48 b8 45 2b 80 00 00 	movabs $0x802b45,%rax
  801e1e:	00 00 00 
  801e21:	48 0f 45 c2          	cmovne %rdx,%rax
  801e25:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  801e29:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801e2d:	7e 06                	jle    801e35 <vprintfmt+0x24c>
  801e2f:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  801e33:	75 34                	jne    801e69 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801e35:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  801e39:	48 8d 58 01          	lea    0x1(%rax),%rbx
  801e3d:	0f b6 00             	movzbl (%rax),%eax
  801e40:	84 c0                	test   %al,%al
  801e42:	0f 84 b2 00 00 00    	je     801efa <vprintfmt+0x311>
  801e48:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  801e4c:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  801e51:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  801e55:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  801e59:	eb 74                	jmp    801ecf <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  801e5b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801e5f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801e63:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e67:	eb a8                	jmp    801e11 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  801e69:	49 63 f5             	movslq %r13d,%rsi
  801e6c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  801e70:	48 b8 bc 23 80 00 00 	movabs $0x8023bc,%rax
  801e77:	00 00 00 
  801e7a:	ff d0                	call   *%rax
  801e7c:	48 89 c2             	mov    %rax,%rdx
  801e7f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801e82:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  801e84:	8d 48 ff             	lea    -0x1(%rax),%ecx
  801e87:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  801e8a:	85 c0                	test   %eax,%eax
  801e8c:	7e a7                	jle    801e35 <vprintfmt+0x24c>
  801e8e:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  801e92:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  801e96:	41 89 cd             	mov    %ecx,%r13d
  801e99:	4c 89 f6             	mov    %r14,%rsi
  801e9c:	89 df                	mov    %ebx,%edi
  801e9e:	41 ff d4             	call   *%r12
  801ea1:	41 83 ed 01          	sub    $0x1,%r13d
  801ea5:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  801ea9:	75 ee                	jne    801e99 <vprintfmt+0x2b0>
  801eab:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  801eaf:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  801eb3:	eb 80                	jmp    801e35 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801eb5:	0f b6 f8             	movzbl %al,%edi
  801eb8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801ebc:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801ebf:	41 83 ef 01          	sub    $0x1,%r15d
  801ec3:	48 83 c3 01          	add    $0x1,%rbx
  801ec7:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  801ecb:	84 c0                	test   %al,%al
  801ecd:	74 1f                	je     801eee <vprintfmt+0x305>
  801ecf:	45 85 ed             	test   %r13d,%r13d
  801ed2:	78 06                	js     801eda <vprintfmt+0x2f1>
  801ed4:	41 83 ed 01          	sub    $0x1,%r13d
  801ed8:	78 46                	js     801f20 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801eda:	45 84 f6             	test   %r14b,%r14b
  801edd:	74 d6                	je     801eb5 <vprintfmt+0x2cc>
  801edf:	8d 50 e0             	lea    -0x20(%rax),%edx
  801ee2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801ee7:	80 fa 5e             	cmp    $0x5e,%dl
  801eea:	77 cc                	ja     801eb8 <vprintfmt+0x2cf>
  801eec:	eb c7                	jmp    801eb5 <vprintfmt+0x2cc>
  801eee:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801ef2:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801ef6:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  801efa:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801efd:	8d 58 ff             	lea    -0x1(%rax),%ebx
  801f00:	85 c0                	test   %eax,%eax
  801f02:	0f 8e 12 fd ff ff    	jle    801c1a <vprintfmt+0x31>
  801f08:	4c 89 f6             	mov    %r14,%rsi
  801f0b:	bf 20 00 00 00       	mov    $0x20,%edi
  801f10:	41 ff d4             	call   *%r12
  801f13:	83 eb 01             	sub    $0x1,%ebx
  801f16:	83 fb ff             	cmp    $0xffffffff,%ebx
  801f19:	75 ed                	jne    801f08 <vprintfmt+0x31f>
  801f1b:	e9 fa fc ff ff       	jmp    801c1a <vprintfmt+0x31>
  801f20:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f24:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f28:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  801f2c:	eb cc                	jmp    801efa <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  801f2e:	45 89 cd             	mov    %r9d,%r13d
  801f31:	84 c9                	test   %cl,%cl
  801f33:	75 25                	jne    801f5a <vprintfmt+0x371>
    switch (lflag) {
  801f35:	85 d2                	test   %edx,%edx
  801f37:	74 57                	je     801f90 <vprintfmt+0x3a7>
  801f39:	83 fa 01             	cmp    $0x1,%edx
  801f3c:	74 78                	je     801fb6 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  801f3e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f41:	83 f8 2f             	cmp    $0x2f,%eax
  801f44:	0f 87 92 00 00 00    	ja     801fdc <vprintfmt+0x3f3>
  801f4a:	89 c2                	mov    %eax,%edx
  801f4c:	48 01 d6             	add    %rdx,%rsi
  801f4f:	83 c0 08             	add    $0x8,%eax
  801f52:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f55:	48 8b 1e             	mov    (%rsi),%rbx
  801f58:	eb 16                	jmp    801f70 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  801f5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f5d:	83 f8 2f             	cmp    $0x2f,%eax
  801f60:	77 20                	ja     801f82 <vprintfmt+0x399>
  801f62:	89 c2                	mov    %eax,%edx
  801f64:	48 01 d6             	add    %rdx,%rsi
  801f67:	83 c0 08             	add    $0x8,%eax
  801f6a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f6d:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  801f70:	48 85 db             	test   %rbx,%rbx
  801f73:	78 78                	js     801fed <vprintfmt+0x404>
            num = i;
  801f75:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  801f78:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  801f7d:	e9 49 02 00 00       	jmp    8021cb <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801f82:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801f86:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801f8a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f8e:	eb dd                	jmp    801f6d <vprintfmt+0x384>
        return va_arg(*ap, int);
  801f90:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f93:	83 f8 2f             	cmp    $0x2f,%eax
  801f96:	77 10                	ja     801fa8 <vprintfmt+0x3bf>
  801f98:	89 c2                	mov    %eax,%edx
  801f9a:	48 01 d6             	add    %rdx,%rsi
  801f9d:	83 c0 08             	add    $0x8,%eax
  801fa0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fa3:	48 63 1e             	movslq (%rsi),%rbx
  801fa6:	eb c8                	jmp    801f70 <vprintfmt+0x387>
  801fa8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fac:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fb0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fb4:	eb ed                	jmp    801fa3 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  801fb6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fb9:	83 f8 2f             	cmp    $0x2f,%eax
  801fbc:	77 10                	ja     801fce <vprintfmt+0x3e5>
  801fbe:	89 c2                	mov    %eax,%edx
  801fc0:	48 01 d6             	add    %rdx,%rsi
  801fc3:	83 c0 08             	add    $0x8,%eax
  801fc6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fc9:	48 8b 1e             	mov    (%rsi),%rbx
  801fcc:	eb a2                	jmp    801f70 <vprintfmt+0x387>
  801fce:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fd2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fd6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fda:	eb ed                	jmp    801fc9 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  801fdc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fe0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fe4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fe8:	e9 68 ff ff ff       	jmp    801f55 <vprintfmt+0x36c>
                putch('-', put_arg);
  801fed:	4c 89 f6             	mov    %r14,%rsi
  801ff0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801ff5:	41 ff d4             	call   *%r12
                i = -i;
  801ff8:	48 f7 db             	neg    %rbx
  801ffb:	e9 75 ff ff ff       	jmp    801f75 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  802000:	45 89 cd             	mov    %r9d,%r13d
  802003:	84 c9                	test   %cl,%cl
  802005:	75 2d                	jne    802034 <vprintfmt+0x44b>
    switch (lflag) {
  802007:	85 d2                	test   %edx,%edx
  802009:	74 57                	je     802062 <vprintfmt+0x479>
  80200b:	83 fa 01             	cmp    $0x1,%edx
  80200e:	74 7f                	je     80208f <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  802010:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802013:	83 f8 2f             	cmp    $0x2f,%eax
  802016:	0f 87 a1 00 00 00    	ja     8020bd <vprintfmt+0x4d4>
  80201c:	89 c2                	mov    %eax,%edx
  80201e:	48 01 d6             	add    %rdx,%rsi
  802021:	83 c0 08             	add    $0x8,%eax
  802024:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802027:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80202a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80202f:	e9 97 01 00 00       	jmp    8021cb <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802034:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802037:	83 f8 2f             	cmp    $0x2f,%eax
  80203a:	77 18                	ja     802054 <vprintfmt+0x46b>
  80203c:	89 c2                	mov    %eax,%edx
  80203e:	48 01 d6             	add    %rdx,%rsi
  802041:	83 c0 08             	add    $0x8,%eax
  802044:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802047:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80204a:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80204f:	e9 77 01 00 00       	jmp    8021cb <vprintfmt+0x5e2>
  802054:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802058:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80205c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802060:	eb e5                	jmp    802047 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  802062:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802065:	83 f8 2f             	cmp    $0x2f,%eax
  802068:	77 17                	ja     802081 <vprintfmt+0x498>
  80206a:	89 c2                	mov    %eax,%edx
  80206c:	48 01 d6             	add    %rdx,%rsi
  80206f:	83 c0 08             	add    $0x8,%eax
  802072:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802075:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  802077:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  80207c:	e9 4a 01 00 00       	jmp    8021cb <vprintfmt+0x5e2>
  802081:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802085:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802089:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80208d:	eb e6                	jmp    802075 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  80208f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802092:	83 f8 2f             	cmp    $0x2f,%eax
  802095:	77 18                	ja     8020af <vprintfmt+0x4c6>
  802097:	89 c2                	mov    %eax,%edx
  802099:	48 01 d6             	add    %rdx,%rsi
  80209c:	83 c0 08             	add    $0x8,%eax
  80209f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020a2:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8020a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8020aa:	e9 1c 01 00 00       	jmp    8021cb <vprintfmt+0x5e2>
  8020af:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020b3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020b7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020bb:	eb e5                	jmp    8020a2 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8020bd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020c1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020c5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020c9:	e9 59 ff ff ff       	jmp    802027 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8020ce:	45 89 cd             	mov    %r9d,%r13d
  8020d1:	84 c9                	test   %cl,%cl
  8020d3:	75 2d                	jne    802102 <vprintfmt+0x519>
    switch (lflag) {
  8020d5:	85 d2                	test   %edx,%edx
  8020d7:	74 57                	je     802130 <vprintfmt+0x547>
  8020d9:	83 fa 01             	cmp    $0x1,%edx
  8020dc:	74 7c                	je     80215a <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8020de:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020e1:	83 f8 2f             	cmp    $0x2f,%eax
  8020e4:	0f 87 9b 00 00 00    	ja     802185 <vprintfmt+0x59c>
  8020ea:	89 c2                	mov    %eax,%edx
  8020ec:	48 01 d6             	add    %rdx,%rsi
  8020ef:	83 c0 08             	add    $0x8,%eax
  8020f2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020f5:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8020f8:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8020fd:	e9 c9 00 00 00       	jmp    8021cb <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802102:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802105:	83 f8 2f             	cmp    $0x2f,%eax
  802108:	77 18                	ja     802122 <vprintfmt+0x539>
  80210a:	89 c2                	mov    %eax,%edx
  80210c:	48 01 d6             	add    %rdx,%rsi
  80210f:	83 c0 08             	add    $0x8,%eax
  802112:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802115:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802118:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80211d:	e9 a9 00 00 00       	jmp    8021cb <vprintfmt+0x5e2>
  802122:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802126:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80212a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80212e:	eb e5                	jmp    802115 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  802130:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802133:	83 f8 2f             	cmp    $0x2f,%eax
  802136:	77 14                	ja     80214c <vprintfmt+0x563>
  802138:	89 c2                	mov    %eax,%edx
  80213a:	48 01 d6             	add    %rdx,%rsi
  80213d:	83 c0 08             	add    $0x8,%eax
  802140:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802143:	8b 16                	mov    (%rsi),%edx
            base = 8;
  802145:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80214a:	eb 7f                	jmp    8021cb <vprintfmt+0x5e2>
  80214c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802150:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802154:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802158:	eb e9                	jmp    802143 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  80215a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80215d:	83 f8 2f             	cmp    $0x2f,%eax
  802160:	77 15                	ja     802177 <vprintfmt+0x58e>
  802162:	89 c2                	mov    %eax,%edx
  802164:	48 01 d6             	add    %rdx,%rsi
  802167:	83 c0 08             	add    $0x8,%eax
  80216a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80216d:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802170:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  802175:	eb 54                	jmp    8021cb <vprintfmt+0x5e2>
  802177:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80217b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80217f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802183:	eb e8                	jmp    80216d <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  802185:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802189:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80218d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802191:	e9 5f ff ff ff       	jmp    8020f5 <vprintfmt+0x50c>
            putch('0', put_arg);
  802196:	45 89 cd             	mov    %r9d,%r13d
  802199:	4c 89 f6             	mov    %r14,%rsi
  80219c:	bf 30 00 00 00       	mov    $0x30,%edi
  8021a1:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8021a4:	4c 89 f6             	mov    %r14,%rsi
  8021a7:	bf 78 00 00 00       	mov    $0x78,%edi
  8021ac:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8021af:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021b2:	83 f8 2f             	cmp    $0x2f,%eax
  8021b5:	77 47                	ja     8021fe <vprintfmt+0x615>
  8021b7:	89 c2                	mov    %eax,%edx
  8021b9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021bd:	83 c0 08             	add    $0x8,%eax
  8021c0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021c3:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8021c6:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8021cb:	48 83 ec 08          	sub    $0x8,%rsp
  8021cf:	41 80 fd 58          	cmp    $0x58,%r13b
  8021d3:	0f 94 c0             	sete   %al
  8021d6:	0f b6 c0             	movzbl %al,%eax
  8021d9:	50                   	push   %rax
  8021da:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  8021df:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8021e3:	4c 89 f6             	mov    %r14,%rsi
  8021e6:	4c 89 e7             	mov    %r12,%rdi
  8021e9:	48 b8 de 1a 80 00 00 	movabs $0x801ade,%rax
  8021f0:	00 00 00 
  8021f3:	ff d0                	call   *%rax
            break;
  8021f5:	48 83 c4 10          	add    $0x10,%rsp
  8021f9:	e9 1c fa ff ff       	jmp    801c1a <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  8021fe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802202:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802206:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80220a:	eb b7                	jmp    8021c3 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  80220c:	45 89 cd             	mov    %r9d,%r13d
  80220f:	84 c9                	test   %cl,%cl
  802211:	75 2a                	jne    80223d <vprintfmt+0x654>
    switch (lflag) {
  802213:	85 d2                	test   %edx,%edx
  802215:	74 54                	je     80226b <vprintfmt+0x682>
  802217:	83 fa 01             	cmp    $0x1,%edx
  80221a:	74 7c                	je     802298 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  80221c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80221f:	83 f8 2f             	cmp    $0x2f,%eax
  802222:	0f 87 9e 00 00 00    	ja     8022c6 <vprintfmt+0x6dd>
  802228:	89 c2                	mov    %eax,%edx
  80222a:	48 01 d6             	add    %rdx,%rsi
  80222d:	83 c0 08             	add    $0x8,%eax
  802230:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802233:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802236:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  80223b:	eb 8e                	jmp    8021cb <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80223d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802240:	83 f8 2f             	cmp    $0x2f,%eax
  802243:	77 18                	ja     80225d <vprintfmt+0x674>
  802245:	89 c2                	mov    %eax,%edx
  802247:	48 01 d6             	add    %rdx,%rsi
  80224a:	83 c0 08             	add    $0x8,%eax
  80224d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802250:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802253:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802258:	e9 6e ff ff ff       	jmp    8021cb <vprintfmt+0x5e2>
  80225d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802261:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802265:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802269:	eb e5                	jmp    802250 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  80226b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80226e:	83 f8 2f             	cmp    $0x2f,%eax
  802271:	77 17                	ja     80228a <vprintfmt+0x6a1>
  802273:	89 c2                	mov    %eax,%edx
  802275:	48 01 d6             	add    %rdx,%rsi
  802278:	83 c0 08             	add    $0x8,%eax
  80227b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80227e:	8b 16                	mov    (%rsi),%edx
            base = 16;
  802280:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  802285:	e9 41 ff ff ff       	jmp    8021cb <vprintfmt+0x5e2>
  80228a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80228e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802292:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802296:	eb e6                	jmp    80227e <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  802298:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80229b:	83 f8 2f             	cmp    $0x2f,%eax
  80229e:	77 18                	ja     8022b8 <vprintfmt+0x6cf>
  8022a0:	89 c2                	mov    %eax,%edx
  8022a2:	48 01 d6             	add    %rdx,%rsi
  8022a5:	83 c0 08             	add    $0x8,%eax
  8022a8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022ab:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8022ae:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8022b3:	e9 13 ff ff ff       	jmp    8021cb <vprintfmt+0x5e2>
  8022b8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022bc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022c0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022c4:	eb e5                	jmp    8022ab <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  8022c6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022ca:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022ce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022d2:	e9 5c ff ff ff       	jmp    802233 <vprintfmt+0x64a>
            putch(ch, put_arg);
  8022d7:	4c 89 f6             	mov    %r14,%rsi
  8022da:	bf 25 00 00 00       	mov    $0x25,%edi
  8022df:	41 ff d4             	call   *%r12
            break;
  8022e2:	e9 33 f9 ff ff       	jmp    801c1a <vprintfmt+0x31>
            putch('%', put_arg);
  8022e7:	4c 89 f6             	mov    %r14,%rsi
  8022ea:	bf 25 00 00 00       	mov    $0x25,%edi
  8022ef:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  8022f2:	49 83 ef 01          	sub    $0x1,%r15
  8022f6:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  8022fb:	75 f5                	jne    8022f2 <vprintfmt+0x709>
  8022fd:	e9 18 f9 ff ff       	jmp    801c1a <vprintfmt+0x31>
}
  802302:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802306:	5b                   	pop    %rbx
  802307:	41 5c                	pop    %r12
  802309:	41 5d                	pop    %r13
  80230b:	41 5e                	pop    %r14
  80230d:	41 5f                	pop    %r15
  80230f:	5d                   	pop    %rbp
  802310:	c3                   	ret    

0000000000802311 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  802311:	55                   	push   %rbp
  802312:	48 89 e5             	mov    %rsp,%rbp
  802315:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  802319:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80231d:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  802322:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802326:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  80232d:	48 85 ff             	test   %rdi,%rdi
  802330:	74 2b                	je     80235d <vsnprintf+0x4c>
  802332:	48 85 f6             	test   %rsi,%rsi
  802335:	74 26                	je     80235d <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  802337:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80233b:	48 bf 94 1b 80 00 00 	movabs $0x801b94,%rdi
  802342:	00 00 00 
  802345:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  80234c:	00 00 00 
  80234f:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  802351:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802355:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  802358:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  80235d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802362:	eb f7                	jmp    80235b <vsnprintf+0x4a>

0000000000802364 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  802364:	55                   	push   %rbp
  802365:	48 89 e5             	mov    %rsp,%rbp
  802368:	48 83 ec 50          	sub    $0x50,%rsp
  80236c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802370:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802374:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802378:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80237f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802383:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802387:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80238b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  80238f:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  802393:	48 b8 11 23 80 00 00 	movabs $0x802311,%rax
  80239a:	00 00 00 
  80239d:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

00000000008023a1 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  8023a1:	80 3f 00             	cmpb   $0x0,(%rdi)
  8023a4:	74 10                	je     8023b6 <strlen+0x15>
    size_t n = 0;
  8023a6:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8023ab:	48 83 c0 01          	add    $0x1,%rax
  8023af:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023b3:	75 f6                	jne    8023ab <strlen+0xa>
  8023b5:	c3                   	ret    
    size_t n = 0;
  8023b6:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  8023bb:	c3                   	ret    

00000000008023bc <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  8023bc:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  8023c1:	48 85 f6             	test   %rsi,%rsi
  8023c4:	74 10                	je     8023d6 <strnlen+0x1a>
  8023c6:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023ca:	74 09                	je     8023d5 <strnlen+0x19>
  8023cc:	48 83 c0 01          	add    $0x1,%rax
  8023d0:	48 39 c6             	cmp    %rax,%rsi
  8023d3:	75 f1                	jne    8023c6 <strnlen+0xa>
    return n;
}
  8023d5:	c3                   	ret    
    size_t n = 0;
  8023d6:	48 89 f0             	mov    %rsi,%rax
  8023d9:	c3                   	ret    

00000000008023da <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8023da:	b8 00 00 00 00       	mov    $0x0,%eax
  8023df:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  8023e3:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  8023e6:	48 83 c0 01          	add    $0x1,%rax
  8023ea:	84 d2                	test   %dl,%dl
  8023ec:	75 f1                	jne    8023df <strcpy+0x5>
        ;
    return res;
}
  8023ee:	48 89 f8             	mov    %rdi,%rax
  8023f1:	c3                   	ret    

00000000008023f2 <strcat>:

char *
strcat(char *dst, const char *src) {
  8023f2:	55                   	push   %rbp
  8023f3:	48 89 e5             	mov    %rsp,%rbp
  8023f6:	41 54                	push   %r12
  8023f8:	53                   	push   %rbx
  8023f9:	48 89 fb             	mov    %rdi,%rbx
  8023fc:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8023ff:	48 b8 a1 23 80 00 00 	movabs $0x8023a1,%rax
  802406:	00 00 00 
  802409:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  80240b:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  80240f:	4c 89 e6             	mov    %r12,%rsi
  802412:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  802419:	00 00 00 
  80241c:	ff d0                	call   *%rax
    return dst;
}
  80241e:	48 89 d8             	mov    %rbx,%rax
  802421:	5b                   	pop    %rbx
  802422:	41 5c                	pop    %r12
  802424:	5d                   	pop    %rbp
  802425:	c3                   	ret    

0000000000802426 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  802426:	48 85 d2             	test   %rdx,%rdx
  802429:	74 1d                	je     802448 <strncpy+0x22>
  80242b:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80242f:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  802432:	48 83 c0 01          	add    $0x1,%rax
  802436:	0f b6 16             	movzbl (%rsi),%edx
  802439:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  80243c:	80 fa 01             	cmp    $0x1,%dl
  80243f:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  802443:	48 39 c1             	cmp    %rax,%rcx
  802446:	75 ea                	jne    802432 <strncpy+0xc>
    }
    return ret;
}
  802448:	48 89 f8             	mov    %rdi,%rax
  80244b:	c3                   	ret    

000000000080244c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  80244c:	48 89 f8             	mov    %rdi,%rax
  80244f:	48 85 d2             	test   %rdx,%rdx
  802452:	74 24                	je     802478 <strlcpy+0x2c>
        while (--size > 0 && *src)
  802454:	48 83 ea 01          	sub    $0x1,%rdx
  802458:	74 1b                	je     802475 <strlcpy+0x29>
  80245a:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80245e:	0f b6 16             	movzbl (%rsi),%edx
  802461:	84 d2                	test   %dl,%dl
  802463:	74 10                	je     802475 <strlcpy+0x29>
            *dst++ = *src++;
  802465:	48 83 c6 01          	add    $0x1,%rsi
  802469:	48 83 c0 01          	add    $0x1,%rax
  80246d:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  802470:	48 39 c8             	cmp    %rcx,%rax
  802473:	75 e9                	jne    80245e <strlcpy+0x12>
        *dst = '\0';
  802475:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802478:	48 29 f8             	sub    %rdi,%rax
}
  80247b:	c3                   	ret    

000000000080247c <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  80247c:	0f b6 07             	movzbl (%rdi),%eax
  80247f:	84 c0                	test   %al,%al
  802481:	74 13                	je     802496 <strcmp+0x1a>
  802483:	38 06                	cmp    %al,(%rsi)
  802485:	75 0f                	jne    802496 <strcmp+0x1a>
  802487:	48 83 c7 01          	add    $0x1,%rdi
  80248b:	48 83 c6 01          	add    $0x1,%rsi
  80248f:	0f b6 07             	movzbl (%rdi),%eax
  802492:	84 c0                	test   %al,%al
  802494:	75 ed                	jne    802483 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  802496:	0f b6 c0             	movzbl %al,%eax
  802499:	0f b6 16             	movzbl (%rsi),%edx
  80249c:	29 d0                	sub    %edx,%eax
}
  80249e:	c3                   	ret    

000000000080249f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  80249f:	48 85 d2             	test   %rdx,%rdx
  8024a2:	74 1f                	je     8024c3 <strncmp+0x24>
  8024a4:	0f b6 07             	movzbl (%rdi),%eax
  8024a7:	84 c0                	test   %al,%al
  8024a9:	74 1e                	je     8024c9 <strncmp+0x2a>
  8024ab:	3a 06                	cmp    (%rsi),%al
  8024ad:	75 1a                	jne    8024c9 <strncmp+0x2a>
  8024af:	48 83 c7 01          	add    $0x1,%rdi
  8024b3:	48 83 c6 01          	add    $0x1,%rsi
  8024b7:	48 83 ea 01          	sub    $0x1,%rdx
  8024bb:	75 e7                	jne    8024a4 <strncmp+0x5>

    if (!n) return 0;
  8024bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c2:	c3                   	ret    
  8024c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c8:	c3                   	ret    
  8024c9:	48 85 d2             	test   %rdx,%rdx
  8024cc:	74 09                	je     8024d7 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  8024ce:	0f b6 07             	movzbl (%rdi),%eax
  8024d1:	0f b6 16             	movzbl (%rsi),%edx
  8024d4:	29 d0                	sub    %edx,%eax
  8024d6:	c3                   	ret    
    if (!n) return 0;
  8024d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024dc:	c3                   	ret    

00000000008024dd <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  8024dd:	0f b6 07             	movzbl (%rdi),%eax
  8024e0:	84 c0                	test   %al,%al
  8024e2:	74 18                	je     8024fc <strchr+0x1f>
        if (*str == c) {
  8024e4:	0f be c0             	movsbl %al,%eax
  8024e7:	39 f0                	cmp    %esi,%eax
  8024e9:	74 17                	je     802502 <strchr+0x25>
    for (; *str; str++) {
  8024eb:	48 83 c7 01          	add    $0x1,%rdi
  8024ef:	0f b6 07             	movzbl (%rdi),%eax
  8024f2:	84 c0                	test   %al,%al
  8024f4:	75 ee                	jne    8024e4 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  8024f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fb:	c3                   	ret    
  8024fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802501:	c3                   	ret    
  802502:	48 89 f8             	mov    %rdi,%rax
}
  802505:	c3                   	ret    

0000000000802506 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  802506:	0f b6 07             	movzbl (%rdi),%eax
  802509:	84 c0                	test   %al,%al
  80250b:	74 16                	je     802523 <strfind+0x1d>
  80250d:	0f be c0             	movsbl %al,%eax
  802510:	39 f0                	cmp    %esi,%eax
  802512:	74 13                	je     802527 <strfind+0x21>
  802514:	48 83 c7 01          	add    $0x1,%rdi
  802518:	0f b6 07             	movzbl (%rdi),%eax
  80251b:	84 c0                	test   %al,%al
  80251d:	75 ee                	jne    80250d <strfind+0x7>
  80251f:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  802522:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  802523:	48 89 f8             	mov    %rdi,%rax
  802526:	c3                   	ret    
  802527:	48 89 f8             	mov    %rdi,%rax
  80252a:	c3                   	ret    

000000000080252b <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80252b:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80252e:	48 89 f8             	mov    %rdi,%rax
  802531:	48 f7 d8             	neg    %rax
  802534:	83 e0 07             	and    $0x7,%eax
  802537:	49 89 d1             	mov    %rdx,%r9
  80253a:	49 29 c1             	sub    %rax,%r9
  80253d:	78 32                	js     802571 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80253f:	40 0f b6 c6          	movzbl %sil,%eax
  802543:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  80254a:	01 01 01 
  80254d:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  802551:	40 f6 c7 07          	test   $0x7,%dil
  802555:	75 34                	jne    80258b <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  802557:	4c 89 c9             	mov    %r9,%rcx
  80255a:	48 c1 f9 03          	sar    $0x3,%rcx
  80255e:	74 08                	je     802568 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  802560:	fc                   	cld    
  802561:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802564:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802568:	4d 85 c9             	test   %r9,%r9
  80256b:	75 45                	jne    8025b2 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80256d:	4c 89 c0             	mov    %r8,%rax
  802570:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  802571:	48 85 d2             	test   %rdx,%rdx
  802574:	74 f7                	je     80256d <memset+0x42>
  802576:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  802579:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80257c:	48 83 c0 01          	add    $0x1,%rax
  802580:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  802584:	48 39 c2             	cmp    %rax,%rdx
  802587:	75 f3                	jne    80257c <memset+0x51>
  802589:	eb e2                	jmp    80256d <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  80258b:	40 f6 c7 01          	test   $0x1,%dil
  80258f:	74 06                	je     802597 <memset+0x6c>
  802591:	88 07                	mov    %al,(%rdi)
  802593:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  802597:	40 f6 c7 02          	test   $0x2,%dil
  80259b:	74 07                	je     8025a4 <memset+0x79>
  80259d:	66 89 07             	mov    %ax,(%rdi)
  8025a0:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025a4:	40 f6 c7 04          	test   $0x4,%dil
  8025a8:	74 ad                	je     802557 <memset+0x2c>
  8025aa:	89 07                	mov    %eax,(%rdi)
  8025ac:	48 83 c7 04          	add    $0x4,%rdi
  8025b0:	eb a5                	jmp    802557 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025b2:	41 f6 c1 04          	test   $0x4,%r9b
  8025b6:	74 06                	je     8025be <memset+0x93>
  8025b8:	89 07                	mov    %eax,(%rdi)
  8025ba:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025be:	41 f6 c1 02          	test   $0x2,%r9b
  8025c2:	74 07                	je     8025cb <memset+0xa0>
  8025c4:	66 89 07             	mov    %ax,(%rdi)
  8025c7:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8025cb:	41 f6 c1 01          	test   $0x1,%r9b
  8025cf:	74 9c                	je     80256d <memset+0x42>
  8025d1:	88 07                	mov    %al,(%rdi)
  8025d3:	eb 98                	jmp    80256d <memset+0x42>

00000000008025d5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8025d5:	48 89 f8             	mov    %rdi,%rax
  8025d8:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8025db:	48 39 fe             	cmp    %rdi,%rsi
  8025de:	73 39                	jae    802619 <memmove+0x44>
  8025e0:	48 01 f2             	add    %rsi,%rdx
  8025e3:	48 39 fa             	cmp    %rdi,%rdx
  8025e6:	76 31                	jbe    802619 <memmove+0x44>
        s += n;
        d += n;
  8025e8:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8025eb:	48 89 d6             	mov    %rdx,%rsi
  8025ee:	48 09 fe             	or     %rdi,%rsi
  8025f1:	48 09 ce             	or     %rcx,%rsi
  8025f4:	40 f6 c6 07          	test   $0x7,%sil
  8025f8:	75 12                	jne    80260c <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8025fa:	48 83 ef 08          	sub    $0x8,%rdi
  8025fe:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  802602:	48 c1 e9 03          	shr    $0x3,%rcx
  802606:	fd                   	std    
  802607:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80260a:	fc                   	cld    
  80260b:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80260c:	48 83 ef 01          	sub    $0x1,%rdi
  802610:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  802614:	fd                   	std    
  802615:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  802617:	eb f1                	jmp    80260a <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802619:	48 89 f2             	mov    %rsi,%rdx
  80261c:	48 09 c2             	or     %rax,%rdx
  80261f:	48 09 ca             	or     %rcx,%rdx
  802622:	f6 c2 07             	test   $0x7,%dl
  802625:	75 0c                	jne    802633 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  802627:	48 c1 e9 03          	shr    $0x3,%rcx
  80262b:	48 89 c7             	mov    %rax,%rdi
  80262e:	fc                   	cld    
  80262f:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  802632:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  802633:	48 89 c7             	mov    %rax,%rdi
  802636:	fc                   	cld    
  802637:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  802639:	c3                   	ret    

000000000080263a <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  80263a:	55                   	push   %rbp
  80263b:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80263e:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  802645:	00 00 00 
  802648:	ff d0                	call   *%rax
}
  80264a:	5d                   	pop    %rbp
  80264b:	c3                   	ret    

000000000080264c <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80264c:	55                   	push   %rbp
  80264d:	48 89 e5             	mov    %rsp,%rbp
  802650:	41 57                	push   %r15
  802652:	41 56                	push   %r14
  802654:	41 55                	push   %r13
  802656:	41 54                	push   %r12
  802658:	53                   	push   %rbx
  802659:	48 83 ec 08          	sub    $0x8,%rsp
  80265d:	49 89 fe             	mov    %rdi,%r14
  802660:	49 89 f7             	mov    %rsi,%r15
  802663:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  802666:	48 89 f7             	mov    %rsi,%rdi
  802669:	48 b8 a1 23 80 00 00 	movabs $0x8023a1,%rax
  802670:	00 00 00 
  802673:	ff d0                	call   *%rax
  802675:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  802678:	48 89 de             	mov    %rbx,%rsi
  80267b:	4c 89 f7             	mov    %r14,%rdi
  80267e:	48 b8 bc 23 80 00 00 	movabs $0x8023bc,%rax
  802685:	00 00 00 
  802688:	ff d0                	call   *%rax
  80268a:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80268d:	48 39 c3             	cmp    %rax,%rbx
  802690:	74 36                	je     8026c8 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  802692:	48 89 d8             	mov    %rbx,%rax
  802695:	4c 29 e8             	sub    %r13,%rax
  802698:	4c 39 e0             	cmp    %r12,%rax
  80269b:	76 30                	jbe    8026cd <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  80269d:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8026a2:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026a6:	4c 89 fe             	mov    %r15,%rsi
  8026a9:	48 b8 3a 26 80 00 00 	movabs $0x80263a,%rax
  8026b0:	00 00 00 
  8026b3:	ff d0                	call   *%rax
    return dstlen + srclen;
  8026b5:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8026b9:	48 83 c4 08          	add    $0x8,%rsp
  8026bd:	5b                   	pop    %rbx
  8026be:	41 5c                	pop    %r12
  8026c0:	41 5d                	pop    %r13
  8026c2:	41 5e                	pop    %r14
  8026c4:	41 5f                	pop    %r15
  8026c6:	5d                   	pop    %rbp
  8026c7:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8026c8:	4c 01 e0             	add    %r12,%rax
  8026cb:	eb ec                	jmp    8026b9 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8026cd:	48 83 eb 01          	sub    $0x1,%rbx
  8026d1:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026d5:	48 89 da             	mov    %rbx,%rdx
  8026d8:	4c 89 fe             	mov    %r15,%rsi
  8026db:	48 b8 3a 26 80 00 00 	movabs $0x80263a,%rax
  8026e2:	00 00 00 
  8026e5:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8026e7:	49 01 de             	add    %rbx,%r14
  8026ea:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8026ef:	eb c4                	jmp    8026b5 <strlcat+0x69>

00000000008026f1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8026f1:	49 89 f0             	mov    %rsi,%r8
  8026f4:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8026f7:	48 85 d2             	test   %rdx,%rdx
  8026fa:	74 2a                	je     802726 <memcmp+0x35>
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  802701:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  802705:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80270a:	38 ca                	cmp    %cl,%dl
  80270c:	75 0f                	jne    80271d <memcmp+0x2c>
    while (n-- > 0) {
  80270e:	48 83 c0 01          	add    $0x1,%rax
  802712:	48 39 c6             	cmp    %rax,%rsi
  802715:	75 ea                	jne    802701 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  802717:	b8 00 00 00 00       	mov    $0x0,%eax
  80271c:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  80271d:	0f b6 c2             	movzbl %dl,%eax
  802720:	0f b6 c9             	movzbl %cl,%ecx
  802723:	29 c8                	sub    %ecx,%eax
  802725:	c3                   	ret    
    return 0;
  802726:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80272b:	c3                   	ret    

000000000080272c <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80272c:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802730:	48 39 c7             	cmp    %rax,%rdi
  802733:	73 0f                	jae    802744 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802735:	40 38 37             	cmp    %sil,(%rdi)
  802738:	74 0e                	je     802748 <memfind+0x1c>
    for (; src < end; src++) {
  80273a:	48 83 c7 01          	add    $0x1,%rdi
  80273e:	48 39 f8             	cmp    %rdi,%rax
  802741:	75 f2                	jne    802735 <memfind+0x9>
  802743:	c3                   	ret    
  802744:	48 89 f8             	mov    %rdi,%rax
  802747:	c3                   	ret    
  802748:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80274b:	c3                   	ret    

000000000080274c <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80274c:	49 89 f2             	mov    %rsi,%r10
  80274f:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802752:	0f b6 37             	movzbl (%rdi),%esi
  802755:	40 80 fe 20          	cmp    $0x20,%sil
  802759:	74 06                	je     802761 <strtol+0x15>
  80275b:	40 80 fe 09          	cmp    $0x9,%sil
  80275f:	75 13                	jne    802774 <strtol+0x28>
  802761:	48 83 c7 01          	add    $0x1,%rdi
  802765:	0f b6 37             	movzbl (%rdi),%esi
  802768:	40 80 fe 20          	cmp    $0x20,%sil
  80276c:	74 f3                	je     802761 <strtol+0x15>
  80276e:	40 80 fe 09          	cmp    $0x9,%sil
  802772:	74 ed                	je     802761 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802774:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802777:	83 e0 fd             	and    $0xfffffffd,%eax
  80277a:	3c 01                	cmp    $0x1,%al
  80277c:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802780:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  802787:	75 11                	jne    80279a <strtol+0x4e>
  802789:	80 3f 30             	cmpb   $0x30,(%rdi)
  80278c:	74 16                	je     8027a4 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80278e:	45 85 c0             	test   %r8d,%r8d
  802791:	b8 0a 00 00 00       	mov    $0xa,%eax
  802796:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  80279a:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80279f:	4d 63 c8             	movslq %r8d,%r9
  8027a2:	eb 38                	jmp    8027dc <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8027a4:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8027a8:	74 11                	je     8027bb <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8027aa:	45 85 c0             	test   %r8d,%r8d
  8027ad:	75 eb                	jne    80279a <strtol+0x4e>
        s++;
  8027af:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8027b3:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8027b9:	eb df                	jmp    80279a <strtol+0x4e>
        s += 2;
  8027bb:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8027bf:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8027c5:	eb d3                	jmp    80279a <strtol+0x4e>
            dig -= '0';
  8027c7:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8027ca:	0f b6 c8             	movzbl %al,%ecx
  8027cd:	44 39 c1             	cmp    %r8d,%ecx
  8027d0:	7d 1f                	jge    8027f1 <strtol+0xa5>
        val = val * base + dig;
  8027d2:	49 0f af d1          	imul   %r9,%rdx
  8027d6:	0f b6 c0             	movzbl %al,%eax
  8027d9:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8027dc:	48 83 c7 01          	add    $0x1,%rdi
  8027e0:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8027e4:	3c 39                	cmp    $0x39,%al
  8027e6:	76 df                	jbe    8027c7 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8027e8:	3c 7b                	cmp    $0x7b,%al
  8027ea:	77 05                	ja     8027f1 <strtol+0xa5>
            dig -= 'a' - 10;
  8027ec:	83 e8 57             	sub    $0x57,%eax
  8027ef:	eb d9                	jmp    8027ca <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8027f1:	4d 85 d2             	test   %r10,%r10
  8027f4:	74 03                	je     8027f9 <strtol+0xad>
  8027f6:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8027f9:	48 89 d0             	mov    %rdx,%rax
  8027fc:	48 f7 d8             	neg    %rax
  8027ff:	40 80 fe 2d          	cmp    $0x2d,%sil
  802803:	48 0f 44 d0          	cmove  %rax,%rdx
}
  802807:	48 89 d0             	mov    %rdx,%rax
  80280a:	c3                   	ret    

000000000080280b <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80280b:	55                   	push   %rbp
  80280c:	48 89 e5             	mov    %rsp,%rbp
  80280f:	41 54                	push   %r12
  802811:	53                   	push   %rbx
  802812:	48 89 fb             	mov    %rdi,%rbx
  802815:	48 89 f7             	mov    %rsi,%rdi
  802818:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  80281b:	48 85 f6             	test   %rsi,%rsi
  80281e:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802825:	00 00 00 
  802828:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  80282c:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802831:	48 85 d2             	test   %rdx,%rdx
  802834:	74 02                	je     802838 <ipc_recv+0x2d>
  802836:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802838:	48 63 f6             	movslq %esi,%rsi
  80283b:	48 b8 20 05 80 00 00 	movabs $0x800520,%rax
  802842:	00 00 00 
  802845:	ff d0                	call   *%rax

    if (res < 0) {
  802847:	85 c0                	test   %eax,%eax
  802849:	78 45                	js     802890 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  80284b:	48 85 db             	test   %rbx,%rbx
  80284e:	74 12                	je     802862 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802850:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802857:	00 00 00 
  80285a:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802860:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802862:	4d 85 e4             	test   %r12,%r12
  802865:	74 14                	je     80287b <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802867:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80286e:	00 00 00 
  802871:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802877:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  80287b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802882:	00 00 00 
  802885:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  80288b:	5b                   	pop    %rbx
  80288c:	41 5c                	pop    %r12
  80288e:	5d                   	pop    %rbp
  80288f:	c3                   	ret    
        if (from_env_store)
  802890:	48 85 db             	test   %rbx,%rbx
  802893:	74 06                	je     80289b <ipc_recv+0x90>
            *from_env_store = 0;
  802895:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  80289b:	4d 85 e4             	test   %r12,%r12
  80289e:	74 eb                	je     80288b <ipc_recv+0x80>
            *perm_store = 0;
  8028a0:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028a7:	00 
  8028a8:	eb e1                	jmp    80288b <ipc_recv+0x80>

00000000008028aa <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028aa:	55                   	push   %rbp
  8028ab:	48 89 e5             	mov    %rsp,%rbp
  8028ae:	41 57                	push   %r15
  8028b0:	41 56                	push   %r14
  8028b2:	41 55                	push   %r13
  8028b4:	41 54                	push   %r12
  8028b6:	53                   	push   %rbx
  8028b7:	48 83 ec 18          	sub    $0x18,%rsp
  8028bb:	41 89 fd             	mov    %edi,%r13d
  8028be:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028c1:	48 89 d3             	mov    %rdx,%rbx
  8028c4:	49 89 cc             	mov    %rcx,%r12
  8028c7:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028cb:	48 85 d2             	test   %rdx,%rdx
  8028ce:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8028d5:	00 00 00 
  8028d8:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028dc:	49 be f4 04 80 00 00 	movabs $0x8004f4,%r14
  8028e3:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  8028e6:	49 bf f7 01 80 00 00 	movabs $0x8001f7,%r15
  8028ed:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028f0:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8028f3:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  8028f7:	4c 89 e1             	mov    %r12,%rcx
  8028fa:	48 89 da             	mov    %rbx,%rdx
  8028fd:	44 89 ef             	mov    %r13d,%edi
  802900:	41 ff d6             	call   *%r14
  802903:	85 c0                	test   %eax,%eax
  802905:	79 37                	jns    80293e <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802907:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80290a:	75 05                	jne    802911 <ipc_send+0x67>
          sys_yield();
  80290c:	41 ff d7             	call   *%r15
  80290f:	eb df                	jmp    8028f0 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802911:	89 c1                	mov    %eax,%ecx
  802913:	48 ba 3f 30 80 00 00 	movabs $0x80303f,%rdx
  80291a:	00 00 00 
  80291d:	be 46 00 00 00       	mov    $0x46,%esi
  802922:	48 bf 52 30 80 00 00 	movabs $0x803052,%rdi
  802929:	00 00 00 
  80292c:	b8 00 00 00 00       	mov    $0x0,%eax
  802931:	49 b8 49 19 80 00 00 	movabs $0x801949,%r8
  802938:	00 00 00 
  80293b:	41 ff d0             	call   *%r8
      }
}
  80293e:	48 83 c4 18          	add    $0x18,%rsp
  802942:	5b                   	pop    %rbx
  802943:	41 5c                	pop    %r12
  802945:	41 5d                	pop    %r13
  802947:	41 5e                	pop    %r14
  802949:	41 5f                	pop    %r15
  80294b:	5d                   	pop    %rbp
  80294c:	c3                   	ret    

000000000080294d <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  80294d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802952:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802959:	00 00 00 
  80295c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802960:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802964:	48 c1 e2 04          	shl    $0x4,%rdx
  802968:	48 01 ca             	add    %rcx,%rdx
  80296b:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802971:	39 fa                	cmp    %edi,%edx
  802973:	74 12                	je     802987 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802975:	48 83 c0 01          	add    $0x1,%rax
  802979:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80297f:	75 db                	jne    80295c <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802981:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802986:	c3                   	ret    
            return envs[i].env_id;
  802987:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80298b:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80298f:	48 c1 e0 04          	shl    $0x4,%rax
  802993:	48 89 c2             	mov    %rax,%rdx
  802996:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  80299d:	00 00 00 
  8029a0:	48 01 d0             	add    %rdx,%rax
  8029a3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029a9:	c3                   	ret    
  8029aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

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
  802cc0:	93 1c 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ........."......
  802cd0:	d7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802ce0:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802cf0:	e7 22 80 00 00 00 00 00 ad 1c 80 00 00 00 00 00     ."..............
  802d00:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802d10:	a4 1c 80 00 00 00 00 00 1a 1d 80 00 00 00 00 00     ................
  802d20:	e7 22 80 00 00 00 00 00 a4 1c 80 00 00 00 00 00     ."..............
  802d30:	e7 1c 80 00 00 00 00 00 e7 1c 80 00 00 00 00 00     ................
  802d40:	e7 1c 80 00 00 00 00 00 e7 1c 80 00 00 00 00 00     ................
  802d50:	e7 1c 80 00 00 00 00 00 e7 1c 80 00 00 00 00 00     ................
  802d60:	e7 1c 80 00 00 00 00 00 e7 1c 80 00 00 00 00 00     ................
  802d70:	e7 1c 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ........."......
  802d80:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802d90:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802da0:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802db0:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802dc0:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802dd0:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802de0:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802df0:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802e00:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802e10:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802e20:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802e30:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802e40:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802e50:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802e60:	e7 22 80 00 00 00 00 00 0c 22 80 00 00 00 00 00     ."......."......
  802e70:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802e80:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802e90:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802ea0:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802eb0:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802ec0:	38 1d 80 00 00 00 00 00 2e 1f 80 00 00 00 00 00     8...............
  802ed0:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802ee0:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802ef0:	66 1d 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     f........"......
  802f00:	e7 22 80 00 00 00 00 00 2d 1d 80 00 00 00 00 00     ."......-.......
  802f10:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802f20:	ce 20 80 00 00 00 00 00 96 21 80 00 00 00 00 00     . .......!......
  802f30:	e7 22 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ."......."......
  802f40:	fe 1d 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     ........."......
  802f50:	00 20 80 00 00 00 00 00 e7 22 80 00 00 00 00 00     . ......."......
  802f60:	e7 22 80 00 00 00 00 00 0c 22 80 00 00 00 00 00     ."......."......
  802f70:	e7 22 80 00 00 00 00 00 9c 1c 80 00 00 00 00 00     ."..............

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
