
obj/user/memlayout:     file format elf64-x86-64


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
  80001e:	e8 51 03 00 00       	call   800374 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <memlayout>:
#ifndef PROT_SHARE
#define PROT_SHARE 0x400
#endif

void
memlayout(void) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 57                	push   %r15
  80002b:	41 56                	push   %r14
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 83 ec 48          	sub    $0x48,%rsp
    size_t total_p = 0;
    size_t total_u = 0;
    size_t total_w = 0;
    size_t total_cow = 0;

    cprintf("EID: %d, PEID: %d\n", thisenv->env_id, thisenv->env_parent_id);
  800036:	49 bc 00 50 80 00 00 	movabs $0x805000,%r12
  80003d:	00 00 00 
  800040:	49 8b 04 24          	mov    (%r12),%rax
  800044:	8b 90 cc 00 00 00    	mov    0xcc(%rax),%edx
  80004a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800050:	48 bf bc 2e 80 00 00 	movabs $0x802ebc,%rdi
  800057:	00 00 00 
  80005a:	b8 00 00 00 00       	mov    $0x0,%eax
  80005f:	48 bb 95 05 80 00 00 	movabs $0x800595,%rbx
  800066:	00 00 00 
  800069:	ff d3                	call   *%rbx
    cprintf("pml4=%p uvpml4=%p uvpdp=%p uvpd=%p uvpt=%p\n", thisenv->address_space.pml4,
  80006b:	49 8b 04 24          	mov    (%r12),%rax
  80006f:	48 8b b0 e8 00 00 00 	mov    0xe8(%rax),%rsi
  800076:	49 b9 00 00 00 80 00 	movabs $0x10080000000,%r9
  80007d:	01 00 00 
  800080:	49 b8 00 00 00 00 00 	movabs $0x10000000000,%r8
  800087:	01 00 00 
  80008a:	48 b9 00 00 40 80 00 	movabs $0x10080400000,%rcx
  800091:	01 00 00 
  800094:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80009b:	01 00 00 
  80009e:	48 bf 68 2f 80 00 00 	movabs $0x802f68,%rdi
  8000a5:	00 00 00 
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	ff d3                	call   *%rbx
    size_t total_cow = 0;
  8000af:	48 c7 45 90 00 00 00 	movq   $0x0,-0x70(%rbp)
  8000b6:	00 
    size_t total_w = 0;
  8000b7:	48 c7 45 98 00 00 00 	movq   $0x0,-0x68(%rbp)
  8000be:	00 
    size_t total_u = 0;
  8000bf:	48 c7 45 a0 00 00 00 	movq   $0x0,-0x60(%rbp)
  8000c6:	00 
    size_t total_p = 0;
  8000c7:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
  8000ce:	00 
            (void *)UVPML4, (void *)UVPDP, (void *)UVPT, (void *)UVPD);

    for (addr = 0; addr < KERN_BASE_ADDR; addr += PAGE_SIZE) {
  8000cf:	41 be 00 00 00 00    	mov    $0x0,%r14d
        pte_t ent = get_uvpt_entry((void *)addr);
  8000d5:	49 bd d4 28 80 00 00 	movabs $0x8028d4,%r13
  8000dc:	00 00 00 
        if (ent) {
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  8000df:	49 bc e5 2e 80 00 00 	movabs $0x802ee5,%r12
  8000e6:	00 00 00 
  8000e9:	eb 5e                	jmp    800149 <memlayout+0x124>
                    (void *)get_uvpt_entry((void *)addr), (unsigned long)addr, (unsigned long)ent,
  8000eb:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8000ef:	41 ff d5             	call   *%r13
  8000f2:	48 89 c6             	mov    %rax,%rsi
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  8000f5:	48 83 ec 08          	sub    $0x8,%rsp
  8000f9:	41 57                	push   %r15
  8000fb:	ff 75 c0             	push   -0x40(%rbp)
  8000fe:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800101:	50                   	push   %rax
  800102:	44 8b 4d b8          	mov    -0x48(%rbp),%r9d
  800106:	44 8b 45 b4          	mov    -0x4c(%rbp),%r8d
  80010a:	48 89 d9             	mov    %rbx,%rcx
  80010d:	4c 89 f2             	mov    %r14,%rdx
  800110:	48 bf 98 2f 80 00 00 	movabs $0x802f98,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	48 bb 95 05 80 00 00 	movabs $0x800595,%rbx
  800126:	00 00 00 
  800129:	ff d3                	call   *%rbx
  80012b:	48 83 c4 20          	add    $0x20,%rsp
    for (addr = 0; addr < KERN_BASE_ADDR; addr += PAGE_SIZE) {
  80012f:	49 81 c6 00 10 00 00 	add    $0x1000,%r14
  800136:	48 b8 00 00 00 40 80 	movabs $0x8040000000,%rax
  80013d:	00 00 00 
  800140:	49 39 c6             	cmp    %rax,%r14
  800143:	0f 84 8f 00 00 00    	je     8001d8 <memlayout+0x1b3>
        pte_t ent = get_uvpt_entry((void *)addr);
  800149:	4c 89 75 c8          	mov    %r14,-0x38(%rbp)
  80014d:	4c 89 f7             	mov    %r14,%rdi
  800150:	41 ff d5             	call   *%r13
  800153:	48 89 c3             	mov    %rax,%rbx
        if (ent) {
  800156:	48 85 c0             	test   %rax,%rax
  800159:	74 d4                	je     80012f <memlayout+0x10a>
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  80015b:	a8 40                	test   $0x40,%al
  80015d:	49 bf b0 2e 80 00 00 	movabs $0x802eb0,%r15
  800164:	00 00 00 
  800167:	4d 0f 44 fc          	cmove  %r12,%r15
  80016b:	4c 89 65 c0          	mov    %r12,-0x40(%rbp)
  80016f:	f6 c4 08             	test   $0x8,%ah
  800172:	74 13                	je     800187 <memlayout+0x162>
                    (ent & PTE_P)    ? total_p++, 'P' : '-',
                    (ent & PTE_U)    ? total_u++, 'U' : '-',
                    (ent & PTE_W)    ? total_w++, 'W' : '-',
                    (ent & PROT_COW) ? total_cow++, " COW" : "",
  800174:	48 83 45 90 01       	addq   $0x1,-0x70(%rbp)
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  800179:	48 b8 b7 2e 80 00 00 	movabs $0x802eb7,%rax
  800180:	00 00 00 
  800183:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800187:	c7 45 bc 2d 00 00 00 	movl   $0x2d,-0x44(%rbp)
  80018e:	f6 c3 02             	test   $0x2,%bl
  800191:	74 0c                	je     80019f <memlayout+0x17a>
                    (ent & PTE_W)    ? total_w++, 'W' : '-',
  800193:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  800198:	c7 45 bc 57 00 00 00 	movl   $0x57,-0x44(%rbp)
  80019f:	c7 45 b8 2d 00 00 00 	movl   $0x2d,-0x48(%rbp)
  8001a6:	f6 c3 04             	test   $0x4,%bl
  8001a9:	74 0c                	je     8001b7 <memlayout+0x192>
                    (ent & PTE_U)    ? total_u++, 'U' : '-',
  8001ab:	48 83 45 a0 01       	addq   $0x1,-0x60(%rbp)
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  8001b0:	c7 45 b8 55 00 00 00 	movl   $0x55,-0x48(%rbp)
  8001b7:	c7 45 b4 2d 00 00 00 	movl   $0x2d,-0x4c(%rbp)
  8001be:	f6 c3 01             	test   $0x1,%bl
  8001c1:	0f 84 24 ff ff ff    	je     8000eb <memlayout+0xc6>
                    (ent & PTE_P)    ? total_p++, 'P' : '-',
  8001c7:	48 83 45 a8 01       	addq   $0x1,-0x58(%rbp)
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  8001cc:	c7 45 b4 50 00 00 00 	movl   $0x50,-0x4c(%rbp)
  8001d3:	e9 13 ff ff ff       	jmp    8000eb <memlayout+0xc6>
                    (ent & PROT_SHARE) ? " SHARE" : "");
        }
    }

    cprintf("Memory usage summary:\n");
  8001d8:	48 bf cf 2e 80 00 00 	movabs $0x802ecf,%rdi
  8001df:	00 00 00 
  8001e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e7:	48 bb 95 05 80 00 00 	movabs $0x800595,%rbx
  8001ee:	00 00 00 
  8001f1:	ff d3                	call   *%rbx
    cprintf("  PTE_P: %lu\n", (unsigned long)total_p);
  8001f3:	48 8b 75 a8          	mov    -0x58(%rbp),%rsi
  8001f7:	48 bf e6 2e 80 00 00 	movabs $0x802ee6,%rdi
  8001fe:	00 00 00 
  800201:	b8 00 00 00 00       	mov    $0x0,%eax
  800206:	ff d3                	call   *%rbx
    cprintf("  PTE_U: %lu\n", (unsigned long)total_u);
  800208:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80020c:	48 bf f4 2e 80 00 00 	movabs $0x802ef4,%rdi
  800213:	00 00 00 
  800216:	b8 00 00 00 00       	mov    $0x0,%eax
  80021b:	ff d3                	call   *%rbx
    cprintf("  PTE_W: %lu\n", (unsigned long)total_w);
  80021d:	48 8b 75 98          	mov    -0x68(%rbp),%rsi
  800221:	48 bf 02 2f 80 00 00 	movabs $0x802f02,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	ff d3                	call   *%rbx
    cprintf("  PTE_COW: %lu\n", (unsigned long)total_cow);
  800232:	48 8b 75 90          	mov    -0x70(%rbp),%rsi
  800236:	48 bf 10 2f 80 00 00 	movabs $0x802f10,%rdi
  80023d:	00 00 00 
  800240:	b8 00 00 00 00       	mov    $0x0,%eax
  800245:	ff d3                	call   *%rbx
}
  800247:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80024b:	5b                   	pop    %rbx
  80024c:	41 5c                	pop    %r12
  80024e:	41 5d                	pop    %r13
  800250:	41 5e                	pop    %r14
  800252:	41 5f                	pop    %r15
  800254:	5d                   	pop    %rbp
  800255:	c3                   	ret    

0000000000800256 <umain>:

void
umain(int argc, char *argv[]) {
  800256:	55                   	push   %rbp
  800257:	48 89 e5             	mov    %rsp,%rbp
  80025a:	41 54                	push   %r12
  80025c:	53                   	push   %rbx
  80025d:	48 83 ec 10          	sub    $0x10,%rsp
    envid_t ceid;
    int pipefd[2];
    int res;

    memlayout();
  800261:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800268:	00 00 00 
  80026b:	ff d0                	call   *%rax

    res = pipe(pipefd);
  80026d:	48 8d 7d e8          	lea    -0x18(%rbp),%rdi
  800271:	48 b8 75 26 80 00 00 	movabs $0x802675,%rax
  800278:	00 00 00 
  80027b:	ff d0                	call   *%rax
    if (res < 0) panic("pipe() failed\n");
  80027d:	85 c0                	test   %eax,%eax
  80027f:	78 46                	js     8002c7 <umain+0x71>
    ceid = fork();
  800281:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  800288:	00 00 00 
  80028b:	ff d0                	call   *%rax
    if (ceid < 0) panic("fork() failed\n");
  80028d:	85 c0                	test   %eax,%eax
  80028f:	78 60                	js     8002f1 <umain+0x9b>

    if (!ceid) {
  800291:	0f 84 84 00 00 00    	je     80031b <umain+0xc5>
        cprintf("==== Child\n");
        memlayout();
        return;
    }

    cprintf("==== Parent\n");
  800297:	48 bf 5b 2f 80 00 00 	movabs $0x802f5b,%rdi
  80029e:	00 00 00 
  8002a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a6:	48 ba 95 05 80 00 00 	movabs $0x800595,%rdx
  8002ad:	00 00 00 
  8002b0:	ff d2                	call   *%rdx
    memlayout();
  8002b2:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8002b9:	00 00 00 
  8002bc:	ff d0                	call   *%rax
}
  8002be:	48 83 c4 10          	add    $0x10,%rsp
  8002c2:	5b                   	pop    %rbx
  8002c3:	41 5c                	pop    %r12
  8002c5:	5d                   	pop    %rbp
  8002c6:	c3                   	ret    
    if (res < 0) panic("pipe() failed\n");
  8002c7:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  8002ce:	00 00 00 
  8002d1:	be 33 00 00 00       	mov    $0x33,%esi
  8002d6:	48 bf 2f 2f 80 00 00 	movabs $0x802f2f,%rdi
  8002dd:	00 00 00 
  8002e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e5:	48 b9 45 04 80 00 00 	movabs $0x800445,%rcx
  8002ec:	00 00 00 
  8002ef:	ff d1                	call   *%rcx
    if (ceid < 0) panic("fork() failed\n");
  8002f1:	48 ba 40 2f 80 00 00 	movabs $0x802f40,%rdx
  8002f8:	00 00 00 
  8002fb:	be 35 00 00 00       	mov    $0x35,%esi
  800300:	48 bf 2f 2f 80 00 00 	movabs $0x802f2f,%rdi
  800307:	00 00 00 
  80030a:	b8 00 00 00 00       	mov    $0x0,%eax
  80030f:	48 b9 45 04 80 00 00 	movabs $0x800445,%rcx
  800316:	00 00 00 
  800319:	ff d1                	call   *%rcx
        cprintf("\n");
  80031b:	48 bf e4 2e 80 00 00 	movabs $0x802ee4,%rdi
  800322:	00 00 00 
  800325:	48 ba 95 05 80 00 00 	movabs $0x800595,%rdx
  80032c:	00 00 00 
  80032f:	ff d2                	call   *%rdx
  800331:	bb 00 90 01 00       	mov    $0x19000,%ebx
            sys_yield();
  800336:	49 bc 01 14 80 00 00 	movabs $0x801401,%r12
  80033d:	00 00 00 
  800340:	41 ff d4             	call   *%r12
        for (i = 0; i < 102400; i++)
  800343:	83 eb 01             	sub    $0x1,%ebx
  800346:	75 f8                	jne    800340 <umain+0xea>
        cprintf("==== Child\n");
  800348:	48 bf 4f 2f 80 00 00 	movabs $0x802f4f,%rdi
  80034f:	00 00 00 
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	48 ba 95 05 80 00 00 	movabs $0x800595,%rdx
  80035e:	00 00 00 
  800361:	ff d2                	call   *%rdx
        memlayout();
  800363:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80036a:	00 00 00 
  80036d:	ff d0                	call   *%rax
        return;
  80036f:	e9 4a ff ff ff       	jmp    8002be <umain+0x68>

0000000000800374 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800374:	55                   	push   %rbp
  800375:	48 89 e5             	mov    %rsp,%rbp
  800378:	41 56                	push   %r14
  80037a:	41 55                	push   %r13
  80037c:	41 54                	push   %r12
  80037e:	53                   	push   %rbx
  80037f:	41 89 fd             	mov    %edi,%r13d
  800382:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800385:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80038c:	00 00 00 
  80038f:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800396:	00 00 00 
  800399:	48 39 c2             	cmp    %rax,%rdx
  80039c:	73 17                	jae    8003b5 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80039e:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8003a1:	49 89 c4             	mov    %rax,%r12
  8003a4:	48 83 c3 08          	add    $0x8,%rbx
  8003a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ad:	ff 53 f8             	call   *-0x8(%rbx)
  8003b0:	4c 39 e3             	cmp    %r12,%rbx
  8003b3:	72 ef                	jb     8003a4 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8003b5:	48 b8 d0 13 80 00 00 	movabs $0x8013d0,%rax
  8003bc:	00 00 00 
  8003bf:	ff d0                	call   *%rax
  8003c1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003c6:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8003ca:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8003ce:	48 c1 e0 04          	shl    $0x4,%rax
  8003d2:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8003d9:	00 00 00 
  8003dc:	48 01 d0             	add    %rdx,%rax
  8003df:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8003e6:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8003e9:	45 85 ed             	test   %r13d,%r13d
  8003ec:	7e 0d                	jle    8003fb <libmain+0x87>
  8003ee:	49 8b 06             	mov    (%r14),%rax
  8003f1:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8003f8:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8003fb:	4c 89 f6             	mov    %r14,%rsi
  8003fe:	44 89 ef             	mov    %r13d,%edi
  800401:	48 b8 56 02 80 00 00 	movabs $0x800256,%rax
  800408:	00 00 00 
  80040b:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80040d:	48 b8 22 04 80 00 00 	movabs $0x800422,%rax
  800414:	00 00 00 
  800417:	ff d0                	call   *%rax
#endif
}
  800419:	5b                   	pop    %rbx
  80041a:	41 5c                	pop    %r12
  80041c:	41 5d                	pop    %r13
  80041e:	41 5e                	pop    %r14
  800420:	5d                   	pop    %rbp
  800421:	c3                   	ret    

0000000000800422 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800422:	55                   	push   %rbp
  800423:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800426:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  80042d:	00 00 00 
  800430:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800432:	bf 00 00 00 00       	mov    $0x0,%edi
  800437:	48 b8 65 13 80 00 00 	movabs $0x801365,%rax
  80043e:	00 00 00 
  800441:	ff d0                	call   *%rax
}
  800443:	5d                   	pop    %rbp
  800444:	c3                   	ret    

0000000000800445 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800445:	55                   	push   %rbp
  800446:	48 89 e5             	mov    %rsp,%rbp
  800449:	41 56                	push   %r14
  80044b:	41 55                	push   %r13
  80044d:	41 54                	push   %r12
  80044f:	53                   	push   %rbx
  800450:	48 83 ec 50          	sub    $0x50,%rsp
  800454:	49 89 fc             	mov    %rdi,%r12
  800457:	41 89 f5             	mov    %esi,%r13d
  80045a:	48 89 d3             	mov    %rdx,%rbx
  80045d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800461:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800465:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800469:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800470:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800474:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800478:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80047c:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800480:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800487:	00 00 00 
  80048a:	4c 8b 30             	mov    (%rax),%r14
  80048d:	48 b8 d0 13 80 00 00 	movabs $0x8013d0,%rax
  800494:	00 00 00 
  800497:	ff d0                	call   *%rax
  800499:	89 c6                	mov    %eax,%esi
  80049b:	45 89 e8             	mov    %r13d,%r8d
  80049e:	4c 89 e1             	mov    %r12,%rcx
  8004a1:	4c 89 f2             	mov    %r14,%rdx
  8004a4:	48 bf c8 2f 80 00 00 	movabs $0x802fc8,%rdi
  8004ab:	00 00 00 
  8004ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b3:	49 bc 95 05 80 00 00 	movabs $0x800595,%r12
  8004ba:	00 00 00 
  8004bd:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8004c0:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8004c4:	48 89 df             	mov    %rbx,%rdi
  8004c7:	48 b8 31 05 80 00 00 	movabs $0x800531,%rax
  8004ce:	00 00 00 
  8004d1:	ff d0                	call   *%rax
    cprintf("\n");
  8004d3:	48 bf e4 2e 80 00 00 	movabs $0x802ee4,%rdi
  8004da:	00 00 00 
  8004dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e2:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8004e5:	cc                   	int3   
  8004e6:	eb fd                	jmp    8004e5 <_panic+0xa0>

00000000008004e8 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8004e8:	55                   	push   %rbp
  8004e9:	48 89 e5             	mov    %rsp,%rbp
  8004ec:	53                   	push   %rbx
  8004ed:	48 83 ec 08          	sub    $0x8,%rsp
  8004f1:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8004f4:	8b 06                	mov    (%rsi),%eax
  8004f6:	8d 50 01             	lea    0x1(%rax),%edx
  8004f9:	89 16                	mov    %edx,(%rsi)
  8004fb:	48 98                	cltq   
  8004fd:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800502:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800508:	74 0a                	je     800514 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80050a:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80050e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800512:	c9                   	leave  
  800513:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800514:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800518:	be ff 00 00 00       	mov    $0xff,%esi
  80051d:	48 b8 07 13 80 00 00 	movabs $0x801307,%rax
  800524:	00 00 00 
  800527:	ff d0                	call   *%rax
        state->offset = 0;
  800529:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80052f:	eb d9                	jmp    80050a <putch+0x22>

0000000000800531 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800531:	55                   	push   %rbp
  800532:	48 89 e5             	mov    %rsp,%rbp
  800535:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80053c:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80053f:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800546:	b9 21 00 00 00       	mov    $0x21,%ecx
  80054b:	b8 00 00 00 00       	mov    $0x0,%eax
  800550:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800553:	48 89 f1             	mov    %rsi,%rcx
  800556:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80055d:	48 bf e8 04 80 00 00 	movabs $0x8004e8,%rdi
  800564:	00 00 00 
  800567:	48 b8 e5 06 80 00 00 	movabs $0x8006e5,%rax
  80056e:	00 00 00 
  800571:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800573:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80057a:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800581:	48 b8 07 13 80 00 00 	movabs $0x801307,%rax
  800588:	00 00 00 
  80058b:	ff d0                	call   *%rax

    return state.count;
}
  80058d:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800593:	c9                   	leave  
  800594:	c3                   	ret    

0000000000800595 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800595:	55                   	push   %rbp
  800596:	48 89 e5             	mov    %rsp,%rbp
  800599:	48 83 ec 50          	sub    $0x50,%rsp
  80059d:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8005a1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8005a5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8005a9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8005ad:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8005b1:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8005b8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005c0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8005c4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8005c8:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8005cc:	48 b8 31 05 80 00 00 	movabs $0x800531,%rax
  8005d3:	00 00 00 
  8005d6:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

00000000008005da <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8005da:	55                   	push   %rbp
  8005db:	48 89 e5             	mov    %rsp,%rbp
  8005de:	41 57                	push   %r15
  8005e0:	41 56                	push   %r14
  8005e2:	41 55                	push   %r13
  8005e4:	41 54                	push   %r12
  8005e6:	53                   	push   %rbx
  8005e7:	48 83 ec 18          	sub    $0x18,%rsp
  8005eb:	49 89 fc             	mov    %rdi,%r12
  8005ee:	49 89 f5             	mov    %rsi,%r13
  8005f1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8005f5:	8b 45 10             	mov    0x10(%rbp),%eax
  8005f8:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8005fb:	41 89 cf             	mov    %ecx,%r15d
  8005fe:	49 39 d7             	cmp    %rdx,%r15
  800601:	76 5b                	jbe    80065e <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800603:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800607:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80060b:	85 db                	test   %ebx,%ebx
  80060d:	7e 0e                	jle    80061d <print_num+0x43>
            putch(padc, put_arg);
  80060f:	4c 89 ee             	mov    %r13,%rsi
  800612:	44 89 f7             	mov    %r14d,%edi
  800615:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800618:	83 eb 01             	sub    $0x1,%ebx
  80061b:	75 f2                	jne    80060f <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  80061d:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800621:	48 b9 eb 2f 80 00 00 	movabs $0x802feb,%rcx
  800628:	00 00 00 
  80062b:	48 b8 fc 2f 80 00 00 	movabs $0x802ffc,%rax
  800632:	00 00 00 
  800635:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800639:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80063d:	ba 00 00 00 00       	mov    $0x0,%edx
  800642:	49 f7 f7             	div    %r15
  800645:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800649:	4c 89 ee             	mov    %r13,%rsi
  80064c:	41 ff d4             	call   *%r12
}
  80064f:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800653:	5b                   	pop    %rbx
  800654:	41 5c                	pop    %r12
  800656:	41 5d                	pop    %r13
  800658:	41 5e                	pop    %r14
  80065a:	41 5f                	pop    %r15
  80065c:	5d                   	pop    %rbp
  80065d:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  80065e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800662:	ba 00 00 00 00       	mov    $0x0,%edx
  800667:	49 f7 f7             	div    %r15
  80066a:	48 83 ec 08          	sub    $0x8,%rsp
  80066e:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800672:	52                   	push   %rdx
  800673:	45 0f be c9          	movsbl %r9b,%r9d
  800677:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80067b:	48 89 c2             	mov    %rax,%rdx
  80067e:	48 b8 da 05 80 00 00 	movabs $0x8005da,%rax
  800685:	00 00 00 
  800688:	ff d0                	call   *%rax
  80068a:	48 83 c4 10          	add    $0x10,%rsp
  80068e:	eb 8d                	jmp    80061d <print_num+0x43>

0000000000800690 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800690:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800694:	48 8b 06             	mov    (%rsi),%rax
  800697:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80069b:	73 0a                	jae    8006a7 <sprintputch+0x17>
        *state->start++ = ch;
  80069d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006a1:	48 89 16             	mov    %rdx,(%rsi)
  8006a4:	40 88 38             	mov    %dil,(%rax)
    }
}
  8006a7:	c3                   	ret    

