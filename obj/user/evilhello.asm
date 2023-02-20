
obj/user/evilhello:     file format elf64-x86-64


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
  80001e:	e8 23 00 00 00       	call   800046 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
 * kernel should destroy user environment in response */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
    /* try to print the kernel entry point as a string!  mua ha ha! */
    sys_cputs((char *)0x804020000c, 100);
  800029:	be 64 00 00 00       	mov    $0x64,%esi
  80002e:	48 bf 0c 00 20 40 80 	movabs $0x804020000c,%rdi
  800035:	00 00 00 
  800038:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  80003f:	00 00 00 
  800042:	ff d0                	call   *%rax
}
  800044:	5d                   	pop    %rbp
  800045:	c3                   	ret    

0000000000800046 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800046:	55                   	push   %rbp
  800047:	48 89 e5             	mov    %rsp,%rbp
  80004a:	41 56                	push   %r14
  80004c:	41 55                	push   %r13
  80004e:	41 54                	push   %r12
  800050:	53                   	push   %rbx
  800051:	41 89 fd             	mov    %edi,%r13d
  800054:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800057:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80005e:	00 00 00 
  800061:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800068:	00 00 00 
  80006b:	48 39 c2             	cmp    %rax,%rdx
  80006e:	73 17                	jae    800087 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800070:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800073:	49 89 c4             	mov    %rax,%r12
  800076:	48 83 c3 08          	add    $0x8,%rbx
  80007a:	b8 00 00 00 00       	mov    $0x0,%eax
  80007f:	ff 53 f8             	call   *-0x8(%rbx)
  800082:	4c 39 e3             	cmp    %r12,%rbx
  800085:	72 ef                	jb     800076 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800087:	48 b8 e0 01 80 00 00 	movabs $0x8001e0,%rax
  80008e:	00 00 00 
  800091:	ff d0                	call   *%rax
  800093:	25 ff 03 00 00       	and    $0x3ff,%eax
  800098:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80009c:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000a0:	48 c1 e0 04          	shl    $0x4,%rax
  8000a4:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000ab:	00 00 00 
  8000ae:	48 01 d0             	add    %rdx,%rax
  8000b1:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000b8:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000bb:	45 85 ed             	test   %r13d,%r13d
  8000be:	7e 0d                	jle    8000cd <libmain+0x87>
  8000c0:	49 8b 06             	mov    (%r14),%rax
  8000c3:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000ca:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000cd:	4c 89 f6             	mov    %r14,%rsi
  8000d0:	44 89 ef             	mov    %r13d,%edi
  8000d3:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000da:	00 00 00 
  8000dd:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000df:	48 b8 f4 00 80 00 00 	movabs $0x8000f4,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	call   *%rax
#endif
}
  8000eb:	5b                   	pop    %rbx
  8000ec:	41 5c                	pop    %r12
  8000ee:	41 5d                	pop    %r13
  8000f0:	41 5e                	pop    %r14
  8000f2:	5d                   	pop    %rbp
  8000f3:	c3                   	ret    

00000000008000f4 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000f4:	55                   	push   %rbp
  8000f5:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000f8:	48 b8 30 08 80 00 00 	movabs $0x800830,%rax
  8000ff:	00 00 00 
  800102:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800104:	bf 00 00 00 00       	mov    $0x0,%edi
  800109:	48 b8 75 01 80 00 00 	movabs $0x800175,%rax
  800110:	00 00 00 
  800113:	ff d0                	call   *%rax
}
  800115:	5d                   	pop    %rbp
  800116:	c3                   	ret    

0000000000800117 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800117:	55                   	push   %rbp
  800118:	48 89 e5             	mov    %rsp,%rbp
  80011b:	53                   	push   %rbx
  80011c:	48 89 fa             	mov    %rdi,%rdx
  80011f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800122:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800127:	bb 00 00 00 00       	mov    $0x0,%ebx
  80012c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800131:	be 00 00 00 00       	mov    $0x0,%esi
  800136:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80013c:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80013e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800142:	c9                   	leave  
  800143:	c3                   	ret    

0000000000800144 <sys_cgetc>:

int
sys_cgetc(void) {
  800144:	55                   	push   %rbp
  800145:	48 89 e5             	mov    %rsp,%rbp
  800148:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800149:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80014e:	ba 00 00 00 00       	mov    $0x0,%edx
  800153:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800158:	bb 00 00 00 00       	mov    $0x0,%ebx
  80015d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800162:	be 00 00 00 00       	mov    $0x0,%esi
  800167:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80016d:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80016f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800173:	c9                   	leave  
  800174:	c3                   	ret    

0000000000800175 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800175:	55                   	push   %rbp
  800176:	48 89 e5             	mov    %rsp,%rbp
  800179:	53                   	push   %rbx
  80017a:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80017e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800181:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800186:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80018b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800190:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800195:	be 00 00 00 00       	mov    $0x0,%esi
  80019a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001a0:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001a2:	48 85 c0             	test   %rax,%rax
  8001a5:	7f 06                	jg     8001ad <sys_env_destroy+0x38>
}
  8001a7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001ad:	49 89 c0             	mov    %rax,%r8
  8001b0:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001b5:	48 ba d8 29 80 00 00 	movabs $0x8029d8,%rdx
  8001bc:	00 00 00 
  8001bf:	be 26 00 00 00       	mov    $0x26,%esi
  8001c4:	48 bf f7 29 80 00 00 	movabs $0x8029f7,%rdi
  8001cb:	00 00 00 
  8001ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d3:	49 b9 63 19 80 00 00 	movabs $0x801963,%r9
  8001da:	00 00 00 
  8001dd:	41 ff d1             	call   *%r9

00000000008001e0 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001e0:	55                   	push   %rbp
  8001e1:	48 89 e5             	mov    %rsp,%rbp
  8001e4:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001e5:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ef:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001fe:	be 00 00 00 00       	mov    $0x0,%esi
  800203:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800209:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80020b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80020f:	c9                   	leave  
  800210:	c3                   	ret    

0000000000800211 <sys_yield>:

void
sys_yield(void) {
  800211:	55                   	push   %rbp
  800212:	48 89 e5             	mov    %rsp,%rbp
  800215:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800216:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80021b:	ba 00 00 00 00       	mov    $0x0,%edx
  800220:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800225:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80022f:	be 00 00 00 00       	mov    $0x0,%esi
  800234:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80023a:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80023c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800240:	c9                   	leave  
  800241:	c3                   	ret    

0000000000800242 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  800242:	55                   	push   %rbp
  800243:	48 89 e5             	mov    %rsp,%rbp
  800246:	53                   	push   %rbx
  800247:	48 89 fa             	mov    %rdi,%rdx
  80024a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80024d:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800252:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800259:	00 00 00 
  80025c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800261:	be 00 00 00 00       	mov    $0x0,%esi
  800266:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80026c:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80026e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800272:	c9                   	leave  
  800273:	c3                   	ret    

0000000000800274 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  800274:	55                   	push   %rbp
  800275:	48 89 e5             	mov    %rsp,%rbp
  800278:	53                   	push   %rbx
  800279:	49 89 f8             	mov    %rdi,%r8
  80027c:	48 89 d3             	mov    %rdx,%rbx
  80027f:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  800282:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800287:	4c 89 c2             	mov    %r8,%rdx
  80028a:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80028d:	be 00 00 00 00       	mov    $0x0,%esi
  800292:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800298:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80029a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    

00000000008002a0 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002a0:	55                   	push   %rbp
  8002a1:	48 89 e5             	mov    %rsp,%rbp
  8002a4:	53                   	push   %rbx
  8002a5:	48 83 ec 08          	sub    $0x8,%rsp
  8002a9:	89 f8                	mov    %edi,%eax
  8002ab:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002ae:	48 63 f9             	movslq %ecx,%rdi
  8002b1:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002b4:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002b9:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002bc:	be 00 00 00 00       	mov    $0x0,%esi
  8002c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002c7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002c9:	48 85 c0             	test   %rax,%rax
  8002cc:	7f 06                	jg     8002d4 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002ce:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002d2:	c9                   	leave  
  8002d3:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002d4:	49 89 c0             	mov    %rax,%r8
  8002d7:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002dc:	48 ba d8 29 80 00 00 	movabs $0x8029d8,%rdx
  8002e3:	00 00 00 
  8002e6:	be 26 00 00 00       	mov    $0x26,%esi
  8002eb:	48 bf f7 29 80 00 00 	movabs $0x8029f7,%rdi
  8002f2:	00 00 00 
  8002f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fa:	49 b9 63 19 80 00 00 	movabs $0x801963,%r9
  800301:	00 00 00 
  800304:	41 ff d1             	call   *%r9

0000000000800307 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  800307:	55                   	push   %rbp
  800308:	48 89 e5             	mov    %rsp,%rbp
  80030b:	53                   	push   %rbx
  80030c:	48 83 ec 08          	sub    $0x8,%rsp
  800310:	89 f8                	mov    %edi,%eax
  800312:	49 89 f2             	mov    %rsi,%r10
  800315:	48 89 cf             	mov    %rcx,%rdi
  800318:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80031b:	48 63 da             	movslq %edx,%rbx
  80031e:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800321:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800326:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800329:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80032c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80032e:	48 85 c0             	test   %rax,%rax
  800331:	7f 06                	jg     800339 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  800333:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800337:	c9                   	leave  
  800338:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800339:	49 89 c0             	mov    %rax,%r8
  80033c:	b9 05 00 00 00       	mov    $0x5,%ecx
  800341:	48 ba d8 29 80 00 00 	movabs $0x8029d8,%rdx
  800348:	00 00 00 
  80034b:	be 26 00 00 00       	mov    $0x26,%esi
  800350:	48 bf f7 29 80 00 00 	movabs $0x8029f7,%rdi
  800357:	00 00 00 
  80035a:	b8 00 00 00 00       	mov    $0x0,%eax
  80035f:	49 b9 63 19 80 00 00 	movabs $0x801963,%r9
  800366:	00 00 00 
  800369:	41 ff d1             	call   *%r9

000000000080036c <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80036c:	55                   	push   %rbp
  80036d:	48 89 e5             	mov    %rsp,%rbp
  800370:	53                   	push   %rbx
  800371:	48 83 ec 08          	sub    $0x8,%rsp
  800375:	48 89 f1             	mov    %rsi,%rcx
  800378:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80037b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80037e:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800383:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800388:	be 00 00 00 00       	mov    $0x0,%esi
  80038d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800393:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800395:	48 85 c0             	test   %rax,%rax
  800398:	7f 06                	jg     8003a0 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80039a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003a0:	49 89 c0             	mov    %rax,%r8
  8003a3:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003a8:	48 ba d8 29 80 00 00 	movabs $0x8029d8,%rdx
  8003af:	00 00 00 
  8003b2:	be 26 00 00 00       	mov    $0x26,%esi
  8003b7:	48 bf f7 29 80 00 00 	movabs $0x8029f7,%rdi
  8003be:	00 00 00 
  8003c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c6:	49 b9 63 19 80 00 00 	movabs $0x801963,%r9
  8003cd:	00 00 00 
  8003d0:	41 ff d1             	call   *%r9

00000000008003d3 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8003d3:	55                   	push   %rbp
  8003d4:	48 89 e5             	mov    %rsp,%rbp
  8003d7:	53                   	push   %rbx
  8003d8:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8003dc:	48 63 ce             	movslq %esi,%rcx
  8003df:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8003e2:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8003e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003ec:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003f1:	be 00 00 00 00       	mov    $0x0,%esi
  8003f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003fc:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003fe:	48 85 c0             	test   %rax,%rax
  800401:	7f 06                	jg     800409 <sys_env_set_status+0x36>
}
  800403:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800407:	c9                   	leave  
  800408:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800409:	49 89 c0             	mov    %rax,%r8
  80040c:	b9 09 00 00 00       	mov    $0x9,%ecx
  800411:	48 ba d8 29 80 00 00 	movabs $0x8029d8,%rdx
  800418:	00 00 00 
  80041b:	be 26 00 00 00       	mov    $0x26,%esi
  800420:	48 bf f7 29 80 00 00 	movabs $0x8029f7,%rdi
  800427:	00 00 00 
  80042a:	b8 00 00 00 00       	mov    $0x0,%eax
  80042f:	49 b9 63 19 80 00 00 	movabs $0x801963,%r9
  800436:	00 00 00 
  800439:	41 ff d1             	call   *%r9

000000000080043c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80043c:	55                   	push   %rbp
  80043d:	48 89 e5             	mov    %rsp,%rbp
  800440:	53                   	push   %rbx
  800441:	48 83 ec 08          	sub    $0x8,%rsp
  800445:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  800448:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80044b:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800450:	bb 00 00 00 00       	mov    $0x0,%ebx
  800455:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80045a:	be 00 00 00 00       	mov    $0x0,%esi
  80045f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800465:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800467:	48 85 c0             	test   %rax,%rax
  80046a:	7f 06                	jg     800472 <sys_env_set_trapframe+0x36>
}
  80046c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800470:	c9                   	leave  
  800471:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800472:	49 89 c0             	mov    %rax,%r8
  800475:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80047a:	48 ba d8 29 80 00 00 	movabs $0x8029d8,%rdx
  800481:	00 00 00 
  800484:	be 26 00 00 00       	mov    $0x26,%esi
  800489:	48 bf f7 29 80 00 00 	movabs $0x8029f7,%rdi
  800490:	00 00 00 
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	49 b9 63 19 80 00 00 	movabs $0x801963,%r9
  80049f:	00 00 00 
  8004a2:	41 ff d1             	call   *%r9

00000000008004a5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8004a5:	55                   	push   %rbp
  8004a6:	48 89 e5             	mov    %rsp,%rbp
  8004a9:	53                   	push   %rbx
  8004aa:	48 83 ec 08          	sub    $0x8,%rsp
  8004ae:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8004b1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004b4:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004be:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004c3:	be 00 00 00 00       	mov    $0x0,%esi
  8004c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004ce:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004d0:	48 85 c0             	test   %rax,%rax
  8004d3:	7f 06                	jg     8004db <sys_env_set_pgfault_upcall+0x36>
}
  8004d5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004db:	49 89 c0             	mov    %rax,%r8
  8004de:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8004e3:	48 ba d8 29 80 00 00 	movabs $0x8029d8,%rdx
  8004ea:	00 00 00 
  8004ed:	be 26 00 00 00       	mov    $0x26,%esi
  8004f2:	48 bf f7 29 80 00 00 	movabs $0x8029f7,%rdi
  8004f9:	00 00 00 
  8004fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800501:	49 b9 63 19 80 00 00 	movabs $0x801963,%r9
  800508:	00 00 00 
  80050b:	41 ff d1             	call   *%r9

000000000080050e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80050e:	55                   	push   %rbp
  80050f:	48 89 e5             	mov    %rsp,%rbp
  800512:	53                   	push   %rbx
  800513:	89 f8                	mov    %edi,%eax
  800515:	49 89 f1             	mov    %rsi,%r9
  800518:	48 89 d3             	mov    %rdx,%rbx
  80051b:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80051e:	49 63 f0             	movslq %r8d,%rsi
  800521:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800524:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800529:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80052c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800532:	cd 30                	int    $0x30
}
  800534:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800538:	c9                   	leave  
  800539:	c3                   	ret    

000000000080053a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80053a:	55                   	push   %rbp
  80053b:	48 89 e5             	mov    %rsp,%rbp
  80053e:	53                   	push   %rbx
  80053f:	48 83 ec 08          	sub    $0x8,%rsp
  800543:	48 89 fa             	mov    %rdi,%rdx
  800546:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800549:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80054e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800553:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800558:	be 00 00 00 00       	mov    $0x0,%esi
  80055d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800563:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800565:	48 85 c0             	test   %rax,%rax
  800568:	7f 06                	jg     800570 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80056a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800570:	49 89 c0             	mov    %rax,%r8
  800573:	b9 0e 00 00 00       	mov    $0xe,%ecx
  800578:	48 ba d8 29 80 00 00 	movabs $0x8029d8,%rdx
  80057f:	00 00 00 
  800582:	be 26 00 00 00       	mov    $0x26,%esi
  800587:	48 bf f7 29 80 00 00 	movabs $0x8029f7,%rdi
  80058e:	00 00 00 
  800591:	b8 00 00 00 00       	mov    $0x0,%eax
  800596:	49 b9 63 19 80 00 00 	movabs $0x801963,%r9
  80059d:	00 00 00 
  8005a0:	41 ff d1             	call   *%r9

00000000008005a3 <sys_gettime>:

int
sys_gettime(void) {
  8005a3:	55                   	push   %rbp
  8005a4:	48 89 e5             	mov    %rsp,%rbp
  8005a7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005a8:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005bc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005c1:	be 00 00 00 00       	mov    $0x0,%esi
  8005c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005cc:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8005ce:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

00000000008005d4 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8005d4:	55                   	push   %rbp
  8005d5:	48 89 e5             	mov    %rsp,%rbp
  8005d8:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8005d9:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005de:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005ed:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005f2:	be 00 00 00 00       	mov    $0x0,%esi
  8005f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005fd:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8005ff:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800603:	c9                   	leave  
  800604:	c3                   	ret    

0000000000800605 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800605:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80060c:	ff ff ff 
  80060f:	48 01 f8             	add    %rdi,%rax
  800612:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800616:	c3                   	ret    

0000000000800617 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800617:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80061e:	ff ff ff 
  800621:	48 01 f8             	add    %rdi,%rax
  800624:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  800628:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80062e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800632:	c3                   	ret    

0000000000800633 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  800633:	55                   	push   %rbp
  800634:	48 89 e5             	mov    %rsp,%rbp
  800637:	41 57                	push   %r15
  800639:	41 56                	push   %r14
  80063b:	41 55                	push   %r13
  80063d:	41 54                	push   %r12
  80063f:	53                   	push   %rbx
  800640:	48 83 ec 08          	sub    $0x8,%rsp
  800644:	49 89 ff             	mov    %rdi,%r15
  800647:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80064c:	49 bc e1 15 80 00 00 	movabs $0x8015e1,%r12
  800653:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  800656:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  80065c:	48 89 df             	mov    %rbx,%rdi
  80065f:	41 ff d4             	call   *%r12
  800662:	83 e0 04             	and    $0x4,%eax
  800665:	74 1a                	je     800681 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  800667:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80066e:	4c 39 f3             	cmp    %r14,%rbx
  800671:	75 e9                	jne    80065c <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  800673:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  80067a:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80067f:	eb 03                	jmp    800684 <fd_alloc+0x51>
            *fd_store = fd;
  800681:	49 89 1f             	mov    %rbx,(%r15)
}
  800684:	48 83 c4 08          	add    $0x8,%rsp
  800688:	5b                   	pop    %rbx
  800689:	41 5c                	pop    %r12
  80068b:	41 5d                	pop    %r13
  80068d:	41 5e                	pop    %r14
  80068f:	41 5f                	pop    %r15
  800691:	5d                   	pop    %rbp
  800692:	c3                   	ret    

