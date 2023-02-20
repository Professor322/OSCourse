
obj/user/testpteshare:     file format elf64-x86-64


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
  80001e:	e8 54 02 00 00       	call   800277 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <childofspawn>:

    breakpoint();
}

void
childofspawn(void) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
    strcpy(VA, msg2);
  800029:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800030:	00 00 00 
  800033:	48 8b 30             	mov    (%rax),%rsi
  800036:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  80003b:	48 b8 d9 0d 80 00 00 	movabs $0x800dd9,%rax
  800042:	00 00 00 
  800045:	ff d0                	call   *%rax
    exit();
  800047:	48 b8 25 03 80 00 00 	movabs $0x800325,%rax
  80004e:	00 00 00 
  800051:	ff d0                	call   *%rax
}
  800053:	5d                   	pop    %rbp
  800054:	c3                   	ret    

0000000000800055 <umain>:
umain(int argc, char **argv) {
  800055:	55                   	push   %rbp
  800056:	48 89 e5             	mov    %rsp,%rbp
  800059:	53                   	push   %rbx
  80005a:	48 83 ec 08          	sub    $0x8,%rsp
    if (argc != 0)
  80005e:	85 ff                	test   %edi,%edi
  800060:	0f 85 4a 01 00 00    	jne    8001b0 <umain+0x15b>
    if ((r = sys_alloc_region(0, VA, PAGE_SIZE, PROT_SHARE | PROT_RW)) < 0)
  800066:	b9 46 00 00 00       	mov    $0x46,%ecx
  80006b:	ba 00 10 00 00       	mov    $0x1000,%edx
  800070:	be 00 00 00 0a       	mov    $0xa000000,%esi
  800075:	bf 00 00 00 00       	mov    $0x0,%edi
  80007a:	48 b8 93 13 80 00 00 	movabs $0x801393,%rax
  800081:	00 00 00 
  800084:	ff d0                	call   *%rax
  800086:	85 c0                	test   %eax,%eax
  800088:	0f 88 33 01 00 00    	js     8001c1 <umain+0x16c>
    if ((r = fork()) < 0)
  80008e:	48 b8 f8 16 80 00 00 	movabs $0x8016f8,%rax
  800095:	00 00 00 
  800098:	ff d0                	call   *%rax
  80009a:	89 c3                	mov    %eax,%ebx
  80009c:	85 c0                	test   %eax,%eax
  80009e:	0f 88 4a 01 00 00    	js     8001ee <umain+0x199>
    if (r == 0) {
  8000a4:	0f 84 71 01 00 00    	je     80021b <umain+0x1c6>
    wait(r);
  8000aa:	89 df                	mov    %ebx,%edi
  8000ac:	48 b8 7d 30 80 00 00 	movabs $0x80307d,%rax
  8000b3:	00 00 00 
  8000b6:	ff d0                	call   *%rax
    cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000b8:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8000bf:	00 00 00 
  8000c2:	48 8b 30             	mov    (%rax),%rsi
  8000c5:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  8000ca:	48 b8 7b 0e 80 00 00 	movabs $0x800e7b,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	call   *%rax
  8000d6:	85 c0                	test   %eax,%eax
  8000d8:	48 be 20 37 80 00 00 	movabs $0x803720,%rsi
  8000df:	00 00 00 
  8000e2:	48 b8 26 37 80 00 00 	movabs $0x803726,%rax
  8000e9:	00 00 00 
  8000ec:	48 0f 45 f0          	cmovne %rax,%rsi
  8000f0:	48 bf 53 37 80 00 00 	movabs $0x803753,%rdi
  8000f7:	00 00 00 
  8000fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ff:	48 ba 98 04 80 00 00 	movabs $0x800498,%rdx
  800106:	00 00 00 
  800109:	ff d2                	call   *%rdx
    if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  80010b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800110:	48 ba 6e 37 80 00 00 	movabs $0x80376e,%rdx
  800117:	00 00 00 
  80011a:	48 be 73 37 80 00 00 	movabs $0x803773,%rsi
  800121:	00 00 00 
  800124:	48 bf 72 37 80 00 00 	movabs $0x803772,%rdi
  80012b:	00 00 00 
  80012e:	b8 00 00 00 00       	mov    $0x0,%eax
  800133:	49 b8 88 2a 80 00 00 	movabs $0x802a88,%r8
  80013a:	00 00 00 
  80013d:	41 ff d0             	call   *%r8
  800140:	89 c7                	mov    %eax,%edi
  800142:	85 c0                	test   %eax,%eax
  800144:	0f 88 00 01 00 00    	js     80024a <umain+0x1f5>
    wait(r);
  80014a:	48 b8 7d 30 80 00 00 	movabs $0x80307d,%rax
  800151:	00 00 00 
  800154:	ff d0                	call   *%rax
    cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800156:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80015d:	00 00 00 
  800160:	48 8b 30             	mov    (%rax),%rsi
  800163:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  800168:	48 b8 7b 0e 80 00 00 	movabs $0x800e7b,%rax
  80016f:	00 00 00 
  800172:	ff d0                	call   *%rax
  800174:	85 c0                	test   %eax,%eax
  800176:	48 be 20 37 80 00 00 	movabs $0x803720,%rsi
  80017d:	00 00 00 
  800180:	48 b8 26 37 80 00 00 	movabs $0x803726,%rax
  800187:	00 00 00 
  80018a:	48 0f 45 f0          	cmovne %rax,%rsi
  80018e:	48 bf 8a 37 80 00 00 	movabs $0x80378a,%rdi
  800195:	00 00 00 
  800198:	b8 00 00 00 00       	mov    $0x0,%eax
  80019d:	48 ba 98 04 80 00 00 	movabs $0x800498,%rdx
  8001a4:	00 00 00 
  8001a7:	ff d2                	call   *%rdx

#include <inc/types.h>

static inline void __attribute__((always_inline))
breakpoint(void) {
    asm volatile("int3");
  8001a9:	cc                   	int3   
}
  8001aa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    
        childofspawn();
  8001b0:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	call   *%rax
  8001bc:	e9 a5 fe ff ff       	jmp    800066 <umain+0x11>
        panic("sys_page_alloc: %i", r);
  8001c1:	89 c1                	mov    %eax,%ecx
  8001c3:	48 ba 2c 37 80 00 00 	movabs $0x80372c,%rdx
  8001ca:	00 00 00 
  8001cd:	be 12 00 00 00       	mov    $0x12,%esi
  8001d2:	48 bf 3f 37 80 00 00 	movabs $0x80373f,%rdi
  8001d9:	00 00 00 
  8001dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e1:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  8001e8:	00 00 00 
  8001eb:	41 ff d0             	call   *%r8
        panic("fork: %i", r);
  8001ee:	89 c1                	mov    %eax,%ecx
  8001f0:	48 ba 54 3d 80 00 00 	movabs $0x803d54,%rdx
  8001f7:	00 00 00 
  8001fa:	be 16 00 00 00       	mov    $0x16,%esi
  8001ff:	48 bf 3f 37 80 00 00 	movabs $0x80373f,%rdi
  800206:	00 00 00 
  800209:	b8 00 00 00 00       	mov    $0x0,%eax
  80020e:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  800215:	00 00 00 
  800218:	41 ff d0             	call   *%r8
        strcpy(VA, msg);
  80021b:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800222:	00 00 00 
  800225:	48 8b 30             	mov    (%rax),%rsi
  800228:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  80022d:	48 b8 d9 0d 80 00 00 	movabs $0x800dd9,%rax
  800234:	00 00 00 
  800237:	ff d0                	call   *%rax
        exit();
  800239:	48 b8 25 03 80 00 00 	movabs $0x800325,%rax
  800240:	00 00 00 
  800243:	ff d0                	call   *%rax
  800245:	e9 60 fe ff ff       	jmp    8000aa <umain+0x55>
        panic("spawn: %i", r);
  80024a:	89 c1                	mov    %eax,%ecx
  80024c:	48 ba 80 37 80 00 00 	movabs $0x803780,%rdx
  800253:	00 00 00 
  800256:	be 20 00 00 00       	mov    $0x20,%esi
  80025b:	48 bf 3f 37 80 00 00 	movabs $0x80373f,%rdi
  800262:	00 00 00 
  800265:	b8 00 00 00 00       	mov    $0x0,%eax
  80026a:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  800271:	00 00 00 
  800274:	41 ff d0             	call   *%r8

0000000000800277 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800277:	55                   	push   %rbp
  800278:	48 89 e5             	mov    %rsp,%rbp
  80027b:	41 56                	push   %r14
  80027d:	41 55                	push   %r13
  80027f:	41 54                	push   %r12
  800281:	53                   	push   %rbx
  800282:	41 89 fd             	mov    %edi,%r13d
  800285:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800288:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80028f:	00 00 00 
  800292:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800299:	00 00 00 
  80029c:	48 39 c2             	cmp    %rax,%rdx
  80029f:	73 17                	jae    8002b8 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  8002a1:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8002a4:	49 89 c4             	mov    %rax,%r12
  8002a7:	48 83 c3 08          	add    $0x8,%rbx
  8002ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b0:	ff 53 f8             	call   *-0x8(%rbx)
  8002b3:	4c 39 e3             	cmp    %r12,%rbx
  8002b6:	72 ef                	jb     8002a7 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8002b8:	48 b8 d3 12 80 00 00 	movabs $0x8012d3,%rax
  8002bf:	00 00 00 
  8002c2:	ff d0                	call   *%rax
  8002c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002c9:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8002cd:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8002d1:	48 c1 e0 04          	shl    $0x4,%rax
  8002d5:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8002dc:	00 00 00 
  8002df:	48 01 d0             	add    %rdx,%rax
  8002e2:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8002e9:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8002ec:	45 85 ed             	test   %r13d,%r13d
  8002ef:	7e 0d                	jle    8002fe <libmain+0x87>
  8002f1:	49 8b 06             	mov    (%r14),%rax
  8002f4:	48 a3 10 40 80 00 00 	movabs %rax,0x804010
  8002fb:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8002fe:	4c 89 f6             	mov    %r14,%rsi
  800301:	44 89 ef             	mov    %r13d,%edi
  800304:	48 b8 55 00 80 00 00 	movabs $0x800055,%rax
  80030b:	00 00 00 
  80030e:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800310:	48 b8 25 03 80 00 00 	movabs $0x800325,%rax
  800317:	00 00 00 
  80031a:	ff d0                	call   *%rax
#endif
}
  80031c:	5b                   	pop    %rbx
  80031d:	41 5c                	pop    %r12
  80031f:	41 5d                	pop    %r13
  800321:	41 5e                	pop    %r14
  800323:	5d                   	pop    %rbp
  800324:	c3                   	ret    

0000000000800325 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800325:	55                   	push   %rbp
  800326:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800329:	48 b8 da 1a 80 00 00 	movabs $0x801ada,%rax
  800330:	00 00 00 
  800333:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800335:	bf 00 00 00 00       	mov    $0x0,%edi
  80033a:	48 b8 68 12 80 00 00 	movabs $0x801268,%rax
  800341:	00 00 00 
  800344:	ff d0                	call   *%rax
}
  800346:	5d                   	pop    %rbp
  800347:	c3                   	ret    

0000000000800348 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800348:	55                   	push   %rbp
  800349:	48 89 e5             	mov    %rsp,%rbp
  80034c:	41 56                	push   %r14
  80034e:	41 55                	push   %r13
  800350:	41 54                	push   %r12
  800352:	53                   	push   %rbx
  800353:	48 83 ec 50          	sub    $0x50,%rsp
  800357:	49 89 fc             	mov    %rdi,%r12
  80035a:	41 89 f5             	mov    %esi,%r13d
  80035d:	48 89 d3             	mov    %rdx,%rbx
  800360:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800364:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800368:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80036c:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800373:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800377:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80037b:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80037f:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800383:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80038a:	00 00 00 
  80038d:	4c 8b 30             	mov    (%rax),%r14
  800390:	48 b8 d3 12 80 00 00 	movabs $0x8012d3,%rax
  800397:	00 00 00 
  80039a:	ff d0                	call   *%rax
  80039c:	89 c6                	mov    %eax,%esi
  80039e:	45 89 e8             	mov    %r13d,%r8d
  8003a1:	4c 89 e1             	mov    %r12,%rcx
  8003a4:	4c 89 f2             	mov    %r14,%rdx
  8003a7:	48 bf d0 37 80 00 00 	movabs $0x8037d0,%rdi
  8003ae:	00 00 00 
  8003b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b6:	49 bc 98 04 80 00 00 	movabs $0x800498,%r12
  8003bd:	00 00 00 
  8003c0:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8003c3:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8003c7:	48 89 df             	mov    %rbx,%rdi
  8003ca:	48 b8 34 04 80 00 00 	movabs $0x800434,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	call   *%rax
    cprintf("\n");
  8003d6:	48 bf b4 37 80 00 00 	movabs $0x8037b4,%rdi
  8003dd:	00 00 00 
  8003e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e5:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8003e8:	cc                   	int3   
  8003e9:	eb fd                	jmp    8003e8 <_panic+0xa0>

00000000008003eb <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8003eb:	55                   	push   %rbp
  8003ec:	48 89 e5             	mov    %rsp,%rbp
  8003ef:	53                   	push   %rbx
  8003f0:	48 83 ec 08          	sub    $0x8,%rsp
  8003f4:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8003f7:	8b 06                	mov    (%rsi),%eax
  8003f9:	8d 50 01             	lea    0x1(%rax),%edx
  8003fc:	89 16                	mov    %edx,(%rsi)
  8003fe:	48 98                	cltq   
  800400:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800405:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80040b:	74 0a                	je     800417 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80040d:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800411:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800415:	c9                   	leave  
  800416:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800417:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80041b:	be ff 00 00 00       	mov    $0xff,%esi
  800420:	48 b8 0a 12 80 00 00 	movabs $0x80120a,%rax
  800427:	00 00 00 
  80042a:	ff d0                	call   *%rax
        state->offset = 0;
  80042c:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800432:	eb d9                	jmp    80040d <putch+0x22>

0000000000800434 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800434:	55                   	push   %rbp
  800435:	48 89 e5             	mov    %rsp,%rbp
  800438:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80043f:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800442:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800449:	b9 21 00 00 00       	mov    $0x21,%ecx
  80044e:	b8 00 00 00 00       	mov    $0x0,%eax
  800453:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800456:	48 89 f1             	mov    %rsi,%rcx
  800459:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800460:	48 bf eb 03 80 00 00 	movabs $0x8003eb,%rdi
  800467:	00 00 00 
  80046a:	48 b8 e8 05 80 00 00 	movabs $0x8005e8,%rax
  800471:	00 00 00 
  800474:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800476:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80047d:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800484:	48 b8 0a 12 80 00 00 	movabs $0x80120a,%rax
  80048b:	00 00 00 
  80048e:	ff d0                	call   *%rax

    return state.count;
}
  800490:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800496:	c9                   	leave  
  800497:	c3                   	ret    

0000000000800498 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800498:	55                   	push   %rbp
  800499:	48 89 e5             	mov    %rsp,%rbp
  80049c:	48 83 ec 50          	sub    $0x50,%rsp
  8004a0:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8004a4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8004a8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8004ac:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8004b0:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8004b4:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8004bb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004bf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004c3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004c7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8004cb:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8004cf:	48 b8 34 04 80 00 00 	movabs $0x800434,%rax
  8004d6:	00 00 00 
  8004d9:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8004db:	c9                   	leave  
  8004dc:	c3                   	ret    

00000000008004dd <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8004dd:	55                   	push   %rbp
  8004de:	48 89 e5             	mov    %rsp,%rbp
  8004e1:	41 57                	push   %r15
  8004e3:	41 56                	push   %r14
  8004e5:	41 55                	push   %r13
  8004e7:	41 54                	push   %r12
  8004e9:	53                   	push   %rbx
  8004ea:	48 83 ec 18          	sub    $0x18,%rsp
  8004ee:	49 89 fc             	mov    %rdi,%r12
  8004f1:	49 89 f5             	mov    %rsi,%r13
  8004f4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8004f8:	8b 45 10             	mov    0x10(%rbp),%eax
  8004fb:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8004fe:	41 89 cf             	mov    %ecx,%r15d
  800501:	49 39 d7             	cmp    %rdx,%r15
  800504:	76 5b                	jbe    800561 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800506:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80050a:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80050e:	85 db                	test   %ebx,%ebx
  800510:	7e 0e                	jle    800520 <print_num+0x43>
            putch(padc, put_arg);
  800512:	4c 89 ee             	mov    %r13,%rsi
  800515:	44 89 f7             	mov    %r14d,%edi
  800518:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80051b:	83 eb 01             	sub    $0x1,%ebx
  80051e:	75 f2                	jne    800512 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800520:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800524:	48 b9 f3 37 80 00 00 	movabs $0x8037f3,%rcx
  80052b:	00 00 00 
  80052e:	48 b8 04 38 80 00 00 	movabs $0x803804,%rax
  800535:	00 00 00 
  800538:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80053c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800540:	ba 00 00 00 00       	mov    $0x0,%edx
  800545:	49 f7 f7             	div    %r15
  800548:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80054c:	4c 89 ee             	mov    %r13,%rsi
  80054f:	41 ff d4             	call   *%r12
}
  800552:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800556:	5b                   	pop    %rbx
  800557:	41 5c                	pop    %r12
  800559:	41 5d                	pop    %r13
  80055b:	41 5e                	pop    %r14
  80055d:	41 5f                	pop    %r15
  80055f:	5d                   	pop    %rbp
  800560:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800561:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800565:	ba 00 00 00 00       	mov    $0x0,%edx
  80056a:	49 f7 f7             	div    %r15
  80056d:	48 83 ec 08          	sub    $0x8,%rsp
  800571:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800575:	52                   	push   %rdx
  800576:	45 0f be c9          	movsbl %r9b,%r9d
  80057a:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80057e:	48 89 c2             	mov    %rax,%rdx
  800581:	48 b8 dd 04 80 00 00 	movabs $0x8004dd,%rax
  800588:	00 00 00 
  80058b:	ff d0                	call   *%rax
  80058d:	48 83 c4 10          	add    $0x10,%rsp
  800591:	eb 8d                	jmp    800520 <print_num+0x43>

0000000000800593 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800593:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800597:	48 8b 06             	mov    (%rsi),%rax
  80059a:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80059e:	73 0a                	jae    8005aa <sprintputch+0x17>
        *state->start++ = ch;
  8005a0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8005a4:	48 89 16             	mov    %rdx,(%rsi)
  8005a7:	40 88 38             	mov    %dil,(%rax)
    }
}
  8005aa:	c3                   	ret    

00000000008005ab <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8005ab:	55                   	push   %rbp
  8005ac:	48 89 e5             	mov    %rsp,%rbp
  8005af:	48 83 ec 50          	sub    $0x50,%rsp
  8005b3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8005b7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8005bb:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8005bf:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8005c6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005ce:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8005d2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8005d6:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8005da:	48 b8 e8 05 80 00 00 	movabs $0x8005e8,%rax
  8005e1:	00 00 00 
  8005e4:	ff d0                	call   *%rax
}
  8005e6:	c9                   	leave  
  8005e7:	c3                   	ret    