00000000008006a8 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8006a8:	55                   	push   %rbp
  8006a9:	48 89 e5             	mov    %rsp,%rbp
  8006ac:	48 83 ec 50          	sub    $0x50,%rsp
  8006b0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8006b4:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8006b8:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8006bc:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8006c3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006c7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006cb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8006cf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8006d3:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8006d7:	48 b8 e5 06 80 00 00 	movabs $0x8006e5,%rax
  8006de:	00 00 00 
  8006e1:	ff d0                	call   *%rax
}
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

00000000008006e5 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8006e5:	55                   	push   %rbp
  8006e6:	48 89 e5             	mov    %rsp,%rbp
  8006e9:	41 57                	push   %r15
  8006eb:	41 56                	push   %r14
  8006ed:	41 55                	push   %r13
  8006ef:	41 54                	push   %r12
  8006f1:	53                   	push   %rbx
  8006f2:	48 83 ec 48          	sub    $0x48,%rsp
  8006f6:	49 89 fc             	mov    %rdi,%r12
  8006f9:	49 89 f6             	mov    %rsi,%r14
  8006fc:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  8006ff:	48 8b 01             	mov    (%rcx),%rax
  800702:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800706:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80070a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80070e:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800712:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800716:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  80071a:	41 0f b6 3f          	movzbl (%r15),%edi
  80071e:	40 80 ff 25          	cmp    $0x25,%dil
  800722:	74 18                	je     80073c <vprintfmt+0x57>
            if (!ch) return;
  800724:	40 84 ff             	test   %dil,%dil
  800727:	0f 84 d1 06 00 00    	je     800dfe <vprintfmt+0x719>
            putch(ch, put_arg);
  80072d:	40 0f b6 ff          	movzbl %dil,%edi
  800731:	4c 89 f6             	mov    %r14,%rsi
  800734:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800737:	49 89 df             	mov    %rbx,%r15
  80073a:	eb da                	jmp    800716 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  80073c:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800740:	b9 00 00 00 00       	mov    $0x0,%ecx
  800745:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  800749:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  80074e:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800754:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80075b:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  80075f:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800764:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  80076a:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  80076e:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800772:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800776:	3c 57                	cmp    $0x57,%al
  800778:	0f 87 65 06 00 00    	ja     800de3 <vprintfmt+0x6fe>
  80077e:	0f b6 c0             	movzbl %al,%eax
  800781:	49 ba 80 31 80 00 00 	movabs $0x803180,%r10
  800788:	00 00 00 
  80078b:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  80078f:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800792:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800796:	eb d2                	jmp    80076a <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  800798:	4c 89 fb             	mov    %r15,%rbx
  80079b:	44 89 c1             	mov    %r8d,%ecx
  80079e:	eb ca                	jmp    80076a <vprintfmt+0x85>
            padc = ch;
  8007a0:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8007a4:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8007a7:	eb c1                	jmp    80076a <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8007a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ac:	83 f8 2f             	cmp    $0x2f,%eax
  8007af:	77 24                	ja     8007d5 <vprintfmt+0xf0>
  8007b1:	41 89 c1             	mov    %eax,%r9d
  8007b4:	49 01 f1             	add    %rsi,%r9
  8007b7:	83 c0 08             	add    $0x8,%eax
  8007ba:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007bd:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8007c0:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8007c3:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8007c7:	79 a1                	jns    80076a <vprintfmt+0x85>
                width = precision;
  8007c9:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  8007cd:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8007d3:	eb 95                	jmp    80076a <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8007d5:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8007d9:	49 8d 41 08          	lea    0x8(%r9),%rax
  8007dd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007e1:	eb da                	jmp    8007bd <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8007e3:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8007e7:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8007eb:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8007ef:	3c 39                	cmp    $0x39,%al
  8007f1:	77 1e                	ja     800811 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8007f3:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  8007f7:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  8007fc:	0f b6 c0             	movzbl %al,%eax
  8007ff:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800804:	41 0f b6 07          	movzbl (%r15),%eax
  800808:	3c 39                	cmp    $0x39,%al
  80080a:	76 e7                	jbe    8007f3 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  80080c:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  80080f:	eb b2                	jmp    8007c3 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800811:	4c 89 fb             	mov    %r15,%rbx
  800814:	eb ad                	jmp    8007c3 <vprintfmt+0xde>
            width = MAX(0, width);
  800816:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800819:	85 c0                	test   %eax,%eax
  80081b:	0f 48 c7             	cmovs  %edi,%eax
  80081e:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800821:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800824:	e9 41 ff ff ff       	jmp    80076a <vprintfmt+0x85>
            lflag++;
  800829:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80082c:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80082f:	e9 36 ff ff ff       	jmp    80076a <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800834:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800837:	83 f8 2f             	cmp    $0x2f,%eax
  80083a:	77 18                	ja     800854 <vprintfmt+0x16f>
  80083c:	89 c2                	mov    %eax,%edx
  80083e:	48 01 f2             	add    %rsi,%rdx
  800841:	83 c0 08             	add    $0x8,%eax
  800844:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800847:	4c 89 f6             	mov    %r14,%rsi
  80084a:	8b 3a                	mov    (%rdx),%edi
  80084c:	41 ff d4             	call   *%r12
            break;
  80084f:	e9 c2 fe ff ff       	jmp    800716 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800854:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800858:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80085c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800860:	eb e5                	jmp    800847 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800862:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800865:	83 f8 2f             	cmp    $0x2f,%eax
  800868:	77 5b                	ja     8008c5 <vprintfmt+0x1e0>
  80086a:	89 c2                	mov    %eax,%edx
  80086c:	48 01 d6             	add    %rdx,%rsi
  80086f:	83 c0 08             	add    $0x8,%eax
  800872:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800875:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800877:	89 c8                	mov    %ecx,%eax
  800879:	c1 f8 1f             	sar    $0x1f,%eax
  80087c:	31 c1                	xor    %eax,%ecx
  80087e:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800880:	83 f9 13             	cmp    $0x13,%ecx
  800883:	7f 4e                	jg     8008d3 <vprintfmt+0x1ee>
  800885:	48 63 c1             	movslq %ecx,%rax
  800888:	48 ba 40 34 80 00 00 	movabs $0x803440,%rdx
  80088f:	00 00 00 
  800892:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800896:	48 85 c0             	test   %rax,%rax
  800899:	74 38                	je     8008d3 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  80089b:	48 89 c1             	mov    %rax,%rcx
  80089e:	48 ba 79 36 80 00 00 	movabs $0x803679,%rdx
  8008a5:	00 00 00 
  8008a8:	4c 89 f6             	mov    %r14,%rsi
  8008ab:	4c 89 e7             	mov    %r12,%rdi
  8008ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b3:	49 b8 a8 06 80 00 00 	movabs $0x8006a8,%r8
  8008ba:	00 00 00 
  8008bd:	41 ff d0             	call   *%r8
  8008c0:	e9 51 fe ff ff       	jmp    800716 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8008c5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008c9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008cd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008d1:	eb a2                	jmp    800875 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8008d3:	48 ba 14 30 80 00 00 	movabs $0x803014,%rdx
  8008da:	00 00 00 
  8008dd:	4c 89 f6             	mov    %r14,%rsi
  8008e0:	4c 89 e7             	mov    %r12,%rdi
  8008e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e8:	49 b8 a8 06 80 00 00 	movabs $0x8006a8,%r8
  8008ef:	00 00 00 
  8008f2:	41 ff d0             	call   *%r8
  8008f5:	e9 1c fe ff ff       	jmp    800716 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  8008fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fd:	83 f8 2f             	cmp    $0x2f,%eax
  800900:	77 55                	ja     800957 <vprintfmt+0x272>
  800902:	89 c2                	mov    %eax,%edx
  800904:	48 01 d6             	add    %rdx,%rsi
  800907:	83 c0 08             	add    $0x8,%eax
  80090a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80090d:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800910:	48 85 d2             	test   %rdx,%rdx
  800913:	48 b8 0d 30 80 00 00 	movabs $0x80300d,%rax
  80091a:	00 00 00 
  80091d:	48 0f 45 c2          	cmovne %rdx,%rax
  800921:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800925:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800929:	7e 06                	jle    800931 <vprintfmt+0x24c>
  80092b:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  80092f:	75 34                	jne    800965 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800931:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800935:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800939:	0f b6 00             	movzbl (%rax),%eax
  80093c:	84 c0                	test   %al,%al
  80093e:	0f 84 b2 00 00 00    	je     8009f6 <vprintfmt+0x311>
  800944:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  800948:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  80094d:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800951:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800955:	eb 74                	jmp    8009cb <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  800957:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80095b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80095f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800963:	eb a8                	jmp    80090d <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800965:	49 63 f5             	movslq %r13d,%rsi
  800968:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  80096c:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  800973:	00 00 00 
  800976:	ff d0                	call   *%rax
  800978:	48 89 c2             	mov    %rax,%rdx
  80097b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80097e:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800980:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800983:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800986:	85 c0                	test   %eax,%eax
  800988:	7e a7                	jle    800931 <vprintfmt+0x24c>
  80098a:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  80098e:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800992:	41 89 cd             	mov    %ecx,%r13d
  800995:	4c 89 f6             	mov    %r14,%rsi
  800998:	89 df                	mov    %ebx,%edi
  80099a:	41 ff d4             	call   *%r12
  80099d:	41 83 ed 01          	sub    $0x1,%r13d
  8009a1:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8009a5:	75 ee                	jne    800995 <vprintfmt+0x2b0>
  8009a7:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8009ab:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8009af:	eb 80                	jmp    800931 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8009b1:	0f b6 f8             	movzbl %al,%edi
  8009b4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009b8:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8009bb:	41 83 ef 01          	sub    $0x1,%r15d
  8009bf:	48 83 c3 01          	add    $0x1,%rbx
  8009c3:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8009c7:	84 c0                	test   %al,%al
  8009c9:	74 1f                	je     8009ea <vprintfmt+0x305>
  8009cb:	45 85 ed             	test   %r13d,%r13d
  8009ce:	78 06                	js     8009d6 <vprintfmt+0x2f1>
  8009d0:	41 83 ed 01          	sub    $0x1,%r13d
  8009d4:	78 46                	js     800a1c <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8009d6:	45 84 f6             	test   %r14b,%r14b
  8009d9:	74 d6                	je     8009b1 <vprintfmt+0x2cc>
  8009db:	8d 50 e0             	lea    -0x20(%rax),%edx
  8009de:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009e3:	80 fa 5e             	cmp    $0x5e,%dl
  8009e6:	77 cc                	ja     8009b4 <vprintfmt+0x2cf>
  8009e8:	eb c7                	jmp    8009b1 <vprintfmt+0x2cc>
  8009ea:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8009ee:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8009f2:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  8009f6:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8009f9:	8d 58 ff             	lea    -0x1(%rax),%ebx
  8009fc:	85 c0                	test   %eax,%eax
  8009fe:	0f 8e 12 fd ff ff    	jle    800716 <vprintfmt+0x31>
  800a04:	4c 89 f6             	mov    %r14,%rsi
  800a07:	bf 20 00 00 00       	mov    $0x20,%edi
  800a0c:	41 ff d4             	call   *%r12
  800a0f:	83 eb 01             	sub    $0x1,%ebx
  800a12:	83 fb ff             	cmp    $0xffffffff,%ebx
  800a15:	75 ed                	jne    800a04 <vprintfmt+0x31f>
  800a17:	e9 fa fc ff ff       	jmp    800716 <vprintfmt+0x31>
  800a1c:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800a20:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800a24:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  800a28:	eb cc                	jmp    8009f6 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800a2a:	45 89 cd             	mov    %r9d,%r13d
  800a2d:	84 c9                	test   %cl,%cl
  800a2f:	75 25                	jne    800a56 <vprintfmt+0x371>
    switch (lflag) {
  800a31:	85 d2                	test   %edx,%edx
  800a33:	74 57                	je     800a8c <vprintfmt+0x3a7>
  800a35:	83 fa 01             	cmp    $0x1,%edx
  800a38:	74 78                	je     800ab2 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800a3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3d:	83 f8 2f             	cmp    $0x2f,%eax
  800a40:	0f 87 92 00 00 00    	ja     800ad8 <vprintfmt+0x3f3>
  800a46:	89 c2                	mov    %eax,%edx
  800a48:	48 01 d6             	add    %rdx,%rsi
  800a4b:	83 c0 08             	add    $0x8,%eax
  800a4e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a51:	48 8b 1e             	mov    (%rsi),%rbx
  800a54:	eb 16                	jmp    800a6c <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800a56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a59:	83 f8 2f             	cmp    $0x2f,%eax
  800a5c:	77 20                	ja     800a7e <vprintfmt+0x399>
  800a5e:	89 c2                	mov    %eax,%edx
  800a60:	48 01 d6             	add    %rdx,%rsi
  800a63:	83 c0 08             	add    $0x8,%eax
  800a66:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a69:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800a6c:	48 85 db             	test   %rbx,%rbx
  800a6f:	78 78                	js     800ae9 <vprintfmt+0x404>
            num = i;
  800a71:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800a74:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800a79:	e9 49 02 00 00       	jmp    800cc7 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a7e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a82:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a86:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a8a:	eb dd                	jmp    800a69 <vprintfmt+0x384>
        return va_arg(*ap, int);
  800a8c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8f:	83 f8 2f             	cmp    $0x2f,%eax
  800a92:	77 10                	ja     800aa4 <vprintfmt+0x3bf>
  800a94:	89 c2                	mov    %eax,%edx
  800a96:	48 01 d6             	add    %rdx,%rsi
  800a99:	83 c0 08             	add    $0x8,%eax
  800a9c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a9f:	48 63 1e             	movslq (%rsi),%rbx
  800aa2:	eb c8                	jmp    800a6c <vprintfmt+0x387>
  800aa4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800aa8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800aac:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ab0:	eb ed                	jmp    800a9f <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800ab2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab5:	83 f8 2f             	cmp    $0x2f,%eax
  800ab8:	77 10                	ja     800aca <vprintfmt+0x3e5>
  800aba:	89 c2                	mov    %eax,%edx
  800abc:	48 01 d6             	add    %rdx,%rsi
  800abf:	83 c0 08             	add    $0x8,%eax
  800ac2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ac5:	48 8b 1e             	mov    (%rsi),%rbx
  800ac8:	eb a2                	jmp    800a6c <vprintfmt+0x387>
  800aca:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ace:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ad2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad6:	eb ed                	jmp    800ac5 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800ad8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800adc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ae0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ae4:	e9 68 ff ff ff       	jmp    800a51 <vprintfmt+0x36c>
                putch('-', put_arg);
  800ae9:	4c 89 f6             	mov    %r14,%rsi
  800aec:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800af1:	41 ff d4             	call   *%r12
                i = -i;
  800af4:	48 f7 db             	neg    %rbx
  800af7:	e9 75 ff ff ff       	jmp    800a71 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800afc:	45 89 cd             	mov    %r9d,%r13d
  800aff:	84 c9                	test   %cl,%cl
  800b01:	75 2d                	jne    800b30 <vprintfmt+0x44b>
    switch (lflag) {
  800b03:	85 d2                	test   %edx,%edx
  800b05:	74 57                	je     800b5e <vprintfmt+0x479>
  800b07:	83 fa 01             	cmp    $0x1,%edx
  800b0a:	74 7f                	je     800b8b <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800b0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0f:	83 f8 2f             	cmp    $0x2f,%eax
  800b12:	0f 87 a1 00 00 00    	ja     800bb9 <vprintfmt+0x4d4>
  800b18:	89 c2                	mov    %eax,%edx
  800b1a:	48 01 d6             	add    %rdx,%rsi
  800b1d:	83 c0 08             	add    $0x8,%eax
  800b20:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b23:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800b26:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800b2b:	e9 97 01 00 00       	jmp    800cc7 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b30:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b33:	83 f8 2f             	cmp    $0x2f,%eax
  800b36:	77 18                	ja     800b50 <vprintfmt+0x46b>
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	48 01 d6             	add    %rdx,%rsi
  800b3d:	83 c0 08             	add    $0x8,%eax
  800b40:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b43:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800b46:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b4b:	e9 77 01 00 00       	jmp    800cc7 <vprintfmt+0x5e2>
  800b50:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b54:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b58:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b5c:	eb e5                	jmp    800b43 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800b5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b61:	83 f8 2f             	cmp    $0x2f,%eax
  800b64:	77 17                	ja     800b7d <vprintfmt+0x498>
  800b66:	89 c2                	mov    %eax,%edx
  800b68:	48 01 d6             	add    %rdx,%rsi
  800b6b:	83 c0 08             	add    $0x8,%eax
  800b6e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b71:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800b73:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800b78:	e9 4a 01 00 00       	jmp    800cc7 <vprintfmt+0x5e2>
  800b7d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b81:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b85:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b89:	eb e6                	jmp    800b71 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800b8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8e:	83 f8 2f             	cmp    $0x2f,%eax
  800b91:	77 18                	ja     800bab <vprintfmt+0x4c6>
  800b93:	89 c2                	mov    %eax,%edx
  800b95:	48 01 d6             	add    %rdx,%rsi
  800b98:	83 c0 08             	add    $0x8,%eax
  800b9b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b9e:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800ba1:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800ba6:	e9 1c 01 00 00       	jmp    800cc7 <vprintfmt+0x5e2>
  800bab:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800baf:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bb3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb7:	eb e5                	jmp    800b9e <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800bb9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bbd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bc1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bc5:	e9 59 ff ff ff       	jmp    800b23 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800bca:	45 89 cd             	mov    %r9d,%r13d
  800bcd:	84 c9                	test   %cl,%cl
  800bcf:	75 2d                	jne    800bfe <vprintfmt+0x519>
    switch (lflag) {
  800bd1:	85 d2                	test   %edx,%edx
  800bd3:	74 57                	je     800c2c <vprintfmt+0x547>
  800bd5:	83 fa 01             	cmp    $0x1,%edx
  800bd8:	74 7c                	je     800c56 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800bda:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bdd:	83 f8 2f             	cmp    $0x2f,%eax
  800be0:	0f 87 9b 00 00 00    	ja     800c81 <vprintfmt+0x59c>
  800be6:	89 c2                	mov    %eax,%edx
  800be8:	48 01 d6             	add    %rdx,%rsi
  800beb:	83 c0 08             	add    $0x8,%eax
  800bee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bf1:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800bf4:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800bf9:	e9 c9 00 00 00       	jmp    800cc7 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800bfe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c01:	83 f8 2f             	cmp    $0x2f,%eax
  800c04:	77 18                	ja     800c1e <vprintfmt+0x539>
  800c06:	89 c2                	mov    %eax,%edx
  800c08:	48 01 d6             	add    %rdx,%rsi
  800c0b:	83 c0 08             	add    $0x8,%eax
  800c0e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c11:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800c14:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c19:	e9 a9 00 00 00       	jmp    800cc7 <vprintfmt+0x5e2>
  800c1e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c22:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c26:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c2a:	eb e5                	jmp    800c11 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800c2c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2f:	83 f8 2f             	cmp    $0x2f,%eax
  800c32:	77 14                	ja     800c48 <vprintfmt+0x563>
  800c34:	89 c2                	mov    %eax,%edx
  800c36:	48 01 d6             	add    %rdx,%rsi
  800c39:	83 c0 08             	add    $0x8,%eax
  800c3c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c3f:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800c41:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800c46:	eb 7f                	jmp    800cc7 <vprintfmt+0x5e2>
  800c48:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c4c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c50:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c54:	eb e9                	jmp    800c3f <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800c56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c59:	83 f8 2f             	cmp    $0x2f,%eax
  800c5c:	77 15                	ja     800c73 <vprintfmt+0x58e>
  800c5e:	89 c2                	mov    %eax,%edx
  800c60:	48 01 d6             	add    %rdx,%rsi
  800c63:	83 c0 08             	add    $0x8,%eax
  800c66:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c69:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800c6c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800c71:	eb 54                	jmp    800cc7 <vprintfmt+0x5e2>
  800c73:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c77:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c7b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c7f:	eb e8                	jmp    800c69 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800c81:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c85:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c89:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c8d:	e9 5f ff ff ff       	jmp    800bf1 <vprintfmt+0x50c>
            putch('0', put_arg);
  800c92:	45 89 cd             	mov    %r9d,%r13d
  800c95:	4c 89 f6             	mov    %r14,%rsi
  800c98:	bf 30 00 00 00       	mov    $0x30,%edi
  800c9d:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800ca0:	4c 89 f6             	mov    %r14,%rsi
  800ca3:	bf 78 00 00 00       	mov    $0x78,%edi
  800ca8:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800cab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cae:	83 f8 2f             	cmp    $0x2f,%eax
  800cb1:	77 47                	ja     800cfa <vprintfmt+0x615>
  800cb3:	89 c2                	mov    %eax,%edx
  800cb5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cb9:	83 c0 08             	add    $0x8,%eax
  800cbc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cbf:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800cc2:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800cc7:	48 83 ec 08          	sub    $0x8,%rsp
  800ccb:	41 80 fd 58          	cmp    $0x58,%r13b
  800ccf:	0f 94 c0             	sete   %al
  800cd2:	0f b6 c0             	movzbl %al,%eax
  800cd5:	50                   	push   %rax
  800cd6:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800cdb:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800cdf:	4c 89 f6             	mov    %r14,%rsi
  800ce2:	4c 89 e7             	mov    %r12,%rdi
  800ce5:	48 b8 da 05 80 00 00 	movabs $0x8005da,%rax
  800cec:	00 00 00 
  800cef:	ff d0                	call   *%rax
            break;
  800cf1:	48 83 c4 10          	add    $0x10,%rsp
  800cf5:	e9 1c fa ff ff       	jmp    800716 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800cfa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cfe:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d02:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d06:	eb b7                	jmp    800cbf <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800d08:	45 89 cd             	mov    %r9d,%r13d
  800d0b:	84 c9                	test   %cl,%cl
  800d0d:	75 2a                	jne    800d39 <vprintfmt+0x654>
    switch (lflag) {
  800d0f:	85 d2                	test   %edx,%edx
  800d11:	74 54                	je     800d67 <vprintfmt+0x682>
  800d13:	83 fa 01             	cmp    $0x1,%edx
  800d16:	74 7c                	je     800d94 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800d18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d1b:	83 f8 2f             	cmp    $0x2f,%eax
  800d1e:	0f 87 9e 00 00 00    	ja     800dc2 <vprintfmt+0x6dd>
  800d24:	89 c2                	mov    %eax,%edx
  800d26:	48 01 d6             	add    %rdx,%rsi
  800d29:	83 c0 08             	add    $0x8,%eax
  800d2c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d2f:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800d32:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800d37:	eb 8e                	jmp    800cc7 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800d39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3c:	83 f8 2f             	cmp    $0x2f,%eax
  800d3f:	77 18                	ja     800d59 <vprintfmt+0x674>
  800d41:	89 c2                	mov    %eax,%edx
  800d43:	48 01 d6             	add    %rdx,%rsi
  800d46:	83 c0 08             	add    $0x8,%eax
  800d49:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d4c:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800d4f:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800d54:	e9 6e ff ff ff       	jmp    800cc7 <vprintfmt+0x5e2>
  800d59:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d5d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d61:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d65:	eb e5                	jmp    800d4c <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800d67:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d6a:	83 f8 2f             	cmp    $0x2f,%eax
  800d6d:	77 17                	ja     800d86 <vprintfmt+0x6a1>
  800d6f:	89 c2                	mov    %eax,%edx
  800d71:	48 01 d6             	add    %rdx,%rsi
  800d74:	83 c0 08             	add    $0x8,%eax
  800d77:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d7a:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800d7c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800d81:	e9 41 ff ff ff       	jmp    800cc7 <vprintfmt+0x5e2>
  800d86:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d8a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d8e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d92:	eb e6                	jmp    800d7a <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800d94:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d97:	83 f8 2f             	cmp    $0x2f,%eax
  800d9a:	77 18                	ja     800db4 <vprintfmt+0x6cf>
  800d9c:	89 c2                	mov    %eax,%edx
  800d9e:	48 01 d6             	add    %rdx,%rsi
  800da1:	83 c0 08             	add    $0x8,%eax
  800da4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800da7:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800daa:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800daf:	e9 13 ff ff ff       	jmp    800cc7 <vprintfmt+0x5e2>
  800db4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800db8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800dbc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dc0:	eb e5                	jmp    800da7 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800dc2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800dc6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800dca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dce:	e9 5c ff ff ff       	jmp    800d2f <vprintfmt+0x64a>
            putch(ch, put_arg);
  800dd3:	4c 89 f6             	mov    %r14,%rsi
  800dd6:	bf 25 00 00 00       	mov    $0x25,%edi
  800ddb:	41 ff d4             	call   *%r12
            break;
  800dde:	e9 33 f9 ff ff       	jmp    800716 <vprintfmt+0x31>
            putch('%', put_arg);
  800de3:	4c 89 f6             	mov    %r14,%rsi
  800de6:	bf 25 00 00 00       	mov    $0x25,%edi
  800deb:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800dee:	49 83 ef 01          	sub    $0x1,%r15
  800df2:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800df7:	75 f5                	jne    800dee <vprintfmt+0x709>
  800df9:	e9 18 f9 ff ff       	jmp    800716 <vprintfmt+0x31>
}
  800dfe:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800e02:	5b                   	pop    %rbx
  800e03:	41 5c                	pop    %r12
  800e05:	41 5d                	pop    %r13
  800e07:	41 5e                	pop    %r14
  800e09:	41 5f                	pop    %r15
  800e0b:	5d                   	pop    %rbp
  800e0c:	c3                   	ret    

0000000000800e0d <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800e0d:	55                   	push   %rbp
  800e0e:	48 89 e5             	mov    %rsp,%rbp
  800e11:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800e15:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e19:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800e1e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800e22:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800e29:	48 85 ff             	test   %rdi,%rdi
  800e2c:	74 2b                	je     800e59 <vsnprintf+0x4c>
  800e2e:	48 85 f6             	test   %rsi,%rsi
  800e31:	74 26                	je     800e59 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800e33:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800e37:	48 bf 90 06 80 00 00 	movabs $0x800690,%rdi
  800e3e:	00 00 00 
  800e41:	48 b8 e5 06 80 00 00 	movabs $0x8006e5,%rax
  800e48:	00 00 00 
  800e4b:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800e4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e51:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800e54:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800e59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e5e:	eb f7                	jmp    800e57 <vsnprintf+0x4a>

0000000000800e60 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800e60:	55                   	push   %rbp
  800e61:	48 89 e5             	mov    %rsp,%rbp
  800e64:	48 83 ec 50          	sub    $0x50,%rsp
  800e68:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e6c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800e70:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800e74:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800e7b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e7f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e83:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e87:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800e8b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800e8f:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  800e96:	00 00 00 
  800e99:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800e9b:	c9                   	leave  
  800e9c:	c3                   	ret    

0000000000800e9d <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800e9d:	80 3f 00             	cmpb   $0x0,(%rdi)
  800ea0:	74 10                	je     800eb2 <strlen+0x15>
    size_t n = 0;
  800ea2:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800ea7:	48 83 c0 01          	add    $0x1,%rax
  800eab:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800eaf:	75 f6                	jne    800ea7 <strlen+0xa>
  800eb1:	c3                   	ret    
    size_t n = 0;
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800eb7:	c3                   	ret    

0000000000800eb8 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800eb8:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800ebd:	48 85 f6             	test   %rsi,%rsi
  800ec0:	74 10                	je     800ed2 <strnlen+0x1a>
  800ec2:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800ec6:	74 09                	je     800ed1 <strnlen+0x19>
  800ec8:	48 83 c0 01          	add    $0x1,%rax
  800ecc:	48 39 c6             	cmp    %rax,%rsi
  800ecf:	75 f1                	jne    800ec2 <strnlen+0xa>
    return n;
}
  800ed1:	c3                   	ret    
    size_t n = 0;
  800ed2:	48 89 f0             	mov    %rsi,%rax
  800ed5:	c3                   	ret    

0000000000800ed6 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  800edb:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800edf:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800ee2:	48 83 c0 01          	add    $0x1,%rax
  800ee6:	84 d2                	test   %dl,%dl
  800ee8:	75 f1                	jne    800edb <strcpy+0x5>
        ;
    return res;
}
  800eea:	48 89 f8             	mov    %rdi,%rax
  800eed:	c3                   	ret    

0000000000800eee <strcat>:

char *
strcat(char *dst, const char *src) {
  800eee:	55                   	push   %rbp
  800eef:	48 89 e5             	mov    %rsp,%rbp
  800ef2:	41 54                	push   %r12
  800ef4:	53                   	push   %rbx
  800ef5:	48 89 fb             	mov    %rdi,%rbx
  800ef8:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800efb:	48 b8 9d 0e 80 00 00 	movabs $0x800e9d,%rax
  800f02:	00 00 00 
  800f05:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800f07:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800f0b:	4c 89 e6             	mov    %r12,%rsi
  800f0e:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  800f15:	00 00 00 
  800f18:	ff d0                	call   *%rax
    return dst;
}
  800f1a:	48 89 d8             	mov    %rbx,%rax
  800f1d:	5b                   	pop    %rbx
  800f1e:	41 5c                	pop    %r12
  800f20:	5d                   	pop    %rbp
  800f21:	c3                   	ret    

0000000000800f22 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800f22:	48 85 d2             	test   %rdx,%rdx
  800f25:	74 1d                	je     800f44 <strncpy+0x22>
  800f27:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800f2b:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800f2e:	48 83 c0 01          	add    $0x1,%rax
  800f32:	0f b6 16             	movzbl (%rsi),%edx
  800f35:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800f38:	80 fa 01             	cmp    $0x1,%dl
  800f3b:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800f3f:	48 39 c1             	cmp    %rax,%rcx
  800f42:	75 ea                	jne    800f2e <strncpy+0xc>
    }
    return ret;
}
  800f44:	48 89 f8             	mov    %rdi,%rax
  800f47:	c3                   	ret    

