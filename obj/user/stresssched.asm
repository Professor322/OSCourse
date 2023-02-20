
obj/user/stresssched:     file format elf64-x86-64


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
  80001e:	e8 37 01 00 00       	call   80015a <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

volatile int counter;

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 55                	push   %r13
  80002b:	41 54                	push   %r12
  80002d:	53                   	push   %rbx
  80002e:	48 83 ec 08          	sub    $0x8,%rsp
    int i, j;
    envid_t parent = sys_getenvid();
  800032:	48 b8 b6 11 80 00 00 	movabs $0x8011b6,%rax
  800039:	00 00 00 
  80003c:	ff d0                	call   *%rax
  80003e:	41 89 c5             	mov    %eax,%r13d

    /* Fork several environments */
    for (i = 0; i < 20; i++)
  800041:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (fork() == 0)
  800046:	49 bc db 15 80 00 00 	movabs $0x8015db,%r12
  80004d:	00 00 00 
  800050:	41 ff d4             	call   *%r12
  800053:	85 c0                	test   %eax,%eax
  800055:	74 19                	je     800070 <umain+0x4b>
    for (i = 0; i < 20; i++)
  800057:	83 c3 01             	add    $0x1,%ebx
  80005a:	83 fb 14             	cmp    $0x14,%ebx
  80005d:	75 f1                	jne    800050 <umain+0x2b>
            break;
    if (i == 20) {
        sys_yield();
  80005f:	48 b8 e7 11 80 00 00 	movabs $0x8011e7,%rax
  800066:	00 00 00 
  800069:	ff d0                	call   *%rax
        return;
  80006b:	e9 a8 00 00 00       	jmp    800118 <umain+0xf3>
    if (i == 20) {
  800070:	83 fb 14             	cmp    $0x14,%ebx
  800073:	74 ea                	je     80005f <umain+0x3a>
    }

    /* Wait for the parent to finish forking */
    while (envs[ENVX(parent)].env_status != ENV_FREE)
  800075:	44 89 ea             	mov    %r13d,%edx
  800078:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80007e:	44 89 e8             	mov    %r13d,%eax
  800081:	25 ff 03 00 00       	and    $0x3ff,%eax
  800086:	48 8d 0c c0          	lea    (%rax,%rax,8),%rcx
  80008a:	48 8d 04 48          	lea    (%rax,%rcx,2),%rax
  80008e:	48 c1 e0 04          	shl    $0x4,%rax
  800092:	48 89 c1             	mov    %rax,%rcx
  800095:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  80009c:	00 00 00 
  80009f:	48 01 c8             	add    %rcx,%rax
  8000a2:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8000a8:	85 c0                	test   %eax,%eax
  8000aa:	74 28                	je     8000d4 <umain+0xaf>
  8000ac:	48 63 c2             	movslq %edx,%rax
  8000af:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000b3:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000b7:	48 c1 e0 04          	shl    $0x4,%rax
  8000bb:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000c2:	00 00 00 
  8000c5:	48 01 c2             	add    %rax,%rdx
        asm volatile("pause");
  8000c8:	f3 90                	pause  
    while (envs[ENVX(parent)].env_status != ENV_FREE)
  8000ca:	8b 82 d4 00 00 00    	mov    0xd4(%rdx),%eax
  8000d0:	85 c0                	test   %eax,%eax
  8000d2:	75 f4                	jne    8000c8 <umain+0xa3>
    for (i = 0; i < 20; i++)
  8000d4:	41 bc 0a 00 00 00    	mov    $0xa,%r12d

    /* Check that one environment doesn't run on two CPUs at once */
    for (i = 0; i < 10; i++) {
        sys_yield();
  8000da:	49 bd e7 11 80 00 00 	movabs $0x8011e7,%r13
  8000e1:	00 00 00 
        for (j = 0; j < 10000; j++)
            counter++;
  8000e4:	48 bb 00 50 80 00 00 	movabs $0x805000,%rbx
  8000eb:	00 00 00 
        sys_yield();
  8000ee:	41 ff d5             	call   *%r13
  8000f1:	ba 10 27 00 00       	mov    $0x2710,%edx
            counter++;
  8000f6:	8b 03                	mov    (%rbx),%eax
  8000f8:	83 c0 01             	add    $0x1,%eax
  8000fb:	89 03                	mov    %eax,(%rbx)
        for (j = 0; j < 10000; j++)
  8000fd:	83 ea 01             	sub    $0x1,%edx
  800100:	75 f4                	jne    8000f6 <umain+0xd1>
    for (i = 0; i < 10; i++) {
  800102:	41 83 ec 01          	sub    $0x1,%r12d
  800106:	75 e6                	jne    8000ee <umain+0xc9>
    }

    if (counter != 10 * 10000)
  800108:	a1 00 50 80 00 00 00 	movabs 0x805000,%eax
  80010f:	00 00 
  800111:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  800116:	75 0b                	jne    800123 <umain+0xfe>
        panic("ran on two CPUs at once (counter is %d)", counter);

    /* Check that we see environments running on different CPUs */
    //cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
}
  800118:	48 83 c4 08          	add    $0x8,%rsp
  80011c:	5b                   	pop    %rbx
  80011d:	41 5c                	pop    %r12
  80011f:	41 5d                	pop    %r13
  800121:	5d                   	pop    %rbp
  800122:	c3                   	ret    
        panic("ran on two CPUs at once (counter is %d)", counter);
  800123:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80012a:	00 00 00 
  80012d:	8b 08                	mov    (%rax),%ecx
  80012f:	48 ba 90 2c 80 00 00 	movabs $0x802c90,%rdx
  800136:	00 00 00 
  800139:	be 1f 00 00 00       	mov    $0x1f,%esi
  80013e:	48 bf b8 2c 80 00 00 	movabs $0x802cb8,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	49 b8 2b 02 80 00 00 	movabs $0x80022b,%r8
  800154:	00 00 00 
  800157:	41 ff d0             	call   *%r8

000000000080015a <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80015a:	55                   	push   %rbp
  80015b:	48 89 e5             	mov    %rsp,%rbp
  80015e:	41 56                	push   %r14
  800160:	41 55                	push   %r13
  800162:	41 54                	push   %r12
  800164:	53                   	push   %rbx
  800165:	41 89 fd             	mov    %edi,%r13d
  800168:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80016b:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800172:	00 00 00 
  800175:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80017c:	00 00 00 
  80017f:	48 39 c2             	cmp    %rax,%rdx
  800182:	73 17                	jae    80019b <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800184:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800187:	49 89 c4             	mov    %rax,%r12
  80018a:	48 83 c3 08          	add    $0x8,%rbx
  80018e:	b8 00 00 00 00       	mov    $0x0,%eax
  800193:	ff 53 f8             	call   *-0x8(%rbx)
  800196:	4c 39 e3             	cmp    %r12,%rbx
  800199:	72 ef                	jb     80018a <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80019b:	48 b8 b6 11 80 00 00 	movabs $0x8011b6,%rax
  8001a2:	00 00 00 
  8001a5:	ff d0                	call   *%rax
  8001a7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ac:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8001b0:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8001b4:	48 c1 e0 04          	shl    $0x4,%rax
  8001b8:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8001bf:	00 00 00 
  8001c2:	48 01 d0             	add    %rdx,%rax
  8001c5:	48 a3 08 50 80 00 00 	movabs %rax,0x805008
  8001cc:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8001cf:	45 85 ed             	test   %r13d,%r13d
  8001d2:	7e 0d                	jle    8001e1 <libmain+0x87>
  8001d4:	49 8b 06             	mov    (%r14),%rax
  8001d7:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8001de:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8001e1:	4c 89 f6             	mov    %r14,%rsi
  8001e4:	44 89 ef             	mov    %r13d,%edi
  8001e7:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8001ee:	00 00 00 
  8001f1:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001f3:	48 b8 08 02 80 00 00 	movabs $0x800208,%rax
  8001fa:	00 00 00 
  8001fd:	ff d0                	call   *%rax
#endif
}
  8001ff:	5b                   	pop    %rbx
  800200:	41 5c                	pop    %r12
  800202:	41 5d                	pop    %r13
  800204:	41 5e                	pop    %r14
  800206:	5d                   	pop    %rbp
  800207:	c3                   	ret    

0000000000800208 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800208:	55                   	push   %rbp
  800209:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80020c:	48 b8 bd 19 80 00 00 	movabs $0x8019bd,%rax
  800213:	00 00 00 
  800216:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800218:	bf 00 00 00 00       	mov    $0x0,%edi
  80021d:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  800224:	00 00 00 
  800227:	ff d0                	call   *%rax
}
  800229:	5d                   	pop    %rbp
  80022a:	c3                   	ret    

000000000080022b <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80022b:	55                   	push   %rbp
  80022c:	48 89 e5             	mov    %rsp,%rbp
  80022f:	41 56                	push   %r14
  800231:	41 55                	push   %r13
  800233:	41 54                	push   %r12
  800235:	53                   	push   %rbx
  800236:	48 83 ec 50          	sub    $0x50,%rsp
  80023a:	49 89 fc             	mov    %rdi,%r12
  80023d:	41 89 f5             	mov    %esi,%r13d
  800240:	48 89 d3             	mov    %rdx,%rbx
  800243:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800247:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80024b:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80024f:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800256:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80025a:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80025e:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800262:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800266:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80026d:	00 00 00 
  800270:	4c 8b 30             	mov    (%rax),%r14
  800273:	48 b8 b6 11 80 00 00 	movabs $0x8011b6,%rax
  80027a:	00 00 00 
  80027d:	ff d0                	call   *%rax
  80027f:	89 c6                	mov    %eax,%esi
  800281:	45 89 e8             	mov    %r13d,%r8d
  800284:	4c 89 e1             	mov    %r12,%rcx
  800287:	4c 89 f2             	mov    %r14,%rdx
  80028a:	48 bf d8 2c 80 00 00 	movabs $0x802cd8,%rdi
  800291:	00 00 00 
  800294:	b8 00 00 00 00       	mov    $0x0,%eax
  800299:	49 bc 7b 03 80 00 00 	movabs $0x80037b,%r12
  8002a0:	00 00 00 
  8002a3:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8002a6:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8002aa:	48 89 df             	mov    %rbx,%rdi
  8002ad:	48 b8 17 03 80 00 00 	movabs $0x800317,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	call   *%rax
    cprintf("\n");
  8002b9:	48 bf 2b 33 80 00 00 	movabs $0x80332b,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8002cb:	cc                   	int3   
  8002cc:	eb fd                	jmp    8002cb <_panic+0xa0>

00000000008002ce <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8002ce:	55                   	push   %rbp
  8002cf:	48 89 e5             	mov    %rsp,%rbp
  8002d2:	53                   	push   %rbx
  8002d3:	48 83 ec 08          	sub    $0x8,%rsp
  8002d7:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8002da:	8b 06                	mov    (%rsi),%eax
  8002dc:	8d 50 01             	lea    0x1(%rax),%edx
  8002df:	89 16                	mov    %edx,(%rsi)
  8002e1:	48 98                	cltq   
  8002e3:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8002e8:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8002ee:	74 0a                	je     8002fa <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8002f0:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8002f4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  8002fa:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8002fe:	be ff 00 00 00       	mov    $0xff,%esi
  800303:	48 b8 ed 10 80 00 00 	movabs $0x8010ed,%rax
  80030a:	00 00 00 
  80030d:	ff d0                	call   *%rax
        state->offset = 0;
  80030f:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800315:	eb d9                	jmp    8002f0 <putch+0x22>

0000000000800317 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800317:	55                   	push   %rbp
  800318:	48 89 e5             	mov    %rsp,%rbp
  80031b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800322:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800325:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80032c:	b9 21 00 00 00       	mov    $0x21,%ecx
  800331:	b8 00 00 00 00       	mov    $0x0,%eax
  800336:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800339:	48 89 f1             	mov    %rsi,%rcx
  80033c:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800343:	48 bf ce 02 80 00 00 	movabs $0x8002ce,%rdi
  80034a:	00 00 00 
  80034d:	48 b8 cb 04 80 00 00 	movabs $0x8004cb,%rax
  800354:	00 00 00 
  800357:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800359:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800360:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800367:	48 b8 ed 10 80 00 00 	movabs $0x8010ed,%rax
  80036e:	00 00 00 
  800371:	ff d0                	call   *%rax

    return state.count;
}
  800373:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

000000000080037b <cprintf>:

int
cprintf(const char *fmt, ...) {
  80037b:	55                   	push   %rbp
  80037c:	48 89 e5             	mov    %rsp,%rbp
  80037f:	48 83 ec 50          	sub    $0x50,%rsp
  800383:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800387:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80038b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80038f:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800393:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800397:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80039e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003a2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003a6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8003aa:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8003ae:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8003b2:	48 b8 17 03 80 00 00 	movabs $0x800317,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8003be:	c9                   	leave  
  8003bf:	c3                   	ret    

00000000008003c0 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8003c0:	55                   	push   %rbp
  8003c1:	48 89 e5             	mov    %rsp,%rbp
  8003c4:	41 57                	push   %r15
  8003c6:	41 56                	push   %r14
  8003c8:	41 55                	push   %r13
  8003ca:	41 54                	push   %r12
  8003cc:	53                   	push   %rbx
  8003cd:	48 83 ec 18          	sub    $0x18,%rsp
  8003d1:	49 89 fc             	mov    %rdi,%r12
  8003d4:	49 89 f5             	mov    %rsi,%r13
  8003d7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8003db:	8b 45 10             	mov    0x10(%rbp),%eax
  8003de:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8003e1:	41 89 cf             	mov    %ecx,%r15d
  8003e4:	49 39 d7             	cmp    %rdx,%r15
  8003e7:	76 5b                	jbe    800444 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8003e9:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8003ed:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8003f1:	85 db                	test   %ebx,%ebx
  8003f3:	7e 0e                	jle    800403 <print_num+0x43>
            putch(padc, put_arg);
  8003f5:	4c 89 ee             	mov    %r13,%rsi
  8003f8:	44 89 f7             	mov    %r14d,%edi
  8003fb:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8003fe:	83 eb 01             	sub    $0x1,%ebx
  800401:	75 f2                	jne    8003f5 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800403:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800407:	48 b9 fb 2c 80 00 00 	movabs $0x802cfb,%rcx
  80040e:	00 00 00 
  800411:	48 b8 0c 2d 80 00 00 	movabs $0x802d0c,%rax
  800418:	00 00 00 
  80041b:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80041f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800423:	ba 00 00 00 00       	mov    $0x0,%edx
  800428:	49 f7 f7             	div    %r15
  80042b:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80042f:	4c 89 ee             	mov    %r13,%rsi
  800432:	41 ff d4             	call   *%r12
}
  800435:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800439:	5b                   	pop    %rbx
  80043a:	41 5c                	pop    %r12
  80043c:	41 5d                	pop    %r13
  80043e:	41 5e                	pop    %r14
  800440:	41 5f                	pop    %r15
  800442:	5d                   	pop    %rbp
  800443:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800444:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800448:	ba 00 00 00 00       	mov    $0x0,%edx
  80044d:	49 f7 f7             	div    %r15
  800450:	48 83 ec 08          	sub    $0x8,%rsp
  800454:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800458:	52                   	push   %rdx
  800459:	45 0f be c9          	movsbl %r9b,%r9d
  80045d:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800461:	48 89 c2             	mov    %rax,%rdx
  800464:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  80046b:	00 00 00 
  80046e:	ff d0                	call   *%rax
  800470:	48 83 c4 10          	add    $0x10,%rsp
  800474:	eb 8d                	jmp    800403 <print_num+0x43>

0000000000800476 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800476:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80047a:	48 8b 06             	mov    (%rsi),%rax
  80047d:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800481:	73 0a                	jae    80048d <sprintputch+0x17>
        *state->start++ = ch;
  800483:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800487:	48 89 16             	mov    %rdx,(%rsi)
  80048a:	40 88 38             	mov    %dil,(%rax)
    }
}
  80048d:	c3                   	ret    

000000000080048e <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80048e:	55                   	push   %rbp
  80048f:	48 89 e5             	mov    %rsp,%rbp
  800492:	48 83 ec 50          	sub    $0x50,%rsp
  800496:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80049a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80049e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8004a2:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8004a9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004ad:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004b1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004b5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8004b9:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8004bd:	48 b8 cb 04 80 00 00 	movabs $0x8004cb,%rax
  8004c4:	00 00 00 
  8004c7:	ff d0                	call   *%rax
}
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