0000000000800693 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  800693:	83 ff 1f             	cmp    $0x1f,%edi
  800696:	77 39                	ja     8006d1 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  800698:	55                   	push   %rbp
  800699:	48 89 e5             	mov    %rsp,%rbp
  80069c:	41 54                	push   %r12
  80069e:	53                   	push   %rbx
  80069f:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8006a2:	48 63 df             	movslq %edi,%rbx
  8006a5:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8006ac:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8006b0:	48 89 df             	mov    %rbx,%rdi
  8006b3:	48 b8 e1 15 80 00 00 	movabs $0x8015e1,%rax
  8006ba:	00 00 00 
  8006bd:	ff d0                	call   *%rax
  8006bf:	a8 04                	test   $0x4,%al
  8006c1:	74 14                	je     8006d7 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8006c3:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8006c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006cc:	5b                   	pop    %rbx
  8006cd:	41 5c                	pop    %r12
  8006cf:	5d                   	pop    %rbp
  8006d0:	c3                   	ret    
        return -E_INVAL;
  8006d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006d6:	c3                   	ret    
        return -E_INVAL;
  8006d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006dc:	eb ee                	jmp    8006cc <fd_lookup+0x39>

00000000008006de <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8006de:	55                   	push   %rbp
  8006df:	48 89 e5             	mov    %rsp,%rbp
  8006e2:	53                   	push   %rbx
  8006e3:	48 83 ec 08          	sub    $0x8,%rsp
  8006e7:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8006ea:	48 ba a0 2a 80 00 00 	movabs $0x802aa0,%rdx
  8006f1:	00 00 00 
  8006f4:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8006fb:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8006fe:	39 38                	cmp    %edi,(%rax)
  800700:	74 4b                	je     80074d <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  800702:	48 83 c2 08          	add    $0x8,%rdx
  800706:	48 8b 02             	mov    (%rdx),%rax
  800709:	48 85 c0             	test   %rax,%rax
  80070c:	75 f0                	jne    8006fe <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80070e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800715:	00 00 00 
  800718:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80071e:	89 fa                	mov    %edi,%edx
  800720:	48 bf 08 2a 80 00 00 	movabs $0x802a08,%rdi
  800727:	00 00 00 
  80072a:	b8 00 00 00 00       	mov    $0x0,%eax
  80072f:	48 b9 b3 1a 80 00 00 	movabs $0x801ab3,%rcx
  800736:	00 00 00 
  800739:	ff d1                	call   *%rcx
    *dev = 0;
  80073b:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  800742:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800747:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    
            *dev = devtab[i];
  80074d:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  800750:	b8 00 00 00 00       	mov    $0x0,%eax
  800755:	eb f0                	jmp    800747 <dev_lookup+0x69>

0000000000800757 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  800757:	55                   	push   %rbp
  800758:	48 89 e5             	mov    %rsp,%rbp
  80075b:	41 55                	push   %r13
  80075d:	41 54                	push   %r12
  80075f:	53                   	push   %rbx
  800760:	48 83 ec 18          	sub    $0x18,%rsp
  800764:	49 89 fc             	mov    %rdi,%r12
  800767:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80076a:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  800771:	ff ff ff 
  800774:	4c 01 e7             	add    %r12,%rdi
  800777:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80077b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80077f:	48 b8 93 06 80 00 00 	movabs $0x800693,%rax
  800786:	00 00 00 
  800789:	ff d0                	call   *%rax
  80078b:	89 c3                	mov    %eax,%ebx
  80078d:	85 c0                	test   %eax,%eax
  80078f:	78 06                	js     800797 <fd_close+0x40>
  800791:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  800795:	74 18                	je     8007af <fd_close+0x58>
        return (must_exist ? res : 0);
  800797:	45 84 ed             	test   %r13b,%r13b
  80079a:	b8 00 00 00 00       	mov    $0x0,%eax
  80079f:	0f 44 d8             	cmove  %eax,%ebx
}
  8007a2:	89 d8                	mov    %ebx,%eax
  8007a4:	48 83 c4 18          	add    $0x18,%rsp
  8007a8:	5b                   	pop    %rbx
  8007a9:	41 5c                	pop    %r12
  8007ab:	41 5d                	pop    %r13
  8007ad:	5d                   	pop    %rbp
  8007ae:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8007af:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8007b3:	41 8b 3c 24          	mov    (%r12),%edi
  8007b7:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  8007be:	00 00 00 
  8007c1:	ff d0                	call   *%rax
  8007c3:	89 c3                	mov    %eax,%ebx
  8007c5:	85 c0                	test   %eax,%eax
  8007c7:	78 19                	js     8007e2 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8007c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8007cd:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007d6:	48 85 c0             	test   %rax,%rax
  8007d9:	74 07                	je     8007e2 <fd_close+0x8b>
  8007db:	4c 89 e7             	mov    %r12,%rdi
  8007de:	ff d0                	call   *%rax
  8007e0:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8007e2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8007e7:	4c 89 e6             	mov    %r12,%rsi
  8007ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8007ef:	48 b8 6c 03 80 00 00 	movabs $0x80036c,%rax
  8007f6:	00 00 00 
  8007f9:	ff d0                	call   *%rax
    return res;
  8007fb:	eb a5                	jmp    8007a2 <fd_close+0x4b>

00000000008007fd <close>:

int
close(int fdnum) {
  8007fd:	55                   	push   %rbp
  8007fe:	48 89 e5             	mov    %rsp,%rbp
  800801:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  800805:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800809:	48 b8 93 06 80 00 00 	movabs $0x800693,%rax
  800810:	00 00 00 
  800813:	ff d0                	call   *%rax
    if (res < 0) return res;
  800815:	85 c0                	test   %eax,%eax
  800817:	78 15                	js     80082e <close+0x31>

    return fd_close(fd, 1);
  800819:	be 01 00 00 00       	mov    $0x1,%esi
  80081e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800822:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  800829:	00 00 00 
  80082c:	ff d0                	call   *%rax
}
  80082e:	c9                   	leave  
  80082f:	c3                   	ret    

0000000000800830 <close_all>:

void
close_all(void) {
  800830:	55                   	push   %rbp
  800831:	48 89 e5             	mov    %rsp,%rbp
  800834:	41 54                	push   %r12
  800836:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  800837:	bb 00 00 00 00       	mov    $0x0,%ebx
  80083c:	49 bc fd 07 80 00 00 	movabs $0x8007fd,%r12
  800843:	00 00 00 
  800846:	89 df                	mov    %ebx,%edi
  800848:	41 ff d4             	call   *%r12
  80084b:	83 c3 01             	add    $0x1,%ebx
  80084e:	83 fb 20             	cmp    $0x20,%ebx
  800851:	75 f3                	jne    800846 <close_all+0x16>
}
  800853:	5b                   	pop    %rbx
  800854:	41 5c                	pop    %r12
  800856:	5d                   	pop    %rbp
  800857:	c3                   	ret    

0000000000800858 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  800858:	55                   	push   %rbp
  800859:	48 89 e5             	mov    %rsp,%rbp
  80085c:	41 56                	push   %r14
  80085e:	41 55                	push   %r13
  800860:	41 54                	push   %r12
  800862:	53                   	push   %rbx
  800863:	48 83 ec 10          	sub    $0x10,%rsp
  800867:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80086a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80086e:	48 b8 93 06 80 00 00 	movabs $0x800693,%rax
  800875:	00 00 00 
  800878:	ff d0                	call   *%rax
  80087a:	89 c3                	mov    %eax,%ebx
  80087c:	85 c0                	test   %eax,%eax
  80087e:	0f 88 b7 00 00 00    	js     80093b <dup+0xe3>
    close(newfdnum);
  800884:	44 89 e7             	mov    %r12d,%edi
  800887:	48 b8 fd 07 80 00 00 	movabs $0x8007fd,%rax
  80088e:	00 00 00 
  800891:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800893:	4d 63 ec             	movslq %r12d,%r13
  800896:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80089d:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8008a1:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8008a5:	49 be 17 06 80 00 00 	movabs $0x800617,%r14
  8008ac:	00 00 00 
  8008af:	41 ff d6             	call   *%r14
  8008b2:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8008b5:	4c 89 ef             	mov    %r13,%rdi
  8008b8:	41 ff d6             	call   *%r14
  8008bb:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8008be:	48 89 df             	mov    %rbx,%rdi
  8008c1:	48 b8 e1 15 80 00 00 	movabs $0x8015e1,%rax
  8008c8:	00 00 00 
  8008cb:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8008cd:	a8 04                	test   $0x4,%al
  8008cf:	74 2b                	je     8008fc <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8008d1:	41 89 c1             	mov    %eax,%r9d
  8008d4:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8008da:	4c 89 f1             	mov    %r14,%rcx
  8008dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e2:	48 89 de             	mov    %rbx,%rsi
  8008e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8008ea:	48 b8 07 03 80 00 00 	movabs $0x800307,%rax
  8008f1:	00 00 00 
  8008f4:	ff d0                	call   *%rax
  8008f6:	89 c3                	mov    %eax,%ebx
  8008f8:	85 c0                	test   %eax,%eax
  8008fa:	78 4e                	js     80094a <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8008fc:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800900:	48 b8 e1 15 80 00 00 	movabs $0x8015e1,%rax
  800907:	00 00 00 
  80090a:	ff d0                	call   *%rax
  80090c:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  80090f:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800915:	4c 89 e9             	mov    %r13,%rcx
  800918:	ba 00 00 00 00       	mov    $0x0,%edx
  80091d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800921:	bf 00 00 00 00       	mov    $0x0,%edi
  800926:	48 b8 07 03 80 00 00 	movabs $0x800307,%rax
  80092d:	00 00 00 
  800930:	ff d0                	call   *%rax
  800932:	89 c3                	mov    %eax,%ebx
  800934:	85 c0                	test   %eax,%eax
  800936:	78 12                	js     80094a <dup+0xf2>

    return newfdnum;
  800938:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80093b:	89 d8                	mov    %ebx,%eax
  80093d:	48 83 c4 10          	add    $0x10,%rsp
  800941:	5b                   	pop    %rbx
  800942:	41 5c                	pop    %r12
  800944:	41 5d                	pop    %r13
  800946:	41 5e                	pop    %r14
  800948:	5d                   	pop    %rbp
  800949:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80094a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80094f:	4c 89 ee             	mov    %r13,%rsi
  800952:	bf 00 00 00 00       	mov    $0x0,%edi
  800957:	49 bc 6c 03 80 00 00 	movabs $0x80036c,%r12
  80095e:	00 00 00 
  800961:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  800964:	ba 00 10 00 00       	mov    $0x1000,%edx
  800969:	4c 89 f6             	mov    %r14,%rsi
  80096c:	bf 00 00 00 00       	mov    $0x0,%edi
  800971:	41 ff d4             	call   *%r12
    return res;
  800974:	eb c5                	jmp    80093b <dup+0xe3>

0000000000800976 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800976:	55                   	push   %rbp
  800977:	48 89 e5             	mov    %rsp,%rbp
  80097a:	41 55                	push   %r13
  80097c:	41 54                	push   %r12
  80097e:	53                   	push   %rbx
  80097f:	48 83 ec 18          	sub    $0x18,%rsp
  800983:	89 fb                	mov    %edi,%ebx
  800985:	49 89 f4             	mov    %rsi,%r12
  800988:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80098b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80098f:	48 b8 93 06 80 00 00 	movabs $0x800693,%rax
  800996:	00 00 00 
  800999:	ff d0                	call   *%rax
  80099b:	85 c0                	test   %eax,%eax
  80099d:	78 49                	js     8009e8 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80099f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8009a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009a7:	8b 38                	mov    (%rax),%edi
  8009a9:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  8009b0:	00 00 00 
  8009b3:	ff d0                	call   *%rax
  8009b5:	85 c0                	test   %eax,%eax
  8009b7:	78 33                	js     8009ec <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8009b9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8009bd:	8b 47 08             	mov    0x8(%rdi),%eax
  8009c0:	83 e0 03             	and    $0x3,%eax
  8009c3:	83 f8 01             	cmp    $0x1,%eax
  8009c6:	74 28                	je     8009f0 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8009c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009cc:	48 8b 40 10          	mov    0x10(%rax),%rax
  8009d0:	48 85 c0             	test   %rax,%rax
  8009d3:	74 51                	je     800a26 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8009d5:	4c 89 ea             	mov    %r13,%rdx
  8009d8:	4c 89 e6             	mov    %r12,%rsi
  8009db:	ff d0                	call   *%rax
}
  8009dd:	48 83 c4 18          	add    $0x18,%rsp
  8009e1:	5b                   	pop    %rbx
  8009e2:	41 5c                	pop    %r12
  8009e4:	41 5d                	pop    %r13
  8009e6:	5d                   	pop    %rbp
  8009e7:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8009e8:	48 98                	cltq   
  8009ea:	eb f1                	jmp    8009dd <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8009ec:	48 98                	cltq   
  8009ee:	eb ed                	jmp    8009dd <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8009f0:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8009f7:	00 00 00 
  8009fa:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800a00:	89 da                	mov    %ebx,%edx
  800a02:	48 bf 49 2a 80 00 00 	movabs $0x802a49,%rdi
  800a09:	00 00 00 
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a11:	48 b9 b3 1a 80 00 00 	movabs $0x801ab3,%rcx
  800a18:	00 00 00 
  800a1b:	ff d1                	call   *%rcx
        return -E_INVAL;
  800a1d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800a24:	eb b7                	jmp    8009dd <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800a26:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800a2d:	eb ae                	jmp    8009dd <read+0x67>

0000000000800a2f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800a2f:	55                   	push   %rbp
  800a30:	48 89 e5             	mov    %rsp,%rbp
  800a33:	41 57                	push   %r15
  800a35:	41 56                	push   %r14
  800a37:	41 55                	push   %r13
  800a39:	41 54                	push   %r12
  800a3b:	53                   	push   %rbx
  800a3c:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800a40:	48 85 d2             	test   %rdx,%rdx
  800a43:	74 54                	je     800a99 <readn+0x6a>
  800a45:	41 89 fd             	mov    %edi,%r13d
  800a48:	49 89 f6             	mov    %rsi,%r14
  800a4b:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800a4e:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800a53:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800a58:	49 bf 76 09 80 00 00 	movabs $0x800976,%r15
  800a5f:	00 00 00 
  800a62:	4c 89 e2             	mov    %r12,%rdx
  800a65:	48 29 f2             	sub    %rsi,%rdx
  800a68:	4c 01 f6             	add    %r14,%rsi
  800a6b:	44 89 ef             	mov    %r13d,%edi
  800a6e:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800a71:	85 c0                	test   %eax,%eax
  800a73:	78 20                	js     800a95 <readn+0x66>
    for (; inc && res < n; res += inc) {
  800a75:	01 c3                	add    %eax,%ebx
  800a77:	85 c0                	test   %eax,%eax
  800a79:	74 08                	je     800a83 <readn+0x54>
  800a7b:	48 63 f3             	movslq %ebx,%rsi
  800a7e:	4c 39 e6             	cmp    %r12,%rsi
  800a81:	72 df                	jb     800a62 <readn+0x33>
    }
    return res;
  800a83:	48 63 c3             	movslq %ebx,%rax
}
  800a86:	48 83 c4 08          	add    $0x8,%rsp
  800a8a:	5b                   	pop    %rbx
  800a8b:	41 5c                	pop    %r12
  800a8d:	41 5d                	pop    %r13
  800a8f:	41 5e                	pop    %r14
  800a91:	41 5f                	pop    %r15
  800a93:	5d                   	pop    %rbp
  800a94:	c3                   	ret    
        if (inc < 0) return inc;
  800a95:	48 98                	cltq   
  800a97:	eb ed                	jmp    800a86 <readn+0x57>
    int inc = 1, res = 0;
  800a99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a9e:	eb e3                	jmp    800a83 <readn+0x54>

0000000000800aa0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800aa0:	55                   	push   %rbp
  800aa1:	48 89 e5             	mov    %rsp,%rbp
  800aa4:	41 55                	push   %r13
  800aa6:	41 54                	push   %r12
  800aa8:	53                   	push   %rbx
  800aa9:	48 83 ec 18          	sub    $0x18,%rsp
  800aad:	89 fb                	mov    %edi,%ebx
  800aaf:	49 89 f4             	mov    %rsi,%r12
  800ab2:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800ab5:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800ab9:	48 b8 93 06 80 00 00 	movabs $0x800693,%rax
  800ac0:	00 00 00 
  800ac3:	ff d0                	call   *%rax
  800ac5:	85 c0                	test   %eax,%eax
  800ac7:	78 44                	js     800b0d <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800ac9:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800acd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ad1:	8b 38                	mov    (%rax),%edi
  800ad3:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  800ada:	00 00 00 
  800add:	ff d0                	call   *%rax
  800adf:	85 c0                	test   %eax,%eax
  800ae1:	78 2e                	js     800b11 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ae3:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ae7:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800aeb:	74 28                	je     800b15 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800aed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800af1:	48 8b 40 18          	mov    0x18(%rax),%rax
  800af5:	48 85 c0             	test   %rax,%rax
  800af8:	74 51                	je     800b4b <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  800afa:	4c 89 ea             	mov    %r13,%rdx
  800afd:	4c 89 e6             	mov    %r12,%rsi
  800b00:	ff d0                	call   *%rax
}
  800b02:	48 83 c4 18          	add    $0x18,%rsp
  800b06:	5b                   	pop    %rbx
  800b07:	41 5c                	pop    %r12
  800b09:	41 5d                	pop    %r13
  800b0b:	5d                   	pop    %rbp
  800b0c:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b0d:	48 98                	cltq   
  800b0f:	eb f1                	jmp    800b02 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b11:	48 98                	cltq   
  800b13:	eb ed                	jmp    800b02 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b15:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800b1c:	00 00 00 
  800b1f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800b25:	89 da                	mov    %ebx,%edx
  800b27:	48 bf 65 2a 80 00 00 	movabs $0x802a65,%rdi
  800b2e:	00 00 00 
  800b31:	b8 00 00 00 00       	mov    $0x0,%eax
  800b36:	48 b9 b3 1a 80 00 00 	movabs $0x801ab3,%rcx
  800b3d:	00 00 00 
  800b40:	ff d1                	call   *%rcx
        return -E_INVAL;
  800b42:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800b49:	eb b7                	jmp    800b02 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800b4b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800b52:	eb ae                	jmp    800b02 <write+0x62>

0000000000800b54 <seek>:

int
seek(int fdnum, off_t offset) {
  800b54:	55                   	push   %rbp
  800b55:	48 89 e5             	mov    %rsp,%rbp
  800b58:	53                   	push   %rbx
  800b59:	48 83 ec 18          	sub    $0x18,%rsp
  800b5d:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b5f:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b63:	48 b8 93 06 80 00 00 	movabs $0x800693,%rax
  800b6a:	00 00 00 
  800b6d:	ff d0                	call   *%rax
  800b6f:	85 c0                	test   %eax,%eax
  800b71:	78 0c                	js     800b7f <seek+0x2b>

    fd->fd_offset = offset;
  800b73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b77:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800b7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800b83:	c9                   	leave  
  800b84:	c3                   	ret    

0000000000800b85 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800b85:	55                   	push   %rbp
  800b86:	48 89 e5             	mov    %rsp,%rbp
  800b89:	41 54                	push   %r12
  800b8b:	53                   	push   %rbx
  800b8c:	48 83 ec 10          	sub    $0x10,%rsp
  800b90:	89 fb                	mov    %edi,%ebx
  800b92:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b95:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b99:	48 b8 93 06 80 00 00 	movabs $0x800693,%rax
  800ba0:	00 00 00 
  800ba3:	ff d0                	call   *%rax
  800ba5:	85 c0                	test   %eax,%eax
  800ba7:	78 36                	js     800bdf <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800ba9:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800bad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb1:	8b 38                	mov    (%rax),%edi
  800bb3:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  800bba:	00 00 00 
  800bbd:	ff d0                	call   *%rax
  800bbf:	85 c0                	test   %eax,%eax
  800bc1:	78 1c                	js     800bdf <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bc3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800bc7:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  800bcb:	74 1b                	je     800be8 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800bcd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800bd1:	48 8b 40 30          	mov    0x30(%rax),%rax
  800bd5:	48 85 c0             	test   %rax,%rax
  800bd8:	74 42                	je     800c1c <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  800bda:	44 89 e6             	mov    %r12d,%esi
  800bdd:	ff d0                	call   *%rax
}
  800bdf:	48 83 c4 10          	add    $0x10,%rsp
  800be3:	5b                   	pop    %rbx
  800be4:	41 5c                	pop    %r12
  800be6:	5d                   	pop    %rbp
  800be7:	c3                   	ret    
                thisenv->env_id, fdnum);
  800be8:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bef:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800bf2:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800bf8:	89 da                	mov    %ebx,%edx
  800bfa:	48 bf 28 2a 80 00 00 	movabs $0x802a28,%rdi
  800c01:	00 00 00 
  800c04:	b8 00 00 00 00       	mov    $0x0,%eax
  800c09:	48 b9 b3 1a 80 00 00 	movabs $0x801ab3,%rcx
  800c10:	00 00 00 
  800c13:	ff d1                	call   *%rcx
        return -E_INVAL;
  800c15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c1a:	eb c3                	jmp    800bdf <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c1c:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c21:	eb bc                	jmp    800bdf <ftruncate+0x5a>

0000000000800c23 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800c23:	55                   	push   %rbp
  800c24:	48 89 e5             	mov    %rsp,%rbp
  800c27:	53                   	push   %rbx
  800c28:	48 83 ec 18          	sub    $0x18,%rsp
  800c2c:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c2f:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c33:	48 b8 93 06 80 00 00 	movabs $0x800693,%rax
  800c3a:	00 00 00 
  800c3d:	ff d0                	call   *%rax
  800c3f:	85 c0                	test   %eax,%eax
  800c41:	78 4d                	js     800c90 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c43:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800c47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4b:	8b 38                	mov    (%rax),%edi
  800c4d:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  800c54:	00 00 00 
  800c57:	ff d0                	call   *%rax
  800c59:	85 c0                	test   %eax,%eax
  800c5b:	78 33                	js     800c90 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c61:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800c66:	74 2e                	je     800c96 <fstat+0x73>

    stat->st_name[0] = 0;
  800c68:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800c6b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800c72:	00 00 00 
    stat->st_isdir = 0;
  800c75:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800c7c:	00 00 00 
    stat->st_dev = dev;
  800c7f:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800c86:	48 89 de             	mov    %rbx,%rsi
  800c89:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c8d:	ff 50 28             	call   *0x28(%rax)
}
  800c90:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800c96:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800c9b:	eb f3                	jmp    800c90 <fstat+0x6d>

0000000000800c9d <stat>:

int
stat(const char *path, struct Stat *stat) {
  800c9d:	55                   	push   %rbp
  800c9e:	48 89 e5             	mov    %rsp,%rbp
  800ca1:	41 54                	push   %r12
  800ca3:	53                   	push   %rbx
  800ca4:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800ca7:	be 00 00 00 00       	mov    $0x0,%esi
  800cac:	48 b8 68 0f 80 00 00 	movabs $0x800f68,%rax
  800cb3:	00 00 00 
  800cb6:	ff d0                	call   *%rax
  800cb8:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	78 25                	js     800ce3 <stat+0x46>

    int res = fstat(fd, stat);
  800cbe:	4c 89 e6             	mov    %r12,%rsi
  800cc1:	89 c7                	mov    %eax,%edi
  800cc3:	48 b8 23 0c 80 00 00 	movabs $0x800c23,%rax
  800cca:	00 00 00 
  800ccd:	ff d0                	call   *%rax
  800ccf:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800cd2:	89 df                	mov    %ebx,%edi
  800cd4:	48 b8 fd 07 80 00 00 	movabs $0x8007fd,%rax
  800cdb:	00 00 00 
  800cde:	ff d0                	call   *%rax

    return res;
  800ce0:	44 89 e3             	mov    %r12d,%ebx
}
  800ce3:	89 d8                	mov    %ebx,%eax
  800ce5:	5b                   	pop    %rbx
  800ce6:	41 5c                	pop    %r12
  800ce8:	5d                   	pop    %rbp
  800ce9:	c3                   	ret    

0000000000800cea <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800cea:	55                   	push   %rbp
  800ceb:	48 89 e5             	mov    %rsp,%rbp
  800cee:	41 54                	push   %r12
  800cf0:	53                   	push   %rbx
  800cf1:	48 83 ec 10          	sub    $0x10,%rsp
  800cf5:	41 89 fc             	mov    %edi,%r12d
  800cf8:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800cfb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d02:	00 00 00 
  800d05:	83 38 00             	cmpl   $0x0,(%rax)
  800d08:	74 5e                	je     800d68 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800d0a:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800d10:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800d15:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800d1c:	00 00 00 
  800d1f:	44 89 e6             	mov    %r12d,%esi
  800d22:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800d29:	00 00 00 
  800d2c:	8b 38                	mov    (%rax),%edi
  800d2e:	48 b8 c4 28 80 00 00 	movabs $0x8028c4,%rax
  800d35:	00 00 00 
  800d38:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800d3a:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800d41:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800d42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d47:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d4b:	48 89 de             	mov    %rbx,%rsi
  800d4e:	bf 00 00 00 00       	mov    $0x0,%edi
  800d53:	48 b8 25 28 80 00 00 	movabs $0x802825,%rax
  800d5a:	00 00 00 
  800d5d:	ff d0                	call   *%rax
}
  800d5f:	48 83 c4 10          	add    $0x10,%rsp
  800d63:	5b                   	pop    %rbx
  800d64:	41 5c                	pop    %r12
  800d66:	5d                   	pop    %rbp
  800d67:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800d68:	bf 03 00 00 00       	mov    $0x3,%edi
  800d6d:	48 b8 67 29 80 00 00 	movabs $0x802967,%rax
  800d74:	00 00 00 
  800d77:	ff d0                	call   *%rax
  800d79:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800d80:	00 00 
  800d82:	eb 86                	jmp    800d0a <fsipc+0x20>

0000000000800d84 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800d84:	55                   	push   %rbp
  800d85:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d88:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800d8f:	00 00 00 
  800d92:	8b 57 0c             	mov    0xc(%rdi),%edx
  800d95:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800d97:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800d9a:	be 00 00 00 00       	mov    $0x0,%esi
  800d9f:	bf 02 00 00 00       	mov    $0x2,%edi
  800da4:	48 b8 ea 0c 80 00 00 	movabs $0x800cea,%rax
  800dab:	00 00 00 
  800dae:	ff d0                	call   *%rax
}
  800db0:	5d                   	pop    %rbp
  800db1:	c3                   	ret    

0000000000800db2 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800db2:	55                   	push   %rbp
  800db3:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800db6:	8b 47 0c             	mov    0xc(%rdi),%eax
  800db9:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800dc0:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800dc2:	be 00 00 00 00       	mov    $0x0,%esi
  800dc7:	bf 06 00 00 00       	mov    $0x6,%edi
  800dcc:	48 b8 ea 0c 80 00 00 	movabs $0x800cea,%rax
  800dd3:	00 00 00 
  800dd6:	ff d0                	call   *%rax
}
  800dd8:	5d                   	pop    %rbp
  800dd9:	c3                   	ret    

0000000000800dda <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800dda:	55                   	push   %rbp
  800ddb:	48 89 e5             	mov    %rsp,%rbp
  800dde:	53                   	push   %rbx
  800ddf:	48 83 ec 08          	sub    $0x8,%rsp
  800de3:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800de6:	8b 47 0c             	mov    0xc(%rdi),%eax
  800de9:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800df0:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800df2:	be 00 00 00 00       	mov    $0x0,%esi
  800df7:	bf 05 00 00 00       	mov    $0x5,%edi
  800dfc:	48 b8 ea 0c 80 00 00 	movabs $0x800cea,%rax
  800e03:	00 00 00 
  800e06:	ff d0                	call   *%rax
    if (res < 0) return res;
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	78 40                	js     800e4c <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800e0c:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800e13:	00 00 00 
  800e16:	48 89 df             	mov    %rbx,%rdi
  800e19:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  800e20:	00 00 00 
  800e23:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800e25:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e2c:	00 00 00 
  800e2f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  800e35:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e3b:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  800e41:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e4c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800e50:	c9                   	leave  
  800e51:	c3                   	ret    

0000000000800e52 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800e52:	55                   	push   %rbp
  800e53:	48 89 e5             	mov    %rsp,%rbp
  800e56:	41 57                	push   %r15
  800e58:	41 56                	push   %r14
  800e5a:	41 55                	push   %r13
  800e5c:	41 54                	push   %r12
  800e5e:	53                   	push   %rbx
  800e5f:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  800e63:	48 85 d2             	test   %rdx,%rdx
  800e66:	0f 84 91 00 00 00    	je     800efd <devfile_write+0xab>
  800e6c:	49 89 ff             	mov    %rdi,%r15
  800e6f:	49 89 f4             	mov    %rsi,%r12
  800e72:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  800e75:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e7c:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  800e83:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  800e86:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  800e8d:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  800e93:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  800e97:	4c 89 ea             	mov    %r13,%rdx
  800e9a:	4c 89 e6             	mov    %r12,%rsi
  800e9d:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  800ea4:	00 00 00 
  800ea7:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  800eae:	00 00 00 
  800eb1:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800eb3:	41 8b 47 0c          	mov    0xc(%r15),%eax
  800eb7:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  800eba:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  800ebe:	be 00 00 00 00       	mov    $0x0,%esi
  800ec3:	bf 04 00 00 00       	mov    $0x4,%edi
  800ec8:	48 b8 ea 0c 80 00 00 	movabs $0x800cea,%rax
  800ecf:	00 00 00 
  800ed2:	ff d0                	call   *%rax
        if (res < 0)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	78 21                	js     800ef9 <devfile_write+0xa7>
        buf += res;
  800ed8:	48 63 d0             	movslq %eax,%rdx
  800edb:	49 01 d4             	add    %rdx,%r12
        ext += res;
  800ede:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  800ee1:	48 29 d3             	sub    %rdx,%rbx
  800ee4:	75 a0                	jne    800e86 <devfile_write+0x34>
    return ext;
  800ee6:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  800eea:	48 83 c4 18          	add    $0x18,%rsp
  800eee:	5b                   	pop    %rbx
  800eef:	41 5c                	pop    %r12
  800ef1:	41 5d                	pop    %r13
  800ef3:	41 5e                	pop    %r14
  800ef5:	41 5f                	pop    %r15
  800ef7:	5d                   	pop    %rbp
  800ef8:	c3                   	ret    
            return res;
  800ef9:	48 98                	cltq   
  800efb:	eb ed                	jmp    800eea <devfile_write+0x98>
    int ext = 0;
  800efd:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  800f04:	eb e0                	jmp    800ee6 <devfile_write+0x94>

0000000000800f06 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800f06:	55                   	push   %rbp
  800f07:	48 89 e5             	mov    %rsp,%rbp
  800f0a:	41 54                	push   %r12
  800f0c:	53                   	push   %rbx
  800f0d:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800f10:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f17:	00 00 00 
  800f1a:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f1d:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  800f1f:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  800f23:	be 00 00 00 00       	mov    $0x0,%esi
  800f28:	bf 03 00 00 00       	mov    $0x3,%edi
  800f2d:	48 b8 ea 0c 80 00 00 	movabs $0x800cea,%rax
  800f34:	00 00 00 
  800f37:	ff d0                	call   *%rax
    if (read < 0) 
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	78 27                	js     800f64 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  800f3d:	48 63 d8             	movslq %eax,%rbx
  800f40:	48 89 da             	mov    %rbx,%rdx
  800f43:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800f4a:	00 00 00 
  800f4d:	4c 89 e7             	mov    %r12,%rdi
  800f50:	48 b8 ef 25 80 00 00 	movabs $0x8025ef,%rax
  800f57:	00 00 00 
  800f5a:	ff d0                	call   *%rax
    return read;
  800f5c:	48 89 d8             	mov    %rbx,%rax
}
  800f5f:	5b                   	pop    %rbx
  800f60:	41 5c                	pop    %r12
  800f62:	5d                   	pop    %rbp
  800f63:	c3                   	ret    
		return read;
  800f64:	48 98                	cltq   
  800f66:	eb f7                	jmp    800f5f <devfile_read+0x59>

0000000000800f68 <open>:
open(const char *path, int mode) {
  800f68:	55                   	push   %rbp
  800f69:	48 89 e5             	mov    %rsp,%rbp
  800f6c:	41 55                	push   %r13
  800f6e:	41 54                	push   %r12
  800f70:	53                   	push   %rbx
  800f71:	48 83 ec 18          	sub    $0x18,%rsp
  800f75:	49 89 fc             	mov    %rdi,%r12
  800f78:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  800f7b:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  800f82:	00 00 00 
  800f85:	ff d0                	call   *%rax
  800f87:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  800f8d:	0f 87 8c 00 00 00    	ja     80101f <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  800f93:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  800f97:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  800f9e:	00 00 00 
  800fa1:	ff d0                	call   *%rax
  800fa3:	89 c3                	mov    %eax,%ebx
  800fa5:	85 c0                	test   %eax,%eax
  800fa7:	78 52                	js     800ffb <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  800fa9:	4c 89 e6             	mov    %r12,%rsi
  800fac:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  800fb3:	00 00 00 
  800fb6:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  800fbd:	00 00 00 
  800fc0:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  800fc2:	44 89 e8             	mov    %r13d,%eax
  800fc5:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  800fcc:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fce:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800fd2:	bf 01 00 00 00       	mov    $0x1,%edi
  800fd7:	48 b8 ea 0c 80 00 00 	movabs $0x800cea,%rax
  800fde:	00 00 00 
  800fe1:	ff d0                	call   *%rax
  800fe3:	89 c3                	mov    %eax,%ebx
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	78 1f                	js     801008 <open+0xa0>
    return fd2num(fd);
  800fe9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800fed:	48 b8 05 06 80 00 00 	movabs $0x800605,%rax
  800ff4:	00 00 00 
  800ff7:	ff d0                	call   *%rax
  800ff9:	89 c3                	mov    %eax,%ebx
}
  800ffb:	89 d8                	mov    %ebx,%eax
  800ffd:	48 83 c4 18          	add    $0x18,%rsp
  801001:	5b                   	pop    %rbx
  801002:	41 5c                	pop    %r12
  801004:	41 5d                	pop    %r13
  801006:	5d                   	pop    %rbp
  801007:	c3                   	ret    
        fd_close(fd, 0);
  801008:	be 00 00 00 00       	mov    $0x0,%esi
  80100d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801011:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  801018:	00 00 00 
  80101b:	ff d0                	call   *%rax
        return res;
  80101d:	eb dc                	jmp    800ffb <open+0x93>
        return -E_BAD_PATH;
  80101f:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801024:	eb d5                	jmp    800ffb <open+0x93>

0000000000801026 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801026:	55                   	push   %rbp
  801027:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80102a:	be 00 00 00 00       	mov    $0x0,%esi
  80102f:	bf 08 00 00 00       	mov    $0x8,%edi
  801034:	48 b8 ea 0c 80 00 00 	movabs $0x800cea,%rax
  80103b:	00 00 00 
  80103e:	ff d0                	call   *%rax
}
  801040:	5d                   	pop    %rbp
  801041:	c3                   	ret    

0000000000801042 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801042:	55                   	push   %rbp
  801043:	48 89 e5             	mov    %rsp,%rbp
  801046:	41 54                	push   %r12
  801048:	53                   	push   %rbx
  801049:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80104c:	48 b8 17 06 80 00 00 	movabs $0x800617,%rax
  801053:	00 00 00 
  801056:	ff d0                	call   *%rax
  801058:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80105b:	48 be c0 2a 80 00 00 	movabs $0x802ac0,%rsi
  801062:	00 00 00 
  801065:	48 89 df             	mov    %rbx,%rdi
  801068:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  80106f:	00 00 00 
  801072:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801074:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801079:	41 2b 04 24          	sub    (%r12),%eax
  80107d:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801083:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80108a:	00 00 00 
    stat->st_dev = &devpipe;
  80108d:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801094:	00 00 00 
  801097:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80109e:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a3:	5b                   	pop    %rbx
  8010a4:	41 5c                	pop    %r12
  8010a6:	5d                   	pop    %rbp
  8010a7:	c3                   	ret    

00000000008010a8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8010a8:	55                   	push   %rbp
  8010a9:	48 89 e5             	mov    %rsp,%rbp
  8010ac:	41 54                	push   %r12
  8010ae:	53                   	push   %rbx
  8010af:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8010b2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010b7:	48 89 fe             	mov    %rdi,%rsi
  8010ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8010bf:	49 bc 6c 03 80 00 00 	movabs $0x80036c,%r12
  8010c6:	00 00 00 
  8010c9:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8010cc:	48 89 df             	mov    %rbx,%rdi
  8010cf:	48 b8 17 06 80 00 00 	movabs $0x800617,%rax
  8010d6:	00 00 00 
  8010d9:	ff d0                	call   *%rax
  8010db:	48 89 c6             	mov    %rax,%rsi
  8010de:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8010e8:	41 ff d4             	call   *%r12
}
  8010eb:	5b                   	pop    %rbx
  8010ec:	41 5c                	pop    %r12
  8010ee:	5d                   	pop    %rbp
  8010ef:	c3                   	ret    