00000000008005e8 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8005e8:	55                   	push   %rbp
  8005e9:	48 89 e5             	mov    %rsp,%rbp
  8005ec:	41 57                	push   %r15
  8005ee:	41 56                	push   %r14
  8005f0:	41 55                	push   %r13
  8005f2:	41 54                	push   %r12
  8005f4:	53                   	push   %rbx
  8005f5:	48 83 ec 48          	sub    $0x48,%rsp
  8005f9:	49 89 fc             	mov    %rdi,%r12
  8005fc:	49 89 f6             	mov    %rsi,%r14
  8005ff:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800602:	48 8b 01             	mov    (%rcx),%rax
  800605:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800609:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80060d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800611:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800615:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800619:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  80061d:	41 0f b6 3f          	movzbl (%r15),%edi
  800621:	40 80 ff 25          	cmp    $0x25,%dil
  800625:	74 18                	je     80063f <vprintfmt+0x57>
            if (!ch) return;
  800627:	40 84 ff             	test   %dil,%dil
  80062a:	0f 84 d1 06 00 00    	je     800d01 <vprintfmt+0x719>
            putch(ch, put_arg);
  800630:	40 0f b6 ff          	movzbl %dil,%edi
  800634:	4c 89 f6             	mov    %r14,%rsi
  800637:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80063a:	49 89 df             	mov    %rbx,%r15
  80063d:	eb da                	jmp    800619 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  80063f:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800643:	b9 00 00 00 00       	mov    $0x0,%ecx
  800648:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80064c:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800651:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800657:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80065e:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800662:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800667:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  80066d:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800671:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800675:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800679:	3c 57                	cmp    $0x57,%al
  80067b:	0f 87 65 06 00 00    	ja     800ce6 <vprintfmt+0x6fe>
  800681:	0f b6 c0             	movzbl %al,%eax
  800684:	49 ba a0 39 80 00 00 	movabs $0x8039a0,%r10
  80068b:	00 00 00 
  80068e:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800692:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800695:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800699:	eb d2                	jmp    80066d <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  80069b:	4c 89 fb             	mov    %r15,%rbx
  80069e:	44 89 c1             	mov    %r8d,%ecx
  8006a1:	eb ca                	jmp    80066d <vprintfmt+0x85>
            padc = ch;
  8006a3:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8006a7:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8006aa:	eb c1                	jmp    80066d <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8006ac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006af:	83 f8 2f             	cmp    $0x2f,%eax
  8006b2:	77 24                	ja     8006d8 <vprintfmt+0xf0>
  8006b4:	41 89 c1             	mov    %eax,%r9d
  8006b7:	49 01 f1             	add    %rsi,%r9
  8006ba:	83 c0 08             	add    $0x8,%eax
  8006bd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006c0:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8006c3:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8006c6:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8006ca:	79 a1                	jns    80066d <vprintfmt+0x85>
                width = precision;
  8006cc:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  8006d0:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8006d6:	eb 95                	jmp    80066d <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8006d8:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8006dc:	49 8d 41 08          	lea    0x8(%r9),%rax
  8006e0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006e4:	eb da                	jmp    8006c0 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8006e6:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8006ea:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8006ee:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8006f2:	3c 39                	cmp    $0x39,%al
  8006f4:	77 1e                	ja     800714 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8006f6:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  8006fa:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  8006ff:	0f b6 c0             	movzbl %al,%eax
  800702:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800707:	41 0f b6 07          	movzbl (%r15),%eax
  80070b:	3c 39                	cmp    $0x39,%al
  80070d:	76 e7                	jbe    8006f6 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  80070f:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800712:	eb b2                	jmp    8006c6 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800714:	4c 89 fb             	mov    %r15,%rbx
  800717:	eb ad                	jmp    8006c6 <vprintfmt+0xde>
            width = MAX(0, width);
  800719:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80071c:	85 c0                	test   %eax,%eax
  80071e:	0f 48 c7             	cmovs  %edi,%eax
  800721:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800724:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800727:	e9 41 ff ff ff       	jmp    80066d <vprintfmt+0x85>
            lflag++;
  80072c:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80072f:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800732:	e9 36 ff ff ff       	jmp    80066d <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800737:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80073a:	83 f8 2f             	cmp    $0x2f,%eax
  80073d:	77 18                	ja     800757 <vprintfmt+0x16f>
  80073f:	89 c2                	mov    %eax,%edx
  800741:	48 01 f2             	add    %rsi,%rdx
  800744:	83 c0 08             	add    $0x8,%eax
  800747:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80074a:	4c 89 f6             	mov    %r14,%rsi
  80074d:	8b 3a                	mov    (%rdx),%edi
  80074f:	41 ff d4             	call   *%r12
            break;
  800752:	e9 c2 fe ff ff       	jmp    800619 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800757:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80075b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80075f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800763:	eb e5                	jmp    80074a <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800765:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800768:	83 f8 2f             	cmp    $0x2f,%eax
  80076b:	77 5b                	ja     8007c8 <vprintfmt+0x1e0>
  80076d:	89 c2                	mov    %eax,%edx
  80076f:	48 01 d6             	add    %rdx,%rsi
  800772:	83 c0 08             	add    $0x8,%eax
  800775:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800778:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  80077a:	89 c8                	mov    %ecx,%eax
  80077c:	c1 f8 1f             	sar    $0x1f,%eax
  80077f:	31 c1                	xor    %eax,%ecx
  800781:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800783:	83 f9 13             	cmp    $0x13,%ecx
  800786:	7f 4e                	jg     8007d6 <vprintfmt+0x1ee>
  800788:	48 63 c1             	movslq %ecx,%rax
  80078b:	48 ba 60 3c 80 00 00 	movabs $0x803c60,%rdx
  800792:	00 00 00 
  800795:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800799:	48 85 c0             	test   %rax,%rax
  80079c:	74 38                	je     8007d6 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  80079e:	48 89 c1             	mov    %rax,%rcx
  8007a1:	48 ba 0c 3f 80 00 00 	movabs $0x803f0c,%rdx
  8007a8:	00 00 00 
  8007ab:	4c 89 f6             	mov    %r14,%rsi
  8007ae:	4c 89 e7             	mov    %r12,%rdi
  8007b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b6:	49 b8 ab 05 80 00 00 	movabs $0x8005ab,%r8
  8007bd:	00 00 00 
  8007c0:	41 ff d0             	call   *%r8
  8007c3:	e9 51 fe ff ff       	jmp    800619 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8007c8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007cc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007d0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007d4:	eb a2                	jmp    800778 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8007d6:	48 ba 1c 38 80 00 00 	movabs $0x80381c,%rdx
  8007dd:	00 00 00 
  8007e0:	4c 89 f6             	mov    %r14,%rsi
  8007e3:	4c 89 e7             	mov    %r12,%rdi
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007eb:	49 b8 ab 05 80 00 00 	movabs $0x8005ab,%r8
  8007f2:	00 00 00 
  8007f5:	41 ff d0             	call   *%r8
  8007f8:	e9 1c fe ff ff       	jmp    800619 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  8007fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800800:	83 f8 2f             	cmp    $0x2f,%eax
  800803:	77 55                	ja     80085a <vprintfmt+0x272>
  800805:	89 c2                	mov    %eax,%edx
  800807:	48 01 d6             	add    %rdx,%rsi
  80080a:	83 c0 08             	add    $0x8,%eax
  80080d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800810:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800813:	48 85 d2             	test   %rdx,%rdx
  800816:	48 b8 15 38 80 00 00 	movabs $0x803815,%rax
  80081d:	00 00 00 
  800820:	48 0f 45 c2          	cmovne %rdx,%rax
  800824:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800828:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80082c:	7e 06                	jle    800834 <vprintfmt+0x24c>
  80082e:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800832:	75 34                	jne    800868 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800834:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800838:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80083c:	0f b6 00             	movzbl (%rax),%eax
  80083f:	84 c0                	test   %al,%al
  800841:	0f 84 b2 00 00 00    	je     8008f9 <vprintfmt+0x311>
  800847:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80084b:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800850:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800854:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800858:	eb 74                	jmp    8008ce <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80085a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80085e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800862:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800866:	eb a8                	jmp    800810 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800868:	49 63 f5             	movslq %r13d,%rsi
  80086b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  80086f:	48 b8 bb 0d 80 00 00 	movabs $0x800dbb,%rax
  800876:	00 00 00 
  800879:	ff d0                	call   *%rax
  80087b:	48 89 c2             	mov    %rax,%rdx
  80087e:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800881:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800883:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800886:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800889:	85 c0                	test   %eax,%eax
  80088b:	7e a7                	jle    800834 <vprintfmt+0x24c>
  80088d:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800891:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800895:	41 89 cd             	mov    %ecx,%r13d
  800898:	4c 89 f6             	mov    %r14,%rsi
  80089b:	89 df                	mov    %ebx,%edi
  80089d:	41 ff d4             	call   *%r12
  8008a0:	41 83 ed 01          	sub    $0x1,%r13d
  8008a4:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8008a8:	75 ee                	jne    800898 <vprintfmt+0x2b0>
  8008aa:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8008ae:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8008b2:	eb 80                	jmp    800834 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8008b4:	0f b6 f8             	movzbl %al,%edi
  8008b7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008bb:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8008be:	41 83 ef 01          	sub    $0x1,%r15d
  8008c2:	48 83 c3 01          	add    $0x1,%rbx
  8008c6:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8008ca:	84 c0                	test   %al,%al
  8008cc:	74 1f                	je     8008ed <vprintfmt+0x305>
  8008ce:	45 85 ed             	test   %r13d,%r13d
  8008d1:	78 06                	js     8008d9 <vprintfmt+0x2f1>
  8008d3:	41 83 ed 01          	sub    $0x1,%r13d
  8008d7:	78 46                	js     80091f <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8008d9:	45 84 f6             	test   %r14b,%r14b
  8008dc:	74 d6                	je     8008b4 <vprintfmt+0x2cc>
  8008de:	8d 50 e0             	lea    -0x20(%rax),%edx
  8008e1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8008e6:	80 fa 5e             	cmp    $0x5e,%dl
  8008e9:	77 cc                	ja     8008b7 <vprintfmt+0x2cf>
  8008eb:	eb c7                	jmp    8008b4 <vprintfmt+0x2cc>
  8008ed:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8008f1:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8008f5:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  8008f9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008fc:	8d 58 ff             	lea    -0x1(%rax),%ebx
  8008ff:	85 c0                	test   %eax,%eax
  800901:	0f 8e 12 fd ff ff    	jle    800619 <vprintfmt+0x31>
  800907:	4c 89 f6             	mov    %r14,%rsi
  80090a:	bf 20 00 00 00       	mov    $0x20,%edi
  80090f:	41 ff d4             	call   *%r12
  800912:	83 eb 01             	sub    $0x1,%ebx
  800915:	83 fb ff             	cmp    $0xffffffff,%ebx
  800918:	75 ed                	jne    800907 <vprintfmt+0x31f>
  80091a:	e9 fa fc ff ff       	jmp    800619 <vprintfmt+0x31>
  80091f:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800923:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800927:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80092b:	eb cc                	jmp    8008f9 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  80092d:	45 89 cd             	mov    %r9d,%r13d
  800930:	84 c9                	test   %cl,%cl
  800932:	75 25                	jne    800959 <vprintfmt+0x371>
    switch (lflag) {
  800934:	85 d2                	test   %edx,%edx
  800936:	74 57                	je     80098f <vprintfmt+0x3a7>
  800938:	83 fa 01             	cmp    $0x1,%edx
  80093b:	74 78                	je     8009b5 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  80093d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800940:	83 f8 2f             	cmp    $0x2f,%eax
  800943:	0f 87 92 00 00 00    	ja     8009db <vprintfmt+0x3f3>
  800949:	89 c2                	mov    %eax,%edx
  80094b:	48 01 d6             	add    %rdx,%rsi
  80094e:	83 c0 08             	add    $0x8,%eax
  800951:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800954:	48 8b 1e             	mov    (%rsi),%rbx
  800957:	eb 16                	jmp    80096f <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800959:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095c:	83 f8 2f             	cmp    $0x2f,%eax
  80095f:	77 20                	ja     800981 <vprintfmt+0x399>
  800961:	89 c2                	mov    %eax,%edx
  800963:	48 01 d6             	add    %rdx,%rsi
  800966:	83 c0 08             	add    $0x8,%eax
  800969:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80096c:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  80096f:	48 85 db             	test   %rbx,%rbx
  800972:	78 78                	js     8009ec <vprintfmt+0x404>
            num = i;
  800974:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800977:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80097c:	e9 49 02 00 00       	jmp    800bca <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800981:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800985:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800989:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80098d:	eb dd                	jmp    80096c <vprintfmt+0x384>
        return va_arg(*ap, int);
  80098f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800992:	83 f8 2f             	cmp    $0x2f,%eax
  800995:	77 10                	ja     8009a7 <vprintfmt+0x3bf>
  800997:	89 c2                	mov    %eax,%edx
  800999:	48 01 d6             	add    %rdx,%rsi
  80099c:	83 c0 08             	add    $0x8,%eax
  80099f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009a2:	48 63 1e             	movslq (%rsi),%rbx
  8009a5:	eb c8                	jmp    80096f <vprintfmt+0x387>
  8009a7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009ab:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009af:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009b3:	eb ed                	jmp    8009a2 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  8009b5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b8:	83 f8 2f             	cmp    $0x2f,%eax
  8009bb:	77 10                	ja     8009cd <vprintfmt+0x3e5>
  8009bd:	89 c2                	mov    %eax,%edx
  8009bf:	48 01 d6             	add    %rdx,%rsi
  8009c2:	83 c0 08             	add    $0x8,%eax
  8009c5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009c8:	48 8b 1e             	mov    (%rsi),%rbx
  8009cb:	eb a2                	jmp    80096f <vprintfmt+0x387>
  8009cd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009d1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009d5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009d9:	eb ed                	jmp    8009c8 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  8009db:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009df:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009e3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009e7:	e9 68 ff ff ff       	jmp    800954 <vprintfmt+0x36c>
                putch('-', put_arg);
  8009ec:	4c 89 f6             	mov    %r14,%rsi
  8009ef:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009f4:	41 ff d4             	call   *%r12
                i = -i;
  8009f7:	48 f7 db             	neg    %rbx
  8009fa:	e9 75 ff ff ff       	jmp    800974 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  8009ff:	45 89 cd             	mov    %r9d,%r13d
  800a02:	84 c9                	test   %cl,%cl
  800a04:	75 2d                	jne    800a33 <vprintfmt+0x44b>
    switch (lflag) {
  800a06:	85 d2                	test   %edx,%edx
  800a08:	74 57                	je     800a61 <vprintfmt+0x479>
  800a0a:	83 fa 01             	cmp    $0x1,%edx
  800a0d:	74 7f                	je     800a8e <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800a0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a12:	83 f8 2f             	cmp    $0x2f,%eax
  800a15:	0f 87 a1 00 00 00    	ja     800abc <vprintfmt+0x4d4>
  800a1b:	89 c2                	mov    %eax,%edx
  800a1d:	48 01 d6             	add    %rdx,%rsi
  800a20:	83 c0 08             	add    $0x8,%eax
  800a23:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a26:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800a29:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800a2e:	e9 97 01 00 00       	jmp    800bca <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a36:	83 f8 2f             	cmp    $0x2f,%eax
  800a39:	77 18                	ja     800a53 <vprintfmt+0x46b>
  800a3b:	89 c2                	mov    %eax,%edx
  800a3d:	48 01 d6             	add    %rdx,%rsi
  800a40:	83 c0 08             	add    $0x8,%eax
  800a43:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a46:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800a49:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a4e:	e9 77 01 00 00       	jmp    800bca <vprintfmt+0x5e2>
  800a53:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a57:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a5b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a5f:	eb e5                	jmp    800a46 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800a61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a64:	83 f8 2f             	cmp    $0x2f,%eax
  800a67:	77 17                	ja     800a80 <vprintfmt+0x498>
  800a69:	89 c2                	mov    %eax,%edx
  800a6b:	48 01 d6             	add    %rdx,%rsi
  800a6e:	83 c0 08             	add    $0x8,%eax
  800a71:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a74:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800a76:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800a7b:	e9 4a 01 00 00       	jmp    800bca <vprintfmt+0x5e2>
  800a80:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a84:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a88:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a8c:	eb e6                	jmp    800a74 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800a8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a91:	83 f8 2f             	cmp    $0x2f,%eax
  800a94:	77 18                	ja     800aae <vprintfmt+0x4c6>
  800a96:	89 c2                	mov    %eax,%edx
  800a98:	48 01 d6             	add    %rdx,%rsi
  800a9b:	83 c0 08             	add    $0x8,%eax
  800a9e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aa1:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800aa4:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800aa9:	e9 1c 01 00 00       	jmp    800bca <vprintfmt+0x5e2>
  800aae:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ab2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ab6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aba:	eb e5                	jmp    800aa1 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800abc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ac0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ac4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac8:	e9 59 ff ff ff       	jmp    800a26 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800acd:	45 89 cd             	mov    %r9d,%r13d
  800ad0:	84 c9                	test   %cl,%cl
  800ad2:	75 2d                	jne    800b01 <vprintfmt+0x519>
    switch (lflag) {
  800ad4:	85 d2                	test   %edx,%edx
  800ad6:	74 57                	je     800b2f <vprintfmt+0x547>
  800ad8:	83 fa 01             	cmp    $0x1,%edx
  800adb:	74 7c                	je     800b59 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800add:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae0:	83 f8 2f             	cmp    $0x2f,%eax
  800ae3:	0f 87 9b 00 00 00    	ja     800b84 <vprintfmt+0x59c>
  800ae9:	89 c2                	mov    %eax,%edx
  800aeb:	48 01 d6             	add    %rdx,%rsi
  800aee:	83 c0 08             	add    $0x8,%eax
  800af1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800af4:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800af7:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800afc:	e9 c9 00 00 00       	jmp    800bca <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b04:	83 f8 2f             	cmp    $0x2f,%eax
  800b07:	77 18                	ja     800b21 <vprintfmt+0x539>
  800b09:	89 c2                	mov    %eax,%edx
  800b0b:	48 01 d6             	add    %rdx,%rsi
  800b0e:	83 c0 08             	add    $0x8,%eax
  800b11:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b14:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800b17:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b1c:	e9 a9 00 00 00       	jmp    800bca <vprintfmt+0x5e2>
  800b21:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b25:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b29:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b2d:	eb e5                	jmp    800b14 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800b2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b32:	83 f8 2f             	cmp    $0x2f,%eax
  800b35:	77 14                	ja     800b4b <vprintfmt+0x563>
  800b37:	89 c2                	mov    %eax,%edx
  800b39:	48 01 d6             	add    %rdx,%rsi
  800b3c:	83 c0 08             	add    $0x8,%eax
  800b3f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b42:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800b44:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800b49:	eb 7f                	jmp    800bca <vprintfmt+0x5e2>
  800b4b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b4f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b53:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b57:	eb e9                	jmp    800b42 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800b59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5c:	83 f8 2f             	cmp    $0x2f,%eax
  800b5f:	77 15                	ja     800b76 <vprintfmt+0x58e>
  800b61:	89 c2                	mov    %eax,%edx
  800b63:	48 01 d6             	add    %rdx,%rsi
  800b66:	83 c0 08             	add    $0x8,%eax
  800b69:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b6c:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800b6f:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800b74:	eb 54                	jmp    800bca <vprintfmt+0x5e2>
  800b76:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b7a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b7e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b82:	eb e8                	jmp    800b6c <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800b84:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b88:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b8c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b90:	e9 5f ff ff ff       	jmp    800af4 <vprintfmt+0x50c>
            putch('0', put_arg);
  800b95:	45 89 cd             	mov    %r9d,%r13d
  800b98:	4c 89 f6             	mov    %r14,%rsi
  800b9b:	bf 30 00 00 00       	mov    $0x30,%edi
  800ba0:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800ba3:	4c 89 f6             	mov    %r14,%rsi
  800ba6:	bf 78 00 00 00       	mov    $0x78,%edi
  800bab:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800bae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb1:	83 f8 2f             	cmp    $0x2f,%eax
  800bb4:	77 47                	ja     800bfd <vprintfmt+0x615>
  800bb6:	89 c2                	mov    %eax,%edx
  800bb8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bbc:	83 c0 08             	add    $0x8,%eax
  800bbf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bc2:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800bc5:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800bca:	48 83 ec 08          	sub    $0x8,%rsp
  800bce:	41 80 fd 58          	cmp    $0x58,%r13b
  800bd2:	0f 94 c0             	sete   %al
  800bd5:	0f b6 c0             	movzbl %al,%eax
  800bd8:	50                   	push   %rax
  800bd9:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800bde:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800be2:	4c 89 f6             	mov    %r14,%rsi
  800be5:	4c 89 e7             	mov    %r12,%rdi
  800be8:	48 b8 dd 04 80 00 00 	movabs $0x8004dd,%rax
  800bef:	00 00 00 
  800bf2:	ff d0                	call   *%rax
            break;
  800bf4:	48 83 c4 10          	add    $0x10,%rsp
  800bf8:	e9 1c fa ff ff       	jmp    800619 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800bfd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c01:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c05:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c09:	eb b7                	jmp    800bc2 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800c0b:	45 89 cd             	mov    %r9d,%r13d
  800c0e:	84 c9                	test   %cl,%cl
  800c10:	75 2a                	jne    800c3c <vprintfmt+0x654>
    switch (lflag) {
  800c12:	85 d2                	test   %edx,%edx
  800c14:	74 54                	je     800c6a <vprintfmt+0x682>
  800c16:	83 fa 01             	cmp    $0x1,%edx
  800c19:	74 7c                	je     800c97 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800c1b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c1e:	83 f8 2f             	cmp    $0x2f,%eax
  800c21:	0f 87 9e 00 00 00    	ja     800cc5 <vprintfmt+0x6dd>
  800c27:	89 c2                	mov    %eax,%edx
  800c29:	48 01 d6             	add    %rdx,%rsi
  800c2c:	83 c0 08             	add    $0x8,%eax
  800c2f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c32:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800c35:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800c3a:	eb 8e                	jmp    800bca <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800c3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3f:	83 f8 2f             	cmp    $0x2f,%eax
  800c42:	77 18                	ja     800c5c <vprintfmt+0x674>
  800c44:	89 c2                	mov    %eax,%edx
  800c46:	48 01 d6             	add    %rdx,%rsi
  800c49:	83 c0 08             	add    $0x8,%eax
  800c4c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c4f:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800c52:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c57:	e9 6e ff ff ff       	jmp    800bca <vprintfmt+0x5e2>
  800c5c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c60:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c64:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c68:	eb e5                	jmp    800c4f <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800c6a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6d:	83 f8 2f             	cmp    $0x2f,%eax
  800c70:	77 17                	ja     800c89 <vprintfmt+0x6a1>
  800c72:	89 c2                	mov    %eax,%edx
  800c74:	48 01 d6             	add    %rdx,%rsi
  800c77:	83 c0 08             	add    $0x8,%eax
  800c7a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c7d:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800c7f:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800c84:	e9 41 ff ff ff       	jmp    800bca <vprintfmt+0x5e2>
  800c89:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c8d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c91:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c95:	eb e6                	jmp    800c7d <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800c97:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9a:	83 f8 2f             	cmp    $0x2f,%eax
  800c9d:	77 18                	ja     800cb7 <vprintfmt+0x6cf>
  800c9f:	89 c2                	mov    %eax,%edx
  800ca1:	48 01 d6             	add    %rdx,%rsi
  800ca4:	83 c0 08             	add    $0x8,%eax
  800ca7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800caa:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800cad:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800cb2:	e9 13 ff ff ff       	jmp    800bca <vprintfmt+0x5e2>
  800cb7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800cbb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800cbf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cc3:	eb e5                	jmp    800caa <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800cc5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800cc9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ccd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cd1:	e9 5c ff ff ff       	jmp    800c32 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800cd6:	4c 89 f6             	mov    %r14,%rsi
  800cd9:	bf 25 00 00 00       	mov    $0x25,%edi
  800cde:	41 ff d4             	call   *%r12
            break;
  800ce1:	e9 33 f9 ff ff       	jmp    800619 <vprintfmt+0x31>
            putch('%', put_arg);
  800ce6:	4c 89 f6             	mov    %r14,%rsi
  800ce9:	bf 25 00 00 00       	mov    $0x25,%edi
  800cee:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800cf1:	49 83 ef 01          	sub    $0x1,%r15
  800cf5:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800cfa:	75 f5                	jne    800cf1 <vprintfmt+0x709>
  800cfc:	e9 18 f9 ff ff       	jmp    800619 <vprintfmt+0x31>
}
  800d01:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800d05:	5b                   	pop    %rbx
  800d06:	41 5c                	pop    %r12
  800d08:	41 5d                	pop    %r13
  800d0a:	41 5e                	pop    %r14
  800d0c:	41 5f                	pop    %r15
  800d0e:	5d                   	pop    %rbp
  800d0f:	c3                   	ret    

0000000000800d10 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800d10:	55                   	push   %rbp
  800d11:	48 89 e5             	mov    %rsp,%rbp
  800d14:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800d18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800d1c:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800d21:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800d25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800d2c:	48 85 ff             	test   %rdi,%rdi
  800d2f:	74 2b                	je     800d5c <vsnprintf+0x4c>
  800d31:	48 85 f6             	test   %rsi,%rsi
  800d34:	74 26                	je     800d5c <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800d36:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800d3a:	48 bf 93 05 80 00 00 	movabs $0x800593,%rdi
  800d41:	00 00 00 
  800d44:	48 b8 e8 05 80 00 00 	movabs $0x8005e8,%rax
  800d4b:	00 00 00 
  800d4e:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800d50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d54:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800d57:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800d5a:	c9                   	leave  
  800d5b:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800d5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d61:	eb f7                	jmp    800d5a <vsnprintf+0x4a>

0000000000800d63 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800d63:	55                   	push   %rbp
  800d64:	48 89 e5             	mov    %rsp,%rbp
  800d67:	48 83 ec 50          	sub    $0x50,%rsp
  800d6b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800d6f:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800d73:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800d77:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800d7e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d82:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d86:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d8a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800d8e:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800d92:	48 b8 10 0d 80 00 00 	movabs $0x800d10,%rax
  800d99:	00 00 00 
  800d9c:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

0000000000800da0 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800da0:	80 3f 00             	cmpb   $0x0,(%rdi)
  800da3:	74 10                	je     800db5 <strlen+0x15>
    size_t n = 0;
  800da5:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800daa:	48 83 c0 01          	add    $0x1,%rax
  800dae:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800db2:	75 f6                	jne    800daa <strlen+0xa>
  800db4:	c3                   	ret    
    size_t n = 0;
  800db5:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800dba:	c3                   	ret    

0000000000800dbb <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800dbb:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800dc0:	48 85 f6             	test   %rsi,%rsi
  800dc3:	74 10                	je     800dd5 <strnlen+0x1a>
  800dc5:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800dc9:	74 09                	je     800dd4 <strnlen+0x19>
  800dcb:	48 83 c0 01          	add    $0x1,%rax
  800dcf:	48 39 c6             	cmp    %rax,%rsi
  800dd2:	75 f1                	jne    800dc5 <strnlen+0xa>
    return n;
}
  800dd4:	c3                   	ret    
    size_t n = 0;
  800dd5:	48 89 f0             	mov    %rsi,%rax
  800dd8:	c3                   	ret    

0000000000800dd9 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800dd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dde:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800de2:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800de5:	48 83 c0 01          	add    $0x1,%rax
  800de9:	84 d2                	test   %dl,%dl
  800deb:	75 f1                	jne    800dde <strcpy+0x5>
        ;
    return res;
}
  800ded:	48 89 f8             	mov    %rdi,%rax
  800df0:	c3                   	ret    

0000000000800df1 <strcat>:

char *
strcat(char *dst, const char *src) {
  800df1:	55                   	push   %rbp
  800df2:	48 89 e5             	mov    %rsp,%rbp
  800df5:	41 54                	push   %r12
  800df7:	53                   	push   %rbx
  800df8:	48 89 fb             	mov    %rdi,%rbx
  800dfb:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800dfe:	48 b8 a0 0d 80 00 00 	movabs $0x800da0,%rax
  800e05:	00 00 00 
  800e08:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800e0a:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800e0e:	4c 89 e6             	mov    %r12,%rsi
  800e11:	48 b8 d9 0d 80 00 00 	movabs $0x800dd9,%rax
  800e18:	00 00 00 
  800e1b:	ff d0                	call   *%rax
    return dst;
}
  800e1d:	48 89 d8             	mov    %rbx,%rax
  800e20:	5b                   	pop    %rbx
  800e21:	41 5c                	pop    %r12
  800e23:	5d                   	pop    %rbp
  800e24:	c3                   	ret    

0000000000800e25 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800e25:	48 85 d2             	test   %rdx,%rdx
  800e28:	74 1d                	je     800e47 <strncpy+0x22>
  800e2a:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800e2e:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800e31:	48 83 c0 01          	add    $0x1,%rax
  800e35:	0f b6 16             	movzbl (%rsi),%edx
  800e38:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800e3b:	80 fa 01             	cmp    $0x1,%dl
  800e3e:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800e42:	48 39 c1             	cmp    %rax,%rcx
  800e45:	75 ea                	jne    800e31 <strncpy+0xc>
    }
    return ret;
}
  800e47:	48 89 f8             	mov    %rdi,%rax
  800e4a:	c3                   	ret    

0000000000800e4b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800e4b:	48 89 f8             	mov    %rdi,%rax
  800e4e:	48 85 d2             	test   %rdx,%rdx
  800e51:	74 24                	je     800e77 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800e53:	48 83 ea 01          	sub    $0x1,%rdx
  800e57:	74 1b                	je     800e74 <strlcpy+0x29>
  800e59:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800e5d:	0f b6 16             	movzbl (%rsi),%edx
  800e60:	84 d2                	test   %dl,%dl
  800e62:	74 10                	je     800e74 <strlcpy+0x29>
            *dst++ = *src++;
  800e64:	48 83 c6 01          	add    $0x1,%rsi
  800e68:	48 83 c0 01          	add    $0x1,%rax
  800e6c:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800e6f:	48 39 c8             	cmp    %rcx,%rax
  800e72:	75 e9                	jne    800e5d <strlcpy+0x12>
        *dst = '\0';
  800e74:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800e77:	48 29 f8             	sub    %rdi,%rax
}
  800e7a:	c3                   	ret    

0000000000800e7b <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800e7b:	0f b6 07             	movzbl (%rdi),%eax
  800e7e:	84 c0                	test   %al,%al
  800e80:	74 13                	je     800e95 <strcmp+0x1a>
  800e82:	38 06                	cmp    %al,(%rsi)
  800e84:	75 0f                	jne    800e95 <strcmp+0x1a>
  800e86:	48 83 c7 01          	add    $0x1,%rdi
  800e8a:	48 83 c6 01          	add    $0x1,%rsi
  800e8e:	0f b6 07             	movzbl (%rdi),%eax
  800e91:	84 c0                	test   %al,%al
  800e93:	75 ed                	jne    800e82 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800e95:	0f b6 c0             	movzbl %al,%eax
  800e98:	0f b6 16             	movzbl (%rsi),%edx
  800e9b:	29 d0                	sub    %edx,%eax
}
  800e9d:	c3                   	ret    

0000000000800e9e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800e9e:	48 85 d2             	test   %rdx,%rdx
  800ea1:	74 1f                	je     800ec2 <strncmp+0x24>
  800ea3:	0f b6 07             	movzbl (%rdi),%eax
  800ea6:	84 c0                	test   %al,%al
  800ea8:	74 1e                	je     800ec8 <strncmp+0x2a>
  800eaa:	3a 06                	cmp    (%rsi),%al
  800eac:	75 1a                	jne    800ec8 <strncmp+0x2a>
  800eae:	48 83 c7 01          	add    $0x1,%rdi
  800eb2:	48 83 c6 01          	add    $0x1,%rsi
  800eb6:	48 83 ea 01          	sub    $0x1,%rdx
  800eba:	75 e7                	jne    800ea3 <strncmp+0x5>

    if (!n) return 0;
  800ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec1:	c3                   	ret    
  800ec2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec7:	c3                   	ret    
  800ec8:	48 85 d2             	test   %rdx,%rdx
  800ecb:	74 09                	je     800ed6 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800ecd:	0f b6 07             	movzbl (%rdi),%eax
  800ed0:	0f b6 16             	movzbl (%rsi),%edx
  800ed3:	29 d0                	sub    %edx,%eax
  800ed5:	c3                   	ret    
    if (!n) return 0;
  800ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800edb:	c3                   	ret    

0000000000800edc <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800edc:	0f b6 07             	movzbl (%rdi),%eax
  800edf:	84 c0                	test   %al,%al
  800ee1:	74 18                	je     800efb <strchr+0x1f>
        if (*str == c) {
  800ee3:	0f be c0             	movsbl %al,%eax
  800ee6:	39 f0                	cmp    %esi,%eax
  800ee8:	74 17                	je     800f01 <strchr+0x25>
    for (; *str; str++) {
  800eea:	48 83 c7 01          	add    $0x1,%rdi
  800eee:	0f b6 07             	movzbl (%rdi),%eax
  800ef1:	84 c0                	test   %al,%al
  800ef3:	75 ee                	jne    800ee3 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  800efa:	c3                   	ret    
  800efb:	b8 00 00 00 00       	mov    $0x0,%eax
  800f00:	c3                   	ret    
  800f01:	48 89 f8             	mov    %rdi,%rax
}
  800f04:	c3                   	ret    

0000000000800f05 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800f05:	0f b6 07             	movzbl (%rdi),%eax
  800f08:	84 c0                	test   %al,%al
  800f0a:	74 16                	je     800f22 <strfind+0x1d>
  800f0c:	0f be c0             	movsbl %al,%eax
  800f0f:	39 f0                	cmp    %esi,%eax
  800f11:	74 13                	je     800f26 <strfind+0x21>
  800f13:	48 83 c7 01          	add    $0x1,%rdi
  800f17:	0f b6 07             	movzbl (%rdi),%eax
  800f1a:	84 c0                	test   %al,%al
  800f1c:	75 ee                	jne    800f0c <strfind+0x7>
  800f1e:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800f21:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800f22:	48 89 f8             	mov    %rdi,%rax
  800f25:	c3                   	ret    
  800f26:	48 89 f8             	mov    %rdi,%rax
  800f29:	c3                   	ret    

0000000000800f2a <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800f2a:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800f2d:	48 89 f8             	mov    %rdi,%rax
  800f30:	48 f7 d8             	neg    %rax
  800f33:	83 e0 07             	and    $0x7,%eax
  800f36:	49 89 d1             	mov    %rdx,%r9
  800f39:	49 29 c1             	sub    %rax,%r9
  800f3c:	78 32                	js     800f70 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800f3e:	40 0f b6 c6          	movzbl %sil,%eax
  800f42:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800f49:	01 01 01 
  800f4c:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800f50:	40 f6 c7 07          	test   $0x7,%dil
  800f54:	75 34                	jne    800f8a <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800f56:	4c 89 c9             	mov    %r9,%rcx
  800f59:	48 c1 f9 03          	sar    $0x3,%rcx
  800f5d:	74 08                	je     800f67 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800f5f:	fc                   	cld    
  800f60:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800f63:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800f67:	4d 85 c9             	test   %r9,%r9
  800f6a:	75 45                	jne    800fb1 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800f6c:	4c 89 c0             	mov    %r8,%rax
  800f6f:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800f70:	48 85 d2             	test   %rdx,%rdx
  800f73:	74 f7                	je     800f6c <memset+0x42>
  800f75:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800f78:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800f7b:	48 83 c0 01          	add    $0x1,%rax
  800f7f:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800f83:	48 39 c2             	cmp    %rax,%rdx
  800f86:	75 f3                	jne    800f7b <memset+0x51>
  800f88:	eb e2                	jmp    800f6c <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800f8a:	40 f6 c7 01          	test   $0x1,%dil
  800f8e:	74 06                	je     800f96 <memset+0x6c>
  800f90:	88 07                	mov    %al,(%rdi)
  800f92:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f96:	40 f6 c7 02          	test   $0x2,%dil
  800f9a:	74 07                	je     800fa3 <memset+0x79>
  800f9c:	66 89 07             	mov    %ax,(%rdi)
  800f9f:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800fa3:	40 f6 c7 04          	test   $0x4,%dil
  800fa7:	74 ad                	je     800f56 <memset+0x2c>
  800fa9:	89 07                	mov    %eax,(%rdi)
  800fab:	48 83 c7 04          	add    $0x4,%rdi
  800faf:	eb a5                	jmp    800f56 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800fb1:	41 f6 c1 04          	test   $0x4,%r9b
  800fb5:	74 06                	je     800fbd <memset+0x93>
  800fb7:	89 07                	mov    %eax,(%rdi)
  800fb9:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800fbd:	41 f6 c1 02          	test   $0x2,%r9b
  800fc1:	74 07                	je     800fca <memset+0xa0>
  800fc3:	66 89 07             	mov    %ax,(%rdi)
  800fc6:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800fca:	41 f6 c1 01          	test   $0x1,%r9b
  800fce:	74 9c                	je     800f6c <memset+0x42>
  800fd0:	88 07                	mov    %al,(%rdi)
  800fd2:	eb 98                	jmp    800f6c <memset+0x42>

0000000000800fd4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800fd4:	48 89 f8             	mov    %rdi,%rax
  800fd7:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800fda:	48 39 fe             	cmp    %rdi,%rsi
  800fdd:	73 39                	jae    801018 <memmove+0x44>
  800fdf:	48 01 f2             	add    %rsi,%rdx
  800fe2:	48 39 fa             	cmp    %rdi,%rdx
  800fe5:	76 31                	jbe    801018 <memmove+0x44>
        s += n;
        d += n;
  800fe7:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800fea:	48 89 d6             	mov    %rdx,%rsi
  800fed:	48 09 fe             	or     %rdi,%rsi
  800ff0:	48 09 ce             	or     %rcx,%rsi
  800ff3:	40 f6 c6 07          	test   $0x7,%sil
  800ff7:	75 12                	jne    80100b <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800ff9:	48 83 ef 08          	sub    $0x8,%rdi
  800ffd:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801001:	48 c1 e9 03          	shr    $0x3,%rcx
  801005:	fd                   	std    
  801006:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801009:	fc                   	cld    
  80100a:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80100b:	48 83 ef 01          	sub    $0x1,%rdi
  80100f:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  801013:	fd                   	std    
  801014:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801016:	eb f1                	jmp    801009 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801018:	48 89 f2             	mov    %rsi,%rdx
  80101b:	48 09 c2             	or     %rax,%rdx
  80101e:	48 09 ca             	or     %rcx,%rdx
  801021:	f6 c2 07             	test   $0x7,%dl
  801024:	75 0c                	jne    801032 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801026:	48 c1 e9 03          	shr    $0x3,%rcx
  80102a:	48 89 c7             	mov    %rax,%rdi
  80102d:	fc                   	cld    
  80102e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801031:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  801032:	48 89 c7             	mov    %rax,%rdi
  801035:	fc                   	cld    
  801036:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801038:	c3                   	ret    

0000000000801039 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801039:	55                   	push   %rbp
  80103a:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80103d:	48 b8 d4 0f 80 00 00 	movabs $0x800fd4,%rax
  801044:	00 00 00 
  801047:	ff d0                	call   *%rax
}
  801049:	5d                   	pop    %rbp
  80104a:	c3                   	ret    