00000000008004cb <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8004cb:	55                   	push   %rbp
  8004cc:	48 89 e5             	mov    %rsp,%rbp
  8004cf:	41 57                	push   %r15
  8004d1:	41 56                	push   %r14
  8004d3:	41 55                	push   %r13
  8004d5:	41 54                	push   %r12
  8004d7:	53                   	push   %rbx
  8004d8:	48 83 ec 48          	sub    $0x48,%rsp
  8004dc:	49 89 fc             	mov    %rdi,%r12
  8004df:	49 89 f6             	mov    %rsi,%r14
  8004e2:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  8004e5:	48 8b 01             	mov    (%rcx),%rax
  8004e8:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8004ec:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8004f0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004f4:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8004f8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8004fc:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800500:	41 0f b6 3f          	movzbl (%r15),%edi
  800504:	40 80 ff 25          	cmp    $0x25,%dil
  800508:	74 18                	je     800522 <vprintfmt+0x57>
            if (!ch) return;
  80050a:	40 84 ff             	test   %dil,%dil
  80050d:	0f 84 d1 06 00 00    	je     800be4 <vprintfmt+0x719>
            putch(ch, put_arg);
  800513:	40 0f b6 ff          	movzbl %dil,%edi
  800517:	4c 89 f6             	mov    %r14,%rsi
  80051a:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80051d:	49 89 df             	mov    %rbx,%r15
  800520:	eb da                	jmp    8004fc <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800522:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800526:	b9 00 00 00 00       	mov    $0x0,%ecx
  80052b:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80052f:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800534:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80053a:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800541:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800545:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  80054a:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800550:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800554:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800558:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  80055c:	3c 57                	cmp    $0x57,%al
  80055e:	0f 87 65 06 00 00    	ja     800bc9 <vprintfmt+0x6fe>
  800564:	0f b6 c0             	movzbl %al,%eax
  800567:	49 ba a0 2e 80 00 00 	movabs $0x802ea0,%r10
  80056e:	00 00 00 
  800571:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800575:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800578:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  80057c:	eb d2                	jmp    800550 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  80057e:	4c 89 fb             	mov    %r15,%rbx
  800581:	44 89 c1             	mov    %r8d,%ecx
  800584:	eb ca                	jmp    800550 <vprintfmt+0x85>
            padc = ch;
  800586:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  80058a:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80058d:	eb c1                	jmp    800550 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80058f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800592:	83 f8 2f             	cmp    $0x2f,%eax
  800595:	77 24                	ja     8005bb <vprintfmt+0xf0>
  800597:	41 89 c1             	mov    %eax,%r9d
  80059a:	49 01 f1             	add    %rsi,%r9
  80059d:	83 c0 08             	add    $0x8,%eax
  8005a0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005a3:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8005a6:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8005a9:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8005ad:	79 a1                	jns    800550 <vprintfmt+0x85>
                width = precision;
  8005af:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  8005b3:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8005b9:	eb 95                	jmp    800550 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8005bb:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8005bf:	49 8d 41 08          	lea    0x8(%r9),%rax
  8005c3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005c7:	eb da                	jmp    8005a3 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8005c9:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8005cd:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8005d1:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8005d5:	3c 39                	cmp    $0x39,%al
  8005d7:	77 1e                	ja     8005f7 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8005d9:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  8005dd:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  8005e2:	0f b6 c0             	movzbl %al,%eax
  8005e5:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8005ea:	41 0f b6 07          	movzbl (%r15),%eax
  8005ee:	3c 39                	cmp    $0x39,%al
  8005f0:	76 e7                	jbe    8005d9 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  8005f2:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  8005f5:	eb b2                	jmp    8005a9 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  8005f7:	4c 89 fb             	mov    %r15,%rbx
  8005fa:	eb ad                	jmp    8005a9 <vprintfmt+0xde>
            width = MAX(0, width);
  8005fc:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005ff:	85 c0                	test   %eax,%eax
  800601:	0f 48 c7             	cmovs  %edi,%eax
  800604:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800607:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80060a:	e9 41 ff ff ff       	jmp    800550 <vprintfmt+0x85>
            lflag++;
  80060f:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800612:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800615:	e9 36 ff ff ff       	jmp    800550 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  80061a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80061d:	83 f8 2f             	cmp    $0x2f,%eax
  800620:	77 18                	ja     80063a <vprintfmt+0x16f>
  800622:	89 c2                	mov    %eax,%edx
  800624:	48 01 f2             	add    %rsi,%rdx
  800627:	83 c0 08             	add    $0x8,%eax
  80062a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80062d:	4c 89 f6             	mov    %r14,%rsi
  800630:	8b 3a                	mov    (%rdx),%edi
  800632:	41 ff d4             	call   *%r12
            break;
  800635:	e9 c2 fe ff ff       	jmp    8004fc <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  80063a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80063e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800642:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800646:	eb e5                	jmp    80062d <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800648:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80064b:	83 f8 2f             	cmp    $0x2f,%eax
  80064e:	77 5b                	ja     8006ab <vprintfmt+0x1e0>
  800650:	89 c2                	mov    %eax,%edx
  800652:	48 01 d6             	add    %rdx,%rsi
  800655:	83 c0 08             	add    $0x8,%eax
  800658:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80065b:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  80065d:	89 c8                	mov    %ecx,%eax
  80065f:	c1 f8 1f             	sar    $0x1f,%eax
  800662:	31 c1                	xor    %eax,%ecx
  800664:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800666:	83 f9 13             	cmp    $0x13,%ecx
  800669:	7f 4e                	jg     8006b9 <vprintfmt+0x1ee>
  80066b:	48 63 c1             	movslq %ecx,%rax
  80066e:	48 ba 60 31 80 00 00 	movabs $0x803160,%rdx
  800675:	00 00 00 
  800678:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80067c:	48 85 c0             	test   %rax,%rax
  80067f:	74 38                	je     8006b9 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  800681:	48 89 c1             	mov    %rax,%rcx
  800684:	48 ba 99 33 80 00 00 	movabs $0x803399,%rdx
  80068b:	00 00 00 
  80068e:	4c 89 f6             	mov    %r14,%rsi
  800691:	4c 89 e7             	mov    %r12,%rdi
  800694:	b8 00 00 00 00       	mov    $0x0,%eax
  800699:	49 b8 8e 04 80 00 00 	movabs $0x80048e,%r8
  8006a0:	00 00 00 
  8006a3:	41 ff d0             	call   *%r8
  8006a6:	e9 51 fe ff ff       	jmp    8004fc <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8006ab:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006af:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006b3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006b7:	eb a2                	jmp    80065b <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8006b9:	48 ba 24 2d 80 00 00 	movabs $0x802d24,%rdx
  8006c0:	00 00 00 
  8006c3:	4c 89 f6             	mov    %r14,%rsi
  8006c6:	4c 89 e7             	mov    %r12,%rdi
  8006c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ce:	49 b8 8e 04 80 00 00 	movabs $0x80048e,%r8
  8006d5:	00 00 00 
  8006d8:	41 ff d0             	call   *%r8
  8006db:	e9 1c fe ff ff       	jmp    8004fc <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  8006e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006e3:	83 f8 2f             	cmp    $0x2f,%eax
  8006e6:	77 55                	ja     80073d <vprintfmt+0x272>
  8006e8:	89 c2                	mov    %eax,%edx
  8006ea:	48 01 d6             	add    %rdx,%rsi
  8006ed:	83 c0 08             	add    $0x8,%eax
  8006f0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006f3:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  8006f6:	48 85 d2             	test   %rdx,%rdx
  8006f9:	48 b8 1d 2d 80 00 00 	movabs $0x802d1d,%rax
  800700:	00 00 00 
  800703:	48 0f 45 c2          	cmovne %rdx,%rax
  800707:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80070b:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80070f:	7e 06                	jle    800717 <vprintfmt+0x24c>
  800711:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800715:	75 34                	jne    80074b <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800717:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80071b:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80071f:	0f b6 00             	movzbl (%rax),%eax
  800722:	84 c0                	test   %al,%al
  800724:	0f 84 b2 00 00 00    	je     8007dc <vprintfmt+0x311>
  80072a:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80072e:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800733:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800737:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  80073b:	eb 74                	jmp    8007b1 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80073d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800741:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800745:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800749:	eb a8                	jmp    8006f3 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  80074b:	49 63 f5             	movslq %r13d,%rsi
  80074e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  800752:	48 b8 9e 0c 80 00 00 	movabs $0x800c9e,%rax
  800759:	00 00 00 
  80075c:	ff d0                	call   *%rax
  80075e:	48 89 c2             	mov    %rax,%rdx
  800761:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800764:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800766:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800769:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  80076c:	85 c0                	test   %eax,%eax
  80076e:	7e a7                	jle    800717 <vprintfmt+0x24c>
  800770:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800774:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800778:	41 89 cd             	mov    %ecx,%r13d
  80077b:	4c 89 f6             	mov    %r14,%rsi
  80077e:	89 df                	mov    %ebx,%edi
  800780:	41 ff d4             	call   *%r12
  800783:	41 83 ed 01          	sub    $0x1,%r13d
  800787:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  80078b:	75 ee                	jne    80077b <vprintfmt+0x2b0>
  80078d:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800791:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800795:	eb 80                	jmp    800717 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800797:	0f b6 f8             	movzbl %al,%edi
  80079a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80079e:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8007a1:	41 83 ef 01          	sub    $0x1,%r15d
  8007a5:	48 83 c3 01          	add    $0x1,%rbx
  8007a9:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8007ad:	84 c0                	test   %al,%al
  8007af:	74 1f                	je     8007d0 <vprintfmt+0x305>
  8007b1:	45 85 ed             	test   %r13d,%r13d
  8007b4:	78 06                	js     8007bc <vprintfmt+0x2f1>
  8007b6:	41 83 ed 01          	sub    $0x1,%r13d
  8007ba:	78 46                	js     800802 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8007bc:	45 84 f6             	test   %r14b,%r14b
  8007bf:	74 d6                	je     800797 <vprintfmt+0x2cc>
  8007c1:	8d 50 e0             	lea    -0x20(%rax),%edx
  8007c4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8007c9:	80 fa 5e             	cmp    $0x5e,%dl
  8007cc:	77 cc                	ja     80079a <vprintfmt+0x2cf>
  8007ce:	eb c7                	jmp    800797 <vprintfmt+0x2cc>
  8007d0:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8007d4:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8007d8:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  8007dc:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007df:	8d 58 ff             	lea    -0x1(%rax),%ebx
  8007e2:	85 c0                	test   %eax,%eax
  8007e4:	0f 8e 12 fd ff ff    	jle    8004fc <vprintfmt+0x31>
  8007ea:	4c 89 f6             	mov    %r14,%rsi
  8007ed:	bf 20 00 00 00       	mov    $0x20,%edi
  8007f2:	41 ff d4             	call   *%r12
  8007f5:	83 eb 01             	sub    $0x1,%ebx
  8007f8:	83 fb ff             	cmp    $0xffffffff,%ebx
  8007fb:	75 ed                	jne    8007ea <vprintfmt+0x31f>
  8007fd:	e9 fa fc ff ff       	jmp    8004fc <vprintfmt+0x31>
  800802:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800806:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80080a:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80080e:	eb cc                	jmp    8007dc <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800810:	45 89 cd             	mov    %r9d,%r13d
  800813:	84 c9                	test   %cl,%cl
  800815:	75 25                	jne    80083c <vprintfmt+0x371>
    switch (lflag) {
  800817:	85 d2                	test   %edx,%edx
  800819:	74 57                	je     800872 <vprintfmt+0x3a7>
  80081b:	83 fa 01             	cmp    $0x1,%edx
  80081e:	74 78                	je     800898 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800820:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800823:	83 f8 2f             	cmp    $0x2f,%eax
  800826:	0f 87 92 00 00 00    	ja     8008be <vprintfmt+0x3f3>
  80082c:	89 c2                	mov    %eax,%edx
  80082e:	48 01 d6             	add    %rdx,%rsi
  800831:	83 c0 08             	add    $0x8,%eax
  800834:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800837:	48 8b 1e             	mov    (%rsi),%rbx
  80083a:	eb 16                	jmp    800852 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  80083c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80083f:	83 f8 2f             	cmp    $0x2f,%eax
  800842:	77 20                	ja     800864 <vprintfmt+0x399>
  800844:	89 c2                	mov    %eax,%edx
  800846:	48 01 d6             	add    %rdx,%rsi
  800849:	83 c0 08             	add    $0x8,%eax
  80084c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80084f:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800852:	48 85 db             	test   %rbx,%rbx
  800855:	78 78                	js     8008cf <vprintfmt+0x404>
            num = i;
  800857:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  80085a:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80085f:	e9 49 02 00 00       	jmp    800aad <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800864:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800868:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80086c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800870:	eb dd                	jmp    80084f <vprintfmt+0x384>
        return va_arg(*ap, int);
  800872:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800875:	83 f8 2f             	cmp    $0x2f,%eax
  800878:	77 10                	ja     80088a <vprintfmt+0x3bf>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	48 01 d6             	add    %rdx,%rsi
  80087f:	83 c0 08             	add    $0x8,%eax
  800882:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800885:	48 63 1e             	movslq (%rsi),%rbx
  800888:	eb c8                	jmp    800852 <vprintfmt+0x387>
  80088a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80088e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800892:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800896:	eb ed                	jmp    800885 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800898:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089b:	83 f8 2f             	cmp    $0x2f,%eax
  80089e:	77 10                	ja     8008b0 <vprintfmt+0x3e5>
  8008a0:	89 c2                	mov    %eax,%edx
  8008a2:	48 01 d6             	add    %rdx,%rsi
  8008a5:	83 c0 08             	add    $0x8,%eax
  8008a8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008ab:	48 8b 1e             	mov    (%rsi),%rbx
  8008ae:	eb a2                	jmp    800852 <vprintfmt+0x387>
  8008b0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008b4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008b8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008bc:	eb ed                	jmp    8008ab <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  8008be:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008c2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008c6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ca:	e9 68 ff ff ff       	jmp    800837 <vprintfmt+0x36c>
                putch('-', put_arg);
  8008cf:	4c 89 f6             	mov    %r14,%rsi
  8008d2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8008d7:	41 ff d4             	call   *%r12
                i = -i;
  8008da:	48 f7 db             	neg    %rbx
  8008dd:	e9 75 ff ff ff       	jmp    800857 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  8008e2:	45 89 cd             	mov    %r9d,%r13d
  8008e5:	84 c9                	test   %cl,%cl
  8008e7:	75 2d                	jne    800916 <vprintfmt+0x44b>
    switch (lflag) {
  8008e9:	85 d2                	test   %edx,%edx
  8008eb:	74 57                	je     800944 <vprintfmt+0x479>
  8008ed:	83 fa 01             	cmp    $0x1,%edx
  8008f0:	74 7f                	je     800971 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  8008f2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f5:	83 f8 2f             	cmp    $0x2f,%eax
  8008f8:	0f 87 a1 00 00 00    	ja     80099f <vprintfmt+0x4d4>
  8008fe:	89 c2                	mov    %eax,%edx
  800900:	48 01 d6             	add    %rdx,%rsi
  800903:	83 c0 08             	add    $0x8,%eax
  800906:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800909:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80090c:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800911:	e9 97 01 00 00       	jmp    800aad <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800916:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800919:	83 f8 2f             	cmp    $0x2f,%eax
  80091c:	77 18                	ja     800936 <vprintfmt+0x46b>
  80091e:	89 c2                	mov    %eax,%edx
  800920:	48 01 d6             	add    %rdx,%rsi
  800923:	83 c0 08             	add    $0x8,%eax
  800926:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800929:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80092c:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800931:	e9 77 01 00 00       	jmp    800aad <vprintfmt+0x5e2>
  800936:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80093a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80093e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800942:	eb e5                	jmp    800929 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800944:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800947:	83 f8 2f             	cmp    $0x2f,%eax
  80094a:	77 17                	ja     800963 <vprintfmt+0x498>
  80094c:	89 c2                	mov    %eax,%edx
  80094e:	48 01 d6             	add    %rdx,%rsi
  800951:	83 c0 08             	add    $0x8,%eax
  800954:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800957:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800959:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  80095e:	e9 4a 01 00 00       	jmp    800aad <vprintfmt+0x5e2>
  800963:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800967:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80096b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80096f:	eb e6                	jmp    800957 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800971:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800974:	83 f8 2f             	cmp    $0x2f,%eax
  800977:	77 18                	ja     800991 <vprintfmt+0x4c6>
  800979:	89 c2                	mov    %eax,%edx
  80097b:	48 01 d6             	add    %rdx,%rsi
  80097e:	83 c0 08             	add    $0x8,%eax
  800981:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800984:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800987:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80098c:	e9 1c 01 00 00       	jmp    800aad <vprintfmt+0x5e2>
  800991:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800995:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800999:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80099d:	eb e5                	jmp    800984 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  80099f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009a3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009a7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ab:	e9 59 ff ff ff       	jmp    800909 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8009b0:	45 89 cd             	mov    %r9d,%r13d
  8009b3:	84 c9                	test   %cl,%cl
  8009b5:	75 2d                	jne    8009e4 <vprintfmt+0x519>
    switch (lflag) {
  8009b7:	85 d2                	test   %edx,%edx
  8009b9:	74 57                	je     800a12 <vprintfmt+0x547>
  8009bb:	83 fa 01             	cmp    $0x1,%edx
  8009be:	74 7c                	je     800a3c <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8009c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c3:	83 f8 2f             	cmp    $0x2f,%eax
  8009c6:	0f 87 9b 00 00 00    	ja     800a67 <vprintfmt+0x59c>
  8009cc:	89 c2                	mov    %eax,%edx
  8009ce:	48 01 d6             	add    %rdx,%rsi
  8009d1:	83 c0 08             	add    $0x8,%eax
  8009d4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d7:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8009da:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8009df:	e9 c9 00 00 00       	jmp    800aad <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8009e4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e7:	83 f8 2f             	cmp    $0x2f,%eax
  8009ea:	77 18                	ja     800a04 <vprintfmt+0x539>
  8009ec:	89 c2                	mov    %eax,%edx
  8009ee:	48 01 d6             	add    %rdx,%rsi
  8009f1:	83 c0 08             	add    $0x8,%eax
  8009f4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009f7:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8009fa:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009ff:	e9 a9 00 00 00       	jmp    800aad <vprintfmt+0x5e2>
  800a04:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a08:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a0c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a10:	eb e5                	jmp    8009f7 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800a12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a15:	83 f8 2f             	cmp    $0x2f,%eax
  800a18:	77 14                	ja     800a2e <vprintfmt+0x563>
  800a1a:	89 c2                	mov    %eax,%edx
  800a1c:	48 01 d6             	add    %rdx,%rsi
  800a1f:	83 c0 08             	add    $0x8,%eax
  800a22:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a25:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800a27:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800a2c:	eb 7f                	jmp    800aad <vprintfmt+0x5e2>
  800a2e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a32:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a36:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a3a:	eb e9                	jmp    800a25 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800a3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3f:	83 f8 2f             	cmp    $0x2f,%eax
  800a42:	77 15                	ja     800a59 <vprintfmt+0x58e>
  800a44:	89 c2                	mov    %eax,%edx
  800a46:	48 01 d6             	add    %rdx,%rsi
  800a49:	83 c0 08             	add    $0x8,%eax
  800a4c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a4f:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800a52:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800a57:	eb 54                	jmp    800aad <vprintfmt+0x5e2>
  800a59:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a5d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a61:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a65:	eb e8                	jmp    800a4f <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800a67:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a6b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a6f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a73:	e9 5f ff ff ff       	jmp    8009d7 <vprintfmt+0x50c>
            putch('0', put_arg);
  800a78:	45 89 cd             	mov    %r9d,%r13d
  800a7b:	4c 89 f6             	mov    %r14,%rsi
  800a7e:	bf 30 00 00 00       	mov    $0x30,%edi
  800a83:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800a86:	4c 89 f6             	mov    %r14,%rsi
  800a89:	bf 78 00 00 00       	mov    $0x78,%edi
  800a8e:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800a91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a94:	83 f8 2f             	cmp    $0x2f,%eax
  800a97:	77 47                	ja     800ae0 <vprintfmt+0x615>
  800a99:	89 c2                	mov    %eax,%edx
  800a9b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a9f:	83 c0 08             	add    $0x8,%eax
  800aa2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aa5:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800aa8:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800aad:	48 83 ec 08          	sub    $0x8,%rsp
  800ab1:	41 80 fd 58          	cmp    $0x58,%r13b
  800ab5:	0f 94 c0             	sete   %al
  800ab8:	0f b6 c0             	movzbl %al,%eax
  800abb:	50                   	push   %rax
  800abc:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800ac1:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800ac5:	4c 89 f6             	mov    %r14,%rsi
  800ac8:	4c 89 e7             	mov    %r12,%rdi
  800acb:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  800ad2:	00 00 00 
  800ad5:	ff d0                	call   *%rax
            break;
  800ad7:	48 83 c4 10          	add    $0x10,%rsp
  800adb:	e9 1c fa ff ff       	jmp    8004fc <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800ae0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ae8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aec:	eb b7                	jmp    800aa5 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800aee:	45 89 cd             	mov    %r9d,%r13d
  800af1:	84 c9                	test   %cl,%cl
  800af3:	75 2a                	jne    800b1f <vprintfmt+0x654>
    switch (lflag) {
  800af5:	85 d2                	test   %edx,%edx
  800af7:	74 54                	je     800b4d <vprintfmt+0x682>
  800af9:	83 fa 01             	cmp    $0x1,%edx
  800afc:	74 7c                	je     800b7a <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800afe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b01:	83 f8 2f             	cmp    $0x2f,%eax
  800b04:	0f 87 9e 00 00 00    	ja     800ba8 <vprintfmt+0x6dd>
  800b0a:	89 c2                	mov    %eax,%edx
  800b0c:	48 01 d6             	add    %rdx,%rsi
  800b0f:	83 c0 08             	add    $0x8,%eax
  800b12:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b15:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b18:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800b1d:	eb 8e                	jmp    800aad <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b1f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b22:	83 f8 2f             	cmp    $0x2f,%eax
  800b25:	77 18                	ja     800b3f <vprintfmt+0x674>
  800b27:	89 c2                	mov    %eax,%edx
  800b29:	48 01 d6             	add    %rdx,%rsi
  800b2c:	83 c0 08             	add    $0x8,%eax
  800b2f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b32:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b35:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b3a:	e9 6e ff ff ff       	jmp    800aad <vprintfmt+0x5e2>
  800b3f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b43:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b47:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b4b:	eb e5                	jmp    800b32 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800b4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b50:	83 f8 2f             	cmp    $0x2f,%eax
  800b53:	77 17                	ja     800b6c <vprintfmt+0x6a1>
  800b55:	89 c2                	mov    %eax,%edx
  800b57:	48 01 d6             	add    %rdx,%rsi
  800b5a:	83 c0 08             	add    $0x8,%eax
  800b5d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b60:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800b62:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800b67:	e9 41 ff ff ff       	jmp    800aad <vprintfmt+0x5e2>
  800b6c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b70:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b74:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b78:	eb e6                	jmp    800b60 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800b7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7d:	83 f8 2f             	cmp    $0x2f,%eax
  800b80:	77 18                	ja     800b9a <vprintfmt+0x6cf>
  800b82:	89 c2                	mov    %eax,%edx
  800b84:	48 01 d6             	add    %rdx,%rsi
  800b87:	83 c0 08             	add    $0x8,%eax
  800b8a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b8d:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b90:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800b95:	e9 13 ff ff ff       	jmp    800aad <vprintfmt+0x5e2>
  800b9a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b9e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ba2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba6:	eb e5                	jmp    800b8d <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800ba8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bac:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bb0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb4:	e9 5c ff ff ff       	jmp    800b15 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800bb9:	4c 89 f6             	mov    %r14,%rsi
  800bbc:	bf 25 00 00 00       	mov    $0x25,%edi
  800bc1:	41 ff d4             	call   *%r12
            break;
  800bc4:	e9 33 f9 ff ff       	jmp    8004fc <vprintfmt+0x31>
            putch('%', put_arg);
  800bc9:	4c 89 f6             	mov    %r14,%rsi
  800bcc:	bf 25 00 00 00       	mov    $0x25,%edi
  800bd1:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800bd4:	49 83 ef 01          	sub    $0x1,%r15
  800bd8:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800bdd:	75 f5                	jne    800bd4 <vprintfmt+0x709>
  800bdf:	e9 18 f9 ff ff       	jmp    8004fc <vprintfmt+0x31>
}
  800be4:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800be8:	5b                   	pop    %rbx
  800be9:	41 5c                	pop    %r12
  800beb:	41 5d                	pop    %r13
  800bed:	41 5e                	pop    %r14
  800bef:	41 5f                	pop    %r15
  800bf1:	5d                   	pop    %rbp
  800bf2:	c3                   	ret    

0000000000800bf3 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800bf3:	55                   	push   %rbp
  800bf4:	48 89 e5             	mov    %rsp,%rbp
  800bf7:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800bfb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800bff:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800c04:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800c08:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800c0f:	48 85 ff             	test   %rdi,%rdi
  800c12:	74 2b                	je     800c3f <vsnprintf+0x4c>
  800c14:	48 85 f6             	test   %rsi,%rsi
  800c17:	74 26                	je     800c3f <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800c19:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c1d:	48 bf 76 04 80 00 00 	movabs $0x800476,%rdi
  800c24:	00 00 00 
  800c27:	48 b8 cb 04 80 00 00 	movabs $0x8004cb,%rax
  800c2e:	00 00 00 
  800c31:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800c33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c37:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800c3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800c3f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c44:	eb f7                	jmp    800c3d <vsnprintf+0x4a>

0000000000800c46 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800c46:	55                   	push   %rbp
  800c47:	48 89 e5             	mov    %rsp,%rbp
  800c4a:	48 83 ec 50          	sub    $0x50,%rsp
  800c4e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c52:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800c56:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800c5a:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800c61:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c65:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c69:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c6d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800c71:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800c75:	48 b8 f3 0b 80 00 00 	movabs $0x800bf3,%rax
  800c7c:	00 00 00 
  800c7f:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

0000000000800c83 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800c83:	80 3f 00             	cmpb   $0x0,(%rdi)
  800c86:	74 10                	je     800c98 <strlen+0x15>
    size_t n = 0;
  800c88:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800c8d:	48 83 c0 01          	add    $0x1,%rax
  800c91:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c95:	75 f6                	jne    800c8d <strlen+0xa>
  800c97:	c3                   	ret    
    size_t n = 0;
  800c98:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800c9d:	c3                   	ret    

0000000000800c9e <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800c9e:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800ca3:	48 85 f6             	test   %rsi,%rsi
  800ca6:	74 10                	je     800cb8 <strnlen+0x1a>
  800ca8:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800cac:	74 09                	je     800cb7 <strnlen+0x19>
  800cae:	48 83 c0 01          	add    $0x1,%rax
  800cb2:	48 39 c6             	cmp    %rax,%rsi
  800cb5:	75 f1                	jne    800ca8 <strnlen+0xa>
    return n;
}
  800cb7:	c3                   	ret    
    size_t n = 0;
  800cb8:	48 89 f0             	mov    %rsi,%rax
  800cbb:	c3                   	ret    

0000000000800cbc <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800cbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc1:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800cc5:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800cc8:	48 83 c0 01          	add    $0x1,%rax
  800ccc:	84 d2                	test   %dl,%dl
  800cce:	75 f1                	jne    800cc1 <strcpy+0x5>
        ;
    return res;
}
  800cd0:	48 89 f8             	mov    %rdi,%rax
  800cd3:	c3                   	ret    

0000000000800cd4 <strcat>:

char *
strcat(char *dst, const char *src) {
  800cd4:	55                   	push   %rbp
  800cd5:	48 89 e5             	mov    %rsp,%rbp
  800cd8:	41 54                	push   %r12
  800cda:	53                   	push   %rbx
  800cdb:	48 89 fb             	mov    %rdi,%rbx
  800cde:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800ce1:	48 b8 83 0c 80 00 00 	movabs $0x800c83,%rax
  800ce8:	00 00 00 
  800ceb:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800ced:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800cf1:	4c 89 e6             	mov    %r12,%rsi
  800cf4:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  800cfb:	00 00 00 
  800cfe:	ff d0                	call   *%rax
    return dst;
}
  800d00:	48 89 d8             	mov    %rbx,%rax
  800d03:	5b                   	pop    %rbx
  800d04:	41 5c                	pop    %r12
  800d06:	5d                   	pop    %rbp
  800d07:	c3                   	ret    

0000000000800d08 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800d08:	48 85 d2             	test   %rdx,%rdx
  800d0b:	74 1d                	je     800d2a <strncpy+0x22>
  800d0d:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d11:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800d14:	48 83 c0 01          	add    $0x1,%rax
  800d18:	0f b6 16             	movzbl (%rsi),%edx
  800d1b:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800d1e:	80 fa 01             	cmp    $0x1,%dl
  800d21:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800d25:	48 39 c1             	cmp    %rax,%rcx
  800d28:	75 ea                	jne    800d14 <strncpy+0xc>
    }
    return ret;
}
  800d2a:	48 89 f8             	mov    %rdi,%rax
  800d2d:	c3                   	ret    