00000000008010f0 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8010f0:	55                   	push   %rbp
  8010f1:	48 89 e5             	mov    %rsp,%rbp
  8010f4:	41 57                	push   %r15
  8010f6:	41 56                	push   %r14
  8010f8:	41 55                	push   %r13
  8010fa:	41 54                	push   %r12
  8010fc:	53                   	push   %rbx
  8010fd:	48 83 ec 18          	sub    $0x18,%rsp
  801101:	49 89 fc             	mov    %rdi,%r12
  801104:	49 89 f5             	mov    %rsi,%r13
  801107:	49 89 d7             	mov    %rdx,%r15
  80110a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80110e:	48 b8 17 06 80 00 00 	movabs $0x800617,%rax
  801115:	00 00 00 
  801118:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80111a:	4d 85 ff             	test   %r15,%r15
  80111d:	0f 84 ac 00 00 00    	je     8011cf <devpipe_write+0xdf>
  801123:	48 89 c3             	mov    %rax,%rbx
  801126:	4c 89 f8             	mov    %r15,%rax
  801129:	4d 89 ef             	mov    %r13,%r15
  80112c:	49 01 c5             	add    %rax,%r13
  80112f:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801133:	49 bd 74 02 80 00 00 	movabs $0x800274,%r13
  80113a:	00 00 00 
            sys_yield();
  80113d:	49 be 11 02 80 00 00 	movabs $0x800211,%r14
  801144:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801147:	8b 73 04             	mov    0x4(%rbx),%esi
  80114a:	48 63 ce             	movslq %esi,%rcx
  80114d:	48 63 03             	movslq (%rbx),%rax
  801150:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801156:	48 39 c1             	cmp    %rax,%rcx
  801159:	72 2e                	jb     801189 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80115b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801160:	48 89 da             	mov    %rbx,%rdx
  801163:	be 00 10 00 00       	mov    $0x1000,%esi
  801168:	4c 89 e7             	mov    %r12,%rdi
  80116b:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80116e:	85 c0                	test   %eax,%eax
  801170:	74 63                	je     8011d5 <devpipe_write+0xe5>
            sys_yield();
  801172:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801175:	8b 73 04             	mov    0x4(%rbx),%esi
  801178:	48 63 ce             	movslq %esi,%rcx
  80117b:	48 63 03             	movslq (%rbx),%rax
  80117e:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801184:	48 39 c1             	cmp    %rax,%rcx
  801187:	73 d2                	jae    80115b <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801189:	41 0f b6 3f          	movzbl (%r15),%edi
  80118d:	48 89 ca             	mov    %rcx,%rdx
  801190:	48 c1 ea 03          	shr    $0x3,%rdx
  801194:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80119b:	08 10 20 
  80119e:	48 f7 e2             	mul    %rdx
  8011a1:	48 c1 ea 06          	shr    $0x6,%rdx
  8011a5:	48 89 d0             	mov    %rdx,%rax
  8011a8:	48 c1 e0 09          	shl    $0x9,%rax
  8011ac:	48 29 d0             	sub    %rdx,%rax
  8011af:	48 c1 e0 03          	shl    $0x3,%rax
  8011b3:	48 29 c1             	sub    %rax,%rcx
  8011b6:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8011bb:	83 c6 01             	add    $0x1,%esi
  8011be:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8011c1:	49 83 c7 01          	add    $0x1,%r15
  8011c5:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8011c9:	0f 85 78 ff ff ff    	jne    801147 <devpipe_write+0x57>
    return n;
  8011cf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8011d3:	eb 05                	jmp    8011da <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8011d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011da:	48 83 c4 18          	add    $0x18,%rsp
  8011de:	5b                   	pop    %rbx
  8011df:	41 5c                	pop    %r12
  8011e1:	41 5d                	pop    %r13
  8011e3:	41 5e                	pop    %r14
  8011e5:	41 5f                	pop    %r15
  8011e7:	5d                   	pop    %rbp
  8011e8:	c3                   	ret    

00000000008011e9 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8011e9:	55                   	push   %rbp
  8011ea:	48 89 e5             	mov    %rsp,%rbp
  8011ed:	41 57                	push   %r15
  8011ef:	41 56                	push   %r14
  8011f1:	41 55                	push   %r13
  8011f3:	41 54                	push   %r12
  8011f5:	53                   	push   %rbx
  8011f6:	48 83 ec 18          	sub    $0x18,%rsp
  8011fa:	49 89 fc             	mov    %rdi,%r12
  8011fd:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801201:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801205:	48 b8 17 06 80 00 00 	movabs $0x800617,%rax
  80120c:	00 00 00 
  80120f:	ff d0                	call   *%rax
  801211:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  801214:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80121a:	49 bd 74 02 80 00 00 	movabs $0x800274,%r13
  801221:	00 00 00 
            sys_yield();
  801224:	49 be 11 02 80 00 00 	movabs $0x800211,%r14
  80122b:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80122e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801233:	74 7a                	je     8012af <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801235:	8b 03                	mov    (%rbx),%eax
  801237:	3b 43 04             	cmp    0x4(%rbx),%eax
  80123a:	75 26                	jne    801262 <devpipe_read+0x79>
            if (i > 0) return i;
  80123c:	4d 85 ff             	test   %r15,%r15
  80123f:	75 74                	jne    8012b5 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801241:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801246:	48 89 da             	mov    %rbx,%rdx
  801249:	be 00 10 00 00       	mov    $0x1000,%esi
  80124e:	4c 89 e7             	mov    %r12,%rdi
  801251:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801254:	85 c0                	test   %eax,%eax
  801256:	74 6f                	je     8012c7 <devpipe_read+0xde>
            sys_yield();
  801258:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80125b:	8b 03                	mov    (%rbx),%eax
  80125d:	3b 43 04             	cmp    0x4(%rbx),%eax
  801260:	74 df                	je     801241 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801262:	48 63 c8             	movslq %eax,%rcx
  801265:	48 89 ca             	mov    %rcx,%rdx
  801268:	48 c1 ea 03          	shr    $0x3,%rdx
  80126c:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801273:	08 10 20 
  801276:	48 f7 e2             	mul    %rdx
  801279:	48 c1 ea 06          	shr    $0x6,%rdx
  80127d:	48 89 d0             	mov    %rdx,%rax
  801280:	48 c1 e0 09          	shl    $0x9,%rax
  801284:	48 29 d0             	sub    %rdx,%rax
  801287:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80128e:	00 
  80128f:	48 89 c8             	mov    %rcx,%rax
  801292:	48 29 d0             	sub    %rdx,%rax
  801295:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80129a:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80129e:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8012a2:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012a5:	49 83 c7 01          	add    $0x1,%r15
  8012a9:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8012ad:	75 86                	jne    801235 <devpipe_read+0x4c>
    return n;
  8012af:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012b3:	eb 03                	jmp    8012b8 <devpipe_read+0xcf>
            if (i > 0) return i;
  8012b5:	4c 89 f8             	mov    %r15,%rax
}
  8012b8:	48 83 c4 18          	add    $0x18,%rsp
  8012bc:	5b                   	pop    %rbx
  8012bd:	41 5c                	pop    %r12
  8012bf:	41 5d                	pop    %r13
  8012c1:	41 5e                	pop    %r14
  8012c3:	41 5f                	pop    %r15
  8012c5:	5d                   	pop    %rbp
  8012c6:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8012c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cc:	eb ea                	jmp    8012b8 <devpipe_read+0xcf>

00000000008012ce <pipe>:
pipe(int pfd[2]) {
  8012ce:	55                   	push   %rbp
  8012cf:	48 89 e5             	mov    %rsp,%rbp
  8012d2:	41 55                	push   %r13
  8012d4:	41 54                	push   %r12
  8012d6:	53                   	push   %rbx
  8012d7:	48 83 ec 18          	sub    $0x18,%rsp
  8012db:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8012de:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8012e2:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  8012e9:	00 00 00 
  8012ec:	ff d0                	call   *%rax
  8012ee:	89 c3                	mov    %eax,%ebx
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	0f 88 a0 01 00 00    	js     801498 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8012f8:	b9 46 00 00 00       	mov    $0x46,%ecx
  8012fd:	ba 00 10 00 00       	mov    $0x1000,%edx
  801302:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801306:	bf 00 00 00 00       	mov    $0x0,%edi
  80130b:	48 b8 a0 02 80 00 00 	movabs $0x8002a0,%rax
  801312:	00 00 00 
  801315:	ff d0                	call   *%rax
  801317:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801319:	85 c0                	test   %eax,%eax
  80131b:	0f 88 77 01 00 00    	js     801498 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801321:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  801325:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  80132c:	00 00 00 
  80132f:	ff d0                	call   *%rax
  801331:	89 c3                	mov    %eax,%ebx
  801333:	85 c0                	test   %eax,%eax
  801335:	0f 88 43 01 00 00    	js     80147e <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80133b:	b9 46 00 00 00       	mov    $0x46,%ecx
  801340:	ba 00 10 00 00       	mov    $0x1000,%edx
  801345:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801349:	bf 00 00 00 00       	mov    $0x0,%edi
  80134e:	48 b8 a0 02 80 00 00 	movabs $0x8002a0,%rax
  801355:	00 00 00 
  801358:	ff d0                	call   *%rax
  80135a:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80135c:	85 c0                	test   %eax,%eax
  80135e:	0f 88 1a 01 00 00    	js     80147e <pipe+0x1b0>
    va = fd2data(fd0);
  801364:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801368:	48 b8 17 06 80 00 00 	movabs $0x800617,%rax
  80136f:	00 00 00 
  801372:	ff d0                	call   *%rax
  801374:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801377:	b9 46 00 00 00       	mov    $0x46,%ecx
  80137c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801381:	48 89 c6             	mov    %rax,%rsi
  801384:	bf 00 00 00 00       	mov    $0x0,%edi
  801389:	48 b8 a0 02 80 00 00 	movabs $0x8002a0,%rax
  801390:	00 00 00 
  801393:	ff d0                	call   *%rax
  801395:	89 c3                	mov    %eax,%ebx
  801397:	85 c0                	test   %eax,%eax
  801399:	0f 88 c5 00 00 00    	js     801464 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80139f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8013a3:	48 b8 17 06 80 00 00 	movabs $0x800617,%rax
  8013aa:	00 00 00 
  8013ad:	ff d0                	call   *%rax
  8013af:	48 89 c1             	mov    %rax,%rcx
  8013b2:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8013b8:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8013be:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c3:	4c 89 ee             	mov    %r13,%rsi
  8013c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8013cb:	48 b8 07 03 80 00 00 	movabs $0x800307,%rax
  8013d2:	00 00 00 
  8013d5:	ff d0                	call   *%rax
  8013d7:	89 c3                	mov    %eax,%ebx
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	78 6e                	js     80144b <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8013dd:	be 00 10 00 00       	mov    $0x1000,%esi
  8013e2:	4c 89 ef             	mov    %r13,%rdi
  8013e5:	48 b8 42 02 80 00 00 	movabs $0x800242,%rax
  8013ec:	00 00 00 
  8013ef:	ff d0                	call   *%rax
  8013f1:	83 f8 02             	cmp    $0x2,%eax
  8013f4:	0f 85 ab 00 00 00    	jne    8014a5 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8013fa:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  801401:	00 00 
  801403:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801407:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  801409:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80140d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  801414:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801418:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80141a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80141e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801425:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801429:	48 bb 05 06 80 00 00 	movabs $0x800605,%rbx
  801430:	00 00 00 
  801433:	ff d3                	call   *%rbx
  801435:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801439:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80143d:	ff d3                	call   *%rbx
  80143f:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  801444:	bb 00 00 00 00       	mov    $0x0,%ebx
  801449:	eb 4d                	jmp    801498 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  80144b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801450:	4c 89 ee             	mov    %r13,%rsi
  801453:	bf 00 00 00 00       	mov    $0x0,%edi
  801458:	48 b8 6c 03 80 00 00 	movabs $0x80036c,%rax
  80145f:	00 00 00 
  801462:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  801464:	ba 00 10 00 00       	mov    $0x1000,%edx
  801469:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80146d:	bf 00 00 00 00       	mov    $0x0,%edi
  801472:	48 b8 6c 03 80 00 00 	movabs $0x80036c,%rax
  801479:	00 00 00 
  80147c:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80147e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801483:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801487:	bf 00 00 00 00       	mov    $0x0,%edi
  80148c:	48 b8 6c 03 80 00 00 	movabs $0x80036c,%rax
  801493:	00 00 00 
  801496:	ff d0                	call   *%rax
}
  801498:	89 d8                	mov    %ebx,%eax
  80149a:	48 83 c4 18          	add    $0x18,%rsp
  80149e:	5b                   	pop    %rbx
  80149f:	41 5c                	pop    %r12
  8014a1:	41 5d                	pop    %r13
  8014a3:	5d                   	pop    %rbp
  8014a4:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014a5:	48 b9 f0 2a 80 00 00 	movabs $0x802af0,%rcx
  8014ac:	00 00 00 
  8014af:	48 ba c7 2a 80 00 00 	movabs $0x802ac7,%rdx
  8014b6:	00 00 00 
  8014b9:	be 2e 00 00 00       	mov    $0x2e,%esi
  8014be:	48 bf dc 2a 80 00 00 	movabs $0x802adc,%rdi
  8014c5:	00 00 00 
  8014c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cd:	49 b8 63 19 80 00 00 	movabs $0x801963,%r8
  8014d4:	00 00 00 
  8014d7:	41 ff d0             	call   *%r8

00000000008014da <pipeisclosed>:
pipeisclosed(int fdnum) {
  8014da:	55                   	push   %rbp
  8014db:	48 89 e5             	mov    %rsp,%rbp
  8014de:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8014e2:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8014e6:	48 b8 93 06 80 00 00 	movabs $0x800693,%rax
  8014ed:	00 00 00 
  8014f0:	ff d0                	call   *%rax
    if (res < 0) return res;
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	78 35                	js     80152b <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8014f6:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8014fa:	48 b8 17 06 80 00 00 	movabs $0x800617,%rax
  801501:	00 00 00 
  801504:	ff d0                	call   *%rax
  801506:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801509:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80150e:	be 00 10 00 00       	mov    $0x1000,%esi
  801513:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801517:	48 b8 74 02 80 00 00 	movabs $0x800274,%rax
  80151e:	00 00 00 
  801521:	ff d0                	call   *%rax
  801523:	85 c0                	test   %eax,%eax
  801525:	0f 94 c0             	sete   %al
  801528:	0f b6 c0             	movzbl %al,%eax
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

000000000080152d <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80152d:	48 89 f8             	mov    %rdi,%rax
  801530:	48 c1 e8 27          	shr    $0x27,%rax
  801534:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80153b:	01 00 00 
  80153e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801542:	f6 c2 01             	test   $0x1,%dl
  801545:	74 6d                	je     8015b4 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801547:	48 89 f8             	mov    %rdi,%rax
  80154a:	48 c1 e8 1e          	shr    $0x1e,%rax
  80154e:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801555:	01 00 00 
  801558:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80155c:	f6 c2 01             	test   $0x1,%dl
  80155f:	74 62                	je     8015c3 <get_uvpt_entry+0x96>
  801561:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801568:	01 00 00 
  80156b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80156f:	f6 c2 80             	test   $0x80,%dl
  801572:	75 4f                	jne    8015c3 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801574:	48 89 f8             	mov    %rdi,%rax
  801577:	48 c1 e8 15          	shr    $0x15,%rax
  80157b:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801582:	01 00 00 
  801585:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801589:	f6 c2 01             	test   $0x1,%dl
  80158c:	74 44                	je     8015d2 <get_uvpt_entry+0xa5>
  80158e:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801595:	01 00 00 
  801598:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80159c:	f6 c2 80             	test   $0x80,%dl
  80159f:	75 31                	jne    8015d2 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8015a1:	48 c1 ef 0c          	shr    $0xc,%rdi
  8015a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8015ac:	01 00 00 
  8015af:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8015b3:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8015b4:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8015bb:	01 00 00 
  8015be:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015c2:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8015c3:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8015ca:	01 00 00 
  8015cd:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015d1:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8015d2:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8015d9:	01 00 00 
  8015dc:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8015e0:	c3                   	ret    

00000000008015e1 <get_prot>:

int
get_prot(void *va) {
  8015e1:	55                   	push   %rbp
  8015e2:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8015e5:	48 b8 2d 15 80 00 00 	movabs $0x80152d,%rax
  8015ec:	00 00 00 
  8015ef:	ff d0                	call   *%rax
  8015f1:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8015f4:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8015f9:	89 c1                	mov    %eax,%ecx
  8015fb:	83 c9 04             	or     $0x4,%ecx
  8015fe:	f6 c2 01             	test   $0x1,%dl
  801601:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  801604:	89 c1                	mov    %eax,%ecx
  801606:	83 c9 02             	or     $0x2,%ecx
  801609:	f6 c2 02             	test   $0x2,%dl
  80160c:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80160f:	89 c1                	mov    %eax,%ecx
  801611:	83 c9 01             	or     $0x1,%ecx
  801614:	48 85 d2             	test   %rdx,%rdx
  801617:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80161a:	89 c1                	mov    %eax,%ecx
  80161c:	83 c9 40             	or     $0x40,%ecx
  80161f:	f6 c6 04             	test   $0x4,%dh
  801622:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801625:	5d                   	pop    %rbp
  801626:	c3                   	ret    

0000000000801627 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801627:	55                   	push   %rbp
  801628:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80162b:	48 b8 2d 15 80 00 00 	movabs $0x80152d,%rax
  801632:	00 00 00 
  801635:	ff d0                	call   *%rax
    return pte & PTE_D;
  801637:	48 c1 e8 06          	shr    $0x6,%rax
  80163b:	83 e0 01             	and    $0x1,%eax
}
  80163e:	5d                   	pop    %rbp
  80163f:	c3                   	ret    

0000000000801640 <is_page_present>:

bool
is_page_present(void *va) {
  801640:	55                   	push   %rbp
  801641:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801644:	48 b8 2d 15 80 00 00 	movabs $0x80152d,%rax
  80164b:	00 00 00 
  80164e:	ff d0                	call   *%rax
  801650:	83 e0 01             	and    $0x1,%eax
}
  801653:	5d                   	pop    %rbp
  801654:	c3                   	ret    

0000000000801655 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801655:	55                   	push   %rbp
  801656:	48 89 e5             	mov    %rsp,%rbp
  801659:	41 57                	push   %r15
  80165b:	41 56                	push   %r14
  80165d:	41 55                	push   %r13
  80165f:	41 54                	push   %r12
  801661:	53                   	push   %rbx
  801662:	48 83 ec 28          	sub    $0x28,%rsp
  801666:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  80166a:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  80166e:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  801673:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  80167a:	01 00 00 
  80167d:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  801684:	01 00 00 
  801687:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  80168e:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  801691:	49 bf e1 15 80 00 00 	movabs $0x8015e1,%r15
  801698:	00 00 00 
  80169b:	eb 16                	jmp    8016b3 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  80169d:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8016a4:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8016ab:	00 00 00 
  8016ae:	48 39 c3             	cmp    %rax,%rbx
  8016b1:	77 73                	ja     801726 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8016b3:	48 89 d8             	mov    %rbx,%rax
  8016b6:	48 c1 e8 27          	shr    $0x27,%rax
  8016ba:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8016be:	a8 01                	test   $0x1,%al
  8016c0:	74 db                	je     80169d <foreach_shared_region+0x48>
  8016c2:	48 89 d8             	mov    %rbx,%rax
  8016c5:	48 c1 e8 1e          	shr    $0x1e,%rax
  8016c9:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8016ce:	a8 01                	test   $0x1,%al
  8016d0:	74 cb                	je     80169d <foreach_shared_region+0x48>
  8016d2:	48 89 d8             	mov    %rbx,%rax
  8016d5:	48 c1 e8 15          	shr    $0x15,%rax
  8016d9:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8016dd:	a8 01                	test   $0x1,%al
  8016df:	74 bc                	je     80169d <foreach_shared_region+0x48>
        void *start = (void*)i;
  8016e1:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016e5:	48 89 df             	mov    %rbx,%rdi
  8016e8:	41 ff d7             	call   *%r15
  8016eb:	a8 40                	test   $0x40,%al
  8016ed:	75 09                	jne    8016f8 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8016ef:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8016f6:	eb ac                	jmp    8016a4 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8016f8:	48 89 df             	mov    %rbx,%rdi
  8016fb:	48 b8 40 16 80 00 00 	movabs $0x801640,%rax
  801702:	00 00 00 
  801705:	ff d0                	call   *%rax
  801707:	84 c0                	test   %al,%al
  801709:	74 e4                	je     8016ef <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  80170b:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  801712:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801716:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80171a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80171e:	ff d0                	call   *%rax
  801720:	85 c0                	test   %eax,%eax
  801722:	79 cb                	jns    8016ef <foreach_shared_region+0x9a>
  801724:	eb 05                	jmp    80172b <foreach_shared_region+0xd6>
    }
    return 0;
  801726:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172b:	48 83 c4 28          	add    $0x28,%rsp
  80172f:	5b                   	pop    %rbx
  801730:	41 5c                	pop    %r12
  801732:	41 5d                	pop    %r13
  801734:	41 5e                	pop    %r14
  801736:	41 5f                	pop    %r15
  801738:	5d                   	pop    %rbp
  801739:	c3                   	ret    

