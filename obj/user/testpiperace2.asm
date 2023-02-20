
obj/user/testpiperace2:     file format elf64-x86-64


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
  80001e:	e8 b8 02 00 00       	call   8002db <libmain>
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
    int p[2], r, i;
    struct Fd *fd;
    const volatile struct Env *kid;

    cprintf("testing for pipeisclosed race...\n");
  800036:	48 bf 10 2e 80 00 00 	movabs $0x802e10,%rdi
  80003d:	00 00 00 
  800040:	b8 00 00 00 00       	mov    $0x0,%eax
  800045:	48 ba fc 04 80 00 00 	movabs $0x8004fc,%rdx
  80004c:	00 00 00 
  80004f:	ff d2                	call   *%rdx
    if ((r = pipe(p)) < 0)
  800051:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  800055:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  80005c:	00 00 00 
  80005f:	ff d0                	call   *%rax
  800061:	85 c0                	test   %eax,%eax
  800063:	0f 88 9d 00 00 00    	js     800106 <umain+0xe1>
        panic("pipe: %i", r);
    if ((r = fork()) < 0)
  800069:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  800070:	00 00 00 
  800073:	ff d0                	call   *%rax
  800075:	89 45 bc             	mov    %eax,-0x44(%rbp)
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 88 b3 00 00 00    	js     800133 <umain+0x10e>
        panic("fork: %i", r);
    if (r == 0) {
  800080:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  800084:	0f 84 d6 00 00 00    	je     800160 <umain+0x13b>
     * it shouldn't.
     *
     * So either way, pipeisclosed is going give a wrong answer. */

    kid = &envs[ENVX(r)];
    while (kid->env_status == ENV_RUNNABLE) {
  80008a:	8b 45 bc             	mov    -0x44(%rbp),%eax
  80008d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800092:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800096:	48 8d 1c 50          	lea    (%rax,%rdx,2),%rbx
  80009a:	48 c1 e3 04          	shl    $0x4,%rbx
  80009e:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8000a5:	00 00 00 
  8000a8:	48 01 c3             	add    %rax,%rbx
        if (pipeisclosed(p[0]) != 0) {
  8000ab:	49 bc e8 27 80 00 00 	movabs $0x8027e8,%r12
  8000b2:	00 00 00 
    while (kid->env_status == ENV_RUNNABLE) {
  8000b5:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
  8000bb:	83 f8 02             	cmp    $0x2,%eax
  8000be:	0f 85 41 01 00 00    	jne    800205 <umain+0x1e0>
        if (pipeisclosed(p[0]) != 0) {
  8000c4:	8b 7d c8             	mov    -0x38(%rbp),%edi
  8000c7:	41 ff d4             	call   *%r12
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	74 e7                	je     8000b5 <umain+0x90>
            cprintf("\nRACE: pipe appears closed\n");
  8000ce:	48 bf 84 2e 80 00 00 	movabs $0x802e84,%rdi
  8000d5:	00 00 00 
  8000d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000dd:	48 ba fc 04 80 00 00 	movabs $0x8004fc,%rdx
  8000e4:	00 00 00 
  8000e7:	ff d2                	call   *%rdx
            sys_env_destroy(r);
  8000e9:	8b 7d bc             	mov    -0x44(%rbp),%edi
  8000ec:	48 b8 cc 12 80 00 00 	movabs $0x8012cc,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	call   *%rax
            exit();
  8000f8:	48 b8 89 03 80 00 00 	movabs $0x800389,%rax
  8000ff:	00 00 00 
  800102:	ff d0                	call   *%rax
  800104:	eb af                	jmp    8000b5 <umain+0x90>
        panic("pipe: %i", r);
  800106:	89 c1                	mov    %eax,%ecx
  800108:	48 ba 62 2e 80 00 00 	movabs $0x802e62,%rdx
  80010f:	00 00 00 
  800112:	be 0c 00 00 00       	mov    $0xc,%esi
  800117:	48 bf 6b 2e 80 00 00 	movabs $0x802e6b,%rdi
  80011e:	00 00 00 
  800121:	b8 00 00 00 00       	mov    $0x0,%eax
  800126:	49 b8 ac 03 80 00 00 	movabs $0x8003ac,%r8
  80012d:	00 00 00 
  800130:	41 ff d0             	call   *%r8
        panic("fork: %i", r);
  800133:	89 c1                	mov    %eax,%ecx
  800135:	48 ba 74 34 80 00 00 	movabs $0x803474,%rdx
  80013c:	00 00 00 
  80013f:	be 0e 00 00 00       	mov    $0xe,%esi
  800144:	48 bf 6b 2e 80 00 00 	movabs $0x802e6b,%rdi
  80014b:	00 00 00 
  80014e:	b8 00 00 00 00       	mov    $0x0,%eax
  800153:	49 b8 ac 03 80 00 00 	movabs $0x8003ac,%r8
  80015a:	00 00 00 
  80015d:	41 ff d0             	call   *%r8
        close(p[1]);
  800160:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800163:	48 b8 0b 1b 80 00 00 	movabs $0x801b0b,%rax
  80016a:	00 00 00 
  80016d:	ff d0                	call   *%rax
        for (i = 0; i < 200; i++) {
  80016f:	8b 5d bc             	mov    -0x44(%rbp),%ebx
                cprintf("%d.", i);
  800172:	49 bf fc 04 80 00 00 	movabs $0x8004fc,%r15
  800179:	00 00 00 
            dup(p[0], 10);
  80017c:	49 be 66 1b 80 00 00 	movabs $0x801b66,%r14
  800183:	00 00 00 
            sys_yield();
  800186:	49 bc 68 13 80 00 00 	movabs $0x801368,%r12
  80018d:	00 00 00 
            close(10);
  800190:	49 bd 0b 1b 80 00 00 	movabs $0x801b0b,%r13
  800197:	00 00 00 
  80019a:	eb 24                	jmp    8001c0 <umain+0x19b>
            dup(p[0], 10);
  80019c:	be 0a 00 00 00       	mov    $0xa,%esi
  8001a1:	8b 7d c8             	mov    -0x38(%rbp),%edi
  8001a4:	41 ff d6             	call   *%r14
            sys_yield();
  8001a7:	41 ff d4             	call   *%r12
            close(10);
  8001aa:	bf 0a 00 00 00       	mov    $0xa,%edi
  8001af:	41 ff d5             	call   *%r13
            sys_yield();
  8001b2:	41 ff d4             	call   *%r12
        for (i = 0; i < 200; i++) {
  8001b5:	83 c3 01             	add    $0x1,%ebx
  8001b8:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  8001be:	74 34                	je     8001f4 <umain+0x1cf>
            if (i % 10 == 0)
  8001c0:	48 63 c3             	movslq %ebx,%rax
  8001c3:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
  8001ca:	48 c1 f8 22          	sar    $0x22,%rax
  8001ce:	89 da                	mov    %ebx,%edx
  8001d0:	c1 fa 1f             	sar    $0x1f,%edx
  8001d3:	29 d0                	sub    %edx,%eax
  8001d5:	8d 04 80             	lea    (%rax,%rax,4),%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	39 c3                	cmp    %eax,%ebx
  8001dc:	75 be                	jne    80019c <umain+0x177>
                cprintf("%d.", i);
  8001de:	89 de                	mov    %ebx,%esi
  8001e0:	48 bf 80 2e 80 00 00 	movabs $0x802e80,%rdi
  8001e7:	00 00 00 
  8001ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ef:	41 ff d7             	call   *%r15
  8001f2:	eb a8                	jmp    80019c <umain+0x177>
        exit();
  8001f4:	48 b8 89 03 80 00 00 	movabs $0x800389,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	call   *%rax
  800200:	e9 85 fe ff ff       	jmp    80008a <umain+0x65>
        }
    }
    cprintf("child done with loop\n");
  800205:	48 bf a0 2e 80 00 00 	movabs $0x802ea0,%rdi
  80020c:	00 00 00 
  80020f:	b8 00 00 00 00       	mov    $0x0,%eax
  800214:	48 ba fc 04 80 00 00 	movabs $0x8004fc,%rdx
  80021b:	00 00 00 
  80021e:	ff d2                	call   *%rdx
    if (pipeisclosed(p[0]))
  800220:	8b 7d c8             	mov    -0x38(%rbp),%edi
  800223:	48 b8 e8 27 80 00 00 	movabs $0x8027e8,%rax
  80022a:	00 00 00 
  80022d:	ff d0                	call   *%rax
  80022f:	85 c0                	test   %eax,%eax
  800231:	75 51                	jne    800284 <umain+0x25f>
        panic("somehow the other end of p[0] got closed!");
    if ((r = fd_lookup(p[0], &fd)) < 0)
  800233:	48 8d 75 c0          	lea    -0x40(%rbp),%rsi
  800237:	8b 7d c8             	mov    -0x38(%rbp),%edi
  80023a:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  800241:	00 00 00 
  800244:	ff d0                	call   *%rax
  800246:	85 c0                	test   %eax,%eax
  800248:	78 64                	js     8002ae <umain+0x289>
        panic("cannot look up p[0]: %i", r);
    USED(fd2data(fd));
  80024a:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
  80024e:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  800255:	00 00 00 
  800258:	ff d0                	call   *%rax
    cprintf("race didn't happen\n");
  80025a:	48 bf ce 2e 80 00 00 	movabs $0x802ece,%rdi
  800261:	00 00 00 
  800264:	b8 00 00 00 00       	mov    $0x0,%eax
  800269:	48 ba fc 04 80 00 00 	movabs $0x8004fc,%rdx
  800270:	00 00 00 
  800273:	ff d2                	call   *%rdx
}
  800275:	48 83 c4 28          	add    $0x28,%rsp
  800279:	5b                   	pop    %rbx
  80027a:	41 5c                	pop    %r12
  80027c:	41 5d                	pop    %r13
  80027e:	41 5e                	pop    %r14
  800280:	41 5f                	pop    %r15
  800282:	5d                   	pop    %rbp
  800283:	c3                   	ret    
        panic("somehow the other end of p[0] got closed!");
  800284:	48 ba 38 2e 80 00 00 	movabs $0x802e38,%rdx
  80028b:	00 00 00 
  80028e:	be 40 00 00 00       	mov    $0x40,%esi
  800293:	48 bf 6b 2e 80 00 00 	movabs $0x802e6b,%rdi
  80029a:	00 00 00 
  80029d:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a2:	48 b9 ac 03 80 00 00 	movabs $0x8003ac,%rcx
  8002a9:	00 00 00 
  8002ac:	ff d1                	call   *%rcx
        panic("cannot look up p[0]: %i", r);
  8002ae:	89 c1                	mov    %eax,%ecx
  8002b0:	48 ba b6 2e 80 00 00 	movabs $0x802eb6,%rdx
  8002b7:	00 00 00 
  8002ba:	be 42 00 00 00       	mov    $0x42,%esi
  8002bf:	48 bf 6b 2e 80 00 00 	movabs $0x802e6b,%rdi
  8002c6:	00 00 00 
  8002c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ce:	49 b8 ac 03 80 00 00 	movabs $0x8003ac,%r8
  8002d5:	00 00 00 
  8002d8:	41 ff d0             	call   *%r8

00000000008002db <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8002db:	55                   	push   %rbp
  8002dc:	48 89 e5             	mov    %rsp,%rbp
  8002df:	41 56                	push   %r14
  8002e1:	41 55                	push   %r13
  8002e3:	41 54                	push   %r12
  8002e5:	53                   	push   %rbx
  8002e6:	41 89 fd             	mov    %edi,%r13d
  8002e9:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8002ec:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8002f3:	00 00 00 
  8002f6:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8002fd:	00 00 00 
  800300:	48 39 c2             	cmp    %rax,%rdx
  800303:	73 17                	jae    80031c <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800305:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800308:	49 89 c4             	mov    %rax,%r12
  80030b:	48 83 c3 08          	add    $0x8,%rbx
  80030f:	b8 00 00 00 00       	mov    $0x0,%eax
  800314:	ff 53 f8             	call   *-0x8(%rbx)
  800317:	4c 39 e3             	cmp    %r12,%rbx
  80031a:	72 ef                	jb     80030b <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80031c:	48 b8 37 13 80 00 00 	movabs $0x801337,%rax
  800323:	00 00 00 
  800326:	ff d0                	call   *%rax
  800328:	25 ff 03 00 00       	and    $0x3ff,%eax
  80032d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800331:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800335:	48 c1 e0 04          	shl    $0x4,%rax
  800339:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  800340:	00 00 00 
  800343:	48 01 d0             	add    %rdx,%rax
  800346:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80034d:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800350:	45 85 ed             	test   %r13d,%r13d
  800353:	7e 0d                	jle    800362 <libmain+0x87>
  800355:	49 8b 06             	mov    (%r14),%rax
  800358:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  80035f:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800362:	4c 89 f6             	mov    %r14,%rsi
  800365:	44 89 ef             	mov    %r13d,%edi
  800368:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80036f:	00 00 00 
  800372:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800374:	48 b8 89 03 80 00 00 	movabs $0x800389,%rax
  80037b:	00 00 00 
  80037e:	ff d0                	call   *%rax
#endif
}
  800380:	5b                   	pop    %rbx
  800381:	41 5c                	pop    %r12
  800383:	41 5d                	pop    %r13
  800385:	41 5e                	pop    %r14
  800387:	5d                   	pop    %rbp
  800388:	c3                   	ret    

0000000000800389 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800389:	55                   	push   %rbp
  80038a:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80038d:	48 b8 3e 1b 80 00 00 	movabs $0x801b3e,%rax
  800394:	00 00 00 
  800397:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800399:	bf 00 00 00 00       	mov    $0x0,%edi
  80039e:	48 b8 cc 12 80 00 00 	movabs $0x8012cc,%rax
  8003a5:	00 00 00 
  8003a8:	ff d0                	call   *%rax
}
  8003aa:	5d                   	pop    %rbp
  8003ab:	c3                   	ret    

00000000008003ac <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8003ac:	55                   	push   %rbp
  8003ad:	48 89 e5             	mov    %rsp,%rbp
  8003b0:	41 56                	push   %r14
  8003b2:	41 55                	push   %r13
  8003b4:	41 54                	push   %r12
  8003b6:	53                   	push   %rbx
  8003b7:	48 83 ec 50          	sub    $0x50,%rsp
  8003bb:	49 89 fc             	mov    %rdi,%r12
  8003be:	41 89 f5             	mov    %esi,%r13d
  8003c1:	48 89 d3             	mov    %rdx,%rbx
  8003c4:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8003c8:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8003cc:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8003d0:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8003d7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003db:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8003df:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8003e3:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8003e7:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8003ee:	00 00 00 
  8003f1:	4c 8b 30             	mov    (%rax),%r14
  8003f4:	48 b8 37 13 80 00 00 	movabs $0x801337,%rax
  8003fb:	00 00 00 
  8003fe:	ff d0                	call   *%rax
  800400:	89 c6                	mov    %eax,%esi
  800402:	45 89 e8             	mov    %r13d,%r8d
  800405:	4c 89 e1             	mov    %r12,%rcx
  800408:	4c 89 f2             	mov    %r14,%rdx
  80040b:	48 bf f0 2e 80 00 00 	movabs $0x802ef0,%rdi
  800412:	00 00 00 
  800415:	b8 00 00 00 00       	mov    $0x0,%eax
  80041a:	49 bc fc 04 80 00 00 	movabs $0x8004fc,%r12
  800421:	00 00 00 
  800424:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800427:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80042b:	48 89 df             	mov    %rbx,%rdi
  80042e:	48 b8 98 04 80 00 00 	movabs $0x800498,%rax
  800435:	00 00 00 
  800438:	ff d0                	call   *%rax
    cprintf("\n");
  80043a:	48 bf 9e 2e 80 00 00 	movabs $0x802e9e,%rdi
  800441:	00 00 00 
  800444:	b8 00 00 00 00       	mov    $0x0,%eax
  800449:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80044c:	cc                   	int3   
  80044d:	eb fd                	jmp    80044c <_panic+0xa0>

000000000080044f <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80044f:	55                   	push   %rbp
  800450:	48 89 e5             	mov    %rsp,%rbp
  800453:	53                   	push   %rbx
  800454:	48 83 ec 08          	sub    $0x8,%rsp
  800458:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80045b:	8b 06                	mov    (%rsi),%eax
  80045d:	8d 50 01             	lea    0x1(%rax),%edx
  800460:	89 16                	mov    %edx,(%rsi)
  800462:	48 98                	cltq   
  800464:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800469:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80046f:	74 0a                	je     80047b <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800471:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800475:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800479:	c9                   	leave  
  80047a:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  80047b:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80047f:	be ff 00 00 00       	mov    $0xff,%esi
  800484:	48 b8 6e 12 80 00 00 	movabs $0x80126e,%rax
  80048b:	00 00 00 
  80048e:	ff d0                	call   *%rax
        state->offset = 0;
  800490:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800496:	eb d9                	jmp    800471 <putch+0x22>

0000000000800498 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800498:	55                   	push   %rbp
  800499:	48 89 e5             	mov    %rsp,%rbp
  80049c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8004a3:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8004a6:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8004ad:	b9 21 00 00 00       	mov    $0x21,%ecx
  8004b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b7:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8004ba:	48 89 f1             	mov    %rsi,%rcx
  8004bd:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8004c4:	48 bf 4f 04 80 00 00 	movabs $0x80044f,%rdi
  8004cb:	00 00 00 
  8004ce:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  8004d5:	00 00 00 
  8004d8:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8004da:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8004e1:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8004e8:	48 b8 6e 12 80 00 00 	movabs $0x80126e,%rax
  8004ef:	00 00 00 
  8004f2:	ff d0                	call   *%rax

    return state.count;
}
  8004f4:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8004fa:	c9                   	leave  
  8004fb:	c3                   	ret    

00000000008004fc <cprintf>:

int
cprintf(const char *fmt, ...) {
  8004fc:	55                   	push   %rbp
  8004fd:	48 89 e5             	mov    %rsp,%rbp
  800500:	48 83 ec 50          	sub    $0x50,%rsp
  800504:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800508:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80050c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800510:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800514:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800518:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80051f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800523:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800527:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80052b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80052f:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800533:	48 b8 98 04 80 00 00 	movabs $0x800498,%rax
  80053a:	00 00 00 
  80053d:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80053f:	c9                   	leave  
  800540:	c3                   	ret    

0000000000800541 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800541:	55                   	push   %rbp
  800542:	48 89 e5             	mov    %rsp,%rbp
  800545:	41 57                	push   %r15
  800547:	41 56                	push   %r14
  800549:	41 55                	push   %r13
  80054b:	41 54                	push   %r12
  80054d:	53                   	push   %rbx
  80054e:	48 83 ec 18          	sub    $0x18,%rsp
  800552:	49 89 fc             	mov    %rdi,%r12
  800555:	49 89 f5             	mov    %rsi,%r13
  800558:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80055c:	8b 45 10             	mov    0x10(%rbp),%eax
  80055f:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800562:	41 89 cf             	mov    %ecx,%r15d
  800565:	49 39 d7             	cmp    %rdx,%r15
  800568:	76 5b                	jbe    8005c5 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80056a:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80056e:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800572:	85 db                	test   %ebx,%ebx
  800574:	7e 0e                	jle    800584 <print_num+0x43>
            putch(padc, put_arg);
  800576:	4c 89 ee             	mov    %r13,%rsi
  800579:	44 89 f7             	mov    %r14d,%edi
  80057c:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80057f:	83 eb 01             	sub    $0x1,%ebx
  800582:	75 f2                	jne    800576 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800584:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800588:	48 b9 13 2f 80 00 00 	movabs $0x802f13,%rcx
  80058f:	00 00 00 
  800592:	48 b8 24 2f 80 00 00 	movabs $0x802f24,%rax
  800599:	00 00 00 
  80059c:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8005a0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8005a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a9:	49 f7 f7             	div    %r15
  8005ac:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8005b0:	4c 89 ee             	mov    %r13,%rsi
  8005b3:	41 ff d4             	call   *%r12
}
  8005b6:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8005ba:	5b                   	pop    %rbx
  8005bb:	41 5c                	pop    %r12
  8005bd:	41 5d                	pop    %r13
  8005bf:	41 5e                	pop    %r14
  8005c1:	41 5f                	pop    %r15
  8005c3:	5d                   	pop    %rbp
  8005c4:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8005c5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8005c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ce:	49 f7 f7             	div    %r15
  8005d1:	48 83 ec 08          	sub    $0x8,%rsp
  8005d5:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8005d9:	52                   	push   %rdx
  8005da:	45 0f be c9          	movsbl %r9b,%r9d
  8005de:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8005e2:	48 89 c2             	mov    %rax,%rdx
  8005e5:	48 b8 41 05 80 00 00 	movabs $0x800541,%rax
  8005ec:	00 00 00 
  8005ef:	ff d0                	call   *%rax
  8005f1:	48 83 c4 10          	add    $0x10,%rsp
  8005f5:	eb 8d                	jmp    800584 <print_num+0x43>

00000000008005f7 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8005f7:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8005fb:	48 8b 06             	mov    (%rsi),%rax
  8005fe:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800602:	73 0a                	jae    80060e <sprintputch+0x17>
        *state->start++ = ch;
  800604:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800608:	48 89 16             	mov    %rdx,(%rsi)
  80060b:	40 88 38             	mov    %dil,(%rax)
    }
}
  80060e:	c3                   	ret    

000000000080060f <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80060f:	55                   	push   %rbp
  800610:	48 89 e5             	mov    %rsp,%rbp
  800613:	48 83 ec 50          	sub    $0x50,%rsp
  800617:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80061b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80061f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800623:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80062a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80062e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800632:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800636:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80063a:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80063e:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  800645:	00 00 00 
  800648:	ff d0                	call   *%rax
}
  80064a:	c9                   	leave  
  80064b:	c3                   	ret    