0000000000800d2e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800d2e:	48 89 f8             	mov    %rdi,%rax
  800d31:	48 85 d2             	test   %rdx,%rdx
  800d34:	74 24                	je     800d5a <strlcpy+0x2c>
        while (--size > 0 && *src)
  800d36:	48 83 ea 01          	sub    $0x1,%rdx
  800d3a:	74 1b                	je     800d57 <strlcpy+0x29>
  800d3c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d40:	0f b6 16             	movzbl (%rsi),%edx
  800d43:	84 d2                	test   %dl,%dl
  800d45:	74 10                	je     800d57 <strlcpy+0x29>
            *dst++ = *src++;
  800d47:	48 83 c6 01          	add    $0x1,%rsi
  800d4b:	48 83 c0 01          	add    $0x1,%rax
  800d4f:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800d52:	48 39 c8             	cmp    %rcx,%rax
  800d55:	75 e9                	jne    800d40 <strlcpy+0x12>
        *dst = '\0';
  800d57:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800d5a:	48 29 f8             	sub    %rdi,%rax
}
  800d5d:	c3                   	ret    

0000000000800d5e <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800d5e:	0f b6 07             	movzbl (%rdi),%eax
  800d61:	84 c0                	test   %al,%al
  800d63:	74 13                	je     800d78 <strcmp+0x1a>
  800d65:	38 06                	cmp    %al,(%rsi)
  800d67:	75 0f                	jne    800d78 <strcmp+0x1a>
  800d69:	48 83 c7 01          	add    $0x1,%rdi
  800d6d:	48 83 c6 01          	add    $0x1,%rsi
  800d71:	0f b6 07             	movzbl (%rdi),%eax
  800d74:	84 c0                	test   %al,%al
  800d76:	75 ed                	jne    800d65 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800d78:	0f b6 c0             	movzbl %al,%eax
  800d7b:	0f b6 16             	movzbl (%rsi),%edx
  800d7e:	29 d0                	sub    %edx,%eax
}
  800d80:	c3                   	ret    

0000000000800d81 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800d81:	48 85 d2             	test   %rdx,%rdx
  800d84:	74 1f                	je     800da5 <strncmp+0x24>
  800d86:	0f b6 07             	movzbl (%rdi),%eax
  800d89:	84 c0                	test   %al,%al
  800d8b:	74 1e                	je     800dab <strncmp+0x2a>
  800d8d:	3a 06                	cmp    (%rsi),%al
  800d8f:	75 1a                	jne    800dab <strncmp+0x2a>
  800d91:	48 83 c7 01          	add    $0x1,%rdi
  800d95:	48 83 c6 01          	add    $0x1,%rsi
  800d99:	48 83 ea 01          	sub    $0x1,%rdx
  800d9d:	75 e7                	jne    800d86 <strncmp+0x5>

    if (!n) return 0;
  800d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800da4:	c3                   	ret    
  800da5:	b8 00 00 00 00       	mov    $0x0,%eax
  800daa:	c3                   	ret    
  800dab:	48 85 d2             	test   %rdx,%rdx
  800dae:	74 09                	je     800db9 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800db0:	0f b6 07             	movzbl (%rdi),%eax
  800db3:	0f b6 16             	movzbl (%rsi),%edx
  800db6:	29 d0                	sub    %edx,%eax
  800db8:	c3                   	ret    
    if (!n) return 0;
  800db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbe:	c3                   	ret    

0000000000800dbf <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800dbf:	0f b6 07             	movzbl (%rdi),%eax
  800dc2:	84 c0                	test   %al,%al
  800dc4:	74 18                	je     800dde <strchr+0x1f>
        if (*str == c) {
  800dc6:	0f be c0             	movsbl %al,%eax
  800dc9:	39 f0                	cmp    %esi,%eax
  800dcb:	74 17                	je     800de4 <strchr+0x25>
    for (; *str; str++) {
  800dcd:	48 83 c7 01          	add    $0x1,%rdi
  800dd1:	0f b6 07             	movzbl (%rdi),%eax
  800dd4:	84 c0                	test   %al,%al
  800dd6:	75 ee                	jne    800dc6 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800dd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddd:	c3                   	ret    
  800dde:	b8 00 00 00 00       	mov    $0x0,%eax
  800de3:	c3                   	ret    
  800de4:	48 89 f8             	mov    %rdi,%rax
}
  800de7:	c3                   	ret    

0000000000800de8 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800de8:	0f b6 07             	movzbl (%rdi),%eax
  800deb:	84 c0                	test   %al,%al
  800ded:	74 16                	je     800e05 <strfind+0x1d>
  800def:	0f be c0             	movsbl %al,%eax
  800df2:	39 f0                	cmp    %esi,%eax
  800df4:	74 13                	je     800e09 <strfind+0x21>
  800df6:	48 83 c7 01          	add    $0x1,%rdi
  800dfa:	0f b6 07             	movzbl (%rdi),%eax
  800dfd:	84 c0                	test   %al,%al
  800dff:	75 ee                	jne    800def <strfind+0x7>
  800e01:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800e04:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800e05:	48 89 f8             	mov    %rdi,%rax
  800e08:	c3                   	ret    
  800e09:	48 89 f8             	mov    %rdi,%rax
  800e0c:	c3                   	ret    

0000000000800e0d <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800e0d:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800e10:	48 89 f8             	mov    %rdi,%rax
  800e13:	48 f7 d8             	neg    %rax
  800e16:	83 e0 07             	and    $0x7,%eax
  800e19:	49 89 d1             	mov    %rdx,%r9
  800e1c:	49 29 c1             	sub    %rax,%r9
  800e1f:	78 32                	js     800e53 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800e21:	40 0f b6 c6          	movzbl %sil,%eax
  800e25:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800e2c:	01 01 01 
  800e2f:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800e33:	40 f6 c7 07          	test   $0x7,%dil
  800e37:	75 34                	jne    800e6d <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800e39:	4c 89 c9             	mov    %r9,%rcx
  800e3c:	48 c1 f9 03          	sar    $0x3,%rcx
  800e40:	74 08                	je     800e4a <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800e42:	fc                   	cld    
  800e43:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800e46:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800e4a:	4d 85 c9             	test   %r9,%r9
  800e4d:	75 45                	jne    800e94 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800e4f:	4c 89 c0             	mov    %r8,%rax
  800e52:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800e53:	48 85 d2             	test   %rdx,%rdx
  800e56:	74 f7                	je     800e4f <memset+0x42>
  800e58:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800e5b:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800e5e:	48 83 c0 01          	add    $0x1,%rax
  800e62:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800e66:	48 39 c2             	cmp    %rax,%rdx
  800e69:	75 f3                	jne    800e5e <memset+0x51>
  800e6b:	eb e2                	jmp    800e4f <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800e6d:	40 f6 c7 01          	test   $0x1,%dil
  800e71:	74 06                	je     800e79 <memset+0x6c>
  800e73:	88 07                	mov    %al,(%rdi)
  800e75:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e79:	40 f6 c7 02          	test   $0x2,%dil
  800e7d:	74 07                	je     800e86 <memset+0x79>
  800e7f:	66 89 07             	mov    %ax,(%rdi)
  800e82:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e86:	40 f6 c7 04          	test   $0x4,%dil
  800e8a:	74 ad                	je     800e39 <memset+0x2c>
  800e8c:	89 07                	mov    %eax,(%rdi)
  800e8e:	48 83 c7 04          	add    $0x4,%rdi
  800e92:	eb a5                	jmp    800e39 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e94:	41 f6 c1 04          	test   $0x4,%r9b
  800e98:	74 06                	je     800ea0 <memset+0x93>
  800e9a:	89 07                	mov    %eax,(%rdi)
  800e9c:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ea0:	41 f6 c1 02          	test   $0x2,%r9b
  800ea4:	74 07                	je     800ead <memset+0xa0>
  800ea6:	66 89 07             	mov    %ax,(%rdi)
  800ea9:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800ead:	41 f6 c1 01          	test   $0x1,%r9b
  800eb1:	74 9c                	je     800e4f <memset+0x42>
  800eb3:	88 07                	mov    %al,(%rdi)
  800eb5:	eb 98                	jmp    800e4f <memset+0x42>

0000000000800eb7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800eb7:	48 89 f8             	mov    %rdi,%rax
  800eba:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800ebd:	48 39 fe             	cmp    %rdi,%rsi
  800ec0:	73 39                	jae    800efb <memmove+0x44>
  800ec2:	48 01 f2             	add    %rsi,%rdx
  800ec5:	48 39 fa             	cmp    %rdi,%rdx
  800ec8:	76 31                	jbe    800efb <memmove+0x44>
        s += n;
        d += n;
  800eca:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800ecd:	48 89 d6             	mov    %rdx,%rsi
  800ed0:	48 09 fe             	or     %rdi,%rsi
  800ed3:	48 09 ce             	or     %rcx,%rsi
  800ed6:	40 f6 c6 07          	test   $0x7,%sil
  800eda:	75 12                	jne    800eee <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800edc:	48 83 ef 08          	sub    $0x8,%rdi
  800ee0:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800ee4:	48 c1 e9 03          	shr    $0x3,%rcx
  800ee8:	fd                   	std    
  800ee9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800eec:	fc                   	cld    
  800eed:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800eee:	48 83 ef 01          	sub    $0x1,%rdi
  800ef2:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800ef6:	fd                   	std    
  800ef7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800ef9:	eb f1                	jmp    800eec <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800efb:	48 89 f2             	mov    %rsi,%rdx
  800efe:	48 09 c2             	or     %rax,%rdx
  800f01:	48 09 ca             	or     %rcx,%rdx
  800f04:	f6 c2 07             	test   $0x7,%dl
  800f07:	75 0c                	jne    800f15 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800f09:	48 c1 e9 03          	shr    $0x3,%rcx
  800f0d:	48 89 c7             	mov    %rax,%rdi
  800f10:	fc                   	cld    
  800f11:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800f14:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800f15:	48 89 c7             	mov    %rax,%rdi
  800f18:	fc                   	cld    
  800f19:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800f1b:	c3                   	ret    

0000000000800f1c <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800f1c:	55                   	push   %rbp
  800f1d:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800f20:	48 b8 b7 0e 80 00 00 	movabs $0x800eb7,%rax
  800f27:	00 00 00 
  800f2a:	ff d0                	call   *%rax
}
  800f2c:	5d                   	pop    %rbp
  800f2d:	c3                   	ret    

0000000000800f2e <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800f2e:	55                   	push   %rbp
  800f2f:	48 89 e5             	mov    %rsp,%rbp
  800f32:	41 57                	push   %r15
  800f34:	41 56                	push   %r14
  800f36:	41 55                	push   %r13
  800f38:	41 54                	push   %r12
  800f3a:	53                   	push   %rbx
  800f3b:	48 83 ec 08          	sub    $0x8,%rsp
  800f3f:	49 89 fe             	mov    %rdi,%r14
  800f42:	49 89 f7             	mov    %rsi,%r15
  800f45:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800f48:	48 89 f7             	mov    %rsi,%rdi
  800f4b:	48 b8 83 0c 80 00 00 	movabs $0x800c83,%rax
  800f52:	00 00 00 
  800f55:	ff d0                	call   *%rax
  800f57:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800f5a:	48 89 de             	mov    %rbx,%rsi
  800f5d:	4c 89 f7             	mov    %r14,%rdi
  800f60:	48 b8 9e 0c 80 00 00 	movabs $0x800c9e,%rax
  800f67:	00 00 00 
  800f6a:	ff d0                	call   *%rax
  800f6c:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800f6f:	48 39 c3             	cmp    %rax,%rbx
  800f72:	74 36                	je     800faa <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800f74:	48 89 d8             	mov    %rbx,%rax
  800f77:	4c 29 e8             	sub    %r13,%rax
  800f7a:	4c 39 e0             	cmp    %r12,%rax
  800f7d:	76 30                	jbe    800faf <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800f7f:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800f84:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f88:	4c 89 fe             	mov    %r15,%rsi
  800f8b:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  800f92:	00 00 00 
  800f95:	ff d0                	call   *%rax
    return dstlen + srclen;
  800f97:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800f9b:	48 83 c4 08          	add    $0x8,%rsp
  800f9f:	5b                   	pop    %rbx
  800fa0:	41 5c                	pop    %r12
  800fa2:	41 5d                	pop    %r13
  800fa4:	41 5e                	pop    %r14
  800fa6:	41 5f                	pop    %r15
  800fa8:	5d                   	pop    %rbp
  800fa9:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800faa:	4c 01 e0             	add    %r12,%rax
  800fad:	eb ec                	jmp    800f9b <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800faf:	48 83 eb 01          	sub    $0x1,%rbx
  800fb3:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800fb7:	48 89 da             	mov    %rbx,%rdx
  800fba:	4c 89 fe             	mov    %r15,%rsi
  800fbd:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  800fc4:	00 00 00 
  800fc7:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800fc9:	49 01 de             	add    %rbx,%r14
  800fcc:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800fd1:	eb c4                	jmp    800f97 <strlcat+0x69>

0000000000800fd3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800fd3:	49 89 f0             	mov    %rsi,%r8
  800fd6:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800fd9:	48 85 d2             	test   %rdx,%rdx
  800fdc:	74 2a                	je     801008 <memcmp+0x35>
  800fde:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800fe3:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800fe7:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800fec:	38 ca                	cmp    %cl,%dl
  800fee:	75 0f                	jne    800fff <memcmp+0x2c>
    while (n-- > 0) {
  800ff0:	48 83 c0 01          	add    $0x1,%rax
  800ff4:	48 39 c6             	cmp    %rax,%rsi
  800ff7:	75 ea                	jne    800fe3 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffe:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800fff:	0f b6 c2             	movzbl %dl,%eax
  801002:	0f b6 c9             	movzbl %cl,%ecx
  801005:	29 c8                	sub    %ecx,%eax
  801007:	c3                   	ret    
    return 0;
  801008:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100d:	c3                   	ret    

000000000080100e <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80100e:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801012:	48 39 c7             	cmp    %rax,%rdi
  801015:	73 0f                	jae    801026 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801017:	40 38 37             	cmp    %sil,(%rdi)
  80101a:	74 0e                	je     80102a <memfind+0x1c>
    for (; src < end; src++) {
  80101c:	48 83 c7 01          	add    $0x1,%rdi
  801020:	48 39 f8             	cmp    %rdi,%rax
  801023:	75 f2                	jne    801017 <memfind+0x9>
  801025:	c3                   	ret    
  801026:	48 89 f8             	mov    %rdi,%rax
  801029:	c3                   	ret    
  80102a:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80102d:	c3                   	ret    

000000000080102e <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80102e:	49 89 f2             	mov    %rsi,%r10
  801031:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801034:	0f b6 37             	movzbl (%rdi),%esi
  801037:	40 80 fe 20          	cmp    $0x20,%sil
  80103b:	74 06                	je     801043 <strtol+0x15>
  80103d:	40 80 fe 09          	cmp    $0x9,%sil
  801041:	75 13                	jne    801056 <strtol+0x28>
  801043:	48 83 c7 01          	add    $0x1,%rdi
  801047:	0f b6 37             	movzbl (%rdi),%esi
  80104a:	40 80 fe 20          	cmp    $0x20,%sil
  80104e:	74 f3                	je     801043 <strtol+0x15>
  801050:	40 80 fe 09          	cmp    $0x9,%sil
  801054:	74 ed                	je     801043 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801056:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801059:	83 e0 fd             	and    $0xfffffffd,%eax
  80105c:	3c 01                	cmp    $0x1,%al
  80105e:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801062:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801069:	75 11                	jne    80107c <strtol+0x4e>
  80106b:	80 3f 30             	cmpb   $0x30,(%rdi)
  80106e:	74 16                	je     801086 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801070:	45 85 c0             	test   %r8d,%r8d
  801073:	b8 0a 00 00 00       	mov    $0xa,%eax
  801078:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  80107c:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801081:	4d 63 c8             	movslq %r8d,%r9
  801084:	eb 38                	jmp    8010be <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801086:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80108a:	74 11                	je     80109d <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  80108c:	45 85 c0             	test   %r8d,%r8d
  80108f:	75 eb                	jne    80107c <strtol+0x4e>
        s++;
  801091:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801095:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  80109b:	eb df                	jmp    80107c <strtol+0x4e>
        s += 2;
  80109d:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8010a1:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8010a7:	eb d3                	jmp    80107c <strtol+0x4e>
            dig -= '0';
  8010a9:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8010ac:	0f b6 c8             	movzbl %al,%ecx
  8010af:	44 39 c1             	cmp    %r8d,%ecx
  8010b2:	7d 1f                	jge    8010d3 <strtol+0xa5>
        val = val * base + dig;
  8010b4:	49 0f af d1          	imul   %r9,%rdx
  8010b8:	0f b6 c0             	movzbl %al,%eax
  8010bb:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8010be:	48 83 c7 01          	add    $0x1,%rdi
  8010c2:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8010c6:	3c 39                	cmp    $0x39,%al
  8010c8:	76 df                	jbe    8010a9 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8010ca:	3c 7b                	cmp    $0x7b,%al
  8010cc:	77 05                	ja     8010d3 <strtol+0xa5>
            dig -= 'a' - 10;
  8010ce:	83 e8 57             	sub    $0x57,%eax
  8010d1:	eb d9                	jmp    8010ac <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8010d3:	4d 85 d2             	test   %r10,%r10
  8010d6:	74 03                	je     8010db <strtol+0xad>
  8010d8:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8010db:	48 89 d0             	mov    %rdx,%rax
  8010de:	48 f7 d8             	neg    %rax
  8010e1:	40 80 fe 2d          	cmp    $0x2d,%sil
  8010e5:	48 0f 44 d0          	cmove  %rax,%rdx
}
  8010e9:	48 89 d0             	mov    %rdx,%rax
  8010ec:	c3                   	ret    

00000000008010ed <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8010ed:	55                   	push   %rbp
  8010ee:	48 89 e5             	mov    %rsp,%rbp
  8010f1:	53                   	push   %rbx
  8010f2:	48 89 fa             	mov    %rdi,%rdx
  8010f5:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010f8:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801102:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801107:	be 00 00 00 00       	mov    $0x0,%esi
  80110c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801112:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801114:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801118:	c9                   	leave  
  801119:	c3                   	ret    

000000000080111a <sys_cgetc>:

int
sys_cgetc(void) {
  80111a:	55                   	push   %rbp
  80111b:	48 89 e5             	mov    %rsp,%rbp
  80111e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80111f:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801124:	ba 00 00 00 00       	mov    $0x0,%edx
  801129:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80112e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801133:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801138:	be 00 00 00 00       	mov    $0x0,%esi
  80113d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801143:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801145:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

000000000080114b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80114b:	55                   	push   %rbp
  80114c:	48 89 e5             	mov    %rsp,%rbp
  80114f:	53                   	push   %rbx
  801150:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801154:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801157:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80115c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801161:	bb 00 00 00 00       	mov    $0x0,%ebx
  801166:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80116b:	be 00 00 00 00       	mov    $0x0,%esi
  801170:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801176:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801178:	48 85 c0             	test   %rax,%rax
  80117b:	7f 06                	jg     801183 <sys_env_destroy+0x38>
}
  80117d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801181:	c9                   	leave  
  801182:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801183:	49 89 c0             	mov    %rax,%r8
  801186:	b9 03 00 00 00       	mov    $0x3,%ecx
  80118b:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  801192:	00 00 00 
  801195:	be 26 00 00 00       	mov    $0x26,%esi
  80119a:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  8011a1:	00 00 00 
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a9:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  8011b0:	00 00 00 
  8011b3:	41 ff d1             	call   *%r9

00000000008011b6 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8011b6:	55                   	push   %rbp
  8011b7:	48 89 e5             	mov    %rsp,%rbp
  8011ba:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011bb:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011cf:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011d4:	be 00 00 00 00       	mov    $0x0,%esi
  8011d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011df:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8011e1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011e5:	c9                   	leave  
  8011e6:	c3                   	ret    

00000000008011e7 <sys_yield>:

void
sys_yield(void) {
  8011e7:	55                   	push   %rbp
  8011e8:	48 89 e5             	mov    %rsp,%rbp
  8011eb:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011ec:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8011f6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801200:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801205:	be 00 00 00 00       	mov    $0x0,%esi
  80120a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801210:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801212:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801216:	c9                   	leave  
  801217:	c3                   	ret    

0000000000801218 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801218:	55                   	push   %rbp
  801219:	48 89 e5             	mov    %rsp,%rbp
  80121c:	53                   	push   %rbx
  80121d:	48 89 fa             	mov    %rdi,%rdx
  801220:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801223:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801228:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80122f:	00 00 00 
  801232:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801237:	be 00 00 00 00       	mov    $0x0,%esi
  80123c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801242:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801244:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801248:	c9                   	leave  
  801249:	c3                   	ret    

000000000080124a <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80124a:	55                   	push   %rbp
  80124b:	48 89 e5             	mov    %rsp,%rbp
  80124e:	53                   	push   %rbx
  80124f:	49 89 f8             	mov    %rdi,%r8
  801252:	48 89 d3             	mov    %rdx,%rbx
  801255:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801258:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80125d:	4c 89 c2             	mov    %r8,%rdx
  801260:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801263:	be 00 00 00 00       	mov    $0x0,%esi
  801268:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80126e:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801270:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801274:	c9                   	leave  
  801275:	c3                   	ret    

0000000000801276 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801276:	55                   	push   %rbp
  801277:	48 89 e5             	mov    %rsp,%rbp
  80127a:	53                   	push   %rbx
  80127b:	48 83 ec 08          	sub    $0x8,%rsp
  80127f:	89 f8                	mov    %edi,%eax
  801281:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801284:	48 63 f9             	movslq %ecx,%rdi
  801287:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80128a:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80128f:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801292:	be 00 00 00 00       	mov    $0x0,%esi
  801297:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80129d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80129f:	48 85 c0             	test   %rax,%rax
  8012a2:	7f 06                	jg     8012aa <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8012a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012aa:	49 89 c0             	mov    %rax,%r8
  8012ad:	b9 04 00 00 00       	mov    $0x4,%ecx
  8012b2:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  8012b9:	00 00 00 
  8012bc:	be 26 00 00 00       	mov    $0x26,%esi
  8012c1:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  8012c8:	00 00 00 
  8012cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d0:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  8012d7:	00 00 00 
  8012da:	41 ff d1             	call   *%r9

00000000008012dd <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8012dd:	55                   	push   %rbp
  8012de:	48 89 e5             	mov    %rsp,%rbp
  8012e1:	53                   	push   %rbx
  8012e2:	48 83 ec 08          	sub    $0x8,%rsp
  8012e6:	89 f8                	mov    %edi,%eax
  8012e8:	49 89 f2             	mov    %rsi,%r10
  8012eb:	48 89 cf             	mov    %rcx,%rdi
  8012ee:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8012f1:	48 63 da             	movslq %edx,%rbx
  8012f4:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012f7:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012fc:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012ff:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801302:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801304:	48 85 c0             	test   %rax,%rax
  801307:	7f 06                	jg     80130f <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801309:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80130f:	49 89 c0             	mov    %rax,%r8
  801312:	b9 05 00 00 00       	mov    $0x5,%ecx
  801317:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  80131e:	00 00 00 
  801321:	be 26 00 00 00       	mov    $0x26,%esi
  801326:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  80132d:	00 00 00 
  801330:	b8 00 00 00 00       	mov    $0x0,%eax
  801335:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  80133c:	00 00 00 
  80133f:	41 ff d1             	call   *%r9

0000000000801342 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801342:	55                   	push   %rbp
  801343:	48 89 e5             	mov    %rsp,%rbp
  801346:	53                   	push   %rbx
  801347:	48 83 ec 08          	sub    $0x8,%rsp
  80134b:	48 89 f1             	mov    %rsi,%rcx
  80134e:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801351:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801354:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801359:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80135e:	be 00 00 00 00       	mov    $0x0,%esi
  801363:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801369:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80136b:	48 85 c0             	test   %rax,%rax
  80136e:	7f 06                	jg     801376 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801370:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801374:	c9                   	leave  
  801375:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801376:	49 89 c0             	mov    %rax,%r8
  801379:	b9 06 00 00 00       	mov    $0x6,%ecx
  80137e:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  801385:	00 00 00 
  801388:	be 26 00 00 00       	mov    $0x26,%esi
  80138d:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  801394:	00 00 00 
  801397:	b8 00 00 00 00       	mov    $0x0,%eax
  80139c:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  8013a3:	00 00 00 
  8013a6:	41 ff d1             	call   *%r9

00000000008013a9 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8013a9:	55                   	push   %rbp
  8013aa:	48 89 e5             	mov    %rsp,%rbp
  8013ad:	53                   	push   %rbx
  8013ae:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8013b2:	48 63 ce             	movslq %esi,%rcx
  8013b5:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013b8:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013c7:	be 00 00 00 00       	mov    $0x0,%esi
  8013cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013d2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013d4:	48 85 c0             	test   %rax,%rax
  8013d7:	7f 06                	jg     8013df <sys_env_set_status+0x36>
}
  8013d9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013df:	49 89 c0             	mov    %rax,%r8
  8013e2:	b9 09 00 00 00       	mov    $0x9,%ecx
  8013e7:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  8013ee:	00 00 00 
  8013f1:	be 26 00 00 00       	mov    $0x26,%esi
  8013f6:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  8013fd:	00 00 00 
  801400:	b8 00 00 00 00       	mov    $0x0,%eax
  801405:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  80140c:	00 00 00 
  80140f:	41 ff d1             	call   *%r9

0000000000801412 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801412:	55                   	push   %rbp
  801413:	48 89 e5             	mov    %rsp,%rbp
  801416:	53                   	push   %rbx
  801417:	48 83 ec 08          	sub    $0x8,%rsp
  80141b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80141e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801421:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801430:	be 00 00 00 00       	mov    $0x0,%esi
  801435:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80143b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80143d:	48 85 c0             	test   %rax,%rax
  801440:	7f 06                	jg     801448 <sys_env_set_trapframe+0x36>
}
  801442:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801446:	c9                   	leave  
  801447:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801448:	49 89 c0             	mov    %rax,%r8
  80144b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801450:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  801457:	00 00 00 
  80145a:	be 26 00 00 00       	mov    $0x26,%esi
  80145f:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  801466:	00 00 00 
  801469:	b8 00 00 00 00       	mov    $0x0,%eax
  80146e:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  801475:	00 00 00 
  801478:	41 ff d1             	call   *%r9