000000000080173a <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax
  80173f:	c3                   	ret    

0000000000801740 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  801740:	55                   	push   %rbp
  801741:	48 89 e5             	mov    %rsp,%rbp
  801744:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  801747:	48 be 14 2b 80 00 00 	movabs $0x802b14,%rsi
  80174e:	00 00 00 
  801751:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  801758:	00 00 00 
  80175b:	ff d0                	call   *%rax
    return 0;
}
  80175d:	b8 00 00 00 00       	mov    $0x0,%eax
  801762:	5d                   	pop    %rbp
  801763:	c3                   	ret    

0000000000801764 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  801764:	55                   	push   %rbp
  801765:	48 89 e5             	mov    %rsp,%rbp
  801768:	41 57                	push   %r15
  80176a:	41 56                	push   %r14
  80176c:	41 55                	push   %r13
  80176e:	41 54                	push   %r12
  801770:	53                   	push   %rbx
  801771:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  801778:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80177f:	48 85 d2             	test   %rdx,%rdx
  801782:	74 78                	je     8017fc <devcons_write+0x98>
  801784:	49 89 d6             	mov    %rdx,%r14
  801787:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80178d:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801792:	49 bf ef 25 80 00 00 	movabs $0x8025ef,%r15
  801799:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80179c:	4c 89 f3             	mov    %r14,%rbx
  80179f:	48 29 f3             	sub    %rsi,%rbx
  8017a2:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8017a6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8017ab:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8017af:	4c 63 eb             	movslq %ebx,%r13
  8017b2:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8017b9:	4c 89 ea             	mov    %r13,%rdx
  8017bc:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017c3:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8017c6:	4c 89 ee             	mov    %r13,%rsi
  8017c9:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8017d0:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  8017d7:	00 00 00 
  8017da:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8017dc:	41 01 dc             	add    %ebx,%r12d
  8017df:	49 63 f4             	movslq %r12d,%rsi
  8017e2:	4c 39 f6             	cmp    %r14,%rsi
  8017e5:	72 b5                	jb     80179c <devcons_write+0x38>
    return res;
  8017e7:	49 63 c4             	movslq %r12d,%rax
}
  8017ea:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8017f1:	5b                   	pop    %rbx
  8017f2:	41 5c                	pop    %r12
  8017f4:	41 5d                	pop    %r13
  8017f6:	41 5e                	pop    %r14
  8017f8:	41 5f                	pop    %r15
  8017fa:	5d                   	pop    %rbp
  8017fb:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8017fc:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801802:	eb e3                	jmp    8017e7 <devcons_write+0x83>

0000000000801804 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801804:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801807:	ba 00 00 00 00       	mov    $0x0,%edx
  80180c:	48 85 c0             	test   %rax,%rax
  80180f:	74 55                	je     801866 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801811:	55                   	push   %rbp
  801812:	48 89 e5             	mov    %rsp,%rbp
  801815:	41 55                	push   %r13
  801817:	41 54                	push   %r12
  801819:	53                   	push   %rbx
  80181a:	48 83 ec 08          	sub    $0x8,%rsp
  80181e:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801821:	48 bb 44 01 80 00 00 	movabs $0x800144,%rbx
  801828:	00 00 00 
  80182b:	49 bc 11 02 80 00 00 	movabs $0x800211,%r12
  801832:	00 00 00 
  801835:	eb 03                	jmp    80183a <devcons_read+0x36>
  801837:	41 ff d4             	call   *%r12
  80183a:	ff d3                	call   *%rbx
  80183c:	85 c0                	test   %eax,%eax
  80183e:	74 f7                	je     801837 <devcons_read+0x33>
    if (c < 0) return c;
  801840:	48 63 d0             	movslq %eax,%rdx
  801843:	78 13                	js     801858 <devcons_read+0x54>
    if (c == 0x04) return 0;
  801845:	ba 00 00 00 00       	mov    $0x0,%edx
  80184a:	83 f8 04             	cmp    $0x4,%eax
  80184d:	74 09                	je     801858 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  80184f:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801853:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801858:	48 89 d0             	mov    %rdx,%rax
  80185b:	48 83 c4 08          	add    $0x8,%rsp
  80185f:	5b                   	pop    %rbx
  801860:	41 5c                	pop    %r12
  801862:	41 5d                	pop    %r13
  801864:	5d                   	pop    %rbp
  801865:	c3                   	ret    
  801866:	48 89 d0             	mov    %rdx,%rax
  801869:	c3                   	ret    

000000000080186a <cputchar>:
cputchar(int ch) {
  80186a:	55                   	push   %rbp
  80186b:	48 89 e5             	mov    %rsp,%rbp
  80186e:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801872:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801876:	be 01 00 00 00       	mov    $0x1,%esi
  80187b:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80187f:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  801886:	00 00 00 
  801889:	ff d0                	call   *%rax
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

000000000080188d <getchar>:
getchar(void) {
  80188d:	55                   	push   %rbp
  80188e:	48 89 e5             	mov    %rsp,%rbp
  801891:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801895:	ba 01 00 00 00       	mov    $0x1,%edx
  80189a:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  80189e:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a3:	48 b8 76 09 80 00 00 	movabs $0x800976,%rax
  8018aa:	00 00 00 
  8018ad:	ff d0                	call   *%rax
  8018af:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8018b1:	85 c0                	test   %eax,%eax
  8018b3:	78 06                	js     8018bb <getchar+0x2e>
  8018b5:	74 08                	je     8018bf <getchar+0x32>
  8018b7:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8018bb:	89 d0                	mov    %edx,%eax
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8018bf:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8018c4:	eb f5                	jmp    8018bb <getchar+0x2e>

00000000008018c6 <iscons>:
iscons(int fdnum) {
  8018c6:	55                   	push   %rbp
  8018c7:	48 89 e5             	mov    %rsp,%rbp
  8018ca:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8018ce:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018d2:	48 b8 93 06 80 00 00 	movabs $0x800693,%rax
  8018d9:	00 00 00 
  8018dc:	ff d0                	call   *%rax
    if (res < 0) return res;
  8018de:	85 c0                	test   %eax,%eax
  8018e0:	78 18                	js     8018fa <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8018e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018e6:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8018ed:	00 00 00 
  8018f0:	8b 00                	mov    (%rax),%eax
  8018f2:	39 02                	cmp    %eax,(%rdx)
  8018f4:	0f 94 c0             	sete   %al
  8018f7:	0f b6 c0             	movzbl %al,%eax
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

00000000008018fc <opencons>:
opencons(void) {
  8018fc:	55                   	push   %rbp
  8018fd:	48 89 e5             	mov    %rsp,%rbp
  801900:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801904:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801908:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  80190f:	00 00 00 
  801912:	ff d0                	call   *%rax
  801914:	85 c0                	test   %eax,%eax
  801916:	78 49                	js     801961 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801918:	b9 46 00 00 00       	mov    $0x46,%ecx
  80191d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801922:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801926:	bf 00 00 00 00       	mov    $0x0,%edi
  80192b:	48 b8 a0 02 80 00 00 	movabs $0x8002a0,%rax
  801932:	00 00 00 
  801935:	ff d0                	call   *%rax
  801937:	85 c0                	test   %eax,%eax
  801939:	78 26                	js     801961 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  80193b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80193f:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801946:	00 00 
  801948:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80194a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80194e:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801955:	48 b8 05 06 80 00 00 	movabs $0x800605,%rax
  80195c:	00 00 00 
  80195f:	ff d0                	call   *%rax
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

0000000000801963 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801963:	55                   	push   %rbp
  801964:	48 89 e5             	mov    %rsp,%rbp
  801967:	41 56                	push   %r14
  801969:	41 55                	push   %r13
  80196b:	41 54                	push   %r12
  80196d:	53                   	push   %rbx
  80196e:	48 83 ec 50          	sub    $0x50,%rsp
  801972:	49 89 fc             	mov    %rdi,%r12
  801975:	41 89 f5             	mov    %esi,%r13d
  801978:	48 89 d3             	mov    %rdx,%rbx
  80197b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80197f:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801983:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801987:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  80198e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801992:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801996:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80199a:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  80199e:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8019a5:	00 00 00 
  8019a8:	4c 8b 30             	mov    (%rax),%r14
  8019ab:	48 b8 e0 01 80 00 00 	movabs $0x8001e0,%rax
  8019b2:	00 00 00 
  8019b5:	ff d0                	call   *%rax
  8019b7:	89 c6                	mov    %eax,%esi
  8019b9:	45 89 e8             	mov    %r13d,%r8d
  8019bc:	4c 89 e1             	mov    %r12,%rcx
  8019bf:	4c 89 f2             	mov    %r14,%rdx
  8019c2:	48 bf 20 2b 80 00 00 	movabs $0x802b20,%rdi
  8019c9:	00 00 00 
  8019cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d1:	49 bc b3 1a 80 00 00 	movabs $0x801ab3,%r12
  8019d8:	00 00 00 
  8019db:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8019de:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8019e2:	48 89 df             	mov    %rbx,%rdi
  8019e5:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  8019ec:	00 00 00 
  8019ef:	ff d0                	call   *%rax
    cprintf("\n");
  8019f1:	48 bf 63 2a 80 00 00 	movabs $0x802a63,%rdi
  8019f8:	00 00 00 
  8019fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801a00:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801a03:	cc                   	int3   
  801a04:	eb fd                	jmp    801a03 <_panic+0xa0>

0000000000801a06 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801a06:	55                   	push   %rbp
  801a07:	48 89 e5             	mov    %rsp,%rbp
  801a0a:	53                   	push   %rbx
  801a0b:	48 83 ec 08          	sub    $0x8,%rsp
  801a0f:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801a12:	8b 06                	mov    (%rsi),%eax
  801a14:	8d 50 01             	lea    0x1(%rax),%edx
  801a17:	89 16                	mov    %edx,(%rsi)
  801a19:	48 98                	cltq   
  801a1b:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801a20:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801a26:	74 0a                	je     801a32 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801a28:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801a2c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  801a32:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801a36:	be ff 00 00 00       	mov    $0xff,%esi
  801a3b:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  801a42:	00 00 00 
  801a45:	ff d0                	call   *%rax
        state->offset = 0;
  801a47:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801a4d:	eb d9                	jmp    801a28 <putch+0x22>

0000000000801a4f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801a4f:	55                   	push   %rbp
  801a50:	48 89 e5             	mov    %rsp,%rbp
  801a53:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801a5a:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801a5d:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801a64:	b9 21 00 00 00       	mov    $0x21,%ecx
  801a69:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6e:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801a71:	48 89 f1             	mov    %rsi,%rcx
  801a74:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801a7b:	48 bf 06 1a 80 00 00 	movabs $0x801a06,%rdi
  801a82:	00 00 00 
  801a85:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  801a8c:	00 00 00 
  801a8f:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801a91:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801a98:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801a9f:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  801aa6:	00 00 00 
  801aa9:	ff d0                	call   *%rax

    return state.count;
}
  801aab:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

0000000000801ab3 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801ab3:	55                   	push   %rbp
  801ab4:	48 89 e5             	mov    %rsp,%rbp
  801ab7:	48 83 ec 50          	sub    $0x50,%rsp
  801abb:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801abf:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801ac3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ac7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801acb:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801acf:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801ad6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ada:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ade:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801ae2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801ae6:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801aea:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  801af1:	00 00 00 
  801af4:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

0000000000801af8 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801af8:	55                   	push   %rbp
  801af9:	48 89 e5             	mov    %rsp,%rbp
  801afc:	41 57                	push   %r15
  801afe:	41 56                	push   %r14
  801b00:	41 55                	push   %r13
  801b02:	41 54                	push   %r12
  801b04:	53                   	push   %rbx
  801b05:	48 83 ec 18          	sub    $0x18,%rsp
  801b09:	49 89 fc             	mov    %rdi,%r12
  801b0c:	49 89 f5             	mov    %rsi,%r13
  801b0f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801b13:	8b 45 10             	mov    0x10(%rbp),%eax
  801b16:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801b19:	41 89 cf             	mov    %ecx,%r15d
  801b1c:	49 39 d7             	cmp    %rdx,%r15
  801b1f:	76 5b                	jbe    801b7c <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801b21:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801b25:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801b29:	85 db                	test   %ebx,%ebx
  801b2b:	7e 0e                	jle    801b3b <print_num+0x43>
            putch(padc, put_arg);
  801b2d:	4c 89 ee             	mov    %r13,%rsi
  801b30:	44 89 f7             	mov    %r14d,%edi
  801b33:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801b36:	83 eb 01             	sub    $0x1,%ebx
  801b39:	75 f2                	jne    801b2d <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801b3b:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801b3f:	48 b9 43 2b 80 00 00 	movabs $0x802b43,%rcx
  801b46:	00 00 00 
  801b49:	48 b8 54 2b 80 00 00 	movabs $0x802b54,%rax
  801b50:	00 00 00 
  801b53:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801b57:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b60:	49 f7 f7             	div    %r15
  801b63:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801b67:	4c 89 ee             	mov    %r13,%rsi
  801b6a:	41 ff d4             	call   *%r12
}
  801b6d:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801b71:	5b                   	pop    %rbx
  801b72:	41 5c                	pop    %r12
  801b74:	41 5d                	pop    %r13
  801b76:	41 5e                	pop    %r14
  801b78:	41 5f                	pop    %r15
  801b7a:	5d                   	pop    %rbp
  801b7b:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801b7c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b80:	ba 00 00 00 00       	mov    $0x0,%edx
  801b85:	49 f7 f7             	div    %r15
  801b88:	48 83 ec 08          	sub    $0x8,%rsp
  801b8c:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801b90:	52                   	push   %rdx
  801b91:	45 0f be c9          	movsbl %r9b,%r9d
  801b95:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801b99:	48 89 c2             	mov    %rax,%rdx
  801b9c:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  801ba3:	00 00 00 
  801ba6:	ff d0                	call   *%rax
  801ba8:	48 83 c4 10          	add    $0x10,%rsp
  801bac:	eb 8d                	jmp    801b3b <print_num+0x43>

0000000000801bae <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  801bae:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801bb2:	48 8b 06             	mov    (%rsi),%rax
  801bb5:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801bb9:	73 0a                	jae    801bc5 <sprintputch+0x17>
        *state->start++ = ch;
  801bbb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bbf:	48 89 16             	mov    %rdx,(%rsi)
  801bc2:	40 88 38             	mov    %dil,(%rax)
    }
}
  801bc5:	c3                   	ret    

0000000000801bc6 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801bc6:	55                   	push   %rbp
  801bc7:	48 89 e5             	mov    %rsp,%rbp
  801bca:	48 83 ec 50          	sub    $0x50,%rsp
  801bce:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bd2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801bd6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801bda:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801be1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801be5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801be9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801bed:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801bf1:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801bf5:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  801bfc:	00 00 00 
  801bff:	ff d0                	call   *%rax
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