000000000080104b <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80104b:	55                   	push   %rbp
  80104c:	48 89 e5             	mov    %rsp,%rbp
  80104f:	41 57                	push   %r15
  801051:	41 56                	push   %r14
  801053:	41 55                	push   %r13
  801055:	41 54                	push   %r12
  801057:	53                   	push   %rbx
  801058:	48 83 ec 08          	sub    $0x8,%rsp
  80105c:	49 89 fe             	mov    %rdi,%r14
  80105f:	49 89 f7             	mov    %rsi,%r15
  801062:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801065:	48 89 f7             	mov    %rsi,%rdi
  801068:	48 b8 a0 0d 80 00 00 	movabs $0x800da0,%rax
  80106f:	00 00 00 
  801072:	ff d0                	call   *%rax
  801074:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801077:	48 89 de             	mov    %rbx,%rsi
  80107a:	4c 89 f7             	mov    %r14,%rdi
  80107d:	48 b8 bb 0d 80 00 00 	movabs $0x800dbb,%rax
  801084:	00 00 00 
  801087:	ff d0                	call   *%rax
  801089:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80108c:	48 39 c3             	cmp    %rax,%rbx
  80108f:	74 36                	je     8010c7 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  801091:	48 89 d8             	mov    %rbx,%rax
  801094:	4c 29 e8             	sub    %r13,%rax
  801097:	4c 39 e0             	cmp    %r12,%rax
  80109a:	76 30                	jbe    8010cc <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  80109c:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8010a1:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8010a5:	4c 89 fe             	mov    %r15,%rsi
  8010a8:	48 b8 39 10 80 00 00 	movabs $0x801039,%rax
  8010af:	00 00 00 
  8010b2:	ff d0                	call   *%rax
    return dstlen + srclen;
  8010b4:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8010b8:	48 83 c4 08          	add    $0x8,%rsp
  8010bc:	5b                   	pop    %rbx
  8010bd:	41 5c                	pop    %r12
  8010bf:	41 5d                	pop    %r13
  8010c1:	41 5e                	pop    %r14
  8010c3:	41 5f                	pop    %r15
  8010c5:	5d                   	pop    %rbp
  8010c6:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8010c7:	4c 01 e0             	add    %r12,%rax
  8010ca:	eb ec                	jmp    8010b8 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8010cc:	48 83 eb 01          	sub    $0x1,%rbx
  8010d0:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8010d4:	48 89 da             	mov    %rbx,%rdx
  8010d7:	4c 89 fe             	mov    %r15,%rsi
  8010da:	48 b8 39 10 80 00 00 	movabs $0x801039,%rax
  8010e1:	00 00 00 
  8010e4:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8010e6:	49 01 de             	add    %rbx,%r14
  8010e9:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8010ee:	eb c4                	jmp    8010b4 <strlcat+0x69>

00000000008010f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8010f0:	49 89 f0             	mov    %rsi,%r8
  8010f3:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8010f6:	48 85 d2             	test   %rdx,%rdx
  8010f9:	74 2a                	je     801125 <memcmp+0x35>
  8010fb:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801100:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801104:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  801109:	38 ca                	cmp    %cl,%dl
  80110b:	75 0f                	jne    80111c <memcmp+0x2c>
    while (n-- > 0) {
  80110d:	48 83 c0 01          	add    $0x1,%rax
  801111:	48 39 c6             	cmp    %rax,%rsi
  801114:	75 ea                	jne    801100 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801116:	b8 00 00 00 00       	mov    $0x0,%eax
  80111b:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  80111c:	0f b6 c2             	movzbl %dl,%eax
  80111f:	0f b6 c9             	movzbl %cl,%ecx
  801122:	29 c8                	sub    %ecx,%eax
  801124:	c3                   	ret    
    return 0;
  801125:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80112a:	c3                   	ret    

000000000080112b <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80112b:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80112f:	48 39 c7             	cmp    %rax,%rdi
  801132:	73 0f                	jae    801143 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801134:	40 38 37             	cmp    %sil,(%rdi)
  801137:	74 0e                	je     801147 <memfind+0x1c>
    for (; src < end; src++) {
  801139:	48 83 c7 01          	add    $0x1,%rdi
  80113d:	48 39 f8             	cmp    %rdi,%rax
  801140:	75 f2                	jne    801134 <memfind+0x9>
  801142:	c3                   	ret    
  801143:	48 89 f8             	mov    %rdi,%rax
  801146:	c3                   	ret    
  801147:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80114a:	c3                   	ret    

000000000080114b <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80114b:	49 89 f2             	mov    %rsi,%r10
  80114e:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801151:	0f b6 37             	movzbl (%rdi),%esi
  801154:	40 80 fe 20          	cmp    $0x20,%sil
  801158:	74 06                	je     801160 <strtol+0x15>
  80115a:	40 80 fe 09          	cmp    $0x9,%sil
  80115e:	75 13                	jne    801173 <strtol+0x28>
  801160:	48 83 c7 01          	add    $0x1,%rdi
  801164:	0f b6 37             	movzbl (%rdi),%esi
  801167:	40 80 fe 20          	cmp    $0x20,%sil
  80116b:	74 f3                	je     801160 <strtol+0x15>
  80116d:	40 80 fe 09          	cmp    $0x9,%sil
  801171:	74 ed                	je     801160 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801173:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801176:	83 e0 fd             	and    $0xfffffffd,%eax
  801179:	3c 01                	cmp    $0x1,%al
  80117b:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80117f:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801186:	75 11                	jne    801199 <strtol+0x4e>
  801188:	80 3f 30             	cmpb   $0x30,(%rdi)
  80118b:	74 16                	je     8011a3 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80118d:	45 85 c0             	test   %r8d,%r8d
  801190:	b8 0a 00 00 00       	mov    $0xa,%eax
  801195:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  801199:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80119e:	4d 63 c8             	movslq %r8d,%r9
  8011a1:	eb 38                	jmp    8011db <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8011a3:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8011a7:	74 11                	je     8011ba <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8011a9:	45 85 c0             	test   %r8d,%r8d
  8011ac:	75 eb                	jne    801199 <strtol+0x4e>
        s++;
  8011ae:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8011b2:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8011b8:	eb df                	jmp    801199 <strtol+0x4e>
        s += 2;
  8011ba:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8011be:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8011c4:	eb d3                	jmp    801199 <strtol+0x4e>
            dig -= '0';
  8011c6:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8011c9:	0f b6 c8             	movzbl %al,%ecx
  8011cc:	44 39 c1             	cmp    %r8d,%ecx
  8011cf:	7d 1f                	jge    8011f0 <strtol+0xa5>
        val = val * base + dig;
  8011d1:	49 0f af d1          	imul   %r9,%rdx
  8011d5:	0f b6 c0             	movzbl %al,%eax
  8011d8:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8011db:	48 83 c7 01          	add    $0x1,%rdi
  8011df:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8011e3:	3c 39                	cmp    $0x39,%al
  8011e5:	76 df                	jbe    8011c6 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8011e7:	3c 7b                	cmp    $0x7b,%al
  8011e9:	77 05                	ja     8011f0 <strtol+0xa5>
            dig -= 'a' - 10;
  8011eb:	83 e8 57             	sub    $0x57,%eax
  8011ee:	eb d9                	jmp    8011c9 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8011f0:	4d 85 d2             	test   %r10,%r10
  8011f3:	74 03                	je     8011f8 <strtol+0xad>
  8011f5:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8011f8:	48 89 d0             	mov    %rdx,%rax
  8011fb:	48 f7 d8             	neg    %rax
  8011fe:	40 80 fe 2d          	cmp    $0x2d,%sil
  801202:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801206:	48 89 d0             	mov    %rdx,%rax
  801209:	c3                   	ret    

000000000080120a <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80120a:	55                   	push   %rbp
  80120b:	48 89 e5             	mov    %rsp,%rbp
  80120e:	53                   	push   %rbx
  80120f:	48 89 fa             	mov    %rdi,%rdx
  801212:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801215:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80121a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801224:	be 00 00 00 00       	mov    $0x0,%esi
  801229:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80122f:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801231:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801235:	c9                   	leave  
  801236:	c3                   	ret    

0000000000801237 <sys_cgetc>:

int
sys_cgetc(void) {
  801237:	55                   	push   %rbp
  801238:	48 89 e5             	mov    %rsp,%rbp
  80123b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80123c:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801241:	ba 00 00 00 00       	mov    $0x0,%edx
  801246:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80124b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801250:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801255:	be 00 00 00 00       	mov    $0x0,%esi
  80125a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801260:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801262:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801266:	c9                   	leave  
  801267:	c3                   	ret    

0000000000801268 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801268:	55                   	push   %rbp
  801269:	48 89 e5             	mov    %rsp,%rbp
  80126c:	53                   	push   %rbx
  80126d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801271:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801274:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801279:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80127e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801283:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801288:	be 00 00 00 00       	mov    $0x0,%esi
  80128d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801293:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801295:	48 85 c0             	test   %rax,%rax
  801298:	7f 06                	jg     8012a0 <sys_env_destroy+0x38>
}
  80129a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012a0:	49 89 c0             	mov    %rax,%r8
  8012a3:	b9 03 00 00 00       	mov    $0x3,%ecx
  8012a8:	48 ba 20 3d 80 00 00 	movabs $0x803d20,%rdx
  8012af:	00 00 00 
  8012b2:	be 26 00 00 00       	mov    $0x26,%esi
  8012b7:	48 bf 3f 3d 80 00 00 	movabs $0x803d3f,%rdi
  8012be:	00 00 00 
  8012c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c6:	49 b9 48 03 80 00 00 	movabs $0x800348,%r9
  8012cd:	00 00 00 
  8012d0:	41 ff d1             	call   *%r9

00000000008012d3 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8012d3:	55                   	push   %rbp
  8012d4:	48 89 e5             	mov    %rsp,%rbp
  8012d7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8012d8:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ec:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012f1:	be 00 00 00 00       	mov    $0x0,%esi
  8012f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012fc:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8012fe:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801302:	c9                   	leave  
  801303:	c3                   	ret    

0000000000801304 <sys_yield>:

void
sys_yield(void) {
  801304:	55                   	push   %rbp
  801305:	48 89 e5             	mov    %rsp,%rbp
  801308:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801309:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80130e:	ba 00 00 00 00       	mov    $0x0,%edx
  801313:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801318:	bb 00 00 00 00       	mov    $0x0,%ebx
  80131d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801322:	be 00 00 00 00       	mov    $0x0,%esi
  801327:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80132d:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80132f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801333:	c9                   	leave  
  801334:	c3                   	ret    

0000000000801335 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801335:	55                   	push   %rbp
  801336:	48 89 e5             	mov    %rsp,%rbp
  801339:	53                   	push   %rbx
  80133a:	48 89 fa             	mov    %rdi,%rdx
  80133d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801340:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801345:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80134c:	00 00 00 
  80134f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801354:	be 00 00 00 00       	mov    $0x0,%esi
  801359:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80135f:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801361:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801365:	c9                   	leave  
  801366:	c3                   	ret    

0000000000801367 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801367:	55                   	push   %rbp
  801368:	48 89 e5             	mov    %rsp,%rbp
  80136b:	53                   	push   %rbx
  80136c:	49 89 f8             	mov    %rdi,%r8
  80136f:	48 89 d3             	mov    %rdx,%rbx
  801372:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801375:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80137a:	4c 89 c2             	mov    %r8,%rdx
  80137d:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801380:	be 00 00 00 00       	mov    $0x0,%esi
  801385:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80138b:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80138d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801391:	c9                   	leave  
  801392:	c3                   	ret    

0000000000801393 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801393:	55                   	push   %rbp
  801394:	48 89 e5             	mov    %rsp,%rbp
  801397:	53                   	push   %rbx
  801398:	48 83 ec 08          	sub    $0x8,%rsp
  80139c:	89 f8                	mov    %edi,%eax
  80139e:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8013a1:	48 63 f9             	movslq %ecx,%rdi
  8013a4:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013a7:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013ac:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013af:	be 00 00 00 00       	mov    $0x0,%esi
  8013b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013ba:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013bc:	48 85 c0             	test   %rax,%rax
  8013bf:	7f 06                	jg     8013c7 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8013c1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013c7:	49 89 c0             	mov    %rax,%r8
  8013ca:	b9 04 00 00 00       	mov    $0x4,%ecx
  8013cf:	48 ba 20 3d 80 00 00 	movabs $0x803d20,%rdx
  8013d6:	00 00 00 
  8013d9:	be 26 00 00 00       	mov    $0x26,%esi
  8013de:	48 bf 3f 3d 80 00 00 	movabs $0x803d3f,%rdi
  8013e5:	00 00 00 
  8013e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ed:	49 b9 48 03 80 00 00 	movabs $0x800348,%r9
  8013f4:	00 00 00 
  8013f7:	41 ff d1             	call   *%r9

00000000008013fa <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8013fa:	55                   	push   %rbp
  8013fb:	48 89 e5             	mov    %rsp,%rbp
  8013fe:	53                   	push   %rbx
  8013ff:	48 83 ec 08          	sub    $0x8,%rsp
  801403:	89 f8                	mov    %edi,%eax
  801405:	49 89 f2             	mov    %rsi,%r10
  801408:	48 89 cf             	mov    %rcx,%rdi
  80140b:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80140e:	48 63 da             	movslq %edx,%rbx
  801411:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801414:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801419:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80141c:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80141f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801421:	48 85 c0             	test   %rax,%rax
  801424:	7f 06                	jg     80142c <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801426:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80142c:	49 89 c0             	mov    %rax,%r8
  80142f:	b9 05 00 00 00       	mov    $0x5,%ecx
  801434:	48 ba 20 3d 80 00 00 	movabs $0x803d20,%rdx
  80143b:	00 00 00 
  80143e:	be 26 00 00 00       	mov    $0x26,%esi
  801443:	48 bf 3f 3d 80 00 00 	movabs $0x803d3f,%rdi
  80144a:	00 00 00 
  80144d:	b8 00 00 00 00       	mov    $0x0,%eax
  801452:	49 b9 48 03 80 00 00 	movabs $0x800348,%r9
  801459:	00 00 00 
  80145c:	41 ff d1             	call   *%r9

000000000080145f <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80145f:	55                   	push   %rbp
  801460:	48 89 e5             	mov    %rsp,%rbp
  801463:	53                   	push   %rbx
  801464:	48 83 ec 08          	sub    $0x8,%rsp
  801468:	48 89 f1             	mov    %rsi,%rcx
  80146b:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80146e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801471:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801476:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80147b:	be 00 00 00 00       	mov    $0x0,%esi
  801480:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801486:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801488:	48 85 c0             	test   %rax,%rax
  80148b:	7f 06                	jg     801493 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80148d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801491:	c9                   	leave  
  801492:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801493:	49 89 c0             	mov    %rax,%r8
  801496:	b9 06 00 00 00       	mov    $0x6,%ecx
  80149b:	48 ba 20 3d 80 00 00 	movabs $0x803d20,%rdx
  8014a2:	00 00 00 
  8014a5:	be 26 00 00 00       	mov    $0x26,%esi
  8014aa:	48 bf 3f 3d 80 00 00 	movabs $0x803d3f,%rdi
  8014b1:	00 00 00 
  8014b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b9:	49 b9 48 03 80 00 00 	movabs $0x800348,%r9
  8014c0:	00 00 00 
  8014c3:	41 ff d1             	call   *%r9

00000000008014c6 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8014c6:	55                   	push   %rbp
  8014c7:	48 89 e5             	mov    %rsp,%rbp
  8014ca:	53                   	push   %rbx
  8014cb:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8014cf:	48 63 ce             	movslq %esi,%rcx
  8014d2:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014d5:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014df:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014e4:	be 00 00 00 00       	mov    $0x0,%esi
  8014e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014ef:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014f1:	48 85 c0             	test   %rax,%rax
  8014f4:	7f 06                	jg     8014fc <sys_env_set_status+0x36>
}
  8014f6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014fc:	49 89 c0             	mov    %rax,%r8
  8014ff:	b9 09 00 00 00       	mov    $0x9,%ecx
  801504:	48 ba 20 3d 80 00 00 	movabs $0x803d20,%rdx
  80150b:	00 00 00 
  80150e:	be 26 00 00 00       	mov    $0x26,%esi
  801513:	48 bf 3f 3d 80 00 00 	movabs $0x803d3f,%rdi
  80151a:	00 00 00 
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
  801522:	49 b9 48 03 80 00 00 	movabs $0x800348,%r9
  801529:	00 00 00 
  80152c:	41 ff d1             	call   *%r9

000000000080152f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80152f:	55                   	push   %rbp
  801530:	48 89 e5             	mov    %rsp,%rbp
  801533:	53                   	push   %rbx
  801534:	48 83 ec 08          	sub    $0x8,%rsp
  801538:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80153b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80153e:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801543:	bb 00 00 00 00       	mov    $0x0,%ebx
  801548:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80154d:	be 00 00 00 00       	mov    $0x0,%esi
  801552:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801558:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80155a:	48 85 c0             	test   %rax,%rax
  80155d:	7f 06                	jg     801565 <sys_env_set_trapframe+0x36>
}
  80155f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801563:	c9                   	leave  
  801564:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801565:	49 89 c0             	mov    %rax,%r8
  801568:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80156d:	48 ba 20 3d 80 00 00 	movabs $0x803d20,%rdx
  801574:	00 00 00 
  801577:	be 26 00 00 00       	mov    $0x26,%esi
  80157c:	48 bf 3f 3d 80 00 00 	movabs $0x803d3f,%rdi
  801583:	00 00 00 
  801586:	b8 00 00 00 00       	mov    $0x0,%eax
  80158b:	49 b9 48 03 80 00 00 	movabs $0x800348,%r9
  801592:	00 00 00 
  801595:	41 ff d1             	call   *%r9

0000000000801598 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801598:	55                   	push   %rbp
  801599:	48 89 e5             	mov    %rsp,%rbp
  80159c:	53                   	push   %rbx
  80159d:	48 83 ec 08          	sub    $0x8,%rsp
  8015a1:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8015a4:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015a7:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015b6:	be 00 00 00 00       	mov    $0x0,%esi
  8015bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015c1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015c3:	48 85 c0             	test   %rax,%rax
  8015c6:	7f 06                	jg     8015ce <sys_env_set_pgfault_upcall+0x36>
}
  8015c8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015ce:	49 89 c0             	mov    %rax,%r8
  8015d1:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8015d6:	48 ba 20 3d 80 00 00 	movabs $0x803d20,%rdx
  8015dd:	00 00 00 
  8015e0:	be 26 00 00 00       	mov    $0x26,%esi
  8015e5:	48 bf 3f 3d 80 00 00 	movabs $0x803d3f,%rdi
  8015ec:	00 00 00 
  8015ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f4:	49 b9 48 03 80 00 00 	movabs $0x800348,%r9
  8015fb:	00 00 00 
  8015fe:	41 ff d1             	call   *%r9

0000000000801601 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801601:	55                   	push   %rbp
  801602:	48 89 e5             	mov    %rsp,%rbp
  801605:	53                   	push   %rbx
  801606:	89 f8                	mov    %edi,%eax
  801608:	49 89 f1             	mov    %rsi,%r9
  80160b:	48 89 d3             	mov    %rdx,%rbx
  80160e:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801611:	49 63 f0             	movslq %r8d,%rsi
  801614:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801617:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80161c:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80161f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801625:	cd 30                	int    $0x30
}
  801627:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

000000000080162d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80162d:	55                   	push   %rbp
  80162e:	48 89 e5             	mov    %rsp,%rbp
  801631:	53                   	push   %rbx
  801632:	48 83 ec 08          	sub    $0x8,%rsp
  801636:	48 89 fa             	mov    %rdi,%rdx
  801639:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80163c:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801641:	bb 00 00 00 00       	mov    $0x0,%ebx
  801646:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80164b:	be 00 00 00 00       	mov    $0x0,%esi
  801650:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801656:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801658:	48 85 c0             	test   %rax,%rax
  80165b:	7f 06                	jg     801663 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80165d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801661:	c9                   	leave  
  801662:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801663:	49 89 c0             	mov    %rax,%r8
  801666:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80166b:	48 ba 20 3d 80 00 00 	movabs $0x803d20,%rdx
  801672:	00 00 00 
  801675:	be 26 00 00 00       	mov    $0x26,%esi
  80167a:	48 bf 3f 3d 80 00 00 	movabs $0x803d3f,%rdi
  801681:	00 00 00 
  801684:	b8 00 00 00 00       	mov    $0x0,%eax
  801689:	49 b9 48 03 80 00 00 	movabs $0x800348,%r9
  801690:	00 00 00 
  801693:	41 ff d1             	call   *%r9

0000000000801696 <sys_gettime>:

int
sys_gettime(void) {
  801696:	55                   	push   %rbp
  801697:	48 89 e5             	mov    %rsp,%rbp
  80169a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80169b:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016af:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016b4:	be 00 00 00 00       	mov    $0x0,%esi
  8016b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016bf:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8016c1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

00000000008016c7 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8016c7:	55                   	push   %rbp
  8016c8:	48 89 e5             	mov    %rsp,%rbp
  8016cb:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8016cc:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016e0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016e5:	be 00 00 00 00       	mov    $0x0,%esi
  8016ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016f0:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8016f2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

00000000008016f8 <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8016f8:	55                   	push   %rbp
  8016f9:	48 89 e5             	mov    %rsp,%rbp
  8016fc:	53                   	push   %rbx
  8016fd:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  801701:	b8 08 00 00 00       	mov    $0x8,%eax
  801706:	cd 30                	int    $0x30
  801708:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  80170a:	85 c0                	test   %eax,%eax
  80170c:	0f 88 85 00 00 00    	js     801797 <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  801712:	0f 84 ac 00 00 00    	je     8017c4 <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  801718:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  80171e:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801725:	00 00 00 
  801728:	b9 00 00 00 00       	mov    $0x0,%ecx
  80172d:	89 c2                	mov    %eax,%edx
  80172f:	be 00 00 00 00       	mov    $0x0,%esi
  801734:	bf 00 00 00 00       	mov    $0x0,%edi
  801739:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  801740:	00 00 00 
  801743:	ff d0                	call   *%rax
    if (res < 0)
  801745:	85 c0                	test   %eax,%eax
  801747:	0f 88 ad 00 00 00    	js     8017fa <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  80174d:	be 02 00 00 00       	mov    $0x2,%esi
  801752:	89 df                	mov    %ebx,%edi
  801754:	48 b8 c6 14 80 00 00 	movabs $0x8014c6,%rax
  80175b:	00 00 00 
  80175e:	ff d0                	call   *%rax
    if (res < 0)
  801760:	85 c0                	test   %eax,%eax
  801762:	0f 88 bf 00 00 00    	js     801827 <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  801768:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80176f:	00 00 00 
  801772:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  801779:	89 df                	mov    %ebx,%edi
  80177b:	48 b8 98 15 80 00 00 	movabs $0x801598,%rax
  801782:	00 00 00 
  801785:	ff d0                	call   *%rax
    if (res < 0)
  801787:	85 c0                	test   %eax,%eax
  801789:	0f 88 c5 00 00 00    	js     801854 <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  80178f:	89 d8                	mov    %ebx,%eax
  801791:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801795:	c9                   	leave  
  801796:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  801797:	89 c1                	mov    %eax,%ecx
  801799:	48 ba 4d 3d 80 00 00 	movabs $0x803d4d,%rdx
  8017a0:	00 00 00 
  8017a3:	be 1a 00 00 00       	mov    $0x1a,%esi
  8017a8:	48 bf 5d 3d 80 00 00 	movabs $0x803d5d,%rdi
  8017af:	00 00 00 
  8017b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b7:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  8017be:	00 00 00 
  8017c1:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  8017c4:	48 b8 d3 12 80 00 00 	movabs $0x8012d3,%rax
  8017cb:	00 00 00 
  8017ce:	ff d0                	call   *%rax
  8017d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017d5:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8017d9:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8017dd:	48 c1 e0 04          	shl    $0x4,%rax
  8017e1:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8017e8:	00 00 00 
  8017eb:	48 01 d0             	add    %rdx,%rax
  8017ee:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8017f5:	00 00 00 
        return 0;
  8017f8:	eb 95                	jmp    80178f <fork+0x97>
        panic("sys_map_region: %i", res);
  8017fa:	89 c1                	mov    %eax,%ecx
  8017fc:	48 ba 68 3d 80 00 00 	movabs $0x803d68,%rdx
  801803:	00 00 00 
  801806:	be 22 00 00 00       	mov    $0x22,%esi
  80180b:	48 bf 5d 3d 80 00 00 	movabs $0x803d5d,%rdi
  801812:	00 00 00 
  801815:	b8 00 00 00 00       	mov    $0x0,%eax
  80181a:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  801821:	00 00 00 
  801824:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  801827:	89 c1                	mov    %eax,%ecx
  801829:	48 ba 7b 3d 80 00 00 	movabs $0x803d7b,%rdx
  801830:	00 00 00 
  801833:	be 25 00 00 00       	mov    $0x25,%esi
  801838:	48 bf 5d 3d 80 00 00 	movabs $0x803d5d,%rdi
  80183f:	00 00 00 
  801842:	b8 00 00 00 00       	mov    $0x0,%eax
  801847:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  80184e:	00 00 00 
  801851:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  801854:	89 c1                	mov    %eax,%ecx
  801856:	48 ba b0 3d 80 00 00 	movabs $0x803db0,%rdx
  80185d:	00 00 00 
  801860:	be 28 00 00 00       	mov    $0x28,%esi
  801865:	48 bf 5d 3d 80 00 00 	movabs $0x803d5d,%rdi
  80186c:	00 00 00 
  80186f:	b8 00 00 00 00       	mov    $0x0,%eax
  801874:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  80187b:	00 00 00 
  80187e:	41 ff d0             	call   *%r8

0000000000801881 <sfork>:

envid_t
sfork() {
  801881:	55                   	push   %rbp
  801882:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801885:	48 ba 92 3d 80 00 00 	movabs $0x803d92,%rdx
  80188c:	00 00 00 
  80188f:	be 2f 00 00 00       	mov    $0x2f,%esi
  801894:	48 bf 5d 3d 80 00 00 	movabs $0x803d5d,%rdi
  80189b:	00 00 00 
  80189e:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a3:	48 b9 48 03 80 00 00 	movabs $0x800348,%rcx
  8018aa:	00 00 00 
  8018ad:	ff d1                	call   *%rcx

00000000008018af <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8018af:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8018b6:	ff ff ff 
  8018b9:	48 01 f8             	add    %rdi,%rax
  8018bc:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8018c0:	c3                   	ret    

00000000008018c1 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8018c1:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8018c8:	ff ff ff 
  8018cb:	48 01 f8             	add    %rdi,%rax
  8018ce:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8018d2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8018d8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8018dc:	c3                   	ret    

00000000008018dd <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8018dd:	55                   	push   %rbp
  8018de:	48 89 e5             	mov    %rsp,%rbp
  8018e1:	41 57                	push   %r15
  8018e3:	41 56                	push   %r14
  8018e5:	41 55                	push   %r13
  8018e7:	41 54                	push   %r12
  8018e9:	53                   	push   %rbx
  8018ea:	48 83 ec 08          	sub    $0x8,%rsp
  8018ee:	49 89 ff             	mov    %rdi,%r15
  8018f1:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8018f6:	49 bc fe 31 80 00 00 	movabs $0x8031fe,%r12
  8018fd:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801900:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801906:	48 89 df             	mov    %rbx,%rdi
  801909:	41 ff d4             	call   *%r12
  80190c:	83 e0 04             	and    $0x4,%eax
  80190f:	74 1a                	je     80192b <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  801911:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801918:	4c 39 f3             	cmp    %r14,%rbx
  80191b:	75 e9                	jne    801906 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  80191d:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801924:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801929:	eb 03                	jmp    80192e <fd_alloc+0x51>
            *fd_store = fd;
  80192b:	49 89 1f             	mov    %rbx,(%r15)
}
  80192e:	48 83 c4 08          	add    $0x8,%rsp
  801932:	5b                   	pop    %rbx
  801933:	41 5c                	pop    %r12
  801935:	41 5d                	pop    %r13
  801937:	41 5e                	pop    %r14
  801939:	41 5f                	pop    %r15
  80193b:	5d                   	pop    %rbp
  80193c:	c3                   	ret    

000000000080193d <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  80193d:	83 ff 1f             	cmp    $0x1f,%edi
  801940:	77 39                	ja     80197b <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801942:	55                   	push   %rbp
  801943:	48 89 e5             	mov    %rsp,%rbp
  801946:	41 54                	push   %r12
  801948:	53                   	push   %rbx
  801949:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80194c:	48 63 df             	movslq %edi,%rbx
  80194f:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801956:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  80195a:	48 89 df             	mov    %rbx,%rdi
  80195d:	48 b8 fe 31 80 00 00 	movabs $0x8031fe,%rax
  801964:	00 00 00 
  801967:	ff d0                	call   *%rax
  801969:	a8 04                	test   $0x4,%al
  80196b:	74 14                	je     801981 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80196d:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801971:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801976:	5b                   	pop    %rbx
  801977:	41 5c                	pop    %r12
  801979:	5d                   	pop    %rbp
  80197a:	c3                   	ret    
        return -E_INVAL;
  80197b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801980:	c3                   	ret    
        return -E_INVAL;
  801981:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801986:	eb ee                	jmp    801976 <fd_lookup+0x39>

0000000000801988 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801988:	55                   	push   %rbp
  801989:	48 89 e5             	mov    %rsp,%rbp
  80198c:	53                   	push   %rbx
  80198d:	48 83 ec 08          	sub    $0x8,%rsp
  801991:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801994:	48 ba 60 3e 80 00 00 	movabs $0x803e60,%rdx
  80199b:	00 00 00 
  80199e:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8019a5:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8019a8:	39 38                	cmp    %edi,(%rax)
  8019aa:	74 4b                	je     8019f7 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8019ac:	48 83 c2 08          	add    $0x8,%rdx
  8019b0:	48 8b 02             	mov    (%rdx),%rax
  8019b3:	48 85 c0             	test   %rax,%rax
  8019b6:	75 f0                	jne    8019a8 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8019b8:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8019bf:	00 00 00 
  8019c2:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8019c8:	89 fa                	mov    %edi,%edx
  8019ca:	48 bf d0 3d 80 00 00 	movabs $0x803dd0,%rdi
  8019d1:	00 00 00 
  8019d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d9:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  8019e0:	00 00 00 
  8019e3:	ff d1                	call   *%rcx
    *dev = 0;
  8019e5:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  8019ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019f1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    
            *dev = devtab[i];
  8019f7:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  8019fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ff:	eb f0                	jmp    8019f1 <dev_lookup+0x69>

0000000000801a01 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801a01:	55                   	push   %rbp
  801a02:	48 89 e5             	mov    %rsp,%rbp
  801a05:	41 55                	push   %r13
  801a07:	41 54                	push   %r12
  801a09:	53                   	push   %rbx
  801a0a:	48 83 ec 18          	sub    $0x18,%rsp
  801a0e:	49 89 fc             	mov    %rdi,%r12
  801a11:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a14:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801a1b:	ff ff ff 
  801a1e:	4c 01 e7             	add    %r12,%rdi
  801a21:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801a25:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a29:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  801a30:	00 00 00 
  801a33:	ff d0                	call   *%rax
  801a35:	89 c3                	mov    %eax,%ebx
  801a37:	85 c0                	test   %eax,%eax
  801a39:	78 06                	js     801a41 <fd_close+0x40>
  801a3b:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801a3f:	74 18                	je     801a59 <fd_close+0x58>
        return (must_exist ? res : 0);
  801a41:	45 84 ed             	test   %r13b,%r13b
  801a44:	b8 00 00 00 00       	mov    $0x0,%eax
  801a49:	0f 44 d8             	cmove  %eax,%ebx
}
  801a4c:	89 d8                	mov    %ebx,%eax
  801a4e:	48 83 c4 18          	add    $0x18,%rsp
  801a52:	5b                   	pop    %rbx
  801a53:	41 5c                	pop    %r12
  801a55:	41 5d                	pop    %r13
  801a57:	5d                   	pop    %rbp
  801a58:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a59:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a5d:	41 8b 3c 24          	mov    (%r12),%edi
  801a61:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801a68:	00 00 00 
  801a6b:	ff d0                	call   *%rax
  801a6d:	89 c3                	mov    %eax,%ebx
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	78 19                	js     801a8c <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801a73:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a77:	48 8b 40 20          	mov    0x20(%rax),%rax
  801a7b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a80:	48 85 c0             	test   %rax,%rax
  801a83:	74 07                	je     801a8c <fd_close+0x8b>
  801a85:	4c 89 e7             	mov    %r12,%rdi
  801a88:	ff d0                	call   *%rax
  801a8a:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801a8c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a91:	4c 89 e6             	mov    %r12,%rsi
  801a94:	bf 00 00 00 00       	mov    $0x0,%edi
  801a99:	48 b8 5f 14 80 00 00 	movabs $0x80145f,%rax
  801aa0:	00 00 00 
  801aa3:	ff d0                	call   *%rax
    return res;
  801aa5:	eb a5                	jmp    801a4c <fd_close+0x4b>