000000000080064c <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80064c:	55                   	push   %rbp
  80064d:	48 89 e5             	mov    %rsp,%rbp
  800650:	41 57                	push   %r15
  800652:	41 56                	push   %r14
  800654:	41 55                	push   %r13
  800656:	41 54                	push   %r12
  800658:	53                   	push   %rbx
  800659:	48 83 ec 48          	sub    $0x48,%rsp
  80065d:	49 89 fc             	mov    %rdi,%r12
  800660:	49 89 f6             	mov    %rsi,%r14
  800663:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800666:	48 8b 01             	mov    (%rcx),%rax
  800669:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80066d:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800671:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800675:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800679:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80067d:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800681:	41 0f b6 3f          	movzbl (%r15),%edi
  800685:	40 80 ff 25          	cmp    $0x25,%dil
  800689:	74 18                	je     8006a3 <vprintfmt+0x57>
            if (!ch) return;
  80068b:	40 84 ff             	test   %dil,%dil
  80068e:	0f 84 d1 06 00 00    	je     800d65 <vprintfmt+0x719>
            putch(ch, put_arg);
  800694:	40 0f b6 ff          	movzbl %dil,%edi
  800698:	4c 89 f6             	mov    %r14,%rsi
  80069b:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80069e:	49 89 df             	mov    %rbx,%r15
  8006a1:	eb da                	jmp    80067d <vprintfmt+0x31>
            precision = va_arg(aq, int);
  8006a3:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  8006a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ac:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  8006b0:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8006b5:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8006bb:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8006c2:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8006c6:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8006cb:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8006d1:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8006d5:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8006d9:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8006dd:	3c 57                	cmp    $0x57,%al
  8006df:	0f 87 65 06 00 00    	ja     800d4a <vprintfmt+0x6fe>
  8006e5:	0f b6 c0             	movzbl %al,%eax
  8006e8:	49 ba c0 30 80 00 00 	movabs $0x8030c0,%r10
  8006ef:	00 00 00 
  8006f2:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8006f6:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8006f9:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8006fd:	eb d2                	jmp    8006d1 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8006ff:	4c 89 fb             	mov    %r15,%rbx
  800702:	44 89 c1             	mov    %r8d,%ecx
  800705:	eb ca                	jmp    8006d1 <vprintfmt+0x85>
            padc = ch;
  800707:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  80070b:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80070e:	eb c1                	jmp    8006d1 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800710:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800713:	83 f8 2f             	cmp    $0x2f,%eax
  800716:	77 24                	ja     80073c <vprintfmt+0xf0>
  800718:	41 89 c1             	mov    %eax,%r9d
  80071b:	49 01 f1             	add    %rsi,%r9
  80071e:	83 c0 08             	add    $0x8,%eax
  800721:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800724:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800727:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  80072a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80072e:	79 a1                	jns    8006d1 <vprintfmt+0x85>
                width = precision;
  800730:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800734:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80073a:	eb 95                	jmp    8006d1 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80073c:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  800740:	49 8d 41 08          	lea    0x8(%r9),%rax
  800744:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800748:	eb da                	jmp    800724 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  80074a:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  80074e:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800752:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800756:	3c 39                	cmp    $0x39,%al
  800758:	77 1e                	ja     800778 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  80075a:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80075e:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800763:	0f b6 c0             	movzbl %al,%eax
  800766:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80076b:	41 0f b6 07          	movzbl (%r15),%eax
  80076f:	3c 39                	cmp    $0x39,%al
  800771:	76 e7                	jbe    80075a <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800773:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800776:	eb b2                	jmp    80072a <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800778:	4c 89 fb             	mov    %r15,%rbx
  80077b:	eb ad                	jmp    80072a <vprintfmt+0xde>
            width = MAX(0, width);
  80077d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800780:	85 c0                	test   %eax,%eax
  800782:	0f 48 c7             	cmovs  %edi,%eax
  800785:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800788:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80078b:	e9 41 ff ff ff       	jmp    8006d1 <vprintfmt+0x85>
            lflag++;
  800790:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800793:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800796:	e9 36 ff ff ff       	jmp    8006d1 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  80079b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079e:	83 f8 2f             	cmp    $0x2f,%eax
  8007a1:	77 18                	ja     8007bb <vprintfmt+0x16f>
  8007a3:	89 c2                	mov    %eax,%edx
  8007a5:	48 01 f2             	add    %rsi,%rdx
  8007a8:	83 c0 08             	add    $0x8,%eax
  8007ab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ae:	4c 89 f6             	mov    %r14,%rsi
  8007b1:	8b 3a                	mov    (%rdx),%edi
  8007b3:	41 ff d4             	call   *%r12
            break;
  8007b6:	e9 c2 fe ff ff       	jmp    80067d <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  8007bb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007bf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007c3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c7:	eb e5                	jmp    8007ae <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8007c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007cc:	83 f8 2f             	cmp    $0x2f,%eax
  8007cf:	77 5b                	ja     80082c <vprintfmt+0x1e0>
  8007d1:	89 c2                	mov    %eax,%edx
  8007d3:	48 01 d6             	add    %rdx,%rsi
  8007d6:	83 c0 08             	add    $0x8,%eax
  8007d9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007dc:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8007de:	89 c8                	mov    %ecx,%eax
  8007e0:	c1 f8 1f             	sar    $0x1f,%eax
  8007e3:	31 c1                	xor    %eax,%ecx
  8007e5:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8007e7:	83 f9 13             	cmp    $0x13,%ecx
  8007ea:	7f 4e                	jg     80083a <vprintfmt+0x1ee>
  8007ec:	48 63 c1             	movslq %ecx,%rax
  8007ef:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  8007f6:	00 00 00 
  8007f9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8007fd:	48 85 c0             	test   %rax,%rax
  800800:	74 38                	je     80083a <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  800802:	48 89 c1             	mov    %rax,%rcx
  800805:	48 ba b9 35 80 00 00 	movabs $0x8035b9,%rdx
  80080c:	00 00 00 
  80080f:	4c 89 f6             	mov    %r14,%rsi
  800812:	4c 89 e7             	mov    %r12,%rdi
  800815:	b8 00 00 00 00       	mov    $0x0,%eax
  80081a:	49 b8 0f 06 80 00 00 	movabs $0x80060f,%r8
  800821:	00 00 00 
  800824:	41 ff d0             	call   *%r8
  800827:	e9 51 fe ff ff       	jmp    80067d <vprintfmt+0x31>
            int err = va_arg(aq, int);
  80082c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800830:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800834:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800838:	eb a2                	jmp    8007dc <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  80083a:	48 ba 3c 2f 80 00 00 	movabs $0x802f3c,%rdx
  800841:	00 00 00 
  800844:	4c 89 f6             	mov    %r14,%rsi
  800847:	4c 89 e7             	mov    %r12,%rdi
  80084a:	b8 00 00 00 00       	mov    $0x0,%eax
  80084f:	49 b8 0f 06 80 00 00 	movabs $0x80060f,%r8
  800856:	00 00 00 
  800859:	41 ff d0             	call   *%r8
  80085c:	e9 1c fe ff ff       	jmp    80067d <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800861:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800864:	83 f8 2f             	cmp    $0x2f,%eax
  800867:	77 55                	ja     8008be <vprintfmt+0x272>
  800869:	89 c2                	mov    %eax,%edx
  80086b:	48 01 d6             	add    %rdx,%rsi
  80086e:	83 c0 08             	add    $0x8,%eax
  800871:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800874:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800877:	48 85 d2             	test   %rdx,%rdx
  80087a:	48 b8 35 2f 80 00 00 	movabs $0x802f35,%rax
  800881:	00 00 00 
  800884:	48 0f 45 c2          	cmovne %rdx,%rax
  800888:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80088c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800890:	7e 06                	jle    800898 <vprintfmt+0x24c>
  800892:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800896:	75 34                	jne    8008cc <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800898:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80089c:	48 8d 58 01          	lea    0x1(%rax),%rbx
  8008a0:	0f b6 00             	movzbl (%rax),%eax
  8008a3:	84 c0                	test   %al,%al
  8008a5:	0f 84 b2 00 00 00    	je     80095d <vprintfmt+0x311>
  8008ab:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  8008af:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  8008b4:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  8008b8:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  8008bc:	eb 74                	jmp    800932 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  8008be:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008c2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008c6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ca:	eb a8                	jmp    800874 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8008cc:	49 63 f5             	movslq %r13d,%rsi
  8008cf:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8008d3:	48 b8 1f 0e 80 00 00 	movabs $0x800e1f,%rax
  8008da:	00 00 00 
  8008dd:	ff d0                	call   *%rax
  8008df:	48 89 c2             	mov    %rax,%rdx
  8008e2:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008e5:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8008e7:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8008ea:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8008ed:	85 c0                	test   %eax,%eax
  8008ef:	7e a7                	jle    800898 <vprintfmt+0x24c>
  8008f1:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8008f5:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8008f9:	41 89 cd             	mov    %ecx,%r13d
  8008fc:	4c 89 f6             	mov    %r14,%rsi
  8008ff:	89 df                	mov    %ebx,%edi
  800901:	41 ff d4             	call   *%r12
  800904:	41 83 ed 01          	sub    $0x1,%r13d
  800908:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  80090c:	75 ee                	jne    8008fc <vprintfmt+0x2b0>
  80090e:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800912:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800916:	eb 80                	jmp    800898 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800918:	0f b6 f8             	movzbl %al,%edi
  80091b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80091f:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800922:	41 83 ef 01          	sub    $0x1,%r15d
  800926:	48 83 c3 01          	add    $0x1,%rbx
  80092a:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  80092e:	84 c0                	test   %al,%al
  800930:	74 1f                	je     800951 <vprintfmt+0x305>
  800932:	45 85 ed             	test   %r13d,%r13d
  800935:	78 06                	js     80093d <vprintfmt+0x2f1>
  800937:	41 83 ed 01          	sub    $0x1,%r13d
  80093b:	78 46                	js     800983 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80093d:	45 84 f6             	test   %r14b,%r14b
  800940:	74 d6                	je     800918 <vprintfmt+0x2cc>
  800942:	8d 50 e0             	lea    -0x20(%rax),%edx
  800945:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80094a:	80 fa 5e             	cmp    $0x5e,%dl
  80094d:	77 cc                	ja     80091b <vprintfmt+0x2cf>
  80094f:	eb c7                	jmp    800918 <vprintfmt+0x2cc>
  800951:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800955:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800959:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80095d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800960:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800963:	85 c0                	test   %eax,%eax
  800965:	0f 8e 12 fd ff ff    	jle    80067d <vprintfmt+0x31>
  80096b:	4c 89 f6             	mov    %r14,%rsi
  80096e:	bf 20 00 00 00       	mov    $0x20,%edi
  800973:	41 ff d4             	call   *%r12
  800976:	83 eb 01             	sub    $0x1,%ebx
  800979:	83 fb ff             	cmp    $0xffffffff,%ebx
  80097c:	75 ed                	jne    80096b <vprintfmt+0x31f>
  80097e:	e9 fa fc ff ff       	jmp    80067d <vprintfmt+0x31>
  800983:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800987:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80098b:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80098f:	eb cc                	jmp    80095d <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800991:	45 89 cd             	mov    %r9d,%r13d
  800994:	84 c9                	test   %cl,%cl
  800996:	75 25                	jne    8009bd <vprintfmt+0x371>
    switch (lflag) {
  800998:	85 d2                	test   %edx,%edx
  80099a:	74 57                	je     8009f3 <vprintfmt+0x3a7>
  80099c:	83 fa 01             	cmp    $0x1,%edx
  80099f:	74 78                	je     800a19 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  8009a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a4:	83 f8 2f             	cmp    $0x2f,%eax
  8009a7:	0f 87 92 00 00 00    	ja     800a3f <vprintfmt+0x3f3>
  8009ad:	89 c2                	mov    %eax,%edx
  8009af:	48 01 d6             	add    %rdx,%rsi
  8009b2:	83 c0 08             	add    $0x8,%eax
  8009b5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009b8:	48 8b 1e             	mov    (%rsi),%rbx
  8009bb:	eb 16                	jmp    8009d3 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  8009bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c0:	83 f8 2f             	cmp    $0x2f,%eax
  8009c3:	77 20                	ja     8009e5 <vprintfmt+0x399>
  8009c5:	89 c2                	mov    %eax,%edx
  8009c7:	48 01 d6             	add    %rdx,%rsi
  8009ca:	83 c0 08             	add    $0x8,%eax
  8009cd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d0:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8009d3:	48 85 db             	test   %rbx,%rbx
  8009d6:	78 78                	js     800a50 <vprintfmt+0x404>
            num = i;
  8009d8:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8009db:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8009e0:	e9 49 02 00 00       	jmp    800c2e <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8009e5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009e9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009ed:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009f1:	eb dd                	jmp    8009d0 <vprintfmt+0x384>
        return va_arg(*ap, int);
  8009f3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f6:	83 f8 2f             	cmp    $0x2f,%eax
  8009f9:	77 10                	ja     800a0b <vprintfmt+0x3bf>
  8009fb:	89 c2                	mov    %eax,%edx
  8009fd:	48 01 d6             	add    %rdx,%rsi
  800a00:	83 c0 08             	add    $0x8,%eax
  800a03:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a06:	48 63 1e             	movslq (%rsi),%rbx
  800a09:	eb c8                	jmp    8009d3 <vprintfmt+0x387>
  800a0b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a0f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a13:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a17:	eb ed                	jmp    800a06 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800a19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1c:	83 f8 2f             	cmp    $0x2f,%eax
  800a1f:	77 10                	ja     800a31 <vprintfmt+0x3e5>
  800a21:	89 c2                	mov    %eax,%edx
  800a23:	48 01 d6             	add    %rdx,%rsi
  800a26:	83 c0 08             	add    $0x8,%eax
  800a29:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a2c:	48 8b 1e             	mov    (%rsi),%rbx
  800a2f:	eb a2                	jmp    8009d3 <vprintfmt+0x387>
  800a31:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a35:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a39:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a3d:	eb ed                	jmp    800a2c <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800a3f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a43:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a47:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a4b:	e9 68 ff ff ff       	jmp    8009b8 <vprintfmt+0x36c>
                putch('-', put_arg);
  800a50:	4c 89 f6             	mov    %r14,%rsi
  800a53:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a58:	41 ff d4             	call   *%r12
                i = -i;
  800a5b:	48 f7 db             	neg    %rbx
  800a5e:	e9 75 ff ff ff       	jmp    8009d8 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800a63:	45 89 cd             	mov    %r9d,%r13d
  800a66:	84 c9                	test   %cl,%cl
  800a68:	75 2d                	jne    800a97 <vprintfmt+0x44b>
    switch (lflag) {
  800a6a:	85 d2                	test   %edx,%edx
  800a6c:	74 57                	je     800ac5 <vprintfmt+0x479>
  800a6e:	83 fa 01             	cmp    $0x1,%edx
  800a71:	74 7f                	je     800af2 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800a73:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a76:	83 f8 2f             	cmp    $0x2f,%eax
  800a79:	0f 87 a1 00 00 00    	ja     800b20 <vprintfmt+0x4d4>
  800a7f:	89 c2                	mov    %eax,%edx
  800a81:	48 01 d6             	add    %rdx,%rsi
  800a84:	83 c0 08             	add    $0x8,%eax
  800a87:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a8a:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800a8d:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800a92:	e9 97 01 00 00       	jmp    800c2e <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a97:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9a:	83 f8 2f             	cmp    $0x2f,%eax
  800a9d:	77 18                	ja     800ab7 <vprintfmt+0x46b>
  800a9f:	89 c2                	mov    %eax,%edx
  800aa1:	48 01 d6             	add    %rdx,%rsi
  800aa4:	83 c0 08             	add    $0x8,%eax
  800aa7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aaa:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800aad:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800ab2:	e9 77 01 00 00       	jmp    800c2e <vprintfmt+0x5e2>
  800ab7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800abb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800abf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac3:	eb e5                	jmp    800aaa <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800ac5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac8:	83 f8 2f             	cmp    $0x2f,%eax
  800acb:	77 17                	ja     800ae4 <vprintfmt+0x498>
  800acd:	89 c2                	mov    %eax,%edx
  800acf:	48 01 d6             	add    %rdx,%rsi
  800ad2:	83 c0 08             	add    $0x8,%eax
  800ad5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ad8:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800ada:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800adf:	e9 4a 01 00 00       	jmp    800c2e <vprintfmt+0x5e2>
  800ae4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ae8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800aec:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800af0:	eb e6                	jmp    800ad8 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800af2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af5:	83 f8 2f             	cmp    $0x2f,%eax
  800af8:	77 18                	ja     800b12 <vprintfmt+0x4c6>
  800afa:	89 c2                	mov    %eax,%edx
  800afc:	48 01 d6             	add    %rdx,%rsi
  800aff:	83 c0 08             	add    $0x8,%eax
  800b02:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b05:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800b08:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800b0d:	e9 1c 01 00 00       	jmp    800c2e <vprintfmt+0x5e2>
  800b12:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b16:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b1a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b1e:	eb e5                	jmp    800b05 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800b20:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b24:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b28:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b2c:	e9 59 ff ff ff       	jmp    800a8a <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800b31:	45 89 cd             	mov    %r9d,%r13d
  800b34:	84 c9                	test   %cl,%cl
  800b36:	75 2d                	jne    800b65 <vprintfmt+0x519>
    switch (lflag) {
  800b38:	85 d2                	test   %edx,%edx
  800b3a:	74 57                	je     800b93 <vprintfmt+0x547>
  800b3c:	83 fa 01             	cmp    $0x1,%edx
  800b3f:	74 7c                	je     800bbd <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800b41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b44:	83 f8 2f             	cmp    $0x2f,%eax
  800b47:	0f 87 9b 00 00 00    	ja     800be8 <vprintfmt+0x59c>
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	48 01 d6             	add    %rdx,%rsi
  800b52:	83 c0 08             	add    $0x8,%eax
  800b55:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b58:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800b5b:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800b60:	e9 c9 00 00 00       	jmp    800c2e <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b68:	83 f8 2f             	cmp    $0x2f,%eax
  800b6b:	77 18                	ja     800b85 <vprintfmt+0x539>
  800b6d:	89 c2                	mov    %eax,%edx
  800b6f:	48 01 d6             	add    %rdx,%rsi
  800b72:	83 c0 08             	add    $0x8,%eax
  800b75:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b78:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800b7b:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b80:	e9 a9 00 00 00       	jmp    800c2e <vprintfmt+0x5e2>
  800b85:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b89:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b8d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b91:	eb e5                	jmp    800b78 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800b93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b96:	83 f8 2f             	cmp    $0x2f,%eax
  800b99:	77 14                	ja     800baf <vprintfmt+0x563>
  800b9b:	89 c2                	mov    %eax,%edx
  800b9d:	48 01 d6             	add    %rdx,%rsi
  800ba0:	83 c0 08             	add    $0x8,%eax
  800ba3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ba6:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800ba8:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800bad:	eb 7f                	jmp    800c2e <vprintfmt+0x5e2>
  800baf:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bb3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bb7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bbb:	eb e9                	jmp    800ba6 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800bbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc0:	83 f8 2f             	cmp    $0x2f,%eax
  800bc3:	77 15                	ja     800bda <vprintfmt+0x58e>
  800bc5:	89 c2                	mov    %eax,%edx
  800bc7:	48 01 d6             	add    %rdx,%rsi
  800bca:	83 c0 08             	add    $0x8,%eax
  800bcd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bd0:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800bd3:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800bd8:	eb 54                	jmp    800c2e <vprintfmt+0x5e2>
  800bda:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bde:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800be2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800be6:	eb e8                	jmp    800bd0 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800be8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bec:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bf0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bf4:	e9 5f ff ff ff       	jmp    800b58 <vprintfmt+0x50c>
            putch('0', put_arg);
  800bf9:	45 89 cd             	mov    %r9d,%r13d
  800bfc:	4c 89 f6             	mov    %r14,%rsi
  800bff:	bf 30 00 00 00       	mov    $0x30,%edi
  800c04:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800c07:	4c 89 f6             	mov    %r14,%rsi
  800c0a:	bf 78 00 00 00       	mov    $0x78,%edi
  800c0f:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800c12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c15:	83 f8 2f             	cmp    $0x2f,%eax
  800c18:	77 47                	ja     800c61 <vprintfmt+0x615>
  800c1a:	89 c2                	mov    %eax,%edx
  800c1c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c20:	83 c0 08             	add    $0x8,%eax
  800c23:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c26:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c29:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800c2e:	48 83 ec 08          	sub    $0x8,%rsp
  800c32:	41 80 fd 58          	cmp    $0x58,%r13b
  800c36:	0f 94 c0             	sete   %al
  800c39:	0f b6 c0             	movzbl %al,%eax
  800c3c:	50                   	push   %rax
  800c3d:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800c42:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800c46:	4c 89 f6             	mov    %r14,%rsi
  800c49:	4c 89 e7             	mov    %r12,%rdi
  800c4c:	48 b8 41 05 80 00 00 	movabs $0x800541,%rax
  800c53:	00 00 00 
  800c56:	ff d0                	call   *%rax
            break;
  800c58:	48 83 c4 10          	add    $0x10,%rsp
  800c5c:	e9 1c fa ff ff       	jmp    80067d <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800c61:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c65:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c69:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c6d:	eb b7                	jmp    800c26 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800c6f:	45 89 cd             	mov    %r9d,%r13d
  800c72:	84 c9                	test   %cl,%cl
  800c74:	75 2a                	jne    800ca0 <vprintfmt+0x654>
    switch (lflag) {
  800c76:	85 d2                	test   %edx,%edx
  800c78:	74 54                	je     800cce <vprintfmt+0x682>
  800c7a:	83 fa 01             	cmp    $0x1,%edx
  800c7d:	74 7c                	je     800cfb <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800c7f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c82:	83 f8 2f             	cmp    $0x2f,%eax
  800c85:	0f 87 9e 00 00 00    	ja     800d29 <vprintfmt+0x6dd>
  800c8b:	89 c2                	mov    %eax,%edx
  800c8d:	48 01 d6             	add    %rdx,%rsi
  800c90:	83 c0 08             	add    $0x8,%eax
  800c93:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c96:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800c99:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800c9e:	eb 8e                	jmp    800c2e <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800ca0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca3:	83 f8 2f             	cmp    $0x2f,%eax
  800ca6:	77 18                	ja     800cc0 <vprintfmt+0x674>
  800ca8:	89 c2                	mov    %eax,%edx
  800caa:	48 01 d6             	add    %rdx,%rsi
  800cad:	83 c0 08             	add    $0x8,%eax
  800cb0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cb3:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800cb6:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800cbb:	e9 6e ff ff ff       	jmp    800c2e <vprintfmt+0x5e2>
  800cc0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800cc4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800cc8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ccc:	eb e5                	jmp    800cb3 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800cce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd1:	83 f8 2f             	cmp    $0x2f,%eax
  800cd4:	77 17                	ja     800ced <vprintfmt+0x6a1>
  800cd6:	89 c2                	mov    %eax,%edx
  800cd8:	48 01 d6             	add    %rdx,%rsi
  800cdb:	83 c0 08             	add    $0x8,%eax
  800cde:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ce1:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800ce3:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800ce8:	e9 41 ff ff ff       	jmp    800c2e <vprintfmt+0x5e2>
  800ced:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800cf1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800cf5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cf9:	eb e6                	jmp    800ce1 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800cfb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cfe:	83 f8 2f             	cmp    $0x2f,%eax
  800d01:	77 18                	ja     800d1b <vprintfmt+0x6cf>
  800d03:	89 c2                	mov    %eax,%edx
  800d05:	48 01 d6             	add    %rdx,%rsi
  800d08:	83 c0 08             	add    $0x8,%eax
  800d0b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d0e:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800d11:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800d16:	e9 13 ff ff ff       	jmp    800c2e <vprintfmt+0x5e2>
  800d1b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d1f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d23:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d27:	eb e5                	jmp    800d0e <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800d29:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d2d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d31:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d35:	e9 5c ff ff ff       	jmp    800c96 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800d3a:	4c 89 f6             	mov    %r14,%rsi
  800d3d:	bf 25 00 00 00       	mov    $0x25,%edi
  800d42:	41 ff d4             	call   *%r12
            break;
  800d45:	e9 33 f9 ff ff       	jmp    80067d <vprintfmt+0x31>
            putch('%', put_arg);
  800d4a:	4c 89 f6             	mov    %r14,%rsi
  800d4d:	bf 25 00 00 00       	mov    $0x25,%edi
  800d52:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800d55:	49 83 ef 01          	sub    $0x1,%r15
  800d59:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800d5e:	75 f5                	jne    800d55 <vprintfmt+0x709>
  800d60:	e9 18 f9 ff ff       	jmp    80067d <vprintfmt+0x31>
}
  800d65:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800d69:	5b                   	pop    %rbx
  800d6a:	41 5c                	pop    %r12
  800d6c:	41 5d                	pop    %r13
  800d6e:	41 5e                	pop    %r14
  800d70:	41 5f                	pop    %r15
  800d72:	5d                   	pop    %rbp
  800d73:	c3                   	ret    

0000000000800d74 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800d74:	55                   	push   %rbp
  800d75:	48 89 e5             	mov    %rsp,%rbp
  800d78:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800d7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800d80:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800d85:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800d89:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800d90:	48 85 ff             	test   %rdi,%rdi
  800d93:	74 2b                	je     800dc0 <vsnprintf+0x4c>
  800d95:	48 85 f6             	test   %rsi,%rsi
  800d98:	74 26                	je     800dc0 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800d9a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800d9e:	48 bf f7 05 80 00 00 	movabs $0x8005f7,%rdi
  800da5:	00 00 00 
  800da8:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  800daf:	00 00 00 
  800db2:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800db4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db8:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800dbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800dc0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dc5:	eb f7                	jmp    800dbe <vsnprintf+0x4a>

0000000000800dc7 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800dc7:	55                   	push   %rbp
  800dc8:	48 89 e5             	mov    %rsp,%rbp
  800dcb:	48 83 ec 50          	sub    $0x50,%rsp
  800dcf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800dd3:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800dd7:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800ddb:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800de2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800de6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dea:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800dee:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800df2:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800df6:	48 b8 74 0d 80 00 00 	movabs $0x800d74,%rax
  800dfd:	00 00 00 
  800e00:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

0000000000800e04 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800e04:	80 3f 00             	cmpb   $0x0,(%rdi)
  800e07:	74 10                	je     800e19 <strlen+0x15>
    size_t n = 0;
  800e09:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800e0e:	48 83 c0 01          	add    $0x1,%rax
  800e12:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800e16:	75 f6                	jne    800e0e <strlen+0xa>
  800e18:	c3                   	ret    
    size_t n = 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800e1e:	c3                   	ret    

0000000000800e1f <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800e1f:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800e24:	48 85 f6             	test   %rsi,%rsi
  800e27:	74 10                	je     800e39 <strnlen+0x1a>
  800e29:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800e2d:	74 09                	je     800e38 <strnlen+0x19>
  800e2f:	48 83 c0 01          	add    $0x1,%rax
  800e33:	48 39 c6             	cmp    %rax,%rsi
  800e36:	75 f1                	jne    800e29 <strnlen+0xa>
    return n;
}
  800e38:	c3                   	ret    
    size_t n = 0;
  800e39:	48 89 f0             	mov    %rsi,%rax
  800e3c:	c3                   	ret    

0000000000800e3d <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800e3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e42:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800e46:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800e49:	48 83 c0 01          	add    $0x1,%rax
  800e4d:	84 d2                	test   %dl,%dl
  800e4f:	75 f1                	jne    800e42 <strcpy+0x5>
        ;
    return res;
}
  800e51:	48 89 f8             	mov    %rdi,%rax
  800e54:	c3                   	ret    

0000000000800e55 <strcat>:

char *
strcat(char *dst, const char *src) {
  800e55:	55                   	push   %rbp
  800e56:	48 89 e5             	mov    %rsp,%rbp
  800e59:	41 54                	push   %r12
  800e5b:	53                   	push   %rbx
  800e5c:	48 89 fb             	mov    %rdi,%rbx
  800e5f:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800e62:	48 b8 04 0e 80 00 00 	movabs $0x800e04,%rax
  800e69:	00 00 00 
  800e6c:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800e6e:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800e72:	4c 89 e6             	mov    %r12,%rsi
  800e75:	48 b8 3d 0e 80 00 00 	movabs $0x800e3d,%rax
  800e7c:	00 00 00 
  800e7f:	ff d0                	call   *%rax
    return dst;
}
  800e81:	48 89 d8             	mov    %rbx,%rax
  800e84:	5b                   	pop    %rbx
  800e85:	41 5c                	pop    %r12
  800e87:	5d                   	pop    %rbp
  800e88:	c3                   	ret    

0000000000800e89 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800e89:	48 85 d2             	test   %rdx,%rdx
  800e8c:	74 1d                	je     800eab <strncpy+0x22>
  800e8e:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800e92:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800e95:	48 83 c0 01          	add    $0x1,%rax
  800e99:	0f b6 16             	movzbl (%rsi),%edx
  800e9c:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800e9f:	80 fa 01             	cmp    $0x1,%dl
  800ea2:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800ea6:	48 39 c1             	cmp    %rax,%rcx
  800ea9:	75 ea                	jne    800e95 <strncpy+0xc>
    }
    return ret;
}
  800eab:	48 89 f8             	mov    %rdi,%rax
  800eae:	c3                   	ret    