0000000000801c03 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801c03:	55                   	push   %rbp
  801c04:	48 89 e5             	mov    %rsp,%rbp
  801c07:	41 57                	push   %r15
  801c09:	41 56                	push   %r14
  801c0b:	41 55                	push   %r13
  801c0d:	41 54                	push   %r12
  801c0f:	53                   	push   %rbx
  801c10:	48 83 ec 48          	sub    $0x48,%rsp
  801c14:	49 89 fc             	mov    %rdi,%r12
  801c17:	49 89 f6             	mov    %rsi,%r14
  801c1a:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  801c1d:	48 8b 01             	mov    (%rcx),%rax
  801c20:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801c24:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801c28:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801c2c:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801c30:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801c34:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  801c38:	41 0f b6 3f          	movzbl (%r15),%edi
  801c3c:	40 80 ff 25          	cmp    $0x25,%dil
  801c40:	74 18                	je     801c5a <vprintfmt+0x57>
            if (!ch) return;
  801c42:	40 84 ff             	test   %dil,%dil
  801c45:	0f 84 d1 06 00 00    	je     80231c <vprintfmt+0x719>
            putch(ch, put_arg);
  801c4b:	40 0f b6 ff          	movzbl %dil,%edi
  801c4f:	4c 89 f6             	mov    %r14,%rsi
  801c52:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  801c55:	49 89 df             	mov    %rbx,%r15
  801c58:	eb da                	jmp    801c34 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  801c5a:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  801c5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c63:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  801c67:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801c6c:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801c72:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801c79:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  801c7d:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  801c82:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  801c88:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  801c8c:	44 0f b6 0b          	movzbl (%rbx),%r9d
  801c90:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  801c94:	3c 57                	cmp    $0x57,%al
  801c96:	0f 87 65 06 00 00    	ja     802301 <vprintfmt+0x6fe>
  801c9c:	0f b6 c0             	movzbl %al,%eax
  801c9f:	49 ba e0 2c 80 00 00 	movabs $0x802ce0,%r10
  801ca6:	00 00 00 
  801ca9:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  801cad:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  801cb0:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  801cb4:	eb d2                	jmp    801c88 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  801cb6:	4c 89 fb             	mov    %r15,%rbx
  801cb9:	44 89 c1             	mov    %r8d,%ecx
  801cbc:	eb ca                	jmp    801c88 <vprintfmt+0x85>
            padc = ch;
  801cbe:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  801cc2:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801cc5:	eb c1                	jmp    801c88 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cc7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801cca:	83 f8 2f             	cmp    $0x2f,%eax
  801ccd:	77 24                	ja     801cf3 <vprintfmt+0xf0>
  801ccf:	41 89 c1             	mov    %eax,%r9d
  801cd2:	49 01 f1             	add    %rsi,%r9
  801cd5:	83 c0 08             	add    $0x8,%eax
  801cd8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801cdb:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  801cde:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  801ce1:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801ce5:	79 a1                	jns    801c88 <vprintfmt+0x85>
                width = precision;
  801ce7:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  801ceb:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801cf1:	eb 95                	jmp    801c88 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  801cf3:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  801cf7:	49 8d 41 08          	lea    0x8(%r9),%rax
  801cfb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801cff:	eb da                	jmp    801cdb <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  801d01:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  801d05:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d09:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  801d0d:	3c 39                	cmp    $0x39,%al
  801d0f:	77 1e                	ja     801d2f <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  801d11:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  801d15:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  801d1a:	0f b6 c0             	movzbl %al,%eax
  801d1d:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801d22:	41 0f b6 07          	movzbl (%r15),%eax
  801d26:	3c 39                	cmp    $0x39,%al
  801d28:	76 e7                	jbe    801d11 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  801d2a:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  801d2d:	eb b2                	jmp    801ce1 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  801d2f:	4c 89 fb             	mov    %r15,%rbx
  801d32:	eb ad                	jmp    801ce1 <vprintfmt+0xde>
            width = MAX(0, width);
  801d34:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801d37:	85 c0                	test   %eax,%eax
  801d39:	0f 48 c7             	cmovs  %edi,%eax
  801d3c:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801d3f:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d42:	e9 41 ff ff ff       	jmp    801c88 <vprintfmt+0x85>
            lflag++;
  801d47:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801d4a:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801d4d:	e9 36 ff ff ff       	jmp    801c88 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  801d52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d55:	83 f8 2f             	cmp    $0x2f,%eax
  801d58:	77 18                	ja     801d72 <vprintfmt+0x16f>
  801d5a:	89 c2                	mov    %eax,%edx
  801d5c:	48 01 f2             	add    %rsi,%rdx
  801d5f:	83 c0 08             	add    $0x8,%eax
  801d62:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d65:	4c 89 f6             	mov    %r14,%rsi
  801d68:	8b 3a                	mov    (%rdx),%edi
  801d6a:	41 ff d4             	call   *%r12
            break;
  801d6d:	e9 c2 fe ff ff       	jmp    801c34 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  801d72:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801d76:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801d7a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d7e:	eb e5                	jmp    801d65 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  801d80:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d83:	83 f8 2f             	cmp    $0x2f,%eax
  801d86:	77 5b                	ja     801de3 <vprintfmt+0x1e0>
  801d88:	89 c2                	mov    %eax,%edx
  801d8a:	48 01 d6             	add    %rdx,%rsi
  801d8d:	83 c0 08             	add    $0x8,%eax
  801d90:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d93:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  801d95:	89 c8                	mov    %ecx,%eax
  801d97:	c1 f8 1f             	sar    $0x1f,%eax
  801d9a:	31 c1                	xor    %eax,%ecx
  801d9c:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  801d9e:	83 f9 13             	cmp    $0x13,%ecx
  801da1:	7f 4e                	jg     801df1 <vprintfmt+0x1ee>
  801da3:	48 63 c1             	movslq %ecx,%rax
  801da6:	48 ba a0 2f 80 00 00 	movabs $0x802fa0,%rdx
  801dad:	00 00 00 
  801db0:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801db4:	48 85 c0             	test   %rax,%rax
  801db7:	74 38                	je     801df1 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  801db9:	48 89 c1             	mov    %rax,%rcx
  801dbc:	48 ba d9 2a 80 00 00 	movabs $0x802ad9,%rdx
  801dc3:	00 00 00 
  801dc6:	4c 89 f6             	mov    %r14,%rsi
  801dc9:	4c 89 e7             	mov    %r12,%rdi
  801dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd1:	49 b8 c6 1b 80 00 00 	movabs $0x801bc6,%r8
  801dd8:	00 00 00 
  801ddb:	41 ff d0             	call   *%r8
  801dde:	e9 51 fe ff ff       	jmp    801c34 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  801de3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801de7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801deb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801def:	eb a2                	jmp    801d93 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  801df1:	48 ba 6c 2b 80 00 00 	movabs $0x802b6c,%rdx
  801df8:	00 00 00 
  801dfb:	4c 89 f6             	mov    %r14,%rsi
  801dfe:	4c 89 e7             	mov    %r12,%rdi
  801e01:	b8 00 00 00 00       	mov    $0x0,%eax
  801e06:	49 b8 c6 1b 80 00 00 	movabs $0x801bc6,%r8
  801e0d:	00 00 00 
  801e10:	41 ff d0             	call   *%r8
  801e13:	e9 1c fe ff ff       	jmp    801c34 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  801e18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801e1b:	83 f8 2f             	cmp    $0x2f,%eax
  801e1e:	77 55                	ja     801e75 <vprintfmt+0x272>
  801e20:	89 c2                	mov    %eax,%edx
  801e22:	48 01 d6             	add    %rdx,%rsi
  801e25:	83 c0 08             	add    $0x8,%eax
  801e28:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801e2b:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  801e2e:	48 85 d2             	test   %rdx,%rdx
  801e31:	48 b8 65 2b 80 00 00 	movabs $0x802b65,%rax
  801e38:	00 00 00 
  801e3b:	48 0f 45 c2          	cmovne %rdx,%rax
  801e3f:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  801e43:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801e47:	7e 06                	jle    801e4f <vprintfmt+0x24c>
  801e49:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  801e4d:	75 34                	jne    801e83 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801e4f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  801e53:	48 8d 58 01          	lea    0x1(%rax),%rbx
  801e57:	0f b6 00             	movzbl (%rax),%eax
  801e5a:	84 c0                	test   %al,%al
  801e5c:	0f 84 b2 00 00 00    	je     801f14 <vprintfmt+0x311>
  801e62:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  801e66:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  801e6b:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  801e6f:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  801e73:	eb 74                	jmp    801ee9 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  801e75:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801e79:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801e7d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e81:	eb a8                	jmp    801e2b <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  801e83:	49 63 f5             	movslq %r13d,%rsi
  801e86:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  801e8a:	48 b8 d6 23 80 00 00 	movabs $0x8023d6,%rax
  801e91:	00 00 00 
  801e94:	ff d0                	call   *%rax
  801e96:	48 89 c2             	mov    %rax,%rdx
  801e99:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801e9c:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  801e9e:	8d 48 ff             	lea    -0x1(%rax),%ecx
  801ea1:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	7e a7                	jle    801e4f <vprintfmt+0x24c>
  801ea8:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  801eac:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  801eb0:	41 89 cd             	mov    %ecx,%r13d
  801eb3:	4c 89 f6             	mov    %r14,%rsi
  801eb6:	89 df                	mov    %ebx,%edi
  801eb8:	41 ff d4             	call   *%r12
  801ebb:	41 83 ed 01          	sub    $0x1,%r13d
  801ebf:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  801ec3:	75 ee                	jne    801eb3 <vprintfmt+0x2b0>
  801ec5:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  801ec9:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  801ecd:	eb 80                	jmp    801e4f <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801ecf:	0f b6 f8             	movzbl %al,%edi
  801ed2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801ed6:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801ed9:	41 83 ef 01          	sub    $0x1,%r15d
  801edd:	48 83 c3 01          	add    $0x1,%rbx
  801ee1:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  801ee5:	84 c0                	test   %al,%al
  801ee7:	74 1f                	je     801f08 <vprintfmt+0x305>
  801ee9:	45 85 ed             	test   %r13d,%r13d
  801eec:	78 06                	js     801ef4 <vprintfmt+0x2f1>
  801eee:	41 83 ed 01          	sub    $0x1,%r13d
  801ef2:	78 46                	js     801f3a <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801ef4:	45 84 f6             	test   %r14b,%r14b
  801ef7:	74 d6                	je     801ecf <vprintfmt+0x2cc>
  801ef9:	8d 50 e0             	lea    -0x20(%rax),%edx
  801efc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801f01:	80 fa 5e             	cmp    $0x5e,%dl
  801f04:	77 cc                	ja     801ed2 <vprintfmt+0x2cf>
  801f06:	eb c7                	jmp    801ecf <vprintfmt+0x2cc>
  801f08:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f0c:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f10:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  801f14:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801f17:	8d 58 ff             	lea    -0x1(%rax),%ebx
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	0f 8e 12 fd ff ff    	jle    801c34 <vprintfmt+0x31>
  801f22:	4c 89 f6             	mov    %r14,%rsi
  801f25:	bf 20 00 00 00       	mov    $0x20,%edi
  801f2a:	41 ff d4             	call   *%r12
  801f2d:	83 eb 01             	sub    $0x1,%ebx
  801f30:	83 fb ff             	cmp    $0xffffffff,%ebx
  801f33:	75 ed                	jne    801f22 <vprintfmt+0x31f>
  801f35:	e9 fa fc ff ff       	jmp    801c34 <vprintfmt+0x31>
  801f3a:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801f3e:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801f42:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  801f46:	eb cc                	jmp    801f14 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  801f48:	45 89 cd             	mov    %r9d,%r13d
  801f4b:	84 c9                	test   %cl,%cl
  801f4d:	75 25                	jne    801f74 <vprintfmt+0x371>
    switch (lflag) {
  801f4f:	85 d2                	test   %edx,%edx
  801f51:	74 57                	je     801faa <vprintfmt+0x3a7>
  801f53:	83 fa 01             	cmp    $0x1,%edx
  801f56:	74 78                	je     801fd0 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  801f58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f5b:	83 f8 2f             	cmp    $0x2f,%eax
  801f5e:	0f 87 92 00 00 00    	ja     801ff6 <vprintfmt+0x3f3>
  801f64:	89 c2                	mov    %eax,%edx
  801f66:	48 01 d6             	add    %rdx,%rsi
  801f69:	83 c0 08             	add    $0x8,%eax
  801f6c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f6f:	48 8b 1e             	mov    (%rsi),%rbx
  801f72:	eb 16                	jmp    801f8a <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  801f74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f77:	83 f8 2f             	cmp    $0x2f,%eax
  801f7a:	77 20                	ja     801f9c <vprintfmt+0x399>
  801f7c:	89 c2                	mov    %eax,%edx
  801f7e:	48 01 d6             	add    %rdx,%rsi
  801f81:	83 c0 08             	add    $0x8,%eax
  801f84:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f87:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  801f8a:	48 85 db             	test   %rbx,%rbx
  801f8d:	78 78                	js     802007 <vprintfmt+0x404>
            num = i;
  801f8f:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  801f92:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  801f97:	e9 49 02 00 00       	jmp    8021e5 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801f9c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fa0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fa4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fa8:	eb dd                	jmp    801f87 <vprintfmt+0x384>
        return va_arg(*ap, int);
  801faa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fad:	83 f8 2f             	cmp    $0x2f,%eax
  801fb0:	77 10                	ja     801fc2 <vprintfmt+0x3bf>
  801fb2:	89 c2                	mov    %eax,%edx
  801fb4:	48 01 d6             	add    %rdx,%rsi
  801fb7:	83 c0 08             	add    $0x8,%eax
  801fba:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fbd:	48 63 1e             	movslq (%rsi),%rbx
  801fc0:	eb c8                	jmp    801f8a <vprintfmt+0x387>
  801fc2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fc6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801fca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fce:	eb ed                	jmp    801fbd <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  801fd0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fd3:	83 f8 2f             	cmp    $0x2f,%eax
  801fd6:	77 10                	ja     801fe8 <vprintfmt+0x3e5>
  801fd8:	89 c2                	mov    %eax,%edx
  801fda:	48 01 d6             	add    %rdx,%rsi
  801fdd:	83 c0 08             	add    $0x8,%eax
  801fe0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fe3:	48 8b 1e             	mov    (%rsi),%rbx
  801fe6:	eb a2                	jmp    801f8a <vprintfmt+0x387>
  801fe8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801fec:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801ff0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ff4:	eb ed                	jmp    801fe3 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  801ff6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801ffa:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801ffe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802002:	e9 68 ff ff ff       	jmp    801f6f <vprintfmt+0x36c>
                putch('-', put_arg);
  802007:	4c 89 f6             	mov    %r14,%rsi
  80200a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80200f:	41 ff d4             	call   *%r12
                i = -i;
  802012:	48 f7 db             	neg    %rbx
  802015:	e9 75 ff ff ff       	jmp    801f8f <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  80201a:	45 89 cd             	mov    %r9d,%r13d
  80201d:	84 c9                	test   %cl,%cl
  80201f:	75 2d                	jne    80204e <vprintfmt+0x44b>
    switch (lflag) {
  802021:	85 d2                	test   %edx,%edx
  802023:	74 57                	je     80207c <vprintfmt+0x479>
  802025:	83 fa 01             	cmp    $0x1,%edx
  802028:	74 7f                	je     8020a9 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  80202a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80202d:	83 f8 2f             	cmp    $0x2f,%eax
  802030:	0f 87 a1 00 00 00    	ja     8020d7 <vprintfmt+0x4d4>
  802036:	89 c2                	mov    %eax,%edx
  802038:	48 01 d6             	add    %rdx,%rsi
  80203b:	83 c0 08             	add    $0x8,%eax
  80203e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802041:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802044:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  802049:	e9 97 01 00 00       	jmp    8021e5 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80204e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802051:	83 f8 2f             	cmp    $0x2f,%eax
  802054:	77 18                	ja     80206e <vprintfmt+0x46b>
  802056:	89 c2                	mov    %eax,%edx
  802058:	48 01 d6             	add    %rdx,%rsi
  80205b:	83 c0 08             	add    $0x8,%eax
  80205e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802061:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802064:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802069:	e9 77 01 00 00       	jmp    8021e5 <vprintfmt+0x5e2>
  80206e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802072:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802076:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80207a:	eb e5                	jmp    802061 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  80207c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80207f:	83 f8 2f             	cmp    $0x2f,%eax
  802082:	77 17                	ja     80209b <vprintfmt+0x498>
  802084:	89 c2                	mov    %eax,%edx
  802086:	48 01 d6             	add    %rdx,%rsi
  802089:	83 c0 08             	add    $0x8,%eax
  80208c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80208f:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  802091:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802096:	e9 4a 01 00 00       	jmp    8021e5 <vprintfmt+0x5e2>
  80209b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80209f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020a3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020a7:	eb e6                	jmp    80208f <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8020a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020ac:	83 f8 2f             	cmp    $0x2f,%eax
  8020af:	77 18                	ja     8020c9 <vprintfmt+0x4c6>
  8020b1:	89 c2                	mov    %eax,%edx
  8020b3:	48 01 d6             	add    %rdx,%rsi
  8020b6:	83 c0 08             	add    $0x8,%eax
  8020b9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020bc:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8020bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8020c4:	e9 1c 01 00 00       	jmp    8021e5 <vprintfmt+0x5e2>
  8020c9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020cd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020d1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020d5:	eb e5                	jmp    8020bc <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8020d7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8020db:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8020df:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020e3:	e9 59 ff ff ff       	jmp    802041 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8020e8:	45 89 cd             	mov    %r9d,%r13d
  8020eb:	84 c9                	test   %cl,%cl
  8020ed:	75 2d                	jne    80211c <vprintfmt+0x519>
    switch (lflag) {
  8020ef:	85 d2                	test   %edx,%edx
  8020f1:	74 57                	je     80214a <vprintfmt+0x547>
  8020f3:	83 fa 01             	cmp    $0x1,%edx
  8020f6:	74 7c                	je     802174 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8020f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020fb:	83 f8 2f             	cmp    $0x2f,%eax
  8020fe:	0f 87 9b 00 00 00    	ja     80219f <vprintfmt+0x59c>
  802104:	89 c2                	mov    %eax,%edx
  802106:	48 01 d6             	add    %rdx,%rsi
  802109:	83 c0 08             	add    $0x8,%eax
  80210c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80210f:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802112:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802117:	e9 c9 00 00 00       	jmp    8021e5 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80211c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80211f:	83 f8 2f             	cmp    $0x2f,%eax
  802122:	77 18                	ja     80213c <vprintfmt+0x539>
  802124:	89 c2                	mov    %eax,%edx
  802126:	48 01 d6             	add    %rdx,%rsi
  802129:	83 c0 08             	add    $0x8,%eax
  80212c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80212f:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802132:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802137:	e9 a9 00 00 00       	jmp    8021e5 <vprintfmt+0x5e2>
  80213c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802140:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802144:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802148:	eb e5                	jmp    80212f <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  80214a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80214d:	83 f8 2f             	cmp    $0x2f,%eax
  802150:	77 14                	ja     802166 <vprintfmt+0x563>
  802152:	89 c2                	mov    %eax,%edx
  802154:	48 01 d6             	add    %rdx,%rsi
  802157:	83 c0 08             	add    $0x8,%eax
  80215a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80215d:	8b 16                	mov    (%rsi),%edx
            base = 8;
  80215f:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  802164:	eb 7f                	jmp    8021e5 <vprintfmt+0x5e2>
  802166:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80216a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80216e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802172:	eb e9                	jmp    80215d <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  802174:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802177:	83 f8 2f             	cmp    $0x2f,%eax
  80217a:	77 15                	ja     802191 <vprintfmt+0x58e>
  80217c:	89 c2                	mov    %eax,%edx
  80217e:	48 01 d6             	add    %rdx,%rsi
  802181:	83 c0 08             	add    $0x8,%eax
  802184:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802187:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80218a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80218f:	eb 54                	jmp    8021e5 <vprintfmt+0x5e2>
  802191:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802195:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802199:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80219d:	eb e8                	jmp    802187 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  80219f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8021a3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8021a7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8021ab:	e9 5f ff ff ff       	jmp    80210f <vprintfmt+0x50c>
            putch('0', put_arg);
  8021b0:	45 89 cd             	mov    %r9d,%r13d
  8021b3:	4c 89 f6             	mov    %r14,%rsi
  8021b6:	bf 30 00 00 00       	mov    $0x30,%edi
  8021bb:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8021be:	4c 89 f6             	mov    %r14,%rsi
  8021c1:	bf 78 00 00 00       	mov    $0x78,%edi
  8021c6:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8021c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021cc:	83 f8 2f             	cmp    $0x2f,%eax
  8021cf:	77 47                	ja     802218 <vprintfmt+0x615>
  8021d1:	89 c2                	mov    %eax,%edx
  8021d3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021d7:	83 c0 08             	add    $0x8,%eax
  8021da:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021dd:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8021e0:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8021e5:	48 83 ec 08          	sub    $0x8,%rsp
  8021e9:	41 80 fd 58          	cmp    $0x58,%r13b
  8021ed:	0f 94 c0             	sete   %al
  8021f0:	0f b6 c0             	movzbl %al,%eax
  8021f3:	50                   	push   %rax
  8021f4:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  8021f9:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8021fd:	4c 89 f6             	mov    %r14,%rsi
  802200:	4c 89 e7             	mov    %r12,%rdi
  802203:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  80220a:	00 00 00 
  80220d:	ff d0                	call   *%rax
            break;
  80220f:	48 83 c4 10          	add    $0x10,%rsp
  802213:	e9 1c fa ff ff       	jmp    801c34 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  802218:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80221c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802220:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802224:	eb b7                	jmp    8021dd <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  802226:	45 89 cd             	mov    %r9d,%r13d
  802229:	84 c9                	test   %cl,%cl
  80222b:	75 2a                	jne    802257 <vprintfmt+0x654>
    switch (lflag) {
  80222d:	85 d2                	test   %edx,%edx
  80222f:	74 54                	je     802285 <vprintfmt+0x682>
  802231:	83 fa 01             	cmp    $0x1,%edx
  802234:	74 7c                	je     8022b2 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  802236:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802239:	83 f8 2f             	cmp    $0x2f,%eax
  80223c:	0f 87 9e 00 00 00    	ja     8022e0 <vprintfmt+0x6dd>
  802242:	89 c2                	mov    %eax,%edx
  802244:	48 01 d6             	add    %rdx,%rsi
  802247:	83 c0 08             	add    $0x8,%eax
  80224a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80224d:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802250:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  802255:	eb 8e                	jmp    8021e5 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802257:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80225a:	83 f8 2f             	cmp    $0x2f,%eax
  80225d:	77 18                	ja     802277 <vprintfmt+0x674>
  80225f:	89 c2                	mov    %eax,%edx
  802261:	48 01 d6             	add    %rdx,%rsi
  802264:	83 c0 08             	add    $0x8,%eax
  802267:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80226a:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80226d:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802272:	e9 6e ff ff ff       	jmp    8021e5 <vprintfmt+0x5e2>
  802277:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80227b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80227f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802283:	eb e5                	jmp    80226a <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  802285:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802288:	83 f8 2f             	cmp    $0x2f,%eax
  80228b:	77 17                	ja     8022a4 <vprintfmt+0x6a1>
  80228d:	89 c2                	mov    %eax,%edx
  80228f:	48 01 d6             	add    %rdx,%rsi
  802292:	83 c0 08             	add    $0x8,%eax
  802295:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802298:	8b 16                	mov    (%rsi),%edx
            base = 16;
  80229a:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  80229f:	e9 41 ff ff ff       	jmp    8021e5 <vprintfmt+0x5e2>
  8022a4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022a8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022ac:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022b0:	eb e6                	jmp    802298 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8022b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022b5:	83 f8 2f             	cmp    $0x2f,%eax
  8022b8:	77 18                	ja     8022d2 <vprintfmt+0x6cf>
  8022ba:	89 c2                	mov    %eax,%edx
  8022bc:	48 01 d6             	add    %rdx,%rsi
  8022bf:	83 c0 08             	add    $0x8,%eax
  8022c2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022c5:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8022c8:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8022cd:	e9 13 ff ff ff       	jmp    8021e5 <vprintfmt+0x5e2>
  8022d2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022d6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022da:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022de:	eb e5                	jmp    8022c5 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  8022e0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8022e4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8022e8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022ec:	e9 5c ff ff ff       	jmp    80224d <vprintfmt+0x64a>
            putch(ch, put_arg);
  8022f1:	4c 89 f6             	mov    %r14,%rsi
  8022f4:	bf 25 00 00 00       	mov    $0x25,%edi
  8022f9:	41 ff d4             	call   *%r12
            break;
  8022fc:	e9 33 f9 ff ff       	jmp    801c34 <vprintfmt+0x31>
            putch('%', put_arg);
  802301:	4c 89 f6             	mov    %r14,%rsi
  802304:	bf 25 00 00 00       	mov    $0x25,%edi
  802309:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  80230c:	49 83 ef 01          	sub    $0x1,%r15
  802310:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  802315:	75 f5                	jne    80230c <vprintfmt+0x709>
  802317:	e9 18 f9 ff ff       	jmp    801c34 <vprintfmt+0x31>
}
  80231c:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802320:	5b                   	pop    %rbx
  802321:	41 5c                	pop    %r12
  802323:	41 5d                	pop    %r13
  802325:	41 5e                	pop    %r14
  802327:	41 5f                	pop    %r15
  802329:	5d                   	pop    %rbp
  80232a:	c3                   	ret    

000000000080232b <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  80232b:	55                   	push   %rbp
  80232c:	48 89 e5             	mov    %rsp,%rbp
  80232f:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  802333:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802337:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  80233c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802340:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  802347:	48 85 ff             	test   %rdi,%rdi
  80234a:	74 2b                	je     802377 <vsnprintf+0x4c>
  80234c:	48 85 f6             	test   %rsi,%rsi
  80234f:	74 26                	je     802377 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  802351:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802355:	48 bf ae 1b 80 00 00 	movabs $0x801bae,%rdi
  80235c:	00 00 00 
  80235f:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  802366:	00 00 00 
  802369:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  80236b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236f:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  802372:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802375:	c9                   	leave  
  802376:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  802377:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80237c:	eb f7                	jmp    802375 <vsnprintf+0x4a>

000000000080237e <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  80237e:	55                   	push   %rbp
  80237f:	48 89 e5             	mov    %rsp,%rbp
  802382:	48 83 ec 50          	sub    $0x50,%rsp
  802386:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80238a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80238e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802392:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  802399:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80239d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023a1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8023a5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  8023a9:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8023ad:	48 b8 2b 23 80 00 00 	movabs $0x80232b,%rax
  8023b4:	00 00 00 
  8023b7:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

00000000008023bb <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  8023bb:	80 3f 00             	cmpb   $0x0,(%rdi)
  8023be:	74 10                	je     8023d0 <strlen+0x15>
    size_t n = 0;
  8023c0:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8023c5:	48 83 c0 01          	add    $0x1,%rax
  8023c9:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023cd:	75 f6                	jne    8023c5 <strlen+0xa>
  8023cf:	c3                   	ret    
    size_t n = 0;
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  8023d5:	c3                   	ret    

00000000008023d6 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  8023d6:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  8023db:	48 85 f6             	test   %rsi,%rsi
  8023de:	74 10                	je     8023f0 <strnlen+0x1a>
  8023e0:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8023e4:	74 09                	je     8023ef <strnlen+0x19>
  8023e6:	48 83 c0 01          	add    $0x1,%rax
  8023ea:	48 39 c6             	cmp    %rax,%rsi
  8023ed:	75 f1                	jne    8023e0 <strnlen+0xa>
    return n;
}
  8023ef:	c3                   	ret    
    size_t n = 0;
  8023f0:	48 89 f0             	mov    %rsi,%rax
  8023f3:	c3                   	ret    

00000000008023f4 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8023f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f9:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  8023fd:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  802400:	48 83 c0 01          	add    $0x1,%rax
  802404:	84 d2                	test   %dl,%dl
  802406:	75 f1                	jne    8023f9 <strcpy+0x5>
        ;
    return res;
}
  802408:	48 89 f8             	mov    %rdi,%rax
  80240b:	c3                   	ret    

000000000080240c <strcat>:

char *
strcat(char *dst, const char *src) {
  80240c:	55                   	push   %rbp
  80240d:	48 89 e5             	mov    %rsp,%rbp
  802410:	41 54                	push   %r12
  802412:	53                   	push   %rbx
  802413:	48 89 fb             	mov    %rdi,%rbx
  802416:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  802419:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  802420:	00 00 00 
  802423:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  802425:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  802429:	4c 89 e6             	mov    %r12,%rsi
  80242c:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  802433:	00 00 00 
  802436:	ff d0                	call   *%rax
    return dst;
}
  802438:	48 89 d8             	mov    %rbx,%rax
  80243b:	5b                   	pop    %rbx
  80243c:	41 5c                	pop    %r12
  80243e:	5d                   	pop    %rbp
  80243f:	c3                   	ret    

0000000000802440 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  802440:	48 85 d2             	test   %rdx,%rdx
  802443:	74 1d                	je     802462 <strncpy+0x22>
  802445:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802449:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  80244c:	48 83 c0 01          	add    $0x1,%rax
  802450:	0f b6 16             	movzbl (%rsi),%edx
  802453:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  802456:	80 fa 01             	cmp    $0x1,%dl
  802459:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  80245d:	48 39 c1             	cmp    %rax,%rcx
  802460:	75 ea                	jne    80244c <strncpy+0xc>
    }
    return ret;
}
  802462:	48 89 f8             	mov    %rdi,%rax
  802465:	c3                   	ret    