000000000080147b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80147b:	55                   	push   %rbp
  80147c:	48 89 e5             	mov    %rsp,%rbp
  80147f:	53                   	push   %rbx
  801480:	48 83 ec 08          	sub    $0x8,%rsp
  801484:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801487:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80148a:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80148f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801494:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801499:	be 00 00 00 00       	mov    $0x0,%esi
  80149e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014a4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014a6:	48 85 c0             	test   %rax,%rax
  8014a9:	7f 06                	jg     8014b1 <sys_env_set_pgfault_upcall+0x36>
}
  8014ab:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014b1:	49 89 c0             	mov    %rax,%r8
  8014b4:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8014b9:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  8014c0:	00 00 00 
  8014c3:	be 26 00 00 00       	mov    $0x26,%esi
  8014c8:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  8014cf:	00 00 00 
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  8014de:	00 00 00 
  8014e1:	41 ff d1             	call   *%r9

00000000008014e4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8014e4:	55                   	push   %rbp
  8014e5:	48 89 e5             	mov    %rsp,%rbp
  8014e8:	53                   	push   %rbx
  8014e9:	89 f8                	mov    %edi,%eax
  8014eb:	49 89 f1             	mov    %rsi,%r9
  8014ee:	48 89 d3             	mov    %rdx,%rbx
  8014f1:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8014f4:	49 63 f0             	movslq %r8d,%rsi
  8014f7:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014fa:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014ff:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801502:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801508:	cd 30                	int    $0x30
}
  80150a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

0000000000801510 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801510:	55                   	push   %rbp
  801511:	48 89 e5             	mov    %rsp,%rbp
  801514:	53                   	push   %rbx
  801515:	48 83 ec 08          	sub    $0x8,%rsp
  801519:	48 89 fa             	mov    %rdi,%rdx
  80151c:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80151f:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801524:	bb 00 00 00 00       	mov    $0x0,%ebx
  801529:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80152e:	be 00 00 00 00       	mov    $0x0,%esi
  801533:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801539:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80153b:	48 85 c0             	test   %rax,%rax
  80153e:	7f 06                	jg     801546 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801540:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801544:	c9                   	leave  
  801545:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801546:	49 89 c0             	mov    %rax,%r8
  801549:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80154e:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  801555:	00 00 00 
  801558:	be 26 00 00 00       	mov    $0x26,%esi
  80155d:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  801564:	00 00 00 
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
  80156c:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  801573:	00 00 00 
  801576:	41 ff d1             	call   *%r9

0000000000801579 <sys_gettime>:

int
sys_gettime(void) {
  801579:	55                   	push   %rbp
  80157a:	48 89 e5             	mov    %rsp,%rbp
  80157d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80157e:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801583:	ba 00 00 00 00       	mov    $0x0,%edx
  801588:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80158d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801592:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801597:	be 00 00 00 00       	mov    $0x0,%esi
  80159c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015a2:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8015a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

00000000008015aa <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8015aa:	55                   	push   %rbp
  8015ab:	48 89 e5             	mov    %rsp,%rbp
  8015ae:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015af:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015c3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015c8:	be 00 00 00 00       	mov    $0x0,%esi
  8015cd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015d3:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8015d5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

00000000008015db <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8015db:	55                   	push   %rbp
  8015dc:	48 89 e5             	mov    %rsp,%rbp
  8015df:	53                   	push   %rbx
  8015e0:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8015e4:	b8 08 00 00 00       	mov    $0x8,%eax
  8015e9:	cd 30                	int    $0x30
  8015eb:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	0f 88 85 00 00 00    	js     80167a <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  8015f5:	0f 84 ac 00 00 00    	je     8016a7 <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  8015fb:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  801601:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801608:	00 00 00 
  80160b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801610:	89 c2                	mov    %eax,%edx
  801612:	be 00 00 00 00       	mov    $0x0,%esi
  801617:	bf 00 00 00 00       	mov    $0x0,%edi
  80161c:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  801623:	00 00 00 
  801626:	ff d0                	call   *%rax
    if (res < 0)
  801628:	85 c0                	test   %eax,%eax
  80162a:	0f 88 ad 00 00 00    	js     8016dd <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801630:	be 02 00 00 00       	mov    $0x2,%esi
  801635:	89 df                	mov    %ebx,%edi
  801637:	48 b8 a9 13 80 00 00 	movabs $0x8013a9,%rax
  80163e:	00 00 00 
  801641:	ff d0                	call   *%rax
    if (res < 0)
  801643:	85 c0                	test   %eax,%eax
  801645:	0f 88 bf 00 00 00    	js     80170a <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  80164b:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801652:	00 00 00 
  801655:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  80165c:	89 df                	mov    %ebx,%edi
  80165e:	48 b8 7b 14 80 00 00 	movabs $0x80147b,%rax
  801665:	00 00 00 
  801668:	ff d0                	call   *%rax
    if (res < 0)
  80166a:	85 c0                	test   %eax,%eax
  80166c:	0f 88 c5 00 00 00    	js     801737 <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  801672:	89 d8                	mov    %ebx,%eax
  801674:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801678:	c9                   	leave  
  801679:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  80167a:	89 c1                	mov    %eax,%ecx
  80167c:	48 ba 4d 32 80 00 00 	movabs $0x80324d,%rdx
  801683:	00 00 00 
  801686:	be 1a 00 00 00       	mov    $0x1a,%esi
  80168b:	48 bf 5d 32 80 00 00 	movabs $0x80325d,%rdi
  801692:	00 00 00 
  801695:	b8 00 00 00 00       	mov    $0x0,%eax
  80169a:	49 b8 2b 02 80 00 00 	movabs $0x80022b,%r8
  8016a1:	00 00 00 
  8016a4:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  8016a7:	48 b8 b6 11 80 00 00 	movabs $0x8011b6,%rax
  8016ae:	00 00 00 
  8016b1:	ff d0                	call   *%rax
  8016b3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016b8:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8016bc:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8016c0:	48 c1 e0 04          	shl    $0x4,%rax
  8016c4:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8016cb:	00 00 00 
  8016ce:	48 01 d0             	add    %rdx,%rax
  8016d1:	48 a3 08 50 80 00 00 	movabs %rax,0x805008
  8016d8:	00 00 00 
        return 0;
  8016db:	eb 95                	jmp    801672 <fork+0x97>
        panic("sys_map_region: %i", res);
  8016dd:	89 c1                	mov    %eax,%ecx
  8016df:	48 ba 68 32 80 00 00 	movabs $0x803268,%rdx
  8016e6:	00 00 00 
  8016e9:	be 22 00 00 00       	mov    $0x22,%esi
  8016ee:	48 bf 5d 32 80 00 00 	movabs $0x80325d,%rdi
  8016f5:	00 00 00 
  8016f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fd:	49 b8 2b 02 80 00 00 	movabs $0x80022b,%r8
  801704:	00 00 00 
  801707:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  80170a:	89 c1                	mov    %eax,%ecx
  80170c:	48 ba 7b 32 80 00 00 	movabs $0x80327b,%rdx
  801713:	00 00 00 
  801716:	be 25 00 00 00       	mov    $0x25,%esi
  80171b:	48 bf 5d 32 80 00 00 	movabs $0x80325d,%rdi
  801722:	00 00 00 
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
  80172a:	49 b8 2b 02 80 00 00 	movabs $0x80022b,%r8
  801731:	00 00 00 
  801734:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  801737:	89 c1                	mov    %eax,%ecx
  801739:	48 ba b0 32 80 00 00 	movabs $0x8032b0,%rdx
  801740:	00 00 00 
  801743:	be 28 00 00 00       	mov    $0x28,%esi
  801748:	48 bf 5d 32 80 00 00 	movabs $0x80325d,%rdi
  80174f:	00 00 00 
  801752:	b8 00 00 00 00       	mov    $0x0,%eax
  801757:	49 b8 2b 02 80 00 00 	movabs $0x80022b,%r8
  80175e:	00 00 00 
  801761:	41 ff d0             	call   *%r8

0000000000801764 <sfork>:

envid_t
sfork() {
  801764:	55                   	push   %rbp
  801765:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801768:	48 ba 92 32 80 00 00 	movabs $0x803292,%rdx
  80176f:	00 00 00 
  801772:	be 2f 00 00 00       	mov    $0x2f,%esi
  801777:	48 bf 5d 32 80 00 00 	movabs $0x80325d,%rdi
  80177e:	00 00 00 
  801781:	b8 00 00 00 00       	mov    $0x0,%eax
  801786:	48 b9 2b 02 80 00 00 	movabs $0x80022b,%rcx
  80178d:	00 00 00 
  801790:	ff d1                	call   *%rcx

0000000000801792 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801792:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801799:	ff ff ff 
  80179c:	48 01 f8             	add    %rdi,%rax
  80179f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8017a3:	c3                   	ret    

00000000008017a4 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8017a4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8017ab:	ff ff ff 
  8017ae:	48 01 f8             	add    %rdi,%rax
  8017b1:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8017b5:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8017bb:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8017bf:	c3                   	ret    

00000000008017c0 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8017c0:	55                   	push   %rbp
  8017c1:	48 89 e5             	mov    %rsp,%rbp
  8017c4:	41 57                	push   %r15
  8017c6:	41 56                	push   %r14
  8017c8:	41 55                	push   %r13
  8017ca:	41 54                	push   %r12
  8017cc:	53                   	push   %rbx
  8017cd:	48 83 ec 08          	sub    $0x8,%rsp
  8017d1:	49 89 ff             	mov    %rdi,%r15
  8017d4:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8017d9:	49 bc 6e 27 80 00 00 	movabs $0x80276e,%r12
  8017e0:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8017e3:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8017e9:	48 89 df             	mov    %rbx,%rdi
  8017ec:	41 ff d4             	call   *%r12
  8017ef:	83 e0 04             	and    $0x4,%eax
  8017f2:	74 1a                	je     80180e <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8017f4:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8017fb:	4c 39 f3             	cmp    %r14,%rbx
  8017fe:	75 e9                	jne    8017e9 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801800:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801807:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80180c:	eb 03                	jmp    801811 <fd_alloc+0x51>
            *fd_store = fd;
  80180e:	49 89 1f             	mov    %rbx,(%r15)
}
  801811:	48 83 c4 08          	add    $0x8,%rsp
  801815:	5b                   	pop    %rbx
  801816:	41 5c                	pop    %r12
  801818:	41 5d                	pop    %r13
  80181a:	41 5e                	pop    %r14
  80181c:	41 5f                	pop    %r15
  80181e:	5d                   	pop    %rbp
  80181f:	c3                   	ret    

0000000000801820 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801820:	83 ff 1f             	cmp    $0x1f,%edi
  801823:	77 39                	ja     80185e <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801825:	55                   	push   %rbp
  801826:	48 89 e5             	mov    %rsp,%rbp
  801829:	41 54                	push   %r12
  80182b:	53                   	push   %rbx
  80182c:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80182f:	48 63 df             	movslq %edi,%rbx
  801832:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801839:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  80183d:	48 89 df             	mov    %rbx,%rdi
  801840:	48 b8 6e 27 80 00 00 	movabs $0x80276e,%rax
  801847:	00 00 00 
  80184a:	ff d0                	call   *%rax
  80184c:	a8 04                	test   $0x4,%al
  80184e:	74 14                	je     801864 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801850:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801854:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801859:	5b                   	pop    %rbx
  80185a:	41 5c                	pop    %r12
  80185c:	5d                   	pop    %rbp
  80185d:	c3                   	ret    
        return -E_INVAL;
  80185e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801863:	c3                   	ret    
        return -E_INVAL;
  801864:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801869:	eb ee                	jmp    801859 <fd_lookup+0x39>

000000000080186b <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80186b:	55                   	push   %rbp
  80186c:	48 89 e5             	mov    %rsp,%rbp
  80186f:	53                   	push   %rbx
  801870:	48 83 ec 08          	sub    $0x8,%rsp
  801874:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801877:	48 ba 60 33 80 00 00 	movabs $0x803360,%rdx
  80187e:	00 00 00 
  801881:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801888:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  80188b:	39 38                	cmp    %edi,(%rax)
  80188d:	74 4b                	je     8018da <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  80188f:	48 83 c2 08          	add    $0x8,%rdx
  801893:	48 8b 02             	mov    (%rdx),%rax
  801896:	48 85 c0             	test   %rax,%rax
  801899:	75 f0                	jne    80188b <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80189b:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  8018a2:	00 00 00 
  8018a5:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8018ab:	89 fa                	mov    %edi,%edx
  8018ad:	48 bf d0 32 80 00 00 	movabs $0x8032d0,%rdi
  8018b4:	00 00 00 
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bc:	48 b9 7b 03 80 00 00 	movabs $0x80037b,%rcx
  8018c3:	00 00 00 
  8018c6:	ff d1                	call   *%rcx
    *dev = 0;
  8018c8:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  8018cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018d4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    
            *dev = devtab[i];
  8018da:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  8018dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e2:	eb f0                	jmp    8018d4 <dev_lookup+0x69>

00000000008018e4 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8018e4:	55                   	push   %rbp
  8018e5:	48 89 e5             	mov    %rsp,%rbp
  8018e8:	41 55                	push   %r13
  8018ea:	41 54                	push   %r12
  8018ec:	53                   	push   %rbx
  8018ed:	48 83 ec 18          	sub    $0x18,%rsp
  8018f1:	49 89 fc             	mov    %rdi,%r12
  8018f4:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8018f7:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8018fe:	ff ff ff 
  801901:	4c 01 e7             	add    %r12,%rdi
  801904:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801908:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80190c:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801913:	00 00 00 
  801916:	ff d0                	call   *%rax
  801918:	89 c3                	mov    %eax,%ebx
  80191a:	85 c0                	test   %eax,%eax
  80191c:	78 06                	js     801924 <fd_close+0x40>
  80191e:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801922:	74 18                	je     80193c <fd_close+0x58>
        return (must_exist ? res : 0);
  801924:	45 84 ed             	test   %r13b,%r13b
  801927:	b8 00 00 00 00       	mov    $0x0,%eax
  80192c:	0f 44 d8             	cmove  %eax,%ebx
}
  80192f:	89 d8                	mov    %ebx,%eax
  801931:	48 83 c4 18          	add    $0x18,%rsp
  801935:	5b                   	pop    %rbx
  801936:	41 5c                	pop    %r12
  801938:	41 5d                	pop    %r13
  80193a:	5d                   	pop    %rbp
  80193b:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80193c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801940:	41 8b 3c 24          	mov    (%r12),%edi
  801944:	48 b8 6b 18 80 00 00 	movabs $0x80186b,%rax
  80194b:	00 00 00 
  80194e:	ff d0                	call   *%rax
  801950:	89 c3                	mov    %eax,%ebx
  801952:	85 c0                	test   %eax,%eax
  801954:	78 19                	js     80196f <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801956:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80195a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80195e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801963:	48 85 c0             	test   %rax,%rax
  801966:	74 07                	je     80196f <fd_close+0x8b>
  801968:	4c 89 e7             	mov    %r12,%rdi
  80196b:	ff d0                	call   *%rax
  80196d:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80196f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801974:	4c 89 e6             	mov    %r12,%rsi
  801977:	bf 00 00 00 00       	mov    $0x0,%edi
  80197c:	48 b8 42 13 80 00 00 	movabs $0x801342,%rax
  801983:	00 00 00 
  801986:	ff d0                	call   *%rax
    return res;
  801988:	eb a5                	jmp    80192f <fd_close+0x4b>

