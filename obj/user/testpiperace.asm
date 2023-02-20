
obj/user/testpiperace:     file format elf64-x86-64


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
  80001e:	e8 41 03 00 00       	call   800364 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 57                	push   %r15
  80002b:	41 56                	push   %r14
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 83 ec 28          	sub    $0x28,%rsp
    int p[2], r, pid, i, max;
    void *va;
    struct Fd *fd;
    const volatile struct Env *kid;

    cprintf("testing for dup race...\n");
  800036:	48 bf a0 2e 80 00 00 	movabs $0x802ea0,%rdi
  80003d:	00 00 00 
  800040:	b8 00 00 00 00       	mov    $0x0,%eax
  800045:	48 ba 85 05 80 00 00 	movabs $0x800585,%rdx
  80004c:	00 00 00 
  80004f:	ff d2                	call   *%rdx
    if ((r = pipe(p)) < 0)
  800051:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  800055:	48 b8 04 28 80 00 00 	movabs $0x802804,%rax
  80005c:	00 00 00 
  80005f:	ff d0                	call   *%rax
  800061:	85 c0                	test   %eax,%eax
  800063:	0f 88 99 01 00 00    	js     800202 <umain+0x1dd>
        panic("pipe: %i", r);
    max = 200;
    if ((r = fork()) < 0)
  800069:	48 b8 e5 17 80 00 00 	movabs $0x8017e5,%rax
  800070:	00 00 00 
  800073:	ff d0                	call   *%rax
  800075:	89 45 bc             	mov    %eax,-0x44(%rbp)
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 88 af 01 00 00    	js     80022f <umain+0x20a>
        panic("fork: %i", r);
    if (r == 0) {
  800080:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  800084:	0f 84 d2 01 00 00    	je     80025c <umain+0x237>
        }
        /* do something to be not runnable besides exiting */
        ipc_recv(0, 0, 0, 0);
    }
    pid = r;
    cprintf("pid is %d\n", pid);
  80008a:	8b 5d bc             	mov    -0x44(%rbp),%ebx
  80008d:	89 de                	mov    %ebx,%esi
  80008f:	48 bf f1 2e 80 00 00 	movabs $0x802ef1,%rdi
  800096:	00 00 00 
  800099:	b8 00 00 00 00       	mov    $0x0,%eax
  80009e:	49 be 85 05 80 00 00 	movabs $0x800585,%r14
  8000a5:	00 00 00 
  8000a8:	41 ff d6             	call   *%r14
    va = 0;
    kid = &envs[ENVX(pid)];
  8000ab:	41 89 dd             	mov    %ebx,%r13d
  8000ae:	41 81 e5 ff 03 00 00 	and    $0x3ff,%r13d
    cprintf("kid is %d\n", (int32_t)(kid - envs));
  8000b5:	41 89 dc             	mov    %ebx,%r12d
  8000b8:	41 81 e4 ff 03 00 00 	and    $0x3ff,%r12d
  8000bf:	4b 8d 1c e4          	lea    (%r12,%r12,8),%rbx
  8000c3:	48 01 db             	add    %rbx,%rbx
  8000c6:	4a 8d 34 23          	lea    (%rbx,%r12,1),%rsi
  8000ca:	48 b8 1b ca 6b 28 af 	movabs $0x86bca1af286bca1b,%rax
  8000d1:	a1 bc 86 
  8000d4:	48 0f af f0          	imul   %rax,%rsi
  8000d8:	48 bf fc 2e 80 00 00 	movabs $0x802efc,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	41 ff d6             	call   *%r14
    dup(p[0], 10);
  8000ea:	be 0a 00 00 00       	mov    $0xa,%esi
  8000ef:	8b 7d c8             	mov    -0x38(%rbp),%edi
  8000f2:	48 b8 8e 1d 80 00 00 	movabs $0x801d8e,%rax
  8000f9:	00 00 00 
  8000fc:	ff d0                	call   *%rax
    while (kid->env_status == ENV_RUNNABLE)
  8000fe:	4c 01 e3             	add    %r12,%rbx
  800101:	48 c1 e3 04          	shl    $0x4,%rbx
  800105:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  80010c:	00 00 00 
  80010f:	48 01 c3             	add    %rax,%rbx
  800112:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
  800118:	83 f8 02             	cmp    $0x2,%eax
  80011b:	75 41                	jne    80015e <umain+0x139>
        dup(p[0], 10);
  80011d:	49 bc 8e 1d 80 00 00 	movabs $0x801d8e,%r12
  800124:	00 00 00 
    while (kid->env_status == ENV_RUNNABLE)
  800127:	4d 63 ed             	movslq %r13d,%r13
  80012a:	4b 8d 44 ed 00       	lea    0x0(%r13,%r13,8),%rax
  80012f:	49 8d 5c 45 00       	lea    0x0(%r13,%rax,2),%rbx
  800134:	48 89 d8             	mov    %rbx,%rax
  800137:	48 c1 e0 04          	shl    $0x4,%rax
  80013b:	48 bb 00 00 c0 1f 80 	movabs $0x801fc00000,%rbx
  800142:	00 00 00 
  800145:	48 01 c3             	add    %rax,%rbx
        dup(p[0], 10);
  800148:	be 0a 00 00 00       	mov    $0xa,%esi
  80014d:	8b 7d c8             	mov    -0x38(%rbp),%edi
  800150:	41 ff d4             	call   *%r12
    while (kid->env_status == ENV_RUNNABLE)
  800153:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
  800159:	83 f8 02             	cmp    $0x2,%eax
  80015c:	74 ea                	je     800148 <umain+0x123>

    cprintf("child done with loop\n");
  80015e:	48 bf 07 2f 80 00 00 	movabs $0x802f07,%rdi
  800165:	00 00 00 
  800168:	b8 00 00 00 00       	mov    $0x0,%eax
  80016d:	48 ba 85 05 80 00 00 	movabs $0x800585,%rdx
  800174:	00 00 00 
  800177:	ff d2                	call   *%rdx
    if (pipeisclosed(p[0]))
  800179:	8b 7d c8             	mov    -0x38(%rbp),%edi
  80017c:	48 b8 10 2a 80 00 00 	movabs $0x802a10,%rax
  800183:	00 00 00 
  800186:	ff d0                	call   *%rax
  800188:	85 c0                	test   %eax,%eax
  80018a:	0f 85 58 01 00 00    	jne    8002e8 <umain+0x2c3>
        panic("somehow the other end of p[0] got closed!");
    if ((r = fd_lookup(p[0], &fd)) < 0)
  800190:	48 8d 75 c0          	lea    -0x40(%rbp),%rsi
  800194:	8b 7d c8             	mov    -0x38(%rbp),%edi
  800197:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  80019e:	00 00 00 
  8001a1:	ff d0                	call   *%rax
  8001a3:	85 c0                	test   %eax,%eax
  8001a5:	0f 88 67 01 00 00    	js     800312 <umain+0x2ed>
        panic("cannot look up p[0]: %i", r);
    va = fd2data(fd);
  8001ab:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
  8001af:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  8001b6:	00 00 00 
  8001b9:	ff d0                	call   *%rax
  8001bb:	48 89 c7             	mov    %rax,%rdi
    if (sys_region_refs(va, PAGE_SIZE) != 3 + 1)
  8001be:	be 00 10 00 00       	mov    $0x1000,%esi
  8001c3:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	call   *%rax
  8001cf:	83 f8 04             	cmp    $0x4,%eax
  8001d2:	0f 84 67 01 00 00    	je     80033f <umain+0x31a>
        cprintf("\nchild detected race\n");
  8001d8:	48 bf 35 2f 80 00 00 	movabs $0x802f35,%rdi
  8001df:	00 00 00 
  8001e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e7:	48 ba 85 05 80 00 00 	movabs $0x800585,%rdx
  8001ee:	00 00 00 
  8001f1:	ff d2                	call   *%rdx
    else
        cprintf("\nrace didn't happen (number of tests: %d)\n", max);
}
  8001f3:	48 83 c4 28          	add    $0x28,%rsp
  8001f7:	5b                   	pop    %rbx
  8001f8:	41 5c                	pop    %r12
  8001fa:	41 5d                	pop    %r13
  8001fc:	41 5e                	pop    %r14
  8001fe:	41 5f                	pop    %r15
  800200:	5d                   	pop    %rbp
  800201:	c3                   	ret    
        panic("pipe: %i", r);
  800202:	89 c1                	mov    %eax,%ecx
  800204:	48 ba b9 2e 80 00 00 	movabs $0x802eb9,%rdx
  80020b:	00 00 00 
  80020e:	be 0c 00 00 00       	mov    $0xc,%esi
  800213:	48 bf c2 2e 80 00 00 	movabs $0x802ec2,%rdi
  80021a:	00 00 00 
  80021d:	b8 00 00 00 00       	mov    $0x0,%eax
  800222:	49 b8 35 04 80 00 00 	movabs $0x800435,%r8
  800229:	00 00 00 
  80022c:	41 ff d0             	call   *%r8
        panic("fork: %i", r);
  80022f:	89 c1                	mov    %eax,%ecx
  800231:	48 ba 34 35 80 00 00 	movabs $0x803534,%rdx
  800238:	00 00 00 
  80023b:	be 0f 00 00 00       	mov    $0xf,%esi
  800240:	48 bf c2 2e 80 00 00 	movabs $0x802ec2,%rdi
  800247:	00 00 00 
  80024a:	b8 00 00 00 00       	mov    $0x0,%eax
  80024f:	49 b8 35 04 80 00 00 	movabs $0x800435,%r8
  800256:	00 00 00 
  800259:	41 ff d0             	call   *%r8
        close(p[1]);
  80025c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80025f:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  800266:	00 00 00 
  800269:	ff d0                	call   *%rax
  80026b:	bb c8 00 00 00       	mov    $0xc8,%ebx
            if (pipeisclosed(p[0])) {
  800270:	49 bd 10 2a 80 00 00 	movabs $0x802a10,%r13
  800277:	00 00 00 
                cprintf("RACE: pipe appears closed\n");
  80027a:	49 bf 85 05 80 00 00 	movabs $0x800585,%r15
  800281:	00 00 00 
                exit();
  800284:	49 be 12 04 80 00 00 	movabs $0x800412,%r14
  80028b:	00 00 00 
            sys_yield();
  80028e:	49 bc f1 13 80 00 00 	movabs $0x8013f1,%r12
  800295:	00 00 00 
  800298:	eb 08                	jmp    8002a2 <umain+0x27d>
  80029a:	41 ff d4             	call   *%r12
        for (i = 0; i < max; i++) {
  80029d:	83 eb 01             	sub    $0x1,%ebx
  8002a0:	74 21                	je     8002c3 <umain+0x29e>
            if (pipeisclosed(p[0])) {
  8002a2:	8b 7d c8             	mov    -0x38(%rbp),%edi
  8002a5:	41 ff d5             	call   *%r13
  8002a8:	85 c0                	test   %eax,%eax
  8002aa:	74 ee                	je     80029a <umain+0x275>
                cprintf("RACE: pipe appears closed\n");
  8002ac:	48 bf d6 2e 80 00 00 	movabs $0x802ed6,%rdi
  8002b3:	00 00 00 
  8002b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002bb:	41 ff d7             	call   *%r15
                exit();
  8002be:	41 ff d6             	call   *%r14
  8002c1:	eb d7                	jmp    80029a <umain+0x275>
        ipc_recv(0, 0, 0, 0);
  8002c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002cd:	be 00 00 00 00       	mov    $0x0,%esi
  8002d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8002d7:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	call   *%rax
  8002e3:	e9 a2 fd ff ff       	jmp    80008a <umain+0x65>
        panic("somehow the other end of p[0] got closed!");
  8002e8:	48 ba 50 2f 80 00 00 	movabs $0x802f50,%rdx
  8002ef:	00 00 00 
  8002f2:	be 38 00 00 00       	mov    $0x38,%esi
  8002f7:	48 bf c2 2e 80 00 00 	movabs $0x802ec2,%rdi
  8002fe:	00 00 00 
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	48 b9 35 04 80 00 00 	movabs $0x800435,%rcx
  80030d:	00 00 00 
  800310:	ff d1                	call   *%rcx
        panic("cannot look up p[0]: %i", r);
  800312:	89 c1                	mov    %eax,%ecx
  800314:	48 ba 1d 2f 80 00 00 	movabs $0x802f1d,%rdx
  80031b:	00 00 00 
  80031e:	be 3a 00 00 00       	mov    $0x3a,%esi
  800323:	48 bf c2 2e 80 00 00 	movabs $0x802ec2,%rdi
  80032a:	00 00 00 
  80032d:	b8 00 00 00 00       	mov    $0x0,%eax
  800332:	49 b8 35 04 80 00 00 	movabs $0x800435,%r8
  800339:	00 00 00 
  80033c:	41 ff d0             	call   *%r8
        cprintf("\nrace didn't happen (number of tests: %d)\n", max);
  80033f:	be c8 00 00 00       	mov    $0xc8,%esi
  800344:	48 bf 80 2f 80 00 00 	movabs $0x802f80,%rdi
  80034b:	00 00 00 
  80034e:	b8 00 00 00 00       	mov    $0x0,%eax
  800353:	48 ba 85 05 80 00 00 	movabs $0x800585,%rdx
  80035a:	00 00 00 
  80035d:	ff d2                	call   *%rdx
}
  80035f:	e9 8f fe ff ff       	jmp    8001f3 <umain+0x1ce>

0000000000800364 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800364:	55                   	push   %rbp
  800365:	48 89 e5             	mov    %rsp,%rbp
  800368:	41 56                	push   %r14
  80036a:	41 55                	push   %r13
  80036c:	41 54                	push   %r12
  80036e:	53                   	push   %rbx
  80036f:	41 89 fd             	mov    %edi,%r13d
  800372:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800375:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80037c:	00 00 00 
  80037f:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800386:	00 00 00 
  800389:	48 39 c2             	cmp    %rax,%rdx
  80038c:	73 17                	jae    8003a5 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80038e:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800391:	49 89 c4             	mov    %rax,%r12
  800394:	48 83 c3 08          	add    $0x8,%rbx
  800398:	b8 00 00 00 00       	mov    $0x0,%eax
  80039d:	ff 53 f8             	call   *-0x8(%rbx)
  8003a0:	4c 39 e3             	cmp    %r12,%rbx
  8003a3:	72 ef                	jb     800394 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8003a5:	48 b8 c0 13 80 00 00 	movabs $0x8013c0,%rax
  8003ac:	00 00 00 
  8003af:	ff d0                	call   *%rax
  8003b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003b6:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8003ba:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8003be:	48 c1 e0 04          	shl    $0x4,%rax
  8003c2:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8003c9:	00 00 00 
  8003cc:	48 01 d0             	add    %rdx,%rax
  8003cf:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8003d6:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8003d9:	45 85 ed             	test   %r13d,%r13d
  8003dc:	7e 0d                	jle    8003eb <libmain+0x87>
  8003de:	49 8b 06             	mov    (%r14),%rax
  8003e1:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8003e8:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8003eb:	4c 89 f6             	mov    %r14,%rsi
  8003ee:	44 89 ef             	mov    %r13d,%edi
  8003f1:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8003f8:	00 00 00 
  8003fb:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8003fd:	48 b8 12 04 80 00 00 	movabs $0x800412,%rax
  800404:	00 00 00 
  800407:	ff d0                	call   *%rax
#endif
}
  800409:	5b                   	pop    %rbx
  80040a:	41 5c                	pop    %r12
  80040c:	41 5d                	pop    %r13
  80040e:	41 5e                	pop    %r14
  800410:	5d                   	pop    %rbp
  800411:	c3                   	ret    

0000000000800412 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800412:	55                   	push   %rbp
  800413:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800416:	48 b8 66 1d 80 00 00 	movabs $0x801d66,%rax
  80041d:	00 00 00 
  800420:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800422:	bf 00 00 00 00       	mov    $0x0,%edi
  800427:	48 b8 55 13 80 00 00 	movabs $0x801355,%rax
  80042e:	00 00 00 
  800431:	ff d0                	call   *%rax
}
  800433:	5d                   	pop    %rbp
  800434:	c3                   	ret    

0000000000800435 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800435:	55                   	push   %rbp
  800436:	48 89 e5             	mov    %rsp,%rbp
  800439:	41 56                	push   %r14
  80043b:	41 55                	push   %r13
  80043d:	41 54                	push   %r12
  80043f:	53                   	push   %rbx
  800440:	48 83 ec 50          	sub    $0x50,%rsp
  800444:	49 89 fc             	mov    %rdi,%r12
  800447:	41 89 f5             	mov    %esi,%r13d
  80044a:	48 89 d3             	mov    %rdx,%rbx
  80044d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800451:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800455:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800459:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800460:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800464:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800468:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80046c:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800470:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800477:	00 00 00 
  80047a:	4c 8b 30             	mov    (%rax),%r14
  80047d:	48 b8 c0 13 80 00 00 	movabs $0x8013c0,%rax
  800484:	00 00 00 
  800487:	ff d0                	call   *%rax
  800489:	89 c6                	mov    %eax,%esi
  80048b:	45 89 e8             	mov    %r13d,%r8d
  80048e:	4c 89 e1             	mov    %r12,%rcx
  800491:	4c 89 f2             	mov    %r14,%rdx
  800494:	48 bf b8 2f 80 00 00 	movabs $0x802fb8,%rdi
  80049b:	00 00 00 
  80049e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a3:	49 bc 85 05 80 00 00 	movabs $0x800585,%r12
  8004aa:	00 00 00 
  8004ad:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8004b0:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8004b4:	48 89 df             	mov    %rbx,%rdi
  8004b7:	48 b8 21 05 80 00 00 	movabs $0x800521,%rax
  8004be:	00 00 00 
  8004c1:	ff d0                	call   *%rax
    cprintf("\n");
  8004c3:	48 bf b7 2e 80 00 00 	movabs $0x802eb7,%rdi
  8004ca:	00 00 00 
  8004cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d2:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8004d5:	cc                   	int3   
  8004d6:	eb fd                	jmp    8004d5 <_panic+0xa0>

00000000008004d8 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8004d8:	55                   	push   %rbp
  8004d9:	48 89 e5             	mov    %rsp,%rbp
  8004dc:	53                   	push   %rbx
  8004dd:	48 83 ec 08          	sub    $0x8,%rsp
  8004e1:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8004e4:	8b 06                	mov    (%rsi),%eax
  8004e6:	8d 50 01             	lea    0x1(%rax),%edx
  8004e9:	89 16                	mov    %edx,(%rsi)
  8004eb:	48 98                	cltq   
  8004ed:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8004f2:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8004f8:	74 0a                	je     800504 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8004fa:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8004fe:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800502:	c9                   	leave  
  800503:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800504:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800508:	be ff 00 00 00       	mov    $0xff,%esi
  80050d:	48 b8 f7 12 80 00 00 	movabs $0x8012f7,%rax
  800514:	00 00 00 
  800517:	ff d0                	call   *%rax
        state->offset = 0;
  800519:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80051f:	eb d9                	jmp    8004fa <putch+0x22>

0000000000800521 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800521:	55                   	push   %rbp
  800522:	48 89 e5             	mov    %rsp,%rbp
  800525:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80052c:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80052f:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800536:	b9 21 00 00 00       	mov    $0x21,%ecx
  80053b:	b8 00 00 00 00       	mov    $0x0,%eax
  800540:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800543:	48 89 f1             	mov    %rsi,%rcx
  800546:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80054d:	48 bf d8 04 80 00 00 	movabs $0x8004d8,%rdi
  800554:	00 00 00 
  800557:	48 b8 d5 06 80 00 00 	movabs $0x8006d5,%rax
  80055e:	00 00 00 
  800561:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800563:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80056a:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800571:	48 b8 f7 12 80 00 00 	movabs $0x8012f7,%rax
  800578:	00 00 00 
  80057b:	ff d0                	call   *%rax

    return state.count;
}
  80057d:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800583:	c9                   	leave  
  800584:	c3                   	ret    

0000000000800585 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800585:	55                   	push   %rbp
  800586:	48 89 e5             	mov    %rsp,%rbp
  800589:	48 83 ec 50          	sub    $0x50,%rsp
  80058d:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800591:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800595:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800599:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80059d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8005a1:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8005a8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005ac:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005b0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8005b4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8005b8:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8005bc:	48 b8 21 05 80 00 00 	movabs $0x800521,%rax
  8005c3:	00 00 00 
  8005c6:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

00000000008005ca <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8005ca:	55                   	push   %rbp
  8005cb:	48 89 e5             	mov    %rsp,%rbp
  8005ce:	41 57                	push   %r15
  8005d0:	41 56                	push   %r14
  8005d2:	41 55                	push   %r13
  8005d4:	41 54                	push   %r12
  8005d6:	53                   	push   %rbx
  8005d7:	48 83 ec 18          	sub    $0x18,%rsp
  8005db:	49 89 fc             	mov    %rdi,%r12
  8005de:	49 89 f5             	mov    %rsi,%r13
  8005e1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8005e5:	8b 45 10             	mov    0x10(%rbp),%eax
  8005e8:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8005eb:	41 89 cf             	mov    %ecx,%r15d
  8005ee:	49 39 d7             	cmp    %rdx,%r15
  8005f1:	76 5b                	jbe    80064e <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8005f3:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8005f7:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8005fb:	85 db                	test   %ebx,%ebx
  8005fd:	7e 0e                	jle    80060d <print_num+0x43>
            putch(padc, put_arg);
  8005ff:	4c 89 ee             	mov    %r13,%rsi
  800602:	44 89 f7             	mov    %r14d,%edi
  800605:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800608:	83 eb 01             	sub    $0x1,%ebx
  80060b:	75 f2                	jne    8005ff <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  80060d:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800611:	48 b9 db 2f 80 00 00 	movabs $0x802fdb,%rcx
  800618:	00 00 00 
  80061b:	48 b8 ec 2f 80 00 00 	movabs $0x802fec,%rax
  800622:	00 00 00 
  800625:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800629:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80062d:	ba 00 00 00 00       	mov    $0x0,%edx
  800632:	49 f7 f7             	div    %r15
  800635:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800639:	4c 89 ee             	mov    %r13,%rsi
  80063c:	41 ff d4             	call   *%r12
}
  80063f:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800643:	5b                   	pop    %rbx
  800644:	41 5c                	pop    %r12
  800646:	41 5d                	pop    %r13
  800648:	41 5e                	pop    %r14
  80064a:	41 5f                	pop    %r15
  80064c:	5d                   	pop    %rbp
  80064d:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  80064e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800652:	ba 00 00 00 00       	mov    $0x0,%edx
  800657:	49 f7 f7             	div    %r15
  80065a:	48 83 ec 08          	sub    $0x8,%rsp
  80065e:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800662:	52                   	push   %rdx
  800663:	45 0f be c9          	movsbl %r9b,%r9d
  800667:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80066b:	48 89 c2             	mov    %rax,%rdx
  80066e:	48 b8 ca 05 80 00 00 	movabs $0x8005ca,%rax
  800675:	00 00 00 
  800678:	ff d0                	call   *%rax
  80067a:	48 83 c4 10          	add    $0x10,%rsp
  80067e:	eb 8d                	jmp    80060d <print_num+0x43>

0000000000800680 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800680:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800684:	48 8b 06             	mov    (%rsi),%rax
  800687:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80068b:	73 0a                	jae    800697 <sprintputch+0x17>
        *state->start++ = ch;
  80068d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800691:	48 89 16             	mov    %rdx,(%rsi)
  800694:	40 88 38             	mov    %dil,(%rax)
    }
}
  800697:	c3                   	ret    

0000000000800698 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800698:	55                   	push   %rbp
  800699:	48 89 e5             	mov    %rsp,%rbp
  80069c:	48 83 ec 50          	sub    $0x50,%rsp
  8006a0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8006a4:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8006a8:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8006ac:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8006b3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006b7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006bb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8006bf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8006c3:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8006c7:	48 b8 d5 06 80 00 00 	movabs $0x8006d5,%rax
  8006ce:	00 00 00 
  8006d1:	ff d0                	call   *%rax
}
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    