0000000000801aa7 <close>:

int
close(int fdnum) {
  801aa7:	55                   	push   %rbp
  801aa8:	48 89 e5             	mov    %rsp,%rbp
  801aab:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801aaf:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801ab3:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  801aba:	00 00 00 
  801abd:	ff d0                	call   *%rax
    if (res < 0) return res;
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	78 15                	js     801ad8 <close+0x31>

    return fd_close(fd, 1);
  801ac3:	be 01 00 00 00       	mov    $0x1,%esi
  801ac8:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801acc:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801ad3:	00 00 00 
  801ad6:	ff d0                	call   *%rax
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

0000000000801ada <close_all>:

void
close_all(void) {
  801ada:	55                   	push   %rbp
  801adb:	48 89 e5             	mov    %rsp,%rbp
  801ade:	41 54                	push   %r12
  801ae0:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801ae1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ae6:	49 bc a7 1a 80 00 00 	movabs $0x801aa7,%r12
  801aed:	00 00 00 
  801af0:	89 df                	mov    %ebx,%edi
  801af2:	41 ff d4             	call   *%r12
  801af5:	83 c3 01             	add    $0x1,%ebx
  801af8:	83 fb 20             	cmp    $0x20,%ebx
  801afb:	75 f3                	jne    801af0 <close_all+0x16>
}
  801afd:	5b                   	pop    %rbx
  801afe:	41 5c                	pop    %r12
  801b00:	5d                   	pop    %rbp
  801b01:	c3                   	ret    

0000000000801b02 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801b02:	55                   	push   %rbp
  801b03:	48 89 e5             	mov    %rsp,%rbp
  801b06:	41 56                	push   %r14
  801b08:	41 55                	push   %r13
  801b0a:	41 54                	push   %r12
  801b0c:	53                   	push   %rbx
  801b0d:	48 83 ec 10          	sub    $0x10,%rsp
  801b11:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801b14:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b18:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  801b1f:	00 00 00 
  801b22:	ff d0                	call   *%rax
  801b24:	89 c3                	mov    %eax,%ebx
  801b26:	85 c0                	test   %eax,%eax
  801b28:	0f 88 b7 00 00 00    	js     801be5 <dup+0xe3>
    close(newfdnum);
  801b2e:	44 89 e7             	mov    %r12d,%edi
  801b31:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  801b38:	00 00 00 
  801b3b:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801b3d:	4d 63 ec             	movslq %r12d,%r13
  801b40:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801b47:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801b4b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b4f:	49 be c1 18 80 00 00 	movabs $0x8018c1,%r14
  801b56:	00 00 00 
  801b59:	41 ff d6             	call   *%r14
  801b5c:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801b5f:	4c 89 ef             	mov    %r13,%rdi
  801b62:	41 ff d6             	call   *%r14
  801b65:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801b68:	48 89 df             	mov    %rbx,%rdi
  801b6b:	48 b8 fe 31 80 00 00 	movabs $0x8031fe,%rax
  801b72:	00 00 00 
  801b75:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801b77:	a8 04                	test   $0x4,%al
  801b79:	74 2b                	je     801ba6 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801b7b:	41 89 c1             	mov    %eax,%r9d
  801b7e:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b84:	4c 89 f1             	mov    %r14,%rcx
  801b87:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8c:	48 89 de             	mov    %rbx,%rsi
  801b8f:	bf 00 00 00 00       	mov    $0x0,%edi
  801b94:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  801b9b:	00 00 00 
  801b9e:	ff d0                	call   *%rax
  801ba0:	89 c3                	mov    %eax,%ebx
  801ba2:	85 c0                	test   %eax,%eax
  801ba4:	78 4e                	js     801bf4 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801ba6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801baa:	48 b8 fe 31 80 00 00 	movabs $0x8031fe,%rax
  801bb1:	00 00 00 
  801bb4:	ff d0                	call   *%rax
  801bb6:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801bb9:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801bbf:	4c 89 e9             	mov    %r13,%rcx
  801bc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc7:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801bcb:	bf 00 00 00 00       	mov    $0x0,%edi
  801bd0:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  801bd7:	00 00 00 
  801bda:	ff d0                	call   *%rax
  801bdc:	89 c3                	mov    %eax,%ebx
  801bde:	85 c0                	test   %eax,%eax
  801be0:	78 12                	js     801bf4 <dup+0xf2>

    return newfdnum;
  801be2:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801be5:	89 d8                	mov    %ebx,%eax
  801be7:	48 83 c4 10          	add    $0x10,%rsp
  801beb:	5b                   	pop    %rbx
  801bec:	41 5c                	pop    %r12
  801bee:	41 5d                	pop    %r13
  801bf0:	41 5e                	pop    %r14
  801bf2:	5d                   	pop    %rbp
  801bf3:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801bf4:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bf9:	4c 89 ee             	mov    %r13,%rsi
  801bfc:	bf 00 00 00 00       	mov    $0x0,%edi
  801c01:	49 bc 5f 14 80 00 00 	movabs $0x80145f,%r12
  801c08:	00 00 00 
  801c0b:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801c0e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c13:	4c 89 f6             	mov    %r14,%rsi
  801c16:	bf 00 00 00 00       	mov    $0x0,%edi
  801c1b:	41 ff d4             	call   *%r12
    return res;
  801c1e:	eb c5                	jmp    801be5 <dup+0xe3>

0000000000801c20 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801c20:	55                   	push   %rbp
  801c21:	48 89 e5             	mov    %rsp,%rbp
  801c24:	41 55                	push   %r13
  801c26:	41 54                	push   %r12
  801c28:	53                   	push   %rbx
  801c29:	48 83 ec 18          	sub    $0x18,%rsp
  801c2d:	89 fb                	mov    %edi,%ebx
  801c2f:	49 89 f4             	mov    %rsi,%r12
  801c32:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c35:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c39:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  801c40:	00 00 00 
  801c43:	ff d0                	call   *%rax
  801c45:	85 c0                	test   %eax,%eax
  801c47:	78 49                	js     801c92 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c49:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c51:	8b 38                	mov    (%rax),%edi
  801c53:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801c5a:	00 00 00 
  801c5d:	ff d0                	call   *%rax
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	78 33                	js     801c96 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c63:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c67:	8b 47 08             	mov    0x8(%rdi),%eax
  801c6a:	83 e0 03             	and    $0x3,%eax
  801c6d:	83 f8 01             	cmp    $0x1,%eax
  801c70:	74 28                	je     801c9a <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801c72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c76:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c7a:	48 85 c0             	test   %rax,%rax
  801c7d:	74 51                	je     801cd0 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801c7f:	4c 89 ea             	mov    %r13,%rdx
  801c82:	4c 89 e6             	mov    %r12,%rsi
  801c85:	ff d0                	call   *%rax
}
  801c87:	48 83 c4 18          	add    $0x18,%rsp
  801c8b:	5b                   	pop    %rbx
  801c8c:	41 5c                	pop    %r12
  801c8e:	41 5d                	pop    %r13
  801c90:	5d                   	pop    %rbp
  801c91:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c92:	48 98                	cltq   
  801c94:	eb f1                	jmp    801c87 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c96:	48 98                	cltq   
  801c98:	eb ed                	jmp    801c87 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c9a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801ca1:	00 00 00 
  801ca4:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801caa:	89 da                	mov    %ebx,%edx
  801cac:	48 bf 11 3e 80 00 00 	movabs $0x803e11,%rdi
  801cb3:	00 00 00 
  801cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbb:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  801cc2:	00 00 00 
  801cc5:	ff d1                	call   *%rcx
        return -E_INVAL;
  801cc7:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801cce:	eb b7                	jmp    801c87 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801cd0:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801cd7:	eb ae                	jmp    801c87 <read+0x67>

0000000000801cd9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801cd9:	55                   	push   %rbp
  801cda:	48 89 e5             	mov    %rsp,%rbp
  801cdd:	41 57                	push   %r15
  801cdf:	41 56                	push   %r14
  801ce1:	41 55                	push   %r13
  801ce3:	41 54                	push   %r12
  801ce5:	53                   	push   %rbx
  801ce6:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801cea:	48 85 d2             	test   %rdx,%rdx
  801ced:	74 54                	je     801d43 <readn+0x6a>
  801cef:	41 89 fd             	mov    %edi,%r13d
  801cf2:	49 89 f6             	mov    %rsi,%r14
  801cf5:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801cf8:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801cfd:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801d02:	49 bf 20 1c 80 00 00 	movabs $0x801c20,%r15
  801d09:	00 00 00 
  801d0c:	4c 89 e2             	mov    %r12,%rdx
  801d0f:	48 29 f2             	sub    %rsi,%rdx
  801d12:	4c 01 f6             	add    %r14,%rsi
  801d15:	44 89 ef             	mov    %r13d,%edi
  801d18:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	78 20                	js     801d3f <readn+0x66>
    for (; inc && res < n; res += inc) {
  801d1f:	01 c3                	add    %eax,%ebx
  801d21:	85 c0                	test   %eax,%eax
  801d23:	74 08                	je     801d2d <readn+0x54>
  801d25:	48 63 f3             	movslq %ebx,%rsi
  801d28:	4c 39 e6             	cmp    %r12,%rsi
  801d2b:	72 df                	jb     801d0c <readn+0x33>
    }
    return res;
  801d2d:	48 63 c3             	movslq %ebx,%rax
}
  801d30:	48 83 c4 08          	add    $0x8,%rsp
  801d34:	5b                   	pop    %rbx
  801d35:	41 5c                	pop    %r12
  801d37:	41 5d                	pop    %r13
  801d39:	41 5e                	pop    %r14
  801d3b:	41 5f                	pop    %r15
  801d3d:	5d                   	pop    %rbp
  801d3e:	c3                   	ret    
        if (inc < 0) return inc;
  801d3f:	48 98                	cltq   
  801d41:	eb ed                	jmp    801d30 <readn+0x57>
    int inc = 1, res = 0;
  801d43:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d48:	eb e3                	jmp    801d2d <readn+0x54>

0000000000801d4a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801d4a:	55                   	push   %rbp
  801d4b:	48 89 e5             	mov    %rsp,%rbp
  801d4e:	41 55                	push   %r13
  801d50:	41 54                	push   %r12
  801d52:	53                   	push   %rbx
  801d53:	48 83 ec 18          	sub    $0x18,%rsp
  801d57:	89 fb                	mov    %edi,%ebx
  801d59:	49 89 f4             	mov    %rsi,%r12
  801d5c:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d5f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d63:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  801d6a:	00 00 00 
  801d6d:	ff d0                	call   *%rax
  801d6f:	85 c0                	test   %eax,%eax
  801d71:	78 44                	js     801db7 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d73:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d7b:	8b 38                	mov    (%rax),%edi
  801d7d:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801d84:	00 00 00 
  801d87:	ff d0                	call   *%rax
  801d89:	85 c0                	test   %eax,%eax
  801d8b:	78 2e                	js     801dbb <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d8d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801d91:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801d95:	74 28                	je     801dbf <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801d97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d9b:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d9f:	48 85 c0             	test   %rax,%rax
  801da2:	74 51                	je     801df5 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801da4:	4c 89 ea             	mov    %r13,%rdx
  801da7:	4c 89 e6             	mov    %r12,%rsi
  801daa:	ff d0                	call   *%rax
}
  801dac:	48 83 c4 18          	add    $0x18,%rsp
  801db0:	5b                   	pop    %rbx
  801db1:	41 5c                	pop    %r12
  801db3:	41 5d                	pop    %r13
  801db5:	5d                   	pop    %rbp
  801db6:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801db7:	48 98                	cltq   
  801db9:	eb f1                	jmp    801dac <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801dbb:	48 98                	cltq   
  801dbd:	eb ed                	jmp    801dac <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801dbf:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801dc6:	00 00 00 
  801dc9:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801dcf:	89 da                	mov    %ebx,%edx
  801dd1:	48 bf 2d 3e 80 00 00 	movabs $0x803e2d,%rdi
  801dd8:	00 00 00 
  801ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  801de0:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  801de7:	00 00 00 
  801dea:	ff d1                	call   *%rcx
        return -E_INVAL;
  801dec:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801df3:	eb b7                	jmp    801dac <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801df5:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801dfc:	eb ae                	jmp    801dac <write+0x62>

0000000000801dfe <seek>:

int
seek(int fdnum, off_t offset) {
  801dfe:	55                   	push   %rbp
  801dff:	48 89 e5             	mov    %rsp,%rbp
  801e02:	53                   	push   %rbx
  801e03:	48 83 ec 18          	sub    $0x18,%rsp
  801e07:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e09:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e0d:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  801e14:	00 00 00 
  801e17:	ff d0                	call   *%rax
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	78 0c                	js     801e29 <seek+0x2b>

    fd->fd_offset = offset;
  801e1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e21:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e29:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

0000000000801e2f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801e2f:	55                   	push   %rbp
  801e30:	48 89 e5             	mov    %rsp,%rbp
  801e33:	41 54                	push   %r12
  801e35:	53                   	push   %rbx
  801e36:	48 83 ec 10          	sub    $0x10,%rsp
  801e3a:	89 fb                	mov    %edi,%ebx
  801e3c:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e3f:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e43:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  801e4a:	00 00 00 
  801e4d:	ff d0                	call   *%rax
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	78 36                	js     801e89 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e53:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801e57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e5b:	8b 38                	mov    (%rax),%edi
  801e5d:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801e64:	00 00 00 
  801e67:	ff d0                	call   *%rax
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	78 1c                	js     801e89 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e6d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e71:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801e75:	74 1b                	je     801e92 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801e77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e7b:	48 8b 40 30          	mov    0x30(%rax),%rax
  801e7f:	48 85 c0             	test   %rax,%rax
  801e82:	74 42                	je     801ec6 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801e84:	44 89 e6             	mov    %r12d,%esi
  801e87:	ff d0                	call   *%rax
}
  801e89:	48 83 c4 10          	add    $0x10,%rsp
  801e8d:	5b                   	pop    %rbx
  801e8e:	41 5c                	pop    %r12
  801e90:	5d                   	pop    %rbp
  801e91:	c3                   	ret    
                thisenv->env_id, fdnum);
  801e92:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801e99:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e9c:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ea2:	89 da                	mov    %ebx,%edx
  801ea4:	48 bf f0 3d 80 00 00 	movabs $0x803df0,%rdi
  801eab:	00 00 00 
  801eae:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb3:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  801eba:	00 00 00 
  801ebd:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ebf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ec4:	eb c3                	jmp    801e89 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801ec6:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ecb:	eb bc                	jmp    801e89 <ftruncate+0x5a>

0000000000801ecd <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801ecd:	55                   	push   %rbp
  801ece:	48 89 e5             	mov    %rsp,%rbp
  801ed1:	53                   	push   %rbx
  801ed2:	48 83 ec 18          	sub    $0x18,%rsp
  801ed6:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ed9:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801edd:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  801ee4:	00 00 00 
  801ee7:	ff d0                	call   *%rax
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	78 4d                	js     801f3a <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801eed:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801ef1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef5:	8b 38                	mov    (%rax),%edi
  801ef7:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801efe:	00 00 00 
  801f01:	ff d0                	call   *%rax
  801f03:	85 c0                	test   %eax,%eax
  801f05:	78 33                	js     801f3a <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f0b:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801f10:	74 2e                	je     801f40 <fstat+0x73>

    stat->st_name[0] = 0;
  801f12:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801f15:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801f1c:	00 00 00 
    stat->st_isdir = 0;
  801f1f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801f26:	00 00 00 
    stat->st_dev = dev;
  801f29:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801f30:	48 89 de             	mov    %rbx,%rsi
  801f33:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f37:	ff 50 28             	call   *0x28(%rax)
}
  801f3a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f40:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f45:	eb f3                	jmp    801f3a <fstat+0x6d>

0000000000801f47 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801f47:	55                   	push   %rbp
  801f48:	48 89 e5             	mov    %rsp,%rbp
  801f4b:	41 54                	push   %r12
  801f4d:	53                   	push   %rbx
  801f4e:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801f51:	be 00 00 00 00       	mov    $0x0,%esi
  801f56:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  801f5d:	00 00 00 
  801f60:	ff d0                	call   *%rax
  801f62:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801f64:	85 c0                	test   %eax,%eax
  801f66:	78 25                	js     801f8d <stat+0x46>

    int res = fstat(fd, stat);
  801f68:	4c 89 e6             	mov    %r12,%rsi
  801f6b:	89 c7                	mov    %eax,%edi
  801f6d:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  801f74:	00 00 00 
  801f77:	ff d0                	call   *%rax
  801f79:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801f7c:	89 df                	mov    %ebx,%edi
  801f7e:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  801f85:	00 00 00 
  801f88:	ff d0                	call   *%rax

    return res;
  801f8a:	44 89 e3             	mov    %r12d,%ebx
}
  801f8d:	89 d8                	mov    %ebx,%eax
  801f8f:	5b                   	pop    %rbx
  801f90:	41 5c                	pop    %r12
  801f92:	5d                   	pop    %rbp
  801f93:	c3                   	ret    

0000000000801f94 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801f94:	55                   	push   %rbp
  801f95:	48 89 e5             	mov    %rsp,%rbp
  801f98:	41 54                	push   %r12
  801f9a:	53                   	push   %rbx
  801f9b:	48 83 ec 10          	sub    $0x10,%rsp
  801f9f:	41 89 fc             	mov    %edi,%r12d
  801fa2:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801fa5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801fac:	00 00 00 
  801faf:	83 38 00             	cmpl   $0x0,(%rax)
  801fb2:	74 5e                	je     802012 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801fb4:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801fba:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801fbf:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801fc6:	00 00 00 
  801fc9:	44 89 e6             	mov    %r12d,%esi
  801fcc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801fd3:	00 00 00 
  801fd6:	8b 38                	mov    (%rax),%edi
  801fd8:	48 b8 1f 36 80 00 00 	movabs $0x80361f,%rax
  801fdf:	00 00 00 
  801fe2:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801fe4:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801feb:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801fec:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ff1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ff5:	48 89 de             	mov    %rbx,%rsi
  801ff8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ffd:	48 b8 80 35 80 00 00 	movabs $0x803580,%rax
  802004:	00 00 00 
  802007:	ff d0                	call   *%rax
}
  802009:	48 83 c4 10          	add    $0x10,%rsp
  80200d:	5b                   	pop    %rbx
  80200e:	41 5c                	pop    %r12
  802010:	5d                   	pop    %rbp
  802011:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802012:	bf 03 00 00 00       	mov    $0x3,%edi
  802017:	48 b8 c2 36 80 00 00 	movabs $0x8036c2,%rax
  80201e:	00 00 00 
  802021:	ff d0                	call   *%rax
  802023:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80202a:	00 00 
  80202c:	eb 86                	jmp    801fb4 <fsipc+0x20>

000000000080202e <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80202e:	55                   	push   %rbp
  80202f:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802032:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802039:	00 00 00 
  80203c:	8b 57 0c             	mov    0xc(%rdi),%edx
  80203f:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802041:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802044:	be 00 00 00 00       	mov    $0x0,%esi
  802049:	bf 02 00 00 00       	mov    $0x2,%edi
  80204e:	48 b8 94 1f 80 00 00 	movabs $0x801f94,%rax
  802055:	00 00 00 
  802058:	ff d0                	call   *%rax
}
  80205a:	5d                   	pop    %rbp
  80205b:	c3                   	ret    

000000000080205c <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80205c:	55                   	push   %rbp
  80205d:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802060:	8b 47 0c             	mov    0xc(%rdi),%eax
  802063:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  80206a:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  80206c:	be 00 00 00 00       	mov    $0x0,%esi
  802071:	bf 06 00 00 00       	mov    $0x6,%edi
  802076:	48 b8 94 1f 80 00 00 	movabs $0x801f94,%rax
  80207d:	00 00 00 
  802080:	ff d0                	call   *%rax
}
  802082:	5d                   	pop    %rbp
  802083:	c3                   	ret    

0000000000802084 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802084:	55                   	push   %rbp
  802085:	48 89 e5             	mov    %rsp,%rbp
  802088:	53                   	push   %rbx
  802089:	48 83 ec 08          	sub    $0x8,%rsp
  80208d:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802090:	8b 47 0c             	mov    0xc(%rdi),%eax
  802093:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  80209a:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  80209c:	be 00 00 00 00       	mov    $0x0,%esi
  8020a1:	bf 05 00 00 00       	mov    $0x5,%edi
  8020a6:	48 b8 94 1f 80 00 00 	movabs $0x801f94,%rax
  8020ad:	00 00 00 
  8020b0:	ff d0                	call   *%rax
    if (res < 0) return res;
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	78 40                	js     8020f6 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8020b6:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8020bd:	00 00 00 
  8020c0:	48 89 df             	mov    %rbx,%rdi
  8020c3:	48 b8 d9 0d 80 00 00 	movabs $0x800dd9,%rax
  8020ca:	00 00 00 
  8020cd:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8020cf:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8020d6:	00 00 00 
  8020d9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8020df:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8020e5:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8020eb:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8020f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

00000000008020fc <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8020fc:	55                   	push   %rbp
  8020fd:	48 89 e5             	mov    %rsp,%rbp
  802100:	41 57                	push   %r15
  802102:	41 56                	push   %r14
  802104:	41 55                	push   %r13
  802106:	41 54                	push   %r12
  802108:	53                   	push   %rbx
  802109:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  80210d:	48 85 d2             	test   %rdx,%rdx
  802110:	0f 84 91 00 00 00    	je     8021a7 <devfile_write+0xab>
  802116:	49 89 ff             	mov    %rdi,%r15
  802119:	49 89 f4             	mov    %rsi,%r12
  80211c:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  80211f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802126:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  80212d:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802130:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  802137:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  80213d:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  802141:	4c 89 ea             	mov    %r13,%rdx
  802144:	4c 89 e6             	mov    %r12,%rsi
  802147:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  80214e:	00 00 00 
  802151:	48 b8 39 10 80 00 00 	movabs $0x801039,%rax
  802158:	00 00 00 
  80215b:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80215d:	41 8b 47 0c          	mov    0xc(%r15),%eax
  802161:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  802164:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  802168:	be 00 00 00 00       	mov    $0x0,%esi
  80216d:	bf 04 00 00 00       	mov    $0x4,%edi
  802172:	48 b8 94 1f 80 00 00 	movabs $0x801f94,%rax
  802179:	00 00 00 
  80217c:	ff d0                	call   *%rax
        if (res < 0)
  80217e:	85 c0                	test   %eax,%eax
  802180:	78 21                	js     8021a3 <devfile_write+0xa7>
        buf += res;
  802182:	48 63 d0             	movslq %eax,%rdx
  802185:	49 01 d4             	add    %rdx,%r12
        ext += res;
  802188:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  80218b:	48 29 d3             	sub    %rdx,%rbx
  80218e:	75 a0                	jne    802130 <devfile_write+0x34>
    return ext;
  802190:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  802194:	48 83 c4 18          	add    $0x18,%rsp
  802198:	5b                   	pop    %rbx
  802199:	41 5c                	pop    %r12
  80219b:	41 5d                	pop    %r13
  80219d:	41 5e                	pop    %r14
  80219f:	41 5f                	pop    %r15
  8021a1:	5d                   	pop    %rbp
  8021a2:	c3                   	ret    
            return res;
  8021a3:	48 98                	cltq   
  8021a5:	eb ed                	jmp    802194 <devfile_write+0x98>
    int ext = 0;
  8021a7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  8021ae:	eb e0                	jmp    802190 <devfile_write+0x94>