0000000000800eaf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800eaf:	48 89 f8             	mov    %rdi,%rax
  800eb2:	48 85 d2             	test   %rdx,%rdx
  800eb5:	74 24                	je     800edb <strlcpy+0x2c>
        while (--size > 0 && *src)
  800eb7:	48 83 ea 01          	sub    $0x1,%rdx
  800ebb:	74 1b                	je     800ed8 <strlcpy+0x29>
  800ebd:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800ec1:	0f b6 16             	movzbl (%rsi),%edx
  800ec4:	84 d2                	test   %dl,%dl
  800ec6:	74 10                	je     800ed8 <strlcpy+0x29>
            *dst++ = *src++;
  800ec8:	48 83 c6 01          	add    $0x1,%rsi
  800ecc:	48 83 c0 01          	add    $0x1,%rax
  800ed0:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800ed3:	48 39 c8             	cmp    %rcx,%rax
  800ed6:	75 e9                	jne    800ec1 <strlcpy+0x12>
        *dst = '\0';
  800ed8:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800edb:	48 29 f8             	sub    %rdi,%rax
}
  800ede:	c3                   	ret    

0000000000800edf <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800edf:	0f b6 07             	movzbl (%rdi),%eax
  800ee2:	84 c0                	test   %al,%al
  800ee4:	74 13                	je     800ef9 <strcmp+0x1a>
  800ee6:	38 06                	cmp    %al,(%rsi)
  800ee8:	75 0f                	jne    800ef9 <strcmp+0x1a>
  800eea:	48 83 c7 01          	add    $0x1,%rdi
  800eee:	48 83 c6 01          	add    $0x1,%rsi
  800ef2:	0f b6 07             	movzbl (%rdi),%eax
  800ef5:	84 c0                	test   %al,%al
  800ef7:	75 ed                	jne    800ee6 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800ef9:	0f b6 c0             	movzbl %al,%eax
  800efc:	0f b6 16             	movzbl (%rsi),%edx
  800eff:	29 d0                	sub    %edx,%eax
}
  800f01:	c3                   	ret    

0000000000800f02 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800f02:	48 85 d2             	test   %rdx,%rdx
  800f05:	74 1f                	je     800f26 <strncmp+0x24>
  800f07:	0f b6 07             	movzbl (%rdi),%eax
  800f0a:	84 c0                	test   %al,%al
  800f0c:	74 1e                	je     800f2c <strncmp+0x2a>
  800f0e:	3a 06                	cmp    (%rsi),%al
  800f10:	75 1a                	jne    800f2c <strncmp+0x2a>
  800f12:	48 83 c7 01          	add    $0x1,%rdi
  800f16:	48 83 c6 01          	add    $0x1,%rsi
  800f1a:	48 83 ea 01          	sub    $0x1,%rdx
  800f1e:	75 e7                	jne    800f07 <strncmp+0x5>

    if (!n) return 0;
  800f20:	b8 00 00 00 00       	mov    $0x0,%eax
  800f25:	c3                   	ret    
  800f26:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2b:	c3                   	ret    
  800f2c:	48 85 d2             	test   %rdx,%rdx
  800f2f:	74 09                	je     800f3a <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800f31:	0f b6 07             	movzbl (%rdi),%eax
  800f34:	0f b6 16             	movzbl (%rsi),%edx
  800f37:	29 d0                	sub    %edx,%eax
  800f39:	c3                   	ret    
    if (!n) return 0;
  800f3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f3f:	c3                   	ret    

0000000000800f40 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800f40:	0f b6 07             	movzbl (%rdi),%eax
  800f43:	84 c0                	test   %al,%al
  800f45:	74 18                	je     800f5f <strchr+0x1f>
        if (*str == c) {
  800f47:	0f be c0             	movsbl %al,%eax
  800f4a:	39 f0                	cmp    %esi,%eax
  800f4c:	74 17                	je     800f65 <strchr+0x25>
    for (; *str; str++) {
  800f4e:	48 83 c7 01          	add    $0x1,%rdi
  800f52:	0f b6 07             	movzbl (%rdi),%eax
  800f55:	84 c0                	test   %al,%al
  800f57:	75 ee                	jne    800f47 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800f59:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5e:	c3                   	ret    
  800f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f64:	c3                   	ret    
  800f65:	48 89 f8             	mov    %rdi,%rax
}
  800f68:	c3                   	ret    

0000000000800f69 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800f69:	0f b6 07             	movzbl (%rdi),%eax
  800f6c:	84 c0                	test   %al,%al
  800f6e:	74 16                	je     800f86 <strfind+0x1d>
  800f70:	0f be c0             	movsbl %al,%eax
  800f73:	39 f0                	cmp    %esi,%eax
  800f75:	74 13                	je     800f8a <strfind+0x21>
  800f77:	48 83 c7 01          	add    $0x1,%rdi
  800f7b:	0f b6 07             	movzbl (%rdi),%eax
  800f7e:	84 c0                	test   %al,%al
  800f80:	75 ee                	jne    800f70 <strfind+0x7>
  800f82:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800f85:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800f86:	48 89 f8             	mov    %rdi,%rax
  800f89:	c3                   	ret    
  800f8a:	48 89 f8             	mov    %rdi,%rax
  800f8d:	c3                   	ret    

0000000000800f8e <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800f8e:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800f91:	48 89 f8             	mov    %rdi,%rax
  800f94:	48 f7 d8             	neg    %rax
  800f97:	83 e0 07             	and    $0x7,%eax
  800f9a:	49 89 d1             	mov    %rdx,%r9
  800f9d:	49 29 c1             	sub    %rax,%r9
  800fa0:	78 32                	js     800fd4 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800fa2:	40 0f b6 c6          	movzbl %sil,%eax
  800fa6:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800fad:	01 01 01 
  800fb0:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800fb4:	40 f6 c7 07          	test   $0x7,%dil
  800fb8:	75 34                	jne    800fee <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800fba:	4c 89 c9             	mov    %r9,%rcx
  800fbd:	48 c1 f9 03          	sar    $0x3,%rcx
  800fc1:	74 08                	je     800fcb <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800fc3:	fc                   	cld    
  800fc4:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800fc7:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800fcb:	4d 85 c9             	test   %r9,%r9
  800fce:	75 45                	jne    801015 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800fd0:	4c 89 c0             	mov    %r8,%rax
  800fd3:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800fd4:	48 85 d2             	test   %rdx,%rdx
  800fd7:	74 f7                	je     800fd0 <memset+0x42>
  800fd9:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800fdc:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800fdf:	48 83 c0 01          	add    $0x1,%rax
  800fe3:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800fe7:	48 39 c2             	cmp    %rax,%rdx
  800fea:	75 f3                	jne    800fdf <memset+0x51>
  800fec:	eb e2                	jmp    800fd0 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800fee:	40 f6 c7 01          	test   $0x1,%dil
  800ff2:	74 06                	je     800ffa <memset+0x6c>
  800ff4:	88 07                	mov    %al,(%rdi)
  800ff6:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ffa:	40 f6 c7 02          	test   $0x2,%dil
  800ffe:	74 07                	je     801007 <memset+0x79>
  801000:	66 89 07             	mov    %ax,(%rdi)
  801003:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801007:	40 f6 c7 04          	test   $0x4,%dil
  80100b:	74 ad                	je     800fba <memset+0x2c>
  80100d:	89 07                	mov    %eax,(%rdi)
  80100f:	48 83 c7 04          	add    $0x4,%rdi
  801013:	eb a5                	jmp    800fba <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  801015:	41 f6 c1 04          	test   $0x4,%r9b
  801019:	74 06                	je     801021 <memset+0x93>
  80101b:	89 07                	mov    %eax,(%rdi)
  80101d:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801021:	41 f6 c1 02          	test   $0x2,%r9b
  801025:	74 07                	je     80102e <memset+0xa0>
  801027:	66 89 07             	mov    %ax,(%rdi)
  80102a:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80102e:	41 f6 c1 01          	test   $0x1,%r9b
  801032:	74 9c                	je     800fd0 <memset+0x42>
  801034:	88 07                	mov    %al,(%rdi)
  801036:	eb 98                	jmp    800fd0 <memset+0x42>

0000000000801038 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801038:	48 89 f8             	mov    %rdi,%rax
  80103b:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  80103e:	48 39 fe             	cmp    %rdi,%rsi
  801041:	73 39                	jae    80107c <memmove+0x44>
  801043:	48 01 f2             	add    %rsi,%rdx
  801046:	48 39 fa             	cmp    %rdi,%rdx
  801049:	76 31                	jbe    80107c <memmove+0x44>
        s += n;
        d += n;
  80104b:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80104e:	48 89 d6             	mov    %rdx,%rsi
  801051:	48 09 fe             	or     %rdi,%rsi
  801054:	48 09 ce             	or     %rcx,%rsi
  801057:	40 f6 c6 07          	test   $0x7,%sil
  80105b:	75 12                	jne    80106f <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80105d:	48 83 ef 08          	sub    $0x8,%rdi
  801061:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801065:	48 c1 e9 03          	shr    $0x3,%rcx
  801069:	fd                   	std    
  80106a:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80106d:	fc                   	cld    
  80106e:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80106f:	48 83 ef 01          	sub    $0x1,%rdi
  801073:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  801077:	fd                   	std    
  801078:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  80107a:	eb f1                	jmp    80106d <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80107c:	48 89 f2             	mov    %rsi,%rdx
  80107f:	48 09 c2             	or     %rax,%rdx
  801082:	48 09 ca             	or     %rcx,%rdx
  801085:	f6 c2 07             	test   $0x7,%dl
  801088:	75 0c                	jne    801096 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80108a:	48 c1 e9 03          	shr    $0x3,%rcx
  80108e:	48 89 c7             	mov    %rax,%rdi
  801091:	fc                   	cld    
  801092:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801095:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  801096:	48 89 c7             	mov    %rax,%rdi
  801099:	fc                   	cld    
  80109a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  80109c:	c3                   	ret    

000000000080109d <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  80109d:	55                   	push   %rbp
  80109e:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8010a1:	48 b8 38 10 80 00 00 	movabs $0x801038,%rax
  8010a8:	00 00 00 
  8010ab:	ff d0                	call   *%rax
}
  8010ad:	5d                   	pop    %rbp
  8010ae:	c3                   	ret    

00000000008010af <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8010af:	55                   	push   %rbp
  8010b0:	48 89 e5             	mov    %rsp,%rbp
  8010b3:	41 57                	push   %r15
  8010b5:	41 56                	push   %r14
  8010b7:	41 55                	push   %r13
  8010b9:	41 54                	push   %r12
  8010bb:	53                   	push   %rbx
  8010bc:	48 83 ec 08          	sub    $0x8,%rsp
  8010c0:	49 89 fe             	mov    %rdi,%r14
  8010c3:	49 89 f7             	mov    %rsi,%r15
  8010c6:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8010c9:	48 89 f7             	mov    %rsi,%rdi
  8010cc:	48 b8 04 0e 80 00 00 	movabs $0x800e04,%rax
  8010d3:	00 00 00 
  8010d6:	ff d0                	call   *%rax
  8010d8:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8010db:	48 89 de             	mov    %rbx,%rsi
  8010de:	4c 89 f7             	mov    %r14,%rdi
  8010e1:	48 b8 1f 0e 80 00 00 	movabs $0x800e1f,%rax
  8010e8:	00 00 00 
  8010eb:	ff d0                	call   *%rax
  8010ed:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8010f0:	48 39 c3             	cmp    %rax,%rbx
  8010f3:	74 36                	je     80112b <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  8010f5:	48 89 d8             	mov    %rbx,%rax
  8010f8:	4c 29 e8             	sub    %r13,%rax
  8010fb:	4c 39 e0             	cmp    %r12,%rax
  8010fe:	76 30                	jbe    801130 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  801100:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801105:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801109:	4c 89 fe             	mov    %r15,%rsi
  80110c:	48 b8 9d 10 80 00 00 	movabs $0x80109d,%rax
  801113:	00 00 00 
  801116:	ff d0                	call   *%rax
    return dstlen + srclen;
  801118:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80111c:	48 83 c4 08          	add    $0x8,%rsp
  801120:	5b                   	pop    %rbx
  801121:	41 5c                	pop    %r12
  801123:	41 5d                	pop    %r13
  801125:	41 5e                	pop    %r14
  801127:	41 5f                	pop    %r15
  801129:	5d                   	pop    %rbp
  80112a:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  80112b:	4c 01 e0             	add    %r12,%rax
  80112e:	eb ec                	jmp    80111c <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  801130:	48 83 eb 01          	sub    $0x1,%rbx
  801134:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801138:	48 89 da             	mov    %rbx,%rdx
  80113b:	4c 89 fe             	mov    %r15,%rsi
  80113e:	48 b8 9d 10 80 00 00 	movabs $0x80109d,%rax
  801145:	00 00 00 
  801148:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80114a:	49 01 de             	add    %rbx,%r14
  80114d:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801152:	eb c4                	jmp    801118 <strlcat+0x69>

0000000000801154 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801154:	49 89 f0             	mov    %rsi,%r8
  801157:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  80115a:	48 85 d2             	test   %rdx,%rdx
  80115d:	74 2a                	je     801189 <memcmp+0x35>
  80115f:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801164:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801168:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80116d:	38 ca                	cmp    %cl,%dl
  80116f:	75 0f                	jne    801180 <memcmp+0x2c>
    while (n-- > 0) {
  801171:	48 83 c0 01          	add    $0x1,%rax
  801175:	48 39 c6             	cmp    %rax,%rsi
  801178:	75 ea                	jne    801164 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
  80117f:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  801180:	0f b6 c2             	movzbl %dl,%eax
  801183:	0f b6 c9             	movzbl %cl,%ecx
  801186:	29 c8                	sub    %ecx,%eax
  801188:	c3                   	ret    
    return 0;
  801189:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80118e:	c3                   	ret    

000000000080118f <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80118f:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801193:	48 39 c7             	cmp    %rax,%rdi
  801196:	73 0f                	jae    8011a7 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801198:	40 38 37             	cmp    %sil,(%rdi)
  80119b:	74 0e                	je     8011ab <memfind+0x1c>
    for (; src < end; src++) {
  80119d:	48 83 c7 01          	add    $0x1,%rdi
  8011a1:	48 39 f8             	cmp    %rdi,%rax
  8011a4:	75 f2                	jne    801198 <memfind+0x9>
  8011a6:	c3                   	ret    
  8011a7:	48 89 f8             	mov    %rdi,%rax
  8011aa:	c3                   	ret    
  8011ab:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8011ae:	c3                   	ret    

00000000008011af <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8011af:	49 89 f2             	mov    %rsi,%r10
  8011b2:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8011b5:	0f b6 37             	movzbl (%rdi),%esi
  8011b8:	40 80 fe 20          	cmp    $0x20,%sil
  8011bc:	74 06                	je     8011c4 <strtol+0x15>
  8011be:	40 80 fe 09          	cmp    $0x9,%sil
  8011c2:	75 13                	jne    8011d7 <strtol+0x28>
  8011c4:	48 83 c7 01          	add    $0x1,%rdi
  8011c8:	0f b6 37             	movzbl (%rdi),%esi
  8011cb:	40 80 fe 20          	cmp    $0x20,%sil
  8011cf:	74 f3                	je     8011c4 <strtol+0x15>
  8011d1:	40 80 fe 09          	cmp    $0x9,%sil
  8011d5:	74 ed                	je     8011c4 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8011d7:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8011da:	83 e0 fd             	and    $0xfffffffd,%eax
  8011dd:	3c 01                	cmp    $0x1,%al
  8011df:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8011e3:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  8011ea:	75 11                	jne    8011fd <strtol+0x4e>
  8011ec:	80 3f 30             	cmpb   $0x30,(%rdi)
  8011ef:	74 16                	je     801207 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8011f1:	45 85 c0             	test   %r8d,%r8d
  8011f4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011f9:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8011fd:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801202:	4d 63 c8             	movslq %r8d,%r9
  801205:	eb 38                	jmp    80123f <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801207:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80120b:	74 11                	je     80121e <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  80120d:	45 85 c0             	test   %r8d,%r8d
  801210:	75 eb                	jne    8011fd <strtol+0x4e>
        s++;
  801212:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801216:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  80121c:	eb df                	jmp    8011fd <strtol+0x4e>
        s += 2;
  80121e:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801222:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  801228:	eb d3                	jmp    8011fd <strtol+0x4e>
            dig -= '0';
  80122a:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  80122d:	0f b6 c8             	movzbl %al,%ecx
  801230:	44 39 c1             	cmp    %r8d,%ecx
  801233:	7d 1f                	jge    801254 <strtol+0xa5>
        val = val * base + dig;
  801235:	49 0f af d1          	imul   %r9,%rdx
  801239:	0f b6 c0             	movzbl %al,%eax
  80123c:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  80123f:	48 83 c7 01          	add    $0x1,%rdi
  801243:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  801247:	3c 39                	cmp    $0x39,%al
  801249:	76 df                	jbe    80122a <strtol+0x7b>
        else if (dig - 'a' < 27)
  80124b:	3c 7b                	cmp    $0x7b,%al
  80124d:	77 05                	ja     801254 <strtol+0xa5>
            dig -= 'a' - 10;
  80124f:	83 e8 57             	sub    $0x57,%eax
  801252:	eb d9                	jmp    80122d <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  801254:	4d 85 d2             	test   %r10,%r10
  801257:	74 03                	je     80125c <strtol+0xad>
  801259:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80125c:	48 89 d0             	mov    %rdx,%rax
  80125f:	48 f7 d8             	neg    %rax
  801262:	40 80 fe 2d          	cmp    $0x2d,%sil
  801266:	48 0f 44 d0          	cmove  %rax,%rdx
}
  80126a:	48 89 d0             	mov    %rdx,%rax
  80126d:	c3                   	ret    

000000000080126e <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80126e:	55                   	push   %rbp
  80126f:	48 89 e5             	mov    %rsp,%rbp
  801272:	53                   	push   %rbx
  801273:	48 89 fa             	mov    %rdi,%rdx
  801276:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801279:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80127e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801283:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801288:	be 00 00 00 00       	mov    $0x0,%esi
  80128d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801293:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801295:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801299:	c9                   	leave  
  80129a:	c3                   	ret    

000000000080129b <sys_cgetc>:

int
sys_cgetc(void) {
  80129b:	55                   	push   %rbp
  80129c:	48 89 e5             	mov    %rsp,%rbp
  80129f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8012a0:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8012aa:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012b9:	be 00 00 00 00       	mov    $0x0,%esi
  8012be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012c4:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8012c6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    

00000000008012cc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8012cc:	55                   	push   %rbp
  8012cd:	48 89 e5             	mov    %rsp,%rbp
  8012d0:	53                   	push   %rbx
  8012d1:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8012d5:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012d8:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012dd:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012ec:	be 00 00 00 00       	mov    $0x0,%esi
  8012f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012f7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012f9:	48 85 c0             	test   %rax,%rax
  8012fc:	7f 06                	jg     801304 <sys_env_destroy+0x38>
}
  8012fe:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801302:	c9                   	leave  
  801303:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801304:	49 89 c0             	mov    %rax,%r8
  801307:	b9 03 00 00 00       	mov    $0x3,%ecx
  80130c:	48 ba 40 34 80 00 00 	movabs $0x803440,%rdx
  801313:	00 00 00 
  801316:	be 26 00 00 00       	mov    $0x26,%esi
  80131b:	48 bf 5f 34 80 00 00 	movabs $0x80345f,%rdi
  801322:	00 00 00 
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
  80132a:	49 b9 ac 03 80 00 00 	movabs $0x8003ac,%r9
  801331:	00 00 00 
  801334:	41 ff d1             	call   *%r9

0000000000801337 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801337:	55                   	push   %rbp
  801338:	48 89 e5             	mov    %rsp,%rbp
  80133b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80133c:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801341:	ba 00 00 00 00       	mov    $0x0,%edx
  801346:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80134b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801350:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801355:	be 00 00 00 00       	mov    $0x0,%esi
  80135a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801360:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801362:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801366:	c9                   	leave  
  801367:	c3                   	ret    

0000000000801368 <sys_yield>:

void
sys_yield(void) {
  801368:	55                   	push   %rbp
  801369:	48 89 e5             	mov    %rsp,%rbp
  80136c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80136d:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801372:	ba 00 00 00 00       	mov    $0x0,%edx
  801377:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80137c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801381:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801386:	be 00 00 00 00       	mov    $0x0,%esi
  80138b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801391:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801393:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801397:	c9                   	leave  
  801398:	c3                   	ret    

0000000000801399 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801399:	55                   	push   %rbp
  80139a:	48 89 e5             	mov    %rsp,%rbp
  80139d:	53                   	push   %rbx
  80139e:	48 89 fa             	mov    %rdi,%rdx
  8013a1:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8013a4:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013a9:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8013b0:	00 00 00 
  8013b3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013b8:	be 00 00 00 00       	mov    $0x0,%esi
  8013bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013c3:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8013c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

00000000008013cb <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8013cb:	55                   	push   %rbp
  8013cc:	48 89 e5             	mov    %rsp,%rbp
  8013cf:	53                   	push   %rbx
  8013d0:	49 89 f8             	mov    %rdi,%r8
  8013d3:	48 89 d3             	mov    %rdx,%rbx
  8013d6:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8013d9:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013de:	4c 89 c2             	mov    %r8,%rdx
  8013e1:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e4:	be 00 00 00 00       	mov    $0x0,%esi
  8013e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013ef:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8013f1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

00000000008013f7 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8013f7:	55                   	push   %rbp
  8013f8:	48 89 e5             	mov    %rsp,%rbp
  8013fb:	53                   	push   %rbx
  8013fc:	48 83 ec 08          	sub    $0x8,%rsp
  801400:	89 f8                	mov    %edi,%eax
  801402:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801405:	48 63 f9             	movslq %ecx,%rdi
  801408:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80140b:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801410:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801413:	be 00 00 00 00       	mov    $0x0,%esi
  801418:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80141e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801420:	48 85 c0             	test   %rax,%rax
  801423:	7f 06                	jg     80142b <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801425:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801429:	c9                   	leave  
  80142a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80142b:	49 89 c0             	mov    %rax,%r8
  80142e:	b9 04 00 00 00       	mov    $0x4,%ecx
  801433:	48 ba 40 34 80 00 00 	movabs $0x803440,%rdx
  80143a:	00 00 00 
  80143d:	be 26 00 00 00       	mov    $0x26,%esi
  801442:	48 bf 5f 34 80 00 00 	movabs $0x80345f,%rdi
  801449:	00 00 00 
  80144c:	b8 00 00 00 00       	mov    $0x0,%eax
  801451:	49 b9 ac 03 80 00 00 	movabs $0x8003ac,%r9
  801458:	00 00 00 
  80145b:	41 ff d1             	call   *%r9

000000000080145e <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80145e:	55                   	push   %rbp
  80145f:	48 89 e5             	mov    %rsp,%rbp
  801462:	53                   	push   %rbx
  801463:	48 83 ec 08          	sub    $0x8,%rsp
  801467:	89 f8                	mov    %edi,%eax
  801469:	49 89 f2             	mov    %rsi,%r10
  80146c:	48 89 cf             	mov    %rcx,%rdi
  80146f:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801472:	48 63 da             	movslq %edx,%rbx
  801475:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801478:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80147d:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801480:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801483:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801485:	48 85 c0             	test   %rax,%rax
  801488:	7f 06                	jg     801490 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80148a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801490:	49 89 c0             	mov    %rax,%r8
  801493:	b9 05 00 00 00       	mov    $0x5,%ecx
  801498:	48 ba 40 34 80 00 00 	movabs $0x803440,%rdx
  80149f:	00 00 00 
  8014a2:	be 26 00 00 00       	mov    $0x26,%esi
  8014a7:	48 bf 5f 34 80 00 00 	movabs $0x80345f,%rdi
  8014ae:	00 00 00 
  8014b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b6:	49 b9 ac 03 80 00 00 	movabs $0x8003ac,%r9
  8014bd:	00 00 00 
  8014c0:	41 ff d1             	call   *%r9

00000000008014c3 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8014c3:	55                   	push   %rbp
  8014c4:	48 89 e5             	mov    %rsp,%rbp
  8014c7:	53                   	push   %rbx
  8014c8:	48 83 ec 08          	sub    $0x8,%rsp
  8014cc:	48 89 f1             	mov    %rsi,%rcx
  8014cf:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8014d2:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014d5:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014da:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014df:	be 00 00 00 00       	mov    $0x0,%esi
  8014e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014ea:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014ec:	48 85 c0             	test   %rax,%rax
  8014ef:	7f 06                	jg     8014f7 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8014f1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014f7:	49 89 c0             	mov    %rax,%r8
  8014fa:	b9 06 00 00 00       	mov    $0x6,%ecx
  8014ff:	48 ba 40 34 80 00 00 	movabs $0x803440,%rdx
  801506:	00 00 00 
  801509:	be 26 00 00 00       	mov    $0x26,%esi
  80150e:	48 bf 5f 34 80 00 00 	movabs $0x80345f,%rdi
  801515:	00 00 00 
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
  80151d:	49 b9 ac 03 80 00 00 	movabs $0x8003ac,%r9
  801524:	00 00 00 
  801527:	41 ff d1             	call   *%r9

000000000080152a <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80152a:	55                   	push   %rbp
  80152b:	48 89 e5             	mov    %rsp,%rbp
  80152e:	53                   	push   %rbx
  80152f:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801533:	48 63 ce             	movslq %esi,%rcx
  801536:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801539:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80153e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801543:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801548:	be 00 00 00 00       	mov    $0x0,%esi
  80154d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801553:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801555:	48 85 c0             	test   %rax,%rax
  801558:	7f 06                	jg     801560 <sys_env_set_status+0x36>
}
  80155a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801560:	49 89 c0             	mov    %rax,%r8
  801563:	b9 09 00 00 00       	mov    $0x9,%ecx
  801568:	48 ba 40 34 80 00 00 	movabs $0x803440,%rdx
  80156f:	00 00 00 
  801572:	be 26 00 00 00       	mov    $0x26,%esi
  801577:	48 bf 5f 34 80 00 00 	movabs $0x80345f,%rdi
  80157e:	00 00 00 
  801581:	b8 00 00 00 00       	mov    $0x0,%eax
  801586:	49 b9 ac 03 80 00 00 	movabs $0x8003ac,%r9
  80158d:	00 00 00 
  801590:	41 ff d1             	call   *%r9

0000000000801593 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801593:	55                   	push   %rbp
  801594:	48 89 e5             	mov    %rsp,%rbp
  801597:	53                   	push   %rbx
  801598:	48 83 ec 08          	sub    $0x8,%rsp
  80159c:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80159f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015a2:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015ac:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015b1:	be 00 00 00 00       	mov    $0x0,%esi
  8015b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015bc:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015be:	48 85 c0             	test   %rax,%rax
  8015c1:	7f 06                	jg     8015c9 <sys_env_set_trapframe+0x36>
}
  8015c3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015c9:	49 89 c0             	mov    %rax,%r8
  8015cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015d1:	48 ba 40 34 80 00 00 	movabs $0x803440,%rdx
  8015d8:	00 00 00 
  8015db:	be 26 00 00 00       	mov    $0x26,%esi
  8015e0:	48 bf 5f 34 80 00 00 	movabs $0x80345f,%rdi
  8015e7:	00 00 00 
  8015ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ef:	49 b9 ac 03 80 00 00 	movabs $0x8003ac,%r9
  8015f6:	00 00 00 
  8015f9:	41 ff d1             	call   *%r9