00000000008006d5 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8006d5:	55                   	push   %rbp
  8006d6:	48 89 e5             	mov    %rsp,%rbp
  8006d9:	41 57                	push   %r15
  8006db:	41 56                	push   %r14
  8006dd:	41 55                	push   %r13
  8006df:	41 54                	push   %r12
  8006e1:	53                   	push   %rbx
  8006e2:	48 83 ec 48          	sub    $0x48,%rsp
  8006e6:	49 89 fc             	mov    %rdi,%r12
  8006e9:	49 89 f6             	mov    %rsi,%r14
  8006ec:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  8006ef:	48 8b 01             	mov    (%rcx),%rax
  8006f2:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8006f6:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8006fa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006fe:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800702:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800706:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  80070a:	41 0f b6 3f          	movzbl (%r15),%edi
  80070e:	40 80 ff 25          	cmp    $0x25,%dil
  800712:	74 18                	je     80072c <vprintfmt+0x57>
            if (!ch) return;
  800714:	40 84 ff             	test   %dil,%dil
  800717:	0f 84 d1 06 00 00    	je     800dee <vprintfmt+0x719>
            putch(ch, put_arg);
  80071d:	40 0f b6 ff          	movzbl %dil,%edi
  800721:	4c 89 f6             	mov    %r14,%rsi
  800724:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800727:	49 89 df             	mov    %rbx,%r15
  80072a:	eb da                	jmp    800706 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  80072c:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800730:	b9 00 00 00 00       	mov    $0x0,%ecx
  800735:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  800739:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  80073e:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800744:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80074b:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  80074f:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800754:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  80075a:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  80075e:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800762:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800766:	3c 57                	cmp    $0x57,%al
  800768:	0f 87 65 06 00 00    	ja     800dd3 <vprintfmt+0x6fe>
  80076e:	0f b6 c0             	movzbl %al,%eax
  800771:	49 ba 80 31 80 00 00 	movabs $0x803180,%r10
  800778:	00 00 00 
  80077b:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  80077f:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800782:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800786:	eb d2                	jmp    80075a <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  800788:	4c 89 fb             	mov    %r15,%rbx
  80078b:	44 89 c1             	mov    %r8d,%ecx
  80078e:	eb ca                	jmp    80075a <vprintfmt+0x85>
            padc = ch;
  800790:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800794:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800797:	eb c1                	jmp    80075a <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800799:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079c:	83 f8 2f             	cmp    $0x2f,%eax
  80079f:	77 24                	ja     8007c5 <vprintfmt+0xf0>
  8007a1:	41 89 c1             	mov    %eax,%r9d
  8007a4:	49 01 f1             	add    %rsi,%r9
  8007a7:	83 c0 08             	add    $0x8,%eax
  8007aa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ad:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8007b0:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8007b3:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8007b7:	79 a1                	jns    80075a <vprintfmt+0x85>
                width = precision;
  8007b9:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  8007bd:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8007c3:	eb 95                	jmp    80075a <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8007c5:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8007c9:	49 8d 41 08          	lea    0x8(%r9),%rax
  8007cd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007d1:	eb da                	jmp    8007ad <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8007d3:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8007d7:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8007db:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8007df:	3c 39                	cmp    $0x39,%al
  8007e1:	77 1e                	ja     800801 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8007e3:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  8007e7:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  8007ec:	0f b6 c0             	movzbl %al,%eax
  8007ef:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8007f4:	41 0f b6 07          	movzbl (%r15),%eax
  8007f8:	3c 39                	cmp    $0x39,%al
  8007fa:	76 e7                	jbe    8007e3 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  8007fc:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  8007ff:	eb b2                	jmp    8007b3 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800801:	4c 89 fb             	mov    %r15,%rbx
  800804:	eb ad                	jmp    8007b3 <vprintfmt+0xde>
            width = MAX(0, width);
  800806:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800809:	85 c0                	test   %eax,%eax
  80080b:	0f 48 c7             	cmovs  %edi,%eax
  80080e:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800811:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800814:	e9 41 ff ff ff       	jmp    80075a <vprintfmt+0x85>
            lflag++;
  800819:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80081c:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80081f:	e9 36 ff ff ff       	jmp    80075a <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800824:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800827:	83 f8 2f             	cmp    $0x2f,%eax
  80082a:	77 18                	ja     800844 <vprintfmt+0x16f>
  80082c:	89 c2                	mov    %eax,%edx
  80082e:	48 01 f2             	add    %rsi,%rdx
  800831:	83 c0 08             	add    $0x8,%eax
  800834:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800837:	4c 89 f6             	mov    %r14,%rsi
  80083a:	8b 3a                	mov    (%rdx),%edi
  80083c:	41 ff d4             	call   *%r12
            break;
  80083f:	e9 c2 fe ff ff       	jmp    800706 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800844:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800848:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80084c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800850:	eb e5                	jmp    800837 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800852:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800855:	83 f8 2f             	cmp    $0x2f,%eax
  800858:	77 5b                	ja     8008b5 <vprintfmt+0x1e0>
  80085a:	89 c2                	mov    %eax,%edx
  80085c:	48 01 d6             	add    %rdx,%rsi
  80085f:	83 c0 08             	add    $0x8,%eax
  800862:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800865:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800867:	89 c8                	mov    %ecx,%eax
  800869:	c1 f8 1f             	sar    $0x1f,%eax
  80086c:	31 c1                	xor    %eax,%ecx
  80086e:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800870:	83 f9 13             	cmp    $0x13,%ecx
  800873:	7f 4e                	jg     8008c3 <vprintfmt+0x1ee>
  800875:	48 63 c1             	movslq %ecx,%rax
  800878:	48 ba 40 34 80 00 00 	movabs $0x803440,%rdx
  80087f:	00 00 00 
  800882:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800886:	48 85 c0             	test   %rax,%rax
  800889:	74 38                	je     8008c3 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  80088b:	48 89 c1             	mov    %rax,%rcx
  80088e:	48 ba 99 36 80 00 00 	movabs $0x803699,%rdx
  800895:	00 00 00 
  800898:	4c 89 f6             	mov    %r14,%rsi
  80089b:	4c 89 e7             	mov    %r12,%rdi
  80089e:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a3:	49 b8 98 06 80 00 00 	movabs $0x800698,%r8
  8008aa:	00 00 00 
  8008ad:	41 ff d0             	call   *%r8
  8008b0:	e9 51 fe ff ff       	jmp    800706 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8008b5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008b9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008bd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008c1:	eb a2                	jmp    800865 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8008c3:	48 ba 04 30 80 00 00 	movabs $0x803004,%rdx
  8008ca:	00 00 00 
  8008cd:	4c 89 f6             	mov    %r14,%rsi
  8008d0:	4c 89 e7             	mov    %r12,%rdi
  8008d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d8:	49 b8 98 06 80 00 00 	movabs $0x800698,%r8
  8008df:	00 00 00 
  8008e2:	41 ff d0             	call   *%r8
  8008e5:	e9 1c fe ff ff       	jmp    800706 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  8008ea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ed:	83 f8 2f             	cmp    $0x2f,%eax
  8008f0:	77 55                	ja     800947 <vprintfmt+0x272>
  8008f2:	89 c2                	mov    %eax,%edx
  8008f4:	48 01 d6             	add    %rdx,%rsi
  8008f7:	83 c0 08             	add    $0x8,%eax
  8008fa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008fd:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800900:	48 85 d2             	test   %rdx,%rdx
  800903:	48 b8 fd 2f 80 00 00 	movabs $0x802ffd,%rax
  80090a:	00 00 00 
  80090d:	48 0f 45 c2          	cmovne %rdx,%rax
  800911:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800915:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800919:	7e 06                	jle    800921 <vprintfmt+0x24c>
  80091b:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  80091f:	75 34                	jne    800955 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800921:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800925:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800929:	0f b6 00             	movzbl (%rax),%eax
  80092c:	84 c0                	test   %al,%al
  80092e:	0f 84 b2 00 00 00    	je     8009e6 <vprintfmt+0x311>
  800934:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  800938:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  80093d:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800941:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800945:	eb 74                	jmp    8009bb <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  800947:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80094b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80094f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800953:	eb a8                	jmp    8008fd <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800955:	49 63 f5             	movslq %r13d,%rsi
  800958:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  80095c:	48 b8 a8 0e 80 00 00 	movabs $0x800ea8,%rax
  800963:	00 00 00 
  800966:	ff d0                	call   *%rax
  800968:	48 89 c2             	mov    %rax,%rdx
  80096b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80096e:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800970:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800973:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800976:	85 c0                	test   %eax,%eax
  800978:	7e a7                	jle    800921 <vprintfmt+0x24c>
  80097a:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  80097e:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800982:	41 89 cd             	mov    %ecx,%r13d
  800985:	4c 89 f6             	mov    %r14,%rsi
  800988:	89 df                	mov    %ebx,%edi
  80098a:	41 ff d4             	call   *%r12
  80098d:	41 83 ed 01          	sub    $0x1,%r13d
  800991:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800995:	75 ee                	jne    800985 <vprintfmt+0x2b0>
  800997:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  80099b:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  80099f:	eb 80                	jmp    800921 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8009a1:	0f b6 f8             	movzbl %al,%edi
  8009a4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009a8:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8009ab:	41 83 ef 01          	sub    $0x1,%r15d
  8009af:	48 83 c3 01          	add    $0x1,%rbx
  8009b3:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8009b7:	84 c0                	test   %al,%al
  8009b9:	74 1f                	je     8009da <vprintfmt+0x305>
  8009bb:	45 85 ed             	test   %r13d,%r13d
  8009be:	78 06                	js     8009c6 <vprintfmt+0x2f1>
  8009c0:	41 83 ed 01          	sub    $0x1,%r13d
  8009c4:	78 46                	js     800a0c <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8009c6:	45 84 f6             	test   %r14b,%r14b
  8009c9:	74 d6                	je     8009a1 <vprintfmt+0x2cc>
  8009cb:	8d 50 e0             	lea    -0x20(%rax),%edx
  8009ce:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009d3:	80 fa 5e             	cmp    $0x5e,%dl
  8009d6:	77 cc                	ja     8009a4 <vprintfmt+0x2cf>
  8009d8:	eb c7                	jmp    8009a1 <vprintfmt+0x2cc>
  8009da:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8009de:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8009e2:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  8009e6:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8009e9:	8d 58 ff             	lea    -0x1(%rax),%ebx
  8009ec:	85 c0                	test   %eax,%eax
  8009ee:	0f 8e 12 fd ff ff    	jle    800706 <vprintfmt+0x31>
  8009f4:	4c 89 f6             	mov    %r14,%rsi
  8009f7:	bf 20 00 00 00       	mov    $0x20,%edi
  8009fc:	41 ff d4             	call   *%r12
  8009ff:	83 eb 01             	sub    $0x1,%ebx
  800a02:	83 fb ff             	cmp    $0xffffffff,%ebx
  800a05:	75 ed                	jne    8009f4 <vprintfmt+0x31f>
  800a07:	e9 fa fc ff ff       	jmp    800706 <vprintfmt+0x31>
  800a0c:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800a10:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800a14:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  800a18:	eb cc                	jmp    8009e6 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800a1a:	45 89 cd             	mov    %r9d,%r13d
  800a1d:	84 c9                	test   %cl,%cl
  800a1f:	75 25                	jne    800a46 <vprintfmt+0x371>
    switch (lflag) {
  800a21:	85 d2                	test   %edx,%edx
  800a23:	74 57                	je     800a7c <vprintfmt+0x3a7>
  800a25:	83 fa 01             	cmp    $0x1,%edx
  800a28:	74 78                	je     800aa2 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800a2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2d:	83 f8 2f             	cmp    $0x2f,%eax
  800a30:	0f 87 92 00 00 00    	ja     800ac8 <vprintfmt+0x3f3>
  800a36:	89 c2                	mov    %eax,%edx
  800a38:	48 01 d6             	add    %rdx,%rsi
  800a3b:	83 c0 08             	add    $0x8,%eax
  800a3e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a41:	48 8b 1e             	mov    (%rsi),%rbx
  800a44:	eb 16                	jmp    800a5c <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800a46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a49:	83 f8 2f             	cmp    $0x2f,%eax
  800a4c:	77 20                	ja     800a6e <vprintfmt+0x399>
  800a4e:	89 c2                	mov    %eax,%edx
  800a50:	48 01 d6             	add    %rdx,%rsi
  800a53:	83 c0 08             	add    $0x8,%eax
  800a56:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a59:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800a5c:	48 85 db             	test   %rbx,%rbx
  800a5f:	78 78                	js     800ad9 <vprintfmt+0x404>
            num = i;
  800a61:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800a64:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800a69:	e9 49 02 00 00       	jmp    800cb7 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a6e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a72:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a76:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a7a:	eb dd                	jmp    800a59 <vprintfmt+0x384>
        return va_arg(*ap, int);
  800a7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7f:	83 f8 2f             	cmp    $0x2f,%eax
  800a82:	77 10                	ja     800a94 <vprintfmt+0x3bf>
  800a84:	89 c2                	mov    %eax,%edx
  800a86:	48 01 d6             	add    %rdx,%rsi
  800a89:	83 c0 08             	add    $0x8,%eax
  800a8c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a8f:	48 63 1e             	movslq (%rsi),%rbx
  800a92:	eb c8                	jmp    800a5c <vprintfmt+0x387>
  800a94:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a98:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a9c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aa0:	eb ed                	jmp    800a8f <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800aa2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa5:	83 f8 2f             	cmp    $0x2f,%eax
  800aa8:	77 10                	ja     800aba <vprintfmt+0x3e5>
  800aaa:	89 c2                	mov    %eax,%edx
  800aac:	48 01 d6             	add    %rdx,%rsi
  800aaf:	83 c0 08             	add    $0x8,%eax
  800ab2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ab5:	48 8b 1e             	mov    (%rsi),%rbx
  800ab8:	eb a2                	jmp    800a5c <vprintfmt+0x387>
  800aba:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800abe:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ac2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac6:	eb ed                	jmp    800ab5 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800ac8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800acc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ad0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad4:	e9 68 ff ff ff       	jmp    800a41 <vprintfmt+0x36c>
                putch('-', put_arg);
  800ad9:	4c 89 f6             	mov    %r14,%rsi
  800adc:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ae1:	41 ff d4             	call   *%r12
                i = -i;
  800ae4:	48 f7 db             	neg    %rbx
  800ae7:	e9 75 ff ff ff       	jmp    800a61 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800aec:	45 89 cd             	mov    %r9d,%r13d
  800aef:	84 c9                	test   %cl,%cl
  800af1:	75 2d                	jne    800b20 <vprintfmt+0x44b>
    switch (lflag) {
  800af3:	85 d2                	test   %edx,%edx
  800af5:	74 57                	je     800b4e <vprintfmt+0x479>
  800af7:	83 fa 01             	cmp    $0x1,%edx
  800afa:	74 7f                	je     800b7b <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800afc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aff:	83 f8 2f             	cmp    $0x2f,%eax
  800b02:	0f 87 a1 00 00 00    	ja     800ba9 <vprintfmt+0x4d4>
  800b08:	89 c2                	mov    %eax,%edx
  800b0a:	48 01 d6             	add    %rdx,%rsi
  800b0d:	83 c0 08             	add    $0x8,%eax
  800b10:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b13:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800b16:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800b1b:	e9 97 01 00 00       	jmp    800cb7 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b20:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b23:	83 f8 2f             	cmp    $0x2f,%eax
  800b26:	77 18                	ja     800b40 <vprintfmt+0x46b>
  800b28:	89 c2                	mov    %eax,%edx
  800b2a:	48 01 d6             	add    %rdx,%rsi
  800b2d:	83 c0 08             	add    $0x8,%eax
  800b30:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b33:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800b36:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b3b:	e9 77 01 00 00       	jmp    800cb7 <vprintfmt+0x5e2>
  800b40:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b44:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b48:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b4c:	eb e5                	jmp    800b33 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800b4e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b51:	83 f8 2f             	cmp    $0x2f,%eax
  800b54:	77 17                	ja     800b6d <vprintfmt+0x498>
  800b56:	89 c2                	mov    %eax,%edx
  800b58:	48 01 d6             	add    %rdx,%rsi
  800b5b:	83 c0 08             	add    $0x8,%eax
  800b5e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b61:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800b63:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800b68:	e9 4a 01 00 00       	jmp    800cb7 <vprintfmt+0x5e2>
  800b6d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b71:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b75:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b79:	eb e6                	jmp    800b61 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800b7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7e:	83 f8 2f             	cmp    $0x2f,%eax
  800b81:	77 18                	ja     800b9b <vprintfmt+0x4c6>
  800b83:	89 c2                	mov    %eax,%edx
  800b85:	48 01 d6             	add    %rdx,%rsi
  800b88:	83 c0 08             	add    $0x8,%eax
  800b8b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b8e:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800b91:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800b96:	e9 1c 01 00 00       	jmp    800cb7 <vprintfmt+0x5e2>
  800b9b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b9f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ba3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba7:	eb e5                	jmp    800b8e <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800ba9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bad:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bb1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb5:	e9 59 ff ff ff       	jmp    800b13 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800bba:	45 89 cd             	mov    %r9d,%r13d
  800bbd:	84 c9                	test   %cl,%cl
  800bbf:	75 2d                	jne    800bee <vprintfmt+0x519>
    switch (lflag) {
  800bc1:	85 d2                	test   %edx,%edx
  800bc3:	74 57                	je     800c1c <vprintfmt+0x547>
  800bc5:	83 fa 01             	cmp    $0x1,%edx
  800bc8:	74 7c                	je     800c46 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800bca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcd:	83 f8 2f             	cmp    $0x2f,%eax
  800bd0:	0f 87 9b 00 00 00    	ja     800c71 <vprintfmt+0x59c>
  800bd6:	89 c2                	mov    %eax,%edx
  800bd8:	48 01 d6             	add    %rdx,%rsi
  800bdb:	83 c0 08             	add    $0x8,%eax
  800bde:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800be1:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800be4:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800be9:	e9 c9 00 00 00       	jmp    800cb7 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800bee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf1:	83 f8 2f             	cmp    $0x2f,%eax
  800bf4:	77 18                	ja     800c0e <vprintfmt+0x539>
  800bf6:	89 c2                	mov    %eax,%edx
  800bf8:	48 01 d6             	add    %rdx,%rsi
  800bfb:	83 c0 08             	add    $0x8,%eax
  800bfe:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c01:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800c04:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c09:	e9 a9 00 00 00       	jmp    800cb7 <vprintfmt+0x5e2>
  800c0e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c12:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c16:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c1a:	eb e5                	jmp    800c01 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800c1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c1f:	83 f8 2f             	cmp    $0x2f,%eax
  800c22:	77 14                	ja     800c38 <vprintfmt+0x563>
  800c24:	89 c2                	mov    %eax,%edx
  800c26:	48 01 d6             	add    %rdx,%rsi
  800c29:	83 c0 08             	add    $0x8,%eax
  800c2c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c2f:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800c31:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800c36:	eb 7f                	jmp    800cb7 <vprintfmt+0x5e2>
  800c38:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c3c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c40:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c44:	eb e9                	jmp    800c2f <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800c46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c49:	83 f8 2f             	cmp    $0x2f,%eax
  800c4c:	77 15                	ja     800c63 <vprintfmt+0x58e>
  800c4e:	89 c2                	mov    %eax,%edx
  800c50:	48 01 d6             	add    %rdx,%rsi
  800c53:	83 c0 08             	add    $0x8,%eax
  800c56:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c59:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800c5c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800c61:	eb 54                	jmp    800cb7 <vprintfmt+0x5e2>
  800c63:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c67:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c6b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c6f:	eb e8                	jmp    800c59 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800c71:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c75:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c79:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c7d:	e9 5f ff ff ff       	jmp    800be1 <vprintfmt+0x50c>
            putch('0', put_arg);
  800c82:	45 89 cd             	mov    %r9d,%r13d
  800c85:	4c 89 f6             	mov    %r14,%rsi
  800c88:	bf 30 00 00 00       	mov    $0x30,%edi
  800c8d:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800c90:	4c 89 f6             	mov    %r14,%rsi
  800c93:	bf 78 00 00 00       	mov    $0x78,%edi
  800c98:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800c9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9e:	83 f8 2f             	cmp    $0x2f,%eax
  800ca1:	77 47                	ja     800cea <vprintfmt+0x615>
  800ca3:	89 c2                	mov    %eax,%edx
  800ca5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ca9:	83 c0 08             	add    $0x8,%eax
  800cac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800caf:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800cb2:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800cb7:	48 83 ec 08          	sub    $0x8,%rsp
  800cbb:	41 80 fd 58          	cmp    $0x58,%r13b
  800cbf:	0f 94 c0             	sete   %al
  800cc2:	0f b6 c0             	movzbl %al,%eax
  800cc5:	50                   	push   %rax
  800cc6:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800ccb:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800ccf:	4c 89 f6             	mov    %r14,%rsi
  800cd2:	4c 89 e7             	mov    %r12,%rdi
  800cd5:	48 b8 ca 05 80 00 00 	movabs $0x8005ca,%rax
  800cdc:	00 00 00 
  800cdf:	ff d0                	call   *%rax
            break;
  800ce1:	48 83 c4 10          	add    $0x10,%rsp
  800ce5:	e9 1c fa ff ff       	jmp    800706 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800cea:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cee:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cf2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cf6:	eb b7                	jmp    800caf <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800cf8:	45 89 cd             	mov    %r9d,%r13d
  800cfb:	84 c9                	test   %cl,%cl
  800cfd:	75 2a                	jne    800d29 <vprintfmt+0x654>
    switch (lflag) {
  800cff:	85 d2                	test   %edx,%edx
  800d01:	74 54                	je     800d57 <vprintfmt+0x682>
  800d03:	83 fa 01             	cmp    $0x1,%edx
  800d06:	74 7c                	je     800d84 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800d08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d0b:	83 f8 2f             	cmp    $0x2f,%eax
  800d0e:	0f 87 9e 00 00 00    	ja     800db2 <vprintfmt+0x6dd>
  800d14:	89 c2                	mov    %eax,%edx
  800d16:	48 01 d6             	add    %rdx,%rsi
  800d19:	83 c0 08             	add    $0x8,%eax
  800d1c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d1f:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800d22:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800d27:	eb 8e                	jmp    800cb7 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800d29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2c:	83 f8 2f             	cmp    $0x2f,%eax
  800d2f:	77 18                	ja     800d49 <vprintfmt+0x674>
  800d31:	89 c2                	mov    %eax,%edx
  800d33:	48 01 d6             	add    %rdx,%rsi
  800d36:	83 c0 08             	add    $0x8,%eax
  800d39:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d3c:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800d3f:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800d44:	e9 6e ff ff ff       	jmp    800cb7 <vprintfmt+0x5e2>
  800d49:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d4d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d51:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d55:	eb e5                	jmp    800d3c <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800d57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d5a:	83 f8 2f             	cmp    $0x2f,%eax
  800d5d:	77 17                	ja     800d76 <vprintfmt+0x6a1>
  800d5f:	89 c2                	mov    %eax,%edx
  800d61:	48 01 d6             	add    %rdx,%rsi
  800d64:	83 c0 08             	add    $0x8,%eax
  800d67:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d6a:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800d6c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800d71:	e9 41 ff ff ff       	jmp    800cb7 <vprintfmt+0x5e2>
  800d76:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d7a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d7e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d82:	eb e6                	jmp    800d6a <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800d84:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d87:	83 f8 2f             	cmp    $0x2f,%eax
  800d8a:	77 18                	ja     800da4 <vprintfmt+0x6cf>
  800d8c:	89 c2                	mov    %eax,%edx
  800d8e:	48 01 d6             	add    %rdx,%rsi
  800d91:	83 c0 08             	add    $0x8,%eax
  800d94:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d97:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800d9a:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800d9f:	e9 13 ff ff ff       	jmp    800cb7 <vprintfmt+0x5e2>
  800da4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800da8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800dac:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800db0:	eb e5                	jmp    800d97 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800db2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800db6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800dba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dbe:	e9 5c ff ff ff       	jmp    800d1f <vprintfmt+0x64a>
            putch(ch, put_arg);
  800dc3:	4c 89 f6             	mov    %r14,%rsi
  800dc6:	bf 25 00 00 00       	mov    $0x25,%edi
  800dcb:	41 ff d4             	call   *%r12
            break;
  800dce:	e9 33 f9 ff ff       	jmp    800706 <vprintfmt+0x31>
            putch('%', put_arg);
  800dd3:	4c 89 f6             	mov    %r14,%rsi
  800dd6:	bf 25 00 00 00       	mov    $0x25,%edi
  800ddb:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800dde:	49 83 ef 01          	sub    $0x1,%r15
  800de2:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800de7:	75 f5                	jne    800dde <vprintfmt+0x709>
  800de9:	e9 18 f9 ff ff       	jmp    800706 <vprintfmt+0x31>
}
  800dee:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800df2:	5b                   	pop    %rbx
  800df3:	41 5c                	pop    %r12
  800df5:	41 5d                	pop    %r13
  800df7:	41 5e                	pop    %r14
  800df9:	41 5f                	pop    %r15
  800dfb:	5d                   	pop    %rbp
  800dfc:	c3                   	ret    

0000000000800dfd <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800dfd:	55                   	push   %rbp
  800dfe:	48 89 e5             	mov    %rsp,%rbp
  800e01:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800e05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e09:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800e0e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800e12:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800e19:	48 85 ff             	test   %rdi,%rdi
  800e1c:	74 2b                	je     800e49 <vsnprintf+0x4c>
  800e1e:	48 85 f6             	test   %rsi,%rsi
  800e21:	74 26                	je     800e49 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800e23:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800e27:	48 bf 80 06 80 00 00 	movabs $0x800680,%rdi
  800e2e:	00 00 00 
  800e31:	48 b8 d5 06 80 00 00 	movabs $0x8006d5,%rax
  800e38:	00 00 00 
  800e3b:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e41:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800e44:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800e47:	c9                   	leave  
  800e48:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800e49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e4e:	eb f7                	jmp    800e47 <vsnprintf+0x4a>

0000000000800e50 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800e50:	55                   	push   %rbp
  800e51:	48 89 e5             	mov    %rsp,%rbp
  800e54:	48 83 ec 50          	sub    $0x50,%rsp
  800e58:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e5c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800e60:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800e64:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800e6b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e6f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e73:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e77:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800e7b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800e7f:	48 b8 fd 0d 80 00 00 	movabs $0x800dfd,%rax
  800e86:	00 00 00 
  800e89:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

0000000000800e8d <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800e8d:	80 3f 00             	cmpb   $0x0,(%rdi)
  800e90:	74 10                	je     800ea2 <strlen+0x15>
    size_t n = 0;
  800e92:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800e97:	48 83 c0 01          	add    $0x1,%rax
  800e9b:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800e9f:	75 f6                	jne    800e97 <strlen+0xa>
  800ea1:	c3                   	ret    
    size_t n = 0;
  800ea2:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800ea7:	c3                   	ret    

0000000000800ea8 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800ea8:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800ead:	48 85 f6             	test   %rsi,%rsi
  800eb0:	74 10                	je     800ec2 <strnlen+0x1a>
  800eb2:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800eb6:	74 09                	je     800ec1 <strnlen+0x19>
  800eb8:	48 83 c0 01          	add    $0x1,%rax
  800ebc:	48 39 c6             	cmp    %rax,%rsi
  800ebf:	75 f1                	jne    800eb2 <strnlen+0xa>
    return n;
}
  800ec1:	c3                   	ret    
    size_t n = 0;
  800ec2:	48 89 f0             	mov    %rsi,%rax
  800ec5:	c3                   	ret    

0000000000800ec6 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecb:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800ecf:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800ed2:	48 83 c0 01          	add    $0x1,%rax
  800ed6:	84 d2                	test   %dl,%dl
  800ed8:	75 f1                	jne    800ecb <strcpy+0x5>
        ;
    return res;
}
  800eda:	48 89 f8             	mov    %rdi,%rax
  800edd:	c3                   	ret    

0000000000800ede <strcat>:

char *
strcat(char *dst, const char *src) {
  800ede:	55                   	push   %rbp
  800edf:	48 89 e5             	mov    %rsp,%rbp
  800ee2:	41 54                	push   %r12
  800ee4:	53                   	push   %rbx
  800ee5:	48 89 fb             	mov    %rdi,%rbx
  800ee8:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800eeb:	48 b8 8d 0e 80 00 00 	movabs $0x800e8d,%rax
  800ef2:	00 00 00 
  800ef5:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800ef7:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800efb:	4c 89 e6             	mov    %r12,%rsi
  800efe:	48 b8 c6 0e 80 00 00 	movabs $0x800ec6,%rax
  800f05:	00 00 00 
  800f08:	ff d0                	call   *%rax
    return dst;
}
  800f0a:	48 89 d8             	mov    %rbx,%rax
  800f0d:	5b                   	pop    %rbx
  800f0e:	41 5c                	pop    %r12
  800f10:	5d                   	pop    %rbp
  800f11:	c3                   	ret    

0000000000800f12 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800f12:	48 85 d2             	test   %rdx,%rdx
  800f15:	74 1d                	je     800f34 <strncpy+0x22>
  800f17:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800f1b:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800f1e:	48 83 c0 01          	add    $0x1,%rax
  800f22:	0f b6 16             	movzbl (%rsi),%edx
  800f25:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800f28:	80 fa 01             	cmp    $0x1,%dl
  800f2b:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800f2f:	48 39 c1             	cmp    %rax,%rcx
  800f32:	75 ea                	jne    800f1e <strncpy+0xc>
    }
    return ret;
}
  800f34:	48 89 f8             	mov    %rdi,%rax
  800f37:	c3                   	ret    