0000000000802466 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  802466:	48 89 f8             	mov    %rdi,%rax
  802469:	48 85 d2             	test   %rdx,%rdx
  80246c:	74 24                	je     802492 <strlcpy+0x2c>
        while (--size > 0 && *src)
  80246e:	48 83 ea 01          	sub    $0x1,%rdx
  802472:	74 1b                	je     80248f <strlcpy+0x29>
  802474:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802478:	0f b6 16             	movzbl (%rsi),%edx
  80247b:	84 d2                	test   %dl,%dl
  80247d:	74 10                	je     80248f <strlcpy+0x29>
            *dst++ = *src++;
  80247f:	48 83 c6 01          	add    $0x1,%rsi
  802483:	48 83 c0 01          	add    $0x1,%rax
  802487:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80248a:	48 39 c8             	cmp    %rcx,%rax
  80248d:	75 e9                	jne    802478 <strlcpy+0x12>
        *dst = '\0';
  80248f:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802492:	48 29 f8             	sub    %rdi,%rax
}
  802495:	c3                   	ret    

0000000000802496 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  802496:	0f b6 07             	movzbl (%rdi),%eax
  802499:	84 c0                	test   %al,%al
  80249b:	74 13                	je     8024b0 <strcmp+0x1a>
  80249d:	38 06                	cmp    %al,(%rsi)
  80249f:	75 0f                	jne    8024b0 <strcmp+0x1a>
  8024a1:	48 83 c7 01          	add    $0x1,%rdi
  8024a5:	48 83 c6 01          	add    $0x1,%rsi
  8024a9:	0f b6 07             	movzbl (%rdi),%eax
  8024ac:	84 c0                	test   %al,%al
  8024ae:	75 ed                	jne    80249d <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8024b0:	0f b6 c0             	movzbl %al,%eax
  8024b3:	0f b6 16             	movzbl (%rsi),%edx
  8024b6:	29 d0                	sub    %edx,%eax
}
  8024b8:	c3                   	ret    

00000000008024b9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  8024b9:	48 85 d2             	test   %rdx,%rdx
  8024bc:	74 1f                	je     8024dd <strncmp+0x24>
  8024be:	0f b6 07             	movzbl (%rdi),%eax
  8024c1:	84 c0                	test   %al,%al
  8024c3:	74 1e                	je     8024e3 <strncmp+0x2a>
  8024c5:	3a 06                	cmp    (%rsi),%al
  8024c7:	75 1a                	jne    8024e3 <strncmp+0x2a>
  8024c9:	48 83 c7 01          	add    $0x1,%rdi
  8024cd:	48 83 c6 01          	add    $0x1,%rsi
  8024d1:	48 83 ea 01          	sub    $0x1,%rdx
  8024d5:	75 e7                	jne    8024be <strncmp+0x5>

    if (!n) return 0;
  8024d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024dc:	c3                   	ret    
  8024dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e2:	c3                   	ret    
  8024e3:	48 85 d2             	test   %rdx,%rdx
  8024e6:	74 09                	je     8024f1 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  8024e8:	0f b6 07             	movzbl (%rdi),%eax
  8024eb:	0f b6 16             	movzbl (%rsi),%edx
  8024ee:	29 d0                	sub    %edx,%eax
  8024f0:	c3                   	ret    
    if (!n) return 0;
  8024f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f6:	c3                   	ret    

00000000008024f7 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  8024f7:	0f b6 07             	movzbl (%rdi),%eax
  8024fa:	84 c0                	test   %al,%al
  8024fc:	74 18                	je     802516 <strchr+0x1f>
        if (*str == c) {
  8024fe:	0f be c0             	movsbl %al,%eax
  802501:	39 f0                	cmp    %esi,%eax
  802503:	74 17                	je     80251c <strchr+0x25>
    for (; *str; str++) {
  802505:	48 83 c7 01          	add    $0x1,%rdi
  802509:	0f b6 07             	movzbl (%rdi),%eax
  80250c:	84 c0                	test   %al,%al
  80250e:	75 ee                	jne    8024fe <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  802510:	b8 00 00 00 00       	mov    $0x0,%eax
  802515:	c3                   	ret    
  802516:	b8 00 00 00 00       	mov    $0x0,%eax
  80251b:	c3                   	ret    
  80251c:	48 89 f8             	mov    %rdi,%rax
}
  80251f:	c3                   	ret    

0000000000802520 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  802520:	0f b6 07             	movzbl (%rdi),%eax
  802523:	84 c0                	test   %al,%al
  802525:	74 16                	je     80253d <strfind+0x1d>
  802527:	0f be c0             	movsbl %al,%eax
  80252a:	39 f0                	cmp    %esi,%eax
  80252c:	74 13                	je     802541 <strfind+0x21>
  80252e:	48 83 c7 01          	add    $0x1,%rdi
  802532:	0f b6 07             	movzbl (%rdi),%eax
  802535:	84 c0                	test   %al,%al
  802537:	75 ee                	jne    802527 <strfind+0x7>
  802539:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  80253c:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  80253d:	48 89 f8             	mov    %rdi,%rax
  802540:	c3                   	ret    
  802541:	48 89 f8             	mov    %rdi,%rax
  802544:	c3                   	ret    

0000000000802545 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  802545:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  802548:	48 89 f8             	mov    %rdi,%rax
  80254b:	48 f7 d8             	neg    %rax
  80254e:	83 e0 07             	and    $0x7,%eax
  802551:	49 89 d1             	mov    %rdx,%r9
  802554:	49 29 c1             	sub    %rax,%r9
  802557:	78 32                	js     80258b <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  802559:	40 0f b6 c6          	movzbl %sil,%eax
  80255d:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  802564:	01 01 01 
  802567:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80256b:	40 f6 c7 07          	test   $0x7,%dil
  80256f:	75 34                	jne    8025a5 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  802571:	4c 89 c9             	mov    %r9,%rcx
  802574:	48 c1 f9 03          	sar    $0x3,%rcx
  802578:	74 08                	je     802582 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80257a:	fc                   	cld    
  80257b:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  80257e:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802582:	4d 85 c9             	test   %r9,%r9
  802585:	75 45                	jne    8025cc <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  802587:	4c 89 c0             	mov    %r8,%rax
  80258a:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  80258b:	48 85 d2             	test   %rdx,%rdx
  80258e:	74 f7                	je     802587 <memset+0x42>
  802590:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  802593:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  802596:	48 83 c0 01          	add    $0x1,%rax
  80259a:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80259e:	48 39 c2             	cmp    %rax,%rdx
  8025a1:	75 f3                	jne    802596 <memset+0x51>
  8025a3:	eb e2                	jmp    802587 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8025a5:	40 f6 c7 01          	test   $0x1,%dil
  8025a9:	74 06                	je     8025b1 <memset+0x6c>
  8025ab:	88 07                	mov    %al,(%rdi)
  8025ad:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025b1:	40 f6 c7 02          	test   $0x2,%dil
  8025b5:	74 07                	je     8025be <memset+0x79>
  8025b7:	66 89 07             	mov    %ax,(%rdi)
  8025ba:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025be:	40 f6 c7 04          	test   $0x4,%dil
  8025c2:	74 ad                	je     802571 <memset+0x2c>
  8025c4:	89 07                	mov    %eax,(%rdi)
  8025c6:	48 83 c7 04          	add    $0x4,%rdi
  8025ca:	eb a5                	jmp    802571 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8025cc:	41 f6 c1 04          	test   $0x4,%r9b
  8025d0:	74 06                	je     8025d8 <memset+0x93>
  8025d2:	89 07                	mov    %eax,(%rdi)
  8025d4:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8025d8:	41 f6 c1 02          	test   $0x2,%r9b
  8025dc:	74 07                	je     8025e5 <memset+0xa0>
  8025de:	66 89 07             	mov    %ax,(%rdi)
  8025e1:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8025e5:	41 f6 c1 01          	test   $0x1,%r9b
  8025e9:	74 9c                	je     802587 <memset+0x42>
  8025eb:	88 07                	mov    %al,(%rdi)
  8025ed:	eb 98                	jmp    802587 <memset+0x42>

00000000008025ef <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8025ef:	48 89 f8             	mov    %rdi,%rax
  8025f2:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8025f5:	48 39 fe             	cmp    %rdi,%rsi
  8025f8:	73 39                	jae    802633 <memmove+0x44>
  8025fa:	48 01 f2             	add    %rsi,%rdx
  8025fd:	48 39 fa             	cmp    %rdi,%rdx
  802600:	76 31                	jbe    802633 <memmove+0x44>
        s += n;
        d += n;
  802602:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802605:	48 89 d6             	mov    %rdx,%rsi
  802608:	48 09 fe             	or     %rdi,%rsi
  80260b:	48 09 ce             	or     %rcx,%rsi
  80260e:	40 f6 c6 07          	test   $0x7,%sil
  802612:	75 12                	jne    802626 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  802614:	48 83 ef 08          	sub    $0x8,%rdi
  802618:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  80261c:	48 c1 e9 03          	shr    $0x3,%rcx
  802620:	fd                   	std    
  802621:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  802624:	fc                   	cld    
  802625:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  802626:	48 83 ef 01          	sub    $0x1,%rdi
  80262a:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80262e:	fd                   	std    
  80262f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  802631:	eb f1                	jmp    802624 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802633:	48 89 f2             	mov    %rsi,%rdx
  802636:	48 09 c2             	or     %rax,%rdx
  802639:	48 09 ca             	or     %rcx,%rdx
  80263c:	f6 c2 07             	test   $0x7,%dl
  80263f:	75 0c                	jne    80264d <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  802641:	48 c1 e9 03          	shr    $0x3,%rcx
  802645:	48 89 c7             	mov    %rax,%rdi
  802648:	fc                   	cld    
  802649:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80264c:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80264d:	48 89 c7             	mov    %rax,%rdi
  802650:	fc                   	cld    
  802651:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  802653:	c3                   	ret    

0000000000802654 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  802654:	55                   	push   %rbp
  802655:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802658:	48 b8 ef 25 80 00 00 	movabs $0x8025ef,%rax
  80265f:	00 00 00 
  802662:	ff d0                	call   *%rax
}
  802664:	5d                   	pop    %rbp
  802665:	c3                   	ret    