00000000008015fc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8015fc:	55                   	push   %rbp
  8015fd:	48 89 e5             	mov    %rsp,%rbp
  801600:	53                   	push   %rbx
  801601:	48 83 ec 08          	sub    $0x8,%rsp
  801605:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801608:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80160b:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801610:	bb 00 00 00 00       	mov    $0x0,%ebx
  801615:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80161a:	be 00 00 00 00       	mov    $0x0,%esi
  80161f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801625:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801627:	48 85 c0             	test   %rax,%rax
  80162a:	7f 06                	jg     801632 <sys_env_set_pgfault_upcall+0x36>
}
  80162c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801630:	c9                   	leave  
  801631:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801632:	49 89 c0             	mov    %rax,%r8
  801635:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80163a:	48 ba 40 34 80 00 00 	movabs $0x803440,%rdx
  801641:	00 00 00 
  801644:	be 26 00 00 00       	mov    $0x26,%esi
  801649:	48 bf 5f 34 80 00 00 	movabs $0x80345f,%rdi
  801650:	00 00 00 
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	49 b9 ac 03 80 00 00 	movabs $0x8003ac,%r9
  80165f:	00 00 00 
  801662:	41 ff d1             	call   *%r9

0000000000801665 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801665:	55                   	push   %rbp
  801666:	48 89 e5             	mov    %rsp,%rbp
  801669:	53                   	push   %rbx
  80166a:	89 f8                	mov    %edi,%eax
  80166c:	49 89 f1             	mov    %rsi,%r9
  80166f:	48 89 d3             	mov    %rdx,%rbx
  801672:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801675:	49 63 f0             	movslq %r8d,%rsi
  801678:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80167b:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801680:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801683:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801689:	cd 30                	int    $0x30
}
  80168b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

0000000000801691 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801691:	55                   	push   %rbp
  801692:	48 89 e5             	mov    %rsp,%rbp
  801695:	53                   	push   %rbx
  801696:	48 83 ec 08          	sub    $0x8,%rsp
  80169a:	48 89 fa             	mov    %rdi,%rdx
  80169d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8016a0:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016aa:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016af:	be 00 00 00 00       	mov    $0x0,%esi
  8016b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016ba:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016bc:	48 85 c0             	test   %rax,%rax
  8016bf:	7f 06                	jg     8016c7 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8016c1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016c7:	49 89 c0             	mov    %rax,%r8
  8016ca:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8016cf:	48 ba 40 34 80 00 00 	movabs $0x803440,%rdx
  8016d6:	00 00 00 
  8016d9:	be 26 00 00 00       	mov    $0x26,%esi
  8016de:	48 bf 5f 34 80 00 00 	movabs $0x80345f,%rdi
  8016e5:	00 00 00 
  8016e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ed:	49 b9 ac 03 80 00 00 	movabs $0x8003ac,%r9
  8016f4:	00 00 00 
  8016f7:	41 ff d1             	call   *%r9

00000000008016fa <sys_gettime>:

int
sys_gettime(void) {
  8016fa:	55                   	push   %rbp
  8016fb:	48 89 e5             	mov    %rsp,%rbp
  8016fe:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8016ff:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801704:	ba 00 00 00 00       	mov    $0x0,%edx
  801709:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80170e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801713:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801718:	be 00 00 00 00       	mov    $0x0,%esi
  80171d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801723:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801725:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

000000000080172b <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  80172b:	55                   	push   %rbp
  80172c:	48 89 e5             	mov    %rsp,%rbp
  80172f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801730:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801735:	ba 00 00 00 00       	mov    $0x0,%edx
  80173a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80173f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801744:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801749:	be 00 00 00 00       	mov    $0x0,%esi
  80174e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801754:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801756:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

000000000080175c <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  80175c:	55                   	push   %rbp
  80175d:	48 89 e5             	mov    %rsp,%rbp
  801760:	53                   	push   %rbx
  801761:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  801765:	b8 08 00 00 00       	mov    $0x8,%eax
  80176a:	cd 30                	int    $0x30
  80176c:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  80176e:	85 c0                	test   %eax,%eax
  801770:	0f 88 85 00 00 00    	js     8017fb <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  801776:	0f 84 ac 00 00 00    	je     801828 <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  80177c:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  801782:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801789:	00 00 00 
  80178c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801791:	89 c2                	mov    %eax,%edx
  801793:	be 00 00 00 00       	mov    $0x0,%esi
  801798:	bf 00 00 00 00       	mov    $0x0,%edi
  80179d:	48 b8 5e 14 80 00 00 	movabs $0x80145e,%rax
  8017a4:	00 00 00 
  8017a7:	ff d0                	call   *%rax
    if (res < 0)
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	0f 88 ad 00 00 00    	js     80185e <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  8017b1:	be 02 00 00 00       	mov    $0x2,%esi
  8017b6:	89 df                	mov    %ebx,%edi
  8017b8:	48 b8 2a 15 80 00 00 	movabs $0x80152a,%rax
  8017bf:	00 00 00 
  8017c2:	ff d0                	call   *%rax
    if (res < 0)
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	0f 88 bf 00 00 00    	js     80188b <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  8017cc:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8017d3:	00 00 00 
  8017d6:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  8017dd:	89 df                	mov    %ebx,%edi
  8017df:	48 b8 fc 15 80 00 00 	movabs $0x8015fc,%rax
  8017e6:	00 00 00 
  8017e9:	ff d0                	call   *%rax
    if (res < 0)
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	0f 88 c5 00 00 00    	js     8018b8 <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  8017f3:	89 d8                	mov    %ebx,%eax
  8017f5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  8017fb:	89 c1                	mov    %eax,%ecx
  8017fd:	48 ba 6d 34 80 00 00 	movabs $0x80346d,%rdx
  801804:	00 00 00 
  801807:	be 1a 00 00 00       	mov    $0x1a,%esi
  80180c:	48 bf 7d 34 80 00 00 	movabs $0x80347d,%rdi
  801813:	00 00 00 
  801816:	b8 00 00 00 00       	mov    $0x0,%eax
  80181b:	49 b8 ac 03 80 00 00 	movabs $0x8003ac,%r8
  801822:	00 00 00 
  801825:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  801828:	48 b8 37 13 80 00 00 	movabs $0x801337,%rax
  80182f:	00 00 00 
  801832:	ff d0                	call   *%rax
  801834:	25 ff 03 00 00       	and    $0x3ff,%eax
  801839:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80183d:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801841:	48 c1 e0 04          	shl    $0x4,%rax
  801845:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  80184c:	00 00 00 
  80184f:	48 01 d0             	add    %rdx,%rax
  801852:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  801859:	00 00 00 
        return 0;
  80185c:	eb 95                	jmp    8017f3 <fork+0x97>
        panic("sys_map_region: %i", res);
  80185e:	89 c1                	mov    %eax,%ecx
  801860:	48 ba 88 34 80 00 00 	movabs $0x803488,%rdx
  801867:	00 00 00 
  80186a:	be 22 00 00 00       	mov    $0x22,%esi
  80186f:	48 bf 7d 34 80 00 00 	movabs $0x80347d,%rdi
  801876:	00 00 00 
  801879:	b8 00 00 00 00       	mov    $0x0,%eax
  80187e:	49 b8 ac 03 80 00 00 	movabs $0x8003ac,%r8
  801885:	00 00 00 
  801888:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  80188b:	89 c1                	mov    %eax,%ecx
  80188d:	48 ba 9b 34 80 00 00 	movabs $0x80349b,%rdx
  801894:	00 00 00 
  801897:	be 25 00 00 00       	mov    $0x25,%esi
  80189c:	48 bf 7d 34 80 00 00 	movabs $0x80347d,%rdi
  8018a3:	00 00 00 
  8018a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ab:	49 b8 ac 03 80 00 00 	movabs $0x8003ac,%r8
  8018b2:	00 00 00 
  8018b5:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  8018b8:	89 c1                	mov    %eax,%ecx
  8018ba:	48 ba d0 34 80 00 00 	movabs $0x8034d0,%rdx
  8018c1:	00 00 00 
  8018c4:	be 28 00 00 00       	mov    $0x28,%esi
  8018c9:	48 bf 7d 34 80 00 00 	movabs $0x80347d,%rdi
  8018d0:	00 00 00 
  8018d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d8:	49 b8 ac 03 80 00 00 	movabs $0x8003ac,%r8
  8018df:	00 00 00 
  8018e2:	41 ff d0             	call   *%r8

00000000008018e5 <sfork>:

envid_t
sfork() {
  8018e5:	55                   	push   %rbp
  8018e6:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  8018e9:	48 ba b2 34 80 00 00 	movabs $0x8034b2,%rdx
  8018f0:	00 00 00 
  8018f3:	be 2f 00 00 00       	mov    $0x2f,%esi
  8018f8:	48 bf 7d 34 80 00 00 	movabs $0x80347d,%rdi
  8018ff:	00 00 00 
  801902:	b8 00 00 00 00       	mov    $0x0,%eax
  801907:	48 b9 ac 03 80 00 00 	movabs $0x8003ac,%rcx
  80190e:	00 00 00 
  801911:	ff d1                	call   *%rcx

0000000000801913 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801913:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80191a:	ff ff ff 
  80191d:	48 01 f8             	add    %rdi,%rax
  801920:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801924:	c3                   	ret    

0000000000801925 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801925:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80192c:	ff ff ff 
  80192f:	48 01 f8             	add    %rdi,%rax
  801932:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  801936:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80193c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801940:	c3                   	ret    

0000000000801941 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801941:	55                   	push   %rbp
  801942:	48 89 e5             	mov    %rsp,%rbp
  801945:	41 57                	push   %r15
  801947:	41 56                	push   %r14
  801949:	41 55                	push   %r13
  80194b:	41 54                	push   %r12
  80194d:	53                   	push   %rbx
  80194e:	48 83 ec 08          	sub    $0x8,%rsp
  801952:	49 89 ff             	mov    %rdi,%r15
  801955:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80195a:	49 bc ef 28 80 00 00 	movabs $0x8028ef,%r12
  801961:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801964:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  80196a:	48 89 df             	mov    %rbx,%rdi
  80196d:	41 ff d4             	call   *%r12
  801970:	83 e0 04             	and    $0x4,%eax
  801973:	74 1a                	je     80198f <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  801975:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80197c:	4c 39 f3             	cmp    %r14,%rbx
  80197f:	75 e9                	jne    80196a <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801981:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801988:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80198d:	eb 03                	jmp    801992 <fd_alloc+0x51>
            *fd_store = fd;
  80198f:	49 89 1f             	mov    %rbx,(%r15)
}
  801992:	48 83 c4 08          	add    $0x8,%rsp
  801996:	5b                   	pop    %rbx
  801997:	41 5c                	pop    %r12
  801999:	41 5d                	pop    %r13
  80199b:	41 5e                	pop    %r14
  80199d:	41 5f                	pop    %r15
  80199f:	5d                   	pop    %rbp
  8019a0:	c3                   	ret    

00000000008019a1 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8019a1:	83 ff 1f             	cmp    $0x1f,%edi
  8019a4:	77 39                	ja     8019df <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8019a6:	55                   	push   %rbp
  8019a7:	48 89 e5             	mov    %rsp,%rbp
  8019aa:	41 54                	push   %r12
  8019ac:	53                   	push   %rbx
  8019ad:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8019b0:	48 63 df             	movslq %edi,%rbx
  8019b3:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8019ba:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8019be:	48 89 df             	mov    %rbx,%rdi
  8019c1:	48 b8 ef 28 80 00 00 	movabs $0x8028ef,%rax
  8019c8:	00 00 00 
  8019cb:	ff d0                	call   *%rax
  8019cd:	a8 04                	test   $0x4,%al
  8019cf:	74 14                	je     8019e5 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8019d1:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8019d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019da:	5b                   	pop    %rbx
  8019db:	41 5c                	pop    %r12
  8019dd:	5d                   	pop    %rbp
  8019de:	c3                   	ret    
        return -E_INVAL;
  8019df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019e4:	c3                   	ret    
        return -E_INVAL;
  8019e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ea:	eb ee                	jmp    8019da <fd_lookup+0x39>

00000000008019ec <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8019ec:	55                   	push   %rbp
  8019ed:	48 89 e5             	mov    %rsp,%rbp
  8019f0:	53                   	push   %rbx
  8019f1:	48 83 ec 08          	sub    $0x8,%rsp
  8019f5:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8019f8:	48 ba 80 35 80 00 00 	movabs $0x803580,%rdx
  8019ff:	00 00 00 
  801a02:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801a09:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801a0c:	39 38                	cmp    %edi,(%rax)
  801a0e:	74 4b                	je     801a5b <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801a10:	48 83 c2 08          	add    $0x8,%rdx
  801a14:	48 8b 02             	mov    (%rdx),%rax
  801a17:	48 85 c0             	test   %rax,%rax
  801a1a:	75 f0                	jne    801a0c <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a1c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a23:	00 00 00 
  801a26:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a2c:	89 fa                	mov    %edi,%edx
  801a2e:	48 bf f0 34 80 00 00 	movabs $0x8034f0,%rdi
  801a35:	00 00 00 
  801a38:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3d:	48 b9 fc 04 80 00 00 	movabs $0x8004fc,%rcx
  801a44:	00 00 00 
  801a47:	ff d1                	call   *%rcx
    *dev = 0;
  801a49:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801a50:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a55:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    
            *dev = devtab[i];
  801a5b:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a63:	eb f0                	jmp    801a55 <dev_lookup+0x69>

0000000000801a65 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801a65:	55                   	push   %rbp
  801a66:	48 89 e5             	mov    %rsp,%rbp
  801a69:	41 55                	push   %r13
  801a6b:	41 54                	push   %r12
  801a6d:	53                   	push   %rbx
  801a6e:	48 83 ec 18          	sub    $0x18,%rsp
  801a72:	49 89 fc             	mov    %rdi,%r12
  801a75:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a78:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801a7f:	ff ff ff 
  801a82:	4c 01 e7             	add    %r12,%rdi
  801a85:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801a89:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a8d:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  801a94:	00 00 00 
  801a97:	ff d0                	call   *%rax
  801a99:	89 c3                	mov    %eax,%ebx
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 06                	js     801aa5 <fd_close+0x40>
  801a9f:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801aa3:	74 18                	je     801abd <fd_close+0x58>
        return (must_exist ? res : 0);
  801aa5:	45 84 ed             	test   %r13b,%r13b
  801aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  801aad:	0f 44 d8             	cmove  %eax,%ebx
}
  801ab0:	89 d8                	mov    %ebx,%eax
  801ab2:	48 83 c4 18          	add    $0x18,%rsp
  801ab6:	5b                   	pop    %rbx
  801ab7:	41 5c                	pop    %r12
  801ab9:	41 5d                	pop    %r13
  801abb:	5d                   	pop    %rbp
  801abc:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801abd:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ac1:	41 8b 3c 24          	mov    (%r12),%edi
  801ac5:	48 b8 ec 19 80 00 00 	movabs $0x8019ec,%rax
  801acc:	00 00 00 
  801acf:	ff d0                	call   *%rax
  801ad1:	89 c3                	mov    %eax,%ebx
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	78 19                	js     801af0 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801ad7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801adb:	48 8b 40 20          	mov    0x20(%rax),%rax
  801adf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ae4:	48 85 c0             	test   %rax,%rax
  801ae7:	74 07                	je     801af0 <fd_close+0x8b>
  801ae9:	4c 89 e7             	mov    %r12,%rdi
  801aec:	ff d0                	call   *%rax
  801aee:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801af0:	ba 00 10 00 00       	mov    $0x1000,%edx
  801af5:	4c 89 e6             	mov    %r12,%rsi
  801af8:	bf 00 00 00 00       	mov    $0x0,%edi
  801afd:	48 b8 c3 14 80 00 00 	movabs $0x8014c3,%rax
  801b04:	00 00 00 
  801b07:	ff d0                	call   *%rax
    return res;
  801b09:	eb a5                	jmp    801ab0 <fd_close+0x4b>

0000000000801b0b <close>:

int
close(int fdnum) {
  801b0b:	55                   	push   %rbp
  801b0c:	48 89 e5             	mov    %rsp,%rbp
  801b0f:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801b13:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b17:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  801b1e:	00 00 00 
  801b21:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b23:	85 c0                	test   %eax,%eax
  801b25:	78 15                	js     801b3c <close+0x31>

    return fd_close(fd, 1);
  801b27:	be 01 00 00 00       	mov    $0x1,%esi
  801b2c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801b30:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  801b37:	00 00 00 
  801b3a:	ff d0                	call   *%rax
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

0000000000801b3e <close_all>:

void
close_all(void) {
  801b3e:	55                   	push   %rbp
  801b3f:	48 89 e5             	mov    %rsp,%rbp
  801b42:	41 54                	push   %r12
  801b44:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801b45:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b4a:	49 bc 0b 1b 80 00 00 	movabs $0x801b0b,%r12
  801b51:	00 00 00 
  801b54:	89 df                	mov    %ebx,%edi
  801b56:	41 ff d4             	call   *%r12
  801b59:	83 c3 01             	add    $0x1,%ebx
  801b5c:	83 fb 20             	cmp    $0x20,%ebx
  801b5f:	75 f3                	jne    801b54 <close_all+0x16>
}
  801b61:	5b                   	pop    %rbx
  801b62:	41 5c                	pop    %r12
  801b64:	5d                   	pop    %rbp
  801b65:	c3                   	ret    

0000000000801b66 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801b66:	55                   	push   %rbp
  801b67:	48 89 e5             	mov    %rsp,%rbp
  801b6a:	41 56                	push   %r14
  801b6c:	41 55                	push   %r13
  801b6e:	41 54                	push   %r12
  801b70:	53                   	push   %rbx
  801b71:	48 83 ec 10          	sub    $0x10,%rsp
  801b75:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801b78:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b7c:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  801b83:	00 00 00 
  801b86:	ff d0                	call   *%rax
  801b88:	89 c3                	mov    %eax,%ebx
  801b8a:	85 c0                	test   %eax,%eax
  801b8c:	0f 88 b7 00 00 00    	js     801c49 <dup+0xe3>
    close(newfdnum);
  801b92:	44 89 e7             	mov    %r12d,%edi
  801b95:	48 b8 0b 1b 80 00 00 	movabs $0x801b0b,%rax
  801b9c:	00 00 00 
  801b9f:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801ba1:	4d 63 ec             	movslq %r12d,%r13
  801ba4:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801bab:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801baf:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801bb3:	49 be 25 19 80 00 00 	movabs $0x801925,%r14
  801bba:	00 00 00 
  801bbd:	41 ff d6             	call   *%r14
  801bc0:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801bc3:	4c 89 ef             	mov    %r13,%rdi
  801bc6:	41 ff d6             	call   *%r14
  801bc9:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801bcc:	48 89 df             	mov    %rbx,%rdi
  801bcf:	48 b8 ef 28 80 00 00 	movabs $0x8028ef,%rax
  801bd6:	00 00 00 
  801bd9:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801bdb:	a8 04                	test   $0x4,%al
  801bdd:	74 2b                	je     801c0a <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801bdf:	41 89 c1             	mov    %eax,%r9d
  801be2:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801be8:	4c 89 f1             	mov    %r14,%rcx
  801beb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf0:	48 89 de             	mov    %rbx,%rsi
  801bf3:	bf 00 00 00 00       	mov    $0x0,%edi
  801bf8:	48 b8 5e 14 80 00 00 	movabs $0x80145e,%rax
  801bff:	00 00 00 
  801c02:	ff d0                	call   *%rax
  801c04:	89 c3                	mov    %eax,%ebx
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 4e                	js     801c58 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801c0a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c0e:	48 b8 ef 28 80 00 00 	movabs $0x8028ef,%rax
  801c15:	00 00 00 
  801c18:	ff d0                	call   *%rax
  801c1a:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801c1d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c23:	4c 89 e9             	mov    %r13,%rcx
  801c26:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801c2f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c34:	48 b8 5e 14 80 00 00 	movabs $0x80145e,%rax
  801c3b:	00 00 00 
  801c3e:	ff d0                	call   *%rax
  801c40:	89 c3                	mov    %eax,%ebx
  801c42:	85 c0                	test   %eax,%eax
  801c44:	78 12                	js     801c58 <dup+0xf2>

    return newfdnum;
  801c46:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801c49:	89 d8                	mov    %ebx,%eax
  801c4b:	48 83 c4 10          	add    $0x10,%rsp
  801c4f:	5b                   	pop    %rbx
  801c50:	41 5c                	pop    %r12
  801c52:	41 5d                	pop    %r13
  801c54:	41 5e                	pop    %r14
  801c56:	5d                   	pop    %rbp
  801c57:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801c58:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c5d:	4c 89 ee             	mov    %r13,%rsi
  801c60:	bf 00 00 00 00       	mov    $0x0,%edi
  801c65:	49 bc c3 14 80 00 00 	movabs $0x8014c3,%r12
  801c6c:	00 00 00 
  801c6f:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801c72:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c77:	4c 89 f6             	mov    %r14,%rsi
  801c7a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c7f:	41 ff d4             	call   *%r12
    return res;
  801c82:	eb c5                	jmp    801c49 <dup+0xe3>

0000000000801c84 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801c84:	55                   	push   %rbp
  801c85:	48 89 e5             	mov    %rsp,%rbp
  801c88:	41 55                	push   %r13
  801c8a:	41 54                	push   %r12
  801c8c:	53                   	push   %rbx
  801c8d:	48 83 ec 18          	sub    $0x18,%rsp
  801c91:	89 fb                	mov    %edi,%ebx
  801c93:	49 89 f4             	mov    %rsi,%r12
  801c96:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c99:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c9d:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  801ca4:	00 00 00 
  801ca7:	ff d0                	call   *%rax
  801ca9:	85 c0                	test   %eax,%eax
  801cab:	78 49                	js     801cf6 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cad:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801cb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb5:	8b 38                	mov    (%rax),%edi
  801cb7:	48 b8 ec 19 80 00 00 	movabs $0x8019ec,%rax
  801cbe:	00 00 00 
  801cc1:	ff d0                	call   *%rax
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	78 33                	js     801cfa <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801cc7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801ccb:	8b 47 08             	mov    0x8(%rdi),%eax
  801cce:	83 e0 03             	and    $0x3,%eax
  801cd1:	83 f8 01             	cmp    $0x1,%eax
  801cd4:	74 28                	je     801cfe <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801cd6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cda:	48 8b 40 10          	mov    0x10(%rax),%rax
  801cde:	48 85 c0             	test   %rax,%rax
  801ce1:	74 51                	je     801d34 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801ce3:	4c 89 ea             	mov    %r13,%rdx
  801ce6:	4c 89 e6             	mov    %r12,%rsi
  801ce9:	ff d0                	call   *%rax
}
  801ceb:	48 83 c4 18          	add    $0x18,%rsp
  801cef:	5b                   	pop    %rbx
  801cf0:	41 5c                	pop    %r12
  801cf2:	41 5d                	pop    %r13
  801cf4:	5d                   	pop    %rbp
  801cf5:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cf6:	48 98                	cltq   
  801cf8:	eb f1                	jmp    801ceb <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cfa:	48 98                	cltq   
  801cfc:	eb ed                	jmp    801ceb <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801cfe:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801d05:	00 00 00 
  801d08:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d0e:	89 da                	mov    %ebx,%edx
  801d10:	48 bf 31 35 80 00 00 	movabs $0x803531,%rdi
  801d17:	00 00 00 
  801d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1f:	48 b9 fc 04 80 00 00 	movabs $0x8004fc,%rcx
  801d26:	00 00 00 
  801d29:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d2b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801d32:	eb b7                	jmp    801ceb <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801d34:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801d3b:	eb ae                	jmp    801ceb <read+0x67>

0000000000801d3d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801d3d:	55                   	push   %rbp
  801d3e:	48 89 e5             	mov    %rsp,%rbp
  801d41:	41 57                	push   %r15
  801d43:	41 56                	push   %r14
  801d45:	41 55                	push   %r13
  801d47:	41 54                	push   %r12
  801d49:	53                   	push   %rbx
  801d4a:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801d4e:	48 85 d2             	test   %rdx,%rdx
  801d51:	74 54                	je     801da7 <readn+0x6a>
  801d53:	41 89 fd             	mov    %edi,%r13d
  801d56:	49 89 f6             	mov    %rsi,%r14
  801d59:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801d5c:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801d61:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801d66:	49 bf 84 1c 80 00 00 	movabs $0x801c84,%r15
  801d6d:	00 00 00 
  801d70:	4c 89 e2             	mov    %r12,%rdx
  801d73:	48 29 f2             	sub    %rsi,%rdx
  801d76:	4c 01 f6             	add    %r14,%rsi
  801d79:	44 89 ef             	mov    %r13d,%edi
  801d7c:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	78 20                	js     801da3 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801d83:	01 c3                	add    %eax,%ebx
  801d85:	85 c0                	test   %eax,%eax
  801d87:	74 08                	je     801d91 <readn+0x54>
  801d89:	48 63 f3             	movslq %ebx,%rsi
  801d8c:	4c 39 e6             	cmp    %r12,%rsi
  801d8f:	72 df                	jb     801d70 <readn+0x33>
    }
    return res;
  801d91:	48 63 c3             	movslq %ebx,%rax
}
  801d94:	48 83 c4 08          	add    $0x8,%rsp
  801d98:	5b                   	pop    %rbx
  801d99:	41 5c                	pop    %r12
  801d9b:	41 5d                	pop    %r13
  801d9d:	41 5e                	pop    %r14
  801d9f:	41 5f                	pop    %r15
  801da1:	5d                   	pop    %rbp
  801da2:	c3                   	ret    
        if (inc < 0) return inc;
  801da3:	48 98                	cltq   
  801da5:	eb ed                	jmp    801d94 <readn+0x57>
    int inc = 1, res = 0;
  801da7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dac:	eb e3                	jmp    801d91 <readn+0x54>

0000000000801dae <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801dae:	55                   	push   %rbp
  801daf:	48 89 e5             	mov    %rsp,%rbp
  801db2:	41 55                	push   %r13
  801db4:	41 54                	push   %r12
  801db6:	53                   	push   %rbx
  801db7:	48 83 ec 18          	sub    $0x18,%rsp
  801dbb:	89 fb                	mov    %edi,%ebx
  801dbd:	49 89 f4             	mov    %rsi,%r12
  801dc0:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dc3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801dc7:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  801dce:	00 00 00 
  801dd1:	ff d0                	call   *%rax
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	78 44                	js     801e1b <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801dd7:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ddb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ddf:	8b 38                	mov    (%rax),%edi
  801de1:	48 b8 ec 19 80 00 00 	movabs $0x8019ec,%rax
  801de8:	00 00 00 
  801deb:	ff d0                	call   *%rax
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 2e                	js     801e1f <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801df1:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801df5:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801df9:	74 28                	je     801e23 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801dfb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dff:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e03:	48 85 c0             	test   %rax,%rax
  801e06:	74 51                	je     801e59 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801e08:	4c 89 ea             	mov    %r13,%rdx
  801e0b:	4c 89 e6             	mov    %r12,%rsi
  801e0e:	ff d0                	call   *%rax
}
  801e10:	48 83 c4 18          	add    $0x18,%rsp
  801e14:	5b                   	pop    %rbx
  801e15:	41 5c                	pop    %r12
  801e17:	41 5d                	pop    %r13
  801e19:	5d                   	pop    %rbp
  801e1a:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e1b:	48 98                	cltq   
  801e1d:	eb f1                	jmp    801e10 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e1f:	48 98                	cltq   
  801e21:	eb ed                	jmp    801e10 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801e23:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801e2a:	00 00 00 
  801e2d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e33:	89 da                	mov    %ebx,%edx
  801e35:	48 bf 4d 35 80 00 00 	movabs $0x80354d,%rdi
  801e3c:	00 00 00 
  801e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e44:	48 b9 fc 04 80 00 00 	movabs $0x8004fc,%rcx
  801e4b:	00 00 00 
  801e4e:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e50:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801e57:	eb b7                	jmp    801e10 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801e59:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801e60:	eb ae                	jmp    801e10 <write+0x62>

0000000000801e62 <seek>:

int
seek(int fdnum, off_t offset) {
  801e62:	55                   	push   %rbp
  801e63:	48 89 e5             	mov    %rsp,%rbp
  801e66:	53                   	push   %rbx
  801e67:	48 83 ec 18          	sub    $0x18,%rsp
  801e6b:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e6d:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e71:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  801e78:	00 00 00 
  801e7b:	ff d0                	call   *%rax
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	78 0c                	js     801e8d <seek+0x2b>

    fd->fd_offset = offset;
  801e81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e85:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801e88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

0000000000801e93 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801e93:	55                   	push   %rbp
  801e94:	48 89 e5             	mov    %rsp,%rbp
  801e97:	41 54                	push   %r12
  801e99:	53                   	push   %rbx
  801e9a:	48 83 ec 10          	sub    $0x10,%rsp
  801e9e:	89 fb                	mov    %edi,%ebx
  801ea0:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ea3:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ea7:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  801eae:	00 00 00 
  801eb1:	ff d0                	call   *%rax
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	78 36                	js     801eed <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801eb7:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801ebb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ebf:	8b 38                	mov    (%rax),%edi
  801ec1:	48 b8 ec 19 80 00 00 	movabs $0x8019ec,%rax
  801ec8:	00 00 00 
  801ecb:	ff d0                	call   *%rax
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	78 1c                	js     801eed <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ed1:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ed5:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801ed9:	74 1b                	je     801ef6 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801edb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801edf:	48 8b 40 30          	mov    0x30(%rax),%rax
  801ee3:	48 85 c0             	test   %rax,%rax
  801ee6:	74 42                	je     801f2a <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801ee8:	44 89 e6             	mov    %r12d,%esi
  801eeb:	ff d0                	call   *%rax
}
  801eed:	48 83 c4 10          	add    $0x10,%rsp
  801ef1:	5b                   	pop    %rbx
  801ef2:	41 5c                	pop    %r12
  801ef4:	5d                   	pop    %rbp
  801ef5:	c3                   	ret    
                thisenv->env_id, fdnum);
  801ef6:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801efd:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f00:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f06:	89 da                	mov    %ebx,%edx
  801f08:	48 bf 10 35 80 00 00 	movabs $0x803510,%rdi
  801f0f:	00 00 00 
  801f12:	b8 00 00 00 00       	mov    $0x0,%eax
  801f17:	48 b9 fc 04 80 00 00 	movabs $0x8004fc,%rcx
  801f1e:	00 00 00 
  801f21:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f28:	eb c3                	jmp    801eed <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f2a:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f2f:	eb bc                	jmp    801eed <ftruncate+0x5a>

0000000000801f31 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801f31:	55                   	push   %rbp
  801f32:	48 89 e5             	mov    %rsp,%rbp
  801f35:	53                   	push   %rbx
  801f36:	48 83 ec 18          	sub    $0x18,%rsp
  801f3a:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f3d:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f41:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  801f48:	00 00 00 
  801f4b:	ff d0                	call   *%rax
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	78 4d                	js     801f9e <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f51:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801f55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f59:	8b 38                	mov    (%rax),%edi
  801f5b:	48 b8 ec 19 80 00 00 	movabs $0x8019ec,%rax
  801f62:	00 00 00 
  801f65:	ff d0                	call   *%rax
  801f67:	85 c0                	test   %eax,%eax
  801f69:	78 33                	js     801f9e <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f6f:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801f74:	74 2e                	je     801fa4 <fstat+0x73>

    stat->st_name[0] = 0;
  801f76:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801f79:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801f80:	00 00 00 
    stat->st_isdir = 0;
  801f83:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801f8a:	00 00 00 
    stat->st_dev = dev;
  801f8d:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801f94:	48 89 de             	mov    %rbx,%rsi
  801f97:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f9b:	ff 50 28             	call   *0x28(%rax)
}
  801f9e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801fa4:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801fa9:	eb f3                	jmp    801f9e <fstat+0x6d>

0000000000801fab <stat>:

int
stat(const char *path, struct Stat *stat) {
  801fab:	55                   	push   %rbp
  801fac:	48 89 e5             	mov    %rsp,%rbp
  801faf:	41 54                	push   %r12
  801fb1:	53                   	push   %rbx
  801fb2:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801fb5:	be 00 00 00 00       	mov    $0x0,%esi
  801fba:	48 b8 76 22 80 00 00 	movabs $0x802276,%rax
  801fc1:	00 00 00 
  801fc4:	ff d0                	call   *%rax
  801fc6:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	78 25                	js     801ff1 <stat+0x46>

    int res = fstat(fd, stat);
  801fcc:	4c 89 e6             	mov    %r12,%rsi
  801fcf:	89 c7                	mov    %eax,%edi
  801fd1:	48 b8 31 1f 80 00 00 	movabs $0x801f31,%rax
  801fd8:	00 00 00 
  801fdb:	ff d0                	call   *%rax
  801fdd:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801fe0:	89 df                	mov    %ebx,%edi
  801fe2:	48 b8 0b 1b 80 00 00 	movabs $0x801b0b,%rax
  801fe9:	00 00 00 
  801fec:	ff d0                	call   *%rax

    return res;
  801fee:	44 89 e3             	mov    %r12d,%ebx
}
  801ff1:	89 d8                	mov    %ebx,%eax
  801ff3:	5b                   	pop    %rbx
  801ff4:	41 5c                	pop    %r12
  801ff6:	5d                   	pop    %rbp
  801ff7:	c3                   	ret    

0000000000801ff8 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801ff8:	55                   	push   %rbp
  801ff9:	48 89 e5             	mov    %rsp,%rbp
  801ffc:	41 54                	push   %r12
  801ffe:	53                   	push   %rbx
  801fff:	48 83 ec 10          	sub    $0x10,%rsp
  802003:	41 89 fc             	mov    %edi,%r12d
  802006:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802009:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802010:	00 00 00 
  802013:	83 38 00             	cmpl   $0x0,(%rax)
  802016:	74 5e                	je     802076 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802018:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  80201e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802023:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  80202a:	00 00 00 
  80202d:	44 89 e6             	mov    %r12d,%esi
  802030:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802037:	00 00 00 
  80203a:	8b 38                	mov    (%rax),%edi
  80203c:	48 b8 10 2d 80 00 00 	movabs $0x802d10,%rax
  802043:	00 00 00 
  802046:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802048:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  80204f:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802050:	b9 00 00 00 00       	mov    $0x0,%ecx
  802055:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802059:	48 89 de             	mov    %rbx,%rsi
  80205c:	bf 00 00 00 00       	mov    $0x0,%edi
  802061:	48 b8 71 2c 80 00 00 	movabs $0x802c71,%rax
  802068:	00 00 00 
  80206b:	ff d0                	call   *%rax
}
  80206d:	48 83 c4 10          	add    $0x10,%rsp
  802071:	5b                   	pop    %rbx
  802072:	41 5c                	pop    %r12
  802074:	5d                   	pop    %rbp
  802075:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802076:	bf 03 00 00 00       	mov    $0x3,%edi
  80207b:	48 b8 b3 2d 80 00 00 	movabs $0x802db3,%rax
  802082:	00 00 00 
  802085:	ff d0                	call   *%rax
  802087:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80208e:	00 00 
  802090:	eb 86                	jmp    802018 <fsipc+0x20>

0000000000802092 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802092:	55                   	push   %rbp
  802093:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802096:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80209d:	00 00 00 
  8020a0:	8b 57 0c             	mov    0xc(%rdi),%edx
  8020a3:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8020a5:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8020a8:	be 00 00 00 00       	mov    $0x0,%esi
  8020ad:	bf 02 00 00 00       	mov    $0x2,%edi
  8020b2:	48 b8 f8 1f 80 00 00 	movabs $0x801ff8,%rax
  8020b9:	00 00 00 
  8020bc:	ff d0                	call   *%rax
}
  8020be:	5d                   	pop    %rbp
  8020bf:	c3                   	ret    

00000000008020c0 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8020c0:	55                   	push   %rbp
  8020c1:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8020c4:	8b 47 0c             	mov    0xc(%rdi),%eax
  8020c7:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  8020ce:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  8020d0:	be 00 00 00 00       	mov    $0x0,%esi
  8020d5:	bf 06 00 00 00       	mov    $0x6,%edi
  8020da:	48 b8 f8 1f 80 00 00 	movabs $0x801ff8,%rax
  8020e1:	00 00 00 
  8020e4:	ff d0                	call   *%rax
}
  8020e6:	5d                   	pop    %rbp
  8020e7:	c3                   	ret    

00000000008020e8 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  8020e8:	55                   	push   %rbp
  8020e9:	48 89 e5             	mov    %rsp,%rbp
  8020ec:	53                   	push   %rbx
  8020ed:	48 83 ec 08          	sub    $0x8,%rsp
  8020f1:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8020f4:	8b 47 0c             	mov    0xc(%rdi),%eax
  8020f7:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  8020fe:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802100:	be 00 00 00 00       	mov    $0x0,%esi
  802105:	bf 05 00 00 00       	mov    $0x5,%edi
  80210a:	48 b8 f8 1f 80 00 00 	movabs $0x801ff8,%rax
  802111:	00 00 00 
  802114:	ff d0                	call   *%rax
    if (res < 0) return res;
  802116:	85 c0                	test   %eax,%eax
  802118:	78 40                	js     80215a <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80211a:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802121:	00 00 00 
  802124:	48 89 df             	mov    %rbx,%rdi
  802127:	48 b8 3d 0e 80 00 00 	movabs $0x800e3d,%rax
  80212e:	00 00 00 
  802131:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802133:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80213a:	00 00 00 
  80213d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802143:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802149:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80214f:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802155:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80215a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

0000000000802160 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802160:	55                   	push   %rbp
  802161:	48 89 e5             	mov    %rsp,%rbp
  802164:	41 57                	push   %r15
  802166:	41 56                	push   %r14
  802168:	41 55                	push   %r13
  80216a:	41 54                	push   %r12
  80216c:	53                   	push   %rbx
  80216d:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  802171:	48 85 d2             	test   %rdx,%rdx
  802174:	0f 84 91 00 00 00    	je     80220b <devfile_write+0xab>
  80217a:	49 89 ff             	mov    %rdi,%r15
  80217d:	49 89 f4             	mov    %rsi,%r12
  802180:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  802183:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80218a:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  802191:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802194:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  80219b:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  8021a1:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  8021a5:	4c 89 ea             	mov    %r13,%rdx
  8021a8:	4c 89 e6             	mov    %r12,%rsi
  8021ab:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  8021b2:	00 00 00 
  8021b5:	48 b8 9d 10 80 00 00 	movabs $0x80109d,%rax
  8021bc:	00 00 00 
  8021bf:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8021c1:	41 8b 47 0c          	mov    0xc(%r15),%eax
  8021c5:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  8021c8:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  8021cc:	be 00 00 00 00       	mov    $0x0,%esi
  8021d1:	bf 04 00 00 00       	mov    $0x4,%edi
  8021d6:	48 b8 f8 1f 80 00 00 	movabs $0x801ff8,%rax
  8021dd:	00 00 00 
  8021e0:	ff d0                	call   *%rax
        if (res < 0)
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	78 21                	js     802207 <devfile_write+0xa7>
        buf += res;
  8021e6:	48 63 d0             	movslq %eax,%rdx
  8021e9:	49 01 d4             	add    %rdx,%r12
        ext += res;
  8021ec:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  8021ef:	48 29 d3             	sub    %rdx,%rbx
  8021f2:	75 a0                	jne    802194 <devfile_write+0x34>
    return ext;
  8021f4:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  8021f8:	48 83 c4 18          	add    $0x18,%rsp
  8021fc:	5b                   	pop    %rbx
  8021fd:	41 5c                	pop    %r12
  8021ff:	41 5d                	pop    %r13
  802201:	41 5e                	pop    %r14
  802203:	41 5f                	pop    %r15
  802205:	5d                   	pop    %rbp
  802206:	c3                   	ret    
            return res;
  802207:	48 98                	cltq   
  802209:	eb ed                	jmp    8021f8 <devfile_write+0x98>
    int ext = 0;
  80220b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  802212:	eb e0                	jmp    8021f4 <devfile_write+0x94>

0000000000802214 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802214:	55                   	push   %rbp
  802215:	48 89 e5             	mov    %rsp,%rbp
  802218:	41 54                	push   %r12
  80221a:	53                   	push   %rbx
  80221b:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80221e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802225:	00 00 00 
  802228:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  80222b:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  80222d:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  802231:	be 00 00 00 00       	mov    $0x0,%esi
  802236:	bf 03 00 00 00       	mov    $0x3,%edi
  80223b:	48 b8 f8 1f 80 00 00 	movabs $0x801ff8,%rax
  802242:	00 00 00 
  802245:	ff d0                	call   *%rax
    if (read < 0) 
  802247:	85 c0                	test   %eax,%eax
  802249:	78 27                	js     802272 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  80224b:	48 63 d8             	movslq %eax,%rbx
  80224e:	48 89 da             	mov    %rbx,%rdx
  802251:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802258:	00 00 00 
  80225b:	4c 89 e7             	mov    %r12,%rdi
  80225e:	48 b8 38 10 80 00 00 	movabs $0x801038,%rax
  802265:	00 00 00 
  802268:	ff d0                	call   *%rax
    return read;
  80226a:	48 89 d8             	mov    %rbx,%rax
}
  80226d:	5b                   	pop    %rbx
  80226e:	41 5c                	pop    %r12
  802270:	5d                   	pop    %rbp
  802271:	c3                   	ret    
		return read;
  802272:	48 98                	cltq   
  802274:	eb f7                	jmp    80226d <devfile_read+0x59>