0000000000800f48 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800f48:	48 89 f8             	mov    %rdi,%rax
  800f4b:	48 85 d2             	test   %rdx,%rdx
  800f4e:	74 24                	je     800f74 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800f50:	48 83 ea 01          	sub    $0x1,%rdx
  800f54:	74 1b                	je     800f71 <strlcpy+0x29>
  800f56:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800f5a:	0f b6 16             	movzbl (%rsi),%edx
  800f5d:	84 d2                	test   %dl,%dl
  800f5f:	74 10                	je     800f71 <strlcpy+0x29>
            *dst++ = *src++;
  800f61:	48 83 c6 01          	add    $0x1,%rsi
  800f65:	48 83 c0 01          	add    $0x1,%rax
  800f69:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800f6c:	48 39 c8             	cmp    %rcx,%rax
  800f6f:	75 e9                	jne    800f5a <strlcpy+0x12>
        *dst = '\0';
  800f71:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800f74:	48 29 f8             	sub    %rdi,%rax
}
  800f77:	c3                   	ret    

0000000000800f78 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800f78:	0f b6 07             	movzbl (%rdi),%eax
  800f7b:	84 c0                	test   %al,%al
  800f7d:	74 13                	je     800f92 <strcmp+0x1a>
  800f7f:	38 06                	cmp    %al,(%rsi)
  800f81:	75 0f                	jne    800f92 <strcmp+0x1a>
  800f83:	48 83 c7 01          	add    $0x1,%rdi
  800f87:	48 83 c6 01          	add    $0x1,%rsi
  800f8b:	0f b6 07             	movzbl (%rdi),%eax
  800f8e:	84 c0                	test   %al,%al
  800f90:	75 ed                	jne    800f7f <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800f92:	0f b6 c0             	movzbl %al,%eax
  800f95:	0f b6 16             	movzbl (%rsi),%edx
  800f98:	29 d0                	sub    %edx,%eax
}
  800f9a:	c3                   	ret    

0000000000800f9b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800f9b:	48 85 d2             	test   %rdx,%rdx
  800f9e:	74 1f                	je     800fbf <strncmp+0x24>
  800fa0:	0f b6 07             	movzbl (%rdi),%eax
  800fa3:	84 c0                	test   %al,%al
  800fa5:	74 1e                	je     800fc5 <strncmp+0x2a>
  800fa7:	3a 06                	cmp    (%rsi),%al
  800fa9:	75 1a                	jne    800fc5 <strncmp+0x2a>
  800fab:	48 83 c7 01          	add    $0x1,%rdi
  800faf:	48 83 c6 01          	add    $0x1,%rsi
  800fb3:	48 83 ea 01          	sub    $0x1,%rdx
  800fb7:	75 e7                	jne    800fa0 <strncmp+0x5>

    if (!n) return 0;
  800fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbe:	c3                   	ret    
  800fbf:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc4:	c3                   	ret    
  800fc5:	48 85 d2             	test   %rdx,%rdx
  800fc8:	74 09                	je     800fd3 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800fca:	0f b6 07             	movzbl (%rdi),%eax
  800fcd:	0f b6 16             	movzbl (%rsi),%edx
  800fd0:	29 d0                	sub    %edx,%eax
  800fd2:	c3                   	ret    
    if (!n) return 0;
  800fd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd8:	c3                   	ret    

0000000000800fd9 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800fd9:	0f b6 07             	movzbl (%rdi),%eax
  800fdc:	84 c0                	test   %al,%al
  800fde:	74 18                	je     800ff8 <strchr+0x1f>
        if (*str == c) {
  800fe0:	0f be c0             	movsbl %al,%eax
  800fe3:	39 f0                	cmp    %esi,%eax
  800fe5:	74 17                	je     800ffe <strchr+0x25>
    for (; *str; str++) {
  800fe7:	48 83 c7 01          	add    $0x1,%rdi
  800feb:	0f b6 07             	movzbl (%rdi),%eax
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 ee                	jne    800fe0 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff7:	c3                   	ret    
  800ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffd:	c3                   	ret    
  800ffe:	48 89 f8             	mov    %rdi,%rax
}
  801001:	c3                   	ret    

0000000000801002 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  801002:	0f b6 07             	movzbl (%rdi),%eax
  801005:	84 c0                	test   %al,%al
  801007:	74 16                	je     80101f <strfind+0x1d>
  801009:	0f be c0             	movsbl %al,%eax
  80100c:	39 f0                	cmp    %esi,%eax
  80100e:	74 13                	je     801023 <strfind+0x21>
  801010:	48 83 c7 01          	add    $0x1,%rdi
  801014:	0f b6 07             	movzbl (%rdi),%eax
  801017:	84 c0                	test   %al,%al
  801019:	75 ee                	jne    801009 <strfind+0x7>
  80101b:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  80101e:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  80101f:	48 89 f8             	mov    %rdi,%rax
  801022:	c3                   	ret    
  801023:	48 89 f8             	mov    %rdi,%rax
  801026:	c3                   	ret    

0000000000801027 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  801027:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80102a:	48 89 f8             	mov    %rdi,%rax
  80102d:	48 f7 d8             	neg    %rax
  801030:	83 e0 07             	and    $0x7,%eax
  801033:	49 89 d1             	mov    %rdx,%r9
  801036:	49 29 c1             	sub    %rax,%r9
  801039:	78 32                	js     80106d <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80103b:	40 0f b6 c6          	movzbl %sil,%eax
  80103f:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  801046:	01 01 01 
  801049:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80104d:	40 f6 c7 07          	test   $0x7,%dil
  801051:	75 34                	jne    801087 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  801053:	4c 89 c9             	mov    %r9,%rcx
  801056:	48 c1 f9 03          	sar    $0x3,%rcx
  80105a:	74 08                	je     801064 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80105c:	fc                   	cld    
  80105d:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  801060:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801064:	4d 85 c9             	test   %r9,%r9
  801067:	75 45                	jne    8010ae <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  801069:	4c 89 c0             	mov    %r8,%rax
  80106c:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  80106d:	48 85 d2             	test   %rdx,%rdx
  801070:	74 f7                	je     801069 <memset+0x42>
  801072:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801075:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  801078:	48 83 c0 01          	add    $0x1,%rax
  80107c:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  801080:	48 39 c2             	cmp    %rax,%rdx
  801083:	75 f3                	jne    801078 <memset+0x51>
  801085:	eb e2                	jmp    801069 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801087:	40 f6 c7 01          	test   $0x1,%dil
  80108b:	74 06                	je     801093 <memset+0x6c>
  80108d:	88 07                	mov    %al,(%rdi)
  80108f:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801093:	40 f6 c7 02          	test   $0x2,%dil
  801097:	74 07                	je     8010a0 <memset+0x79>
  801099:	66 89 07             	mov    %ax,(%rdi)
  80109c:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8010a0:	40 f6 c7 04          	test   $0x4,%dil
  8010a4:	74 ad                	je     801053 <memset+0x2c>
  8010a6:	89 07                	mov    %eax,(%rdi)
  8010a8:	48 83 c7 04          	add    $0x4,%rdi
  8010ac:	eb a5                	jmp    801053 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8010ae:	41 f6 c1 04          	test   $0x4,%r9b
  8010b2:	74 06                	je     8010ba <memset+0x93>
  8010b4:	89 07                	mov    %eax,(%rdi)
  8010b6:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8010ba:	41 f6 c1 02          	test   $0x2,%r9b
  8010be:	74 07                	je     8010c7 <memset+0xa0>
  8010c0:	66 89 07             	mov    %ax,(%rdi)
  8010c3:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8010c7:	41 f6 c1 01          	test   $0x1,%r9b
  8010cb:	74 9c                	je     801069 <memset+0x42>
  8010cd:	88 07                	mov    %al,(%rdi)
  8010cf:	eb 98                	jmp    801069 <memset+0x42>

00000000008010d1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8010d1:	48 89 f8             	mov    %rdi,%rax
  8010d4:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8010d7:	48 39 fe             	cmp    %rdi,%rsi
  8010da:	73 39                	jae    801115 <memmove+0x44>
  8010dc:	48 01 f2             	add    %rsi,%rdx
  8010df:	48 39 fa             	cmp    %rdi,%rdx
  8010e2:	76 31                	jbe    801115 <memmove+0x44>
        s += n;
        d += n;
  8010e4:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8010e7:	48 89 d6             	mov    %rdx,%rsi
  8010ea:	48 09 fe             	or     %rdi,%rsi
  8010ed:	48 09 ce             	or     %rcx,%rsi
  8010f0:	40 f6 c6 07          	test   $0x7,%sil
  8010f4:	75 12                	jne    801108 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8010f6:	48 83 ef 08          	sub    $0x8,%rdi
  8010fa:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8010fe:	48 c1 e9 03          	shr    $0x3,%rcx
  801102:	fd                   	std    
  801103:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801106:	fc                   	cld    
  801107:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801108:	48 83 ef 01          	sub    $0x1,%rdi
  80110c:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  801110:	fd                   	std    
  801111:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801113:	eb f1                	jmp    801106 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801115:	48 89 f2             	mov    %rsi,%rdx
  801118:	48 09 c2             	or     %rax,%rdx
  80111b:	48 09 ca             	or     %rcx,%rdx
  80111e:	f6 c2 07             	test   $0x7,%dl
  801121:	75 0c                	jne    80112f <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801123:	48 c1 e9 03          	shr    $0x3,%rcx
  801127:	48 89 c7             	mov    %rax,%rdi
  80112a:	fc                   	cld    
  80112b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80112e:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80112f:	48 89 c7             	mov    %rax,%rdi
  801132:	fc                   	cld    
  801133:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801135:	c3                   	ret    

0000000000801136 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801136:	55                   	push   %rbp
  801137:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80113a:	48 b8 d1 10 80 00 00 	movabs $0x8010d1,%rax
  801141:	00 00 00 
  801144:	ff d0                	call   *%rax
}
  801146:	5d                   	pop    %rbp
  801147:	c3                   	ret    

0000000000801148 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801148:	55                   	push   %rbp
  801149:	48 89 e5             	mov    %rsp,%rbp
  80114c:	41 57                	push   %r15
  80114e:	41 56                	push   %r14
  801150:	41 55                	push   %r13
  801152:	41 54                	push   %r12
  801154:	53                   	push   %rbx
  801155:	48 83 ec 08          	sub    $0x8,%rsp
  801159:	49 89 fe             	mov    %rdi,%r14
  80115c:	49 89 f7             	mov    %rsi,%r15
  80115f:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801162:	48 89 f7             	mov    %rsi,%rdi
  801165:	48 b8 9d 0e 80 00 00 	movabs $0x800e9d,%rax
  80116c:	00 00 00 
  80116f:	ff d0                	call   *%rax
  801171:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801174:	48 89 de             	mov    %rbx,%rsi
  801177:	4c 89 f7             	mov    %r14,%rdi
  80117a:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  801181:	00 00 00 
  801184:	ff d0                	call   *%rax
  801186:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801189:	48 39 c3             	cmp    %rax,%rbx
  80118c:	74 36                	je     8011c4 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  80118e:	48 89 d8             	mov    %rbx,%rax
  801191:	4c 29 e8             	sub    %r13,%rax
  801194:	4c 39 e0             	cmp    %r12,%rax
  801197:	76 30                	jbe    8011c9 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  801199:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  80119e:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8011a2:	4c 89 fe             	mov    %r15,%rsi
  8011a5:	48 b8 36 11 80 00 00 	movabs $0x801136,%rax
  8011ac:	00 00 00 
  8011af:	ff d0                	call   *%rax
    return dstlen + srclen;
  8011b1:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8011b5:	48 83 c4 08          	add    $0x8,%rsp
  8011b9:	5b                   	pop    %rbx
  8011ba:	41 5c                	pop    %r12
  8011bc:	41 5d                	pop    %r13
  8011be:	41 5e                	pop    %r14
  8011c0:	41 5f                	pop    %r15
  8011c2:	5d                   	pop    %rbp
  8011c3:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8011c4:	4c 01 e0             	add    %r12,%rax
  8011c7:	eb ec                	jmp    8011b5 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8011c9:	48 83 eb 01          	sub    $0x1,%rbx
  8011cd:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8011d1:	48 89 da             	mov    %rbx,%rdx
  8011d4:	4c 89 fe             	mov    %r15,%rsi
  8011d7:	48 b8 36 11 80 00 00 	movabs $0x801136,%rax
  8011de:	00 00 00 
  8011e1:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8011e3:	49 01 de             	add    %rbx,%r14
  8011e6:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8011eb:	eb c4                	jmp    8011b1 <strlcat+0x69>

00000000008011ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8011ed:	49 89 f0             	mov    %rsi,%r8
  8011f0:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8011f3:	48 85 d2             	test   %rdx,%rdx
  8011f6:	74 2a                	je     801222 <memcmp+0x35>
  8011f8:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8011fd:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801201:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  801206:	38 ca                	cmp    %cl,%dl
  801208:	75 0f                	jne    801219 <memcmp+0x2c>
    while (n-- > 0) {
  80120a:	48 83 c0 01          	add    $0x1,%rax
  80120e:	48 39 c6             	cmp    %rax,%rsi
  801211:	75 ea                	jne    8011fd <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801213:	b8 00 00 00 00       	mov    $0x0,%eax
  801218:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  801219:	0f b6 c2             	movzbl %dl,%eax
  80121c:	0f b6 c9             	movzbl %cl,%ecx
  80121f:	29 c8                	sub    %ecx,%eax
  801221:	c3                   	ret    
    return 0;
  801222:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801227:	c3                   	ret    

0000000000801228 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  801228:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80122c:	48 39 c7             	cmp    %rax,%rdi
  80122f:	73 0f                	jae    801240 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801231:	40 38 37             	cmp    %sil,(%rdi)
  801234:	74 0e                	je     801244 <memfind+0x1c>
    for (; src < end; src++) {
  801236:	48 83 c7 01          	add    $0x1,%rdi
  80123a:	48 39 f8             	cmp    %rdi,%rax
  80123d:	75 f2                	jne    801231 <memfind+0x9>
  80123f:	c3                   	ret    
  801240:	48 89 f8             	mov    %rdi,%rax
  801243:	c3                   	ret    
  801244:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801247:	c3                   	ret    

0000000000801248 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801248:	49 89 f2             	mov    %rsi,%r10
  80124b:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80124e:	0f b6 37             	movzbl (%rdi),%esi
  801251:	40 80 fe 20          	cmp    $0x20,%sil
  801255:	74 06                	je     80125d <strtol+0x15>
  801257:	40 80 fe 09          	cmp    $0x9,%sil
  80125b:	75 13                	jne    801270 <strtol+0x28>
  80125d:	48 83 c7 01          	add    $0x1,%rdi
  801261:	0f b6 37             	movzbl (%rdi),%esi
  801264:	40 80 fe 20          	cmp    $0x20,%sil
  801268:	74 f3                	je     80125d <strtol+0x15>
  80126a:	40 80 fe 09          	cmp    $0x9,%sil
  80126e:	74 ed                	je     80125d <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801270:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801273:	83 e0 fd             	and    $0xfffffffd,%eax
  801276:	3c 01                	cmp    $0x1,%al
  801278:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80127c:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801283:	75 11                	jne    801296 <strtol+0x4e>
  801285:	80 3f 30             	cmpb   $0x30,(%rdi)
  801288:	74 16                	je     8012a0 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80128a:	45 85 c0             	test   %r8d,%r8d
  80128d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801292:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  801296:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80129b:	4d 63 c8             	movslq %r8d,%r9
  80129e:	eb 38                	jmp    8012d8 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8012a0:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8012a4:	74 11                	je     8012b7 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8012a6:	45 85 c0             	test   %r8d,%r8d
  8012a9:	75 eb                	jne    801296 <strtol+0x4e>
        s++;
  8012ab:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8012af:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8012b5:	eb df                	jmp    801296 <strtol+0x4e>
        s += 2;
  8012b7:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8012bb:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8012c1:	eb d3                	jmp    801296 <strtol+0x4e>
            dig -= '0';
  8012c3:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8012c6:	0f b6 c8             	movzbl %al,%ecx
  8012c9:	44 39 c1             	cmp    %r8d,%ecx
  8012cc:	7d 1f                	jge    8012ed <strtol+0xa5>
        val = val * base + dig;
  8012ce:	49 0f af d1          	imul   %r9,%rdx
  8012d2:	0f b6 c0             	movzbl %al,%eax
  8012d5:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8012d8:	48 83 c7 01          	add    $0x1,%rdi
  8012dc:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8012e0:	3c 39                	cmp    $0x39,%al
  8012e2:	76 df                	jbe    8012c3 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8012e4:	3c 7b                	cmp    $0x7b,%al
  8012e6:	77 05                	ja     8012ed <strtol+0xa5>
            dig -= 'a' - 10;
  8012e8:	83 e8 57             	sub    $0x57,%eax
  8012eb:	eb d9                	jmp    8012c6 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8012ed:	4d 85 d2             	test   %r10,%r10
  8012f0:	74 03                	je     8012f5 <strtol+0xad>
  8012f2:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8012f5:	48 89 d0             	mov    %rdx,%rax
  8012f8:	48 f7 d8             	neg    %rax
  8012fb:	40 80 fe 2d          	cmp    $0x2d,%sil
  8012ff:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801303:	48 89 d0             	mov    %rdx,%rax
  801306:	c3                   	ret    

0000000000801307 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801307:	55                   	push   %rbp
  801308:	48 89 e5             	mov    %rsp,%rbp
  80130b:	53                   	push   %rbx
  80130c:	48 89 fa             	mov    %rdi,%rdx
  80130f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801312:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801317:	bb 00 00 00 00       	mov    $0x0,%ebx
  80131c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801321:	be 00 00 00 00       	mov    $0x0,%esi
  801326:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80132c:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80132e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801332:	c9                   	leave  
  801333:	c3                   	ret    

0000000000801334 <sys_cgetc>:

int
sys_cgetc(void) {
  801334:	55                   	push   %rbp
  801335:	48 89 e5             	mov    %rsp,%rbp
  801338:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801339:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80133e:	ba 00 00 00 00       	mov    $0x0,%edx
  801343:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801348:	bb 00 00 00 00       	mov    $0x0,%ebx
  80134d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801352:	be 00 00 00 00       	mov    $0x0,%esi
  801357:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80135d:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80135f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801363:	c9                   	leave  
  801364:	c3                   	ret    

0000000000801365 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801365:	55                   	push   %rbp
  801366:	48 89 e5             	mov    %rsp,%rbp
  801369:	53                   	push   %rbx
  80136a:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80136e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801371:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801376:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80137b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801380:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801385:	be 00 00 00 00       	mov    $0x0,%esi
  80138a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801390:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801392:	48 85 c0             	test   %rax,%rax
  801395:	7f 06                	jg     80139d <sys_env_destroy+0x38>
}
  801397:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80139d:	49 89 c0             	mov    %rax,%r8
  8013a0:	b9 03 00 00 00       	mov    $0x3,%ecx
  8013a5:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  8013ac:	00 00 00 
  8013af:	be 26 00 00 00       	mov    $0x26,%esi
  8013b4:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  8013bb:	00 00 00 
  8013be:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c3:	49 b9 45 04 80 00 00 	movabs $0x800445,%r9
  8013ca:	00 00 00 
  8013cd:	41 ff d1             	call   *%r9

00000000008013d0 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8013d0:	55                   	push   %rbp
  8013d1:	48 89 e5             	mov    %rsp,%rbp
  8013d4:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013d5:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013da:	ba 00 00 00 00       	mov    $0x0,%edx
  8013df:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013ee:	be 00 00 00 00       	mov    $0x0,%esi
  8013f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013f9:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8013fb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

0000000000801401 <sys_yield>:

void
sys_yield(void) {
  801401:	55                   	push   %rbp
  801402:	48 89 e5             	mov    %rsp,%rbp
  801405:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801406:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80140b:	ba 00 00 00 00       	mov    $0x0,%edx
  801410:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801415:	bb 00 00 00 00       	mov    $0x0,%ebx
  80141a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80141f:	be 00 00 00 00       	mov    $0x0,%esi
  801424:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80142a:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80142c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801430:	c9                   	leave  
  801431:	c3                   	ret    

0000000000801432 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801432:	55                   	push   %rbp
  801433:	48 89 e5             	mov    %rsp,%rbp
  801436:	53                   	push   %rbx
  801437:	48 89 fa             	mov    %rdi,%rdx
  80143a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80143d:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801442:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801449:	00 00 00 
  80144c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801451:	be 00 00 00 00       	mov    $0x0,%esi
  801456:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80145c:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80145e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801462:	c9                   	leave  
  801463:	c3                   	ret    

0000000000801464 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801464:	55                   	push   %rbp
  801465:	48 89 e5             	mov    %rsp,%rbp
  801468:	53                   	push   %rbx
  801469:	49 89 f8             	mov    %rdi,%r8
  80146c:	48 89 d3             	mov    %rdx,%rbx
  80146f:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801472:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801477:	4c 89 c2             	mov    %r8,%rdx
  80147a:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80147d:	be 00 00 00 00       	mov    $0x0,%esi
  801482:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801488:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80148a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

0000000000801490 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801490:	55                   	push   %rbp
  801491:	48 89 e5             	mov    %rsp,%rbp
  801494:	53                   	push   %rbx
  801495:	48 83 ec 08          	sub    $0x8,%rsp
  801499:	89 f8                	mov    %edi,%eax
  80149b:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80149e:	48 63 f9             	movslq %ecx,%rdi
  8014a1:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014a4:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014a9:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014ac:	be 00 00 00 00       	mov    $0x0,%esi
  8014b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014b7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014b9:	48 85 c0             	test   %rax,%rax
  8014bc:	7f 06                	jg     8014c4 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8014be:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014c4:	49 89 c0             	mov    %rax,%r8
  8014c7:	b9 04 00 00 00       	mov    $0x4,%ecx
  8014cc:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  8014d3:	00 00 00 
  8014d6:	be 26 00 00 00       	mov    $0x26,%esi
  8014db:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  8014e2:	00 00 00 
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ea:	49 b9 45 04 80 00 00 	movabs $0x800445,%r9
  8014f1:	00 00 00 
  8014f4:	41 ff d1             	call   *%r9

00000000008014f7 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8014f7:	55                   	push   %rbp
  8014f8:	48 89 e5             	mov    %rsp,%rbp
  8014fb:	53                   	push   %rbx
  8014fc:	48 83 ec 08          	sub    $0x8,%rsp
  801500:	89 f8                	mov    %edi,%eax
  801502:	49 89 f2             	mov    %rsi,%r10
  801505:	48 89 cf             	mov    %rcx,%rdi
  801508:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80150b:	48 63 da             	movslq %edx,%rbx
  80150e:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801511:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801516:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801519:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80151c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80151e:	48 85 c0             	test   %rax,%rax
  801521:	7f 06                	jg     801529 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801523:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801527:	c9                   	leave  
  801528:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801529:	49 89 c0             	mov    %rax,%r8
  80152c:	b9 05 00 00 00       	mov    $0x5,%ecx
  801531:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  801538:	00 00 00 
  80153b:	be 26 00 00 00       	mov    $0x26,%esi
  801540:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  801547:	00 00 00 
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
  80154f:	49 b9 45 04 80 00 00 	movabs $0x800445,%r9
  801556:	00 00 00 
  801559:	41 ff d1             	call   *%r9

000000000080155c <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80155c:	55                   	push   %rbp
  80155d:	48 89 e5             	mov    %rsp,%rbp
  801560:	53                   	push   %rbx
  801561:	48 83 ec 08          	sub    $0x8,%rsp
  801565:	48 89 f1             	mov    %rsi,%rcx
  801568:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80156b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80156e:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801573:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801578:	be 00 00 00 00       	mov    $0x0,%esi
  80157d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801583:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801585:	48 85 c0             	test   %rax,%rax
  801588:	7f 06                	jg     801590 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80158a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801590:	49 89 c0             	mov    %rax,%r8
  801593:	b9 06 00 00 00       	mov    $0x6,%ecx
  801598:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  80159f:	00 00 00 
  8015a2:	be 26 00 00 00       	mov    $0x26,%esi
  8015a7:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  8015ae:	00 00 00 
  8015b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b6:	49 b9 45 04 80 00 00 	movabs $0x800445,%r9
  8015bd:	00 00 00 
  8015c0:	41 ff d1             	call   *%r9

00000000008015c3 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8015c3:	55                   	push   %rbp
  8015c4:	48 89 e5             	mov    %rsp,%rbp
  8015c7:	53                   	push   %rbx
  8015c8:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8015cc:	48 63 ce             	movslq %esi,%rcx
  8015cf:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015d2:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015dc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015e1:	be 00 00 00 00       	mov    $0x0,%esi
  8015e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015ec:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015ee:	48 85 c0             	test   %rax,%rax
  8015f1:	7f 06                	jg     8015f9 <sys_env_set_status+0x36>
}
  8015f3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015f9:	49 89 c0             	mov    %rax,%r8
  8015fc:	b9 09 00 00 00       	mov    $0x9,%ecx
  801601:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  801608:	00 00 00 
  80160b:	be 26 00 00 00       	mov    $0x26,%esi
  801610:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  801617:	00 00 00 
  80161a:	b8 00 00 00 00       	mov    $0x0,%eax
  80161f:	49 b9 45 04 80 00 00 	movabs $0x800445,%r9
  801626:	00 00 00 
  801629:	41 ff d1             	call   *%r9

000000000080162c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80162c:	55                   	push   %rbp
  80162d:	48 89 e5             	mov    %rsp,%rbp
  801630:	53                   	push   %rbx
  801631:	48 83 ec 08          	sub    $0x8,%rsp
  801635:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801638:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80163b:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801640:	bb 00 00 00 00       	mov    $0x0,%ebx
  801645:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80164a:	be 00 00 00 00       	mov    $0x0,%esi
  80164f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801655:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801657:	48 85 c0             	test   %rax,%rax
  80165a:	7f 06                	jg     801662 <sys_env_set_trapframe+0x36>
}
  80165c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801660:	c9                   	leave  
  801661:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801662:	49 89 c0             	mov    %rax,%r8
  801665:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80166a:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  801671:	00 00 00 
  801674:	be 26 00 00 00       	mov    $0x26,%esi
  801679:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  801680:	00 00 00 
  801683:	b8 00 00 00 00       	mov    $0x0,%eax
  801688:	49 b9 45 04 80 00 00 	movabs $0x800445,%r9
  80168f:	00 00 00 
  801692:	41 ff d1             	call   *%r9

0000000000801695 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801695:	55                   	push   %rbp
  801696:	48 89 e5             	mov    %rsp,%rbp
  801699:	53                   	push   %rbx
  80169a:	48 83 ec 08          	sub    $0x8,%rsp
  80169e:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8016a1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016a4:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016ae:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016b3:	be 00 00 00 00       	mov    $0x0,%esi
  8016b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016be:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016c0:	48 85 c0             	test   %rax,%rax
  8016c3:	7f 06                	jg     8016cb <sys_env_set_pgfault_upcall+0x36>
}
  8016c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016cb:	49 89 c0             	mov    %rax,%r8
  8016ce:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8016d3:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  8016da:	00 00 00 
  8016dd:	be 26 00 00 00       	mov    $0x26,%esi
  8016e2:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  8016e9:	00 00 00 
  8016ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f1:	49 b9 45 04 80 00 00 	movabs $0x800445,%r9
  8016f8:	00 00 00 
  8016fb:	41 ff d1             	call   *%r9