00000000008021b0 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8021b0:	55                   	push   %rbp
  8021b1:	48 89 e5             	mov    %rsp,%rbp
  8021b4:	41 54                	push   %r12
  8021b6:	53                   	push   %rbx
  8021b7:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  8021ba:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8021c1:	00 00 00 
  8021c4:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8021c7:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  8021c9:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  8021cd:	be 00 00 00 00       	mov    $0x0,%esi
  8021d2:	bf 03 00 00 00       	mov    $0x3,%edi
  8021d7:	48 b8 94 1f 80 00 00 	movabs $0x801f94,%rax
  8021de:	00 00 00 
  8021e1:	ff d0                	call   *%rax
    if (read < 0) 
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	78 27                	js     80220e <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  8021e7:	48 63 d8             	movslq %eax,%rbx
  8021ea:	48 89 da             	mov    %rbx,%rdx
  8021ed:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8021f4:	00 00 00 
  8021f7:	4c 89 e7             	mov    %r12,%rdi
  8021fa:	48 b8 d4 0f 80 00 00 	movabs $0x800fd4,%rax
  802201:	00 00 00 
  802204:	ff d0                	call   *%rax
    return read;
  802206:	48 89 d8             	mov    %rbx,%rax
}
  802209:	5b                   	pop    %rbx
  80220a:	41 5c                	pop    %r12
  80220c:	5d                   	pop    %rbp
  80220d:	c3                   	ret    
		return read;
  80220e:	48 98                	cltq   
  802210:	eb f7                	jmp    802209 <devfile_read+0x59>

0000000000802212 <open>:
open(const char *path, int mode) {
  802212:	55                   	push   %rbp
  802213:	48 89 e5             	mov    %rsp,%rbp
  802216:	41 55                	push   %r13
  802218:	41 54                	push   %r12
  80221a:	53                   	push   %rbx
  80221b:	48 83 ec 18          	sub    $0x18,%rsp
  80221f:	49 89 fc             	mov    %rdi,%r12
  802222:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802225:	48 b8 a0 0d 80 00 00 	movabs $0x800da0,%rax
  80222c:	00 00 00 
  80222f:	ff d0                	call   *%rax
  802231:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802237:	0f 87 8c 00 00 00    	ja     8022c9 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80223d:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802241:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  802248:	00 00 00 
  80224b:	ff d0                	call   *%rax
  80224d:	89 c3                	mov    %eax,%ebx
  80224f:	85 c0                	test   %eax,%eax
  802251:	78 52                	js     8022a5 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802253:	4c 89 e6             	mov    %r12,%rsi
  802256:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  80225d:	00 00 00 
  802260:	48 b8 d9 0d 80 00 00 	movabs $0x800dd9,%rax
  802267:	00 00 00 
  80226a:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80226c:	44 89 e8             	mov    %r13d,%eax
  80226f:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802276:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802278:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80227c:	bf 01 00 00 00       	mov    $0x1,%edi
  802281:	48 b8 94 1f 80 00 00 	movabs $0x801f94,%rax
  802288:	00 00 00 
  80228b:	ff d0                	call   *%rax
  80228d:	89 c3                	mov    %eax,%ebx
  80228f:	85 c0                	test   %eax,%eax
  802291:	78 1f                	js     8022b2 <open+0xa0>
    return fd2num(fd);
  802293:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802297:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  80229e:	00 00 00 
  8022a1:	ff d0                	call   *%rax
  8022a3:	89 c3                	mov    %eax,%ebx
}
  8022a5:	89 d8                	mov    %ebx,%eax
  8022a7:	48 83 c4 18          	add    $0x18,%rsp
  8022ab:	5b                   	pop    %rbx
  8022ac:	41 5c                	pop    %r12
  8022ae:	41 5d                	pop    %r13
  8022b0:	5d                   	pop    %rbp
  8022b1:	c3                   	ret    
        fd_close(fd, 0);
  8022b2:	be 00 00 00 00       	mov    $0x0,%esi
  8022b7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022bb:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  8022c2:	00 00 00 
  8022c5:	ff d0                	call   *%rax
        return res;
  8022c7:	eb dc                	jmp    8022a5 <open+0x93>
        return -E_BAD_PATH;
  8022c9:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8022ce:	eb d5                	jmp    8022a5 <open+0x93>

00000000008022d0 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8022d0:	55                   	push   %rbp
  8022d1:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8022d4:	be 00 00 00 00       	mov    $0x0,%esi
  8022d9:	bf 08 00 00 00       	mov    $0x8,%edi
  8022de:	48 b8 94 1f 80 00 00 	movabs $0x801f94,%rax
  8022e5:	00 00 00 
  8022e8:	ff d0                	call   *%rax
}
  8022ea:	5d                   	pop    %rbp
  8022eb:	c3                   	ret    

00000000008022ec <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  8022ec:	55                   	push   %rbp
  8022ed:	48 89 e5             	mov    %rsp,%rbp
  8022f0:	41 55                	push   %r13
  8022f2:	41 54                	push   %r12
  8022f4:	53                   	push   %rbx
  8022f5:	48 83 ec 08          	sub    $0x8,%rsp
  8022f9:	48 89 fb             	mov    %rdi,%rbx
  8022fc:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  8022ff:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  802302:	48 b8 fe 31 80 00 00 	movabs $0x8031fe,%rax
  802309:	00 00 00 
  80230c:	ff d0                	call   *%rax
  80230e:	41 89 c1             	mov    %eax,%r9d
  802311:	4d 89 e0             	mov    %r12,%r8
  802314:	49 29 d8             	sub    %rbx,%r8
  802317:	48 89 d9             	mov    %rbx,%rcx
  80231a:	44 89 ea             	mov    %r13d,%edx
  80231d:	48 89 de             	mov    %rbx,%rsi
  802320:	bf 00 00 00 00       	mov    $0x0,%edi
  802325:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  80232c:	00 00 00 
  80232f:	ff d0                	call   *%rax
}
  802331:	48 83 c4 08          	add    $0x8,%rsp
  802335:	5b                   	pop    %rbx
  802336:	41 5c                	pop    %r12
  802338:	41 5d                	pop    %r13
  80233a:	5d                   	pop    %rbp
  80233b:	c3                   	ret    