0000000000800f38 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800f38:	48 89 f8             	mov    %rdi,%rax
  800f3b:	48 85 d2             	test   %rdx,%rdx
  800f3e:	74 24                	je     800f64 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800f40:	48 83 ea 01          	sub    $0x1,%rdx
  800f44:	74 1b                	je     800f61 <strlcpy+0x29>
  800f46:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800f4a:	0f b6 16             	movzbl (%rsi),%edx
  800f4d:	84 d2                	test   %dl,%dl
  800f4f:	74 10                	je     800f61 <strlcpy+0x29>
            *dst++ = *src++;
  800f51:	48 83 c6 01          	add    $0x1,%rsi
  800f55:	48 83 c0 01          	add    $0x1,%rax
  800f59:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800f5c:	48 39 c8             	cmp    %rcx,%rax
  800f5f:	75 e9                	jne    800f4a <strlcpy+0x12>
        *dst = '\0';
  800f61:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800f64:	48 29 f8             	sub    %rdi,%rax
}
  800f67:	c3                   	ret    

0000000000800f68 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800f68:	0f b6 07             	movzbl (%rdi),%eax
  800f6b:	84 c0                	test   %al,%al
  800f6d:	74 13                	je     800f82 <strcmp+0x1a>
  800f6f:	38 06                	cmp    %al,(%rsi)
  800f71:	75 0f                	jne    800f82 <strcmp+0x1a>
  800f73:	48 83 c7 01          	add    $0x1,%rdi
  800f77:	48 83 c6 01          	add    $0x1,%rsi
  800f7b:	0f b6 07             	movzbl (%rdi),%eax
  800f7e:	84 c0                	test   %al,%al
  800f80:	75 ed                	jne    800f6f <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800f82:	0f b6 c0             	movzbl %al,%eax
  800f85:	0f b6 16             	movzbl (%rsi),%edx
  800f88:	29 d0                	sub    %edx,%eax
}
  800f8a:	c3                   	ret    

0000000000800f8b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800f8b:	48 85 d2             	test   %rdx,%rdx
  800f8e:	74 1f                	je     800faf <strncmp+0x24>
  800f90:	0f b6 07             	movzbl (%rdi),%eax
  800f93:	84 c0                	test   %al,%al
  800f95:	74 1e                	je     800fb5 <strncmp+0x2a>
  800f97:	3a 06                	cmp    (%rsi),%al
  800f99:	75 1a                	jne    800fb5 <strncmp+0x2a>
  800f9b:	48 83 c7 01          	add    $0x1,%rdi
  800f9f:	48 83 c6 01          	add    $0x1,%rsi
  800fa3:	48 83 ea 01          	sub    $0x1,%rdx
  800fa7:	75 e7                	jne    800f90 <strncmp+0x5>

    if (!n) return 0;
  800fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fae:	c3                   	ret    
  800faf:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb4:	c3                   	ret    
  800fb5:	48 85 d2             	test   %rdx,%rdx
  800fb8:	74 09                	je     800fc3 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800fba:	0f b6 07             	movzbl (%rdi),%eax
  800fbd:	0f b6 16             	movzbl (%rsi),%edx
  800fc0:	29 d0                	sub    %edx,%eax
  800fc2:	c3                   	ret    
    if (!n) return 0;
  800fc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc8:	c3                   	ret    

0000000000800fc9 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800fc9:	0f b6 07             	movzbl (%rdi),%eax
  800fcc:	84 c0                	test   %al,%al
  800fce:	74 18                	je     800fe8 <strchr+0x1f>
        if (*str == c) {
  800fd0:	0f be c0             	movsbl %al,%eax
  800fd3:	39 f0                	cmp    %esi,%eax
  800fd5:	74 17                	je     800fee <strchr+0x25>
    for (; *str; str++) {
  800fd7:	48 83 c7 01          	add    $0x1,%rdi
  800fdb:	0f b6 07             	movzbl (%rdi),%eax
  800fde:	84 c0                	test   %al,%al
  800fe0:	75 ee                	jne    800fd0 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe7:	c3                   	ret    
  800fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fed:	c3                   	ret    
  800fee:	48 89 f8             	mov    %rdi,%rax
}
  800ff1:	c3                   	ret    

0000000000800ff2 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800ff2:	0f b6 07             	movzbl (%rdi),%eax
  800ff5:	84 c0                	test   %al,%al
  800ff7:	74 16                	je     80100f <strfind+0x1d>
  800ff9:	0f be c0             	movsbl %al,%eax
  800ffc:	39 f0                	cmp    %esi,%eax
  800ffe:	74 13                	je     801013 <strfind+0x21>
  801000:	48 83 c7 01          	add    $0x1,%rdi
  801004:	0f b6 07             	movzbl (%rdi),%eax
  801007:	84 c0                	test   %al,%al
  801009:	75 ee                	jne    800ff9 <strfind+0x7>
  80100b:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  80100e:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  80100f:	48 89 f8             	mov    %rdi,%rax
  801012:	c3                   	ret    
  801013:	48 89 f8             	mov    %rdi,%rax
  801016:	c3                   	ret    

0000000000801017 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  801017:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80101a:	48 89 f8             	mov    %rdi,%rax
  80101d:	48 f7 d8             	neg    %rax
  801020:	83 e0 07             	and    $0x7,%eax
  801023:	49 89 d1             	mov    %rdx,%r9
  801026:	49 29 c1             	sub    %rax,%r9
  801029:	78 32                	js     80105d <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80102b:	40 0f b6 c6          	movzbl %sil,%eax
  80102f:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  801036:	01 01 01 
  801039:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80103d:	40 f6 c7 07          	test   $0x7,%dil
  801041:	75 34                	jne    801077 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  801043:	4c 89 c9             	mov    %r9,%rcx
  801046:	48 c1 f9 03          	sar    $0x3,%rcx
  80104a:	74 08                	je     801054 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80104c:	fc                   	cld    
  80104d:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  801050:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801054:	4d 85 c9             	test   %r9,%r9
  801057:	75 45                	jne    80109e <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  801059:	4c 89 c0             	mov    %r8,%rax
  80105c:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  80105d:	48 85 d2             	test   %rdx,%rdx
  801060:	74 f7                	je     801059 <memset+0x42>
  801062:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801065:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  801068:	48 83 c0 01          	add    $0x1,%rax
  80106c:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  801070:	48 39 c2             	cmp    %rax,%rdx
  801073:	75 f3                	jne    801068 <memset+0x51>
  801075:	eb e2                	jmp    801059 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801077:	40 f6 c7 01          	test   $0x1,%dil
  80107b:	74 06                	je     801083 <memset+0x6c>
  80107d:	88 07                	mov    %al,(%rdi)
  80107f:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801083:	40 f6 c7 02          	test   $0x2,%dil
  801087:	74 07                	je     801090 <memset+0x79>
  801089:	66 89 07             	mov    %ax,(%rdi)
  80108c:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801090:	40 f6 c7 04          	test   $0x4,%dil
  801094:	74 ad                	je     801043 <memset+0x2c>
  801096:	89 07                	mov    %eax,(%rdi)
  801098:	48 83 c7 04          	add    $0x4,%rdi
  80109c:	eb a5                	jmp    801043 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  80109e:	41 f6 c1 04          	test   $0x4,%r9b
  8010a2:	74 06                	je     8010aa <memset+0x93>
  8010a4:	89 07                	mov    %eax,(%rdi)
  8010a6:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8010aa:	41 f6 c1 02          	test   $0x2,%r9b
  8010ae:	74 07                	je     8010b7 <memset+0xa0>
  8010b0:	66 89 07             	mov    %ax,(%rdi)
  8010b3:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8010b7:	41 f6 c1 01          	test   $0x1,%r9b
  8010bb:	74 9c                	je     801059 <memset+0x42>
  8010bd:	88 07                	mov    %al,(%rdi)
  8010bf:	eb 98                	jmp    801059 <memset+0x42>

00000000008010c1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8010c1:	48 89 f8             	mov    %rdi,%rax
  8010c4:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8010c7:	48 39 fe             	cmp    %rdi,%rsi
  8010ca:	73 39                	jae    801105 <memmove+0x44>
  8010cc:	48 01 f2             	add    %rsi,%rdx
  8010cf:	48 39 fa             	cmp    %rdi,%rdx
  8010d2:	76 31                	jbe    801105 <memmove+0x44>
        s += n;
        d += n;
  8010d4:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8010d7:	48 89 d6             	mov    %rdx,%rsi
  8010da:	48 09 fe             	or     %rdi,%rsi
  8010dd:	48 09 ce             	or     %rcx,%rsi
  8010e0:	40 f6 c6 07          	test   $0x7,%sil
  8010e4:	75 12                	jne    8010f8 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8010e6:	48 83 ef 08          	sub    $0x8,%rdi
  8010ea:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8010ee:	48 c1 e9 03          	shr    $0x3,%rcx
  8010f2:	fd                   	std    
  8010f3:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8010f6:	fc                   	cld    
  8010f7:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8010f8:	48 83 ef 01          	sub    $0x1,%rdi
  8010fc:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  801100:	fd                   	std    
  801101:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801103:	eb f1                	jmp    8010f6 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801105:	48 89 f2             	mov    %rsi,%rdx
  801108:	48 09 c2             	or     %rax,%rdx
  80110b:	48 09 ca             	or     %rcx,%rdx
  80110e:	f6 c2 07             	test   $0x7,%dl
  801111:	75 0c                	jne    80111f <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801113:	48 c1 e9 03          	shr    $0x3,%rcx
  801117:	48 89 c7             	mov    %rax,%rdi
  80111a:	fc                   	cld    
  80111b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80111e:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80111f:	48 89 c7             	mov    %rax,%rdi
  801122:	fc                   	cld    
  801123:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801125:	c3                   	ret    

0000000000801126 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801126:	55                   	push   %rbp
  801127:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80112a:	48 b8 c1 10 80 00 00 	movabs $0x8010c1,%rax
  801131:	00 00 00 
  801134:	ff d0                	call   *%rax
}
  801136:	5d                   	pop    %rbp
  801137:	c3                   	ret    

0000000000801138 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801138:	55                   	push   %rbp
  801139:	48 89 e5             	mov    %rsp,%rbp
  80113c:	41 57                	push   %r15
  80113e:	41 56                	push   %r14
  801140:	41 55                	push   %r13
  801142:	41 54                	push   %r12
  801144:	53                   	push   %rbx
  801145:	48 83 ec 08          	sub    $0x8,%rsp
  801149:	49 89 fe             	mov    %rdi,%r14
  80114c:	49 89 f7             	mov    %rsi,%r15
  80114f:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801152:	48 89 f7             	mov    %rsi,%rdi
  801155:	48 b8 8d 0e 80 00 00 	movabs $0x800e8d,%rax
  80115c:	00 00 00 
  80115f:	ff d0                	call   *%rax
  801161:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801164:	48 89 de             	mov    %rbx,%rsi
  801167:	4c 89 f7             	mov    %r14,%rdi
  80116a:	48 b8 a8 0e 80 00 00 	movabs $0x800ea8,%rax
  801171:	00 00 00 
  801174:	ff d0                	call   *%rax
  801176:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801179:	48 39 c3             	cmp    %rax,%rbx
  80117c:	74 36                	je     8011b4 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  80117e:	48 89 d8             	mov    %rbx,%rax
  801181:	4c 29 e8             	sub    %r13,%rax
  801184:	4c 39 e0             	cmp    %r12,%rax
  801187:	76 30                	jbe    8011b9 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  801189:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  80118e:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801192:	4c 89 fe             	mov    %r15,%rsi
  801195:	48 b8 26 11 80 00 00 	movabs $0x801126,%rax
  80119c:	00 00 00 
  80119f:	ff d0                	call   *%rax
    return dstlen + srclen;
  8011a1:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8011a5:	48 83 c4 08          	add    $0x8,%rsp
  8011a9:	5b                   	pop    %rbx
  8011aa:	41 5c                	pop    %r12
  8011ac:	41 5d                	pop    %r13
  8011ae:	41 5e                	pop    %r14
  8011b0:	41 5f                	pop    %r15
  8011b2:	5d                   	pop    %rbp
  8011b3:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8011b4:	4c 01 e0             	add    %r12,%rax
  8011b7:	eb ec                	jmp    8011a5 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8011b9:	48 83 eb 01          	sub    $0x1,%rbx
  8011bd:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8011c1:	48 89 da             	mov    %rbx,%rdx
  8011c4:	4c 89 fe             	mov    %r15,%rsi
  8011c7:	48 b8 26 11 80 00 00 	movabs $0x801126,%rax
  8011ce:	00 00 00 
  8011d1:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8011d3:	49 01 de             	add    %rbx,%r14
  8011d6:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8011db:	eb c4                	jmp    8011a1 <strlcat+0x69>