0000000000802276 <open>:
open(const char *path, int mode) {
  802276:	55                   	push   %rbp
  802277:	48 89 e5             	mov    %rsp,%rbp
  80227a:	41 55                	push   %r13
  80227c:	41 54                	push   %r12
  80227e:	53                   	push   %rbx
  80227f:	48 83 ec 18          	sub    $0x18,%rsp
  802283:	49 89 fc             	mov    %rdi,%r12
  802286:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802289:	48 b8 04 0e 80 00 00 	movabs $0x800e04,%rax
  802290:	00 00 00 
  802293:	ff d0                	call   *%rax
  802295:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80229b:	0f 87 8c 00 00 00    	ja     80232d <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8022a1:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8022a5:	48 b8 41 19 80 00 00 	movabs $0x801941,%rax
  8022ac:	00 00 00 
  8022af:	ff d0                	call   *%rax
  8022b1:	89 c3                	mov    %eax,%ebx
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	78 52                	js     802309 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  8022b7:	4c 89 e6             	mov    %r12,%rsi
  8022ba:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  8022c1:	00 00 00 
  8022c4:	48 b8 3d 0e 80 00 00 	movabs $0x800e3d,%rax
  8022cb:	00 00 00 
  8022ce:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8022d0:	44 89 e8             	mov    %r13d,%eax
  8022d3:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  8022da:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8022dc:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8022e0:	bf 01 00 00 00       	mov    $0x1,%edi
  8022e5:	48 b8 f8 1f 80 00 00 	movabs $0x801ff8,%rax
  8022ec:	00 00 00 
  8022ef:	ff d0                	call   *%rax
  8022f1:	89 c3                	mov    %eax,%ebx
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	78 1f                	js     802316 <open+0xa0>
    return fd2num(fd);
  8022f7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022fb:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  802302:	00 00 00 
  802305:	ff d0                	call   *%rax
  802307:	89 c3                	mov    %eax,%ebx
}
  802309:	89 d8                	mov    %ebx,%eax
  80230b:	48 83 c4 18          	add    $0x18,%rsp
  80230f:	5b                   	pop    %rbx
  802310:	41 5c                	pop    %r12
  802312:	41 5d                	pop    %r13
  802314:	5d                   	pop    %rbp
  802315:	c3                   	ret    
        fd_close(fd, 0);
  802316:	be 00 00 00 00       	mov    $0x0,%esi
  80231b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80231f:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  802326:	00 00 00 
  802329:	ff d0                	call   *%rax
        return res;
  80232b:	eb dc                	jmp    802309 <open+0x93>
        return -E_BAD_PATH;
  80232d:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802332:	eb d5                	jmp    802309 <open+0x93>

0000000000802334 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802334:	55                   	push   %rbp
  802335:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802338:	be 00 00 00 00       	mov    $0x0,%esi
  80233d:	bf 08 00 00 00       	mov    $0x8,%edi
  802342:	48 b8 f8 1f 80 00 00 	movabs $0x801ff8,%rax
  802349:	00 00 00 
  80234c:	ff d0                	call   *%rax
}
  80234e:	5d                   	pop    %rbp
  80234f:	c3                   	ret    

0000000000802350 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802350:	55                   	push   %rbp
  802351:	48 89 e5             	mov    %rsp,%rbp
  802354:	41 54                	push   %r12
  802356:	53                   	push   %rbx
  802357:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80235a:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  802361:	00 00 00 
  802364:	ff d0                	call   *%rax
  802366:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802369:	48 be a0 35 80 00 00 	movabs $0x8035a0,%rsi
  802370:	00 00 00 
  802373:	48 89 df             	mov    %rbx,%rdi
  802376:	48 b8 3d 0e 80 00 00 	movabs $0x800e3d,%rax
  80237d:	00 00 00 
  802380:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802382:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802387:	41 2b 04 24          	sub    (%r12),%eax
  80238b:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802391:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802398:	00 00 00 
    stat->st_dev = &devpipe;
  80239b:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8023a2:	00 00 00 
  8023a5:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8023ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b1:	5b                   	pop    %rbx
  8023b2:	41 5c                	pop    %r12
  8023b4:	5d                   	pop    %rbp
  8023b5:	c3                   	ret    

00000000008023b6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8023b6:	55                   	push   %rbp
  8023b7:	48 89 e5             	mov    %rsp,%rbp
  8023ba:	41 54                	push   %r12
  8023bc:	53                   	push   %rbx
  8023bd:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8023c0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023c5:	48 89 fe             	mov    %rdi,%rsi
  8023c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8023cd:	49 bc c3 14 80 00 00 	movabs $0x8014c3,%r12
  8023d4:	00 00 00 
  8023d7:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8023da:	48 89 df             	mov    %rbx,%rdi
  8023dd:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  8023e4:	00 00 00 
  8023e7:	ff d0                	call   *%rax
  8023e9:	48 89 c6             	mov    %rax,%rsi
  8023ec:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f6:	41 ff d4             	call   *%r12
}
  8023f9:	5b                   	pop    %rbx
  8023fa:	41 5c                	pop    %r12
  8023fc:	5d                   	pop    %rbp
  8023fd:	c3                   	ret    

00000000008023fe <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8023fe:	55                   	push   %rbp
  8023ff:	48 89 e5             	mov    %rsp,%rbp
  802402:	41 57                	push   %r15
  802404:	41 56                	push   %r14
  802406:	41 55                	push   %r13
  802408:	41 54                	push   %r12
  80240a:	53                   	push   %rbx
  80240b:	48 83 ec 18          	sub    $0x18,%rsp
  80240f:	49 89 fc             	mov    %rdi,%r12
  802412:	49 89 f5             	mov    %rsi,%r13
  802415:	49 89 d7             	mov    %rdx,%r15
  802418:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80241c:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  802423:	00 00 00 
  802426:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802428:	4d 85 ff             	test   %r15,%r15
  80242b:	0f 84 ac 00 00 00    	je     8024dd <devpipe_write+0xdf>
  802431:	48 89 c3             	mov    %rax,%rbx
  802434:	4c 89 f8             	mov    %r15,%rax
  802437:	4d 89 ef             	mov    %r13,%r15
  80243a:	49 01 c5             	add    %rax,%r13
  80243d:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802441:	49 bd cb 13 80 00 00 	movabs $0x8013cb,%r13
  802448:	00 00 00 
            sys_yield();
  80244b:	49 be 68 13 80 00 00 	movabs $0x801368,%r14
  802452:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802455:	8b 73 04             	mov    0x4(%rbx),%esi
  802458:	48 63 ce             	movslq %esi,%rcx
  80245b:	48 63 03             	movslq (%rbx),%rax
  80245e:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802464:	48 39 c1             	cmp    %rax,%rcx
  802467:	72 2e                	jb     802497 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802469:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80246e:	48 89 da             	mov    %rbx,%rdx
  802471:	be 00 10 00 00       	mov    $0x1000,%esi
  802476:	4c 89 e7             	mov    %r12,%rdi
  802479:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80247c:	85 c0                	test   %eax,%eax
  80247e:	74 63                	je     8024e3 <devpipe_write+0xe5>
            sys_yield();
  802480:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802483:	8b 73 04             	mov    0x4(%rbx),%esi
  802486:	48 63 ce             	movslq %esi,%rcx
  802489:	48 63 03             	movslq (%rbx),%rax
  80248c:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802492:	48 39 c1             	cmp    %rax,%rcx
  802495:	73 d2                	jae    802469 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802497:	41 0f b6 3f          	movzbl (%r15),%edi
  80249b:	48 89 ca             	mov    %rcx,%rdx
  80249e:	48 c1 ea 03          	shr    $0x3,%rdx
  8024a2:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8024a9:	08 10 20 
  8024ac:	48 f7 e2             	mul    %rdx
  8024af:	48 c1 ea 06          	shr    $0x6,%rdx
  8024b3:	48 89 d0             	mov    %rdx,%rax
  8024b6:	48 c1 e0 09          	shl    $0x9,%rax
  8024ba:	48 29 d0             	sub    %rdx,%rax
  8024bd:	48 c1 e0 03          	shl    $0x3,%rax
  8024c1:	48 29 c1             	sub    %rax,%rcx
  8024c4:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8024c9:	83 c6 01             	add    $0x1,%esi
  8024cc:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8024cf:	49 83 c7 01          	add    $0x1,%r15
  8024d3:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8024d7:	0f 85 78 ff ff ff    	jne    802455 <devpipe_write+0x57>
    return n;
  8024dd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8024e1:	eb 05                	jmp    8024e8 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8024e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e8:	48 83 c4 18          	add    $0x18,%rsp
  8024ec:	5b                   	pop    %rbx
  8024ed:	41 5c                	pop    %r12
  8024ef:	41 5d                	pop    %r13
  8024f1:	41 5e                	pop    %r14
  8024f3:	41 5f                	pop    %r15
  8024f5:	5d                   	pop    %rbp
  8024f6:	c3                   	ret    

00000000008024f7 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8024f7:	55                   	push   %rbp
  8024f8:	48 89 e5             	mov    %rsp,%rbp
  8024fb:	41 57                	push   %r15
  8024fd:	41 56                	push   %r14
  8024ff:	41 55                	push   %r13
  802501:	41 54                	push   %r12
  802503:	53                   	push   %rbx
  802504:	48 83 ec 18          	sub    $0x18,%rsp
  802508:	49 89 fc             	mov    %rdi,%r12
  80250b:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80250f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802513:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  80251a:	00 00 00 
  80251d:	ff d0                	call   *%rax
  80251f:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802522:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802528:	49 bd cb 13 80 00 00 	movabs $0x8013cb,%r13
  80252f:	00 00 00 
            sys_yield();
  802532:	49 be 68 13 80 00 00 	movabs $0x801368,%r14
  802539:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80253c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802541:	74 7a                	je     8025bd <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802543:	8b 03                	mov    (%rbx),%eax
  802545:	3b 43 04             	cmp    0x4(%rbx),%eax
  802548:	75 26                	jne    802570 <devpipe_read+0x79>
            if (i > 0) return i;
  80254a:	4d 85 ff             	test   %r15,%r15
  80254d:	75 74                	jne    8025c3 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80254f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802554:	48 89 da             	mov    %rbx,%rdx
  802557:	be 00 10 00 00       	mov    $0x1000,%esi
  80255c:	4c 89 e7             	mov    %r12,%rdi
  80255f:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802562:	85 c0                	test   %eax,%eax
  802564:	74 6f                	je     8025d5 <devpipe_read+0xde>
            sys_yield();
  802566:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802569:	8b 03                	mov    (%rbx),%eax
  80256b:	3b 43 04             	cmp    0x4(%rbx),%eax
  80256e:	74 df                	je     80254f <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802570:	48 63 c8             	movslq %eax,%rcx
  802573:	48 89 ca             	mov    %rcx,%rdx
  802576:	48 c1 ea 03          	shr    $0x3,%rdx
  80257a:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802581:	08 10 20 
  802584:	48 f7 e2             	mul    %rdx
  802587:	48 c1 ea 06          	shr    $0x6,%rdx
  80258b:	48 89 d0             	mov    %rdx,%rax
  80258e:	48 c1 e0 09          	shl    $0x9,%rax
  802592:	48 29 d0             	sub    %rdx,%rax
  802595:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80259c:	00 
  80259d:	48 89 c8             	mov    %rcx,%rax
  8025a0:	48 29 d0             	sub    %rdx,%rax
  8025a3:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8025a8:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8025ac:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8025b0:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8025b3:	49 83 c7 01          	add    $0x1,%r15
  8025b7:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8025bb:	75 86                	jne    802543 <devpipe_read+0x4c>
    return n;
  8025bd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8025c1:	eb 03                	jmp    8025c6 <devpipe_read+0xcf>
            if (i > 0) return i;
  8025c3:	4c 89 f8             	mov    %r15,%rax
}
  8025c6:	48 83 c4 18          	add    $0x18,%rsp
  8025ca:	5b                   	pop    %rbx
  8025cb:	41 5c                	pop    %r12
  8025cd:	41 5d                	pop    %r13
  8025cf:	41 5e                	pop    %r14
  8025d1:	41 5f                	pop    %r15
  8025d3:	5d                   	pop    %rbp
  8025d4:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8025d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025da:	eb ea                	jmp    8025c6 <devpipe_read+0xcf>

00000000008025dc <pipe>:
pipe(int pfd[2]) {
  8025dc:	55                   	push   %rbp
  8025dd:	48 89 e5             	mov    %rsp,%rbp
  8025e0:	41 55                	push   %r13
  8025e2:	41 54                	push   %r12
  8025e4:	53                   	push   %rbx
  8025e5:	48 83 ec 18          	sub    $0x18,%rsp
  8025e9:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8025ec:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8025f0:	48 b8 41 19 80 00 00 	movabs $0x801941,%rax
  8025f7:	00 00 00 
  8025fa:	ff d0                	call   *%rax
  8025fc:	89 c3                	mov    %eax,%ebx
  8025fe:	85 c0                	test   %eax,%eax
  802600:	0f 88 a0 01 00 00    	js     8027a6 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802606:	b9 46 00 00 00       	mov    $0x46,%ecx
  80260b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802610:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802614:	bf 00 00 00 00       	mov    $0x0,%edi
  802619:	48 b8 f7 13 80 00 00 	movabs $0x8013f7,%rax
  802620:	00 00 00 
  802623:	ff d0                	call   *%rax
  802625:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802627:	85 c0                	test   %eax,%eax
  802629:	0f 88 77 01 00 00    	js     8027a6 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80262f:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802633:	48 b8 41 19 80 00 00 	movabs $0x801941,%rax
  80263a:	00 00 00 
  80263d:	ff d0                	call   *%rax
  80263f:	89 c3                	mov    %eax,%ebx
  802641:	85 c0                	test   %eax,%eax
  802643:	0f 88 43 01 00 00    	js     80278c <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802649:	b9 46 00 00 00       	mov    $0x46,%ecx
  80264e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802653:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802657:	bf 00 00 00 00       	mov    $0x0,%edi
  80265c:	48 b8 f7 13 80 00 00 	movabs $0x8013f7,%rax
  802663:	00 00 00 
  802666:	ff d0                	call   *%rax
  802668:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80266a:	85 c0                	test   %eax,%eax
  80266c:	0f 88 1a 01 00 00    	js     80278c <pipe+0x1b0>
    va = fd2data(fd0);
  802672:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802676:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  80267d:	00 00 00 
  802680:	ff d0                	call   *%rax
  802682:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802685:	b9 46 00 00 00       	mov    $0x46,%ecx
  80268a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80268f:	48 89 c6             	mov    %rax,%rsi
  802692:	bf 00 00 00 00       	mov    $0x0,%edi
  802697:	48 b8 f7 13 80 00 00 	movabs $0x8013f7,%rax
  80269e:	00 00 00 
  8026a1:	ff d0                	call   *%rax
  8026a3:	89 c3                	mov    %eax,%ebx
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	0f 88 c5 00 00 00    	js     802772 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8026ad:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8026b1:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  8026b8:	00 00 00 
  8026bb:	ff d0                	call   *%rax
  8026bd:	48 89 c1             	mov    %rax,%rcx
  8026c0:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8026c6:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8026cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d1:	4c 89 ee             	mov    %r13,%rsi
  8026d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d9:	48 b8 5e 14 80 00 00 	movabs $0x80145e,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	call   *%rax
  8026e5:	89 c3                	mov    %eax,%ebx
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	78 6e                	js     802759 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8026eb:	be 00 10 00 00       	mov    $0x1000,%esi
  8026f0:	4c 89 ef             	mov    %r13,%rdi
  8026f3:	48 b8 99 13 80 00 00 	movabs $0x801399,%rax
  8026fa:	00 00 00 
  8026fd:	ff d0                	call   *%rax
  8026ff:	83 f8 02             	cmp    $0x2,%eax
  802702:	0f 85 ab 00 00 00    	jne    8027b3 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802708:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80270f:	00 00 
  802711:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802715:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802717:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80271b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802722:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802726:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802728:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80272c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802733:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802737:	48 bb 13 19 80 00 00 	movabs $0x801913,%rbx
  80273e:	00 00 00 
  802741:	ff d3                	call   *%rbx
  802743:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802747:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80274b:	ff d3                	call   *%rbx
  80274d:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802752:	bb 00 00 00 00       	mov    $0x0,%ebx
  802757:	eb 4d                	jmp    8027a6 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802759:	ba 00 10 00 00       	mov    $0x1000,%edx
  80275e:	4c 89 ee             	mov    %r13,%rsi
  802761:	bf 00 00 00 00       	mov    $0x0,%edi
  802766:	48 b8 c3 14 80 00 00 	movabs $0x8014c3,%rax
  80276d:	00 00 00 
  802770:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802772:	ba 00 10 00 00       	mov    $0x1000,%edx
  802777:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80277b:	bf 00 00 00 00       	mov    $0x0,%edi
  802780:	48 b8 c3 14 80 00 00 	movabs $0x8014c3,%rax
  802787:	00 00 00 
  80278a:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80278c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802791:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802795:	bf 00 00 00 00       	mov    $0x0,%edi
  80279a:	48 b8 c3 14 80 00 00 	movabs $0x8014c3,%rax
  8027a1:	00 00 00 
  8027a4:	ff d0                	call   *%rax
}
  8027a6:	89 d8                	mov    %ebx,%eax
  8027a8:	48 83 c4 18          	add    $0x18,%rsp
  8027ac:	5b                   	pop    %rbx
  8027ad:	41 5c                	pop    %r12
  8027af:	41 5d                	pop    %r13
  8027b1:	5d                   	pop    %rbp
  8027b2:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8027b3:	48 b9 d0 35 80 00 00 	movabs $0x8035d0,%rcx
  8027ba:	00 00 00 
  8027bd:	48 ba a7 35 80 00 00 	movabs $0x8035a7,%rdx
  8027c4:	00 00 00 
  8027c7:	be 2e 00 00 00       	mov    $0x2e,%esi
  8027cc:	48 bf bc 35 80 00 00 	movabs $0x8035bc,%rdi
  8027d3:	00 00 00 
  8027d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027db:	49 b8 ac 03 80 00 00 	movabs $0x8003ac,%r8
  8027e2:	00 00 00 
  8027e5:	41 ff d0             	call   *%r8

00000000008027e8 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8027e8:	55                   	push   %rbp
  8027e9:	48 89 e5             	mov    %rsp,%rbp
  8027ec:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8027f0:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8027f4:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  8027fb:	00 00 00 
  8027fe:	ff d0                	call   *%rax
    if (res < 0) return res;
  802800:	85 c0                	test   %eax,%eax
  802802:	78 35                	js     802839 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802804:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802808:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  80280f:	00 00 00 
  802812:	ff d0                	call   *%rax
  802814:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802817:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80281c:	be 00 10 00 00       	mov    $0x1000,%esi
  802821:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802825:	48 b8 cb 13 80 00 00 	movabs $0x8013cb,%rax
  80282c:	00 00 00 
  80282f:	ff d0                	call   *%rax
  802831:	85 c0                	test   %eax,%eax
  802833:	0f 94 c0             	sete   %al
  802836:	0f b6 c0             	movzbl %al,%eax
}
  802839:	c9                   	leave  
  80283a:	c3                   	ret    

000000000080283b <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80283b:	48 89 f8             	mov    %rdi,%rax
  80283e:	48 c1 e8 27          	shr    $0x27,%rax
  802842:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802849:	01 00 00 
  80284c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802850:	f6 c2 01             	test   $0x1,%dl
  802853:	74 6d                	je     8028c2 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802855:	48 89 f8             	mov    %rdi,%rax
  802858:	48 c1 e8 1e          	shr    $0x1e,%rax
  80285c:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802863:	01 00 00 
  802866:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80286a:	f6 c2 01             	test   $0x1,%dl
  80286d:	74 62                	je     8028d1 <get_uvpt_entry+0x96>
  80286f:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802876:	01 00 00 
  802879:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80287d:	f6 c2 80             	test   $0x80,%dl
  802880:	75 4f                	jne    8028d1 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802882:	48 89 f8             	mov    %rdi,%rax
  802885:	48 c1 e8 15          	shr    $0x15,%rax
  802889:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802890:	01 00 00 
  802893:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802897:	f6 c2 01             	test   $0x1,%dl
  80289a:	74 44                	je     8028e0 <get_uvpt_entry+0xa5>
  80289c:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8028a3:	01 00 00 
  8028a6:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028aa:	f6 c2 80             	test   $0x80,%dl
  8028ad:	75 31                	jne    8028e0 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8028af:	48 c1 ef 0c          	shr    $0xc,%rdi
  8028b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028ba:	01 00 00 
  8028bd:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8028c1:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8028c2:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8028c9:	01 00 00 
  8028cc:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8028d0:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8028d1:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8028d8:	01 00 00 
  8028db:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8028df:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8028e0:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8028e7:	01 00 00 
  8028ea:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8028ee:	c3                   	ret    

00000000008028ef <get_prot>:

int
get_prot(void *va) {
  8028ef:	55                   	push   %rbp
  8028f0:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8028f3:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  8028fa:	00 00 00 
  8028fd:	ff d0                	call   *%rax
  8028ff:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802902:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802907:	89 c1                	mov    %eax,%ecx
  802909:	83 c9 04             	or     $0x4,%ecx
  80290c:	f6 c2 01             	test   $0x1,%dl
  80290f:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802912:	89 c1                	mov    %eax,%ecx
  802914:	83 c9 02             	or     $0x2,%ecx
  802917:	f6 c2 02             	test   $0x2,%dl
  80291a:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80291d:	89 c1                	mov    %eax,%ecx
  80291f:	83 c9 01             	or     $0x1,%ecx
  802922:	48 85 d2             	test   %rdx,%rdx
  802925:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802928:	89 c1                	mov    %eax,%ecx
  80292a:	83 c9 40             	or     $0x40,%ecx
  80292d:	f6 c6 04             	test   $0x4,%dh
  802930:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802933:	5d                   	pop    %rbp
  802934:	c3                   	ret    

0000000000802935 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802935:	55                   	push   %rbp
  802936:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802939:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  802940:	00 00 00 
  802943:	ff d0                	call   *%rax
    return pte & PTE_D;
  802945:	48 c1 e8 06          	shr    $0x6,%rax
  802949:	83 e0 01             	and    $0x1,%eax
}
  80294c:	5d                   	pop    %rbp
  80294d:	c3                   	ret    

000000000080294e <is_page_present>:

bool
is_page_present(void *va) {
  80294e:	55                   	push   %rbp
  80294f:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802952:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  802959:	00 00 00 
  80295c:	ff d0                	call   *%rax
  80295e:	83 e0 01             	and    $0x1,%eax
}
  802961:	5d                   	pop    %rbp
  802962:	c3                   	ret    

0000000000802963 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802963:	55                   	push   %rbp
  802964:	48 89 e5             	mov    %rsp,%rbp
  802967:	41 57                	push   %r15
  802969:	41 56                	push   %r14
  80296b:	41 55                	push   %r13
  80296d:	41 54                	push   %r12
  80296f:	53                   	push   %rbx
  802970:	48 83 ec 28          	sub    $0x28,%rsp
  802974:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802978:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  80297c:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802981:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802988:	01 00 00 
  80298b:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802992:	01 00 00 
  802995:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  80299c:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80299f:	49 bf ef 28 80 00 00 	movabs $0x8028ef,%r15
  8029a6:	00 00 00 
  8029a9:	eb 16                	jmp    8029c1 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8029ab:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8029b2:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8029b9:	00 00 00 
  8029bc:	48 39 c3             	cmp    %rax,%rbx
  8029bf:	77 73                	ja     802a34 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8029c1:	48 89 d8             	mov    %rbx,%rax
  8029c4:	48 c1 e8 27          	shr    $0x27,%rax
  8029c8:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8029cc:	a8 01                	test   $0x1,%al
  8029ce:	74 db                	je     8029ab <foreach_shared_region+0x48>
  8029d0:	48 89 d8             	mov    %rbx,%rax
  8029d3:	48 c1 e8 1e          	shr    $0x1e,%rax
  8029d7:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8029dc:	a8 01                	test   $0x1,%al
  8029de:	74 cb                	je     8029ab <foreach_shared_region+0x48>
  8029e0:	48 89 d8             	mov    %rbx,%rax
  8029e3:	48 c1 e8 15          	shr    $0x15,%rax
  8029e7:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8029eb:	a8 01                	test   $0x1,%al
  8029ed:	74 bc                	je     8029ab <foreach_shared_region+0x48>
        void *start = (void*)i;
  8029ef:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8029f3:	48 89 df             	mov    %rbx,%rdi
  8029f6:	41 ff d7             	call   *%r15
  8029f9:	a8 40                	test   $0x40,%al
  8029fb:	75 09                	jne    802a06 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8029fd:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802a04:	eb ac                	jmp    8029b2 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802a06:	48 89 df             	mov    %rbx,%rdi
  802a09:	48 b8 4e 29 80 00 00 	movabs $0x80294e,%rax
  802a10:	00 00 00 
  802a13:	ff d0                	call   *%rax
  802a15:	84 c0                	test   %al,%al
  802a17:	74 e4                	je     8029fd <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802a19:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802a20:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802a24:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802a28:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802a2c:	ff d0                	call   *%rax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	79 cb                	jns    8029fd <foreach_shared_region+0x9a>
  802a32:	eb 05                	jmp    802a39 <foreach_shared_region+0xd6>
    }
    return 0;
  802a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a39:	48 83 c4 28          	add    $0x28,%rsp
  802a3d:	5b                   	pop    %rbx
  802a3e:	41 5c                	pop    %r12
  802a40:	41 5d                	pop    %r13
  802a42:	41 5e                	pop    %r14
  802a44:	41 5f                	pop    %r15
  802a46:	5d                   	pop    %rbp
  802a47:	c3                   	ret    