000000000080233c <spawn>:
spawn(const char *prog, const char **argv) {
  80233c:	55                   	push   %rbp
  80233d:	48 89 e5             	mov    %rsp,%rbp
  802340:	41 57                	push   %r15
  802342:	41 56                	push   %r14
  802344:	41 55                	push   %r13
  802346:	41 54                	push   %r12
  802348:	53                   	push   %rbx
  802349:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  802350:	48 89 f3             	mov    %rsi,%rbx
    int fd = open(prog, O_RDONLY);
  802353:	be 00 00 00 00       	mov    $0x0,%esi
  802358:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  80235f:	00 00 00 
  802362:	ff d0                	call   *%rax
  802364:	41 89 c6             	mov    %eax,%r14d
    if (fd < 0) return fd;
  802367:	85 c0                	test   %eax,%eax
  802369:	0f 88 8a 06 00 00    	js     8029f9 <spawn+0x6bd>
    res = readn(fd, elf_buf, sizeof(elf_buf));
  80236f:	ba 00 02 00 00       	mov    $0x200,%edx
  802374:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  80237b:	89 c7                	mov    %eax,%edi
  80237d:	48 b8 d9 1c 80 00 00 	movabs $0x801cd9,%rax
  802384:	00 00 00 
  802387:	ff d0                	call   *%rax
    if (res != sizeof(elf_buf)) {
  802389:	3d 00 02 00 00       	cmp    $0x200,%eax
  80238e:	0f 85 b7 02 00 00    	jne    80264b <spawn+0x30f>
        elf->e_elf[1] != 1 /* little endian */ ||
  802394:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  80239b:	ff ff 00 
  80239e:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  8023a5:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  8023ac:	01 01 00 
  8023af:	48 39 d0             	cmp    %rdx,%rax
  8023b2:	0f 85 ca 02 00 00    	jne    802682 <spawn+0x346>
        elf->e_type != ET_EXEC /* executable */ ||
  8023b8:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  8023bf:	00 3e 00 
  8023c2:	0f 85 ba 02 00 00    	jne    802682 <spawn+0x346>
  8023c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8023cd:	cd 30                	int    $0x30
  8023cf:	89 85 f4 fc ff ff    	mov    %eax,-0x30c(%rbp)
  8023d5:	41 89 c7             	mov    %eax,%r15d
    if ((int)(res = sys_exofork()) < 0) goto error2;
  8023d8:	85 c0                	test   %eax,%eax
  8023da:	0f 88 07 06 00 00    	js     8029e7 <spawn+0x6ab>
    envid_t child = res;
  8023e0:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  8023e6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8023eb:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8023ef:	48 8d 34 50          	lea    (%rax,%rdx,2),%rsi
  8023f3:	48 89 f0             	mov    %rsi,%rax
  8023f6:	48 c1 e0 04          	shl    $0x4,%rax
  8023fa:	48 be 00 00 c0 1f 80 	movabs $0x801fc00000,%rsi
  802401:	00 00 00 
  802404:	48 01 c6             	add    %rax,%rsi
  802407:	48 8b 06             	mov    (%rsi),%rax
  80240a:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  802411:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  802418:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  80241f:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  802426:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  80242d:	48 29 ce             	sub    %rcx,%rsi
  802430:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  802436:	c1 e9 03             	shr    $0x3,%ecx
  802439:	89 c9                	mov    %ecx,%ecx
  80243b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  80243e:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802445:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  80244c:	48 8b 3b             	mov    (%rbx),%rdi
  80244f:	48 85 ff             	test   %rdi,%rdi
  802452:	0f 84 e0 05 00 00    	je     802a38 <spawn+0x6fc>
  802458:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    string_size = 0;
  80245e:	41 bd 00 00 00 00    	mov    $0x0,%r13d
        string_size += strlen(argv[argc]) + 1;
  802464:	49 bf a0 0d 80 00 00 	movabs $0x800da0,%r15
  80246b:	00 00 00 
  80246e:	44 89 a5 f8 fc ff ff 	mov    %r12d,-0x308(%rbp)
  802475:	41 ff d7             	call   *%r15
  802478:	4d 8d 6c 05 01       	lea    0x1(%r13,%rax,1),%r13
    for (argc = 0; argv[argc] != 0; argc++)
  80247d:	44 89 e0             	mov    %r12d,%eax
  802480:	4c 89 e2             	mov    %r12,%rdx
  802483:	49 83 c4 01          	add    $0x1,%r12
  802487:	4a 8b 7c e3 f8       	mov    -0x8(%rbx,%r12,8),%rdi
  80248c:	48 85 ff             	test   %rdi,%rdi
  80248f:	75 dd                	jne    80246e <spawn+0x132>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802491:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
  802497:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  80249e:	41 bc 00 00 41 00    	mov    $0x410000,%r12d
  8024a4:	4d 29 ec             	sub    %r13,%r12
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  8024a7:	4d 89 e7             	mov    %r12,%r15
  8024aa:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  8024ae:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  8024b5:	8b 85 f8 fc ff ff    	mov    -0x308(%rbp),%eax
  8024bb:	83 c0 01             	add    $0x1,%eax
  8024be:	48 98                	cltq   
  8024c0:	48 c1 e0 03          	shl    $0x3,%rax
  8024c4:	49 29 c7             	sub    %rax,%r15
  8024c7:	4c 89 bd f8 fc ff ff 	mov    %r15,-0x308(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  8024ce:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  8024d2:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8024d8:	0f 86 50 05 00 00    	jbe    802a2e <spawn+0x6f2>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  8024de:	b9 06 00 00 00       	mov    $0x6,%ecx
  8024e3:	ba 00 00 01 00       	mov    $0x10000,%edx
  8024e8:	be 00 00 40 00       	mov    $0x400000,%esi
  8024ed:	48 b8 93 13 80 00 00 	movabs $0x801393,%rax
  8024f4:	00 00 00 
  8024f7:	ff d0                	call   *%rax
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	0f 88 32 05 00 00    	js     802a33 <spawn+0x6f7>
    for (i = 0; i < argc; i++) {
  802501:	83 bd f0 fc ff ff 00 	cmpl   $0x0,-0x310(%rbp)
  802508:	7e 6c                	jle    802576 <spawn+0x23a>
  80250a:	4d 89 fd             	mov    %r15,%r13
  80250d:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  802514:	8d 40 ff             	lea    -0x1(%rax),%eax
  802517:	49 8d 44 c7 08       	lea    0x8(%r15,%rax,8),%rax
        argv_store[i] = UTEMP2USTACK(string_store);
  80251c:	49 bf 00 70 fe ff 7f 	movabs $0x7ffffe7000,%r15
  802523:	00 00 00 
        string_store += strlen(argv[i]) + 1;
  802526:	44 89 b5 f0 fc ff ff 	mov    %r14d,-0x310(%rbp)
  80252d:	49 89 c6             	mov    %rax,%r14
        argv_store[i] = UTEMP2USTACK(string_store);
  802530:	4b 8d 84 3c 00 00 c0 	lea    -0x400000(%r12,%r15,1),%rax
  802537:	ff 
  802538:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  80253c:	48 8b 33             	mov    (%rbx),%rsi
  80253f:	4c 89 e7             	mov    %r12,%rdi
  802542:	48 b8 d9 0d 80 00 00 	movabs $0x800dd9,%rax
  802549:	00 00 00 
  80254c:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  80254e:	48 8b 3b             	mov    (%rbx),%rdi
  802551:	48 b8 a0 0d 80 00 00 	movabs $0x800da0,%rax
  802558:	00 00 00 
  80255b:	ff d0                	call   *%rax
  80255d:	4d 8d 64 04 01       	lea    0x1(%r12,%rax,1),%r12
    for (i = 0; i < argc; i++) {
  802562:	49 83 c5 08          	add    $0x8,%r13
  802566:	48 83 c3 08          	add    $0x8,%rbx
  80256a:	4d 39 f5             	cmp    %r14,%r13
  80256d:	75 c1                	jne    802530 <spawn+0x1f4>
  80256f:	44 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%r14d
    argv_store[argc] = 0;
  802576:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  80257d:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  802584:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802585:	49 81 fc 00 00 41 00 	cmp    $0x410000,%r12
  80258c:	0f 85 30 01 00 00    	jne    8026c2 <spawn+0x386>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  802592:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  802599:	00 00 00 
  80259c:	48 8b 9d f8 fc ff ff 	mov    -0x308(%rbp),%rbx
  8025a3:	48 8d 84 0b 00 00 c0 	lea    -0x400000(%rbx,%rcx,1),%rax
  8025aa:	ff 
  8025ab:	48 89 43 f8          	mov    %rax,-0x8(%rbx)
    argv_store[-2] = argc;
  8025af:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  8025b6:	48 89 43 f0          	mov    %rax,-0x10(%rbx)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  8025ba:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  8025c1:	00 00 00 
  8025c4:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  8025cb:	ff 
  8025cc:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  8025d3:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  8025d9:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  8025df:	8b 95 f4 fc ff ff    	mov    -0x30c(%rbp),%edx
  8025e5:	be 00 00 40 00       	mov    $0x400000,%esi
  8025ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ef:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  8025f6:	00 00 00 
  8025f9:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  8025fb:	48 bb 5f 14 80 00 00 	movabs $0x80145f,%rbx
  802602:	00 00 00 
  802605:	ba 00 00 01 00       	mov    $0x10000,%edx
  80260a:	be 00 00 40 00       	mov    $0x400000,%esi
  80260f:	bf 00 00 00 00       	mov    $0x0,%edi
  802614:	ff d3                	call   *%rbx
  802616:	85 c0                	test   %eax,%eax
  802618:	78 eb                	js     802605 <spawn+0x2c9>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  80261a:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  802621:	4c 8d bc 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r15
  802628:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  802629:	b8 00 00 00 00       	mov    $0x0,%eax
  80262e:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  802635:	00 
  802636:	0f 84 88 02 00 00    	je     8028c4 <spawn+0x588>
  80263c:	44 89 b5 f4 fc ff ff 	mov    %r14d,-0x30c(%rbp)
  802643:	49 89 c6             	mov    %rax,%r14
  802646:	e9 e5 00 00 00       	jmp    802730 <spawn+0x3f4>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  80264b:	89 c6                	mov    %eax,%esi
  80264d:	48 bf 80 3e 80 00 00 	movabs $0x803e80,%rdi
  802654:	00 00 00 
  802657:	b8 00 00 00 00       	mov    $0x0,%eax
  80265c:	48 ba 98 04 80 00 00 	movabs $0x800498,%rdx
  802663:	00 00 00 
  802666:	ff d2                	call   *%rdx
        close(fd);
  802668:	44 89 f7             	mov    %r14d,%edi
  80266b:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  802672:	00 00 00 
  802675:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802677:	41 be ee ff ff ff    	mov    $0xffffffee,%r14d
  80267d:	e9 77 03 00 00       	jmp    8029f9 <spawn+0x6bd>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802682:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802687:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  80268d:	48 bf e0 3e 80 00 00 	movabs $0x803ee0,%rdi
  802694:	00 00 00 
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
  80269c:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  8026a3:	00 00 00 
  8026a6:	ff d1                	call   *%rcx
        close(fd);
  8026a8:	44 89 f7             	mov    %r14d,%edi
  8026ab:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  8026b7:	41 be ee ff ff ff    	mov    $0xffffffee,%r14d
  8026bd:	e9 37 03 00 00       	jmp    8029f9 <spawn+0x6bd>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  8026c2:	48 b9 b0 3e 80 00 00 	movabs $0x803eb0,%rcx
  8026c9:	00 00 00 
  8026cc:	48 ba fa 3e 80 00 00 	movabs $0x803efa,%rdx
  8026d3:	00 00 00 
  8026d6:	be ea 00 00 00       	mov    $0xea,%esi
  8026db:	48 bf 0f 3f 80 00 00 	movabs $0x803f0f,%rdi
  8026e2:	00 00 00 
  8026e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ea:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  8026f1:	00 00 00 
  8026f4:	41 ff d0             	call   *%r8
    /* Map read section conents to child */
    res = sys_map_region(CURENVID, UTEMP, child, (void*)va, filesz, perm | PROT_LAZY);
    if (res < 0)
        return res;
    /* Unmap it from parent */
    return sys_unmap_region(CURENVID, UTEMP, filesz);
  8026f7:	4c 89 ea             	mov    %r13,%rdx
  8026fa:	be 00 00 40 00       	mov    $0x400000,%esi
  8026ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802704:	48 b8 5f 14 80 00 00 	movabs $0x80145f,%rax
  80270b:	00 00 00 
  80270e:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  802710:	85 c0                	test   %eax,%eax
  802712:	0f 88 0a 03 00 00    	js     802a22 <spawn+0x6e6>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  802718:	49 83 c6 01          	add    $0x1,%r14
  80271c:	49 83 c7 38          	add    $0x38,%r15
  802720:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  802727:	4c 39 f0             	cmp    %r14,%rax
  80272a:	0f 86 8d 01 00 00    	jbe    8028bd <spawn+0x581>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  802730:	41 83 3f 01          	cmpl   $0x1,(%r15)
  802734:	75 e2                	jne    802718 <spawn+0x3dc>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  802736:	41 8b 47 04          	mov    0x4(%r15),%eax
  80273a:	41 89 c4             	mov    %eax,%r12d
  80273d:	41 83 e4 02          	and    $0x2,%r12d
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  802741:	44 89 e2             	mov    %r12d,%edx
  802744:	83 ca 04             	or     $0x4,%edx
  802747:	a8 04                	test   $0x4,%al
  802749:	44 0f 45 e2          	cmovne %edx,%r12d
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  80274d:	44 89 e2             	mov    %r12d,%edx
  802750:	83 ca 01             	or     $0x1,%edx
  802753:	a8 01                	test   $0x1,%al
  802755:	44 0f 45 e2          	cmovne %edx,%r12d
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  802759:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  80275d:	89 cb                	mov    %ecx,%ebx
  80275f:	49 8b 47 20          	mov    0x20(%r15),%rax
  802763:	49 8b 57 28          	mov    0x28(%r15),%rdx
  802767:	4d 8b 57 10          	mov    0x10(%r15),%r10
  80276b:	4c 89 95 f8 fc ff ff 	mov    %r10,-0x308(%rbp)
  802772:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802778:	89 bd e8 fc ff ff    	mov    %edi,-0x318(%rbp)
    if (res) {
  80277e:	44 89 d6             	mov    %r10d,%esi
  802781:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
  802787:	74 15                	je     80279e <spawn+0x462>
        va -= res;
  802789:	48 63 fe             	movslq %esi,%rdi
  80278c:	49 29 fa             	sub    %rdi,%r10
  80278f:	4c 89 95 f8 fc ff ff 	mov    %r10,-0x308(%rbp)
        memsz += res;
  802796:	48 01 fa             	add    %rdi,%rdx
        filesz += res;
  802799:	48 01 f8             	add    %rdi,%rax
        fileoffset -= res;
  80279c:	29 f3                	sub    %esi,%ebx
    filesz = ROUNDUP(va + filesz, PAGE_SIZE) - va;
  80279e:	48 8b 8d f8 fc ff ff 	mov    -0x308(%rbp),%rcx
  8027a5:	48 8d b4 08 ff 0f 00 	lea    0xfff(%rax,%rcx,1),%rsi
  8027ac:	00 
  8027ad:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
  8027b4:	49 89 f5             	mov    %rsi,%r13
  8027b7:	49 29 cd             	sub    %rcx,%r13
    if (filesz < memsz) {
  8027ba:	49 39 d5             	cmp    %rdx,%r13
  8027bd:	73 23                	jae    8027e2 <spawn+0x4a6>
        res = sys_alloc_region(child, (void*)va + filesz, memsz - filesz, perm);
  8027bf:	48 01 ca             	add    %rcx,%rdx
  8027c2:	48 29 f2             	sub    %rsi,%rdx
  8027c5:	44 89 e1             	mov    %r12d,%ecx
  8027c8:	8b bd e8 fc ff ff    	mov    -0x318(%rbp),%edi
  8027ce:	48 b8 93 13 80 00 00 	movabs $0x801393,%rax
  8027d5:	00 00 00 
  8027d8:	ff d0                	call   *%rax
        if (res < 0)
  8027da:	85 c0                	test   %eax,%eax
  8027dc:	0f 88 dd 01 00 00    	js     8029bf <spawn+0x683>
    res = sys_alloc_region(CURENVID, UTEMP, filesz, PROT_RW);
  8027e2:	b9 06 00 00 00       	mov    $0x6,%ecx
  8027e7:	4c 89 ea             	mov    %r13,%rdx
  8027ea:	be 00 00 40 00       	mov    $0x400000,%esi
  8027ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f4:	48 b8 93 13 80 00 00 	movabs $0x801393,%rax
  8027fb:	00 00 00 
  8027fe:	ff d0                	call   *%rax
    if (res < 0)
  802800:	85 c0                	test   %eax,%eax
  802802:	0f 88 c3 01 00 00    	js     8029cb <spawn+0x68f>
    res = seek(fd, fileoffset);
  802808:	89 de                	mov    %ebx,%esi
  80280a:	8b bd f4 fc ff ff    	mov    -0x30c(%rbp),%edi
  802810:	48 b8 fe 1d 80 00 00 	movabs $0x801dfe,%rax
  802817:	00 00 00 
  80281a:	ff d0                	call   *%rax
    if (res < 0)
  80281c:	85 c0                	test   %eax,%eax
  80281e:	0f 88 ea 01 00 00    	js     802a0e <spawn+0x6d2>
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  802824:	4d 85 ed             	test   %r13,%r13
  802827:	74 50                	je     802879 <spawn+0x53d>
  802829:	bb 00 00 00 00       	mov    $0x0,%ebx
  80282e:	b8 00 00 00 00       	mov    $0x0,%eax
        res = readn(fd, UTEMP + i, PAGE_SIZE);
  802833:	44 89 a5 e0 fc ff ff 	mov    %r12d,-0x320(%rbp)
  80283a:	44 8b a5 f4 fc ff ff 	mov    -0x30c(%rbp),%r12d
  802841:	48 8d b0 00 00 40 00 	lea    0x400000(%rax),%rsi
  802848:	ba 00 10 00 00       	mov    $0x1000,%edx
  80284d:	44 89 e7             	mov    %r12d,%edi
  802850:	48 b8 d9 1c 80 00 00 	movabs $0x801cd9,%rax
  802857:	00 00 00 
  80285a:	ff d0                	call   *%rax
        if (res < 0)
  80285c:	85 c0                	test   %eax,%eax
  80285e:	0f 88 b6 01 00 00    	js     802a1a <spawn+0x6de>
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  802864:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80286a:	48 63 c3             	movslq %ebx,%rax
  80286d:	49 39 c5             	cmp    %rax,%r13
  802870:	77 cf                	ja     802841 <spawn+0x505>
  802872:	44 8b a5 e0 fc ff ff 	mov    -0x320(%rbp),%r12d
    res = sys_map_region(CURENVID, UTEMP, child, (void*)va, filesz, perm | PROT_LAZY);
  802879:	45 89 e1             	mov    %r12d,%r9d
  80287c:	41 80 c9 80          	or     $0x80,%r9b
  802880:	4d 89 e8             	mov    %r13,%r8
  802883:	48 8b 8d f8 fc ff ff 	mov    -0x308(%rbp),%rcx
  80288a:	8b 95 e8 fc ff ff    	mov    -0x318(%rbp),%edx
  802890:	be 00 00 40 00       	mov    $0x400000,%esi
  802895:	bf 00 00 00 00       	mov    $0x0,%edi
  80289a:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  8028a1:	00 00 00 
  8028a4:	ff d0                	call   *%rax
    if (res < 0)
  8028a6:	85 c0                	test   %eax,%eax
  8028a8:	0f 89 49 fe ff ff    	jns    8026f7 <spawn+0x3bb>
  8028ae:	41 89 c7             	mov    %eax,%r15d
  8028b1:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  8028b8:	e9 18 01 00 00       	jmp    8029d5 <spawn+0x699>
  8028bd:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
    close(fd);
  8028c4:	44 89 f7             	mov    %r14d,%edi
  8028c7:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  8028ce:	00 00 00 
  8028d1:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  8028d3:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  8028da:	48 bf ec 22 80 00 00 	movabs $0x8022ec,%rdi
  8028e1:	00 00 00 
  8028e4:	48 b8 72 32 80 00 00 	movabs $0x803272,%rax
  8028eb:	00 00 00 
  8028ee:	ff d0                	call   *%rax
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	78 44                	js     802938 <spawn+0x5fc>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  8028f4:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  8028fb:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802901:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  802908:	00 00 00 
  80290b:	ff d0                	call   *%rax
  80290d:	85 c0                	test   %eax,%eax
  80290f:	78 54                	js     802965 <spawn+0x629>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802911:	be 02 00 00 00       	mov    $0x2,%esi
  802916:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  80291c:	48 b8 c6 14 80 00 00 	movabs $0x8014c6,%rax
  802923:	00 00 00 
  802926:	ff d0                	call   *%rax
  802928:	85 c0                	test   %eax,%eax
  80292a:	78 66                	js     802992 <spawn+0x656>
    return child;
  80292c:	44 8b b5 cc fd ff ff 	mov    -0x234(%rbp),%r14d
  802933:	e9 c1 00 00 00       	jmp    8029f9 <spawn+0x6bd>
        panic("copy_shared_region: %i", res);
  802938:	89 c1                	mov    %eax,%ecx
  80293a:	48 ba 1b 3f 80 00 00 	movabs $0x803f1b,%rdx
  802941:	00 00 00 
  802944:	be 80 00 00 00       	mov    $0x80,%esi
  802949:	48 bf 0f 3f 80 00 00 	movabs $0x803f0f,%rdi
  802950:	00 00 00 
  802953:	b8 00 00 00 00       	mov    $0x0,%eax
  802958:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  80295f:	00 00 00 
  802962:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  802965:	89 c1                	mov    %eax,%ecx
  802967:	48 ba 32 3f 80 00 00 	movabs $0x803f32,%rdx
  80296e:	00 00 00 
  802971:	be 83 00 00 00       	mov    $0x83,%esi
  802976:	48 bf 0f 3f 80 00 00 	movabs $0x803f0f,%rdi
  80297d:	00 00 00 
  802980:	b8 00 00 00 00       	mov    $0x0,%eax
  802985:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  80298c:	00 00 00 
  80298f:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  802992:	89 c1                	mov    %eax,%ecx
  802994:	48 ba 7b 3d 80 00 00 	movabs $0x803d7b,%rdx
  80299b:	00 00 00 
  80299e:	be 86 00 00 00       	mov    $0x86,%esi
  8029a3:	48 bf 0f 3f 80 00 00 	movabs $0x803f0f,%rdi
  8029aa:	00 00 00 
  8029ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b2:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  8029b9:	00 00 00 
  8029bc:	41 ff d0             	call   *%r8
  8029bf:	41 89 c7             	mov    %eax,%r15d
  8029c2:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  8029c9:	eb 0a                	jmp    8029d5 <spawn+0x699>
  8029cb:	41 89 c7             	mov    %eax,%r15d
  8029ce:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
    sys_env_destroy(child);
  8029d5:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  8029db:	48 b8 68 12 80 00 00 	movabs $0x801268,%rax
  8029e2:	00 00 00 
  8029e5:	ff d0                	call   *%rax
    close(fd);
  8029e7:	44 89 f7             	mov    %r14d,%edi
  8029ea:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  8029f1:	00 00 00 
  8029f4:	ff d0                	call   *%rax
    return res;
  8029f6:	45 89 fe             	mov    %r15d,%r14d
}
  8029f9:	44 89 f0             	mov    %r14d,%eax
  8029fc:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  802a03:	5b                   	pop    %rbx
  802a04:	41 5c                	pop    %r12
  802a06:	41 5d                	pop    %r13
  802a08:	41 5e                	pop    %r14
  802a0a:	41 5f                	pop    %r15
  802a0c:	5d                   	pop    %rbp
  802a0d:	c3                   	ret    
  802a0e:	41 89 c7             	mov    %eax,%r15d
  802a11:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802a18:	eb bb                	jmp    8029d5 <spawn+0x699>
  802a1a:	41 89 c7             	mov    %eax,%r15d
  802a1d:	45 89 e6             	mov    %r12d,%r14d
  802a20:	eb b3                	jmp    8029d5 <spawn+0x699>
  802a22:	41 89 c7             	mov    %eax,%r15d
  802a25:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802a2c:	eb a7                	jmp    8029d5 <spawn+0x699>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  802a2e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  802a33:	41 89 c7             	mov    %eax,%r15d
  802a36:	eb 9d                	jmp    8029d5 <spawn+0x699>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  802a38:	b9 06 00 00 00       	mov    $0x6,%ecx
  802a3d:	ba 00 00 01 00       	mov    $0x10000,%edx
  802a42:	be 00 00 40 00       	mov    $0x400000,%esi
  802a47:	bf 00 00 00 00       	mov    $0x0,%edi
  802a4c:	48 b8 93 13 80 00 00 	movabs $0x801393,%rax
  802a53:	00 00 00 
  802a56:	ff d0                	call   *%rax
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	78 d7                	js     802a33 <spawn+0x6f7>
    for (argc = 0; argv[argc] != 0; argc++)
  802a5c:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  802a63:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802a67:	48 c7 85 f8 fc ff ff 	movq   $0x40fff8,-0x308(%rbp)
  802a6e:	f8 ff 40 00 
  802a72:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  802a79:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802a7d:	41 bc 00 00 41 00    	mov    $0x410000,%r12d
  802a83:	e9 ee fa ff ff       	jmp    802576 <spawn+0x23a>

0000000000802a88 <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  802a88:	55                   	push   %rbp
  802a89:	48 89 e5             	mov    %rsp,%rbp
  802a8c:	48 83 ec 50          	sub    $0x50,%rsp
  802a90:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802a94:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802a98:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802a9c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  802aa0:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802aa7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802aab:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802aaf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802ab3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  802ab7:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  802abc:	eb 15                	jmp    802ad3 <spawnl+0x4b>
  802abe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ac2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802ac6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802aca:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  802ace:	74 1c                	je     802aec <spawnl+0x64>
  802ad0:	83 c1 01             	add    $0x1,%ecx
  802ad3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ad6:	83 f8 2f             	cmp    $0x2f,%eax
  802ad9:	77 e3                	ja     802abe <spawnl+0x36>
  802adb:	89 c2                	mov    %eax,%edx
  802add:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  802ae1:	4c 01 d2             	add    %r10,%rdx
  802ae4:	83 c0 08             	add    $0x8,%eax
  802ae7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802aea:	eb de                	jmp    802aca <spawnl+0x42>
    const char *argv[argc + 2];
  802aec:	8d 41 02             	lea    0x2(%rcx),%eax
  802aef:	48 98                	cltq   
  802af1:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  802af8:	00 
  802af9:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
  802afd:	48 29 c4             	sub    %rax,%rsp
  802b00:	4c 8d 44 24 07       	lea    0x7(%rsp),%r8
  802b05:	4c 89 c0             	mov    %r8,%rax
  802b08:	48 c1 e8 03          	shr    $0x3,%rax
  802b0c:	49 83 e0 f8          	and    $0xfffffffffffffff8,%r8
    argv[0] = arg0;
  802b10:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  802b17:	00 
    argv[argc + 1] = NULL;
  802b18:	8d 41 01             	lea    0x1(%rcx),%eax
  802b1b:	48 98                	cltq   
  802b1d:	49 c7 04 c0 00 00 00 	movq   $0x0,(%r8,%rax,8)
  802b24:	00 
    va_start(vl, arg0);
  802b25:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802b2c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b30:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802b34:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802b38:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  802b3c:	85 c9                	test   %ecx,%ecx
  802b3e:	74 41                	je     802b81 <spawnl+0xf9>
        argv[i + 1] = va_arg(vl, const char *);
  802b40:	49 89 c1             	mov    %rax,%r9
  802b43:	49 8d 40 08          	lea    0x8(%r8),%rax
  802b47:	8d 51 ff             	lea    -0x1(%rcx),%edx
  802b4a:	49 8d 74 d0 10       	lea    0x10(%r8,%rdx,8),%rsi
  802b4f:	eb 1b                	jmp    802b6c <spawnl+0xe4>
  802b51:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802b55:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  802b59:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802b5d:	48 8b 11             	mov    (%rcx),%rdx
  802b60:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  802b63:	48 83 c0 08          	add    $0x8,%rax
  802b67:	48 39 f0             	cmp    %rsi,%rax
  802b6a:	74 15                	je     802b81 <spawnl+0xf9>
        argv[i + 1] = va_arg(vl, const char *);
  802b6c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802b6f:	83 fa 2f             	cmp    $0x2f,%edx
  802b72:	77 dd                	ja     802b51 <spawnl+0xc9>
  802b74:	89 d1                	mov    %edx,%ecx
  802b76:	4c 01 c9             	add    %r9,%rcx
  802b79:	83 c2 08             	add    $0x8,%edx
  802b7c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802b7f:	eb dc                	jmp    802b5d <spawnl+0xd5>
    return spawn(prog, argv);
  802b81:	4c 89 c6             	mov    %r8,%rsi
  802b84:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  802b8b:	00 00 00 
  802b8e:	ff d0                	call   *%rax
}
  802b90:	c9                   	leave  
  802b91:	c3                   	ret    

0000000000802b92 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802b92:	55                   	push   %rbp
  802b93:	48 89 e5             	mov    %rsp,%rbp
  802b96:	41 54                	push   %r12
  802b98:	53                   	push   %rbx
  802b99:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802b9c:	48 b8 c1 18 80 00 00 	movabs $0x8018c1,%rax
  802ba3:	00 00 00 
  802ba6:	ff d0                	call   *%rax
  802ba8:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802bab:	48 be 4c 3f 80 00 00 	movabs $0x803f4c,%rsi
  802bb2:	00 00 00 
  802bb5:	48 89 df             	mov    %rbx,%rdi
  802bb8:	48 b8 d9 0d 80 00 00 	movabs $0x800dd9,%rax
  802bbf:	00 00 00 
  802bc2:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802bc4:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802bc9:	41 2b 04 24          	sub    (%r12),%eax
  802bcd:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802bd3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802bda:	00 00 00 
    stat->st_dev = &devpipe;
  802bdd:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802be4:	00 00 00 
  802be7:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802bee:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf3:	5b                   	pop    %rbx
  802bf4:	41 5c                	pop    %r12
  802bf6:	5d                   	pop    %rbp
  802bf7:	c3                   	ret    

0000000000802bf8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802bf8:	55                   	push   %rbp
  802bf9:	48 89 e5             	mov    %rsp,%rbp
  802bfc:	41 54                	push   %r12
  802bfe:	53                   	push   %rbx
  802bff:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802c02:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c07:	48 89 fe             	mov    %rdi,%rsi
  802c0a:	bf 00 00 00 00       	mov    $0x0,%edi
  802c0f:	49 bc 5f 14 80 00 00 	movabs $0x80145f,%r12
  802c16:	00 00 00 
  802c19:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802c1c:	48 89 df             	mov    %rbx,%rdi
  802c1f:	48 b8 c1 18 80 00 00 	movabs $0x8018c1,%rax
  802c26:	00 00 00 
  802c29:	ff d0                	call   *%rax
  802c2b:	48 89 c6             	mov    %rax,%rsi
  802c2e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c33:	bf 00 00 00 00       	mov    $0x0,%edi
  802c38:	41 ff d4             	call   *%r12
}
  802c3b:	5b                   	pop    %rbx
  802c3c:	41 5c                	pop    %r12
  802c3e:	5d                   	pop    %rbp
  802c3f:	c3                   	ret    

0000000000802c40 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802c40:	55                   	push   %rbp
  802c41:	48 89 e5             	mov    %rsp,%rbp
  802c44:	41 57                	push   %r15
  802c46:	41 56                	push   %r14
  802c48:	41 55                	push   %r13
  802c4a:	41 54                	push   %r12
  802c4c:	53                   	push   %rbx
  802c4d:	48 83 ec 18          	sub    $0x18,%rsp
  802c51:	49 89 fc             	mov    %rdi,%r12
  802c54:	49 89 f5             	mov    %rsi,%r13
  802c57:	49 89 d7             	mov    %rdx,%r15
  802c5a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802c5e:	48 b8 c1 18 80 00 00 	movabs $0x8018c1,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802c6a:	4d 85 ff             	test   %r15,%r15
  802c6d:	0f 84 ac 00 00 00    	je     802d1f <devpipe_write+0xdf>
  802c73:	48 89 c3             	mov    %rax,%rbx
  802c76:	4c 89 f8             	mov    %r15,%rax
  802c79:	4d 89 ef             	mov    %r13,%r15
  802c7c:	49 01 c5             	add    %rax,%r13
  802c7f:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802c83:	49 bd 67 13 80 00 00 	movabs $0x801367,%r13
  802c8a:	00 00 00 
            sys_yield();
  802c8d:	49 be 04 13 80 00 00 	movabs $0x801304,%r14
  802c94:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802c97:	8b 73 04             	mov    0x4(%rbx),%esi
  802c9a:	48 63 ce             	movslq %esi,%rcx
  802c9d:	48 63 03             	movslq (%rbx),%rax
  802ca0:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802ca6:	48 39 c1             	cmp    %rax,%rcx
  802ca9:	72 2e                	jb     802cd9 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802cab:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802cb0:	48 89 da             	mov    %rbx,%rdx
  802cb3:	be 00 10 00 00       	mov    $0x1000,%esi
  802cb8:	4c 89 e7             	mov    %r12,%rdi
  802cbb:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	74 63                	je     802d25 <devpipe_write+0xe5>
            sys_yield();
  802cc2:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802cc5:	8b 73 04             	mov    0x4(%rbx),%esi
  802cc8:	48 63 ce             	movslq %esi,%rcx
  802ccb:	48 63 03             	movslq (%rbx),%rax
  802cce:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802cd4:	48 39 c1             	cmp    %rax,%rcx
  802cd7:	73 d2                	jae    802cab <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802cd9:	41 0f b6 3f          	movzbl (%r15),%edi
  802cdd:	48 89 ca             	mov    %rcx,%rdx
  802ce0:	48 c1 ea 03          	shr    $0x3,%rdx
  802ce4:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802ceb:	08 10 20 
  802cee:	48 f7 e2             	mul    %rdx
  802cf1:	48 c1 ea 06          	shr    $0x6,%rdx
  802cf5:	48 89 d0             	mov    %rdx,%rax
  802cf8:	48 c1 e0 09          	shl    $0x9,%rax
  802cfc:	48 29 d0             	sub    %rdx,%rax
  802cff:	48 c1 e0 03          	shl    $0x3,%rax
  802d03:	48 29 c1             	sub    %rax,%rcx
  802d06:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802d0b:	83 c6 01             	add    $0x1,%esi
  802d0e:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802d11:	49 83 c7 01          	add    $0x1,%r15
  802d15:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802d19:	0f 85 78 ff ff ff    	jne    802c97 <devpipe_write+0x57>
    return n;
  802d1f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802d23:	eb 05                	jmp    802d2a <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802d25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d2a:	48 83 c4 18          	add    $0x18,%rsp
  802d2e:	5b                   	pop    %rbx
  802d2f:	41 5c                	pop    %r12
  802d31:	41 5d                	pop    %r13
  802d33:	41 5e                	pop    %r14
  802d35:	41 5f                	pop    %r15
  802d37:	5d                   	pop    %rbp
  802d38:	c3                   	ret    

0000000000802d39 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802d39:	55                   	push   %rbp
  802d3a:	48 89 e5             	mov    %rsp,%rbp
  802d3d:	41 57                	push   %r15
  802d3f:	41 56                	push   %r14
  802d41:	41 55                	push   %r13
  802d43:	41 54                	push   %r12
  802d45:	53                   	push   %rbx
  802d46:	48 83 ec 18          	sub    $0x18,%rsp
  802d4a:	49 89 fc             	mov    %rdi,%r12
  802d4d:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802d51:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802d55:	48 b8 c1 18 80 00 00 	movabs $0x8018c1,%rax
  802d5c:	00 00 00 
  802d5f:	ff d0                	call   *%rax
  802d61:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802d64:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802d6a:	49 bd 67 13 80 00 00 	movabs $0x801367,%r13
  802d71:	00 00 00 
            sys_yield();
  802d74:	49 be 04 13 80 00 00 	movabs $0x801304,%r14
  802d7b:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802d7e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802d83:	74 7a                	je     802dff <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802d85:	8b 03                	mov    (%rbx),%eax
  802d87:	3b 43 04             	cmp    0x4(%rbx),%eax
  802d8a:	75 26                	jne    802db2 <devpipe_read+0x79>
            if (i > 0) return i;
  802d8c:	4d 85 ff             	test   %r15,%r15
  802d8f:	75 74                	jne    802e05 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802d91:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802d96:	48 89 da             	mov    %rbx,%rdx
  802d99:	be 00 10 00 00       	mov    $0x1000,%esi
  802d9e:	4c 89 e7             	mov    %r12,%rdi
  802da1:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802da4:	85 c0                	test   %eax,%eax
  802da6:	74 6f                	je     802e17 <devpipe_read+0xde>
            sys_yield();
  802da8:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802dab:	8b 03                	mov    (%rbx),%eax
  802dad:	3b 43 04             	cmp    0x4(%rbx),%eax
  802db0:	74 df                	je     802d91 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802db2:	48 63 c8             	movslq %eax,%rcx
  802db5:	48 89 ca             	mov    %rcx,%rdx
  802db8:	48 c1 ea 03          	shr    $0x3,%rdx
  802dbc:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802dc3:	08 10 20 
  802dc6:	48 f7 e2             	mul    %rdx
  802dc9:	48 c1 ea 06          	shr    $0x6,%rdx
  802dcd:	48 89 d0             	mov    %rdx,%rax
  802dd0:	48 c1 e0 09          	shl    $0x9,%rax
  802dd4:	48 29 d0             	sub    %rdx,%rax
  802dd7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802dde:	00 
  802ddf:	48 89 c8             	mov    %rcx,%rax
  802de2:	48 29 d0             	sub    %rdx,%rax
  802de5:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802dea:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802dee:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802df2:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802df5:	49 83 c7 01          	add    $0x1,%r15
  802df9:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802dfd:	75 86                	jne    802d85 <devpipe_read+0x4c>
    return n;
  802dff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802e03:	eb 03                	jmp    802e08 <devpipe_read+0xcf>
            if (i > 0) return i;
  802e05:	4c 89 f8             	mov    %r15,%rax
}
  802e08:	48 83 c4 18          	add    $0x18,%rsp
  802e0c:	5b                   	pop    %rbx
  802e0d:	41 5c                	pop    %r12
  802e0f:	41 5d                	pop    %r13
  802e11:	41 5e                	pop    %r14
  802e13:	41 5f                	pop    %r15
  802e15:	5d                   	pop    %rbp
  802e16:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802e17:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1c:	eb ea                	jmp    802e08 <devpipe_read+0xcf>

0000000000802e1e <pipe>:
pipe(int pfd[2]) {
  802e1e:	55                   	push   %rbp
  802e1f:	48 89 e5             	mov    %rsp,%rbp
  802e22:	41 55                	push   %r13
  802e24:	41 54                	push   %r12
  802e26:	53                   	push   %rbx
  802e27:	48 83 ec 18          	sub    $0x18,%rsp
  802e2b:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802e2e:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802e32:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  802e39:	00 00 00 
  802e3c:	ff d0                	call   *%rax
  802e3e:	89 c3                	mov    %eax,%ebx
  802e40:	85 c0                	test   %eax,%eax
  802e42:	0f 88 a0 01 00 00    	js     802fe8 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802e48:	b9 46 00 00 00       	mov    $0x46,%ecx
  802e4d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e52:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802e56:	bf 00 00 00 00       	mov    $0x0,%edi
  802e5b:	48 b8 93 13 80 00 00 	movabs $0x801393,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	call   *%rax
  802e67:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802e69:	85 c0                	test   %eax,%eax
  802e6b:	0f 88 77 01 00 00    	js     802fe8 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802e71:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802e75:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  802e7c:	00 00 00 
  802e7f:	ff d0                	call   *%rax
  802e81:	89 c3                	mov    %eax,%ebx
  802e83:	85 c0                	test   %eax,%eax
  802e85:	0f 88 43 01 00 00    	js     802fce <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802e8b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802e90:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e95:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e99:	bf 00 00 00 00       	mov    $0x0,%edi
  802e9e:	48 b8 93 13 80 00 00 	movabs $0x801393,%rax
  802ea5:	00 00 00 
  802ea8:	ff d0                	call   *%rax
  802eaa:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802eac:	85 c0                	test   %eax,%eax
  802eae:	0f 88 1a 01 00 00    	js     802fce <pipe+0x1b0>
    va = fd2data(fd0);
  802eb4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802eb8:	48 b8 c1 18 80 00 00 	movabs $0x8018c1,%rax
  802ebf:	00 00 00 
  802ec2:	ff d0                	call   *%rax
  802ec4:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802ec7:	b9 46 00 00 00       	mov    $0x46,%ecx
  802ecc:	ba 00 10 00 00       	mov    $0x1000,%edx
  802ed1:	48 89 c6             	mov    %rax,%rsi
  802ed4:	bf 00 00 00 00       	mov    $0x0,%edi
  802ed9:	48 b8 93 13 80 00 00 	movabs $0x801393,%rax
  802ee0:	00 00 00 
  802ee3:	ff d0                	call   *%rax
  802ee5:	89 c3                	mov    %eax,%ebx
  802ee7:	85 c0                	test   %eax,%eax
  802ee9:	0f 88 c5 00 00 00    	js     802fb4 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802eef:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802ef3:	48 b8 c1 18 80 00 00 	movabs $0x8018c1,%rax
  802efa:	00 00 00 
  802efd:	ff d0                	call   *%rax
  802eff:	48 89 c1             	mov    %rax,%rcx
  802f02:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802f08:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802f0e:	ba 00 00 00 00       	mov    $0x0,%edx
  802f13:	4c 89 ee             	mov    %r13,%rsi
  802f16:	bf 00 00 00 00       	mov    $0x0,%edi
  802f1b:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  802f22:	00 00 00 
  802f25:	ff d0                	call   *%rax
  802f27:	89 c3                	mov    %eax,%ebx
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	78 6e                	js     802f9b <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802f2d:	be 00 10 00 00       	mov    $0x1000,%esi
  802f32:	4c 89 ef             	mov    %r13,%rdi
  802f35:	48 b8 35 13 80 00 00 	movabs $0x801335,%rax
  802f3c:	00 00 00 
  802f3f:	ff d0                	call   *%rax
  802f41:	83 f8 02             	cmp    $0x2,%eax
  802f44:	0f 85 ab 00 00 00    	jne    802ff5 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802f4a:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802f51:	00 00 
  802f53:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f57:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802f59:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f5d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802f64:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802f68:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802f6a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f6e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802f75:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802f79:	48 bb af 18 80 00 00 	movabs $0x8018af,%rbx
  802f80:	00 00 00 
  802f83:	ff d3                	call   *%rbx
  802f85:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802f89:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802f8d:	ff d3                	call   *%rbx
  802f8f:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802f94:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f99:	eb 4d                	jmp    802fe8 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802f9b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802fa0:	4c 89 ee             	mov    %r13,%rsi
  802fa3:	bf 00 00 00 00       	mov    $0x0,%edi
  802fa8:	48 b8 5f 14 80 00 00 	movabs $0x80145f,%rax
  802faf:	00 00 00 
  802fb2:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802fb4:	ba 00 10 00 00       	mov    $0x1000,%edx
  802fb9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fbd:	bf 00 00 00 00       	mov    $0x0,%edi
  802fc2:	48 b8 5f 14 80 00 00 	movabs $0x80145f,%rax
  802fc9:	00 00 00 
  802fcc:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802fce:	ba 00 10 00 00       	mov    $0x1000,%edx
  802fd3:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802fd7:	bf 00 00 00 00       	mov    $0x0,%edi
  802fdc:	48 b8 5f 14 80 00 00 	movabs $0x80145f,%rax
  802fe3:	00 00 00 
  802fe6:	ff d0                	call   *%rax
}
  802fe8:	89 d8                	mov    %ebx,%eax
  802fea:	48 83 c4 18          	add    $0x18,%rsp
  802fee:	5b                   	pop    %rbx
  802fef:	41 5c                	pop    %r12
  802ff1:	41 5d                	pop    %r13
  802ff3:	5d                   	pop    %rbp
  802ff4:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802ff5:	48 b9 68 3f 80 00 00 	movabs $0x803f68,%rcx
  802ffc:	00 00 00 
  802fff:	48 ba fa 3e 80 00 00 	movabs $0x803efa,%rdx
  803006:	00 00 00 
  803009:	be 2e 00 00 00       	mov    $0x2e,%esi
  80300e:	48 bf 53 3f 80 00 00 	movabs $0x803f53,%rdi
  803015:	00 00 00 
  803018:	b8 00 00 00 00       	mov    $0x0,%eax
  80301d:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  803024:	00 00 00 
  803027:	41 ff d0             	call   *%r8

000000000080302a <pipeisclosed>:
pipeisclosed(int fdnum) {
  80302a:	55                   	push   %rbp
  80302b:	48 89 e5             	mov    %rsp,%rbp
  80302e:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  803032:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  803036:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  80303d:	00 00 00 
  803040:	ff d0                	call   *%rax
    if (res < 0) return res;
  803042:	85 c0                	test   %eax,%eax
  803044:	78 35                	js     80307b <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  803046:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80304a:	48 b8 c1 18 80 00 00 	movabs $0x8018c1,%rax
  803051:	00 00 00 
  803054:	ff d0                	call   *%rax
  803056:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803059:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80305e:	be 00 10 00 00       	mov    $0x1000,%esi
  803063:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803067:	48 b8 67 13 80 00 00 	movabs $0x801367,%rax
  80306e:	00 00 00 
  803071:	ff d0                	call   *%rax
  803073:	85 c0                	test   %eax,%eax
  803075:	0f 94 c0             	sete   %al
  803078:	0f b6 c0             	movzbl %al,%eax
}
  80307b:	c9                   	leave  
  80307c:	c3                   	ret    

000000000080307d <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  80307d:	55                   	push   %rbp
  80307e:	48 89 e5             	mov    %rsp,%rbp
  803081:	41 55                	push   %r13
  803083:	41 54                	push   %r12
  803085:	53                   	push   %rbx
  803086:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  80308a:	85 ff                	test   %edi,%edi
  80308c:	0f 84 83 00 00 00    	je     803115 <wait+0x98>
  803092:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  803095:	89 f8                	mov    %edi,%eax
  803097:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  80309c:	89 fa                	mov    %edi,%edx
  80309e:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8030a4:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  8030a8:	48 8d 14 4a          	lea    (%rdx,%rcx,2),%rdx
  8030ac:	48 89 d1             	mov    %rdx,%rcx
  8030af:	48 c1 e1 04          	shl    $0x4,%rcx
  8030b3:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8030ba:	00 00 00 
  8030bd:	48 01 ca             	add    %rcx,%rdx
  8030c0:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  8030c6:	39 d7                	cmp    %edx,%edi
  8030c8:	75 40                	jne    80310a <wait+0x8d>
           env->env_status != ENV_FREE) {
  8030ca:	48 98                	cltq   
  8030cc:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8030d0:	48 8d 1c 50          	lea    (%rax,%rdx,2),%rbx
  8030d4:	48 89 d8             	mov    %rbx,%rax
  8030d7:	48 c1 e0 04          	shl    $0x4,%rax
  8030db:	48 bb 00 00 c0 1f 80 	movabs $0x801fc00000,%rbx
  8030e2:	00 00 00 
  8030e5:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  8030e8:	49 bd 04 13 80 00 00 	movabs $0x801304,%r13
  8030ef:	00 00 00 
           env->env_status != ENV_FREE) {
  8030f2:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  8030f8:	85 c0                	test   %eax,%eax
  8030fa:	74 0e                	je     80310a <wait+0x8d>
        sys_yield();
  8030fc:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  8030ff:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  803105:	44 39 e0             	cmp    %r12d,%eax
  803108:	74 e8                	je     8030f2 <wait+0x75>
    }
}
  80310a:	48 83 c4 08          	add    $0x8,%rsp
  80310e:	5b                   	pop    %rbx
  80310f:	41 5c                	pop    %r12
  803111:	41 5d                	pop    %r13
  803113:	5d                   	pop    %rbp
  803114:	c3                   	ret    
    assert(envid != 0);
  803115:	48 b9 8c 3f 80 00 00 	movabs $0x803f8c,%rcx
  80311c:	00 00 00 
  80311f:	48 ba fa 3e 80 00 00 	movabs $0x803efa,%rdx
  803126:	00 00 00 
  803129:	be 06 00 00 00       	mov    $0x6,%esi
  80312e:	48 bf 97 3f 80 00 00 	movabs $0x803f97,%rdi
  803135:	00 00 00 
  803138:	b8 00 00 00 00       	mov    $0x0,%eax
  80313d:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  803144:	00 00 00 
  803147:	41 ff d0             	call   *%r8

000000000080314a <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80314a:	48 89 f8             	mov    %rdi,%rax
  80314d:	48 c1 e8 27          	shr    $0x27,%rax
  803151:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  803158:	01 00 00 
  80315b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80315f:	f6 c2 01             	test   $0x1,%dl
  803162:	74 6d                	je     8031d1 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803164:	48 89 f8             	mov    %rdi,%rax
  803167:	48 c1 e8 1e          	shr    $0x1e,%rax
  80316b:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  803172:	01 00 00 
  803175:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803179:	f6 c2 01             	test   $0x1,%dl
  80317c:	74 62                	je     8031e0 <get_uvpt_entry+0x96>
  80317e:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  803185:	01 00 00 
  803188:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80318c:	f6 c2 80             	test   $0x80,%dl
  80318f:	75 4f                	jne    8031e0 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803191:	48 89 f8             	mov    %rdi,%rax
  803194:	48 c1 e8 15          	shr    $0x15,%rax
  803198:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80319f:	01 00 00 
  8031a2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8031a6:	f6 c2 01             	test   $0x1,%dl
  8031a9:	74 44                	je     8031ef <get_uvpt_entry+0xa5>
  8031ab:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8031b2:	01 00 00 
  8031b5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8031b9:	f6 c2 80             	test   $0x80,%dl
  8031bc:	75 31                	jne    8031ef <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8031be:	48 c1 ef 0c          	shr    $0xc,%rdi
  8031c2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8031c9:	01 00 00 
  8031cc:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8031d0:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8031d1:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8031d8:	01 00 00 
  8031db:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8031df:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8031e0:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8031e7:	01 00 00 
  8031ea:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8031ee:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8031ef:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8031f6:	01 00 00 
  8031f9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8031fd:	c3                   	ret    

00000000008031fe <get_prot>:

int
get_prot(void *va) {
  8031fe:	55                   	push   %rbp
  8031ff:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803202:	48 b8 4a 31 80 00 00 	movabs $0x80314a,%rax
  803209:	00 00 00 
  80320c:	ff d0                	call   *%rax
  80320e:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  803211:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  803216:	89 c1                	mov    %eax,%ecx
  803218:	83 c9 04             	or     $0x4,%ecx
  80321b:	f6 c2 01             	test   $0x1,%dl
  80321e:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  803221:	89 c1                	mov    %eax,%ecx
  803223:	83 c9 02             	or     $0x2,%ecx
  803226:	f6 c2 02             	test   $0x2,%dl
  803229:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80322c:	89 c1                	mov    %eax,%ecx
  80322e:	83 c9 01             	or     $0x1,%ecx
  803231:	48 85 d2             	test   %rdx,%rdx
  803234:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  803237:	89 c1                	mov    %eax,%ecx
  803239:	83 c9 40             	or     $0x40,%ecx
  80323c:	f6 c6 04             	test   $0x4,%dh
  80323f:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  803242:	5d                   	pop    %rbp
  803243:	c3                   	ret    

0000000000803244 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  803244:	55                   	push   %rbp
  803245:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803248:	48 b8 4a 31 80 00 00 	movabs $0x80314a,%rax
  80324f:	00 00 00 
  803252:	ff d0                	call   *%rax
    return pte & PTE_D;
  803254:	48 c1 e8 06          	shr    $0x6,%rax
  803258:	83 e0 01             	and    $0x1,%eax
}
  80325b:	5d                   	pop    %rbp
  80325c:	c3                   	ret    

000000000080325d <is_page_present>:

bool
is_page_present(void *va) {
  80325d:	55                   	push   %rbp
  80325e:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  803261:	48 b8 4a 31 80 00 00 	movabs $0x80314a,%rax
  803268:	00 00 00 
  80326b:	ff d0                	call   *%rax
  80326d:	83 e0 01             	and    $0x1,%eax
}
  803270:	5d                   	pop    %rbp
  803271:	c3                   	ret    

0000000000803272 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  803272:	55                   	push   %rbp
  803273:	48 89 e5             	mov    %rsp,%rbp
  803276:	41 57                	push   %r15
  803278:	41 56                	push   %r14
  80327a:	41 55                	push   %r13
  80327c:	41 54                	push   %r12
  80327e:	53                   	push   %rbx
  80327f:	48 83 ec 28          	sub    $0x28,%rsp
  803283:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  803287:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  80328b:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  803290:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  803297:	01 00 00 
  80329a:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8032a1:	01 00 00 
  8032a4:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8032ab:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8032ae:	49 bf fe 31 80 00 00 	movabs $0x8031fe,%r15
  8032b5:	00 00 00 
  8032b8:	eb 16                	jmp    8032d0 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8032ba:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8032c1:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8032c8:	00 00 00 
  8032cb:	48 39 c3             	cmp    %rax,%rbx
  8032ce:	77 73                	ja     803343 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8032d0:	48 89 d8             	mov    %rbx,%rax
  8032d3:	48 c1 e8 27          	shr    $0x27,%rax
  8032d7:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8032db:	a8 01                	test   $0x1,%al
  8032dd:	74 db                	je     8032ba <foreach_shared_region+0x48>
  8032df:	48 89 d8             	mov    %rbx,%rax
  8032e2:	48 c1 e8 1e          	shr    $0x1e,%rax
  8032e6:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8032eb:	a8 01                	test   $0x1,%al
  8032ed:	74 cb                	je     8032ba <foreach_shared_region+0x48>
  8032ef:	48 89 d8             	mov    %rbx,%rax
  8032f2:	48 c1 e8 15          	shr    $0x15,%rax
  8032f6:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8032fa:	a8 01                	test   $0x1,%al
  8032fc:	74 bc                	je     8032ba <foreach_shared_region+0x48>
        void *start = (void*)i;
  8032fe:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  803302:	48 89 df             	mov    %rbx,%rdi
  803305:	41 ff d7             	call   *%r15
  803308:	a8 40                	test   $0x40,%al
  80330a:	75 09                	jne    803315 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  80330c:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  803313:	eb ac                	jmp    8032c1 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  803315:	48 89 df             	mov    %rbx,%rdi
  803318:	48 b8 5d 32 80 00 00 	movabs $0x80325d,%rax
  80331f:	00 00 00 
  803322:	ff d0                	call   *%rax
  803324:	84 c0                	test   %al,%al
  803326:	74 e4                	je     80330c <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  803328:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  80332f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803333:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803337:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80333b:	ff d0                	call   *%rax
  80333d:	85 c0                	test   %eax,%eax
  80333f:	79 cb                	jns    80330c <foreach_shared_region+0x9a>
  803341:	eb 05                	jmp    803348 <foreach_shared_region+0xd6>
    }
    return 0;
  803343:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803348:	48 83 c4 28          	add    $0x28,%rsp
  80334c:	5b                   	pop    %rbx
  80334d:	41 5c                	pop    %r12
  80334f:	41 5d                	pop    %r13
  803351:	41 5e                	pop    %r14
  803353:	41 5f                	pop    %r15
  803355:	5d                   	pop    %rbp
  803356:	c3                   	ret    