00000000008011dd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8011dd:	49 89 f0             	mov    %rsi,%r8
  8011e0:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8011e3:	48 85 d2             	test   %rdx,%rdx
  8011e6:	74 2a                	je     801212 <memcmp+0x35>
  8011e8:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8011ed:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  8011f1:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  8011f6:	38 ca                	cmp    %cl,%dl
  8011f8:	75 0f                	jne    801209 <memcmp+0x2c>
    while (n-- > 0) {
  8011fa:	48 83 c0 01          	add    $0x1,%rax
  8011fe:	48 39 c6             	cmp    %rax,%rsi
  801201:	75 ea                	jne    8011ed <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801203:	b8 00 00 00 00       	mov    $0x0,%eax
  801208:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  801209:	0f b6 c2             	movzbl %dl,%eax
  80120c:	0f b6 c9             	movzbl %cl,%ecx
  80120f:	29 c8                	sub    %ecx,%eax
  801211:	c3                   	ret    
    return 0;
  801212:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801217:	c3                   	ret    

0000000000801218 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  801218:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80121c:	48 39 c7             	cmp    %rax,%rdi
  80121f:	73 0f                	jae    801230 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801221:	40 38 37             	cmp    %sil,(%rdi)
  801224:	74 0e                	je     801234 <memfind+0x1c>
    for (; src < end; src++) {
  801226:	48 83 c7 01          	add    $0x1,%rdi
  80122a:	48 39 f8             	cmp    %rdi,%rax
  80122d:	75 f2                	jne    801221 <memfind+0x9>
  80122f:	c3                   	ret    
  801230:	48 89 f8             	mov    %rdi,%rax
  801233:	c3                   	ret    
  801234:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801237:	c3                   	ret    

0000000000801238 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801238:	49 89 f2             	mov    %rsi,%r10
  80123b:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80123e:	0f b6 37             	movzbl (%rdi),%esi
  801241:	40 80 fe 20          	cmp    $0x20,%sil
  801245:	74 06                	je     80124d <strtol+0x15>
  801247:	40 80 fe 09          	cmp    $0x9,%sil
  80124b:	75 13                	jne    801260 <strtol+0x28>
  80124d:	48 83 c7 01          	add    $0x1,%rdi
  801251:	0f b6 37             	movzbl (%rdi),%esi
  801254:	40 80 fe 20          	cmp    $0x20,%sil
  801258:	74 f3                	je     80124d <strtol+0x15>
  80125a:	40 80 fe 09          	cmp    $0x9,%sil
  80125e:	74 ed                	je     80124d <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801260:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801263:	83 e0 fd             	and    $0xfffffffd,%eax
  801266:	3c 01                	cmp    $0x1,%al
  801268:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80126c:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801273:	75 11                	jne    801286 <strtol+0x4e>
  801275:	80 3f 30             	cmpb   $0x30,(%rdi)
  801278:	74 16                	je     801290 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80127a:	45 85 c0             	test   %r8d,%r8d
  80127d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801282:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  801286:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80128b:	4d 63 c8             	movslq %r8d,%r9
  80128e:	eb 38                	jmp    8012c8 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801290:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801294:	74 11                	je     8012a7 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  801296:	45 85 c0             	test   %r8d,%r8d
  801299:	75 eb                	jne    801286 <strtol+0x4e>
        s++;
  80129b:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  80129f:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8012a5:	eb df                	jmp    801286 <strtol+0x4e>
        s += 2;
  8012a7:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8012ab:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8012b1:	eb d3                	jmp    801286 <strtol+0x4e>
            dig -= '0';
  8012b3:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8012b6:	0f b6 c8             	movzbl %al,%ecx
  8012b9:	44 39 c1             	cmp    %r8d,%ecx
  8012bc:	7d 1f                	jge    8012dd <strtol+0xa5>
        val = val * base + dig;
  8012be:	49 0f af d1          	imul   %r9,%rdx
  8012c2:	0f b6 c0             	movzbl %al,%eax
  8012c5:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8012c8:	48 83 c7 01          	add    $0x1,%rdi
  8012cc:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8012d0:	3c 39                	cmp    $0x39,%al
  8012d2:	76 df                	jbe    8012b3 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8012d4:	3c 7b                	cmp    $0x7b,%al
  8012d6:	77 05                	ja     8012dd <strtol+0xa5>
            dig -= 'a' - 10;
  8012d8:	83 e8 57             	sub    $0x57,%eax
  8012db:	eb d9                	jmp    8012b6 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8012dd:	4d 85 d2             	test   %r10,%r10
  8012e0:	74 03                	je     8012e5 <strtol+0xad>
  8012e2:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8012e5:	48 89 d0             	mov    %rdx,%rax
  8012e8:	48 f7 d8             	neg    %rax
  8012eb:	40 80 fe 2d          	cmp    $0x2d,%sil
  8012ef:	48 0f 44 d0          	cmove  %rax,%rdx
}
  8012f3:	48 89 d0             	mov    %rdx,%rax
  8012f6:	c3                   	ret    

00000000008012f7 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8012f7:	55                   	push   %rbp
  8012f8:	48 89 e5             	mov    %rsp,%rbp
  8012fb:	53                   	push   %rbx
  8012fc:	48 89 fa             	mov    %rdi,%rdx
  8012ff:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801302:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801307:	bb 00 00 00 00       	mov    $0x0,%ebx
  80130c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801311:	be 00 00 00 00       	mov    $0x0,%esi
  801316:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80131c:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80131e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801322:	c9                   	leave  
  801323:	c3                   	ret    

0000000000801324 <sys_cgetc>:

int
sys_cgetc(void) {
  801324:	55                   	push   %rbp
  801325:	48 89 e5             	mov    %rsp,%rbp
  801328:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801329:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80132e:	ba 00 00 00 00       	mov    $0x0,%edx
  801333:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801338:	bb 00 00 00 00       	mov    $0x0,%ebx
  80133d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801342:	be 00 00 00 00       	mov    $0x0,%esi
  801347:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80134d:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80134f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801353:	c9                   	leave  
  801354:	c3                   	ret    

0000000000801355 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801355:	55                   	push   %rbp
  801356:	48 89 e5             	mov    %rsp,%rbp
  801359:	53                   	push   %rbx
  80135a:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80135e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801361:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801366:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80136b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801370:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801375:	be 00 00 00 00       	mov    $0x0,%esi
  80137a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801380:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801382:	48 85 c0             	test   %rax,%rax
  801385:	7f 06                	jg     80138d <sys_env_destroy+0x38>
}
  801387:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80138d:	49 89 c0             	mov    %rax,%r8
  801390:	b9 03 00 00 00       	mov    $0x3,%ecx
  801395:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  80139c:	00 00 00 
  80139f:	be 26 00 00 00       	mov    $0x26,%esi
  8013a4:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  8013ab:	00 00 00 
  8013ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b3:	49 b9 35 04 80 00 00 	movabs $0x800435,%r9
  8013ba:	00 00 00 
  8013bd:	41 ff d1             	call   *%r9

00000000008013c0 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8013c0:	55                   	push   %rbp
  8013c1:	48 89 e5             	mov    %rsp,%rbp
  8013c4:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013c5:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8013cf:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013de:	be 00 00 00 00       	mov    $0x0,%esi
  8013e3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013e9:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8013eb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

00000000008013f1 <sys_yield>:

void
sys_yield(void) {
  8013f1:	55                   	push   %rbp
  8013f2:	48 89 e5             	mov    %rsp,%rbp
  8013f5:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013f6:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801400:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801405:	bb 00 00 00 00       	mov    $0x0,%ebx
  80140a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80140f:	be 00 00 00 00       	mov    $0x0,%esi
  801414:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80141a:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80141c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801420:	c9                   	leave  
  801421:	c3                   	ret    

0000000000801422 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801422:	55                   	push   %rbp
  801423:	48 89 e5             	mov    %rsp,%rbp
  801426:	53                   	push   %rbx
  801427:	48 89 fa             	mov    %rdi,%rdx
  80142a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80142d:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801432:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801439:	00 00 00 
  80143c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801441:	be 00 00 00 00       	mov    $0x0,%esi
  801446:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80144c:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80144e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801452:	c9                   	leave  
  801453:	c3                   	ret    

0000000000801454 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801454:	55                   	push   %rbp
  801455:	48 89 e5             	mov    %rsp,%rbp
  801458:	53                   	push   %rbx
  801459:	49 89 f8             	mov    %rdi,%r8
  80145c:	48 89 d3             	mov    %rdx,%rbx
  80145f:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801462:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801467:	4c 89 c2             	mov    %r8,%rdx
  80146a:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80146d:	be 00 00 00 00       	mov    $0x0,%esi
  801472:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801478:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80147a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

0000000000801480 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801480:	55                   	push   %rbp
  801481:	48 89 e5             	mov    %rsp,%rbp
  801484:	53                   	push   %rbx
  801485:	48 83 ec 08          	sub    $0x8,%rsp
  801489:	89 f8                	mov    %edi,%eax
  80148b:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80148e:	48 63 f9             	movslq %ecx,%rdi
  801491:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801494:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801499:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80149c:	be 00 00 00 00       	mov    $0x0,%esi
  8014a1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014a7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014a9:	48 85 c0             	test   %rax,%rax
  8014ac:	7f 06                	jg     8014b4 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8014ae:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014b4:	49 89 c0             	mov    %rax,%r8
  8014b7:	b9 04 00 00 00       	mov    $0x4,%ecx
  8014bc:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  8014c3:	00 00 00 
  8014c6:	be 26 00 00 00       	mov    $0x26,%esi
  8014cb:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  8014d2:	00 00 00 
  8014d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014da:	49 b9 35 04 80 00 00 	movabs $0x800435,%r9
  8014e1:	00 00 00 
  8014e4:	41 ff d1             	call   *%r9

00000000008014e7 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8014e7:	55                   	push   %rbp
  8014e8:	48 89 e5             	mov    %rsp,%rbp
  8014eb:	53                   	push   %rbx
  8014ec:	48 83 ec 08          	sub    $0x8,%rsp
  8014f0:	89 f8                	mov    %edi,%eax
  8014f2:	49 89 f2             	mov    %rsi,%r10
  8014f5:	48 89 cf             	mov    %rcx,%rdi
  8014f8:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8014fb:	48 63 da             	movslq %edx,%rbx
  8014fe:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801501:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801506:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801509:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80150c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80150e:	48 85 c0             	test   %rax,%rax
  801511:	7f 06                	jg     801519 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801513:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801517:	c9                   	leave  
  801518:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801519:	49 89 c0             	mov    %rax,%r8
  80151c:	b9 05 00 00 00       	mov    $0x5,%ecx
  801521:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  801528:	00 00 00 
  80152b:	be 26 00 00 00       	mov    $0x26,%esi
  801530:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  801537:	00 00 00 
  80153a:	b8 00 00 00 00       	mov    $0x0,%eax
  80153f:	49 b9 35 04 80 00 00 	movabs $0x800435,%r9
  801546:	00 00 00 
  801549:	41 ff d1             	call   *%r9

000000000080154c <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80154c:	55                   	push   %rbp
  80154d:	48 89 e5             	mov    %rsp,%rbp
  801550:	53                   	push   %rbx
  801551:	48 83 ec 08          	sub    $0x8,%rsp
  801555:	48 89 f1             	mov    %rsi,%rcx
  801558:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80155b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80155e:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801563:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801568:	be 00 00 00 00       	mov    $0x0,%esi
  80156d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801573:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801575:	48 85 c0             	test   %rax,%rax
  801578:	7f 06                	jg     801580 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80157a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801580:	49 89 c0             	mov    %rax,%r8
  801583:	b9 06 00 00 00       	mov    $0x6,%ecx
  801588:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  80158f:	00 00 00 
  801592:	be 26 00 00 00       	mov    $0x26,%esi
  801597:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  80159e:	00 00 00 
  8015a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a6:	49 b9 35 04 80 00 00 	movabs $0x800435,%r9
  8015ad:	00 00 00 
  8015b0:	41 ff d1             	call   *%r9

00000000008015b3 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8015b3:	55                   	push   %rbp
  8015b4:	48 89 e5             	mov    %rsp,%rbp
  8015b7:	53                   	push   %rbx
  8015b8:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8015bc:	48 63 ce             	movslq %esi,%rcx
  8015bf:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015c2:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015cc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015d1:	be 00 00 00 00       	mov    $0x0,%esi
  8015d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015dc:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015de:	48 85 c0             	test   %rax,%rax
  8015e1:	7f 06                	jg     8015e9 <sys_env_set_status+0x36>
}
  8015e3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015e9:	49 89 c0             	mov    %rax,%r8
  8015ec:	b9 09 00 00 00       	mov    $0x9,%ecx
  8015f1:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  8015f8:	00 00 00 
  8015fb:	be 26 00 00 00       	mov    $0x26,%esi
  801600:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  801607:	00 00 00 
  80160a:	b8 00 00 00 00       	mov    $0x0,%eax
  80160f:	49 b9 35 04 80 00 00 	movabs $0x800435,%r9
  801616:	00 00 00 
  801619:	41 ff d1             	call   *%r9

000000000080161c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80161c:	55                   	push   %rbp
  80161d:	48 89 e5             	mov    %rsp,%rbp
  801620:	53                   	push   %rbx
  801621:	48 83 ec 08          	sub    $0x8,%rsp
  801625:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801628:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80162b:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801630:	bb 00 00 00 00       	mov    $0x0,%ebx
  801635:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80163a:	be 00 00 00 00       	mov    $0x0,%esi
  80163f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801645:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801647:	48 85 c0             	test   %rax,%rax
  80164a:	7f 06                	jg     801652 <sys_env_set_trapframe+0x36>
}
  80164c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801650:	c9                   	leave  
  801651:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801652:	49 89 c0             	mov    %rax,%r8
  801655:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80165a:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  801661:	00 00 00 
  801664:	be 26 00 00 00       	mov    $0x26,%esi
  801669:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  801670:	00 00 00 
  801673:	b8 00 00 00 00       	mov    $0x0,%eax
  801678:	49 b9 35 04 80 00 00 	movabs $0x800435,%r9
  80167f:	00 00 00 
  801682:	41 ff d1             	call   *%r9

0000000000801685 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801685:	55                   	push   %rbp
  801686:	48 89 e5             	mov    %rsp,%rbp
  801689:	53                   	push   %rbx
  80168a:	48 83 ec 08          	sub    $0x8,%rsp
  80168e:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801691:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801694:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801699:	bb 00 00 00 00       	mov    $0x0,%ebx
  80169e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016a3:	be 00 00 00 00       	mov    $0x0,%esi
  8016a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016ae:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016b0:	48 85 c0             	test   %rax,%rax
  8016b3:	7f 06                	jg     8016bb <sys_env_set_pgfault_upcall+0x36>
}
  8016b5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016bb:	49 89 c0             	mov    %rax,%r8
  8016be:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8016c3:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  8016ca:	00 00 00 
  8016cd:	be 26 00 00 00       	mov    $0x26,%esi
  8016d2:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  8016d9:	00 00 00 
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e1:	49 b9 35 04 80 00 00 	movabs $0x800435,%r9
  8016e8:	00 00 00 
  8016eb:	41 ff d1             	call   *%r9

00000000008016ee <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8016ee:	55                   	push   %rbp
  8016ef:	48 89 e5             	mov    %rsp,%rbp
  8016f2:	53                   	push   %rbx
  8016f3:	89 f8                	mov    %edi,%eax
  8016f5:	49 89 f1             	mov    %rsi,%r9
  8016f8:	48 89 d3             	mov    %rdx,%rbx
  8016fb:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8016fe:	49 63 f0             	movslq %r8d,%rsi
  801701:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801704:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801709:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80170c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801712:	cd 30                	int    $0x30
}
  801714:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801718:	c9                   	leave  
  801719:	c3                   	ret    

000000000080171a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80171a:	55                   	push   %rbp
  80171b:	48 89 e5             	mov    %rsp,%rbp
  80171e:	53                   	push   %rbx
  80171f:	48 83 ec 08          	sub    $0x8,%rsp
  801723:	48 89 fa             	mov    %rdi,%rdx
  801726:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801729:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80172e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801733:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801738:	be 00 00 00 00       	mov    $0x0,%esi
  80173d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801743:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801745:	48 85 c0             	test   %rax,%rax
  801748:	7f 06                	jg     801750 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80174a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801750:	49 89 c0             	mov    %rax,%r8
  801753:	b9 0e 00 00 00       	mov    $0xe,%ecx
  801758:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  80175f:	00 00 00 
  801762:	be 26 00 00 00       	mov    $0x26,%esi
  801767:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  80176e:	00 00 00 
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
  801776:	49 b9 35 04 80 00 00 	movabs $0x800435,%r9
  80177d:	00 00 00 
  801780:	41 ff d1             	call   *%r9

0000000000801783 <sys_gettime>:

int
sys_gettime(void) {
  801783:	55                   	push   %rbp
  801784:	48 89 e5             	mov    %rsp,%rbp
  801787:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801788:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80178d:	ba 00 00 00 00       	mov    $0x0,%edx
  801792:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801797:	bb 00 00 00 00       	mov    $0x0,%ebx
  80179c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017a1:	be 00 00 00 00       	mov    $0x0,%esi
  8017a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017ac:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8017ae:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

00000000008017b4 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8017b4:	55                   	push   %rbp
  8017b5:	48 89 e5             	mov    %rsp,%rbp
  8017b8:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8017b9:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8017be:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017cd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017d2:	be 00 00 00 00       	mov    $0x0,%esi
  8017d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017dd:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8017df:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

00000000008017e5 <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8017e5:	55                   	push   %rbp
  8017e6:	48 89 e5             	mov    %rsp,%rbp
  8017e9:	53                   	push   %rbx
  8017ea:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8017ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8017f3:	cd 30                	int    $0x30
  8017f5:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	0f 88 85 00 00 00    	js     801884 <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  8017ff:	0f 84 ac 00 00 00    	je     8018b1 <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  801805:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  80180b:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801812:	00 00 00 
  801815:	b9 00 00 00 00       	mov    $0x0,%ecx
  80181a:	89 c2                	mov    %eax,%edx
  80181c:	be 00 00 00 00       	mov    $0x0,%esi
  801821:	bf 00 00 00 00       	mov    $0x0,%edi
  801826:	48 b8 e7 14 80 00 00 	movabs $0x8014e7,%rax
  80182d:	00 00 00 
  801830:	ff d0                	call   *%rax
    if (res < 0)
  801832:	85 c0                	test   %eax,%eax
  801834:	0f 88 ad 00 00 00    	js     8018e7 <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  80183a:	be 02 00 00 00       	mov    $0x2,%esi
  80183f:	89 df                	mov    %ebx,%edi
  801841:	48 b8 b3 15 80 00 00 	movabs $0x8015b3,%rax
  801848:	00 00 00 
  80184b:	ff d0                	call   *%rax
    if (res < 0)
  80184d:	85 c0                	test   %eax,%eax
  80184f:	0f 88 bf 00 00 00    	js     801914 <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  801855:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80185c:	00 00 00 
  80185f:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  801866:	89 df                	mov    %ebx,%edi
  801868:	48 b8 85 16 80 00 00 	movabs $0x801685,%rax
  80186f:	00 00 00 
  801872:	ff d0                	call   *%rax
    if (res < 0)
  801874:	85 c0                	test   %eax,%eax
  801876:	0f 88 c5 00 00 00    	js     801941 <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  80187c:	89 d8                	mov    %ebx,%eax
  80187e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801882:	c9                   	leave  
  801883:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  801884:	89 c1                	mov    %eax,%ecx
  801886:	48 ba 2d 35 80 00 00 	movabs $0x80352d,%rdx
  80188d:	00 00 00 
  801890:	be 1a 00 00 00       	mov    $0x1a,%esi
  801895:	48 bf 3d 35 80 00 00 	movabs $0x80353d,%rdi
  80189c:	00 00 00 
  80189f:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a4:	49 b8 35 04 80 00 00 	movabs $0x800435,%r8
  8018ab:	00 00 00 
  8018ae:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  8018b1:	48 b8 c0 13 80 00 00 	movabs $0x8013c0,%rax
  8018b8:	00 00 00 
  8018bb:	ff d0                	call   *%rax
  8018bd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8018c2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8018c6:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8018ca:	48 c1 e0 04          	shl    $0x4,%rax
  8018ce:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8018d5:	00 00 00 
  8018d8:	48 01 d0             	add    %rdx,%rax
  8018db:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8018e2:	00 00 00 
        return 0;
  8018e5:	eb 95                	jmp    80187c <fork+0x97>
        panic("sys_map_region: %i", res);
  8018e7:	89 c1                	mov    %eax,%ecx
  8018e9:	48 ba 48 35 80 00 00 	movabs $0x803548,%rdx
  8018f0:	00 00 00 
  8018f3:	be 22 00 00 00       	mov    $0x22,%esi
  8018f8:	48 bf 3d 35 80 00 00 	movabs $0x80353d,%rdi
  8018ff:	00 00 00 
  801902:	b8 00 00 00 00       	mov    $0x0,%eax
  801907:	49 b8 35 04 80 00 00 	movabs $0x800435,%r8
  80190e:	00 00 00 
  801911:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  801914:	89 c1                	mov    %eax,%ecx
  801916:	48 ba 5b 35 80 00 00 	movabs $0x80355b,%rdx
  80191d:	00 00 00 
  801920:	be 25 00 00 00       	mov    $0x25,%esi
  801925:	48 bf 3d 35 80 00 00 	movabs $0x80353d,%rdi
  80192c:	00 00 00 
  80192f:	b8 00 00 00 00       	mov    $0x0,%eax
  801934:	49 b8 35 04 80 00 00 	movabs $0x800435,%r8
  80193b:	00 00 00 
  80193e:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  801941:	89 c1                	mov    %eax,%ecx
  801943:	48 ba 90 35 80 00 00 	movabs $0x803590,%rdx
  80194a:	00 00 00 
  80194d:	be 28 00 00 00       	mov    $0x28,%esi
  801952:	48 bf 3d 35 80 00 00 	movabs $0x80353d,%rdi
  801959:	00 00 00 
  80195c:	b8 00 00 00 00       	mov    $0x0,%eax
  801961:	49 b8 35 04 80 00 00 	movabs $0x800435,%r8
  801968:	00 00 00 
  80196b:	41 ff d0             	call   *%r8

000000000080196e <sfork>:

envid_t
sfork() {
  80196e:	55                   	push   %rbp
  80196f:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801972:	48 ba 72 35 80 00 00 	movabs $0x803572,%rdx
  801979:	00 00 00 
  80197c:	be 2f 00 00 00       	mov    $0x2f,%esi
  801981:	48 bf 3d 35 80 00 00 	movabs $0x80353d,%rdi
  801988:	00 00 00 
  80198b:	b8 00 00 00 00       	mov    $0x0,%eax
  801990:	48 b9 35 04 80 00 00 	movabs $0x800435,%rcx
  801997:	00 00 00 
  80199a:	ff d1                	call   *%rcx

000000000080199c <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80199c:	55                   	push   %rbp
  80199d:	48 89 e5             	mov    %rsp,%rbp
  8019a0:	41 54                	push   %r12
  8019a2:	53                   	push   %rbx
  8019a3:	48 89 fb             	mov    %rdi,%rbx
  8019a6:	48 89 f7             	mov    %rsi,%rdi
  8019a9:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  8019ac:	48 85 f6             	test   %rsi,%rsi
  8019af:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8019b6:	00 00 00 
  8019b9:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  8019bd:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  8019c2:	48 85 d2             	test   %rdx,%rdx
  8019c5:	74 02                	je     8019c9 <ipc_recv+0x2d>
  8019c7:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  8019c9:	48 63 f6             	movslq %esi,%rsi
  8019cc:	48 b8 1a 17 80 00 00 	movabs $0x80171a,%rax
  8019d3:	00 00 00 
  8019d6:	ff d0                	call   *%rax

    if (res < 0) {
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	78 45                	js     801a21 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  8019dc:	48 85 db             	test   %rbx,%rbx
  8019df:	74 12                	je     8019f3 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  8019e1:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8019e8:	00 00 00 
  8019eb:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  8019f1:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  8019f3:	4d 85 e4             	test   %r12,%r12
  8019f6:	74 14                	je     801a0c <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  8019f8:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8019ff:	00 00 00 
  801a02:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  801a08:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  801a0c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a13:	00 00 00 
  801a16:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  801a1c:	5b                   	pop    %rbx
  801a1d:	41 5c                	pop    %r12
  801a1f:	5d                   	pop    %rbp
  801a20:	c3                   	ret    
        if (from_env_store)
  801a21:	48 85 db             	test   %rbx,%rbx
  801a24:	74 06                	je     801a2c <ipc_recv+0x90>
            *from_env_store = 0;
  801a26:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  801a2c:	4d 85 e4             	test   %r12,%r12
  801a2f:	74 eb                	je     801a1c <ipc_recv+0x80>
            *perm_store = 0;
  801a31:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  801a38:	00 
  801a39:	eb e1                	jmp    801a1c <ipc_recv+0x80>

0000000000801a3b <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  801a3b:	55                   	push   %rbp
  801a3c:	48 89 e5             	mov    %rsp,%rbp
  801a3f:	41 57                	push   %r15
  801a41:	41 56                	push   %r14
  801a43:	41 55                	push   %r13
  801a45:	41 54                	push   %r12
  801a47:	53                   	push   %rbx
  801a48:	48 83 ec 18          	sub    $0x18,%rsp
  801a4c:	41 89 fd             	mov    %edi,%r13d
  801a4f:	89 75 cc             	mov    %esi,-0x34(%rbp)
  801a52:	48 89 d3             	mov    %rdx,%rbx
  801a55:	49 89 cc             	mov    %rcx,%r12
  801a58:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  801a5c:	48 85 d2             	test   %rdx,%rdx
  801a5f:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  801a66:	00 00 00 
  801a69:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  801a6d:	49 be ee 16 80 00 00 	movabs $0x8016ee,%r14
  801a74:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  801a77:	49 bf f1 13 80 00 00 	movabs $0x8013f1,%r15
  801a7e:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  801a81:	8b 75 cc             	mov    -0x34(%rbp),%esi
  801a84:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  801a88:	4c 89 e1             	mov    %r12,%rcx
  801a8b:	48 89 da             	mov    %rbx,%rdx
  801a8e:	44 89 ef             	mov    %r13d,%edi
  801a91:	41 ff d6             	call   *%r14
  801a94:	85 c0                	test   %eax,%eax
  801a96:	79 37                	jns    801acf <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  801a98:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801a9b:	75 05                	jne    801aa2 <ipc_send+0x67>
          sys_yield();
  801a9d:	41 ff d7             	call   *%r15
  801aa0:	eb df                	jmp    801a81 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  801aa2:	89 c1                	mov    %eax,%ecx
  801aa4:	48 ba af 35 80 00 00 	movabs $0x8035af,%rdx
  801aab:	00 00 00 
  801aae:	be 46 00 00 00       	mov    $0x46,%esi
  801ab3:	48 bf c2 35 80 00 00 	movabs $0x8035c2,%rdi
  801aba:	00 00 00 
  801abd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac2:	49 b8 35 04 80 00 00 	movabs $0x800435,%r8
  801ac9:	00 00 00 
  801acc:	41 ff d0             	call   *%r8
      }
}
  801acf:	48 83 c4 18          	add    $0x18,%rsp
  801ad3:	5b                   	pop    %rbx
  801ad4:	41 5c                	pop    %r12
  801ad6:	41 5d                	pop    %r13
  801ad8:	41 5e                	pop    %r14
  801ada:	41 5f                	pop    %r15
  801adc:	5d                   	pop    %rbp
  801add:	c3                   	ret    

0000000000801ade <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  801ade:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  801ae3:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  801aea:	00 00 00 
  801aed:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801af1:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  801af5:	48 c1 e2 04          	shl    $0x4,%rdx
  801af9:	48 01 ca             	add    %rcx,%rdx
  801afc:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  801b02:	39 fa                	cmp    %edi,%edx
  801b04:	74 12                	je     801b18 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  801b06:	48 83 c0 01          	add    $0x1,%rax
  801b0a:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  801b10:	75 db                	jne    801aed <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  801b12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b17:	c3                   	ret    
            return envs[i].env_id;
  801b18:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801b1c:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801b20:	48 c1 e0 04          	shl    $0x4,%rax
  801b24:	48 89 c2             	mov    %rax,%rdx
  801b27:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  801b2e:	00 00 00 
  801b31:	48 01 d0             	add    %rdx,%rax
  801b34:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801b3a:	c3                   	ret    

0000000000801b3b <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b3b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b42:	ff ff ff 
  801b45:	48 01 f8             	add    %rdi,%rax
  801b48:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b4c:	c3                   	ret    

0000000000801b4d <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b4d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b54:	ff ff ff 
  801b57:	48 01 f8             	add    %rdi,%rax
  801b5a:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  801b5e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b64:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b68:	c3                   	ret    

0000000000801b69 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801b69:	55                   	push   %rbp
  801b6a:	48 89 e5             	mov    %rsp,%rbp
  801b6d:	41 57                	push   %r15
  801b6f:	41 56                	push   %r14
  801b71:	41 55                	push   %r13
  801b73:	41 54                	push   %r12
  801b75:	53                   	push   %rbx
  801b76:	48 83 ec 08          	sub    $0x8,%rsp
  801b7a:	49 89 ff             	mov    %rdi,%r15
  801b7d:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801b82:	49 bc 17 2b 80 00 00 	movabs $0x802b17,%r12
  801b89:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801b8c:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801b92:	48 89 df             	mov    %rbx,%rdi
  801b95:	41 ff d4             	call   *%r12
  801b98:	83 e0 04             	and    $0x4,%eax
  801b9b:	74 1a                	je     801bb7 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  801b9d:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801ba4:	4c 39 f3             	cmp    %r14,%rbx
  801ba7:	75 e9                	jne    801b92 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801ba9:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801bb0:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801bb5:	eb 03                	jmp    801bba <fd_alloc+0x51>
            *fd_store = fd;
  801bb7:	49 89 1f             	mov    %rbx,(%r15)
}
  801bba:	48 83 c4 08          	add    $0x8,%rsp
  801bbe:	5b                   	pop    %rbx
  801bbf:	41 5c                	pop    %r12
  801bc1:	41 5d                	pop    %r13
  801bc3:	41 5e                	pop    %r14
  801bc5:	41 5f                	pop    %r15
  801bc7:	5d                   	pop    %rbp
  801bc8:	c3                   	ret    