0000000000802a48 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802a48:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4d:	c3                   	ret    

0000000000802a4e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802a4e:	55                   	push   %rbp
  802a4f:	48 89 e5             	mov    %rsp,%rbp
  802a52:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802a55:	48 be f4 35 80 00 00 	movabs $0x8035f4,%rsi
  802a5c:	00 00 00 
  802a5f:	48 b8 3d 0e 80 00 00 	movabs $0x800e3d,%rax
  802a66:	00 00 00 
  802a69:	ff d0                	call   *%rax
    return 0;
}
  802a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a70:	5d                   	pop    %rbp
  802a71:	c3                   	ret    

0000000000802a72 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802a72:	55                   	push   %rbp
  802a73:	48 89 e5             	mov    %rsp,%rbp
  802a76:	41 57                	push   %r15
  802a78:	41 56                	push   %r14
  802a7a:	41 55                	push   %r13
  802a7c:	41 54                	push   %r12
  802a7e:	53                   	push   %rbx
  802a7f:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802a86:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802a8d:	48 85 d2             	test   %rdx,%rdx
  802a90:	74 78                	je     802b0a <devcons_write+0x98>
  802a92:	49 89 d6             	mov    %rdx,%r14
  802a95:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802a9b:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802aa0:	49 bf 38 10 80 00 00 	movabs $0x801038,%r15
  802aa7:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802aaa:	4c 89 f3             	mov    %r14,%rbx
  802aad:	48 29 f3             	sub    %rsi,%rbx
  802ab0:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802ab4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802ab9:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802abd:	4c 63 eb             	movslq %ebx,%r13
  802ac0:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802ac7:	4c 89 ea             	mov    %r13,%rdx
  802aca:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802ad1:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802ad4:	4c 89 ee             	mov    %r13,%rsi
  802ad7:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802ade:	48 b8 6e 12 80 00 00 	movabs $0x80126e,%rax
  802ae5:	00 00 00 
  802ae8:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802aea:	41 01 dc             	add    %ebx,%r12d
  802aed:	49 63 f4             	movslq %r12d,%rsi
  802af0:	4c 39 f6             	cmp    %r14,%rsi
  802af3:	72 b5                	jb     802aaa <devcons_write+0x38>
    return res;
  802af5:	49 63 c4             	movslq %r12d,%rax
}
  802af8:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802aff:	5b                   	pop    %rbx
  802b00:	41 5c                	pop    %r12
  802b02:	41 5d                	pop    %r13
  802b04:	41 5e                	pop    %r14
  802b06:	41 5f                	pop    %r15
  802b08:	5d                   	pop    %rbp
  802b09:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802b0a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802b10:	eb e3                	jmp    802af5 <devcons_write+0x83>

0000000000802b12 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802b12:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802b15:	ba 00 00 00 00       	mov    $0x0,%edx
  802b1a:	48 85 c0             	test   %rax,%rax
  802b1d:	74 55                	je     802b74 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802b1f:	55                   	push   %rbp
  802b20:	48 89 e5             	mov    %rsp,%rbp
  802b23:	41 55                	push   %r13
  802b25:	41 54                	push   %r12
  802b27:	53                   	push   %rbx
  802b28:	48 83 ec 08          	sub    $0x8,%rsp
  802b2c:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802b2f:	48 bb 9b 12 80 00 00 	movabs $0x80129b,%rbx
  802b36:	00 00 00 
  802b39:	49 bc 68 13 80 00 00 	movabs $0x801368,%r12
  802b40:	00 00 00 
  802b43:	eb 03                	jmp    802b48 <devcons_read+0x36>
  802b45:	41 ff d4             	call   *%r12
  802b48:	ff d3                	call   *%rbx
  802b4a:	85 c0                	test   %eax,%eax
  802b4c:	74 f7                	je     802b45 <devcons_read+0x33>
    if (c < 0) return c;
  802b4e:	48 63 d0             	movslq %eax,%rdx
  802b51:	78 13                	js     802b66 <devcons_read+0x54>
    if (c == 0x04) return 0;
  802b53:	ba 00 00 00 00       	mov    $0x0,%edx
  802b58:	83 f8 04             	cmp    $0x4,%eax
  802b5b:	74 09                	je     802b66 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802b5d:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802b61:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802b66:	48 89 d0             	mov    %rdx,%rax
  802b69:	48 83 c4 08          	add    $0x8,%rsp
  802b6d:	5b                   	pop    %rbx
  802b6e:	41 5c                	pop    %r12
  802b70:	41 5d                	pop    %r13
  802b72:	5d                   	pop    %rbp
  802b73:	c3                   	ret    
  802b74:	48 89 d0             	mov    %rdx,%rax
  802b77:	c3                   	ret    

0000000000802b78 <cputchar>:
cputchar(int ch) {
  802b78:	55                   	push   %rbp
  802b79:	48 89 e5             	mov    %rsp,%rbp
  802b7c:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802b80:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802b84:	be 01 00 00 00       	mov    $0x1,%esi
  802b89:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802b8d:	48 b8 6e 12 80 00 00 	movabs $0x80126e,%rax
  802b94:	00 00 00 
  802b97:	ff d0                	call   *%rax
}
  802b99:	c9                   	leave  
  802b9a:	c3                   	ret    

0000000000802b9b <getchar>:
getchar(void) {
  802b9b:	55                   	push   %rbp
  802b9c:	48 89 e5             	mov    %rsp,%rbp
  802b9f:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802ba3:	ba 01 00 00 00       	mov    $0x1,%edx
  802ba8:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802bac:	bf 00 00 00 00       	mov    $0x0,%edi
  802bb1:	48 b8 84 1c 80 00 00 	movabs $0x801c84,%rax
  802bb8:	00 00 00 
  802bbb:	ff d0                	call   *%rax
  802bbd:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	78 06                	js     802bc9 <getchar+0x2e>
  802bc3:	74 08                	je     802bcd <getchar+0x32>
  802bc5:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802bc9:	89 d0                	mov    %edx,%eax
  802bcb:	c9                   	leave  
  802bcc:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802bcd:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802bd2:	eb f5                	jmp    802bc9 <getchar+0x2e>

0000000000802bd4 <iscons>:
iscons(int fdnum) {
  802bd4:	55                   	push   %rbp
  802bd5:	48 89 e5             	mov    %rsp,%rbp
  802bd8:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802bdc:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802be0:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  802be7:	00 00 00 
  802bea:	ff d0                	call   *%rax
    if (res < 0) return res;
  802bec:	85 c0                	test   %eax,%eax
  802bee:	78 18                	js     802c08 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802bf0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bf4:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802bfb:	00 00 00 
  802bfe:	8b 00                	mov    (%rax),%eax
  802c00:	39 02                	cmp    %eax,(%rdx)
  802c02:	0f 94 c0             	sete   %al
  802c05:	0f b6 c0             	movzbl %al,%eax
}
  802c08:	c9                   	leave  
  802c09:	c3                   	ret    

0000000000802c0a <opencons>:
opencons(void) {
  802c0a:	55                   	push   %rbp
  802c0b:	48 89 e5             	mov    %rsp,%rbp
  802c0e:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802c12:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802c16:	48 b8 41 19 80 00 00 	movabs $0x801941,%rax
  802c1d:	00 00 00 
  802c20:	ff d0                	call   *%rax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	78 49                	js     802c6f <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802c26:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c2b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c30:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802c34:	bf 00 00 00 00       	mov    $0x0,%edi
  802c39:	48 b8 f7 13 80 00 00 	movabs $0x8013f7,%rax
  802c40:	00 00 00 
  802c43:	ff d0                	call   *%rax
  802c45:	85 c0                	test   %eax,%eax
  802c47:	78 26                	js     802c6f <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802c49:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c4d:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802c54:	00 00 
  802c56:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802c58:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802c5c:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802c63:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  802c6a:	00 00 00 
  802c6d:	ff d0                	call   *%rax
}
  802c6f:	c9                   	leave  
  802c70:	c3                   	ret    

0000000000802c71 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802c71:	55                   	push   %rbp
  802c72:	48 89 e5             	mov    %rsp,%rbp
  802c75:	41 54                	push   %r12
  802c77:	53                   	push   %rbx
  802c78:	48 89 fb             	mov    %rdi,%rbx
  802c7b:	48 89 f7             	mov    %rsi,%rdi
  802c7e:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802c81:	48 85 f6             	test   %rsi,%rsi
  802c84:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802c8b:	00 00 00 
  802c8e:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802c92:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802c97:	48 85 d2             	test   %rdx,%rdx
  802c9a:	74 02                	je     802c9e <ipc_recv+0x2d>
  802c9c:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802c9e:	48 63 f6             	movslq %esi,%rsi
  802ca1:	48 b8 91 16 80 00 00 	movabs $0x801691,%rax
  802ca8:	00 00 00 
  802cab:	ff d0                	call   *%rax

    if (res < 0) {
  802cad:	85 c0                	test   %eax,%eax
  802caf:	78 45                	js     802cf6 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802cb1:	48 85 db             	test   %rbx,%rbx
  802cb4:	74 12                	je     802cc8 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802cb6:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802cbd:	00 00 00 
  802cc0:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802cc6:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802cc8:	4d 85 e4             	test   %r12,%r12
  802ccb:	74 14                	je     802ce1 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802ccd:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802cd4:	00 00 00 
  802cd7:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802cdd:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802ce1:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802ce8:	00 00 00 
  802ceb:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802cf1:	5b                   	pop    %rbx
  802cf2:	41 5c                	pop    %r12
  802cf4:	5d                   	pop    %rbp
  802cf5:	c3                   	ret    
        if (from_env_store)
  802cf6:	48 85 db             	test   %rbx,%rbx
  802cf9:	74 06                	je     802d01 <ipc_recv+0x90>
            *from_env_store = 0;
  802cfb:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802d01:	4d 85 e4             	test   %r12,%r12
  802d04:	74 eb                	je     802cf1 <ipc_recv+0x80>
            *perm_store = 0;
  802d06:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802d0d:	00 
  802d0e:	eb e1                	jmp    802cf1 <ipc_recv+0x80>

0000000000802d10 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802d10:	55                   	push   %rbp
  802d11:	48 89 e5             	mov    %rsp,%rbp
  802d14:	41 57                	push   %r15
  802d16:	41 56                	push   %r14
  802d18:	41 55                	push   %r13
  802d1a:	41 54                	push   %r12
  802d1c:	53                   	push   %rbx
  802d1d:	48 83 ec 18          	sub    $0x18,%rsp
  802d21:	41 89 fd             	mov    %edi,%r13d
  802d24:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802d27:	48 89 d3             	mov    %rdx,%rbx
  802d2a:	49 89 cc             	mov    %rcx,%r12
  802d2d:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802d31:	48 85 d2             	test   %rdx,%rdx
  802d34:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802d3b:	00 00 00 
  802d3e:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802d42:	49 be 65 16 80 00 00 	movabs $0x801665,%r14
  802d49:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802d4c:	49 bf 68 13 80 00 00 	movabs $0x801368,%r15
  802d53:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802d56:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802d59:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802d5d:	4c 89 e1             	mov    %r12,%rcx
  802d60:	48 89 da             	mov    %rbx,%rdx
  802d63:	44 89 ef             	mov    %r13d,%edi
  802d66:	41 ff d6             	call   *%r14
  802d69:	85 c0                	test   %eax,%eax
  802d6b:	79 37                	jns    802da4 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802d6d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802d70:	75 05                	jne    802d77 <ipc_send+0x67>
          sys_yield();
  802d72:	41 ff d7             	call   *%r15
  802d75:	eb df                	jmp    802d56 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802d77:	89 c1                	mov    %eax,%ecx
  802d79:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  802d80:	00 00 00 
  802d83:	be 46 00 00 00       	mov    $0x46,%esi
  802d88:	48 bf 13 36 80 00 00 	movabs $0x803613,%rdi
  802d8f:	00 00 00 
  802d92:	b8 00 00 00 00       	mov    $0x0,%eax
  802d97:	49 b8 ac 03 80 00 00 	movabs $0x8003ac,%r8
  802d9e:	00 00 00 
  802da1:	41 ff d0             	call   *%r8
      }
}
  802da4:	48 83 c4 18          	add    $0x18,%rsp
  802da8:	5b                   	pop    %rbx
  802da9:	41 5c                	pop    %r12
  802dab:	41 5d                	pop    %r13
  802dad:	41 5e                	pop    %r14
  802daf:	41 5f                	pop    %r15
  802db1:	5d                   	pop    %rbp
  802db2:	c3                   	ret    

0000000000802db3 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802db3:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802db8:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802dbf:	00 00 00 
  802dc2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802dc6:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802dca:	48 c1 e2 04          	shl    $0x4,%rdx
  802dce:	48 01 ca             	add    %rcx,%rdx
  802dd1:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802dd7:	39 fa                	cmp    %edi,%edx
  802dd9:	74 12                	je     802ded <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802ddb:	48 83 c0 01          	add    $0x1,%rax
  802ddf:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802de5:	75 db                	jne    802dc2 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dec:	c3                   	ret    
            return envs[i].env_id;
  802ded:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802df1:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802df5:	48 c1 e0 04          	shl    $0x4,%rax
  802df9:	48 89 c2             	mov    %rax,%rdx
  802dfc:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802e03:	00 00 00 
  802e06:	48 01 d0             	add    %rdx,%rax
  802e09:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e0f:	c3                   	ret    