0000000000803357 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  803357:	b8 00 00 00 00       	mov    $0x0,%eax
  80335c:	c3                   	ret    

000000000080335d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80335d:	55                   	push   %rbp
  80335e:	48 89 e5             	mov    %rsp,%rbp
  803361:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  803364:	48 be a2 3f 80 00 00 	movabs $0x803fa2,%rsi
  80336b:	00 00 00 
  80336e:	48 b8 d9 0d 80 00 00 	movabs $0x800dd9,%rax
  803375:	00 00 00 
  803378:	ff d0                	call   *%rax
    return 0;
}
  80337a:	b8 00 00 00 00       	mov    $0x0,%eax
  80337f:	5d                   	pop    %rbp
  803380:	c3                   	ret    

0000000000803381 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  803381:	55                   	push   %rbp
  803382:	48 89 e5             	mov    %rsp,%rbp
  803385:	41 57                	push   %r15
  803387:	41 56                	push   %r14
  803389:	41 55                	push   %r13
  80338b:	41 54                	push   %r12
  80338d:	53                   	push   %rbx
  80338e:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  803395:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80339c:	48 85 d2             	test   %rdx,%rdx
  80339f:	74 78                	je     803419 <devcons_write+0x98>
  8033a1:	49 89 d6             	mov    %rdx,%r14
  8033a4:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8033aa:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8033af:	49 bf d4 0f 80 00 00 	movabs $0x800fd4,%r15
  8033b6:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8033b9:	4c 89 f3             	mov    %r14,%rbx
  8033bc:	48 29 f3             	sub    %rsi,%rbx
  8033bf:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8033c3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8033c8:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8033cc:	4c 63 eb             	movslq %ebx,%r13
  8033cf:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8033d6:	4c 89 ea             	mov    %r13,%rdx
  8033d9:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8033e0:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8033e3:	4c 89 ee             	mov    %r13,%rsi
  8033e6:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8033ed:	48 b8 0a 12 80 00 00 	movabs $0x80120a,%rax
  8033f4:	00 00 00 
  8033f7:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8033f9:	41 01 dc             	add    %ebx,%r12d
  8033fc:	49 63 f4             	movslq %r12d,%rsi
  8033ff:	4c 39 f6             	cmp    %r14,%rsi
  803402:	72 b5                	jb     8033b9 <devcons_write+0x38>
    return res;
  803404:	49 63 c4             	movslq %r12d,%rax
}
  803407:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80340e:	5b                   	pop    %rbx
  80340f:	41 5c                	pop    %r12
  803411:	41 5d                	pop    %r13
  803413:	41 5e                	pop    %r14
  803415:	41 5f                	pop    %r15
  803417:	5d                   	pop    %rbp
  803418:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  803419:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80341f:	eb e3                	jmp    803404 <devcons_write+0x83>

0000000000803421 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  803421:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  803424:	ba 00 00 00 00       	mov    $0x0,%edx
  803429:	48 85 c0             	test   %rax,%rax
  80342c:	74 55                	je     803483 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80342e:	55                   	push   %rbp
  80342f:	48 89 e5             	mov    %rsp,%rbp
  803432:	41 55                	push   %r13
  803434:	41 54                	push   %r12
  803436:	53                   	push   %rbx
  803437:	48 83 ec 08          	sub    $0x8,%rsp
  80343b:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  80343e:	48 bb 37 12 80 00 00 	movabs $0x801237,%rbx
  803445:	00 00 00 
  803448:	49 bc 04 13 80 00 00 	movabs $0x801304,%r12
  80344f:	00 00 00 
  803452:	eb 03                	jmp    803457 <devcons_read+0x36>
  803454:	41 ff d4             	call   *%r12
  803457:	ff d3                	call   *%rbx
  803459:	85 c0                	test   %eax,%eax
  80345b:	74 f7                	je     803454 <devcons_read+0x33>
    if (c < 0) return c;
  80345d:	48 63 d0             	movslq %eax,%rdx
  803460:	78 13                	js     803475 <devcons_read+0x54>
    if (c == 0x04) return 0;
  803462:	ba 00 00 00 00       	mov    $0x0,%edx
  803467:	83 f8 04             	cmp    $0x4,%eax
  80346a:	74 09                	je     803475 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  80346c:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  803470:	ba 01 00 00 00       	mov    $0x1,%edx
}
  803475:	48 89 d0             	mov    %rdx,%rax
  803478:	48 83 c4 08          	add    $0x8,%rsp
  80347c:	5b                   	pop    %rbx
  80347d:	41 5c                	pop    %r12
  80347f:	41 5d                	pop    %r13
  803481:	5d                   	pop    %rbp
  803482:	c3                   	ret    
  803483:	48 89 d0             	mov    %rdx,%rax
  803486:	c3                   	ret    

0000000000803487 <cputchar>:
cputchar(int ch) {
  803487:	55                   	push   %rbp
  803488:	48 89 e5             	mov    %rsp,%rbp
  80348b:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  80348f:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  803493:	be 01 00 00 00       	mov    $0x1,%esi
  803498:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80349c:	48 b8 0a 12 80 00 00 	movabs $0x80120a,%rax
  8034a3:	00 00 00 
  8034a6:	ff d0                	call   *%rax
}
  8034a8:	c9                   	leave  
  8034a9:	c3                   	ret    

00000000008034aa <getchar>:
getchar(void) {
  8034aa:	55                   	push   %rbp
  8034ab:	48 89 e5             	mov    %rsp,%rbp
  8034ae:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8034b2:	ba 01 00 00 00       	mov    $0x1,%edx
  8034b7:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8034bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8034c0:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  8034c7:	00 00 00 
  8034ca:	ff d0                	call   *%rax
  8034cc:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8034ce:	85 c0                	test   %eax,%eax
  8034d0:	78 06                	js     8034d8 <getchar+0x2e>
  8034d2:	74 08                	je     8034dc <getchar+0x32>
  8034d4:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8034d8:	89 d0                	mov    %edx,%eax
  8034da:	c9                   	leave  
  8034db:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8034dc:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8034e1:	eb f5                	jmp    8034d8 <getchar+0x2e>

00000000008034e3 <iscons>:
iscons(int fdnum) {
  8034e3:	55                   	push   %rbp
  8034e4:	48 89 e5             	mov    %rsp,%rbp
  8034e7:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8034eb:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8034ef:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  8034f6:	00 00 00 
  8034f9:	ff d0                	call   *%rax
    if (res < 0) return res;
  8034fb:	85 c0                	test   %eax,%eax
  8034fd:	78 18                	js     803517 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8034ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803503:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  80350a:	00 00 00 
  80350d:	8b 00                	mov    (%rax),%eax
  80350f:	39 02                	cmp    %eax,(%rdx)
  803511:	0f 94 c0             	sete   %al
  803514:	0f b6 c0             	movzbl %al,%eax
}
  803517:	c9                   	leave  
  803518:	c3                   	ret    

0000000000803519 <opencons>:
opencons(void) {
  803519:	55                   	push   %rbp
  80351a:	48 89 e5             	mov    %rsp,%rbp
  80351d:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  803521:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  803525:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  80352c:	00 00 00 
  80352f:	ff d0                	call   *%rax
  803531:	85 c0                	test   %eax,%eax
  803533:	78 49                	js     80357e <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  803535:	b9 46 00 00 00       	mov    $0x46,%ecx
  80353a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80353f:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  803543:	bf 00 00 00 00       	mov    $0x0,%edi
  803548:	48 b8 93 13 80 00 00 	movabs $0x801393,%rax
  80354f:	00 00 00 
  803552:	ff d0                	call   *%rax
  803554:	85 c0                	test   %eax,%eax
  803556:	78 26                	js     80357e <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  803558:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80355c:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  803563:	00 00 
  803565:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  803567:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80356b:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  803572:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  803579:	00 00 00 
  80357c:	ff d0                	call   *%rax
}
  80357e:	c9                   	leave  
  80357f:	c3                   	ret    

0000000000803580 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  803580:	55                   	push   %rbp
  803581:	48 89 e5             	mov    %rsp,%rbp
  803584:	41 54                	push   %r12
  803586:	53                   	push   %rbx
  803587:	48 89 fb             	mov    %rdi,%rbx
  80358a:	48 89 f7             	mov    %rsi,%rdi
  80358d:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  803590:	48 85 f6             	test   %rsi,%rsi
  803593:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80359a:	00 00 00 
  80359d:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  8035a1:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  8035a6:	48 85 d2             	test   %rdx,%rdx
  8035a9:	74 02                	je     8035ad <ipc_recv+0x2d>
  8035ab:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  8035ad:	48 63 f6             	movslq %esi,%rsi
  8035b0:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8035b7:	00 00 00 
  8035ba:	ff d0                	call   *%rax

    if (res < 0) {
  8035bc:	85 c0                	test   %eax,%eax
  8035be:	78 45                	js     803605 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  8035c0:	48 85 db             	test   %rbx,%rbx
  8035c3:	74 12                	je     8035d7 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  8035c5:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8035cc:	00 00 00 
  8035cf:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  8035d5:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  8035d7:	4d 85 e4             	test   %r12,%r12
  8035da:	74 14                	je     8035f0 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  8035dc:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8035e3:	00 00 00 
  8035e6:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8035ec:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  8035f0:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8035f7:	00 00 00 
  8035fa:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  803600:	5b                   	pop    %rbx
  803601:	41 5c                	pop    %r12
  803603:	5d                   	pop    %rbp
  803604:	c3                   	ret    
        if (from_env_store)
  803605:	48 85 db             	test   %rbx,%rbx
  803608:	74 06                	je     803610 <ipc_recv+0x90>
            *from_env_store = 0;
  80360a:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  803610:	4d 85 e4             	test   %r12,%r12
  803613:	74 eb                	je     803600 <ipc_recv+0x80>
            *perm_store = 0;
  803615:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  80361c:	00 
  80361d:	eb e1                	jmp    803600 <ipc_recv+0x80>

000000000080361f <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  80361f:	55                   	push   %rbp
  803620:	48 89 e5             	mov    %rsp,%rbp
  803623:	41 57                	push   %r15
  803625:	41 56                	push   %r14
  803627:	41 55                	push   %r13
  803629:	41 54                	push   %r12
  80362b:	53                   	push   %rbx
  80362c:	48 83 ec 18          	sub    $0x18,%rsp
  803630:	41 89 fd             	mov    %edi,%r13d
  803633:	89 75 cc             	mov    %esi,-0x34(%rbp)
  803636:	48 89 d3             	mov    %rdx,%rbx
  803639:	49 89 cc             	mov    %rcx,%r12
  80363c:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  803640:	48 85 d2             	test   %rdx,%rdx
  803643:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80364a:	00 00 00 
  80364d:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  803651:	49 be 01 16 80 00 00 	movabs $0x801601,%r14
  803658:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  80365b:	49 bf 04 13 80 00 00 	movabs $0x801304,%r15
  803662:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  803665:	8b 75 cc             	mov    -0x34(%rbp),%esi
  803668:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  80366c:	4c 89 e1             	mov    %r12,%rcx
  80366f:	48 89 da             	mov    %rbx,%rdx
  803672:	44 89 ef             	mov    %r13d,%edi
  803675:	41 ff d6             	call   *%r14
  803678:	85 c0                	test   %eax,%eax
  80367a:	79 37                	jns    8036b3 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  80367c:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80367f:	75 05                	jne    803686 <ipc_send+0x67>
          sys_yield();
  803681:	41 ff d7             	call   *%r15
  803684:	eb df                	jmp    803665 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  803686:	89 c1                	mov    %eax,%ecx
  803688:	48 ba ae 3f 80 00 00 	movabs $0x803fae,%rdx
  80368f:	00 00 00 
  803692:	be 46 00 00 00       	mov    $0x46,%esi
  803697:	48 bf c1 3f 80 00 00 	movabs $0x803fc1,%rdi
  80369e:	00 00 00 
  8036a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a6:	49 b8 48 03 80 00 00 	movabs $0x800348,%r8
  8036ad:	00 00 00 
  8036b0:	41 ff d0             	call   *%r8
      }
}
  8036b3:	48 83 c4 18          	add    $0x18,%rsp
  8036b7:	5b                   	pop    %rbx
  8036b8:	41 5c                	pop    %r12
  8036ba:	41 5d                	pop    %r13
  8036bc:	41 5e                	pop    %r14
  8036be:	41 5f                	pop    %r15
  8036c0:	5d                   	pop    %rbp
  8036c1:	c3                   	ret    

00000000008036c2 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  8036c2:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8036c7:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  8036ce:	00 00 00 
  8036d1:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8036d5:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8036d9:	48 c1 e2 04          	shl    $0x4,%rdx
  8036dd:	48 01 ca             	add    %rcx,%rdx
  8036e0:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8036e6:	39 fa                	cmp    %edi,%edx
  8036e8:	74 12                	je     8036fc <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  8036ea:	48 83 c0 01          	add    $0x1,%rax
  8036ee:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8036f4:	75 db                	jne    8036d1 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8036f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036fb:	c3                   	ret    
            return envs[i].env_id;
  8036fc:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803700:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  803704:	48 c1 e0 04          	shl    $0x4,%rax
  803708:	48 89 c2             	mov    %rax,%rdx
  80370b:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  803712:	00 00 00 
  803715:	48 01 d0             	add    %rdx,%rax
  803718:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80371e:	c3                   	ret    
  80371f:	90                   	nop