0000000000801bc9 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801bc9:	83 ff 1f             	cmp    $0x1f,%edi
  801bcc:	77 39                	ja     801c07 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801bce:	55                   	push   %rbp
  801bcf:	48 89 e5             	mov    %rsp,%rbp
  801bd2:	41 54                	push   %r12
  801bd4:	53                   	push   %rbx
  801bd5:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801bd8:	48 63 df             	movslq %edi,%rbx
  801bdb:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801be2:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801be6:	48 89 df             	mov    %rbx,%rdi
  801be9:	48 b8 17 2b 80 00 00 	movabs $0x802b17,%rax
  801bf0:	00 00 00 
  801bf3:	ff d0                	call   *%rax
  801bf5:	a8 04                	test   $0x4,%al
  801bf7:	74 14                	je     801c0d <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801bf9:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801bfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c02:	5b                   	pop    %rbx
  801c03:	41 5c                	pop    %r12
  801c05:	5d                   	pop    %rbp
  801c06:	c3                   	ret    
        return -E_INVAL;
  801c07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801c0c:	c3                   	ret    
        return -E_INVAL;
  801c0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c12:	eb ee                	jmp    801c02 <fd_lookup+0x39>

0000000000801c14 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801c14:	55                   	push   %rbp
  801c15:	48 89 e5             	mov    %rsp,%rbp
  801c18:	53                   	push   %rbx
  801c19:	48 83 ec 08          	sub    $0x8,%rsp
  801c1d:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801c20:	48 ba 60 36 80 00 00 	movabs $0x803660,%rdx
  801c27:	00 00 00 
  801c2a:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801c31:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801c34:	39 38                	cmp    %edi,(%rax)
  801c36:	74 4b                	je     801c83 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801c38:	48 83 c2 08          	add    $0x8,%rdx
  801c3c:	48 8b 02             	mov    (%rdx),%rax
  801c3f:	48 85 c0             	test   %rax,%rax
  801c42:	75 f0                	jne    801c34 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801c44:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801c4b:	00 00 00 
  801c4e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c54:	89 fa                	mov    %edi,%edx
  801c56:	48 bf d0 35 80 00 00 	movabs $0x8035d0,%rdi
  801c5d:	00 00 00 
  801c60:	b8 00 00 00 00       	mov    $0x0,%eax
  801c65:	48 b9 85 05 80 00 00 	movabs $0x800585,%rcx
  801c6c:	00 00 00 
  801c6f:	ff d1                	call   *%rcx
    *dev = 0;
  801c71:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801c78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801c7d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    
            *dev = devtab[i];
  801c83:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801c86:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8b:	eb f0                	jmp    801c7d <dev_lookup+0x69>

0000000000801c8d <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801c8d:	55                   	push   %rbp
  801c8e:	48 89 e5             	mov    %rsp,%rbp
  801c91:	41 55                	push   %r13
  801c93:	41 54                	push   %r12
  801c95:	53                   	push   %rbx
  801c96:	48 83 ec 18          	sub    $0x18,%rsp
  801c9a:	49 89 fc             	mov    %rdi,%r12
  801c9d:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801ca0:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801ca7:	ff ff ff 
  801caa:	4c 01 e7             	add    %r12,%rdi
  801cad:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801cb1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801cb5:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  801cbc:	00 00 00 
  801cbf:	ff d0                	call   *%rax
  801cc1:	89 c3                	mov    %eax,%ebx
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	78 06                	js     801ccd <fd_close+0x40>
  801cc7:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801ccb:	74 18                	je     801ce5 <fd_close+0x58>
        return (must_exist ? res : 0);
  801ccd:	45 84 ed             	test   %r13b,%r13b
  801cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd5:	0f 44 d8             	cmove  %eax,%ebx
}
  801cd8:	89 d8                	mov    %ebx,%eax
  801cda:	48 83 c4 18          	add    $0x18,%rsp
  801cde:	5b                   	pop    %rbx
  801cdf:	41 5c                	pop    %r12
  801ce1:	41 5d                	pop    %r13
  801ce3:	5d                   	pop    %rbp
  801ce4:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ce5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ce9:	41 8b 3c 24          	mov    (%r12),%edi
  801ced:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  801cf4:	00 00 00 
  801cf7:	ff d0                	call   *%rax
  801cf9:	89 c3                	mov    %eax,%ebx
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	78 19                	js     801d18 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801cff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d03:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d07:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d0c:	48 85 c0             	test   %rax,%rax
  801d0f:	74 07                	je     801d18 <fd_close+0x8b>
  801d11:	4c 89 e7             	mov    %r12,%rdi
  801d14:	ff d0                	call   *%rax
  801d16:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801d18:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d1d:	4c 89 e6             	mov    %r12,%rsi
  801d20:	bf 00 00 00 00       	mov    $0x0,%edi
  801d25:	48 b8 4c 15 80 00 00 	movabs $0x80154c,%rax
  801d2c:	00 00 00 
  801d2f:	ff d0                	call   *%rax
    return res;
  801d31:	eb a5                	jmp    801cd8 <fd_close+0x4b>

0000000000801d33 <close>:

int
close(int fdnum) {
  801d33:	55                   	push   %rbp
  801d34:	48 89 e5             	mov    %rsp,%rbp
  801d37:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801d3b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801d3f:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  801d46:	00 00 00 
  801d49:	ff d0                	call   *%rax
    if (res < 0) return res;
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	78 15                	js     801d64 <close+0x31>

    return fd_close(fd, 1);
  801d4f:	be 01 00 00 00       	mov    $0x1,%esi
  801d54:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801d58:	48 b8 8d 1c 80 00 00 	movabs $0x801c8d,%rax
  801d5f:	00 00 00 
  801d62:	ff d0                	call   *%rax
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

0000000000801d66 <close_all>:

void
close_all(void) {
  801d66:	55                   	push   %rbp
  801d67:	48 89 e5             	mov    %rsp,%rbp
  801d6a:	41 54                	push   %r12
  801d6c:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801d6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d72:	49 bc 33 1d 80 00 00 	movabs $0x801d33,%r12
  801d79:	00 00 00 
  801d7c:	89 df                	mov    %ebx,%edi
  801d7e:	41 ff d4             	call   *%r12
  801d81:	83 c3 01             	add    $0x1,%ebx
  801d84:	83 fb 20             	cmp    $0x20,%ebx
  801d87:	75 f3                	jne    801d7c <close_all+0x16>
}
  801d89:	5b                   	pop    %rbx
  801d8a:	41 5c                	pop    %r12
  801d8c:	5d                   	pop    %rbp
  801d8d:	c3                   	ret    

0000000000801d8e <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801d8e:	55                   	push   %rbp
  801d8f:	48 89 e5             	mov    %rsp,%rbp
  801d92:	41 56                	push   %r14
  801d94:	41 55                	push   %r13
  801d96:	41 54                	push   %r12
  801d98:	53                   	push   %rbx
  801d99:	48 83 ec 10          	sub    $0x10,%rsp
  801d9d:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801da0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801da4:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  801dab:	00 00 00 
  801dae:	ff d0                	call   *%rax
  801db0:	89 c3                	mov    %eax,%ebx
  801db2:	85 c0                	test   %eax,%eax
  801db4:	0f 88 b7 00 00 00    	js     801e71 <dup+0xe3>
    close(newfdnum);
  801dba:	44 89 e7             	mov    %r12d,%edi
  801dbd:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  801dc4:	00 00 00 
  801dc7:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801dc9:	4d 63 ec             	movslq %r12d,%r13
  801dcc:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801dd3:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801dd7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801ddb:	49 be 4d 1b 80 00 00 	movabs $0x801b4d,%r14
  801de2:	00 00 00 
  801de5:	41 ff d6             	call   *%r14
  801de8:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801deb:	4c 89 ef             	mov    %r13,%rdi
  801dee:	41 ff d6             	call   *%r14
  801df1:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801df4:	48 89 df             	mov    %rbx,%rdi
  801df7:	48 b8 17 2b 80 00 00 	movabs $0x802b17,%rax
  801dfe:	00 00 00 
  801e01:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801e03:	a8 04                	test   $0x4,%al
  801e05:	74 2b                	je     801e32 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801e07:	41 89 c1             	mov    %eax,%r9d
  801e0a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801e10:	4c 89 f1             	mov    %r14,%rcx
  801e13:	ba 00 00 00 00       	mov    $0x0,%edx
  801e18:	48 89 de             	mov    %rbx,%rsi
  801e1b:	bf 00 00 00 00       	mov    $0x0,%edi
  801e20:	48 b8 e7 14 80 00 00 	movabs $0x8014e7,%rax
  801e27:	00 00 00 
  801e2a:	ff d0                	call   *%rax
  801e2c:	89 c3                	mov    %eax,%ebx
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	78 4e                	js     801e80 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801e32:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e36:	48 b8 17 2b 80 00 00 	movabs $0x802b17,%rax
  801e3d:	00 00 00 
  801e40:	ff d0                	call   *%rax
  801e42:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801e45:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801e4b:	4c 89 e9             	mov    %r13,%rcx
  801e4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e53:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801e57:	bf 00 00 00 00       	mov    $0x0,%edi
  801e5c:	48 b8 e7 14 80 00 00 	movabs $0x8014e7,%rax
  801e63:	00 00 00 
  801e66:	ff d0                	call   *%rax
  801e68:	89 c3                	mov    %eax,%ebx
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	78 12                	js     801e80 <dup+0xf2>

    return newfdnum;
  801e6e:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801e71:	89 d8                	mov    %ebx,%eax
  801e73:	48 83 c4 10          	add    $0x10,%rsp
  801e77:	5b                   	pop    %rbx
  801e78:	41 5c                	pop    %r12
  801e7a:	41 5d                	pop    %r13
  801e7c:	41 5e                	pop    %r14
  801e7e:	5d                   	pop    %rbp
  801e7f:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801e80:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e85:	4c 89 ee             	mov    %r13,%rsi
  801e88:	bf 00 00 00 00       	mov    $0x0,%edi
  801e8d:	49 bc 4c 15 80 00 00 	movabs $0x80154c,%r12
  801e94:	00 00 00 
  801e97:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801e9a:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e9f:	4c 89 f6             	mov    %r14,%rsi
  801ea2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea7:	41 ff d4             	call   *%r12
    return res;
  801eaa:	eb c5                	jmp    801e71 <dup+0xe3>

0000000000801eac <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801eac:	55                   	push   %rbp
  801ead:	48 89 e5             	mov    %rsp,%rbp
  801eb0:	41 55                	push   %r13
  801eb2:	41 54                	push   %r12
  801eb4:	53                   	push   %rbx
  801eb5:	48 83 ec 18          	sub    $0x18,%rsp
  801eb9:	89 fb                	mov    %edi,%ebx
  801ebb:	49 89 f4             	mov    %rsi,%r12
  801ebe:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ec1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ec5:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  801ecc:	00 00 00 
  801ecf:	ff d0                	call   *%rax
  801ed1:	85 c0                	test   %eax,%eax
  801ed3:	78 49                	js     801f1e <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ed5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ed9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801edd:	8b 38                	mov    (%rax),%edi
  801edf:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  801ee6:	00 00 00 
  801ee9:	ff d0                	call   *%rax
  801eeb:	85 c0                	test   %eax,%eax
  801eed:	78 33                	js     801f22 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801eef:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801ef3:	8b 47 08             	mov    0x8(%rdi),%eax
  801ef6:	83 e0 03             	and    $0x3,%eax
  801ef9:	83 f8 01             	cmp    $0x1,%eax
  801efc:	74 28                	je     801f26 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801efe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f02:	48 8b 40 10          	mov    0x10(%rax),%rax
  801f06:	48 85 c0             	test   %rax,%rax
  801f09:	74 51                	je     801f5c <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801f0b:	4c 89 ea             	mov    %r13,%rdx
  801f0e:	4c 89 e6             	mov    %r12,%rsi
  801f11:	ff d0                	call   *%rax
}
  801f13:	48 83 c4 18          	add    $0x18,%rsp
  801f17:	5b                   	pop    %rbx
  801f18:	41 5c                	pop    %r12
  801f1a:	41 5d                	pop    %r13
  801f1c:	5d                   	pop    %rbp
  801f1d:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f1e:	48 98                	cltq   
  801f20:	eb f1                	jmp    801f13 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f22:	48 98                	cltq   
  801f24:	eb ed                	jmp    801f13 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801f26:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801f2d:	00 00 00 
  801f30:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f36:	89 da                	mov    %ebx,%edx
  801f38:	48 bf 11 36 80 00 00 	movabs $0x803611,%rdi
  801f3f:	00 00 00 
  801f42:	b8 00 00 00 00       	mov    $0x0,%eax
  801f47:	48 b9 85 05 80 00 00 	movabs $0x800585,%rcx
  801f4e:	00 00 00 
  801f51:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f53:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801f5a:	eb b7                	jmp    801f13 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801f5c:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801f63:	eb ae                	jmp    801f13 <read+0x67>

0000000000801f65 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801f65:	55                   	push   %rbp
  801f66:	48 89 e5             	mov    %rsp,%rbp
  801f69:	41 57                	push   %r15
  801f6b:	41 56                	push   %r14
  801f6d:	41 55                	push   %r13
  801f6f:	41 54                	push   %r12
  801f71:	53                   	push   %rbx
  801f72:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801f76:	48 85 d2             	test   %rdx,%rdx
  801f79:	74 54                	je     801fcf <readn+0x6a>
  801f7b:	41 89 fd             	mov    %edi,%r13d
  801f7e:	49 89 f6             	mov    %rsi,%r14
  801f81:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801f84:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801f89:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801f8e:	49 bf ac 1e 80 00 00 	movabs $0x801eac,%r15
  801f95:	00 00 00 
  801f98:	4c 89 e2             	mov    %r12,%rdx
  801f9b:	48 29 f2             	sub    %rsi,%rdx
  801f9e:	4c 01 f6             	add    %r14,%rsi
  801fa1:	44 89 ef             	mov    %r13d,%edi
  801fa4:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	78 20                	js     801fcb <readn+0x66>
    for (; inc && res < n; res += inc) {
  801fab:	01 c3                	add    %eax,%ebx
  801fad:	85 c0                	test   %eax,%eax
  801faf:	74 08                	je     801fb9 <readn+0x54>
  801fb1:	48 63 f3             	movslq %ebx,%rsi
  801fb4:	4c 39 e6             	cmp    %r12,%rsi
  801fb7:	72 df                	jb     801f98 <readn+0x33>
    }
    return res;
  801fb9:	48 63 c3             	movslq %ebx,%rax
}
  801fbc:	48 83 c4 08          	add    $0x8,%rsp
  801fc0:	5b                   	pop    %rbx
  801fc1:	41 5c                	pop    %r12
  801fc3:	41 5d                	pop    %r13
  801fc5:	41 5e                	pop    %r14
  801fc7:	41 5f                	pop    %r15
  801fc9:	5d                   	pop    %rbp
  801fca:	c3                   	ret    
        if (inc < 0) return inc;
  801fcb:	48 98                	cltq   
  801fcd:	eb ed                	jmp    801fbc <readn+0x57>
    int inc = 1, res = 0;
  801fcf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fd4:	eb e3                	jmp    801fb9 <readn+0x54>

0000000000801fd6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801fd6:	55                   	push   %rbp
  801fd7:	48 89 e5             	mov    %rsp,%rbp
  801fda:	41 55                	push   %r13
  801fdc:	41 54                	push   %r12
  801fde:	53                   	push   %rbx
  801fdf:	48 83 ec 18          	sub    $0x18,%rsp
  801fe3:	89 fb                	mov    %edi,%ebx
  801fe5:	49 89 f4             	mov    %rsi,%r12
  801fe8:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801feb:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801fef:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  801ff6:	00 00 00 
  801ff9:	ff d0                	call   *%rax
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	78 44                	js     802043 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fff:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802003:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802007:	8b 38                	mov    (%rax),%edi
  802009:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  802010:	00 00 00 
  802013:	ff d0                	call   *%rax
  802015:	85 c0                	test   %eax,%eax
  802017:	78 2e                	js     802047 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802019:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80201d:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  802021:	74 28                	je     80204b <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  802023:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802027:	48 8b 40 18          	mov    0x18(%rax),%rax
  80202b:	48 85 c0             	test   %rax,%rax
  80202e:	74 51                	je     802081 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  802030:	4c 89 ea             	mov    %r13,%rdx
  802033:	4c 89 e6             	mov    %r12,%rsi
  802036:	ff d0                	call   *%rax
}
  802038:	48 83 c4 18          	add    $0x18,%rsp
  80203c:	5b                   	pop    %rbx
  80203d:	41 5c                	pop    %r12
  80203f:	41 5d                	pop    %r13
  802041:	5d                   	pop    %rbp
  802042:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802043:	48 98                	cltq   
  802045:	eb f1                	jmp    802038 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802047:	48 98                	cltq   
  802049:	eb ed                	jmp    802038 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80204b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802052:	00 00 00 
  802055:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80205b:	89 da                	mov    %ebx,%edx
  80205d:	48 bf 2d 36 80 00 00 	movabs $0x80362d,%rdi
  802064:	00 00 00 
  802067:	b8 00 00 00 00       	mov    $0x0,%eax
  80206c:	48 b9 85 05 80 00 00 	movabs $0x800585,%rcx
  802073:	00 00 00 
  802076:	ff d1                	call   *%rcx
        return -E_INVAL;
  802078:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80207f:	eb b7                	jmp    802038 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  802081:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  802088:	eb ae                	jmp    802038 <write+0x62>

000000000080208a <seek>:

int
seek(int fdnum, off_t offset) {
  80208a:	55                   	push   %rbp
  80208b:	48 89 e5             	mov    %rsp,%rbp
  80208e:	53                   	push   %rbx
  80208f:	48 83 ec 18          	sub    $0x18,%rsp
  802093:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802095:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802099:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  8020a0:	00 00 00 
  8020a3:	ff d0                	call   *%rax
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	78 0c                	js     8020b5 <seek+0x2b>

    fd->fd_offset = offset;
  8020a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ad:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  8020b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

00000000008020bb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  8020bb:	55                   	push   %rbp
  8020bc:	48 89 e5             	mov    %rsp,%rbp
  8020bf:	41 54                	push   %r12
  8020c1:	53                   	push   %rbx
  8020c2:	48 83 ec 10          	sub    $0x10,%rsp
  8020c6:	89 fb                	mov    %edi,%ebx
  8020c8:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8020cb:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8020cf:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  8020d6:	00 00 00 
  8020d9:	ff d0                	call   *%rax
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	78 36                	js     802115 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8020df:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8020e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e7:	8b 38                	mov    (%rax),%edi
  8020e9:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  8020f0:	00 00 00 
  8020f3:	ff d0                	call   *%rax
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	78 1c                	js     802115 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020f9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020fd:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  802101:	74 1b                	je     80211e <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802103:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802107:	48 8b 40 30          	mov    0x30(%rax),%rax
  80210b:	48 85 c0             	test   %rax,%rax
  80210e:	74 42                	je     802152 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  802110:	44 89 e6             	mov    %r12d,%esi
  802113:	ff d0                	call   *%rax
}
  802115:	48 83 c4 10          	add    $0x10,%rsp
  802119:	5b                   	pop    %rbx
  80211a:	41 5c                	pop    %r12
  80211c:	5d                   	pop    %rbp
  80211d:	c3                   	ret    
                thisenv->env_id, fdnum);
  80211e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802125:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  802128:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80212e:	89 da                	mov    %ebx,%edx
  802130:	48 bf f0 35 80 00 00 	movabs $0x8035f0,%rdi
  802137:	00 00 00 
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
  80213f:	48 b9 85 05 80 00 00 	movabs $0x800585,%rcx
  802146:	00 00 00 
  802149:	ff d1                	call   *%rcx
        return -E_INVAL;
  80214b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802150:	eb c3                	jmp    802115 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802152:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802157:	eb bc                	jmp    802115 <ftruncate+0x5a>

0000000000802159 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  802159:	55                   	push   %rbp
  80215a:	48 89 e5             	mov    %rsp,%rbp
  80215d:	53                   	push   %rbx
  80215e:	48 83 ec 18          	sub    $0x18,%rsp
  802162:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802165:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802169:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  802170:	00 00 00 
  802173:	ff d0                	call   *%rax
  802175:	85 c0                	test   %eax,%eax
  802177:	78 4d                	js     8021c6 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802179:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  80217d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802181:	8b 38                	mov    (%rax),%edi
  802183:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  80218a:	00 00 00 
  80218d:	ff d0                	call   *%rax
  80218f:	85 c0                	test   %eax,%eax
  802191:	78 33                	js     8021c6 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  802193:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802197:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  80219c:	74 2e                	je     8021cc <fstat+0x73>

    stat->st_name[0] = 0;
  80219e:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  8021a1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  8021a8:	00 00 00 
    stat->st_isdir = 0;
  8021ab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8021b2:	00 00 00 
    stat->st_dev = dev;
  8021b5:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  8021bc:	48 89 de             	mov    %rbx,%rsi
  8021bf:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8021c3:	ff 50 28             	call   *0x28(%rax)
}
  8021c6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  8021cc:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8021d1:	eb f3                	jmp    8021c6 <fstat+0x6d>

00000000008021d3 <stat>:

int
stat(const char *path, struct Stat *stat) {
  8021d3:	55                   	push   %rbp
  8021d4:	48 89 e5             	mov    %rsp,%rbp
  8021d7:	41 54                	push   %r12
  8021d9:	53                   	push   %rbx
  8021da:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  8021dd:	be 00 00 00 00       	mov    $0x0,%esi
  8021e2:	48 b8 9e 24 80 00 00 	movabs $0x80249e,%rax
  8021e9:	00 00 00 
  8021ec:	ff d0                	call   *%rax
  8021ee:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	78 25                	js     802219 <stat+0x46>

    int res = fstat(fd, stat);
  8021f4:	4c 89 e6             	mov    %r12,%rsi
  8021f7:	89 c7                	mov    %eax,%edi
  8021f9:	48 b8 59 21 80 00 00 	movabs $0x802159,%rax
  802200:	00 00 00 
  802203:	ff d0                	call   *%rax
  802205:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802208:	89 df                	mov    %ebx,%edi
  80220a:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  802211:	00 00 00 
  802214:	ff d0                	call   *%rax

    return res;
  802216:	44 89 e3             	mov    %r12d,%ebx
}
  802219:	89 d8                	mov    %ebx,%eax
  80221b:	5b                   	pop    %rbx
  80221c:	41 5c                	pop    %r12
  80221e:	5d                   	pop    %rbp
  80221f:	c3                   	ret    

0000000000802220 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802220:	55                   	push   %rbp
  802221:	48 89 e5             	mov    %rsp,%rbp
  802224:	41 54                	push   %r12
  802226:	53                   	push   %rbx
  802227:	48 83 ec 10          	sub    $0x10,%rsp
  80222b:	41 89 fc             	mov    %edi,%r12d
  80222e:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802231:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802238:	00 00 00 
  80223b:	83 38 00             	cmpl   $0x0,(%rax)
  80223e:	74 5e                	je     80229e <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802240:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802246:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80224b:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802252:	00 00 00 
  802255:	44 89 e6             	mov    %r12d,%esi
  802258:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80225f:	00 00 00 
  802262:	8b 38                	mov    (%rax),%edi
  802264:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  80226b:	00 00 00 
  80226e:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802270:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802277:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802278:	b9 00 00 00 00       	mov    $0x0,%ecx
  80227d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802281:	48 89 de             	mov    %rbx,%rsi
  802284:	bf 00 00 00 00       	mov    $0x0,%edi
  802289:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  802290:	00 00 00 
  802293:	ff d0                	call   *%rax
}
  802295:	48 83 c4 10          	add    $0x10,%rsp
  802299:	5b                   	pop    %rbx
  80229a:	41 5c                	pop    %r12
  80229c:	5d                   	pop    %rbp
  80229d:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80229e:	bf 03 00 00 00       	mov    $0x3,%edi
  8022a3:	48 b8 de 1a 80 00 00 	movabs $0x801ade,%rax
  8022aa:	00 00 00 
  8022ad:	ff d0                	call   *%rax
  8022af:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8022b6:	00 00 
  8022b8:	eb 86                	jmp    802240 <fsipc+0x20>