00000000008016fe <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8016fe:	55                   	push   %rbp
  8016ff:	48 89 e5             	mov    %rsp,%rbp
  801702:	53                   	push   %rbx
  801703:	89 f8                	mov    %edi,%eax
  801705:	49 89 f1             	mov    %rsi,%r9
  801708:	48 89 d3             	mov    %rdx,%rbx
  80170b:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80170e:	49 63 f0             	movslq %r8d,%rsi
  801711:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801714:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801719:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80171c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801722:	cd 30                	int    $0x30
}
  801724:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801728:	c9                   	leave  
  801729:	c3                   	ret    

000000000080172a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80172a:	55                   	push   %rbp
  80172b:	48 89 e5             	mov    %rsp,%rbp
  80172e:	53                   	push   %rbx
  80172f:	48 83 ec 08          	sub    $0x8,%rsp
  801733:	48 89 fa             	mov    %rdi,%rdx
  801736:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801739:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80173e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801743:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801748:	be 00 00 00 00       	mov    $0x0,%esi
  80174d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801753:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801755:	48 85 c0             	test   %rax,%rax
  801758:	7f 06                	jg     801760 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80175a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801760:	49 89 c0             	mov    %rax,%r8
  801763:	b9 0e 00 00 00       	mov    $0xe,%ecx
  801768:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  80176f:	00 00 00 
  801772:	be 26 00 00 00       	mov    $0x26,%esi
  801777:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  80177e:	00 00 00 
  801781:	b8 00 00 00 00       	mov    $0x0,%eax
  801786:	49 b9 45 04 80 00 00 	movabs $0x800445,%r9
  80178d:	00 00 00 
  801790:	41 ff d1             	call   *%r9

0000000000801793 <sys_gettime>:

int
sys_gettime(void) {
  801793:	55                   	push   %rbp
  801794:	48 89 e5             	mov    %rsp,%rbp
  801797:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801798:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80179d:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017ac:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017b1:	be 00 00 00 00       	mov    $0x0,%esi
  8017b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017bc:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8017be:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

00000000008017c4 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8017c4:	55                   	push   %rbp
  8017c5:	48 89 e5             	mov    %rsp,%rbp
  8017c8:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8017c9:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8017ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017dd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017e2:	be 00 00 00 00       	mov    $0x0,%esi
  8017e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017ed:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8017ef:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

00000000008017f5 <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8017f5:	55                   	push   %rbp
  8017f6:	48 89 e5             	mov    %rsp,%rbp
  8017f9:	53                   	push   %rbx
  8017fa:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8017fe:	b8 08 00 00 00       	mov    $0x8,%eax
  801803:	cd 30                	int    $0x30
  801805:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  801807:	85 c0                	test   %eax,%eax
  801809:	0f 88 85 00 00 00    	js     801894 <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  80180f:	0f 84 ac 00 00 00    	je     8018c1 <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  801815:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  80181b:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801822:	00 00 00 
  801825:	b9 00 00 00 00       	mov    $0x0,%ecx
  80182a:	89 c2                	mov    %eax,%edx
  80182c:	be 00 00 00 00       	mov    $0x0,%esi
  801831:	bf 00 00 00 00       	mov    $0x0,%edi
  801836:	48 b8 f7 14 80 00 00 	movabs $0x8014f7,%rax
  80183d:	00 00 00 
  801840:	ff d0                	call   *%rax
    if (res < 0)
  801842:	85 c0                	test   %eax,%eax
  801844:	0f 88 ad 00 00 00    	js     8018f7 <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  80184a:	be 02 00 00 00       	mov    $0x2,%esi
  80184f:	89 df                	mov    %ebx,%edi
  801851:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  801858:	00 00 00 
  80185b:	ff d0                	call   *%rax
    if (res < 0)
  80185d:	85 c0                	test   %eax,%eax
  80185f:	0f 88 bf 00 00 00    	js     801924 <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  801865:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80186c:	00 00 00 
  80186f:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  801876:	89 df                	mov    %ebx,%edi
  801878:	48 b8 95 16 80 00 00 	movabs $0x801695,%rax
  80187f:	00 00 00 
  801882:	ff d0                	call   *%rax
    if (res < 0)
  801884:	85 c0                	test   %eax,%eax
  801886:	0f 88 c5 00 00 00    	js     801951 <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  80188c:	89 d8                	mov    %ebx,%eax
  80188e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801892:	c9                   	leave  
  801893:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  801894:	89 c1                	mov    %eax,%ecx
  801896:	48 ba 2d 35 80 00 00 	movabs $0x80352d,%rdx
  80189d:	00 00 00 
  8018a0:	be 1a 00 00 00       	mov    $0x1a,%esi
  8018a5:	48 bf 3d 35 80 00 00 	movabs $0x80353d,%rdi
  8018ac:	00 00 00 
  8018af:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b4:	49 b8 45 04 80 00 00 	movabs $0x800445,%r8
  8018bb:	00 00 00 
  8018be:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  8018c1:	48 b8 d0 13 80 00 00 	movabs $0x8013d0,%rax
  8018c8:	00 00 00 
  8018cb:	ff d0                	call   *%rax
  8018cd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8018d2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8018d6:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8018da:	48 c1 e0 04          	shl    $0x4,%rax
  8018de:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8018e5:	00 00 00 
  8018e8:	48 01 d0             	add    %rdx,%rax
  8018eb:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8018f2:	00 00 00 
        return 0;
  8018f5:	eb 95                	jmp    80188c <fork+0x97>
        panic("sys_map_region: %i", res);
  8018f7:	89 c1                	mov    %eax,%ecx
  8018f9:	48 ba 48 35 80 00 00 	movabs $0x803548,%rdx
  801900:	00 00 00 
  801903:	be 22 00 00 00       	mov    $0x22,%esi
  801908:	48 bf 3d 35 80 00 00 	movabs $0x80353d,%rdi
  80190f:	00 00 00 
  801912:	b8 00 00 00 00       	mov    $0x0,%eax
  801917:	49 b8 45 04 80 00 00 	movabs $0x800445,%r8
  80191e:	00 00 00 
  801921:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  801924:	89 c1                	mov    %eax,%ecx
  801926:	48 ba 5b 35 80 00 00 	movabs $0x80355b,%rdx
  80192d:	00 00 00 
  801930:	be 25 00 00 00       	mov    $0x25,%esi
  801935:	48 bf 3d 35 80 00 00 	movabs $0x80353d,%rdi
  80193c:	00 00 00 
  80193f:	b8 00 00 00 00       	mov    $0x0,%eax
  801944:	49 b8 45 04 80 00 00 	movabs $0x800445,%r8
  80194b:	00 00 00 
  80194e:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  801951:	89 c1                	mov    %eax,%ecx
  801953:	48 ba 90 35 80 00 00 	movabs $0x803590,%rdx
  80195a:	00 00 00 
  80195d:	be 28 00 00 00       	mov    $0x28,%esi
  801962:	48 bf 3d 35 80 00 00 	movabs $0x80353d,%rdi
  801969:	00 00 00 
  80196c:	b8 00 00 00 00       	mov    $0x0,%eax
  801971:	49 b8 45 04 80 00 00 	movabs $0x800445,%r8
  801978:	00 00 00 
  80197b:	41 ff d0             	call   *%r8

000000000080197e <sfork>:

envid_t
sfork() {
  80197e:	55                   	push   %rbp
  80197f:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801982:	48 ba 72 35 80 00 00 	movabs $0x803572,%rdx
  801989:	00 00 00 
  80198c:	be 2f 00 00 00       	mov    $0x2f,%esi
  801991:	48 bf 3d 35 80 00 00 	movabs $0x80353d,%rdi
  801998:	00 00 00 
  80199b:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a0:	48 b9 45 04 80 00 00 	movabs $0x800445,%rcx
  8019a7:	00 00 00 
  8019aa:	ff d1                	call   *%rcx

00000000008019ac <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8019ac:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019b3:	ff ff ff 
  8019b6:	48 01 f8             	add    %rdi,%rax
  8019b9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8019bd:	c3                   	ret    

00000000008019be <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8019be:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019c5:	ff ff ff 
  8019c8:	48 01 f8             	add    %rdi,%rax
  8019cb:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8019cf:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8019d5:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8019d9:	c3                   	ret    

00000000008019da <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8019da:	55                   	push   %rbp
  8019db:	48 89 e5             	mov    %rsp,%rbp
  8019de:	41 57                	push   %r15
  8019e0:	41 56                	push   %r14
  8019e2:	41 55                	push   %r13
  8019e4:	41 54                	push   %r12
  8019e6:	53                   	push   %rbx
  8019e7:	48 83 ec 08          	sub    $0x8,%rsp
  8019eb:	49 89 ff             	mov    %rdi,%r15
  8019ee:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8019f3:	49 bc 88 29 80 00 00 	movabs $0x802988,%r12
  8019fa:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8019fd:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801a03:	48 89 df             	mov    %rbx,%rdi
  801a06:	41 ff d4             	call   *%r12
  801a09:	83 e0 04             	and    $0x4,%eax
  801a0c:	74 1a                	je     801a28 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  801a0e:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801a15:	4c 39 f3             	cmp    %r14,%rbx
  801a18:	75 e9                	jne    801a03 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801a1a:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801a21:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801a26:	eb 03                	jmp    801a2b <fd_alloc+0x51>
            *fd_store = fd;
  801a28:	49 89 1f             	mov    %rbx,(%r15)
}
  801a2b:	48 83 c4 08          	add    $0x8,%rsp
  801a2f:	5b                   	pop    %rbx
  801a30:	41 5c                	pop    %r12
  801a32:	41 5d                	pop    %r13
  801a34:	41 5e                	pop    %r14
  801a36:	41 5f                	pop    %r15
  801a38:	5d                   	pop    %rbp
  801a39:	c3                   	ret    

0000000000801a3a <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801a3a:	83 ff 1f             	cmp    $0x1f,%edi
  801a3d:	77 39                	ja     801a78 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a3f:	55                   	push   %rbp
  801a40:	48 89 e5             	mov    %rsp,%rbp
  801a43:	41 54                	push   %r12
  801a45:	53                   	push   %rbx
  801a46:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801a49:	48 63 df             	movslq %edi,%rbx
  801a4c:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801a53:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801a57:	48 89 df             	mov    %rbx,%rdi
  801a5a:	48 b8 88 29 80 00 00 	movabs $0x802988,%rax
  801a61:	00 00 00 
  801a64:	ff d0                	call   *%rax
  801a66:	a8 04                	test   $0x4,%al
  801a68:	74 14                	je     801a7e <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801a6a:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801a6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a73:	5b                   	pop    %rbx
  801a74:	41 5c                	pop    %r12
  801a76:	5d                   	pop    %rbp
  801a77:	c3                   	ret    
        return -E_INVAL;
  801a78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a7d:	c3                   	ret    
        return -E_INVAL;
  801a7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a83:	eb ee                	jmp    801a73 <fd_lookup+0x39>

0000000000801a85 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801a85:	55                   	push   %rbp
  801a86:	48 89 e5             	mov    %rsp,%rbp
  801a89:	53                   	push   %rbx
  801a8a:	48 83 ec 08          	sub    $0x8,%rsp
  801a8e:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801a91:	48 ba 40 36 80 00 00 	movabs $0x803640,%rdx
  801a98:	00 00 00 
  801a9b:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801aa2:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801aa5:	39 38                	cmp    %edi,(%rax)
  801aa7:	74 4b                	je     801af4 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801aa9:	48 83 c2 08          	add    $0x8,%rdx
  801aad:	48 8b 02             	mov    (%rdx),%rax
  801ab0:	48 85 c0             	test   %rax,%rax
  801ab3:	75 f0                	jne    801aa5 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ab5:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801abc:	00 00 00 
  801abf:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ac5:	89 fa                	mov    %edi,%edx
  801ac7:	48 bf b0 35 80 00 00 	movabs $0x8035b0,%rdi
  801ace:	00 00 00 
  801ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad6:	48 b9 95 05 80 00 00 	movabs $0x800595,%rcx
  801add:	00 00 00 
  801ae0:	ff d1                	call   *%rcx
    *dev = 0;
  801ae2:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801ae9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801aee:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    
            *dev = devtab[i];
  801af4:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801af7:	b8 00 00 00 00       	mov    $0x0,%eax
  801afc:	eb f0                	jmp    801aee <dev_lookup+0x69>

0000000000801afe <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801afe:	55                   	push   %rbp
  801aff:	48 89 e5             	mov    %rsp,%rbp
  801b02:	41 55                	push   %r13
  801b04:	41 54                	push   %r12
  801b06:	53                   	push   %rbx
  801b07:	48 83 ec 18          	sub    $0x18,%rsp
  801b0b:	49 89 fc             	mov    %rdi,%r12
  801b0e:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b11:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801b18:	ff ff ff 
  801b1b:	4c 01 e7             	add    %r12,%rdi
  801b1e:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801b22:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b26:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  801b2d:	00 00 00 
  801b30:	ff d0                	call   *%rax
  801b32:	89 c3                	mov    %eax,%ebx
  801b34:	85 c0                	test   %eax,%eax
  801b36:	78 06                	js     801b3e <fd_close+0x40>
  801b38:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801b3c:	74 18                	je     801b56 <fd_close+0x58>
        return (must_exist ? res : 0);
  801b3e:	45 84 ed             	test   %r13b,%r13b
  801b41:	b8 00 00 00 00       	mov    $0x0,%eax
  801b46:	0f 44 d8             	cmove  %eax,%ebx
}
  801b49:	89 d8                	mov    %ebx,%eax
  801b4b:	48 83 c4 18          	add    $0x18,%rsp
  801b4f:	5b                   	pop    %rbx
  801b50:	41 5c                	pop    %r12
  801b52:	41 5d                	pop    %r13
  801b54:	5d                   	pop    %rbp
  801b55:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b56:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b5a:	41 8b 3c 24          	mov    (%r12),%edi
  801b5e:	48 b8 85 1a 80 00 00 	movabs $0x801a85,%rax
  801b65:	00 00 00 
  801b68:	ff d0                	call   *%rax
  801b6a:	89 c3                	mov    %eax,%ebx
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	78 19                	js     801b89 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801b70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b74:	48 8b 40 20          	mov    0x20(%rax),%rax
  801b78:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b7d:	48 85 c0             	test   %rax,%rax
  801b80:	74 07                	je     801b89 <fd_close+0x8b>
  801b82:	4c 89 e7             	mov    %r12,%rdi
  801b85:	ff d0                	call   *%rax
  801b87:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801b89:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b8e:	4c 89 e6             	mov    %r12,%rsi
  801b91:	bf 00 00 00 00       	mov    $0x0,%edi
  801b96:	48 b8 5c 15 80 00 00 	movabs $0x80155c,%rax
  801b9d:	00 00 00 
  801ba0:	ff d0                	call   *%rax
    return res;
  801ba2:	eb a5                	jmp    801b49 <fd_close+0x4b>

0000000000801ba4 <close>:

int
close(int fdnum) {
  801ba4:	55                   	push   %rbp
  801ba5:	48 89 e5             	mov    %rsp,%rbp
  801ba8:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801bac:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801bb0:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  801bb7:	00 00 00 
  801bba:	ff d0                	call   *%rax
    if (res < 0) return res;
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	78 15                	js     801bd5 <close+0x31>

    return fd_close(fd, 1);
  801bc0:	be 01 00 00 00       	mov    $0x1,%esi
  801bc5:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bc9:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  801bd0:	00 00 00 
  801bd3:	ff d0                	call   *%rax
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

0000000000801bd7 <close_all>:

void
close_all(void) {
  801bd7:	55                   	push   %rbp
  801bd8:	48 89 e5             	mov    %rsp,%rbp
  801bdb:	41 54                	push   %r12
  801bdd:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801bde:	bb 00 00 00 00       	mov    $0x0,%ebx
  801be3:	49 bc a4 1b 80 00 00 	movabs $0x801ba4,%r12
  801bea:	00 00 00 
  801bed:	89 df                	mov    %ebx,%edi
  801bef:	41 ff d4             	call   *%r12
  801bf2:	83 c3 01             	add    $0x1,%ebx
  801bf5:	83 fb 20             	cmp    $0x20,%ebx
  801bf8:	75 f3                	jne    801bed <close_all+0x16>
}
  801bfa:	5b                   	pop    %rbx
  801bfb:	41 5c                	pop    %r12
  801bfd:	5d                   	pop    %rbp
  801bfe:	c3                   	ret    

0000000000801bff <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801bff:	55                   	push   %rbp
  801c00:	48 89 e5             	mov    %rsp,%rbp
  801c03:	41 56                	push   %r14
  801c05:	41 55                	push   %r13
  801c07:	41 54                	push   %r12
  801c09:	53                   	push   %rbx
  801c0a:	48 83 ec 10          	sub    $0x10,%rsp
  801c0e:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801c11:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c15:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  801c1c:	00 00 00 
  801c1f:	ff d0                	call   *%rax
  801c21:	89 c3                	mov    %eax,%ebx
  801c23:	85 c0                	test   %eax,%eax
  801c25:	0f 88 b7 00 00 00    	js     801ce2 <dup+0xe3>
    close(newfdnum);
  801c2b:	44 89 e7             	mov    %r12d,%edi
  801c2e:	48 b8 a4 1b 80 00 00 	movabs $0x801ba4,%rax
  801c35:	00 00 00 
  801c38:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801c3a:	4d 63 ec             	movslq %r12d,%r13
  801c3d:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801c44:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801c48:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c4c:	49 be be 19 80 00 00 	movabs $0x8019be,%r14
  801c53:	00 00 00 
  801c56:	41 ff d6             	call   *%r14
  801c59:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801c5c:	4c 89 ef             	mov    %r13,%rdi
  801c5f:	41 ff d6             	call   *%r14
  801c62:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801c65:	48 89 df             	mov    %rbx,%rdi
  801c68:	48 b8 88 29 80 00 00 	movabs $0x802988,%rax
  801c6f:	00 00 00 
  801c72:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801c74:	a8 04                	test   $0x4,%al
  801c76:	74 2b                	je     801ca3 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801c78:	41 89 c1             	mov    %eax,%r9d
  801c7b:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c81:	4c 89 f1             	mov    %r14,%rcx
  801c84:	ba 00 00 00 00       	mov    $0x0,%edx
  801c89:	48 89 de             	mov    %rbx,%rsi
  801c8c:	bf 00 00 00 00       	mov    $0x0,%edi
  801c91:	48 b8 f7 14 80 00 00 	movabs $0x8014f7,%rax
  801c98:	00 00 00 
  801c9b:	ff d0                	call   *%rax
  801c9d:	89 c3                	mov    %eax,%ebx
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	78 4e                	js     801cf1 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801ca3:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801ca7:	48 b8 88 29 80 00 00 	movabs $0x802988,%rax
  801cae:	00 00 00 
  801cb1:	ff d0                	call   *%rax
  801cb3:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801cb6:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801cbc:	4c 89 e9             	mov    %r13,%rcx
  801cbf:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc4:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801cc8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ccd:	48 b8 f7 14 80 00 00 	movabs $0x8014f7,%rax
  801cd4:	00 00 00 
  801cd7:	ff d0                	call   *%rax
  801cd9:	89 c3                	mov    %eax,%ebx
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	78 12                	js     801cf1 <dup+0xf2>

    return newfdnum;
  801cdf:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801ce2:	89 d8                	mov    %ebx,%eax
  801ce4:	48 83 c4 10          	add    $0x10,%rsp
  801ce8:	5b                   	pop    %rbx
  801ce9:	41 5c                	pop    %r12
  801ceb:	41 5d                	pop    %r13
  801ced:	41 5e                	pop    %r14
  801cef:	5d                   	pop    %rbp
  801cf0:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801cf1:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cf6:	4c 89 ee             	mov    %r13,%rsi
  801cf9:	bf 00 00 00 00       	mov    $0x0,%edi
  801cfe:	49 bc 5c 15 80 00 00 	movabs $0x80155c,%r12
  801d05:	00 00 00 
  801d08:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801d0b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d10:	4c 89 f6             	mov    %r14,%rsi
  801d13:	bf 00 00 00 00       	mov    $0x0,%edi
  801d18:	41 ff d4             	call   *%r12
    return res;
  801d1b:	eb c5                	jmp    801ce2 <dup+0xe3>

0000000000801d1d <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801d1d:	55                   	push   %rbp
  801d1e:	48 89 e5             	mov    %rsp,%rbp
  801d21:	41 55                	push   %r13
  801d23:	41 54                	push   %r12
  801d25:	53                   	push   %rbx
  801d26:	48 83 ec 18          	sub    $0x18,%rsp
  801d2a:	89 fb                	mov    %edi,%ebx
  801d2c:	49 89 f4             	mov    %rsi,%r12
  801d2f:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d32:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d36:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  801d3d:	00 00 00 
  801d40:	ff d0                	call   *%rax
  801d42:	85 c0                	test   %eax,%eax
  801d44:	78 49                	js     801d8f <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d46:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d4e:	8b 38                	mov    (%rax),%edi
  801d50:	48 b8 85 1a 80 00 00 	movabs $0x801a85,%rax
  801d57:	00 00 00 
  801d5a:	ff d0                	call   *%rax
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	78 33                	js     801d93 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d60:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801d64:	8b 47 08             	mov    0x8(%rdi),%eax
  801d67:	83 e0 03             	and    $0x3,%eax
  801d6a:	83 f8 01             	cmp    $0x1,%eax
  801d6d:	74 28                	je     801d97 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801d6f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d73:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d77:	48 85 c0             	test   %rax,%rax
  801d7a:	74 51                	je     801dcd <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801d7c:	4c 89 ea             	mov    %r13,%rdx
  801d7f:	4c 89 e6             	mov    %r12,%rsi
  801d82:	ff d0                	call   *%rax
}
  801d84:	48 83 c4 18          	add    $0x18,%rsp
  801d88:	5b                   	pop    %rbx
  801d89:	41 5c                	pop    %r12
  801d8b:	41 5d                	pop    %r13
  801d8d:	5d                   	pop    %rbp
  801d8e:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d8f:	48 98                	cltq   
  801d91:	eb f1                	jmp    801d84 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d93:	48 98                	cltq   
  801d95:	eb ed                	jmp    801d84 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d97:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801d9e:	00 00 00 
  801da1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801da7:	89 da                	mov    %ebx,%edx
  801da9:	48 bf f1 35 80 00 00 	movabs $0x8035f1,%rdi
  801db0:	00 00 00 
  801db3:	b8 00 00 00 00       	mov    $0x0,%eax
  801db8:	48 b9 95 05 80 00 00 	movabs $0x800595,%rcx
  801dbf:	00 00 00 
  801dc2:	ff d1                	call   *%rcx
        return -E_INVAL;
  801dc4:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801dcb:	eb b7                	jmp    801d84 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801dcd:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801dd4:	eb ae                	jmp    801d84 <read+0x67>

0000000000801dd6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801dd6:	55                   	push   %rbp
  801dd7:	48 89 e5             	mov    %rsp,%rbp
  801dda:	41 57                	push   %r15
  801ddc:	41 56                	push   %r14
  801dde:	41 55                	push   %r13
  801de0:	41 54                	push   %r12
  801de2:	53                   	push   %rbx
  801de3:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801de7:	48 85 d2             	test   %rdx,%rdx
  801dea:	74 54                	je     801e40 <readn+0x6a>
  801dec:	41 89 fd             	mov    %edi,%r13d
  801def:	49 89 f6             	mov    %rsi,%r14
  801df2:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801df5:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801dfa:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801dff:	49 bf 1d 1d 80 00 00 	movabs $0x801d1d,%r15
  801e06:	00 00 00 
  801e09:	4c 89 e2             	mov    %r12,%rdx
  801e0c:	48 29 f2             	sub    %rsi,%rdx
  801e0f:	4c 01 f6             	add    %r14,%rsi
  801e12:	44 89 ef             	mov    %r13d,%edi
  801e15:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	78 20                	js     801e3c <readn+0x66>
    for (; inc && res < n; res += inc) {
  801e1c:	01 c3                	add    %eax,%ebx
  801e1e:	85 c0                	test   %eax,%eax
  801e20:	74 08                	je     801e2a <readn+0x54>
  801e22:	48 63 f3             	movslq %ebx,%rsi
  801e25:	4c 39 e6             	cmp    %r12,%rsi
  801e28:	72 df                	jb     801e09 <readn+0x33>
    }
    return res;
  801e2a:	48 63 c3             	movslq %ebx,%rax
}
  801e2d:	48 83 c4 08          	add    $0x8,%rsp
  801e31:	5b                   	pop    %rbx
  801e32:	41 5c                	pop    %r12
  801e34:	41 5d                	pop    %r13
  801e36:	41 5e                	pop    %r14
  801e38:	41 5f                	pop    %r15
  801e3a:	5d                   	pop    %rbp
  801e3b:	c3                   	ret    
        if (inc < 0) return inc;
  801e3c:	48 98                	cltq   
  801e3e:	eb ed                	jmp    801e2d <readn+0x57>
    int inc = 1, res = 0;
  801e40:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e45:	eb e3                	jmp    801e2a <readn+0x54>

0000000000801e47 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801e47:	55                   	push   %rbp
  801e48:	48 89 e5             	mov    %rsp,%rbp
  801e4b:	41 55                	push   %r13
  801e4d:	41 54                	push   %r12
  801e4f:	53                   	push   %rbx
  801e50:	48 83 ec 18          	sub    $0x18,%rsp
  801e54:	89 fb                	mov    %edi,%ebx
  801e56:	49 89 f4             	mov    %rsi,%r12
  801e59:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e5c:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e60:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  801e67:	00 00 00 
  801e6a:	ff d0                	call   *%rax
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	78 44                	js     801eb4 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e70:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e78:	8b 38                	mov    (%rax),%edi
  801e7a:	48 b8 85 1a 80 00 00 	movabs $0x801a85,%rax
  801e81:	00 00 00 
  801e84:	ff d0                	call   *%rax
  801e86:	85 c0                	test   %eax,%eax
  801e88:	78 2e                	js     801eb8 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e8a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e8e:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801e92:	74 28                	je     801ebc <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801e94:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e98:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e9c:	48 85 c0             	test   %rax,%rax
  801e9f:	74 51                	je     801ef2 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801ea1:	4c 89 ea             	mov    %r13,%rdx
  801ea4:	4c 89 e6             	mov    %r12,%rsi
  801ea7:	ff d0                	call   *%rax
}
  801ea9:	48 83 c4 18          	add    $0x18,%rsp
  801ead:	5b                   	pop    %rbx
  801eae:	41 5c                	pop    %r12
  801eb0:	41 5d                	pop    %r13
  801eb2:	5d                   	pop    %rbp
  801eb3:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801eb4:	48 98                	cltq   
  801eb6:	eb f1                	jmp    801ea9 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801eb8:	48 98                	cltq   
  801eba:	eb ed                	jmp    801ea9 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ebc:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801ec3:	00 00 00 
  801ec6:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ecc:	89 da                	mov    %ebx,%edx
  801ece:	48 bf 0d 36 80 00 00 	movabs $0x80360d,%rdi
  801ed5:	00 00 00 
  801ed8:	b8 00 00 00 00       	mov    $0x0,%eax
  801edd:	48 b9 95 05 80 00 00 	movabs $0x800595,%rcx
  801ee4:	00 00 00 
  801ee7:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ee9:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801ef0:	eb b7                	jmp    801ea9 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801ef2:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801ef9:	eb ae                	jmp    801ea9 <write+0x62>

0000000000801efb <seek>:

int
seek(int fdnum, off_t offset) {
  801efb:	55                   	push   %rbp
  801efc:	48 89 e5             	mov    %rsp,%rbp
  801eff:	53                   	push   %rbx
  801f00:	48 83 ec 18          	sub    $0x18,%rsp
  801f04:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f06:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f0a:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  801f11:	00 00 00 
  801f14:	ff d0                	call   *%rax
  801f16:	85 c0                	test   %eax,%eax
  801f18:	78 0c                	js     801f26 <seek+0x2b>

    fd->fd_offset = offset;
  801f1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f1e:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801f21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f26:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

0000000000801f2c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801f2c:	55                   	push   %rbp
  801f2d:	48 89 e5             	mov    %rsp,%rbp
  801f30:	41 54                	push   %r12
  801f32:	53                   	push   %rbx
  801f33:	48 83 ec 10          	sub    $0x10,%rsp
  801f37:	89 fb                	mov    %edi,%ebx
  801f39:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f3c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f40:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  801f47:	00 00 00 
  801f4a:	ff d0                	call   *%rax
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	78 36                	js     801f86 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f50:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801f54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f58:	8b 38                	mov    (%rax),%edi
  801f5a:	48 b8 85 1a 80 00 00 	movabs $0x801a85,%rax
  801f61:	00 00 00 
  801f64:	ff d0                	call   *%rax
  801f66:	85 c0                	test   %eax,%eax
  801f68:	78 1c                	js     801f86 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f6a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f6e:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801f72:	74 1b                	je     801f8f <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f78:	48 8b 40 30          	mov    0x30(%rax),%rax
  801f7c:	48 85 c0             	test   %rax,%rax
  801f7f:	74 42                	je     801fc3 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801f81:	44 89 e6             	mov    %r12d,%esi
  801f84:	ff d0                	call   *%rax
}
  801f86:	48 83 c4 10          	add    $0x10,%rsp
  801f8a:	5b                   	pop    %rbx
  801f8b:	41 5c                	pop    %r12
  801f8d:	5d                   	pop    %rbp
  801f8e:	c3                   	ret    
                thisenv->env_id, fdnum);
  801f8f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801f96:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f99:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f9f:	89 da                	mov    %ebx,%edx
  801fa1:	48 bf d0 35 80 00 00 	movabs $0x8035d0,%rdi
  801fa8:	00 00 00 
  801fab:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb0:	48 b9 95 05 80 00 00 	movabs $0x800595,%rcx
  801fb7:	00 00 00 
  801fba:	ff d1                	call   *%rcx
        return -E_INVAL;
  801fbc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fc1:	eb c3                	jmp    801f86 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801fc3:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801fc8:	eb bc                	jmp    801f86 <ftruncate+0x5a>

0000000000801fca <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801fca:	55                   	push   %rbp
  801fcb:	48 89 e5             	mov    %rsp,%rbp
  801fce:	53                   	push   %rbx
  801fcf:	48 83 ec 18          	sub    $0x18,%rsp
  801fd3:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fd6:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801fda:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  801fe1:	00 00 00 
  801fe4:	ff d0                	call   *%rax
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	78 4d                	js     802037 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fea:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff2:	8b 38                	mov    (%rax),%edi
  801ff4:	48 b8 85 1a 80 00 00 	movabs $0x801a85,%rax
  801ffb:	00 00 00 
  801ffe:	ff d0                	call   *%rax
  802000:	85 c0                	test   %eax,%eax
  802002:	78 33                	js     802037 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  802004:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802008:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  80200d:	74 2e                	je     80203d <fstat+0x73>

    stat->st_name[0] = 0;
  80200f:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  802012:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802019:	00 00 00 
    stat->st_isdir = 0;
  80201c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802023:	00 00 00 
    stat->st_dev = dev;
  802026:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  80202d:	48 89 de             	mov    %rbx,%rsi
  802030:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802034:	ff 50 28             	call   *0x28(%rax)
}
  802037:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  80203d:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802042:	eb f3                	jmp    802037 <fstat+0x6d>

0000000000802044 <stat>:

int
stat(const char *path, struct Stat *stat) {
  802044:	55                   	push   %rbp
  802045:	48 89 e5             	mov    %rsp,%rbp
  802048:	41 54                	push   %r12
  80204a:	53                   	push   %rbx
  80204b:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  80204e:	be 00 00 00 00       	mov    $0x0,%esi
  802053:	48 b8 0f 23 80 00 00 	movabs $0x80230f,%rax
  80205a:	00 00 00 
  80205d:	ff d0                	call   *%rax
  80205f:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  802061:	85 c0                	test   %eax,%eax
  802063:	78 25                	js     80208a <stat+0x46>

    int res = fstat(fd, stat);
  802065:	4c 89 e6             	mov    %r12,%rsi
  802068:	89 c7                	mov    %eax,%edi
  80206a:	48 b8 ca 1f 80 00 00 	movabs $0x801fca,%rax
  802071:	00 00 00 
  802074:	ff d0                	call   *%rax
  802076:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802079:	89 df                	mov    %ebx,%edi
  80207b:	48 b8 a4 1b 80 00 00 	movabs $0x801ba4,%rax
  802082:	00 00 00 
  802085:	ff d0                	call   *%rax

    return res;
  802087:	44 89 e3             	mov    %r12d,%ebx
}
  80208a:	89 d8                	mov    %ebx,%eax
  80208c:	5b                   	pop    %rbx
  80208d:	41 5c                	pop    %r12
  80208f:	5d                   	pop    %rbp
  802090:	c3                   	ret    

0000000000802091 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802091:	55                   	push   %rbp
  802092:	48 89 e5             	mov    %rsp,%rbp
  802095:	41 54                	push   %r12
  802097:	53                   	push   %rbx
  802098:	48 83 ec 10          	sub    $0x10,%rsp
  80209c:	41 89 fc             	mov    %edi,%r12d
  80209f:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8020a2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8020a9:	00 00 00 
  8020ac:	83 38 00             	cmpl   $0x0,(%rax)
  8020af:	74 5e                	je     80210f <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  8020b1:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  8020b7:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020bc:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8020c3:	00 00 00 
  8020c6:	44 89 e6             	mov    %r12d,%esi
  8020c9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8020d0:	00 00 00 
  8020d3:	8b 38                	mov    (%rax),%edi
  8020d5:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  8020dc:	00 00 00 
  8020df:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  8020e1:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8020e8:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  8020e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020ee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020f2:	48 89 de             	mov    %rbx,%rsi
  8020f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020fa:	48 b8 0a 2d 80 00 00 	movabs $0x802d0a,%rax
  802101:	00 00 00 
  802104:	ff d0                	call   *%rax
}
  802106:	48 83 c4 10          	add    $0x10,%rsp
  80210a:	5b                   	pop    %rbx
  80210b:	41 5c                	pop    %r12
  80210d:	5d                   	pop    %rbp
  80210e:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80210f:	bf 03 00 00 00       	mov    $0x3,%edi
  802114:	48 b8 4c 2e 80 00 00 	movabs $0x802e4c,%rax
  80211b:	00 00 00 
  80211e:	ff d0                	call   *%rax
  802120:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802127:	00 00 
  802129:	eb 86                	jmp    8020b1 <fsipc+0x20>

000000000080212b <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80212b:	55                   	push   %rbp
  80212c:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80212f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802136:	00 00 00 
  802139:	8b 57 0c             	mov    0xc(%rdi),%edx
  80213c:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  80213e:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802141:	be 00 00 00 00       	mov    $0x0,%esi
  802146:	bf 02 00 00 00       	mov    $0x2,%edi
  80214b:	48 b8 91 20 80 00 00 	movabs $0x802091,%rax
  802152:	00 00 00 
  802155:	ff d0                	call   *%rax
}
  802157:	5d                   	pop    %rbp
  802158:	c3                   	ret    

0000000000802159 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802159:	55                   	push   %rbp
  80215a:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80215d:	8b 47 0c             	mov    0xc(%rdi),%eax
  802160:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802167:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802169:	be 00 00 00 00       	mov    $0x0,%esi
  80216e:	bf 06 00 00 00       	mov    $0x6,%edi
  802173:	48 b8 91 20 80 00 00 	movabs $0x802091,%rax
  80217a:	00 00 00 
  80217d:	ff d0                	call   *%rax
}
  80217f:	5d                   	pop    %rbp
  802180:	c3                   	ret    

0000000000802181 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802181:	55                   	push   %rbp
  802182:	48 89 e5             	mov    %rsp,%rbp
  802185:	53                   	push   %rbx
  802186:	48 83 ec 08          	sub    $0x8,%rsp
  80218a:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80218d:	8b 47 0c             	mov    0xc(%rdi),%eax
  802190:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802197:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802199:	be 00 00 00 00       	mov    $0x0,%esi
  80219e:	bf 05 00 00 00       	mov    $0x5,%edi
  8021a3:	48 b8 91 20 80 00 00 	movabs $0x802091,%rax
  8021aa:	00 00 00 
  8021ad:	ff d0                	call   *%rax
    if (res < 0) return res;
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	78 40                	js     8021f3 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8021b3:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8021ba:	00 00 00 
  8021bd:	48 89 df             	mov    %rbx,%rdi
  8021c0:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  8021c7:	00 00 00 
  8021ca:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8021cc:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8021d3:	00 00 00 
  8021d6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8021dc:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8021e2:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8021e8:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8021ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

00000000008021f9 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8021f9:	55                   	push   %rbp
  8021fa:	48 89 e5             	mov    %rsp,%rbp
  8021fd:	41 57                	push   %r15
  8021ff:	41 56                	push   %r14
  802201:	41 55                	push   %r13
  802203:	41 54                	push   %r12
  802205:	53                   	push   %rbx
  802206:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  80220a:	48 85 d2             	test   %rdx,%rdx
  80220d:	0f 84 91 00 00 00    	je     8022a4 <devfile_write+0xab>
  802213:	49 89 ff             	mov    %rdi,%r15
  802216:	49 89 f4             	mov    %rsi,%r12
  802219:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  80221c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802223:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  80222a:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80222d:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  802234:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  80223a:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  80223e:	4c 89 ea             	mov    %r13,%rdx
  802241:	4c 89 e6             	mov    %r12,%rsi
  802244:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  80224b:	00 00 00 
  80224e:	48 b8 36 11 80 00 00 	movabs $0x801136,%rax
  802255:	00 00 00 
  802258:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80225a:	41 8b 47 0c          	mov    0xc(%r15),%eax
  80225e:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  802261:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  802265:	be 00 00 00 00       	mov    $0x0,%esi
  80226a:	bf 04 00 00 00       	mov    $0x4,%edi
  80226f:	48 b8 91 20 80 00 00 	movabs $0x802091,%rax
  802276:	00 00 00 
  802279:	ff d0                	call   *%rax
        if (res < 0)
  80227b:	85 c0                	test   %eax,%eax
  80227d:	78 21                	js     8022a0 <devfile_write+0xa7>
        buf += res;
  80227f:	48 63 d0             	movslq %eax,%rdx
  802282:	49 01 d4             	add    %rdx,%r12
        ext += res;
  802285:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  802288:	48 29 d3             	sub    %rdx,%rbx
  80228b:	75 a0                	jne    80222d <devfile_write+0x34>
    return ext;
  80228d:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  802291:	48 83 c4 18          	add    $0x18,%rsp
  802295:	5b                   	pop    %rbx
  802296:	41 5c                	pop    %r12
  802298:	41 5d                	pop    %r13
  80229a:	41 5e                	pop    %r14
  80229c:	41 5f                	pop    %r15
  80229e:	5d                   	pop    %rbp
  80229f:	c3                   	ret    
            return res;
  8022a0:	48 98                	cltq   
  8022a2:	eb ed                	jmp    802291 <devfile_write+0x98>
    int ext = 0;
  8022a4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  8022ab:	eb e0                	jmp    80228d <devfile_write+0x94>

00000000008022ad <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8022ad:	55                   	push   %rbp
  8022ae:	48 89 e5             	mov    %rsp,%rbp
  8022b1:	41 54                	push   %r12
  8022b3:	53                   	push   %rbx
  8022b4:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  8022b7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8022be:	00 00 00 
  8022c1:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8022c4:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  8022c6:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  8022ca:	be 00 00 00 00       	mov    $0x0,%esi
  8022cf:	bf 03 00 00 00       	mov    $0x3,%edi
  8022d4:	48 b8 91 20 80 00 00 	movabs $0x802091,%rax
  8022db:	00 00 00 
  8022de:	ff d0                	call   *%rax
    if (read < 0) 
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	78 27                	js     80230b <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  8022e4:	48 63 d8             	movslq %eax,%rbx
  8022e7:	48 89 da             	mov    %rbx,%rdx
  8022ea:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8022f1:	00 00 00 
  8022f4:	4c 89 e7             	mov    %r12,%rdi
  8022f7:	48 b8 d1 10 80 00 00 	movabs $0x8010d1,%rax
  8022fe:	00 00 00 
  802301:	ff d0                	call   *%rax
    return read;
  802303:	48 89 d8             	mov    %rbx,%rax
}
  802306:	5b                   	pop    %rbx
  802307:	41 5c                	pop    %r12
  802309:	5d                   	pop    %rbp
  80230a:	c3                   	ret    
		return read;
  80230b:	48 98                	cltq   
  80230d:	eb f7                	jmp    802306 <devfile_read+0x59>

000000000080230f <open>:
open(const char *path, int mode) {
  80230f:	55                   	push   %rbp
  802310:	48 89 e5             	mov    %rsp,%rbp
  802313:	41 55                	push   %r13
  802315:	41 54                	push   %r12
  802317:	53                   	push   %rbx
  802318:	48 83 ec 18          	sub    $0x18,%rsp
  80231c:	49 89 fc             	mov    %rdi,%r12
  80231f:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802322:	48 b8 9d 0e 80 00 00 	movabs $0x800e9d,%rax
  802329:	00 00 00 
  80232c:	ff d0                	call   *%rax
  80232e:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802334:	0f 87 8c 00 00 00    	ja     8023c6 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80233a:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80233e:	48 b8 da 19 80 00 00 	movabs $0x8019da,%rax
  802345:	00 00 00 
  802348:	ff d0                	call   *%rax
  80234a:	89 c3                	mov    %eax,%ebx
  80234c:	85 c0                	test   %eax,%eax
  80234e:	78 52                	js     8023a2 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802350:	4c 89 e6             	mov    %r12,%rsi
  802353:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  80235a:	00 00 00 
  80235d:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  802364:	00 00 00 
  802367:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802369:	44 89 e8             	mov    %r13d,%eax
  80236c:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802373:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802375:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802379:	bf 01 00 00 00       	mov    $0x1,%edi
  80237e:	48 b8 91 20 80 00 00 	movabs $0x802091,%rax
  802385:	00 00 00 
  802388:	ff d0                	call   *%rax
  80238a:	89 c3                	mov    %eax,%ebx
  80238c:	85 c0                	test   %eax,%eax
  80238e:	78 1f                	js     8023af <open+0xa0>
    return fd2num(fd);
  802390:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802394:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  80239b:	00 00 00 
  80239e:	ff d0                	call   *%rax
  8023a0:	89 c3                	mov    %eax,%ebx
}
  8023a2:	89 d8                	mov    %ebx,%eax
  8023a4:	48 83 c4 18          	add    $0x18,%rsp
  8023a8:	5b                   	pop    %rbx
  8023a9:	41 5c                	pop    %r12
  8023ab:	41 5d                	pop    %r13
  8023ad:	5d                   	pop    %rbp
  8023ae:	c3                   	ret    
        fd_close(fd, 0);
  8023af:	be 00 00 00 00       	mov    $0x0,%esi
  8023b4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023b8:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  8023bf:	00 00 00 
  8023c2:	ff d0                	call   *%rax
        return res;
  8023c4:	eb dc                	jmp    8023a2 <open+0x93>
        return -E_BAD_PATH;
  8023c6:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8023cb:	eb d5                	jmp    8023a2 <open+0x93>