0000000000802666 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802666:	55                   	push   %rbp
  802667:	48 89 e5             	mov    %rsp,%rbp
  80266a:	41 57                	push   %r15
  80266c:	41 56                	push   %r14
  80266e:	41 55                	push   %r13
  802670:	41 54                	push   %r12
  802672:	53                   	push   %rbx
  802673:	48 83 ec 08          	sub    $0x8,%rsp
  802677:	49 89 fe             	mov    %rdi,%r14
  80267a:	49 89 f7             	mov    %rsi,%r15
  80267d:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  802680:	48 89 f7             	mov    %rsi,%rdi
  802683:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  80268a:	00 00 00 
  80268d:	ff d0                	call   *%rax
  80268f:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  802692:	48 89 de             	mov    %rbx,%rsi
  802695:	4c 89 f7             	mov    %r14,%rdi
  802698:	48 b8 d6 23 80 00 00 	movabs $0x8023d6,%rax
  80269f:	00 00 00 
  8026a2:	ff d0                	call   *%rax
  8026a4:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8026a7:	48 39 c3             	cmp    %rax,%rbx
  8026aa:	74 36                	je     8026e2 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  8026ac:	48 89 d8             	mov    %rbx,%rax
  8026af:	4c 29 e8             	sub    %r13,%rax
  8026b2:	4c 39 e0             	cmp    %r12,%rax
  8026b5:	76 30                	jbe    8026e7 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  8026b7:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8026bc:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026c0:	4c 89 fe             	mov    %r15,%rsi
  8026c3:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  8026ca:	00 00 00 
  8026cd:	ff d0                	call   *%rax
    return dstlen + srclen;
  8026cf:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8026d3:	48 83 c4 08          	add    $0x8,%rsp
  8026d7:	5b                   	pop    %rbx
  8026d8:	41 5c                	pop    %r12
  8026da:	41 5d                	pop    %r13
  8026dc:	41 5e                	pop    %r14
  8026de:	41 5f                	pop    %r15
  8026e0:	5d                   	pop    %rbp
  8026e1:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8026e2:	4c 01 e0             	add    %r12,%rax
  8026e5:	eb ec                	jmp    8026d3 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8026e7:	48 83 eb 01          	sub    $0x1,%rbx
  8026eb:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8026ef:	48 89 da             	mov    %rbx,%rdx
  8026f2:	4c 89 fe             	mov    %r15,%rsi
  8026f5:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  8026fc:	00 00 00 
  8026ff:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  802701:	49 01 de             	add    %rbx,%r14
  802704:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  802709:	eb c4                	jmp    8026cf <strlcat+0x69>

000000000080270b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  80270b:	49 89 f0             	mov    %rsi,%r8
  80270e:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  802711:	48 85 d2             	test   %rdx,%rdx
  802714:	74 2a                	je     802740 <memcmp+0x35>
  802716:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  80271b:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  80271f:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  802724:	38 ca                	cmp    %cl,%dl
  802726:	75 0f                	jne    802737 <memcmp+0x2c>
    while (n-- > 0) {
  802728:	48 83 c0 01          	add    $0x1,%rax
  80272c:	48 39 c6             	cmp    %rax,%rsi
  80272f:	75 ea                	jne    80271b <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  802731:	b8 00 00 00 00       	mov    $0x0,%eax
  802736:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  802737:	0f b6 c2             	movzbl %dl,%eax
  80273a:	0f b6 c9             	movzbl %cl,%ecx
  80273d:	29 c8                	sub    %ecx,%eax
  80273f:	c3                   	ret    
    return 0;
  802740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802745:	c3                   	ret    

0000000000802746 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  802746:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80274a:	48 39 c7             	cmp    %rax,%rdi
  80274d:	73 0f                	jae    80275e <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  80274f:	40 38 37             	cmp    %sil,(%rdi)
  802752:	74 0e                	je     802762 <memfind+0x1c>
    for (; src < end; src++) {
  802754:	48 83 c7 01          	add    $0x1,%rdi
  802758:	48 39 f8             	cmp    %rdi,%rax
  80275b:	75 f2                	jne    80274f <memfind+0x9>
  80275d:	c3                   	ret    
  80275e:	48 89 f8             	mov    %rdi,%rax
  802761:	c3                   	ret    
  802762:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802765:	c3                   	ret    

0000000000802766 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802766:	49 89 f2             	mov    %rsi,%r10
  802769:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80276c:	0f b6 37             	movzbl (%rdi),%esi
  80276f:	40 80 fe 20          	cmp    $0x20,%sil
  802773:	74 06                	je     80277b <strtol+0x15>
  802775:	40 80 fe 09          	cmp    $0x9,%sil
  802779:	75 13                	jne    80278e <strtol+0x28>
  80277b:	48 83 c7 01          	add    $0x1,%rdi
  80277f:	0f b6 37             	movzbl (%rdi),%esi
  802782:	40 80 fe 20          	cmp    $0x20,%sil
  802786:	74 f3                	je     80277b <strtol+0x15>
  802788:	40 80 fe 09          	cmp    $0x9,%sil
  80278c:	74 ed                	je     80277b <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  80278e:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802791:	83 e0 fd             	and    $0xfffffffd,%eax
  802794:	3c 01                	cmp    $0x1,%al
  802796:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80279a:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  8027a1:	75 11                	jne    8027b4 <strtol+0x4e>
  8027a3:	80 3f 30             	cmpb   $0x30,(%rdi)
  8027a6:	74 16                	je     8027be <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8027a8:	45 85 c0             	test   %r8d,%r8d
  8027ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8027b0:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8027b4:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8027b9:	4d 63 c8             	movslq %r8d,%r9
  8027bc:	eb 38                	jmp    8027f6 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8027be:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8027c2:	74 11                	je     8027d5 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8027c4:	45 85 c0             	test   %r8d,%r8d
  8027c7:	75 eb                	jne    8027b4 <strtol+0x4e>
        s++;
  8027c9:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8027cd:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8027d3:	eb df                	jmp    8027b4 <strtol+0x4e>
        s += 2;
  8027d5:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8027d9:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8027df:	eb d3                	jmp    8027b4 <strtol+0x4e>
            dig -= '0';
  8027e1:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8027e4:	0f b6 c8             	movzbl %al,%ecx
  8027e7:	44 39 c1             	cmp    %r8d,%ecx
  8027ea:	7d 1f                	jge    80280b <strtol+0xa5>
        val = val * base + dig;
  8027ec:	49 0f af d1          	imul   %r9,%rdx
  8027f0:	0f b6 c0             	movzbl %al,%eax
  8027f3:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8027f6:	48 83 c7 01          	add    $0x1,%rdi
  8027fa:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8027fe:	3c 39                	cmp    $0x39,%al
  802800:	76 df                	jbe    8027e1 <strtol+0x7b>
        else if (dig - 'a' < 27)
  802802:	3c 7b                	cmp    $0x7b,%al
  802804:	77 05                	ja     80280b <strtol+0xa5>
            dig -= 'a' - 10;
  802806:	83 e8 57             	sub    $0x57,%eax
  802809:	eb d9                	jmp    8027e4 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  80280b:	4d 85 d2             	test   %r10,%r10
  80280e:	74 03                	je     802813 <strtol+0xad>
  802810:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802813:	48 89 d0             	mov    %rdx,%rax
  802816:	48 f7 d8             	neg    %rax
  802819:	40 80 fe 2d          	cmp    $0x2d,%sil
  80281d:	48 0f 44 d0          	cmove  %rax,%rdx
}
  802821:	48 89 d0             	mov    %rdx,%rax
  802824:	c3                   	ret    

0000000000802825 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802825:	55                   	push   %rbp
  802826:	48 89 e5             	mov    %rsp,%rbp
  802829:	41 54                	push   %r12
  80282b:	53                   	push   %rbx
  80282c:	48 89 fb             	mov    %rdi,%rbx
  80282f:	48 89 f7             	mov    %rsi,%rdi
  802832:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802835:	48 85 f6             	test   %rsi,%rsi
  802838:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80283f:	00 00 00 
  802842:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802846:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  80284b:	48 85 d2             	test   %rdx,%rdx
  80284e:	74 02                	je     802852 <ipc_recv+0x2d>
  802850:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802852:	48 63 f6             	movslq %esi,%rsi
  802855:	48 b8 3a 05 80 00 00 	movabs $0x80053a,%rax
  80285c:	00 00 00 
  80285f:	ff d0                	call   *%rax

    if (res < 0) {
  802861:	85 c0                	test   %eax,%eax
  802863:	78 45                	js     8028aa <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802865:	48 85 db             	test   %rbx,%rbx
  802868:	74 12                	je     80287c <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  80286a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802871:	00 00 00 
  802874:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80287a:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  80287c:	4d 85 e4             	test   %r12,%r12
  80287f:	74 14                	je     802895 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802881:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802888:	00 00 00 
  80288b:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802891:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802895:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80289c:	00 00 00 
  80289f:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8028a5:	5b                   	pop    %rbx
  8028a6:	41 5c                	pop    %r12
  8028a8:	5d                   	pop    %rbp
  8028a9:	c3                   	ret    
        if (from_env_store)
  8028aa:	48 85 db             	test   %rbx,%rbx
  8028ad:	74 06                	je     8028b5 <ipc_recv+0x90>
            *from_env_store = 0;
  8028af:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8028b5:	4d 85 e4             	test   %r12,%r12
  8028b8:	74 eb                	je     8028a5 <ipc_recv+0x80>
            *perm_store = 0;
  8028ba:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028c1:	00 
  8028c2:	eb e1                	jmp    8028a5 <ipc_recv+0x80>

00000000008028c4 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028c4:	55                   	push   %rbp
  8028c5:	48 89 e5             	mov    %rsp,%rbp
  8028c8:	41 57                	push   %r15
  8028ca:	41 56                	push   %r14
  8028cc:	41 55                	push   %r13
  8028ce:	41 54                	push   %r12
  8028d0:	53                   	push   %rbx
  8028d1:	48 83 ec 18          	sub    $0x18,%rsp
  8028d5:	41 89 fd             	mov    %edi,%r13d
  8028d8:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028db:	48 89 d3             	mov    %rdx,%rbx
  8028de:	49 89 cc             	mov    %rcx,%r12
  8028e1:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028e5:	48 85 d2             	test   %rdx,%rdx
  8028e8:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8028ef:	00 00 00 
  8028f2:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028f6:	49 be 0e 05 80 00 00 	movabs $0x80050e,%r14
  8028fd:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802900:	49 bf 11 02 80 00 00 	movabs $0x800211,%r15
  802907:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  80290a:	8b 75 cc             	mov    -0x34(%rbp),%esi
  80290d:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802911:	4c 89 e1             	mov    %r12,%rcx
  802914:	48 89 da             	mov    %rbx,%rdx
  802917:	44 89 ef             	mov    %r13d,%edi
  80291a:	41 ff d6             	call   *%r14
  80291d:	85 c0                	test   %eax,%eax
  80291f:	79 37                	jns    802958 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802921:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802924:	75 05                	jne    80292b <ipc_send+0x67>
          sys_yield();
  802926:	41 ff d7             	call   *%r15
  802929:	eb df                	jmp    80290a <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  80292b:	89 c1                	mov    %eax,%ecx
  80292d:	48 ba 5f 30 80 00 00 	movabs $0x80305f,%rdx
  802934:	00 00 00 
  802937:	be 46 00 00 00       	mov    $0x46,%esi
  80293c:	48 bf 72 30 80 00 00 	movabs $0x803072,%rdi
  802943:	00 00 00 
  802946:	b8 00 00 00 00       	mov    $0x0,%eax
  80294b:	49 b8 63 19 80 00 00 	movabs $0x801963,%r8
  802952:	00 00 00 
  802955:	41 ff d0             	call   *%r8
      }
}
  802958:	48 83 c4 18          	add    $0x18,%rsp
  80295c:	5b                   	pop    %rbx
  80295d:	41 5c                	pop    %r12
  80295f:	41 5d                	pop    %r13
  802961:	41 5e                	pop    %r14
  802963:	41 5f                	pop    %r15
  802965:	5d                   	pop    %rbp
  802966:	c3                   	ret    

0000000000802967 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802967:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80296c:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802973:	00 00 00 
  802976:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80297a:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80297e:	48 c1 e2 04          	shl    $0x4,%rdx
  802982:	48 01 ca             	add    %rcx,%rdx
  802985:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  80298b:	39 fa                	cmp    %edi,%edx
  80298d:	74 12                	je     8029a1 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  80298f:	48 83 c0 01          	add    $0x1,%rax
  802993:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802999:	75 db                	jne    802976 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  80299b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a0:	c3                   	ret    
            return envs[i].env_id;
  8029a1:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8029a5:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8029a9:	48 c1 e0 04          	shl    $0x4,%rax
  8029ad:	48 89 c2             	mov    %rax,%rdx
  8029b0:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8029b7:	00 00 00 
  8029ba:	48 01 d0             	add    %rdx,%rax
  8029bd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029c3:	c3                   	ret    
  8029c4:	0f 1f 40 00          	nopl   0x0(%rax)

00000000008029c8 <__rodata_start>:
  8029c8:	3c 75                	cmp    $0x75,%al
  8029ca:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029cb:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8029cf:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029d0:	3e 00 66 0f          	ds add %ah,0xf(%rsi)
  8029d4:	1f                   	(bad)  
  8029d5:	44 00 00             	add    %r8b,(%rax)
  8029d8:	73 79                	jae    802a53 <__rodata_start+0x8b>
  8029da:	73 63                	jae    802a3f <__rodata_start+0x77>
  8029dc:	61                   	(bad)  
  8029dd:	6c                   	insb   (%dx),%es:(%rdi)
  8029de:	6c                   	insb   (%dx),%es:(%rdi)
  8029df:	20 25 7a 64 20 72    	and    %ah,0x7220647a(%rip)        # 72a08e5f <__bss_end+0x72200e5f>
  8029e5:	65 74 75             	gs je  802a5d <__rodata_start+0x95>
  8029e8:	72 6e                	jb     802a58 <__rodata_start+0x90>
  8029ea:	65 64 20 25 7a 64 20 	gs and %ah,%fs:0x2820647a(%rip)        # 28a08e6c <__bss_end+0x28200e6c>
  8029f1:	28 
  8029f2:	3e 20 30             	ds and %dh,(%rax)
  8029f5:	29 00                	sub    %eax,(%rax)
  8029f7:	6c                   	insb   (%dx),%es:(%rdi)
  8029f8:	69 62 2f 73 79 73 63 	imul   $0x63737973,0x2f(%rdx),%esp
  8029ff:	61                   	(bad)  
  802a00:	6c                   	insb   (%dx),%es:(%rdi)
  802a01:	6c                   	insb   (%dx),%es:(%rdi)
  802a02:	2e 63 00             	cs movsxd (%rax),%eax
  802a05:	0f 1f 00             	nopl   (%rax)
  802a08:	5b                   	pop    %rbx
  802a09:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a0e:	20 75 6e             	and    %dh,0x6e(%rbp)
  802a11:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802a15:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a16:	20 64 65 76          	and    %ah,0x76(%rbp,%riz,2)
  802a1a:	69 63 65 20 74 79 70 	imul   $0x70797420,0x65(%rbx),%esp
  802a21:	65 20 25 64 0a 00 00 	and    %ah,%gs:0xa64(%rip)        # 80348c <error_string+0x4ec>
  802a28:	5b                   	pop    %rbx
  802a29:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a2e:	20 66 74             	and    %ah,0x74(%rsi)
  802a31:	72 75                	jb     802aa8 <devtab+0x8>
  802a33:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a34:	63 61 74             	movsxd 0x74(%rcx),%esp
  802a37:	65 20 25 64 20 2d 2d 	and    %ah,%gs:0x2d2d2064(%rip)        # 2dad4aa2 <__bss_end+0x2d2ccaa2>
  802a3e:	20 62 61             	and    %ah,0x61(%rdx)
  802a41:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a45:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a49:	5b                   	pop    %rbx
  802a4a:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a4f:	20 72 65             	and    %dh,0x65(%rdx)
  802a52:	61                   	(bad)  
  802a53:	64 20 25 64 20 2d 2d 	and    %ah,%fs:0x2d2d2064(%rip)        # 2dad4abe <__bss_end+0x2d2ccabe>
  802a5a:	20 62 61             	and    %ah,0x61(%rdx)
  802a5d:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802a61:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a65:	5b                   	pop    %rbx
  802a66:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802a6b:	20 77 72             	and    %dh,0x72(%rdi)
  802a6e:	69 74 65 20 25 64 20 	imul   $0x2d206425,0x20(%rbp,%riz,2),%esi
  802a75:	2d 
  802a76:	2d 20 62 61 64       	sub    $0x64616220,%eax
  802a7b:	20 6d 6f             	and    %ch,0x6f(%rbp)
  802a7e:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802a82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802a89:	00 00 00 
  802a8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802a93:	00 00 00 
  802a96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802a9d:	00 00 00 

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
  802ce0:	ad 1c 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .........#......
  802cf0:	f1 22 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .".......#......
  802d00:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802d10:	01 23 80 00 00 00 00 00 c7 1c 80 00 00 00 00 00     .#..............
  802d20:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802d30:	be 1c 80 00 00 00 00 00 34 1d 80 00 00 00 00 00     ........4.......
  802d40:	01 23 80 00 00 00 00 00 be 1c 80 00 00 00 00 00     .#..............
  802d50:	01 1d 80 00 00 00 00 00 01 1d 80 00 00 00 00 00     ................
  802d60:	01 1d 80 00 00 00 00 00 01 1d 80 00 00 00 00 00     ................
  802d70:	01 1d 80 00 00 00 00 00 01 1d 80 00 00 00 00 00     ................
  802d80:	01 1d 80 00 00 00 00 00 01 1d 80 00 00 00 00 00     ................
  802d90:	01 1d 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .........#......
  802da0:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802db0:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802dc0:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802dd0:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802de0:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802df0:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802e00:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802e10:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802e20:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802e30:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802e40:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802e50:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802e60:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802e70:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802e80:	01 23 80 00 00 00 00 00 26 22 80 00 00 00 00 00     .#......&"......
  802e90:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802ea0:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802eb0:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802ec0:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802ed0:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802ee0:	52 1d 80 00 00 00 00 00 48 1f 80 00 00 00 00 00     R.......H.......
  802ef0:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802f00:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802f10:	80 1d 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .........#......
  802f20:	01 23 80 00 00 00 00 00 47 1d 80 00 00 00 00 00     .#......G.......
  802f30:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802f40:	e8 20 80 00 00 00 00 00 b0 21 80 00 00 00 00 00     . .......!......
  802f50:	01 23 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .#.......#......
  802f60:	18 1e 80 00 00 00 00 00 01 23 80 00 00 00 00 00     .........#......
  802f70:	1a 20 80 00 00 00 00 00 01 23 80 00 00 00 00 00     . .......#......
  802f80:	01 23 80 00 00 00 00 00 26 22 80 00 00 00 00 00     .#......&"......
  802f90:	01 23 80 00 00 00 00 00 b6 1c 80 00 00 00 00 00     .#..............

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