00000000008022ba <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8022ba:	55                   	push   %rbp
  8022bb:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8022be:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8022c5:	00 00 00 
  8022c8:	8b 57 0c             	mov    0xc(%rdi),%edx
  8022cb:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8022cd:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8022d0:	be 00 00 00 00       	mov    $0x0,%esi
  8022d5:	bf 02 00 00 00       	mov    $0x2,%edi
  8022da:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  8022e1:	00 00 00 
  8022e4:	ff d0                	call   *%rax
}
  8022e6:	5d                   	pop    %rbp
  8022e7:	c3                   	ret    

00000000008022e8 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8022e8:	55                   	push   %rbp
  8022e9:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8022ec:	8b 47 0c             	mov    0xc(%rdi),%eax
  8022ef:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  8022f6:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  8022f8:	be 00 00 00 00       	mov    $0x0,%esi
  8022fd:	bf 06 00 00 00       	mov    $0x6,%edi
  802302:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  802309:	00 00 00 
  80230c:	ff d0                	call   *%rax
}
  80230e:	5d                   	pop    %rbp
  80230f:	c3                   	ret    

0000000000802310 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802310:	55                   	push   %rbp
  802311:	48 89 e5             	mov    %rsp,%rbp
  802314:	53                   	push   %rbx
  802315:	48 83 ec 08          	sub    $0x8,%rsp
  802319:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80231c:	8b 47 0c             	mov    0xc(%rdi),%eax
  80231f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802326:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802328:	be 00 00 00 00       	mov    $0x0,%esi
  80232d:	bf 05 00 00 00       	mov    $0x5,%edi
  802332:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  802339:	00 00 00 
  80233c:	ff d0                	call   *%rax
    if (res < 0) return res;
  80233e:	85 c0                	test   %eax,%eax
  802340:	78 40                	js     802382 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802342:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802349:	00 00 00 
  80234c:	48 89 df             	mov    %rbx,%rdi
  80234f:	48 b8 c6 0e 80 00 00 	movabs $0x800ec6,%rax
  802356:	00 00 00 
  802359:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80235b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802362:	00 00 00 
  802365:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80236b:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802371:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  802377:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  80237d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802382:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802386:	c9                   	leave  
  802387:	c3                   	ret    

0000000000802388 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802388:	55                   	push   %rbp
  802389:	48 89 e5             	mov    %rsp,%rbp
  80238c:	41 57                	push   %r15
  80238e:	41 56                	push   %r14
  802390:	41 55                	push   %r13
  802392:	41 54                	push   %r12
  802394:	53                   	push   %rbx
  802395:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  802399:	48 85 d2             	test   %rdx,%rdx
  80239c:	0f 84 91 00 00 00    	je     802433 <devfile_write+0xab>
  8023a2:	49 89 ff             	mov    %rdi,%r15
  8023a5:	49 89 f4             	mov    %rsi,%r12
  8023a8:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  8023ab:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8023b2:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  8023b9:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8023bc:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  8023c3:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  8023c9:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  8023cd:	4c 89 ea             	mov    %r13,%rdx
  8023d0:	4c 89 e6             	mov    %r12,%rsi
  8023d3:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  8023da:	00 00 00 
  8023dd:	48 b8 26 11 80 00 00 	movabs $0x801126,%rax
  8023e4:	00 00 00 
  8023e7:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8023e9:	41 8b 47 0c          	mov    0xc(%r15),%eax
  8023ed:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  8023f0:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  8023f4:	be 00 00 00 00       	mov    $0x0,%esi
  8023f9:	bf 04 00 00 00       	mov    $0x4,%edi
  8023fe:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  802405:	00 00 00 
  802408:	ff d0                	call   *%rax
        if (res < 0)
  80240a:	85 c0                	test   %eax,%eax
  80240c:	78 21                	js     80242f <devfile_write+0xa7>
        buf += res;
  80240e:	48 63 d0             	movslq %eax,%rdx
  802411:	49 01 d4             	add    %rdx,%r12
        ext += res;
  802414:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  802417:	48 29 d3             	sub    %rdx,%rbx
  80241a:	75 a0                	jne    8023bc <devfile_write+0x34>
    return ext;
  80241c:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  802420:	48 83 c4 18          	add    $0x18,%rsp
  802424:	5b                   	pop    %rbx
  802425:	41 5c                	pop    %r12
  802427:	41 5d                	pop    %r13
  802429:	41 5e                	pop    %r14
  80242b:	41 5f                	pop    %r15
  80242d:	5d                   	pop    %rbp
  80242e:	c3                   	ret    
            return res;
  80242f:	48 98                	cltq   
  802431:	eb ed                	jmp    802420 <devfile_write+0x98>
    int ext = 0;
  802433:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  80243a:	eb e0                	jmp    80241c <devfile_write+0x94>

000000000080243c <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80243c:	55                   	push   %rbp
  80243d:	48 89 e5             	mov    %rsp,%rbp
  802440:	41 54                	push   %r12
  802442:	53                   	push   %rbx
  802443:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802446:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80244d:	00 00 00 
  802450:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802453:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  802455:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  802459:	be 00 00 00 00       	mov    $0x0,%esi
  80245e:	bf 03 00 00 00       	mov    $0x3,%edi
  802463:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  80246a:	00 00 00 
  80246d:	ff d0                	call   *%rax
    if (read < 0) 
  80246f:	85 c0                	test   %eax,%eax
  802471:	78 27                	js     80249a <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  802473:	48 63 d8             	movslq %eax,%rbx
  802476:	48 89 da             	mov    %rbx,%rdx
  802479:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802480:	00 00 00 
  802483:	4c 89 e7             	mov    %r12,%rdi
  802486:	48 b8 c1 10 80 00 00 	movabs $0x8010c1,%rax
  80248d:	00 00 00 
  802490:	ff d0                	call   *%rax
    return read;
  802492:	48 89 d8             	mov    %rbx,%rax
}
  802495:	5b                   	pop    %rbx
  802496:	41 5c                	pop    %r12
  802498:	5d                   	pop    %rbp
  802499:	c3                   	ret    
		return read;
  80249a:	48 98                	cltq   
  80249c:	eb f7                	jmp    802495 <devfile_read+0x59>

000000000080249e <open>:
open(const char *path, int mode) {
  80249e:	55                   	push   %rbp
  80249f:	48 89 e5             	mov    %rsp,%rbp
  8024a2:	41 55                	push   %r13
  8024a4:	41 54                	push   %r12
  8024a6:	53                   	push   %rbx
  8024a7:	48 83 ec 18          	sub    $0x18,%rsp
  8024ab:	49 89 fc             	mov    %rdi,%r12
  8024ae:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8024b1:	48 b8 8d 0e 80 00 00 	movabs $0x800e8d,%rax
  8024b8:	00 00 00 
  8024bb:	ff d0                	call   *%rax
  8024bd:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8024c3:	0f 87 8c 00 00 00    	ja     802555 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8024c9:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8024cd:	48 b8 69 1b 80 00 00 	movabs $0x801b69,%rax
  8024d4:	00 00 00 
  8024d7:	ff d0                	call   *%rax
  8024d9:	89 c3                	mov    %eax,%ebx
  8024db:	85 c0                	test   %eax,%eax
  8024dd:	78 52                	js     802531 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  8024df:	4c 89 e6             	mov    %r12,%rsi
  8024e2:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  8024e9:	00 00 00 
  8024ec:	48 b8 c6 0e 80 00 00 	movabs $0x800ec6,%rax
  8024f3:	00 00 00 
  8024f6:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8024f8:	44 89 e8             	mov    %r13d,%eax
  8024fb:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802502:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802504:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802508:	bf 01 00 00 00       	mov    $0x1,%edi
  80250d:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  802514:	00 00 00 
  802517:	ff d0                	call   *%rax
  802519:	89 c3                	mov    %eax,%ebx
  80251b:	85 c0                	test   %eax,%eax
  80251d:	78 1f                	js     80253e <open+0xa0>
    return fd2num(fd);
  80251f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802523:	48 b8 3b 1b 80 00 00 	movabs $0x801b3b,%rax
  80252a:	00 00 00 
  80252d:	ff d0                	call   *%rax
  80252f:	89 c3                	mov    %eax,%ebx
}
  802531:	89 d8                	mov    %ebx,%eax
  802533:	48 83 c4 18          	add    $0x18,%rsp
  802537:	5b                   	pop    %rbx
  802538:	41 5c                	pop    %r12
  80253a:	41 5d                	pop    %r13
  80253c:	5d                   	pop    %rbp
  80253d:	c3                   	ret    
        fd_close(fd, 0);
  80253e:	be 00 00 00 00       	mov    $0x0,%esi
  802543:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802547:	48 b8 8d 1c 80 00 00 	movabs $0x801c8d,%rax
  80254e:	00 00 00 
  802551:	ff d0                	call   *%rax
        return res;
  802553:	eb dc                	jmp    802531 <open+0x93>
        return -E_BAD_PATH;
  802555:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80255a:	eb d5                	jmp    802531 <open+0x93>

000000000080255c <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80255c:	55                   	push   %rbp
  80255d:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802560:	be 00 00 00 00       	mov    $0x0,%esi
  802565:	bf 08 00 00 00       	mov    $0x8,%edi
  80256a:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  802571:	00 00 00 
  802574:	ff d0                	call   *%rax
}
  802576:	5d                   	pop    %rbp
  802577:	c3                   	ret    

0000000000802578 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802578:	55                   	push   %rbp
  802579:	48 89 e5             	mov    %rsp,%rbp
  80257c:	41 54                	push   %r12
  80257e:	53                   	push   %rbx
  80257f:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802582:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  802589:	00 00 00 
  80258c:	ff d0                	call   *%rax
  80258e:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802591:	48 be 80 36 80 00 00 	movabs $0x803680,%rsi
  802598:	00 00 00 
  80259b:	48 89 df             	mov    %rbx,%rdi
  80259e:	48 b8 c6 0e 80 00 00 	movabs $0x800ec6,%rax
  8025a5:	00 00 00 
  8025a8:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8025aa:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8025af:	41 2b 04 24          	sub    (%r12),%eax
  8025b3:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8025b9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8025c0:	00 00 00 
    stat->st_dev = &devpipe;
  8025c3:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8025ca:	00 00 00 
  8025cd:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8025d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d9:	5b                   	pop    %rbx
  8025da:	41 5c                	pop    %r12
  8025dc:	5d                   	pop    %rbp
  8025dd:	c3                   	ret    

00000000008025de <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8025de:	55                   	push   %rbp
  8025df:	48 89 e5             	mov    %rsp,%rbp
  8025e2:	41 54                	push   %r12
  8025e4:	53                   	push   %rbx
  8025e5:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8025e8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025ed:	48 89 fe             	mov    %rdi,%rsi
  8025f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f5:	49 bc 4c 15 80 00 00 	movabs $0x80154c,%r12
  8025fc:	00 00 00 
  8025ff:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802602:	48 89 df             	mov    %rbx,%rdi
  802605:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  80260c:	00 00 00 
  80260f:	ff d0                	call   *%rax
  802611:	48 89 c6             	mov    %rax,%rsi
  802614:	ba 00 10 00 00       	mov    $0x1000,%edx
  802619:	bf 00 00 00 00       	mov    $0x0,%edi
  80261e:	41 ff d4             	call   *%r12
}
  802621:	5b                   	pop    %rbx
  802622:	41 5c                	pop    %r12
  802624:	5d                   	pop    %rbp
  802625:	c3                   	ret    

0000000000802626 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802626:	55                   	push   %rbp
  802627:	48 89 e5             	mov    %rsp,%rbp
  80262a:	41 57                	push   %r15
  80262c:	41 56                	push   %r14
  80262e:	41 55                	push   %r13
  802630:	41 54                	push   %r12
  802632:	53                   	push   %rbx
  802633:	48 83 ec 18          	sub    $0x18,%rsp
  802637:	49 89 fc             	mov    %rdi,%r12
  80263a:	49 89 f5             	mov    %rsi,%r13
  80263d:	49 89 d7             	mov    %rdx,%r15
  802640:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802644:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  80264b:	00 00 00 
  80264e:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802650:	4d 85 ff             	test   %r15,%r15
  802653:	0f 84 ac 00 00 00    	je     802705 <devpipe_write+0xdf>
  802659:	48 89 c3             	mov    %rax,%rbx
  80265c:	4c 89 f8             	mov    %r15,%rax
  80265f:	4d 89 ef             	mov    %r13,%r15
  802662:	49 01 c5             	add    %rax,%r13
  802665:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802669:	49 bd 54 14 80 00 00 	movabs $0x801454,%r13
  802670:	00 00 00 
            sys_yield();
  802673:	49 be f1 13 80 00 00 	movabs $0x8013f1,%r14
  80267a:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80267d:	8b 73 04             	mov    0x4(%rbx),%esi
  802680:	48 63 ce             	movslq %esi,%rcx
  802683:	48 63 03             	movslq (%rbx),%rax
  802686:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80268c:	48 39 c1             	cmp    %rax,%rcx
  80268f:	72 2e                	jb     8026bf <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802691:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802696:	48 89 da             	mov    %rbx,%rdx
  802699:	be 00 10 00 00       	mov    $0x1000,%esi
  80269e:	4c 89 e7             	mov    %r12,%rdi
  8026a1:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	74 63                	je     80270b <devpipe_write+0xe5>
            sys_yield();
  8026a8:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8026ab:	8b 73 04             	mov    0x4(%rbx),%esi
  8026ae:	48 63 ce             	movslq %esi,%rcx
  8026b1:	48 63 03             	movslq (%rbx),%rax
  8026b4:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8026ba:	48 39 c1             	cmp    %rax,%rcx
  8026bd:	73 d2                	jae    802691 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8026bf:	41 0f b6 3f          	movzbl (%r15),%edi
  8026c3:	48 89 ca             	mov    %rcx,%rdx
  8026c6:	48 c1 ea 03          	shr    $0x3,%rdx
  8026ca:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8026d1:	08 10 20 
  8026d4:	48 f7 e2             	mul    %rdx
  8026d7:	48 c1 ea 06          	shr    $0x6,%rdx
  8026db:	48 89 d0             	mov    %rdx,%rax
  8026de:	48 c1 e0 09          	shl    $0x9,%rax
  8026e2:	48 29 d0             	sub    %rdx,%rax
  8026e5:	48 c1 e0 03          	shl    $0x3,%rax
  8026e9:	48 29 c1             	sub    %rax,%rcx
  8026ec:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8026f1:	83 c6 01             	add    $0x1,%esi
  8026f4:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8026f7:	49 83 c7 01          	add    $0x1,%r15
  8026fb:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8026ff:	0f 85 78 ff ff ff    	jne    80267d <devpipe_write+0x57>
    return n;
  802705:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802709:	eb 05                	jmp    802710 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  80270b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802710:	48 83 c4 18          	add    $0x18,%rsp
  802714:	5b                   	pop    %rbx
  802715:	41 5c                	pop    %r12
  802717:	41 5d                	pop    %r13
  802719:	41 5e                	pop    %r14
  80271b:	41 5f                	pop    %r15
  80271d:	5d                   	pop    %rbp
  80271e:	c3                   	ret    

000000000080271f <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80271f:	55                   	push   %rbp
  802720:	48 89 e5             	mov    %rsp,%rbp
  802723:	41 57                	push   %r15
  802725:	41 56                	push   %r14
  802727:	41 55                	push   %r13
  802729:	41 54                	push   %r12
  80272b:	53                   	push   %rbx
  80272c:	48 83 ec 18          	sub    $0x18,%rsp
  802730:	49 89 fc             	mov    %rdi,%r12
  802733:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802737:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80273b:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  802742:	00 00 00 
  802745:	ff d0                	call   *%rax
  802747:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80274a:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802750:	49 bd 54 14 80 00 00 	movabs $0x801454,%r13
  802757:	00 00 00 
            sys_yield();
  80275a:	49 be f1 13 80 00 00 	movabs $0x8013f1,%r14
  802761:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802764:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802769:	74 7a                	je     8027e5 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80276b:	8b 03                	mov    (%rbx),%eax
  80276d:	3b 43 04             	cmp    0x4(%rbx),%eax
  802770:	75 26                	jne    802798 <devpipe_read+0x79>
            if (i > 0) return i;
  802772:	4d 85 ff             	test   %r15,%r15
  802775:	75 74                	jne    8027eb <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802777:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80277c:	48 89 da             	mov    %rbx,%rdx
  80277f:	be 00 10 00 00       	mov    $0x1000,%esi
  802784:	4c 89 e7             	mov    %r12,%rdi
  802787:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80278a:	85 c0                	test   %eax,%eax
  80278c:	74 6f                	je     8027fd <devpipe_read+0xde>
            sys_yield();
  80278e:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802791:	8b 03                	mov    (%rbx),%eax
  802793:	3b 43 04             	cmp    0x4(%rbx),%eax
  802796:	74 df                	je     802777 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802798:	48 63 c8             	movslq %eax,%rcx
  80279b:	48 89 ca             	mov    %rcx,%rdx
  80279e:	48 c1 ea 03          	shr    $0x3,%rdx
  8027a2:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8027a9:	08 10 20 
  8027ac:	48 f7 e2             	mul    %rdx
  8027af:	48 c1 ea 06          	shr    $0x6,%rdx
  8027b3:	48 89 d0             	mov    %rdx,%rax
  8027b6:	48 c1 e0 09          	shl    $0x9,%rax
  8027ba:	48 29 d0             	sub    %rdx,%rax
  8027bd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8027c4:	00 
  8027c5:	48 89 c8             	mov    %rcx,%rax
  8027c8:	48 29 d0             	sub    %rdx,%rax
  8027cb:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8027d0:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8027d4:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8027d8:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8027db:	49 83 c7 01          	add    $0x1,%r15
  8027df:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8027e3:	75 86                	jne    80276b <devpipe_read+0x4c>
    return n;
  8027e5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8027e9:	eb 03                	jmp    8027ee <devpipe_read+0xcf>
            if (i > 0) return i;
  8027eb:	4c 89 f8             	mov    %r15,%rax
}
  8027ee:	48 83 c4 18          	add    $0x18,%rsp
  8027f2:	5b                   	pop    %rbx
  8027f3:	41 5c                	pop    %r12
  8027f5:	41 5d                	pop    %r13
  8027f7:	41 5e                	pop    %r14
  8027f9:	41 5f                	pop    %r15
  8027fb:	5d                   	pop    %rbp
  8027fc:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8027fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802802:	eb ea                	jmp    8027ee <devpipe_read+0xcf>

0000000000802804 <pipe>:
pipe(int pfd[2]) {
  802804:	55                   	push   %rbp
  802805:	48 89 e5             	mov    %rsp,%rbp
  802808:	41 55                	push   %r13
  80280a:	41 54                	push   %r12
  80280c:	53                   	push   %rbx
  80280d:	48 83 ec 18          	sub    $0x18,%rsp
  802811:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802814:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802818:	48 b8 69 1b 80 00 00 	movabs $0x801b69,%rax
  80281f:	00 00 00 
  802822:	ff d0                	call   *%rax
  802824:	89 c3                	mov    %eax,%ebx
  802826:	85 c0                	test   %eax,%eax
  802828:	0f 88 a0 01 00 00    	js     8029ce <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80282e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802833:	ba 00 10 00 00       	mov    $0x1000,%edx
  802838:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80283c:	bf 00 00 00 00       	mov    $0x0,%edi
  802841:	48 b8 80 14 80 00 00 	movabs $0x801480,%rax
  802848:	00 00 00 
  80284b:	ff d0                	call   *%rax
  80284d:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80284f:	85 c0                	test   %eax,%eax
  802851:	0f 88 77 01 00 00    	js     8029ce <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802857:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80285b:	48 b8 69 1b 80 00 00 	movabs $0x801b69,%rax
  802862:	00 00 00 
  802865:	ff d0                	call   *%rax
  802867:	89 c3                	mov    %eax,%ebx
  802869:	85 c0                	test   %eax,%eax
  80286b:	0f 88 43 01 00 00    	js     8029b4 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802871:	b9 46 00 00 00       	mov    $0x46,%ecx
  802876:	ba 00 10 00 00       	mov    $0x1000,%edx
  80287b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80287f:	bf 00 00 00 00       	mov    $0x0,%edi
  802884:	48 b8 80 14 80 00 00 	movabs $0x801480,%rax
  80288b:	00 00 00 
  80288e:	ff d0                	call   *%rax
  802890:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802892:	85 c0                	test   %eax,%eax
  802894:	0f 88 1a 01 00 00    	js     8029b4 <pipe+0x1b0>
    va = fd2data(fd0);
  80289a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80289e:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  8028a5:	00 00 00 
  8028a8:	ff d0                	call   *%rax
  8028aa:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8028ad:	b9 46 00 00 00       	mov    $0x46,%ecx
  8028b2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028b7:	48 89 c6             	mov    %rax,%rsi
  8028ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8028bf:	48 b8 80 14 80 00 00 	movabs $0x801480,%rax
  8028c6:	00 00 00 
  8028c9:	ff d0                	call   *%rax
  8028cb:	89 c3                	mov    %eax,%ebx
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	0f 88 c5 00 00 00    	js     80299a <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8028d5:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8028d9:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  8028e0:	00 00 00 
  8028e3:	ff d0                	call   *%rax
  8028e5:	48 89 c1             	mov    %rax,%rcx
  8028e8:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8028ee:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8028f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f9:	4c 89 ee             	mov    %r13,%rsi
  8028fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802901:	48 b8 e7 14 80 00 00 	movabs $0x8014e7,%rax
  802908:	00 00 00 
  80290b:	ff d0                	call   *%rax
  80290d:	89 c3                	mov    %eax,%ebx
  80290f:	85 c0                	test   %eax,%eax
  802911:	78 6e                	js     802981 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802913:	be 00 10 00 00       	mov    $0x1000,%esi
  802918:	4c 89 ef             	mov    %r13,%rdi
  80291b:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  802922:	00 00 00 
  802925:	ff d0                	call   *%rax
  802927:	83 f8 02             	cmp    $0x2,%eax
  80292a:	0f 85 ab 00 00 00    	jne    8029db <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802930:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802937:	00 00 
  802939:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80293d:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80293f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802943:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80294a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80294e:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802950:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802954:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80295b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80295f:	48 bb 3b 1b 80 00 00 	movabs $0x801b3b,%rbx
  802966:	00 00 00 
  802969:	ff d3                	call   *%rbx
  80296b:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80296f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802973:	ff d3                	call   *%rbx
  802975:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80297a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80297f:	eb 4d                	jmp    8029ce <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802981:	ba 00 10 00 00       	mov    $0x1000,%edx
  802986:	4c 89 ee             	mov    %r13,%rsi
  802989:	bf 00 00 00 00       	mov    $0x0,%edi
  80298e:	48 b8 4c 15 80 00 00 	movabs $0x80154c,%rax
  802995:	00 00 00 
  802998:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80299a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80299f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a8:	48 b8 4c 15 80 00 00 	movabs $0x80154c,%rax
  8029af:	00 00 00 
  8029b2:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8029b4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8029b9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8029bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c2:	48 b8 4c 15 80 00 00 	movabs $0x80154c,%rax
  8029c9:	00 00 00 
  8029cc:	ff d0                	call   *%rax
}
  8029ce:	89 d8                	mov    %ebx,%eax
  8029d0:	48 83 c4 18          	add    $0x18,%rsp
  8029d4:	5b                   	pop    %rbx
  8029d5:	41 5c                	pop    %r12
  8029d7:	41 5d                	pop    %r13
  8029d9:	5d                   	pop    %rbp
  8029da:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8029db:	48 b9 b0 36 80 00 00 	movabs $0x8036b0,%rcx
  8029e2:	00 00 00 
  8029e5:	48 ba 87 36 80 00 00 	movabs $0x803687,%rdx
  8029ec:	00 00 00 
  8029ef:	be 2e 00 00 00       	mov    $0x2e,%esi
  8029f4:	48 bf 9c 36 80 00 00 	movabs $0x80369c,%rdi
  8029fb:	00 00 00 
  8029fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802a03:	49 b8 35 04 80 00 00 	movabs $0x800435,%r8
  802a0a:	00 00 00 
  802a0d:	41 ff d0             	call   *%r8