000000000080198a <close>:

int
close(int fdnum) {
  80198a:	55                   	push   %rbp
  80198b:	48 89 e5             	mov    %rsp,%rbp
  80198e:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801992:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801996:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  80199d:	00 00 00 
  8019a0:	ff d0                	call   *%rax
    if (res < 0) return res;
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	78 15                	js     8019bb <close+0x31>

    return fd_close(fd, 1);
  8019a6:	be 01 00 00 00       	mov    $0x1,%esi
  8019ab:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8019af:	48 b8 e4 18 80 00 00 	movabs $0x8018e4,%rax
  8019b6:	00 00 00 
  8019b9:	ff d0                	call   *%rax
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

00000000008019bd <close_all>:

void
close_all(void) {
  8019bd:	55                   	push   %rbp
  8019be:	48 89 e5             	mov    %rsp,%rbp
  8019c1:	41 54                	push   %r12
  8019c3:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8019c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019c9:	49 bc 8a 19 80 00 00 	movabs $0x80198a,%r12
  8019d0:	00 00 00 
  8019d3:	89 df                	mov    %ebx,%edi
  8019d5:	41 ff d4             	call   *%r12
  8019d8:	83 c3 01             	add    $0x1,%ebx
  8019db:	83 fb 20             	cmp    $0x20,%ebx
  8019de:	75 f3                	jne    8019d3 <close_all+0x16>
}
  8019e0:	5b                   	pop    %rbx
  8019e1:	41 5c                	pop    %r12
  8019e3:	5d                   	pop    %rbp
  8019e4:	c3                   	ret    

00000000008019e5 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8019e5:	55                   	push   %rbp
  8019e6:	48 89 e5             	mov    %rsp,%rbp
  8019e9:	41 56                	push   %r14
  8019eb:	41 55                	push   %r13
  8019ed:	41 54                	push   %r12
  8019ef:	53                   	push   %rbx
  8019f0:	48 83 ec 10          	sub    $0x10,%rsp
  8019f4:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8019f7:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019fb:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801a02:	00 00 00 
  801a05:	ff d0                	call   *%rax
  801a07:	89 c3                	mov    %eax,%ebx
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	0f 88 b7 00 00 00    	js     801ac8 <dup+0xe3>
    close(newfdnum);
  801a11:	44 89 e7             	mov    %r12d,%edi
  801a14:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  801a1b:	00 00 00 
  801a1e:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801a20:	4d 63 ec             	movslq %r12d,%r13
  801a23:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801a2a:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801a2e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801a32:	49 be a4 17 80 00 00 	movabs $0x8017a4,%r14
  801a39:	00 00 00 
  801a3c:	41 ff d6             	call   *%r14
  801a3f:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801a42:	4c 89 ef             	mov    %r13,%rdi
  801a45:	41 ff d6             	call   *%r14
  801a48:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801a4b:	48 89 df             	mov    %rbx,%rdi
  801a4e:	48 b8 6e 27 80 00 00 	movabs $0x80276e,%rax
  801a55:	00 00 00 
  801a58:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801a5a:	a8 04                	test   $0x4,%al
  801a5c:	74 2b                	je     801a89 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801a5e:	41 89 c1             	mov    %eax,%r9d
  801a61:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a67:	4c 89 f1             	mov    %r14,%rcx
  801a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6f:	48 89 de             	mov    %rbx,%rsi
  801a72:	bf 00 00 00 00       	mov    $0x0,%edi
  801a77:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  801a7e:	00 00 00 
  801a81:	ff d0                	call   *%rax
  801a83:	89 c3                	mov    %eax,%ebx
  801a85:	85 c0                	test   %eax,%eax
  801a87:	78 4e                	js     801ad7 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801a89:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801a8d:	48 b8 6e 27 80 00 00 	movabs $0x80276e,%rax
  801a94:	00 00 00 
  801a97:	ff d0                	call   *%rax
  801a99:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801a9c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801aa2:	4c 89 e9             	mov    %r13,%rcx
  801aa5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aaa:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801aae:	bf 00 00 00 00       	mov    $0x0,%edi
  801ab3:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  801aba:	00 00 00 
  801abd:	ff d0                	call   *%rax
  801abf:	89 c3                	mov    %eax,%ebx
  801ac1:	85 c0                	test   %eax,%eax
  801ac3:	78 12                	js     801ad7 <dup+0xf2>

    return newfdnum;
  801ac5:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801ac8:	89 d8                	mov    %ebx,%eax
  801aca:	48 83 c4 10          	add    $0x10,%rsp
  801ace:	5b                   	pop    %rbx
  801acf:	41 5c                	pop    %r12
  801ad1:	41 5d                	pop    %r13
  801ad3:	41 5e                	pop    %r14
  801ad5:	5d                   	pop    %rbp
  801ad6:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801ad7:	ba 00 10 00 00       	mov    $0x1000,%edx
  801adc:	4c 89 ee             	mov    %r13,%rsi
  801adf:	bf 00 00 00 00       	mov    $0x0,%edi
  801ae4:	49 bc 42 13 80 00 00 	movabs $0x801342,%r12
  801aeb:	00 00 00 
  801aee:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801af1:	ba 00 10 00 00       	mov    $0x1000,%edx
  801af6:	4c 89 f6             	mov    %r14,%rsi
  801af9:	bf 00 00 00 00       	mov    $0x0,%edi
  801afe:	41 ff d4             	call   *%r12
    return res;
  801b01:	eb c5                	jmp    801ac8 <dup+0xe3>

0000000000801b03 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801b03:	55                   	push   %rbp
  801b04:	48 89 e5             	mov    %rsp,%rbp
  801b07:	41 55                	push   %r13
  801b09:	41 54                	push   %r12
  801b0b:	53                   	push   %rbx
  801b0c:	48 83 ec 18          	sub    $0x18,%rsp
  801b10:	89 fb                	mov    %edi,%ebx
  801b12:	49 89 f4             	mov    %rsi,%r12
  801b15:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b18:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b1c:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801b23:	00 00 00 
  801b26:	ff d0                	call   *%rax
  801b28:	85 c0                	test   %eax,%eax
  801b2a:	78 49                	js     801b75 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b2c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b34:	8b 38                	mov    (%rax),%edi
  801b36:	48 b8 6b 18 80 00 00 	movabs $0x80186b,%rax
  801b3d:	00 00 00 
  801b40:	ff d0                	call   *%rax
  801b42:	85 c0                	test   %eax,%eax
  801b44:	78 33                	js     801b79 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b46:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b4a:	8b 47 08             	mov    0x8(%rdi),%eax
  801b4d:	83 e0 03             	and    $0x3,%eax
  801b50:	83 f8 01             	cmp    $0x1,%eax
  801b53:	74 28                	je     801b7d <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801b55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b59:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b5d:	48 85 c0             	test   %rax,%rax
  801b60:	74 51                	je     801bb3 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801b62:	4c 89 ea             	mov    %r13,%rdx
  801b65:	4c 89 e6             	mov    %r12,%rsi
  801b68:	ff d0                	call   *%rax
}
  801b6a:	48 83 c4 18          	add    $0x18,%rsp
  801b6e:	5b                   	pop    %rbx
  801b6f:	41 5c                	pop    %r12
  801b71:	41 5d                	pop    %r13
  801b73:	5d                   	pop    %rbp
  801b74:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b75:	48 98                	cltq   
  801b77:	eb f1                	jmp    801b6a <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b79:	48 98                	cltq   
  801b7b:	eb ed                	jmp    801b6a <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b7d:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801b84:	00 00 00 
  801b87:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b8d:	89 da                	mov    %ebx,%edx
  801b8f:	48 bf 11 33 80 00 00 	movabs $0x803311,%rdi
  801b96:	00 00 00 
  801b99:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9e:	48 b9 7b 03 80 00 00 	movabs $0x80037b,%rcx
  801ba5:	00 00 00 
  801ba8:	ff d1                	call   *%rcx
        return -E_INVAL;
  801baa:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801bb1:	eb b7                	jmp    801b6a <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801bb3:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801bba:	eb ae                	jmp    801b6a <read+0x67>

0000000000801bbc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801bbc:	55                   	push   %rbp
  801bbd:	48 89 e5             	mov    %rsp,%rbp
  801bc0:	41 57                	push   %r15
  801bc2:	41 56                	push   %r14
  801bc4:	41 55                	push   %r13
  801bc6:	41 54                	push   %r12
  801bc8:	53                   	push   %rbx
  801bc9:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801bcd:	48 85 d2             	test   %rdx,%rdx
  801bd0:	74 54                	je     801c26 <readn+0x6a>
  801bd2:	41 89 fd             	mov    %edi,%r13d
  801bd5:	49 89 f6             	mov    %rsi,%r14
  801bd8:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801bdb:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801be0:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801be5:	49 bf 03 1b 80 00 00 	movabs $0x801b03,%r15
  801bec:	00 00 00 
  801bef:	4c 89 e2             	mov    %r12,%rdx
  801bf2:	48 29 f2             	sub    %rsi,%rdx
  801bf5:	4c 01 f6             	add    %r14,%rsi
  801bf8:	44 89 ef             	mov    %r13d,%edi
  801bfb:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	78 20                	js     801c22 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801c02:	01 c3                	add    %eax,%ebx
  801c04:	85 c0                	test   %eax,%eax
  801c06:	74 08                	je     801c10 <readn+0x54>
  801c08:	48 63 f3             	movslq %ebx,%rsi
  801c0b:	4c 39 e6             	cmp    %r12,%rsi
  801c0e:	72 df                	jb     801bef <readn+0x33>
    }
    return res;
  801c10:	48 63 c3             	movslq %ebx,%rax
}
  801c13:	48 83 c4 08          	add    $0x8,%rsp
  801c17:	5b                   	pop    %rbx
  801c18:	41 5c                	pop    %r12
  801c1a:	41 5d                	pop    %r13
  801c1c:	41 5e                	pop    %r14
  801c1e:	41 5f                	pop    %r15
  801c20:	5d                   	pop    %rbp
  801c21:	c3                   	ret    
        if (inc < 0) return inc;
  801c22:	48 98                	cltq   
  801c24:	eb ed                	jmp    801c13 <readn+0x57>
    int inc = 1, res = 0;
  801c26:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c2b:	eb e3                	jmp    801c10 <readn+0x54>

0000000000801c2d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801c2d:	55                   	push   %rbp
  801c2e:	48 89 e5             	mov    %rsp,%rbp
  801c31:	41 55                	push   %r13
  801c33:	41 54                	push   %r12
  801c35:	53                   	push   %rbx
  801c36:	48 83 ec 18          	sub    $0x18,%rsp
  801c3a:	89 fb                	mov    %edi,%ebx
  801c3c:	49 89 f4             	mov    %rsi,%r12
  801c3f:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c42:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c46:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801c4d:	00 00 00 
  801c50:	ff d0                	call   *%rax
  801c52:	85 c0                	test   %eax,%eax
  801c54:	78 44                	js     801c9a <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c56:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5e:	8b 38                	mov    (%rax),%edi
  801c60:	48 b8 6b 18 80 00 00 	movabs $0x80186b,%rax
  801c67:	00 00 00 
  801c6a:	ff d0                	call   *%rax
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 2e                	js     801c9e <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c70:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c74:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801c78:	74 28                	je     801ca2 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801c7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c7e:	48 8b 40 18          	mov    0x18(%rax),%rax
  801c82:	48 85 c0             	test   %rax,%rax
  801c85:	74 51                	je     801cd8 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801c87:	4c 89 ea             	mov    %r13,%rdx
  801c8a:	4c 89 e6             	mov    %r12,%rsi
  801c8d:	ff d0                	call   *%rax
}
  801c8f:	48 83 c4 18          	add    $0x18,%rsp
  801c93:	5b                   	pop    %rbx
  801c94:	41 5c                	pop    %r12
  801c96:	41 5d                	pop    %r13
  801c98:	5d                   	pop    %rbp
  801c99:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c9a:	48 98                	cltq   
  801c9c:	eb f1                	jmp    801c8f <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c9e:	48 98                	cltq   
  801ca0:	eb ed                	jmp    801c8f <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ca2:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801ca9:	00 00 00 
  801cac:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801cb2:	89 da                	mov    %ebx,%edx
  801cb4:	48 bf 2d 33 80 00 00 	movabs $0x80332d,%rdi
  801cbb:	00 00 00 
  801cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc3:	48 b9 7b 03 80 00 00 	movabs $0x80037b,%rcx
  801cca:	00 00 00 
  801ccd:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ccf:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801cd6:	eb b7                	jmp    801c8f <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801cd8:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801cdf:	eb ae                	jmp    801c8f <write+0x62>

0000000000801ce1 <seek>:

int
seek(int fdnum, off_t offset) {
  801ce1:	55                   	push   %rbp
  801ce2:	48 89 e5             	mov    %rsp,%rbp
  801ce5:	53                   	push   %rbx
  801ce6:	48 83 ec 18          	sub    $0x18,%rsp
  801cea:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cec:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801cf0:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801cf7:	00 00 00 
  801cfa:	ff d0                	call   *%rax
  801cfc:	85 c0                	test   %eax,%eax
  801cfe:	78 0c                	js     801d0c <seek+0x2b>

    fd->fd_offset = offset;
  801d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d04:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801d07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

0000000000801d12 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801d12:	55                   	push   %rbp
  801d13:	48 89 e5             	mov    %rsp,%rbp
  801d16:	41 54                	push   %r12
  801d18:	53                   	push   %rbx
  801d19:	48 83 ec 10          	sub    $0x10,%rsp
  801d1d:	89 fb                	mov    %edi,%ebx
  801d1f:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d22:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801d26:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801d2d:	00 00 00 
  801d30:	ff d0                	call   *%rax
  801d32:	85 c0                	test   %eax,%eax
  801d34:	78 36                	js     801d6c <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d36:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801d3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3e:	8b 38                	mov    (%rax),%edi
  801d40:	48 b8 6b 18 80 00 00 	movabs $0x80186b,%rax
  801d47:	00 00 00 
  801d4a:	ff d0                	call   *%rax
  801d4c:	85 c0                	test   %eax,%eax
  801d4e:	78 1c                	js     801d6c <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d50:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d54:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801d58:	74 1b                	je     801d75 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d5e:	48 8b 40 30          	mov    0x30(%rax),%rax
  801d62:	48 85 c0             	test   %rax,%rax
  801d65:	74 42                	je     801da9 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801d67:	44 89 e6             	mov    %r12d,%esi
  801d6a:	ff d0                	call   *%rax
}
  801d6c:	48 83 c4 10          	add    $0x10,%rsp
  801d70:	5b                   	pop    %rbx
  801d71:	41 5c                	pop    %r12
  801d73:	5d                   	pop    %rbp
  801d74:	c3                   	ret    
                thisenv->env_id, fdnum);
  801d75:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801d7c:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d7f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d85:	89 da                	mov    %ebx,%edx
  801d87:	48 bf f0 32 80 00 00 	movabs $0x8032f0,%rdi
  801d8e:	00 00 00 
  801d91:	b8 00 00 00 00       	mov    $0x0,%eax
  801d96:	48 b9 7b 03 80 00 00 	movabs $0x80037b,%rcx
  801d9d:	00 00 00 
  801da0:	ff d1                	call   *%rcx
        return -E_INVAL;
  801da2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801da7:	eb c3                	jmp    801d6c <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801da9:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801dae:	eb bc                	jmp    801d6c <ftruncate+0x5a>

0000000000801db0 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801db0:	55                   	push   %rbp
  801db1:	48 89 e5             	mov    %rsp,%rbp
  801db4:	53                   	push   %rbx
  801db5:	48 83 ec 18          	sub    $0x18,%rsp
  801db9:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dbc:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801dc0:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801dc7:	00 00 00 
  801dca:	ff d0                	call   *%rax
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	78 4d                	js     801e1d <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801dd0:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801dd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd8:	8b 38                	mov    (%rax),%edi
  801dda:	48 b8 6b 18 80 00 00 	movabs $0x80186b,%rax
  801de1:	00 00 00 
  801de4:	ff d0                	call   *%rax
  801de6:	85 c0                	test   %eax,%eax
  801de8:	78 33                	js     801e1d <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801dea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dee:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801df3:	74 2e                	je     801e23 <fstat+0x73>

    stat->st_name[0] = 0;
  801df5:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801df8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801dff:	00 00 00 
    stat->st_isdir = 0;
  801e02:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801e09:	00 00 00 
    stat->st_dev = dev;
  801e0c:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801e13:	48 89 de             	mov    %rbx,%rsi
  801e16:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e1a:	ff 50 28             	call   *0x28(%rax)
}
  801e1d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801e23:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801e28:	eb f3                	jmp    801e1d <fstat+0x6d>

0000000000801e2a <stat>:

int
stat(const char *path, struct Stat *stat) {
  801e2a:	55                   	push   %rbp
  801e2b:	48 89 e5             	mov    %rsp,%rbp
  801e2e:	41 54                	push   %r12
  801e30:	53                   	push   %rbx
  801e31:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801e34:	be 00 00 00 00       	mov    $0x0,%esi
  801e39:	48 b8 f5 20 80 00 00 	movabs $0x8020f5,%rax
  801e40:	00 00 00 
  801e43:	ff d0                	call   *%rax
  801e45:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801e47:	85 c0                	test   %eax,%eax
  801e49:	78 25                	js     801e70 <stat+0x46>

    int res = fstat(fd, stat);
  801e4b:	4c 89 e6             	mov    %r12,%rsi
  801e4e:	89 c7                	mov    %eax,%edi
  801e50:	48 b8 b0 1d 80 00 00 	movabs $0x801db0,%rax
  801e57:	00 00 00 
  801e5a:	ff d0                	call   *%rax
  801e5c:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801e5f:	89 df                	mov    %ebx,%edi
  801e61:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  801e68:	00 00 00 
  801e6b:	ff d0                	call   *%rax

    return res;
  801e6d:	44 89 e3             	mov    %r12d,%ebx
}
  801e70:	89 d8                	mov    %ebx,%eax
  801e72:	5b                   	pop    %rbx
  801e73:	41 5c                	pop    %r12
  801e75:	5d                   	pop    %rbp
  801e76:	c3                   	ret    

0000000000801e77 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801e77:	55                   	push   %rbp
  801e78:	48 89 e5             	mov    %rsp,%rbp
  801e7b:	41 54                	push   %r12
  801e7d:	53                   	push   %rbx
  801e7e:	48 83 ec 10          	sub    $0x10,%rsp
  801e82:	41 89 fc             	mov    %edi,%r12d
  801e85:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801e88:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801e8f:	00 00 00 
  801e92:	83 38 00             	cmpl   $0x0,(%rax)
  801e95:	74 5e                	je     801ef5 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801e97:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801e9d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801ea2:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801ea9:	00 00 00 
  801eac:	44 89 e6             	mov    %r12d,%esi
  801eaf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801eb6:	00 00 00 
  801eb9:	8b 38                	mov    (%rax),%edi
  801ebb:	48 b8 8f 2b 80 00 00 	movabs $0x802b8f,%rax
  801ec2:	00 00 00 
  801ec5:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801ec7:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801ece:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801ecf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ed4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ed8:	48 89 de             	mov    %rbx,%rsi
  801edb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee0:	48 b8 f0 2a 80 00 00 	movabs $0x802af0,%rax
  801ee7:	00 00 00 
  801eea:	ff d0                	call   *%rax
}
  801eec:	48 83 c4 10          	add    $0x10,%rsp
  801ef0:	5b                   	pop    %rbx
  801ef1:	41 5c                	pop    %r12
  801ef3:	5d                   	pop    %rbp
  801ef4:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801ef5:	bf 03 00 00 00       	mov    $0x3,%edi
  801efa:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	call   *%rax
  801f06:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801f0d:	00 00 
  801f0f:	eb 86                	jmp    801e97 <fsipc+0x20>

0000000000801f11 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801f11:	55                   	push   %rbp
  801f12:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f15:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801f1c:	00 00 00 
  801f1f:	8b 57 0c             	mov    0xc(%rdi),%edx
  801f22:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801f24:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801f27:	be 00 00 00 00       	mov    $0x0,%esi
  801f2c:	bf 02 00 00 00       	mov    $0x2,%edi
  801f31:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  801f38:	00 00 00 
  801f3b:	ff d0                	call   *%rax
}
  801f3d:	5d                   	pop    %rbp
  801f3e:	c3                   	ret    

0000000000801f3f <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801f3f:	55                   	push   %rbp
  801f40:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f43:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f46:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801f4d:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801f4f:	be 00 00 00 00       	mov    $0x0,%esi
  801f54:	bf 06 00 00 00       	mov    $0x6,%edi
  801f59:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  801f60:	00 00 00 
  801f63:	ff d0                	call   *%rax
}
  801f65:	5d                   	pop    %rbp
  801f66:	c3                   	ret    

0000000000801f67 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801f67:	55                   	push   %rbp
  801f68:	48 89 e5             	mov    %rsp,%rbp
  801f6b:	53                   	push   %rbx
  801f6c:	48 83 ec 08          	sub    $0x8,%rsp
  801f70:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f73:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f76:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801f7d:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801f7f:	be 00 00 00 00       	mov    $0x0,%esi
  801f84:	bf 05 00 00 00       	mov    $0x5,%edi
  801f89:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  801f90:	00 00 00 
  801f93:	ff d0                	call   *%rax
    if (res < 0) return res;
  801f95:	85 c0                	test   %eax,%eax
  801f97:	78 40                	js     801fd9 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f99:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801fa0:	00 00 00 
  801fa3:	48 89 df             	mov    %rbx,%rdi
  801fa6:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  801fad:	00 00 00 
  801fb0:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801fb2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801fb9:	00 00 00 
  801fbc:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801fc2:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801fc8:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801fce:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