00000000008023cd <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8023cd:	55                   	push   %rbp
  8023ce:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8023d1:	be 00 00 00 00       	mov    $0x0,%esi
  8023d6:	bf 08 00 00 00       	mov    $0x8,%edi
  8023db:	48 b8 91 20 80 00 00 	movabs $0x802091,%rax
  8023e2:	00 00 00 
  8023e5:	ff d0                	call   *%rax
}
  8023e7:	5d                   	pop    %rbp
  8023e8:	c3                   	ret    

00000000008023e9 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8023e9:	55                   	push   %rbp
  8023ea:	48 89 e5             	mov    %rsp,%rbp
  8023ed:	41 54                	push   %r12
  8023ef:	53                   	push   %rbx
  8023f0:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8023f3:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  8023fa:	00 00 00 
  8023fd:	ff d0                	call   *%rax
  8023ff:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802402:	48 be 60 36 80 00 00 	movabs $0x803660,%rsi
  802409:	00 00 00 
  80240c:	48 89 df             	mov    %rbx,%rdi
  80240f:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  802416:	00 00 00 
  802419:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80241b:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802420:	41 2b 04 24          	sub    (%r12),%eax
  802424:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80242a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802431:	00 00 00 
    stat->st_dev = &devpipe;
  802434:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80243b:	00 00 00 
  80243e:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802445:	b8 00 00 00 00       	mov    $0x0,%eax
  80244a:	5b                   	pop    %rbx
  80244b:	41 5c                	pop    %r12
  80244d:	5d                   	pop    %rbp
  80244e:	c3                   	ret    

000000000080244f <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80244f:	55                   	push   %rbp
  802450:	48 89 e5             	mov    %rsp,%rbp
  802453:	41 54                	push   %r12
  802455:	53                   	push   %rbx
  802456:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802459:	ba 00 10 00 00       	mov    $0x1000,%edx
  80245e:	48 89 fe             	mov    %rdi,%rsi
  802461:	bf 00 00 00 00       	mov    $0x0,%edi
  802466:	49 bc 5c 15 80 00 00 	movabs $0x80155c,%r12
  80246d:	00 00 00 
  802470:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802473:	48 89 df             	mov    %rbx,%rdi
  802476:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  80247d:	00 00 00 
  802480:	ff d0                	call   *%rax
  802482:	48 89 c6             	mov    %rax,%rsi
  802485:	ba 00 10 00 00       	mov    $0x1000,%edx
  80248a:	bf 00 00 00 00       	mov    $0x0,%edi
  80248f:	41 ff d4             	call   *%r12
}
  802492:	5b                   	pop    %rbx
  802493:	41 5c                	pop    %r12
  802495:	5d                   	pop    %rbp
  802496:	c3                   	ret    

0000000000802497 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802497:	55                   	push   %rbp
  802498:	48 89 e5             	mov    %rsp,%rbp
  80249b:	41 57                	push   %r15
  80249d:	41 56                	push   %r14
  80249f:	41 55                	push   %r13
  8024a1:	41 54                	push   %r12
  8024a3:	53                   	push   %rbx
  8024a4:	48 83 ec 18          	sub    $0x18,%rsp
  8024a8:	49 89 fc             	mov    %rdi,%r12
  8024ab:	49 89 f5             	mov    %rsi,%r13
  8024ae:	49 89 d7             	mov    %rdx,%r15
  8024b1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024b5:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  8024bc:	00 00 00 
  8024bf:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8024c1:	4d 85 ff             	test   %r15,%r15
  8024c4:	0f 84 ac 00 00 00    	je     802576 <devpipe_write+0xdf>
  8024ca:	48 89 c3             	mov    %rax,%rbx
  8024cd:	4c 89 f8             	mov    %r15,%rax
  8024d0:	4d 89 ef             	mov    %r13,%r15
  8024d3:	49 01 c5             	add    %rax,%r13
  8024d6:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024da:	49 bd 64 14 80 00 00 	movabs $0x801464,%r13
  8024e1:	00 00 00 
            sys_yield();
  8024e4:	49 be 01 14 80 00 00 	movabs $0x801401,%r14
  8024eb:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8024ee:	8b 73 04             	mov    0x4(%rbx),%esi
  8024f1:	48 63 ce             	movslq %esi,%rcx
  8024f4:	48 63 03             	movslq (%rbx),%rax
  8024f7:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8024fd:	48 39 c1             	cmp    %rax,%rcx
  802500:	72 2e                	jb     802530 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802502:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802507:	48 89 da             	mov    %rbx,%rdx
  80250a:	be 00 10 00 00       	mov    $0x1000,%esi
  80250f:	4c 89 e7             	mov    %r12,%rdi
  802512:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802515:	85 c0                	test   %eax,%eax
  802517:	74 63                	je     80257c <devpipe_write+0xe5>
            sys_yield();
  802519:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80251c:	8b 73 04             	mov    0x4(%rbx),%esi
  80251f:	48 63 ce             	movslq %esi,%rcx
  802522:	48 63 03             	movslq (%rbx),%rax
  802525:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80252b:	48 39 c1             	cmp    %rax,%rcx
  80252e:	73 d2                	jae    802502 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802530:	41 0f b6 3f          	movzbl (%r15),%edi
  802534:	48 89 ca             	mov    %rcx,%rdx
  802537:	48 c1 ea 03          	shr    $0x3,%rdx
  80253b:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802542:	08 10 20 
  802545:	48 f7 e2             	mul    %rdx
  802548:	48 c1 ea 06          	shr    $0x6,%rdx
  80254c:	48 89 d0             	mov    %rdx,%rax
  80254f:	48 c1 e0 09          	shl    $0x9,%rax
  802553:	48 29 d0             	sub    %rdx,%rax
  802556:	48 c1 e0 03          	shl    $0x3,%rax
  80255a:	48 29 c1             	sub    %rax,%rcx
  80255d:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802562:	83 c6 01             	add    $0x1,%esi
  802565:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802568:	49 83 c7 01          	add    $0x1,%r15
  80256c:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802570:	0f 85 78 ff ff ff    	jne    8024ee <devpipe_write+0x57>
    return n;
  802576:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80257a:	eb 05                	jmp    802581 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  80257c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802581:	48 83 c4 18          	add    $0x18,%rsp
  802585:	5b                   	pop    %rbx
  802586:	41 5c                	pop    %r12
  802588:	41 5d                	pop    %r13
  80258a:	41 5e                	pop    %r14
  80258c:	41 5f                	pop    %r15
  80258e:	5d                   	pop    %rbp
  80258f:	c3                   	ret    

0000000000802590 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802590:	55                   	push   %rbp
  802591:	48 89 e5             	mov    %rsp,%rbp
  802594:	41 57                	push   %r15
  802596:	41 56                	push   %r14
  802598:	41 55                	push   %r13
  80259a:	41 54                	push   %r12
  80259c:	53                   	push   %rbx
  80259d:	48 83 ec 18          	sub    $0x18,%rsp
  8025a1:	49 89 fc             	mov    %rdi,%r12
  8025a4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8025a8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8025ac:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  8025b3:	00 00 00 
  8025b6:	ff d0                	call   *%rax
  8025b8:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8025bb:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025c1:	49 bd 64 14 80 00 00 	movabs $0x801464,%r13
  8025c8:	00 00 00 
            sys_yield();
  8025cb:	49 be 01 14 80 00 00 	movabs $0x801401,%r14
  8025d2:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8025d5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8025da:	74 7a                	je     802656 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8025dc:	8b 03                	mov    (%rbx),%eax
  8025de:	3b 43 04             	cmp    0x4(%rbx),%eax
  8025e1:	75 26                	jne    802609 <devpipe_read+0x79>
            if (i > 0) return i;
  8025e3:	4d 85 ff             	test   %r15,%r15
  8025e6:	75 74                	jne    80265c <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025e8:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8025ed:	48 89 da             	mov    %rbx,%rdx
  8025f0:	be 00 10 00 00       	mov    $0x1000,%esi
  8025f5:	4c 89 e7             	mov    %r12,%rdi
  8025f8:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8025fb:	85 c0                	test   %eax,%eax
  8025fd:	74 6f                	je     80266e <devpipe_read+0xde>
            sys_yield();
  8025ff:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802602:	8b 03                	mov    (%rbx),%eax
  802604:	3b 43 04             	cmp    0x4(%rbx),%eax
  802607:	74 df                	je     8025e8 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802609:	48 63 c8             	movslq %eax,%rcx
  80260c:	48 89 ca             	mov    %rcx,%rdx
  80260f:	48 c1 ea 03          	shr    $0x3,%rdx
  802613:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80261a:	08 10 20 
  80261d:	48 f7 e2             	mul    %rdx
  802620:	48 c1 ea 06          	shr    $0x6,%rdx
  802624:	48 89 d0             	mov    %rdx,%rax
  802627:	48 c1 e0 09          	shl    $0x9,%rax
  80262b:	48 29 d0             	sub    %rdx,%rax
  80262e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802635:	00 
  802636:	48 89 c8             	mov    %rcx,%rax
  802639:	48 29 d0             	sub    %rdx,%rax
  80263c:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802641:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802645:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802649:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80264c:	49 83 c7 01          	add    $0x1,%r15
  802650:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802654:	75 86                	jne    8025dc <devpipe_read+0x4c>
    return n;
  802656:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80265a:	eb 03                	jmp    80265f <devpipe_read+0xcf>
            if (i > 0) return i;
  80265c:	4c 89 f8             	mov    %r15,%rax
}
  80265f:	48 83 c4 18          	add    $0x18,%rsp
  802663:	5b                   	pop    %rbx
  802664:	41 5c                	pop    %r12
  802666:	41 5d                	pop    %r13
  802668:	41 5e                	pop    %r14
  80266a:	41 5f                	pop    %r15
  80266c:	5d                   	pop    %rbp
  80266d:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  80266e:	b8 00 00 00 00       	mov    $0x0,%eax
  802673:	eb ea                	jmp    80265f <devpipe_read+0xcf>

0000000000802675 <pipe>:
pipe(int pfd[2]) {
  802675:	55                   	push   %rbp
  802676:	48 89 e5             	mov    %rsp,%rbp
  802679:	41 55                	push   %r13
  80267b:	41 54                	push   %r12
  80267d:	53                   	push   %rbx
  80267e:	48 83 ec 18          	sub    $0x18,%rsp
  802682:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802685:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802689:	48 b8 da 19 80 00 00 	movabs $0x8019da,%rax
  802690:	00 00 00 
  802693:	ff d0                	call   *%rax
  802695:	89 c3                	mov    %eax,%ebx
  802697:	85 c0                	test   %eax,%eax
  802699:	0f 88 a0 01 00 00    	js     80283f <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80269f:	b9 46 00 00 00       	mov    $0x46,%ecx
  8026a4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026a9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8026ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8026b2:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  8026b9:	00 00 00 
  8026bc:	ff d0                	call   *%rax
  8026be:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8026c0:	85 c0                	test   %eax,%eax
  8026c2:	0f 88 77 01 00 00    	js     80283f <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8026c8:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8026cc:	48 b8 da 19 80 00 00 	movabs $0x8019da,%rax
  8026d3:	00 00 00 
  8026d6:	ff d0                	call   *%rax
  8026d8:	89 c3                	mov    %eax,%ebx
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	0f 88 43 01 00 00    	js     802825 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8026e2:	b9 46 00 00 00       	mov    $0x46,%ecx
  8026e7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026ec:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f5:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  8026fc:	00 00 00 
  8026ff:	ff d0                	call   *%rax
  802701:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802703:	85 c0                	test   %eax,%eax
  802705:	0f 88 1a 01 00 00    	js     802825 <pipe+0x1b0>
    va = fd2data(fd0);
  80270b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80270f:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  802716:	00 00 00 
  802719:	ff d0                	call   *%rax
  80271b:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80271e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802723:	ba 00 10 00 00       	mov    $0x1000,%edx
  802728:	48 89 c6             	mov    %rax,%rsi
  80272b:	bf 00 00 00 00       	mov    $0x0,%edi
  802730:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  802737:	00 00 00 
  80273a:	ff d0                	call   *%rax
  80273c:	89 c3                	mov    %eax,%ebx
  80273e:	85 c0                	test   %eax,%eax
  802740:	0f 88 c5 00 00 00    	js     80280b <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802746:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80274a:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  802751:	00 00 00 
  802754:	ff d0                	call   *%rax
  802756:	48 89 c1             	mov    %rax,%rcx
  802759:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80275f:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802765:	ba 00 00 00 00       	mov    $0x0,%edx
  80276a:	4c 89 ee             	mov    %r13,%rsi
  80276d:	bf 00 00 00 00       	mov    $0x0,%edi
  802772:	48 b8 f7 14 80 00 00 	movabs $0x8014f7,%rax
  802779:	00 00 00 
  80277c:	ff d0                	call   *%rax
  80277e:	89 c3                	mov    %eax,%ebx
  802780:	85 c0                	test   %eax,%eax
  802782:	78 6e                	js     8027f2 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802784:	be 00 10 00 00       	mov    $0x1000,%esi
  802789:	4c 89 ef             	mov    %r13,%rdi
  80278c:	48 b8 32 14 80 00 00 	movabs $0x801432,%rax
  802793:	00 00 00 
  802796:	ff d0                	call   *%rax
  802798:	83 f8 02             	cmp    $0x2,%eax
  80279b:	0f 85 ab 00 00 00    	jne    80284c <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8027a1:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8027a8:	00 00 
  8027aa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027ae:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8027b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027b4:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8027bb:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8027bf:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8027c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027c5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8027cc:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8027d0:	48 bb ac 19 80 00 00 	movabs $0x8019ac,%rbx
  8027d7:	00 00 00 
  8027da:	ff d3                	call   *%rbx
  8027dc:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8027e0:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8027e4:	ff d3                	call   *%rbx
  8027e6:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8027eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027f0:	eb 4d                	jmp    80283f <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8027f2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027f7:	4c 89 ee             	mov    %r13,%rsi
  8027fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ff:	48 b8 5c 15 80 00 00 	movabs $0x80155c,%rax
  802806:	00 00 00 
  802809:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80280b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802810:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802814:	bf 00 00 00 00       	mov    $0x0,%edi
  802819:	48 b8 5c 15 80 00 00 	movabs $0x80155c,%rax
  802820:	00 00 00 
  802823:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802825:	ba 00 10 00 00       	mov    $0x1000,%edx
  80282a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80282e:	bf 00 00 00 00       	mov    $0x0,%edi
  802833:	48 b8 5c 15 80 00 00 	movabs $0x80155c,%rax
  80283a:	00 00 00 
  80283d:	ff d0                	call   *%rax
}
  80283f:	89 d8                	mov    %ebx,%eax
  802841:	48 83 c4 18          	add    $0x18,%rsp
  802845:	5b                   	pop    %rbx
  802846:	41 5c                	pop    %r12
  802848:	41 5d                	pop    %r13
  80284a:	5d                   	pop    %rbp
  80284b:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80284c:	48 b9 90 36 80 00 00 	movabs $0x803690,%rcx
  802853:	00 00 00 
  802856:	48 ba 67 36 80 00 00 	movabs $0x803667,%rdx
  80285d:	00 00 00 
  802860:	be 2e 00 00 00       	mov    $0x2e,%esi
  802865:	48 bf 7c 36 80 00 00 	movabs $0x80367c,%rdi
  80286c:	00 00 00 
  80286f:	b8 00 00 00 00       	mov    $0x0,%eax
  802874:	49 b8 45 04 80 00 00 	movabs $0x800445,%r8
  80287b:	00 00 00 
  80287e:	41 ff d0             	call   *%r8

0000000000802881 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802881:	55                   	push   %rbp
  802882:	48 89 e5             	mov    %rsp,%rbp
  802885:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802889:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80288d:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  802894:	00 00 00 
  802897:	ff d0                	call   *%rax
    if (res < 0) return res;
  802899:	85 c0                	test   %eax,%eax
  80289b:	78 35                	js     8028d2 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80289d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8028a1:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  8028a8:	00 00 00 
  8028ab:	ff d0                	call   *%rax
  8028ad:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8028b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8028b5:	be 00 10 00 00       	mov    $0x1000,%esi
  8028ba:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8028be:	48 b8 64 14 80 00 00 	movabs $0x801464,%rax
  8028c5:	00 00 00 
  8028c8:	ff d0                	call   *%rax
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	0f 94 c0             	sete   %al
  8028cf:	0f b6 c0             	movzbl %al,%eax
}
  8028d2:	c9                   	leave  
  8028d3:	c3                   	ret    

00000000008028d4 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8028d4:	48 89 f8             	mov    %rdi,%rax
  8028d7:	48 c1 e8 27          	shr    $0x27,%rax
  8028db:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8028e2:	01 00 00 
  8028e5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028e9:	f6 c2 01             	test   $0x1,%dl
  8028ec:	74 6d                	je     80295b <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8028ee:	48 89 f8             	mov    %rdi,%rax
  8028f1:	48 c1 e8 1e          	shr    $0x1e,%rax
  8028f5:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8028fc:	01 00 00 
  8028ff:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802903:	f6 c2 01             	test   $0x1,%dl
  802906:	74 62                	je     80296a <get_uvpt_entry+0x96>
  802908:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80290f:	01 00 00 
  802912:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802916:	f6 c2 80             	test   $0x80,%dl
  802919:	75 4f                	jne    80296a <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80291b:	48 89 f8             	mov    %rdi,%rax
  80291e:	48 c1 e8 15          	shr    $0x15,%rax
  802922:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802929:	01 00 00 
  80292c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802930:	f6 c2 01             	test   $0x1,%dl
  802933:	74 44                	je     802979 <get_uvpt_entry+0xa5>
  802935:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80293c:	01 00 00 
  80293f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802943:	f6 c2 80             	test   $0x80,%dl
  802946:	75 31                	jne    802979 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802948:	48 c1 ef 0c          	shr    $0xc,%rdi
  80294c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802953:	01 00 00 
  802956:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80295a:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80295b:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802962:	01 00 00 
  802965:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802969:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80296a:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802971:	01 00 00 
  802974:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802978:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802979:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802980:	01 00 00 
  802983:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802987:	c3                   	ret    

0000000000802988 <get_prot>:

int
get_prot(void *va) {
  802988:	55                   	push   %rbp
  802989:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80298c:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  802993:	00 00 00 
  802996:	ff d0                	call   *%rax
  802998:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80299b:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8029a0:	89 c1                	mov    %eax,%ecx
  8029a2:	83 c9 04             	or     $0x4,%ecx
  8029a5:	f6 c2 01             	test   $0x1,%dl
  8029a8:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8029ab:	89 c1                	mov    %eax,%ecx
  8029ad:	83 c9 02             	or     $0x2,%ecx
  8029b0:	f6 c2 02             	test   $0x2,%dl
  8029b3:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8029b6:	89 c1                	mov    %eax,%ecx
  8029b8:	83 c9 01             	or     $0x1,%ecx
  8029bb:	48 85 d2             	test   %rdx,%rdx
  8029be:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8029c1:	89 c1                	mov    %eax,%ecx
  8029c3:	83 c9 40             	or     $0x40,%ecx
  8029c6:	f6 c6 04             	test   $0x4,%dh
  8029c9:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8029cc:	5d                   	pop    %rbp
  8029cd:	c3                   	ret    

00000000008029ce <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8029ce:	55                   	push   %rbp
  8029cf:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8029d2:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	call   *%rax
    return pte & PTE_D;
  8029de:	48 c1 e8 06          	shr    $0x6,%rax
  8029e2:	83 e0 01             	and    $0x1,%eax
}
  8029e5:	5d                   	pop    %rbp
  8029e6:	c3                   	ret    

00000000008029e7 <is_page_present>:

bool
is_page_present(void *va) {
  8029e7:	55                   	push   %rbp
  8029e8:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8029eb:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  8029f2:	00 00 00 
  8029f5:	ff d0                	call   *%rax
  8029f7:	83 e0 01             	and    $0x1,%eax
}
  8029fa:	5d                   	pop    %rbp
  8029fb:	c3                   	ret    

00000000008029fc <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8029fc:	55                   	push   %rbp
  8029fd:	48 89 e5             	mov    %rsp,%rbp
  802a00:	41 57                	push   %r15
  802a02:	41 56                	push   %r14
  802a04:	41 55                	push   %r13
  802a06:	41 54                	push   %r12
  802a08:	53                   	push   %rbx
  802a09:	48 83 ec 28          	sub    $0x28,%rsp
  802a0d:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802a11:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802a15:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802a1a:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802a21:	01 00 00 
  802a24:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802a2b:	01 00 00 
  802a2e:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802a35:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802a38:	49 bf 88 29 80 00 00 	movabs $0x802988,%r15
  802a3f:	00 00 00 
  802a42:	eb 16                	jmp    802a5a <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802a44:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802a4b:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802a52:	00 00 00 
  802a55:	48 39 c3             	cmp    %rax,%rbx
  802a58:	77 73                	ja     802acd <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802a5a:	48 89 d8             	mov    %rbx,%rax
  802a5d:	48 c1 e8 27          	shr    $0x27,%rax
  802a61:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802a65:	a8 01                	test   $0x1,%al
  802a67:	74 db                	je     802a44 <foreach_shared_region+0x48>
  802a69:	48 89 d8             	mov    %rbx,%rax
  802a6c:	48 c1 e8 1e          	shr    $0x1e,%rax
  802a70:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802a75:	a8 01                	test   $0x1,%al
  802a77:	74 cb                	je     802a44 <foreach_shared_region+0x48>
  802a79:	48 89 d8             	mov    %rbx,%rax
  802a7c:	48 c1 e8 15          	shr    $0x15,%rax
  802a80:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802a84:	a8 01                	test   $0x1,%al
  802a86:	74 bc                	je     802a44 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802a88:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802a8c:	48 89 df             	mov    %rbx,%rdi
  802a8f:	41 ff d7             	call   *%r15
  802a92:	a8 40                	test   $0x40,%al
  802a94:	75 09                	jne    802a9f <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802a96:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802a9d:	eb ac                	jmp    802a4b <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802a9f:	48 89 df             	mov    %rbx,%rdi
  802aa2:	48 b8 e7 29 80 00 00 	movabs $0x8029e7,%rax
  802aa9:	00 00 00 
  802aac:	ff d0                	call   *%rax
  802aae:	84 c0                	test   %al,%al
  802ab0:	74 e4                	je     802a96 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802ab2:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802ab9:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802abd:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802ac1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802ac5:	ff d0                	call   *%rax
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	79 cb                	jns    802a96 <foreach_shared_region+0x9a>
  802acb:	eb 05                	jmp    802ad2 <foreach_shared_region+0xd6>
    }
    return 0;
  802acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ad2:	48 83 c4 28          	add    $0x28,%rsp
  802ad6:	5b                   	pop    %rbx
  802ad7:	41 5c                	pop    %r12
  802ad9:	41 5d                	pop    %r13
  802adb:	41 5e                	pop    %r14
  802add:	41 5f                	pop    %r15
  802adf:	5d                   	pop    %rbp
  802ae0:	c3                   	ret    

0000000000802ae1 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae6:	c3                   	ret    

0000000000802ae7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802ae7:	55                   	push   %rbp
  802ae8:	48 89 e5             	mov    %rsp,%rbp
  802aeb:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802aee:	48 be b4 36 80 00 00 	movabs $0x8036b4,%rsi
  802af5:	00 00 00 
  802af8:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  802aff:	00 00 00 
  802b02:	ff d0                	call   *%rax
    return 0;
}
  802b04:	b8 00 00 00 00       	mov    $0x0,%eax
  802b09:	5d                   	pop    %rbp
  802b0a:	c3                   	ret    