0000000000802a10 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802a10:	55                   	push   %rbp
  802a11:	48 89 e5             	mov    %rsp,%rbp
  802a14:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802a18:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802a1c:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  802a23:	00 00 00 
  802a26:	ff d0                	call   *%rax
    if (res < 0) return res;
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	78 35                	js     802a61 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802a2c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802a30:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  802a37:	00 00 00 
  802a3a:	ff d0                	call   *%rax
  802a3c:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802a3f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802a44:	be 00 10 00 00       	mov    $0x1000,%esi
  802a49:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802a4d:	48 b8 54 14 80 00 00 	movabs $0x801454,%rax
  802a54:	00 00 00 
  802a57:	ff d0                	call   *%rax
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	0f 94 c0             	sete   %al
  802a5e:	0f b6 c0             	movzbl %al,%eax
}
  802a61:	c9                   	leave  
  802a62:	c3                   	ret    

0000000000802a63 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802a63:	48 89 f8             	mov    %rdi,%rax
  802a66:	48 c1 e8 27          	shr    $0x27,%rax
  802a6a:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802a71:	01 00 00 
  802a74:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a78:	f6 c2 01             	test   $0x1,%dl
  802a7b:	74 6d                	je     802aea <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802a7d:	48 89 f8             	mov    %rdi,%rax
  802a80:	48 c1 e8 1e          	shr    $0x1e,%rax
  802a84:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802a8b:	01 00 00 
  802a8e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a92:	f6 c2 01             	test   $0x1,%dl
  802a95:	74 62                	je     802af9 <get_uvpt_entry+0x96>
  802a97:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802a9e:	01 00 00 
  802aa1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802aa5:	f6 c2 80             	test   $0x80,%dl
  802aa8:	75 4f                	jne    802af9 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802aaa:	48 89 f8             	mov    %rdi,%rax
  802aad:	48 c1 e8 15          	shr    $0x15,%rax
  802ab1:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802ab8:	01 00 00 
  802abb:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802abf:	f6 c2 01             	test   $0x1,%dl
  802ac2:	74 44                	je     802b08 <get_uvpt_entry+0xa5>
  802ac4:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802acb:	01 00 00 
  802ace:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802ad2:	f6 c2 80             	test   $0x80,%dl
  802ad5:	75 31                	jne    802b08 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802ad7:	48 c1 ef 0c          	shr    $0xc,%rdi
  802adb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ae2:	01 00 00 
  802ae5:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802ae9:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802aea:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802af1:	01 00 00 
  802af4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802af8:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802af9:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802b00:	01 00 00 
  802b03:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802b07:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802b08:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802b0f:	01 00 00 
  802b12:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802b16:	c3                   	ret    

0000000000802b17 <get_prot>:

int
get_prot(void *va) {
  802b17:	55                   	push   %rbp
  802b18:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b1b:	48 b8 63 2a 80 00 00 	movabs $0x802a63,%rax
  802b22:	00 00 00 
  802b25:	ff d0                	call   *%rax
  802b27:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802b2a:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802b2f:	89 c1                	mov    %eax,%ecx
  802b31:	83 c9 04             	or     $0x4,%ecx
  802b34:	f6 c2 01             	test   $0x1,%dl
  802b37:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802b3a:	89 c1                	mov    %eax,%ecx
  802b3c:	83 c9 02             	or     $0x2,%ecx
  802b3f:	f6 c2 02             	test   $0x2,%dl
  802b42:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802b45:	89 c1                	mov    %eax,%ecx
  802b47:	83 c9 01             	or     $0x1,%ecx
  802b4a:	48 85 d2             	test   %rdx,%rdx
  802b4d:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802b50:	89 c1                	mov    %eax,%ecx
  802b52:	83 c9 40             	or     $0x40,%ecx
  802b55:	f6 c6 04             	test   $0x4,%dh
  802b58:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802b5b:	5d                   	pop    %rbp
  802b5c:	c3                   	ret    

0000000000802b5d <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802b5d:	55                   	push   %rbp
  802b5e:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b61:	48 b8 63 2a 80 00 00 	movabs $0x802a63,%rax
  802b68:	00 00 00 
  802b6b:	ff d0                	call   *%rax
    return pte & PTE_D;
  802b6d:	48 c1 e8 06          	shr    $0x6,%rax
  802b71:	83 e0 01             	and    $0x1,%eax
}
  802b74:	5d                   	pop    %rbp
  802b75:	c3                   	ret    

0000000000802b76 <is_page_present>:

bool
is_page_present(void *va) {
  802b76:	55                   	push   %rbp
  802b77:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802b7a:	48 b8 63 2a 80 00 00 	movabs $0x802a63,%rax
  802b81:	00 00 00 
  802b84:	ff d0                	call   *%rax
  802b86:	83 e0 01             	and    $0x1,%eax
}
  802b89:	5d                   	pop    %rbp
  802b8a:	c3                   	ret    

0000000000802b8b <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802b8b:	55                   	push   %rbp
  802b8c:	48 89 e5             	mov    %rsp,%rbp
  802b8f:	41 57                	push   %r15
  802b91:	41 56                	push   %r14
  802b93:	41 55                	push   %r13
  802b95:	41 54                	push   %r12
  802b97:	53                   	push   %rbx
  802b98:	48 83 ec 28          	sub    $0x28,%rsp
  802b9c:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802ba0:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802ba4:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802ba9:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802bb0:	01 00 00 
  802bb3:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802bba:	01 00 00 
  802bbd:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802bc4:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802bc7:	49 bf 17 2b 80 00 00 	movabs $0x802b17,%r15
  802bce:	00 00 00 
  802bd1:	eb 16                	jmp    802be9 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802bd3:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802bda:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802be1:	00 00 00 
  802be4:	48 39 c3             	cmp    %rax,%rbx
  802be7:	77 73                	ja     802c5c <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802be9:	48 89 d8             	mov    %rbx,%rax
  802bec:	48 c1 e8 27          	shr    $0x27,%rax
  802bf0:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802bf4:	a8 01                	test   $0x1,%al
  802bf6:	74 db                	je     802bd3 <foreach_shared_region+0x48>
  802bf8:	48 89 d8             	mov    %rbx,%rax
  802bfb:	48 c1 e8 1e          	shr    $0x1e,%rax
  802bff:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802c04:	a8 01                	test   $0x1,%al
  802c06:	74 cb                	je     802bd3 <foreach_shared_region+0x48>
  802c08:	48 89 d8             	mov    %rbx,%rax
  802c0b:	48 c1 e8 15          	shr    $0x15,%rax
  802c0f:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802c13:	a8 01                	test   $0x1,%al
  802c15:	74 bc                	je     802bd3 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802c17:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802c1b:	48 89 df             	mov    %rbx,%rdi
  802c1e:	41 ff d7             	call   *%r15
  802c21:	a8 40                	test   $0x40,%al
  802c23:	75 09                	jne    802c2e <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802c25:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802c2c:	eb ac                	jmp    802bda <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802c2e:	48 89 df             	mov    %rbx,%rdi
  802c31:	48 b8 76 2b 80 00 00 	movabs $0x802b76,%rax
  802c38:	00 00 00 
  802c3b:	ff d0                	call   *%rax
  802c3d:	84 c0                	test   %al,%al
  802c3f:	74 e4                	je     802c25 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802c41:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802c48:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802c4c:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802c50:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802c54:	ff d0                	call   *%rax
  802c56:	85 c0                	test   %eax,%eax
  802c58:	79 cb                	jns    802c25 <foreach_shared_region+0x9a>
  802c5a:	eb 05                	jmp    802c61 <foreach_shared_region+0xd6>
    }
    return 0;
  802c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c61:	48 83 c4 28          	add    $0x28,%rsp
  802c65:	5b                   	pop    %rbx
  802c66:	41 5c                	pop    %r12
  802c68:	41 5d                	pop    %r13
  802c6a:	41 5e                	pop    %r14
  802c6c:	41 5f                	pop    %r15
  802c6e:	5d                   	pop    %rbp
  802c6f:	c3                   	ret    

0000000000802c70 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802c70:	b8 00 00 00 00       	mov    $0x0,%eax
  802c75:	c3                   	ret    

0000000000802c76 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802c76:	55                   	push   %rbp
  802c77:	48 89 e5             	mov    %rsp,%rbp
  802c7a:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802c7d:	48 be d4 36 80 00 00 	movabs $0x8036d4,%rsi
  802c84:	00 00 00 
  802c87:	48 b8 c6 0e 80 00 00 	movabs $0x800ec6,%rax
  802c8e:	00 00 00 
  802c91:	ff d0                	call   *%rax
    return 0;
}
  802c93:	b8 00 00 00 00       	mov    $0x0,%eax
  802c98:	5d                   	pop    %rbp
  802c99:	c3                   	ret    

0000000000802c9a <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802c9a:	55                   	push   %rbp
  802c9b:	48 89 e5             	mov    %rsp,%rbp
  802c9e:	41 57                	push   %r15
  802ca0:	41 56                	push   %r14
  802ca2:	41 55                	push   %r13
  802ca4:	41 54                	push   %r12
  802ca6:	53                   	push   %rbx
  802ca7:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802cae:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802cb5:	48 85 d2             	test   %rdx,%rdx
  802cb8:	74 78                	je     802d32 <devcons_write+0x98>
  802cba:	49 89 d6             	mov    %rdx,%r14
  802cbd:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802cc3:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802cc8:	49 bf c1 10 80 00 00 	movabs $0x8010c1,%r15
  802ccf:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802cd2:	4c 89 f3             	mov    %r14,%rbx
  802cd5:	48 29 f3             	sub    %rsi,%rbx
  802cd8:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802cdc:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802ce1:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802ce5:	4c 63 eb             	movslq %ebx,%r13
  802ce8:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802cef:	4c 89 ea             	mov    %r13,%rdx
  802cf2:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802cf9:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802cfc:	4c 89 ee             	mov    %r13,%rsi
  802cff:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802d06:	48 b8 f7 12 80 00 00 	movabs $0x8012f7,%rax
  802d0d:	00 00 00 
  802d10:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802d12:	41 01 dc             	add    %ebx,%r12d
  802d15:	49 63 f4             	movslq %r12d,%rsi
  802d18:	4c 39 f6             	cmp    %r14,%rsi
  802d1b:	72 b5                	jb     802cd2 <devcons_write+0x38>
    return res;
  802d1d:	49 63 c4             	movslq %r12d,%rax
}
  802d20:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802d27:	5b                   	pop    %rbx
  802d28:	41 5c                	pop    %r12
  802d2a:	41 5d                	pop    %r13
  802d2c:	41 5e                	pop    %r14
  802d2e:	41 5f                	pop    %r15
  802d30:	5d                   	pop    %rbp
  802d31:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802d32:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d38:	eb e3                	jmp    802d1d <devcons_write+0x83>

0000000000802d3a <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d3a:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802d3d:	ba 00 00 00 00       	mov    $0x0,%edx
  802d42:	48 85 c0             	test   %rax,%rax
  802d45:	74 55                	je     802d9c <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d47:	55                   	push   %rbp
  802d48:	48 89 e5             	mov    %rsp,%rbp
  802d4b:	41 55                	push   %r13
  802d4d:	41 54                	push   %r12
  802d4f:	53                   	push   %rbx
  802d50:	48 83 ec 08          	sub    $0x8,%rsp
  802d54:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802d57:	48 bb 24 13 80 00 00 	movabs $0x801324,%rbx
  802d5e:	00 00 00 
  802d61:	49 bc f1 13 80 00 00 	movabs $0x8013f1,%r12
  802d68:	00 00 00 
  802d6b:	eb 03                	jmp    802d70 <devcons_read+0x36>
  802d6d:	41 ff d4             	call   *%r12
  802d70:	ff d3                	call   *%rbx
  802d72:	85 c0                	test   %eax,%eax
  802d74:	74 f7                	je     802d6d <devcons_read+0x33>
    if (c < 0) return c;
  802d76:	48 63 d0             	movslq %eax,%rdx
  802d79:	78 13                	js     802d8e <devcons_read+0x54>
    if (c == 0x04) return 0;
  802d7b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d80:	83 f8 04             	cmp    $0x4,%eax
  802d83:	74 09                	je     802d8e <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802d85:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802d89:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802d8e:	48 89 d0             	mov    %rdx,%rax
  802d91:	48 83 c4 08          	add    $0x8,%rsp
  802d95:	5b                   	pop    %rbx
  802d96:	41 5c                	pop    %r12
  802d98:	41 5d                	pop    %r13
  802d9a:	5d                   	pop    %rbp
  802d9b:	c3                   	ret    
  802d9c:	48 89 d0             	mov    %rdx,%rax
  802d9f:	c3                   	ret    

0000000000802da0 <cputchar>:
cputchar(int ch) {
  802da0:	55                   	push   %rbp
  802da1:	48 89 e5             	mov    %rsp,%rbp
  802da4:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802da8:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802dac:	be 01 00 00 00       	mov    $0x1,%esi
  802db1:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802db5:	48 b8 f7 12 80 00 00 	movabs $0x8012f7,%rax
  802dbc:	00 00 00 
  802dbf:	ff d0                	call   *%rax
}
  802dc1:	c9                   	leave  
  802dc2:	c3                   	ret    