0000000000801fdf <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801fdf:	55                   	push   %rbp
  801fe0:	48 89 e5             	mov    %rsp,%rbp
  801fe3:	41 57                	push   %r15
  801fe5:	41 56                	push   %r14
  801fe7:	41 55                	push   %r13
  801fe9:	41 54                	push   %r12
  801feb:	53                   	push   %rbx
  801fec:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801ff0:	48 85 d2             	test   %rdx,%rdx
  801ff3:	0f 84 91 00 00 00    	je     80208a <devfile_write+0xab>
  801ff9:	49 89 ff             	mov    %rdi,%r15
  801ffc:	49 89 f4             	mov    %rsi,%r12
  801fff:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  802002:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802009:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  802010:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802013:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  80201a:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  802020:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  802024:	4c 89 ea             	mov    %r13,%rdx
  802027:	4c 89 e6             	mov    %r12,%rsi
  80202a:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  802031:	00 00 00 
  802034:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  80203b:	00 00 00 
  80203e:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802040:	41 8b 47 0c          	mov    0xc(%r15),%eax
  802044:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  802047:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  80204b:	be 00 00 00 00       	mov    $0x0,%esi
  802050:	bf 04 00 00 00       	mov    $0x4,%edi
  802055:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  80205c:	00 00 00 
  80205f:	ff d0                	call   *%rax
        if (res < 0)
  802061:	85 c0                	test   %eax,%eax
  802063:	78 21                	js     802086 <devfile_write+0xa7>
        buf += res;
  802065:	48 63 d0             	movslq %eax,%rdx
  802068:	49 01 d4             	add    %rdx,%r12
        ext += res;
  80206b:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  80206e:	48 29 d3             	sub    %rdx,%rbx
  802071:	75 a0                	jne    802013 <devfile_write+0x34>
    return ext;
  802073:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  802077:	48 83 c4 18          	add    $0x18,%rsp
  80207b:	5b                   	pop    %rbx
  80207c:	41 5c                	pop    %r12
  80207e:	41 5d                	pop    %r13
  802080:	41 5e                	pop    %r14
  802082:	41 5f                	pop    %r15
  802084:	5d                   	pop    %rbp
  802085:	c3                   	ret    
            return res;
  802086:	48 98                	cltq   
  802088:	eb ed                	jmp    802077 <devfile_write+0x98>
    int ext = 0;
  80208a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  802091:	eb e0                	jmp    802073 <devfile_write+0x94>

0000000000802093 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802093:	55                   	push   %rbp
  802094:	48 89 e5             	mov    %rsp,%rbp
  802097:	41 54                	push   %r12
  802099:	53                   	push   %rbx
  80209a:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80209d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8020a4:	00 00 00 
  8020a7:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8020aa:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  8020ac:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  8020b0:	be 00 00 00 00       	mov    $0x0,%esi
  8020b5:	bf 03 00 00 00       	mov    $0x3,%edi
  8020ba:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  8020c1:	00 00 00 
  8020c4:	ff d0                	call   *%rax
    if (read < 0) 
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	78 27                	js     8020f1 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  8020ca:	48 63 d8             	movslq %eax,%rbx
  8020cd:	48 89 da             	mov    %rbx,%rdx
  8020d0:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8020d7:	00 00 00 
  8020da:	4c 89 e7             	mov    %r12,%rdi
  8020dd:	48 b8 b7 0e 80 00 00 	movabs $0x800eb7,%rax
  8020e4:	00 00 00 
  8020e7:	ff d0                	call   *%rax
    return read;
  8020e9:	48 89 d8             	mov    %rbx,%rax
}
  8020ec:	5b                   	pop    %rbx
  8020ed:	41 5c                	pop    %r12
  8020ef:	5d                   	pop    %rbp
  8020f0:	c3                   	ret    
		return read;
  8020f1:	48 98                	cltq   
  8020f3:	eb f7                	jmp    8020ec <devfile_read+0x59>

00000000008020f5 <open>:
open(const char *path, int mode) {
  8020f5:	55                   	push   %rbp
  8020f6:	48 89 e5             	mov    %rsp,%rbp
  8020f9:	41 55                	push   %r13
  8020fb:	41 54                	push   %r12
  8020fd:	53                   	push   %rbx
  8020fe:	48 83 ec 18          	sub    $0x18,%rsp
  802102:	49 89 fc             	mov    %rdi,%r12
  802105:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802108:	48 b8 83 0c 80 00 00 	movabs $0x800c83,%rax
  80210f:	00 00 00 
  802112:	ff d0                	call   *%rax
  802114:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80211a:	0f 87 8c 00 00 00    	ja     8021ac <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802120:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802124:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  80212b:	00 00 00 
  80212e:	ff d0                	call   *%rax
  802130:	89 c3                	mov    %eax,%ebx
  802132:	85 c0                	test   %eax,%eax
  802134:	78 52                	js     802188 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802136:	4c 89 e6             	mov    %r12,%rsi
  802139:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  802140:	00 00 00 
  802143:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  80214a:	00 00 00 
  80214d:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80214f:	44 89 e8             	mov    %r13d,%eax
  802152:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802159:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80215b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80215f:	bf 01 00 00 00       	mov    $0x1,%edi
  802164:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  80216b:	00 00 00 
  80216e:	ff d0                	call   *%rax
  802170:	89 c3                	mov    %eax,%ebx
  802172:	85 c0                	test   %eax,%eax
  802174:	78 1f                	js     802195 <open+0xa0>
    return fd2num(fd);
  802176:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80217a:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  802181:	00 00 00 
  802184:	ff d0                	call   *%rax
  802186:	89 c3                	mov    %eax,%ebx
}
  802188:	89 d8                	mov    %ebx,%eax
  80218a:	48 83 c4 18          	add    $0x18,%rsp
  80218e:	5b                   	pop    %rbx
  80218f:	41 5c                	pop    %r12
  802191:	41 5d                	pop    %r13
  802193:	5d                   	pop    %rbp
  802194:	c3                   	ret    
        fd_close(fd, 0);
  802195:	be 00 00 00 00       	mov    $0x0,%esi
  80219a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80219e:	48 b8 e4 18 80 00 00 	movabs $0x8018e4,%rax
  8021a5:	00 00 00 
  8021a8:	ff d0                	call   *%rax
        return res;
  8021aa:	eb dc                	jmp    802188 <open+0x93>
        return -E_BAD_PATH;
  8021ac:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8021b1:	eb d5                	jmp    802188 <open+0x93>

00000000008021b3 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8021b3:	55                   	push   %rbp
  8021b4:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8021b7:	be 00 00 00 00       	mov    $0x0,%esi
  8021bc:	bf 08 00 00 00       	mov    $0x8,%edi
  8021c1:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  8021c8:	00 00 00 
  8021cb:	ff d0                	call   *%rax
}
  8021cd:	5d                   	pop    %rbp
  8021ce:	c3                   	ret    

00000000008021cf <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8021cf:	55                   	push   %rbp
  8021d0:	48 89 e5             	mov    %rsp,%rbp
  8021d3:	41 54                	push   %r12
  8021d5:	53                   	push   %rbx
  8021d6:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8021d9:	48 b8 a4 17 80 00 00 	movabs $0x8017a4,%rax
  8021e0:	00 00 00 
  8021e3:	ff d0                	call   *%rax
  8021e5:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8021e8:	48 be 80 33 80 00 00 	movabs $0x803380,%rsi
  8021ef:	00 00 00 
  8021f2:	48 89 df             	mov    %rbx,%rdi
  8021f5:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  8021fc:	00 00 00 
  8021ff:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802201:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802206:	41 2b 04 24          	sub    (%r12),%eax
  80220a:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802210:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802217:	00 00 00 
    stat->st_dev = &devpipe;
  80221a:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802221:	00 00 00 
  802224:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
  802230:	5b                   	pop    %rbx
  802231:	41 5c                	pop    %r12
  802233:	5d                   	pop    %rbp
  802234:	c3                   	ret    

0000000000802235 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802235:	55                   	push   %rbp
  802236:	48 89 e5             	mov    %rsp,%rbp
  802239:	41 54                	push   %r12
  80223b:	53                   	push   %rbx
  80223c:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80223f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802244:	48 89 fe             	mov    %rdi,%rsi
  802247:	bf 00 00 00 00       	mov    $0x0,%edi
  80224c:	49 bc 42 13 80 00 00 	movabs $0x801342,%r12
  802253:	00 00 00 
  802256:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802259:	48 89 df             	mov    %rbx,%rdi
  80225c:	48 b8 a4 17 80 00 00 	movabs $0x8017a4,%rax
  802263:	00 00 00 
  802266:	ff d0                	call   *%rax
  802268:	48 89 c6             	mov    %rax,%rsi
  80226b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802270:	bf 00 00 00 00       	mov    $0x0,%edi
  802275:	41 ff d4             	call   *%r12
}
  802278:	5b                   	pop    %rbx
  802279:	41 5c                	pop    %r12
  80227b:	5d                   	pop    %rbp
  80227c:	c3                   	ret    

000000000080227d <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  80227d:	55                   	push   %rbp
  80227e:	48 89 e5             	mov    %rsp,%rbp
  802281:	41 57                	push   %r15
  802283:	41 56                	push   %r14
  802285:	41 55                	push   %r13
  802287:	41 54                	push   %r12
  802289:	53                   	push   %rbx
  80228a:	48 83 ec 18          	sub    $0x18,%rsp
  80228e:	49 89 fc             	mov    %rdi,%r12
  802291:	49 89 f5             	mov    %rsi,%r13
  802294:	49 89 d7             	mov    %rdx,%r15
  802297:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80229b:	48 b8 a4 17 80 00 00 	movabs $0x8017a4,%rax
  8022a2:	00 00 00 
  8022a5:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8022a7:	4d 85 ff             	test   %r15,%r15
  8022aa:	0f 84 ac 00 00 00    	je     80235c <devpipe_write+0xdf>
  8022b0:	48 89 c3             	mov    %rax,%rbx
  8022b3:	4c 89 f8             	mov    %r15,%rax
  8022b6:	4d 89 ef             	mov    %r13,%r15
  8022b9:	49 01 c5             	add    %rax,%r13
  8022bc:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8022c0:	49 bd 4a 12 80 00 00 	movabs $0x80124a,%r13
  8022c7:	00 00 00 
            sys_yield();
  8022ca:	49 be e7 11 80 00 00 	movabs $0x8011e7,%r14
  8022d1:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8022d4:	8b 73 04             	mov    0x4(%rbx),%esi
  8022d7:	48 63 ce             	movslq %esi,%rcx
  8022da:	48 63 03             	movslq (%rbx),%rax
  8022dd:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8022e3:	48 39 c1             	cmp    %rax,%rcx
  8022e6:	72 2e                	jb     802316 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8022e8:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8022ed:	48 89 da             	mov    %rbx,%rdx
  8022f0:	be 00 10 00 00       	mov    $0x1000,%esi
  8022f5:	4c 89 e7             	mov    %r12,%rdi
  8022f8:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	74 63                	je     802362 <devpipe_write+0xe5>
            sys_yield();
  8022ff:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802302:	8b 73 04             	mov    0x4(%rbx),%esi
  802305:	48 63 ce             	movslq %esi,%rcx
  802308:	48 63 03             	movslq (%rbx),%rax
  80230b:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802311:	48 39 c1             	cmp    %rax,%rcx
  802314:	73 d2                	jae    8022e8 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802316:	41 0f b6 3f          	movzbl (%r15),%edi
  80231a:	48 89 ca             	mov    %rcx,%rdx
  80231d:	48 c1 ea 03          	shr    $0x3,%rdx
  802321:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802328:	08 10 20 
  80232b:	48 f7 e2             	mul    %rdx
  80232e:	48 c1 ea 06          	shr    $0x6,%rdx
  802332:	48 89 d0             	mov    %rdx,%rax
  802335:	48 c1 e0 09          	shl    $0x9,%rax
  802339:	48 29 d0             	sub    %rdx,%rax
  80233c:	48 c1 e0 03          	shl    $0x3,%rax
  802340:	48 29 c1             	sub    %rax,%rcx
  802343:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802348:	83 c6 01             	add    $0x1,%esi
  80234b:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80234e:	49 83 c7 01          	add    $0x1,%r15
  802352:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802356:	0f 85 78 ff ff ff    	jne    8022d4 <devpipe_write+0x57>
    return n;
  80235c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802360:	eb 05                	jmp    802367 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802362:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802367:	48 83 c4 18          	add    $0x18,%rsp
  80236b:	5b                   	pop    %rbx
  80236c:	41 5c                	pop    %r12
  80236e:	41 5d                	pop    %r13
  802370:	41 5e                	pop    %r14
  802372:	41 5f                	pop    %r15
  802374:	5d                   	pop    %rbp
  802375:	c3                   	ret    

0000000000802376 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802376:	55                   	push   %rbp
  802377:	48 89 e5             	mov    %rsp,%rbp
  80237a:	41 57                	push   %r15
  80237c:	41 56                	push   %r14
  80237e:	41 55                	push   %r13
  802380:	41 54                	push   %r12
  802382:	53                   	push   %rbx
  802383:	48 83 ec 18          	sub    $0x18,%rsp
  802387:	49 89 fc             	mov    %rdi,%r12
  80238a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80238e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802392:	48 b8 a4 17 80 00 00 	movabs $0x8017a4,%rax
  802399:	00 00 00 
  80239c:	ff d0                	call   *%rax
  80239e:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8023a1:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023a7:	49 bd 4a 12 80 00 00 	movabs $0x80124a,%r13
  8023ae:	00 00 00 
            sys_yield();
  8023b1:	49 be e7 11 80 00 00 	movabs $0x8011e7,%r14
  8023b8:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8023bb:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8023c0:	74 7a                	je     80243c <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8023c2:	8b 03                	mov    (%rbx),%eax
  8023c4:	3b 43 04             	cmp    0x4(%rbx),%eax
  8023c7:	75 26                	jne    8023ef <devpipe_read+0x79>
            if (i > 0) return i;
  8023c9:	4d 85 ff             	test   %r15,%r15
  8023cc:	75 74                	jne    802442 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023ce:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8023d3:	48 89 da             	mov    %rbx,%rdx
  8023d6:	be 00 10 00 00       	mov    $0x1000,%esi
  8023db:	4c 89 e7             	mov    %r12,%rdi
  8023de:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	74 6f                	je     802454 <devpipe_read+0xde>
            sys_yield();
  8023e5:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8023e8:	8b 03                	mov    (%rbx),%eax
  8023ea:	3b 43 04             	cmp    0x4(%rbx),%eax
  8023ed:	74 df                	je     8023ce <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023ef:	48 63 c8             	movslq %eax,%rcx
  8023f2:	48 89 ca             	mov    %rcx,%rdx
  8023f5:	48 c1 ea 03          	shr    $0x3,%rdx
  8023f9:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802400:	08 10 20 
  802403:	48 f7 e2             	mul    %rdx
  802406:	48 c1 ea 06          	shr    $0x6,%rdx
  80240a:	48 89 d0             	mov    %rdx,%rax
  80240d:	48 c1 e0 09          	shl    $0x9,%rax
  802411:	48 29 d0             	sub    %rdx,%rax
  802414:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80241b:	00 
  80241c:	48 89 c8             	mov    %rcx,%rax
  80241f:	48 29 d0             	sub    %rdx,%rax
  802422:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802427:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80242b:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80242f:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802432:	49 83 c7 01          	add    $0x1,%r15
  802436:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80243a:	75 86                	jne    8023c2 <devpipe_read+0x4c>
    return n;
  80243c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802440:	eb 03                	jmp    802445 <devpipe_read+0xcf>
            if (i > 0) return i;
  802442:	4c 89 f8             	mov    %r15,%rax
}
  802445:	48 83 c4 18          	add    $0x18,%rsp
  802449:	5b                   	pop    %rbx
  80244a:	41 5c                	pop    %r12
  80244c:	41 5d                	pop    %r13
  80244e:	41 5e                	pop    %r14
  802450:	41 5f                	pop    %r15
  802452:	5d                   	pop    %rbp
  802453:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802454:	b8 00 00 00 00       	mov    $0x0,%eax
  802459:	eb ea                	jmp    802445 <devpipe_read+0xcf>

000000000080245b <pipe>:
pipe(int pfd[2]) {
  80245b:	55                   	push   %rbp
  80245c:	48 89 e5             	mov    %rsp,%rbp
  80245f:	41 55                	push   %r13
  802461:	41 54                	push   %r12
  802463:	53                   	push   %rbx
  802464:	48 83 ec 18          	sub    $0x18,%rsp
  802468:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  80246b:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80246f:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  802476:	00 00 00 
  802479:	ff d0                	call   *%rax
  80247b:	89 c3                	mov    %eax,%ebx
  80247d:	85 c0                	test   %eax,%eax
  80247f:	0f 88 a0 01 00 00    	js     802625 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802485:	b9 46 00 00 00       	mov    $0x46,%ecx
  80248a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80248f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802493:	bf 00 00 00 00       	mov    $0x0,%edi
  802498:	48 b8 76 12 80 00 00 	movabs $0x801276,%rax
  80249f:	00 00 00 
  8024a2:	ff d0                	call   *%rax
  8024a4:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	0f 88 77 01 00 00    	js     802625 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8024ae:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8024b2:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  8024b9:	00 00 00 
  8024bc:	ff d0                	call   *%rax
  8024be:	89 c3                	mov    %eax,%ebx
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	0f 88 43 01 00 00    	js     80260b <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8024c8:	b9 46 00 00 00       	mov    $0x46,%ecx
  8024cd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024d2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8024db:	48 b8 76 12 80 00 00 	movabs $0x801276,%rax
  8024e2:	00 00 00 
  8024e5:	ff d0                	call   *%rax
  8024e7:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	0f 88 1a 01 00 00    	js     80260b <pipe+0x1b0>
    va = fd2data(fd0);
  8024f1:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8024f5:	48 b8 a4 17 80 00 00 	movabs $0x8017a4,%rax
  8024fc:	00 00 00 
  8024ff:	ff d0                	call   *%rax
  802501:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802504:	b9 46 00 00 00       	mov    $0x46,%ecx
  802509:	ba 00 10 00 00       	mov    $0x1000,%edx
  80250e:	48 89 c6             	mov    %rax,%rsi
  802511:	bf 00 00 00 00       	mov    $0x0,%edi
  802516:	48 b8 76 12 80 00 00 	movabs $0x801276,%rax
  80251d:	00 00 00 
  802520:	ff d0                	call   *%rax
  802522:	89 c3                	mov    %eax,%ebx
  802524:	85 c0                	test   %eax,%eax
  802526:	0f 88 c5 00 00 00    	js     8025f1 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80252c:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802530:	48 b8 a4 17 80 00 00 	movabs $0x8017a4,%rax
  802537:	00 00 00 
  80253a:	ff d0                	call   *%rax
  80253c:	48 89 c1             	mov    %rax,%rcx
  80253f:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802545:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80254b:	ba 00 00 00 00       	mov    $0x0,%edx
  802550:	4c 89 ee             	mov    %r13,%rsi
  802553:	bf 00 00 00 00       	mov    $0x0,%edi
  802558:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  80255f:	00 00 00 
  802562:	ff d0                	call   *%rax
  802564:	89 c3                	mov    %eax,%ebx
  802566:	85 c0                	test   %eax,%eax
  802568:	78 6e                	js     8025d8 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80256a:	be 00 10 00 00       	mov    $0x1000,%esi
  80256f:	4c 89 ef             	mov    %r13,%rdi
  802572:	48 b8 18 12 80 00 00 	movabs $0x801218,%rax
  802579:	00 00 00 
  80257c:	ff d0                	call   *%rax
  80257e:	83 f8 02             	cmp    $0x2,%eax
  802581:	0f 85 ab 00 00 00    	jne    802632 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802587:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80258e:	00 00 
  802590:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802594:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802596:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80259a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8025a1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8025a5:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8025a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025ab:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8025b2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8025b6:	48 bb 92 17 80 00 00 	movabs $0x801792,%rbx
  8025bd:	00 00 00 
  8025c0:	ff d3                	call   *%rbx
  8025c2:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8025c6:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8025ca:	ff d3                	call   *%rbx
  8025cc:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8025d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025d6:	eb 4d                	jmp    802625 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8025d8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025dd:	4c 89 ee             	mov    %r13,%rsi
  8025e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8025e5:	48 b8 42 13 80 00 00 	movabs $0x801342,%rax
  8025ec:	00 00 00 
  8025ef:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8025f1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025f6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ff:	48 b8 42 13 80 00 00 	movabs $0x801342,%rax
  802606:	00 00 00 
  802609:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80260b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802610:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802614:	bf 00 00 00 00       	mov    $0x0,%edi
  802619:	48 b8 42 13 80 00 00 	movabs $0x801342,%rax
  802620:	00 00 00 
  802623:	ff d0                	call   *%rax
}
  802625:	89 d8                	mov    %ebx,%eax
  802627:	48 83 c4 18          	add    $0x18,%rsp
  80262b:	5b                   	pop    %rbx
  80262c:	41 5c                	pop    %r12
  80262e:	41 5d                	pop    %r13
  802630:	5d                   	pop    %rbp
  802631:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802632:	48 b9 b0 33 80 00 00 	movabs $0x8033b0,%rcx
  802639:	00 00 00 
  80263c:	48 ba 87 33 80 00 00 	movabs $0x803387,%rdx
  802643:	00 00 00 
  802646:	be 2e 00 00 00       	mov    $0x2e,%esi
  80264b:	48 bf 9c 33 80 00 00 	movabs $0x80339c,%rdi
  802652:	00 00 00 
  802655:	b8 00 00 00 00       	mov    $0x0,%eax
  80265a:	49 b8 2b 02 80 00 00 	movabs $0x80022b,%r8
  802661:	00 00 00 
  802664:	41 ff d0             	call   *%r8