0000000000803720 <__rodata_start>:
  803720:	72 69                	jb     80378b <__rodata_start+0x6b>
  803722:	67 68 74 00 77 72    	addr32 push $0x72770074
  803728:	6f                   	outsl  %ds:(%rsi),(%dx)
  803729:	6e                   	outsb  %ds:(%rsi),(%dx)
  80372a:	67 00 73 79          	add    %dh,0x79(%ebx)
  80372e:	73 5f                	jae    80378f <__rodata_start+0x6f>
  803730:	70 61                	jo     803793 <__rodata_start+0x73>
  803732:	67 65 5f             	addr32 gs pop %rdi
  803735:	61                   	(bad)  
  803736:	6c                   	insb   (%dx),%es:(%rdi)
  803737:	6c                   	insb   (%dx),%es:(%rdi)
  803738:	6f                   	outsl  %ds:(%rsi),(%dx)
  803739:	63 3a                	movsxd (%rdx),%edi
  80373b:	20 25 69 00 75 73    	and    %ah,0x73750069(%rip)        # 73f537aa <__bss_end+0x7374b7aa>
  803741:	65 72 2f             	gs jb  803773 <__rodata_start+0x53>
  803744:	74 65                	je     8037ab <__rodata_start+0x8b>
  803746:	73 74                	jae    8037bc <__rodata_start+0x9c>
  803748:	70 74                	jo     8037be <__rodata_start+0x9e>
  80374a:	65 73 68             	gs jae 8037b5 <__rodata_start+0x95>
  80374d:	61                   	(bad)  
  80374e:	72 65                	jb     8037b5 <__rodata_start+0x95>
  803750:	2e 63 00             	cs movsxd (%rax),%eax
  803753:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803755:	72 6b                	jb     8037c2 <__rodata_start+0xa2>
  803757:	20 68 61             	and    %ch,0x61(%rax)
  80375a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80375b:	64 6c                	fs insb (%dx),%es:(%rdi)
  80375d:	65 73 20             	gs jae 803780 <__rodata_start+0x60>
  803760:	50                   	push   %rax
  803761:	54                   	push   %rsp
  803762:	45 5f                	rex.RB pop %r15
  803764:	53                   	push   %rbx
  803765:	48                   	rex.W
  803766:	41 52                	push   %r10
  803768:	45 20 25 73 0a 00 61 	and    %r12b,0x61000a73(%rip)        # 618041e2 <__bss_end+0x60ffc1e2>
  80376f:	72 67                	jb     8037d8 <__rodata_start+0xb8>
  803771:	00 2f                	add    %ch,(%rdi)
  803773:	74 65                	je     8037da <__rodata_start+0xba>
  803775:	73 74                	jae    8037eb <__rodata_start+0xcb>
  803777:	70 74                	jo     8037ed <__rodata_start+0xcd>
  803779:	65 73 68             	gs jae 8037e4 <__rodata_start+0xc4>
  80377c:	61                   	(bad)  
  80377d:	72 65                	jb     8037e4 <__rodata_start+0xc4>
  80377f:	00 73 70             	add    %dh,0x70(%rbx)
  803782:	61                   	(bad)  
  803783:	77 6e                	ja     8037f3 <__rodata_start+0xd3>
  803785:	3a 20                	cmp    (%rax),%ah
  803787:	25 69 00 73 70       	and    $0x70730069,%eax
  80378c:	61                   	(bad)  
  80378d:	77 6e                	ja     8037fd <__rodata_start+0xdd>
  80378f:	20 68 61             	and    %ch,0x61(%rax)
  803792:	6e                   	outsb  %ds:(%rsi),(%dx)
  803793:	64 6c                	fs insb (%dx),%es:(%rdi)
  803795:	65 73 20             	gs jae 8037b8 <__rodata_start+0x98>
  803798:	50                   	push   %rax
  803799:	54                   	push   %rsp
  80379a:	45 5f                	rex.RB pop %r15
  80379c:	53                   	push   %rbx
  80379d:	48                   	rex.W
  80379e:	41 52                	push   %r10
  8037a0:	45 20 25 73 0a 00 67 	and    %r12b,0x67000a73(%rip)        # 6780421a <__bss_end+0x66ffc21a>
  8037a7:	6f                   	outsl  %ds:(%rsi),(%dx)
  8037a8:	6f                   	outsl  %ds:(%rsi),(%dx)
  8037a9:	64 62                	fs (bad) 
  8037ab:	79 65                	jns    803812 <__rodata_start+0xf2>
  8037ad:	2c 20                	sub    $0x20,%al
  8037af:	77 6f                	ja     803820 <__rodata_start+0x100>
  8037b1:	72 6c                	jb     80381f <__rodata_start+0xff>
  8037b3:	64 0a 00             	or     %fs:(%rax),%al
  8037b6:	68 65 6c 6c 6f       	push   $0x6f6c6c65
  8037bb:	2c 20                	sub    $0x20,%al
  8037bd:	77 6f                	ja     80382e <__rodata_start+0x10e>
  8037bf:	72 6c                	jb     80382d <__rodata_start+0x10d>
  8037c1:	64 0a 00             	or     %fs:(%rax),%al
  8037c4:	3c 75                	cmp    $0x75,%al
  8037c6:	6e                   	outsb  %ds:(%rsi),(%dx)
  8037c7:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8037cb:	6e                   	outsb  %ds:(%rsi),(%dx)
  8037cc:	3e 00 66 90          	ds add %ah,-0x70(%rsi)
  8037d0:	5b                   	pop    %rbx
  8037d1:	25 30 38 78 5d       	and    $0x5d783830,%eax
  8037d6:	20 75 73             	and    %dh,0x73(%rbp)
  8037d9:	65 72 20             	gs jb  8037fc <__rodata_start+0xdc>
  8037dc:	70 61                	jo     80383f <__rodata_start+0x11f>
  8037de:	6e                   	outsb  %ds:(%rsi),(%dx)
  8037df:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  8037e6:	73 20                	jae    803808 <__rodata_start+0xe8>
  8037e8:	61                   	(bad)  
  8037e9:	74 20                	je     80380b <__rodata_start+0xeb>
  8037eb:	25 73 3a 25 64       	and    $0x64253a73,%eax
  8037f0:	3a 20                	cmp    (%rax),%ah
  8037f2:	00 30                	add    %dh,(%rax)
  8037f4:	31 32                	xor    %esi,(%rdx)
  8037f6:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  8037fd:	41                   	rex.B
  8037fe:	42                   	rex.X
  8037ff:	43                   	rex.XB
  803800:	44                   	rex.R
  803801:	45                   	rex.RB
  803802:	46 00 30             	rex.RX add %r14b,(%rax)
  803805:	31 32                	xor    %esi,(%rdx)
  803807:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  80380e:	61                   	(bad)  
  80380f:	62 63 64 65 66       	(bad)
  803814:	00 28                	add    %ch,(%rax)
  803816:	6e                   	outsb  %ds:(%rsi),(%dx)
  803817:	75 6c                	jne    803885 <__rodata_start+0x165>
  803819:	6c                   	insb   (%dx),%es:(%rdi)
  80381a:	29 00                	sub    %eax,(%rax)
  80381c:	65 72 72             	gs jb  803891 <__rodata_start+0x171>
  80381f:	6f                   	outsl  %ds:(%rsi),(%dx)
  803820:	72 20                	jb     803842 <__rodata_start+0x122>
  803822:	25 64 00 75 6e       	and    $0x6e750064,%eax
  803827:	73 70                	jae    803899 <__rodata_start+0x179>
  803829:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  80382d:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  803834:	6f                   	outsl  %ds:(%rsi),(%dx)
  803835:	72 00                	jb     803837 <__rodata_start+0x117>
  803837:	62 61 64 20 65       	(bad)
  80383c:	6e                   	outsb  %ds:(%rsi),(%dx)
  80383d:	76 69                	jbe    8038a8 <__rodata_start+0x188>
  80383f:	72 6f                	jb     8038b0 <__rodata_start+0x190>
  803841:	6e                   	outsb  %ds:(%rsi),(%dx)
  803842:	6d                   	insl   (%dx),%es:(%rdi)
  803843:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803845:	74 00                	je     803847 <__rodata_start+0x127>
  803847:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  80384e:	20 70 61             	and    %dh,0x61(%rax)
  803851:	72 61                	jb     8038b4 <__rodata_start+0x194>
  803853:	6d                   	insl   (%dx),%es:(%rdi)
  803854:	65 74 65             	gs je  8038bc <__rodata_start+0x19c>
  803857:	72 00                	jb     803859 <__rodata_start+0x139>
  803859:	6f                   	outsl  %ds:(%rsi),(%dx)
  80385a:	75 74                	jne    8038d0 <__rodata_start+0x1b0>
  80385c:	20 6f 66             	and    %ch,0x66(%rdi)
  80385f:	20 6d 65             	and    %ch,0x65(%rbp)
  803862:	6d                   	insl   (%dx),%es:(%rdi)
  803863:	6f                   	outsl  %ds:(%rsi),(%dx)
  803864:	72 79                	jb     8038df <__rodata_start+0x1bf>
  803866:	00 6f 75             	add    %ch,0x75(%rdi)
  803869:	74 20                	je     80388b <__rodata_start+0x16b>
  80386b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80386c:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  803870:	76 69                	jbe    8038db <__rodata_start+0x1bb>
  803872:	72 6f                	jb     8038e3 <__rodata_start+0x1c3>
  803874:	6e                   	outsb  %ds:(%rsi),(%dx)
  803875:	6d                   	insl   (%dx),%es:(%rdi)
  803876:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803878:	74 73                	je     8038ed <__rodata_start+0x1cd>
  80387a:	00 63 6f             	add    %ah,0x6f(%rbx)
  80387d:	72 72                	jb     8038f1 <__rodata_start+0x1d1>
  80387f:	75 70                	jne    8038f1 <__rodata_start+0x1d1>
  803881:	74 65                	je     8038e8 <__rodata_start+0x1c8>
  803883:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  803888:	75 67                	jne    8038f1 <__rodata_start+0x1d1>
  80388a:	20 69 6e             	and    %ch,0x6e(%rcx)
  80388d:	66 6f                	outsw  %ds:(%rsi),(%dx)
  80388f:	00 73 65             	add    %dh,0x65(%rbx)
  803892:	67 6d                	insl   (%dx),%es:(%edi)
  803894:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803896:	74 61                	je     8038f9 <__rodata_start+0x1d9>
  803898:	74 69                	je     803903 <__rodata_start+0x1e3>
  80389a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80389b:	6e                   	outsb  %ds:(%rsi),(%dx)
  80389c:	20 66 61             	and    %ah,0x61(%rsi)
  80389f:	75 6c                	jne    80390d <__rodata_start+0x1ed>
  8038a1:	74 00                	je     8038a3 <__rodata_start+0x183>
  8038a3:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  8038aa:	20 45 4c             	and    %al,0x4c(%rbp)
  8038ad:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  8038b1:	61                   	(bad)  
  8038b2:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  8038b7:	20 73 75             	and    %dh,0x75(%rbx)
  8038ba:	63 68 20             	movsxd 0x20(%rax),%ebp
  8038bd:	73 79                	jae    803938 <__rodata_start+0x218>
  8038bf:	73 74                	jae    803935 <__rodata_start+0x215>
  8038c1:	65 6d                	gs insl (%dx),%es:(%rdi)
  8038c3:	20 63 61             	and    %ah,0x61(%rbx)
  8038c6:	6c                   	insb   (%dx),%es:(%rdi)
  8038c7:	6c                   	insb   (%dx),%es:(%rdi)
  8038c8:	00 65 6e             	add    %ah,0x6e(%rbp)
  8038cb:	74 72                	je     80393f <__rodata_start+0x21f>
  8038cd:	79 20                	jns    8038ef <__rodata_start+0x1cf>
  8038cf:	6e                   	outsb  %ds:(%rsi),(%dx)
  8038d0:	6f                   	outsl  %ds:(%rsi),(%dx)
  8038d1:	74 20                	je     8038f3 <__rodata_start+0x1d3>
  8038d3:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8038d5:	75 6e                	jne    803945 <__rodata_start+0x225>
  8038d7:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  8038db:	76 20                	jbe    8038fd <__rodata_start+0x1dd>
  8038dd:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  8038e4:	72 65                	jb     80394b <__rodata_start+0x22b>
  8038e6:	63 76 69             	movsxd 0x69(%rsi),%esi
  8038e9:	6e                   	outsb  %ds:(%rsi),(%dx)
  8038ea:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  8038ee:	65 78 70             	gs js  803961 <__rodata_start+0x241>
  8038f1:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  8038f6:	20 65 6e             	and    %ah,0x6e(%rbp)
  8038f9:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  8038fd:	20 66 69             	and    %ah,0x69(%rsi)
  803900:	6c                   	insb   (%dx),%es:(%rdi)
  803901:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  803905:	20 66 72             	and    %ah,0x72(%rsi)
  803908:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  80390d:	61                   	(bad)  
  80390e:	63 65 20             	movsxd 0x20(%rbp),%esp
  803911:	6f                   	outsl  %ds:(%rsi),(%dx)
  803912:	6e                   	outsb  %ds:(%rsi),(%dx)
  803913:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  803917:	6b 00 74             	imul   $0x74,(%rax),%eax
  80391a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80391b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80391c:	20 6d 61             	and    %ch,0x61(%rbp)
  80391f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803920:	79 20                	jns    803942 <__rodata_start+0x222>
  803922:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  803929:	72 65                	jb     803990 <__rodata_start+0x270>
  80392b:	20 6f 70             	and    %ch,0x70(%rdi)
  80392e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803930:	00 66 69             	add    %ah,0x69(%rsi)
  803933:	6c                   	insb   (%dx),%es:(%rdi)
  803934:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  803938:	20 62 6c             	and    %ah,0x6c(%rdx)
  80393b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80393c:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  80393f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803940:	6f                   	outsl  %ds:(%rsi),(%dx)
  803941:	74 20                	je     803963 <__rodata_start+0x243>
  803943:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803945:	75 6e                	jne    8039b5 <__rodata_start+0x295>
  803947:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  80394b:	76 61                	jbe    8039ae <__rodata_start+0x28e>
  80394d:	6c                   	insb   (%dx),%es:(%rdi)
  80394e:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  803955:	00 
  803956:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  80395d:	72 65                	jb     8039c4 <__rodata_start+0x2a4>
  80395f:	61                   	(bad)  
  803960:	64 79 20             	fs jns 803983 <__rodata_start+0x263>
  803963:	65 78 69             	gs js  8039cf <__rodata_start+0x2af>
  803966:	73 74                	jae    8039dc <__rodata_start+0x2bc>
  803968:	73 00                	jae    80396a <__rodata_start+0x24a>
  80396a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80396b:	70 65                	jo     8039d2 <__rodata_start+0x2b2>
  80396d:	72 61                	jb     8039d0 <__rodata_start+0x2b0>
  80396f:	74 69                	je     8039da <__rodata_start+0x2ba>
  803971:	6f                   	outsl  %ds:(%rsi),(%dx)
  803972:	6e                   	outsb  %ds:(%rsi),(%dx)
  803973:	20 6e 6f             	and    %ch,0x6f(%rsi)
  803976:	74 20                	je     803998 <__rodata_start+0x278>
  803978:	73 75                	jae    8039ef <__rodata_start+0x2cf>
  80397a:	70 70                	jo     8039ec <__rodata_start+0x2cc>
  80397c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80397d:	72 74                	jb     8039f3 <__rodata_start+0x2d3>
  80397f:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  803984:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  80398b:	00 
  80398c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803993:	00 00 00 
  803996:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80399d:	00 00 00 
  8039a0:	92                   	xchg   %eax,%edx
  8039a1:	06                   	(bad)  
  8039a2:	80 00 00             	addb   $0x0,(%rax)
  8039a5:	00 00                	add    %al,(%rax)
  8039a7:	00 e6                	add    %ah,%dh
  8039a9:	0c 80                	or     $0x80,%al
  8039ab:	00 00                	add    %al,(%rax)
  8039ad:	00 00                	add    %al,(%rax)
  8039af:	00 d6                	add    %dl,%dh
  8039b1:	0c 80                	or     $0x80,%al
  8039b3:	00 00                	add    %al,(%rax)
  8039b5:	00 00                	add    %al,(%rax)
  8039b7:	00 e6                	add    %ah,%dh
  8039b9:	0c 80                	or     $0x80,%al
  8039bb:	00 00                	add    %al,(%rax)
  8039bd:	00 00                	add    %al,(%rax)
  8039bf:	00 e6                	add    %ah,%dh
  8039c1:	0c 80                	or     $0x80,%al
  8039c3:	00 00                	add    %al,(%rax)
  8039c5:	00 00                	add    %al,(%rax)
  8039c7:	00 e6                	add    %ah,%dh
  8039c9:	0c 80                	or     $0x80,%al
  8039cb:	00 00                	add    %al,(%rax)
  8039cd:	00 00                	add    %al,(%rax)
  8039cf:	00 e6                	add    %ah,%dh
  8039d1:	0c 80                	or     $0x80,%al
  8039d3:	00 00                	add    %al,(%rax)
  8039d5:	00 00                	add    %al,(%rax)
  8039d7:	00 ac 06 80 00 00 00 	add    %ch,0x80(%rsi,%rax,1)
  8039de:	00 00                	add    %al,(%rax)
  8039e0:	e6 0c                	out    %al,$0xc
  8039e2:	80 00 00             	addb   $0x0,(%rax)
  8039e5:	00 00                	add    %al,(%rax)
  8039e7:	00 e6                	add    %ah,%dh
  8039e9:	0c 80                	or     $0x80,%al
  8039eb:	00 00                	add    %al,(%rax)
  8039ed:	00 00                	add    %al,(%rax)
  8039ef:	00 a3 06 80 00 00    	add    %ah,0x8006(%rbx)
  8039f5:	00 00                	add    %al,(%rax)
  8039f7:	00 19                	add    %bl,(%rcx)
  8039f9:	07                   	(bad)  
  8039fa:	80 00 00             	addb   $0x0,(%rax)
  8039fd:	00 00                	add    %al,(%rax)
  8039ff:	00 e6                	add    %ah,%dh
  803a01:	0c 80                	or     $0x80,%al
  803a03:	00 00                	add    %al,(%rax)
  803a05:	00 00                	add    %al,(%rax)
  803a07:	00 a3 06 80 00 00    	add    %ah,0x8006(%rbx)
  803a0d:	00 00                	add    %al,(%rax)
  803a0f:	00 e6                	add    %ah,%dh
  803a11:	06                   	(bad)  
  803a12:	80 00 00             	addb   $0x0,(%rax)
  803a15:	00 00                	add    %al,(%rax)
  803a17:	00 e6                	add    %ah,%dh
  803a19:	06                   	(bad)  
  803a1a:	80 00 00             	addb   $0x0,(%rax)
  803a1d:	00 00                	add    %al,(%rax)
  803a1f:	00 e6                	add    %ah,%dh
  803a21:	06                   	(bad)  
  803a22:	80 00 00             	addb   $0x0,(%rax)
  803a25:	00 00                	add    %al,(%rax)
  803a27:	00 e6                	add    %ah,%dh
  803a29:	06                   	(bad)  
  803a2a:	80 00 00             	addb   $0x0,(%rax)
  803a2d:	00 00                	add    %al,(%rax)
  803a2f:	00 e6                	add    %ah,%dh
  803a31:	06                   	(bad)  
  803a32:	80 00 00             	addb   $0x0,(%rax)
  803a35:	00 00                	add    %al,(%rax)
  803a37:	00 e6                	add    %ah,%dh
  803a39:	06                   	(bad)  
  803a3a:	80 00 00             	addb   $0x0,(%rax)
  803a3d:	00 00                	add    %al,(%rax)
  803a3f:	00 e6                	add    %ah,%dh
  803a41:	06                   	(bad)  
  803a42:	80 00 00             	addb   $0x0,(%rax)
  803a45:	00 00                	add    %al,(%rax)
  803a47:	00 e6                	add    %ah,%dh
  803a49:	06                   	(bad)  
  803a4a:	80 00 00             	addb   $0x0,(%rax)
  803a4d:	00 00                	add    %al,(%rax)
  803a4f:	00 e6                	add    %ah,%dh
  803a51:	06                   	(bad)  
  803a52:	80 00 00             	addb   $0x0,(%rax)
  803a55:	00 00                	add    %al,(%rax)
  803a57:	00 e6                	add    %ah,%dh
  803a59:	0c 80                	or     $0x80,%al
  803a5b:	00 00                	add    %al,(%rax)
  803a5d:	00 00                	add    %al,(%rax)
  803a5f:	00 e6                	add    %ah,%dh
  803a61:	0c 80                	or     $0x80,%al
  803a63:	00 00                	add    %al,(%rax)
  803a65:	00 00                	add    %al,(%rax)
  803a67:	00 e6                	add    %ah,%dh
  803a69:	0c 80                	or     $0x80,%al
  803a6b:	00 00                	add    %al,(%rax)
  803a6d:	00 00                	add    %al,(%rax)
  803a6f:	00 e6                	add    %ah,%dh
  803a71:	0c 80                	or     $0x80,%al
  803a73:	00 00                	add    %al,(%rax)
  803a75:	00 00                	add    %al,(%rax)
  803a77:	00 e6                	add    %ah,%dh
  803a79:	0c 80                	or     $0x80,%al
  803a7b:	00 00                	add    %al,(%rax)
  803a7d:	00 00                	add    %al,(%rax)
  803a7f:	00 e6                	add    %ah,%dh
  803a81:	0c 80                	or     $0x80,%al
  803a83:	00 00                	add    %al,(%rax)
  803a85:	00 00                	add    %al,(%rax)
  803a87:	00 e6                	add    %ah,%dh
  803a89:	0c 80                	or     $0x80,%al
  803a8b:	00 00                	add    %al,(%rax)
  803a8d:	00 00                	add    %al,(%rax)
  803a8f:	00 e6                	add    %ah,%dh
  803a91:	0c 80                	or     $0x80,%al
  803a93:	00 00                	add    %al,(%rax)
  803a95:	00 00                	add    %al,(%rax)
  803a97:	00 e6                	add    %ah,%dh
  803a99:	0c 80                	or     $0x80,%al
  803a9b:	00 00                	add    %al,(%rax)
  803a9d:	00 00                	add    %al,(%rax)
  803a9f:	00 e6                	add    %ah,%dh
  803aa1:	0c 80                	or     $0x80,%al
  803aa3:	00 00                	add    %al,(%rax)
  803aa5:	00 00                	add    %al,(%rax)
  803aa7:	00 e6                	add    %ah,%dh
  803aa9:	0c 80                	or     $0x80,%al
  803aab:	00 00                	add    %al,(%rax)
  803aad:	00 00                	add    %al,(%rax)
  803aaf:	00 e6                	add    %ah,%dh
  803ab1:	0c 80                	or     $0x80,%al
  803ab3:	00 00                	add    %al,(%rax)
  803ab5:	00 00                	add    %al,(%rax)
  803ab7:	00 e6                	add    %ah,%dh
  803ab9:	0c 80                	or     $0x80,%al
  803abb:	00 00                	add    %al,(%rax)
  803abd:	00 00                	add    %al,(%rax)
  803abf:	00 e6                	add    %ah,%dh
  803ac1:	0c 80                	or     $0x80,%al
  803ac3:	00 00                	add    %al,(%rax)
  803ac5:	00 00                	add    %al,(%rax)
  803ac7:	00 e6                	add    %ah,%dh
  803ac9:	0c 80                	or     $0x80,%al
  803acb:	00 00                	add    %al,(%rax)
  803acd:	00 00                	add    %al,(%rax)
  803acf:	00 e6                	add    %ah,%dh
  803ad1:	0c 80                	or     $0x80,%al
  803ad3:	00 00                	add    %al,(%rax)
  803ad5:	00 00                	add    %al,(%rax)
  803ad7:	00 e6                	add    %ah,%dh
  803ad9:	0c 80                	or     $0x80,%al
  803adb:	00 00                	add    %al,(%rax)
  803add:	00 00                	add    %al,(%rax)
  803adf:	00 e6                	add    %ah,%dh
  803ae1:	0c 80                	or     $0x80,%al
  803ae3:	00 00                	add    %al,(%rax)
  803ae5:	00 00                	add    %al,(%rax)
  803ae7:	00 e6                	add    %ah,%dh
  803ae9:	0c 80                	or     $0x80,%al
  803aeb:	00 00                	add    %al,(%rax)
  803aed:	00 00                	add    %al,(%rax)
  803aef:	00 e6                	add    %ah,%dh
  803af1:	0c 80                	or     $0x80,%al
  803af3:	00 00                	add    %al,(%rax)
  803af5:	00 00                	add    %al,(%rax)
  803af7:	00 e6                	add    %ah,%dh
  803af9:	0c 80                	or     $0x80,%al
  803afb:	00 00                	add    %al,(%rax)
  803afd:	00 00                	add    %al,(%rax)
  803aff:	00 e6                	add    %ah,%dh
  803b01:	0c 80                	or     $0x80,%al
  803b03:	00 00                	add    %al,(%rax)
  803b05:	00 00                	add    %al,(%rax)
  803b07:	00 e6                	add    %ah,%dh
  803b09:	0c 80                	or     $0x80,%al
  803b0b:	00 00                	add    %al,(%rax)
  803b0d:	00 00                	add    %al,(%rax)
  803b0f:	00 e6                	add    %ah,%dh
  803b11:	0c 80                	or     $0x80,%al
  803b13:	00 00                	add    %al,(%rax)
  803b15:	00 00                	add    %al,(%rax)
  803b17:	00 e6                	add    %ah,%dh
  803b19:	0c 80                	or     $0x80,%al
  803b1b:	00 00                	add    %al,(%rax)
  803b1d:	00 00                	add    %al,(%rax)
  803b1f:	00 e6                	add    %ah,%dh
  803b21:	0c 80                	or     $0x80,%al
  803b23:	00 00                	add    %al,(%rax)
  803b25:	00 00                	add    %al,(%rax)
  803b27:	00 e6                	add    %ah,%dh
  803b29:	0c 80                	or     $0x80,%al
  803b2b:	00 00                	add    %al,(%rax)
  803b2d:	00 00                	add    %al,(%rax)
  803b2f:	00 e6                	add    %ah,%dh
  803b31:	0c 80                	or     $0x80,%al
  803b33:	00 00                	add    %al,(%rax)
  803b35:	00 00                	add    %al,(%rax)
  803b37:	00 e6                	add    %ah,%dh
  803b39:	0c 80                	or     $0x80,%al
  803b3b:	00 00                	add    %al,(%rax)
  803b3d:	00 00                	add    %al,(%rax)
  803b3f:	00 e6                	add    %ah,%dh
  803b41:	0c 80                	or     $0x80,%al
  803b43:	00 00                	add    %al,(%rax)
  803b45:	00 00                	add    %al,(%rax)
  803b47:	00 0b                	add    %cl,(%rbx)
  803b49:	0c 80                	or     $0x80,%al
  803b4b:	00 00                	add    %al,(%rax)
  803b4d:	00 00                	add    %al,(%rax)
  803b4f:	00 e6                	add    %ah,%dh
  803b51:	0c 80                	or     $0x80,%al
  803b53:	00 00                	add    %al,(%rax)
  803b55:	00 00                	add    %al,(%rax)
  803b57:	00 e6                	add    %ah,%dh
  803b59:	0c 80                	or     $0x80,%al
  803b5b:	00 00                	add    %al,(%rax)
  803b5d:	00 00                	add    %al,(%rax)
  803b5f:	00 e6                	add    %ah,%dh
  803b61:	0c 80                	or     $0x80,%al
  803b63:	00 00                	add    %al,(%rax)
  803b65:	00 00                	add    %al,(%rax)
  803b67:	00 e6                	add    %ah,%dh
  803b69:	0c 80                	or     $0x80,%al
  803b6b:	00 00                	add    %al,(%rax)
  803b6d:	00 00                	add    %al,(%rax)
  803b6f:	00 e6                	add    %ah,%dh
  803b71:	0c 80                	or     $0x80,%al
  803b73:	00 00                	add    %al,(%rax)
  803b75:	00 00                	add    %al,(%rax)
  803b77:	00 e6                	add    %ah,%dh
  803b79:	0c 80                	or     $0x80,%al
  803b7b:	00 00                	add    %al,(%rax)
  803b7d:	00 00                	add    %al,(%rax)
  803b7f:	00 e6                	add    %ah,%dh
  803b81:	0c 80                	or     $0x80,%al
  803b83:	00 00                	add    %al,(%rax)
  803b85:	00 00                	add    %al,(%rax)
  803b87:	00 e6                	add    %ah,%dh
  803b89:	0c 80                	or     $0x80,%al
  803b8b:	00 00                	add    %al,(%rax)
  803b8d:	00 00                	add    %al,(%rax)
  803b8f:	00 e6                	add    %ah,%dh
  803b91:	0c 80                	or     $0x80,%al
  803b93:	00 00                	add    %al,(%rax)
  803b95:	00 00                	add    %al,(%rax)
  803b97:	00 e6                	add    %ah,%dh
  803b99:	0c 80                	or     $0x80,%al
  803b9b:	00 00                	add    %al,(%rax)
  803b9d:	00 00                	add    %al,(%rax)
  803b9f:	00 37                	add    %dh,(%rdi)
  803ba1:	07                   	(bad)  
  803ba2:	80 00 00             	addb   $0x0,(%rax)
  803ba5:	00 00                	add    %al,(%rax)
  803ba7:	00 2d 09 80 00 00    	add    %ch,0x8009(%rip)        # 80bbb6 <__bss_end+0x3bb6>
  803bad:	00 00                	add    %al,(%rax)
  803baf:	00 e6                	add    %ah,%dh
  803bb1:	0c 80                	or     $0x80,%al
  803bb3:	00 00                	add    %al,(%rax)
  803bb5:	00 00                	add    %al,(%rax)
  803bb7:	00 e6                	add    %ah,%dh
  803bb9:	0c 80                	or     $0x80,%al
  803bbb:	00 00                	add    %al,(%rax)
  803bbd:	00 00                	add    %al,(%rax)
  803bbf:	00 e6                	add    %ah,%dh
  803bc1:	0c 80                	or     $0x80,%al
  803bc3:	00 00                	add    %al,(%rax)
  803bc5:	00 00                	add    %al,(%rax)
  803bc7:	00 e6                	add    %ah,%dh
  803bc9:	0c 80                	or     $0x80,%al
  803bcb:	00 00                	add    %al,(%rax)
  803bcd:	00 00                	add    %al,(%rax)
  803bcf:	00 65 07             	add    %ah,0x7(%rbp)
  803bd2:	80 00 00             	addb   $0x0,(%rax)
  803bd5:	00 00                	add    %al,(%rax)
  803bd7:	00 e6                	add    %ah,%dh
  803bd9:	0c 80                	or     $0x80,%al
  803bdb:	00 00                	add    %al,(%rax)
  803bdd:	00 00                	add    %al,(%rax)
  803bdf:	00 e6                	add    %ah,%dh
  803be1:	0c 80                	or     $0x80,%al
  803be3:	00 00                	add    %al,(%rax)
  803be5:	00 00                	add    %al,(%rax)
  803be7:	00 2c 07             	add    %ch,(%rdi,%rax,1)
  803bea:	80 00 00             	addb   $0x0,(%rax)
  803bed:	00 00                	add    %al,(%rax)
  803bef:	00 e6                	add    %ah,%dh
  803bf1:	0c 80                	or     $0x80,%al
  803bf3:	00 00                	add    %al,(%rax)
  803bf5:	00 00                	add    %al,(%rax)
  803bf7:	00 e6                	add    %ah,%dh
  803bf9:	0c 80                	or     $0x80,%al
  803bfb:	00 00                	add    %al,(%rax)
  803bfd:	00 00                	add    %al,(%rax)
  803bff:	00 cd                	add    %cl,%ch
  803c01:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803c07:	00 95 0b 80 00 00    	add    %dl,0x800b(%rbp)
  803c0d:	00 00                	add    %al,(%rax)
  803c0f:	00 e6                	add    %ah,%dh
  803c11:	0c 80                	or     $0x80,%al
  803c13:	00 00                	add    %al,(%rax)
  803c15:	00 00                	add    %al,(%rax)
  803c17:	00 e6                	add    %ah,%dh
  803c19:	0c 80                	or     $0x80,%al
  803c1b:	00 00                	add    %al,(%rax)
  803c1d:	00 00                	add    %al,(%rax)
  803c1f:	00 fd                	add    %bh,%ch
  803c21:	07                   	(bad)  
  803c22:	80 00 00             	addb   $0x0,(%rax)
  803c25:	00 00                	add    %al,(%rax)
  803c27:	00 e6                	add    %ah,%dh
  803c29:	0c 80                	or     $0x80,%al
  803c2b:	00 00                	add    %al,(%rax)
  803c2d:	00 00                	add    %al,(%rax)
  803c2f:	00 ff                	add    %bh,%bh
  803c31:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  803c37:	00 e6                	add    %ah,%dh
  803c39:	0c 80                	or     $0x80,%al
  803c3b:	00 00                	add    %al,(%rax)
  803c3d:	00 00                	add    %al,(%rax)
  803c3f:	00 e6                	add    %ah,%dh
  803c41:	0c 80                	or     $0x80,%al
  803c43:	00 00                	add    %al,(%rax)
  803c45:	00 00                	add    %al,(%rax)
  803c47:	00 0b                	add    %cl,(%rbx)
  803c49:	0c 80                	or     $0x80,%al
  803c4b:	00 00                	add    %al,(%rax)
  803c4d:	00 00                	add    %al,(%rax)
  803c4f:	00 e6                	add    %ah,%dh
  803c51:	0c 80                	or     $0x80,%al
  803c53:	00 00                	add    %al,(%rax)
  803c55:	00 00                	add    %al,(%rax)
  803c57:	00 9b 06 80 00 00    	add    %bl,0x8006(%rbx)
  803c5d:	00 00                	add    %al,(%rax)
	...

0000000000803c60 <error_string>:
	...
  803c68:	25 38 80 00 00 00 00 00 37 38 80 00 00 00 00 00     %8......78......
  803c78:	47 38 80 00 00 00 00 00 59 38 80 00 00 00 00 00     G8......Y8......
  803c88:	67 38 80 00 00 00 00 00 7b 38 80 00 00 00 00 00     g8......{8......
  803c98:	90 38 80 00 00 00 00 00 a3 38 80 00 00 00 00 00     .8.......8......
  803ca8:	b5 38 80 00 00 00 00 00 c9 38 80 00 00 00 00 00     .8.......8......
  803cb8:	d9 38 80 00 00 00 00 00 ec 38 80 00 00 00 00 00     .8.......8......
  803cc8:	03 39 80 00 00 00 00 00 19 39 80 00 00 00 00 00     .9.......9......
  803cd8:	31 39 80 00 00 00 00 00 49 39 80 00 00 00 00 00     19......I9......
  803ce8:	56 39 80 00 00 00 00 00 00 3d 80 00 00 00 00 00     V9.......=......
  803cf8:	6a 39 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     j9......file is 
  803d08:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803d18:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803d28:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803d38:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803d48:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  803d58:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  803d68:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  803d78:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  803d88:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  803d98:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  803da8:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  803db8:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  803dc8:	6c 6c 3a 20 25 69 00 90 5b 25 30 38 78 5d 20 75     ll: %i..[%08x] u
  803dd8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803de8:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803df8:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803e08:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803e18:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803e28:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803e38:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803e48:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e58:	84 00 00 00 00 00 66 90                             ......f.

0000000000803e60 <devtab>:
  803e60:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803e70:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803e80:	57 72 6f 6e 67 20 45 4c 46 20 68 65 61 64 65 72     Wrong ELF header
  803e90:	20 73 69 7a 65 20 6f 72 20 72 65 61 64 20 65 72      size or read er
  803ea0:	72 6f 72 3a 20 25 69 0a 00 00 00 00 00 00 00 00     ror: %i.........
  803eb0:	73 74 72 69 6e 67 5f 73 74 6f 72 65 20 3d 3d 20     string_store == 
  803ec0:	28 63 68 61 72 20 2a 29 55 54 45 4d 50 20 2b 20     (char *)UTEMP + 
  803ed0:	55 53 45 52 5f 53 54 41 43 4b 5f 53 49 5a 45 00     USER_STACK_SIZE.
  803ee0:	45 6c 66 20 6d 61 67 69 63 20 25 30 38 78 20 77     Elf magic %08x w
  803ef0:	61 6e 74 20 25 30 38 78 0a 00 61 73 73 65 72 74     ant %08x..assert
  803f00:	69 6f 6e 20 66 61 69 6c 65 64 3a 20 25 73 00 6c     ion failed: %s.l
  803f10:	69 62 2f 73 70 61 77 6e 2e 63 00 63 6f 70 79 5f     ib/spawn.c.copy_
  803f20:	73 68 61 72 65 64 5f 72 65 67 69 6f 6e 3a 20 25     shared_region: %
  803f30:	69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 74 72     i.sys_env_set_tr
  803f40:	61 70 66 72 61 6d 65 3a 20 25 69 00 3c 70 69 70     apframe: %i.<pip
  803f50:	65 3e 00 6c 69 62 2f 70 69 70 65 2e 63 00 70 69     e>.lib/pipe.c.pi
  803f60:	70 65 00 0f 1f 44 00 00 73 79 73 5f 72 65 67 69     pe...D..sys_regi
  803f70:	6f 6e 5f 72 65 66 73 28 76 61 2c 20 50 41 47 45     on_refs(va, PAGE
  803f80:	5f 53 49 5a 45 29 20 3d 3d 20 32 00 65 6e 76 69     _SIZE) == 2.envi
  803f90:	64 20 21 3d 20 30 00 6c 69 62 2f 77 61 69 74 2e     d != 0.lib/wait.
  803fa0:	63 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00 69 70     c.<cons>.cons.ip
  803fb0:	63 5f 73 65 6e 64 20 65 72 72 6f 72 3a 20 25 69     c_send error: %i
  803fc0:	00 6c 69 62 2f 69 70 63 2e 63 00 66 2e 0f 1f 84     .lib/ipc.c.f....
  803fd0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803fe0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ff0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00     ...f............