0000000000802b0b <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802b0b:	55                   	push   %rbp
  802b0c:	48 89 e5             	mov    %rsp,%rbp
  802b0f:	41 57                	push   %r15
  802b11:	41 56                	push   %r14
  802b13:	41 55                	push   %r13
  802b15:	41 54                	push   %r12
  802b17:	53                   	push   %rbx
  802b18:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802b1f:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802b26:	48 85 d2             	test   %rdx,%rdx
  802b29:	74 78                	je     802ba3 <devcons_write+0x98>
  802b2b:	49 89 d6             	mov    %rdx,%r14
  802b2e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802b34:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802b39:	49 bf d1 10 80 00 00 	movabs $0x8010d1,%r15
  802b40:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802b43:	4c 89 f3             	mov    %r14,%rbx
  802b46:	48 29 f3             	sub    %rsi,%rbx
  802b49:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802b4d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802b52:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802b56:	4c 63 eb             	movslq %ebx,%r13
  802b59:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802b60:	4c 89 ea             	mov    %r13,%rdx
  802b63:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802b6a:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802b6d:	4c 89 ee             	mov    %r13,%rsi
  802b70:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802b77:	48 b8 07 13 80 00 00 	movabs $0x801307,%rax
  802b7e:	00 00 00 
  802b81:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802b83:	41 01 dc             	add    %ebx,%r12d
  802b86:	49 63 f4             	movslq %r12d,%rsi
  802b89:	4c 39 f6             	cmp    %r14,%rsi
  802b8c:	72 b5                	jb     802b43 <devcons_write+0x38>
    return res;
  802b8e:	49 63 c4             	movslq %r12d,%rax
}
  802b91:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802b98:	5b                   	pop    %rbx
  802b99:	41 5c                	pop    %r12
  802b9b:	41 5d                	pop    %r13
  802b9d:	41 5e                	pop    %r14
  802b9f:	41 5f                	pop    %r15
  802ba1:	5d                   	pop    %rbp
  802ba2:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802ba3:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802ba9:	eb e3                	jmp    802b8e <devcons_write+0x83>

0000000000802bab <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802bab:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802bae:	ba 00 00 00 00       	mov    $0x0,%edx
  802bb3:	48 85 c0             	test   %rax,%rax
  802bb6:	74 55                	je     802c0d <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802bb8:	55                   	push   %rbp
  802bb9:	48 89 e5             	mov    %rsp,%rbp
  802bbc:	41 55                	push   %r13
  802bbe:	41 54                	push   %r12
  802bc0:	53                   	push   %rbx
  802bc1:	48 83 ec 08          	sub    $0x8,%rsp
  802bc5:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802bc8:	48 bb 34 13 80 00 00 	movabs $0x801334,%rbx
  802bcf:	00 00 00 
  802bd2:	49 bc 01 14 80 00 00 	movabs $0x801401,%r12
  802bd9:	00 00 00 
  802bdc:	eb 03                	jmp    802be1 <devcons_read+0x36>
  802bde:	41 ff d4             	call   *%r12
  802be1:	ff d3                	call   *%rbx
  802be3:	85 c0                	test   %eax,%eax
  802be5:	74 f7                	je     802bde <devcons_read+0x33>
    if (c < 0) return c;
  802be7:	48 63 d0             	movslq %eax,%rdx
  802bea:	78 13                	js     802bff <devcons_read+0x54>
    if (c == 0x04) return 0;
  802bec:	ba 00 00 00 00       	mov    $0x0,%edx
  802bf1:	83 f8 04             	cmp    $0x4,%eax
  802bf4:	74 09                	je     802bff <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802bf6:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802bfa:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802bff:	48 89 d0             	mov    %rdx,%rax
  802c02:	48 83 c4 08          	add    $0x8,%rsp
  802c06:	5b                   	pop    %rbx
  802c07:	41 5c                	pop    %r12
  802c09:	41 5d                	pop    %r13
  802c0b:	5d                   	pop    %rbp
  802c0c:	c3                   	ret    
  802c0d:	48 89 d0             	mov    %rdx,%rax
  802c10:	c3                   	ret    

0000000000802c11 <cputchar>:
cputchar(int ch) {
  802c11:	55                   	push   %rbp
  802c12:	48 89 e5             	mov    %rsp,%rbp
  802c15:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802c19:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802c1d:	be 01 00 00 00       	mov    $0x1,%esi
  802c22:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802c26:	48 b8 07 13 80 00 00 	movabs $0x801307,%rax
  802c2d:	00 00 00 
  802c30:	ff d0                	call   *%rax
}
  802c32:	c9                   	leave  
  802c33:	c3                   	ret    

0000000000802c34 <getchar>:
getchar(void) {
  802c34:	55                   	push   %rbp
  802c35:	48 89 e5             	mov    %rsp,%rbp
  802c38:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802c3c:	ba 01 00 00 00       	mov    $0x1,%edx
  802c41:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802c45:	bf 00 00 00 00       	mov    $0x0,%edi
  802c4a:	48 b8 1d 1d 80 00 00 	movabs $0x801d1d,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	call   *%rax
  802c56:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	78 06                	js     802c62 <getchar+0x2e>
  802c5c:	74 08                	je     802c66 <getchar+0x32>
  802c5e:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802c62:	89 d0                	mov    %edx,%eax
  802c64:	c9                   	leave  
  802c65:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802c66:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802c6b:	eb f5                	jmp    802c62 <getchar+0x2e>

0000000000802c6d <iscons>:
iscons(int fdnum) {
  802c6d:	55                   	push   %rbp
  802c6e:	48 89 e5             	mov    %rsp,%rbp
  802c71:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802c75:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802c79:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	call   *%rax
    if (res < 0) return res;
  802c85:	85 c0                	test   %eax,%eax
  802c87:	78 18                	js     802ca1 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802c89:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c8d:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802c94:	00 00 00 
  802c97:	8b 00                	mov    (%rax),%eax
  802c99:	39 02                	cmp    %eax,(%rdx)
  802c9b:	0f 94 c0             	sete   %al
  802c9e:	0f b6 c0             	movzbl %al,%eax
}
  802ca1:	c9                   	leave  
  802ca2:	c3                   	ret    

0000000000802ca3 <opencons>:
opencons(void) {
  802ca3:	55                   	push   %rbp
  802ca4:	48 89 e5             	mov    %rsp,%rbp
  802ca7:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802cab:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802caf:	48 b8 da 19 80 00 00 	movabs $0x8019da,%rax
  802cb6:	00 00 00 
  802cb9:	ff d0                	call   *%rax
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	78 49                	js     802d08 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802cbf:	b9 46 00 00 00       	mov    $0x46,%ecx
  802cc4:	ba 00 10 00 00       	mov    $0x1000,%edx
  802cc9:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802ccd:	bf 00 00 00 00       	mov    $0x0,%edi
  802cd2:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  802cd9:	00 00 00 
  802cdc:	ff d0                	call   *%rax
  802cde:	85 c0                	test   %eax,%eax
  802ce0:	78 26                	js     802d08 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802ce2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ce6:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802ced:	00 00 
  802cef:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802cf1:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802cf5:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802cfc:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  802d03:	00 00 00 
  802d06:	ff d0                	call   *%rax
}
  802d08:	c9                   	leave  
  802d09:	c3                   	ret    

0000000000802d0a <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802d0a:	55                   	push   %rbp
  802d0b:	48 89 e5             	mov    %rsp,%rbp
  802d0e:	41 54                	push   %r12
  802d10:	53                   	push   %rbx
  802d11:	48 89 fb             	mov    %rdi,%rbx
  802d14:	48 89 f7             	mov    %rsi,%rdi
  802d17:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802d1a:	48 85 f6             	test   %rsi,%rsi
  802d1d:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802d24:	00 00 00 
  802d27:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802d2b:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802d30:	48 85 d2             	test   %rdx,%rdx
  802d33:	74 02                	je     802d37 <ipc_recv+0x2d>
  802d35:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802d37:	48 63 f6             	movslq %esi,%rsi
  802d3a:	48 b8 2a 17 80 00 00 	movabs $0x80172a,%rax
  802d41:	00 00 00 
  802d44:	ff d0                	call   *%rax

    if (res < 0) {
  802d46:	85 c0                	test   %eax,%eax
  802d48:	78 45                	js     802d8f <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802d4a:	48 85 db             	test   %rbx,%rbx
  802d4d:	74 12                	je     802d61 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802d4f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802d56:	00 00 00 
  802d59:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802d5f:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802d61:	4d 85 e4             	test   %r12,%r12
  802d64:	74 14                	je     802d7a <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802d66:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802d6d:	00 00 00 
  802d70:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802d76:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802d7a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802d81:	00 00 00 
  802d84:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802d8a:	5b                   	pop    %rbx
  802d8b:	41 5c                	pop    %r12
  802d8d:	5d                   	pop    %rbp
  802d8e:	c3                   	ret    
        if (from_env_store)
  802d8f:	48 85 db             	test   %rbx,%rbx
  802d92:	74 06                	je     802d9a <ipc_recv+0x90>
            *from_env_store = 0;
  802d94:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802d9a:	4d 85 e4             	test   %r12,%r12
  802d9d:	74 eb                	je     802d8a <ipc_recv+0x80>
            *perm_store = 0;
  802d9f:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802da6:	00 
  802da7:	eb e1                	jmp    802d8a <ipc_recv+0x80>

0000000000802da9 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802da9:	55                   	push   %rbp
  802daa:	48 89 e5             	mov    %rsp,%rbp
  802dad:	41 57                	push   %r15
  802daf:	41 56                	push   %r14
  802db1:	41 55                	push   %r13
  802db3:	41 54                	push   %r12
  802db5:	53                   	push   %rbx
  802db6:	48 83 ec 18          	sub    $0x18,%rsp
  802dba:	41 89 fd             	mov    %edi,%r13d
  802dbd:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802dc0:	48 89 d3             	mov    %rdx,%rbx
  802dc3:	49 89 cc             	mov    %rcx,%r12
  802dc6:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802dca:	48 85 d2             	test   %rdx,%rdx
  802dcd:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802dd4:	00 00 00 
  802dd7:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802ddb:	49 be fe 16 80 00 00 	movabs $0x8016fe,%r14
  802de2:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802de5:	49 bf 01 14 80 00 00 	movabs $0x801401,%r15
  802dec:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802def:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802df2:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802df6:	4c 89 e1             	mov    %r12,%rcx
  802df9:	48 89 da             	mov    %rbx,%rdx
  802dfc:	44 89 ef             	mov    %r13d,%edi
  802dff:	41 ff d6             	call   *%r14
  802e02:	85 c0                	test   %eax,%eax
  802e04:	79 37                	jns    802e3d <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802e06:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802e09:	75 05                	jne    802e10 <ipc_send+0x67>
          sys_yield();
  802e0b:	41 ff d7             	call   *%r15
  802e0e:	eb df                	jmp    802def <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802e10:	89 c1                	mov    %eax,%ecx
  802e12:	48 ba c0 36 80 00 00 	movabs $0x8036c0,%rdx
  802e19:	00 00 00 
  802e1c:	be 46 00 00 00       	mov    $0x46,%esi
  802e21:	48 bf d3 36 80 00 00 	movabs $0x8036d3,%rdi
  802e28:	00 00 00 
  802e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e30:	49 b8 45 04 80 00 00 	movabs $0x800445,%r8
  802e37:	00 00 00 
  802e3a:	41 ff d0             	call   *%r8
      }
}
  802e3d:	48 83 c4 18          	add    $0x18,%rsp
  802e41:	5b                   	pop    %rbx
  802e42:	41 5c                	pop    %r12
  802e44:	41 5d                	pop    %r13
  802e46:	41 5e                	pop    %r14
  802e48:	41 5f                	pop    %r15
  802e4a:	5d                   	pop    %rbp
  802e4b:	c3                   	ret    