0000000000802667 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802667:	55                   	push   %rbp
  802668:	48 89 e5             	mov    %rsp,%rbp
  80266b:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80266f:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802673:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  80267a:	00 00 00 
  80267d:	ff d0                	call   *%rax
    if (res < 0) return res;
  80267f:	85 c0                	test   %eax,%eax
  802681:	78 35                	js     8026b8 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802683:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802687:	48 b8 a4 17 80 00 00 	movabs $0x8017a4,%rax
  80268e:	00 00 00 
  802691:	ff d0                	call   *%rax
  802693:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802696:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80269b:	be 00 10 00 00       	mov    $0x1000,%esi
  8026a0:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8026a4:	48 b8 4a 12 80 00 00 	movabs $0x80124a,%rax
  8026ab:	00 00 00 
  8026ae:	ff d0                	call   *%rax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	0f 94 c0             	sete   %al
  8026b5:	0f b6 c0             	movzbl %al,%eax
}
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    

00000000008026ba <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8026ba:	48 89 f8             	mov    %rdi,%rax
  8026bd:	48 c1 e8 27          	shr    $0x27,%rax
  8026c1:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8026c8:	01 00 00 
  8026cb:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026cf:	f6 c2 01             	test   $0x1,%dl
  8026d2:	74 6d                	je     802741 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8026d4:	48 89 f8             	mov    %rdi,%rax
  8026d7:	48 c1 e8 1e          	shr    $0x1e,%rax
  8026db:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8026e2:	01 00 00 
  8026e5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026e9:	f6 c2 01             	test   $0x1,%dl
  8026ec:	74 62                	je     802750 <get_uvpt_entry+0x96>
  8026ee:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8026f5:	01 00 00 
  8026f8:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026fc:	f6 c2 80             	test   $0x80,%dl
  8026ff:	75 4f                	jne    802750 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802701:	48 89 f8             	mov    %rdi,%rax
  802704:	48 c1 e8 15          	shr    $0x15,%rax
  802708:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80270f:	01 00 00 
  802712:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802716:	f6 c2 01             	test   $0x1,%dl
  802719:	74 44                	je     80275f <get_uvpt_entry+0xa5>
  80271b:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802722:	01 00 00 
  802725:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802729:	f6 c2 80             	test   $0x80,%dl
  80272c:	75 31                	jne    80275f <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  80272e:	48 c1 ef 0c          	shr    $0xc,%rdi
  802732:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802739:	01 00 00 
  80273c:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802740:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802741:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802748:	01 00 00 
  80274b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80274f:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802750:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802757:	01 00 00 
  80275a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80275e:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80275f:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802766:	01 00 00 
  802769:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80276d:	c3                   	ret    

000000000080276e <get_prot>:

int
get_prot(void *va) {
  80276e:	55                   	push   %rbp
  80276f:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802772:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  802779:	00 00 00 
  80277c:	ff d0                	call   *%rax
  80277e:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802781:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802786:	89 c1                	mov    %eax,%ecx
  802788:	83 c9 04             	or     $0x4,%ecx
  80278b:	f6 c2 01             	test   $0x1,%dl
  80278e:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802791:	89 c1                	mov    %eax,%ecx
  802793:	83 c9 02             	or     $0x2,%ecx
  802796:	f6 c2 02             	test   $0x2,%dl
  802799:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80279c:	89 c1                	mov    %eax,%ecx
  80279e:	83 c9 01             	or     $0x1,%ecx
  8027a1:	48 85 d2             	test   %rdx,%rdx
  8027a4:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8027a7:	89 c1                	mov    %eax,%ecx
  8027a9:	83 c9 40             	or     $0x40,%ecx
  8027ac:	f6 c6 04             	test   $0x4,%dh
  8027af:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8027b2:	5d                   	pop    %rbp
  8027b3:	c3                   	ret    

00000000008027b4 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8027b4:	55                   	push   %rbp
  8027b5:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8027b8:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  8027bf:	00 00 00 
  8027c2:	ff d0                	call   *%rax
    return pte & PTE_D;
  8027c4:	48 c1 e8 06          	shr    $0x6,%rax
  8027c8:	83 e0 01             	and    $0x1,%eax
}
  8027cb:	5d                   	pop    %rbp
  8027cc:	c3                   	ret    

00000000008027cd <is_page_present>:

bool
is_page_present(void *va) {
  8027cd:	55                   	push   %rbp
  8027ce:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8027d1:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  8027d8:	00 00 00 
  8027db:	ff d0                	call   *%rax
  8027dd:	83 e0 01             	and    $0x1,%eax
}
  8027e0:	5d                   	pop    %rbp
  8027e1:	c3                   	ret    

00000000008027e2 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8027e2:	55                   	push   %rbp
  8027e3:	48 89 e5             	mov    %rsp,%rbp
  8027e6:	41 57                	push   %r15
  8027e8:	41 56                	push   %r14
  8027ea:	41 55                	push   %r13
  8027ec:	41 54                	push   %r12
  8027ee:	53                   	push   %rbx
  8027ef:	48 83 ec 28          	sub    $0x28,%rsp
  8027f3:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8027f7:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8027fb:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802800:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802807:	01 00 00 
  80280a:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802811:	01 00 00 
  802814:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  80281b:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80281e:	49 bf 6e 27 80 00 00 	movabs $0x80276e,%r15
  802825:	00 00 00 
  802828:	eb 16                	jmp    802840 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  80282a:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802831:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802838:	00 00 00 
  80283b:	48 39 c3             	cmp    %rax,%rbx
  80283e:	77 73                	ja     8028b3 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802840:	48 89 d8             	mov    %rbx,%rax
  802843:	48 c1 e8 27          	shr    $0x27,%rax
  802847:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  80284b:	a8 01                	test   $0x1,%al
  80284d:	74 db                	je     80282a <foreach_shared_region+0x48>
  80284f:	48 89 d8             	mov    %rbx,%rax
  802852:	48 c1 e8 1e          	shr    $0x1e,%rax
  802856:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80285b:	a8 01                	test   $0x1,%al
  80285d:	74 cb                	je     80282a <foreach_shared_region+0x48>
  80285f:	48 89 d8             	mov    %rbx,%rax
  802862:	48 c1 e8 15          	shr    $0x15,%rax
  802866:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  80286a:	a8 01                	test   $0x1,%al
  80286c:	74 bc                	je     80282a <foreach_shared_region+0x48>
        void *start = (void*)i;
  80286e:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802872:	48 89 df             	mov    %rbx,%rdi
  802875:	41 ff d7             	call   *%r15
  802878:	a8 40                	test   $0x40,%al
  80287a:	75 09                	jne    802885 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  80287c:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802883:	eb ac                	jmp    802831 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802885:	48 89 df             	mov    %rbx,%rdi
  802888:	48 b8 cd 27 80 00 00 	movabs $0x8027cd,%rax
  80288f:	00 00 00 
  802892:	ff d0                	call   *%rax
  802894:	84 c0                	test   %al,%al
  802896:	74 e4                	je     80287c <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802898:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  80289f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8028a3:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8028a7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8028ab:	ff d0                	call   *%rax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	79 cb                	jns    80287c <foreach_shared_region+0x9a>
  8028b1:	eb 05                	jmp    8028b8 <foreach_shared_region+0xd6>
    }
    return 0;
  8028b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028b8:	48 83 c4 28          	add    $0x28,%rsp
  8028bc:	5b                   	pop    %rbx
  8028bd:	41 5c                	pop    %r12
  8028bf:	41 5d                	pop    %r13
  8028c1:	41 5e                	pop    %r14
  8028c3:	41 5f                	pop    %r15
  8028c5:	5d                   	pop    %rbp
  8028c6:	c3                   	ret    

00000000008028c7 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  8028c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cc:	c3                   	ret    

00000000008028cd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8028cd:	55                   	push   %rbp
  8028ce:	48 89 e5             	mov    %rsp,%rbp
  8028d1:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8028d4:	48 be d4 33 80 00 00 	movabs $0x8033d4,%rsi
  8028db:	00 00 00 
  8028de:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  8028e5:	00 00 00 
  8028e8:	ff d0                	call   *%rax
    return 0;
}
  8028ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ef:	5d                   	pop    %rbp
  8028f0:	c3                   	ret    

00000000008028f1 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8028f1:	55                   	push   %rbp
  8028f2:	48 89 e5             	mov    %rsp,%rbp
  8028f5:	41 57                	push   %r15
  8028f7:	41 56                	push   %r14
  8028f9:	41 55                	push   %r13
  8028fb:	41 54                	push   %r12
  8028fd:	53                   	push   %rbx
  8028fe:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802905:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80290c:	48 85 d2             	test   %rdx,%rdx
  80290f:	74 78                	je     802989 <devcons_write+0x98>
  802911:	49 89 d6             	mov    %rdx,%r14
  802914:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80291a:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  80291f:	49 bf b7 0e 80 00 00 	movabs $0x800eb7,%r15
  802926:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802929:	4c 89 f3             	mov    %r14,%rbx
  80292c:	48 29 f3             	sub    %rsi,%rbx
  80292f:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802933:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802938:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  80293c:	4c 63 eb             	movslq %ebx,%r13
  80293f:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802946:	4c 89 ea             	mov    %r13,%rdx
  802949:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802950:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802953:	4c 89 ee             	mov    %r13,%rsi
  802956:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  80295d:	48 b8 ed 10 80 00 00 	movabs $0x8010ed,%rax
  802964:	00 00 00 
  802967:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802969:	41 01 dc             	add    %ebx,%r12d
  80296c:	49 63 f4             	movslq %r12d,%rsi
  80296f:	4c 39 f6             	cmp    %r14,%rsi
  802972:	72 b5                	jb     802929 <devcons_write+0x38>
    return res;
  802974:	49 63 c4             	movslq %r12d,%rax
}
  802977:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80297e:	5b                   	pop    %rbx
  80297f:	41 5c                	pop    %r12
  802981:	41 5d                	pop    %r13
  802983:	41 5e                	pop    %r14
  802985:	41 5f                	pop    %r15
  802987:	5d                   	pop    %rbp
  802988:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802989:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80298f:	eb e3                	jmp    802974 <devcons_write+0x83>

0000000000802991 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802991:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802994:	ba 00 00 00 00       	mov    $0x0,%edx
  802999:	48 85 c0             	test   %rax,%rax
  80299c:	74 55                	je     8029f3 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80299e:	55                   	push   %rbp
  80299f:	48 89 e5             	mov    %rsp,%rbp
  8029a2:	41 55                	push   %r13
  8029a4:	41 54                	push   %r12
  8029a6:	53                   	push   %rbx
  8029a7:	48 83 ec 08          	sub    $0x8,%rsp
  8029ab:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  8029ae:	48 bb 1a 11 80 00 00 	movabs $0x80111a,%rbx
  8029b5:	00 00 00 
  8029b8:	49 bc e7 11 80 00 00 	movabs $0x8011e7,%r12
  8029bf:	00 00 00 
  8029c2:	eb 03                	jmp    8029c7 <devcons_read+0x36>
  8029c4:	41 ff d4             	call   *%r12
  8029c7:	ff d3                	call   *%rbx
  8029c9:	85 c0                	test   %eax,%eax
  8029cb:	74 f7                	je     8029c4 <devcons_read+0x33>
    if (c < 0) return c;
  8029cd:	48 63 d0             	movslq %eax,%rdx
  8029d0:	78 13                	js     8029e5 <devcons_read+0x54>
    if (c == 0x04) return 0;
  8029d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8029d7:	83 f8 04             	cmp    $0x4,%eax
  8029da:	74 09                	je     8029e5 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  8029dc:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8029e0:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8029e5:	48 89 d0             	mov    %rdx,%rax
  8029e8:	48 83 c4 08          	add    $0x8,%rsp
  8029ec:	5b                   	pop    %rbx
  8029ed:	41 5c                	pop    %r12
  8029ef:	41 5d                	pop    %r13
  8029f1:	5d                   	pop    %rbp
  8029f2:	c3                   	ret    
  8029f3:	48 89 d0             	mov    %rdx,%rax
  8029f6:	c3                   	ret    

00000000008029f7 <cputchar>:
cputchar(int ch) {
  8029f7:	55                   	push   %rbp
  8029f8:	48 89 e5             	mov    %rsp,%rbp
  8029fb:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8029ff:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802a03:	be 01 00 00 00       	mov    $0x1,%esi
  802a08:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802a0c:	48 b8 ed 10 80 00 00 	movabs $0x8010ed,%rax
  802a13:	00 00 00 
  802a16:	ff d0                	call   *%rax
}
  802a18:	c9                   	leave  
  802a19:	c3                   	ret    

0000000000802a1a <getchar>:
getchar(void) {
  802a1a:	55                   	push   %rbp
  802a1b:	48 89 e5             	mov    %rsp,%rbp
  802a1e:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802a22:	ba 01 00 00 00       	mov    $0x1,%edx
  802a27:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802a2b:	bf 00 00 00 00       	mov    $0x0,%edi
  802a30:	48 b8 03 1b 80 00 00 	movabs $0x801b03,%rax
  802a37:	00 00 00 
  802a3a:	ff d0                	call   *%rax
  802a3c:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802a3e:	85 c0                	test   %eax,%eax
  802a40:	78 06                	js     802a48 <getchar+0x2e>
  802a42:	74 08                	je     802a4c <getchar+0x32>
  802a44:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802a48:	89 d0                	mov    %edx,%eax
  802a4a:	c9                   	leave  
  802a4b:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802a4c:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802a51:	eb f5                	jmp    802a48 <getchar+0x2e>

0000000000802a53 <iscons>:
iscons(int fdnum) {
  802a53:	55                   	push   %rbp
  802a54:	48 89 e5             	mov    %rsp,%rbp
  802a57:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802a5b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802a5f:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  802a66:	00 00 00 
  802a69:	ff d0                	call   *%rax
    if (res < 0) return res;
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	78 18                	js     802a87 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802a6f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a73:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802a7a:	00 00 00 
  802a7d:	8b 00                	mov    (%rax),%eax
  802a7f:	39 02                	cmp    %eax,(%rdx)
  802a81:	0f 94 c0             	sete   %al
  802a84:	0f b6 c0             	movzbl %al,%eax
}
  802a87:	c9                   	leave  
  802a88:	c3                   	ret    

0000000000802a89 <opencons>:
opencons(void) {
  802a89:	55                   	push   %rbp
  802a8a:	48 89 e5             	mov    %rsp,%rbp
  802a8d:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802a91:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802a95:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  802a9c:	00 00 00 
  802a9f:	ff d0                	call   *%rax
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	78 49                	js     802aee <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802aa5:	b9 46 00 00 00       	mov    $0x46,%ecx
  802aaa:	ba 00 10 00 00       	mov    $0x1000,%edx
  802aaf:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802ab3:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab8:	48 b8 76 12 80 00 00 	movabs $0x801276,%rax
  802abf:	00 00 00 
  802ac2:	ff d0                	call   *%rax
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	78 26                	js     802aee <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802ac8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802acc:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802ad3:	00 00 
  802ad5:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802ad7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802adb:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802ae2:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  802ae9:	00 00 00 
  802aec:	ff d0                	call   *%rax
}
  802aee:	c9                   	leave  
  802aef:	c3                   	ret    

0000000000802af0 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802af0:	55                   	push   %rbp
  802af1:	48 89 e5             	mov    %rsp,%rbp
  802af4:	41 54                	push   %r12
  802af6:	53                   	push   %rbx
  802af7:	48 89 fb             	mov    %rdi,%rbx
  802afa:	48 89 f7             	mov    %rsi,%rdi
  802afd:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802b00:	48 85 f6             	test   %rsi,%rsi
  802b03:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b0a:	00 00 00 
  802b0d:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802b11:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802b16:	48 85 d2             	test   %rdx,%rdx
  802b19:	74 02                	je     802b1d <ipc_recv+0x2d>
  802b1b:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802b1d:	48 63 f6             	movslq %esi,%rsi
  802b20:	48 b8 10 15 80 00 00 	movabs $0x801510,%rax
  802b27:	00 00 00 
  802b2a:	ff d0                	call   *%rax

    if (res < 0) {
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	78 45                	js     802b75 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802b30:	48 85 db             	test   %rbx,%rbx
  802b33:	74 12                	je     802b47 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802b35:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  802b3c:	00 00 00 
  802b3f:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b45:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802b47:	4d 85 e4             	test   %r12,%r12
  802b4a:	74 14                	je     802b60 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802b4c:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  802b53:	00 00 00 
  802b56:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b5c:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802b60:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  802b67:	00 00 00 
  802b6a:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802b70:	5b                   	pop    %rbx
  802b71:	41 5c                	pop    %r12
  802b73:	5d                   	pop    %rbp
  802b74:	c3                   	ret    
        if (from_env_store)
  802b75:	48 85 db             	test   %rbx,%rbx
  802b78:	74 06                	je     802b80 <ipc_recv+0x90>
            *from_env_store = 0;
  802b7a:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802b80:	4d 85 e4             	test   %r12,%r12
  802b83:	74 eb                	je     802b70 <ipc_recv+0x80>
            *perm_store = 0;
  802b85:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b8c:	00 
  802b8d:	eb e1                	jmp    802b70 <ipc_recv+0x80>

0000000000802b8f <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b8f:	55                   	push   %rbp
  802b90:	48 89 e5             	mov    %rsp,%rbp
  802b93:	41 57                	push   %r15
  802b95:	41 56                	push   %r14
  802b97:	41 55                	push   %r13
  802b99:	41 54                	push   %r12
  802b9b:	53                   	push   %rbx
  802b9c:	48 83 ec 18          	sub    $0x18,%rsp
  802ba0:	41 89 fd             	mov    %edi,%r13d
  802ba3:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802ba6:	48 89 d3             	mov    %rdx,%rbx
  802ba9:	49 89 cc             	mov    %rcx,%r12
  802bac:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802bb0:	48 85 d2             	test   %rdx,%rdx
  802bb3:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bba:	00 00 00 
  802bbd:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802bc1:	49 be e4 14 80 00 00 	movabs $0x8014e4,%r14
  802bc8:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802bcb:	49 bf e7 11 80 00 00 	movabs $0x8011e7,%r15
  802bd2:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802bd5:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802bd8:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802bdc:	4c 89 e1             	mov    %r12,%rcx
  802bdf:	48 89 da             	mov    %rbx,%rdx
  802be2:	44 89 ef             	mov    %r13d,%edi
  802be5:	41 ff d6             	call   *%r14
  802be8:	85 c0                	test   %eax,%eax
  802bea:	79 37                	jns    802c23 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bec:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bef:	75 05                	jne    802bf6 <ipc_send+0x67>
          sys_yield();
  802bf1:	41 ff d7             	call   *%r15
  802bf4:	eb df                	jmp    802bd5 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802bf6:	89 c1                	mov    %eax,%ecx
  802bf8:	48 ba e0 33 80 00 00 	movabs $0x8033e0,%rdx
  802bff:	00 00 00 
  802c02:	be 46 00 00 00       	mov    $0x46,%esi
  802c07:	48 bf f3 33 80 00 00 	movabs $0x8033f3,%rdi
  802c0e:	00 00 00 
  802c11:	b8 00 00 00 00       	mov    $0x0,%eax
  802c16:	49 b8 2b 02 80 00 00 	movabs $0x80022b,%r8
  802c1d:	00 00 00 
  802c20:	41 ff d0             	call   *%r8
      }
}
  802c23:	48 83 c4 18          	add    $0x18,%rsp
  802c27:	5b                   	pop    %rbx
  802c28:	41 5c                	pop    %r12
  802c2a:	41 5d                	pop    %r13
  802c2c:	41 5e                	pop    %r14
  802c2e:	41 5f                	pop    %r15
  802c30:	5d                   	pop    %rbp
  802c31:	c3                   	ret    

0000000000802c32 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802c32:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c37:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802c3e:	00 00 00 
  802c41:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c45:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c49:	48 c1 e2 04          	shl    $0x4,%rdx
  802c4d:	48 01 ca             	add    %rcx,%rdx
  802c50:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c56:	39 fa                	cmp    %edi,%edx
  802c58:	74 12                	je     802c6c <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802c5a:	48 83 c0 01          	add    $0x1,%rax
  802c5e:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c64:	75 db                	jne    802c41 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802c66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c6b:	c3                   	ret    
            return envs[i].env_id;
  802c6c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c70:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802c74:	48 c1 e0 04          	shl    $0x4,%rax
  802c78:	48 89 c2             	mov    %rax,%rdx
  802c7b:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802c82:	00 00 00 
  802c85:	48 01 d0             	add    %rdx,%rax
  802c88:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c8e:	c3                   	ret    
  802c8f:	90                   	nop