0000000000802dc3 <getchar>:
getchar(void) {
  802dc3:	55                   	push   %rbp
  802dc4:	48 89 e5             	mov    %rsp,%rbp
  802dc7:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802dcb:	ba 01 00 00 00       	mov    $0x1,%edx
  802dd0:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802dd4:	bf 00 00 00 00       	mov    $0x0,%edi
  802dd9:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  802de0:	00 00 00 
  802de3:	ff d0                	call   *%rax
  802de5:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802de7:	85 c0                	test   %eax,%eax
  802de9:	78 06                	js     802df1 <getchar+0x2e>
  802deb:	74 08                	je     802df5 <getchar+0x32>
  802ded:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802df1:	89 d0                	mov    %edx,%eax
  802df3:	c9                   	leave  
  802df4:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802df5:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802dfa:	eb f5                	jmp    802df1 <getchar+0x2e>

0000000000802dfc <iscons>:
iscons(int fdnum) {
  802dfc:	55                   	push   %rbp
  802dfd:	48 89 e5             	mov    %rsp,%rbp
  802e00:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802e04:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802e08:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  802e0f:	00 00 00 
  802e12:	ff d0                	call   *%rax
    if (res < 0) return res;
  802e14:	85 c0                	test   %eax,%eax
  802e16:	78 18                	js     802e30 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802e18:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e1c:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802e23:	00 00 00 
  802e26:	8b 00                	mov    (%rax),%eax
  802e28:	39 02                	cmp    %eax,(%rdx)
  802e2a:	0f 94 c0             	sete   %al
  802e2d:	0f b6 c0             	movzbl %al,%eax
}
  802e30:	c9                   	leave  
  802e31:	c3                   	ret    

0000000000802e32 <opencons>:
opencons(void) {
  802e32:	55                   	push   %rbp
  802e33:	48 89 e5             	mov    %rsp,%rbp
  802e36:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802e3a:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802e3e:	48 b8 69 1b 80 00 00 	movabs $0x801b69,%rax
  802e45:	00 00 00 
  802e48:	ff d0                	call   *%rax
  802e4a:	85 c0                	test   %eax,%eax
  802e4c:	78 49                	js     802e97 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802e4e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802e53:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e58:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802e5c:	bf 00 00 00 00       	mov    $0x0,%edi
  802e61:	48 b8 80 14 80 00 00 	movabs $0x801480,%rax
  802e68:	00 00 00 
  802e6b:	ff d0                	call   *%rax
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	78 26                	js     802e97 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802e71:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e75:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802e7c:	00 00 
  802e7e:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802e80:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802e84:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802e8b:	48 b8 3b 1b 80 00 00 	movabs $0x801b3b,%rax
  802e92:	00 00 00 
  802e95:	ff d0                	call   *%rax
}
  802e97:	c9                   	leave  
  802e98:	c3                   	ret    
  802e99:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000802ea0 <__rodata_start>:
  802ea0:	74 65                	je     802f07 <__rodata_start+0x67>
  802ea2:	73 74                	jae    802f18 <__rodata_start+0x78>
  802ea4:	69 6e 67 20 66 6f 72 	imul   $0x726f6620,0x67(%rsi),%ebp
  802eab:	20 64 75 70          	and    %ah,0x70(%rbp,%rsi,2)
  802eaf:	20 72 61             	and    %dh,0x61(%rdx)
  802eb2:	63 65 2e             	movsxd 0x2e(%rbp),%esp
  802eb5:	2e 2e 0a 00          	cs cs or (%rax),%al
  802eb9:	70 69                	jo     802f24 <__rodata_start+0x84>
  802ebb:	70 65                	jo     802f22 <__rodata_start+0x82>
  802ebd:	3a 20                	cmp    (%rax),%ah
  802ebf:	25 69 00 75 73       	and    $0x73750069,%eax
  802ec4:	65 72 2f             	gs jb  802ef6 <__rodata_start+0x56>
  802ec7:	74 65                	je     802f2e <__rodata_start+0x8e>
  802ec9:	73 74                	jae    802f3f <__rodata_start+0x9f>
  802ecb:	70 69                	jo     802f36 <__rodata_start+0x96>
  802ecd:	70 65                	jo     802f34 <__rodata_start+0x94>
  802ecf:	72 61                	jb     802f32 <__rodata_start+0x92>
  802ed1:	63 65 2e             	movsxd 0x2e(%rbp),%esp
  802ed4:	63 00                	movsxd (%rax),%eax
  802ed6:	52                   	push   %rdx
  802ed7:	41                   	rex.B
  802ed8:	43                   	rex.XB
  802ed9:	45 3a 20             	cmp    (%r8),%r12b
  802edc:	70 69                	jo     802f47 <__rodata_start+0xa7>
  802ede:	70 65                	jo     802f45 <__rodata_start+0xa5>
  802ee0:	20 61 70             	and    %ah,0x70(%rcx)
  802ee3:	70 65                	jo     802f4a <__rodata_start+0xaa>
  802ee5:	61                   	(bad)  
  802ee6:	72 73                	jb     802f5b <__rodata_start+0xbb>
  802ee8:	20 63 6c             	and    %ah,0x6c(%rbx)
  802eeb:	6f                   	outsl  %ds:(%rsi),(%dx)
  802eec:	73 65                	jae    802f53 <__rodata_start+0xb3>
  802eee:	64 0a 00             	or     %fs:(%rax),%al
  802ef1:	70 69                	jo     802f5c <__rodata_start+0xbc>
  802ef3:	64 20 69 73          	and    %ch,%fs:0x73(%rcx)
  802ef7:	20 25 64 0a 00 6b    	and    %ah,0x6b000a64(%rip)        # 6b803961 <__bss_end+0x6affb961>
  802efd:	69 64 20 69 73 20 25 	imul   $0x64252073,0x69(%rax,%riz,1),%esp
  802f04:	64 
  802f05:	0a 00                	or     (%rax),%al
  802f07:	63 68 69             	movsxd 0x69(%rax),%ebp
  802f0a:	6c                   	insb   (%dx),%es:(%rdi)
  802f0b:	64 20 64 6f 6e       	and    %ah,%fs:0x6e(%rdi,%rbp,2)
  802f10:	65 20 77 69          	and    %dh,%gs:0x69(%rdi)
  802f14:	74 68                	je     802f7e <__rodata_start+0xde>
  802f16:	20 6c 6f 6f          	and    %ch,0x6f(%rdi,%rbp,2)
  802f1a:	70 0a                	jo     802f26 <__rodata_start+0x86>
  802f1c:	00 63 61             	add    %ah,0x61(%rbx)
  802f1f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f20:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f21:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f22:	74 20                	je     802f44 <__rodata_start+0xa4>
  802f24:	6c                   	insb   (%dx),%es:(%rdi)
  802f25:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f26:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f27:	6b 20 75             	imul   $0x75,(%rax),%esp
  802f2a:	70 20                	jo     802f4c <__rodata_start+0xac>
  802f2c:	70 5b                	jo     802f89 <__rodata_start+0xe9>
  802f2e:	30 5d 3a             	xor    %bl,0x3a(%rbp)
  802f31:	20 25 69 00 0a 63    	and    %ah,0x630a0069(%rip)        # 638a2fa0 <__bss_end+0x6309afa0>
  802f37:	68 69 6c 64 20       	push   $0x20646c69
  802f3c:	64 65 74 65          	fs gs je 802fa5 <__rodata_start+0x105>
  802f40:	63 74 65 64          	movsxd 0x64(%rbp,%riz,2),%esi
  802f44:	20 72 61             	and    %dh,0x61(%rdx)
  802f47:	63 65 0a             	movsxd 0xa(%rbp),%esp
  802f4a:	00 0f                	add    %cl,(%rdi)
  802f4c:	1f                   	(bad)  
  802f4d:	44 00 00             	add    %r8b,(%rax)
  802f50:	73 6f                	jae    802fc1 <__rodata_start+0x121>
  802f52:	6d                   	insl   (%dx),%es:(%rdi)
  802f53:	65 68 6f 77 20 74    	gs push $0x7420776f
  802f59:	68 65 20 6f 74       	push   $0x746f2065
  802f5e:	68 65 72 20 65       	push   $0x65207265
  802f63:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f64:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802f68:	20 70 5b             	and    %dh,0x5b(%rax)
  802f6b:	30 5d 20             	xor    %bl,0x20(%rbp)
  802f6e:	67 6f                	outsl  %ds:(%esi),(%dx)
  802f70:	74 20                	je     802f92 <__rodata_start+0xf2>
  802f72:	63 6c 6f 73          	movsxd 0x73(%rdi,%rbp,2),%ebp
  802f76:	65 64 21 00          	gs and %eax,%fs:(%rax)
  802f7a:	00 00                	add    %al,(%rax)
  802f7c:	00 00                	add    %al,(%rax)
  802f7e:	00 00                	add    %al,(%rax)
  802f80:	0a 72 61             	or     0x61(%rdx),%dh
  802f83:	63 65 20             	movsxd 0x20(%rbp),%esp
  802f86:	64 69 64 6e 27 74 20 	imul   $0x61682074,%fs:0x27(%rsi,%rbp,2),%esp
  802f8d:	68 61 
  802f8f:	70 70                	jo     803001 <__rodata_start+0x161>
  802f91:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802f93:	20 28                	and    %ch,(%rax)
  802f95:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f96:	75 6d                	jne    803005 <__rodata_start+0x165>
  802f98:	62                   	(bad)  
  802f99:	65 72 20             	gs jb  802fbc <__rodata_start+0x11c>
  802f9c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f9d:	66 20 74 65 73       	data16 and %dh,0x73(%rbp,%riz,2)
  802fa2:	74 73                	je     803017 <__rodata_start+0x177>
  802fa4:	3a 20                	cmp    (%rax),%ah
  802fa6:	25 64 29 0a 00       	and    $0xa2964,%eax
  802fab:	3c 75                	cmp    $0x75,%al
  802fad:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fae:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802fb2:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fb3:	3e 00 0f             	ds add %cl,(%rdi)
  802fb6:	1f                   	(bad)  
  802fb7:	00 5b 25             	add    %bl,0x25(%rbx)
  802fba:	30 38                	xor    %bh,(%rax)
  802fbc:	78 5d                	js     80301b <__rodata_start+0x17b>
  802fbe:	20 75 73             	and    %dh,0x73(%rbp)
  802fc1:	65 72 20             	gs jb  802fe4 <__rodata_start+0x144>
  802fc4:	70 61                	jo     803027 <__rodata_start+0x187>
  802fc6:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fc7:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  802fce:	73 20                	jae    802ff0 <__rodata_start+0x150>
  802fd0:	61                   	(bad)  
  802fd1:	74 20                	je     802ff3 <__rodata_start+0x153>
  802fd3:	25 73 3a 25 64       	and    $0x64253a73,%eax
  802fd8:	3a 20                	cmp    (%rax),%ah
  802fda:	00 30                	add    %dh,(%rax)
  802fdc:	31 32                	xor    %esi,(%rdx)
  802fde:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802fe5:	41                   	rex.B
  802fe6:	42                   	rex.X
  802fe7:	43                   	rex.XB
  802fe8:	44                   	rex.R
  802fe9:	45                   	rex.RB
  802fea:	46 00 30             	rex.RX add %r14b,(%rax)
  802fed:	31 32                	xor    %esi,(%rdx)
  802fef:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802ff6:	61                   	(bad)  
  802ff7:	62 63 64 65 66       	(bad)
  802ffc:	00 28                	add    %ch,(%rax)
  802ffe:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fff:	75 6c                	jne    80306d <__rodata_start+0x1cd>
  803001:	6c                   	insb   (%dx),%es:(%rdi)
  803002:	29 00                	sub    %eax,(%rax)
  803004:	65 72 72             	gs jb  803079 <__rodata_start+0x1d9>
  803007:	6f                   	outsl  %ds:(%rsi),(%dx)
  803008:	72 20                	jb     80302a <__rodata_start+0x18a>
  80300a:	25 64 00 75 6e       	and    $0x6e750064,%eax
  80300f:	73 70                	jae    803081 <__rodata_start+0x1e1>
  803011:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  803015:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  80301c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80301d:	72 00                	jb     80301f <__rodata_start+0x17f>
  80301f:	62 61 64 20 65       	(bad)
  803024:	6e                   	outsb  %ds:(%rsi),(%dx)
  803025:	76 69                	jbe    803090 <__rodata_start+0x1f0>
  803027:	72 6f                	jb     803098 <__rodata_start+0x1f8>
  803029:	6e                   	outsb  %ds:(%rsi),(%dx)
  80302a:	6d                   	insl   (%dx),%es:(%rdi)
  80302b:	65 6e                	outsb  %gs:(%rsi),(%dx)
  80302d:	74 00                	je     80302f <__rodata_start+0x18f>
  80302f:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  803036:	20 70 61             	and    %dh,0x61(%rax)
  803039:	72 61                	jb     80309c <__rodata_start+0x1fc>
  80303b:	6d                   	insl   (%dx),%es:(%rdi)
  80303c:	65 74 65             	gs je  8030a4 <__rodata_start+0x204>
  80303f:	72 00                	jb     803041 <__rodata_start+0x1a1>
  803041:	6f                   	outsl  %ds:(%rsi),(%dx)
  803042:	75 74                	jne    8030b8 <__rodata_start+0x218>
  803044:	20 6f 66             	and    %ch,0x66(%rdi)
  803047:	20 6d 65             	and    %ch,0x65(%rbp)
  80304a:	6d                   	insl   (%dx),%es:(%rdi)
  80304b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80304c:	72 79                	jb     8030c7 <__rodata_start+0x227>
  80304e:	00 6f 75             	add    %ch,0x75(%rdi)
  803051:	74 20                	je     803073 <__rodata_start+0x1d3>
  803053:	6f                   	outsl  %ds:(%rsi),(%dx)
  803054:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  803058:	76 69                	jbe    8030c3 <__rodata_start+0x223>
  80305a:	72 6f                	jb     8030cb <__rodata_start+0x22b>
  80305c:	6e                   	outsb  %ds:(%rsi),(%dx)
  80305d:	6d                   	insl   (%dx),%es:(%rdi)
  80305e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803060:	74 73                	je     8030d5 <__rodata_start+0x235>
  803062:	00 63 6f             	add    %ah,0x6f(%rbx)
  803065:	72 72                	jb     8030d9 <__rodata_start+0x239>
  803067:	75 70                	jne    8030d9 <__rodata_start+0x239>
  803069:	74 65                	je     8030d0 <__rodata_start+0x230>
  80306b:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  803070:	75 67                	jne    8030d9 <__rodata_start+0x239>
  803072:	20 69 6e             	and    %ch,0x6e(%rcx)
  803075:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803077:	00 73 65             	add    %dh,0x65(%rbx)
  80307a:	67 6d                	insl   (%dx),%es:(%edi)
  80307c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  80307e:	74 61                	je     8030e1 <__rodata_start+0x241>
  803080:	74 69                	je     8030eb <__rodata_start+0x24b>
  803082:	6f                   	outsl  %ds:(%rsi),(%dx)
  803083:	6e                   	outsb  %ds:(%rsi),(%dx)
  803084:	20 66 61             	and    %ah,0x61(%rsi)
  803087:	75 6c                	jne    8030f5 <__rodata_start+0x255>
  803089:	74 00                	je     80308b <__rodata_start+0x1eb>
  80308b:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  803092:	20 45 4c             	and    %al,0x4c(%rbp)
  803095:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  803099:	61                   	(bad)  
  80309a:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  80309f:	20 73 75             	and    %dh,0x75(%rbx)
  8030a2:	63 68 20             	movsxd 0x20(%rax),%ebp
  8030a5:	73 79                	jae    803120 <__rodata_start+0x280>
  8030a7:	73 74                	jae    80311d <__rodata_start+0x27d>
  8030a9:	65 6d                	gs insl (%dx),%es:(%rdi)
  8030ab:	20 63 61             	and    %ah,0x61(%rbx)
  8030ae:	6c                   	insb   (%dx),%es:(%rdi)
  8030af:	6c                   	insb   (%dx),%es:(%rdi)
  8030b0:	00 65 6e             	add    %ah,0x6e(%rbp)
  8030b3:	74 72                	je     803127 <__rodata_start+0x287>
  8030b5:	79 20                	jns    8030d7 <__rodata_start+0x237>
  8030b7:	6e                   	outsb  %ds:(%rsi),(%dx)
  8030b8:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030b9:	74 20                	je     8030db <__rodata_start+0x23b>
  8030bb:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8030bd:	75 6e                	jne    80312d <__rodata_start+0x28d>
  8030bf:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  8030c3:	76 20                	jbe    8030e5 <__rodata_start+0x245>
  8030c5:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  8030cc:	72 65                	jb     803133 <__rodata_start+0x293>
  8030ce:	63 76 69             	movsxd 0x69(%rsi),%esi
  8030d1:	6e                   	outsb  %ds:(%rsi),(%dx)
  8030d2:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  8030d6:	65 78 70             	gs js  803149 <__rodata_start+0x2a9>
  8030d9:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  8030de:	20 65 6e             	and    %ah,0x6e(%rbp)
  8030e1:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  8030e5:	20 66 69             	and    %ah,0x69(%rsi)
  8030e8:	6c                   	insb   (%dx),%es:(%rdi)
  8030e9:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  8030ed:	20 66 72             	and    %ah,0x72(%rsi)
  8030f0:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  8030f5:	61                   	(bad)  
  8030f6:	63 65 20             	movsxd 0x20(%rbp),%esp
  8030f9:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030fa:	6e                   	outsb  %ds:(%rsi),(%dx)
  8030fb:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  8030ff:	6b 00 74             	imul   $0x74,(%rax),%eax
  803102:	6f                   	outsl  %ds:(%rsi),(%dx)
  803103:	6f                   	outsl  %ds:(%rsi),(%dx)
  803104:	20 6d 61             	and    %ch,0x61(%rbp)
  803107:	6e                   	outsb  %ds:(%rsi),(%dx)
  803108:	79 20                	jns    80312a <__rodata_start+0x28a>
  80310a:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  803111:	72 65                	jb     803178 <__rodata_start+0x2d8>
  803113:	20 6f 70             	and    %ch,0x70(%rdi)
  803116:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803118:	00 66 69             	add    %ah,0x69(%rsi)
  80311b:	6c                   	insb   (%dx),%es:(%rdi)
  80311c:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  803120:	20 62 6c             	and    %ah,0x6c(%rdx)
  803123:	6f                   	outsl  %ds:(%rsi),(%dx)
  803124:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  803127:	6e                   	outsb  %ds:(%rsi),(%dx)
  803128:	6f                   	outsl  %ds:(%rsi),(%dx)
  803129:	74 20                	je     80314b <__rodata_start+0x2ab>
  80312b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  80312d:	75 6e                	jne    80319d <__rodata_start+0x2fd>
  80312f:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  803133:	76 61                	jbe    803196 <__rodata_start+0x2f6>
  803135:	6c                   	insb   (%dx),%es:(%rdi)
  803136:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  80313d:	00 
  80313e:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  803145:	72 65                	jb     8031ac <__rodata_start+0x30c>
  803147:	61                   	(bad)  
  803148:	64 79 20             	fs jns 80316b <__rodata_start+0x2cb>
  80314b:	65 78 69             	gs js  8031b7 <__rodata_start+0x317>
  80314e:	73 74                	jae    8031c4 <__rodata_start+0x324>
  803150:	73 00                	jae    803152 <__rodata_start+0x2b2>
  803152:	6f                   	outsl  %ds:(%rsi),(%dx)
  803153:	70 65                	jo     8031ba <__rodata_start+0x31a>
  803155:	72 61                	jb     8031b8 <__rodata_start+0x318>
  803157:	74 69                	je     8031c2 <__rodata_start+0x322>
  803159:	6f                   	outsl  %ds:(%rsi),(%dx)
  80315a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80315b:	20 6e 6f             	and    %ch,0x6f(%rsi)
  80315e:	74 20                	je     803180 <__rodata_start+0x2e0>
  803160:	73 75                	jae    8031d7 <__rodata_start+0x337>
  803162:	70 70                	jo     8031d4 <__rodata_start+0x334>
  803164:	6f                   	outsl  %ds:(%rsi),(%dx)
  803165:	72 74                	jb     8031db <__rodata_start+0x33b>
  803167:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  80316c:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  803173:	00 
  803174:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80317b:	00 00 00 
  80317e:	66 90                	xchg   %ax,%ax
  803180:	7f 07                	jg     803189 <__rodata_start+0x2e9>
  803182:	80 00 00             	addb   $0x0,(%rax)
  803185:	00 00                	add    %al,(%rax)
  803187:	00 d3                	add    %dl,%bl
  803189:	0d 80 00 00 00       	or     $0x80,%eax
  80318e:	00 00                	add    %al,(%rax)
  803190:	c3                   	ret    
  803191:	0d 80 00 00 00       	or     $0x80,%eax
  803196:	00 00                	add    %al,(%rax)
  803198:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80321e <__rodata_start+0x37e>
  80319e:	00 00                	add    %al,(%rax)
  8031a0:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803226 <__rodata_start+0x386>
  8031a6:	00 00                	add    %al,(%rax)
  8031a8:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80322e <__rodata_start+0x38e>
  8031ae:	00 00                	add    %al,(%rax)
  8031b0:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803236 <__rodata_start+0x396>
  8031b6:	00 00                	add    %al,(%rax)
  8031b8:	99                   	cltd   
  8031b9:	07                   	(bad)  
  8031ba:	80 00 00             	addb   $0x0,(%rax)
  8031bd:	00 00                	add    %al,(%rax)
  8031bf:	00 d3                	add    %dl,%bl
  8031c1:	0d 80 00 00 00       	or     $0x80,%eax
  8031c6:	00 00                	add    %al,(%rax)
  8031c8:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80324e <__rodata_start+0x3ae>
  8031ce:	00 00                	add    %al,(%rax)
  8031d0:	90                   	nop
  8031d1:	07                   	(bad)  
  8031d2:	80 00 00             	addb   $0x0,(%rax)
  8031d5:	00 00                	add    %al,(%rax)
  8031d7:	00 06                	add    %al,(%rsi)
  8031d9:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  8031df:	00 d3                	add    %dl,%bl
  8031e1:	0d 80 00 00 00       	or     $0x80,%eax
  8031e6:	00 00                	add    %al,(%rax)
  8031e8:	90                   	nop
  8031e9:	07                   	(bad)  
  8031ea:	80 00 00             	addb   $0x0,(%rax)
  8031ed:	00 00                	add    %al,(%rax)
  8031ef:	00 d3                	add    %dl,%bl
  8031f1:	07                   	(bad)  
  8031f2:	80 00 00             	addb   $0x0,(%rax)
  8031f5:	00 00                	add    %al,(%rax)
  8031f7:	00 d3                	add    %dl,%bl
  8031f9:	07                   	(bad)  
  8031fa:	80 00 00             	addb   $0x0,(%rax)
  8031fd:	00 00                	add    %al,(%rax)
  8031ff:	00 d3                	add    %dl,%bl
  803201:	07                   	(bad)  
  803202:	80 00 00             	addb   $0x0,(%rax)
  803205:	00 00                	add    %al,(%rax)
  803207:	00 d3                	add    %dl,%bl
  803209:	07                   	(bad)  
  80320a:	80 00 00             	addb   $0x0,(%rax)
  80320d:	00 00                	add    %al,(%rax)
  80320f:	00 d3                	add    %dl,%bl
  803211:	07                   	(bad)  
  803212:	80 00 00             	addb   $0x0,(%rax)
  803215:	00 00                	add    %al,(%rax)
  803217:	00 d3                	add    %dl,%bl
  803219:	07                   	(bad)  
  80321a:	80 00 00             	addb   $0x0,(%rax)
  80321d:	00 00                	add    %al,(%rax)
  80321f:	00 d3                	add    %dl,%bl
  803221:	07                   	(bad)  
  803222:	80 00 00             	addb   $0x0,(%rax)
  803225:	00 00                	add    %al,(%rax)
  803227:	00 d3                	add    %dl,%bl
  803229:	07                   	(bad)  
  80322a:	80 00 00             	addb   $0x0,(%rax)
  80322d:	00 00                	add    %al,(%rax)
  80322f:	00 d3                	add    %dl,%bl
  803231:	07                   	(bad)  
  803232:	80 00 00             	addb   $0x0,(%rax)
  803235:	00 00                	add    %al,(%rax)
  803237:	00 d3                	add    %dl,%bl
  803239:	0d 80 00 00 00       	or     $0x80,%eax
  80323e:	00 00                	add    %al,(%rax)
  803240:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8032c6 <__rodata_start+0x426>
  803246:	00 00                	add    %al,(%rax)
  803248:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8032ce <__rodata_start+0x42e>
  80324e:	00 00                	add    %al,(%rax)
  803250:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8032d6 <__rodata_start+0x436>
  803256:	00 00                	add    %al,(%rax)
  803258:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8032de <__rodata_start+0x43e>
  80325e:	00 00                	add    %al,(%rax)
  803260:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8032e6 <__rodata_start+0x446>
  803266:	00 00                	add    %al,(%rax)
  803268:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8032ee <__rodata_start+0x44e>
  80326e:	00 00                	add    %al,(%rax)
  803270:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8032f6 <__rodata_start+0x456>
  803276:	00 00                	add    %al,(%rax)
  803278:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8032fe <__rodata_start+0x45e>
  80327e:	00 00                	add    %al,(%rax)
  803280:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803306 <__rodata_start+0x466>
  803286:	00 00                	add    %al,(%rax)
  803288:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80330e <__rodata_start+0x46e>
  80328e:	00 00                	add    %al,(%rax)
  803290:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803316 <__rodata_start+0x476>
  803296:	00 00                	add    %al,(%rax)
  803298:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80331e <__rodata_start+0x47e>
  80329e:	00 00                	add    %al,(%rax)
  8032a0:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803326 <__rodata_start+0x486>
  8032a6:	00 00                	add    %al,(%rax)
  8032a8:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80332e <__rodata_start+0x48e>
  8032ae:	00 00                	add    %al,(%rax)
  8032b0:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803336 <__rodata_start+0x496>
  8032b6:	00 00                	add    %al,(%rax)
  8032b8:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80333e <__rodata_start+0x49e>
  8032be:	00 00                	add    %al,(%rax)
  8032c0:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803346 <__rodata_start+0x4a6>
  8032c6:	00 00                	add    %al,(%rax)
  8032c8:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80334e <__rodata_start+0x4ae>
  8032ce:	00 00                	add    %al,(%rax)
  8032d0:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803356 <__rodata_start+0x4b6>
  8032d6:	00 00                	add    %al,(%rax)
  8032d8:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80335e <__rodata_start+0x4be>
  8032de:	00 00                	add    %al,(%rax)
  8032e0:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803366 <__rodata_start+0x4c6>
  8032e6:	00 00                	add    %al,(%rax)
  8032e8:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80336e <__rodata_start+0x4ce>
  8032ee:	00 00                	add    %al,(%rax)
  8032f0:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803376 <__rodata_start+0x4d6>
  8032f6:	00 00                	add    %al,(%rax)
  8032f8:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80337e <__rodata_start+0x4de>
  8032fe:	00 00                	add    %al,(%rax)
  803300:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803386 <__rodata_start+0x4e6>
  803306:	00 00                	add    %al,(%rax)
  803308:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80338e <__rodata_start+0x4ee>
  80330e:	00 00                	add    %al,(%rax)
  803310:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803396 <__rodata_start+0x4f6>
  803316:	00 00                	add    %al,(%rax)
  803318:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80339e <__rodata_start+0x4fe>
  80331e:	00 00                	add    %al,(%rax)
  803320:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8033a6 <__rodata_start+0x506>
  803326:	00 00                	add    %al,(%rax)
  803328:	f8                   	clc    
  803329:	0c 80                	or     $0x80,%al
  80332b:	00 00                	add    %al,(%rax)
  80332d:	00 00                	add    %al,(%rax)
  80332f:	00 d3                	add    %dl,%bl
  803331:	0d 80 00 00 00       	or     $0x80,%eax
  803336:	00 00                	add    %al,(%rax)
  803338:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8033be <__rodata_start+0x51e>
  80333e:	00 00                	add    %al,(%rax)
  803340:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8033c6 <__rodata_start+0x526>
  803346:	00 00                	add    %al,(%rax)
  803348:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8033ce <__rodata_start+0x52e>
  80334e:	00 00                	add    %al,(%rax)
  803350:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8033d6 <__rodata_start+0x536>
  803356:	00 00                	add    %al,(%rax)
  803358:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8033de <__rodata_start+0x53e>
  80335e:	00 00                	add    %al,(%rax)
  803360:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8033e6 <__rodata_start+0x546>
  803366:	00 00                	add    %al,(%rax)
  803368:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8033ee <__rodata_start+0x54e>
  80336e:	00 00                	add    %al,(%rax)
  803370:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8033f6 <__rodata_start+0x556>
  803376:	00 00                	add    %al,(%rax)
  803378:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8033fe <__rodata_start+0x55e>
  80337e:	00 00                	add    %al,(%rax)
  803380:	24 08                	and    $0x8,%al
  803382:	80 00 00             	addb   $0x0,(%rax)
  803385:	00 00                	add    %al,(%rax)
  803387:	00 1a                	add    %bl,(%rdx)
  803389:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80338f:	00 d3                	add    %dl,%bl
  803391:	0d 80 00 00 00       	or     $0x80,%eax
  803396:	00 00                	add    %al,(%rax)
  803398:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80341e <__rodata_start+0x57e>
  80339e:	00 00                	add    %al,(%rax)
  8033a0:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803426 <__rodata_start+0x586>
  8033a6:	00 00                	add    %al,(%rax)
  8033a8:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80342e <__rodata_start+0x58e>
  8033ae:	00 00                	add    %al,(%rax)
  8033b0:	52                   	push   %rdx
  8033b1:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  8033b7:	00 d3                	add    %dl,%bl
  8033b9:	0d 80 00 00 00       	or     $0x80,%eax
  8033be:	00 00                	add    %al,(%rax)
  8033c0:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 803446 <error_string+0x6>
  8033c6:	00 00                	add    %al,(%rax)
  8033c8:	19 08                	sbb    %ecx,(%rax)
  8033ca:	80 00 00             	addb   $0x0,(%rax)
  8033cd:	00 00                	add    %al,(%rax)
  8033cf:	00 d3                	add    %dl,%bl
  8033d1:	0d 80 00 00 00       	or     $0x80,%eax
  8033d6:	00 00                	add    %al,(%rax)
  8033d8:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80345e <error_string+0x1e>
  8033de:	00 00                	add    %al,(%rax)
  8033e0:	ba 0b 80 00 00       	mov    $0x800b,%edx
  8033e5:	00 00                	add    %al,(%rax)
  8033e7:	00 82 0c 80 00 00    	add    %al,0x800c(%rdx)
  8033ed:	00 00                	add    %al,(%rax)
  8033ef:	00 d3                	add    %dl,%bl
  8033f1:	0d 80 00 00 00       	or     $0x80,%eax
  8033f6:	00 00                	add    %al,(%rax)
  8033f8:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 80347e <error_string+0x3e>
  8033fe:	00 00                	add    %al,(%rax)
  803400:	ea                   	(bad)  
  803401:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  803407:	00 d3                	add    %dl,%bl
  803409:	0d 80 00 00 00       	or     $0x80,%eax
  80340e:	00 00                	add    %al,(%rax)
  803410:	ec                   	in     (%dx),%al
  803411:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803417:	00 d3                	add    %dl,%bl
  803419:	0d 80 00 00 00       	or     $0x80,%eax
  80341e:	00 00                	add    %al,(%rax)
  803420:	d3 0d 80 00 00 00    	rorl   %cl,0x80(%rip)        # 8034a6 <error_string+0x66>
  803426:	00 00                	add    %al,(%rax)
  803428:	f8                   	clc    
  803429:	0c 80                	or     $0x80,%al
  80342b:	00 00                	add    %al,(%rax)
  80342d:	00 00                	add    %al,(%rax)
  80342f:	00 d3                	add    %dl,%bl
  803431:	0d 80 00 00 00       	or     $0x80,%eax
  803436:	00 00                	add    %al,(%rax)
  803438:	88 07                	mov    %al,(%rdi)
  80343a:	80 00 00             	addb   $0x0,(%rax)
  80343d:	00 00                	add    %al,(%rax)
	...

0000000000803440 <error_string>:
	...
  803448:	0d 30 80 00 00 00 00 00 1f 30 80 00 00 00 00 00     .0.......0......
  803458:	2f 30 80 00 00 00 00 00 41 30 80 00 00 00 00 00     /0......A0......
  803468:	4f 30 80 00 00 00 00 00 63 30 80 00 00 00 00 00     O0......c0......
  803478:	78 30 80 00 00 00 00 00 8b 30 80 00 00 00 00 00     x0.......0......
  803488:	9d 30 80 00 00 00 00 00 b1 30 80 00 00 00 00 00     .0.......0......
  803498:	c1 30 80 00 00 00 00 00 d4 30 80 00 00 00 00 00     .0.......0......
  8034a8:	eb 30 80 00 00 00 00 00 01 31 80 00 00 00 00 00     .0.......1......
  8034b8:	19 31 80 00 00 00 00 00 31 31 80 00 00 00 00 00     .1......11......
  8034c8:	3e 31 80 00 00 00 00 00 e0 34 80 00 00 00 00 00     >1.......4......
  8034d8:	52 31 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     R1......file is 
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
  8035a8:	6c 6c 3a 20 25 69 00 69 70 63 5f 73 65 6e 64 20     ll: %i.ipc_send 
  8035b8:	65 72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69 70     error: %i.lib/ip
  8035c8:	63 2e 63 00 0f 1f 40 00 5b 25 30 38 78 5d 20 75     c.c...@.[%08x] u
  8035d8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  8035e8:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  8035f8:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803608:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803618:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803628:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803638:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803648:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803658:	84 00 00 00 00 00 66 90                             ......f.

0000000000803660 <devtab>:
  803660:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803670:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803680:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  803690:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  8036a0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  8036b0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  8036c0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  8036d0:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  8036e0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8036f0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803700:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803710:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803720:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803730:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803740:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803750:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803760:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803770:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803780:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803790:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8037a0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8037b0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037c0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8037d0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8037e0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8037f0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803800:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803810:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803820:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803830:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803840:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803850:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803860:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803870:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803880:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803890:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8038a0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8038b0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038c0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8038d0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8038e0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8038f0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803900:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803910:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803920:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803930:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803940:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803950:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803960:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803970:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803980:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803990:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8039a0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8039b0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039c0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8039d0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8039e0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8039f0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a00:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a10:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a20:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a30:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a40:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a50:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a60:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a70:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a80:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a90:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803aa0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ab0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ac0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ad0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ae0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803af0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b00:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b10:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b20:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b30:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b40:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b50:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b60:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b70:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b80:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b90:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ba0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803bb0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803bc0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803bd0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803be0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803bf0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c00:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c10:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c20:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c30:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c40:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c50:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c60:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c70:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c80:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c90:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ca0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803cb0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803cc0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803cd0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ce0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803cf0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d00:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d10:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d20:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d30:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d40:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d50:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d60:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d70:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d80:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d90:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803da0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803db0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803dc0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803dd0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803de0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803df0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e00:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e10:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e20:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e30:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e40:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e50:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e60:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e70:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e80:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e90:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ea0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803eb0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ec0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ed0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ee0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ef0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f00:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f10:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f20:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f30:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f40:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f50:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f60:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f70:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f80:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f90:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803fa0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803fb0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803fc0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803fd0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803fe0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ff0:	66 2e 0f 1f 84 00 00 00 00 00 66 0f 1f 44 00 00     f.........f..D..