0000000000802e4c <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802e4c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802e51:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802e58:	00 00 00 
  802e5b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802e5f:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802e63:	48 c1 e2 04          	shl    $0x4,%rdx
  802e67:	48 01 ca             	add    %rcx,%rdx
  802e6a:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802e70:	39 fa                	cmp    %edi,%edx
  802e72:	74 12                	je     802e86 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802e74:	48 83 c0 01          	add    $0x1,%rax
  802e78:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802e7e:	75 db                	jne    802e5b <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e85:	c3                   	ret    
            return envs[i].env_id;
  802e86:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802e8a:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802e8e:	48 c1 e0 04          	shl    $0x4,%rax
  802e92:	48 89 c2             	mov    %rax,%rdx
  802e95:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802e9c:	00 00 00 
  802e9f:	48 01 d0             	add    %rdx,%rax
  802ea2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ea8:	c3                   	ret    
  802ea9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000802eb0 <__rodata_start>:
  802eb0:	20 53 48             	and    %dl,0x48(%rbx)
  802eb3:	41 52                	push   %r10
  802eb5:	45 00 20             	add    %r12b,(%r8)
  802eb8:	43                   	rex.XB
  802eb9:	4f 57                	rex.WRXB push %r15
  802ebb:	00 45 49             	add    %al,0x49(%rbp)
  802ebe:	44 3a 20             	cmp    (%rax),%r12b
  802ec1:	25 64 2c 20 50       	and    $0x50202c64,%eax
  802ec6:	45                   	rex.RB
  802ec7:	49                   	rex.WB
  802ec8:	44 3a 20             	cmp    (%rax),%r12b
  802ecb:	25 64 0a 00 4d       	and    $0x4d000a64,%eax
  802ed0:	65 6d                	gs insl (%dx),%es:(%rdi)
  802ed2:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ed3:	72 79                	jb     802f4e <__rodata_start+0x9e>
  802ed5:	20 75 73             	and    %dh,0x73(%rbp)
  802ed8:	61                   	(bad)  
  802ed9:	67 65 20 73 75       	and    %dh,%gs:0x75(%ebx)
  802ede:	6d                   	insl   (%dx),%es:(%rdi)
  802edf:	6d                   	insl   (%dx),%es:(%rdi)
  802ee0:	61                   	(bad)  
  802ee1:	72 79                	jb     802f5c <__rodata_start+0xac>
  802ee3:	3a 0a                	cmp    (%rdx),%cl
  802ee5:	00 20                	add    %ah,(%rax)
  802ee7:	20 50 54             	and    %dl,0x54(%rax)
  802eea:	45 5f                	rex.RB pop %r15
  802eec:	50                   	push   %rax
  802eed:	3a 20                	cmp    (%rax),%ah
  802eef:	25 6c 75 0a 00       	and    $0xa756c,%eax
  802ef4:	20 20                	and    %ah,(%rax)
  802ef6:	50                   	push   %rax
  802ef7:	54                   	push   %rsp
  802ef8:	45 5f                	rex.RB pop %r15
  802efa:	55                   	push   %rbp
  802efb:	3a 20                	cmp    (%rax),%ah
  802efd:	25 6c 75 0a 00       	and    $0xa756c,%eax
  802f02:	20 20                	and    %ah,(%rax)
  802f04:	50                   	push   %rax
  802f05:	54                   	push   %rsp
  802f06:	45 5f                	rex.RB pop %r15
  802f08:	57                   	push   %rdi
  802f09:	3a 20                	cmp    (%rax),%ah
  802f0b:	25 6c 75 0a 00       	and    $0xa756c,%eax
  802f10:	20 20                	and    %ah,(%rax)
  802f12:	50                   	push   %rax
  802f13:	54                   	push   %rsp
  802f14:	45 5f                	rex.RB pop %r15
  802f16:	43                   	rex.XB
  802f17:	4f 57                	rex.WRXB push %r15
  802f19:	3a 20                	cmp    (%rax),%ah
  802f1b:	25 6c 75 0a 00       	and    $0xa756c,%eax
  802f20:	70 69                	jo     802f8b <__rodata_start+0xdb>
  802f22:	70 65                	jo     802f89 <__rodata_start+0xd9>
  802f24:	28 29                	sub    %ch,(%rcx)
  802f26:	20 66 61             	and    %ah,0x61(%rsi)
  802f29:	69 6c 65 64 0a 00 75 	imul   $0x7375000a,0x64(%rbp,%riz,2),%ebp
  802f30:	73 
  802f31:	65 72 2f             	gs jb  802f63 <__rodata_start+0xb3>
  802f34:	6d                   	insl   (%dx),%es:(%rdi)
  802f35:	65 6d                	gs insl (%dx),%es:(%rdi)
  802f37:	6c                   	insb   (%dx),%es:(%rdi)
  802f38:	61                   	(bad)  
  802f39:	79 6f                	jns    802faa <__rodata_start+0xfa>
  802f3b:	75 74                	jne    802fb1 <__rodata_start+0x101>
  802f3d:	2e 63 00             	cs movsxd (%rax),%eax
  802f40:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802f42:	72 6b                	jb     802faf <__rodata_start+0xff>
  802f44:	28 29                	sub    %ch,(%rcx)
  802f46:	20 66 61             	and    %ah,0x61(%rsi)
  802f49:	69 6c 65 64 0a 00 3d 	imul   $0x3d3d000a,0x64(%rbp,%riz,2),%ebp
  802f50:	3d 
  802f51:	3d 3d 20 43 68       	cmp    $0x6843203d,%eax
  802f56:	69 6c 64 0a 00 3d 3d 	imul   $0x3d3d3d00,0xa(%rsp,%riz,2),%ebp
  802f5d:	3d 
  802f5e:	3d 20 50 61 72       	cmp    $0x72615020,%eax
  802f63:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802f65:	74 0a                	je     802f71 <__rodata_start+0xc1>
  802f67:	00 70 6d             	add    %dh,0x6d(%rax)
  802f6a:	6c                   	insb   (%dx),%es:(%rdi)
  802f6b:	34 3d                	xor    $0x3d,%al
  802f6d:	25 70 20 75 76       	and    $0x76752070,%eax
  802f72:	70 6d                	jo     802fe1 <__rodata_start+0x131>
  802f74:	6c                   	insb   (%dx),%es:(%rdi)
  802f75:	34 3d                	xor    $0x3d,%al
  802f77:	25 70 20 75 76       	and    $0x76752070,%eax
  802f7c:	70 64                	jo     802fe2 <__rodata_start+0x132>
  802f7e:	70 3d                	jo     802fbd <__rodata_start+0x10d>
  802f80:	25 70 20 75 76       	and    $0x76752070,%eax
  802f85:	70 64                	jo     802feb <__rodata_start+0x13b>
  802f87:	3d 25 70 20 75       	cmp    $0x75207025,%eax
  802f8c:	76 70                	jbe    802ffe <__rodata_start+0x14e>
  802f8e:	74 3d                	je     802fcd <__rodata_start+0x11d>
  802f90:	25 70 0a 00 00       	and    $0xa70,%eax
  802f95:	00 00                	add    %al,(%rax)
  802f97:	00 5b 25             	add    %bl,0x25(%rbx)
  802f9a:	70 5d                	jo     802ff9 <__rodata_start+0x149>
  802f9c:	20 25 6c 78 20 2d    	and    %ah,0x2d20786c(%rip)        # 2da0a80e <__bss_end+0x2d20280e>
  802fa2:	3e 20 25 30 38 6c 78 	ds and %ah,0x786c3830(%rip)        # 78ec67d9 <__bss_end+0x786be7d9>
  802fa9:	3a 20                	cmp    (%rax),%ah
  802fab:	25 63 20 25 63       	and    $0x63252063,%eax
  802fb0:	20 25 63 20 7c 25    	and    %ah,0x257c2063(%rip)        # 25fc5019 <__bss_end+0x257bd019>
  802fb6:	73 25                	jae    802fdd <__rodata_start+0x12d>
  802fb8:	73 0a                	jae    802fc4 <__rodata_start+0x114>
  802fba:	00 3c 75 6e 6b 6e 6f 	add    %bh,0x6f6e6b6e(,%rsi,2)
  802fc1:	77 6e                	ja     803031 <__rodata_start+0x181>
  802fc3:	3e 00 0f             	ds add %cl,(%rdi)
  802fc6:	1f                   	(bad)  
  802fc7:	00 5b 25             	add    %bl,0x25(%rbx)
  802fca:	30 38                	xor    %bh,(%rax)
  802fcc:	78 5d                	js     80302b <__rodata_start+0x17b>
  802fce:	20 75 73             	and    %dh,0x73(%rbp)
  802fd1:	65 72 20             	gs jb  802ff4 <__rodata_start+0x144>
  802fd4:	70 61                	jo     803037 <__rodata_start+0x187>
  802fd6:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fd7:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  802fde:	73 20                	jae    803000 <__rodata_start+0x150>
  802fe0:	61                   	(bad)  
  802fe1:	74 20                	je     803003 <__rodata_start+0x153>
  802fe3:	25 73 3a 25 64       	and    $0x64253a73,%eax
  802fe8:	3a 20                	cmp    (%rax),%ah
  802fea:	00 30                	add    %dh,(%rax)
  802fec:	31 32                	xor    %esi,(%rdx)
  802fee:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802ff5:	41                   	rex.B
  802ff6:	42                   	rex.X
  802ff7:	43                   	rex.XB
  802ff8:	44                   	rex.R
  802ff9:	45                   	rex.RB
  802ffa:	46 00 30             	rex.RX add %r14b,(%rax)
  802ffd:	31 32                	xor    %esi,(%rdx)
  802fff:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  803006:	61                   	(bad)  
  803007:	62 63 64 65 66       	(bad)
  80300c:	00 28                	add    %ch,(%rax)
  80300e:	6e                   	outsb  %ds:(%rsi),(%dx)
  80300f:	75 6c                	jne    80307d <__rodata_start+0x1cd>
  803011:	6c                   	insb   (%dx),%es:(%rdi)
  803012:	29 00                	sub    %eax,(%rax)
  803014:	65 72 72             	gs jb  803089 <__rodata_start+0x1d9>
  803017:	6f                   	outsl  %ds:(%rsi),(%dx)
  803018:	72 20                	jb     80303a <__rodata_start+0x18a>
  80301a:	25 64 00 75 6e       	and    $0x6e750064,%eax
  80301f:	73 70                	jae    803091 <__rodata_start+0x1e1>
  803021:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  803025:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  80302c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80302d:	72 00                	jb     80302f <__rodata_start+0x17f>
  80302f:	62 61 64 20 65       	(bad)
  803034:	6e                   	outsb  %ds:(%rsi),(%dx)
  803035:	76 69                	jbe    8030a0 <__rodata_start+0x1f0>
  803037:	72 6f                	jb     8030a8 <__rodata_start+0x1f8>
  803039:	6e                   	outsb  %ds:(%rsi),(%dx)
  80303a:	6d                   	insl   (%dx),%es:(%rdi)
  80303b:	65 6e                	outsb  %gs:(%rsi),(%dx)
  80303d:	74 00                	je     80303f <__rodata_start+0x18f>
  80303f:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  803046:	20 70 61             	and    %dh,0x61(%rax)
  803049:	72 61                	jb     8030ac <__rodata_start+0x1fc>
  80304b:	6d                   	insl   (%dx),%es:(%rdi)
  80304c:	65 74 65             	gs je  8030b4 <__rodata_start+0x204>
  80304f:	72 00                	jb     803051 <__rodata_start+0x1a1>
  803051:	6f                   	outsl  %ds:(%rsi),(%dx)
  803052:	75 74                	jne    8030c8 <__rodata_start+0x218>
  803054:	20 6f 66             	and    %ch,0x66(%rdi)
  803057:	20 6d 65             	and    %ch,0x65(%rbp)
  80305a:	6d                   	insl   (%dx),%es:(%rdi)
  80305b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80305c:	72 79                	jb     8030d7 <__rodata_start+0x227>
  80305e:	00 6f 75             	add    %ch,0x75(%rdi)
  803061:	74 20                	je     803083 <__rodata_start+0x1d3>
  803063:	6f                   	outsl  %ds:(%rsi),(%dx)
  803064:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  803068:	76 69                	jbe    8030d3 <__rodata_start+0x223>
  80306a:	72 6f                	jb     8030db <__rodata_start+0x22b>
  80306c:	6e                   	outsb  %ds:(%rsi),(%dx)
  80306d:	6d                   	insl   (%dx),%es:(%rdi)
  80306e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803070:	74 73                	je     8030e5 <__rodata_start+0x235>
  803072:	00 63 6f             	add    %ah,0x6f(%rbx)
  803075:	72 72                	jb     8030e9 <__rodata_start+0x239>
  803077:	75 70                	jne    8030e9 <__rodata_start+0x239>
  803079:	74 65                	je     8030e0 <__rodata_start+0x230>
  80307b:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  803080:	75 67                	jne    8030e9 <__rodata_start+0x239>
  803082:	20 69 6e             	and    %ch,0x6e(%rcx)
  803085:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803087:	00 73 65             	add    %dh,0x65(%rbx)
  80308a:	67 6d                	insl   (%dx),%es:(%edi)
  80308c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  80308e:	74 61                	je     8030f1 <__rodata_start+0x241>
  803090:	74 69                	je     8030fb <__rodata_start+0x24b>
  803092:	6f                   	outsl  %ds:(%rsi),(%dx)
  803093:	6e                   	outsb  %ds:(%rsi),(%dx)
  803094:	20 66 61             	and    %ah,0x61(%rsi)
  803097:	75 6c                	jne    803105 <__rodata_start+0x255>
  803099:	74 00                	je     80309b <__rodata_start+0x1eb>
  80309b:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  8030a2:	20 45 4c             	and    %al,0x4c(%rbp)
  8030a5:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  8030a9:	61                   	(bad)  
  8030aa:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  8030af:	20 73 75             	and    %dh,0x75(%rbx)
  8030b2:	63 68 20             	movsxd 0x20(%rax),%ebp
  8030b5:	73 79                	jae    803130 <__rodata_start+0x280>
  8030b7:	73 74                	jae    80312d <__rodata_start+0x27d>
  8030b9:	65 6d                	gs insl (%dx),%es:(%rdi)
  8030bb:	20 63 61             	and    %ah,0x61(%rbx)
  8030be:	6c                   	insb   (%dx),%es:(%rdi)
  8030bf:	6c                   	insb   (%dx),%es:(%rdi)
  8030c0:	00 65 6e             	add    %ah,0x6e(%rbp)
  8030c3:	74 72                	je     803137 <__rodata_start+0x287>
  8030c5:	79 20                	jns    8030e7 <__rodata_start+0x237>
  8030c7:	6e                   	outsb  %ds:(%rsi),(%dx)
  8030c8:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030c9:	74 20                	je     8030eb <__rodata_start+0x23b>
  8030cb:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8030cd:	75 6e                	jne    80313d <__rodata_start+0x28d>
  8030cf:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  8030d3:	76 20                	jbe    8030f5 <__rodata_start+0x245>
  8030d5:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  8030dc:	72 65                	jb     803143 <__rodata_start+0x293>
  8030de:	63 76 69             	movsxd 0x69(%rsi),%esi
  8030e1:	6e                   	outsb  %ds:(%rsi),(%dx)
  8030e2:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  8030e6:	65 78 70             	gs js  803159 <__rodata_start+0x2a9>
  8030e9:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  8030ee:	20 65 6e             	and    %ah,0x6e(%rbp)
  8030f1:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  8030f5:	20 66 69             	and    %ah,0x69(%rsi)
  8030f8:	6c                   	insb   (%dx),%es:(%rdi)
  8030f9:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  8030fd:	20 66 72             	and    %ah,0x72(%rsi)
  803100:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  803105:	61                   	(bad)  
  803106:	63 65 20             	movsxd 0x20(%rbp),%esp
  803109:	6f                   	outsl  %ds:(%rsi),(%dx)
  80310a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80310b:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  80310f:	6b 00 74             	imul   $0x74,(%rax),%eax
  803112:	6f                   	outsl  %ds:(%rsi),(%dx)
  803113:	6f                   	outsl  %ds:(%rsi),(%dx)
  803114:	20 6d 61             	and    %ch,0x61(%rbp)
  803117:	6e                   	outsb  %ds:(%rsi),(%dx)
  803118:	79 20                	jns    80313a <__rodata_start+0x28a>
  80311a:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  803121:	72 65                	jb     803188 <__rodata_start+0x2d8>
  803123:	20 6f 70             	and    %ch,0x70(%rdi)
  803126:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803128:	00 66 69             	add    %ah,0x69(%rsi)
  80312b:	6c                   	insb   (%dx),%es:(%rdi)
  80312c:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  803130:	20 62 6c             	and    %ah,0x6c(%rdx)
  803133:	6f                   	outsl  %ds:(%rsi),(%dx)
  803134:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  803137:	6e                   	outsb  %ds:(%rsi),(%dx)
  803138:	6f                   	outsl  %ds:(%rsi),(%dx)
  803139:	74 20                	je     80315b <__rodata_start+0x2ab>
  80313b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  80313d:	75 6e                	jne    8031ad <__rodata_start+0x2fd>
  80313f:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  803143:	76 61                	jbe    8031a6 <__rodata_start+0x2f6>
  803145:	6c                   	insb   (%dx),%es:(%rdi)
  803146:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  80314d:	00 
  80314e:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  803155:	72 65                	jb     8031bc <__rodata_start+0x30c>
  803157:	61                   	(bad)  
  803158:	64 79 20             	fs jns 80317b <__rodata_start+0x2cb>
  80315b:	65 78 69             	gs js  8031c7 <__rodata_start+0x317>
  80315e:	73 74                	jae    8031d4 <__rodata_start+0x324>
  803160:	73 00                	jae    803162 <__rodata_start+0x2b2>
  803162:	6f                   	outsl  %ds:(%rsi),(%dx)
  803163:	70 65                	jo     8031ca <__rodata_start+0x31a>
  803165:	72 61                	jb     8031c8 <__rodata_start+0x318>
  803167:	74 69                	je     8031d2 <__rodata_start+0x322>
  803169:	6f                   	outsl  %ds:(%rsi),(%dx)
  80316a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80316b:	20 6e 6f             	and    %ch,0x6f(%rsi)
  80316e:	74 20                	je     803190 <__rodata_start+0x2e0>
  803170:	73 75                	jae    8031e7 <__rodata_start+0x337>
  803172:	70 70                	jo     8031e4 <__rodata_start+0x334>
  803174:	6f                   	outsl  %ds:(%rsi),(%dx)
  803175:	72 74                	jb     8031eb <__rodata_start+0x33b>
  803177:	65 64 00 66 0f       	gs add %ah,%fs:0xf(%rsi)
  80317c:	1f                   	(bad)  
  80317d:	44 00 00             	add    %r8b,(%rax)
  803180:	8f 07                	pop    (%rdi)
  803182:	80 00 00             	addb   $0x0,(%rax)
  803185:	00 00                	add    %al,(%rax)
  803187:	00 e3                	add    %ah,%bl
  803189:	0d 80 00 00 00       	or     $0x80,%eax
  80318e:	00 00                	add    %al,(%rax)
  803190:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803216 <__rodata_start+0x366>
  803196:	00 00                	add    %al,(%rax)
  803198:	e3 0d                	jrcxz  8031a7 <__rodata_start+0x2f7>
  80319a:	80 00 00             	addb   $0x0,(%rax)
  80319d:	00 00                	add    %al,(%rax)
  80319f:	00 e3                	add    %ah,%bl
  8031a1:	0d 80 00 00 00       	or     $0x80,%eax
  8031a6:	00 00                	add    %al,(%rax)
  8031a8:	e3 0d                	jrcxz  8031b7 <__rodata_start+0x307>
  8031aa:	80 00 00             	addb   $0x0,(%rax)
  8031ad:	00 00                	add    %al,(%rax)
  8031af:	00 e3                	add    %ah,%bl
  8031b1:	0d 80 00 00 00       	or     $0x80,%eax
  8031b6:	00 00                	add    %al,(%rax)
  8031b8:	a9 07 80 00 00       	test   $0x8007,%eax
  8031bd:	00 00                	add    %al,(%rax)
  8031bf:	00 e3                	add    %ah,%bl
  8031c1:	0d 80 00 00 00       	or     $0x80,%eax
  8031c6:	00 00                	add    %al,(%rax)
  8031c8:	e3 0d                	jrcxz  8031d7 <__rodata_start+0x327>
  8031ca:	80 00 00             	addb   $0x0,(%rax)
  8031cd:	00 00                	add    %al,(%rax)
  8031cf:	00 a0 07 80 00 00    	add    %ah,0x8007(%rax)
  8031d5:	00 00                	add    %al,(%rax)
  8031d7:	00 16                	add    %dl,(%rsi)
  8031d9:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  8031df:	00 e3                	add    %ah,%bl
  8031e1:	0d 80 00 00 00       	or     $0x80,%eax
  8031e6:	00 00                	add    %al,(%rax)
  8031e8:	a0 07 80 00 00 00 00 	movabs 0xe300000000008007,%al
  8031ef:	00 e3 
  8031f1:	07                   	(bad)  
  8031f2:	80 00 00             	addb   $0x0,(%rax)
  8031f5:	00 00                	add    %al,(%rax)
  8031f7:	00 e3                	add    %ah,%bl
  8031f9:	07                   	(bad)  
  8031fa:	80 00 00             	addb   $0x0,(%rax)
  8031fd:	00 00                	add    %al,(%rax)
  8031ff:	00 e3                	add    %ah,%bl
  803201:	07                   	(bad)  
  803202:	80 00 00             	addb   $0x0,(%rax)
  803205:	00 00                	add    %al,(%rax)
  803207:	00 e3                	add    %ah,%bl
  803209:	07                   	(bad)  
  80320a:	80 00 00             	addb   $0x0,(%rax)
  80320d:	00 00                	add    %al,(%rax)
  80320f:	00 e3                	add    %ah,%bl
  803211:	07                   	(bad)  
  803212:	80 00 00             	addb   $0x0,(%rax)
  803215:	00 00                	add    %al,(%rax)
  803217:	00 e3                	add    %ah,%bl
  803219:	07                   	(bad)  
  80321a:	80 00 00             	addb   $0x0,(%rax)
  80321d:	00 00                	add    %al,(%rax)
  80321f:	00 e3                	add    %ah,%bl
  803221:	07                   	(bad)  
  803222:	80 00 00             	addb   $0x0,(%rax)
  803225:	00 00                	add    %al,(%rax)
  803227:	00 e3                	add    %ah,%bl
  803229:	07                   	(bad)  
  80322a:	80 00 00             	addb   $0x0,(%rax)
  80322d:	00 00                	add    %al,(%rax)
  80322f:	00 e3                	add    %ah,%bl
  803231:	07                   	(bad)  
  803232:	80 00 00             	addb   $0x0,(%rax)
  803235:	00 00                	add    %al,(%rax)
  803237:	00 e3                	add    %ah,%bl
  803239:	0d 80 00 00 00       	or     $0x80,%eax
  80323e:	00 00                	add    %al,(%rax)
  803240:	e3 0d                	jrcxz  80324f <__rodata_start+0x39f>
  803242:	80 00 00             	addb   $0x0,(%rax)
  803245:	00 00                	add    %al,(%rax)
  803247:	00 e3                	add    %ah,%bl
  803249:	0d 80 00 00 00       	or     $0x80,%eax
  80324e:	00 00                	add    %al,(%rax)
  803250:	e3 0d                	jrcxz  80325f <__rodata_start+0x3af>
  803252:	80 00 00             	addb   $0x0,(%rax)
  803255:	00 00                	add    %al,(%rax)
  803257:	00 e3                	add    %ah,%bl
  803259:	0d 80 00 00 00       	or     $0x80,%eax
  80325e:	00 00                	add    %al,(%rax)
  803260:	e3 0d                	jrcxz  80326f <__rodata_start+0x3bf>
  803262:	80 00 00             	addb   $0x0,(%rax)
  803265:	00 00                	add    %al,(%rax)
  803267:	00 e3                	add    %ah,%bl
  803269:	0d 80 00 00 00       	or     $0x80,%eax
  80326e:	00 00                	add    %al,(%rax)
  803270:	e3 0d                	jrcxz  80327f <__rodata_start+0x3cf>
  803272:	80 00 00             	addb   $0x0,(%rax)
  803275:	00 00                	add    %al,(%rax)
  803277:	00 e3                	add    %ah,%bl
  803279:	0d 80 00 00 00       	or     $0x80,%eax
  80327e:	00 00                	add    %al,(%rax)
  803280:	e3 0d                	jrcxz  80328f <__rodata_start+0x3df>
  803282:	80 00 00             	addb   $0x0,(%rax)
  803285:	00 00                	add    %al,(%rax)
  803287:	00 e3                	add    %ah,%bl
  803289:	0d 80 00 00 00       	or     $0x80,%eax
  80328e:	00 00                	add    %al,(%rax)
  803290:	e3 0d                	jrcxz  80329f <__rodata_start+0x3ef>
  803292:	80 00 00             	addb   $0x0,(%rax)
  803295:	00 00                	add    %al,(%rax)
  803297:	00 e3                	add    %ah,%bl
  803299:	0d 80 00 00 00       	or     $0x80,%eax
  80329e:	00 00                	add    %al,(%rax)
  8032a0:	e3 0d                	jrcxz  8032af <__rodata_start+0x3ff>
  8032a2:	80 00 00             	addb   $0x0,(%rax)
  8032a5:	00 00                	add    %al,(%rax)
  8032a7:	00 e3                	add    %ah,%bl
  8032a9:	0d 80 00 00 00       	or     $0x80,%eax
  8032ae:	00 00                	add    %al,(%rax)
  8032b0:	e3 0d                	jrcxz  8032bf <__rodata_start+0x40f>
  8032b2:	80 00 00             	addb   $0x0,(%rax)
  8032b5:	00 00                	add    %al,(%rax)
  8032b7:	00 e3                	add    %ah,%bl
  8032b9:	0d 80 00 00 00       	or     $0x80,%eax
  8032be:	00 00                	add    %al,(%rax)
  8032c0:	e3 0d                	jrcxz  8032cf <__rodata_start+0x41f>
  8032c2:	80 00 00             	addb   $0x0,(%rax)
  8032c5:	00 00                	add    %al,(%rax)
  8032c7:	00 e3                	add    %ah,%bl
  8032c9:	0d 80 00 00 00       	or     $0x80,%eax
  8032ce:	00 00                	add    %al,(%rax)
  8032d0:	e3 0d                	jrcxz  8032df <__rodata_start+0x42f>
  8032d2:	80 00 00             	addb   $0x0,(%rax)
  8032d5:	00 00                	add    %al,(%rax)
  8032d7:	00 e3                	add    %ah,%bl
  8032d9:	0d 80 00 00 00       	or     $0x80,%eax
  8032de:	00 00                	add    %al,(%rax)
  8032e0:	e3 0d                	jrcxz  8032ef <__rodata_start+0x43f>
  8032e2:	80 00 00             	addb   $0x0,(%rax)
  8032e5:	00 00                	add    %al,(%rax)
  8032e7:	00 e3                	add    %ah,%bl
  8032e9:	0d 80 00 00 00       	or     $0x80,%eax
  8032ee:	00 00                	add    %al,(%rax)
  8032f0:	e3 0d                	jrcxz  8032ff <__rodata_start+0x44f>
  8032f2:	80 00 00             	addb   $0x0,(%rax)
  8032f5:	00 00                	add    %al,(%rax)
  8032f7:	00 e3                	add    %ah,%bl
  8032f9:	0d 80 00 00 00       	or     $0x80,%eax
  8032fe:	00 00                	add    %al,(%rax)
  803300:	e3 0d                	jrcxz  80330f <__rodata_start+0x45f>
  803302:	80 00 00             	addb   $0x0,(%rax)
  803305:	00 00                	add    %al,(%rax)
  803307:	00 e3                	add    %ah,%bl
  803309:	0d 80 00 00 00       	or     $0x80,%eax
  80330e:	00 00                	add    %al,(%rax)
  803310:	e3 0d                	jrcxz  80331f <__rodata_start+0x46f>
  803312:	80 00 00             	addb   $0x0,(%rax)
  803315:	00 00                	add    %al,(%rax)
  803317:	00 e3                	add    %ah,%bl
  803319:	0d 80 00 00 00       	or     $0x80,%eax
  80331e:	00 00                	add    %al,(%rax)
  803320:	e3 0d                	jrcxz  80332f <__rodata_start+0x47f>
  803322:	80 00 00             	addb   $0x0,(%rax)
  803325:	00 00                	add    %al,(%rax)
  803327:	00 08                	add    %cl,(%rax)
  803329:	0d 80 00 00 00       	or     $0x80,%eax
  80332e:	00 00                	add    %al,(%rax)
  803330:	e3 0d                	jrcxz  80333f <__rodata_start+0x48f>
  803332:	80 00 00             	addb   $0x0,(%rax)
  803335:	00 00                	add    %al,(%rax)
  803337:	00 e3                	add    %ah,%bl
  803339:	0d 80 00 00 00       	or     $0x80,%eax
  80333e:	00 00                	add    %al,(%rax)
  803340:	e3 0d                	jrcxz  80334f <__rodata_start+0x49f>
  803342:	80 00 00             	addb   $0x0,(%rax)
  803345:	00 00                	add    %al,(%rax)
  803347:	00 e3                	add    %ah,%bl
  803349:	0d 80 00 00 00       	or     $0x80,%eax
  80334e:	00 00                	add    %al,(%rax)
  803350:	e3 0d                	jrcxz  80335f <__rodata_start+0x4af>
  803352:	80 00 00             	addb   $0x0,(%rax)
  803355:	00 00                	add    %al,(%rax)
  803357:	00 e3                	add    %ah,%bl
  803359:	0d 80 00 00 00       	or     $0x80,%eax
  80335e:	00 00                	add    %al,(%rax)
  803360:	e3 0d                	jrcxz  80336f <__rodata_start+0x4bf>
  803362:	80 00 00             	addb   $0x0,(%rax)
  803365:	00 00                	add    %al,(%rax)
  803367:	00 e3                	add    %ah,%bl
  803369:	0d 80 00 00 00       	or     $0x80,%eax
  80336e:	00 00                	add    %al,(%rax)
  803370:	e3 0d                	jrcxz  80337f <__rodata_start+0x4cf>
  803372:	80 00 00             	addb   $0x0,(%rax)
  803375:	00 00                	add    %al,(%rax)
  803377:	00 e3                	add    %ah,%bl
  803379:	0d 80 00 00 00       	or     $0x80,%eax
  80337e:	00 00                	add    %al,(%rax)
  803380:	34 08                	xor    $0x8,%al
  803382:	80 00 00             	addb   $0x0,(%rax)
  803385:	00 00                	add    %al,(%rax)
  803387:	00 2a                	add    %ch,(%rdx)
  803389:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80338f:	00 e3                	add    %ah,%bl
  803391:	0d 80 00 00 00       	or     $0x80,%eax
  803396:	00 00                	add    %al,(%rax)
  803398:	e3 0d                	jrcxz  8033a7 <__rodata_start+0x4f7>
  80339a:	80 00 00             	addb   $0x0,(%rax)
  80339d:	00 00                	add    %al,(%rax)
  80339f:	00 e3                	add    %ah,%bl
  8033a1:	0d 80 00 00 00       	or     $0x80,%eax
  8033a6:	00 00                	add    %al,(%rax)
  8033a8:	e3 0d                	jrcxz  8033b7 <__rodata_start+0x507>
  8033aa:	80 00 00             	addb   $0x0,(%rax)
  8033ad:	00 00                	add    %al,(%rax)
  8033af:	00 62 08             	add    %ah,0x8(%rdx)
  8033b2:	80 00 00             	addb   $0x0,(%rax)
  8033b5:	00 00                	add    %al,(%rax)
  8033b7:	00 e3                	add    %ah,%bl
  8033b9:	0d 80 00 00 00       	or     $0x80,%eax
  8033be:	00 00                	add    %al,(%rax)
  8033c0:	e3 0d                	jrcxz  8033cf <__rodata_start+0x51f>
  8033c2:	80 00 00             	addb   $0x0,(%rax)
  8033c5:	00 00                	add    %al,(%rax)
  8033c7:	00 29                	add    %ch,(%rcx)
  8033c9:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  8033cf:	00 e3                	add    %ah,%bl
  8033d1:	0d 80 00 00 00       	or     $0x80,%eax
  8033d6:	00 00                	add    %al,(%rax)
  8033d8:	e3 0d                	jrcxz  8033e7 <__rodata_start+0x537>
  8033da:	80 00 00             	addb   $0x0,(%rax)
  8033dd:	00 00                	add    %al,(%rax)
  8033df:	00 ca                	add    %cl,%dl
  8033e1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8033e7:	00 92 0c 80 00 00    	add    %dl,0x800c(%rdx)
  8033ed:	00 00                	add    %al,(%rax)
  8033ef:	00 e3                	add    %ah,%bl
  8033f1:	0d 80 00 00 00       	or     $0x80,%eax
  8033f6:	00 00                	add    %al,(%rax)
  8033f8:	e3 0d                	jrcxz  803407 <__rodata_start+0x557>
  8033fa:	80 00 00             	addb   $0x0,(%rax)
  8033fd:	00 00                	add    %al,(%rax)
  8033ff:	00 fa                	add    %bh,%dl
  803401:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  803407:	00 e3                	add    %ah,%bl
  803409:	0d 80 00 00 00       	or     $0x80,%eax
  80340e:	00 00                	add    %al,(%rax)
  803410:	fc                   	cld    
  803411:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803417:	00 e3                	add    %ah,%bl
  803419:	0d 80 00 00 00       	or     $0x80,%eax
  80341e:	00 00                	add    %al,(%rax)
  803420:	e3 0d                	jrcxz  80342f <__rodata_start+0x57f>
  803422:	80 00 00             	addb   $0x0,(%rax)
  803425:	00 00                	add    %al,(%rax)
  803427:	00 08                	add    %cl,(%rax)
  803429:	0d 80 00 00 00       	or     $0x80,%eax
  80342e:	00 00                	add    %al,(%rax)
  803430:	e3 0d                	jrcxz  80343f <__rodata_start+0x58f>
  803432:	80 00 00             	addb   $0x0,(%rax)
  803435:	00 00                	add    %al,(%rax)
  803437:	00 98 07 80 00 00    	add    %bl,0x8007(%rax)
  80343d:	00 00                	add    %al,(%rax)
	...

0000000000803440 <error_string>:
	...
  803448:	1d 30 80 00 00 00 00 00 2f 30 80 00 00 00 00 00     .0....../0......
  803458:	3f 30 80 00 00 00 00 00 51 30 80 00 00 00 00 00     ?0......Q0......
  803468:	5f 30 80 00 00 00 00 00 73 30 80 00 00 00 00 00     _0......s0......
  803478:	88 30 80 00 00 00 00 00 9b 30 80 00 00 00 00 00     .0.......0......
  803488:	ad 30 80 00 00 00 00 00 c1 30 80 00 00 00 00 00     .0.......0......
  803498:	d1 30 80 00 00 00 00 00 e4 30 80 00 00 00 00 00     .0.......0......
  8034a8:	fb 30 80 00 00 00 00 00 11 31 80 00 00 00 00 00     .0.......1......
  8034b8:	29 31 80 00 00 00 00 00 41 31 80 00 00 00 00 00     )1......A1......
  8034c8:	4e 31 80 00 00 00 00 00 e0 34 80 00 00 00 00 00     N1.......4......
  8034d8:	62 31 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     b1......file is 
  8034e8:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  8034f8:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803508:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803518:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803528:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  803538:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  803548:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  803558:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  803568:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  803578:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  803588:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  803598:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  8035a8:	6c 6c 3a 20 25 69 00 90 5b 25 30 38 78 5d 20 75     ll: %i..[%08x] u
  8035b8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  8035c8:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  8035d8:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  8035e8:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  8035f8:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803608:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803618:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803628:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803638:	84 00 00 00 00 00 66 90                             ......f.

0000000000803640 <devtab>:
  803640:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803650:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803660:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  803670:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803680:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  803690:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  8036a0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  8036b0:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  8036c0:	69 70 63 5f 73 65 6e 64 20 65 72 72 6f 72 3a 20     ipc_send error: 
  8036d0:	25 69 00 6c 69 62 2f 69 70 63 2e 63 00 66 2e 0f     %i.lib/ipc.c.f..
  8036e0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8036f0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803700:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803710:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803720:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803730:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803740:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803750:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803760:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803770:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803780:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803790:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8037a0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8037b0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8037c0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8037d0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8037e0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8037f0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803800:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803810:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803820:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803830:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803840:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803850:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803860:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803870:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803880:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803890:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8038a0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8038b0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8038c0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8038d0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8038e0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8038f0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803900:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803910:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803920:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803930:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803940:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803950:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803960:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803970:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803980:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803990:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8039a0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8039b0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8039c0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8039d0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8039e0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8039f0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803a00:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a10:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a20:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a30:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a40:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803a50:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a60:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a70:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a80:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a90:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803aa0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ab0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ac0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ad0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ae0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803af0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b00:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b10:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b20:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b30:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b40:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b50:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b60:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b70:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b80:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b90:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ba0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803bb0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803bc0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803bd0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803be0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803bf0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c00:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c10:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c20:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c30:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c40:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c50:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c60:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c70:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c80:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c90:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ca0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803cb0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803cc0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803cd0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ce0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803cf0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d00:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d10:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d20:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d30:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d40:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d50:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d60:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d70:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d80:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d90:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803da0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803db0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803dc0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803dd0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803de0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803df0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e00:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e10:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e20:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e30:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e40:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e50:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e60:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e70:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e80:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e90:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ea0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803eb0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ec0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ed0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ee0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ef0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f00:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f10:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f20:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f30:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f40:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f50:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f60:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f70:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f80:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f90:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803fa0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803fb0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803fc0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803fd0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803fe0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ff0:	1f 84 00 00 00 00 00 66 0f 1f 84 00 00 00 00 00     .......f........