0000000000802c90 <__rodata_start>:
  802c90:	72 61                	jb     802cf3 <__rodata_start+0x63>
  802c92:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c93:	20 6f 6e             	and    %ch,0x6e(%rdi)
  802c96:	20 74 77 6f          	and    %dh,0x6f(%rdi,%rsi,2)
  802c9a:	20 43 50             	and    %al,0x50(%rbx)
  802c9d:	55                   	push   %rbp
  802c9e:	73 20                	jae    802cc0 <__rodata_start+0x30>
  802ca0:	61                   	(bad)  
  802ca1:	74 20                	je     802cc3 <__rodata_start+0x33>
  802ca3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ca4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ca5:	63 65 20             	movsxd 0x20(%rbp),%esp
  802ca8:	28 63 6f             	sub    %ah,0x6f(%rbx)
  802cab:	75 6e                	jne    802d1b <__rodata_start+0x8b>
  802cad:	74 65                	je     802d14 <__rodata_start+0x84>
  802caf:	72 20                	jb     802cd1 <__rodata_start+0x41>
  802cb1:	69 73 20 25 64 29 00 	imul   $0x296425,0x20(%rbx),%esi
  802cb8:	75 73                	jne    802d2d <__rodata_start+0x9d>
  802cba:	65 72 2f             	gs jb  802cec <__rodata_start+0x5c>
  802cbd:	73 74                	jae    802d33 <__rodata_start+0xa3>
  802cbf:	72 65                	jb     802d26 <__rodata_start+0x96>
  802cc1:	73 73                	jae    802d36 <__rodata_start+0xa6>
  802cc3:	73 63                	jae    802d28 <__rodata_start+0x98>
  802cc5:	68 65 64 2e 63       	push   $0x632e6465
  802cca:	00 3c 75 6e 6b 6e 6f 	add    %bh,0x6f6e6b6e(,%rsi,2)
  802cd1:	77 6e                	ja     802d41 <__rodata_start+0xb1>
  802cd3:	3e 00 0f             	ds add %cl,(%rdi)
  802cd6:	1f                   	(bad)  
  802cd7:	00 5b 25             	add    %bl,0x25(%rbx)
  802cda:	30 38                	xor    %bh,(%rax)
  802cdc:	78 5d                	js     802d3b <__rodata_start+0xab>
  802cde:	20 75 73             	and    %dh,0x73(%rbp)
  802ce1:	65 72 20             	gs jb  802d04 <__rodata_start+0x74>
  802ce4:	70 61                	jo     802d47 <__rodata_start+0xb7>
  802ce6:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ce7:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  802cee:	73 20                	jae    802d10 <__rodata_start+0x80>
  802cf0:	61                   	(bad)  
  802cf1:	74 20                	je     802d13 <__rodata_start+0x83>
  802cf3:	25 73 3a 25 64       	and    $0x64253a73,%eax
  802cf8:	3a 20                	cmp    (%rax),%ah
  802cfa:	00 30                	add    %dh,(%rax)
  802cfc:	31 32                	xor    %esi,(%rdx)
  802cfe:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802d05:	41                   	rex.B
  802d06:	42                   	rex.X
  802d07:	43                   	rex.XB
  802d08:	44                   	rex.R
  802d09:	45                   	rex.RB
  802d0a:	46 00 30             	rex.RX add %r14b,(%rax)
  802d0d:	31 32                	xor    %esi,(%rdx)
  802d0f:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802d16:	61                   	(bad)  
  802d17:	62 63 64 65 66       	(bad)
  802d1c:	00 28                	add    %ch,(%rax)
  802d1e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d1f:	75 6c                	jne    802d8d <__rodata_start+0xfd>
  802d21:	6c                   	insb   (%dx),%es:(%rdi)
  802d22:	29 00                	sub    %eax,(%rax)
  802d24:	65 72 72             	gs jb  802d99 <__rodata_start+0x109>
  802d27:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d28:	72 20                	jb     802d4a <__rodata_start+0xba>
  802d2a:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802d2f:	73 70                	jae    802da1 <__rodata_start+0x111>
  802d31:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802d35:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802d3c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d3d:	72 00                	jb     802d3f <__rodata_start+0xaf>
  802d3f:	62 61 64 20 65       	(bad)
  802d44:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d45:	76 69                	jbe    802db0 <__rodata_start+0x120>
  802d47:	72 6f                	jb     802db8 <__rodata_start+0x128>
  802d49:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d4a:	6d                   	insl   (%dx),%es:(%rdi)
  802d4b:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d4d:	74 00                	je     802d4f <__rodata_start+0xbf>
  802d4f:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802d56:	20 70 61             	and    %dh,0x61(%rax)
  802d59:	72 61                	jb     802dbc <__rodata_start+0x12c>
  802d5b:	6d                   	insl   (%dx),%es:(%rdi)
  802d5c:	65 74 65             	gs je  802dc4 <__rodata_start+0x134>
  802d5f:	72 00                	jb     802d61 <__rodata_start+0xd1>
  802d61:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d62:	75 74                	jne    802dd8 <__rodata_start+0x148>
  802d64:	20 6f 66             	and    %ch,0x66(%rdi)
  802d67:	20 6d 65             	and    %ch,0x65(%rbp)
  802d6a:	6d                   	insl   (%dx),%es:(%rdi)
  802d6b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d6c:	72 79                	jb     802de7 <__rodata_start+0x157>
  802d6e:	00 6f 75             	add    %ch,0x75(%rdi)
  802d71:	74 20                	je     802d93 <__rodata_start+0x103>
  802d73:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d74:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802d78:	76 69                	jbe    802de3 <__rodata_start+0x153>
  802d7a:	72 6f                	jb     802deb <__rodata_start+0x15b>
  802d7c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d7d:	6d                   	insl   (%dx),%es:(%rdi)
  802d7e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d80:	74 73                	je     802df5 <__rodata_start+0x165>
  802d82:	00 63 6f             	add    %ah,0x6f(%rbx)
  802d85:	72 72                	jb     802df9 <__rodata_start+0x169>
  802d87:	75 70                	jne    802df9 <__rodata_start+0x169>
  802d89:	74 65                	je     802df0 <__rodata_start+0x160>
  802d8b:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802d90:	75 67                	jne    802df9 <__rodata_start+0x169>
  802d92:	20 69 6e             	and    %ch,0x6e(%rcx)
  802d95:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802d97:	00 73 65             	add    %dh,0x65(%rbx)
  802d9a:	67 6d                	insl   (%dx),%es:(%edi)
  802d9c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d9e:	74 61                	je     802e01 <__rodata_start+0x171>
  802da0:	74 69                	je     802e0b <__rodata_start+0x17b>
  802da2:	6f                   	outsl  %ds:(%rsi),(%dx)
  802da3:	6e                   	outsb  %ds:(%rsi),(%dx)
  802da4:	20 66 61             	and    %ah,0x61(%rsi)
  802da7:	75 6c                	jne    802e15 <__rodata_start+0x185>
  802da9:	74 00                	je     802dab <__rodata_start+0x11b>
  802dab:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802db2:	20 45 4c             	and    %al,0x4c(%rbp)
  802db5:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802db9:	61                   	(bad)  
  802dba:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802dbf:	20 73 75             	and    %dh,0x75(%rbx)
  802dc2:	63 68 20             	movsxd 0x20(%rax),%ebp
  802dc5:	73 79                	jae    802e40 <__rodata_start+0x1b0>
  802dc7:	73 74                	jae    802e3d <__rodata_start+0x1ad>
  802dc9:	65 6d                	gs insl (%dx),%es:(%rdi)
  802dcb:	20 63 61             	and    %ah,0x61(%rbx)
  802dce:	6c                   	insb   (%dx),%es:(%rdi)
  802dcf:	6c                   	insb   (%dx),%es:(%rdi)
  802dd0:	00 65 6e             	add    %ah,0x6e(%rbp)
  802dd3:	74 72                	je     802e47 <__rodata_start+0x1b7>
  802dd5:	79 20                	jns    802df7 <__rodata_start+0x167>
  802dd7:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dd8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dd9:	74 20                	je     802dfb <__rodata_start+0x16b>
  802ddb:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802ddd:	75 6e                	jne    802e4d <__rodata_start+0x1bd>
  802ddf:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802de3:	76 20                	jbe    802e05 <__rodata_start+0x175>
  802de5:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802dec:	72 65                	jb     802e53 <__rodata_start+0x1c3>
  802dee:	63 76 69             	movsxd 0x69(%rsi),%esi
  802df1:	6e                   	outsb  %ds:(%rsi),(%dx)
  802df2:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802df6:	65 78 70             	gs js  802e69 <__rodata_start+0x1d9>
  802df9:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802dfe:	20 65 6e             	and    %ah,0x6e(%rbp)
  802e01:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802e05:	20 66 69             	and    %ah,0x69(%rsi)
  802e08:	6c                   	insb   (%dx),%es:(%rdi)
  802e09:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802e0d:	20 66 72             	and    %ah,0x72(%rsi)
  802e10:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802e15:	61                   	(bad)  
  802e16:	63 65 20             	movsxd 0x20(%rbp),%esp
  802e19:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e1a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e1b:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802e1f:	6b 00 74             	imul   $0x74,(%rax),%eax
  802e22:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e23:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e24:	20 6d 61             	and    %ch,0x61(%rbp)
  802e27:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e28:	79 20                	jns    802e4a <__rodata_start+0x1ba>
  802e2a:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802e31:	72 65                	jb     802e98 <__rodata_start+0x208>
  802e33:	20 6f 70             	and    %ch,0x70(%rdi)
  802e36:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802e38:	00 66 69             	add    %ah,0x69(%rsi)
  802e3b:	6c                   	insb   (%dx),%es:(%rdi)
  802e3c:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802e40:	20 62 6c             	and    %ah,0x6c(%rdx)
  802e43:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e44:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802e47:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e48:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e49:	74 20                	je     802e6b <__rodata_start+0x1db>
  802e4b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802e4d:	75 6e                	jne    802ebd <__rodata_start+0x22d>
  802e4f:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802e53:	76 61                	jbe    802eb6 <__rodata_start+0x226>
  802e55:	6c                   	insb   (%dx),%es:(%rdi)
  802e56:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802e5d:	00 
  802e5e:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802e65:	72 65                	jb     802ecc <__rodata_start+0x23c>
  802e67:	61                   	(bad)  
  802e68:	64 79 20             	fs jns 802e8b <__rodata_start+0x1fb>
  802e6b:	65 78 69             	gs js  802ed7 <__rodata_start+0x247>
  802e6e:	73 74                	jae    802ee4 <__rodata_start+0x254>
  802e70:	73 00                	jae    802e72 <__rodata_start+0x1e2>
  802e72:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e73:	70 65                	jo     802eda <__rodata_start+0x24a>
  802e75:	72 61                	jb     802ed8 <__rodata_start+0x248>
  802e77:	74 69                	je     802ee2 <__rodata_start+0x252>
  802e79:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e7a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e7b:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802e7e:	74 20                	je     802ea0 <__rodata_start+0x210>
  802e80:	73 75                	jae    802ef7 <__rodata_start+0x267>
  802e82:	70 70                	jo     802ef4 <__rodata_start+0x264>
  802e84:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e85:	72 74                	jb     802efb <__rodata_start+0x26b>
  802e87:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802e8c:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802e93:	00 
  802e94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e9b:	00 00 00 
  802e9e:	66 90                	xchg   %ax,%ax
  802ea0:	75 05                	jne    802ea7 <__rodata_start+0x217>
  802ea2:	80 00 00             	addb   $0x0,(%rax)
  802ea5:	00 00                	add    %al,(%rax)
  802ea7:	00 c9                	add    %cl,%cl
  802ea9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802eaf:	00 b9 0b 80 00 00    	add    %bh,0x800b(%rcx)
  802eb5:	00 00                	add    %al,(%rax)
  802eb7:	00 c9                	add    %cl,%cl
  802eb9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ebf:	00 c9                	add    %cl,%cl
  802ec1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ec7:	00 c9                	add    %cl,%cl
  802ec9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ecf:	00 c9                	add    %cl,%cl
  802ed1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ed7:	00 8f 05 80 00 00    	add    %cl,0x8005(%rdi)
  802edd:	00 00                	add    %al,(%rax)
  802edf:	00 c9                	add    %cl,%cl
  802ee1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ee7:	00 c9                	add    %cl,%cl
  802ee9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802eef:	00 86 05 80 00 00    	add    %al,0x8005(%rsi)
  802ef5:	00 00                	add    %al,(%rax)
  802ef7:	00 fc                	add    %bh,%ah
  802ef9:	05 80 00 00 00       	add    $0x80,%eax
  802efe:	00 00                	add    %al,(%rax)
  802f00:	c9                   	leave  
  802f01:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f07:	00 86 05 80 00 00    	add    %al,0x8005(%rsi)
  802f0d:	00 00                	add    %al,(%rax)
  802f0f:	00 c9                	add    %cl,%cl
  802f11:	05 80 00 00 00       	add    $0x80,%eax
  802f16:	00 00                	add    %al,(%rax)
  802f18:	c9                   	leave  
  802f19:	05 80 00 00 00       	add    $0x80,%eax
  802f1e:	00 00                	add    %al,(%rax)
  802f20:	c9                   	leave  
  802f21:	05 80 00 00 00       	add    $0x80,%eax
  802f26:	00 00                	add    %al,(%rax)
  802f28:	c9                   	leave  
  802f29:	05 80 00 00 00       	add    $0x80,%eax
  802f2e:	00 00                	add    %al,(%rax)
  802f30:	c9                   	leave  
  802f31:	05 80 00 00 00       	add    $0x80,%eax
  802f36:	00 00                	add    %al,(%rax)
  802f38:	c9                   	leave  
  802f39:	05 80 00 00 00       	add    $0x80,%eax
  802f3e:	00 00                	add    %al,(%rax)
  802f40:	c9                   	leave  
  802f41:	05 80 00 00 00       	add    $0x80,%eax
  802f46:	00 00                	add    %al,(%rax)
  802f48:	c9                   	leave  
  802f49:	05 80 00 00 00       	add    $0x80,%eax
  802f4e:	00 00                	add    %al,(%rax)
  802f50:	c9                   	leave  
  802f51:	05 80 00 00 00       	add    $0x80,%eax
  802f56:	00 00                	add    %al,(%rax)
  802f58:	c9                   	leave  
  802f59:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f5f:	00 c9                	add    %cl,%cl
  802f61:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f67:	00 c9                	add    %cl,%cl
  802f69:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f6f:	00 c9                	add    %cl,%cl
  802f71:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f77:	00 c9                	add    %cl,%cl
  802f79:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f7f:	00 c9                	add    %cl,%cl
  802f81:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f87:	00 c9                	add    %cl,%cl
  802f89:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f8f:	00 c9                	add    %cl,%cl
  802f91:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f97:	00 c9                	add    %cl,%cl
  802f99:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f9f:	00 c9                	add    %cl,%cl
  802fa1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fa7:	00 c9                	add    %cl,%cl
  802fa9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802faf:	00 c9                	add    %cl,%cl
  802fb1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fb7:	00 c9                	add    %cl,%cl
  802fb9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fbf:	00 c9                	add    %cl,%cl
  802fc1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fc7:	00 c9                	add    %cl,%cl
  802fc9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fcf:	00 c9                	add    %cl,%cl
  802fd1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fd7:	00 c9                	add    %cl,%cl
  802fd9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fdf:	00 c9                	add    %cl,%cl
  802fe1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fe7:	00 c9                	add    %cl,%cl
  802fe9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fef:	00 c9                	add    %cl,%cl
  802ff1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ff7:	00 c9                	add    %cl,%cl
  802ff9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fff:	00 c9                	add    %cl,%cl
  803001:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803007:	00 c9                	add    %cl,%cl
  803009:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80300f:	00 c9                	add    %cl,%cl
  803011:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803017:	00 c9                	add    %cl,%cl
  803019:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80301f:	00 c9                	add    %cl,%cl
  803021:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803027:	00 c9                	add    %cl,%cl
  803029:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80302f:	00 c9                	add    %cl,%cl
  803031:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803037:	00 c9                	add    %cl,%cl
  803039:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80303f:	00 c9                	add    %cl,%cl
  803041:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803047:	00 ee                	add    %ch,%dh
  803049:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80304f:	00 c9                	add    %cl,%cl
  803051:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803057:	00 c9                	add    %cl,%cl
  803059:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80305f:	00 c9                	add    %cl,%cl
  803061:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803067:	00 c9                	add    %cl,%cl
  803069:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80306f:	00 c9                	add    %cl,%cl
  803071:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803077:	00 c9                	add    %cl,%cl
  803079:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80307f:	00 c9                	add    %cl,%cl
  803081:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803087:	00 c9                	add    %cl,%cl
  803089:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80308f:	00 c9                	add    %cl,%cl
  803091:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803097:	00 c9                	add    %cl,%cl
  803099:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80309f:	00 1a                	add    %bl,(%rdx)
  8030a1:	06                   	(bad)  
  8030a2:	80 00 00             	addb   $0x0,(%rax)
  8030a5:	00 00                	add    %al,(%rax)
  8030a7:	00 10                	add    %dl,(%rax)
  8030a9:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  8030af:	00 c9                	add    %cl,%cl
  8030b1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030b7:	00 c9                	add    %cl,%cl
  8030b9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030bf:	00 c9                	add    %cl,%cl
  8030c1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030c7:	00 c9                	add    %cl,%cl
  8030c9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030cf:	00 48 06             	add    %cl,0x6(%rax)
  8030d2:	80 00 00             	addb   $0x0,(%rax)
  8030d5:	00 00                	add    %al,(%rax)
  8030d7:	00 c9                	add    %cl,%cl
  8030d9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030df:	00 c9                	add    %cl,%cl
  8030e1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030e7:	00 0f                	add    %cl,(%rdi)
  8030e9:	06                   	(bad)  
  8030ea:	80 00 00             	addb   $0x0,(%rax)
  8030ed:	00 00                	add    %al,(%rax)
  8030ef:	00 c9                	add    %cl,%cl
  8030f1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030f7:	00 c9                	add    %cl,%cl
  8030f9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030ff:	00 b0 09 80 00 00    	add    %dh,0x8009(%rax)
  803105:	00 00                	add    %al,(%rax)
  803107:	00 78 0a             	add    %bh,0xa(%rax)
  80310a:	80 00 00             	addb   $0x0,(%rax)
  80310d:	00 00                	add    %al,(%rax)
  80310f:	00 c9                	add    %cl,%cl
  803111:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803117:	00 c9                	add    %cl,%cl
  803119:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80311f:	00 e0                	add    %ah,%al
  803121:	06                   	(bad)  
  803122:	80 00 00             	addb   $0x0,(%rax)
  803125:	00 00                	add    %al,(%rax)
  803127:	00 c9                	add    %cl,%cl
  803129:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80312f:	00 e2                	add    %ah,%dl
  803131:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  803137:	00 c9                	add    %cl,%cl
  803139:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80313f:	00 c9                	add    %cl,%cl
  803141:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803147:	00 ee                	add    %ch,%dh
  803149:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80314f:	00 c9                	add    %cl,%cl
  803151:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803157:	00 7e 05             	add    %bh,0x5(%rsi)
  80315a:	80 00 00             	addb   $0x0,(%rax)
  80315d:	00 00                	add    %al,(%rax)
	...

0000000000803160 <error_string>:
	...
  803168:	2d 2d 80 00 00 00 00 00 3f 2d 80 00 00 00 00 00     --......?-......
  803178:	4f 2d 80 00 00 00 00 00 61 2d 80 00 00 00 00 00     O-......a-......
  803188:	6f 2d 80 00 00 00 00 00 83 2d 80 00 00 00 00 00     o-.......-......
  803198:	98 2d 80 00 00 00 00 00 ab 2d 80 00 00 00 00 00     .-.......-......
  8031a8:	bd 2d 80 00 00 00 00 00 d1 2d 80 00 00 00 00 00     .-.......-......
  8031b8:	e1 2d 80 00 00 00 00 00 f4 2d 80 00 00 00 00 00     .-.......-......
  8031c8:	0b 2e 80 00 00 00 00 00 21 2e 80 00 00 00 00 00     ........!.......
  8031d8:	39 2e 80 00 00 00 00 00 51 2e 80 00 00 00 00 00     9.......Q.......
  8031e8:	5e 2e 80 00 00 00 00 00 00 32 80 00 00 00 00 00     ^........2......
  8031f8:	72 2e 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     r.......file is 
  803208:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803218:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803228:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803238:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803248:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  803258:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  803268:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  803278:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  803288:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  803298:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  8032a8:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  8032b8:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  8032c8:	6c 6c 3a 20 25 69 00 90 5b 25 30 38 78 5d 20 75     ll: %i..[%08x] u
  8032d8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  8032e8:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  8032f8:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803308:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803318:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803328:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803338:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803348:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803358:	84 00 00 00 00 00 66 90                             ......f.

0000000000803360 <devtab>:
  803360:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803370:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803380:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  803390:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  8033a0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  8033b0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  8033c0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  8033d0:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  8033e0:	69 70 63 5f 73 65 6e 64 20 65 72 72 6f 72 3a 20     ipc_send error: 
  8033f0:	25 69 00 6c 69 62 2f 69 70 63 2e 63 00 66 2e 0f     %i.lib/ipc.c.f..
  803400:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803410:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803420:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803430:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803440:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803450:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803460:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803470:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803480:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803490:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8034a0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8034b0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8034c0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8034d0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8034e0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8034f0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803500:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803510:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803520:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803530:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803540:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803550:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803560:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803570:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803580:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803590:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8035a0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8035b0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8035c0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8035d0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8035e0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8035f0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803600:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803610:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803620:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803630:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803640:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803650:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803660:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803670:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803680:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803690:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8036a0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8036b0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8036c0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8036d0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8036e0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8036f0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803700:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803710:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803720:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803730:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803740:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803750:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803760:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803770:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803780:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803790:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8037a0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8037b0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8037c0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8037d0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8037e0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8037f0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803800:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803810:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803820:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803830:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803840:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803850:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803860:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803870:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803880:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803890:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8038a0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8038b0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8038c0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8038d0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8038e0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8038f0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803900:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803910:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803920:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803930:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803940:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803950:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803960:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803970:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803980:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803990:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8039a0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8039b0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8039c0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8039d0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8039e0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8039f0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a00:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a10:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a20:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a30:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803a40:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a50:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a60:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a70:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a80:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803a90:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803aa0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ab0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ac0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ad0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ae0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803af0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b00:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b10:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b20:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b30:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b40:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b50:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b60:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b70:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b80:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b90:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ba0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803bb0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803bc0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803bd0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803be0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803bf0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c00:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c10:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c20:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c30:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c40:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c50:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c60:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c70:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c80:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c90:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ca0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803cb0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803cc0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803cd0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ce0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803cf0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d00:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d10:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d20:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d30:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d40:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d50:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d60:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d70:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d80:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d90:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803da0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803db0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803dc0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803dd0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803de0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803df0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e00:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e10:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e20:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e30:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e40:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e50:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e60:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e70:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e80:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e90:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ea0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803eb0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ec0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ed0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ee0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ef0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f00:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f10:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f20:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f30:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f40:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f50:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f60:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f70:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f80:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f90:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803fa0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803fb0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803fc0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803fd0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803fe0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ff0:	00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00     .f...........D..