0000000000802e10 <__rodata_start>:
  802e10:	74 65                	je     802e77 <__rodata_start+0x67>
  802e12:	73 74                	jae    802e88 <__rodata_start+0x78>
  802e14:	69 6e 67 20 66 6f 72 	imul   $0x726f6620,0x67(%rsi),%ebp
  802e1b:	20 70 69             	and    %dh,0x69(%rax)
  802e1e:	70 65                	jo     802e85 <__rodata_start+0x75>
  802e20:	69 73 63 6c 6f 73 65 	imul   $0x65736f6c,0x63(%rbx),%esi
  802e27:	64 20 72 61          	and    %dh,%fs:0x61(%rdx)
  802e2b:	63 65 2e             	movsxd 0x2e(%rbp),%esp
  802e2e:	2e 2e 0a 00          	cs cs or (%rax),%al
  802e32:	00 00                	add    %al,(%rax)
  802e34:	00 00                	add    %al,(%rax)
  802e36:	00 00                	add    %al,(%rax)
  802e38:	73 6f                	jae    802ea9 <__rodata_start+0x99>
  802e3a:	6d                   	insl   (%dx),%es:(%rdi)
  802e3b:	65 68 6f 77 20 74    	gs push $0x7420776f
  802e41:	68 65 20 6f 74       	push   $0x746f2065
  802e46:	68 65 72 20 65       	push   $0x65207265
  802e4b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e4c:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802e50:	20 70 5b             	and    %dh,0x5b(%rax)
  802e53:	30 5d 20             	xor    %bl,0x20(%rbp)
  802e56:	67 6f                	outsl  %ds:(%esi),(%dx)
  802e58:	74 20                	je     802e7a <__rodata_start+0x6a>
  802e5a:	63 6c 6f 73          	movsxd 0x73(%rdi,%rbp,2),%ebp
  802e5e:	65 64 21 00          	gs and %eax,%fs:(%rax)
  802e62:	70 69                	jo     802ecd <__rodata_start+0xbd>
  802e64:	70 65                	jo     802ecb <__rodata_start+0xbb>
  802e66:	3a 20                	cmp    (%rax),%ah
  802e68:	25 69 00 75 73       	and    $0x73750069,%eax
  802e6d:	65 72 2f             	gs jb  802e9f <__rodata_start+0x8f>
  802e70:	74 65                	je     802ed7 <__rodata_start+0xc7>
  802e72:	73 74                	jae    802ee8 <__rodata_start+0xd8>
  802e74:	70 69                	jo     802edf <__rodata_start+0xcf>
  802e76:	70 65                	jo     802edd <__rodata_start+0xcd>
  802e78:	72 61                	jb     802edb <__rodata_start+0xcb>
  802e7a:	63 65 32             	movsxd 0x32(%rbp),%esp
  802e7d:	2e 63 00             	cs movsxd (%rax),%eax
  802e80:	25 64 2e 00 0a       	and    $0xa002e64,%eax
  802e85:	52                   	push   %rdx
  802e86:	41                   	rex.B
  802e87:	43                   	rex.XB
  802e88:	45 3a 20             	cmp    (%r8),%r12b
  802e8b:	70 69                	jo     802ef6 <__rodata_start+0xe6>
  802e8d:	70 65                	jo     802ef4 <__rodata_start+0xe4>
  802e8f:	20 61 70             	and    %ah,0x70(%rcx)
  802e92:	70 65                	jo     802ef9 <__rodata_start+0xe9>
  802e94:	61                   	(bad)  
  802e95:	72 73                	jb     802f0a <__rodata_start+0xfa>
  802e97:	20 63 6c             	and    %ah,0x6c(%rbx)
  802e9a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e9b:	73 65                	jae    802f02 <__rodata_start+0xf2>
  802e9d:	64 0a 00             	or     %fs:(%rax),%al
  802ea0:	63 68 69             	movsxd 0x69(%rax),%ebp
  802ea3:	6c                   	insb   (%dx),%es:(%rdi)
  802ea4:	64 20 64 6f 6e       	and    %ah,%fs:0x6e(%rdi,%rbp,2)
  802ea9:	65 20 77 69          	and    %dh,%gs:0x69(%rdi)
  802ead:	74 68                	je     802f17 <__rodata_start+0x107>
  802eaf:	20 6c 6f 6f          	and    %ch,0x6f(%rdi,%rbp,2)
  802eb3:	70 0a                	jo     802ebf <__rodata_start+0xaf>
  802eb5:	00 63 61             	add    %ah,0x61(%rbx)
  802eb8:	6e                   	outsb  %ds:(%rsi),(%dx)
  802eb9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802eba:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ebb:	74 20                	je     802edd <__rodata_start+0xcd>
  802ebd:	6c                   	insb   (%dx),%es:(%rdi)
  802ebe:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ebf:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ec0:	6b 20 75             	imul   $0x75,(%rax),%esp
  802ec3:	70 20                	jo     802ee5 <__rodata_start+0xd5>
  802ec5:	70 5b                	jo     802f22 <__rodata_start+0x112>
  802ec7:	30 5d 3a             	xor    %bl,0x3a(%rbp)
  802eca:	20 25 69 00 72 61    	and    %ah,0x61720069(%rip)        # 61f22f39 <__bss_end+0x6171af39>
  802ed0:	63 65 20             	movsxd 0x20(%rbp),%esp
  802ed3:	64 69 64 6e 27 74 20 	imul   $0x61682074,%fs:0x27(%rsi,%rbp,2),%esp
  802eda:	68 61 
  802edc:	70 70                	jo     802f4e <__rodata_start+0x13e>
  802ede:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802ee0:	0a 00                	or     (%rax),%al
  802ee2:	3c 75                	cmp    $0x75,%al
  802ee4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ee5:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802ee9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802eea:	3e 00 0f             	ds add %cl,(%rdi)
  802eed:	1f                   	(bad)  
  802eee:	40 00 5b 25          	rex add %bl,0x25(%rbx)
  802ef2:	30 38                	xor    %bh,(%rax)
  802ef4:	78 5d                	js     802f53 <__rodata_start+0x143>
  802ef6:	20 75 73             	and    %dh,0x73(%rbp)
  802ef9:	65 72 20             	gs jb  802f1c <__rodata_start+0x10c>
  802efc:	70 61                	jo     802f5f <__rodata_start+0x14f>
  802efe:	6e                   	outsb  %ds:(%rsi),(%dx)
  802eff:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  802f06:	73 20                	jae    802f28 <__rodata_start+0x118>
  802f08:	61                   	(bad)  
  802f09:	74 20                	je     802f2b <__rodata_start+0x11b>
  802f0b:	25 73 3a 25 64       	and    $0x64253a73,%eax
  802f10:	3a 20                	cmp    (%rax),%ah
  802f12:	00 30                	add    %dh,(%rax)
  802f14:	31 32                	xor    %esi,(%rdx)
  802f16:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802f1d:	41                   	rex.B
  802f1e:	42                   	rex.X
  802f1f:	43                   	rex.XB
  802f20:	44                   	rex.R
  802f21:	45                   	rex.RB
  802f22:	46 00 30             	rex.RX add %r14b,(%rax)
  802f25:	31 32                	xor    %esi,(%rdx)
  802f27:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802f2e:	61                   	(bad)  
  802f2f:	62 63 64 65 66       	(bad)
  802f34:	00 28                	add    %ch,(%rax)
  802f36:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f37:	75 6c                	jne    802fa5 <__rodata_start+0x195>
  802f39:	6c                   	insb   (%dx),%es:(%rdi)
  802f3a:	29 00                	sub    %eax,(%rax)
  802f3c:	65 72 72             	gs jb  802fb1 <__rodata_start+0x1a1>
  802f3f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f40:	72 20                	jb     802f62 <__rodata_start+0x152>
  802f42:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802f47:	73 70                	jae    802fb9 <__rodata_start+0x1a9>
  802f49:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802f4d:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802f54:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f55:	72 00                	jb     802f57 <__rodata_start+0x147>
  802f57:	62 61 64 20 65       	(bad)
  802f5c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f5d:	76 69                	jbe    802fc8 <__rodata_start+0x1b8>
  802f5f:	72 6f                	jb     802fd0 <__rodata_start+0x1c0>
  802f61:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f62:	6d                   	insl   (%dx),%es:(%rdi)
  802f63:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802f65:	74 00                	je     802f67 <__rodata_start+0x157>
  802f67:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802f6e:	20 70 61             	and    %dh,0x61(%rax)
  802f71:	72 61                	jb     802fd4 <__rodata_start+0x1c4>
  802f73:	6d                   	insl   (%dx),%es:(%rdi)
  802f74:	65 74 65             	gs je  802fdc <__rodata_start+0x1cc>
  802f77:	72 00                	jb     802f79 <__rodata_start+0x169>
  802f79:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f7a:	75 74                	jne    802ff0 <__rodata_start+0x1e0>
  802f7c:	20 6f 66             	and    %ch,0x66(%rdi)
  802f7f:	20 6d 65             	and    %ch,0x65(%rbp)
  802f82:	6d                   	insl   (%dx),%es:(%rdi)
  802f83:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f84:	72 79                	jb     802fff <__rodata_start+0x1ef>
  802f86:	00 6f 75             	add    %ch,0x75(%rdi)
  802f89:	74 20                	je     802fab <__rodata_start+0x19b>
  802f8b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f8c:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802f90:	76 69                	jbe    802ffb <__rodata_start+0x1eb>
  802f92:	72 6f                	jb     803003 <__rodata_start+0x1f3>
  802f94:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f95:	6d                   	insl   (%dx),%es:(%rdi)
  802f96:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802f98:	74 73                	je     80300d <__rodata_start+0x1fd>
  802f9a:	00 63 6f             	add    %ah,0x6f(%rbx)
  802f9d:	72 72                	jb     803011 <__rodata_start+0x201>
  802f9f:	75 70                	jne    803011 <__rodata_start+0x201>
  802fa1:	74 65                	je     803008 <__rodata_start+0x1f8>
  802fa3:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802fa8:	75 67                	jne    803011 <__rodata_start+0x201>
  802faa:	20 69 6e             	and    %ch,0x6e(%rcx)
  802fad:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802faf:	00 73 65             	add    %dh,0x65(%rbx)
  802fb2:	67 6d                	insl   (%dx),%es:(%edi)
  802fb4:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802fb6:	74 61                	je     803019 <__rodata_start+0x209>
  802fb8:	74 69                	je     803023 <__rodata_start+0x213>
  802fba:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fbb:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fbc:	20 66 61             	and    %ah,0x61(%rsi)
  802fbf:	75 6c                	jne    80302d <__rodata_start+0x21d>
  802fc1:	74 00                	je     802fc3 <__rodata_start+0x1b3>
  802fc3:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802fca:	20 45 4c             	and    %al,0x4c(%rbp)
  802fcd:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802fd1:	61                   	(bad)  
  802fd2:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802fd7:	20 73 75             	and    %dh,0x75(%rbx)
  802fda:	63 68 20             	movsxd 0x20(%rax),%ebp
  802fdd:	73 79                	jae    803058 <__rodata_start+0x248>
  802fdf:	73 74                	jae    803055 <__rodata_start+0x245>
  802fe1:	65 6d                	gs insl (%dx),%es:(%rdi)
  802fe3:	20 63 61             	and    %ah,0x61(%rbx)
  802fe6:	6c                   	insb   (%dx),%es:(%rdi)
  802fe7:	6c                   	insb   (%dx),%es:(%rdi)
  802fe8:	00 65 6e             	add    %ah,0x6e(%rbp)
  802feb:	74 72                	je     80305f <__rodata_start+0x24f>
  802fed:	79 20                	jns    80300f <__rodata_start+0x1ff>
  802fef:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ff0:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ff1:	74 20                	je     803013 <__rodata_start+0x203>
  802ff3:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802ff5:	75 6e                	jne    803065 <__rodata_start+0x255>
  802ff7:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802ffb:	76 20                	jbe    80301d <__rodata_start+0x20d>
  802ffd:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  803004:	72 65                	jb     80306b <__rodata_start+0x25b>
  803006:	63 76 69             	movsxd 0x69(%rsi),%esi
  803009:	6e                   	outsb  %ds:(%rsi),(%dx)
  80300a:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  80300e:	65 78 70             	gs js  803081 <__rodata_start+0x271>
  803011:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  803016:	20 65 6e             	and    %ah,0x6e(%rbp)
  803019:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  80301d:	20 66 69             	and    %ah,0x69(%rsi)
  803020:	6c                   	insb   (%dx),%es:(%rdi)
  803021:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  803025:	20 66 72             	and    %ah,0x72(%rsi)
  803028:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  80302d:	61                   	(bad)  
  80302e:	63 65 20             	movsxd 0x20(%rbp),%esp
  803031:	6f                   	outsl  %ds:(%rsi),(%dx)
  803032:	6e                   	outsb  %ds:(%rsi),(%dx)
  803033:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  803037:	6b 00 74             	imul   $0x74,(%rax),%eax
  80303a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80303b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80303c:	20 6d 61             	and    %ch,0x61(%rbp)
  80303f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803040:	79 20                	jns    803062 <__rodata_start+0x252>
  803042:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  803049:	72 65                	jb     8030b0 <__rodata_start+0x2a0>
  80304b:	20 6f 70             	and    %ch,0x70(%rdi)
  80304e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803050:	00 66 69             	add    %ah,0x69(%rsi)
  803053:	6c                   	insb   (%dx),%es:(%rdi)
  803054:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  803058:	20 62 6c             	and    %ah,0x6c(%rdx)
  80305b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80305c:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  80305f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803060:	6f                   	outsl  %ds:(%rsi),(%dx)
  803061:	74 20                	je     803083 <__rodata_start+0x273>
  803063:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803065:	75 6e                	jne    8030d5 <__rodata_start+0x2c5>
  803067:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  80306b:	76 61                	jbe    8030ce <__rodata_start+0x2be>
  80306d:	6c                   	insb   (%dx),%es:(%rdi)
  80306e:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  803075:	00 
  803076:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  80307d:	72 65                	jb     8030e4 <__rodata_start+0x2d4>
  80307f:	61                   	(bad)  
  803080:	64 79 20             	fs jns 8030a3 <__rodata_start+0x293>
  803083:	65 78 69             	gs js  8030ef <__rodata_start+0x2df>
  803086:	73 74                	jae    8030fc <__rodata_start+0x2ec>
  803088:	73 00                	jae    80308a <__rodata_start+0x27a>
  80308a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80308b:	70 65                	jo     8030f2 <__rodata_start+0x2e2>
  80308d:	72 61                	jb     8030f0 <__rodata_start+0x2e0>
  80308f:	74 69                	je     8030fa <__rodata_start+0x2ea>
  803091:	6f                   	outsl  %ds:(%rsi),(%dx)
  803092:	6e                   	outsb  %ds:(%rsi),(%dx)
  803093:	20 6e 6f             	and    %ch,0x6f(%rsi)
  803096:	74 20                	je     8030b8 <__rodata_start+0x2a8>
  803098:	73 75                	jae    80310f <__rodata_start+0x2ff>
  80309a:	70 70                	jo     80310c <__rodata_start+0x2fc>
  80309c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80309d:	72 74                	jb     803113 <__rodata_start+0x303>
  80309f:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  8030a4:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8030ab:	00 
  8030ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030b3:	00 00 00 
  8030b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030bd:	00 00 00 
  8030c0:	f6 06 80             	testb  $0x80,(%rsi)
  8030c3:	00 00                	add    %al,(%rax)
  8030c5:	00 00                	add    %al,(%rax)
  8030c7:	00 4a 0d             	add    %cl,0xd(%rdx)
  8030ca:	80 00 00             	addb   $0x0,(%rax)
  8030cd:	00 00                	add    %al,(%rax)
  8030cf:	00 3a                	add    %bh,(%rdx)
  8030d1:	0d 80 00 00 00       	or     $0x80,%eax
  8030d6:	00 00                	add    %al,(%rax)
  8030d8:	4a 0d 80 00 00 00    	rex.WX or $0x80,%rax
  8030de:	00 00                	add    %al,(%rax)
  8030e0:	4a 0d 80 00 00 00    	rex.WX or $0x80,%rax
  8030e6:	00 00                	add    %al,(%rax)
  8030e8:	4a 0d 80 00 00 00    	rex.WX or $0x80,%rax
  8030ee:	00 00                	add    %al,(%rax)
  8030f0:	4a 0d 80 00 00 00    	rex.WX or $0x80,%rax
  8030f6:	00 00                	add    %al,(%rax)
  8030f8:	10 07                	adc    %al,(%rdi)
  8030fa:	80 00 00             	addb   $0x0,(%rax)
  8030fd:	00 00                	add    %al,(%rax)
  8030ff:	00 4a 0d             	add    %cl,0xd(%rdx)
  803102:	80 00 00             	addb   $0x0,(%rax)
  803105:	00 00                	add    %al,(%rax)
  803107:	00 4a 0d             	add    %cl,0xd(%rdx)
  80310a:	80 00 00             	addb   $0x0,(%rax)
  80310d:	00 00                	add    %al,(%rax)
  80310f:	00 07                	add    %al,(%rdi)
  803111:	07                   	(bad)  
  803112:	80 00 00             	addb   $0x0,(%rax)
  803115:	00 00                	add    %al,(%rax)
  803117:	00 7d 07             	add    %bh,0x7(%rbp)
  80311a:	80 00 00             	addb   $0x0,(%rax)
  80311d:	00 00                	add    %al,(%rax)
  80311f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803122:	80 00 00             	addb   $0x0,(%rax)
  803125:	00 00                	add    %al,(%rax)
  803127:	00 07                	add    %al,(%rdi)
  803129:	07                   	(bad)  
  80312a:	80 00 00             	addb   $0x0,(%rax)
  80312d:	00 00                	add    %al,(%rax)
  80312f:	00 4a 07             	add    %cl,0x7(%rdx)
  803132:	80 00 00             	addb   $0x0,(%rax)
  803135:	00 00                	add    %al,(%rax)
  803137:	00 4a 07             	add    %cl,0x7(%rdx)
  80313a:	80 00 00             	addb   $0x0,(%rax)
  80313d:	00 00                	add    %al,(%rax)
  80313f:	00 4a 07             	add    %cl,0x7(%rdx)
  803142:	80 00 00             	addb   $0x0,(%rax)
  803145:	00 00                	add    %al,(%rax)
  803147:	00 4a 07             	add    %cl,0x7(%rdx)
  80314a:	80 00 00             	addb   $0x0,(%rax)
  80314d:	00 00                	add    %al,(%rax)
  80314f:	00 4a 07             	add    %cl,0x7(%rdx)
  803152:	80 00 00             	addb   $0x0,(%rax)
  803155:	00 00                	add    %al,(%rax)
  803157:	00 4a 07             	add    %cl,0x7(%rdx)
  80315a:	80 00 00             	addb   $0x0,(%rax)
  80315d:	00 00                	add    %al,(%rax)
  80315f:	00 4a 07             	add    %cl,0x7(%rdx)
  803162:	80 00 00             	addb   $0x0,(%rax)
  803165:	00 00                	add    %al,(%rax)
  803167:	00 4a 07             	add    %cl,0x7(%rdx)
  80316a:	80 00 00             	addb   $0x0,(%rax)
  80316d:	00 00                	add    %al,(%rax)
  80316f:	00 4a 07             	add    %cl,0x7(%rdx)
  803172:	80 00 00             	addb   $0x0,(%rax)
  803175:	00 00                	add    %al,(%rax)
  803177:	00 4a 0d             	add    %cl,0xd(%rdx)
  80317a:	80 00 00             	addb   $0x0,(%rax)
  80317d:	00 00                	add    %al,(%rax)
  80317f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803182:	80 00 00             	addb   $0x0,(%rax)
  803185:	00 00                	add    %al,(%rax)
  803187:	00 4a 0d             	add    %cl,0xd(%rdx)
  80318a:	80 00 00             	addb   $0x0,(%rax)
  80318d:	00 00                	add    %al,(%rax)
  80318f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803192:	80 00 00             	addb   $0x0,(%rax)
  803195:	00 00                	add    %al,(%rax)
  803197:	00 4a 0d             	add    %cl,0xd(%rdx)
  80319a:	80 00 00             	addb   $0x0,(%rax)
  80319d:	00 00                	add    %al,(%rax)
  80319f:	00 4a 0d             	add    %cl,0xd(%rdx)
  8031a2:	80 00 00             	addb   $0x0,(%rax)
  8031a5:	00 00                	add    %al,(%rax)
  8031a7:	00 4a 0d             	add    %cl,0xd(%rdx)
  8031aa:	80 00 00             	addb   $0x0,(%rax)
  8031ad:	00 00                	add    %al,(%rax)
  8031af:	00 4a 0d             	add    %cl,0xd(%rdx)
  8031b2:	80 00 00             	addb   $0x0,(%rax)
  8031b5:	00 00                	add    %al,(%rax)
  8031b7:	00 4a 0d             	add    %cl,0xd(%rdx)
  8031ba:	80 00 00             	addb   $0x0,(%rax)
  8031bd:	00 00                	add    %al,(%rax)
  8031bf:	00 4a 0d             	add    %cl,0xd(%rdx)
  8031c2:	80 00 00             	addb   $0x0,(%rax)
  8031c5:	00 00                	add    %al,(%rax)
  8031c7:	00 4a 0d             	add    %cl,0xd(%rdx)
  8031ca:	80 00 00             	addb   $0x0,(%rax)
  8031cd:	00 00                	add    %al,(%rax)
  8031cf:	00 4a 0d             	add    %cl,0xd(%rdx)
  8031d2:	80 00 00             	addb   $0x0,(%rax)
  8031d5:	00 00                	add    %al,(%rax)
  8031d7:	00 4a 0d             	add    %cl,0xd(%rdx)
  8031da:	80 00 00             	addb   $0x0,(%rax)
  8031dd:	00 00                	add    %al,(%rax)
  8031df:	00 4a 0d             	add    %cl,0xd(%rdx)
  8031e2:	80 00 00             	addb   $0x0,(%rax)
  8031e5:	00 00                	add    %al,(%rax)
  8031e7:	00 4a 0d             	add    %cl,0xd(%rdx)
  8031ea:	80 00 00             	addb   $0x0,(%rax)
  8031ed:	00 00                	add    %al,(%rax)
  8031ef:	00 4a 0d             	add    %cl,0xd(%rdx)
  8031f2:	80 00 00             	addb   $0x0,(%rax)
  8031f5:	00 00                	add    %al,(%rax)
  8031f7:	00 4a 0d             	add    %cl,0xd(%rdx)
  8031fa:	80 00 00             	addb   $0x0,(%rax)
  8031fd:	00 00                	add    %al,(%rax)
  8031ff:	00 4a 0d             	add    %cl,0xd(%rdx)
  803202:	80 00 00             	addb   $0x0,(%rax)
  803205:	00 00                	add    %al,(%rax)
  803207:	00 4a 0d             	add    %cl,0xd(%rdx)
  80320a:	80 00 00             	addb   $0x0,(%rax)
  80320d:	00 00                	add    %al,(%rax)
  80320f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803212:	80 00 00             	addb   $0x0,(%rax)
  803215:	00 00                	add    %al,(%rax)
  803217:	00 4a 0d             	add    %cl,0xd(%rdx)
  80321a:	80 00 00             	addb   $0x0,(%rax)
  80321d:	00 00                	add    %al,(%rax)
  80321f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803222:	80 00 00             	addb   $0x0,(%rax)
  803225:	00 00                	add    %al,(%rax)
  803227:	00 4a 0d             	add    %cl,0xd(%rdx)
  80322a:	80 00 00             	addb   $0x0,(%rax)
  80322d:	00 00                	add    %al,(%rax)
  80322f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803232:	80 00 00             	addb   $0x0,(%rax)
  803235:	00 00                	add    %al,(%rax)
  803237:	00 4a 0d             	add    %cl,0xd(%rdx)
  80323a:	80 00 00             	addb   $0x0,(%rax)
  80323d:	00 00                	add    %al,(%rax)
  80323f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803242:	80 00 00             	addb   $0x0,(%rax)
  803245:	00 00                	add    %al,(%rax)
  803247:	00 4a 0d             	add    %cl,0xd(%rdx)
  80324a:	80 00 00             	addb   $0x0,(%rax)
  80324d:	00 00                	add    %al,(%rax)
  80324f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803252:	80 00 00             	addb   $0x0,(%rax)
  803255:	00 00                	add    %al,(%rax)
  803257:	00 4a 0d             	add    %cl,0xd(%rdx)
  80325a:	80 00 00             	addb   $0x0,(%rax)
  80325d:	00 00                	add    %al,(%rax)
  80325f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803262:	80 00 00             	addb   $0x0,(%rax)
  803265:	00 00                	add    %al,(%rax)
  803267:	00 6f 0c             	add    %ch,0xc(%rdi)
  80326a:	80 00 00             	addb   $0x0,(%rax)
  80326d:	00 00                	add    %al,(%rax)
  80326f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803272:	80 00 00             	addb   $0x0,(%rax)
  803275:	00 00                	add    %al,(%rax)
  803277:	00 4a 0d             	add    %cl,0xd(%rdx)
  80327a:	80 00 00             	addb   $0x0,(%rax)
  80327d:	00 00                	add    %al,(%rax)
  80327f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803282:	80 00 00             	addb   $0x0,(%rax)
  803285:	00 00                	add    %al,(%rax)
  803287:	00 4a 0d             	add    %cl,0xd(%rdx)
  80328a:	80 00 00             	addb   $0x0,(%rax)
  80328d:	00 00                	add    %al,(%rax)
  80328f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803292:	80 00 00             	addb   $0x0,(%rax)
  803295:	00 00                	add    %al,(%rax)
  803297:	00 4a 0d             	add    %cl,0xd(%rdx)
  80329a:	80 00 00             	addb   $0x0,(%rax)
  80329d:	00 00                	add    %al,(%rax)
  80329f:	00 4a 0d             	add    %cl,0xd(%rdx)
  8032a2:	80 00 00             	addb   $0x0,(%rax)
  8032a5:	00 00                	add    %al,(%rax)
  8032a7:	00 4a 0d             	add    %cl,0xd(%rdx)
  8032aa:	80 00 00             	addb   $0x0,(%rax)
  8032ad:	00 00                	add    %al,(%rax)
  8032af:	00 4a 0d             	add    %cl,0xd(%rdx)
  8032b2:	80 00 00             	addb   $0x0,(%rax)
  8032b5:	00 00                	add    %al,(%rax)
  8032b7:	00 4a 0d             	add    %cl,0xd(%rdx)
  8032ba:	80 00 00             	addb   $0x0,(%rax)
  8032bd:	00 00                	add    %al,(%rax)
  8032bf:	00 9b 07 80 00 00    	add    %bl,0x8007(%rbx)
  8032c5:	00 00                	add    %al,(%rax)
  8032c7:	00 91 09 80 00 00    	add    %dl,0x8009(%rcx)
  8032cd:	00 00                	add    %al,(%rax)
  8032cf:	00 4a 0d             	add    %cl,0xd(%rdx)
  8032d2:	80 00 00             	addb   $0x0,(%rax)
  8032d5:	00 00                	add    %al,(%rax)
  8032d7:	00 4a 0d             	add    %cl,0xd(%rdx)
  8032da:	80 00 00             	addb   $0x0,(%rax)
  8032dd:	00 00                	add    %al,(%rax)
  8032df:	00 4a 0d             	add    %cl,0xd(%rdx)
  8032e2:	80 00 00             	addb   $0x0,(%rax)
  8032e5:	00 00                	add    %al,(%rax)
  8032e7:	00 4a 0d             	add    %cl,0xd(%rdx)
  8032ea:	80 00 00             	addb   $0x0,(%rax)
  8032ed:	00 00                	add    %al,(%rax)
  8032ef:	00 c9                	add    %cl,%cl
  8032f1:	07                   	(bad)  
  8032f2:	80 00 00             	addb   $0x0,(%rax)
  8032f5:	00 00                	add    %al,(%rax)
  8032f7:	00 4a 0d             	add    %cl,0xd(%rdx)
  8032fa:	80 00 00             	addb   $0x0,(%rax)
  8032fd:	00 00                	add    %al,(%rax)
  8032ff:	00 4a 0d             	add    %cl,0xd(%rdx)
  803302:	80 00 00             	addb   $0x0,(%rax)
  803305:	00 00                	add    %al,(%rax)
  803307:	00 90 07 80 00 00    	add    %dl,0x8007(%rax)
  80330d:	00 00                	add    %al,(%rax)
  80330f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803312:	80 00 00             	addb   $0x0,(%rax)
  803315:	00 00                	add    %al,(%rax)
  803317:	00 4a 0d             	add    %cl,0xd(%rdx)
  80331a:	80 00 00             	addb   $0x0,(%rax)
  80331d:	00 00                	add    %al,(%rax)
  80331f:	00 31                	add    %dh,(%rcx)
  803321:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803327:	00 f9                	add    %bh,%cl
  803329:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80332f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803332:	80 00 00             	addb   $0x0,(%rax)
  803335:	00 00                	add    %al,(%rax)
  803337:	00 4a 0d             	add    %cl,0xd(%rdx)
  80333a:	80 00 00             	addb   $0x0,(%rax)
  80333d:	00 00                	add    %al,(%rax)
  80333f:	00 61 08             	add    %ah,0x8(%rcx)
  803342:	80 00 00             	addb   $0x0,(%rax)
  803345:	00 00                	add    %al,(%rax)
  803347:	00 4a 0d             	add    %cl,0xd(%rdx)
  80334a:	80 00 00             	addb   $0x0,(%rax)
  80334d:	00 00                	add    %al,(%rax)
  80334f:	00 63 0a             	add    %ah,0xa(%rbx)
  803352:	80 00 00             	addb   $0x0,(%rax)
  803355:	00 00                	add    %al,(%rax)
  803357:	00 4a 0d             	add    %cl,0xd(%rdx)
  80335a:	80 00 00             	addb   $0x0,(%rax)
  80335d:	00 00                	add    %al,(%rax)
  80335f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803362:	80 00 00             	addb   $0x0,(%rax)
  803365:	00 00                	add    %al,(%rax)
  803367:	00 6f 0c             	add    %ch,0xc(%rdi)
  80336a:	80 00 00             	addb   $0x0,(%rax)
  80336d:	00 00                	add    %al,(%rax)
  80336f:	00 4a 0d             	add    %cl,0xd(%rdx)
  803372:	80 00 00             	addb   $0x0,(%rax)
  803375:	00 00                	add    %al,(%rax)
  803377:	00 ff                	add    %bh,%bh
  803379:	06                   	(bad)  
  80337a:	80 00 00             	addb   $0x0,(%rax)
  80337d:	00 00                	add    %al,(%rax)
	...

0000000000803380 <error_string>:
	...
  803388:	45 2f 80 00 00 00 00 00 57 2f 80 00 00 00 00 00     E/......W/......
  803398:	67 2f 80 00 00 00 00 00 79 2f 80 00 00 00 00 00     g/......y/......
  8033a8:	87 2f 80 00 00 00 00 00 9b 2f 80 00 00 00 00 00     ./......./......
  8033b8:	b0 2f 80 00 00 00 00 00 c3 2f 80 00 00 00 00 00     ./......./......
  8033c8:	d5 2f 80 00 00 00 00 00 e9 2f 80 00 00 00 00 00     ./......./......
  8033d8:	f9 2f 80 00 00 00 00 00 0c 30 80 00 00 00 00 00     ./.......0......
  8033e8:	23 30 80 00 00 00 00 00 39 30 80 00 00 00 00 00     #0......90......
  8033f8:	51 30 80 00 00 00 00 00 69 30 80 00 00 00 00 00     Q0......i0......
  803408:	76 30 80 00 00 00 00 00 20 34 80 00 00 00 00 00     v0...... 4......
  803418:	8a 30 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .0......file is 
  803428:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803438:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803448:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803458:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803468:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  803478:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  803488:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  803498:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  8034a8:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  8034b8:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  8034c8:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  8034d8:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  8034e8:	6c 6c 3a 20 25 69 00 90 5b 25 30 38 78 5d 20 75     ll: %i..[%08x] u
  8034f8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803508:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803518:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803528:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803538:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803548:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803558:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803568:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803578:	84 00 00 00 00 00 66 90                             ......f.

0000000000803580 <devtab>:
  803580:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803590:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8035a0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  8035b0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  8035c0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  8035d0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  8035e0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  8035f0:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803600:	69 70 63 5f 73 65 6e 64 20 65 72 72 6f 72 3a 20     ipc_send error: 
  803610:	25 69 00 6c 69 62 2f 69 70 63 2e 63 00 66 2e 0f     %i.lib/ipc.c.f..
  803620:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803630:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803640:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803650:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803660:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803670:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803680:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803690:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8036a0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8036b0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8036c0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8036d0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8036e0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8036f0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803700:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803710:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803720:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803730:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803740:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803750:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803760:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803770:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803780:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803790:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8037a0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8037b0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8037c0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8037d0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8037e0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8037f0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803800:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803810:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803820:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803830:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803840:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803850:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803860:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803870:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803880:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803890:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8038a0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8038b0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8038c0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8038d0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8038e0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8038f0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803900:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803910:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803920:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803930:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803940:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803950:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803960:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803970:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803980:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803990:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8039a0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8039b0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8039c0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8039d0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8039e0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8039f0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a00:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a10:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a20:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803a30:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a40:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a50:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a60:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a70:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803a80:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a90:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803aa0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ab0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ac0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ad0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ae0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803af0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b00:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b10:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b20:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b30:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b40:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b50:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b60:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b70:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b80:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b90:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ba0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803bb0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803bc0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803bd0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803be0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803bf0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c00:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c10:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c20:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c30:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c40:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c50:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c60:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c70:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c80:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c90:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ca0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803cb0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803cc0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803cd0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ce0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803cf0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d00:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d10:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d20:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d30:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d40:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d50:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d60:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d70:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d80:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d90:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803da0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803db0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803dc0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803dd0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803de0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803df0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e00:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e10:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e20:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e30:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e40:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e50:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e60:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e70:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e80:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e90:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ea0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803eb0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ec0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ed0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ee0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ef0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f00:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f10:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f20:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f30:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f40:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f50:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f60:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f70:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f80:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f90:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803fa0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803fb0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803fc0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803fd0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803fe0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ff0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 90     .....f..........
